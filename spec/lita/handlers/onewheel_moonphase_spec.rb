require 'spec_helper'

describe Lita::Handlers::OnewheelMoonphase, lita_handler: true do
  it { is_expected.to route_command('moon') }
  it { is_expected.to route_command('moon portland') }

  it 'shows the current moon phase.' do
    mock = File.open('spec/fixtures/moon.json').read
    allow(RestClient).to receive(:get) { mock }
    send_command 'moon'
    expect(replies.last).to eq('Moon phase 36%, Waxing Crescent.  Rise: 11:45  Set: 22:16')
  end
end
