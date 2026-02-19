require 'date'
require 'set'
require_relative 'parser.rb'
require_relative 'writer.rb'

def generate_calendar(teams, begin_date, end_date)
  Struct.new("Rule", :condition, :stategy, :shift)
  
  combinations = generate_combinations(teams.length).to_a
  dates = generate_dates_in_range(begin_date, end_date)

  rules = [
    Struct::Rule.new(
      condition: -> (combinations, dates) { 
        combinations.length / 3 > dates.length 
      },
      stategy: -> (offset, combinations, date) {
        { date => combinations.drop(offset * 3).first(3) }
      },
      shift: 3
    ),
    Struct::Rule.new(
      condition: -> (combinations, dates) { 
        combinations.length / 2 > dates.length 
      },
      stategy: -> (offset, combinations, date) {
        { date => combinations.drop(offset * 2).first(2) }
      },
      shift: 2
    ),
    Struct::Rule.new(
      condition: -> (combinations, dates) { 
        combinations.length > dates.length 
      },
      stategy: -> (offset, combinations, date) {
        { date => combinations[offset] }
      },
      shift: 1
    ),
    Struct::Rule.new(
      condition: -> (combinations, dates) { true },
      stategy: -> (offset, combinations, date) {
        { date => [combinations[offset % combinations.length]] }
      },
      shift: 1
    )
  ]

  rule = rules.find { |rule| rule.condition.call(combinations, dates) == true }
  strategy = rule[1]
  step = rule[2]

  dates.map.with_index { |date, index|
    if index % step == 0
      strategy.call(index, combinations, date)
    end
  }
end

def generate_dates_in_range(begin_date, end_date)
  if end_date - begin_date <= 0
    raise "Дата начала раньше даты конца"
  end

  result = Array.new()
  necessary_days_of_week_indexes = [0, 5, 6]
  current_date = begin_date

  while current_date.wday != 0
    if necessary_days_of_week_indexes.include?(current_date.wday)
      result << current_date
    end

    current_date += 1
  end

  while current_date <= end_date
    result << current_date << current_date + 5 << current_date + 6
    current_date += 7
  end

  result
end

def generate_combinations(teams_amount) 
  set = Set.new()
  for i in 1..teams_amount do
    for j in 1..teams_amount do 
      if i == j
        next 
      end
      
      set.add([i, j].sort)
    end
  end

  set
end

if ARGV.length != 4
  raise "Не хватает аргументов"
end

total_teams = parse_teams(ARGV[0])
begining_date = Date.strptime(ARGV[1], '%d.%m.%Y')
ending_date = Date.strptime(ARGV[2], '%d.%m.%Y')

# puts total_teams
# puts begining_date
# puts ending_date

puts generate_calendar(total_teams, begining_date, ending_date)
