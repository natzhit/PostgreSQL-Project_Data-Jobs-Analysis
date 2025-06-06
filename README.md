# Introduction
This project focuses on analyzing data analyst jobs in Canada in 2023 and defining an optimal set of the top-paying and sought-after skills for a data analyst. The idea for the project arose from a need to identify the skills required for a data analyst in Canada that are in high demand and associated with higher salaries, thereby uncovering optimal employment opportunities and simplifying the process for jobseekers. 

# Tools and Data
For this project, the following tools were used:
- SQL: querying the database
- Python (pandas, numpy, matplotlib, seaborn): data visualization
- PostgreSQL: database management system for organizing and managing data
- Visual Studio Code: database management and executing SQL queries
- Git & GitHub: sharing the SQL code and analysis

Data comes from the SQL course by Luke Barousse: [link to the course](https://www.youtube.com/watch?v=7mz73uXD9DA).

# Analysis
## 1. Overview of the Canadian data jobs market
This section provides an overview of the Canadian data jobs market, covering the most popular roles, salary trends, required technical skills, and regional job distribution while also emphasizing the continued importance of data analyst positions. It also explores the key skills employers seek in data professionals and maps out the geographic distribution of job opportunities across Canadian provinces.
### 1.1 Top in-demand data jobs in Canada
The following SQL query retrieves a summary of data job postings in Canada from the job_postings_fact table and focuses on identifying the top 5 most frequently posted data job titles in Canada, along with their highest and lowest average yearly salaries and their highest and lowest hourly wages.
It groups the data by job_title_short and filters for rows where job_country is *Canada*. For each job title, it calculates the number of job postings, the maximum and minimum average yearly salaries, and the maximum and minimum average hourly wages. The results are ordered by the number of postings in descending order and limited to the top 5 entries. Key functions used include COUNT() for counting rows, MAX() and MIN() for salary extremes, ROUND() for formatting, GROUP BY for aggregation, ORDER BY for sorting, and LIMIT for restricting output.
```sql
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
```
The following Python code visualizes the results of the SQL query as a horizontal bar chart using *matplotlib* and *seaborn*: 
```py
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sb
top_jobs = pd.read_csv('top_data_jobs_ca.csv')
fig = plt.figure(figsize=(5, 3), facecolor='silver')
axes = fig.add_axes([0, 0, 1, 1])
sb.barplot(y=top_jobs['job_title'], x=top_jobs['job_postings'], errorbar=None, orient='h', color='#1E90FF')
for i, (value, title) in enumerate(zip(top_jobs['job_postings'], top_jobs['job_title'])):
    axes.text(
        value - max(top_jobs['job_postings']) * 0.01,  
        i,
        f'{value}',
        va='center',
        ha='right',
        color='white',
        fontsize=9,
        weight='semibold')
plt.xticks(fontsize=7,c='dimgrey')
plt.yticks(fontsize=9)
axes.set_title('Most In-Demand Data Jobs in Canada (2023)', fontsize=11, weight='semibold')
axes.set_ylabel('')
axes.set_xlabel('Number of Job Postings', fontsize=9)
plt.show()
```
![Most In-Demand Data Jobs](viz\top_jobs_bar.png)
### Key highlights:
- Data engineering roles are the most in-demand data jobs in Canada, significantly outpacing other positions like data analysts and data scientists. 
- Engineering-focused roles not only lead in job volume but also offer some of the highest salary and wage potential, reflecting strong market demand and a wide range of experience levels. 
### 1.2 Salary and wage ranges for the most in-demand data jobs in Canada
The following two Python scripts visualize the salary and hourly wage ranges for the most in-demand data jobs in Canada based on the results of the SQL query shown in question 1.1. The first script displays annual salary ranges; the second script similarly plots hourly wage ranges. Both charts feature job titles on the y-axis, inverted so the highest-demand jobs appear at the top.
```py
import pandas as pd
import matplotlib.pyplot as plt
top_jobs = pd.read_csv('top_data_jobs_ca.csv')
top_jobs = top_jobs.sort_values(by='job_postings', ascending=True)
fig, ax = plt.subplots(figsize=(7, 4), facecolor='silver')
for i, row in top_jobs.iterrows():
    min_sal = row['min_salary']
    max_sal = row['max_salary']
    ax.plot([min_sal, max_sal], [i, i], color='dodgerblue', linewidth=4)
    ax.scatter(min_sal, i, color='white', edgecolor='dodgerblue', zorder=3)
    ax.scatter(max_sal, i, color='dodgerblue', edgecolor='black', zorder=3)
    ax.text(min_sal - 6000, i, f"{int(min_sal):,}", va='center', ha='right', fontsize=8, color='black')
    ax.text(max_sal + 6000, i, f"{int(max_sal):,}", va='center', ha='left', fontsize=8, color='black')
ax.set_yticks(range(len(top_jobs)))
ax.set_yticklabels(top_jobs['job_title'], fontsize=9)
ax.set_xlabel('Salary (CAD)', fontsize=9)
ax.set_title('Salary Ranges for Most In-Demand Data Jobs', fontsize=11, weight='semibold')
ax.set_xlim(0, 500000)
plt.xticks(fontsize=7,c='dimgrey')
plt.grid(axis='x', linestyle='--', alpha=0.5)
plt.tight_layout()
plt.show()
```
![Salary Ranges for Data Jobs](viz\salary_ranges.png)
```py
top_jobs = pd.read_csv('top_data_jobs_ca.csv')
top_jobs = top_jobs.sort_values(by='job_postings', ascending=True)
fig, ax = plt.subplots(figsize=(7, 4), facecolor='silver')
for i, row in top_jobs.iterrows():
    ax.plot([row['min_hourly'], row['max_hourly']], [i, i], color='darkorange', linewidth=4)
    ax.scatter(row['min_hourly'], i, color='white', edgecolor='darkorange', zorder=3)
    ax.scatter(row['max_hourly'], i, color='darkorange', edgecolor='black', zorder=3)
    ax.text(row['min_hourly'] - 2, i, f"{row['min_hourly']:.1f}", va='center', ha='right', fontsize=8)
    ax.text(row['max_hourly'] + 2, i, f"{row['max_hourly']:.1f}", va='center', ha='left', fontsize=8)
ax.set_yticks(range(len(top_jobs)))
ax.set_yticklabels(top_jobs['job_title'], fontsize=9)
ax.set_xlabel('Hourly Rate (CAD)', fontsize=10)
ax.set_title('Wage Ranges for Most In-Demand Data Jobs', fontsize=11, weight='semibold')
ax.set_xlim(0, 110)
plt.xticks(fontsize=8, c='dimgray')
plt.grid(axis='x', linestyle='--', alpha=0.5)
plt.tight_layout()
plt.show()
```
![Wage Ranges for Most In-Demand Data Jobs](viz\wage_ranges.png)
### Key highlights:
- Data engineering roles generally offer the highest salary and wage ranges among the top data jobs in Canada, reflecting strong compensation for this category. 
- Data analyst and data scientist positions show moderate salary and wage ranges, indicating steady but comparatively lower pay. 
- Senior data engineers and software engineers also command solid compensation, with salaries and hourly wages positioned between the highest and moderate ranges.
### 1.3 Top 10 technical skills for data jobs in Canada
The following SQL query retrieves the top 10 most frequently required skills in Canadian job postings by joining three tables: *job_postings_fact*, *skills_job_dim*, and *skills_dim*. It counts how many job postings mention each skill, grouping the results by both the skill name and its type. The query filters for job postings specifically from Canada, orders the skills by their frequency in descending order, and limits the output to the n most common skills, providing insight into the most sought-after skill sets and their categories in the Canadian job market.
```sql
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
```
The Python code creates a bar chart to visualize the most in-demand skills along with their frequency where each bar represents a skill, color-coded based on its type (e.g., programming, cloud, libraries, or analyst tools):
```py
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
top_skills = pd.read_csv('top_skills_for_data_jobs.csv')
type_colors = {
    'programming': 'dodgerblue',
    'cloud': 'darkorange',
    'libraries': 'cadetblue',
    'analyst_tools': 'indianred'}
top_skills['color'] = top_skills['type'].map(type_colors)
plt.figure(figsize=(8,5), facecolor='silver')
bars = plt.bar(top_skills['skills'], top_skills['skill_count'], color=top_skills['color'])
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2, height + 100, f'{int(height)}', ha='center', va='bottom', fontsize=8)
plt.title('Top Technical Skills Needed for Data Jobs', fontsize=11, weight='semibold')
plt.ylabel('Skill Count', fontsize=10)
plt.xticks(rotation=45, ha='right', fontsize=10)
plt.yticks(fontsize=8, c='dimgray')
plt.grid(axis='y', linestyle='--', alpha=0.5)
plt.ylim(0, 10000)
from matplotlib.patches import Patch
legend_elements = [Patch(facecolor=clr, label=typ.replace('_', ' ').title()) for typ, clr in type_colors.items()]
plt.legend(handles=legend_elements, title='Skill Type', fontsize=8, title_fontsize=9, loc='upper right')
plt.tight_layout()
plt.show()
```
![Top Skills for Data Jobs](viz\top_skills_col.png)
### Key highlights:
- SQL and Python emerge as the most in-demand technical skills for data jobs, highlighting the central role of programming and data manipulation in the field. 
- Cloud technologies like AWS and Azure are also highly sought after, reflecting the growing reliance on cloud platforms for data storage and processing. 
- Tools such as Spark and Databricks represent the demand for big data and distributed computing expertise.
- Tableau, Excel, and Power BI show that analyst tools remain essential for data visualization and reporting.
### 1.4 Data job demand by province 
The SQL code below defines a Common Table Expression (CTE) named job_location_prov to standardize Canadian job location data. It handles special cases such as null or generic "Canada..." entries by assigning them as "N/A". Then, in the main query, it counts the number of job postings per province, filters to include only those that contain *Canada* in the province name, groups and orders the results by the count in descending order.
```sql
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
```
The visualization that was created using Python displays job postings across Canadian provinces on an interactive choropleth map. The code retrieves geographic boundaries from a GeoJSON source. Provinces are shaded according to the number of job postings, with darker shades indicating higher counts. 
```py
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import requests
jobs_prov = pd.read_csv('job_count_by_province.csv')
jobs_prov['province'] = jobs_prov['province'].str.replace(', Canada', '', regex=False)
jobs_prov['count'] = jobs_prov['count'].astype(int)
geojson_url = 'https://raw.githubusercontent.com/codeforgermany/click_that_hood/main/public/data/canada.geojson'
canada_geo = requests.get(geojson_url).json()
fig = px.choropleth(
    jobs_prov,
    geojson=canada_geo,
    locations='province',
    featureidkey='properties.name',
    color='count',
    color_continuous_scale='Blues',
    scope='north america',
    labels={'count': 'Job Postings'},
    title='Job Postings by Province in Canada',
    width=1200,
    height=800)
province_centers = {
    'Ontario': [-85, 50],
    'Alberta': [-114, 54],
    'British Columbia': [-123, 52],
    'Quebec': [-71, 52],
    'Nova Scotia': [-61.5, 43],
    'Saskatchewan': [-106, 54],
    'Manitoba': [-97, 54],
    'New Brunswick': [-66.5, 45.7],
    'Northwest Territories': [-120, 65],
    'Newfoundland and Labrador': [-62.1, 53],
    'Prince Edward Island': [-63, 47]}
province_abbr = {
    'Ontario': 'ON',
    'Alberta': 'AB',
    'British Columbia': 'BC',
    'Quebec': 'QC',
    'Nova Scotia': 'NS',
    'Saskatchewan': 'SK',
    'Manitoba': 'MB',
    'New Brunswick': 'NB',
    'Northwest Territories': 'NT',
    'Newfoundland and Labrador': 'NL',
    'Prince Edward Island': 'PE'}
for province, (lon, lat) in province_centers.items():
    value = jobs_prov.loc[jobs_prov['province'] == province, 'count'].values
    if len(value) > 0:
        fig.add_trace(go.Scattergeo(
            lon=[lon],
            lat=[lat],
            text=[str(value[0])],
            mode='text',
            showlegend=False,
            textfont=dict(color='darkorange', size=12)))
        fig.add_trace(go.Scattergeo(
            lon=[lon + 0.3],
            lat=[lat + 1],
            text=[province_abbr[province]],
            mode='text',
            showlegend=False,
            textfont=dict(color='darkorange', size=12, family='Arial Black')))
fig.update_geos(fitbounds="locations", visible=False)
fig.update_layout(
    title={
        'text': 'Job Postings by Province in Canada',
        'x': 0.5,
        'xanchor': 'center',
        'yanchor': 'top'},
    title_font=dict(family='Arial Black', size=20, color='black'),
    geo=dict(bgcolor='rgba(0,0,0,0)'),
    plot_bgcolor='lightgrey',
    paper_bgcolor='lightgrey')
fig.show()
```
![Data Jobs by Province](viz\map_ca.png)
### Key highlights:
- Ontario dominates the Canadian job market with a substantially higher number of job postings compared to other provinces.
- Alberta, British Columbia, and Quebec also show notable activity but at significantly lower levels. 
- The remaining provinces, including Nova Scotia, Saskatchewan, and Manitoba, contribute moderately.
- New Brunswick, the Northwest Territories, Newfoundland and Labrador, and Prince Edward Island reflect minimal job availability, indicating a strong regional concentration of opportunities in central and western Canada.
- Notably, the dataset does not include Nunavut and Yukon, indicating either a lack of available postings or missing data from these northern territories.
## 2. Job market analysis for DATA ANALYSTS
This section presents an analysis of the Canadian job market for **data analysts**, focusing on salary ranges and key skill requirements. Additionally, it examines the balance between remote and on-site job opportunities.
### 2.1 Highest-paying data analyst positions in Canada
This SQL query retrieves the top 5 highest-paying data analyst job postings in Canada with available average annual salary data. It selects the job title (renamed as *job_position*), rounds the average yearly salary, and includes the company name by joining the job_postings_fact table with the company_dim table. The results are ordered in descending order based on salary.
```sql 
 SELECT 
    job_title AS job_position,
    ROUND(salary_year_avg, 0) AS annual_salary,
    name AS company
FROM job_postings_fact
LEFT JOIN company_dim USING (company_id)
WHERE job_title_short = 'Data Analyst' AND job_country = 'Canada' AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 5;
```
A horizontal bar chart displaying the top 5 data analyst job positions in Canada for 2023 was created using Python libraries *pandas*, *matplotlib*, and *seaborn* based on the data from the SQL query above. 
```py
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sb
top_jobs = pd.read_csv('top_da_positions.csv')
fig = plt.figure(figsize=(5, 3), facecolor='silver')
axes = fig.add_axes([0, 0, 1, 1])
sb.barplot(y=top_jobs['job_position'], x=top_jobs['annual_salary'], errorbar=None, orient='h', color='cadetblue')
for i, (value, title) in enumerate(zip(top_jobs['annual_salary'], top_jobs['job_position'])):
    axes.text(
        value - max(top_jobs['annual_salary']) * 0.01,  
        i,
        f'{value}',
        va='center',
        ha='right',
        color='white',
        fontsize=9,
        weight='semibold')
plt.xticks(fontsize=7,c='dimgrey')
plt.yticks(fontsize=9)
axes.set_title('Highest-Paid Data Analyst Roles in Canada (2023)', fontsize=11, weight='semibold')
axes.set_ylabel('')
axes.set_xlabel('Salary (CAD)', fontsize=9)
plt.show()
```
![Highest-Paid Data Analyst Roles](viz\top_da_jobs_bar.png)
### Key highlights:
- Top-paying data analyst roles fall within the $109,000–$120,000 range, indicating a relatively narrow band for data analyst positions.
- The highest-paid role is a Principal Data Analyst, while the lowest is a Data Analyst specializing in VBA and Tableau.
### 2.2 Top 10 in-demand skills for data analysts
The SQL query retrieves the top 10 most frequently mentioned skills for data analyst job postings in Canada. It joins three tables to link job postings to their associated skills, counts how often each skill appears, groups the results by skill and skill type and sorts them in descending order of frequency.
```sql
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
```
The visualization that provides a summary of the most in-demand technical skills in data analyst job postings was created using the Python code below. It shows a column chart to visualize the frequency of each skill. Each skill is categorized by type, and a corresponding color is assigned using a predefined color mapping. 
```py
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
top_skills = pd.read_csv('top_skills_for_da_jobs.csv')
type_colors = {
    'analyst_tools': 'cadetblue',
    'programming': 'dodgerblue',
    'cloud': 'darkorange'}
top_skills['color'] = top_skills['type'].map(type_colors)
plt.figure(figsize=(8,5), facecolor='silver')
bars = plt.bar(top_skills['skills'], top_skills['skill_count'], color=top_skills['color'])
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2, height + 10, f'{int(height)}', ha='center', va='bottom', fontsize=8)
plt.title('Top 10 Technical Skills for Data Analyst Roles', fontsize=11, weight='semibold')
plt.ylabel('Skill Count', fontsize=10)
plt.xticks(rotation=45, ha='right', fontsize=10)
plt.yticks(fontsize=8, c='dimgray')
plt.grid(axis='y', linestyle='--', alpha=0.5)
from matplotlib.patches import Patch
legend_elements = [Patch(facecolor=clr, label=typ.replace('_', ' ').title()) for typ, clr in type_colors.items()]
plt.legend(handles=legend_elements, title='Skill Type', fontsize=8, title_fontsize=9, loc='upper right')
plt.tight_layout()
plt.show()
```
![Top Skills for Data Analysts](viz\top_da_skills_col.png)
### Key highlights:
- Among technical skills frequently mentioned in data analyst job postings, SQL is leading by a wide margin (1,247 mentions), followed by Excel and Python. 
- Programming skills like SQL, Python, and R are in high demand, while analyst tools such as Excel, Tableau, and Power BI also feature prominently. 
- Cloud-related skills are less common, with Azure appearing in 198 listings. 
### 2.3 Remote vs on-site jobs
The following query analyzes data analyst job postings in Canada, grouping them by job type. It uses a CASE statement to label jobs as *Remote* or *On-site* and counts the number of job postings in each category.
```sql
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
```
This Python code reads job type data from a CSV file, converts the job counts to integers, and creates a pie chart visualizing the distribution of data analyst job postings by job type (e.g., *Remote* vs. *On-site*) and providing a visual summary of the proportion of each job type.
```py
import pandas as pd
import matplotlib.pyplot as plt
job_types = pd.read_csv('job_type.csv')
job_types['job_count'] = job_types['job_count'].astype(int)
colors = ['dodgerblue', 'darkorange']
plt.figure(figsize=(5, 5), facecolor='silver')
plt.pie(
    job_types['job_count'],
    labels=None,
    autopct='%1.1f%%',
    startangle=140,
    colors=colors,
    textprops={'color': 'white', 'fontsize': 12})
plt.legend(job_types['job_type'], title="Job Type", loc="center left", bbox_to_anchor=(1, 0.5))
plt.title("Data Analyst Jobs by Job Type", fontsize=12, weight='semibold')
plt.axis('equal')
plt.show()
```
![Job Type](viz\da_job_type_pie.png)
### Key highlights:
Most data analyst job postings (1,875) are for on-site positions, while a smaller portion (507) offer remote work options, which means that roughly 78% of the roles require on-site presence, with about 22% available remotely.

# Conclusion
The data shows that the Canadian data job market is experiencing strong demand, particularly for technically skilled roles such as data engineers, who lead in both job volume and salary potential. Data analysts and data scientists continue to play vital roles, offering steady compensation and serving as essential contributors to data-driven decision-making across industries. 

Although data analysts consistently rank among the top data roles, they generally have a lower hiring volume and moderate salary ranges compared to data engineers. SQL, Python, Excel, Tableau, Excel, Power BI are the most frequently requested skills, while cloud-related skills appear less commonly in job postings, reflecting the market’s emphasis on programming, data manipulation, and visualization tools. Additionally, the majority of data analyst positions require on-site work, with only a small share offering remote opportunities. 

Overall, the findings highlight the growing importance of data expertise in Canada, with regional concentration in provinces like Ontario and Alberta. While data engineering drives the market, data analysts maintain a crucial role supported by strong employer demand and a clear focus on core technical competencies.