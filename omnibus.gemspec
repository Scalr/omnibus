# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omnibus/version'

Gem::Specification.new do |gem|
  gem.name           = 'omnibus'
  gem.version        = Omnibus::VERSION
  gem.license        = 'Apache 2.0'
  gem.author         = 'Chef Software, Inc.'
  gem.email          = 'releng@getchef.com'
  gem.summary        = 'Omnibus is a framework for building self-installing, full-stack software builds.'
  gem.description    = gem.summary
  gem.homepage       = 'https://github.com/opscode/omnibus'

  gem.required_ruby_version = '>= 2'

  gem.files = `git ls-files`.split($/)
  gem.bindir = 'bin'
  gem.executables = %w(omnibus)
  gem.test_files = gem.files.grep(/^(test|spec|features)\//)
  gem.require_paths = ['lib']

  # https://github.com/ksubrama/pedump, branch 'patch-1'
  # is declared in the Gemfile because of its outdated
  # dependency on multipart-post (~> 1.1.4)
  gem.add_dependency 'public_suffix',       '3.0.1'
  gem.add_dependency 'cabin',               '0.9.0'
  gem.add_dependency 'aws-sigv4',           '1.0.2'
  gem.add_dependency 'jmespath',            '1.3.1'
  gem.add_dependency 'backports',           '3.11.0'
  gem.add_dependency 'fuzzyurl',            '0.9.0'
  gem.add_dependency 'mixlib-config',       '2.2.4'
  gem.add_dependency 'ffi',                 '1.9.10'
  gem.add_dependency 'wmi-lite',            '1.0.0'
  gem.add_dependency 'chef-sugar',          '3.6.0'
  gem.add_dependency 'clamp',               '1.0.1'
  gem.add_dependency 'cleanroom',           '1.0.0'
  gem.add_dependency 'dotenv',              '2.2.1'
  gem.add_dependency 'libyajl2',            '1.2.0'
  gem.add_dependency 'json',                '1.8.6'
  gem.add_dependency 'insist',              '1.0.0'
  gem.add_dependency 'mustache',            '0.99.8'
  gem.add_dependency 'stud',                '0.0.23'
  gem.add_dependency 'io-like',             '0.3.0'
  gem.add_dependency 'ipaddress',           '0.8.3'
  gem.add_dependency 'mixlib-cli',          '1.7.0'
  gem.add_dependency 'mixlib-log',          '1.7.1'
  gem.add_dependency 'mixlib-versioning',   '1.1.0'
  gem.add_dependency 'plist',               '3.4.0'
  gem.add_dependency 'systemu',             '2.6.5'
  gem.add_dependency 'ruby-progressbar',    '1.9.0'
  gem.add_dependency 'thor',                '0.20.0'
  gem.add_dependency 'addressable',         '2.5.2'
  gem.add_dependency 'arr-pm',              '0.0.10'
  gem.add_dependency 'aws-sdk-core',        '2.10.121'
  gem.add_dependency 'win32-process',       '0.8.3'
  gem.add_dependency 'childprocess',        '0.8.0'
  gem.add_dependency 'ffi-yajl',            '2.3.0'
  gem.add_dependency 'pleaserun',           '0.0.30'
  gem.add_dependency 'ruby-xz',             '0.2.3'
  gem.add_dependency 'aws-sdk-resources',   '2.10.121'
  gem.add_dependency 'mixlib-shellout',     '2.2.7 '
  gem.add_dependency 'fpm',                 '1.9.3'
  gem.add_dependency 'aws-sdk',             '2.10.121'
  gem.add_dependency 'chef-config',         '13.6.4'
  gem.add_dependency 'ohai',                '8.26.0'

  gem.add_development_dependency 'bundler' 
  gem.add_development_dependency 'artifactory', '~> 2.0'
  gem.add_development_dependency 'aruba',       '~> 0.5'
  gem.add_development_dependency 'fauxhai',     '~> 2.3'
  gem.add_development_dependency 'rspec',       '~> 3.0'
  gem.add_development_dependency 'rspec-its'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'appbundler'
end
