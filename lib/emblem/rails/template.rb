require 'sprockets'
require 'sprockets/engines'
require 'barber-emblem'

module Emblem
  module Rails
    class Template < Tilt::Template
      def self.default_mime_type
        'application/javascript'
      end

      def prepare; end

      def evaluate(scope, locals, &block)
        if configuration.precompile
          template = precompile_emblem(data)
        else
          template = compile_emblem(data)
        end

        if configuration.output_type == :amd
          target = amd_template_target(scope)

          "define('#{target}', ['handlebars.runtime'], function(Handlebars){ Handlebars = Handlebars['default']; return #{template} });"
        else
          target = global_template_target(scope)

          "#{target} = #{template}\n"
        end
      end

      private

      def amd_template_target(scope)
        "#{scope.logical_path.split(".").first}"
      end

      def global_template_target(scope)
        "JST[#{template_path(scope.logical_path).inspect}]"
      end

      def compile_emblem(string)
        "Handlebars.compile(#{indent(string).inspect});"
      end

      def precompile_emblem(string)
        Barber::Emblem::FilePrecompiler.call(string)
      end

      def configuration
        ::Rails.configuration.emblem
      end

      def template_path(path)
        root = configuration.templates_root

        if root.kind_of? Array
          root.each do |root|
            path.sub!(/#{Regexp.quote(root)}\//, '')
          end
        else
          unless root.empty?
            path.sub!(/#{Regexp.quote(root)}\/?/, '')
          end
        end

        path = path.split('/')

        path.join(configuration.templates_path_separator)
      end
    end
  end
end
