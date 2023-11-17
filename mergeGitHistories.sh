repoPath=$1
commitMsg=$2

setupRepo() {
    cd $1
    git checkout master
    git pull
    git checkout -b prepare_monorepo
}

filterUntrackedFiles() {
    git rm -f --ignore-unmatch .*
}

createRepoStructure() {
    mkdir -p $1
    shopt -s extglob
    git mv -k !($1) $1
    shopt -u extglob
}

commitChanges() {
    git add .
    git commit -m $1
}

setupRepo $repoPath
filterUntrackedFiles
createRepoStructure $repoPath
commitChanges $commitMsg

cd ../MonoRepo

git remote add -f RepoA ../RepoA 
git merge -m "Integrating RepoA" RepoA/prepare_monorepo --allow-unrelated-histories
git remote rm RepoA
git push