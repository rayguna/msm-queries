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

  def youngest

    matching_records = Director.where({:dob => Director.all.maximum(:dob)})

    @the_youngest = matching_records.at(0)

    render({:template => "director_templates/youngest"})
  end

  def eldest

    matching_records = Director.where({:dob => Director.all.minimum(:dob)})

    @the_eldest = matching_records.at(0)

    render({:template => "director_templates/eldest"})
  end

end
