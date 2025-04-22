if (!require(Matrix)) install.packages("Matrix", dependencies=TRUE)
library(Matrix)

original_corr <- read.csv("cor_exp1.csv", row.names = 1)
pseudo1_corr <- read.csv("cor_exp_DF_1.csv", row.names = 1)
pseudo2_corr <- read.csv("cor_exp_DF_2.csv", row.names = 1)

pseudo_corr <- (pseudo1_corr + pseudo2_corr) / 2

original_corr_matrix <- as.matrix(original_corr)
pseudo_corr_matrix <- as.matrix(pseudo_corr)

mean_pseudo <- mean(pseudo_corr_matrix)
sd_pseudo <- sd(pseudo_corr_matrix)
z_scores <- (original_corr_matrix - mean_pseudo) / sd_pseudo

p_values <- 2 * pnorm(-abs(z_scores))  

write.csv(p_values, file = 'p_values.csv', quote = FALSE, row.names = TRUE)

cat("P-values have been calculated and saved as CSV files.\n")