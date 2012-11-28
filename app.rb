require "sinatra" 
#require "erb"
#require "pry"
require "data_mapper"

configure :production do
	require 'newrelic_rpm'
end

set :views, settings.root + '/views'

class Paper  
	include DataMapper::Resource
	property :slug, String, :length => 100, key: true, unique_index: true, default: lambda { |resource,prop| resource.title[0..99].downcase.gsub " ", "-" }
	property :title, Text, required: true
	property :author, Text, required: true

	# Strings are not lazy loaded
	property :author_lowercase, String, default: lambda { |resource,prop| resource.author.downcase }
	property :title_lowercase, String, :length => 150, default: lambda { |resource,prop| resource.title[0..149].downcase }
	property :school, Text, required: true
	property :source, Text, required: true
	property :summary, Text, required: false
	property :author_avatar, Text, required: false
	property :created_at, DateTime  
end


configure :development do
	DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/openpaper")
    DataMapper.auto_upgrade!  
end 

configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/openpaper")
	DataMapper.finalize
	DataMapper.auto_upgrade!
end


get "/" do
	@title = "OpenPaper"
	set :erb, :layout => false
	erb :index
end

get "/papers" do
	@papers = Paper.all :order => :title.desc  
	@title = 'All Papers'
	set :erb, :layout => false
	erb :papers
end

get "/addpaper" do
	@papers = Paper.all :order => :title.desc  
	@title = 'All Papers'
	erb :addpaper
end

get '/search/*' do
	query = params[:q].downcase
	query = query.downcase
	@title = query
	#@papers = Paper.all(:conditions => ["author_lowercase.like = ? OR title_lowercase.like = ?", query, query])
	#Paper.all("author_lowercase.like" => "%#{query}%")
	@papers = Paper.all("author_lowercase.like" => "%#{query}%") | Paper.all("title_lowercase.like" => "%#{query}%" )
	#binding.pry
	set :erb, :layout => false
	erb :papers
end

post '/addpaper' do  
	p = Paper.new  
	p.title = params[:title]
	p.author = params[:author]
	p.school = params[:school]
	p.source = params[:source]
	p.summary = params[:summary]
	p.author_avatar = params[:author_avatar]
	p.created_at = Time.now
	p.save  
	redirect '/addpaper'  
end  

# Now redundant due to use of /papers/:slug
get "/addpaper/:slug" do
	@paper = Paper.get params[:slug]
	@title = "Edit paper ##{params[:slug]}"
	erb :edit
end

get "/papers/:slug" do
	@paper = Paper.get params[:slug]
	@title = "Edit paper ##{params[:slug]}"
	erb :edit
end

put '/addpaper/:slug' do
	p = Paper.get params[:slug]
	p.destroy #deltes current entry to renew slug
	p = Paper.new  
	p.title = params[:title]
	p.author = params[:author]
	p.school = params[:school]
	p.source = params[:source]
	p.summary = params[:summary]
	p.author_avatar = params[:author_avatar]
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
