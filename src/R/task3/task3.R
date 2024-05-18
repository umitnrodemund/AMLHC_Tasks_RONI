library(ggplot2)
library(plotly)
library(clusterCrit)
library(ggplot2)
library(cluster)
library(fpc)
library(dendextend)

food_data <- read.csv("../../data/food.csv", row.names = 1)
food_scaled <- scale(food_data)


silhouette_scores <- c()
for (k in 2:5) {
  kmeans_model <- kmeans(food_scaled, centers = k, nstart = 25)
  silhouette_scores[k - 1] <- intCriteria(food_scaled, kmeans_model$cluster, "Silhouette")$score
}

# Select the final number of clusters
optimal_k <- which.max(silhouette_scores) + 1
final_kmeans <- kmeans(food_scaled, centers = optimal_k, nstart = 25)

pca <- princomp(food_scaled)
scores_df <- data.frame(pca$scores, Cluster = as.factor(final_kmeans$cluster))


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



# Hierarchical clustering and dendrogram
dist_matrix <- dist(food_scaled)
hc <- hclust(dist_matrix)
dend <- as.dendrogram(hc)
plot(dend, main = "Dendrogram of Hierarchical Clustering")

# Heatmap with clustering of samples and variables
heatmap(food_scaled, Rowv = as.dendrogram(hc), Colv = NA, scale = "row", main = "Heatmap with Hierarchical Clustering")

# Density-based clustering
db <- dbscan(food_scaled, eps = 0.5, MinPts = 5)
plot(pca$scores[, 1:2], col = db$cluster + 1L, main = "DBSCAN Clustering")


