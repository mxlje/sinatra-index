require 'test/unit'
require 'rack/test'
require 'sinatra/base'
require "#{File.dirname(__FILE__)}/../lib/sinatra-index"

ENV['RACK_ENV'] = 'development'

class TestIndices < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp
  end

  def test_serve_static_files
    get 'foo'
    assert_equal 'foo', last_response.body
  end

  def test_serves_first_index
    get '/'
    assert_equal 'foo.html', last_response.body
  end

  def test_subfolders
    get '/qux/'
    assert last_response.ok?
    assert_equal 'qux/foo.html', last_response.body
  end

  def test_dont_redirect_files
    get '/style.css'
    assert_equal 200, last_response.status
    assert_equal 'body{color: red;}', last_response.body
  end

  def test_redirect_code_in_development
    get '/qux'
    assert_equal 302, last_response.status
  end

  def test_redirect_code_in_production
    ENV['RACK_ENV'] = 'production'

    get '/qux'
    assert_equal 301, last_response.status

    ENV['RACK_ENV'] = 'development'
  end

  def test_https_scheme
    get '/qux', {}, {'HTTPS' => 'on'}
    assert_equal 302, last_response.status
    assert_equal 'https://', last_response.header['Location'][0..7]
  end
end

class TestApp < Sinatra::Base
  register Sinatra::Index
  use_static_indices 'foo.html', 'bar.html'

  set :app_file, __FILE__
end
