
include ForwardTo
    
describe "ForwardTo" do
  it 'has a version number' do
    expect(ForwardTo::VERSION).not_to be_nil
  end

  describe "ForwardTo::ForwardTo" do
    klass = Class.new do
#     attr_accessor :var
#     forward_to :@value, :var, :var=
      forward_to :@array, :size, :+, :[], :[]=
      def initialize() 
        @var = "val"
        @array = [1, 2, 3] 
      end
    end

    let(:a) { klass.new }

    context "when included" do
      it "creates a #forward_to method on Kernel" do
        expect(Kernel.methods).to include :forward_to
      end
    end

    context "the #forward_to method" do
      it "forwards the given methods to the forwarding object" do
        expect(a.size).to eq 3
        expect(a[1]).to eq 2
        expect(a + [4, 5]).to eq [1, 2, 3, 4, 5]
      end
      it "handles #[]=" do
        expect(a[0] = 2).to eq 2
        expect(a[0] += 10).to eq 12
        expect(a[0]).to eq 12
      end
#     it "handles #<name>=" do
#       expect(a.var).to eq "val"
#       expect { a.var = "VAL" }.not_to raise_error
#       expect(a.var).to eq "VAL"
#     end
      it "handles block arguments"
    end
  end
end
