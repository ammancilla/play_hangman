# Encoding: utf-8
# ----------------------------- PLAY HANGMAN -------------------------------
# 
# Ready to play console version of HANGMAN built using 'hangman_engine' gem
# 
# --------------------------------------------------------------------------

# General requires
require 'rbconfig'
require 'hangman_engine'
require 'console_view_helper'
include ConsoleViewHelper

# Windows requires
if (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
  begin
    require 'win32console'
  rescue LoadError
    error_msg = nl + banner('ERROR', subtitle: "win32console gem is missing") + nl
    error_msg << "To solve this error install win32console gem. Just run: 'gem install win32console'."
    abort error_msg
  end
end

# --- Helper Methods
def display_notice(notice)
  putsi(colorize(notice[:msg], notice[:status]) + nl(2)) if notice[:msg]
end

def display_game_banner(base_width, base_idt)
  puts nl + banner('HANGMAN GAME', subtitle: 'by Alfonso Mancilla', width: base_width, indent: base_idt) + nl
end

def display_game_board(hangman_game, base_width, base_idt, notice = {})
  cls
  display_game_banner(base_width, base_idt)
  display_notice(notice)
  putsi "Clue: '#{hangman_game.clue}'" + nl(3) if hangman_game.clue.length > 0
  putsi "Remaining attemps: #{hangman_game.remaining_attempts}" + nl(3)
  puts HangmanEngine::Drawer.draw_puppet(hangman_game).split("\n").map { |part| align(part, base_width + 15, :center) }.join("\n") + nl(3)
  game_board = HangmanEngine::Drawer.draw_board(hangman_game)
  putsi align(game_board, base_width, :center) + nl(3)
end

def display_won(base_width)
  putsi align('*          *   * * * *   *     *', base_width, :center)
  putsi align('*          *   *     *   * *   *', base_width, :center)  
  putsi align('*    **    *   *     *   *  *  *', base_width, :center)
  putsi align(' *  *  *  *    *     *   *   * *' , base_width, :center)
  putsi align('  **    **     * * * *   *    **', base_width, :center)
end

def display_lost(base_width)
  putsi align('* * * *  * * * *  *       *  * * * *', base_width, :center)
  putsi align('*        *     *  * *   * *  *      ', base_width, :center)
  putsi align('* * * *  * * * *  *  * *  *  * * *  ', base_width, :center)
  putsi align('*     *  *     *  *   *   *  *      ', base_width, :center)
  putsi align('* * * *  *     *  *       *  * * * *', base_width, :center)
  puts nl
  putsi align('* * * *  *      *  * * * *  * * * *' , base_width, :center)
  putsi align('*     *  *      *  *        *     *' , base_width, :center)
  putsi align('*     *   *    *   * * *    * * * *' , base_width, :center)
  putsi align('*     *    *  *    *        *    * ' , base_width, :center)
  putsi align('* * * *     **     * * * *  *     *', base_width, :center)
end

# --- Main
base_idt, base_width, keep_playing  = 1, 50, 'y'

while keep_playing == 'y'
  notice = {}
  begin
    # Read data
    data_error = false
    begin
      cls
      display_game_banner(base_width, base_idt)
      display_notice(notice)
      word = hidden_input('Word to guess (will be hidden):', base_idt)
      puts nl(2)
      allowed_attempts = input("Allowed attempts (>= #{word.length}):", base_idt)
      puts nl
      clue = input("Clue:", base_idt)
      hangman_game = HangmanEngine::Game.new(word, allowed_attempts, clue)
    rescue HangmanEngine::GameError => e
      notice = { msg: e.message, status: :error }
      data_error = true
    end
  end while data_error

  # Gameplay
  notice = {}
  until hangman_game.finished?
    begin
      display_game_board(hangman_game, base_width, base_idt, notice)
      ltr = input('Your guess:', 1)
      raise HangmanEngine::GameError, "Type a letter!" unless ltr.length > 0
      hangman_game.guess(ltr.length > 1 ? ltr[0] : ltr)
      notice = if hangman_game.guessed?(ltr)
        { msg: "'#{ltr}' guessed!", status: :success }
      else
        { msg: "Ouuuch! burned :/", status: :error }
      end
    rescue HangmanEngine::GameError => e
      notice = { msg: e.message, status: :error }
    end
  end

  # Result
  display_game_board(hangman_game, base_width, base_idt)
  putsi underscore * base_width + nl(3)
  if hangman_game.solved? 
    display_won(base_width)
    puts nl
  else
    display_lost(base_width)
    puts nl(2)
    putsi align("Answer: #{hangman_game.word}", base_width, :center) + nl(2)
  end
  putsi underscore * base_width + nl(3)

  # Play again?
  keep_playing = input('New game? (y/n):', 1)[0].downcase
end
cls