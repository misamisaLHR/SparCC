if (!require(MASS)) install.packages("MASS", dependencies=TRUE)
library(MASS)
txt_file <- "1001_lines/1001_lines.txt" 
otu_data <- read.table(txt_file, header = TRUE, sep = "\t", row.names = 1)
dim(otu_data)
dataset1 <- matrix(NA, nrow = nrow(otu_data), ncol = ncol(otu_data))
dataset2 <- matrix(NA, nrow = nrow(otu_data), ncol = ncol(otu_data))
for (i in 1:ncol(otu_data)) {
  X <- otu_data[, i]
  for (j in 1:length(X)) {
    z <- X[j]
    alpha <- 1 + z
    beta <- 2  
    X_simulated <- rgamma(1, shape = alpha, rate = beta)
    new_Z <- rpois(2, lambda = X_simulated)
    dataset1[j, i] <- new_Z[1]
    dataset2[j, i] <- new_Z[2]
  }
}
dataset1 <- as.data.frame(dataset1)
dataset2 <- as.data.frame(dataset2)
write.csv(dataset1, file = '1001_lines/dataset1.csv', quote = FALSE, row.names = TRUE)
write.csv(dataset2, file = '1001_lines/dataset2.csv', quote = FALSE, row.names = TRUE)
cat("Datasets have been generated and saved as CSV files.\n")