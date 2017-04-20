class Payment < ApplicationRecord
  belongs_to :recipient
  validates :amount, :currency, :recipient, :ref_payment_id, presence: true
end
