require 'emblem/rails/template'

module Emblem
  module Rails
    class Engine < ::Rails::Engine
      config.emblem = ActiveSupport::OrderedOptions.new
      config.emblem.precompile = true
      config.emblem.templates_root = "templates"
      config.emblem.templates_path_separator = '/'
      config.emblem.output_type = :global

      config.before_initialize do |app|
        app.assets.register_engine '.emblem', Emblem::Rails::Template
      end
    end
  end
end
