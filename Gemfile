# workaround for "invalid byte sequence in US-ASCII (ArgumentError)" breaking the Jenkins build
if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source 'http://rubygems.org'

gem 'rails', '3.2.6'
gem 'mysql2', '0.3.11'
gem 'blacklight', '3.5.0'
gem 'blacklight_advanced_search', '1.2.4'
gem 'hydra-head', '4.1.1'
gem 'active-fedora', '4.4.0'
gem 'rubydora', '0.5.10'
gem 'solrizer-fedora', '2.2.0'
gem 'hydra-ldap', '0.0.4'
gem 'clamav', '0.4.1'
gem 'rainbow', '1.1.4'
gem 'will_paginate', '3.0.3'

# the :require arg is necessary on Linux-based hosts
gem 'rmagick', '2.13.1', :require => 'RMagick'
gem 'resque', '1.21.0', :require => 'resque/server'
gem 'resque-pool', '0.3.0'
gem 'devise', '2.0.4'
gem 'noid', '0.5.5'
gem 'paperclip', '3.1.4'
gem 'daemons', '1.1.8'
gem 'execjs', '1.4.0'
gem 'therubyracer', '0.10.1'
gem 'zipruby', '0.3.6'
gem 'mail_form', :git => 'git://github.com/psu-stewardship/mail_form.git', :ref => '50c00f0'
gem 'rails_autolink', '1.0.9'
gem 'acts_as_follower', '0.1.1'
gem 'nest', '1.1.1'
gem 'sitemap', '0.3.2'
gem 'yaml_db', :git => 'git://github.com/lostapathy/yaml_db', :ref => '98e9a5dc'
gem 'mailboxer', '0.8.0'

group :assets do
  gem 'sass-rails', '3.2.5'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.7'
  gem 'compass-rails', '1.0.3'
  gem 'compass-susy-plugin', '0.9'
end

group :production, :integration do
  gem 'passenger', '3.0.13'
end

group :development, :test do
  gem 'capistrano', '2.13.3'
  gem 'capistrano_colors', '0.5.5'
  gem 'rvm-capistrano', '1.2.7'
  gem 'sqlite3'
  gem 'unicorn-rails'
  gem "debugger"
  gem 'activerecord-import'
  gem "rails_indexes", :git => "https://github.com/warpc/rails_indexes"
  gem 'selenium-webdriver'
  gem 'headless'
  gem 'rspec', '2.10.0'
  gem 'rspec-rails', '>= 2.4.0'
  gem 'ruby-prof'
  gem 'mocha', '0.11.4'
  gem 'cucumber-rails', '~> 1.0', :require => false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'bcrypt-ruby'
  gem "jettywrapper"
  gem "factory_girl_rails", "~> 1.7.0"
  gem 'launchy'
end # (leave this comment here to catch a stray line inserted by blacklight!)
