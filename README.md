# Fashion: Seasonal Trend Forecasting  
## Inventory Demand Forecasting Using Time-Series Sales Analysis

## Introduction
The fashion industry is highly seasonal and trend-driven, making inventory planning a challenging task. Clothing demand changes frequently due to factors such as weather, festivals, consumer preferences, and promotional periods. Poor demand forecasting can result in overstocking, stock shortages, and financial losses.

This project focuses on analysing historical sales data of a clothing brand to identify seasonal trends and forecast future inventory requirements using time-series analysis and machine learning techniques. The goal is to assist fashion retailers in making informed, data-driven inventory decisions.

---

## What This Project Is About
This project studies past sales data to:
- Understand how clothing sales vary over time
- Identify seasonal demand patterns
- Analyse category-wise performance
- Predict future sales using historical trends

By analysing daily and monthly sales behaviour, the project provides insights that can help brands plan inventory more efficiently and reduce wastage.

---

## Why This Project Is Important
Fashion brands often place inventory orders months in advance without accurate forecasting. This leads to:
- Excess stock that requires heavy discounts
- Shortage of popular items during peak demand
- Increased storage and logistics costs

Using time-series forecasting helps brands:
- Predict upcoming demand
- Stock the right products at the right time
- Improve customer satisfaction
- Increase overall profitability

---

## Dataset Used
- *Dataset Name:* H&M Personalized Fashion Recommendations Dataset
- *Source:* Kaggle
- *Type:* Historical transaction-level sales data
- *Time Period:* 2018 – 2020

### Key Columns Used
- t_dat – Date of transaction
- article_id – Product identifier
- customer_id – Customer identifier
- price – Selling price of the item
- sales_channel_id – Sales channel (online/offline)
- product_group_name – Clothing category

Due to the large size of the dataset, only small sample files are stored in this repository. The complete dataset link is provided in the /data folder.

---

## Tools and Technologies Used
- *Programming Language:* R
- *IDE:* RStudio
- *Libraries Used:*
  - tidyverse – Data manipulation and cleaning
  - lubridate – Date and time handling
  - ggplot2 – Data visualisation
  - randomForest – Machine learning model
  - caret – Model training and evaluation

---

## Project Workflow
### 1. Data Loading and Cleaning
- Loaded transaction and product datasets
- Filtered online sales records
- Merged datasets using product IDs
- Removed noise and irrelevant records

### 2. Exploratory Data Analysis (EDA)
- Analysed daily sales trends over time
- Identified seasonal demand patterns
- Studied category-wise sales behaviour
- Visualised trends using line and bar charts

### 3. Feature Engineering
- Extracted month information from dates
- Created lag features based on previous sales
- Prepared structured time-series data for modelling

### 4. Model Building
- Used Random Forest Regressor to forecast sales
- Split data into training and testing sets
- Trained the model on historical sales patterns

### 5. Model Evaluation
- Evaluated model performance using RMSE
- Compared actual sales with predicted values
- Visualised prediction accuracy using graphs

### 6. Business Insights
- Identified peak sales periods
- Highlighted high-demand product categories
- Suggested inventory planning strategies based on trends

---

## Project Output
- Daily sales trend visualisation (“Sales Heartbeat”)
- Seasonal comparison of top clothing categories
- Actual vs predicted sales plot
- Final presentation summarising findings and insights

All generated plots and the final PPT are stored in the /output folder.

## Team Members
- *901 – Yadav Mansi Rampal*
- *902 – Yadav Swetakumari Vinod*
- *903 – Mistry Jaykumar Chetankumar*
- *904 – More Anuj Mahendra*
- *905 – Palkar Shravani Sushil*
