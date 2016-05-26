require 'pry'

INITIAL_MARKER = " ".freeze
PLAYER_MARKER = "X".freeze
COMPUTER_MARKER = "O".freeze
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals
GOES_FIRST = "choose"

def prompt(msg)
  puts "=>#{msg}"
end

def valid_num?(num)
  /\d/.match(num) && /^\d*\.?\d*$/.match(num)
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You are: #{PLAYER_MARKER} - Computer is: #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initalize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, delimiter=', ', word='or')
  arr[-1] = "#{word} #{arr.last}" if arr.size > 1
  arr.join(delimiter)
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd), ', ')})"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select{|k,v| line.include?(k) && v == INITIAL_MARKER}.keys.first
  else
    nil
  end
end

def computer_places_piece!(brd)
  square = nil

  # offense
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if square
  end
  
  # defense first
  if !square
    WINNING_LINES.each do |line|
      square = find_at_risk_square(line, brd, PLAYER_MARKER)
      break if square
    end
  end


  if !square && brd[5] == INITIAL_MARKER
    square = 5
  end
  # just pick a square
  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def yes_or_no?(ans)
  ans.casecmp("Y") == 0 || ans.casecmp("N") == 0
end

def place_piece!(brd, player)
  if player.odd?
    player_places_piece!(brd)

  else
    computer_places_piece!(brd)
  end
end

def alternate_player(player)
  player += 1
end


# End Methods
# ************************************************
prompt "Welcome to Tic Tac Tow. The first to 5 wins!"
prompt "Please #{GOES_FIRST} who goes first."
prompt "1 - Player"
prompt "2 - Computer"

current_player = gets.chomp
loop do 
   if valid_num?(current_player) && (1..2).include?(current_player.to_i)
    break
  else
    prompt "Thats not a valid number."
    prompt "1 - Player"
    prompt "2 - Computer"
    current_player = gets.chomp
  end
end
current_player = current_player.to_i
loop do # Play again loop
  player_score = 0
  computer_score = 0
  loop do # Score loop
    board = initalize_board
   

    loop do # Game loop
      display_board(board)
      place_piece!(board, current_player)
      current_player = alternate_player(current_player)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board)

    if someone_won?(board)
      prompt "#{detect_winner(board)} won this round!"
      if detect_winner(board) == 'Player'
        player_score += 1
        current_player = 1
      elsif detect_winner(board) == 'Computer'
        computer_score += 1
        current_player = 2
      end
    else
      prompt "It's a tie!"
      current_player -= 1
    end

    prompt "Computer Score #{computer_score}"
    prompt "Player Score #{player_score}"
      
 

  if player_score == 5 
    prompt 'Player wins!' 
    break
  elsif computer_score == 5
    prompt 'Computer wins!'
    break
  end
  sleep (2)
end
  
  prompt "Would you like to play again? (Y or N)"
  answer = gets.chomp

  loop do
    if yes_or_no?(answer)
      break
    else
      prompt "That's not a valid choice. Enter Y or N."
      answer = gets.chomp
    end
  end
  break if answer.casecmp('N') == 0
end

prompt "Thanks for playing Tic Tac Toe. Good Bye!"
