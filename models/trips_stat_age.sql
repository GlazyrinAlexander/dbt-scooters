with a as
(select EXTRACT(year from (age (started_at, birth_date))) as age, date(started_at) as start, count(date(started_at)) as trips
from scooters_raw.users 
inner join scooters_raw.trips
on user_id = users.id
group by age, date(started_at)) 
select age, avg(trips)
from a
group by age
order by age