require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'json'
require_relative './models/post.rb'
# require_relative './controllers/posts_controller.rb'
require_relative './controllers/api/posts_controller.rb'

use Rack::MethodOverride
# use Rack::PostBodyContentTypeParser

run PostsController
