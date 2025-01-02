--Creating database
create database sql_project

-- creating table
drop table if exists retail_sales;
create table retail_sales(
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(10),
	age int,
	category varchar(20),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float
	);
ALTER table retail_sales
rename column quantiy to quantity;

select * from retail_sales limit 10;
select count(*) from retail_sales;

-- Identifies the null value of row
select * from retail_sales
where transactions_id is null
	or sale_date is null
	or customer_id is null
	or gender is null
	or category is null
	or quantiy is null
	or price_per_unit is null
	or cogs is null
	or total_sale is null;
-- removing the null value from table
Delete from retail_sales
where transactions_id is null
	or sale_date is null
	or customer_id is null
	or gender is null
	or category is null
	or quantiy is null
	or price_per_unit is null
	or cogs is null
	or total_sale is null;

	-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales
where sale_date='2022-11-05'
order by 1,2;


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in 
-- the month of Nov-2022
select * from retail_sales
where category='Clothing'
		AND 
		TO_char(sale_date,'YYYY-MM')='2022-11'
		AND
		quantity>3
order by 1;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as net_sale,
count(*) as total_order 
from retail_sales
group by category
order by 2 desc;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category,round(AVG(age),2) as avg_age 
from retail_sales
group by category
having category='Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale>1000
order by 1;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category,count(*)
from retail_sales
group by 1,2
order by count(*) desc;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select month,
	year,
	avg_sale,
	rank
	from
		(select 
			extract(month from sale_date) as month,
			extract(year from sale_date) as year,
			AVG(total_sale) as avg_sale,
			RANK() over(partition by extract(year from sale_date) order by AVG(total_sale) desc) as rank
		from retail_sales
		group by 1,2
		order by 2,3 desc) t

where rank=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sale
from retail_sales
group by 1
order by 2 desc limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,
count(DISTINCT customer_id) as uni_cus_id
from retail_sales
group by 1
order by 2 desc;
	


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale 
as
	(
	select *,
	CASE
		when EXtract(Hour from sale_time) < 12 THEN 'Morning'
		when EXtract(Hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	END as sale_shift
	from retail_sales
	)
Select sale_shift, count(*)
from hourly_sale
group by sale_shift
order by count(*) desc;




