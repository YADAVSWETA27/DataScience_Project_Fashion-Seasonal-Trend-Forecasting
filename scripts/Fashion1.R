# ========================================================
# FASHION TREND FORECASTING PROJECT (Team B11)
# ========================================================
# This script generates all analysis, models, and graphs

# 1. Start Output Logging
sink("project_output.txt")
cat("Fashion Project Logging Started...\n")
cat("========================================\n")

# 2. Install and Load Libraries
# (Checks if installed, installs if missing)
required_packages <- c("tidyverse", "lubridate", "randomForest", "caret", "ggplot2", "readr")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(tidyverse)
library(lubridate)
library(randomForest)
library(caret)
library(readr)

cat("Libraries loaded successfully.\n")

# 3. Load Dataset
# Note: Reading 1,000,000 rows to ensure we cover enough days for the model.
cat("\nLoading Data (1 Million rows)... This may take a moment.\n")

if(file.exists("transactions_train.csv") & file.exists("articles.csv")) {
  transactions <- read_csv("transactions_train.csv", n_max = 1000000)
  articles <- read_csv("articles.csv")
  cat("Datasets loaded successfully!\n")
} else {
  stop("ERROR: 'transactions_train.csv' or 'articles.csv' not found in working directory.")
}

# 4. Data Cleaning & Merging
cat("\nCleaning and Merging Data...\n")
data_merged <- transactions %>%
  left_join(articles %>% select(article_id, product_group_name), by = "article_id") %>%
  mutate(t_dat = as.Date(t_dat)) %>%
  filter(sales_channel_id == 2) # Focus on Online Sales

cat("Data cleaned. Rows to analyze:", nrow(data_merged), "\n")


# 6. PREDICTIVE MODELING (Random Forest)

cat("\nTraining Random Forest Model...\n")

# Feature Engineering: Add Lag (Yesterday's Sales)
model_data <- daily_sales %>%
  mutate(month = month(t_dat),
         lag_1_day = lag(total_sales, 1)) %>%
  na.omit()

# Split Data (80% Train, 20% Test)
set.seed(123)
train_index <- createDataPartition(model_data$total_sales, p = 0.8, list = FALSE)
train_data <- model_data[train_index, ]
test_data <- model_data[-train_index, ]

# Train Model
rf_model <- randomForest(total_sales ~ month + lag_1_day, data = train_data, ntree = 100)

cat("Model Trained Successfully.\n")
print(rf_model)

# Predictions & Evaluation
predictions <- predict(rf_model, test_data)
rmse <- sqrt(mean((test_data$total_sales - predictions)^2))
r_squared <- cor(test_data$total_sales, predictions)^2

cat("\n=== MODEL METRICS ===\n")
cat("RMSE (Root Mean Squared Error):", round(rmse, 2), "\n")
cat("R-Squared (Accuracy):", round(r_squared, 2), "\n")

# 7. KEY INSIGHTS (For Slide 9)
cat("\n========================================\n")
cat("=== KEY BUSINESS INSIGHTS (The 'So What?') ===\n")
cat("1. DYNAMIC INVENTORY: Switch to daily/weekly ordering based on 'Lag' data.\n")
cat("2. MATERIAL STRATEGY: Stock Knitwear conservatively; buy Denim in bulk.\n")
cat("3. CLEARANCE: Launch sales exactly when the trend line dips (Mid-October).\n")
cat("========================================\n")
# GRAPHS
# GRAPH 1
# --- BLOCK 1: SETUP & HEARTBEAT GRAPH ---
library(tidyverse)
library(lubridate)
library(randomForest)
library(caret)
library(readr)

# 1. Load Data
if(!exists("transactions")) {
  cat("Loading Data... (This takes 30 seconds)\n")
  transactions <- read_csv("transactions_train.csv", n_max = 1000000)
  articles <- read_csv("articles.csv")
}

# 2. Clean Data
data_merged <- transactions %>%
  left_join(articles %>% select(article_id, product_group_name), by = "article_id") %>%
  mutate(t_dat = as.Date(t_dat)) %>%
  filter(sales_channel_id == 2)

