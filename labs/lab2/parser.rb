Struct.new("Team", :id, :name, :city)

def parse_teams(file_path)
  res = Hash.new()
  File.readlines(file_path).each { |line|
    splitted_outer = line.split('.')
    splitted_inner = splitted_outer[1].split('—').map { |i| i.strip}
    id = splitted_outer[0].to_i

    res[id] = Struct::Team.new(
      id,
      splitted_inner[0].strip,
      splitted_inner[1].strip
    )
  }

  res
end