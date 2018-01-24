class PostsController < Sinatra::Base

  # Sets root as the parent-directory of the current file
  set :root, File.join(File.dirname(__FILE__), '..')

  # Sets the view directory correctly
  set :views, Proc.new { File.join(root, "views") }

  # Enables the reloader so we dont need to keep restarting the server
  configure :development do
      register Sinatra::Reloader
  end

  # A get request to the / route will respond with our index template with all the posts from the model
  get '/' do

    # Page title
    @title = "Blog posts"

    # Get all the posts from our model Post. `all` is a Class method which we can call if use the class first. This is not tied to an instance but we can just use the method
    @posts = Post.all

    # render our index page
    erb :'posts/index'

  end

  # A get request to /new will respond with a template with our new form that the user can complete to add a new post
  get '/new'  do

    # Create a new instance of our Post object which will be empty but will allow our form partial to switch between a new and edit request
    @post = Post.new

    # Render the new template
    erb :'posts/new'

  end

  # A get request to /:id will respond with a the show template with the requested post
  get '/:id' do

    # Get the ID from the params and turn it in to an integer
    id = params[:id].to_i

    # Use the find Class method in post to retrieve the post we need and assign it to an instance variable post
    @post = Post.find(id)

    # Render the show template
    erb :'posts/show'

  end

  # A post request to / will create a new post with the imformation the user entered which is stored in the params
  post '/' do

    # Create a new instance of our Post class
    post = Post.new

    # Becuase we set the title and body in the models attr_accessor we can edit them from outside the object. Here we are setting the values of the title and body to be the information the user put in the form
    post.title = params[:title]
    post.body = params[:body]

    # Save is a instance method that we can use to save the new Post into the db
    post.save

    # After the save we request the / route and display all the posts
    redirect "/"
  end


  # A put request to the /:id will will update an existing post
  put '/:id'  do

    # The id of the post we want to update, we pulled this information from request params
    id = params[:id].to_i

    # We use the find Class method to get us the post we need to update
    post = Post.find(id)

    # Manipulate the the intance variables to the new data the user entered
    post.id = params[:id]
    post.title = params[:title]
    post.body = params[:body]

    # Use the instance method save to update the post
    post.save

    # Redirect to / to show all the posts
    redirect '/'

  end

  # A delete request to /:id will delete the specified post from the db
  delete '/:id'  do

    # The id of the post we want to delete, we pulled this information from request params
    id = params[:id].to_i

    # We can use the Class method destroy to remove the post from the db
    Post.destroy(id)

    # Redirect to / to show all the posts
    redirect "/"

  end

  # A request to /:id/edit will respond with a the edit template with the post data of the post we can want to update
  get '/:id/edit'  do

    # The id of the post we want to update, we pulled this information from request params
    id = params[:id].to_i

    # Use the find Class method in post to retrieve the post we need and assign it to an instance variable post
    @post = Post.find(id)

    # Render the edit template
    erb :'posts/edit'

  end

end
