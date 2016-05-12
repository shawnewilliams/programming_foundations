# loan_calc.rb

# Methods
def prompt(message)
  puts"=>#{message}"
end

def valid_num?(num)
  /\d/.match(num) && /^\d*\.?\d*$/.match(num)
end

def monthly_rate(rate)
  (rate.to_f / 12) / 100
end

def years_to_months(yrs)
  yrs.to_f * 12
end

def print_monthly_pmt(total, interest, yrs)
  c = monthly_rate(interest)
  n = years_to_months(yrs)
  payments = total.to_f * ((c * (1 + c)**n) / ((1 + c)**n - 1))
  format("$%.2f", payments)
end

def print_no_interest_pmt(total, yrs)
  payments = total.to_f / years_to_months(yrs)
  format("$%.2f", payments)
end

def y_or_n?(answer)
  answer.casecmp('y') == 0 || answer.casecmp('n') == 0
end

# Start program

prompt "Welcome to Loan Calculator"
puts "------------------------------"

loop do # main loop
  amount = ''
  prompt "What is the loan amount?"

  loop do
    amount = gets.chomp
    if valid_num?(amount) && amount.to_f > 0
      break
    else
      prompt "Hmm... That doesn't look like a valid number. Please try again."
    end
  end

  apr = ''
  prompt "What is the annual Percentage Rate (APR)?"
  prompt "(Example 5 = 5% and 5.5 = 5.5%)"
  loop do
    apr = gets.chomp
    if valid_num?(apr) && apr.to_f >= 0
      break
    else
      prompt "Hmm... That doesn't look like a valid number. Please try again."
    end
  end
  years = ''
  prompt "Please enter the loan duration in years."

  loop do
    years = gets.chomp
    if valid_num?(years) && years.to_f > 0
      break
    else
      prompt "Hmm... That doesn't look like a valid number. Please try again."
    end
  end

  if apr.to_f == 0
    prompt "Your monthly payment is: #{print_no_interest_pmt(amount, years)}"
  else
    prompt "Your monthly payment is: #{print_monthly_pmt(amount, apr, years)}"
  end
  puts

  continue = ''
  prompt "Would you like to try a different amount? (Y or N)"
  loop do
    continue = gets.chomp
    if y_or_n?(continue)
      break
    else
      prompt "Hmm... That doesn't look like a valid answer. Pleas enter Y or N."
    end
  end

  break unless continue.casecmp('y') == 0
end

prompt "Good Bye!"
