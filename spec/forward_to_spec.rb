
include ForwardTo

describe "ForwardTo" do
  it 'has a version number' do
    expect(ForwardTo::VERSION).not_to be_nil
  end

  describe "#forward_to" do
    # The target class
    target_klass = Class.new do
      def var() @value end
      def var=(value) @value = value end
      def initialize()
        @value = "value"
      end
    end

    # The user class
    klass = Class.new do
      forward_to :@ref, :var, :var=
      forward_to :@array, :size, :+, :[], :[]=
      def initialize(target_klass)
        @ref = target_klass
        @array = [1, 2, 3]
      end
    end

    let(:a) { klass.new(target_klass.new) }

    it "forwards the given methods to the target object" do
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

  describe "#forward_to_class" do
    before do
      stub_const 'TargetKlass', Class.new
      TargetKlass.class_eval do
        def self.class_method() "TargetKlass::class_method"  end
      end

      stub_const 'Klass', Class.new
      Klass.class_eval do
        forward_to_class TargetKlass, :class_method
        forward_to_class :class_object, :keys, :values
        def self.class_object() { key: "val" } end
      end
    end

    context "when target is a class" do
      it "forwards the given class methods to the target class" do
        expect(Klass.class_method).to eq "TargetKlass::class_method"
      end
    end

    context "when target is a method symbol" do
      it "forwards the given class methods to the class method" do
        expect(Klass.keys).to eq [:key]
      end
    end
  end

  describe "#attr_forward" do
    target_klass = Class.new do
      def var() @value end
      def var=(value) @value = value end
      def initialize()
        @value = "value"
      end
    end

    klass = Class.new do
      attr_forward :ref, :var, :var=
      attr_forward :array, :size, :+, :[], :[]=
      def initialize(target_klass)
        @ref = target_klass
        @array = [1, 2, 3]
      end
    end

    let(:a) { klass.new(target_klass.new) }

    it "create an attr_reader for the forwarding object" do
      expect(a.ref.var).to eq "value"
      expect(a.array).to eq [1, 2, 3]
    end

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
