class QuestionnairesController < ApplicationController
  def show
    @questionnaire = Questionnaire.find_by reference: params[:id]
    render json: @questionnaire.object
  end

  def new
    @questionnaire = Questionnaire.new
  end

  def create
    @questionnaire = Questionnaire.new object: YAML.load(params[:questionnaire][:file].read)
    if @questionnaire.save
      redirect_to new_questionnaire_path, notice: "L'upload du questionnaire a réussi"
    else
      render :new
    end
  end
end
