Map
{
  background-color: #eee;
}

#water-bodies
{
  polygon-fill: #eee;
}

#land
{
  polygon-fill: #666;
}

#buildings[zoom>=13]
{
  polygon-fill: #333;
}

/*//////// Base line styles */

@highway_casing: #000;
@highway_outline: #000;
@highway: #fc0;
@major_road_casing: #000;
@major_road_outline: #000;
@major_road_low_zoom: #ccc;
@major_road: #fff;
@minor_road_casing: #000;
@minor_road_outline: #000;
@minor_road_low_zoom: #999;
@minor_road_high_zoom: #ccc;
@rail_casing: #444;
@rail_outline: #444;
@rail: #444;
@path: #fff;

.roads {
  line-join: round;
  line-cap: round;
  line-width: 0;

  ::casing {
    line-cap: butt;
    line-width: 0;
  }

  ::outline {
    line-cap: butt;
    line-width: 0;
  }

  [is_tunnel='yes']
  {
    [zoom>=13]
    {
      ::casing {
        line-opacity: 0.2;
      }

      ::outline {
        line-opacity: 0.2;
      }
    }

    [zoom>=15]
    {
      line-opacity: 0.0;
    }
  }

  [is_link='yes']
  {
    [zoom>=16]
    {
      ::casing {
        line-width: 8;
      }

      line-width: 4;
    }
  }
}

#highway
{
  ::casing {
    line-color: @highway_casing;
  }

  ::outline {
    line-color: @highway_outline;
  }

  line-color: @highway;

  [is_link='yes']
  {
    ::casing {
      line-color: @highway_casing;
    }

    ::outline {
      line-color: @highway_outline;
    }

    line-color: @highway;
  }

  [zoom=10]
  {
    ::outline {
      line-width: 3.5;
    }

    line-width: 2;
  }

  [zoom>=11]
  {
    ::outline {
      line-width: 5;
    }

    line-width: 3;
  }

  [zoom>=12]
  {
    [is_link='yes']
    {
      ::outline {
        line-width: 0;
      }

      line-width: 1;
    }
  }

  [zoom>=13]
  {
    ::outline {
      line-width: 8;
    }

    line-width: 4;

    [is_link='yes']
    {
      ::outline {
        line-width: 5;
      }
    }

    [is_link='yes'][is_bridge='yes']
    {
      ::outline {
        line-width: 3;
      }

      line-width: 1;
    }
  }

  [zoom>=14]
  {
    #highway
    {
      ::outline {
        line-width: 8;
      }
    }

    [is_bridge='yes']
    {
      ::casing {
        line-width: 8;
      }
    }

    [is_link='yes']
    {
      ::outline {
        line-width: 6;
      }

      line-width: 2.5;
    }

    [is_link='yes'][is_bridge='yes']
    {
      ::casing {
        line-width: 6;
      }

      line-width: 4;
    }
  }

  [zoom>=15]
  {
    ::casing {
      line-width: 11;
    }

    line-width: 6;

    [is_link='yes']
    {
      ::casing {
        line-width: 6.5;
      }

      line-width: 3;
    }
  }

  [zoom>=16]
  {
    ::casing {
      line-width: 13;
    }

    line-width: 7.5;
  }

  [zoom>=17]
  {
    ::casing {
      line-width: 24;
    }

    line-width: 15;

    [is_link='yes']
    {
      ::casing {
        line-width: 14;
      }

      line-width: 7;
    }
  }

  [zoom>=18]
  {
    ::casing {
      line-width: 39;
    }

    line-width: 28;

    [is_link='yes']
    {
      ::casing {
        line-width: 19;
      }

      line-width: 10;
    }
  }
}

