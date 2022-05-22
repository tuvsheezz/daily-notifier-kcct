require_relative 'boot'

require 'rails'
require 'action_controller/railtie'

Bundler.require(*Rails.groups)

module Dailynotfier
  class Application < Rails::Application
    config.load_defaults 7.0
    config.time_zone = 'Tokyo'
    config.api_only = true
  end
end
