 Query 1: Persistent state

| parcel_id | land_use    | area_sqm         |
| [PK] text | text        | double precision |
|-----------|-------------|------------------|
| P-001     | Residential | 10000            |

Interpretation: P-001 survives as a row, and its area is computed from the stored geometry with ST_Area, not stored as a copy.


