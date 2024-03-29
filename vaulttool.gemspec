# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vaulttool/version'

Gem::Specification.new do |spec|
  spec.name          = 'vaulttool'
  spec.version       = Vaulttool::VERSION
  spec.authors       = ['Tristan Morgan']
  spec.email         = ['tristan@vibrato.com.au']

  spec.summary       = 'Useful tools to work with Vault and AWS'
  spec.description   = 'Useful tools to work with Vault and AWS'
  spec.homepage      = Vaulttool::HOMEPAGE
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.6.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/|^\..*|^.*\.png}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('awskeyring')
  spec.add_dependency('aws-sdk-iam')
  spec.add_dependency('thor')
  spec.add_dependency('vault')
  spec.metadata['rubygems_mfa_required'] = 'true'
end
