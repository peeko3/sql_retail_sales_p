Create table R_sales(
        
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
);

SELECT count(*) FROM R_sales;
SELECT * FROM R_sales;

--Identify null values
SELECT * FROM R_sales
where 
      transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL 
	  OR
	  age IS NULL
	  OR
	  category IS NULL 
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR 
	  cogs IS NULL
	  OR
	  total_sale is null

-- DELETE NULL VALUES
DELETE FROM R_sales
WHERE
       transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL 
	  OR
	  age IS NULL
	  OR
	  category IS NULL 
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR 
	  cogs IS NULL
	  OR
	  total_sale is null

---DATA EXPLORATION

--how many sales we have
select count(*) as total_sale from R_sales;

--how many unique customer we have 
select count(distinct customer_id) from R_sales

select distinct category from R_sales


-- Analysis and Findings

 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
 select * from R_sales 
 where sale_date = '2022-11-05';
 
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from R_sales
where category='Clothing'
AND
TO_CHAR(sale_date,'yyyy-mm')='2022-11'
AND
quantiy>=4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as total_sales,
count(*) as total_orders
from R_sales
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select category,round(avg(age),2) as AVg_age
from R_sales
where 
   category='Beauty'
   group by category

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM R_sales
where total_sale>1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,gender,
count(transactions_id) as total_transactions
from R_sales
group by category,gender
ORDER BY 
     category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM R_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id ,
       sum(total_sale) as total_sales
from R_sales
group by 1
order by 2 desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,
     count(distinct(customer_id)) as unique_cust
from R_sales
	 group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)  
WITH hourly_sale
as
(
SELECT *,
       CASE
	       WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		   ELSE 'Evening'
	   END AS shift
from R_sales
)
SELECT shift,
      count(*) as total_orders
from hourly_sale
group by shift
