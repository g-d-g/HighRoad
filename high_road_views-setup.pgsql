-- High Road
--
-- This file is a collection of Postgres views that make rendering roads from
-- OpenStreetMap data easier and better-looking. They are broken up by zoom
-- level, corresponding to numbered levels in the traditional web-map spherical
-- mercator projects. Zoom 0 is the entire planet, zoom 10 is where the street
-- details of cities become visible, and zoom 15 is where complex physical road
-- layering such as overpasses and tunnels becomes important.
-- 
-- Taking a cue from Justin O’Bierne’s dearly-departed 41Latitude blog, High
-- Road ensures that each zoom level contains exactly three distinct levels of
-- road: highways, major roads, and minor roads, a simplification of
-- OpenStreetMap’s conventional six-level hierarchy of motorway, trunk, primary,
-- secondary, tertiary, and small local roads.
-- 
-- These three categories are represented by the "kind" attribute, with values
-- of "highway", "major_road", and "minor_road". At the highest zoom levels, a
-- fourth value of "path" appears for footpaths.
-- 
-- 
-- Setup
-- 
-- High Road can be applied to an existing OpenStreetMap rendering database
-- created with osm2pgsql (http://wiki.openstreetmap.org/wiki/Osm2pgsql). Using
-- the command-line psql utility, you can add High Road views like this:
-- 
--     psql -U username -f high_roads_views-setup.pgsql databasename
-- 
-- The views here assume that you've created your database using the default
-- settings of osm2pgsql, including the prefix of "planet_osm". If you've chosen
-- a different prefix, you should find every instance of "planet_osm" in the
-- script below and replace is with your chosen prefix.
-- 
--
-- Removal, upgrading
-- 
-- High Road can be removed from an existing OpenStreetMap rendering database. 
--
-- NOTE: To upgrade your OSM planet, it will need to be removed, then setup again.
--
--- Using the command-line psql utility, you can remove High Road views like this:
-- 
--     psql -U username -f high_road_views-remove.pgsql databasename
-- 
-- The views here assume that you've created your database using the default
-- settings of osm2pgsql, including the prefix of "planet_osm". If you've chosen
-- a different prefix, you should find every instance of "planet_osm" in the
-- script below and replace is with your chosen prefix.
-- 
-- 
-- Inclusion
-- 
-- At zoom levels 10 and 11, local and residential streets are omitted. Bold,
-- simple highways dominate the map, and the visual layering is categorical to
-- clearly separate each road type.
-- 
-- At zoom levels 12 and 13, local roads are added for texture but remain
-- separated from highways and arterial roads. Visual layering is by category,
-- with highways appearing in front of everything else.
-- 
-- At zoom level 14 roads are layered physically using the tunnel,
-- bridge, and layer tags from OpenStreetMap to create correctly-drawn
-- intersections between different types of roads.
--

BEGIN;


-- Cleanup existing views before recreating

DROP VIEW IF EXISTS planet_osm_line_z14;
DROP VIEW IF EXISTS planet_osm_line_z13;
DROP VIEW IF EXISTS planet_osm_line_z12;
DROP VIEW IF EXISTS planet_osm_line_z11;
DROP VIEW IF EXISTS planet_osm_line_z10;
DROP VIEW IF EXISTS planet_osm_line_z8;
DROP VIEW IF EXISTS planet_osm_line_z6;
DROP FUNCTION IF EXISTS high_road(numeric, box3d);


DELETE FROM geometry_columns
WHERE f_table_name
   IN ('planet_osm_line_z14', 'planet_osm_line_z13',
       'planet_osm_line_z12', 'planet_osm_line_z11',
       'planet_osm_line_z10', 'planet_osm_line_z8',
       'planet_osm_line_z6');


-- Done with cleanup, create views

CREATE VIEW planet_osm_line_z6 AS
  SELECT way,
         osm_id,
         highway,
         railway,

         'no'::VARCHAR AS is_link,
         'no'::VARCHAR AS is_tunnel,
         'no'::VARCHAR AS is_bridge,

         (CASE WHEN highway = 'motorway' THEN 'highway'
               WHEN highway = 'trunk' THEN 'major_road'
               ELSE 'minor_road' END) AS kind
  FROM (
      SELECT *
      FROM planet_osm_line
      WHERE highway IN ('motorway', 'trunk')
  ) AS roads;


CREATE VIEW planet_osm_line_z8 AS
  SELECT way,
         osm_id,
         highway,
         railway,

         'no'::VARCHAR AS is_link,
         'no'::VARCHAR AS is_tunnel,
         'no'::VARCHAR AS is_bridge,

         (CASE WHEN highway IN ('motorway') THEN 'highway'
               WHEN highway IN ('trunk', 'primary') THEN 'major_road'
               ELSE 'minor_road' END) AS kind
  FROM (
      SELECT *
      FROM planet_osm_line
      WHERE highway IN ('motorway', 'trunk', 'primary')
  ) AS roads;


CREATE VIEW planet_osm_line_z10 AS
  SELECT way,
         osm_id,
         highway,
         railway,

         (CASE WHEN highway IN ('motorway') THEN 'highway'
               WHEN highway IN ('trunk', 'primary') THEN 'major_road'
               ELSE 'minor_road' END) AS kind,

         'no'::VARCHAR AS is_link,
         (CASE WHEN tunnel IN ('yes', 'true') THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge IN ('yes', 'true') THEN 'yes'
               ELSE 'no' END) AS is_bridge,

         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN highway IN ('trunk', 'primary') THEN 1
               WHEN highway IN ('secondary', 'tertiary') THEN 2
               ELSE 99 END) AS priority
  FROM (

      SELECT *
      FROM planet_osm_line
      WHERE highway IN ('motorway')
         OR highway IN ('trunk', 'primary')
         OR highway IN ('secondary')

  ) AS roads

