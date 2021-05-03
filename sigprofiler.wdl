Version 1.0

workflow sigprofiler {

  input {
    File vcfFile
    String outputFileNamePrefix
  }

  parameter_meta {
    vcfFile: "file to extract signatures from"
    vcfIndex: "Prefix for filename"
  }

  call sigproSS {
    input:
     vcfFile = vcfFile,
     outputFileNamePrefix = outputFileNamePrefix }

  output {
    File decompositionprofile = sigproSS.decompositionprofile
    File mutationprobabilities = sigproSS.mutationprobabilities
    File sigactivities = sigproSS.igactivities
    File signatures = sigproSS.signatures
  }

  meta {
    author: "Alexander Fortuna"
    email: "alexander.fortuna@oicr.on.ca"
    description: "Workflow to detect signatures from snvs and indels"
    dependencies: [
     {
       name: "sigprofilematrixgenerator/1.1",
       url: "https://github.com/AlexandrovLab/SigProfilerMatrixGenerator"
     },
     {
       name: "sigprofilerextractor/1.1",
       url: "https://github.com/AlexandrovLab/SigProfilerExtractor"
     },
     {
       name: "sigpross/0.0.0.27",
       url: "https://github.com/AlexandrovLab/SigProfilerSingleSample"
     }
    ]
  }
}

task sigproSS {

  input {
  	File vcfFile
  	String outputFileNamePrefix
    String reference_genome = "GRCh38"
    String opportunity_genome = "GRCh38"
  	String modules = "sigpross/0.0.0.27 sigprofilerextractor/1.1 sigprofilematrixgenerator/1.1"
	  Int jobMemory = 8
	  Int threads = 4
  	Int timeout = 1
  }

  parameter_meta {
  	vcfFile: "JSON result file from bamQCMetrics"
  	outputFileNamePrefix: "Prefix for output file"
  	modules: "required environment modules"
    memory: "Memory allocated for this job"
  	threads: "Requested CPU threads"
  	timeout: "hours before task timeout"
  }

  runtime {
  	modules: "~{modules}"
    memory:  "~{jobMemory} GB"
	  cpu:     "~{threads}"
  	timeout: "~{timeout}"
  }

  command <<<
      python3 <<CODE
      from SigProfilerExtractor import sigpro as sig
      from sigproSS import spss
      from os.path import dirname, isdir, basename
      import os
      import shutil
      import gzip
      #create output directory
      os.mkdir("~{outputFileNamePrefix}")
      #copy vcf file into directory
      with gzip.open(vcfFile, 'rt') as old_file, open(outputFileNamePrefix + "/" + basename(vcfFile[:-3]), 'w') as new_file:
          new_file.write(old_file.read())
      # run signature extractor
      spss.single_sample("~{outputFileNamePrefix}", "~{outputFileNamePrefix}/results", ref="~{reference_genome}", exome=False)
      shutil.move("results", "~{outputFileNamePrefix}" + "/" + "results")
      shutil.move("~{outputFileNamePrefix}" + "/" + "results" + "/" + "decomposition profile.csv", "~{outputFileNamePrefix}" + "/" + "results" + "/" + "decompositionprofile.csv")
      CODE
  >>>

  output {
  	  File decompositionprofile = "~{outputFileNamePrefix}"/decomposition_profile.csv
      File mutationprobabilities = "~{outputFileNamePrefix}"/Mutation_Probabilities.txt
      File sigactivities = "~{outputFileNamePrefix}"/Sig_activities.txt
      File signatures = "~{outputFileNamePrefix}"/Signatures.txt
  }

  meta {
	    output_meta: {
        decompositionprofile: "summary of global nmf sigatures"
        mutationprobabilities: "table summarizing probability of each mutation by signature"
        sigactivities: "number of mutations attributed to each signature"
        signatures: "attribution of each mutation to each signature"
	  }
  }
}
