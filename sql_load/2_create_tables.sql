

-- practice questions
/* 1. Write a query to find the average salary for job postings (both yearly and hourly) 
that were posted after June 1, 2023. Group the results by job schedule type.*/

SELECT
     AVG(salary_year_avg),
     AVG(salary_hour_avg),
    job_schedule_type 
FROM 
    job_postings_fact
WHERE job_posted_date>='2023-06-01'
GROUP BY job_schedule_type
;

SELECT job_posted_date FROM job_postings_fact LIMIT 10;
/*
**Practice Problem 2**

Write a query to count the number of job postings for each month in 2023, 
adjusting the job_posted_date to the America/New_York time zone before extracting the month(hint). 
assume the job_posted_date is stored in UTC. 

Group by and order by the month. 

*/

SELECT 
     COUNT(job_id),
     EXTRACT(MONTH FROM job_posted_date)AS month
 FROM
      job_postings_fact
GROUP BY month
ORDER BY month
;

SELECT
     job_posted_date AT TIME ZONE  'UTC' AT TIME ZONE 'EST'
FROM
     job_postings_fact;

/*
Write a query to find companies (include company name) that have posted jobs 
offering health insurance where these postings were made in the second quarter
 of 2023. Use date extraction to filter by quarter
*/

SELECT
     C.company_id,
      C.name
FROM job_postings_fact AS J
JOIN company_dim AS C
ON  J.company_id=C.company_id
WHERE job_health_insurance=TRUE 
     AND  EXTRACT(MONTH FROM J.job_posted_date) BETWEEN 5 AND 8
;


SELECT
     C.company_id,
      C.name
FROM job_postings_fact AS J
JOIN company_dim AS C
ON  J.company_id=C.company_id
WHERE job_health_insurance=TRUE 
     AND EXTRACT(QUARTER FROM J.job_posted_date)=2
		 AND EXTRACT(YEAR FROM J.job_posted_date) ='2023';


CREATE TABLE january_jobs AS
SELECT 
     * 
FROM 
     job_postings_fact 
WHERE EXTRACT(MONTH FROM job_posted_date)=1
LIMIT


SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name = 'january_jobs'
LIMIT 10;

CREATE TABLE january_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- Create a table for February jobs
CREATE TABLE february_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- Create a table for March jobs
CREATE TABLE march_jobs AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT 
     job_location,
     job_title_short,
     CASE 
          WHEN job_location='Anywhere' THEN 'Remote'
          WHEN job_location='New York, NY' THEN 'local'
          ELSE 'onsite'
 
     END AS job_category
FROM
     job_postings_fact
/*
Practice Problem 1
❓ Question:
I want to categorize the salaries from each job posting to see if it fits in my desired salary range.

- Put salary into different buckets
- Define what's a high, standard, or low salary with our own conditions
- Why? It is easy to determine which job postings are worth looking at based on salary.
- Bucketing is a common practice in data analysis when viewing categories.

• Only want to look at data analyst roles
• Order from highest to lowest
*/

SELECT DISTINCT
     job_title_short,
      salary_year_avg,
     CASE
          WHEN salary_year_avg>95000 THEN 'HIGH SALARY'
          WHEN salary_year_avg<93000 THEN 'LOW SALARY'
          ELSE 'STANDARD SALARY'

     END AS salry_bucket
FROM 
     job_postings_fact 
WHERE  
     job_title_short='Data Analyst' and  salary_year_avg IS NOT NULL
ORDER BY 
     salary_year_avg DESC

SELECT AVG(salary_year_avg)
FROM job_postings_fact
where job_title_short='Data Analyst'

SELECT * 
FROM (
	SELECT* 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date)=1
	) as january_jobs
/*
PRACTICE-

FIND THE COMPANIES WITH THE MOST JOB OPENINGS

- GET THE TOTAL NUMBER OF JOB POSTINGS PER COMPANY ID
- RETURN THE TOTAL NUMBER OF JOBS WITH THE COMPANY NAME
*/
with company_names as ( 
SELECT count(job_id)AS job_count,
       company_id
from job_postings_fact
GROUP BY company_id
)
select company_dim.name, company_names.job_count
from company_dim
left join company_names
on company_names.company_id=company_dim.company_id
ORDER BY job_count DESC

/*
PRACTICE PROBLEM

FIND THE COUNT OF THE NUMBER OF REMOTE JOB POSTINGS PER SKILL

- DISPLAY THE TOP 5 SKILLS BY THEIR DEMAND IN REMOTE JOBS
- INCLUDE SKILL ID, NAME, AND COUNT OF POSTINGS REQUIRING THE SKILL*/


SELECT 
     COUNT(j.job_id) as jobs,
     skills_dim.skills as skills
FROM 
     job_postings_fact j
join skills_job_dim s
     on j.job_id=s.job_id
JOIN skills_dim
      ON s.skill_id = skills_dim.skill_id
where job_work_from_home is TRUE
GROUP BY skills_dim.skills
order by COUNT(j.job_id) DESC
limit 5



with job_skills as(
SELECT 
     COUNT(j.job_id) as jobs,
     s.skill_id

FROM 
     job_postings_fact j
join skills_job_dim s
on j.job_id=s.job_id
where job_work_from_home is TRUE
AND job_title_short='Data Analyst'
group by s.skill_id
)
select d.skill_id,
     d.skills,
     job_skills.jobs
from job_skills
join skills_dim d
on job_skills.skill_id=d.skill_id
order by   job_skills.jobs DESC
limit 5

/*FIND JOB POSTINGS FROM THE FIRST QUARTER THAT HAVE A SALARY GREATER THAN $70K 

-COMBINE JOB POSTING TABLE FROM THE FIRST QUARTER OF 2023(JAN-MAR)

-GET JOB POSTINGS WITH AN AVERAGE YEARLY SALARY>70K*/

with first_quarter_jobs as(
     SELECT *
     FROM january_jobs
     UNION 
     SELECT *
     FROM february_jobs
     UNION
     SELECT *
     FROM march_jobs
)

select * 
from first_quarter_jobs
where EXTRACT(YEAR FROM job_posted_date)=2023 AND    
      salary_year_avg>70000  
order by EXTRACT(MONTH FROM job_posted_date),salary_year_avg desc