# 3. Generate Graph 1
daily_sales <- data_merged %>%
  group_by(t_dat) %>%
  summarise(total_sales = n())

p1 <- ggplot(daily_sales, aes(x = t_dat, y = total_sales)) +
  geom_line(color = "#2c3e50", size = 1) +
  geom_smooth(method = "loess", color = "#e74c3c", se = FALSE) +
  labs(title = "Daily Sales Trend (The 'Heartbeat')", x = "Date", y = "Sales Volume") +
  theme_minimal()

print(p1)
ggsave("Slide4_Heartbeat.png", width = 8, height = 5)
cat("SUCCESS: Graph 1 Saved (Slide4_Heartbeat.png)\n")

# GRAPH 2
# ========================================================
# FIX FOR SLIDE 5: AUTO-DETECT CATEGORIES
# ========================================================
library(tidyverse)
library(lubridate)
library(ggplot2)

# 1. Load Data (if needed)
if(!exists("data_merged")) {
  transactions <- read_csv("transactions_train.csv", n_max = 1000000)
  articles <- read_csv("articles.csv")
  data_merged <- transactions %>%
    left_join(articles %>% select(article_id, product_group_name), by = "article_id") %>%
    mutate(t_dat = as.Date(t_dat)) %>%
    filter(sales_channel_id == 2)
}

cat("Diagnosing Data...\n")

# 2. AUTO-DETECT: Find the Top 3 Selling Categories automatically
top_categories <- data_merged %>%
  count(product_group_name, sort = TRUE) %>%
  slice(1:3) %>% # Take the top 3 biggest categories
  pull(product_group_name)

print(paste("Top Categories Found:", paste(top_categories, collapse = ", ")))

# 3. Filter Data for these Top 3
plot_data <- data_merged %>%
  mutate(Month = month(t_dat, label = TRUE, abbr = TRUE)) %>%
  filter(product_group_name %in% top_categories) %>%
  group_by(product_group_name, Month) %>%
  summarise(Sales = n(), .groups = 'drop')

# 4. Plot (Using Default Colors to avoid "Shared Levels" error)
p_new <- ggplot(plot_data, aes(x = product_group_name, y = Sales, fill = Month)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  
  labs(title = "Seasonal Shift: Top Categories",
       subtitle = paste("Comparison of", paste(unique(plot_data$Month), collapse=" vs ")),
       x = "Product Category", 
       y = "Items Sold") +
  theme_light() +
  theme(plot.title = element_text(face = "bold", size = 14))

print(p_new)
ggsave("Slide5_Material.png", width = 8, height = 5)

cat("\nSUCCESS: Slide 5 Graph Saved using Auto-Detected Categories!\n")

#GRAPH 3
# --- BLOCK 3: MODEL & PREDICTION GRAPH ---

# 1. Prepare Data
model_data <- daily_sales %>%
  mutate(month = month(t_dat),
         lag_1_day = lag(total_sales, 1)) %>%
  na.omit()

# 2. Train Model
set.seed(123)
train_index <- createDataPartition(model_data$total_sales, p = 0.8, list = FALSE)
train_data <- model_data[train_index, ]
test_data <- model_data[-train_index, ]

rf_model <- randomForest(total_sales ~ month + lag_1_day, data = train_data, ntree = 50)

# 3. Predict
predictions <- predict(rf_model, test_data)
rmse <- sqrt(mean((test_data$total_sales - predictions)^2))

# 4. Plot
eval_plot <- test_data %>%
  mutate(Predicted = predictions) %>%
  pivot_longer(cols = c(total_sales, Predicted), names_to = "Type", values_to = "Sales")

p3 <- ggplot(eval_plot, aes(x = t_dat, y = Sales, color = Type)) +
  geom_line(size = 1) +
  scale_color_manual(values = c("total_sales" = "black", "Predicted" = "red")) +
  labs(title = "Model Evaluation: Actual vs Predicted",
       subtitle = paste("RMSE:", round(rmse, 2)), x = "Date", y = "Sales") +
  theme_minimal()

print(p3)
ggsave("Slide8_Prediction.png", width = 8, height = 5)
cat("SUCCESS: Graph 3 Saved (Slide8_Prediction.png)\n")

sink() # Stop logging