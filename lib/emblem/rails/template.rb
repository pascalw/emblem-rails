require 'sprockets'
require 'sprockets/engines'
require 'ember/handlebars/template'
require 'barber-emblem'

module Emblem
  module Rails
    class Template < Ember::Handlebars::Template

      def evaluate(scope, locals, &block)
        target = global_template_target(scope)

        if configuration.precompile
          template = precompile_emblem(data)
        else
          template = compile_emblem(data)
        end

        "#{target} = #{template}\n"
      end

      private

      def global_template_target(scope)
        "JST[#{template_path(scope.logical_path).inspect}]"
      end

      def compile_emblem(string)
        "Handlebars.compile(#{indent(string).inspect});"
      end

      def precompile_emblem(string)
        Barber::Emblem::FilePrecompiler.call(string)
      end
    end
  end
end
