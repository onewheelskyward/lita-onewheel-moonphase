require 'rest-client'

module Lita
  module Handlers
    class OnewheelMoonphase < Handler
      route /^moon\s*(.*)$/i,
            :moon,
            command: true,
            help: {'moon [location]' => 'Get Moon phase data'}

      def moon(response)
        location = response.matches[0][0]

        if location.empty?
          location = '45.5230622,-122.6764816'
        end

        Lita.logger.debug "Getting Moon data for #{location}"
        uri = "https://j8jqi56gye.execute-api.us-west-2.amazonaws.com/prod/moon?loc=#{URI.encode location}"
        Lita.logger.debug uri
        moon = JSON.parse(RestClient.get(uri))

        reply = "Moon phase #{moon['moondata']['fracillum']}, #{moon['moondata']['curphase']}."
        Lita.logger.debug "Replying with #{reply}"
        response.reply reply
      end

      Lita.register_handler(self)
    end
  end
end
