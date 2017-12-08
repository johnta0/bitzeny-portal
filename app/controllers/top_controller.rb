require 'bigdecimal'
require 'bigdecimal/util'

class TopController < ApplicationController
  def index
    @btc_jpy = btc_jpy
    @zny_btc = zny_btc
    @zny_jpy = @btc_jpy * @zny_btc

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

  private

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
