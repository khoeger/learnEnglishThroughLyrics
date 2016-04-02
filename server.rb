require 'sinatra'
require 'mechanize'
require 'pony'
require 'pry'
require 'httparty'
require 'nokogiri'


#require_relative 'webscraper.rb'
get '/' do
  @post_lyrics = ""
  erb :"index.html"
end

get '/search' do
  art = params[:artist].to_s
  sng = params[:title].to_s
  artist = art.gsub(/\s/,'-')
  title = sng.gsub(/\s/,'-')
  erb :"index.html"
end

post "/search" do
  $songNames = []
  $songUrls = []
  $wrd = params[:word].to_s
  word = $wrd.gsub(/\s/,'%20').downcase
  puts word
  page = HTTParty.get('http://www.lyrics.net/lyrics/' + word)
  url = ('http://www.lyrics.net/lyrics/' + word)
  puts url
  parse_page = Nokogiri::HTML(page)
  parse_page.css('.lyric-meta-title a[href]').map do |a|
    #puts a.href
    puts a['href']
    #$titleUrl = a["href"]
    $songUrls.push(a['href'])
    #$songUrls.push(a["href"])
    #puts $songNames
    $lyricToScrape = $songUrls[0]
    #put $lyricToScrape
    puts "Its #{$songUrls[0]}"
  end
  parse_page.css('.lyric-meta-title').each do |a|
    puts a.text
    #puts a
    $titleLink = a.text
    #$titleUrl = a["href"]
    $songNames.push(a.text)
    #$songUrls.push(a["href"])
    #puts $songNames
    #$lyricToScrape = $songUrls[0]
    #put $lyricToScrape
  end
  firstLink = HTTParty.get('http://www.lyrics.net' + $lyricToScrape)
  puts ('http://www.lyrics.net' + $lyricToScrape)
  parse_page = Nokogiri::HTML(firstLink)
  parse_page.css('#lyric-body-text').each do |a|
    $lyrics = a.text
    $lyrics = $lyrics.to_s
    $final_lyrics = $lyrics.gsub! '\n', '</br>'
    puts $lyrics
    puts $final_lyrics
  end
  parse_page.css('embed[src]').map do |a|
    #puts a.href
    puts a['src']
    $video = a['src']
    #$titleUrl = a["href"]
    #$songUrls.push(a['href'])
    #$songUrls.push(a["href"])
    #puts $songNames
    #$lyricToScrape = $songUrls[0]
    #put $lyricToScrape
    puts "Its #{a['src']}"
  end
  redirect to '/search'
end
