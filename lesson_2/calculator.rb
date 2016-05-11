# ask the user for two numbers
# ask the user for an operation to perform
# perform the operation on the two numbers
# output the result

# answer = gets
# puts answer
require 'yaml'

LANGUAGE = 'en'

MESSAGES = YAML.load_file('calc_messages.yml')

def messages(message, lang='en')
  MESSAGES[lang][message]
end

def prompt(key)
  message = messages(key, LANGUAGE)   # make sure the "messages" method is declared above this line
  puts("=> #{message}")
end

def valid_number?(num)
  num.to_f.to_s == num || num.to_i.to_s == num
end

def operation_to_message(opp)
  word = case opp
  when '1'
    MESSAGES[LANGUAGE]['add']
  when '2'
    MESSAGES[LANGUAGE]['sub']
  when '3'
    MESSAGES[LANGUAGE]['mult']
  when '4'
    MESSAGES[LANGUAGE]['div']
  end
  puts "..."
  word
end

prompt('welcome')

name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt('valid_name')
  else
    break
  end
end

puts ("=>#{MESSAGES[LANGUAGE]['hi']} #{name}#{MESSAGES[LANGUAGE]['exc']}")

loop do # main loop
  number1 = ''
  loop do
    prompt('first_num')
    number1 = gets.chomp

    if valid_number?(number1)
      break
    else
      prompt('valid_num')
    end
  end

  number2 = ''

  loop do
    prompt('second_num')
    number2 = gets.chomp

    if valid_number?(number2)
      break
    else
      prompt('valid_num')
    end
  end

  operator_prompt = ('msg')
  prompt(operator_prompt)

  operator = ''
  loop do
    operator = gets.chomp

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt('valid_opp')
    end
  end

  puts("=>#{operation_to_message(operator)} " + MESSAGES[LANGUAGE]['operating'])

  result =  case operator
            when '1'
              number1.to_i + number2.to_i
            when '2'
              number1.to_i - number2.to_i
            when '3'
              number1.to_i * number2.to_i
            when '4'
              number1.to_f / number2.to_f
            end

  puts("=>#{MESSAGES[LANGUAGE]['result']} #{result}")

  prompt('repeat')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('bye')
