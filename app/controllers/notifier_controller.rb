class NotifierController < ApplicationController
  def notify
    require 'json'
    today = DateTime.current.strftime('%Y/%m/%d')

    json_data = {
      "2022/05/22": ['https://atcoder.jp/contests/abc219/tasks/abc219_d'],
      "2022/05/23": ['https://atcoder.jp/contests/abc236/tasks/abc236_d'],
      "2022/05/24": ['https://atcoder.jp/contests/abc246/tasks/abc246_d'],
      "2022/05/25": ['https://atcoder.jp/contests/abc132/tasks/abc132_d'],
      "2022/05/26": ['https://atcoder.jp/contests/abc188/tasks/abc188_e'],
      "2022/05/27": ['https://atcoder.jp/contests/abc160/tasks/abc160_e'],
      "2022/05/28": ['https://atcoder.jp/contests/abc181/tasks/abc181_e'],
      "2022/05/30": ['Amrii tee'],
      "2022/05/31": ['Amrii tee']
    }

    listfound = false

    json_data.each do |date, linklist|
      next unless today == date.to_s

      listfound = true
      raise "#{today}: list empty" unless linklist.any?

      callwebhook(linklist.join("\n"), params[:discord])
    end

    raise "#{today}: list not found" unless listfound
  rescue StandardError => e
    callwebhook(e, params[:discord])
  end

  def callwebhook(msg, discord_url)
    require 'faraday'
    conn = Faraday.new
    conn.post do |req|
      req.url discord_url
      req.headers['Content-Type'] = 'application/json'
      req.body = { content: msg }.to_json
    end
  end
end
