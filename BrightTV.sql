with user_profiles as (
select UserID,
        Name, surname, email,
case 
  when gender = ' ' OR gender = 'None' 
  then 'other' 
  else gender 
end as gender,
case
  when race = ' ' OR race = 'None'
  then 'other' 
  else race 
end as race,
case 
  when province = ' ' OR province = 'None'
  then 'uncategorized' 
  else province
end as province,
age,
  CASE
        WHEN Age BETWEEN 0 AND 17 THEN 'Kids'
        WHEN Age BETWEEN 18 AND 24 THEN 'Teenagers'
        WHEN Age BETWEEN 25 AND 35 THEN 'Youth'
        WHEN Age BETWEEN 36 AND 55 THEN 'Adults'
        WHEN Age BETWEEN 56 AND 114 THEN 'Pensioners'
        ELSE 'Uncategorized'
    END AS Age_Group
from workspace.`bright-tv`.user_profiles),
viewership AS (
  SELECT UserID0,
    Channel2,
    RecordDate2,
    `Duration 2`,

    DATE_FORMAT(RecordDate2, 'yyyy-dd-MM') AS watch_date,
    MONTHNAME(RecordDate2) AS month_name,
    DAYNAME(RecordDate2) AS day_name,
    DAY(RecordDate2) AS day_of_month,
    HOUR(RecordDate2) AS hour_of_day,
    DATE_FORMAT(RecordDate2, 'HH:mm:ss') AS watch_time,
    DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS duration_time,
    Round(hour(`Duration 2`)*60 + minute(`Duration 2`) + second(`Duration 2`)/60, 2) AS duration_minutes,

    CASE
        WHEN DAYOFWEEK(RecordDate2) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_classification,

    CASE
        WHEN HOUR(RecordDate2) BETWEEN 0 AND 5 THEN 'Late Night'
        WHEN HOUR(RecordDate2) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(RecordDate2) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(RecordDate2) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Prime Time Night'
    END AS viewing_period

FROM workspace.`bright-tv`.viewership
)
SELECT 
    COALESCE(A.UserID0, B.UserID) AS UserID,
    A.Channel2,
    A.RecordDate2,
    A.`Duration 2`,
    A.watch_date,
    A.month_name,
    A.day_name,
    A.day_of_month,
    A.hour_of_day,
    A.watch_time,
    A.duration_time,
    A.day_classification,
    A.viewing_period,
    B.Name,
    B.surname,
    B.email,
    B.gender,
    B.race,
    B.province,
    B.age,
    B.Age_Group
FROM viewership AS A
LEFT JOIN user_profiles AS B
ON A.UserID0 = B.UserID
