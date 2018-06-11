# encoding: utf-8

#  Copyright (c) 2012-2018, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.
require 'spec_helper'

describe InvoiceMailer do

  let(:invoice) { invoices(:invoice) }
  let(:sender) { people(:bottom_member) }
  let(:mail) { InvoiceMailer.notification(invoice, sender) }
  let(:html) { mail.body.parts.find { |p| p.content_type =~/html/ }.to_s }
  let(:pdf) { mail.body.parts.find { |p| p.content_type =~/pdf/ } }

  subject { mail }

  its(:to)        { should == [invoice.recipient.email] }
  its(:reply_to)  { should == [sender.email] }
  its(:subject)   { should =~ /Rechnung \d+-\d+ von Bottom One/ }

  it 'renders body if invoice.recipient is missing' do
    invoice.update(recipient: nil, recipient_email: 'test@example.com')
    expect(html).to match('test@example.com')
  end

  describe :html_body do
    it 'includes group address' do
      expect(html).to match(/Absender: Bottom One, 3000 Bern/)
    end

    it 'lists pins items' do
      expect(html).to match(/pins.*0.50 CHF/)
    end

    it 'has calculated total' do
      expect(html).to match(/Total inkl\. MWSt\..*5\.35 CHF/)
    end
  end

  describe :pdf_body do
    it 'includes filename' do
      expect(pdf.content_type).to match(/filename=#{invoice.filename}/)
    end
  end

end