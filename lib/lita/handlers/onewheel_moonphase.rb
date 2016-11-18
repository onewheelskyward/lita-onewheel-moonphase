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

        unless location
          location = 'Portland, OR'
        end

        Lita.logger.debug "Getting Moon data for #{location}"
        uri = "https://j8jqi56gye.execute-api.us-west-2.amazonaws.com/prod/moon?loc=#{location}"
        Lita.logger.debug uri
        moon = JSON.parse(RestClient.get(uri))

        reply = "Moon phase #{moon['moondata']['fracillum']}, #{moon['moondata']['curphase']}."
        response.reply reply
      end

      Lita.register_handler(self)
    end
  end
end
{
    "year": 2016,
    "month": 11,
    "day": 18,
    "dayOfWeek": "Friday",
    "lng": -122.186048,
    "lat": 45.205518,
    "tz": -8,
    "sundata": {
        "civilRise": "06:40",
        "rise": "07:12",
        "transit": "11:54",
        "set": "16:36",
        "civilSet": "17:08"
    },
    "moondata": {
        "transit": "03:45",
        "set": "11:16",
        "rise": "21:14"
    }
}
