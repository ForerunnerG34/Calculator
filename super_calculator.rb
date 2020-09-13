# frozen_string_literal: true

def precedence?(left, right)
  precedence = {}
  precedence['*'] = 3
  precedence['/'] = 3
  precedence['+'] = 2
  precedence['-'] = 2
  precedence['('] = 1

  precedence[left] >= precedence[right]
end

def calculate(num1, num2, opr)
  case opr
  when '*'
    num1 * num2
  when '/'
    num1 / num2
  when '+'
    num1 + num2
  when '-'
    num1 - num2
  end
end

def push_operator(character, operators_stack, expression_stack)
  while !operators_stack.empty? && precedence?(operators_stack.last, character)
    expression_stack.push operators_stack.pop
  end

  operators_stack.push(character)
end

def push_number_and_operator(character, number, operators_stack, expression_stack)
  # push the number
  expression_stack.push number unless number.empty?

  if character == '('
    operators_stack.push(character)
  elsif character == ')'
    # push the operator into the result stack and then remove the inserted '('
    expression_stack.push operators_stack.pop
    operators_stack.pop
  else
    # push the operator based on the precedence
    push_operator(character, operators_stack, expression_stack)
  end
end

def push_remaining_number_and_opertors(number,  operators_stack, expression_stack)
  expression_stack.push number unless number.empty?

  # push the remaining operators at the end
  until operators_stack.empty? do expression_stack.push operators_stack.pop end

  expression_stack
end

def convert_to_postfix(input, operators_stack, expression_stack, numbers)
  number = ''

  input.each_char do |c|
    if numbers.include? c
      # if is a number, start capturing the digits of the number before pushing it into the stack
      number += c
    else
      # insert the whole number and then the operator
      push_number_and_operator(c, number, operators_stack, expression_stack)
      number = ''
    end
  end

  # push remaining symbols from the stack and return the postfix stack.
  push_remaining_number_and_opertors(number,  operators_stack, expression_stack)
end

def calculate_postfix(expression_stack, result_stack, operators)
  # Scan the postfix stack one by one
  expression_stack.each do |c|
    # If the scanned character is a number, push it to the result stack
    if !operators.include? c
      result_stack.push c
    else
      # If the scanned character is an operator, pop to numbers from the results stack and apply the operator
      n2 = result_stack.pop
      n1 = result_stack.pop
      result_stack.push calculate(n1.to_f, n2.to_f, c)
    end
  end

  result_stack.pop
end

title = 'WELCOME TO SUPER CALCULATOR'
puts title
title.length.times { print '=' }
puts
puts 'What do you want to calculate?'
# puts 'Examples:'
# puts  '5+9'
# puts  '3*12.3/67'
# puts  '((4+5)/6)*5.4'

input = gets.chomp.downcase

# convert expression to postfix format for easier calculation. (example: 4+3 => 43+)
numbers = '1234567890.'
expression_stack = []
operators_stack = []
result_stack = []
operators = '+-*/'

postfix = convert_to_postfix(input, operators_stack, expression_stack, numbers)

return 'Nothing to calculate' unless postfix.length >= 3

result = calculate_postfix(postfix, result_stack, operators)
puts result
