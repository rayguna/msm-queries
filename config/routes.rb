Rails.application.routes.draw do
  get("/", { :controller => "misc", :action => "homepage" })

  #directors  
  get("/directors", { :controller => "directors", :action => "index" })
  get("/directors/:the_id", { :controller => "directors", :action => "show" })

  #movies
  get("/movies", { :controller => "movies", :action => "index"})
  get("/movies/:the_id", { :controller => "movies", :action => "show" })

  #actors
  get("/actors", { :controller => "actors", :action => "index"})
  get("/actors/:the_id", { :controller => "actors", :action => "show" })

end
