RSpec.describe Capistrano::Revision do
  it "has a version number" do
    expect(Capistrano::Revision::VERSION).not_to be nil
  end

  describe "#latest?" do
    subject { described_class.latest? }
    before do
      allow(described_class).to receive(:current).and_return current
      allow(described_class).to receive(:deployed).and_return deployed
    end

    context "on development" do
      let(:current) { nil }
      let(:deployed) { nil }

      it { should be_truthy }
    end

    context "REVISION が無いとき" do
      let(:current) { nil }
      let(:deployed) { "a" }

      it { should be_falsy }
    end

    context "revision.log が読めなかったとき" do
      let(:current) { "a" }
      let(:deployed) { nil }

      it { should be_falsy }
    end

    context "一致する時" do
      let(:current) { "a" }
      let(:deployed) { "a" }

      it { should be_truthy }
    end

    context "一致しない時" do
      let(:current) { "a" }
      let(:deployed) { "b" }

      it { should be_falsy }
    end
  end

  describe "#tail" do
    subject { described_class.tail filename }

    context "normal case" do
      let(:filename) { "spec/fixtures/revisions.log" }

      it { should == "Branch master (at 1ba4170be1c0f259fdb7c44dc92ffc9bd8fc05bf) deployed as release 20170122151156 by ubuntu" }
    end

    context "empty log" do
      let(:filename) { "spec/fixtures/empty.log" }

      it { should be_nil }
    end

    describe "one line" do
      let(:filename) { "spec/fixtures/one_line.log" }

      it { should == "Branch master (at 9dafdf7511417845d5619c5d961403fd2c8d6d08) deployed as release 20170122145018 by ubuntu" }
    end

    context "long branch name" do
      let(:filename) { "spec/fixtures/long_branch.log" }

      it { should == "Branch long-long-branch-name (at 1bea8232ffb57cf287dca033c53dccdf9e068993) deployed as release 20170206150230 by ubuntu" }
    end
  end
end
