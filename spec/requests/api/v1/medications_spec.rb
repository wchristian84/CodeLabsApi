require 'swagger_helper'
require 'faker'
require 'factory_bot'

RSpec.describe 'api/v1/medications', type: :request do
  user = FactoryBot.create(:user)
  token = FactoryBot.create(:token, user_id: user.id)
  medication = FactoryBot.create(:medication, user_id: user.id)
  no_meds_user = FactoryBot.create(:user)
  no_meds_token = FactoryBot.create(:token, user_id: no_meds_user.id)

  path '/api/v1/medications/new' do
    post('new medication') do
        tags "Medications"
        description "Creates a new medication record"
        consumes 'application/json'
        produces 'application/json'
        security [bearer_auth: []]
        parameter name: :new_medication, in: :body, schema: { '$ref' => '#/components/schemas/new_medication'}
        response "200", "success" do
          let(:Authorization) { "Bearer " + token.value }
          let(:new_medication) { {
            name: medication.name, 
            dosage: medication.dosage,
            frequency: medication.frequency,
            date: medication.date,
            day: medication.day,
            benefits: medication.benefits,
            side_effects: medication.side_effects,
            start_date: medication.start_date,
            stop_date: medication.stop_date,
            reason_stopped: medication.reason_stopped,
            is_current: medication.is_current,
            morning: medication.morning,
            midday: medication.midday,
            evening: medication.evening,
            night: medication.night,
            user_id: medication.user_id
          } }
          it 'returns a valid 200 response' do |example|
            assert_response_matches_metadata(example.metadata)
          end
          after do |example|
            example.metadata[:response][:content] = {
              'application/json' => {
                example: JSON.parse(response.body, symbolize_names: true)
              }
            }
          end
        run_test!
      end
      
      response "401", "authentication failed" do
        let(:Authorization) { "Bearer #{::Base64.strict_encode64('bogus:bogus')}" }
        let(:new_medication) { {
            name: medication.name, 
            dosage: medication.dosage,
            frequency: medication.frequency,
            date: medication.date,
            day: medication.day,
            benefits: medication.benefits,
            side_effects: medication.side_effects,
            start_date: medication.start_date,
            stop_date: medication.stop_date,
            reason_stopped: medication.reason_stopped,
            is_current: medication.is_current,
            morning: medication.morning,
            midday: medication.midday,
            evening: medication.evening,
            night: medication.night,
            user_id: medication.user_id
          } }
        it 'returns a valid 401 response' do |example|
          assert_response_matches_metadata(example.metadata)
        end
        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json"=>{
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end
        schema '$ref' => '#/components/schemas/bad_credentials'
        run_test!
      end
    end
  end

  path '/api/v1/medications/meds' do

    get('meds medication') do
      tags "Medications"
      description "Retrieves user's stored medications"
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      # parameter name: :user_id, in: :query, schema: { '$ref' => '#/components/schemas/meds_medication'}, description: "Logged in users id", required: true
      response(200, 'successful') do
        let(:Authorization) { "Bearer " + token.value }
        FactoryBot.create(:medication, user_id: token.user_id)
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    
      response "400", "no meds found" do
        let(:Authorization) { "Bearer " + no_meds_token.value }
        it 'returns a valid 400 response' do |example|
          assert_response_matches_metadata(example.metadata)
        end
        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json"=>{
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end
        schema '$ref' => '#/components/schemas/no_meds'
        run_test!
      end
    end
  end
    
  



  path '/api/v1/medications/delete' do

    delete('delete medication') do      
      tags "Medications"
      description "Retrieves user's stored medications"
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :delete_medication, in: :body, schema: { '$ref' => '#/components/schemas/delete_medication'}
      response(200, 'successful') do
        let(:Authorization) { "Bearer " + token.value }
        let(:delete_medication) { {user_id: user.id, med_id: medication.id } }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
    response "400", "Error deleting medication" do
      to_delete = FactoryBot.create(:medication, user_id: token.user_id)
      let(:Authorization) { "Bearer #{token.value}" }
      let(:delete_medication) { {user_id: no_meds_user.id, med_id: to_delete.id} }
      after do |example|
        content = example.metadata[:response][:content] || {}
        example_spec = {
          "application/json"=>{
            examples: {
              test_example: {
                value: JSON.parse(response.body, symbolize_names: true)
              }
            }
          }
        }
        example.metadata[:response][:content] = content.deep_merge(example_spec)
      end
      schema '$ref' => '#/components/schemas/delete_failed'
      run_test!
    end
  end

  path '/api/v1/medications/edit' do

    patch('edit medication') do
      tags "Medications"
      description "Edits a stored medication"
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :edit_medication, in: :body, schema: { '$ref' => '#/components/schemas/edit_medication'}
      response(200, 'successful') do
        let(:Authorization) { "Bearer " + token.value }
        let(:edit_medication) { {
          id: medication.id,
          name: "updated name", 
          dosage: medication.dosage,
          frequency: medication.frequency,
          date: medication.date,
          day: medication.day,
          benefits: medication.benefits,
          side_effects: medication.side_effects,
          start_date: medication.start_date,
          stop_date: medication.stop_date,
          reason_stopped: medication.reason_stopped,
          is_current: medication.is_current,
          morning: medication.morning,
          midday: medication.midday,
          evening: medication.evening,
          night: medication.night,
          user_id: medication.user_id
        } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
    response "400", "Error updating medication" do
      let(:Authorization) { "Bearer " + token.value }
      let(:edit_medication) { {
        id: medication.id,
        name: "updated name", 
        dosage: medication.dosage,
        frequency: medication.frequency,
        date: medication.date,
        day: medication.day,
        benefits: medication.benefits,
        side_effects: medication.side_effects,
        start_date: medication.start_date,
        stop_date: medication.stop_date,
        reason_stopped: medication.reason_stopped,
        is_current: medication.is_current,
        morning: medication.morning,
        midday: medication.midday,
        evening: medication.evening,
        night: medication.night,
        user_id: no_meds_user.id
      } }
      after do |example|
        content = example.metadata[:response][:content] || {}
        example_spec = {
          "application/json"=>{
            examples: {
              test_example: {
                value: JSON.parse(response.body, symbolize_names: true)
              }
            }
          }
        }
        example.metadata[:response][:content] = content.deep_merge(example_spec)
      end
      schema '$ref' => '#/components/schemas/edit_failed'
      run_test!
    end
  
  end
end
