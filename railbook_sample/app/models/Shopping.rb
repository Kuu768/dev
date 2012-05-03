# coding: utf-8
require 'rubygems'
require 'amazon/ecs'
require 'kconv'

class Shopping < ActiveResource::Base

  def self.item_search(keyword, genre_id=0, page=1)
    namespaces_yahoo = {
      "itemSearch" => "urn:yahoo:jp:itemSearch",
    }
    namespaces_rakuten = {
      "itemSearch" => "http://api.rakuten.co.jp/rws/rest/ItemSearch/2010-09-15",
    }

    def self.add(data, site, name, description, url, 
                 img_s, img_m, price, affirate, rate, rateCnt, shopName, shopUrl)
      data.push({'site' => site, 'name' => name, 'description' => description, 'url' => url,
                 'img_s' => img_s, 'img_m' => img_m, 'price' => price, 'affirate' => affirate,
                 'rate' => rate, 'rateCnt' => rateCnt, 'shopName' => shopName, 'shopUrl' => shopUrl})
      return data
    end

array_yahoo = Hash.new
array_yahoo = []

#    yahoo_aff_id = "k_lkGhWuJd3OTEr8wkS6AQ--"
#    xml_yahoo = Nokogiri::XML(open('http://shopping.yahooapis.jp/ShoppingWebService/V1/itemSearch?appid=AlqPtEuxg64xfMuR.hw13wIOAN8Eg82721MUJ6vQ5iBsWXyaAmHYv2mpFWbKY66y&query=' + ERB::Util.url_encode(keyword) + '&sort=-sold'))
#    array_yahoo = Hash.new
#    array_yahoo = []
#
#   if not xml_yahoo.xpath("//itemSearch:Hit[@index='1']", namespaces_yahoo).blank?
#      xml_yahoo.xpath("//itemSearch:Hit", namespaces_yahoo).each do |result|
#        site = "Yahoo!"
#        name = result.xpath('.//itemSearch:Name', namespaces_yahoo)[0].text
#        description = result.xpath('.//itemSearch:Description', namespaces_yahoo).text
#        url = result.xpath('.//itemSearch:Url', namespaces_yahoo)[0].text
#        img_s = result.xpath('.//itemSearch:Small', namespaces_yahoo).text
#        img_m = result.xpath('.//itemSearch:Medium', namespaces_yahoo).text
#        price = result.xpath('.//itemSearch:Price', namespaces_yahoo).text
#        affirate = result.xpath('.//itemSearch:Rate', namespaces_yahoo)[1].text
#        rate = result.xpath('.//itemSearch:Rate', namespaces_yahoo)[0].text
#        rateCnt = result.xpath('.//itemSearch:Count', namespaces_yahoo)[0].text
#        shopName = result.xpath('.//itemSearch:Name', namespaces_yahoo)[4].text
#        shopUrl = result.xpath('.//itemSearch:Url', namespaces_yahoo)[1].text
#        array_yahoo = add(array_yahoo, site, name, description, url,
#                          img_s, img_m, price, affirate, rate, rateCnt, shopName, shopUrl)
#      end
#    end

    puts("MODELからの出力")
    puts(array_yahoo)

#    xml_rakuten = Nokogiri::XML(open('http://api.rakuten.co.jp/rws/3.0/rest?developerId=2b03148ff2a189548facd96142779f62&operation=ItemSearch&version=2010-09-15&keyword=' + ERB::Util.url_encode(keyword) + '&sort=-reviewAverage'))
#    rakuten_aff_id = "0bfe2ffc.e71f82d6.0bfe2ffd.20458080"
#    array_rakuten = Hash.new
#    array_rakuten = []

