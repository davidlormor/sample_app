class User < ActiveRecord::Base
	before_save :downcase_username_and_email
	before_create :create_remember_token

	validates :username, presence: true, length: { maximum: 25 },
						uniqueness: { case_sensitive: false }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
	validates :password, length: { minimum: 8 }
	has_secure_password

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	protected
		def downcase_username_and_email
			email.downcase!
			username.downcase!
		end

	private
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end

end