ORDER BY priority DESC;



CREATE VIEW planet_osm_line_z11 AS
  SELECT way,
         osm_id,
         highway,
         railway,

         (CASE WHEN highway IN ('motorway') THEN 'highway'
               WHEN highway IN ('trunk', 'primary') THEN 'major_road'
               ELSE 'minor_road' END) AS kind,

         'no'::VARCHAR AS is_link,
         (CASE WHEN tunnel IN ('yes', 'true') THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge IN ('yes', 'true') THEN 'yes'
               ELSE 'no' END) AS is_bridge,

         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN highway IN ('trunk', 'primary') THEN 1
               WHEN highway IN ('secondary', 'tertiary') THEN 2
               ELSE 99 END) AS priority
  FROM (

      SELECT *
      FROM planet_osm_line
      WHERE highway IN ('motorway')
         OR highway IN ('trunk', 'primary')
         OR highway IN ('secondary', 'tertiary')

  ) AS roads

ORDER BY priority DESC;



CREATE VIEW planet_osm_line_z12 AS
  SELECT way,
         osm_id,
         highway,
         railway,

         (CASE WHEN highway IN ('motorway', 'motorway_link') THEN 'highway'
               WHEN highway IN ('trunk', 'trunk_link', 'secondary', 'primary') THEN 'major_road'
               WHEN railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail') THEN 'rail'
               ELSE 'minor_road' END) AS kind,

         (CASE WHEN highway LIKE '%_link' THEN 'yes'
               ELSE 'no' END) AS is_link,
         (CASE WHEN tunnel IN ('yes', 'true') THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge IN ('yes', 'true') THEN 'yes'
               ELSE 'no' END) AS is_bridge,

         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail') THEN .5
               WHEN highway IN ('trunk', 'secondary', 'primary') THEN 1
--               WHEN highway IN ('tertiary', 'residential', 'unclassified', 'road') THEN 2
               WHEN highway IN ('tertiary') THEN 2
               WHEN highway LIKE '%_link' THEN 3
               ELSE 99 END) AS priority
  FROM (
    
      SELECT *
      FROM planet_osm_line
      WHERE highway IN ('motorway', 'motorway_link')
         OR highway IN ('trunk', 'trunk_link')
         OR highway IN ('primary', 'secondary', 'tertiary')
--         OR highway IN ('tertiary', 'residential', 'unclassified', 'road', 'unclassified')

         OR railway IN ('rail', 'light_rail', 'narrow_gauge')

  ) AS roads

