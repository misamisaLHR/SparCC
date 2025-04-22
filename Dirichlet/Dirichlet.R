library(DirichletReg)
library(vegan)
library(readxl)
file_path <- "OTU.csv"
data <- read.csv(file_path)

otu_data <- data[, 1:50]
env_data <- data[, 51:53]

otu_prop <- otu_data / rowSums(otu_data)
otu_DR <- DR_data(otu_prop)
env_data_scaled <- scale(env_data)

cb_data_filtered <- cbind(otu_DR, env_data_scaled)
cb_data_filtered <- as.data.frame(cb_data_filtered)

dirichlet_model <- DirichReg(otu_DR ~ env_data_scaled, data = cb_data_filtered)
summary(dirichlet_model)

predictions <- predict(dirichlet_model, type = "link")
predicted_data <- exp(predictions)
predicted_data <- predicted_data / rowSums(predicted_data)
residuals <- otu_prop - predicted_data
otu_data_no_env_effect <- residuals * rowSums(otu_data)
min_value <- min(otu_data_no_env_effect)
shifted_residuals <- otu_data_no_env_effect - min_value + 1  
otu_data_no_env_effect_int <- round(shifted_residuals)
df_otu_no_env_effect <- as.data.frame(otu_data_no_env_effect_int)
write.csv(df_otu_no_env_effect, "OTU_no_env_effect.csv", row.names = FALSE)

print("去除环境因素影响后的OTU数据已保存为 'OTU_no_env_effect.csv'")