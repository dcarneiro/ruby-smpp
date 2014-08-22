require "bundler/gem_tasks"

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

task :console do
  require 'irb'
  require 'irb/completion'
  require 'nmusic_search_server'
  ARGV.clear
  IRB.start
end