#major_road
{
  ::casing {
    line-color: @major_road_casing;
  }

  ::outline {
    line-color: @major_road_outline;
  }

  line-color: @major_road_low_zoom;

  [is_link='yes']
  {
    ::casing {
      line-color: @major_road_casing;
    }

    ::outline {
      line-color: @major_road_outline;
    }
  }

  [zoom>=10]
  {
    line-width: 2;
  }

  [zoom>=11]
  {
    ::outline {
      line-width: 4;
    }
  }

  [zoom>=12]
  {
    ::outline {
      line-width: 4;
    }
  }

  [zoom>=13]
  {
    line-color: @major_road;
    line-width: 3;

    [is_link='no']
    {
      ::outline {
        line-width: 5;
      }
    }
  }

  [zoom>=14]
  {
    ::outline {
      line-width: 6;
    }

    line-width: 4;

    [is_bridge='yes']
    {
      ::casing {
        line-width: 6;
      }
    }

    [is_link='yes']
    {
      ::outline {
        line-width: 5;
      }

      line-width: 2;
    }

    [is_link='yes'][is_bridge='yes']
    {
      ::casing {
        line-width: 5;
      }

      line-width: 4;
    }
  }

  [zoom>=15]
  {
    ::casing {
      line-width: 8;
    }

    line-width: 5;

    [is_link='yes']
    {
      ::casing {
        line-width: 5.5;
      }

      line-width: 2.5;
    }
  }

  [zoom>=16]
  {
    ::casing {
      line-width: 10;
    }

    line-width: 7;

    [is_link='yes']
    {
      ::casing {
        line-width: 6;
      }

      line-width: 4;
    }
  }

  [zoom>=17]
  {
    ::casing {
      line-width: 20;
    }

    line-width: 14;

    [is_link='yes']
    {
      ::casing {
        line-width: 14;
      }

      line-width: 7;
    }
  }

  [zoom>=18]
  {
    ::casing {
      line-width: 25;
    }

    line-width: 17;

    [is_link='yes']
    {
      ::casing {
        line-width: 19;
      }

      line-width: 10;
    }
  }
}

#minor_road
{
  ::casing {
    line-color: @minor_road_casing;
  }

  ::outline {
    line-color: @minor_road_outline;
  }

  line-color: @minor_road_low_zoom;

  [zoom>=10]
  {
    line-width: 1;
  }

  [zoom>=12]
  {
    line-width: 1.5;
  }

  [zoom>=13]
  {
    line-color: @minor_road_high_zoom;
  }

  [zoom>=14]
  {
    ::outline {
      line-width: 3.5;
    }

    line-width: 2.5;

    /* TODO something about is_bridge... */
    [is_bridge='yes']
    {
      ::casing {
        line-width: 3.5;
      }

      line-width: 2.5;
    }
  }

  [zoom>=15]
  {
    ::casing {
      line-width: 6;
    }

    line-width: 4;
  }

  [zoom>=16]
  {
    ::casing {
      line-width: 6.5;
    }
  }

  [zoom>=17]
  {
    ::casing {
      line-width: 11.5;
    }

    line-width: 8;
  }

  [zoom>=18]
  {
    ::casing {
      line-width: 14.5;
    }

    line-width: 11;
  }
}


#rail
{
  ::casing {
    line-color: @rail_casing;
  }

  ::outline {
    line-color: @rail_outline;
  }

  line-color: @rail;

  [zoom>=14]
  {
    ::casing {
      line-width: 3;
      line-dasharray: 1,3;
    }

    line-width: 1;
  }

  [zoom>=16]
  {
    ::casing {
      line-width: 5;
      line-dasharray: 1,4;
    }
  }

  [zoom>=17]
  {
    ::casing {
      line-width: 5;
    }
  }

  [zoom>=18]
  {
    ::casing {
      line-width: 7;
      line-dasharray: 2,6;
    }

    line-width: 2;
  }
}

.roads[highway='service']
{
  [zoom>=15]
  {
    ::casing {
      line-width: 3.5;
    }

    line-width: 2.5;
  }

  [zoom>=16]
  {
    ::casing {
      line-width: 4;
    }
  }

  [zoom>=17]
  {
    ::casing {
      line-width: 8;
    }

    line-width: 5;
  }
}

#path
{
  line-color: @path;

  [zoom>=15]
  {
    line-width: 1;
    line-dasharray: 2,3;
  }

  [zoom>=17]
  {
    line-width: 2;
    line-dasharray: 4,6;
  }
}
