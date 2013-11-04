module Middleman
  class BlogPageExtension < Extension
    self.supports_multiple_instances = true

    option :name, nil, 'Unique ID for telling multiple blog pages apart'
    option :prefix, nil, 'Prefix to mount the blog page at'
    option :permalink, ":title.html", 'HTTP path to host pages at'
    option :sources, "pages/:title.html", 'How to extract metadata from on-disk files'
    option :layout, "layout", 'Article-specific layout'
    option :default_extension, ".markdown", 'Default article extension'

    attr_accessor :data, :uid

    def initialize(app, options_hash={}, &block)
      super

      @uid = options.name

      require 'middleman-blog_page/blog_page_data'
      require 'middleman-blog_page/blog_page_article'
      require 'active_support/core_ext/time/zones'

      # app.set :time_zone, 'UTC'

      # If "prefix" option is specified, all other paths are relative to it.
      if options.prefix
        options.prefix = "/#{options.prefix}" unless options.prefix.start_with? '/'
        options.permalink = File.join(options.prefix, options.permalink)
        options.sources = File.join(options.prefix, options.sources)
      end
    end

    def after_configuration
      @uid ||= "blog_page#{@app.blog_instances.keys.length}"

      @app.blog_page_instances[@uid.to_sym] = self

      # Make sure ActiveSupport's TimeZone stuff has something to work with,
      # allowing people to set their desired time zone via Time.zone or
      # set :time_zone
      Time.zone = app.config[:time_zone] if app.config[:time_zone]
      time_zone = Time.zone if Time.zone
      zone_default = Time.find_zone!(time_zone || 'UTC')
      unless zone_default
        raise 'Value assigned to time_zone not recognized.'
      end
      Time.zone_default = zone_default

      # Initialize blog with options

      @data = ::Middleman::BlogPage::BlogPageData.new(@app, options, self)

      @app.sitemap.register_resource_list_manipulator(
        :"blog_#{uid}_pages",
        @data,
        false
      )
    end

    # Helpers for use within templates and layouts.
    helpers do
      def blog_page_instances
        @blog_page_instances ||= {}
      end

      def blog_page_controller(key=nil)
        if !key && current_resource
          key = current_resource.metadata[:page]["blog_page"]

          if !key && current_resource.respond_to?(:blog_page_controller) && current_resource.blog_page_controller
            return current_resource.blog_page_controller
          end
        end

        # In multiblog situations, force people to specify the blog
        if !key && blog_page_instances.size > 1
          raise "You must either specify the blog page name in calling this method or in your page frontmatter (using the 'blog' key)"
        end

        key ||= blog_page_instances.keys.first
        blog_page_instances[key.to_sym]
      end

      def blog_page(key=nil)
        blog_page_controller(key).data
      end

      # Determine whether the currently rendering template is a blog article.
      # This can be useful in layouts.
      # @return [Boolean]
      def is_blog_page?
        !current_blog_page.nil?
      end

      # Get a {Resource} with mixed in {BlogArticle} methods representing the current article.
      # @return [Middleman::Sitemap::Resource]
      def current_blog_page
        blog_page_instances.each do |key, blog|
          found = blog.data.page(current_resource.path)
          return found if found
        end

        nil
      end

      # Returns the list of articles to display on this page.
      # @return [Array<Middleman::Sitemap::Resource>]
      def blog_pages(key=nil)
        blog_page(key).pages
      end
    end
  end
end
