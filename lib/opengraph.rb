# frozen_string_literal: true

require 'addressable'
require 'hashie'
require 'nokogiri'
require 'rest-client'

module OpenGraph
  # Fetch Open Graph data from the specified URI. Makes an
  # HTTP GET request and returns an OpenGraph::Object if there
  # is data to be found or <tt>false</tt> if there isn't.
  #
  # Pass <tt>false</tt> for the second argument if you want to
  # see invalid (i.e. missing a required attribute) data.
  def self.fetch(uri, strict = true)
    normalized = Addressable::URI.parse(uri).normalize.to_str
    parse(RestClient.get(normalized).body, strict)
  rescue RestClient::Exception, SocketError
    false
  end

  def self.parse(html, strict = true)
    doc = Nokogiri::HTML.parse(html)
    page = OpenGraph::Object.new
    doc.css('meta').each do |m|
      if m.attribute('property')&.to_s&.match(/^og:(.+)$/i)
        page[Regexp.last_match(1).gsub('-', '_')] = m.attribute('content').to_s
      end
    end
    return false if page.keys.empty?

    return false if strict && !page.valid?

    page
  end

  TYPES = {
    'activity' => %w[activity sport],
    'business' => %w[bar company cafe hotel restaurant],
    'group' => %w[cause sports_league sports_team],
    'organization' => %w[band government non_profit school university],
    'person' => %w[actor athlete author director musician politician public_figure],
    'place' => %w[city country landmark state_province],
    'product' => %w[album book drink food game movie product song tv_show],
    'website' => %w[blog website]
  }.freeze

  # The OpenGraph::Object is a Hash with method accessors for
  # all detected Open Graph attributes.
  class Object < ::Hashie::Mash
    MANDATORY_ATTRIBUTES = %w[title type image url].freeze

    # The object type.
    def type
      self['type']
    end

    # The schema under which this particular object lies. May be any of
    # the keys of the TYPES constant.
    def schema
      OpenGraph::TYPES.each_pair do |schema, types|
        return schema if types.include?(type)
      end
      nil
    end

    OpenGraph::TYPES.values.flatten.each do |type|
      define_method "#{type}?" do
        self.type == type
      end
    end

    OpenGraph::TYPES.keys.each do |scheme|
      define_method "#{scheme}?" do
        type == scheme || OpenGraph::TYPES[scheme].include?(type)
      end
    end

    # If the Open Graph information for this object doesn't contain
    # the mandatory attributes, this will be <tt>false</tt>.
    def valid?
      MANDATORY_ATTRIBUTES.each { |a| return false unless self[a] }
      true
    end
  end
end
