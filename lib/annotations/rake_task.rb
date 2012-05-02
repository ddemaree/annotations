require 'rake'
require 'rake/tasklib'
require 'annotations'

module Annotations
  class RakeTask < ::Rake::TaskLib

    attr_accessor :name, :tags

    def initialize(name = :notes)
      @name = name
      @tags = [:optimize, :fixme, :todo]
      yield self
      define
    end

    def tags_to_pattern
      @tags.map { |t| t.to_s.upcase }.join("|")
    end

    # Define tasks
    def define
      desc "Enumerate all annotations"
      task name do
        Annotations::Extractor.enumerate(tags_to_pattern, :tag => true)
      end

      namespace name do
        tags.each do |tagname|
          desc "Enumerate all #{tagname.to_s.upcase} annotations"
          task tagname.to_sym do
            Annotations::Extractor.enumerate(tagname.to_s.upcase, :tag => true)
          end
        end

        desc "Enumerate a custom annotation, specify with ANNOTATION=CUSTOM"
        task :custom, :annotation do |annotation|
          puts annotation
          SourceAnnotationExtractor.enumerate ENV['ANNOTATION']
        end
      end
    end

  end
end