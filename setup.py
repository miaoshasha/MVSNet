from setuptools import setup, find_packages
try: # for pip >= 10
    from pip._internal.req import parse_requirements
except ImportError: # for pip <= 9.0.3
    from pip.req import parse_requirements
import uuid

install_reqs = parse_requirements('requirements.txt', session=uuid.uuid1())
requirements = [str(ir.req) for ir in install_reqs]

config = {
    'description': 'Tensorflow model for multi-view stereo depthmap regression',
    'author': 'Yisha',
    'url': '',
    'download_url': '',
    'author_email': '',
    'version': '0.1',
    'install_requires': requirements,
    'packages': find_packages(),
    '_include_package_data_set': True,
    'scripts': [],
    'name': 'mvsnet'
}

setup(**config)
