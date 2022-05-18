require 'discordrb/webhooks'
require 'json'
client = Discordrb::Webhooks::Client.new(url: Rails.application.credentials[:DISCORD_WEBHOOK_URL])

namespace :dailynotifier do
  desc 'Daily notifier'
  task :just_do_it, :environment do
    logger = Logger.new('log/notifier_log.log')

    file = File.open(Rails.root.join("problemlist/#{DateTime.now.strftime('%Y%m')}.json"))
    json_data = JSON.parse(file.read)

    today = DateTime.now.strftime('%Y/%m/%d')

    listfound = false

    json_data.each do |date, linklist|
      next unless today == date

      listfound = true
      raise Errno::ENOENT unless linklist.any?

      client.execute do |builder|
        builder.content = linklist.join("\n")
      end
    end

    raise Errno::ENOENT unless listfound
  rescue Errno::ENOENT
    client.execute { |builder| builder.content = 'Problem list not found!' }
  rescue StandardError => e
    client.execute { |builder| builder.content = 'DAILY NOTIFIER BUG!!!' }
    logger.error e
  end
end
