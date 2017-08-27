require 'rest-client'

module Lita
  module Handlers
    class OnewheelMoonphase < Handler
      route /^moon\s*(.*)$/i,
            :moon,
            command: true,
            help: {'moon [location]' => 'Get Moon phase data'}

      # 🌑🌛

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
