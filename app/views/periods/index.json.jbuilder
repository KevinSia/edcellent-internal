json.array!(@periods) do |period|
  json.extract! period, :id, :note, :description
  json.tutor period.tutor.name
  array = []
  period.group.users.each do |user|
    array << user.name
  end
  if period.period_status == "done"
    json.color "blue"
  else
    json.color "red"
  end
  json.student array.join(", ")
  json.start period.start_time
  json.end period.end_time
  # json.url period_url(period, format: :html)
  json.update_url period_path(period, method: :patch)
  json.edit_url edit_period_path(period)
end