# frozen_string_literal: true

require 'tty-prompt'
require 'pastel'
require 'mission_control/game/mission'
require 'mission_control/game/rocket'
require 'mission_control/utils'

module MissionControl
  class ControlCenter
    include MissionUtils
    STATUS_SUCCESS = 0

    attr_reader :prompt, :pastel, :missions, :explosions, :aborts

    def initialize
      @prompt = TTY::Prompt.new
      @pastel = Pastel.new
      @missions = []
      @explosions = 0
      @aborts = 0
    end

    def execute
      start_new_mission
      STATUS_SUCCESS
    end

    private

    def start_new_mission
      mission = MissionControl::Game::Mission.new(prompt, pastel, mission_name, MissionControl::Game::Rocket.new)
      missions << mission
      mission.play
      prompt.yes?(pastel.bold('Would you like to re-attempt the mission?')) ? start_new_mission : after_action_report
    end

    def mission_name
      prompt.ask(pastel.bold('Welcome to Mission Control! Provide a mission name:'), required: true)
    end

    def after_action_report
      successfull_missions = missions.select(&:success)
      final_stats(successfull_missions)
    end

    def final_stats(successfull_missions)
      stats = <<~EOS
        Flight Stats:
        Distance traveled:           #{successfull_missions.sum(&:distance_traveled)} kilometers
        Number of explosions:        #{missions.count(&:lost)}
        Number of abort/retries:     #{missions.count(&:aborted)}/#{missions.length - 1}
        Fuel burned:                 #{successfull_missions.sum(&:fuel_burned).round} liters
        Flight time:                 #{time_to_string(successfull_missions.sum(&:flight_time))}
      EOS
      report_color(stats, :yellow)
    end
  end
end
