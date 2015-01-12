Gem::Specification.new do |spec|
  spec.date        = '2015-01-12'
  spec.version     = '0.0.2'
  spec.name        = 'play_hangman'
  spec.summary     = %q(Play HANGMAN on your console! Install, run the command 'play_hangman' and enjoy.)
  spec.description =
    [
      "Play HANGMAN on your console! Install, run the command 'play_hangman' and enjoy.",
      "This game was built using the 'hangman_engine' gem. Check it out to build your own HANGMAN version.",
    ].join("\n")
  spec.license     = 'MIT'
  spec.homepage    = 'https://github.com/ammancilla/play_hangman'
  
  spec.authors     = ['Alfonso Mancilla']
  spec.email       = ['almancill@gmail.com']
  
  spec.files       = ['lib/play_hangman.rb']
  spec.executables = 'play_hangman'
  
  spec.add_runtime_dependency 'console_view_helper', ['~> 0.0.4']
  spec.add_runtime_dependency 'hangman_engine', ['~> 0.0.1']
end