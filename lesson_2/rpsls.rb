def win?(first, second)
  first == 'r' && second == 's' ||
    first == 'r' && second == 'l' ||
    first == 'p' && second == 'r' ||
    first == 'p' && second == 'sp' ||
    first == 's' && second == 'p' ||
    first == 's' && second == 'l' ||
    first == 'l' && second == 'sp' ||
    first == 'l' && second == 'p' ||
    first == 'sp' && second == 'r' ||
    first == 'sp' && second == 's'
end

def display_results(player, computer, name)
  if win?(player, computer)
    prompt "#{name} won this round!"
  elsif win?(computer, player)
    prompt "Computer won this round!"
  else
    prompt "Its a tie!"
  end
end

def prompt(message)
  puts "=> #{message}"
end

def y_or_n?(ans)
  ans.downcase == 'y' || ans.downcase == 'n'
end

VALID_CHOICES = { "r" => 'Rock', "p" => 'Paper', "s" => 'Scissors', "l" => 'Lizard', "sp" => 'Spock' }

prompt "Welcome to Rock, Paper, Scissors, Lizard, Spock."
prompt "What is your name?"

name = ''
loop do
  name = gets.chomp
  if name.empty?
    prompt "How do I know who's playing if you don't enter a name?"
    prompt "What is your name?"
  else
    break
  end
end

prompt "Hi #{name}!"
rules = <<-MSG
Here are the rules:
  -Scissors cuts Paper
  -Paper covers Rock
  -Rock crushes Lizard
  -Lizard poisons Spock
  -Spock smashes Scissors
  -Scissors decapitates Lizard
  -Lizard eats Paper
  -Paper disproves Spock
  -Spock vaporizes Rock
  -Rock crushes Scissors
MSG

prompt rules
puts "------------------------------"

loop do # main loop
  user_score = 0
  computer_score = 0
  loop do # scoring loop
    choice = ''
    loop do
      prompt "Choose one:"
      VALID_CHOICES.each do |key, value|
        prompt "For #{value}, type: #{key.upcase}"
      end

      choice = gets.chomp.downcase

      if VALID_CHOICES.key?(choice)
        break
      else
        prompt "That's not a valid choice."
      end
    end

    computer_choice = []
    VALID_CHOICES.each do |key, _|
      computer_choice.push(key)
    end

    computer_choice = computer_choice.sample

    prompt "#{name} chose: #{VALID_CHOICES[choice]} - Computer chose: #{VALID_CHOICES[computer_choice]}"

    display_results(choice, computer_choice, name)
    if win?(choice, computer_choice)
      user_score += 1
    elsif win?(computer_choice, choice)
      computer_score += 1
    end

    puts
    puts <<-MSG
SCORE:
#{name}: #{user_score}
Computer: #{computer_score}
MSG
    puts
    if user_score == 5
      prompt "#{name} wins with a score of #{user_score} to #{computer_score}"
      break
    elsif computer_score == 5
      prompt "The computer wins with a score of #{computer_score} to #{user_score}"
      break
    end
  end # end scoring loop

  prompt "Do you want to play again? (Y or N)"
  answer = gets.chomp

  if y_or_n?(answer) == false
    loop do
      prompt "That's not a valid answer. Please type Y or N."
      answer = gets.chomp
      break if y_or_n?(answer)
    end
  end
  break if answer.downcase == 'n'
end

prompt "Thank you for playing. Good Bye!"
