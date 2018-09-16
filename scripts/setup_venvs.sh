#!/usr/bin/env bash
VENVS_ROOT=$HOME/venvs
if [[ "$@" != "" ]]; then
  VENVS="$@"
else
  VENVS="default"
fi

apt-get -y install python-pip
sh -c -l 'pip install --upgrade pip'
sh -c -l 'pip install pipenv'

mkdir -p $VENVS_ROOT
for _venv in $VENVS; do
  sh -c -l "cd $VENVS_ROOT && virtualenv $_venv"
  sh -c -l ". $VENVS_ROOT/$_venv/bin/activate && pip install ansible"
  # pyenv for ansible_python_interpreter
  cat << 'EOF' > $VENVS_ROOT/$_venv/bin/pyenv
#!/usr/bin/env bash
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/activate"
python $@
EOF
  chmod +x $VENVS_ROOT/$_venv/bin/pyenv
done
