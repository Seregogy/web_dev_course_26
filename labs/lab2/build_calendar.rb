require_relative 'generator.rb'
require_relative 'parser.rb'
require_relative 'writer.rb'

if ARGV.length != 4
  raise "Не хватает аргументов"
end

total_teams = parse_teams(ARGV[0])
begining_date = Date.strptime(ARGV[1], '%d.%m.%Y')
ending_date = Date.strptime(ARGV[2], '%d.%m.%Y')

write_calendar_to_json(
  ARGV[3],
  generate_calendar(total_teams, begining_date, ending_date),
  total_teams  
)