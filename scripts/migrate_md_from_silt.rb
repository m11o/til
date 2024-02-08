require 'nokogiri'
require 'fileutils'

root_dir = File.expand_path('..', __dir__)

silt_dir = File.expand_path('../../silt', __dir__)
silt_files = Dir.glob("#{silt_dir}/**/*.md")

class Node
  attr_accessor :filename, :children, :parent

  SILT_DIR = File.expand_path('../../silt', __dir__)
  ROOT_DIR = File.expand_path('..', __dir__)

  def initialize(filename, parent = nil)
    @filename = filename
    @children = []
    @parent = parent
  end

  def add_child(child, descendants = [])
    if child == 'notes'
      return # 何もしない
    end

    children = self.children
    child_node = children.find { |node| node.filename == child }
    if child_node.nil?
      child_node = Node.new(child, self) if child_node.nil?
      self.children << child_node
      if child =~ /\.md/
        FileUtils.cp("#{SILT_DIR}/#{child_node.path}", "#{ROOT_DIR}/Writerside/topics/#{child}")
      else
        File.open("#{ROOT_DIR}/Writerside/topics/#{child}.md", 'w') do |f|
          f.write <<~EOS
            # #{child}
          EOS
        end
      end
    end

    descendant = descendants.shift
    if !descendant.nil?
      child_node.add_child(descendant, descendants)
    end
  end

  def build_filename_with_extension(file)
    "#{File.basename(file, ".md")}.md"
  end

  def to_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.doc.create_internal_subset(
        'instance-profile',
        "SYSTEM",
        "https://resources.jetbrains.com/writerside/1.0/product-profile.dtd"
      )
      xml.send('instance-profile', { id: 'til', name: 'til', 'start-page' => 'starter-topic.md' }) do
        create_xml_node(xml)
      end
    end
    builder.to_xml
  end

  def create_xml_node(xml)
    xml.send('toc-element', topic: "#{build_filename_with_extension(filename)}") do
      self.children.each do |child|
        child.create_xml_node(xml)
      end
    end
  end

  def path
    if self.parent.nil?
      ''
    else
      "#{self.parent.path}/#{self.filename}"
    end
  end
end

root_node = Node.new('root')
silt_files.each do |file|
  basename = File.basename(file)
  next if (basename == 'README.md')

  parents = file.split('/')[4..-1]
  root_node.add_child(parents.shift, parents)
end

File.open("#{root_dir}/Writerside/til.tree", 'w') do |f|
  f.write(root_node.to_xml)
end
