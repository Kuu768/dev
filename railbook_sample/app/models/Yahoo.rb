class Yahoo < ActiveResource::Base
  self.site    = "http://shopping.yahooapis.jp/ShoppingWebService/V1/itemSearch"
  self.format = :xml
  #FROM         = "/rws/2.0/rest"
  AFFILIATE_ID = "AlqPtEuxg64xfMuR.hw13wIOAN8Eg82721MUJ6vQ5iBsWXyaAmHYv2mpFWbKY66y"
  DEVLOPER_ID  = "******************************"
  VERSION      = "2009-04-15"

  def self.item_search(keyword, genre_id=0, page=1)
    self.find(
      :one,
      :params => {
        :appid       => AFFILIATE_ID,
        #:affiliateId => AFFILIATE_ID,
        #:version     => VERSION,
        #:operation   => "ItemSearch",
        #:genreId     => genre_id,
        #:page        => page,
        :query     => keyword
      }
    )
  end
end

