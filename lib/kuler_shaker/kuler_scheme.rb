module KulerShaker
  # Contains the data objects necessary to work with a single Kuler scheme. See the Adobe
  # API reference for more info (not that there's a whole lot! Grr!)
  class KulerScheme
    
    # the title of this scheme
    attr_accessor :title
    
    # the url of the image used by this theme (the adobe swatch .png)
    attr_accessor :image
    
    # the ID of the author for this swatch
    attr_accessor :author_id
    
    # the name of the author for this swatch
    attr_accessor :author_name
    
    # an array of tags associated to this scheme
    attr_accessor :tags
    
    # the rating for this scheme
    attr_accessor :rating
    
    # the download count for this scheme
    attr_accessor :download_count
    
    # date this scheme was created
    attr_accessor :created_at
    
    # date this scehme was edited
    attr_accessor :edited_at
    
    # an array of *KulerShaker::KulerSwatch* objects, representing the colours that make up this scheme 
    attr_accessor :swatches
  end
end