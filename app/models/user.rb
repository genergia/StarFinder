class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :image, ImageUploader
  has_many :posts, dependent: :destroy
  has_many :favorites
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :comments, dependent: :destroy
  def self.create_unique_string
    SecureRandom.uuid
  end
end
