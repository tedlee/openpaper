require "sinatra" 
require "erb"
require "pry"
require "data_mapper"

set :views, settings.root + '/views'

#Setup the sqlite3 db and schema
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/papers.db") 

class Paper  
	include DataMapper::Resource
	property :id, Serial
	property :title, Text, :required => true
	property :author, Text, :required => true
	property :school, Text, :required => true
	property :source, Text, :required => true
	property :created_at, DateTime  
end

DataMapper.auto_upgrade!

get "/" do
	@title = "OpenPaper"
	erb :index
end

get "/papers" do

	@papers = Paper.all :order => :title.desc  
	@title = 'All Papers'
	erb :papers

end

post '/papers' do  
	p = Paper.new  
	p.title = params[:title]
	p.author = params[:author]
	p.school = params[:school]
	p.source = params[:source]
	p.created_at = Time.now
	p.save  
	redirect '/papers'  
end  

get "/papers/:id" do
	@paper = Paper.get params[:id]
	@title = "Edit paper ##{params[:id]}"
	erb :edit
end

put '/papers/:id' do
	p = Paper.get params[:id]
	p.title = params[:title]
	p.author = params[:author]
	p.school = params[:school]
	p.source = params[:source]
	p.save
	redirect '/papers'
end


get "/add" do
	# For new entry
	erb :add
end


not_found do  
	halt 404, 'No page for you.'  
end  
