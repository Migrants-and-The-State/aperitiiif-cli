# frozen_string_literal: true

require_relative 'lib/aperitiiif/version'

Gem::Specification.new do |spec|
  spec.name     = 'aperitiiif'
  spec.version  = Aperitiiif::VERSION
  spec.authors  = ['mnyrop']
  spec.email    = ['marii@nyu.edu']
  spec.summary  = ''
  spec.homepage = 'https://github.com/nyu-dss/aperitiiif-cli'
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['homepage_uri']     = spec.homepage
  spec.metadata['source_code_uri']  = 'https://github.com/nyu-dss/aperitiiif-cli'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir         = 'bin'
  spec.executables    = ['aperitiiif']
  spec.require_paths  = ['lib']

  spec.add_dependency 'colorize'
  spec.add_dependency 'csv'
  spec.add_dependency 'iiif-presentation', '1.1'
  spec.add_dependency 'liquid'
  spec.add_dependency 'mimemagic'
  spec.add_dependency 'ostruct'
  spec.add_dependency 'parallel'
  spec.add_dependency 'ruby-progressbar'
  spec.add_dependency 'ruby-vips'
  spec.add_dependency 'safe_yaml'
  spec.add_dependency 'thor'
end
