Config = {}

-- max npc on bus is 15, so dont put 15 on one station..

Config.Stations = {
      [1] = {
        Peds = { -- max passagers 5!
          [1] = {
            coords = {x = 305.33, y = -761.05, z = 29.31, heading = 259.84, model = "a_m_m_afriamer_01"},
          },
          [2] = {
            coords = {x = 303.95, y = -766.65, z = 29.31, heading = 259.84, model = "s_m_y_airworker"},
          },
          [3] = {
            coords = {x = 305.7, y = -765.07, z = 29.16, heading = 259.84, model = "csb_anita"},
          },
          [4] = {
            coords = {x = 303.01, y = -769.14, z = 29.31, heading = 259.84, model = "csb_ballasog"},
          },
          [5] = {
            coords = {x = 302.21, y = -771.05, z = 29.31, heading = 259.84, model = "ig_ashley"},
          }
        },
        Marker = {
            Sprite = 2,
            Size = {x = 0.5, y = 0.5, z = 0.2},
            Color = {r = 1, g = 21, b = 25},
            Rotate = true, 
            Jump = true,
          },
        get_npc = {x = 308.11, y = -767.33, z = 29.3},
        final_station = false,
        drop_npc = {x = 113.8, y = -785.79, z = 31.4},
      },

      [2] = {
        Peds = { -- max passagers 5!
          [1] = {
            coords = {x = 237.34, y = -960.0, z = 29.19, heading = 259.19, model = "a_m_m_afriamer_01"},
          },
          [2] = {
            coords = {x = 236.87, y = -961.82, z = 29.19, heading = 256.15, model = "s_m_y_airworker"},
          }
        },
        Marker = {
            Sprite = 2,
            Size = {x = 0.5, y = 0.5, z = 0.2},
            Color = {r = 1, g = 21, b = 25},
            Rotate = true, 
            Jump = true,
        },
        get_npc = {x = 240.99, y = -961.58, z = 29.3},
        final_station = false,
        drop_npc = {x = 113.8, y = -785.79, z = 31.4}, 
      },
      [3] = {
        Peds = { -- max passagers 5!
          [1] = {
            coords = {x = 187.13, y = -1018.53, z = 29.34, heading = 166.13, model = "a_m_m_afriamer_01"},
          },
          [2] = {
            coords = {x = 189.43, y = -1019.19, z = 29.34, heading = 157.69, model = "s_m_y_airworker"},
          }
        },
        Marker = {
            Sprite = 2,
            Size = {x = 0.5, y = 0.5, z = 0.2},
            Color = {r = 1, g = 21, b = 25},
            Rotate = true, 
            Jump = true,
        },
        get_npc = {x = 188.0, y = -1022.72, z = 29.36},
        final_station = true,
        drop_npc = {x = 113.8, y = -785.79, z = 31.4}, 
      }
}

