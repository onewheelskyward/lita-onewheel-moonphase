require 'rest-client'

module Lita
  module Handlers
    class OnewheelMoonphase < Handler
      route /^moon\s*(.*)$/i,
            :moon,
            command: true,
            help: {'moon [location]' => 'Get Moon phase data'}

      def moon(response)
        location = get_location(response)

        moon = get_data(location)

        # today = Time.now
        rise_time = Time.parse moon['moondata']['rise']
        set_time = Time.parse moon['moondata']['set']

        reply = "Moon phase #{moon['moondata']['fracillum']}, #{moon['moondata']['curphase']}.  "
        reply += "Rise: #{rise_time.strftime("%H:%M")}  Set: #{set_time.strftime('%H:%M')}"
        Lita.logger.debug "Replying with #{reply}"
        response.reply reply
      end

      def get_data(location)
        Lita.logger.debug "Getting Moon data for #{location}"
        uri = "https://j8jqi56gye.execute-api.us-west-2.amazonaws.com/prod/moon?loc=#{URI.encode location}"
        Lita.logger.debug uri
        JSON.parse(RestClient.get(uri))
      end

      def get_location(response)
        location = response.matches[0][0]

        if location.empty?
          location = '45.5230622,-122.6764816'
        end

        location
      end

      Lita.register_handler(self)
    end
  end
end
