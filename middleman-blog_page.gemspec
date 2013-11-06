# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-blog_page/version"

Gem::Specification.new do |s|
  s.name = "middleman-blog_page"
  s.version = Middleman::BlogPage::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["jasl"]
  s.email = ["jasl9187@hotmail.com"]
  s.homepage = "https://github.com/jasl/middleman-blog_page"
  s.summary = %q{Blog page engine for Middleman}
  s.description = %q{Blog page engine for Middleman}
  s.license = "MIT"
  s.files = `git ls-files -z`.split("\0")
  s.require_paths = ["lib"]
  s.add_dependency("middleman-core", ["~> 3.2"])
  s.add_dependency("tzinfo", ["~> 0.3.0"])
end
