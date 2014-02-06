require 'spec_helper'

describe User do
  
  before do
  	@user = User.new(username: "Example User", email: "user@example.com",
                     password: "foobar2014", password_confirmation: "foobar2014")
  end

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when username is not present" do
  	before { @user.username = " " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when username is too long" do
  	before { @user.username = "a" * 26 }
  	it { should_not be_valid }
  end

  describe "when username is already taken" do
  	before do
  		user_with_same_username = @user.dup
  		user_with_same_username.email = @user.email.upcase
  		user_with_same_username.save
  	end

  	it { should_not be_valid }
  end

  describe "username with mixed case" do
    let(:mixed_case_username) { "dLorMOr"}

    it "should be saved as all lower-case" do
      @user.username = mixed_case_username
      @user.save
      expect(@user.reload.username).to eq mixed_case_username.downcase
    end
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo.
  									 foo@bar_baz.com foo@bar+baz.com foo@bar..com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "dLorMOr@AIDT.edu"}

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(username: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 7 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(username: @user.username) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
end
