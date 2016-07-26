.PHONY: image test

image:
	docker build -t codeclimate/codeclimate-poseidon .

test: image
	docker run --rm -t codeclimate/codeclimate-poseidon bundle exec rake spec:all
