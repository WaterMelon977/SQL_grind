SELECT first_name,last_name ,gender from patients where gender='M';

SELECT first_name,last_name from patients WHERE allergies is NULL ;

SELECT first_name from patients WHERE first_name like 'c%' ;

SELECT
  first_name,
  last_name
from patients
WHERE weight >=100 and weight <=120;

SELECT
  first_name,
  last_name
FROM patients
WHERE weight BETWEEN 100 AND 120;

UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL;

SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;

SELECT a.first_name,a.last_name , d.province_name 
FROM patients a join province_names d  
WHERE  a.province_id=d.province_id

SELECT
  first_name,
  last_name,
  province_name
FROM patients
  JOIN province_names ON province_names.province_id = patients.province_id;

select count(*) from patients where YEAR(birth_date)=2010;


SELECT count(first_name) AS total_patients
FROM patients
WHERE
  birth_date between '2010-01-01' AND '2010-12-31'


SELECT count(first_name) AS total_patients
FROM patients
WHERE
  birth_date >= '2010-01-01'
  AND birth_date <= '2010-12-31'


SELECT
  first_name,
  last_name,
  height
FROM patients
WHERE height = (
    SELECT max(height)
    FROM patients
  )


SELECT *
FROM patients
WHERE
  patient_id IN (1, 45, 534, 879, 1000);

SELECT *
FROM admissions
WHERE admission_date = discharge_date;


SELECT
  patient_id,
  COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;

SELECT DISTINCT(city) AS unique_cities
FROM patients
WHERE province_id = 'NS';

SELECT city
FROM patients
GROUP BY city
HAVING province_id = 'NS';

SELECT first_name, last_name, birth_date FROM patients
WHERE height > 160 AND weight > 70;






SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  city = 'Hamilton'
  and allergies is not null




SELECT
  DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year;



SELECT year(birth_date)
FROM patients
GROUP BY year(birth_date)


SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1




SELECT first_name
FROM (
    SELECT
      first_name,
      count(first_name) AS occurrencies
    FROM patients
    GROUP BY first_name
  )
WHERE occurrencies = 1




-- Show patient_id and first_name from patients where their first_name 
-- start and ends with 's' and is at least 6 characters long.

SELECT
  patient_id,
  first_name
FROM patients
WHERE first_name LIKE 's____%s';


SELECT
  patient_id,
  first_name
FROM patients
WHERE
  first_name LIKE 's%s'
  AND len(first_name) >= 6;


SELECT
  patient_id,
  first_name
FROM patients
where
  first_name like 's%'
  and first_name like '%s'
  and len(first_name) >= 6;




-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
-- Primary diagnosis is stored in the admissions table.


SELECT
  patients.patient_id,
  first_name,
  last_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
WHERE diagnosis = 'Dementia';


SELECT
  patient_id,
  first_name,
  last_name
FROM patients
WHERE patient_id IN (
    SELECT patient_id
    FROM admissions
    WHERE diagnosis = 'Dementia'
  );



SELECT
  patient_id,
  first_name,
  last_name
FROM patients p
WHERE 'Dementia' IN (
    SELECT diagnosis
    FROM admissions
    WHERE admissions.patient_id = p.patient_id
  );



-- Display every patient's first_name.
-- Order the list by the length of each name and then by alphabetically.

SELECT first_name
FROM patients
order by
  len(first_name),
  first_name;



-- Show the total amount of male patients and the total amount of female patients in the patients table.
-- Display the two results in the same row.

SELECT 
  (SELECT count(*) FROM patients WHERE gender='M') AS male_count, 
  (SELECT count(*) FROM patients WHERE gender='F') AS female_count;


SELECT 
  SUM(Gender = 'M') as male_count, 
  SUM(Gender = 'F') AS female_count
FROM patients


select 
  sum(case when gender = 'M' then 1 end) as male_count,
  sum(case when gender = 'F' then 1 end) as female_count 
from patients;



-- Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. 
-- Show results ordered ascending by allergies then by first_name then by last_name.

SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  allergies IN ('Penicillin', 'Morphine')
ORDER BY
  allergies,
  first_name,
  last_name;



SELECT
  first_name,
  last_name,
  allergies
FROM
  patients
WHERE
  allergies = 'Penicillin'
  OR allergies = 'Morphine'
ORDER BY
  allergies ASC,
  first_name ASC,
  last_name ASC;




-- Show patient_id, diagnosis from admissions. 
-- Find patients admitted multiple times for the same diagnosis.

SELECT
  patient_id,
  diagnosis
FROM admissions
GROUP BY
  patient_id,
  diagnosis
HAVING COUNT(*) > 1;

-- Show the city and the total number of patients in the city.
-- Order from most to least patients and then by city name ascending.



SELECT
  city,
  COUNT(*) AS num_patients
FROM patients
GROUP BY city
ORDER BY num_patients DESC, city asc;



-- Show first name, last name and role of every person that is either patient or doctor.
-- The roles are either "Patient" or "Doctor"

SELECT first_name, last_name, 'Patient' as role FROM patients
    union all
select first_name, last_name, 'Doctor' from doctors;


-- Show all allergies ordered by popularity. Remove NULL values from query.

SELECT
  allergies,
  COUNT(*) AS total_diagnosis
FROM patients
WHERE
  allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC


SELECT
  allergies,
  count(*)
FROM patients
WHERE allergies NOT NULL
GROUP BY allergies
ORDER BY count(*) DESC


SELECT
  allergies,
  count(allergies) AS total_diagnosis
