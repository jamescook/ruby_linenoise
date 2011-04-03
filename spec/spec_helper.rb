lib = File.expand_path('../../', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "linenoise"

RSpec.configure do
  def fixture_path
    File.join( File.dirname(__FILE__), "fixtures" )
  end
end
