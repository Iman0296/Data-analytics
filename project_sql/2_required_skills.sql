with skills_name as(
    select job_id,skills_dim.skill_id,skills_dim.skills
    from skills_job_dim
    join skills_dim
    on skills_job_dim.skill_id=skills_dim.skill_id
)
SELECT 
    j.job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    c.name,
    skills_name.skills

FROM
    job_postings_fact j
LEFT JOIN company_dim c
    ON j.company_id=c.company_id
JOIN skills_name
    ON j.job_id=skills_name.job_id
WHERE
    job_title_short='Data Analyst'AND
    job_location='Anywhere'AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC



