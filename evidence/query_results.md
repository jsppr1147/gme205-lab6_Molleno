 Query 1: Persistent state

| parcel_id | land_use    | area_sqm         |
| [PK] text | text        | double precision |
|-----------|-------------|------------------|
| P-001     | Residential | 10000            |

Interpretation: P-001 survives as a row, and its area is computed from the stored geometry with ST_Area, not stored as a copy.


 Query 2: Building -> Parcel (JOIN)

| building_id | floors | parcel_id | land_use    |
| text        |integer |   text    |    text     |
|-------------|--------|-----------|-------------|
| B-001       | 2      | P-001     | Residential |

Interpretation: The JOIN matches `parcel_id` across both tables so we can easily link building B-001 back to its land parcel and see its land use.

Query 3: ST_Within

| building_id | parcel_id | is_inside |
|     text    |     text  |   boolean |
|-------------|-----------|-----------|
| B-001       | P-001     | true      |

Interpretation: `ST_Within` compares their shapes and verifies that building B-001 actually sits entirely inside parcel P-001.

Query 4: ST_DWithin

| parcel_id | road_id | within_15m |
|    text   |   text  |   boolean  |
|-----------|---------|------------|
| P-001     | R-001   | true       |

Interpretation: `ST_DWithin` checks the distance between them and confirms parcel P-001 is within 15 meters of road R-001.