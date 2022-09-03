
include ForwardTo
    
describe "ForwardTo" do
  it 'has a version number' do
    expect(ForwardTo::VERSION).not_to be_nil
  end

  describe "ForwardTo::ForwardTo" do
    refklass = Class.new do
      def var() @value end
      def var=(value) @value = value end
      def initialize()
        @value = "value"
      end
    end

    klass = Class.new do
      forward_to :@ref, :var, :var=
      forward_to :@array, :size, :+, :[], :[]=
      def initialize(refklass) 
        @ref = refklass
        @array = [1, 2, 3] 
      end
    end

    let(:a) { klass.new(refklass.new) }

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
      it "handles #=" do
        expect(a.var).to eq "value"
        expect { a.var = "VALUE" }.not_to raise_error
        expect(a.var).to eq "VALUE"
      end
      it "handles block arguments"
    end
  end
end
