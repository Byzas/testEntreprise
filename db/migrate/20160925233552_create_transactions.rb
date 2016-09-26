class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :organization_id
      t.integer :membership_id
      t.float :amount

      t.timestamps null: false
    end
  end
end
