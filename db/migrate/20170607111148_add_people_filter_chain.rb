# encoding: utf-8

#  Copyright (c) 2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class AddPeopleFilterChain < ActiveRecord::Migration
  def change
    add_column :people_filters, :filter_chain, :text
    add_column :people_filters, :range, :string, default: 'deep'

    add_column :people_filters, :created_at, :timestamp
    add_column :people_filters, :updated_at, :timestamp
  end
end
