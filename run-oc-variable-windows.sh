#!/bin/bash

# Window length constraints
WINDOW_MIN=${WINDOW_MIN-1}
WINDOW_MAX=${WINDOW_MAX-50}

# Input files
TOPIC_FILE=${TOPIC_FILE-'data/topics.txt'}
REF_CORPUS_DIR=${REF_CORPUS_DIR-'ref_corpus/wiki'}

declare -a metrics=("pmi" "npmi" "lcp")

echo "Running with window sizes from $WINDOW_MIN to $WINDOW_MAX"

for i in $( seq $WINDOW_MIN $WINDOW_MAX ); do
  wordcount_file="wordcount/wc-oc.$i.txt"

  echo -e "\t\tComputing word occurrence with window $i..."
  python ComputeWordCount.py $TOPIC_FILE $REF_CORPUS_DIR $i > $wordcount_file

  echo "Window size: $i"

  for metric in "${metrics[@]}"
  do
    echo -e "\t$metric"
    oc_file="results/topics-oc.$i.$metric.txt"
    
    #compute the topic observed coherence
    echo -e "\t\tComputing the observed coherence with window $i and metric $metric..."
    python ComputeObservedCoherence.py $TOPIC_FILE $metric $wordcount_file > $oc_file
  done
done
