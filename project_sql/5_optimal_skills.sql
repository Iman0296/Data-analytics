/*5. what are the most optimal skills to learn?
    1. optimal: high demand and high paying*/
WITH demanded_skills AS(
    SELECT
        count(skills_job_dim.job_id) as skill_demand,
        min(skills_dim.skills) as skills,
        skills_job_dim.skill_id
    FROM
        skills_job_dim
    JOIN
        skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
    JOIN
        job_postings_fact ON skills_job_dim.job_id=job_postings_fact.job_id
    WHERE
        job_title_short='Data Analyst'  AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
    order BY skill_demand DESC),

top_paid_Skills AS(
    SELECT
        ROUND(avg(salary_year_avg), 0) as average_salary,
        skills_job_dim.skill_id
    FROM
        job_postings_fact
    JOIN
        skills_job_dim ON skills_job_dim.job_id=job_postings_fact.job_id
    JOIN
        skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
    WHERE
        job_title_short='Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id)

SELECT 
    d.skill_id,
    d.skills,
    d.skill_demand,
    p.average_salary
FROM
    demanded_skills d
JOIN
    top_paid_Skills p
ON d.skill_id=p.skill_id
ORDER BY d.skill_demand desc, p.average_salary DESC
LIMIT 25
