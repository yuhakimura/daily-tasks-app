class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.date :date_start
      t.date :date_end
      t.integer :quantity
      t.integer :quantity_finished
      t.integer :color
      t.boolean :completed
      t.references :user
      t.timestamps null: false
    end
  end
end
