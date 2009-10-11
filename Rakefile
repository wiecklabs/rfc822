require "rubygems"
require "rake"
require "rake/testtask"
require "rake/gempackagetask"

task :default => :test

Rake::TestTask.new do |t|
  t.test_files = 'test/**/*_test.rb'
end

require File.dirname(__FILE__) + "/lib/rfc822"

NAME = "rfc822"
SUMMARY = "RFC822 Email Parser / Validator"
GEM_VERSION = RFC822::VERSION

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.summary = s.description = SUMMARY
  s.author = "Wieck Media"
  s.email = "dev@wieck.com"
  s.homepage = "http://www.wiecklabs.com"
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY

  s.require_path = 'lib'
  s.files = %w(Rakefile) + Dir.glob("{lib}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install #{NAME} as a gem"
task :install => [:repackage] do
  sh %{gem install pkg/#{NAME}-#{GEM_VERSION}}
end