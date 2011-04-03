# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'linenoise/version'

Gem::Specification.new do |s|
  s.name        = "ruby_linenoise"
  s.version     = Linenoise::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["James Cook"]
  s.email       = ["james@isotope11.com"]
  s.summary     = %q{Linenoise ruby wrapper. Aims to replaces readline"}
  #s.description = %q{}

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "ruby_linenoise"

  s.add_dependency "ffi"
  s.add_development_dependency "rspec"
  s.add_development_dependency "flexmock"

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths      = ["lib"]
end
