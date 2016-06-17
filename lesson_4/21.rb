DECK = { "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, +
         "7" => 7, "8" => 8, "9" => 9, "10" => 10, "Jack" => 10, +
         "Queen" => 10, "King" => 10, "Ace" => 11 }.freeze
MAX = 21
MIN = 17

H = "Hearts".freeze
D = "Diamonds".freeze
S = "Spades".freeze
C = "Clubs".freeze

def add_card
  [" --------- ",
   "|         |",
   "|         |",
   "|         |",
   "     ?     ",
   "           ",
   "|         |",
   "|         |",
   "|         |",
   " --------- "]
end

def first_card
  "









  "
end

def prompt(message)
  puts "=> #{message}"
end

def new_deck(num)
  deck = DECK.keys
  new_deck = []
  deck.each_index do |i|
    new_deck.push([deck[i], H])
    new_deck.push([deck[i], D])
    new_deck.push([deck[i], S])
    new_deck.push([deck[i], C])
  end
  new_deck * num
end

def card(deck)
  deck.delete_at(deck.find_index(deck.sample))
end

def add_to_hand(hand, card)
  hand.push(card)
end

def cards_in_hand(cards, card)
  new_line = ''
  count = 0

  new_card = add_card

  cards.each_line do |line|
    new_line += if count == 4
                  line.chomp + "   #{card[0].center(10)}\n"
                elsif count == 5
                  line.chomp + "   #{card[1].center(10)}\n"
                else
                  line.chomp + "  #{new_card[count]}\n"
                end
    count += 1
  end
  cards.replace new_line
end

def computer_cards_in_hand(cards)
  new_line = ''
  count = 0
  new_card = add_card

  cards.each_line do |line|
    new_line += line.chomp + "  #{new_card[count]}\n"
    count += 1
  end
  cards.replace new_line
end

def shuffle?(deck)
  if deck.empty?
    puts
    puts "The deck is empty. Time to shuffle"
    deck.concat new_deck(1)
    puts
    sleep(1)
  end
end

def deal(player, hand, deck, cards)
  shuffle?(deck)
  add_to_hand(hand, card_1 = card(deck))
  shuffle?(deck)
  add_to_hand(hand, card_2 = card(deck))
  puts "#{player}'s Hand:"
  cards_in_hand(cards, card_1)
  if player == "Computer"
    puts computer_cards_in_hand(cards)
    cards.replace first_card
    cards_in_hand(cards, card_1)
    cards_in_hand(cards, card_2)
  else
    puts cards_in_hand(cards, card_2)
  end
end

def hit(player, hand, deck, cards)
  shuffle?(deck)
  add_to_hand(hand, card = card(deck))
  puts "#{player}'s Hand:"
  puts cards_in_hand(cards, card)
end

# rubocop:disable MethodLength
def total(hand)
  total = 0
  aces = 0
  hand.each do |card|
    if card[0] == "Ace"
      aces += 1
    else total += DECK[card[0]]
    end
  end
  if aces > 0
    aces.times do
      total += if total + 11 > MAX
                 1
               else
                 11
               end
    end
  end
  total
end

def display_total(player, hand)
  puts "#{player}'s total = #{total(hand)}"
  puts
end

def busted?(hand)
  total(hand) > MAX
end

# rubocop:disable CyclomaticComplexity, PerceivedComplexity
def won?(hand1, hand2)
  if busted?(hand2) &&
     !busted?(hand1)
    :hand2_busted
  elsif busted?(hand1) &&
        !busted?(hand2)
    :hand1_busted
  elsif busted?(hand1) &&
        busted?(hand2)
    nil
  elsif total(hand1) > total(hand2)
    :hand1
  elsif total(hand2) > total(hand1)
    :hand2
  else
    :tie
  end
end
# rubocop:enable CyclomaticComplexity, PerceivedComplexity
# rubocop:enable MethodLength

def display_winner(player1, player2, hand1, hand2)
  result = won?(hand1, hand2)
  case result
  when :hand2_busted
    puts "#{player2} Busted. #{player1} WINS!"
  when :hand1_busted
    puts "#{player1} Busted. #{player2} WINS!"
  when :hand1
    puts "#{player1} WINS!"
  when :hand2
    puts "#{player2} WINS!"
  when :tie
    puts "Its a TIE."
  end
