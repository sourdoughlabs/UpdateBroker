# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "updatebroker/version"

Gem::Specification.new do |s|
  s.name        = "updatebroker"
  s.version     = Updatebroker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Vince Hodges"]
  s.email       = ["vince@sourdoughlabs.com"]
  s.homepage    = "https://github.com/sourdoughlabs/UpdateBroker"
  s.summary     = %q{Broker updates from apps to connected web clients}
  s.description = %q{Simple service (using Goliath) for reading updates from redis and sending them to clients using SSE}

  s.rubyforge_project = "updatebroker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "hiredis"
  s.add_dependency "em-hiredis"
  s.add_dependency "em-synchrony"
  s.add_dependency "goliath"
end
