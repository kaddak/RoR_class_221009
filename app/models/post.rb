class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :user
  
  has_many :comments
  
  validates_presence_of :title, :body
  validates_length_of :body, :minimum => 5,
                             :message => " is Not long enough!"
  validates_length_of :title,
                             :within => 5..50
                             
  def Post.all_published  # code moved here (good practice)
    find_all_by_published(true).reverse # show only the published to users who are not logged
  end
  

end
