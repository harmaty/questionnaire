class Questionnaire < ApplicationRecord
  attr_accessor :file

  before_validation :set_reference

  validates_with QuestionnaireValidator

  private

  def set_reference
    self.reference = object['reference'] if object.is_a? Hash
  end
end
