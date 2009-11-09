module KulerShaker
  # holds the data necessary to work with comments as they are provided by the Kuler RSS feed.
  # See the Adobe API reference for more info (not that there's a whole lot! Grr!)
  class KulerComment
    
    # the comment text - a string with HTML key codes to indicate formatting
    attr_accessor :comment
    
    # the author of this comment
    attr_accessor :author
    
    # when the comment was posted
    attr_accessor :posted_at
    
    # the id for the theme to which this comment is associated
    attr_accessor :theme_id
    
    # the title for the theme to which this comment is associated
    attr_accessor :theme_title
    
    # the url of the adobe swatch image (the swatch .png) for the theme to which this comment is associated
    attr_accessor :theme_image
    
    # the name of the author for the theme to which this comment is associated
    attr_accessor :theme_artist
  end
end