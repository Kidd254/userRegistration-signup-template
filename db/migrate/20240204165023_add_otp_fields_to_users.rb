class AddOtpFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :pin, :integer
    add_column :users, :pin_sent_at, :datetime
    add_column :users, :verified, :boolean
  end
end
