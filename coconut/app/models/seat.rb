class Seat < ActiveRecord::Base
  belongs_to :flight
  def validate
     if baggage > flight.baggage_allowance
       errors.add_to_base("あなたのバックは重すぎます。")
     end
     if flight.seats.size >= flight.capacity
       errors.add_to_base("このフライトは満席です。")
     end
  end
end