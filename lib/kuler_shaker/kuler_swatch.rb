module KulerShaker
  # Holds the data necessary to hold a single colour swatch, of which there are (so far) five 
  # in a scheme. See the Adobe API reference for more info (not that there's a whole lot! Grr!)
  class KulerSwatch
    
    # the colour in this watch represented as a hexidecimal value (RRGGBB expressed as a hex triplet)
    attr_accessor :hex_color
    
    # the colour mode expressed by the channel data (e.g., 'rgb', 'hsl', 'cymk', etc)
    attr_accessor :color_mode
    
    # the first colour channel (e.g., in 'cmyk' colour mode, this is 'c')
    attr_accessor :channel_1
    
    # the second colour channel (e.g., in 'cmyk' colour mode this is 'm')
    attr_accessor :channel_2
    
    # the third colour channel (e.g., in 'cmyk' colour mode this is 'y')
    attr_accessor :channel_3
    
    # the fourth colour channel (e.g., in 'cmyk' colour mode this is 'k')
    attr_accessor :channel_4
    
    # the index indicates the order of this swatch in the scheme
    attr_accessor :swatch_index
  end
end