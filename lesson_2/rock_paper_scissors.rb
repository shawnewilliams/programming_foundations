def win?(first, second)
  first == 'rock' && second == 'scissors' ||
    first == 'paper' && second == 'rock' ||
    first == 'scissors' && second == 'paper'
end

def display_results(player, computer)
  if win?(player, computer)
    prompt "You won!"
  elsif win?(computer, player)
    prompt "Computer won!"
  else
    prompt "Its a tie!"
  end
end

def prompt(message)
  puts "=> #{message}"
end

VALID_CHOICES = %w(rock paper scissors)

loop do # main loop
  choice = ''
  loop do
    prompt "Choose one: #{VALID_CHOICES.join(', ')}"
    choice = gets.chomp

    if VALID_CHOICES.include?(choice)
      break
    else
      prompt "That's not a valid choice."
    end
  end

  computer_choice = VALID_CHOICES.sample

  prompt "You chose: #{choice}. Computer chose: #{computer_choice}"

  display_results(choice, computer_choice)

  prompt "Do you want to play again? (Y or N)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thank you for playing. Good Bye!"
