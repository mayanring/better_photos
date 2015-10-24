class RecommendationsController < ApplicationController
  def index
    user_id = photo_params

    # this is the query engine, not the event engine
    client = PredictionIO::EngineClient.new(ENV['PIO_ENGINE_URL'])
    client = PredictionIO::EngineClient.new("http://localhost:8000")
    recommended_photos = client.send_query(user: user_id)

    photo_ids = recommended_photos["itemScores"].map { |item| item["item"] }

    response = F00px.get("photos?image_size=20&ids=#{photo_ids.join(',')}")
    json_response = JSON.parse(response.body)

    photos = json_response["photos"]

    @image_urls = photo_ids.map do |photo_id|
      photos[photo_id.to_s]['images'][0]['url']
    end
  end

  private

  def photo_params
    params.require(:user_id)
  end
end
