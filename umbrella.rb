require "http"
require "json"
require "dotenv/load"

pp "Hi! This is your Umbrella. To know whether it's going to rain or not, we need to know where you are! Where are you?"
# user_location = gets.chomp
user_location = "Clarksville, Tennessee"
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
currently = parsed_response.fetch("currently")
current_temp = currently.fetch("temperature").to_s
current_precip_int = currently.fetch("precipIntensity").to_s
hourly = parsed_response.fetch("hourly")
# summary = hourly.fetch("summary")
if current_precip_int.to_i == 0
  pp "Right now, at " + user_location + ", the temperature is " + current_temp + "ºF, and it is not raining."
else
pp "Right now, at " + user_location + ", the temperature is " + current_temp + "ºF, and it is raining."
end

hourly_data = hourly.fetch("data")
next_twelve = hourly_data[1..12]
next_twelve.each do |hour|
  epoch_time = hour.fetch("time")
  utc_time = Time.at(epoch_time)
  seconds_from_now = utc_time - Time.now
  hours_from_now = seconds_from_now / 60 / 60
  rounded_hfn = hours_from_now.round
    if rounded_hfn == 1
       pp "In " + rounded_hfn.to_s + " hour from now:"
    else
      pp "In " + rounded_hfn.to_s + " hours:"
    end
  pp hour.fetch("summary")
  pp hour.fetch("precipIntensity")
  pp hour.fetch("precipProbability")
end
