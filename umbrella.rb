require "http"
require "json"
require "dotenv/load"

pp "Hi! This is your Umbrella. To know whether it's going to rain or not, we need to know where you are! Where are you?"
user_location = gets.chomp
# user_location = "474 N Lake Shore Dr"
pp user_location
maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

resp = HTTP.get(maps_url)
raw_response = resp.to_s
parsed_response = JSON.parse(raw_response)
results = parsed_response.fetch("results")
first_result = results.at(0)
geo = first_result.fetch("geometry")
loc = geo.fetch("location")
pp latitude = loc.fetch("lat")
pp longitude = loc.fetch("lng")
