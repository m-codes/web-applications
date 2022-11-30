require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  def reset_table
    albums_seed_sql = File.read('spec/seeds/albums_seeds.sql')
    artists_seed_sql = File.read('spec/seeds/artists_seeds.sql')


    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(albums_seed_sql)
    connection.exec(artists_seed_sql)

  end

  before(:each) do
    reset_table
  end

  context 'GET /albums' do
    it 'should return the list of albums in div' do
      response = get('/albums')
      expect(response.status).to eq 200
      expect(response.body).to include('Title: I Put a Spell on You')
      expect(response.body).to include('Title: Surfer Rosa')
      expect(response.body).to include('Released: 2020')
      expect(response.body).to include('Title: Fodder on My Wings')
      expect(response.body).to include('Released: 1982')
    end
  end



  context 'GET /albums/:id' do
    it 'returns an album by its id' do
      response = get('/albums/1')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context 'GET /albums/:id' do
    it 'returns an album by its id' do
      response = get('/albums/2')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')

    end
  end


  context 'GET /artists' do
    it 'should return the list of artists' do
      response = get('/artists')
      expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone"
      expect(response.status).to eq 200
      expect(response.body).to eq(expected_response)
    end
  end

  # context 'GET /albums' do
  #   it 'should return the list of albums' do
  #     response = get('/albums')
  #     expected_response = "Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"
  #     expect(response.status).to eq 200
  #     expect(response.body).to eq(expected_response)
  #   end
  # end

  # context 'POST /albums' do
  #   it 'should create a new album' do
  #     response = post(
  #       '/albums',
  #       title: 'Voyage',
  #       release_year: '2022',
  #       artist_id: '2'
  #     )
  #
  #     expect(response.status).to eq 200
  #     expect(response.body).to eq ('')
  #
  #     response = get('/albums')
  #     expect(response.body).to include('Voyage')
  #   end
  # end



  context 'POST /artists' do
    it 'should create a new artist' do
      response = post(
        '/artists',
        name: 'Wild nothing',
        genre: 'Indie'
      )

      expect(response.status).to eq 200
      expect(response.body).to eq ('')

      response = get('/artists')
      expect(response.body).to include('Wild nothing')
    end
  end



end
