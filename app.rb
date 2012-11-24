require "sinatra" 
#require "erb"
#require "pry"
require "data_mapper"


set :views, settings.root + '/views'


DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/openpaper")

#Setup the sqlite3 db and schema
#DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/papers.db")

class Paper  
	include DataMapper::Resource
	property :slug, String, key: true, unique_index: true, default: lambda { |resource,prop| resource.title.downcase.gsub " ", "-" }
	property :title, Text, required: true
	property :author, Text, required: true
	property :school, Text, required: true
	property :source, Text, required: true
	property :created_at, DateTime  
end

#configure :development do
#	DataMapper.auto_migrate!
#end

#configure :production do
DataMapper.auto_migrate!
#end

get "/" do
	@title = "OpenPaper"
	erb :index
end

get "/addpaper" do
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
	redirect '/addpaper'  
end  

get "/papers/:slug" do
	@paper = Paper.get params[:slug]
	@title = "Edit paper ##{params[:slug]}"
	erb :edit
end

put '/papers/:slug' do
	p = Paper.get params[:slug]
	p.destroy #deltes current entry to renew slug
	p = Paper.new  
	p.title = params[:title]
	p.author = params[:author]
	p.school = params[:school]
	p.source = params[:source]
	p.created_at = Time.now
	p.save  
	redirect '/addpaper'
end

get '/:slug/delete' do
	@paper = Paper.get params[:slug]
	@title = "Confirm deletion of paper ##{params[:slug]}"
	erb :delete 
end

delete '/:slug' do  
	p = Paper.get params[:slug]  
	p.destroy  
	redirect '/addpaper'  
end  

get "/add" do
	# For new entry
	erb :add
end


not_found do  
	halt 404, 'No page for you.'  
end  
