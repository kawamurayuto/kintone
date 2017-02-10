require 'spec_helper'
require 'kintone/command/record_status'
require 'kintone/api'

describe Kintone::Command::RecordStatus do
  let(:target) { Kintone::Command::RecordStatus.new(api) }
  let(:api) { Kintone::Api.new('www.example.com', 'Administrator', 'cybozu') }

  describe '#update' do
    before(:each) do
      stub_request(
        :put,
        'https://www.example.com/k/v1/record/status.json'
      )
        .with(body: request_body.to_json)
        .to_return(
          body: response_body.to_json,
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.update(app, id, action) }

    let(:app) { 4 }
    let(:id) { 1 }
    let(:action) { '申請する' }
    let(:response_body) { { revision: '2' } }

    context 'without revision' do
      let(:request_body) { { 'app' => 4, 'id' => 1, 'action' => action } }

      it { expect(subject).to match 'revision' => '2' }
    end

    context 'with revision' do
      subject { target.update(app, id, action, revision: revision) }

      let(:revision) { 1 }
      let(:request_body) { { 'app' => 4, 'id' => 1, 'action' => action, 'revision' => 1 } }

      it { expect(subject).to match 'revision' => '2' }
    end

    context 'with assignee' do
      subject { target.update(app, id, action, assignee: assignee) }

      let(:assignee) { 'Administrator' }
      let(:request_body) { { 'app' => 4, 'id' => 1, 'action' => action, 'assignee' => assignee } }

      it { expect(subject).to match 'revision' => '2' }
    end

    context 'fail to request' do
      before(:each) do
        stub_request(
          :put,
          'https://www.example.com/k/v1/record/status.json'
        )
          .with(body: request_body.to_json)
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      let(:request_body) { { 'app' => 4, 'id' => 1, 'action' => action } }

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end
end
