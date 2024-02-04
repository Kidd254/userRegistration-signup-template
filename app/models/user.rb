class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
       :recoverable, :rememberable, :timeoutable,
       :jwt_authenticatable, jwt_revocation_strategy: self

       OTP_LENGTH = 6

  def send_confirmation_instructions
    token = SecureRandom.random_number(10**OTP_LENGTH).to_s.rjust(OTP_LENGTH, "0")
    self.confirmation_token = token
    self.confirmation_sent_at = Time.now.utc
    save(validate: false)
    UserMailer.confirmation_instructions(self, self.confirmation_token).deliver_now
  end
end
