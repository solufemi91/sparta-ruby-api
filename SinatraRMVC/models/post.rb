class Post

  # Creates instance variables and also makes them visible and editable outside the object.
  attr_accessor :id, :title, :body

  # Save is an instance method that we can use to create or update a post
  def save

    # Assign the Postgre connect to variable
    conn = Post.open_connection

    # If the Post instance has an it means it already exists so we are going to update an existing record
    if(self.id)
      sql = "UPDATE post SET title='#{self.title}', body='#{self.body}' WHERE id = #{self.id}"
    # If there Post has no id this means the post is new and needs creating
    else
      sql = "INSERT INTO post (title, body) VALUES ('#{self.title}', '#{self.body}')"
    end

    # Execute the sql in Postgres
    conn.exec(sql)
  end


def self.create(post)
  conn = self.open_connection

  sql = "INSERT INTO post (title , body) VALUES ( '#{post[:title]}', '#{post[:body]}')"

  conn.exec(sql)




end
  # Open connection is Class method that we will use to open a connection the Postgres database. This is not tied to instance of a class but to the class itself
  def self.open_connection
    # Assign the Postgre connect to variable
    conn = PG.connect(dbname: "blog")
  end

  # Class method the get all our post from the db
  def self.all

    # Assign the Postgre connect to variable
    conn = self.open_connection

    # SQL statement to select our posts and order them
    sql = "SELECT id,title,body FROM post ORDER BY id DESC"

    # Execute the sql in Postgres
    results = conn.exec(sql)

    posts = results.map do |post|
      self.hydrate(post)
    end


  end

  # Class method the will retrieve one post from the db
  def self.find(id)

    # Assign the Postgre connect to variable
    conn = self.open_connection

    # SQL statement to select one post and limit to one
    sql = "SELECT * FROM post WHERE id =#{id} LIMIT 1"

    # Execute the sql in Postgres
    posts = conn.exec(sql)

    # Return the post


  end

  # A class method to destroy a post from the DB
  def self.destroy(id)

    # Assign the Postgre connect to variable
    conn = self.open_connection

    # SQL statement to delete one post with the id we passed in
    sql = "DELETE FROM post WHERE id = #{id}"

    # Execute the sql in Postgres
    conn.exec(sql)

  end

  # Hydrate is Class method that we can use to format our data that we get back from the PG gem. The PG gem returns the data as a weird object type called PG:Result.
  def self.hydrate(post_data)

    # Create an instace of a post
    post = Post.new

    # Set the instance variables to be the ones from the PG:Result object so we can use them later in our templates
    post.id = post_data['id']
    post.title = post_data['title']
    post.body = post_data['body']

    # Return the post
    post
  end

end
