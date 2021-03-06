require "middleman-core"

require "middleman-blog_page/version"
require "middleman-blog_page/commands/blog_page"

::Middleman::Extensions.register(:blog_page) do
  if defined?(::Middleman::Extension)
    require "middleman-blog_page/extension_3_1"
    ::Middleman::BlogPageExtension
  else
    require "middleman-blog_page/extension_3_0"
    ::Middleman::BlogPage
  end
end
