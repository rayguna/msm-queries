# msm-queries

Target: https://msm-queries.matchthetarget.com/

Link to the lesson: https://learn.firstdraft.com/lessons/126

Notes:

A. Set up database

1. Start out by setting up the databases. The video describes automated scripts for the database creation. The database related files are located within app/models.

Models are Ruby classes that generate the SQL we need to CRUD rows in tables.

Rails can automatically write most of our migrations for us, if we tell it:

- The name of the table we want.

- The columns we want in that table, along with their datatypes.

We can give Rails this information using a new tool: a Rails generator.

```
rails generate model movie title:string year:integer duration:integer description:text image:string director_id:integer
```

When you execute this command, you’ll see some output indicating that two files were created.

- One is a migration file located in the db/migrate folder called 20240613132926_create_movies.rb.

- One is a model file located in the app/models folder called movie.rb.

Take a peek at both files. Then, run the migration file with the following command:

```
rake db:migrate
```

You will see some output indicating that the movies table has been created. Verify in /rails/db.

```
msm-queries main % rake db:migrate
== 20240613132926 CreateMovies: migrating =====================================
-- create_table(:movies)
   -> 0.0031s
== 20240613132926 CreateMovies: migrated (0.0032s) ============================

Annotated (1): app/models/movie.rb
```

The app/models/movie.rb file content becomes:

```
# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  description :text
#  duration    :integer
#  image       :string
#  title       :string
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  director_id :integer
#
class Movie < ApplicationRecord
end
```


Then, copy-paste the commands to create the rest of our tables:

```
rails generate model director name:string dob:date bio:text image:string

rails generate model actor name:string dob:date bio:text image:string

rails generate model character name:string actor_id:integer movie_id:integer
```

The above commands create models for each character (director, actor, and character). The output are as follows:

```
msm-queries main % rails generate model director name:string dob:date bio:text image:string
      invoke  active_record
      create    db/migrate/20240613133401_create_directors.rb
      create    app/models/director.rb
msm-queries main % rails generate model actor name:string dob:date bio:text image:string
      invoke  active_record
      create    db/migrate/20240613133417_create_actors.rb
      create    app/models/actor.rb
msm-queries main % rails generate model character name:string actor_id:integer movie_id:integer
      invoke  active_record
      create    db/migrate/20240613133427_create_characters.rb
      create    app/models/character.rb
```

To execute the new migrations, run `rake db:migrate` again. The `rake db:migrate` command looks in the db/migrations folder, looks for any migrations that haven’t yet been executed, and executes them. So we don’t need to worry about the movies table being duplicated — the rake db:migrate command is smart, and knows that it already ran that migration.

Verify in /rails/db that all four tables have been created. A series of .db files are created within the db folder.

Since the model files to interact with these tables have also been generated, we’re ready to go! We can start adding sample data.

To make your life easier, I already scraped the iMDB Top 250 list and wrote a sample data rake task. You can simply run it with:

```
rake sample_data
```

In /rails/db, you should now see that all four tables have been populated with data.

2. run the web-app by typing in the terminal bin/dev. Run the browser and add to the url rails/db, https://psychic-sniffle-pgj4945p9x6crqgq-3000.app.github.dev/rails/db, where you will see the tables listed. Each table is populated with data.

B. Link table data to web-app (10 min)

1. Use the RCAV (routes, controller, action, view) acronym to link the information to the web-page. Start from within the config/routes.rb file. 

2. Update routes to reflect all paths. :action => index is a conventional name for the action that displays a list of records from a table.

```
#config/routes.rb

Rails.application.routes.draw do
  get("/", { :controller => "misc", :action => "homepage" })

  get("/directors", { :controller => "misc", :action => "index" }) 
end
```

3. Create the class and method to link to the respective web-page. Let's start with director.

```
#app/controllers/directors_controller.rb

class DirectorsController < ApplicsationController
  def index
    render({:template => "director"})
  end
end
```

4. Create the corresponding html page within a new folder called director_templates.

```
# app/views/director_templates/list.html.erb

<h1>List of directors</h1>

<table border = "1">
<tr>
  <th> ID </th>
  <th> Image </th>
  <th> Name </th>
  <th> Dob </th>
  <th></th>
</tr>

<% Director.all.each do |a_director| %>
  <tr>
    <td><%=a_director.id%></td>
    <td>
      <img src="<%=a_director.image%>" width = 100>
    </td>
    <td><%=a_director.name%></td>
    <td><<%=a_director.dob%>/td>
    <td><a href="/directors/<%=a_director.id%>">Show Details</a></td>
  </tr>
<%end%> 



</table>
```

5. Include a dynamic page that has a route ending with :the id. The routed page will be the page called show.html.erb, but the contents of the page will be dynamic depending on the dynamic value of :the_id.

```
#config/routes.rb

Rails.application.routes.draw do
  get("/", { :controller => "misc", :action => "homepage" })

  get("/directors", { :controller => "directors", :action => "index" })

  get("/directors/:the_id", { :controller => "directors", :action => "show" })
end
```

6. Accordingly, create a show.html.erb file called show.html.erb.

To test to make sure that this page can read the dynamic route, add within the page: <%=params%>.

Here is what you will see:
```
howdy {"controller"=>"directors", "action"=>"show", "the_id"=>"1"}
```
21 min.

7. Perform all tasks within the file app/controllers/directors_controller.rb and within the method show to do database filtering and pass the output using @the_director, as follows.

```
class DirectorsController < ApplicationController
  def index
    render({:template => "director_templates/list"})
  end

  def show
    the_id = params.fetch("the_id")

    matching_records = Director.where({:id => the_id})

    @the_director = matching_records.at(0)

    render({:template => "director_templates/details"})
  end
end
```

8. You can accordingly call the vaious methods of the @the_director variable on the html page, as follows.

```
<h1>Director #<%=@the_director.id%> details</h1>

<a href="/directors/">Go back</a>

<hr>

<%=@the_director.dob%>
```
27 min

9. Next, we need to show the filmography for the director on the details.html.erb page.

40 min - begin discussions on movie details page
