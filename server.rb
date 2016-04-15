require 'sinatra'
require 'sinatra/reloader' if development?
require 'mechanize'
require 'pony'
require 'pry'
require 'httparty'
require 'nokogiri'


#require_relative 'webscraper.rb'
get '/' do
  @post_lyrics = ""
  erb :index
end

get '/search' do
  art = params[:artist].to_s
  sng = params[:title].to_s
  artist = art.gsub(/\s/,'-')
  title = sng.gsub(/\s/,'-')
  @lyrics = $lyrics
  @word = $wrd
  @songNames = $songNames
  erb :search
end

post "/search" do
  $lyricToScrape = ""
  $lyrics = ""
  $titleLink = ""
  $songNames = []
  $songUrls = []
  $wrd = params[:word].to_s
  word = $wrd.gsub(/\s/,'%20').downcase
  page = HTTParty.get('http://www.lyrics.net/lyrics/' + word)
  parse_page = Nokogiri::HTML(page)
  parse_page.css('.lyric-meta-title a[href]').map do |a|
    $songUrls.push(a['href'])
    $lyricToScrape = $songUrls[0]
  end

  parse_page.css('.lyric-meta-title').each do |a|
    $titleLink = a.text
    $songNames.push(a.text)
  end

  firstLink = HTTParty.get('http://www.lyrics.net' + $lyricToScrape)
  parse_page = Nokogiri::HTML(firstLink)
  parse_page.css('#lyric-body-text').each do |a|
    $lyrics = a.text
    $lyrics = $lyrics.to_s
    $final_lyrics = $lyrics.gsub! '\n', '</br>'
  end

  parse_page.css('embed[src]').map do |a|
    $video = a['src']
  end

  redirect to '/search'
end
