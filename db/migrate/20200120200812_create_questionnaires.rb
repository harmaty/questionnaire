class CreateQuestionnaires < ActiveRecord::Migration[6.0]
  def change
    create_table :questionnaires do |t|
      t.string :reference, index: true
      t.jsonb :object, null: false

      t.timestamps
    end
  end
end
