# Retail-Sales-Analysis-SQL

## Project Overview

**Project Title** : Retail Sales Analysis
**Level** : Beginner
**Database** : rs_analysis

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named rs_analysis.
- **Table Creation**: A table named 'retail_sales' is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE rs_analysis;

CREATE TABLE retail_sales
(
    transactions_id int PRIMARY KEY,
    sale_date date,	
    sale_time time,
    customer_id int,	
    gender varchar(10),
    age int,
    category varchar(35),
    quantity int,
    price_per_unit float,	
    cogs float,
    total_sale float
);
```

### 2. Data Exploration and Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
select * from retail_sales;
select count(*) from retail_sales;
select count(distinct customer_id) from retail_sales;
select distinct category from retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Basic Data Exploration

1. **How many sales we have**
   ```sql
   select count(*) as total_sale from retail_sales;
   ```

2. **How many unique customers we have**
   ```sql
   select count(distinct customer_id) as customer_id from retail_sales;
   ```

3. **How many categories we have**
   ```sql
   select distinct category from retail_sales;
   ```

### 4. Data Analysis & Business Key Problems and Answers

1. **Write a sql query to retrieve all columns for sales made on 2022-11-05**
   ```sql
   select * from retail_sales 
   where sale_date = '2022-11-05';
   ```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**
   ```sql
   select * from retail_sales where category = 'Clothing' 
   and month(sale_date) = 11
   and year(sale_date) = 2022
   and quantity >= 4
   order by sale_date;
   ```

3. **Write a SQL query to calculate the total sales (total_sale) for each category**
   ```sql
   select category, 
   sum(total_sale) as total_sales,
   count(*) as total_orders
   from retail_sales
   group by category
   order by total_sales desc;
   ```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**
   ```sql
   select round(avg(age),2) as average_age 
   from retail_sales
   where category = 'Beauty';
   ```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000**
   ```sql
   select * from retail_sales
   where total_sale > 1000;
   ```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category**
   ```sql
   select category, gender, count(*) as transactions
   from retail_sales
   group by gender, category
   order by 1;
   ```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**
   ```sql
   with avg_sale as (
      select year(sale_date) as sale_year, month(sale_date) as sale_month, 
      round(avg(total_sale),2) as average_sale
      from retail_sales
      group by month(sale_date), year(sale_date)
      order by month(sale_date), year(sale_date)
      ),
      ranked_month as(
      select *,
      rank() over(partition by sale_year ORDER BY average_sale DESC) as rnkk
      from avg_sale
      )
      SELECT sale_year, sale_month, average_sale
      FROM ranked_month
      WHERE rnkk = 1
      ORDER BY sale_year;
   ```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**
   ```sql
   SELECT customer_id, SUM(total_sale) AS total_sales
   FROM retail_sales
   GROUP BY customer_id
   ORDER BY total_sales DESC
   LIMIT 5;
   ```

9. **Write a SQL query to find the number of unique customers who purchased items from each category**
    ```sql
   select count(distinct customer_id) as customers, category
   from retail_sales
   group by category
   order by customers;
   ```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**
    ```sql
    WITH hour_sale as
       (
	   select *,
     case
	   when EXTRACT(hour from sale_time) < 12 then 'Morning'
	   when EXTRACT(hour from sale_time) between 12 and 17 then 'Afternoon'
	   else 'Evening'
     end as shift
     from retail_sale
    ) 
    select shift, COUNT(*) as total_orders    
    from hour_sale
    group by shift;
    ```

# Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

# Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

# Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.



