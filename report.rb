require 'json'

board_id, auth_token = ARGV

puts 'Identifying current sprint...'
response = %x{
  curl --request GET \
  -s \
  --url 'https://firstleaf.atlassian.net/rest/agile/1.0/board/#{board_id}/sprint?state=active' \
  --header "Authorization: Basic #{auth_token}" \
  --header 'Accept: application/json'
}
active_sprint_json = JSON.parse(response)
active_sprint = active_sprint_json['values'] && active_sprint_json['values'].first

if !active_sprint
  puts 'No active sprint found'
  exit(0)
end

puts "Active sprint: #{active_sprint['name']}"

puts 'Requesting current sprint issues...'
response = %x{
  curl --request GET \
  -s \
  --url 'https://firstleaf.atlassian.net/rest/agile/1.0/board/#{board_id}/sprint/#{active_sprint['id']}/issue' \
  --header "Authorization: Basic #{auth_token}" \
  --header 'Accept: application/json'
}
issues_json = JSON.parse(response)

issues = issues_json.dig('issues')
content = issues.map do |issue|
  issue_fields = issue.dig('fields')
  summary = issue_fields.dig('summary')
  epic_summary = issue_fields.dig('epic', 'summary') || 'Other'
  status = issue_fields.dig('status', 'name')

  {
    summary: summary,
    epic: epic_summary,
    status: status
  }
end
by_epic = content.group_by { |issue| issue[:epic] }

results = []
by_epic.each do |epic, issues|
  results << "> *#{epic}*"
  by_status = issues.group_by { |issue| issue[:status] }
  by_status.each do |status, issues|
      results << " _#{status}_"
      issues.each { |i| results << " - #{i[:summary]}" }
  end
  results << ''
end

IO.popen('pbcopy', 'w') { |pipe| pipe.puts results.join("\n") }
puts "Report copied to your transfer area. Press ctrl+v/cmd+v to paste the results"
