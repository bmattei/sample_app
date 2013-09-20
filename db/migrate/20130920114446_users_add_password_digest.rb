class UsersAddPasswordDigest < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string, unique: true

  end
end
