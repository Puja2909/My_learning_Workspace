--Question--The business wants to understand which accounts contribute to the bulk of the revenue and the business also wants to see year on year 
--trend on the revenue contribution of each account.The final table should show revenue share of each account for each year's total revenue
with acct_rev_share as (
					with Acct_revenue as (
								with Acct_order_revenue as (
													select 
													o.occured_at as order_time,
													date_part('year',o.occured_at) as "year", 
													o.total_amt_usd as total_revenue,
													a.account_id as acc_id,
													a."name" as acc_name
													from orders o
													join accounts a
													on o.account_id = a.account_id) 

select "year",acc_name, sum(total_revenue) as rev
from Acct_order_revenue
group by "year",acc_name
order by "year")

select 
*,
rev/sum(rev) over (partition by "year") as pct_yearly_rev
from Acct_revenue)

select 
*,
dense_rank() over (partition by "year" order by pct_yearly_rev desc) as rev_rank
from acct_rev_share;