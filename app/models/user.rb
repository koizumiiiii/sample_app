class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "followed_id",
                           class_name: "Relationship",
                           dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :name,  presence: true, length: { maximum: 50 }
  
  def feed
    Micropost.where("user_id = ?", id)
  end
  
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end
  
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  
end
