class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
       :recoverable, :rememberable, :lockable, :timeoutable,
       :jwt_authenticatable, jwt_revocation_strategy: self
end
