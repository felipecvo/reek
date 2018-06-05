# frozen_string_literal: true

require 'pathname'
require_relative '../configuration/configuration_validator'

module Reek
  module Configuration
    # Responsible for converting configuration values coming from the outside world
    # to whatever we want to use internally.
    module Converter
      DETECTORS_WITH_ACCEPT_REJECT = %w(
        UncommunicativeMethodName
        UncommunicativeModuleName
        UncommunicativeParameterName
        UncommunicativeVariableName
      ).freeze

      class << self
        include ConfigurationValidator

        # @param configuration [Hash]
        # @return [Hash]
        def strings_to_regexes(configuration)
          DETECTORS_WITH_ACCEPT_REJECT.each do |detector|
            %w(accept reject).each do |key|
              configuration[detector][key] = configuration[detector][key].map { |string| Regexp.new string }
            end
          end
          configuration.each do |key, _|
            if smell_type?(key) && !configuration[key]['exclude'].nil?
              configuration[key]['exclude'] = configuration[key]['exclude'].map { |string| Regexp.new string }
            end
          end
          configuration
        end
      end
    end
  end
end
