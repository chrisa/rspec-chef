require 'rspec'

$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))
require 'rspec-chef'

COOKBOOKS = File.expand_path('../fixtures/cookbooks', __FILE__)

RSpec.configure do |c|
  c.default_attributes = {
    'platform' => 'testing',
    'platform_version' => '1.0',
  }
end
