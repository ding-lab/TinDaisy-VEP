# Perform post-call VCF filtering based on VAF, indel length, and read depth.
# Parses varscan, pindel, and strelka VCFs
# Filtering is performed by pyvcf-based scripts in ./vcf_filter
# Configuration file defines all adjustable filter parameters.
# Output filename is given by $output_vcf, written to $results_dir/vaf_length_depth_filters/$output_vcf

# Accepts options --bypass_vaf, --bypass_length, --bypass_depth

sub vaf_length_depth_filters {
    my $results_dir = shift;
    my $job_files_dir = shift;
    my $input_vcf = shift;  
    my $output_vcf = shift;  #
    my $caller = shift;  # optional.  If defined, should be strelka, varscan, or pindel
    my $vcf_filter_config = shift;
    my $bypass_vaf = shift;  # boolean: will skip filtering if defined
    my $bypass_length = shift;  # boolean: will skip filtering if defined
    my $bypass_depth = shift;  # boolean: will skip filtering if defined
    my $bypass = shift;  # boolean: will skip all filtering if defined
    my $debug = shift;  # boolean: will skip filtering if defined

    my $bypass_str = $bypass ? "--bypass" : "";
    $bypass_str = $bypass_vaf ? "--bypass_vaf $bypass_str" : "$bypass_str";
    $bypass_str = $bypass_length ? "--bypass_length $bypass_str" : "$bypass_str";
    $bypass_str = $bypass_depth ? "--bypass_depth $bypass_str" : "$bypass_str";
    my $debug_str = $debug ? "--debug" : "";
    die "Error: Input data file $input_vcf does not exist\n" if (! -e $input_vcf);

    # Caller can be defined on command line or in config file.  Here, command line definition
    my $caller_str = $caller ? "--caller $caller" : "";

    my $filter_results = "$results_dir/vaf_length_depth_filters";
    system("mkdir -p $filter_results");

# Create run script
    my $runfn = "$job_files_dir/j_caller_vcf_filter.sh";
    print STDERR "Writing to $runfn\n";
    open(OUT, ">$runfn") or die $!;

    my $vcf_filtered_fn = "$filter_results/$output_vcf";

# Run vcf_filter.py family of filters: VAF, read depth, and indel length

    print OUT <<"EOF";
#!/bin/bash

>&2 echo Running combined vcf_filter.py filters: VAF, read depth, and indel length
export PYTHONPATH="$SWpaths::filter_dir:\$PYTHONPATH"
bash $SWpaths::filter_dir/run_vaf_length_depth_filters.sh $input_vcf $vcf_filter_config $vcf_filtered_fn $bypass_str $debug_str $caller_str
rc=\$?
if [[ \$rc != 0 ]]; then
    >&2 echo Fatal error \$rc: \$!.  Exiting.
    exit \$rc;
fi

EOF
    close OUT;
    my $cmd = "bash < $runfn\n";
    print STDERR "Executing:\n $cmd \n";

    my $return_code = system ( $cmd );
    die("Exiting ($return_code).\n") if $return_code != 0;
}

1;
