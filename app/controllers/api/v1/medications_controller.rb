module Api
  module V1
    class MedicationsController < Api::V1::ApplicationController
    before_action :authenticate

      def delete
        render_error(errors: "Error deleting medication", status: 400) unless params[:user_id] == @current_user.id
        result = PracticeApi::Medications.destroy(params)
        render_error(errors: "Error deleting medication", status: 400) and return unless result.success?

        render_success(payload: result.payload, status: 200)
      end

      def edit
        render_error(errors: "Error updating medication", status: 400) unless params[:user_id] == @current_user.id
        result = PracticeApi::Medications.edit_med(params)

        render_error(errors: "Error updating medication", status: 400) and return unless result.success?
        render_success(payload: result.payload, status: 200)
      end

      def meds
        render_error(errors: "Error retrieving medications", status: 400) unless params[:user_id] == @current_user.id
        result = PracticeApi::Medications.return_meds(params[:user_id])
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
