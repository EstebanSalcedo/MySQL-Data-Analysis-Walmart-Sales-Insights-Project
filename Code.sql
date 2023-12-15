create database salesDataWalmart;
use salesDataWalmart;

create table sales (
	invoce_id varchar(30) not null primary key,
    branch varchar(5) not null, 
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float (6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_pcpt float(11,9),
    gross_income decimal(12,4) not null,
    rating float(2,1)
    );

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/WalmartSalesData.csv'
INTO TABLE sales 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

----------------- FEATURE ENGINEERING---------------------------------------
-- Adding time_of_day column ----------------------------------------------
select time,
	Case
		when time between "00:00:00" and "12:00:00" then 'Morning'
        when time between "12:01:00" and "16:00:00" then 'Afternoon'
        else 'Evening'
	end as time_of_day
from sales;

alter table sales
add column time_of_day varchar(20);

UPDATE sales
SET time_of_day =
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;
    
-- Adding day_name ----------------------------------------------------

alter table sales
add column day_of_week varchar(20);

UPDATE sales
SET day_of_week = dayname(date);

select day_of_week from sales;

-- Adding month_name --------------------------------------------------
alter table sales
add column month varchar(20);

UPDATE sales
SET month = monthname(date);

select * from sales; 
-- -------------------------- GENERIC -------------------------------------

-- How many cities unique does the data have?
select distinct city
from sales;

select distinct branch
from sales;

-- In which city is each branch?

select distinct city, branch from sales;

-- --------------------------PRODUCT ---------------------
select*from sales;

-- How many unique products line does data have?
select count(distinct product_line) from sales;

-- What is the most common payment methond?
select payment, count(payment) as cnt 
from sales 
group by payment 
order by cnt desc;

-- What is the most selling product line?
select product_line, count(product_line) cnt
from sales
group by product_line
order by cnt desc;

-- What is the total revenue by month?
select month, sum(total) as cnt
from sales
group by month
order by cnt desc;

-- What month had the largest COGS?
select month, sum(cogs) as COGS
from sales
group by month
order by COGS desc;

-- What produc line had the larget revenue?
Select product_line, sum(total) as revenue
from sales
group by product_line
order by revenue desc;

-- What is the city with the largest revenue?
select city, sum(total) as revenue
from sales
group by city
order by revenue;

-- What product line had the largest VAT?
select product_line as product, avg(vat) as AVG_VAT
from sales
group by product
order by AVG_VAT;

-- Which branch sold more product than the average product sold?
select
branch, sum(quantity) as qty
from sales
group by branch
having qty > (select avg(quantity) from sales);

-- What is the most common product line gender?
select gender, product_line, count(gender) as cnt
from sales
group by gender, product_line
order by cnt desc;

-- What is the average rating of each product line?
select product_line, round(avg(rating), 2) as avg_rating
from sales
group by product_line
order by avg_rating desc;

