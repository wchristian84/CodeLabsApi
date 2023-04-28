module Api
  module V1
    class MedicationsController < Api::V1::ApplicationController
    before_action :authenticate

      def delete
        result = PracticeApi::Medications.destroy(params, @current_user.id)
        render_error(errors: "Error deleting medication", status: 400) and return unless result.success?
        
        render_success(payload: result.payload, status: 200)
      end

      def edit
        result = PracticeApi::Medications.edit_med(params, @current_user.id)

        render_error(errors: "Error updating medication", status: 400) and return unless result.success?
        render_success(payload: result.payload, status: 200)
      end

      def meds
        result = PracticeApi::Medications.return_meds(@current_user.id)
        render_error(errors: "no medications found", status: 400) and return unless result.success?
        
        render_success(payload: result.payload, status: 200)
        
      end

      def new
        result = PracticeApi::Medications.create(params)
        render_error(errors: "Error saving medication", status: 400) and return unless result.success?

        render_success(payload: result.payload, status: 200)
      end
    end
  end
end
