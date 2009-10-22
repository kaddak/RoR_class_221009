class AddUserToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :user, :reference
  end

  def self.down
    remove_column :posts, :user
    
  end
end
