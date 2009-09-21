class CreateDiaries < ActiveRecord::Migration
  def self.up
    create_table :diaries do |t|
      t.string :state, :null => false, :default => 'published'
      t.string :title
      t.string :cache_slug
      t.integer :owner_id
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :diaries
  end
end