ORDER BY priority DESC;



CREATE VIEW planet_osm_line_z13 AS
  SELECT way,
         osm_id,
         highway,
         railway,

         (CASE WHEN highway IN ('motorway', 'motorway_link') THEN 'highway'
               WHEN highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') THEN 'major_road'
               WHEN railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail') THEN 'rail'
               ELSE 'minor_road' END) AS kind,

         (CASE WHEN highway LIKE '%_link' THEN 'yes'
               ELSE 'no' END) AS is_link,
         (CASE WHEN tunnel IN ('yes', 'true') THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge IN ('yes', 'true') THEN 'yes'
               ELSE 'no' END) AS is_bridge,

         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN highway IN ('motorway_link') THEN 1
               WHEN railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail') THEN 1.5
               WHEN highway IN ('trunk', 'primary', 'secondary', 'tertiary') THEN 2
               WHEN highway IN ('trunk_link', 'primary_link', 'secondary_link') THEN 3
               WHEN highway IN ('residential', 'unclassified', 'road') THEN 4
               ELSE 99 END) AS priority
  FROM (
    
      SELECT *
      FROM planet_osm_line
      WHERE highway IN ('motorway', 'motorway_link')
         OR highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary')
         OR highway IN ('residential', 'unclassified', 'road', 'unclassified')

         OR railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail')
    
  ) AS roads

ORDER BY priority DESC;



CREATE VIEW planet_osm_line_z14 AS
  SELECT way,
         osm_id,
         highway,
         railway,

         (CASE WHEN highway IN ('motorway', 'motorway_link') THEN 'highway'
               WHEN highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') THEN 'major_road'
--               WHEN highway IN ('footpath', 'track', 'footway', 'steps', 'pedestrian', 'path', 'cycleway') THEN 'path'
               WHEN railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail') THEN 'rail'
               ELSE 'minor_road' END) AS kind,

         (CASE WHEN highway LIKE '%_link' THEN 'yes'
               ELSE 'no' END) AS is_link,
         (CASE WHEN tunnel IN ('yes', 'true') THEN 'yes'
               ELSE 'no' END) AS is_tunnel,
         (CASE WHEN bridge IN ('yes', 'true') THEN 'yes'
               ELSE 'no' END) AS is_bridge,

         -- explicit layer is the physical layering of under- and overpasses
         (CASE WHEN layer ~ E'^-?[[:digit:]]+(\.[[:digit:]]+)?$' THEN CAST (layer AS FLOAT)
               ELSE 0
               END) AS explicit_layer,

         -- implied layer is guessed based on bridges and tunnels
         (CASE WHEN tunnel in ('yes', 'true') THEN -1
               WHEN bridge in ('yes', 'true') THEN 1
               ELSE 0
               END) AS implied_layer,

         (CASE WHEN highway IN ('motorway') THEN 0
               WHEN railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail') THEN .5
               WHEN highway IN ('trunk') THEN 1
               WHEN highway IN ('primary') THEN 2
               WHEN highway IN ('secondary') THEN 3
               WHEN highway IN ('tertiary') THEN 4
               WHEN highway LIKE '%_link' THEN 5
               WHEN highway IN ('residential', 'unclassified', 'road') THEN 6
               WHEN highway IN ('unclassified', 'service', 'minor') THEN 7
               ELSE 99 END) AS priority
  FROM (
    
      SELECT way, osm_id, highway, railway, tunnel, bridge, layer
      FROM planet_osm_line
      WHERE highway IN ('motorway', 'motorway_link')
         OR highway IN ('trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link')
         OR highway IN ('residential', 'unclassified', 'road', 'unclassified', 'service', 'minor')
--         OR highway IN ('footpath', 'track', 'footway', 'steps', 'pedestrian', 'path', 'cycleway')
         OR railway IN ('rail', 'tram', 'light_rail', 'narrow_gauge', 'monorail')

  ) AS roads

