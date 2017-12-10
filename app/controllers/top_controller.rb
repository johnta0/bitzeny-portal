require 'net/http'
require 'bigdecimal'
require 'bigdecimal/util'

class TopController < ApplicationController
  before_action :get_last_prices, only: [:index, :api]
  def index
    # フォームから値を受取り、Convert計算を行う
    if params[:form_jpy].present?
      @form_jpy = params[:form_jpy]
      @btc_converted = @form_jpy / @btc_jpy.to_f
    end
    if params[:form_btc].present?
      @form_btc = params[:form_btc]

    end
    if params[:form_zny].present?

    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def generate_tweet
    screen_name = params[:screen_name]
    amount = params[:amount]
    intent_url = "https://twitter.com/intent/tweet?text="
    tweet_text = "@zenyhime tip @#{screen_name} #{amount}"
    intent_url += tweet_text
    intent_url = URI.escape(intent_url)
    redirect_to intent_url
  end

  def api
    if params[:q].present?
      if params[:q] == 'zny_btc'
        last_price = {
            last_price: @zny_btc
        }
      elsif params[:q] == 'zny_jpy'
        last_price = {
            last_price: @zny_jpy
        }
      else
        last_price = {
            message: "404 Not found"
        }
      end
    else
      last_price = {
          message: "Please include query parameters. ex: q=zny_btc"
      }
    end
    render json: last_price
  end

  private

  def get_last_prices
    @btc_jpy = btc_jpy
    @zny_btc = zny_btc
    @zny_jpy = @btc_jpy * @zny_btc
  end

  def btc_jpy
    json = get_json("https://api.zaif.jp/api/1/last_price/btc_jpy")
    json["last_price"].to_d
  end

  def zny_btc
    json = get_json("https://c-cex.com/t/zny-btc.json")
    json["ticker"]["lastprice"].to_d
  end

  def get_json(uri)
    uri = URI.parse(uri)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
