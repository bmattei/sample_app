class Micropost < ActiveRecord::Base
  
  belongs_to :user 
  default_scope -> {order('created_at DESC')} # -> defined s function (lambda)
  validates :user_id, presence: true
  validates :content, presence: true, :length => {:maximum => 140 }
end
