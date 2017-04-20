class Recipient < ApplicationRecord
  has_many :payments
  validates :name, :ref_recipient_id,presence: true
end
