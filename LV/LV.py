import numpy as np
import pandas as pd
from scipy.integrate import solve_ivp
from scipy.optimize import minimize

# 1. 读取数据
data_path = 'output/otu_1_17.xlsx'
df = pd.read_excel(data_path, index_col=0)  # 假设第一列是时间点
data = df.values
n_otus = data.shape[1]
time_points = df.index.values.tolist()  # 用列表存储时间点，方便后续扩展

# 2. 定义 Lotka-Volterra 竞争模型
def lv_model(t, x, r, alpha):
    dxdt = r * x * (1 - np.dot(alpha, x))
    return dxdt

# 3. 目标函数（参数优化）
def objective(params, time_series, obs_data):
    r = params[:n_otus]
    alpha = params[n_otus:].reshape(n_otus, n_otus)
    sol = solve_ivp(lv_model, [time_series[0], time_series[-1]], obs_data[0, :], args=(r, alpha), t_eval=time_series)
    return np.mean((sol.y.T - obs_data) ** 2)

# 4. 参数初始化与优化
initial_params = np.hstack([np.random.rand(n_otus), np.random.rand(n_otus, n_otus).flatten()])
result = minimize(objective, initial_params, args=(time_points, data), method='L-BFGS-B')
optimized_params = result.x
r_opt = optimized_params[:n_otus]
alpha_opt = optimized_params[n_otus:].reshape(n_otus, n_otus)

# 5. **分步预测**
future_time_points = [18, 19, 20]  # 需要预测的时间点
predicted_results = []  # 用于存储预测值

current_data = data.copy()  # 复制原始数据
current_time_points = time_points.copy()  # 复制时间点

for t in future_time_points:
    # 预测下一个时间点
    sol = solve_ivp(lv_model, [current_time_points[0], t], current_data[0, :], args=(r_opt, alpha_opt), t_eval=[t])
    
    # 获取预测值
    next_prediction = sol.y[:, -1]
    predicted_results.append(next_prediction)
    
    # 更新数据集
    current_time_points.append(t)  # 添加新时间点
    current_data = np.vstack([current_data, next_prediction])  # 添加新数据

    # 重新优化参数（如果希望每次微调参数）
    result = minimize(objective, optimized_params, args=(current_time_points, current_data), method='L-BFGS-B')
    optimized_params = result.x
    r_opt = optimized_params[:n_otus]
    alpha_opt = optimized_params[n_otus:].reshape(n_otus, n_otus)

# 6. 输出预测结果
predicted_df = pd.DataFrame(predicted_results, index=future_time_points, columns=df.columns)
predicted_df.to_excel('LV_predictions_stepwise.xlsx')
print("滚动预测完成，结果已保存。")
