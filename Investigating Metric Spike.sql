use project3;
---------------------------------------------------------------------------------------------------------------
create table users (
user_id int,
created_at varchar(255),
company_id int,
language varchar(255),
activated_at varchar(255),
state varchar(255)
);

# Data imported from the provided csv file using Table Data Import Wizard;

select * from users;

create table users_new
(select	user_id,
str_to_date(created_at, '%d-%m-%Y %H:%i') as created_at,
company_id, language,
str_to_date(activated_at, '%d-%m-%Y %H:%i') as activated_at,
state
from users);

drop table users;

select * from users_new;
---------------------------------------------------------------------------------------------------------------
create table events (
user_id int,
occurred_at varchar(255),
event_type varchar(255),
event_name varchar(255),
location varchar(255),
device varchar(255),
user_type int
);

show variables like 'secure_file_priv';

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv'
into table events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from events;

create table events_new
(select user_id, str_to_date(occurred_at, '%d-%m-%Y %H:%i') as occurred_at,
event_type, event_name, location, device, user_type
from events);

drop table events;

select * from events_new;
---------------------------------------------------------------------------------------------------------------
create table email_events
(user_id int,
occurred_at varchar(255),
action varchar(255),
user_type int);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv'
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

create table email_events_new
(select
user_id, str_to_date(occurred_at, '%d-%m-%Y %H:%i') as occurred_at, action, user_type
from email_events);

drop table email_events;

select * from email_events_new;
---------------------------------------------------------------------------------------------------------------
# A. Weekly User Engagement:

select extract(year from occurred_at) as year, extract(week from occurred_at) as week, count(distinct user_id) as Count
from events_new
where event_type = 'engagement'
group by week, year;

# B. User Growth Analysis:

select concat(extract(month from created_at),'-',extract(year from created_at)) as month_year,
count(user_id) as count_of_users,
count(user_id) - lag(count(user_id),1) over () as growth
from users_new
group by month_year;

# C.Weekly Retention Analysis:

select extract(week from occurred_at) as sign_up_week,count(distinct user_id) as count_of_users
from events_new
where event_type = 'signup_flow'
and event_name = 'complete_signup'
group by sign_up_week;

# D. Weekly Engagement Per Device:

select extract(year from occurred_at) as year, extract(week from occurred_at) as week_number, 
count(case when device = 'acer aspire desktop' then user_id else null end) as 'acer aspire desktop',
count(case when device = 'acer aspire notebook' then user_id else null end) as 'acer aspire notebook',
count(case when device = 'amazon fire phone' then user_id else null end) as 'amazon fire phone',
count(case when device = 'asus chromebook' then user_id else null end) as 'asus chromebook',
count(case when device = 'dell inspiron desktop' then user_id else null end) as 'dell inspiron desktop',
count(case when device = 'dell inspiron notebook' then user_id else null end) as 'dell inspiron notebook',
count(case when device = 'hp pavilion desktopp' then user_id else null end) as 'hp pavilion desktop',
count(case when device = 'htc one' then user_id else null end) as 'htc one',
count(case when device = 'ipad air' then user_id else null end) as 'ipad air',
count(case when device = 'ipad mini' then user_id else null end) as 'ipad mini',
count(case when device = 'iphone 4s' then user_id else null end) as 'iphone 4s',
count(case when device = 'iphone 5' then user_id else null end) as 'iphone 5',
count(case when device = 'iphone 5s' then user_id else null end) as 'iphone 5s',
count(case when device = 'kindle fire' then user_id else null end) as 'kindle fire',
count(case when device = 'lenovo thinkpad' then user_id else null end) as 'lenovo thinkpad',
count(case when device = 'mac mini' then user_id else null end) as 'mac mini',
count(case when device = 'macbook air' then user_id else null end) as 'macbook air',
count(case when device = 'macbook pro' then user_id else null end) as 'macbook pro',
count(case when device = 'nexus 10' then user_id else null end) as 'nexus 10',
count(case when device = 'nexus 5' then user_id else null end) as 'nexus 5',
count(case when device = 'nexus 7' then user_id else null end) as 'nexus 7',
count(case when device = 'nokia lumia 635' then user_id else null end) as 'nokia lumia 635',
count(case when device = 'samsumg galaxy tablet' then user_id else null end) as 'samsumg galaxy tablet',
count(case when device = 'samsung galaxy note' then user_id else null end) as 'samsung galaxy note',
count(case when device = 'samsung galaxy s4' then user_id else null end) as 'samsung galaxy s4',
count(case when device = 'windows surface' then user_id else null end) as 'windows surface'
from events_new
where event_type = 'engagement'
group by year, week_number
order by year, week_number;

# E.Email Engagement Analysis:

select extract(year from occurred_at) as year, extract(week from occurred_at) as week_number,
count(case when action = 'sent_weekly_digest' then user_id else null end) as 'sent_weekly_digest',
count(case when action = 'email_open' then user_id else null end) as 'email_open',
count(case when action = 'email_clickthrough' then user_id else null end) as 'email_clickthrough',
count(case when action = 'sent_reengagement_email' then user_id else null end) as 'sent_reengagement_email'
from email_events_new
group by year, week_number;
---------------------------------------------------------------------------------------------------------------