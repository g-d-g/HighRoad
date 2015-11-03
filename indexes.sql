CREATE INDEX idx_highroad_z6 ON planet_osm_line USING gist(way) WHERE highway IS NOT NULL AND highway IN 
  ('motorway', 'trunk');
CREATE INDEX idx_highroad_z8 ON planet_osm_line USING gist(way) WHERE highway IS NOT NULL AND highway IN 
  ('motorway', 'trunk', 'primary');
CREATE INDEX idx_highroad_z10 ON planet_osm_line USING gist(way) WHERE highway IS NOT NULL AND highway IN 
  ('motorway', 'trunk', 'primary', 'secondary');
CREATE INDEX idx_highroad_z11 ON planet_osm_line USING gist(way) WHERE highway IS NOT NULL AND highway IN 
  ('motorway', 'trunk', 'primary', 'secondary', 'tertiary');
CREATE INDEX idx_highroad_z12 ON planet_osm_line USING gist(way) WHERE highway IS NOT NULL AND highway IN 
  ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'secondary', 'tertiary');
CREATE INDEX idx_highroad_z13 ON planet_osm_line USING gist(way) WHERE highway IS NOT NULL AND highway IN 
  ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 
    'tertiary', 'residential', 'unclassified', 'road', 'track');
CREATE INDEX idx_highroad_z14 ON planet_osm_line USING gist(way) WHERE highway IS NOT NULL AND highway IN 
  ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link',
   'tertiary', 'tertiary_link', 'residential', 'unclassified', 'road', 'unclassified', 'service', 'minor', 'track');