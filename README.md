# sigProfiler

Workflow to detect signatures from snvs and indels

## Overview

## Dependencies

* [sigprofilematrixgenerator 1.1](https://github.com/AlexandrovLab/SigProfilerMatrixGenerator)
* [sigprofilerextractor 1.1](https://github.com/AlexandrovLab/SigProfilerExtractor)


## Usage

### Cromwell
```
java -jar cromwell.jar run sigProfiler.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`vcfFile`|File|file to extract signatures from
`vcfIndex`|File|Prefix for filename
`outputFileNamePrefix`|String|Output filename for signatuer folder


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`extractSignature.reference_genome`|String|"GRCh38"|The name of the reference genome
`extractSignature.opportunity_genome`|String|"GRCh38"|The build or version of the reference signatures for the reference genome
`extractSignature.input_type`|String|"vcf"|the type of input, vcf or matrix
`extractSignature.modules`|String|"sigprofilerextractor/1.1"|required environment modules
`extractSignature.jobMemory`|Int|8|Memory allocated for this job
`extractSignature.threads`|Int|4|Requested CPU threads
`extractSignature.timeout`|Int|1|hours before task timeout


### Outputs

Output | Type | Description
---|---|---
`result`|File|JSON file of collated results


## Niassa + Cromwell

This WDL workflow is wrapped in a Niassa workflow (https://github.com/oicr-gsi/pipedev/tree/master/pipedev-niassa-cromwell-workflow) so that it can used with the Niassa metadata tracking system (https://github.com/oicr-gsi/niassa).

* Building
```
mvn clean install
```

* Testing
```
mvn clean verify \
-Djava_opts="-Xmx1g -XX:+UseG1GC -XX:+UseStringDeduplication" \
-DrunTestThreads=2 \
-DskipITs=false \
-DskipRunITs=false \
-DworkingDirectory=/path/to/tmp/ \
-DschedulingHost=niassa_oozie_host \
-DwebserviceUrl=http://niassa-url:8080 \
-DwebserviceUser=niassa_user \
-DwebservicePassword=niassa_user_password \
-Dcromwell-host=http://cromwell-url:8000
```

## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
