# frozen_string_literal: true

class UserPermit < Permit

  def control_class
    'User'
  end

  def fields
    [*default_fields, other_relations]
  end

  def default_fields
    %i[name surname patronymic email age nationality country gender skills]
  end

  def other_relations
    { interests: [] }
  end
end
