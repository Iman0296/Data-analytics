SELECT
    count(skills_job_dim.skill_id) as skill_demand,
    skills
FROM
    skills_job_dim
JOIN
    skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
JOIN
    job_postings_fact ON skills_job_dim.job_id=job_postings_fact.job_id
WHERE
    job_title_short='Data Analyst'
GROUP BY
    skills
order BY skill_demand DESC
limit 10


