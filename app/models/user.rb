class User < ActiveRecord::Base
  has_many :posts

  attr_accessor :password_confirmation
  attr_reader :password
  #nämä ei tallennu kantaan (ei ole niille sarakkeita)

  validates_uniqueness_of :email
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password 
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(pwd, self.salt)
  end
  
  #Returns a user if the supplied email and pw match the db record
  def User.authenticate(email, password) #self. makes it a classmethod also
    user = User.find_by_email(email)
    if user
      password_attempt = User.encrypted_password(password, user.salt)
      if password_attempt != user.hashed_password
        user = nil      # wrong pw
        
      end
    end
    return user
  end
  
  private #kaikki tämän jälkeen on private
    # Generates random value to store it in the db
    def create_new_salt
      self.salt = Digest::SHA256.hexdigest(Time.now.to_s + rand.to_s) #self. koska laitetaan kantaan
    end
    
    # Given a password and the generated salt
    # Returns the hashed pw
      def self.encrypted_password(pwd, salt) # = User.
        string_to_hash = pwd + salt
        Digest::SHA256.hexdigest(string_to_hash)
      end
  
end
