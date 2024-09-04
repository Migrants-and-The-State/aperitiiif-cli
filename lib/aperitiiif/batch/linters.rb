# frozen_string_literal: true

# TO DO COMMENT
module Aperitiiif
  # TO DO COMMENT
  module Linters
    def linters
      @linters ||= [
        method(:warn_nil_record_items),
        method(:warn_duplicate_record_ids),
        method(:warn_duplicate_image_names),
        method(:warn_missing_labels),
        method(:warn_stray_files)
      ]
    end

    def lint
      puts 'Linting...'.colorize(:cyan)
      puts 'Passed ✓'.colorize(:green) unless report_failures.any?
    end

    def report_failures
      linters.map(&:call)
    end

    # has smell :reek:TooManyStatements
    def warn_nil_record_items
      nil_record_items = items.select { |item| item.record.to_s.empty? }
      return false if nil_record_items.empty?

      warn "Could not find record(s) for #{nil_record_items.length} items:".colorize(:orange)
      nil_record_items.each { |item| puts Utils.rm_batch_namespace(item.id).colorize(:yellow) }
      true
    end

    # has smell :reek:TooManyStatements
    def warn_duplicate_record_ids
      ids     = records.map(&:id)
      dup_ids = ids.select { |id| ids.count(id) > 1 }.uniq
      return false if dup_ids.empty?

      warn "Found #{dup_ids.length} non-unique record id value(s):".colorize(:orange)
      dup_ids.each { |id| puts id.colorize(:yellow) }
      true
    end

    # has smell :reek:DuplicateMethodCall
    # has smell :reek:TooManyStatements
    # rubocop: disable Metrics/AbcSize
    def warn_duplicate_image_names
      files = Dir.glob("#{config.source_dir}/**/*").select { |file| File.file? file }
      files.map! { |file| Utils.rm_ext file.sub(config.source_dir, '') }
      duplicate_names = files.select { |file| files.count(file) > 1 }.uniq
      return false if duplicate_names.empty?

      warn "Found #{duplicate_names.length} duplicate image name(s):".colorize(:orange)
      duplicate_names.each { |name| puts Utils.prune_prefix_junk(name).colorize(:yellow) }
      true
    end
    # rubocop: enable Metrics/AbcSize

    # has smell :reek:TooManyStatements
    def warn_missing_labels
      no_label_records = records.select { |record| record.label.to_s.empty? }
      return false if no_label_records.empty?

      warn "Found #{no_label_records.length} record(s) missing labels (strongly encouraged):".colorize(:orange)
      no_label_records.each { |record| puts record.id.colorize(:yellow) }
      true
    end

    # has smell :reek:TooManyStatements
    # rubocop:disable Metrics/AbcSize
    def warn_stray_files
      stray_files = Dir.glob("#{config.source_dir}/**/*")
      stray_files.select! { |file| File.file?(file) && !file.end_with?(*ALLOWED_SRC_FORMATS) }
      return false if stray_files.empty?

      warn "Found #{stray_files.length} stray file(s) with unaccepted file types:".colorize(:orange)
      stray_files.each { |file| puts file.colorize(:yellow) }
      puts "(Accepted file extensions: #{ALLOWED_SRC_FORMATS.join(', ')})".colorize(:pink)
      true
    end
    # rubocop:enable Metrics/AbcSize
  end
end
