require 'sinatra/base'
require_relative 'database_setup'

class BookmarkManager < Sinatra::Base
  set :views, Proc.new { File.join(root,"..", "views")}


  get '/' do
    @links = Link.all
    erb :index
  end

  post '/links' do
    url = params['url']
    title = params['title']
    tags = params['tags'].split(' ').map do |tag|
      # Either finds the tag or creates it if it doesn't exist already
      Tag.first_or_create(text: tag)
    end
    Link.create(url: url, title: title, tags: tags)
    redirect to('/')
  end

  get '/tags/:text' do
    tag = Tag.first(text: params[:text])
    @links = tag ? tag.links : []
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
