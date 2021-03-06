require 'java'
java_import 'java.lang.System'

module RedStorm
  CWD = Dir.pwd

  launch_path = File.expand_path(File.dirname(__FILE__))
  jar_context = !!(launch_path =~ /stormjar\.jar!\/red_storm$/)

  if jar_context
    BASE_PATH = 'uri:classloader:/'
    REDSTORM_HOME = BASE_PATH
    GEM_PATH = "#{REDSTORM_HOME}/gems/"
    # If we're in the "cluster" mode that means we're running in an embedded JRuby
    # and we should modify our environment to suit that.
    if env == :cluster
      Dir.chdir('uri:classloader:/')
      ENV['JARS_HOME'] = 'uri:classloader:/jars'
      $LOAD_PATH.unshift('uri:classloader://')
    end
  else
    BASE_PATH = CWD
    REDSTORM_HOME = File.expand_path(launch_path + '/../..')
    GEM_PATH = "#{BASE_PATH}/target/gems/"
  end

  unless defined?(SPECS_CONTEXT)
    ENV["GEM_PATH"] = GEM_PATH
    ENV["GEM_HOME"] = GEM_PATH
  end

  TARGET_DIR = "#{CWD}/target"
  TARGET_LIB_DIR = "#{TARGET_DIR}/lib"
  TARGET_SRC_DIR = "#{TARGET_DIR}/src"
  TARGET_GEM_DIR = "#{TARGET_DIR}/gems/gems"
  TARGET_SPECS_DIR = "#{TARGET_DIR}/gems/specifications"
  TARGET_CLASSES_DIR = "#{TARGET_DIR}/classes"
  TARGET_DEPENDENCY_DIR = "#{TARGET_DIR}/dependency"
  TARGET_DEPENDENCY_UNPACKED_DIR = "#{TARGET_DIR}/dependency-unpacked"
  TARGET_CLUSTER_JAR = "#{TARGET_DIR}/cluster-topology.jar"

  REDSTORM_JAVA_SRC_DIR = "#{REDSTORM_HOME}/src/main"
  REDSTORM_LIB_DIR = "#{REDSTORM_HOME}/lib"

  SRC_EXAMPLES = "#{REDSTORM_HOME}/examples"
  DST_EXAMPLES = "#{CWD}/examples"

  SRC_IVY_DIR = "#{REDSTORM_HOME}/ivy"
  DST_IVY_DIR = "#{CWD}/ivy"
  DEFAULT_IVY_SETTINGS = "#{SRC_IVY_DIR}/settings.xml"
  CUSTOM_IVY_SETTINGS = "#{DST_IVY_DIR}/settings.xml"
  DEFAULT_IVY_STORM_DEPENDENCIES = "#{SRC_IVY_DIR}/storm_dependencies.xml"
  CUSTOM_IVY_STORM_DEPENDENCIES = "#{DST_IVY_DIR}/storm_dependencies.xml"
  DEFAULT_IVY_TOPOLOGY_DEPENDENCIES = "#{SRC_IVY_DIR}/topology_dependencies.xml"
  CUSTOM_IVY_TOPOLOGY_DEPENDENCIES = "#{DST_IVY_DIR}/topology_dependencies.xml"

  DEFAULT_STORM_CONF_FILE = File.expand_path("$HOME/.storm/storm.yaml") rescue ''

  def current_ruby_mode
    RUBY_VERSION[/(\d+\.\d+)(\.\d+)*/, 1]
  end

  def jruby_mode_token(ruby_version = nil)
    version_map = {"1.8" => "RUBY1_8", "--1.8" => "RUBY1_8", "1.9" => "RUBY1_9", "--1.9" => "RUBY1_9"}
    version_map[ruby_version.to_s] || version_map[RedStorm.current_ruby_mode]
  end

  def java_runtime_version
    System.properties["java.runtime.version"].to_s[/^(\d+\.\d+).[^\s]+$/, 1] || raise("unknown java runtime version #{System.properties["java.runtime.version"].to_s}")
  end

  module_function :current_ruby_mode, :jruby_mode_token, :java_runtime_version
end
