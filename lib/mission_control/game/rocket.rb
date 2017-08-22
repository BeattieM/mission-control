# frozen_string_literal: true

module MissionControl
  module Game
    class Rocket

      LITERS_PER_KM_M = 6729.32
      DISTANCE_TO_ORBIT = 160

      attr_reader :burn_rate, :speed, :distance_traveled, :fuel_burned, :flight_time

      def initialize
        @speed = rand(1200..1800).to_f
        @burn_rate = ((speed / 60) * LITERS_PER_KM_M).round(2)
        @distance_traveled = 0
        @fuel_burned = 0
        @flight_time = 0
      end

      def perform_cross_checks
        rand > 0.33
      end

      def launch
        rand > 0.2
      end

      def mission_inprogress
        @flight_time = DISTANCE_TO_ORBIT / ((speed / 60) / 60)
        @distance_traveled = rand(10..100)
      end

      def elapsed_time
        distance_traveled / ((speed / 60) / 60)
      end

      def time_remaining
        flight_time - elapsed_time
      end

      def mission_complete
        @distance_traveled = DISTANCE_TO_ORBIT
        @fuel_burned = burn_rate * distance_traveled
      end
    end
  end
end
