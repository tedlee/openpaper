require "sinatra" 
require "sqlite3"
require "erb"
require "pry"

db = SQLite3::Database.new "development.sqlite3"
set :views, settings.root + '/views'

get "/" do
	erb :index
end

get "/papers" do
	
	records = []
	db.execute( "select title,author,school from papers" ) do |row|
	  records << row
	end
	results = records.map do | record |
		{"title" => record[0],  "author" => record[1], "school" => record[2]}
	end 
	erb :papers, :locals => {:records => results}

end

not_found do
  "Not found"
end
