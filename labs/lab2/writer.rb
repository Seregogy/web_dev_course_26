require  'json'

Struct.new("Event", :date, :day_name, :games)
Struct.new("Game", :time, :teams)

def write_calendar_to_json(output_file_name, raw_data, teams)
    times = [ 
        "12:00", 
        "15:00", 
        "18:00" 
    ]
    day_names_by_indexes = {
        0 => "Воскресенье",
        5 => "Пятница",
        6 => "Суббота"
    }

    prepared_data = raw_data.compact.map { |k, v|
        Struct::Event.new(
            date: k.strftime('%d %B, %Y'),
            day_name: day_names_by_indexes[k.wday],
            games: v.map.with_index { |raw_teams, index|
                Struct::Game.new(
                    time: times[index],
                    teams: raw_teams.map { |team_id|
                        teams[team_id].to_h
                    } 
                ).to_h
            }
        ).to_h
    }

    File.write(output_file_name, JSON.pretty_generate(prepared_data))
end 