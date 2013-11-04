require 'active_support/time_with_zone'
require 'active_support/core_ext/time/calculations'

module Middleman
  module BlogPage
    # A module that adds blog_page-article methods to Resources.
    module BlogPageArticle
      def self.extended(base)
        base.class.send(:attr_accessor, :blog_page_controller)
      end

      def blog_page_data
        if self.blog_page_controller
          self.blog_page_controller.data
        else
          app.blog_page
        end
      end

      def blog_options
        if self.blog_page_controller
          self.blog_page_controller.options
        else
          app.blog_page.options
        end
      end

      # Render this resource
      # @return [String]
      def render(opts={}, locs={}, &block)
        if opts[:layout].nil?
          if metadata[:options] && !metadata[:options][:layout].nil?
            opts[:layout] = metadata[:options][:layout]
          end
          opts[:layout] = blog_options.layout if opts[:layout].nil?
          opts[:layout] = opts[:layout].to_s if opts[:layout].is_a? Symbol
        end

        super(opts, locs, &block)
      end

      # The title of the article, set from frontmatter
      # @return [String]
      def title
        data["title"]
      end

      # Whether or not this article has been published
      #
      # An article is considered published in the following scenarios:
      #
      # 1. frontmatter does not set published to false and either
      # 2. published_future_dated is true or
      # 3. article date is after the current time
      # @return [Boolean]
      def published?
        (data["published"] != false) and
          (blog_options.publish_future_dated || date <= Time.current)
      end

      # The body of this article, in HTML. This is for
      # things like RSS feeds or lists of articles - individual
      # articles will automatically be rendered from their
      # template.
      # @return [String]
      def body
        render(:layout => false)
      end

      # Retrieve a section of the source path
      # @param [String] The part of the path, e.g. "year", "month", "day", "title"
      # @return [String]
      def path_part(part)
        @_path_parts ||= blog_page_data.path_matcher.match(path).captures
        @_path_parts[blog_page_data.matcher_indexes[part]]
      end

      # The "slug" of the article that shows up in its URL.
      # @return [String]
      def slug
        @_slug ||= data["slug"]

        @_slug ||= if blog_options.sources.include?(":title")
          path_part("title")
        elsif title
          title.parameterize
        else
          raise "Can't generate a slug for #{path} because it has no :title in its path pattern or title/slug in its frontmatter."
        end
      end

      # The "priority" of the article make how order articles
      # @return [Integer]
      def priority
        @_priority ||= data["priority"].to_i
      end

      def inspect
        "#<Middleman::BlogPage::BlogPageArticle: #{data.inspect}>"
      end
    end
  end
end
