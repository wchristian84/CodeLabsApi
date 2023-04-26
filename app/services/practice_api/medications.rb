# frozen_string_literal: true

module PracticeApi
  module Medications
    def self.create(params)

      user = User.find_by(id: params[:user_id])
      medication = user.medications.new(
        name: params[:name],
        dosage: params[:dosage],
        frequency: params[:frequency],
        date: params[:date],
        day: params[:day],
        benefits: params[:benefits],
        side_effects: params[:side_effects],
        start_date: params[:start_date],
        stop_date: params[:stop_date],
        reason_stopped: params[:reason_stopped],
        is_current: params[:is_current],
        morning: params[:morning],
        midday: params[:midday],
        evening: params[:evening],
        night: params[:night], 
      )
      return ServiceContract.error('Error creating medication.') unless medication.save

      ServiceContract.success([medication])
    end

    def self.destroy(params)
      medication = Medication.find(params[:med_id])
      if medication
        return ServiceContract.error('Error deleting medication') unless medication.destroy
        ServiceContract.success(payload: "Medication successfully deleted")
      end
    end

    def self.edit_med(params)
      editedMed = Medication.find(params[:id])
      if editedMed
        editedMed.update(
          name: params[:name],
          dosage: params[:dosage],
          frequency: params[:frequency],
          date: params[:date],
          day: params[:day],
          benefits: params[:benefits],
          side_effects: params[:side_effects],
          start_date: params[:start_date],
          stop_date: params[:stop_date],
          reason_stopped: params[:reason_stopped],
          is_current: params[:is_current],
          morning: params[:morning],
          midday: params[:midday],
          evening: params[:evening],
          night: params[:night]
        )
        return ServiceContract.error('Error updating medication.') unless editedMed.save
        ServiceContract.success(editedMed)
      else
        return ServiceContract.error("Medication doesn't exist on current user")
      end
    end

    def self.return_meds(user_id)
    
      user_meds = Medication.find_by(user_id: user_id)
      
      return ServiceContract.error("Error retrieving medications") unless user_meds
      ServiceContract.success(user_meds)
    end
  end
end
