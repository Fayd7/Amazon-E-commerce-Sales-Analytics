🛍️ Amazon E-Commerce Sales Analytics Project
📘 Project Overview

This project showcases an end-to-end data analytics pipeline built using Python, MySQL, and Power BI to explore and visualize Amazon’s e-commerce sales performance.
The workflow covers data cleaning, transformation, database management, SQL analytics, and interactive dashboard development for actionable business insights.

🎯 Objectives

Clean and preprocess raw e-commerce data using Python (Pandas, NumPy).

Store, query, and manage the cleaned data in a MySQL relational database.

Apply SQL techniques (aggregations, joins, CTEs, and window functions) for data analysis.

Build an interactive Power BI dashboard to visualize key business metrics such as sales, returns, delivery delays, and customer satisfaction.

🗂️ Dataset Overview

File Name: amazon.csv
Database: amazon_sales (MySQL)

Key Columns:

Column	Description
order_id	Unique identifier for each order
customer_name	Customer’s full name
product_name	Name of the product purchased
category, sub_category	Product classification
region	Sales region
price, quantity, discount(%), shipping_cost	Transaction details
order_date, delivery_date	Order and delivery timestamps
return_requested, review_text, rating	Customer feedback & returns
payment_method	Payment type used
delivery_delay_days	Delivery performance metric
⚙️ Workflow
🧹 Step 1: Data Cleaning (Python)

Used Pandas and NumPy for preprocessing:

Removed duplicate and null values.

Standardized text columns with .str.strip() and .str.title().

Capped outliers using the 99th percentile (quantile(0.99) method).

Imputed missing values using median/mode strategies.

Exported the cleaned dataset for database integration.

Example:

df['Price'].fillna(df['Price'].median(), inplace=False)
df['Region'] = df['Region'].str.strip().str.title()
price_cap = df['Price'].quantile(0.99)
df['Price'] = np.where(df['Price'] > price_cap, price_cap, df['Price'])

🗄️ Step 2: Database Integration (MySQL)

Created the amazon_sales database and imported cleaned data using SQLAlchemy.

Wrote SQL queries to analyze trends in pricing, customer ratings, discounts, and returns.

Used CTEs, window functions, and aggregations for deep insights.

Example:

-- Top 5 highest-rated products per category
WITH top_rated AS (
  SELECT category, product_name, rating,
         RANK() OVER (PARTITION BY category ORDER BY rating DESC) AS rnk
  FROM amazon_sales
)
SELECT category, product_name, rating
FROM top_rated
WHERE rnk <= 5;

📊 Step 3: Data Visualization (Power BI)

Connected Power BI directly to the MySQL database to build an interactive sales and customer insights dashboard.

Dashboard Highlights:

KPI Cards: Total Sales, Profit Margin, Average Rating, Return Rate.

Regional Sales Map: Visualizes sales performance by geography.

Category Performance Chart: Sales vs Profit by category and sub-category.

Sales Trend Line: Month-over-month and year-over-year growth tracking.

Payment Method Analysis: Popularity and distribution of payment modes.

Customer Review Word Cloud (optional): Highlighted key sentiment words.

💡 Key Insights

West region generated the highest revenue, followed by South.

Technology category led in profit margin, while Furniture had the most returns.

Credit Card payments dominated sales transactions.

Significant sales spikes in Q4, indicating strong seasonal demand.

Delivery delays directly impacted customer ratings.

🧭 Recommendations

Optimize delivery logistics in regions with high delays.

Increase marketing focus on high-margin categories.

Introduce customer incentives for repeat purchases.

Streamline product listings to reduce return rates.

Implement review-based quality improvement for low-rated items.

🧰 Tools & Technologies
Tool	Purpose
Python (Pandas, NumPy)	Data cleaning & preprocessing
MySQL	Data storage & SQL analysis
Power BI	Data visualization & dashboard creation
SQLAlchemy	Python–MySQL integration
Excel/CSV	Initial data format


🧩 Outcome

The Amazon E-Commerce Sales Dashboard provides stakeholders with a 360-degree view of business performance, helping identify growth opportunities, operational inefficiencies, and customer experience gaps through data-driven insights.




Author ---
Mohammed Fayd F
