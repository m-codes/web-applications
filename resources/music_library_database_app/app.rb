# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end



  get '/artist/new' do
  # This route doesn't do much,
  # it returns the view with the HTML form.
  return erb(:new_artist)
end


  get '/album/new' do
  # This route doesn't do much,
  # it returns the view with the HTML form.
  return erb(:new_album)
end

# post '/albums' do
#   # Get request body parameters
#   title = params[:title]
#   content = params[:content]
#
#   # Do something useful, like creating a post
#   # in a database.
#   new_post = Post.new
#   new_post.title = title
#   new_post.content = content
#   PostRepository.new.create(new_post)
#
#   # Return a view to confirm
#   # the form submission or resource creation
#   # to the user.
#   return erb(:post_created)
# end



  get '/albums/:id' do
    album_repo = AlbumRepository.new
    @album = album_repo.find(params[:id])
    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(@album.artist_id)
    return erb(:album)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:all_albums)
  end


  get '/artists' do
    repo = ArtistRepository.new
    artists = repo.all
    response = artists.map do |artist|
      artist.name
    end.join(', ')
    return response
  end

  get '/artist/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])
    return erb(:artist)
  end

  get '/all_artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:all_artists)
  end



  # get '/albums' do
  #   repo = AlbumRepository.new
  #   albums = repo.all
  #   response = albums.map do |album|
  #     album.title
  #   end.join(', ')
  #   return response
  # end

  post '/albums' do
    if invalid_album_parameters?
      status 400
      return 'fields should not be empty'
    end
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    return ''
  end

  post '/artists' do
    if invalid_artist_parameters?
      status 400
      return 'fields should not be empty'
    end
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]
    repo.create(new_artist)
    return ''
  end


  def invalid_album_parameters?
    return (params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil)
  end

  def invalid_artist_parameters?
    return (params[:name] == nil || params[:genre] == nil)
  end







end
