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
    actual_start_time= Time.strptime(row[3], "%m/%d/%y %H:%M:%S")
    actual_end_time= Time.strptime(row[4], "%m/%d/%y %H:%M:%S")
    observation_date= Date.strptime(row[5], "%m/%d/%y")
    activity = activities.find { |a| a[:code] == row[2] }
    category = categories.find { |c| c[:code] == activity[:category_code] }

    data << {
        id: row[0],
        observation_id: row[1],
        category_code: category[:code],
        # category_label: category[:label],
        # category_color: category[:color],
        # activity_code: row[2],
        # activity_label: activity[:label],
        # activity_color: activity[:color],
        actual_start_time: actual_start_time,
        actual_start_time_sec: actual_start_time.to_i,
        actual_end_time: actual_end_time,
        actual_end_time_sec: actual_end_time.to_i,
        duration: (actual_end_time - actual_start_time).to_i,
        start_since_midnight: actual_start_time.seconds_since_midnight.to_i,
        end_since_midnight: actual_end_time.seconds_since_midnight.to_i
        # observation_date: observation_date,
        # notes: row[6]
    }
  rescue StandardError => ex
    puts row
    raise ex
  end
end

File.write("./data/data.json", JSON.generate({categories: categories, data: data}))
