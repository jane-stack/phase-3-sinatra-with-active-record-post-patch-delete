require 'pry'
class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  patch '/reviews/:id' do
    # find the review to update using the ID
    review = Review.find(params[:id])
    # Access the data in the body of the request
    review.update(
      # use that data to update the review in the database
      score: params[:score],
      comment: params[:comment]
    )
    # Send a response with updated review as JSON
    review.to_json
  end

  post '/reviews' do
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id]
    )
    review.to_json
  end

  delete '/reviews/:id' do
  # find the review to delete using the ID
    review = Review.find(params[:id])
    # Delete the review from the database
    review.destroy
    # Send a response with the deleted review as JSON to confirm that it was deleted successfully, so the frontend can show the successful deletion to the use.
    review.to_json
  end

  get '/reviews' do
    review = Review.all
    review.to_json
  end

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

end