#    if not xml_rakuten.xpath("//itemSearch:Status", namespaces_rakuten) == "NotFound"
#      xml_rakuten.xpath("//itemSearch:ItemSearch/Items/Item", namespaces_rakuten).each do |result|
#        site = "楽天"
#        name = result.xpath('.//itemName').text
#        description = result.xpath('.//itemCaption').text
#        url = result.xpath('.//itemUrl').text
#        img_s = result.xpath('.//smallImageUrl').text
#        img_m = result.xpath('.//mediumImageUrl').text
#        price = result.xpath('.//itemPrice').text
#        affirate = result.xpath('.//affiliateRate').text
#        rate = result.xpath('.//reviewAverage').text
#        rateCnt = result.xpath('.//reviewCount').text
#        shopName = result.xpath('.//shopName').text
#        shopUrl = result.xpath('.//shopUrl').text
#        array_yahoo = add(array_yahoo, site, name, description, url,
#                          img_s, img_m, price, affirate, rate, rateCnt, shopName, shopUrl)
#      end
#    end

    Amazon::Ecs.debug = true
    Amazon::Ecs.options = {
      :associate_tag => "group-22", #Associate ID
      :aWS_access_key_id => "AKIAIIKQPUDDRRVFTHDQ", # Your Access Key ID
      :aWS_secret_key => "JcN2EfENG7n800MbcEQ3u1CUaJeiAsp+CvCuPS6n",
      :country => :jp,
    }
    
    res = Amazon::Ecs.item_search(keyword, {:response_group => "Medium", :search_index => 'All'})

    #puts res.items
    res.items.each do |item|
        site = "AMAZON"
        name = item.get('ItemAttributes/Title').kconv(Kconv::UNKNOWN,Kconv::UTF8)
        #name = NKF.guess(item.get('ItemAttributes/Title'))

        #puts name
        description = ""
        url = item.get('DetailPageURL')
        img_s = item.get('SmallImage/URL')
        img_m = item.get('MediumImage/URL')
        price = item.get('ItemAttributes/ListPrice/Amount')
        affirate = item.get('ItemAttributes/Title')
        rate = item.get('ItemAttributes/Title')
        rateCnt = item.get('ItemAttributes/Title')
        shopName = item.get('ItemAttributes/Manufacturer')
        shopUrl = item.get('DetailPageURL')
        array_yahoo = add(array_yahoo, site, name, description, url,
                          img_s, img_m, price, affirate, rate, rateCnt, shopName, shopUrl)


    end

    #xml_amazon = Nokogiri::XML(open('http://ecs.amazonaws.jp/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=AKIAIIKQPUDDRRVFTHDQ&Operation=ItemSearch&Version=2010-09-01&SearchIndex=Books&Keywords=Java'))
    #amazon_access_id = "AKIAIIKQPUDDRRVFTHDQ"
    
    # ソート処理
    #array = array_yahoo.to_a.sort_by {|a| a['rate'] }
    array = array_yahoo.to_a.sort_by {|a| [a['rate'], a['name']]}.reverse!
    #array = array_yahoo.to_a.sort_by.reverse! {|i| [i['rate'],i['val'].text -i['val'].text] }

    #array_yahoo.sort{|a, b| a[0] <=> b[0] }.each{|key, value|

    return array
  end

#  self.site    = "http://api.rakuten.co.jp"
#  self.format = :xml
#  FROM         = "/rws/3.0/rest"
#  AFFILIATE_ID = "AlqPtEuxg64xfMuR.hw13wIOAN8Eg82721MUJ6vQ5iBsWXyaAmHYv2mpFWbKY66y"
#  DEVLOPER_ID  = "2b03148ff2a189548facd96142779f62"
#  VERSION      = "2010-09-15"
#
#  def self.item_search(keyword, genre_id=0, page=1)
#    self.find(
#      :one,
#      :from,
#      :params => {
#        :developerId       => DEVLOPER_ID,
#        #:affiliateId => AFFILIATE_ID,
#        :version     => VERSION,
#        :operation   => "ItemSearch",
#        #:genreId     => genre_id,
#        #:page        => page,
#        :keyword     => keyword
#      }
#    )
#  end
end

