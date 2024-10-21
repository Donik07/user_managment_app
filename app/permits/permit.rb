class Permit

  def initialize
  end
  # @return [ApplicationRecord]
  def control_model
    control_class.safe_constantize
  end

  # @return [Array]
  def fields
    []
  end
end
