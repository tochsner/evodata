CREATE TABLE "PaperWithExperiments" (
    doi TEXT PRIMARY KEY,
    abbrevation TEXT NOT NULL,
    title TEXT NOT NULL,
    authors TEXT[] NOT NULL,
    abstract TEXT NOT NULL,
    bibtex TEXT NOT NULL,
    url TEXT,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Experiment" (
    id SERIAL PRIMARY KEY,
    type TEXT NOT NULL CHECK (type = 'beast2Experiment'),
    origin TEXT NOT NULL,
    "uploadDate" TIMESTAMP WITH TIME ZONE NOT NULL,
    title TEXT,
    description TEXT,
    license TEXT NOT NULL,
    -- Tree related fields
    "numberOfTrees" INTEGER NOT NULL,
    "numberOfTips" INTEGER NOT NULL,
    ultrametric BOOLEAN NOT NULL,
    "timeTree" BOOLEAN NOT NULL,
    rooted BOOLEAN NOT NULL,
    "ccd1Entropy" NUMERIC NOT NULL,
    "treeEss" NUMERIC NOT NULL,
    "ccd0MapTree" TEXT NOT NULL,
    "hipstrTree" TEXT NOT NULL,
    "leafToSampleMap" JSONB NOT NULL DEFAULT '{}',
    "averageRootAge" NUMERIC NOT NULL,
    -- Metadata
    "phyloDataPipelineVersion" TEXT NOT NULL,
    "paperDoi" TEXT REFERENCES "PaperWithExperiments"(doi) ON DELETE CASCADE,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "File" (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN (
        'beast2Configuration',
        'beast2PosteriorLogs',
        'beast2PosteriorTrees',
        'codephyModel',
        'phyloDataExperiment',
        'summaryTree',
        'unknown'
    )),
    version INTEGER NOT NULL,
    "sizeBytes" BIGINT NOT NULL,
    md5 TEXT NOT NULL,
    "localPath" TEXT,
    "remotePath" TEXT,
    "experimentId" INTEGER REFERENCES "Experiment"(id) ON DELETE CASCADE,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Sample" (
    id SERIAL PRIMARY KEY,
    "sampleId" TEXT NOT NULL,
    "scientificName" TEXT NOT NULL,
    "commonName" TEXT,
    type TEXT NOT NULL CHECK (type IN ('cells', 'language', 'species', 'unknown')),
    "experimentId" INTEGER REFERENCES "Experiment"(id) ON DELETE CASCADE,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "SampleData" (
    id SERIAL PRIMARY KEY,
    type TEXT NOT NULL CHECK (type IN (
        'aminoAcids',
        'dna',
        'phasedDiploidDna',
        'rna',
        'traits',
        'unknown'
    )),
    length INTEGER NOT NULL,
    data TEXT NOT NULL,
    "sampleId" INTEGER REFERENCES "Sample"(id) ON DELETE CASCADE
);

CREATE TABLE "ClassificationEntry" (
    id SERIAL PRIMARY KEY,
    "classificationId" TEXT NOT NULL,
    "scientificName" TEXT NOT NULL,
    "commonName" TEXT,
    "idType" TEXT NOT NULL CHECK ("idType" IN ('glottologId', 'ncibTaxonomyId')),
    "sampleId" INTEGER REFERENCES "Sample"(id) ON DELETE CASCADE
);

CREATE TABLE "EvolutionaryModelComponent" (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN (
        'clockModel',
        'other',
        'substitutionModel',
        'treeLikelihood',
        'treePrior'
    )),
    "documentationUrl" TEXT NOT NULL,
    parameters JSONB NOT NULL DEFAULT '{}',
    "experimentId" INTEGER REFERENCES "Experiment"(id) ON DELETE CASCADE
);
