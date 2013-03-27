module Celluloid
  # A proxy which sends asynchronous calls to an actor
  class AsyncProxy < AbstractProxy
    attr_reader :mailbox

    def initialize(actor)
      @mailbox, @klass = actor.mailbox, actor.subject.class.to_s
    end

    def inspect
      "#<Celluloid::AsyncProxy(#{@klass})>"
    end

    def method_missing(meth, *args, &block)
      if @mailbox == ::Thread.current[:celluloid_mailbox]
        Actor.async @mailbox, :__send__, meth, *args, &block
      else
        Actor.async @mailbox, meth, *args, &block
      end
    end
  end
end
