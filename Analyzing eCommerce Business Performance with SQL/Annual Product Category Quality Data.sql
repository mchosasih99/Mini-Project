-- Create Monetary Value Table
create table monetary_value as
	select a.order_id, a.product_id,
	a.price-freight_value as monetary, extract(year from b.order_purchase_timestamp) as yr
	from order_items a 
	inner join orders b on a.order_id = b.order_id
	where b.order_status in ('invoiced', 'delivered')
	
-- Create Canceled Order Table
create table canceled_order as
select order_id, customer_id, extract(year from order_purchase_timestamp) as yr
from orders
where order_status = 'canceled'

-- Create Name of Product Table
create table name_of_product as
select oi.order_id, oi.product_id, p.product_id_name as product_name
from order_items oi
inner join product p on oi.product_id = p.product_id

-- Yearly Revenue
select 
	count(order_id) as total_customers,
	sum(monetary) gmv,
	yr as year_of_sales
from monetary_value
group by 3
order by 3

-- Canceled Order by Year
select 
	count(order_id) as total_orders,
	extract(year from order_purchase_timestamp) as year_of_sale
from 
	orders
where order_status = 'canceled'
group by 2
order by 2	

-- Order Status by Year
select 
	count(order_id) as total_orders,
	order_status,
	extract(year from order_purchase_timestamp) as year_of_sale
from 
	orders
group by 2,3
order by 2,3

-- Rank of Product Category
select 
	product_id_name,
	total,
	yr,
	rank() over (partition by yr order by total DESC)
from	(
		select 
			c.product_id_name,
			sum(d.monetary) as total,
			d.yr
		from product c
		inner join monetary_value d on c.product_id=d.product_id
		group by 1,3
) mv
group by 1,2,3
order by 4,3

-- Rank of Canceled Product Category
select
	count(co.order_id) as total_canceled_orders,
	nop.product_name,
	co.yr,
	rank() over (partition by yr order by count(co.order_id) DESC)
from name_of_product nop
inner join canceled_order co on nop.order_id = co.order_id
group by 2,3
order by 4,3
