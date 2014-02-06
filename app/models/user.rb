class User < ActiveRecord::Base
	before_save :downcase_username_and_email

	validates :username, presence: true, length: { maximum: 25 },
						uniqueness: { case_sensitive: false }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
	validates :password, length: { minimum: 8 }
	has_secure_password

	protected
		def downcase_username_and_email
			self.email = email.downcase
			self.username = username.downcase
		end
end
