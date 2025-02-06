require "http"
require "json"
require "dotenv/load"

pp "Hi! This is your Umbrella. To know whether it's going to rain or not, we need to know where you are! Where are you?"
user_location = gets.chomp
# user_location = "474 N Lake Shore Dr"
pp user_location
maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

# GEOCODING
resp = HTTP.get(maps_url)
raw_response = resp.to_s
parsed_response = JSON.parse(raw_response)
results = parsed_response.fetch("results")
first_result = results.at(0)
geo = first_result.fetch("geometry")
loc = geo.fetch("location")
latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

# TEMP RETRIEVAL
pirate_weather_url = "https://api.pirateweather.net/forecast/" + ENV.fetch("PIRATE_WEATHER_KEY") + "/" + latitude.to_s + "," + longitude.to_s
resp = HTTP.get(pirate_weather_url)
raw_response = resp.to_s
parsed_response = JSON.parse(raw_response)
pp parsed_response
