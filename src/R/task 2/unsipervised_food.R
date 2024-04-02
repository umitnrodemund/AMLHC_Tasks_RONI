library(ggplot2)
library(plotly)

food_data <- read.csv(".food.csv", row.names = 1)

print(paste("Dimensions: ", paste(dim(food_data), collapse = " x ")))
print(paste("Missing values (n): ", sum(is.na(food_data))))

# Prepare dataframe
food_data_scaled <- scale(food_data)
pca_results <- princomp(food_data_scaled, cor = TRUE)
scores <- pca_results$scores[, 1:2]
scores_df <- data.frame(PC1 = scores[, 1], PC2 = scores[, 2], Country = rownames(scores))

# Use qplot, as given task
qplot(scores[, 1], scores[, 2], xlab = "PC1", ylab = "PC2", main = "PCA Score Plot")

# Create a more comprehensive plot using a more flexible library creating dynamic plots
plot_ly(data = scores_df, 
        x = ~PC1, 
        y = ~PC2, 
        type = 'scatter', 
        mode = 'markers+text', 
        text = ~Country, 
        hoverinfo = 'text', 
        marker = list(size = 10), 
        textposition = 'bottom center') %>%
  layout(title = 'PCA Score Plot',
         xaxis = list(title = 'PC1'),
         yaxis = list(title = 'PC2'))

# To center this plot the axis ranges are needed

range_x <- range(scores_df$PC1, na.rm = TRUE)
range_y <- range(scores_df$PC2, na.rm = TRUE)
max_range <- max(abs(c(range_x, range_y)))

# Create a more comprehensive plot using a more flexible library, centered
plot_ly(data = scores_df, 
        x = ~PC1, 
        y = ~PC2, 
        type = 'scatter', 
        mode = 'markers+text', 
        text = ~Country, 
        hoverinfo = 'text', 
        marker = list(size = 10), 
        textposition = 'bottom center') %>%
  layout(title = 'PCA Score Plot',
         xaxis = list(title = 'PC1', zeroline = TRUE, showline = TRUE, range = c(-max_range, max_range)),
         yaxis = list(title = 'PC2', zeroline = TRUE, showline = TRUE, range = c(-max_range, max_range)))

