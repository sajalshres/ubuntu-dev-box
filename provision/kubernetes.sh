#!/bin/sh
set +ex

# Install latest MicroK8s
# MicroK8s is packaged as a snap which requires snapd to be installed.
# The latest Ubuntu release comes with this already built in.
snap install microk8s --classic
