require 'rspec/core'
require 'rspec/core/rake_task'
require 'rdf'
require 'rdf/rdfxml'

namespace :scholarsphere do

  desc "Execute Continuous Integration build (docs, tests with coverage)"
  task :ci do
    #Rake::Task["hyhead:doc"].invoke
    Rake::Task["jetty:config"].invoke
    Rake::Task["db:migrate"].invoke
    
    require 'jettywrapper'
    jetty_params = Jettywrapper.load_config.merge({:jetty_home => File.expand_path(File.dirname(__FILE__) + '/../jetty')})
    
    error = nil
    error = Jettywrapper.wrap(jetty_params) do
        Rake::Task['spec'].invoke
        Rake::Task['cucumber:ok'].invoke
    end
    raise "test failures: #{error}" if error
  end

  namespace :export do
    desc "Dump metadata as RDF/XML for e.g. Summon integration"
    task :rdfxml => :environment do 
      raise "rake scholarsphere:export:rdfxml output=FILE" unless ENV['output']
      export_file = ENV['output']
      triples = RDF::Repository.new
      rows = GenericFile.count
      GenericFile.find(:all, :rows => rows).each do |gf|
        next unless ["read", "discover"].include? gf.rightsMetadata.groups["public"] 
        next unless gf.descMetadata.content
        RDF::Reader.for(:ntriples).new(gf.descMetadata.content) do |reader|
          reader.each_statement do |statement|
            triples << statement
          end
        end
      end
      unless triples.empty?
        RDF::Writer.for(:rdfxml).open(export_file) do |writer|
          writer << triples
        end
      end
    end
  end

  namespace :harvest do
    desc "Harvest LC subjects"
    task :lc_subjects => :environment do |cmd, args|
      vocabs = ["/tmp/subjects-skos.nt"]
      LocalAuthority.harvest_rdf(cmd.to_s.split(":").last, vocabs)
    end

    desc "Harvest DBpedia titles"
    task :dbpedia_titles => :environment do |cmd, args|
      vocabs = ["/tmp/labels_en.nt"]
      LocalAuthority.harvest_rdf(cmd.to_s.split(":").last, vocabs, :predicate => RDF::RDFS.label)
    end

    desc "Harvest DBpedia categories"
    task :dbpedia_categories => :environment do |cmd, args|
      vocabs = ["/tmp/category_labels_en.nt"]
      LocalAuthority.harvest_rdf(cmd.to_s.split(":").last, vocabs, :predicate => RDF::RDFS.label)
    end

    desc "Harvest LC MARC geographic areas"
    task :lc_geographic => :environment do |cmd, args|
      vocabs = ["/tmp/vocabularygeographicAreas.nt"]
      LocalAuthority.harvest_rdf(cmd.to_s.split(":").last, vocabs)
    end

    desc "Harvest Geonames cities"
    task :geonames_cities => :environment do |cmd, args|
      vocabs = ["/tmp/cities1000.txt"]
      LocalAuthority.harvest_tsv(cmd.to_s.split(":").last, vocabs, :prefix => 'http://sws.geonames.org/')
    end

    desc "Harvest Lexvo languages"
    task :lexvo_languages => :environment do |cmd, args|
      vocabs = ["/tmp/lexvo_2012-03-04.rdf"]
      LocalAuthority.harvest_rdf(cmd.to_s.split(":").last, vocabs,
                                 :format => 'rdfxml', 
                                 :predicate => RDF::URI("http://www.w3.org/2008/05/skos#prefLabel"))
    end

    desc "Harvest LC genres"
    task :lc_genres => :environment do |cmd, args|
      vocabs = ["/tmp/authoritiesgenreForms.nt"]
      LocalAuthority.harvest_rdf(cmd.to_s.split(":").last, vocabs)
    end

    desc "Harvest LC name authorities"
    task :lc_names => :environment do |cmd, args|
      vocabs = ["/tmp/authoritiesnames.nt.skos"]
      LocalAuthority.harvest_rdf(cmd.to_s.split(":").last, vocabs)
    end

    desc "Harvest LC thesaurus of graphic materials"
    task :lc_graphics => :environment do |cmd, args|
      vocabs = ["/tmp/vocabularygraphicMaterials.nt"]
      LocalAuthority.harvest_rdf(cmd.to_s.split(":").last, vocabs)
    end
  end
end