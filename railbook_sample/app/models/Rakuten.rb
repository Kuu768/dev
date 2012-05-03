class Rakuten < ActiveResource::Base
  self.site    = "http://api.rakuten.co.jp"
  self.format = :xml
  FROM         = "/rws/3.0/rest"
  AFFILIATE_ID = "AlqPtEuxg64xfMuR.hw13wIOAN8Eg82721MUJ6vQ5iBsWXyaAmHYv2mpFWbKY66y"
  DEVLOPER_ID  = "2b03148ff2a189548facd96142779f62"
  VERSION      = "2010-09-15"

  def self.item_search(keyword, genre_id=0, page=1)
    self.find(
      :one,
      :from,
      :params => {
        :developerId       => DEVLOPER_ID,
        #:affiliateId => AFFILIATE_ID,
        :version     => VERSION,
        :operation   => "ItemSearch",
        #:genreId     => genre_id,
        #:page        => page,
        :keyword     => keyword
      }
    )
  end
end

