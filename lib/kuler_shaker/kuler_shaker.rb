module KulerShaker
  
  # Provides methods for interacting with the Adobe Kuler RSS feed. 
  class Feed
    public
    
    # Retrieve the comments for a particular theme or user. The comments retreived can be
    # customised using options. Returns an array of KulerShaker::KulerComment objects.
    #
    # ==Options
    # [theme_id] search for comments attached to a specific theme
    # [email] seach for comments by a user identified by their email
    # [start_index] 0 based index specifying the first item to display
    # [items_per_page] the maximum number of items to display in the range 1..100
    # [key] *required:* your Kuler API developer key
    def self.comments *args
      args.flatten! if args
      args.compact! if args
      options = args.extract_options!
      
      query = {}
      query[:themeID] = options[:theme_id] if options[:theme_id]
      query[:email] = options[:email] if options[:email]   
      query[:startIndex] = options[:start_index] if options[:start_index]
      query[:itemsPerPage] = options[:items_per_page] if options[:items_per_page]
      query[:key] = options[:key] || nil
      
      return [] if query[:key] == nil
      
      url = URI.parse(service_address)
      
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.get(comments_feed_address + feed_options(query))
      end
      
      
      comments_from_xml_response res.body
    end
    
    # Perform a search on the Kuler Service. Search can be customised using options. Returns 
    # an array of KulerShaker::KulerScheme objects.
    #
    # ==Options
    # [theme_id] search for a specific theme ID
    # [user_id] search for a specific user ID
    # [email] search for a specific email
    # [tag] search for a specific tag
    # [hex] search for a specific hex colour
    # [title] search for a specific title
    # [all_fields] search in all fields
    # [start_index] 0 based index specifying the first item to display
    # [items_per_page] the maximum number of items to display in the range 1..100
    # [key] *required:* your Kuler API developer key
    def self.search *args
      args.flatten! if args
      args.compact! if args
      options = args.extract_options!
      
      query = {}
      query[:searchQuery] = "themeID:#{options[:theme_id]}" if options[:theme_id]
      query[:searchQuery] = "userID:#{options[:user_id]}" if options[:user_id]
      query[:searchQuery] = "email:#{options[:email]}" if options[:email]
      query[:searchQuery] = "tag:#{options[:tag]}" if options[:tag]
      query[:searchQuery] = "hex:#{options[:hex]}" if options[:hex]
      query[:searchQuery] = "title:#{options[:title]}" if options[:title]
      query[:searchQuery] = options[:all_fields] if options[:all_fields]
      
      query[:startIndex] = options[:start_index] if options[:start_index]
      query[:itemsPerPage] = options[:items_per_page] if options[:items_per_page]
      query[:key] = options[:key] || nil
      
      return [] if query[:key] == nil
      
      url = URI.parse(service_address)
      
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.get(search_feed_address + feed_options(query))
      end
    
      swatches_from_xml_response res.body
    end
    
    # Will retreive a set of schemes from the Kuler service. The schemes retreived can be
    # customised by using options. Returns an array of KulerShaker::KulerScheme objects.
    #
    # ==Options
    # [list_type] one of 'recent', 'popular', 'rating', or 'random' (default is 'recent')
    # [start_index] 0 based index specifying the first item to display
    # [items_per_page] the maximum number of items to display in the range 1..100
    # [time_span] value in days to limit the retreival of sets.
    # [key] *required:* your Kuler API developer key
    def self.get *args
    
      args.flatten! if args
      args.compact! if args
      options = args.extract_options!
    
      query = {}        
      query[:listType] = options[:list_type] if options[:list_type]
      query[:startIndex] = options[:start_index] if options[:start_index]
      query[:itemsPerPage] = options[:items_per_page] if options[:items_per_page]
      query[:timeSpan] = options[:time_span] if options[:timespan]
      query[:key] = options[:key] || nil
    
      return [] if query[:key] == nil
    
      url = URI.parse(service_address)
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.get(get_feed_address + feed_options(query))
      end
    
      swatches_from_xml_response res.body
    end

    private

    # return the comments contained in the response
    def self.comments_from_xml_response xml_data #:nodoc:
      comments = []
      
      doc = REXML::Document.new xml_data
      
      doc.elements.each("*/channel/item/kuler:commentItem") do |comment|
        c = ::KulerShaker::KulerComment.new
        
        c.comment = comment.elements["kuler:comment"].text
        c.author = comment.elements["kuler:author"].text
        c.posted_at = comment.elements["kuler:postedAt"].text
        c.theme_id = comment.elements["kuler:themeItem"].elements["kuler:themeID"].text
        c.theme_title = comment.elements["kuler:themeItem"].elements["kuler:themeTitle"].text
        c.theme_image = comment.elements["kuler:themeItem"].elements["kuler:themeImage"].text
        c.theme_artist = comment.elements["kuler:themeItem"].elements["kuler:themeArtist"].text

        comments << c
      end
      
      return comments
      
    end

    # return the swatches contained in the response
    def self.swatches_from_xml_response xml_data #:nodoc:
      schemes = []
      items = []    
      
      doc = REXML::Document.new xml_data
    
      doc.elements.each("*/channel/item/kuler:themeItem") {|item| items << item}
    
      items.each do |item|
      
        # get main scheme information
        s = ::KulerShaker::KulerScheme.new
        s.title = item.elements["kuler:themeTitle"].text
        s.image = item.elements["kuler:themeImage"].text
        s.author_id = item.elements["kuler:themeAuthor"].elements["kuler:authorID"].text
        s.author_name = item.elements["kuler:themeAuthor"].elements["kuler:authorLabel"].text
        s.tags = item.elements["kuler:themeTags"].text
        s.tags = s.tags == nil ? [] : s.tags.split(/\s*,\s*/)
        s.rating = item.elements["kuler:themeRating"].text
        s.download_count = item.elements["kuler:themeDownloadCount"].text
        s.created_at = item.elements["kuler:themeCreatedAt"].text
        s.edited_at = item.elements["kuler:themeEditedAt"].text
        
        s.swatches = []
      
        # get values for each swatch
        item.elements.each("kuler:themeSwatches/kuler:swatch") do |swatch|
          sw = ::KulerShaker::KulerSwatch.new
          sw.hex_color = swatch.elements["kuler:swatchHexColor"].text
          sw.color_mode = swatch.elements["kuler:swatchColorMode"].text
          sw.channel_1 = swatch.elements["kuler:swatchChannel1"].text.to_f
          sw.channel_2 = swatch.elements["kuler:swatchChannel2"].text.to_f
          sw.channel_3 = swatch.elements["kuler:swatchChannel3"].text.to_f
          sw.channel_4 = swatch.elements["kuler:swatchChannel4"].text.to_f
          sw.swatch_index = swatch.elements["kuler:swatchIndex"].text.to_i
					
          s.swatches << sw
        end
      
        schemes << s
      end
    
      return schemes
    end

    # convert a hash of options into a parameter string
    def self.feed_options options = {} #:nodoc:
      ActionController::Routing::Route.new.build_query_string options
    end
  
    # this is the address for the kuler service
    def self.service_address #:nodoc:
      "http://kuler-api.adobe.com" 
    end
  
    # this is the suffix for the Get RSS Feed
    def self.get_feed_address #:nodoc:
      "/rss/get.cfm"
    end

    # this is the suffix for the Search RSS Feed
    def self.search_feed_address #:nodoc:
      "/rss/search.cfm"
    end
    
    # this is the suffix for the Comments Feed
    def self.comments_feed_address #:nodoc:
      "/rss/comments.cfm"
    end

  end
end