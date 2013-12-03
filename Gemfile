source 'https://rubygems.org'

#gem 'rails', '4.0.1'
gem 'rails', github: 'rails/rails', branch: 'fxn/string-pools'
gem 'arel', github: 'rails/arel'

#gem 'ruby-prof'
gem 'benchmark_suite', :require => false

gem 'mysql2'
gem 'rugged', '0.17.0.b7'
gem 'unf'
gem 'turbolinks'
gem 'actionpack-page_caching'

gem 'sprockets-rails',  github: "rails/sprockets-rails"

# Use SCSS for stylesheets
gem 'sass-rails',       github: "rails/sass-rails"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails',     github: "rails/coffee-rails"

group :development do
  gem 'capistrano'
  gem 'rvm-capistrano', require: false
  gem 'capistrano-unicorn', github: 'miepleinc/capistrano-unicorn', require: false
end

group :test do
  gem 'delorean'
end

group :production do
  gem 'unicorn'
end
