task :default => :piedrapapeltijera

desc "Ejecutar piedrapapeltijera en el servidor thin (puerto 9292)"
task :piedrapapeltijera do
  sh "ruby piedrapapeltijera.rb"
end

desc "Ejecutar el cliente con piedra"
task :rock do
  sh "ruby piedrapapeltijera.rb ; curl -v 'http://localhost:9292?choice=rock'"
end

desc "Ejecutar el cliente con papel"
task :paper do
  sh "ruby piedrapapeltijera.rb ; curl -v 'http://localhost:9292?choice=paper'"
end

desc "Ejecutar el cliente con tijeras"
task :scissors do
  sh "ruby piedrapapeltijera.rb ; curl -v 'http://localhost:9292?choice=scissors'"
end