end

def h_or_s?(ans)
  ans.casecmp('h') == 0 || ans.casecmp('s') == 0
end

def y_or_n?(ans)
  ans.casecmp('y') == 0 || ans.casecmp('n') == 0
end

def valid_num(num, cash)
  /\d/.match(num) && /^\d*\.?\d*$/.match(num) && num.to_i <= cash
end

def clear_screen
  system('clear') || system('cls')
end

# Strat program
# *****************************************************

clear_screen
deck = new_deck(1)
cash = 100
player = ''
prompt "Let's play #{MAX}."
prompt "What is your name?"
loop do
  player = gets.chomp
  if player.empty?
    prompt "How do I know who's playing if you don't enter a name?"
    prompt "What is your name?"
  else
    break
  end
end

prompt "Hello #{player}!"
puts

loop do # Game loop
  bet = 0
  prompt "You have $#{cash}."
  prompt "How much would you like to bet"
  bet = gets.chomp
  loop do
    break if valid_num(bet, cash)
    prompt "That's not a valid number. Please try again."
    bet = gets.chomp
  end
  player_hand = []
  player_cards = first_card
  computer_hand = []
  computer_cards = first_card

  clear_screen

  # Deal ************
  puts
  deal("Computer", computer_hand, deck, computer_cards)
  computer_total = total(computer_hand)
  puts "Computer Showing #{DECK[computer_hand[0][0]]}"
  puts
  puts "---------------------------"
  puts
  deal(player, player_hand, deck, player_cards)
  player_total = total(player_hand)
  puts "#{player}'s Total = #{player_total}"
  puts

  bet = bet.to_i
  if player_total == 21 && computer_total != 21
    bet *= 1.5
  end

  # Player turn ************************************
  loop do
    prompt "Hit or Stay? (H or S)"
    answer = gets.chomp
    loop do
      if h_or_s?(answer)
        break
      else
        prompt "That's not a valid answer. Enter H or S"
        answer = gets.chomp
      end
    end

    if answer.casecmp('s') == 0
      puts "#{player} Stays at #{player_total}"
      puts
      break
    end
    puts
    puts "#{player} Hits at #{player_total}"
    puts
    clear_screen
    hit(player, player_hand, deck, player_cards)
    player_total = total(player_hand)
    puts "#{player}'s Total = #{player_total}"
    puts
    next unless busted?(player_hand)
    puts "#{player} Busted!"
    sleep(2)
    puts
    break
  end
  # End player turn ******************************

  clear_screen

  puts "Computer's Hand"
  puts computer_cards
  puts "Computer's Total = #{computer_total}"

  # Computer turn ************************************
  loop do
    sleep(1)
    break if busted?(player_hand)
    if computer_total >= MIN
      puts
      puts "Computer Stays"
      sleep(1)
      break
    end
    puts
    puts "Computer Hits"
    sleep(1)
    clear_screen
    hit("Computer", computer_hand, deck, computer_cards)
    computer_total = total(computer_hand)
    puts "Computer's Total = #{computer_total}"
    next unless busted?(computer_hand)
    puts
    puts "Computer Busted!"
    sleep(1)
    break
  end
  # End computer turn ******************************

  clear_screen
  puts "#{player}'s Hand"
  puts player_cards
  puts "#{player}'s Total = #{player_total}"
  puts
  puts puts "Computer's Hand"
  puts computer_cards
  puts "Computer's Total = #{computer_total}"
  puts
  puts "---------------------------"
  puts

  display_winner(player, "Computer", player_hand, computer_hand)
  puts

  result = won?(player_hand, computer_hand)
  case result
  when :hand1
    cash += bet
  when :hand2_busted
    cash += bet
  when :hand2
    cash -= bet
  when :hand1_busted
    cash -= bet
  end

  puts "You have $#{cash}"
  puts

  if cash == 0
    puts "Ha ha! I have all your money. Better luck next time!"
    break
  end

  prompt "Would you like to keep playing? (Y or N)"
  answer = gets.chomp
  loop do
    if y_or_n?(answer)
      break
    else
      prompt "That not a valid answer. Please type Y or N."
      answer = gets.chomp
    end
  end
  break if answer.casecmp('n') == 0
  clear_screen
end # End game loop
puts "Thanks for playing. Goodbye!"
puts
