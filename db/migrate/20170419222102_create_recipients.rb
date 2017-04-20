class CreateRecipients < ActiveRecord::Migration[5.0]
  def change
    create_table :recipients do |t|
      t.string :name
      t.string :ref_recipient_id

      t.timestamps
    end
  end
end
