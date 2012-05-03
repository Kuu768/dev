# coding: utf-8
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'erb'

class AjaxController < ApplicationController
  def upanel
    @time = Time.now.to_s
  end

  def search
    @books = Book.select('DISTINCT publish')
  end

  def result
    sleep(2)
    @books = Book.where(:publish => params[:publish])
  end

  def yahoo
    #Net::HTTP.start('search.yahooapis.jp') do |http|
    #  response = http.get('/WebSearchService/V2/webSearch?appid=wings-project&query=' + ERB::Util.url_encode(params[:keywd]))
    #  @body = Hash.from_xml(response.body)
    #end
    #Net::HTTP.start('shopping.yahooapis.jp') do |http|
    #  response = http.get('/ShoppingWebService/V1/itemSearch?appid=AlqPtEuxg64xfMuR.hw13wIOAN8Eg82721MUJ6vQ5iBsWXyaAmHYv2mpFWbKY66y&query=' + ERB::Util.url_encode(params[:keywd]))
    #  @body = Hash.from_xml(response.body)
    #end


    #Net::HTTP.start('weather.livedoor.com') do |http|
    #  response = http.get('/forecast/webservice/rest/v1?city=113&day=tomorrow')
    #  @body = Hash.from_xml(response.body)
    #end
    #@items = Rakuten.item_search(params[:keywd])
    @items = Shopping.item_search(params[:keywd])


    #xml = Nokogiri::XML(open('http://shopping.yahooapis.jp/ShoppingWebService/V1/itemSearch?appid=AlqPtEuxg64xfMuR.hw13wIOAN8Eg82721MUJ6vQ5iBsWXyaAmHYv2mpFWbKY66y&query=' + ERB::Util.url_encode(params[:keywd])))
    # = Nokogiri::XML(open('http://api.rakuten.co.jp/rws/3.0/rest?developerId=2b03148ff2a189548facd96142779f62&operation=ItemSearch&version=2010-09-15&keyword=' + ERB::Util.url_encode(params[:keywd])))
    #puts html
    array = Hash.new
    array = []

    def add(data, thumn, bign)
      data.push({'name' => thumn, 'description' => bign})
      return data
    end

    namespaces = {
      "itemSearch" => "http://api.rakuten.co.jp/rws/rest/ItemSearch/2010-09-15",
    }


      #<td><%= link_to , result.xpath('.//itemUrl').text %></td>
      #<td><%=  %></td>
      #<td><%= result.xpath('.//itemPrice').text %>円</td>
      #<img src="<%= result.xpath('.//mediumImageUrl').text %>" alt="<%= result['itemName'] %>" />


    #xml.xpath("//itemSearch:ItemSearch/Items/Item", namespaces).each do |result|
    #  thum = result.xpath('.//itemName').text
    #  big = result.xpath('.//itemCaption').text
    # array = add(array, thum, big)
    #end

      #namespaces = {
      #  "itemSearch" => "urn:yahoo:jp:itemSearch",
      #}
      #namespaces = {
      #  "itemSearch" => "http://api.rakuten.co.jp/rws/rest/ItemSearch/2010-09-15",
      #}
      #
      #xml.xpath("//itemSearch:Result/Hit", namespaces)
      #xml.xpath("//itemSearch:Result/Hit")

    #array = xml.xpath('.//Hit').each do |hits|
    #  thum = posts.xpath('./Name').text
    #  big = posts.xpath('./Url').text
    # array = add(array, thum, big)
    #end
    puts("ARRAY!!!!")
    #puts(xml)
    #puts(array)

    #@items = array
    #@items = array
    #puts(@items)

  end

  def rakuten_api
    Net::HTTP.start('api.rakuten.co.jp') do |http|
      response = http.get('/rws/3.0/rest?developerId=2b03148ff2a189548facd96142779f62&operation=ItemSearch&version=2010-09-15&keyword=' + params[:keywd] + '&sort=%2BitemPrice')
      @body = Hash.from_xml(response.body)


    end
  end

  def yahoo_shopping_api
    Net::HTTP.start('shopping.yahooapis.jp') do |http|
      response = http.get('/ShoppingWebService/V1/itemSearch?appid=AlqPtEuxg64xfMuR.hw13wIOAN8Eg82721MUJ6vQ5iBsWXyaAmHYv2mpFWbKY66y&query=' + ERB::Util.url_encode(params[:keywd]))
      @body = Hash.from_xml(response.body)
    end
  end
end
