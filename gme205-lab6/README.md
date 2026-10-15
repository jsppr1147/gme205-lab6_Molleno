Laboratory 6: Introductory Spatial Database Modeling

----------------------------------------------------
Part A: Project Setup and Database Preflight  
- For this part similar to the previous laboratory exercises, the directories and file structure was setup for this exercise. 
- The difference for this lab is that the PostGIS database creation is also added.
- The SQL PREFLIGHT was done by typing these three query statements in the PostGIS query tool:  

        SELECT current_database();
        SELECT version();
        SELECT postgis_full_version();
- After all three statements return valid results, the database name and PostGIS version is recorded:
   Database: gis_db
   PostGIS version: "3.6.2 3.6.2"
- Then after successfully recording the information, the git was initialized and the first commit is implemented.

