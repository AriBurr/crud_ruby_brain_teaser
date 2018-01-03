require 'httparty'
require 'json'
require 'pry'

BASE_URL = "http://json-server.devpointlabs.com/api/v1"
ALL_USERS = HTTParty.get("#{BASE_URL}/users").parsed_response

def start_menu
  menu = ["All Users", "View Single User", "Add User", "Delete User", "Update User", "Quit"]
  puts "***** MAIN MENU *****"
  menu.each_with_index { |option, i| puts "[#{i + 1}] #{option}" }
  p "Please select an action:"
  action = gets.strip.to_i

  unless action === 6
    case action
      when 1
        view_all_users
      when 2
        view_single_user
      when 3
        add_user
      when 4
        delete_user
      when 5
        update_user
    end
    start_menu
  end

end

def view_all_users
  ALL_USERS.each_with_index do |user, i|
    puts "-----User ##{i + 1}------"
    puts "#{user['first_name']}"
    puts "#{user['last_name']}"
  end
end

def view_single_user
  view_all_users
  p "Please select user for more info:"
  action = gets.strip.to_i
  fetch_single_user(action)
end

def fetch_single_user(action)
  ALL_USERS.each_with_index do |user, i|
    if i + 1 === action
      single_user = HTTParty.get("#{BASE_URL}/users/#{user['id']}").parsed_response
      puts "User ID: #{single_user['id']}"
      puts "First Name: #{single_user['first_name']}"
      puts "Last Name: #{single_user['last_name']}"
      puts "Phone: #{single_user['phone_number']}"
    end
  end
end

def add_user
  p "Please input first name:"
  first_name = gets.strip

  p "Please input last name:"
  last_name = gets.strip

  p "Please input phone number:"
  phone_number = gets.strip

  HTTParty.post("#{BASE_URL}/users/",
    body: {
      'user[first_name]': first_name,
      'user[last_name]': last_name,
      'user[phone_number]': phone_number
    })
end

def update_user
  view_all_users
  p "Please select user to update:"
  action = gets.strip.to_i

  ALL_USERS.each_with_index do |user, i|
    if i + 1 === action
      p "Please input first name:"
      first_name = gets.strip

      p "Please input last name:"
      last_name = gets.strip

      p "Please input phone number:"
      phone_number = gets.strip

      HTTParty.put("#{BASE_URL}/users/#{user['id']}",
        body: {
          'user[first_name]': first_name,
          'user[last_name]': last_name,
          'user[phone_number]': phone_number
        })
    end
  end
  
end

def delete_user
  view_all_users
  p "Please select user to delete:"
  action = gets.strip.to_i
  ALL_USERS.each_with_index do |user, i|
    HTTParty.delete("#{BASE_URL}/users/#{user['id']}").parsed_response if i + 1 === action
  end
end

start_menu
