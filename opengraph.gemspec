# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'opengraph'
  s.version = '0.1.0'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Michael Bleigh']
  s.date = '2010-11-04'
  s.description = 'A very simple Ruby library for parsing Open Graph protocol information from websites. '\
                  'See http://opengraphprotocol.org for more information.'
  s.email = 'michael@intridea.com'
  s.extra_rdoc_files = [
    'LICENSE',
    'README.rdoc'
  ]
  s.files = [
    '.document',
    '.gitignore',
    '.rspec',
    'LICENSE',
    'README.rdoc',
    'Rakefile',
    'VERSION',
    'lib/opengraph.rb',
    'opengraph.gemspec',
    'spec/examples/partial.html',
    'spec/examples/rottentomatoes.html',
    'spec/opengraph_spec.rb',
    'spec/spec.opts',
    'spec/spec_helper.rb'
  ]
  s.homepage = 'http://github.com/intridea/opengraph'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.rubygems_version = '1.3.7'
  s.summary = 'A very simple Ruby library for parsing Open Graph protocol information from websites.'
  s.test_files = %w[spec/opengraph_spec.rb spec/spec_helper.rb]
end
