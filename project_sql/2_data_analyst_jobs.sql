-- Top 5 high-paying DATA ANALYST positions in Canada
 SELECT 
    job_title AS job_position,
    ROUND(salary_year_avg, 0) AS annual_salary,
    name AS company
FROM job_postings_fact
LEFT JOIN company_dim USING (company_id)
WHERE job_title_short = 'Data Analyst' AND job_country = 'Canada' AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 5;

-- Top 10 in-demand skills for DATA ANALYST
SELECT 
    skills, 
    COUNT(sd.skill_id) AS skill_count,
    type
FROM job_postings_fact jpf
JOIN skills_job_dim sjd ON jpf.job_id=sjd.job_id
JOIN skills_dim sd ON sjd.skill_id=sd.skill_id
WHERE 
    job_country = 'Canada' 
    AND job_title_short = 'Data Analyst'
GROUP BY 3,1
ORDER BY 2 DESC
LIMIT 10;

-- Optimal skill set by demand (high paying & most in-demand skills)
WITH skills_demand AS (
    SELECT sd.skill_id, sd.skills, COUNT(sjd.job_id) AS skill_count
    FROM job_postings_fact jpf
    JOIN skills_job_dim sjd ON jpf.job_id=sjd.job_id
    JOIN skills_dim sd ON sjd.skill_id=sd.skill_id
    WHERE job_country = 'Canada' AND job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id),
    average_salary AS(
    SELECT sd.skill_id, ROUND(AVG(jpf.salary_year_avg),0) AS avg_salary
    FROM job_postings_fact jpf
    JOIN skills_job_dim sjd ON jpf.job_id=sjd.job_id
    JOIN skills_dim sd ON sjd.skill_id=sd.skill_id
    WHERE job_country = 'Canada' AND job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id)
SELECT skills_demand.skills, skill_count, avg_salary
FROM skills_demand
JOIN average_salary ON skills_demand.skill_id=average_salary.skill_id
WHERE skill_count >= 5
ORDER BY skill_count DESC
LIMIT 10;
-- Optimal skill set by salary (high paying & most in-demand skills)
WITH skills_demand AS (
    SELECT sd.skill_id, sd.skills, COUNT(sjd.job_id) AS skill_count
    FROM job_postings_fact jpf
    JOIN skills_job_dim sjd ON jpf.job_id=sjd.job_id
    JOIN skills_dim sd ON sjd.skill_id=sd.skill_id
    WHERE job_country = 'Canada' AND job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id),
    average_salary AS(
    SELECT sd.skill_id, ROUND(AVG(jpf.salary_year_avg),0) AS avg_salary
    FROM job_postings_fact jpf
    JOIN skills_job_dim sjd ON jpf.job_id=sjd.job_id
    JOIN skills_dim sd ON sjd.skill_id=sd.skill_id
    WHERE job_country = 'Canada' AND job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id)
SELECT skills_demand.skills, skill_count, avg_salary
FROM skills_demand
JOIN average_salary ON skills_demand.skill_id=average_salary.skill_id
WHERE skill_count >= 5
ORDER BY avg_salary DESC
LIMIT 10;

/* --DA jobs count by province
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
        WHEN job_location LIKE 'Canada%' OR job_location IS NULL THEN 'Location not specified'
        ELSE job_location
    END AS province,
    COUNT(job_title_short) AS job_postings
FROM job_postings_fact
WHERE 
    job_country = 'Canada' 
    AND job_title_short = 'Data Analyst'
GROUP BY province
ORDER BY 2 DESC;*/

-- Remote vs on-site jobs
SELECT 
    job_title_short,
    CASE
    WHEN job_work_from_home IS TRUE THEN 'Remote'
    WHEN job_work_from_home IS FALSE THEN 'On-site'
    END AS job_type,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst' AND job_country = 'Canada'
GROUP BY 1, 2;

