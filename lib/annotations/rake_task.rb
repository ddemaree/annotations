require 'rake'
require 'rake/tasklib'
require 'annotations'

module Annotations
  class RakeTask < ::Rake::TaskLib

    attr_accessor :name, :tags

    def initialize(name = :notes)
      @name = name
      @tags = [:optimize, :fixme, :todo]
      @extensions = ENV["ext"]
      yield self if block_given?
      define
    end

    def tags_to_pattern
      @tags.map { |t| t.to_s.upcase }.join("|")
    end

    # Define tasks
    def define
      desc "Enumerate all annotations"
      task name do
        Annotations::Extractor.enumerate(tags_to_pattern, :tag => true, :extensions => @extensions)
      end

      namespace name do
        tags.each do |tagname|
          desc "Enumerate all #{tagname.to_s.upcase} annotations"
          task tagname.to_sym do
            Annotations::Extractor.enumerate(tagname.to_s.upcase, :tag => true, :extensions => @extensions)
          end
        end

        desc "Enumerate a custom annotation, specify with ANNOTATION=CUSTOM"
        task :custom, :annotation do |annotation|
          puts annotation
          Annotations::Extractor.enumerate(ENV['ANNOTATION'], :extensions => @extensions)
        end
      end
    end

  end
end