FROM patients
GROUP BY allergies
HAVING
  allergies IS NOT NULL
ORDER BY total_diagnosis DESC



-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. 
-- Sort the list starting from the earliest birth_date.


SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE
  YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;


SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE
  birth_date >= '1970-01-01'
  AND birth_date < '1980-01-01'
ORDER BY birth_date ASC

SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE year(birth_date) LIKE '197%'
ORDER BY birth_date ASC


-- We want to display each patient's full name in a single column. 
-- Their last_name in all upper letters must appear first, then first_name in all lower case letters.
-- Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
-- EX: SMITH,jane

SELECT
  CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS new_name_format
FROM patients
ORDER BY first_name DESC;


SELECT
  UPPER(last_name) || ',' || LOWER(first_name) AS new_name_format
FROM patients
ORDER BY first_name DESC;



-- Show the province_id(s), sum of height; 
-- where the total sum of its patient's height is greater than or equal to 7,000.


SELECT
  province_id,
  SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING sum_height >= 7000


select * from (select province_id, SUM(height) as sum_height FROM patients group by province_id) where sum_height >= 7000;


-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'


select (Max(weight)-Min(weight)) from patients where last_name ='Maroni'

SELECT
  (MAX(weight) - MIN(weight)) AS weight_delta
FROM patients
WHERE last_name = 'Maroni';



-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. 
-- Sort by the day with most admissions to least admissions.

SELECT
  DAY(admission_date) AS day_number,
  COUNT(*) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC


-- Show all columns for patient_id 542's most recent admission_date.

select *
from admissions
where patient_id = 542
order by admission_date DESC
limit 1


SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING
  admission_date = MAX(admission_date);


SELECT *
FROM admissions
WHERE
  patient_id = '542'
  AND admission_date = (
    SELECT MAX(admission_date)
    FROM admissions
    WHERE patient_id = '542'
  )

SELECT *
FROM admissions
GROUP BY patient_id
HAVING
  patient_id = 542
  AND max(admission_date)


-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

select
  patient_id,
  attending_doctor_id,
  diagnosis
from admissions
where
  patient_id % 2 != 0
  and attending_doctor_id in (1, 5, 19)
  
union all

select
  patient_id,
  attending_doctor_id,
  diagnosis
from admissions
where
  attending_doctor_id like '%2%'
  and len(patient_id) = 3


-- Show first_name, last_name, and the total number of admissions attended for each doctor.
-- Every admission has been attended by a doctor.


select
  first_name,
  last_name,
  COUNT(*)
from doctors
  join admissions ON doctors.doctor_id = admissions.attending_doctor_id
group by doctor_id


SELECT
  first_name,
  last_name,
  count(*)
from
  doctors p,
  admissions a
where
  a.attending_doctor_id = p.doctor_id
group by p.doctor_id;



-- For each doctor, display their id, full name, and the first and last admission date they attended.

select
  doctor_id,
  concat(first_name, ' ', last_name) as full_name,
  MIN(admission_date) as firstadmission,
  MAX(admission_date) as lastadmission
from doctors
  join admissions on doctors.doctor_id = admissions.attending_doctor_id
group by attending_doctor_id




-- Display the total amount of patients for each province. Order by descending.


SELECT
  province_name,
  COUNT(*) as patient_count
FROM patients pa
  join province_names pr on pr.province_id = pa.province_id
group by pr.province_id
order by patient_count desc;




-- For every admission, display the patient's full name, their admission diagnosis,
--  and their doctor's full name who diagnosed their problem.

select
  concat(p.first_name, ' ', p.last_name),
  diagnosis,
  concat(d.first_name, ' ', d.last_name)
from admissions
  join patients p on p.patient_id = admissions.patient_id
  JOIN doctors d ON admissions.attending_doctor_id = d.doctor_id



-- display the first name, last name and number of duplicate patients based on their first name and last name.
-- Ex: A patient with an identical name can be considered a duplicate.

select
  first_name,
  last_name,
  count(*) as dup
from patients
group by
  first_name,
  last_name
  having dup>1


-- Display patient's full name,
-- height in the units feet rounded to 1 decimal,
-- weight in the unit pounds rounded to 0 decimals,
-- birth_date,
-- gender non abbreviated.
-- Convert CM to feet by dividing by 30.48.
-- Convert KG to pounds by multiplying by 2.205.

select
  concat(first_name, ' ', last_name) AS 'patient_name',
  ROUND(height / 30.48, 1) as 'height "Feet"',
  ROUND(weight * 2.205, 0) AS 'weight "Pounds"',
  birth_date,
  CASE
    WHEN gender = 'M' THEN 'MALE'
    ELSE 'FEMALE'
  END AS 'gender_type'
from patients


-- Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. 
-- (Their patient_id does not exist in any admissions.patient_id rows.)
select
  patient_id,
  first_name,
  last_name
from patients
where patient_id noT IN (
    select ad.patient_id
    from admissions ad
  )


SELECT
  patients.patient_id,
  first_name,
  last_name
from patients
  left join admissions on patients.patient_id = admissions.patient_id
where admissions.patient_id is NULL


-- Display a single row with max_visits, min_visits, average_visits where the maximum, minimum and
--  average number of admissions per day is calculated. Average is rounded to 2 decimal places.


select max(visits) as max_visits , MIN(visits) as min_visits ,ROUND(AVG(visits) ,2) FROM
(
select COUNT(*) as visits
from admissions
group by admission_date
)




