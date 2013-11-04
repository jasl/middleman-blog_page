module Middleman
  module BlogPage
    class Options
      KEYS = [
              :prefix,
              :permalink,
              :sources,
              :layout,
              :default_extension
             ]

      KEYS.each do |name|
        attr_accessor name
      end

      def initialize(options={})
        options.each do |k,v|
          self.send(:"#{k}=", v)
        end
      end
    end

    class << self
      def registered(app, options_hash={}, &block)
        require 'middleman-blog/blog_page_data'
        require 'middleman-blog/blog_page_article'
        require 'active_support/core_ext/time/zones'

        app.send :include, Helpers

        options = Options.new(options_hash)
        yield options if block_given?

        options.permalink            ||= ":title.html"
        options.sources              ||= "pages/:title.html"
        options.layout               ||= "layout"
        options.default_extension    ||= ".markdown"

        # If "prefix" option is specified, all other paths are relative to it.
        if options.prefix
          options.prefix = "/#{options.prefix}" unless options.prefix.start_with? '/'
          options.permalink = File.join(options.prefix, options.permalink)
          options.sources = File.join(options.prefix, options.sources)
        end

        app.after_configuration do
          # Make sure ActiveSupport's TimeZone stuff has something to work with,
          # allowing people to set their desired time zone via Time.zone or
          # set :time_zone
          Time.zone = self.time_zone if self.respond_to?(:time_zone)
          time_zone = Time.zone if Time.zone
          zone_default = Time.find_zone!(time_zone || 'UTC')
          unless zone_default
            raise 'Value assigned to time_zone not recognized.'
          end
          Time.zone_default = zone_default

          # Initialize blog with options
          blog_page(options)

          sitemap.register_resource_list_manipulator(
                                                     :blog_pages,
                                                     blog_page,
                                                     false
                                                     )

        end
      end
      alias :included :registered
    end

    # Helpers for use within templates and layouts.
    module Helpers
      # Get the {BlogPageData} for this site.
      # @return [BlogPageData]
      def blog_page(options=nil)
        @_blog_page ||= BlogPageData.new(self, options)
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
        blog_page.page(current_resource.path)
      end

      # Returns the list of articles to display on this page.
      # @return [Array<Middleman::Sitemap::Resource>]
      def blog_pages
        blog_page.pages
      end
    end
  end
end
