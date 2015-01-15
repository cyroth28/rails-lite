require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require 'byebug'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      controller = self.class.to_s.underscore
      file = File.read("views/#{controller}/#{template_name}.html.erb")
      erb = ERB.new(file).result(binding)

      self.render_content(erb, 'text/html')
      byebug
    end
  end
end
