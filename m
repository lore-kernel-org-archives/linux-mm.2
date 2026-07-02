Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A41C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ABFE6B0137; Thu,  2 Jul 2026 20:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784186B013A; Thu,  2 Jul 2026 20:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624A66B013B; Thu,  2 Jul 2026 20:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21DD96B0137
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:48:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C26DA401DC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:40:44 +0000 (UTC)
X-FDA: 84944551608.26.A6F5407
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf05.hostedemail.com (Postfix) with ESMTP id 83057100005
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:40:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=n2P5mEHB;
	spf=pass (imf05.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014042;
	b=NXr7WFimcNQiGqPi6u88FFxX4xj5lsJTys797BNmYnzOUx81Z+qmQpT3/rE6dzhjKVFD8U
	QwxahOiUY7Ma/4H8oHHaDzHrI0V7XoUMT3RhP5Phdl4ipxQd41NWUKsE41EDgSsAU8dNLc
	GQK+KMXWLyDrNAA8CZpiXLWK2wcx+t0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yNPCtJS7zBtCAE2YXriwx7XKMhltueALVW8fi9ZgLvM=;
	b=MEEKQU8pTIfH4eWO982bBofb2OFVQ7mYfhTjMT5OHdasPLRHpRFMM7gebNdrLHfRfy9C17
	Bb1z5R05R6jZdbwRrkFgWimC6qF+6rtEjO9uDpCCkrTllr5U8Ilp7oN+1wMMZ3Q7fCSjg0
	7ZuHjFDNXrxeCTkXmk65j7OnAgOgshY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=n2P5mEHB;
	spf=pass (imf05.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014042; x=1814550042;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yNPCtJS7zBtCAE2YXriwx7XKMhltueALVW8fi9ZgLvM=;
  b=n2P5mEHBfqK+oyc4BBzPtqVS4lZO812/TU6SP1mbLIYNQP93DIhWolL8
   EWuoOxyf29yL1T/hU/7eCa3fI0w1pjTLoFkZc//z1mviLLtYJEQYAfrkW
   4M0r5GrDprUzElml38gwIsdbyCD/wqIDUDx66OdjAB7g2JUffVQ34efyL
   6OPZlmkBMX2rJHDXPppAQ5Di1fiAXStpyJwX0DZceoCq5JLwhCYxKlL/E
   RasieXwmP5zcKo005Ft11Ihc0byDATkyjJ7gHoqJgLQImAVhwzxLRGnBd
   9uYz+Q9OPOWqXNWUFFO9RpIrk4/mFtMPO2KF3Lca4qkYOFAhy8ABtBY+f
   A==;
X-CSE-ConnectionGUID: 5xN7P1ipT8CvnCH2x09Y/g==
X-CSE-MsgGUID: 8SypBo+mSRWloV+lLv0m5w==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22939040"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:40:38 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:31268]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.225:2525] with esmtp (Farcaster)
 id 85f956fc-c1bb-4e7b-b2de-53fd06591ab4; Thu, 2 Jul 2026 17:40:38 +0000 (UTC)
X-Farcaster-Flow-ID: 85f956fc-c1bb-4e7b-b2de-53fd06591ab4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:40:38 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:40:35 +0000
From: Pavol Sakac <sakacpav@amazon.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tejun Heo
	<tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <driver-core@lists.linux.dev>, "David
 Woodhouse" <dwmw@amazon.co.uk>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, "David
 Matlack" <dmatlack@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Alexander Graf <graf@amazon.com>, <linux-mm@kvack.org>,
	<kexec@lists.infradead.org>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 00/14] driver core: defer per-VF sysfs creation for fast SR-IOV bring-up
Date: Thu, 2 Jul 2026 19:40:19 +0200
Message-ID: <20260702174033.32116-1-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D035UWB002.ant.amazon.com (10.13.138.97) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 83057100005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 66no89iuu3gti4xoke6s55prfnjoe8cf
X-HE-Tag: 1783014042-46973
X-HE-Meta: U2FsdGVkX1/xIjIeznh088yDLbxpEGmpYrJHponrRqYJA4ImNJiTDQKWF3/O25WYw6jHlMj3V8bLKyf8PvXWnkKNuvuFHO2mdnMchphKNbNFQiq+dNN78Q8bouzd8DWwf0lnvag0jLwTWSEPFnrUtUx+NPNpAgOqaRr3HIEpl1YnAhetOheGmYdzU6igTAaQnnFbBFv47oFhoKpEOZHw+YjjlWXu+nXck5ZsBmZVQpmnXAogHDL82BEdWMNJ9kL9aKPOxxNtt9gEmdgn6BwUgK64eWBmIj2Rs2W2WTbWGcbhm5Qxm4eRM93f6FWTVLnh/TVLkE4R7ul2c4vfkmIoOjiSzUrKbQokMvmoPwij/N6Vw4UMtQtCK/bjfG4LaavGey+xJMeCaWj6b8LRLWcS5HGveCi0AatsgnH8JixzkfqvJM7KqVxZKomvA7yUxn22zpWx9ySuWxqR/DtnoAvuhfE++xynuvoHr68C8RQkPf5CWcbCGL+tW4L8c3rpCwgFkLiglKSmhhASMWZiMOpXIAyYP8J347qeiMqf4apk4V7K5888e5tsIwMJT1IWbLYUA/1k4uAYOI1x+97+zT226zk0mu7BX6VPk+mcEQJ7LEp5xbkERMLzBfGAc/aq5liFWghyjONxYD+wWpxRtgax5lHyFRvnf7bd5stV3SmNiSLuKDVQhGwm/e5ITft7vvSFog21UgXXhHSLWHy6IvPX4EKv/eFD35K8dMCyVS55FchWy9evx6VOq9hi3RIE1q0Lg0N4vxAuyqzWvCdQKa5AOJoh++yTLqweQwTkPTkrfdNdUd3I44KMunF7ULzb4CsV1qrUgHbOe4aHNEHUrkFG7hjSps8/9mKHOXJ0fz8exlV9gfo3P2Yd+khGKWy3JR9+LBJPtIiZQcgQlQy4qlAcCIKV6knUPkbZucFmyjpE4KIww8ElGCOV+oBl6PUoKkSz4orpJfvYgDDS9QYlh2f
 88pE0KkO
 aTOJr3MpH3T4nsa72t+B/VPOsqER0T6RBJRjMzHOcih6i6AOMMFPtMRVZhT5Deh0aVU50q5PfBJn8YpF5L+2vV/57WwxzenhJsbDG1O5RArpe+JrxiJqarBG+9sWUta+Vwu8R9fkF3jcsKD0Z/3DvmY8B2HNEphTTyy/Y/+bybV2+yaDFj/e5b7L0SM8lUzaVFnmAWdQ3KMUoqmHW7yi3ORM+mD4RlofBCQ6771FobHesKhUaRuKhj77S6047dVmOZozYN9lVgB5j8Kow5bbeV3xhcGT6VMpSNOqDMr2cC01MB7Bcq3cGDUcr6fzz1KRc9XLug5jfH8EwyQpv2Qep7rMEvxgx0/5DBYZojlhPiTvfvULSaSqubFjba9/aU9EaZEbU8spUYCGWvafIz3HXdK3FjdUSaC7hqA/6emS+x3N6q14iQnkfKabPR3ego3j9JnMMdkoeqBcIrmU71P9VhdsZyXFcjwKJgFZ8jbH9aOZMzak1JC3vYFoEJtgzMVUaFoB3A6v7oYV+znlZnNQfn2kVCaOB+A0Tx2cET/3UdNvcwVc4rjSAIAF5SbytvyetIzZoygp+WO3ADnmqxUPHOyfDfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Virtualization hardware keeps increasing in CPU-core and VF density.
Kernel is trending towards preserving VFs using LUO across a kexec
which will put SR-IOV in live-update hotpath. VFs must be re-added to
the sysfs tree, along with its supporting devices (e.g. vfio,
iommu_groups). On production hardware a single VF can consume ~80 kernfs
nodes. With thousands of VFs on modern hardware, hundreds of thousands
of kernfs nodes need to be created, which can add 100ms+ to the boot
time and to guest downtime.

Proposed here is a PoC of deferred materialization of sysfs files until
first access to avoid cost of kernfs node creation in hot path. In the
reproducer below using a synthetic VF to isolate the sysfs overhead,
the per-device sysfs-creation time is reduced by ~74%. It exploits the
expected access pattern of hypervisors, where only a subset of device
files need to be accessed to attach a VF to a VM on the hot path.

To allow lazy init scheme, a minimal set of files and directories is
built per device: a device directory resolves directly to the device's
kobject and is used to materialize attributes at access time. The
access is trapped in kernfs at the dir-read or path-walk stage and
depending on the trigger, either the full directory or a single file is
materialized.

The changes are two logically distinct parts:

  1. Refactor of hardcoded device_add / iommu_group sysfs attribute
     creation to a table-driven form to allow walkability of all
     attributes and single point of definition for attributes
     regardless of lazy opt-in to avoid duplicate definitions and
     associated maintainability issues with it.
  2. Lazy-init infra to front-run access to device files at lookup/
     readdir time to trigger materialization. Opt-in per device: PCI VFs
     and VFIO devices opt in via device_set_sysfs_lazy(); iommu_group
     opts in at the kobject level.

As a PoC, the code does not yet follow this logical structure in the
commit sequence and likely does not yet cover all corner cases.

Synthetic reproducer measurements
---------------------------------
  devices   per-dev time   total time       kernfs nodes (base -> lazy)
  -------   ------------   --------------   ----------------------------
     500    31.8->8.3 us    15.9-> 4.1 ms     36,417 ->  3,922  (72.8->7.8/dev)
    1000    33.2->8.7 us    33.2-> 8.7 ms     73,427 ->  8,432  (73.4->8.4/dev)
    2500    32.8->9.1 us    82.0->22.7 ms    184,421 -> 21,925  (73.8->8.8/dev)
    5000    33.0->8.7 us   165.1->43.5 ms    369,401 -> 44,406  (73.9->8.9/dev)

The reproducer is synthetic: an in-kernel module registers N unbound
platform devices (60 attributes / 4 groups, ~74 kernfs nodes each; no
config space, BARs, or probe) in one timed burst that models SR-IOV
enablement. It runs as a two-kernel A/B from one vanilla 7.1-rc2 tree
(eager baseline vs patched, plus a patched/opt-in-OFF arm), 20 runs per
point. Measures only sysfs-creation slice.

Deferral removes ~74% of the sysfs-creation time and ~88% of the kernfs
nodes. At 5000 devices that is 121.6 ms removed (165.1 -> 43.5 ms) and
~325,000 fewer kernfs nodes (369,401 -> 44,406). The table-driven rework
adds a +7..+11% eager-path time overhead to non-opted devices.

Available as a docker image that orchestrates builds in qemu guest and
prints results as a table (x86_64 Linux host with /dev/kvm assumed):

   docker run --device /dev/kvm ghcr.io/pavsa/linux-lazy-sysfs-vf-bench:7.1-rc2

Assumptions / Trade-offs
------------------------
The saving depends on the access pattern of hypervisors, and on no
component walking the whole device tree on the hot path to avoid full
materialization. Both are expected to hold on optimized hypervisors.

An actual production hypervisor was observed in local testing to
materialize an additional 5-10% of total nodes on average on the hot
path.

Overhead: +7..+11% eager-path time overhead applies to every non-opted
device going through device_add() as all struct devices traverse the
walker and can't be gated under a config option.
The lazy opt-in infra can be gated under config option to have zero
impact if disabled.

Final words
-----------
This is an RFC to first get feedback on the decisions taken at driver
core + kernfs level before engaging maintainers of other subsystems
if we want to pursue this further or pivot to something else.

The code is at a proof-of-concept quality written with AI assistance
with some known limitations with main target to gather potential
savings and initiate conversation.

Feedback appreciated for:
- table-driven attribute refactor targeting common device add path /
  suggestions for more efficient/less invasive approach
- mechanism of interception in kernfs, materialization, locking scheme
- fit into context of LUO - complementary or is there some other
  mechanism already considered to mitigate the sysfs impact

Pavol Sakac (14):
  kernfs: add populate callbacks and KERNFS_LAZY flag for lazy dir
    population
  sysfs: add existence-check helpers for lazy populate races
  sysfs: introduce sysfs_kf_syscall_ops dispatching to kobj_type
  driver core: add struct sysfs_lazy_state and device_set_sysfs_lazy()
  driver core: add struct device_sysfs_entry and walker
  driver core: wire device_ktype populate to walker
  driver core: migrate device sysfs to device_sysfs_entry table
  PCI/sysfs: migrate to device_sysfs_entry, defer physfn symlink
  iommu: lazy-populate iommu_group reserved_regions/type attrs
  PCI/IOV: opt SR-IOV VFs into sysfs_lazy
  vfio: opt vfio-dev and VFIO group devices into sysfs_lazy
  driver core: test: add KUnit tests for device_sysfs_apply
  Documentation: add lazy sysfs initialisation and device_sysfs_entry
    docs
  selftests: sysfs-lazy: add tests for lazy sysfs initialization

 Documentation/ABI/testing/sysfs-lazy          |   77 +
 Documentation/driver-api/index.rst            |    1 +
 Documentation/driver-api/sysfs-lazy.rst       |  146 ++
 MAINTAINERS                                   |    4 +
 drivers/base/bus.c                            |   41 +-
 drivers/base/core.c                           | 1047 +++++++++--
 drivers/base/test/.kunitconfig                |    7 +
 drivers/base/test/Kconfig                     |   13 +
 drivers/base/test/Makefile                    |    2 +
 drivers/base/test/device_sysfs_apply_test.c   | 1601 +++++++++++++++++
 drivers/iommu/iommu.c                         |  132 +-
 drivers/pci/iov.c                             |   24 +-
 drivers/pci/pci-sysfs.c                       |  158 +-
 drivers/pci/pci.h                             |    5 +
 drivers/pci/probe.c                           |    4 +-
 drivers/vfio/group.c                          |    5 +
 drivers/vfio/vfio_main.c                      |    5 +
 fs/kernfs/dir.c                               |   43 +-
 fs/sysfs/dir.c                                |   43 +
 fs/sysfs/file.c                               |   39 +
 fs/sysfs/group.c                              |   70 +
 fs/sysfs/mount.c                              |   60 +-
 fs/sysfs/sysfs.h                              |    7 +-
 include/linux/device.h                        |   90 +-
 include/linux/kernfs.h                        |   28 +
 include/linux/kobject.h                       |   15 +
 include/linux/sysfs.h                         |   39 +
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/sysfs-lazy/.gitignore |    3 +
 tools/testing/selftests/sysfs-lazy/Makefile   |   24 +
 tools/testing/selftests/sysfs-lazy/README.rst |   52 +
 tools/testing/selftests/sysfs-lazy/config     |    6 +
 .../selftests/sysfs-lazy/iommu_groups.c       |  162 ++
 .../selftests/sysfs-lazy/kmsg_cursor.h        |  167 ++
 .../selftests/sysfs-lazy/pci_resource.c       |  284 +++
 tools/testing/selftests/sysfs-lazy/settings   |    1 +
 .../testing/selftests/sysfs-lazy/sysfs-lazy.c |  777 ++++++++
 .../selftests/sysfs-lazy/test_mod/Makefile    |   28 +
 .../sysfs-lazy/test_mod/sysfs_lazy_test_mod.c |  319 ++++
 39 files changed, 5341 insertions(+), 189 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-lazy
 create mode 100644 Documentation/driver-api/sysfs-lazy.rst
 create mode 100644 drivers/base/test/device_sysfs_apply_test.c
 create mode 100644 tools/testing/selftests/sysfs-lazy/.gitignore
 create mode 100644 tools/testing/selftests/sysfs-lazy/Makefile
 create mode 100644 tools/testing/selftests/sysfs-lazy/README.rst
 create mode 100644 tools/testing/selftests/sysfs-lazy/config
 create mode 100644 tools/testing/selftests/sysfs-lazy/iommu_groups.c
 create mode 100644 tools/testing/selftests/sysfs-lazy/kmsg_cursor.h
 create mode 100644 tools/testing/selftests/sysfs-lazy/pci_resource.c
 create mode 100644 tools/testing/selftests/sysfs-lazy/settings
 create mode 100644 tools/testing/selftests/sysfs-lazy/sysfs-lazy.c
 create mode 100644 tools/testing/selftests/sysfs-lazy/test_mod/Makefile
 create mode 100644 tools/testing/selftests/sysfs-lazy/test_mod/sysfs_lazy_test_mod.c


base-commit: ec89572766744e844df24c27d31c97b4c00f4e07
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


