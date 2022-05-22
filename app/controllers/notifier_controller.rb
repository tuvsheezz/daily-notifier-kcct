class NotifierController < ApplicationController
  def notify
    require 'json'
    logger = Logger.new('log/notifier_log.log')
    file = File.open(Rails.root.join("problemlist/#{DateTime.now.strftime('%Y%m')}.json"))
    json_data = JSON.parse(file.read)

    today = DateTime.current.strftime('%Y/%m/%d')

    listfound = false

    json_data.each do |date, linklist|
      next unless today == date

      listfound = true
      raise Errno::ENOENT unless linklist.any?

      callwebhook(linklist.join("\n"), params[:discord])
    end

    raise Errno::ENOENT unless listfound
  rescue Errno::ENOENT
    callwebhook('Problem list not found!', params[:discord])
  rescue StandardError => e
    callwebhook('DAILY NOTIFIER BUG!!!', params[:discord])
    logger.error e
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
