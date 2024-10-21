# spec/interactions/users/create_spec.rb
require 'rails_helper'

RSpec.describe Users::Create, type: :interaction do
  let(:valid_user_params) do
    {
      name: "Ivan",
      surname: "Bragin",
      patronymic: "Jr",
      email: "ivan@example.com",
      age: 30,
      nationality: "Russian",
      country: "Russia",
      gender: "male",
      interests: ["Reading"],
      skills: "Ruby, JavaScript"
    }
  end

  it "creates a user with valid parameters" do
    result = Users::Create.run(params: valid_user_params)
    expect(result).to be_valid
    expect(result.result).to be_a(User)
  end

  it "fails when email is invalid" do
    invalid_user_params = valid_user_params.merge(email: "invalid_email")
    result = Users::Create.run(params: invalid_user_params)

    expect(result).not_to be_valid
    expect(result.errors.full_messages).to include("Email is invalid")
  end
end
