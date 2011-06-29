class Event

  class EventInitializedError < Exception; end

  KEY_CODES = {
    8   => :backspace,
    9   => :tab,
    13  => :return,
    27  => :escape,
    32  => :space,
    37  => :left,
    38  => :up,
    39  => :right,
    40  => :down,
    46  => :delete
  }

  def initialize
    raise EventInitializedError, "Events cannot be manually created"
  end

  def stop
    prevent_defaut
    stop_propagation
  end

  def prevent_default
    `var evt = self.$evt;
    self.$default_prevented = true;
    evt.preventDefault ? evt.preventDefault() : evt.returnValue = false;`
    self
  end

  def default_prevented?
    `return self.$default_prevented ? Qtrue : Qfalse;`
  end

  def stop_propagation
    `var evt = self.$evt;
    self.$propagation_stopped = true;
    evt.stopPropagation ? evt.stopPropagation() : evt.cancelBubble = true;`
    self
  end

  def propagation_stopped?
    `return self.$propagation_stopped ? Qtrue : Qfalse;`
  end

  def target
    return @target if @target

    `var target = self.$evt.target;
    if (!target) { target = self.$et.srcElement || document; }`

    @target = Element.from_native `target`
  end

  def alt?
    `return self.$evt.altKey ? Qtrue : Qfalse;`
  end

  def ctrl?
    `return self.$evt.ctrlKey ? Qtrue : Qfalse;`
  end

  def shift?
    `return self.$evt.shiftKey ? Qtrue : Qfalse;`
  end

  def meta?
    `return self.$evt.metaKey ? Qtrue : Qfalse;`
  end

  def key
    return @key if @key

    `var code = self.$evt.which || self.$evt.keyCode;`
    key = KEY_CODES[`code`] || `$runtime.Y(String.fromCharCode(code))`
    @key = key
  end

  # Returns the type of the event, which is derived from the native
  # event. The type is a symbol that matches the usual javascript
  # event names.
  #
  # @example
  #
  #   Document[:some_element].mousedown { |e| puts e.type }
  #   # => :mousedown
  #
  # @return [Symbol]
  def type
    `return $rb.Y(self.$evt.type);`
  end

  # Returns the x position that the event took place at which is the
  # number of pixels from the left of the page including any pixels that
  # have scrolled out of view.
  #
  # @return [Numeric]
  def page_x
    `var evt = self.$evt, x;
    x = evt.pageX || evt.clientX + document.scrollLeft;
    return x;`
  end

  # Returns the y position that the event took place at which is the
  # number of pixels from the top of the page including any pixels that
  # have scrolled out of view.
  #
  # @return [Numeric]
  def page_y
    `var evt = self.$evt, y;
    y = evt.pageY || evt.clientY + document.scrollTop;
    return y;`
  end

  # Returns the x position that the event took place at in relation to
  # the browser's viewport.
  #
  # @return [Numeric]
  def client_x
    `var evt = self.$evt, x;
    x = evt.pageX ? evt.pageX - window.pageXOffset : evt.clientX;
    return x;`
  end

  # Returns the y position that the event took place at in relation to
  # the browser viewport.
  #
  # @return [Numeric]
  def client_y
    `var evt = self.$evt, y;
    y = evt.pageY ? evt.pageY - window.pageYOffset : evt.clientY;
    return y;`
  end

  # Create an instance from a native js event
  def self.from_native(evt)
    `var res = #{ allocate };
    res.$evt = evt;
    return res;`
  end
end # Event
