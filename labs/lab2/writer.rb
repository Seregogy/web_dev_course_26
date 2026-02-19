require  'json'

def write_calendar(data)

    
    File.write("output.txt", JSON.pretty_generate(data))
end 