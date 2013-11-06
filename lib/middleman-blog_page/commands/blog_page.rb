require 'middleman-core/cli'
require 'date'

module Middleman
  module Cli
    # This class provides an "article" command for the middleman CLI.
    class BlogPage < Thor
      include Thor::Actions

      check_unknown_options!

      namespace :blog_page

      # Template files are relative to this file
      # @return [String]
      def self.source_root
        File.dirname(__FILE__)
      end

      # Tell Thor to exit with a nonzero exit code on failure
      def self.exit_on_failure?
        true
      end

      desc "blog_page TITLE", "Create a new blog page"
      def blog_page(title)
        shared_instance = ::Middleman::Application.server.inst

        # This only exists when the config.rb sets it!
        if shared_instance.respond_to? :blog_pages
          @title = title
          @slug = title.parameterize

          article_path = shared_instance.blog_page.options.sources.
            sub(':title', @slug)

          template "blog_page.tt", File.join(shared_instance.source_dir, article_path + shared_instance.blog.options.default_extension)
        else
          raise Thor::Error.new "You need to activate the blog_page extension in config.rb before you can create an article"
        end
      end
    end
  end
end

