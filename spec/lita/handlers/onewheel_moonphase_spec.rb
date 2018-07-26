require 'spec_helper'

describe Lita::Handlers::OnewheelMoonphase, lita_handler: true do
  it { is_expected.to route_command('moon') }
  it { is_expected.to route_command('moon portland') }

  def load_mock(file)
    mock = File.open("spec/fixtures/#{file}.json").read
    allow(RestClient).to receive(:get) { mock }
  end

  it 'waning crescent' do
    load_mock('moon_waning_crescent')
    send_command 'moon'
    expect(replies.last).to eq('🌘 Moon phase 15%, Waning Crescent.  Rise: 11:45  Set: 22:16')
  end

  it 'waxing crescent' do
    load_mock('moon_waxing_crescent')
    send_command 'moon'
    expect(replies.last).to eq('🌒 Moon phase 13%, Waxing Crescent.  Rise: 11:45  Set: 22:16')
  end

  it 'first_quarter' do
    load_mock('moon_first_quarter')
    send_command 'moon'
    expect(replies.last).to eq('🌓 Moon phase 35%, First Quarter.  Rise: 11:45  Set: 22:16')
  end

  it 'last quarter' do
    load_mock('moon_last_quarter')
    send_command 'moon'
    expect(replies.last).to eq('🌗 Moon phase 35%, Last Quarter.  Rise: 11:45  Set: 22:16')
  end

  it 'waning gibbous' do
    load_mock('moon_waning_gibbous')
    send_command 'moon'
    expect(replies.last).to eq('🌖 Moon phase 75%, Waning Gibbous.  Rise: 11:45  Set: 22:16')
  end

  it 'waxing gibbous' do
    load_mock('moon_waxing_gibbous')
    send_command 'moon'
    expect(replies.last).to eq('🌔 Moon phase 75%, Waxing Gibbous.  Rise: 11:45  Set: 22:16')
  end

  it 'marses' do
    load_mock('mars')
    send_command 'mars'
    expect(replies.last).to eq("Sol 2108, Month 7, A Sunny day with a min temp of -65 and a high of -24 Celsius.  Sunrise is at 05:19 and sunset occurs at 17:27.")
  end
end
