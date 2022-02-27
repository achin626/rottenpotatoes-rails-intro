class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_by = params[:sort_by]
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:selected_ratings]
    
    if !params[:selected_ratings] || !params[:sort_by]
      # If already sorted by a column, clicking on that column will then sort by id
      if @sort_by == session['sort_by']
        @sort_by = 'id'
      else
        @sort_by = params[:sort_by] || session['sort_by'] || 'id'
      end
      
      @selected_ratings = params[:ratings]&.keys || session['selected_ratings'] || Movie.all_ratings
      
      redirect_to movies_path({sort_by: @sort_by, selected_ratings: @selected_ratings})
    end
    
    @movies = Movie.with_ratings(@selected_ratings).order(@sort_by)
    
    session['sort_by'] = @sort_by
    session['selected_ratings'] = @selected_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
