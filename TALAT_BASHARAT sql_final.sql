/*
Question #1: 
*/

-- q1 solution:

select state,
	count(distinct customer_id) 
  from customers
  group by 1;

/*
Question #2: 
*/

-- q2 solution:

with completed_orders as(
  select *
  from orders
  where status = 'Complete'),
  clean_customers as(select *,
  case when state like '%US State%' then 'California'
  else state
  end as clean_state
  from customers)
  select clean_state,
  	count(distinct order_id) as total_completed_orders
    from completed_orders inner join clean_customers
    on clean_customers.customer_id = completed_orders.user_id
    group by 1;

/*
Question #3: 
*/

-- q3 solution:

with orders_clean as (
  select *, 
  case when state = 'US State' then 'California'
  when state is null then 'Missing data'
  else state
  end as clean_state
  from orders
  left join customers
  on orders.user_id = customers.customer_id),
  nike_complete as (
    select order_id from order_items),
  vintage_complete as (
    select order_id from order_items_vintage)
     select clean_state,
     count(distinct orders_clean.order_id) as total_complete_orders,
     count(distinct nike_complete.order_id) as official_completed_orders,
     count(distinct vintage_complete.order_id) as vintage_completed_orders
     from orders_clean left join nike_complete
     on nike_complete.order_id = orders_clean.order_id
     left join vintage_complete
     on vintage_complete.order_id = orders_clean.order_id
     where orders_clean.status = 'Complete'
     group by 1
     order by 1
     

/*
Question #4: 
*/

-- q4 solution:
with temp_table as (select case when state = 'US State' then 'California'
                    when state is Null then 'Missing Data'
                    else state
                    end as cleaned_state, sum(sale_price) as total_revenue, 
              count(returned_at) from order_items
              full join customers
              on customers.customer_id = order_items.user_id
              group by cleaned_state
              union all
              select case when state = 'US State' then 'California'
                    when state is Null then 'Missing Data'
                    else state
                    end as cleaned_state, sum(sale_price) as total_revenue,
              count(returned_at)
              from order_items_vintage
              full join customers
              on customers.customer_id = order_items_vintage.user_id
              group by cleaned_state
              
              ),  

				complete_orders as (
          select case when state = 'US State' then 'California'
                    when state is Null then 'Missing Data'
                    else state
                    end as cleaned_state, count(distinct orders.order_id) as total_completed_orders, 
                    count(distinct order_items.order_id) as official_completed_orders,
                    count(distinct order_items_vintage.order_id) as vintage_completed_orders
             
                    from customers
                   full join orders
                    on orders.user_id = customers.customer_id
                    left join order_items
                    on orders.order_id = order_items.order_id
                    left join order_items_vintage
                    on order_items_vintage.order_id = orders.order_id
                  	where orders.status = 'Complete'
                    group by cleaned_state

				)
        
        select complete_orders.cleaned_state, complete_orders.total_completed_orders, 
        complete_orders.official_completed_orders, complete_orders.vintage_completed_orders, 
        sum(temp_table.total_revenue) as total_revenue from complete_orders
        full join temp_table
        on complete_orders.cleaned_state = temp_table.cleaned_state
        group by 1, 2, 3, 4;


/*
Question #5: 
*/

-- q5 solution:

with temp_table as (select case when state = 'US State' then 'California'
                    when state is Null then 'Missing Data'
                    else state
                    end as cleaned_state, sum(sale_price) as total_revenue, 
              count(returned_at) as return_items from order_items
              full join customers
              on customers.customer_id = order_items.user_id
              group by cleaned_state
              union all
              select case when state = 'US State' then 'California'
                    when state is Null then 'Missing Data'
                    else state
                    end as cleaned_state, sum(sale_price) as total_revenue,
              count(returned_at) as return_items
              from order_items_vintage
              full join customers
              on customers.customer_id = order_items_vintage.user_id
              group by cleaned_state),  

				complete_orders as (
          select case when state = 'US State' then 'California'
                    when state is Null then 'Missing Data'
                    else state
                    end as cleaned_state, count(distinct orders.order_id) as total_completed_orders, 
                    count(distinct order_items.order_id) as official_completed_orders,
                    count(distinct order_items_vintage.order_id) as vintage_completed_orders
             
                    from customers
                   full join orders
                    on orders.user_id = customers.customer_id
                    left join order_items
                    on orders.order_id = order_items.order_id
                    left join order_items_vintage
                    on order_items_vintage.order_id = orders.order_id
                  	where orders.status = 'Complete'
                    group by cleaned_state)
        
        select complete_orders.cleaned_state, complete_orders.total_completed_orders, 
        complete_orders.official_completed_orders, complete_orders.vintage_completed_orders, 
        sum(temp_table.total_revenue) as total_revenue,
        sum(return_items) as returned_items
        
        from complete_orders
        full join temp_table
        on complete_orders.cleaned_state = temp_table.cleaned_state
        group by 1, 2, 3, 4;

/*
Question #6: 
*/

-- q6 solution:
with temp_table as (select case when state = 'US State' then 'California'
                    when state is Null then 'Missing Data'
                    else state
                    end as cleaned_state, sum(sale_price) as total_revenue, 
              count(returned_at) as return_items,
              count(distinct order_item_id) as order_item from order_items
                   
              full join customers
              on customers.customer_id = order_items.user_id
              group by cleaned_state
              union all
              select case when state = 'US State' then 'California'
                    when state is Null then 'Missing Data'
                    else state
                    end as cleaned_state, sum(sale_price) as total_revenue,
              count(returned_at) as return_items,
              count(distinct order_item_id) as order_item
              from order_items_vintage
              full join customers
              on customers.customer_id = order_items_vintage.user_id
              group by cleaned_state),  

				complete_orders as (
          select case when state = 'US State' then 'California'
                    when state is Null then 'Missing Data'
                    else state
                    end as cleaned_state, count(distinct orders.order_id) as total_completed_orders, 
                    count(distinct order_items.order_id) as official_completed_orders,
                    count(distinct order_items_vintage.order_id) as vintage_completed_orders
             
                    from customers
                   full join orders
                    on orders.user_id = customers.customer_id
                    left join order_items
                    on orders.order_id = order_items.order_id
                    left join order_items_vintage
                    on order_items_vintage.order_id = orders.order_id
                  	where orders.status = 'Complete'
                    group by cleaned_state)
        
        select complete_orders.cleaned_state, complete_orders.total_completed_orders, 
        complete_orders.official_completed_orders, complete_orders.vintage_completed_orders, 
        sum(temp_table.total_revenue) as total_revenue,
        sum(return_items) as returned_items,
        sum(return_items)/sum(temp_table.order_item) as return_rate
        
        from complete_orders
        full join temp_table
        on complete_orders.cleaned_state = temp_table.cleaned_state
        group by 1, 2, 3, 4;
