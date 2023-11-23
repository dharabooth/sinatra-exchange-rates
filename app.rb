require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

currency_key = ENV.fetch("EXCHANGE_RATE_KEY")


api_url = "https://api.exchangerate.host/list?access_key=#{currency_key}"

  raw_currency_data = HTTP.get(api_url)
  currency_string = raw_currency_data.to_s
  parsed_currency_data = JSON.parse(currency_string)
  main_hash = parsed_currency_data.fetch("currencies")
  abbreviations = main_hash.keys

get("/") do

  @abbrev_list = []

  abbreviations.each do |abbrev|
    @abbrev_list.push(abbrev)
  end

  erb(:homepage)
end

get("/:country_code") do
  @main_country = params.fetch("country_code").to_s

  @abbrev_list = []

  abbreviations.each do |abbrev|
    @abbrev_list.push(abbrev)
  end
  
  erb(:conversion_list)
end

get("/:country_code/:convert") do

  @main_country = params.fetch("country_code").to_s
  @converting_country = params.fetch("convert").to_s

  exhange_url = "https://api.exchangerate.host/convert?access_key=#{currency_key}&from=#{@main_country}&to=#{@converting_country}&amount=1"

  conversion_raw_data = HTTP.get(exhange_url)
  exchange_string = conversion_raw_data.to_s
  parsed_exchange_data = JSON.parse(exchange_string)
  rates = parsed_exchange_data.fetch("result")

  @rate = rates.to_s

  erb(:specific_conversion)

end
