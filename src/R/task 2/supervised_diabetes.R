library(Hmisc)
library(ggplot2)
library(dplyr)
library(tidyr)
diabetes <- read.csv("../../data/diabetes.csv")

# Note: This is an undocumented dataset. To find out the meaning of the columns, a jupyter notebook analyze_diabetes.ipynb has been used, it's results being known here
# Note 2: Again I had issues with the R package manager, not being able to install a proper version of the requested package.

# Define a function for IQR based outlier detection and replacement
detect_replace_outliers <- function(x) {
  Q1 <- quantile(x, 0.25)
  Q3 <- quantile(x, 0.75)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  
  # Replace outliers with NA
  x[x < lower_bound | x > upper_bound] <- NA
  return(x)
}

# Apply outlier detection to numerical columns
num_cols <- sapply(diabetes, is.numeric)
diabetes[num_cols] <- lapply(diabetes[num_cols], detect_replace_outliers)

# Replace zeros with NA in columns where zero is not meaningful, data derived from analyze_diabetes.ipynb
cols_with_zeros <- c("plas", "pres", "skin", "insu", "mass")
diabetes[cols_with_zeros] <- lapply(diabetes[cols_with_zeros], function(x) replace(x, x == 0, NA))

# Drop NA
diabetes_clean <- diabetes %>% drop_na()

# Describe
describe(diabetes_clean) 

# Note: After trying to debug why the R package manager cannot install a proper version of FSelector exceeding the time I can spend for this task I stop doing it with R here and continue with python.