#
# This file is largely to help with common imports/tooling needed to load
# redstorm into an RSpec test environment properly
#

module Backtype
  java_import 'backtype.storm.Config'
end

java_import 'redstorm.storm.jruby.JRubyBolt'
java_import 'redstorm.storm.jruby.JRubySpout'
java_import 'redstorm.storm.jruby.JRubyBatchBolt'
java_import 'redstorm.storm.jruby.JRubyBatchCommitterBolt'
java_import 'redstorm.storm.jruby.JRubyBatchSpout'
java_import 'redstorm.storm.jruby.JRubyTransactionalSpout'
java_import 'redstorm.storm.jruby.JRubyTransactionalBolt'
java_import 'redstorm.storm.jruby.JRubyTransactionalCommitterBolt'

java_import 'backtype.storm.Testing'
java_import 'backtype.storm.tuple.Values'
java_import 'backtype.storm.tuple.Fields'
java_import 'backtype.storm.testing.MkTupleParam'
java_import 'backtype.storm.testing.MkClusterParam'
java_import 'backtype.storm.testing.TestJob'
java_import 'backtype.storm.testing.MockedSources'
java_import 'backtype.storm.testing.CompleteTopologyParam'

# This goes in its own module so that logback.Logger's being final doesn't
# conflict with Protobuf's need to reopen Logger
module Logback
  include_package 'ch.qos.logback.classic'

  # Quiet logback, if we're using that and not slf4j-nop
  # (Storm will log stuff here; this does not affect logging within our
  # application or toologies.)
  java_import 'org.slf4j.LoggerFactory'
  java_import 'ch.qos.logback.classic.Level'
  java_import 'ch.qos.logback.classic.Logger'

  root = LoggerFactory.get_logger(Logger::ROOT_LOGGER_NAME)
  # If root is a ch.qos.logback.classic Logger
  if root.is_a? Logger
    root.set_level(Level::OFF)
  end
end

require 'zookeeper'
class NullLogger
  def method_missing(meth, *args, &block);end
end
Zookeeper::Logger.wrapped_logger = NullLogger.new

