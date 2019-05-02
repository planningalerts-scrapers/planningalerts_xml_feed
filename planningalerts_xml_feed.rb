require 'scraperwiki'
require 'mechanize'

module PlanningAlertsXMLFeed
  def self.scrape(url, verbose = false)
    agent = Mechanize.new

    page = Nokogiri::XML(agent.get(url).body)

    page.search("application").each do |app|
      record = {
        "council_reference" => app.at("council_reference").inner_text,
        "address" => app.at("address").inner_text,
        "description" => app.at("description").inner_text,
        "info_url" => app.at("info_url").inner_text,
        "comment_url" => app.at("comment_url").inner_text,
        "date_scraped" => Date.today.to_s
      }
      # Optional fields
      if app.at("date_received") && app.at("date_received").inner_text.strip != ""
        record["date_received"] = app.at("date_received").inner_text
      end
      if app.at("on_notice_from") && app.at("on_notice_from").inner_text.strip != ""
        record["on_notice_from"] = app.at("on_notice_from").inner_text
      end
      if app.at("on_notice_to") && app.at("on_notice_to").inner_text.strip != ""
        record["on_notice_to"] = app.at("on_notice_to").inner_text
      end
      p record if verbose
      ScraperWiki.save_sqlite(['council_reference'], record)
    end
  end
end
