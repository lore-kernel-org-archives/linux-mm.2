Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B446C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1982A6B0171; Thu,  2 Jul 2026 21:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140E46B016E; Thu,  2 Jul 2026 21:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24906B0174; Thu,  2 Jul 2026 21:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A29D06B016E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:01:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FAB81C19FE
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:55:50 +0000 (UTC)
X-FDA: 84944589660.15.9BD03E1
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4B21740007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:55:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b="dQHDVf3/";
	spf=pass (imf04.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014948;
	b=Tfr2se82W4UitQw33Pxgk/v/h7A8IElkl8g4v8+3KSIL2deIqfgqQapxQJkQOTF553QJe/
	3QfVZCPPhRTZedat0gZlrCvxAPN2IPMPmTNpEo++zRgZlAdDCL/ehQ7jObmAY7a5SKWxMa
	hzBik/IGTfNPaT/8hrtp8iRYqiUmS4g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFmIg3hL0q3j/Hsjk04HwbZaeoVYUJNjVvmJepwmBGc=;
	b=Gu22uhC7smxWz5A+0C20rGwgla6zGdWsFgQJZC9NY2cr4elZe5pJPUGd3BMQG6r77LWCvs
	8j+QJjzP5npL7FJEXpkPEYRnagxhuWB1wCmH1Edu5nAm18jahL9/hqufO3dEDe9Cp01a3D
	bZdPdRIwxw+VTc/drO1Ys/cHmS12Ojc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b="dQHDVf3/";
	spf=pass (imf04.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014948; x=1814550948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cFmIg3hL0q3j/Hsjk04HwbZaeoVYUJNjVvmJepwmBGc=;
  b=dQHDVf3/rDTtR4pYMTrbUaBM2lBAa1VVlWkAi5GmnE1z2r5fhT7cChg9
   AWPHiR49qNxrVqWrskz2ESmBTO9OeHseycs8qA/P035kNzC6LX0qX/RRy
   6+RD/X9VDJCP3ANYBVFCTsLTQKn9qU7w8zNuZedeSD/5ALjyfiRqHRVV2
   rvn4aBT5l5C14zuHxkL25W+IfyaGsSyz1mKhSIUFFN9c31NpFplQhxrtb
   f/2thr4sw8fWpmWYQc3lPhx/xZkxry/GvMwU9fV+3jT4tgIJXKkjyHNlx
   zwZAHr2WMkSiif4wJB+SszGI73SkCOQmmsY+OaGyETUcXvnvQDlsw0Qhc
   w==;
X-CSE-ConnectionGUID: x2XGedNhRU+MjL1IjezJNg==
X-CSE-MsgGUID: 6OL4jp4yTPCWXa1bmw4Crw==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22965889"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:55:47 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:18776]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.225:2525] with esmtp (Farcaster)
 id 809b607f-dbc9-423e-b071-6f20917d738b; Thu, 2 Jul 2026 17:55:47 +0000 (UTC)
X-Farcaster-Flow-ID: 809b607f-dbc9-423e-b071-6f20917d738b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:55:46 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:55:43 +0000
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
Subject: [RFC PATCH 13/14] Documentation: add lazy sysfs initialisation and device_sysfs_entry docs
Date: Thu, 2 Jul 2026 19:51:13 +0200
Message-ID: <20260702175114.24659-9-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702175114.24659-1-sakacpav@amazon.de>
References: <20260702174033.32116-1-sakacpav@amazon.de>
 <20260702175114.24659-1-sakacpav@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D035UWA002.ant.amazon.com (10.13.139.60) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4B21740007
X-Rspam-User: 
X-Stat-Signature: 5zysuy9z7gs9fdazcpfap5zmf5ymtw53
X-HE-Tag: 1783014948-471797
X-HE-Meta: U2FsdGVkX1/8dv1lNg5RxjrAflOUu2tAleKjnt6n1++2442iDghMNCEO8bN+enrJhPe4eHYM2d/dIvlDRO3Sd8cRQXYqqjVXRRKNtLoYUUuw7lUNg3M9lwNGt0KxVW2Ov3vFhLEiasgGXCH1aupoj5nIEhI6eqOPaos3vNAnlc/w4BUYytzMU6yt+KLFGLAufFka6DuB5aY6xugDrBFZwLi24/swWvbj77uHWFsP46MuFzNqyJzf0Pim5w9jSLKhFm2B2rrBliIaEIz1A06I9tWUfosVRaWE4RQKI8h30vEpG3Si0X4mhFGmZkeJtakhg31g0HjjRBp9Z4wXfXcPUy3C4WEl+/LX1LKJOFzuVolg+82OY/4QQ0EqRGu71XjwOyHFfHt8cy2A2fcIIWBIy45pyBlcaxFvsEqzWUdpGdtRLG1ll+GbJmdBPTny9m5NyvUjAWUDapIM/m4sWKm34GA/fomWUlRGFfQFm11glBbMrsG6/FCkmB+XkGeKF8DWYRqX4YmjToQlb/FaHGIG5JW9iVbHYEgsqBrl7VuLWjK1nyPcsIb/pmEtkmxWTKnsNkOu6sOeP8v12hLPh4X60FXLU6FIuob8zpwEsuGVZyE0UF6xCPq9UGO5PkZ95kaq8act5F9WFBxGmNsZeJJp/58eH+OzH7Im2IwoJb1JX8mr5tokjqEm8esBLIYmLj143+KUgLu24K1otD9MM0I94d8ILt3d5p9TzVVr+80l3sJP7t+pSZ4KLqkRt8T5NyWVihBa4S3pfDFTRgQAwFFLB3Sf5t28ggTgPpliVi5KthNPtpURHEVdj2NeVFBi6GO0vC/temrOXUMQ/xvip38BBpdt7HF+StUV8wN9ajEzuT4ZtwRaAccY3I9uenXvrlsoD7mnyw6mpsBHGmRekE4ru+41BmmaeCLDG5ZmQ3uLnFxaFsz3q+aqktgEg/g0dRZkJEx/J7PE1Sfvrbkm0cX
 iKdWT+Br
 P5SJBmpkPqrV4Rge5FFSrWVnYGfNcIWGCmmWk/nmN1hgBo3HkV7th1xyLl8Wj9Np5b328aeqv5fy++axTqXsLmuAsRA2/2DQtrLkS9DOjQvDsMIVl+vbkqiMol0GamAGUO2euMSz4LvIcYdYjv9pPk929luD06IM6zu9LzwhamIVSOhNt78/D6wKQBDYH4pcQcAFqAoElFtJ0s3LI7WD6Y4EtFgtbnTV2ejMqoGOuicd5viwsfgQ/fsFCYk6GBa0LCZArYT2KAof93DM42V7sGGUzBHEGeGOSf3CfF9o87QIOM11O0Swpog8FRIVx7ZeYGogqGFRfzwyBNK8EnEM8AdUOiGcQ/xfBjcxkusdjmxGXtxdGuO6k1jN6r+DdxPIj3qVwmscW5hFQFIbzdxtW6kLmN8BX3Qlbt8c1tqZJm6NqNeD5rCRKzuEhOj+Ltyikuivm7hdmyuajMEJvHw3T0QQHTg+sdkH0vsXC8JdaD6YV4WvFU7ZpSKT1dgXH9tj9kdi0ik+3VzKiR8vCZxj+Ptvd8HV15yoUHfibFi+0VTYcjOKVzvZ2WPeD8uUuYWRCT1WiY7tcbIlp8PAt1ql6H22xd8Uzmxc/HePjYfZI/U5gYO4PPxoZ13MyzsZPKiN0lCSxuV2Hqd3rRYV6EGweFtmHkYkgzlq+PNS6BREjB4lMuLCtglI1rFikE3Ybf41hm2JAOipDR6CTvp0wsw+mKgZ5ZnY0qz7KyCF8KaLax9wtWDcTci5/HHfJGWqsSNh3ZOJp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the lazy sysfs mechanism and its declarative walker:

  - Documentation/driver-api/sysfs-lazy.rst: developer guide
    covering overview, opting-in, populate callbacks (per-device
    walker and the iommu_group small-table pattern), locking,
    teardown, known limitations, and a "See also" section
    pointing to the KUnit tests and the kselftest.

  - Documentation/ABI/testing/sysfs-lazy: userspace-visible
    semantics - lookup vs readdir trigger points, stat() behaviour
    on known and unknown names, inotify / fanotify interaction,
    udev cold-plug compatibility, and the list of currently
    opted-in device classes (SR-IOV VFs, VFIO, iommu_groups).

  - Documentation/driver-api/index.rst: add sysfs-lazy to the
    toctree.

  - MAINTAINERS: add F: entries for the new docs, the KUnit test
    drivers/base/test/device_sysfs_apply_test.c, and the
    tools/testing/selftests/sysfs-lazy/ directory (added in the
    next commit) under DRIVER CORE, KOBJECTS, DEBUGFS AND SYSFS.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: driver-core@lists.linux.dev
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 Documentation/ABI/testing/sysfs-lazy    |  77 +++++++++++++
 Documentation/driver-api/index.rst      |   1 +
 Documentation/driver-api/sysfs-lazy.rst | 146 ++++++++++++++++++++++++
 MAINTAINERS                             |   4 +
 4 files changed, 228 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-lazy
 create mode 100644 Documentation/driver-api/sysfs-lazy.rst

diff --git a/Documentation/ABI/testing/sysfs-lazy b/Documentation/ABI/testing/sysfs-lazy
new file mode 100644
index 0000000000000..3a1b2a0e97e1c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-lazy
@@ -0,0 +1,77 @@
+What:		/sys/devices/.../
+		/sys/kernel/iommu_groups/<N>/
+Date:		May 2026
+KernelVersion:	7.1
+Contact:	Pavol Sakac <sakacpav@amazon.de>
+Description:
+		This entry documents the *realisation timing* contract
+		for sysfs entries under devices that have opted into
+		lazy population.  All attribute names, contents, modes,
+		and ownership are identical to the eager-device tree;
+		only the moment of creation differs.  The opt-in set is
+		enumerated in "Currently opted-in device classes" below.
+
+		When a device driver sets the sysfs_lazy flag on a struct
+		device before calling device_add(), the kernel defers
+		creation of attribute files, attribute groups, and
+		class/bus/driver symlinks under that device's sysfs
+		directory.
+
+		These entries are materialised on demand:
+
+		- A lookup (open, stat, readlink) of a specific filename
+		  triggers creation of that single file or symlink via
+		  the ktype->populate callback, which drives
+		  device_sysfs_apply() with DEV_SYSFS_ADD_ONE.
+		- A directory listing (readdir / getdents) triggers
+		  creation of all deferred entries at once via the
+		  ktype->populate_all callback, which drives
+		  device_sysfs_apply() with DEV_SYSFS_ADD_ALL.
+
+		A stat() call on a not-yet-realised filename:
+
+		- If the name corresponds to a known row (including one
+		  owned by dev->type->entries), the attribute or
+		  symlink is created and stat() succeeds with the same
+		  metadata an eager device would show.
+		- If the name is unknown, stat() returns -ENOENT and
+		  kernfs caches a negative dentry.  Transient errors
+		  (-ENOMEM, -EBUSY) propagate unchanged and are NOT
+		  negative-cached; the next lookup retries.
+		  access(F_OK) behaves identically to stat().
+
+		readdir() returns the full set of names the device
+		would expose if eager - applies_to gating is evaluated
+		during populate_all(), so the visible set exactly
+		matches the eager-device tree.
+
+		Once a row's entry is realised, it persists for the
+		lifetime of the device.  A second open()/stat() is a
+		plain kernfs lookup and involves no walker invocation.
+
+		What does NOT change relative to an eager device:
+
+		- The set of files and their names (applies_to is the
+		  single gate, identical between eager and lazy paths).
+		- File contents, permissions, ownership, and SELinux
+		  labels.
+		- The device directory itself (always eager) and its
+		  parent chain.
+
+		Interaction with inotify / fanotify:
+		  Watchers see IN_CREATE events at first-access time,
+		  not at device_add() time.
+
+		Interaction with udev / systemd-udevd:
+		  udev cold-plug works without modification.  udev
+		  reads the device directory on KOBJ_ADD, which
+		  triggers readdir -> full realisation.
+
+		Currently opted-in device classes:
+
+		- PCI SR-IOV Virtual Functions (drivers/pci/iov.c)
+		- VFIO group and vfio-dev children (drivers/vfio/)
+		- IOMMU groups (/sys/kernel/iommu_groups/<N>/,
+		  drivers/iommu/iommu.c)
+
+Users:		udev, systemd-udevd, libvirt, DPDK, SPDK
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index eaf7161ff9578..b1807ca6cd1ce 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -23,6 +23,7 @@ of interest to most developers working on device drivers.
    driver-model/index
    device_link
    infrastructure
+   sysfs-lazy
    ioctl
    pm/index
 
diff --git a/Documentation/driver-api/sysfs-lazy.rst b/Documentation/driver-api/sysfs-lazy.rst
new file mode 100644
index 0000000000000..5fbd7732afe0d
--- /dev/null
+++ b/Documentation/driver-api/sysfs-lazy.rst
@@ -0,0 +1,146 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+Lazy sysfs initialisation
+=========================
+
+Overview
+========
+
+``device_add()`` normally creates every sysfs attribute, attribute
+group, and class/bus/driver symlink under a new device's directory
+synchronously.  For populations created in bulk - hundreds of PCI
+SR-IOV VFs, fleets of vfio-dev children - that work dominates
+``device_add()`` latency yet the resulting sysfs nodes are rarely
+read.
+
+Lazy sysfs defers attribute creation until the directory is first
+opened by userspace.  The device directory itself, its parent chain,
+and uevent broadcast remain eager; only the *content* of the
+directory is deferred.
+
+Opting in
+=========
+
+A subsystem opts a device in by:
+
+1. Calling ``device_set_sysfs_lazy(dev)`` before ``device_add()``.
+2. Making the kernfs directory created by ``device_add()`` a lazy
+   directory via ``kernfs_set_lazy()``.
+
+``kernfs_set_lazy()`` flips ``KERNFS_LAZY`` on a directory under
+``kernfs_rwsem`` and returns ``-EINVAL`` for namespaced nodes (a
+non-NULL namespace tag or the ``KERNFS_NS`` flag) and non-directory
+nodes: lazy dispatch does not carry an active namespace tag into the
+populate callback.
+
+The flag is set once and never cleared.
+
+Populate callbacks
+==================
+
+A lazy directory's first ``readdir(3)`` or ``open(2)`` of a
+not-yet-created child invokes one of two callbacks defined on
+``struct kobj_type``::
+
+    int (*populate)(struct kobject *kobj, const char *name);
+    void (*populate_all)(struct kobject *kobj);
+
+``populate(name)`` runs on a named lookup miss and creates the single
+matching attribute.  ``populate_all()`` runs on the first
+``readdir(3)`` and creates every attribute the device exposes.
+
+For a ``struct device``, the driver core wires both callbacks to
+``device_sysfs_apply()``, which walks an immutable
+``device_sysfs_entry`` table.  Each row declares an
+``applies_to(dev)`` predicate, a ``create(dev, name)`` action, and a
+``remove(dev)`` action.  The walker dispatches the rows whose
+predicate passes for ``@dev``; the rows themselves call
+``sysfs_create_file()``, ``sysfs_create_link()``, or
+``sysfs_create_group()`` directly.
+
+The same pattern is used by ``iommu_group``: a lazy ``iommu_group``
+kobject's ``populate``/``populate_all`` walks a small fixed table of
+group attributes (``reserved_regions``, ``type``).
+
+Locking
+=======
+
+Each lazy device holds ``dev->sysfs_lazy->lock`` (a mutex).  All
+three populate paths take it::
+
+    populate(name)      -> mutex_lock(lock)
+                          walk(ADD_ONE, name)
+                          mutex_unlock
+    populate_all()      -> if (test_bit(POPULATED)) return;
+                          mutex_lock(lock)
+                          if (test_bit(POPULATED)) goto out;
+                          if (dev->p->dead)        goto out;
+                          walk(ADD_ALL, NULL)
+                          set_bit(POPULATED)
+                          mutex_unlock
+    REMOVE_ALL teardown -> mutex_lock(lock)
+                          walk(REMOVE_ALL, NULL)
+                          mutex_unlock
+
+The ``dev->sysfs_lazy->populated`` bool is the
+``populate_all()`` once-latch.  The unlocked read fast path is a
+performance optimisation; the field is only authoritative under
+``lock``.  A stale false on the fast path harmlessly retakes
+the mutex and re-checks.
+
+Lock ordering: ``lock`` nests inside any caller-held VFS or
+kernfs lock that brought us into ``populate``/``populate_all``.  No
+sysfs / kernfs operation that requires ``kernfs_rwsem`` write may be
+issued while holding ``lock``.
+
+The ``iommu_group`` path uses the same pattern:
+``group->sysfs_lazy.lock`` and
+``group->sysfs_lazy.populated``.
+
+Teardown
+========
+
+``device_del()`` sets ``dev->p->dead`` *before* the
+``REMOVE_ALL`` walker call and takes ``lock`` around it.
+Any populate callback racing with ``device_del()``:
+
+1. Either takes the lock first and runs against a not-yet-dead
+   device (its created files are torn down a moment later by
+   ``REMOVE_ALL``, which is idempotent against the row's
+   ``remove()``); or
+2. Sees ``dev->p->dead == true`` after acquiring the lock and bails
+   without creating anything.
+
+Either way, the device exits with a quiesced sysfs subtree and no
+populate callback sees a half-deleted device.
+
+``iommu_group_release()`` follows the same dead-flag + lock-then-walk
+contract.
+
+Known limitations
+=================
+
+* Lazy sysfs is only available for devices whose populate path is
+  driven through ``device_sysfs_entry`` rows.  Subsystems with bespoke
+  ``device_add()``-time sysfs creation must migrate before opting in.
+* Namespaced kobjects cannot be marked lazy: ``kernfs_set_lazy()``
+  rejects them because the populate callback does not carry the
+  active namespace tag.
+* The directory's eager skeleton (the directory inode itself and the
+  ``uevent`` file emitted by ``device_add()``) is not deferred.
+* Per-attribute creation cost is unchanged.  Lazy sysfs amortises
+  the cost across first-access events instead of paying it during
+  ``device_add()``.
+
+See also
+========
+
+* ``include/linux/kernfs.h`` - ``kernfs_set_lazy()``, ``KERNFS_LAZY``.
+* ``drivers/base/core.c`` - ``device_sysfs_apply()``,
+  ``driver_core_sysfs_entries[]``.
+* ``drivers/iommu/iommu.c`` - ``iommu_group_lazy_attrs[]``.
+* ``drivers/base/test/device_sysfs_apply_test.c`` - KUnit walker
+  contract tests.
+* ``tools/testing/selftests/sysfs-lazy/`` - userspace VFS-level
+  parity tests.
diff --git a/MAINTAINERS b/MAINTAINERS
index 5d8a887c868ed..1424e641d535f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7800,9 +7800,12 @@ M:	Danilo Krummrich <dakr@kernel.org>
 L:	driver-core@lists.linux.dev
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core.git
+F:	Documentation/ABI/testing/sysfs-lazy
 F:	Documentation/core-api/kobject.rst
 F:	Documentation/driver-api/driver-model/
+F:	Documentation/driver-api/sysfs-lazy.rst
 F:	drivers/base/
+F:	drivers/base/test/device_sysfs_apply_test.c
 F:	fs/debugfs/
 F:	fs/sysfs/
 F:	include/linux/device/
@@ -7830,6 +7833,7 @@ F:	samples/rust/rust_debugfs_scoped.rs
 F:	samples/rust/rust_driver_platform.rs
 F:	samples/rust/rust_driver_faux.rs
 F:	samples/rust/rust_soc.rs
+F:	tools/testing/selftests/sysfs-lazy/
 
 DRIVERS FOR OMAP ADAPTIVE VOLTAGE SCALING (AVS)
 M:	Nishanth Menon <nm@ti.com>
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


