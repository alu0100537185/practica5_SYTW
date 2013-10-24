require 'rack/request'
require 'rack/response'
require 'haml'
  
module RockPaperScissors
    class App 
  
      def initialize(app = nil)
        @app = app
        @content_type = :html
        @defeat = {'rock' => 'scissors', 'paper' => 'rock', 'scissors' => 'paper'}
        @throws = @defeat.keys
        @choose = @throws.map { |x| 
           %Q{ <li><a href="/?choice=#{x}">#{x}</a></li> }
        }.join("\n")
        @choose = "<p>\n<ul>\n#{@choose}\n</ul>"
      end
  
      def call(env)
        req = Rack::Request.new(env)
  
        req.env.keys.sort.each { |x| puts "#{x} => #{req.env[x]}" }
  
        computer_throw = @throws.sample
        player_throw = req.GET["choice"]
        answer = if !@throws.include?(player_throw)
            "Elige una opcion entre piedra, papel o tijera:"
          elsif player_throw == computer_throw
            "Has empatado con la computadora"
          elsif computer_throw == @defeat[player_throw]
            "Bien hecho; #{player_throw} vence a #{computer_throw}"
          else
            "Vaya; #{computer_throw} vence a #{player_throw}. Suerte para la proxima"
          end

	if !answer.empty?
          answer.insert(0, "<b>Tu eleccion:</b> #{player_throw}, \n<b>Eleccion de la computadora:</b> #{computer_throw}, ")
        end
        engine = Haml::Engine.new File.open("views/index.haml").read
        res = Rack::Response.new
        res.write engine.render({},
               :answer => answer,
               :choose => @choose,
               :throws => @throws)
        res.finish
      end # call
    end   # App
  end     # RockPaperScissors
  
  if $0 == __FILE__
    require 'rack'
    Rack::Server.start(
      :app => Rack::ShowExceptions.new(
                Rack::Lint.new(
                  RockPaperScissors::App.new)), 
      :Port => 9292,
      :server => 'thin'
    )
  end
