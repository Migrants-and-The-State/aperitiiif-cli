# frozen_string_literal: true

# TO DO COMMENT
module Aperitiiif
  # has smell :reek:Attribute
  # TO DO COMMENT
  class Config
    attr_reader :namespace, :hash

    DELEGATE       = %i[puts p].freeze
    DEFAULT_VALUES = {
      'build_dir' => './build',
      'source_dir' => './src/data',
      'service_namespace' => 'aperitiiif-batch'
    }.freeze

    def initialize(seed = {})
      @hash       = DEFAULT_VALUES.merge(seed)
      @namespace  = batch_namespace

      validate
    end

    def method_missing(method, *args, &block)
      return super if DELEGATE.include? method

      @hash.fetch method.to_s, ''
    end

    def respond_to_missing?(method, _args)
      DELEGATE.include?(method) or super
    end

    # should check for more reqs
    def validate
      raise Aperitiiif::Error, "Config is missing a valid 'namespace' for the batch." if namespace.empty?
      raise Aperitiiif::Error, "Config is missing 'label' for the batch." if label.empty?
    end

    def batch_namespace(dir = nil)
      dir ||= Dir.getwd
      name = File.basename(dir).sub service_namespace, ''
      Utils.slugify name
    end

    def presentation_build_dir  = "#{build_dir}/presentation"
    def image_build_dir         = "#{build_dir}/image"
    def html_build_dir          = "#{build_dir}/html"
    def records_file            = @hash.dig('records', 'file') || ''
    def records_defaults        = @hash.dig('records', 'defaults') || {}
  end
end
