class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  mount_uploader :image, ImageUploader
  validates :name, presence: true
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i(google line)

  def self.create_unique_string
    SecureRandom.uuid
  end
  
  def self.find_for_google(auth)
    user = User.find_by(email: auth.info.email)
  
    unless user
      user = User.new(name: auth.info.name,
                      email: auth.info.email,
                      provider: auth.provider,
                      uid:      auth.uid,
                      password: Devise.friendly_token[0, 20],
                                   )
    end
    user.save
    user
  end

  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end

  # ゲストログインについての記述
  # def self.guest
  #   find_or_create_by!(email: 'guest@guest.com') do |user|
  #     user.password = SecureRandom.urlsafe_base64
  #     user.password_confirmation = user.password
  #     user.uid = SecureRandom.uuid
  #     user.provider = SecureRandom.uuid
  #     user.name = 'ゲスト'
  #     user.admin = false
  #   end
  # end

  # def self.guest_admin
  #   find_or_create_by!(email: 'admin@admin.com') do |user|
  #     user.password = SecureRandom.urlsafe_base64
  #     user.password_confirmation = user.password
  #     user.uid = SecureRandom.uuid
  #     user.provider = SecureRandom.uuid
  #     user.name = '管理者'
  #     user.admin = true
  #   end
  # end
end
