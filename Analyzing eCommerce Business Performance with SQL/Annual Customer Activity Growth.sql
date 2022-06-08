-- Total Monthly Users
select 	
count(distinct c.customer_unique_id) as monthly_users,
	extract (month from o.order_purchase_timestamp) as trx_month, 
	extract (year from o.order_purchase_timestamp) as trx_year 
from 	orders o
join 	customers c on o.customer_id = c.customer_id
group by 2,3 
order by 3;

-- Monthly Average Users by Year
select 
	yr, 
	round(avg(monthly_users), 0) as average_mau
from (
		select 	
				count(distinct c.customer_unique_id) as monthly_users,
				extract (month from o.order_purchase_timestamp) as mnth, 
				extract (year from o.order_purchase_timestamp) as yr 
		from orders o
		join customers c on o.customer_id = c.customer_id
		group by 2,3 
		order by 3
) monthly_subq

-- New Customers Each Year
select 	
count (distinct customer_unique_id) as total_customers, 
	extract (year from first_order) as yr
from 	(
			select 
				c.customer_unique_id,
				min(o.order_purchase_timestamp) as first_order
			from 	orders o 
			join 	customers c on c.customer_id = o.customer_id
			group by 1
) ord
group by 2;

-- Repeat Customers Each Year
select 
	yr, 
	count(distinct customer_unique_id) as repeat
from (
		select 
			c.customer_unique_id,
			extract (year from order_purchase_timestamp) as yr,
			count(2) as purchase_frequency
		from orders o 
		join customers c on c.customer_id = o.customer_id
		group by 1, 2
		having count(2) > 1
) freq_subq
group by 1;

-- Average Orders per User
select 
	yr, 
	round(avg(purchase_frequency),4) as avg_orders_per_customers
from (
		select 
			c.customer_unique_id,
			extract (year from order_purchase_timestamp) as yr,
			count(2) as purchase_frequency
		from orders o 
		join customers c on c.customer_id = o.customer_id
		group by 1, 2
) freq_subq
group by 1

-- Summary Table
with 
mau_table as (
select 
	yr, 
	round(avg(monthly_users), 0) as average_mau
from (
		select 	
				count(distinct c.customer_unique_id) as monthly_users,
				extract (month from o.order_purchase_timestamp) as mnth, 
				extract (year from o.order_purchase_timestamp) as yr 
		from orders o
		join customers c on o.customer_id = c.customer_id
		group by 2,3 
		order by 3
) monthly_subq
group by 1),
new_cust_table as(
select 	count (distinct customer_unique_id) as total_customers, 
		extract (year from first_order) as yr
from 	(
			select 
				c.customer_unique_id,
				min(o.order_purchase_timestamp) as first_order
			from orders o 
			join customers c on c.customer_id = o.customer_id
			group by 1
) ord
group by 2),
repeat_order_table as(
select 
	yr, 
	count(distinct customer_unique_id) as repeat
from (
		select 
			c.customer_unique_id,
			extract (year from order_purchase_timestamp) as yr,
			count(2) as purchase_frequency
		from orders o 
		join customers c on c.customer_id = o.customer_id
		group by 1, 2
		having count(2) > 1
) freq_subq
group by 1),
avg_order_table as(
select 
	yr, 
	round(avg(purchase_frequency),4) as avg_orders_per_customers
from (
		select 
			c.customer_unique_id,
			extract (year from order_purchase_timestamp) as yr,
			count(2) as purchase_frequency
		from orders o 
		join customers c on c.customer_id = o.customer_id
		group by 1, 2
) freq_subq
group by 1)

select 
	mau_table.yr as year, 
	mau_table.average_mau, 
	new_cust_table.total_customers as new_customers,
	repeat_order_table.repeat as repeat_customers, 
	avg_order_table.avg_orders_per_customers
from mau_table
join new_cust_table on mau_table.yr = new_cust_table.yr
join repeat_order_table on repeat_order_table.yr = mau_table.yr
join avg_order_table on avg_order_table.yr = mau_table.yr