import pandas as pd
import numpy as np
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
import plotly.express as px
import os

# Ensure Working Directory is correct, assuming csv is in same directory as script
os.chdir(os.path.dirname(__file__))

# Load the dataset
food_data = pd.read_csv("food.csv", index_col=0)

# Print dimensions and count of missing values
print(f"Dimensions: {food_data.shape[0]} x {food_data.shape[1]}")
print(f"Missing values (n): {food_data.isna().sum().sum()}")

# Scale the data
scaler = StandardScaler()
food_data_scaled = scaler.fit_transform(food_data)

# Perform PCA
pca = PCA(n_components=2)
pca_results = pca.fit_transform(food_data_scaled)

# Create DataFrame for scores
scores_df = pd.DataFrame(pca_results, columns=['PC1', 'PC2'], index=food_data.index)

# Flip the scores so the plots are similar to R output
scores_df['PC1'] = -scores_df['PC1']  
scores_df['PC2'] = -scores_df['PC2']

# PCA Score Plot using matplotlib (similar to qplot)
plt.figure(figsize=(10, 8))
plt.scatter(scores_df['PC1'], scores_df['PC2'])
plt.xlabel('PC1')
plt.ylabel('PC2')
plt.axhline(y=0, color='b', linestyle='--')  #
plt.axvline(x=0, color='b', linestyle='--')  
plt.title('PCA Score Plot')
for i, txt in enumerate(scores_df.index):
    plt.annotate(txt, (scores_df['PC1'][i], scores_df['PC2'][i]))
plt.show()

# Interactive PCA Score Plot using plotly
fig = px.scatter(scores_df, x='PC1', y='PC2', text=scores_df.index,
                 title='PCA Score Plot', labels={'PC1': 'PC1', 'PC2': 'PC2'})
fig.update_traces(textposition='bottom center', marker=dict(size=10), hoverinfo='text')
fig.update_layout(xaxis_title='PC1', yaxis_title='PC2',
                  xaxis=dict(zeroline=True, showline=True,zerolinewidth=2, zerolinecolor='LightPink',),
                  yaxis=dict(zeroline=True, showline=True,zerolinewidth=2, zerolinecolor='LightPink',))

fig.show()

# Again, like in R create a centered plot
range_x = max(abs(scores_df['PC1'].min()), abs(scores_df['PC1'].max()))
range_y = max(abs(scores_df['PC2'].min()), abs(scores_df['PC2'].max()))
max_range = max(range_x, range_y )

fig.update_layout(xaxis_title='PC1', yaxis_title='PC2',
                  xaxis=dict(range=[-max_range, max_range], zeroline=True, zerolinewidth=2, zerolinecolor='LightPink',showline=True),
                  yaxis=dict(range=[-max_range, max_range], zeroline=True, zerolinewidth=2, zerolinecolor='LightPink',showline=True))
fig.show()