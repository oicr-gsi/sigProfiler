# sigprofiler

Workflow to detect signatures from snvs and indels

## Overview

## Dependencies

* [sigprofilematrixgenerator 1.1](https://github.com/AlexandrovLab/SigProfilerMatrixGenerator)
* [sigprofilerextractor 1.1](https://github.com/AlexandrovLab/SigProfilerExtractor)
* [sigpross 0.0.0.27](https://github.com/AlexandrovLab/SigProfilerSingleSample)


## Usage

### Cromwell
```
java -jar cromwell.jar run sigprofiler.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`vcfFile`|File|file to extract signatures from
`outputFileNamePrefix`|String|the file name prefix you wish to use


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`sigproSS.reference_genome`|String|"GRCh38"|the genome version used for variant calling
`sigproSS.modules`|String|"sigpross/0.0.0.27 sigprofilerextractor/1.1 sigprofilematrixgenerator/1.1"|required environment modules
`sigproSS.jobMemory`|Int|8|Memory allocated for this job
`sigproSS.threads`|Int|4|Requested CPU threads
`sigproSS.timeout`|Int|1|hours before task timeout


### Outputs

Output | Type | Description
---|---|---
`decompositionprofile`|File|summary of global nmf sigatures
`mutationprobabilities`|File|table summarizing probability of each mutation by signature
`sigactivities`|File|number of mutations attributed to each signature
`signatures`|File|attribution of each mutation to each signature


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
