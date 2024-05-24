create database project3;
---------------------------------------------------------------------------------------------------------------
use project3;
---------------------------------------------------------------------------------------------------------------
create table job_data (
ds varchar(255),
job_id int not null,
actor_id int not null,
event varchar(255),
language varchar(255),
time_spent int not null,
org varchar(255)
);

# Data imported from the provided csv file using Table Data Import Wizard;

select * from job_data;

create table job_data_new(
select str_to_date(ds,'%m/%d/%Y') ds, job_id, actor_id, event, language, org, time_spent from job_data);

drop table job_data;

select * from job_data_new
order by ds;

---------------------------------------------------------------------------------------------------------------
# A. Jobs Reviewed Over Time:

SELECT ds, (count(job_id)*3600/sum(time_spent)) as num_of_job_reviewed_per_day_per_hour
from job_data_new
group by ds
order by ds;

# B.Throughput Analysis:

select ds, 
round(sum(count(job_id)) over (order by ds rows between 6 preceding and current row)/sum(sum(time_spent)) over (order by ds rows between 6 preceding and current row),2) as throughput_7d,
round(sum(count(job_id)) over (order by ds) / sum(sum(time_spent)) over (order by ds),2) as throughtput_daily
from job_data_new
group by ds
order by ds;

# C.Language Share Analysis:

select language, count(language) as count, count(language)/(select count(*) from job_data_new)*100 as Percent_language_share
from job_data_new
group by language;

# D. Duplicate Rows Detection:

select * from job_data_new
group by  ds, job_id, actor_id, event, language, time_spent, org
having count(*)>1;