-- Large roads are drawn on top of smaller roads.
-- Implicit physical layers (tunnels, bridges) are drawn in order.
-- Explicit physical layers are drawn in order.
--
ORDER BY explicit_layer ASC, implied_layer ASC, priority DESC;



-- Create a function that takes mapniks !scale_denominator! and !bbox! tokens and chooses the correct view

CREATE FUNCTION high_road(scaleDenominator numeric, bbox box3d)
  RETURNS TABLE(way geometry, osm_id bigint, highway text, railway text, kind text, is_link text, is_tunnel text, is_bridge text) AS
$$
BEGIN
  CASE
    -- z5 - 7
    WHEN scaleDenominator <= 20000000 AND scaleDenominator > 5000000 THEN
      RETURN QUERY SELECT tbl.way, tbl.osm_id, tbl.highway::text, tbl.railway::text,
       tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text
      FROM planet_osm_line_z6 as tbl
      WHERE tbl.way && bbox;

    -- z8 - 9
    WHEN scaleDenominator <= 5000000 AND scaleDenominator > 750000 THEN
      RETURN QUERY SELECT tbl.way, tbl.osm_id, tbl.highway::text, tbl.railway::text,
       tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text
      FROM planet_osm_line_z8 as tbl
      WHERE tbl.way && bbox;

    -- z10
    WHEN scaleDenominator <= 750000 AND scaleDenominator > 400000 THEN
      RETURN QUERY SELECT tbl.way, tbl.osm_id, tbl.highway::text, tbl.railway::text,
       tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text
      FROM planet_osm_line_z10 as tbl
      WHERE tbl.way && bbox;

    -- z11
    WHEN scaleDenominator <= 400000 AND scaleDenominator > 200000 THEN
      RETURN QUERY SELECT tbl.way, tbl.osm_id, tbl.highway::text, tbl.railway::text,
       tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text
      FROM planet_osm_line_z11 as tbl
      WHERE tbl.way && bbox;

    -- z12
    WHEN scaleDenominator <= 200000 AND scaleDenominator > 100000 THEN
      RETURN QUERY SELECT tbl.way, tbl.osm_id, tbl.highway::text, tbl.railway::text,
       tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text
      FROM planet_osm_line_z12 as tbl
      WHERE tbl.way && bbox;

    -- z13
    WHEN scaleDenominator <= 100000 AND scaleDenominator > 50000 THEN
      RETURN QUERY SELECT tbl.way, tbl.osm_id, tbl.highway::text, tbl.railway::text,
       tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text
      FROM planet_osm_line_z13 as tbl
      WHERE tbl.way && bbox;

    -- z14
    WHEN scaleDenominator <= 50000 THEN
      RETURN QUERY SELECT tbl.way, tbl.osm_id, tbl.highway::text, tbl.railway::text,
       tbl.kind::text, tbl.is_link::text, tbl.is_tunnel::text, tbl.is_bridge::text
      FROM planet_osm_line_z14 as tbl
      WHERE tbl.way && bbox;

    ELSE
      NULL;
   END CASE;
END
$$
LANGUAGE 'plpgsql';



-- Some housekeeping

INSERT INTO geometry_columns
(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, "type")
VALUES
    ('', 'public', 'planet_osm_line_z6',  'way', 2, 900913, 'LINESTRING'),
    ('', 'public', 'planet_osm_line_z8',  'way', 2, 900913, 'LINESTRING'),
    ('', 'public', 'planet_osm_line_z10', 'way', 2, 900913, 'LINESTRING'),
    ('', 'public', 'planet_osm_line_z11', 'way', 2, 900913, 'LINESTRING'),
    ('', 'public', 'planet_osm_line_z12', 'way', 2, 900913, 'LINESTRING'),
    ('', 'public', 'planet_osm_line_z13', 'way', 2, 900913, 'LINESTRING'),
    ('', 'public', 'planet_osm_line_z14', 'way', 2, 900913, 'LINESTRING');



COMMIT;
