class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.string :currency
      t.string :ref_payment_id
      t.string :status
      t.belongs_to :recipient, foreign_key: true

      t.timestamps
    end
  end
end
