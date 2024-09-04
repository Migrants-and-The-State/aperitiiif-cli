# frozen_string_literal: true

require 'iiif/presentation'
require 'ostruct'

# to do
module Aperitiiif
  # to do
  # has smell :reek:InstanceVariableAssumption
  # has smell :reek:TooManyInstanceVariables
  # has smell :reek:TooManyMethods
  class Item
    # has smell  :reek:Attribute
    attr_writer :record
    attr_reader :id, :assets

    def initialize(id, assets, config)
      @id       = id
      @config   = config
      @assets   = assets

      validate_config
    end

    def validate_config
      raise Aperitiiif::Error, "No value found for 'namespace'. Check your config?" if @config.namespace.empty?
      raise Aperitiiif::Error, "No value found for 'presentation_api_url'. Check your config?" if @config.presentation_api_url.empty?
      raise Aperitiiif::Error, "No value found for 'presentation_build_dir'. Check your config?" if @config.presentation_build_dir.empty?
    end

    def record
      @record || default_record
    end

    def default_record
      Record.new({ 'id' => id }, @config.records_defaults)
    end

    def manifest
      @manifest ||= build_manifest
    end

    def label
      record.label
    end

    def manifest_url
      "#{@config.presentation_api_url}/#{@config.namespace}/#{@id}/manifest.json"
    end

    def full_url
      return '' if assets.empty?

      assets.first.full_resource_url
    end

    def thumbnail_url
      return '' if assets.empty?

      assets.first.thumbnail_url
    end

    def viewpoint_url
      "https://dss.hosting.nyu.edu/viewpoint/mirador/#manifests[]=#{CGI.escape manifest_url}&theme=dark"
    end

    # has smell :reek: TooManyStatements
    def seed
      {
        '@id' => manifest_url,
        'label' => label,
        'logo' => record.logo,
        'description' => record.description,
        'source' => record.source,
        'metadata' => record.custom_metadata
      }.delete_if { |_key, val| val.to_s.empty? }
    end

    def build_manifest
      manifest = IIIF::Presentation::Manifest.new seed
      sequence = IIIF::Presentation::Sequence.new
      sequence.canvases = assets.map(&:canvas)
      manifest.sequences << sequence
      manifest
    end

    def manifest_file
      "#{@config.presentation_build_dir}/#{@config.namespace}/#{id}/manifest.json"
    end

    def manifest_written?
      File.file? manifest_file
    end

    def write_presentation_json
      Aperitiiif::Utils.mkfile_p manifest_file, manifest.to_json(pretty: true)
    end

    def to_hash
      {
        'id' => id,
        'label' => label,
        'manifest_url' => manifest_url,
        'thumbnail_url' => thumbnail_url,
        'full_url' => full_url,
        'viewpoint_url' => viewpoint_url
      }
    end
  end
end
