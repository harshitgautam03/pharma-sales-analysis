Create database pharma_project;
Use pharma_project;

create table pharma_dailysales (
    Date date,
    M01AB float,
    M01AE float,
    N02BA float,
    N02BE float,
    N05B float,
    N05C float,
    R03 float,
    R06 float,
    Year int,
    Month int,
    Day_Type varchar(20)
);
Load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pharmasalesdaily.csv'
into table pharma_dailysales
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(@Date, M01AB, M01AE, N02BA, N02BE, N05B, N05C, R03, R06, @Year, @Month, Day_Type)
set 
Date = str_to_date(@Date, '%m/%d/%Y'),
Year = nullif(@Year, ''),
Month = nullif(@Month, '');
select * from pharma_dailysales limit 10;
select count(*) from pharma_dailysales;


-- Total Sales
select 
round(sum(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06), 2) as Total_Sales
from pharma_dailysales;

-- Monthly Sales Trend
select 
Month,
round(sum(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06),2) AS Monthly_Sales
from pharma_dailysales
group by Month
order by Month;

-- Top Product Catagory
select 'M01AB' as Product, sum(M01AB) as Sales from pharma_dailysales
union all
select 'M01AE', sum(M01AE) from pharma_dailysales
union all
select 'N02BA', sum(N02BA) from pharma_dailysales
union all
select 'N02BE', sum(N02BE) from pharma_dailysales
union all
select 'N05B', sum(N05B) from pharma_dailysales
union all
select 'N05C', sum(N05C) from pharma_dailysales
union all
select 'R03', sum(R03) from pharma_dailysales
union all
select 'R06', sum(R06) from pharma_dailysales
order by Sales desc;

-- Weekday Vs Weekend Sales
select 
Day_Type,
round(sum(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06),2) AS Sales
from pharma_dailysales
group by Day_Type;

-- Average Daily Sales
select 
round(avg(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06),2) AS Avg_Daily_Sales
from pharma_dailysales;

-- Growth Analysis
select
Month,
round(sum(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06),2) AS Sales,
lag(round(sum(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06),2)) 
over (order by Month) as Prev_Month_Sales
from pharma_dailysales
group by Month;