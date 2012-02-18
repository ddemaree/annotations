require 'rake'
require 'rake/tasklib'
require 'annotations'

module Annotations
  class RakeTask < ::Rake::TaskLib

    attr_accessor :name, :tags

    def initialize(name = :notes)
      @name = name
      @tags = [:optimize, :fixme, :todo]
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

      # desc name == :notes ? "Compile assets" : "Compile #{name} assets"
      # desc "Enumerate all annotations (use notes:optimize, :fixme, :todo for focus)"
      # task name do
      #   with_logger do
      #     manifest.compile(assets)
      #   end
      # end

      # desc name == :assets ? "Remove all assets" : "Remove all #{name} assets"
      # task "clobber_#{name}" do
      #   with_logger do
      #     manifest.clobber
      #   end
      # end

      # task :clobber => ["clobber_#{name}"]

      # desc name == :assets ? "Clean old assets" : "Clean old #{name} assets"
      # task "clean_#{name}" do
      #   with_logger do
      #     manifest.clean(keep)
      #   end
      # end

      # task :clean => ["clean_#{name}"]
    end

  end
end