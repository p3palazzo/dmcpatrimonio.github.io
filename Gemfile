source "https://rubygems.org"
gem "jekyll", "~> 4.2.0"
gem "minima", "~>2.5.1"
group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-pandoc"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
  # Sassc is preferred to the legacy ruby-sass
  gem "sassc"
  # Required GitHub Pages plugins below
  gem "jekyll-coffeescript"
  gem "jekyll-default-layout"
  gem "jekyll-gist"
  gem "jekyll-optional-front-matter"
  gem "jekyll-paginate"
  gem "jekyll-readme-index"
  gem "jekyll-relative-links"
  gem "jekyll-titles-from-headings"
  # Required by Ruby 3
  gem "webrick"
  gem "stringex"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?

