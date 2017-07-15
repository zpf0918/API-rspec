class Reservation < ApplicationRecord
  validates_presence_of :booking_code, :seat_number, :train_id
  validates_uniqueness_of :seat_number, :scope => :train_id

  belongs_to :train
  belongs_to :user

  before_validation :generate_booking_code, :on => :create

  def generate_booking_code
    self.booking_code = SecureRandom.uuid
  end
end
