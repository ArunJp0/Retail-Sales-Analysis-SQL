create table retail_sales
             (
             transactions_id int PRIMARY KEY,
             sale_date date,
             sale_time time,
             customer_id int,
             gender varchar(15),
             age int,
             category varchar(15),
             quantity int,
             price_per_unit float,
             cogs float,
             total_sale float
             );
             
select * from retail_sales;
select count(*) from retail_sales;

-- Data Cleaning
select * from retail_sales 
where transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null
or
age is null
or
quantity is null
or
cogs is null
or
price_per_unit is null
or
total_sale is null;

delete from retail_sales 
where transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
category is null
or
age is null
or
quantity is null
or
cogs is null
or
price_per_unit is null
or
total_sale is null;
--

-- Basic Data Exploration 

-- 1. How many sales we have?
      select count(*) as total_sale from retail_sales;

-- 2. How many unique customers we have?
      select count(distinct customer_id) as customer_id from retail_sales;

-- 3. How many categories we have?
      select distinct category from retail_sales;

--

-- Data Analysis & Business Key Problems and Answers

-- 1. Write a sql query to retrieve all columns for sales made on 2022-11-05
	  select * from retail_sales 
      where sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
      select * from retail_sales where category = 'Clothing' 
	  AND MONTH(sale_date) = 11
      AND YEAR(sale_date) = 2022
      and quantity >= 4
      order by sale_date;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.
      select category, 
      sum(total_sale) as total_sales,
      count(*) as total_orders
      from retail_sales
      group by category
      order by total_sales desc;
      
-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
      select round(avg(age),2) as average_age 
      from retail_sales
      where category = 'Beauty';
      
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
      select * from retail_sales
      where total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
      select category, gender, count(*) as transactions
      from retail_sales
      group by gender, category
      order by 1;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
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

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.
      SELECT customer_id, SUM(total_sale) AS total_sales
	  FROM retail_sales
      GROUP BY customer_id
      ORDER BY total_sales DESC
      LIMIT 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.
      select count(distinct customer_id) as customers, category
      from retail_sales
      group by category
      order by customers;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
       WITH hour_sale as
       (
	   select *,
       case
	   when EXTRACT(hour from sale_time) < 12 then 'Morning'
	   when EXTRACT(hour from sale_time) between 12 and 17 then 'Afternoon'
	   else 'Evening'
       end as shift
       from retail_sales
       )
       select shift, COUNT(*) as total_orders    
       from hour_sale
       group by shift

-- End of Project

