# 1. Load Libraries
library(tidyverse)

# 2. Read just the first 1000 rows (Fast & Easy)
transactions <- read_csv("transactions_train.csv", n_max = 50)
articles <- read_csv("articles.csv", n_max = 50)

# 3. Display the "Transactions" Data (Sales History)
print("=== TRANSACTIONS DATA (First 10 Rows) ===")
head(transactions, 10)

# 4. Display the "Articles" Data (Product Details)
print("=== ARTICLES DATA (Product Details) ===")
head(articles %>% select(article_id, product_group_name, colour_group_name), 10)

# 5. View in a nice table (Opens a new tab in RStudio)
View(transactions)