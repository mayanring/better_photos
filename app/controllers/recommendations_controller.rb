class RecommendationsController < ApplicationController
  def index
    @skipped = []
    @images = []

    username = photo_params[:username]
    num_recs = photo_params[:num]

    if username
      # fetch user from 500px
      userResponse = JSON.parse(F00px.get("users/show?username=#{username}").body)["user"]
      @user = {
        id: userResponse["id"],
        fullname: userResponse["fullname"],
        avatar: userResponse["userpic_url"]
      }
    end

    # get recommendations
    client = PredictionIO::EngineClient.new(ENV['PIO_ENGINE_URL'] || "http://localhost:8000")
    if @user
      recommended_photos = client.send_query(user: @user[:id], num: num_recs || 20)
    else
      recommended_photos = client.send_query(num: num_recs || 20)
    end
    recommended_photos = recommended_photos["itemScores"].map { |r| OpenStruct.new(r) }

    # I expect recommended_photos to look like this:
    # [{ item: '123456', score: '0.2313545' }, {..}]

    # this is fake data for me to play around with since I don't have the trained set
    # photo_ids = [126144867,126144863,126042209,125847453,126144869,126149775,126144871,125902351,125984143,126130809,126143083,126133729,126088895,125830649,126127571,125888997,126133939,125918445,126043109,125876325]
    # random = Random.new(Time.now.to_i)

    # recommended_photos = photo_ids.map do |photo_id|
    #   OpenStruct.new(item: photo_id, score: random.rand(1.5))
    # end

    # fetch photos from 500px
    photoResponse = JSON.parse(F00px.get("photos?image_size=31&ids=#{recommended_photos.map{ |r| r.item }.join(',')}").body)
    photos = photoResponse["photos"]

    recommended_photos.each do |r|
      photo_id = r.item.to_s

      if photos[photo_id]
        @images << {
            id: r.item,
            url: photos[photo_id]['images'][0]['url'],
            score: r.score,
            favorites_count: photos[photo_id]['favorites_count'],
            votes_count: photos[photo_id]['votes_count'],
            highest_rating: photos[photo_id]['highest_rating']
          }
      else
        @skipped << r.item
      end
    end

    @images = @images.compact
  end

  private

  def photo_params
    params.permit(:username)
  end
end
