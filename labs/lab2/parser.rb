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