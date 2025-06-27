"""This file contains all the types which are used to describe a PhyloData experiment."""

from datetime import date
from enum import Enum
from typing import Any, Optional

import msgspec


class ExperimentType(Enum):
    BEAST2_Experiment = "beast2Experiment"


class FileType(Enum):
    BEAST2_CONFIGURATION = "beast2Configuration"
    BEAST2_POSTERIOR_LOGS = "beast2PosteriorLogs"
    BEAST2_POSTERIOR_TREES = "beast2PosteriorTrees"
    SUMMARY_TREE = "summaryTree"
    CODEPHY_MODEL = "codephyModel"
    EVO_DATA_EXPERIMENT = "evoDataExperiment"
    UNKNOWN = "unknown"


class SampleType(Enum):
    SPECIES = "species"
    CELLS = "cells"
    LANGUAGE = "language"
    UNKNOWN = "unknown"


class DataType(Enum):
    RNA = "rna"
    DNA = "dna"
    AMINO_ACIDS = "aminoAcids"
    PHASED_DIPLOID_DNA = "phasedDiploidDna"
    TRAITS = "traits"
    UNKNOWN = "unknown"


class ModelType(Enum):
    SUBSTITUTION_MODEL = "substitutionModel"
    CLOCK_MODEL = "clockModel"
    TREE_PRIOR = "treePrior"
    TREE_LIKELIHOOD = "treeLikelihood"
    OTHER = "other"


class Experiment(msgspec.Struct, rename="camel"):
    type: ExperimentType
    origin: str
    upload_date: date
    title: Optional[str] = None
    description: Optional[str] = None
    license: str = "CC0"
    id: Optional[str] = None


class Paper(msgspec.Struct, rename="camel"):
    title: str
    authors: list[str]
    abstract: str
    bibtex: str
    doi: Optional[str] = None
    id: Optional[str] = None
    url: Optional[str] = None


class File(msgspec.Struct, rename="camel"):
    name: str
    type: FileType
    version: int
    size_bytes: int
    md5: str
    local_path: Optional[str] = None
    remote_path: Optional[str] = None


class SampleData(msgspec.Struct, rename="camel"):
    type: DataType
    length: int
    data: list[str]


class ClassificationEntry(msgspec.Struct, rename="camel"):
    id: str
    scientific_name: str


class Sample(msgspec.Struct, rename="camel"):
    id: str
    scientific_name: str
    type: SampleType
    classification: list[ClassificationEntry]
    data: list[SampleData]


class Trees(msgspec.Struct, rename="camel"):
    number_of_trees: int
    number_of_tips: int
    ultrametric: bool
    time_tree: bool
    rooted: bool
    ccd1_entropy: float
    tree_ess: int
    ccd0_map_tree: str
    hipstr_tree: str
    leaf_to_sample_map: dict[str, str]
    average_root_age: float


class EvolutionaryModelComponent(msgspec.Struct, rename="camel"):
    name: str
    description: str
    type: ModelType
    documentation_url: str
    parameters: dict[str, Any]


class EvolutionaryModel(msgspec.Struct, rename="camel"):
    models: list[EvolutionaryModelComponent]


class Metadata(msgspec.Struct, rename="camel"):
    evo_data_pipeline_version: str


class PaperWithExperiment(msgspec.Struct, rename="camel"):
    experiment: Experiment
    paper: Paper
    files: list[File]
    samples: list[Sample]
    trees: Trees
    evolutionary_model: EvolutionaryModel
    metadata: Metadata
