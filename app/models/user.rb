class User < ActiveRecord::Base
  validates_presence_of :name, :email, :password
  #so no one can sign up without inputting all three
end