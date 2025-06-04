-- Data job market overview in Canada 

-- Top 5 in-demand data jobs in Canada with salary/wage ranges
SELECT 
    job_title_short, 
    COUNT(job_id),
    ROUND(MAX(salary_year_avg),0) AS max_salary, 
    ROUND(MIN(salary_year_avg),0) AS min_salary, 
    MAX(salary_hour_avg) AS max_wages, 
    MIN(salary_hour_avg) AS min_wages
FROM job_postings_fact
WHERE job_country = 'Canada'
GROUP BY job_title_short
ORDER BY 2 DESC
LIMIT 5;

-- Top in-demand skills for data jobs in Canada
SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS skill_count,
    skills_dim.type
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_country = 'Canada'
GROUP BY skills_dim.type, skills_dim.skills
ORDER BY skill_count DESC
LIMIT 10;

-- Demand for data jobs in Canada by province 
WITH job_location_prov AS(
    SELECT 
        CASE 
        WHEN job_location LIKE '% AB, Canada%' THEN 'Alberta, Canada'
        WHEN job_location LIKE '% BC, Canada%' THEN 'British Columbia, Canada'
        WHEN job_location LIKE '% MB, Canada%' THEN 'Manitoba, Canada'
        WHEN job_location LIKE '% NB, Canada%' THEN 'New Brunswick, Canada'
        WHEN job_location LIKE '% NL, Canada%' THEN 'Newfoundland and Labrador, Canada'
        WHEN job_location LIKE '% NS, Canada%' THEN 'Nova Scotia, Canada'
        WHEN job_location LIKE '% NT, Canada%' THEN 'Northwest Territories, Canada'
        WHEN job_location LIKE '% NU, Canada%' THEN 'Nunavut, Canada'
        WHEN job_location LIKE '% ON, Canada%' THEN 'Ontario, Canada'
        WHEN job_location LIKE '% PE, Canada%' THEN 'Prince Edward Island, Canada'
        WHEN job_location LIKE '% QC, Canada%' THEN 'Quebec, Canada'
        WHEN job_location LIKE '% SK, Canada%' THEN 'Saskatchewan, Canada'
        WHEN job_location LIKE '% YT, Canada%' THEN 'Yukon, Canada'
        WHEN job_location LIKE 'Canada%' OR job_location IS NULL THEN 'N/A'
        ELSE job_location
        END AS province,
        job_id
    FROM job_postings_fact
    WHERE job_country = 'Canada')
SELECT 
    province, 
    COUNT(job_id)
FROM job_location_prov
GROUP BY province
HAVING province LIKE '%Canada%'
ORDER BY COUNT(job_id) DESC;

