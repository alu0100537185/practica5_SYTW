require 'rack/request'
require 'rack/response'
require 'haml'
require 'rack'
  
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

			 def set_env(env)
                                @env = env
                                @session = env['rack.session']
                        end

                        def getwin
                                return @session['won'].to_i if @session['won']
                                @session['won'] = 0
                        end

                        def setwin=(value)
                                @session['won'] = value
                        end

                        def getlose
                                return @session['lost'].to_i if @session['lost']
                                @session['lost'] = 0
                        end

                        def setlose=(value)
                                @session['lost'] = value
                        end

                        def gettie
                                return @session['tied'].to_i if @session['tied']
                                @session['tied'] = 0
                        end

                        def settie=(value)
                                @session['tied'] = value
                        end

                        def getplay
                                return @session['play'].to_i if @session['play']
                                @session['play'] = 0
                        end

                        def setplay=(value)
                                @session['play'] = value
                        end
  
      def call(env)
        set_env(env)
        req = Rack::Request.new(env)
  
        req.env.keys.sort.each { |x| puts "#{x} => #{req.env[x]}" }
  
        computer_throw = @throws.sample
        player_throw = req.GET["choice"]
        answer = if !@throws.include?(player_throw)
            "Elige una opcion entre piedra, papel o tijera:"
          elsif player_throw == computer_throw
						self.setplay=self.getplay+1
                                                self.settie=self.gettie+1
            "Has empatado con la computadora"
          elsif computer_throw == @defeat[player_throw]
						self.setplay=self.getplay+1
                                                self.setwin=self.getwin+1
            "Bien hecho; #{player_throw} vence a #{computer_throw}"
          else
						self.setplay=self.getplay+1
                                                self.setlose=self.getlose+1
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
					:win => self.getwin,
                                        :lose => self.getlose,
                                        :tie => self.gettie,
                                        :play => self.getplay,
               :throws => @throws,
	       :computer_throw => computer_throw,
	)
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
