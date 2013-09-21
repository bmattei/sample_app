class User < ActiveRecord::Base
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
  uniqueness: { case_sensitive: false }  # uniqueness can fail - in certain race conditions
  has_secure_password  # this add instance attributes password and confirm_password
  validates :password, length: { minimum: 6}
  
end
