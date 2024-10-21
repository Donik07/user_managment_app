class Users::Create < ActiveInteraction::Base
  # Описываем входные данные
  hash :params do
    string :name
    string :surname, default: nil
    string :patronymic
    string :email
    integer :age
    string :nationality
    string :country
    string :gender
    array :interests, default: []
    string :skills, default: ''
  end

  # Валидации. Из-за особенностей работы с ActiveInteraction пришлось написать кастомыне методы валидации
  validate :validate_age
  validate :validate_gender
  validate :validate_email

  def execute
    # Генерация полного имени пользователя
    user_full_name = "#{params[:surname]} #{params[:name]} #{params[:patronymic]}".strip

    # Проверка на уникальность email
    return errors.add(:email, 'already exists') if User.exists?(email: params[:email])

    # Создание пользователя
    user = User.new(
      name: params[:name],
      surname: params[:surname],
      patronymic: params[:patronymic],
      email: params[:email],
      age: params[:age],
      nationality: params[:nationality],
      country: params[:country],
      gender: params[:gender],
      full_name: user_full_name
    )

    # Обработка интересов
    interests = Interest.where(name: params[:interests])
    user.interests << interests if interests.present?

    # Обработка навыков
    skills = Skill.where(name: params[:skills].split(',').map(&:strip))
    user.skills << skills if skills.present?

    # Сохранение пользователя
    unless user.save
      errors.merge!(user.errors)
      return
    end

    user
  end

  # Кастомные валидации

  def validate_age
    unless params[:age].is_a?(Integer) && params[:age] > 0 && params[:age] <= 90
      errors.add(:age, 'must be a number between 1 and 90')
    end
  end

  def validate_gender
    unless %w[male female].include?(params[:gender])
      errors.add(:gender, 'must be male or female')
    end
  end

  def validate_email
    unless params[:email] =~ URI::MailTo::EMAIL_REGEXP
      errors.add(:email, 'is invalid')
    end
  end
end
