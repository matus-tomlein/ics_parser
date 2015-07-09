# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "ics_parser"
  spec.version       = '0.0.3'
  spec.authors       = ["Matúš Tomlein"]
  spec.email         = ["matus@tomlein.org"]
  spec.summary       = %q{Reads iCalendar feeds and returns events in an array.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/matus-tomlein/ics_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
