Version 1.0

workflow sigProfiler {

  input {
    File vcfFile
    File vcfIndex
  }

  parameter_meta {
    vcfFile: "file to extract signatures from"
    vcfIndex: "Prefix for filename"
  }

  call generateMatrix {
    input:
     vcfFile = vcfFile,
     outputFileNamePrefix = outputFileNamePrefix }

  output {
    File result     = sigProfiler.result
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
     }
    ]
  }
}

task generateMatrix {

  input {
  	File vcfFile
  	String outputFileNamePrefix
    String reference_genome = "GRCh38"
    String opportunity_genome = "GRCh38"
    String input_type = "vcf"
    String out_put
    String input_data
  	String modules = "sigprofilerextractor/1.1"
	Int jobMemory = 8
	Int threads = 4
  	Int timeout = 1
  }

  parameter_meta {
  	vcfFile: "JSON result file from bamQCMetrics"
  	outputFileNamePrefix: "Prefix for output file"
  	modules: "required environment modules"
  	jobMemory: "Memory allocated for this job"
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
      from os.path import dirname, isdir, basename
      from os import mkdir
      import shutil
      #create output directory
      os.mkdir("~{outputFileNamePrefix}")
      #copy vcf file into directory
      shutil.copyfile("~{vcfFile}", "~{outputFileNamePrefix}" + "/" + basename("~{outputFileNamePrefix}"))
      # run signature extractor
      sig.sigProfilerExtractor(
        '~{input_type}',
        'output' + '/',
        "~{outputFileNamePrefix}" + "/" ,
        reference_genome='~{reference_genome}',
        opportunity_genome='~{opportunity_genome}',
        context_type='default',
        exome=False,
        minimum_signatures=1,
        maximum_signatures=10,
        nmf_replicates=100,
        resample=True,
        batch_size=1,
        cpu=-1,
        gpu=False,
        nmf_init='random',
        precision='single',
        matrix_normalization='gmm',
        seeds='none',
        min_nmf_iterations=10000,
        max_nmf_iterations=1000000,
        nmf_test_conv=10000,
        nmf_tolerance=1e-15,
        nnls_add_penalty=0.05,
        nnls_remove_penalty=0.01,
        initial_remove_penalty=0.05,
        de_novo_fit_penalty=0.02,
        get_all_signature_matrices=False,
        )
      CODE

       tar cf - "~{outputFileNamePrefix}"/output | gzip --no-name > "~{outputFileNamePrefix}".tar.gz
  >>>

  output {
  	 File result = "~{outputFileNamePrefix}".tar.gz
  }

  meta {
	  output_meta: {
        output1: "JSON file of collated results"
	  }
  }
}
