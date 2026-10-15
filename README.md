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

Part B: From Objects to Persistent State  
- For this part, the idea is that an object from Python lives only while the program runs. 
- The database keeps what must still exist after the program ends so before the any 'CREATE TABLE', I ask each element if "when the program stop, should this fact still exist when it starts running again?"   
- Some rule of thumb: (a) Data and relationships that describe the world are persisted. (b) Methods and calculations stay as code or are derived by queries.  

- Shown below is the persistence table 

State (candidates to persist)  

| Item | Persist? | Note |
| :--- | :---: | :--- |
| `Parcel.parcel_id`, `zone`, `geometry` | **Yes** | Turns into `parcel_id`, `land_use`, and `geom` in the DB |
| `Parcel.area_sqm` | **No** | No need, `ST_Area` can calculate this on the fly |
| `HazardZone.zone_id`, `hazard_type`, `severity`, `geometry` | **Yes, in a real system** | Would save this normally, but skipped here since our lab only needs 3 tables |
| `Road.road_id`, `geometry` | **Yes** | Saved here, though Lab 6 adds `road_class` which Lab 5 didn't have |

Configuration (not facts about the world)  

| Item | Persist? | Note |
| :--- | :---: | :--- |
| `MinimumAreaRule._min_area` | **No** | Just a rule threshold/config setting |
| `AllowedZoneRule._allowed_zones` | **No** | Same idea, hardcoded/app config |
| `RoadAccessRule._max_distance` | **No** | Same thing, rule parameter |
| `AssessmentRule._name` | **No** | Just an in-memory class label |

Relationships  

| Item | Persist? | Note |
| :--- | :---: | :--- |
| `NoHazardOverlapRule` &rarr; `HazardZone` | **No** | Just code referencing an object |
| `RoadAccessRule` &rarr; `Road` | **No** | Same as above, plus spatial queries can find this anyway |
| `ParcelAssessment` &rarr; `Parcel` and rules | **No** | Handled at runtime |

Behavior and outputs (not persisted)  

| Item | Persist? | Note |
| :--- | :---: | :--- |
| `Parcel.intersects()` | **No** | Swapped out for PostGIS `ST_Intersects` or `ST_Within` |
| `evaluate()` on each rule | **No** | App logic |
| `ParcelAssessment.passed()` | **No** | Calculated every time you run it |
| `RuleResult` (`rule_name`, `passed`, `message`) | **No** | Execution output. Only worth saving if you want an audit trail later |
| The JSON report | **No** | Already written to a file anyway |