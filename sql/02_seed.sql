INSERT INTO lab6.parcels (parcel_id, land_use, geom) VALUES (
    'P-001',
    'Residential',
    ST_GeomFromText('POLYGON((0 0,100 0,100 100,0 100,0 0))', 32651)
);

INSERT INTO lab6.buildings (building_id, parcel_id, floors, geom) VALUES (
    'B-001',
    'P-001',
    2,
    ST_GeomFromText('POLYGON((20 20,40 20,40 40,20 40,20 20))', 32651)
);

INSERT INTO lab6.roads (road_id, road_class, geom) VALUES (
    'R-001',
    'Local',
    ST_GeomFromText('LINESTRING(0 -10,100 -10)', 32651)
);