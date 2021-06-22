# -*- encoding: utf-8 -*-
require File.expand_path('../lib/x12/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "gm_x12"
  gem.version       = X12::VERSION
  gem.authors       = ["Robert Mathews"]
  gem.email         = ["robert.mathews@goodmeasures.com"]
  gem.description   = %q{A useful X12 parser that can handle large files using a callback per record. Currently tested with Ruby >= 2.7.1. Gem supports X12 EDI transactions 834, 270, 997, 837p and 835.  Anyone wanting to create additional XML files for other transactions welcomed. }
  gem.summary       = %q{A gem to handle parsing and generation of ANSI X12 documents}
  gem.homepage      = "https://github.com/goodmeasuresllc/x12"
  gem.licenses      = 'GPL-2'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'libxml-ruby'
  
end
