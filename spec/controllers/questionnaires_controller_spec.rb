require 'rails_helper'

RSpec.describe QuestionnairesController, type: :controller do
  describe '#create' do

    context 'valid yml file' do
      it 'redirects with success' do
        post :create, params: {
            questionnaire:
                { file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/questionnaire.yml") }
        }
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq("L'upload du questionnaire a réussi")
      end
    end

    context 'invalid yml file' do
      it 'redirects with success' do
        post :create, params: {
            questionnaire:
                { file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/invalid.yml") }
        }
        expect(response).to have_http_status(200)
        expect(assigns(:questionnaire).errors).to_not be_empty
      end
    end
  end
end