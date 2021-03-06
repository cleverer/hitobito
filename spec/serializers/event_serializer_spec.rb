#  Copyright (c) 2018, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.
#
# == Schema Information
#
# Table name: events
#
#  id                          :integer          not null, primary key
#  type                        :string(255)
#  name                        :string(255)      not null
#  number                      :string(255)
#  motto                       :string(255)
#  cost                        :string(255)
#  maximum_participants        :integer
#  contact_id                  :integer
#  description                 :text(65535)
#  location                    :text(65535)
#  application_opening_at      :date
#  application_closing_at      :date
#  application_conditions      :text(65535)
#  kind_id                     :integer
#  state                       :string(60)
#  priorization                :boolean          default(FALSE), not null
#  requires_approval           :boolean          default(FALSE), not null
#  created_at                  :datetime
#  updated_at                  :datetime
#  participant_count           :integer          default(0)
#  application_contact_id      :integer
#  external_applications       :boolean          default(FALSE)
#  applicant_count             :integer          default(0)
#  teamer_count                :integer          default(0)
#  signature                   :boolean
#  signature_confirmation      :boolean
#  signature_confirmation_text :string(255)
#  creator_id                  :integer
#  updater_id                  :integer
#  applications_cancelable     :boolean          default(FALSE), not null
#  required_contact_attrs      :text(65535)
#  hidden_contact_attrs        :text(65535)
#  display_booking_info        :boolean          default(TRUE), not null
#

require 'spec_helper'

describe EventSerializer do

  let(:event)      { events(:top_event).decorate }
  let(:controller) { double().as_null_object }
  let(:serializer) { EventSerializer.new(event, controller: controller)}
  let(:hash)       { serializer.to_hash.with_indifferent_access }

  subject { hash[:events].first }


  context 'event properties' do

    it 'includes all keys' do
      keys = [:name, :description, :motto, :cost, :maximum_participants, :participant_count,
       :location, :application_opening_at, :application_closing_at, :application_conditions,
       :state, :teamer_count, :external_application_link, :links]

      keys.each do |key|
        is_expected.to have_key(key)
      end
    end

    it 'includes dates properties' do
      keys = [:id, :label, :start_at, :finish_at, :location]
      keys.each do |key|
        expect(hash[:linked][:event_dates].first).to have_key(key)
      end

      expect(subject[:links]).to have_key(:dates)
    end

    it 'includes groups properties' do
      keys = [:id, :href, :group_type, :layer, :name, :short_name, :email, :address,
              :zip_code, :town, :country, :created_at, :updated_at]

      group = hash[:linked][:groups].first

      keys.each do |key|
        expect(group).to have_key(key)
      end

      expect(group[:links]).to have_key(:layer_group)
      expect(group[:links]).to have_key(:hierarchies)
      expect(group[:links]).to have_key(:children)
      expect(subject[:links]).to have_key(:groups)
    end

    it 'does not include kind' do
      expect(subject[:links]).not_to have_key(:kind)
    end

  end

  context 'coures properties' do
    let(:event) { events(:top_course).decorate }

    it 'includes kind properties' do
      keys = [:id, :label, :short_name, :minimum_age, :general_information, :application_conditions]
      keys.each do |key|
        expect(hash[:linked][:event_kinds].first).to have_key(key)
      end

      expect(subject[:links]).to have_key(:kind)
    end
  end

end
