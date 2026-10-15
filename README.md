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

- Shown below is the persistence table:

| Element | Persist? | Reason |
| :--- | :---: | :--- |
| Parcel id, land_use, geometry | **Yes** | This is the core information about the real world that we need to save so the system actually knows where parcels are and what they're used for. |
| Parcel.area() | **No** | It's just a function that calculates a result when called, so there's nothing here to permanently save in a database. |
| Building id, floors, geometry | **Yes** | Basic facts about physical buildings. We need to store these so we can look up building details and locations anytime. |
| Building -> Parcel relationship | **Yes** | We need a way to link buildings to their specific parcels, otherwise the system won't know which building sits on which land parcel. |
| Road id, road_class, geometry | **Yes** | Important road network data. Saving this allows us to run checks like how far a property is from the nearest road. |
| SpatialRule.evaluate() | **No** | This is just code running a check in the background. It does work during runtime, but it isn't data you store in a table. |
| Parcel.area_sqm | **No** | Storing this directly isn't needed and can get outdated if geometry changes. We can just calculate the area from the geometry whenever we need it. |
| MinimumAreaRule._min_area | **No** | Just a rule threshold/config setting |
| Parcel.intersects() | **No** | Swapped out for PostGIS `ST_Intersects` or `ST_Within` |  


Part C: Converting the Object Model to a Relational Model  
- for this part, similar to the UML diagrams for the object modeling on lab5, relational database diagrams were created.
- this is saved in the diagrams folder as 'lab6_relational_model.png'   

Part D: Forward-Engineering the Model to PostGIS  
- For this part, the relational database model is now converted into SQL.
- a dedicated schema was created, following the template indicated in the lab manual.

        CREATE TABLE lab6.buildings (
                building_id TEXT PRIMARY KEY,
                parcel_id TEXT NOT NULL,
                floors INTEGER NOT NULL,
                geom geometry(Polygon, 32651) NOT NULL,
                -- TODO: add the foreign-key constraint
        );

-  the line 'FOREIGN KEY (parcel_id) REFERENCES lab6.parcels(parcel_id)' was replaced in the TODO part of the building tables.
- Following the template of the structuring of the parcel and building object, the roads object was created. 

        CREATE TABLE lab6.roads (
                road_id    TEXT PRIMARY KEY,
                road_class TEXT NOT NULL,
                geom       geometry(LineString, 32651) NOT NULL
        );

- Some key takeaways when writing the sql file:  

| SQL / Concept | Explanation |
| :--- | :--- |
| `CREATE SCHEMA lab6` | Creates a dedicated folder inside the database to keep all your lab tables organized together. |
| `SET search_path` | Tells PostgreSQL to look in `lab6` first for tables, then fall back to `public` (where PostGIS features live). |
| `CREATE TABLE ... ( ... )` | Sets up a new table where each line inside defines a column name followed by its data type. |
| `TEXT`, `INTEGER` | Standard data types: `TEXT` stores plain text strings, while `INTEGER` holds whole numbers. |
| `PRIMARY KEY` | Gives each row a unique identifier so no two rows are identical and values can't be left blank. |
| `NOT NULL` | A constraint ensuring the column can never be empty—it must always contain a value. |
| `geometry(Polygon, 32651)` | A spatial data column restricted to polygon shapes, mapped using the EPSG:32651 coordinate system (in meters). |
| `FOREIGN KEY (parcel_id) REFERENCES lab6.parcels(parcel_id)` | Links each building's `parcel_id` to an existing parcel, enforcing the rule that a building must belong to a valid parcel. |
| No comma after the last line | Syntax rule: the final column or constraint definition in a `CREATE TABLE` block shouldn't have a trailing comma. |

- After running the schema.sql, 3 tables were created under the gis_db → Schemas → lab6 → Tables. These are 'parcels', 'buildings' & 'roads'