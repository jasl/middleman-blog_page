# Middleman-BlogPage

`middleman-blog_page` is an extension for the [Middleman] static site generator that help to manage static pages ```e.g: about me, resume, contact, etc.```. This includes handling pages, helpers for listing pages.

**This gem is copy and simplify from [Middleman-blog] .**

## Installation

If you're just getting started, install the `middleman` gem and generate a new project:

```
gem install middleman
middleman init MY_PROJECT
```

If you already have a Middleman project: Add `gem "middleman-blog_page"` to your `Gemfile` and run `bundle install`

## Configuration

```
activate :blog_page
```

for advance:

```
activate :blog_page do |page|
  # page.prefix = "page"
  # page.permalink = ":title.html"
  # page.sources = "pages/:title.html"
  # page.layout = "layout"
  # page.default_extension = ".markdown"
end
```

## Bug Reports

Github Issues are used for managing bug reports and feature requests. If you run into issues, please search the issues and submit new problems: https://github.com/middleman/middleman-blog/issues

The best way to get quick responses to your issues and swift fixes to your bugs is to submit detailed bug reports, include test cases and respond to developer questions in a timely manner. Even better, if you know Ruby, you can submit [Pull Requests](https://help.github.com/articles/using-pull-requests) containing Cucumber Features which describe how your feature should work or exploit the bug you are submitting.

## How to Run Cucumber Tests

1. Checkout Repository: `git clone https://github.com/jasl/middleman-blog_page.git`
2. Install Bundler: `gem install bundler`
3. Run `bundle install` inside the project root to install the gem dependencies.
4. Run test cases: `bundle exec rake test`

## License

Copyright (c) 2010-2013 Jasl. MIT Licensed, see [LICENSE] for details.

[middleman]: http://middlemanapp.com
[middleman-blog]: https://github.com/middleman/middleman-blog
[gem]: https://rubygems.org/gems/middleman-blog
[travis]: http://travis-ci.org/middleman/middleman-blog
[gemnasium]: https://gemnasium.com/middleman/middleman-blog
[codeclimate]: https://codeclimate.com/github/middleman/middleman-blog
[rubydoc]: http://rubydoc.info/github/middleman/middleman-blog
[LICENSE]: https://github.com/jasl/middleman-blog_page/blob/master/LICENSE.md