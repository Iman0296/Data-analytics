SELECT
    ROUND(avg(salary_year_avg), 0) as average_salary,
    skills
FROM
    job_postings_fact
JOIN
    skills_job_dim ON skills_job_dim.job_id=job_postings_fact.job_id
JOIN
    skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
WHERE
    job_title_short='Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY
    skills
order BY average_salary DESC
limit 10
/* Here's a quick breakdown for the top paying skills:

Infrastructure knowledge pays off: Tools like SVN, Terraform, and VMware 
show demand for analysts who understand deployment and system management.

AI and automation stand out: DataRobot and MXNet highlight the advantage 
of applying machine learning in analytics.

Programming boosts salaries: Skills like Golang and Solidity are linked
 to higher-paying, tech-focused roles.

Data handling remains key: dplyr proves strong data manipulation skills
 are still essential.

Overall: The best-paid analysts blend data expertise with engineering, 
automation, and cloud skills

[
  {
    "average_salary": "400000",
    "skills": "svn"
  },
  {
    "average_salary": "179000",
    "skills": "solidity"
  },
  {
    "average_salary": "160515",
    "skills": "couchbase"
  },
  {
    "average_salary": "155486",
    "skills": "datarobot"
  },
  {
    "average_salary": "155000",
    "skills": "golang"
  },
  {
    "average_salary": "149000",
    "skills": "mxnet"
  },
  {
    "average_salary": "147633",
    "skills": "dplyr"
  },
  {
    "average_salary": "147500",
    "skills": "vmware"
  },
  {
    "average_salary": "146734",
    "skills": "terraform"
  },
  {
    "average_salary": "138500",
    "skills": "twilio"
  }
]
*/