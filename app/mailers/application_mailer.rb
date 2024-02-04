class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
  default from: 'your-email@example.com' # Set your default 'from' address here

  def confirmation_instructions(user, otp)
    @user = user
    @otp = otp
    email = @user.email.presence || @user.unconfirmed_email

    mail(to: email, subject: "Your OTP") do |format|
      format.json { render json: confirmation_instructions_json }
    end
  end

  private

  def confirmation_instructions_json
    {
      user_id: @user.id,
      otp: @otp,
      message: "Confirmation instructions sent successfully."
    }
  end
end
