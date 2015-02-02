# This file needs to be run with bundler like this:
# bundle exec ruby main.rb
require 'csv'
require 'time'
require 'date'
require 'json'
require 'active_support/time'

categories = []
CSV.foreach("./data/Activity_Tracking_db_4_category.csv", headers: true) do |row|
  categories << {code: row[0], label: row[1], color: row[2]}
end

# puts categories

activities = []
CSV.foreach("./data/Activity_Tracking_db_4_activity.csv", headers: true) do |row|
  activities << {code: row[0], category_code: row[1], theme_code: row[2], label: row[3], color: row[4]}
end

# puts activities

data = []
CSV.foreach("./data/Activity_Tracking_db_4_data.csv", headers: true) do |row|
  begin
    actual_start_time= Time.strptime(row[4], "%m/%d/%y %H:%M:%S")
    actual_end_time= Time.strptime(row[5], "%m/%d/%y %H:%M:%S")
    # observation_date= Date.strptime(row[8], "%m/%d/%y")
    # activity = activities.find { |a| a[:code] == row[2] }
    category = categories.find { |c| c[:label] == row[3] }

    parsed ={
        id: row[0],
        observation_id: row[1],
        category_code: category[:code],
        start_since_midnight: actual_start_time.seconds_since_midnight.to_i,
        end_since_midnight: actual_end_time.seconds_since_midnight.to_i
    }
    data << parsed
  rescue StandardError => ex
    puts row
    raise ex
  end
end

File.write("./data/data.json", JSON.pretty_generate({categories: categories, data: data}))
