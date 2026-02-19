require 'date'
require 'json'

Struct.new("Team", :id, :name, :city, :played_teams)

def parse_teams(file_path)
  File.readlines(file_path).map { |line|
    splitted_outer = line.split('.')
    splitted_inner = splitted_outer[1].split('—').map { |i| i.strip}

    Struct::Team.new(
      splitted_outer[0].to_i,
      splitted_inner[0].strip,
      splitted_inner[1].strip,
      Array.new()
    )
  }
end

def generate_calendar(teams, begin_date, end_date)
  generate_dates_in_range(begin_date, end_date).map { |day|
    
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

if ARGV.length != 4
  raise "Не хватает аргументов"
end

total_teams = parse_teams(ARGV[0])
begining_date = Date.strptime(ARGV[1], '%d.%m.%Y')
ending_date = Date.strptime(ARGV[2], '%d.%m.%Y')

# puts total_teams
# puts begining_date
# puts ending_date

generate_calendar(total_teams, begining_date, ending_date)
