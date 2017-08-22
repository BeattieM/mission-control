# frozen_string_literal: true

require 'pastel'

module MissionControl
  module MissionUtils
    def time_to_string(seconds)
      Time.at(seconds).utc.strftime('%H:%M:%S')
    end

    def report(message)
      puts pastel.bold(message)
    end

    def report_color(message, color)
      puts pastel.send(color).bold(message)
    end
  end
end
