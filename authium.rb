#!/usr/bin/env ruby
require 'sinatra'
require 'pp'
require 'sqlite3'
require 'json'

db = SQLite3::Database.new "ids.db"

rows = db.execute "CREATE TABLE IF NOT EXISTS order_ids(id TEXT, activated BIT);"

set :environment, :production
set :port, 8001

post '/add-id' do

	# So users can't add a key
	unless request.env.key?("HTTP_X_SELLY_SIGNATURE")
	  puts "Invalid request"
	  return
	end

	payload = params
	payload = JSON.parse(request.body.read.to_s) unless params['path']

	pp payload 
	pp payload.class
	id = payload["id"]
	pp "Inserting id: #{id}"
	db.execute("INSERT INTO order_ids(id) VALUES (?)", id)
	#[JSON.parse(request.body.read.to_s)["id"]].each do |id|
	#  pp "Inserting id: #{id}"
	#  db.execute("INSERT INTO order_ids(id) VALUES (?)", id)
	#end
	#pp request.env
end

get '/activate-id/:id' do |id|
	db.execute("UPDATE order_ids SET activated=1 WHERE id='#{id}'")
end

get '/check-id/:id' do |id|
	db.execute("SELECT * FROM order_ids") do |row|
	  pp row
	  return {"status" => "true"}.to_json if row.include? id
	end
	return {"status" => "false"}.to_json
end

get '/id-info/:id' do |id|
	info = {}
	
	#stm = db.prepare("SELECT * FROM order_ids WHERE id = ?")
	#stm.bind_param 1, id
	#rs = statement.execute
	#rs.each do |rw|
	#  rw.each do |row|
	db.execute("SELECT * FROM order_ids WHERE id = ?", id).each do |row|
	    pp row
	    # row => [id, activated]
	    if row.include? id
	      info['exists'] = true
	      if row[1] == 1
		info['activated'] = true
	      else
		info['activated'] = false
	      end
	    else
	      info['exists'] = false
	      return info.to_json
	    end
	  
	  
	  pp row
	  return info.to_json
 	end
end
