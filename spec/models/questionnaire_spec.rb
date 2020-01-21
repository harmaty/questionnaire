require 'rails_helper'

RSpec.describe Questionnaire, type: :model do
  describe '#validate?' do
    subject { Questionnaire.new(object: params).valid? }
    context 'when questionnaire content is missing' do
      let(:params) { { reference: 'sample', type: 'questionnaire' } }

      it { is_expected.to be_falsey }
    end

    context 'when questionnaire content is not a slide' do
      let(:params) {
        {
          reference: 'sample',
          type: 'questionnaire',
          content: [{
            reference: 'last_name',
            type: 'text_input',
            label: 'Quel est votre age ?'
          }]
        }
      }

      it { is_expected.to be_falsey }
    end

    context 'when questionnaire content is a slide without content' do
      let(:params) {
        {
            reference: 'sample',
            type: 'questionnaire',
            content: [{
              reference: 'slide1',
              type: 'slide',
              label: 'Informations personnelles'
            }]
        }
      }

      it { is_expected.to be_falsey }
    end

    context 'when questionnaire content is a slide with valid content' do
      let(:params) {
        {
            reference: 'sample',
            type: 'questionnaire',
            content: [{
                reference: 'slide1',
                type: 'slide',
                label: 'Informations personnelles',
                content: [{
                    reference: 'first_name',
                    type: 'text_input',
                    label: 'Quel est votre prénom ?'
                }]
            }]
        }
      }

      it { is_expected.to be_truthy }
    end
  end
end