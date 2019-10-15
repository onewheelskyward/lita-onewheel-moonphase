require 'rest-client'

module Lita
  module Handlers
    class OnewheelMoonphase < Handler
      route /^moon\s*(.*)$/i,
            :moon,
            command: true,
            help: {'moon [location]' => 'Get Moon phase data'}

      route /^mars$/i,
            :mars,
            command: true,
            help: {'mars' => 'Get Mars weather data'}

      # 🌑🌛

      def mars(response)
        api_resp = RestClient.get 'https://api.maas2.apollorion.com'
        data = JSON.parse(api_resp)
        # {
        #   "status": 200,
        #   "id": 198,
        #   "sol": 2108,
        #   "season": "Month 7",
        #   "min_temp": -65,
        #   "max_temp": -24,
        #   "atmo_opacity": "Sunny",
        #   "sunrise": "05:19",
        #   "sunset": "17:27",
        #   "min_gts_temp": -58,
        #   "max_gts_temp": -15,
        #   "unitOfMeasure": "Celsius",
        #   "TZ_Data": "America/Port_of_Spain"
        # }

        resp = "Sol #{data['sol']}, #{data['season']}, A #{data['atmo_opacity']} day with a min temp of #{data['min_temp']} and a high of #{data['max_temp']} #{data['unitOfMeasure']}.  Sunrise is at #{data['sunrise']} and sunset occurs at #{data['sunset']}."
        response.reply resp
      end
      def moon(response)
        location = get_location(response)
        moon = get_data(location)

        # today = Time.now
        rise_time = Time.parse moon['moondata']['rise']
        set_time = Time.parse moon['moondata']['set']

        emoonjis = {
          'New Moon'        => '🌚',
          'Waxing Crescent' => '🌒',
          'First Quarter'   => '🌓',
          'Waxing Gibbous'  => '🌔',
          'Full Moon'       => '🌕',
          'Waning Gibbous'  => '🌖',
          'Last Quarter'    => '🌗',
          'Waning Crescent' => '🌘'
        }

        reply = "#{emoonjis[moon['moondata']['curphase']]} Moon phase #{moon['moondata']['fracillum']}, #{moon['moondata']['curphase']}.  "
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

      # Next step, determine waxing or waning.
      # def get_moonmoji(percent_full, phase)
        # moonmoji = ''
        # waning = false

        # if phase.match /waning/i
        #   waning = true
        # end
        #
        # case percent_full.sub('%', '').to_i
        #   when 0..1
        #     moonmoji = '🌚'
        #   when 2..32
        #     moonmoji = waning ? '🌘' : '🌒'
        #   when 33..62
        #     moonmoji = phase.match(/last/i) ? '🌗' : '🌓'
        #   when 63..90
        #     moonmoji = waning ? '🌖' : '🌔'
        #   when 91..100
        #     moonmoji = '🌕'
        # end
        # moonmoji
      # end

      Lita.register_handler(self)
    end
  end
end
