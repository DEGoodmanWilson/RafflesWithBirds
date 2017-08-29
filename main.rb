require 'grape'
require 'twitter'

module Raffler
  class API < Grape::API
    version 'v1', using: :path, vendor: 'sqreen'
    format :json

    helpers do
      def client
        @client ||= Twitter::REST::Client.new do |config|
          config.consumer_key = ENV["CONSUMER_KEY"]
          config.consumer_secret = ENV["CONSUMER_SECRET"]
        end
      end
    end

    resource :hashtags do

      route_param :hashtag do
        get do
          # this is ridiculously ineffecient, but whatever.
          list = []

          client.search("##{params[:hashtag]}").each do |tweet|
            list.push(tweet)
          end

          return {} if list.empty?

          tweet = list.sample

          {
              screen_name: tweet.user.screen_name,
              text: tweet.text
          }
        end
      end

    end
  end
end
