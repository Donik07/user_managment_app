class UsersController < ApplicationController
  def create
    outcome = Users::Create.run(params: user_params)

    if outcome.valid?
      render json: outcome.result, status: :created
    else
      render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # new для UserPermit нужен для будущей реализации более сложной логики, пока он просто чтобы вызвать класс
    params.require(:user).permit(UserPermit.new.fields)
  end
end
