# frozen_string_literal: true

require 'tty-prompt'
require 'pastel'
require 'forwardable'
require 'mission_control/utils'

module MissionControl
  module Game
    class Mission
      include MissionUtils
      extend Forwardable

      attr_reader :prompt, :pastel, :mission_name, :rocket, :success, :aborted, :lost
      def_delegators :@rocket, :burn_rate, :distance_traveled, :fuel_burned, :flight_time

      def initialize(prompt, pastel, mission_name, rocket)
        @prompt = prompt
        @pastel = pastel
        @mission_name = mission_name
        @rocket = rocket
        @success = false
        @aborted = false
        @lost = false
      end

      def play
        load_mission
      end

      private

      def load_mission
        report_color("Welcome #{mission_name}. Your mission is to launch the rocket into lower orbit.", :green)
        report_color("Here's what you need to know:", :green)
        intro_stats
        prompt.yes?(pastel.bold('Are you ready?')) ? begin_launch : mission_aborted
      end

      def begin_launch
        report("\nEnabling stage 1 afterburner.")
        prompt.yes?(pastel.bold('Disengage release structure?')) ? disengage : mission_aborted
      end

      def disengage
        report("Release structure disengaged.\n")
        prompt.yes?(pastel.bold('Perform cross-checks?')) ? perform_checks : mission_aborted
      end

      def perform_checks
        if rocket.perform_cross_checks
          report("Cross-checks performed successfully.\n")
          prompt.yes?(pastel.bold('Ready to launch?')) ? go_for_launch : mission_aborted
        else
          report_color('Error:Cross-checks failed to performed successfully.', :red)
          mission_aborted
        end
      end

      def go_for_launch
        if rocket.launch
          mission_success
        else
          mission_lost
        end
      end

      def mission_success
        report_color('Congratulations! Launched successfully!', :green)
        rocket.mission_inprogress
        mission_status
        rocket.mission_complete
        @success = true
      end

      def mission_aborted
        report_color('Mission aborted.', :red)
        @aborted = true
      end

      def mission_lost
        report_color('Oh the horror! The rocket exploded shortly after launched!', :red)
        report_color('Mission lost.', :red)
        @lost = true
      end

      def intro_stats
        stats = <<~EOS
          Travel distance:       160 kilometers
          Payload capacity:      50,000 kilograms
          Fuel capacity:         1,514,100 liters
          Average burn rate:     168,233 liters / minute
          Average speed:         1500 kilometers / hr
        EOS
        report_color(stats, :yellow)
      end

      def mission_status
        status = <<~EOS
          Current fuel burn:           #{burn_rate} liters per minute
          Current speed:               #{rocket.speed.round} kilometers per hour
          Current distance traveled:   #{distance_traveled} kilometers
          Elased time:                 #{time_to_string(rocket.elapsed_time)}
          Time to destination:         #{time_to_string(rocket.time_remaining)}
        EOS
        report_color(status, :yellow)
        report_color("Congratulations you've reached lower orbit!\n", :green)
      end
    end
  end
end
