class QuestionnaireValidator < ActiveModel::Validator
  attr_accessor :errors

  def validate(record)
    @errors = []
    validate_object_structure! record.object

    if @errors.any?
      @errors.uniq.each do |error|
        record.errors.add(:base, error)
      end
    end
  end

  private

  def validate_object_structure!(element)
    validate_type element, 'questionnaire'
    validate_presence element, 'reference'
    validate_content element

    if element['content'].is_a? Array
      element['content'].each do |item|
        validate_slide item
      end
    end
  end

  def validate_slide(element)
    validate_type element,  'slide'
    validate_presence element, 'reference'
    validate_presence element, 'label'
    validate_content element

    if element['content'].is_a? Array
      element['content'].each do |item|
        validate_element item
      end
    end
  end

  def validate_element(element)
    if element['type'].blank?
      validate_presence element, 'type'
    else
      case element['type']
      when 'text_input', 'number_input', 'boolean'
        validate_primitive_element(element)
      when 'single_choice', 'multiple_choice'
        validate_list_element(element)
      else
        errors << "Invalid type #{element['type']} of #{element['reference']} element"
      end
    end
  end

  def validate_primitive_element(element)
    validate_presence element, 'reference'
    validate_presence element, 'label'
  end

  def validate_list_element(element)
    validate_primitive_element element
    validate_content element

    if element['content'].is_a? Array
      element['content'].each do |item|
        validate_item item, element['reference']
      end
    end
  end

  def validate_item(element, reference)
    validate_presence element, 'value', "#{reference}'s item"
    validate_presence element, 'label', "#{reference}'s item"
  end

  def validate_presence(element, key, label = 'element')
    if element[key].blank?
      errors << "The #{key} of #{element['reference']} #{label} element should not be blank"
    end
  end

  def validate_content(element)
    if element['content'].blank? || !element['content'].is_a?(Array)
      errors << "The content of the #{element['reference']} should not be empty"
    end
  end

  def validate_type(element, value)
    if element['type'] != value
      errors << "The type of the #{element['reference']} element should be #{value}"
    end
  end
end