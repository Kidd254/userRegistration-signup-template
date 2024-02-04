class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  before_action :send_otp, only: [:create]
  before_action :verify_otp, only: [:create]
  

  respond_to :json
  def send_otp
    user = current_user
    otp = user.generate_otp
    user.update(otp_password: otp)

    ApplicationMailer.confirmation_instructions(user, otp).deliver_now

    render json: { message: "OTP sent successfully" }
  end

  def verify_otp
    user = current_user
    entered_otp = params[:otp]

    if user.verify_otp(entered_otp)
      user.update(verified: true)
      render json: { message: "OTP verified successfully" }
    else
      render json: { error: "Invalid OTP" }, status: :unprocessable_entity
    end
  end

  private

  def respond_with(resource, _opts = {})
    if request.method == 'POST' && resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up sucessfully.' },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    elsif request.method == 'DELETE'
      render json: {
        status: { code: 200, message: 'Account deleted successfully.' }
      }, status: :ok
    else
      render json: {
        status: {
          code: 422,
          message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
        }
      }, status: :unprocessable_entity
    end
  end
end
