-- Create List Customer Payment Table
create table payment_customer as
	select 
		op.order_id,
		o.customer_id,
		payment_sequential,
		payment_type,
		payment_installments,
		payment_value, 
		o.order_purchase_timestamp
	from order_payments op
	join orders o on op.order_id=o.order_id

-- Most Payment Type Used
select 
	payment_type,
	count(1) as total_used
from 
	payment_customer
group by 1
order by 2 DESC

-- Payment Type Information
select 
	extract(year from order_purchase_timestamp) as yr,
	case when payment_type like 'not_defined' then 'Not Defined'
		when payment_type like 'boleto' then 'Boleto'
		when payment_type like 'debit_card' then 'Debit Card'
		when payment_type like 'voucher' then 'Voucher'
		when payment_type like 'credit_card' then 'Credit Card'
		end as type_payment,
	count(customer_id) as total_customers,
	count(customer_id) - count(distinct customer_id) as total_repeat_payment_type,
	avg(payment_value) as average_value,
	max(payment_value) as max_value,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY payment_sequential) as median_payment_sequential,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY payment_installments) as median_payment_installments,
	max(payment_sequential) as max_payment_sequential,
	max(payment_installments) as max_payment_installments
from 
	payment_customer
group by 1,2
order by 1,3 DESC