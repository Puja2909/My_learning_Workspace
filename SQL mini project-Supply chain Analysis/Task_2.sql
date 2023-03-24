--Question 1--Which sales reps are handling which accounts?
with reps_accounts (sales_rep_id,sales_rep_name,sales_rep_region,account_name) as (
select 
sr.sales_rep_id as sales_rep_id,
sr."name" as sales_rep_name,
sr.region_id as sales_rep_region,
a.name as account_name
from sales_rep sr
join accounts a on a.sales_rep_id = sr.sales_rep_id 
)
select *,row_number() over(partition by sales_rep_name) as acc_num
from reps_accounts
order by sales_rep_region;

--Question 2--One of the aspects that the business wants to explore is what has been the share of each sales representative's s year
-- on year sales out of the total yearly sales
with Rep_sales_share as (
					with sales_per_rep as (
										with sales_rep_order_sales as (
																		select 
																		o.total_amt_usd as total_sales,
																		o.occured_at as order_time,
																		date_part('month',o.occured_at) as "month", 
																		date_part('year',o.occured_at) as "year",
																		a."name" as account_name,
																		sr."name" as sales_rep_name
																		from orders o
																		join accounts a on
																		o.account_id = a.account_id  
																		join sales_rep sr on
																		sr.sales_rep_id = a.sales_rep_id 
																		)
select 
*,
sum(total_sales) over (partition by year) as year_total,
sum(total_sales) over (partition by sales_rep_name,"year") as sales_rep_rev,
sum(total_sales) over (partition by sales_rep_name,"year")/sum(total_sales) over (partition by "year") as perc_sales_rep
from sales_rep_order_sales
order by year,sales_rep_name)

select
"year",
"month",
sales_rep_name,
perc_sales_rep,
dense_rank() over (partition by "year" order by perc_sales_rep desc) as rank_sales_rep,
row_number() over (partition by sales_rep_name,"year") as row_num 
from sales_per_rep)

select "year",sales_rep_name,perc_sales_rep,rank_sales_rep
from Rep_sales_share
where row_num=1;

---Question 3--Repeat the analysis given above but this time for region. Generate the percentage contribution of each region to total yearly revenue over years

with Region_sales_share as (
					with sales_per_region as (
										with sales_region_order_sales as (
																		select 
																		o.total_amt_usd as total_sales,
																		o.occured_at as order_time,
																		date_part('month',o.occured_at) as "month", 
																		date_part('year',o.occured_at) as "year",
																		a."name" as account_name,
																		
																		re."name" as region_name
																		from orders o
																		join accounts a on
																		o.account_id = a.account_id  
																		join sales_rep sr on
																		sr.sales_rep_id = a.sales_rep_id
																		join region re on 
																		re.region_id = sr.region_id
																		)
select 
*,
sum(total_sales) over (partition by year) as year_total,
sum(total_sales) over (partition by region_name,"year") as sales_rep_rev,
sum(total_sales) over (partition by region_name,"year")/sum(total_sales) over (partition by "year") as perc_region_sales
from sales_region_order_sales
order by "year",region_name)

select
"year",
"month",
region_name,
perc_region_sales,
dense_rank() over (partition by "year" order by perc_region_sales desc) as rank_region_sales,
row_number() over (partition by region_name,"year") as row_num 
from sales_per_region)

select "year",region_name,perc_region_sales,rank_region_sales
from Region_sales_share
where row_num=1;