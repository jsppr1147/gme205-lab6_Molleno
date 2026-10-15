CREATE SCHEMA IF NOT EXISTS lab6;
SET search_path TO lab6, public;

CREATE TABLE lab6.parcels (
    parcel_id TEXT PRIMARY KEY,
    land_use  TEXT NOT NULL,
    geom      geometry(Polygon, 32651) NOT NULL
);

CREATE TABLE lab6.buildings (
    building_id TEXT PRIMARY KEY,
    parcel_id   TEXT NOT NULL,
    floors      INTEGER NOT NULL,
    geom        geometry(Polygon, 32651) NOT NULL,
    FOREIGN KEY (parcel_id) REFERENCES lab6.parcels(parcel_id)
);

CREATE TABLE lab6.roads (
    road_id    TEXT PRIMARY KEY,
    road_class TEXT NOT NULL,
    geom       geometry(LineString, 32651) NOT NULL
);