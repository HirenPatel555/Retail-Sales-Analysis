-- SQL Retail Sales Analysis, Project 01

create database sql_project_01;

-- Table Creating

-- drop table if exists retail_sale_tb;

create table retail_sale_tb(
				transactions_id int primary key,
				sale_date date,
				sale_time time,	
				customer_id int,
				gender varchar(25),	
				age	int,
				category varchar(25),
				quantiy int,
				price_per_unit float,
				cogs float,
				total_sale float
);

select * from retail_sale_tb;

select * from retail_sale_tb
where transactions_id = 1;

select count(*) from retail_sale_tb;

-- truncate table retail_sale_tb;

SELECT *
FROM retail_sale_tb
WHERE age IS NULL;

-- data cleaning 

select * from retail_sale_tb 
where 
	transactions_id is null
	or sale_date is null 
	or sale_time is null 
    or customer_id is null 
    or gender is null 
    or age is null 
    or category is null 
    or quantiy is null 
    or price_per_unit is null 
    or cogs is null 
    or total_sale is null ;

-- data exploration

-- how many sales we have?
select count(*) as total_sale from retail_sale_tb;

-- how many uniuque customer we have?
select count(distinct customer_id) from retail_sale_tb;

-- how many uniuque category we have?
select count(distinct category) from retail_sale_tb;
select distinct category from retail_sale_tb;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 04 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * 
from retail_sale_tb
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 04 in the month of Nov-2022

select *
from retail_sale_tb
where category = 'Clothing' 
and YEAR(sale_date) = 2022
and MONTH(sale_date) = 11
and 
quantiy >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
category,
sum(total_sale) as net_sale
from retail_sale_tb
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
round(avg(age), 2) as avg_age
from retail_sale_tb
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

 select * from retail_sale_tb
 where total_sale >=1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
	category,
    gender,
    count(*) as total_trans
from 
	retail_sale_tb
group by category, gender
order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
	year, 
    month, 
    avg_sale 
from (
	select 
		year(sale_date) as year,
		month(sale_date) as month,
		round(avg(total_sale), 2) as avg_sale,
		rank() over(
				partition by year(sale_date)
                order by avg(total_sale) desc
                ) as sale_rank
		from retail_sale_tb
		group by 1, 2
) as t1
where sale_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
	customer_id,
    sum(total_sale) as total_sale
from retail_sale_tb
group by 1
order by 2 desc	
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
	category,
    count(distinct customer_id) as cnt_unique_cs
from retail_sale_tb
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(
select *,
	case 
		when extract(hour from sale_time)< 12 then 'morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        else 'evening'
	end as shift
from retail_sale_tb
) 
select 
	shift,
    count(transactions_id) as total_orders
from hourly_sale
group by shift;












