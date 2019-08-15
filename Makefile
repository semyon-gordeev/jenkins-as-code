jenkins:
	echo "[all]\n${host}" > hosts
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts jenkins.yml
