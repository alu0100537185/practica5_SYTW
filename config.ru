require './piedrapapeltijera'

use Rack::Static, :urls => ["/public"]
run RockPaperScissors::App.new
