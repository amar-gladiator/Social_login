class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]

  def self.find_for_facebook_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email.blank? ? auth.uid + "@facebook.com" : auth.info.email
      user.provider = auth.provider
      user.password = Devise.friendly_token[0,20]
      user.uid = auth.uid
      user.username = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end 

  def self.find_for_twitter_oauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user
      return user
    else
      registered_user = User.where(email: auth.uid + "@twitter.com").first
      if registered_user
        return registered_user
      else
        user = User.create(
                          username: auth.extra.raw_info.name,
                          provider: auth.provider,
                          username: auth.info.name,
                          oauth_token: auth.credentials.token,
                          uid: auth.uid,
                          email: auth.uid + "@twitter.com",
                          password: Devise.friendly_token[0,20],
                          
                          )
      end
    end
  end

  def self.find_for_google_oauth(auth_hash)
    user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
    user.email = auth_hash['info']['email']
    user.password = Devise.friendly_token[0,20]
    user.username = auth_hash['info']['name']
    user.oauth_token = auth_hash['credentials']['token']
    user.save!
    user
  end
end
