Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF68C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320526B017D; Thu,  2 Jul 2026 21:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7A36B017F; Thu,  2 Jul 2026 21:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199566B0180; Thu,  2 Jul 2026 21:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C01876B017D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:04:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A16CAA0243
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:55:53 +0000 (UTC)
X-FDA: 84944589786.09.E32F40E
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf06.hostedemail.com (Postfix) with ESMTP id 42868180009
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:55:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=USJ5AS5j;
	spf=pass (imf06.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014951;
	b=Nyg2ViG9wnTAYWb8Fbkdr6sJ13wG6XAcNa+6K6qCRVLzqxEtAV9aLxi27Ah4PvXi4+XpxH
	8kamN/q02oNYA9YG5jQwH7Mv/mvO5PKXxI5ji8ovHFYtpavm5tGgA8Eumk4BjgaJW/8HQk
	EfiMqfjuN6E5yZ8QD4O7PcHLJmB02f0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQGAvFDg/4HjX7OHbuopGghl+52twC+QoPd2tO4M2G4=;
	b=5PtHY+JJx3P6cnDKHekyeULJ2EXDdGVJJoA+3wHwhx9kZDP7YHbvBdB8wxVN5kzyOvxlr9
	Ip6CT5yMYs2HVPTOybQTDYOLlNX0lTOCn3e1VtW57nN3hYIxFYm16TnzLl+FyYJaXWcKwd
	EBuFk6beaI+G9YsNp2wMEx6NqPbAJ/0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=USJ5AS5j;
	spf=pass (imf06.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014951; x=1814550951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aQGAvFDg/4HjX7OHbuopGghl+52twC+QoPd2tO4M2G4=;
  b=USJ5AS5jYcfXIBbebOwMqXnLdvljawDKIKk9iMmcGvQYq9DZSQ+9guhh
   YK2Ii3yE23g91CTzt/0m4tI+6Svx2ROfYMHZ7v+cZ/YqN1fkUCqFoYprU
   aojOD1iMnKCUFiyZdPTbnEsDiZ84y2TDafmfynw3fRuLsa0RXv6zq54OW
   nzKD/ig76UcAsqxnUZtxZ7Yx6zinzrFX8RW08Ti7qocMM43tY4dGf9NfS
   ZLk+1ozcqL67IpJrNzF5MsyINIzSk9c9jRHNDFjEdSx3pSEx9/s/XbDRo
   wjNlSXh94j5rktwdY+sLYA7Db8q8Xtbx/6Pwer2sSYkSQ9uSpd1OUJTqo
   A==;
X-CSE-ConnectionGUID: b3RVlrqvRsm6ovqvnOrlwA==
X-CSE-MsgGUID: l1ZUerMfR3CBfKuizuWp2g==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22939996"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:55:50 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:26660]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.1.125:2525] with esmtp (Farcaster)
 id b47d5271-f973-4d5f-8488-6ad365b7d51e; Thu, 2 Jul 2026 17:55:49 +0000 (UTC)
X-Farcaster-Flow-ID: b47d5271-f973-4d5f-8488-6ad365b7d51e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:55:49 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:55:46 +0000
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
Subject: [RFC PATCH 14/14] selftests: sysfs-lazy: add tests for lazy sysfs initialization
Date: Thu, 2 Jul 2026 19:51:14 +0200
Message-ID: <20260702175114.24659-10-sakacpav@amazon.de>
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
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: ttp1o7f4yamtshi63g9oorq3jbxd8pkb
X-Rspamd-Queue-Id: 42868180009
X-HE-Tag: 1783014951-769010
X-HE-Meta: U2FsdGVkX19xuyHmlkcPzEXVMXCs+jXeXHARe9EKi5mUrjZtFLVNt0rHllG0NtCUqIaAo7OHIYirjhHZK0uWMCDDsgloNzQkoNlSS0BLm3SBF+698UsoJTi7QR+kOVjSq2TpjeLVNKAkMpxWBt8/VetbAUDsio/nB/T4bv+FRe9pUv6mb98nCqSCSBZgdahD2KVSEwCEdJwNYLhhI5FSziRLuq1SwFbg6fMPU8MHa1pba+witY+uklNUicoKlBNvjaDhXgAw+QL+xqRHYI2ob2zwSliXKCXPI/G+R87l46xEFz+h4nJ9bkop1eXcfB/JLnaFkCAqLTVB2Zwe+9dTIBcMlFUzq2LRpQYqGtj6yE4/ub1/VmysezZoEbV2bAGx1JmL28TXEDOq7roMDb0T4uZG5lgyZyJplQO2nKibxkp/UgZp1Vp+m1kyWPlEbMAdfjUuVfjBpt6Kt1HavvO/i/m8FeC1PppEnz7Msw118NZtdMzCQrR3jOOGOfmPfhw1mag/dX/Bs1SMO/t5ITH+OZ4pnPlZgeCMj2zSTTcpHROxOn0T+xVNX6VSCHmdl1wkdQSegVzvyZOupKu2hklXExfRlN4ajOfQvgovfs9vaMpD1B48C5FZ9WMFAbXHVxlUQKZh021XmzniFucGBFs2e37w5UhjXvDRhxck/A+Nvu6NdqGqopCzwZNHPLoMmxJRY1wyF9InW//ObvvflXJzM0PREvrTt8TXGD9Hw9YrG1TG0K6KSqbo83adA8YuV2Nk5Dg4Ylhl1t0b+0zDIsLES8YyvdgyUqn713V1AnawcrqqS2Y8bkdEoq7mq49e9RvFjsAcvufH4znlfU6VDQSyhV5c7pO+HBB6xayLV3Zf4fcATAk4pUW5ky0EJr7V96pvxt1UkHe+h5wqQorbMgAuRMnO11XpzLR73SbFi+H8hlul4n4KW2HJ+wDO9tlCS4SJNp7xBGNWIac6Ms9TVK8
 Y1xwVhxl
 L8W6t+9dZKIZeDnU+K0nEO/qfaCk5yH0layxOcY06kqNXYB7kvke9yE6WHeFyAXHmLUuXBYy85N3dRiFg80/l4gZb4RnusxqgcXzJvoIrpkJWy07o+R0u5LKEg05WVG6SqxZ0BcT6qSFNvXizBrDi30GRx5ZlKajewxHG3/Zf9Eg5hm3m2T/Z1a8MqDZ52sIoTXz0Pt2EUIpB1PmKjja9K/0i1AeFfCFdDWHVXJqR4tvIOOb8q6ABulXKZhvNxiwnJE6RkztEHOPlHi2hMHitrY2UfRbtmb/y2cvYSiLZx0moxNmTnTANa0B2UaoLnzcNXYgdMHAokG+AkQBpsWsqG7YearvtswOVNfy5v0rquU5a7UbE7UBrkpajK5xigljJ87aCwpIkQvHchB23zuHIyR5NR6tDYYJK8JqcWjRBqvdySGC6PL8dEQaTJmuvSDDqgndgl/kLZSWbEBqktD6svesPv19nnDvLre0rdFG6IRWcGe2Danr31Oju61vbK1FGwAFBm1I8Njuw/Zd7RrZLYyNLGSNivoEBn7MvRSL2FL2txLdWk4sgC8Kzkp9kOHEFPWDHid76AdIfB6/Za5r7zAdO6PewdMMQFyjU6OG4GhULK+41qLohTM4mrsrBgRYN+v3hyYMhWE0lUdUUBJ9ZFGgyQ4O1GhXZj/G+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kselftest suite exercising the lazy sysfs path end to end:

  - test_mod/sysfs_lazy_test_mod.c: a minimal platform driver that
    registers a device opted into sysfs_lazy (attributes, groups, a
    named symlink and a binary attribute).  An eager_twin module
    parameter registers an identical non-lazy device so tests can
    compare lazy against eager.

  - sysfs-lazy.c: userspace tests (kselftest_harness) covering
    partial realize then module unload, leak-free full populate and
    unload, driver unbind/rebind, transient populate-error
    propagation to open(2) with no negative dentry cached, lazy
    readdir(3) order matching the eager tree, and full lazy/eager
    tree equivalence.

  - iommu_groups.c: stat()s the lazily-populated iommu_group 'type'
    and 'reserved_regions' attributes; skips cleanly where IOMMU
    groups are absent.

  - pci_resource.c: concurrently drives populate-one and
    populate-all on a live PCI device and fails on any WARN/BUG/
    KASAN/Oops splat in the race window, asserting resource0 stays
    openable; the userspace companion to the in-kernel idempotency
    KUnit case.  Skips cleanly without a suitable device or
    privileges.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-api@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: driver-core@lists.linux.dev
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/sysfs-lazy/.gitignore |   3 +
 tools/testing/selftests/sysfs-lazy/Makefile   |  24 +
 tools/testing/selftests/sysfs-lazy/README.rst |  52 ++
 tools/testing/selftests/sysfs-lazy/config     |   6 +
 .../selftests/sysfs-lazy/iommu_groups.c       | 162 ++++
 .../selftests/sysfs-lazy/kmsg_cursor.h        | 167 ++++
 .../selftests/sysfs-lazy/pci_resource.c       | 284 +++++++
 tools/testing/selftests/sysfs-lazy/settings   |   1 +
 .../testing/selftests/sysfs-lazy/sysfs-lazy.c | 777 ++++++++++++++++++
 .../selftests/sysfs-lazy/test_mod/Makefile    |  28 +
 .../sysfs-lazy/test_mod/sysfs_lazy_test_mod.c | 319 +++++++
 12 files changed, 1824 insertions(+)
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

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6e59b8f63e416..f2ab852b9c2cc 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -116,6 +116,7 @@ TARGETS += static_keys
 TARGETS += sync
 TARGETS += syscall_user_dispatch
 TARGETS += sysctl
+TARGETS += sysfs-lazy
 TARGETS += tc-testing
 TARGETS += tdx
 TARGETS += thermal/intel/power_floor
diff --git a/tools/testing/selftests/sysfs-lazy/.gitignore b/tools/testing/selftests/sysfs-lazy/.gitignore
new file mode 100644
index 0000000000000..b2af0d124131b
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/.gitignore
@@ -0,0 +1,3 @@
+sysfs-lazy
+iommu_groups
+pci_resource
diff --git a/tools/testing/selftests/sysfs-lazy/Makefile b/tools/testing/selftests/sysfs-lazy/Makefile
new file mode 100644
index 0000000000000..5e5f06cc3deb6
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/Makefile
@@ -0,0 +1,24 @@
+# SPDX-License-Identifier: GPL-2.0
+CFLAGS += -Wall $(KHDR_INCLUDES)
+LDLIBS += -lpthread
+
+TEST_GEN_PROGS := sysfs-lazy iommu_groups pci_resource
+TEST_FILES := settings
+
+KDIR ?= $(if $(O),$(O),$(realpath ../../../..))
+ifneq (,$(wildcard $(KDIR)/Module.symvers))
+TEST_GEN_MODS_DIR := test_mod
+else
+SYSFS_LAZY_MOD_WARNING = "missing Module.symvers, please have the kernel built first"
+endif
+
+include ../lib.mk
+
+ifneq ($(SYSFS_LAZY_MOD_WARNING),)
+all: warn_missing_test_mod
+
+warn_missing_test_mod:
+	@echo ; \
+	echo "Warning: $(SYSFS_LAZY_MOD_WARNING). sysfs_lazy_test_mod will not be built." ; \
+	echo
+endif
diff --git a/tools/testing/selftests/sysfs-lazy/README.rst b/tools/testing/selftests/sysfs-lazy/README.rst
new file mode 100644
index 0000000000000..63c5571428f48
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/README.rst
@@ -0,0 +1,52 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========================
+sysfs-lazy kselftest suite
+==========================
+
+Integration tests for the per-file lazy sysfs initialization mechanism.
+Per-call populate behaviour (visibility, mode, groups,
+idempotency, atomicity) is validated in-kernel by the KUnit suite at
+``drivers/base/test/device_sysfs_apply_test.c``
+(``CONFIG_DEVICE_SYSFS_APPLY_KUNIT_TEST``); this suite covers only
+invariants that require userspace (module load/unload, driver-core
+rebind) or a live IOMMU topology.
+
+Prerequisites
+=============
+
+- Kernel built with ``CONFIG_SYSFS=y``, ``CONFIG_DEBUG_FS=y``,
+  ``CONFIG_MODULES=y``.
+- The ``sysfs_lazy_test_mod`` module built and available for
+  ``modprobe`` (for the ``sysfs-lazy`` binary).
+- An IOMMU-enabled kernel with at least one group under
+  ``/sys/kernel/iommu_groups/`` (for the ``iommu_groups`` binary;
+  test SKIPs gracefully otherwise).
+
+Running
+=======
+
+Build and run::
+
+    make -C tools/testing/selftests TARGETS=sysfs-lazy run_tests
+
+Test binaries
+=============
+
+``sysfs-lazy``
+  Module-backed integration tests.  Loads/unloads
+  ``sysfs_lazy_test_mod`` automatically.  Test cases:
+
+  1. **teardown_partial** - partial populate + module unload leaves no
+     leaks.
+  2. **no_leaks_on_unload** - kmemleak scan after full populate + unload.
+  3. **bind_unbind_cycle** - driver rebind after lazy populate preserves
+     materialized attrs.
+
+``iommu_groups``
+  Smoke test for ``iommu: lazy-populate iommu_group
+  reserved_regions/type attrs``.  Walks
+  ``/sys/kernel/iommu_groups/<N>/`` and stat()s the deferred ``type``
+  and ``reserved_regions`` attributes to verify lazy materialization.
+  Also exercises ``readdir`` (``ls``) to drive the all-path materializer.
+  SKIPs cleanly when IOMMU is disabled or no groups are present.
diff --git a/tools/testing/selftests/sysfs-lazy/config b/tools/testing/selftests/sysfs-lazy/config
new file mode 100644
index 0000000000000..2152f1bf2a903
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/config
@@ -0,0 +1,6 @@
+CONFIG_SYSFS=y
+CONFIG_DEBUG_FS=y
+CONFIG_MODULES=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_KCSAN=y
+CONFIG_KASAN=y
diff --git a/tools/testing/selftests/sysfs-lazy/iommu_groups.c b/tools/testing/selftests/sysfs-lazy/iommu_groups.c
new file mode 100644
index 0000000000000..3b0be6beea484
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/iommu_groups.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * iommu_groups - lazy-populate smoke test for iommu_group sysfs attrs
+ *
+ * Complements the integration tests in sysfs-lazy.c and the in-kernel
+ * KUnit suite drivers/base/test/device_sysfs_apply_test.c by exercising
+ * the lazy-populate opt-in added for the kernel commit
+ *   iommu: lazy-populate iommu_group reserved_regions/type attrs
+ *
+ * Walks /sys/kernel/iommu_groups/<N>/ and verifies that the two
+ * always-present attributes (reserved_regions, type) are accessible
+ * via both per-file stat() and group-level readdir().  On a system
+ * running the lazy-populate kernel, these attributes are materialized
+ * on first access; on a non-lazy kernel they already exist eagerly.
+ * Either way, this test passes when the kernel exposes a
+ * syntactically-complete iommu_group hierarchy.
+ *
+ * Uses kselftest harness.  Skips gracefully if:
+ *   - /sys/kernel/iommu_groups/ does not exist (IOMMU disabled); or
+ *   - no groups are present on the host.
+ *
+ * Does not require root.
+ */
+
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+#define IOMMU_GROUPS_ROOT "/sys/kernel/iommu_groups"
+
+/*
+ * find_first_group: return heap-allocated path to the first
+ * numerically-named entry under IOMMU_GROUPS_ROOT, or NULL if none.
+ * Caller frees.
+ */
+static char *find_first_group(void)
+{
+	DIR *d = opendir(IOMMU_GROUPS_ROOT);
+	struct dirent *de;
+	char *path = NULL;
+
+	if (!d)
+		return NULL;
+
+	while ((de = readdir(d))) {
+		char *endp;
+		unsigned long id;
+
+		if (de->d_name[0] == '.')
+			continue;
+
+		id = strtoul(de->d_name, &endp, 10);
+		if (*endp != '\0')
+			continue;
+		(void)id;
+
+		path = malloc(PATH_MAX);
+		if (!path)
+			break;
+		snprintf(path, PATH_MAX, "%s/%s", IOMMU_GROUPS_ROOT,
+			 de->d_name);
+		break;
+	}
+
+	closedir(d);
+	return path;
+}
+
+TEST(iommu_groups_root_exists_or_skip)
+{
+	struct stat st;
+
+	if (stat(IOMMU_GROUPS_ROOT, &st) < 0) {
+		SKIP(return,
+		     "/sys/kernel/iommu_groups/ absent (IOMMU not enabled)");
+	}
+	ASSERT_TRUE(S_ISDIR(st.st_mode));
+}
+
+TEST(first_group_reserved_regions_and_type)
+{
+	char path[PATH_MAX];
+	char *group;
+	struct stat st;
+	int fd;
+	char buf[64];
+	ssize_t n;
+
+	group = find_first_group();
+	if (!group)
+		SKIP(return, "no iommu_groups present on this host");
+
+	/*
+	 * Step 1: stat() on the group's "type" attribute must succeed.
+	 * On a lazy-populate kernel, this is the first access and
+	 * triggers populate_one(name="type").  On a non-lazy kernel,
+	 * the attribute was created eagerly at group allocation time.
+	 */
+	snprintf(path, sizeof(path), "%s/type", group);
+	ASSERT_EQ(stat(path, &st), 0) {
+		TH_LOG("stat(%s) failed: %s", path, strerror(errno));
+	}
+	ASSERT_TRUE(S_ISREG(st.st_mode));
+
+	/* Step 2: read the "type" attribute.  Expect a non-empty short
+	 * string (e.g. "DMA", "identity", ...).
+	 */
+	fd = open(path, O_RDONLY);
+	ASSERT_GE(fd, 0);
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	ASSERT_GT(n, 0);
+	buf[n] = '\0';
+	TH_LOG("iommu_group type: %s", buf);
+
+	/*
+	 * Step 3: stat() on "reserved_regions" must also succeed.  On
+	 * a lazy-populate kernel, this is potentially a second
+	 * populate_one() call.  The file may be empty (many groups
+	 * have no reserved regions) but must exist.
+	 */
+	snprintf(path, sizeof(path), "%s/reserved_regions", group);
+	ASSERT_EQ(stat(path, &st), 0) {
+		TH_LOG("stat(%s) failed: %s", path, strerror(errno));
+	}
+	ASSERT_TRUE(S_ISREG(st.st_mode));
+
+	/*
+	 * Step 4: readdir() the group directory.  On a lazy-populate
+	 * kernel this triggers populate_all() which must materialize
+	 * both attributes (if they were not materialized by step 1/3
+	 * already).  Verify both names appear.
+	 */
+	DIR *d;
+	struct dirent *de;
+	int saw_type = 0, saw_rr = 0;
+
+	d = opendir(group);
+	ASSERT_NE(d, NULL);
+	while ((de = readdir(d))) {
+		if (!strcmp(de->d_name, "type"))
+			saw_type = 1;
+		else if (!strcmp(de->d_name, "reserved_regions"))
+			saw_rr = 1;
+	}
+	closedir(d);
+	ASSERT_TRUE(saw_type);
+	ASSERT_TRUE(saw_rr);
+
+	free(group);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/sysfs-lazy/kmsg_cursor.h b/tools/testing/selftests/sysfs-lazy/kmsg_cursor.h
new file mode 100644
index 0000000000000..d85c1315cbf3d
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/kmsg_cursor.h
@@ -0,0 +1,167 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * kmsg_cursor.h - capture WARN/BUG kernel-log lines emitted within a
+ * bounded test window.
+ *
+ * Selftest builds catch userspace-visible regressions but miss the
+ * silent kernel-side ones - a WARN_ON splat, a UAF KASAN report, a
+ * RCU stall - that only show up in dmesg. The cursor provides a
+ * minimal wrapper around /dev/kmsg with two operations a TEST_F
+ * needs: snapshot at test start, extract WARN/BUG lines emitted
+ * since the snapshot.
+ *
+ * /dev/kmsg semantics (fs/printk/printk.c::devkmsg_*):
+ *   - open(/dev/kmsg, O_RDONLY) initially positions at the first
+ *     record retained in the printk buffer;
+ *   - lseek(fd, 0, SEEK_END) advances past the current end so
+ *     subsequent read()s see only newly-appended records;
+ *   - O_NONBLOCK makes read() return -EAGAIN at EOF rather than
+ *     blocking for the next record.
+ *
+ * Each record is one read() call; the textual line begins after the
+ * first ',' delimiters in the metadata prefix
+ * "<prio>,<seq>,<ts>,<flag>;<text>\n".
+ *
+ * Requires CAP_SYS_ADMIN (or CAP_SYSLOG with kernel.dmesg_restrict
+ * relaxed). Selftests run as root in the kselftest harness so this
+ * is satisfied; kmsg_cursor_snapshot() returns -EPERM if not, and
+ * callers may SKIP the WARN/BUG assertion in that case.
+ */
+#ifndef SYSFS_LAZY_KMSG_CURSOR_H
+#define SYSFS_LAZY_KMSG_CURSOR_H
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#define KMSG_CURSOR_BUF_SZ	8192	/* one /dev/kmsg record max */
+
+struct kmsg_cursor {
+	int fd;
+};
+
+/*
+ * kmsg_cursor_snapshot - open /dev/kmsg and seek past the current
+ * end so subsequent extract() returns only records appended after
+ * this call. Returns 0 on success, -errno on failure (e.g. -EPERM
+ * if the caller lacks CAP_SYS_ADMIN/CAP_SYSLOG, -ENOENT if /dev/kmsg
+ * is absent in this filesystem image).
+ */
+static inline int kmsg_cursor_snapshot(struct kmsg_cursor *c)
+{
+	c->fd = open("/dev/kmsg", O_RDONLY | O_NONBLOCK);
+	if (c->fd < 0)
+		return -errno;
+	if (lseek(c->fd, 0, SEEK_END) == (off_t)-1) {
+		int err = -errno;
+
+		close(c->fd);
+		c->fd = -1;
+		return err;
+	}
+	return 0;
+}
+
+/*
+ * kmsg_cursor_extract_warnings - drain records appended since
+ * kmsg_cursor_snapshot() and return a heap-allocated newline-joined
+ * string of those whose textual body contains "WARNING:", "BUG:",
+ * "KASAN:", "UBSAN:", or "Oops:" (case-sensitive - these are the
+ * established splat prefixes from kernel/panic.c::__warn() and
+ * lib/ubsan.c). Returns NULL when no matches were found OR when
+ * extraction was not possible (no kmsg fd). Callers must free()
+ * the returned string.
+ *
+ * Reads are non-blocking: on -EAGAIN the loop terminates. -EPIPE
+ * (records overrun before we drained them) is treated as "no
+ * matches"; the harness will not synthesise a false-positive WARN
+ * on its own log saturation.
+ */
+static inline char *kmsg_cursor_extract_warnings(struct kmsg_cursor *c)
+{
+	char rec[KMSG_CURSOR_BUF_SZ];
+	char *out = NULL;
+	size_t out_len = 0, out_cap = 0;
+	ssize_t n;
+
+	if (!c || c->fd < 0)
+		return NULL;
+
+	for (;;) {
+		n = read(c->fd, rec, sizeof(rec) - 1);
+		if (n < 0) {
+			if (errno == EPIPE) {
+				/* Overrun - skip and keep draining. */
+				continue;
+			}
+			if (errno == EAGAIN || errno == EWOULDBLOCK)
+				break;
+			/* Other errors: stop, return what we have. */
+			break;
+		}
+		if (n == 0)
+			break;
+		rec[n] = '\0';
+
+		/* Split the metadata prefix off at the first ';'. */
+		char *body = strchr(rec, ';');
+
+		if (!body)
+			continue;
+		body++;
+
+		/* Trim a trailing newline so concatenation stays tidy. */
+		size_t blen = strlen(body);
+
+		while (blen && (body[blen - 1] == '\n' ||
+				body[blen - 1] == '\r'))
+			body[--blen] = '\0';
+
+		if (!strstr(body, "WARNING:") &&
+		    !strstr(body, "BUG:") &&
+		    !strstr(body, "KASAN:") &&
+		    !strstr(body, "UBSAN:") &&
+		    !strstr(body, "Oops:"))
+			continue;
+
+		/* Append "<body>\n" to the output buffer. */
+		size_t need = out_len + blen + 2; /* '\n' + NUL */
+
+		if (need > out_cap) {
+			size_t new_cap = out_cap ? out_cap * 2 : 1024;
+			char *p;
+
+			while (new_cap < need)
+				new_cap *= 2;
+			p = realloc(out, new_cap);
+			if (!p)
+				break;
+			out = p;
+			out_cap = new_cap;
+		}
+		memcpy(out + out_len, body, blen);
+		out_len += blen;
+		out[out_len++] = '\n';
+		out[out_len] = '\0';
+	}
+
+	return out;
+}
+
+static inline void kmsg_cursor_close(struct kmsg_cursor *c)
+{
+	if (c && c->fd >= 0) {
+		close(c->fd);
+		c->fd = -1;
+	}
+}
+
+#endif /* SYSFS_LAZY_KMSG_CURSOR_H */
diff --git a/tools/testing/selftests/sysfs-lazy/pci_resource.c b/tools/testing/selftests/sysfs-lazy/pci_resource.c
new file mode 100644
index 0000000000000..b54bcd40c7949
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/pci_resource.c
@@ -0,0 +1,284 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pci_resource - live-race idempotency stress test for lazy PCI
+ * resource sysfs files.
+ *
+ * Exercises the populate_one() vs populate_all() concurrency contract
+ * for pci_create_resource_files() after migration to the
+ * device_sysfs_entry walker.  Two threads attack the same PCI device
+ * directory for a bounded wall-clock window:
+ *
+ *   A: open(<dev>/resource0) + close, looped - drives
+ *      populate_one("resource0") through kernfs_iop_lookup() and the
+ *      device's ->populate hook.
+ *   B: opendir(<dev>) + readdir + closedir, looped - drives
+ *      populate_all() through the kernfs ->iterate dispatcher and the
+ *      device's ->populate_all hook.
+ *
+ * The fixed pre-walker pci_create_resource_files() created a single
+ * kernfs entry per BAR and assumed the post-create state was its own;
+ * called twice (e.g. once for resource0 by populate_one, once for the
+ * full set by populate_all racing immediately after), the second call
+ * would attempt to re-create the already-created entry and trip
+ * sysfs_warn_dup() / kernfs_link_sibling()'s "cannot create duplicate
+ * filename" WARN.
+ *
+ * The walker post-fix shape has the wildcard PCI resource row absorb
+ * the populate-already-done case (idempotent) under the per-device
+ * lock + populated-latch protocol added with the lazy
+ * series.  This selftest is the userspace boundary observable: race
+ * the two paths, then drain /dev/kmsg via kmsg_cursor and assert no
+ * WARN/BUG splat fired in the window.  The companion KUnit test
+ * walk_wildcard_row_idempotent() covers the in-kernel single-thread
+ * sequencing of the same contract; this one covers the multi-thread
+ * race that the production bug actually expressed under.
+ *
+ * Skips when:
+ *   - /sys/bus/pci/devices/ is empty (e.g. virtio-only builds);
+ *   - no PCI device has a resource0 attribute (BAR0 absent);
+ *   - /dev/kmsg is unreadable (lack of CAP_SYS_ADMIN/CAP_SYSLOG -
+ *     selftests usually run as root, but harness execution outside
+ *     a kselftest runner may not).
+ */
+#define _GNU_SOURCE
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <pthread.h>
+#include <stdatomic.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+#include "kmsg_cursor.h"
+
+#define PCI_DEVICES_ROOT	"/sys/bus/pci/devices"
+#define RACE_DURATION_MS	100
+
+/*
+ * find_pci_dev_with_resource0 - return heap-allocated absolute path
+ * to the first PCI device under PCI_DEVICES_ROOT whose "resource0"
+ * attribute is openable for read by the calling process, or NULL if
+ * none.  Caller frees.
+ *
+ * On a lazy-populate kernel, the open(2) probe below performs a
+ * populate_one("resource0") on the candidate device - which is the
+ * very contract this test races concurrently elsewhere.  This single
+ * up-front lookup is benign: there is no second writer at this point
+ * in the program, and the created attr stays present for the race
+ * window that follows.
+ *
+ * The probe uses open() rather than access(F_OK) so that a process
+ * without read permission on PCI resource files (selftests usually
+ * run as root, but ad-hoc invocations may not) skips gracefully via
+ * the caller's NULL-path SKIP rather than failing the post-race
+ * readability check.
+ */
+static char *find_pci_dev_with_resource0(void)
+{
+	DIR *d = opendir(PCI_DEVICES_ROOT);
+	struct dirent *de;
+	char *path = NULL;
+
+	if (!d)
+		return NULL;
+
+	while ((de = readdir(d))) {
+		char probe[PATH_MAX];
+		int fd;
+
+		if (de->d_name[0] == '.')
+			continue;
+
+		snprintf(probe, sizeof(probe), "%s/%s/resource0",
+			 PCI_DEVICES_ROOT, de->d_name);
+		fd = open(probe, O_RDONLY);
+		if (fd < 0)
+			continue;
+		close(fd);
+
+		path = malloc(PATH_MAX);
+		if (!path)
+			break;
+		snprintf(path, PATH_MAX, "%s/%s",
+			 PCI_DEVICES_ROOT, de->d_name);
+		break;
+	}
+
+	closedir(d);
+	return path;
+}
+
+struct race_ctx {
+	char			dev_dir[PATH_MAX];
+	char			res0_path[PATH_MAX];
+	atomic_int		stop;
+	atomic_long		iters_open;
+	atomic_long		iters_readdir;
+};
+
+static void *thread_open_close(void *arg)
+{
+	struct race_ctx *ctx = arg;
+
+	while (!atomic_load_explicit(&ctx->stop, memory_order_acquire)) {
+		int fd = open(ctx->res0_path, O_RDONLY);
+
+		if (fd >= 0)
+			close(fd);
+		atomic_fetch_add(&ctx->iters_open, 1);
+	}
+	return NULL;
+}
+
+static void *thread_readdir(void *arg)
+{
+	struct race_ctx *ctx = arg;
+
+	while (!atomic_load_explicit(&ctx->stop, memory_order_acquire)) {
+		DIR *d = opendir(ctx->dev_dir);
+
+		if (d) {
+			struct dirent *de;
+
+			while ((de = readdir(d)))
+				;
+			closedir(d);
+		}
+		atomic_fetch_add(&ctx->iters_readdir, 1);
+	}
+	return NULL;
+}
+
+static long elapsed_ms(const struct timespec *start)
+{
+	struct timespec now;
+
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	return (now.tv_sec - start->tv_sec) * 1000 +
+	       (now.tv_nsec - start->tv_nsec) / 1000000;
+}
+
+/*
+ * pci_resource_concurrent_open_readdir: stress the populate_one vs
+ * populate_all live-race for ~RACE_DURATION_MS milliseconds on the
+ * first PCI device that exposes resource0.  Capture /dev/kmsg
+ * WARN/BUG splats with kmsg_cursor; assert none fired during the
+ * race window.  resource0 must remain openable post-race.
+ */
+TEST(pci_resource_concurrent_open_readdir)
+{
+	struct race_ctx ctx = { 0 };
+	char *dev_path;
+	pthread_t t_open, t_dir;
+	bool t_open_started = false, t_dir_started = false;
+	struct kmsg_cursor kc;
+	char *warns;
+	int kc_ret, ret, fd;
+	struct timespec start;
+	long ms;
+
+	dev_path = find_pci_dev_with_resource0();
+	if (!dev_path)
+		SKIP(return,
+		     "no PCI device with readable resource0 found under "
+		     PCI_DEVICES_ROOT
+		     " (no PCI bus, no BAR0, or insufficient privileges)");
+
+	strncpy(ctx.dev_dir, dev_path, sizeof(ctx.dev_dir) - 1);
+	snprintf(ctx.res0_path, sizeof(ctx.res0_path), "%s/resource0",
+		 dev_path);
+	atomic_init(&ctx.stop, 0);
+	atomic_init(&ctx.iters_open, 0);
+	atomic_init(&ctx.iters_readdir, 0);
+
+	kc_ret = kmsg_cursor_snapshot(&kc);
+	if (kc_ret) {
+		free(dev_path);
+		SKIP(return,
+		     "kmsg cursor unavailable (%s); cannot detect WARN/dup splat",
+		     strerror(-kc_ret));
+	}
+
+	ret = pthread_create(&t_open, NULL, thread_open_close, &ctx);
+	ASSERT_EQ(0, ret) {
+		kmsg_cursor_close(&kc);
+		free(dev_path);
+		TH_LOG("pthread_create(open_close) failed: %s",
+		       strerror(ret));
+	}
+	t_open_started = true;
+
+	ret = pthread_create(&t_dir, NULL, thread_readdir, &ctx);
+	if (ret) {
+		atomic_store(&ctx.stop, 1);
+		pthread_join(t_open, NULL);
+		kmsg_cursor_close(&kc);
+		free(dev_path);
+		ASSERT_EQ(0, ret) {
+			TH_LOG("pthread_create(readdir) failed: %s",
+			       strerror(ret));
+		}
+	}
+	t_dir_started = true;
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	do {
+		struct timespec ts = { 0, 5 * 1000 * 1000 }; /* 5 ms */
+
+		nanosleep(&ts, NULL);
+		ms = elapsed_ms(&start);
+	} while (ms < RACE_DURATION_MS);
+
+	atomic_store(&ctx.stop, 1);
+	if (t_open_started)
+		pthread_join(t_open, NULL);
+	if (t_dir_started)
+		pthread_join(t_dir, NULL);
+
+	/*
+	 * Drain WARN/BUG splats accumulated during the race window.
+	 * The signature of the bug under test is:
+	 *   "sysfs: cannot create duplicate filename '/devices/.../resource0'"
+	 * inside a "WARNING:" splat, but any WARN/BUG/KASAN/UBSAN/Oops
+	 * fault during the window is also a regression of the
+	 * lock + populated-latch protocol or its callees and
+	 * fails the test.
+	 */
+	warns = kmsg_cursor_extract_warnings(&kc);
+	EXPECT_EQ(NULL, warns) {
+		TH_LOG("kernel WARN/BUG during pci_resource race on %s:\n%s",
+		       dev_path, warns);
+	}
+	free(warns);
+	kmsg_cursor_close(&kc);
+
+	/* resource0 must still be openable post-race. */
+	fd = open(ctx.res0_path, O_RDONLY);
+	EXPECT_GE(fd, 0) {
+		TH_LOG("open(%s) failed post-race: %s",
+		       ctx.res0_path, strerror(errno));
+	}
+	if (fd >= 0)
+		close(fd);
+
+	/* Sanity: both threads got CPU time. */
+	EXPECT_GT(atomic_load(&ctx.iters_open), 0);
+	EXPECT_GT(atomic_load(&ctx.iters_readdir), 0);
+	TH_LOG("race ran %ldms: open_close=%ld readdir=%ld on %s",
+	       ms,
+	       atomic_load(&ctx.iters_open),
+	       atomic_load(&ctx.iters_readdir),
+	       dev_path);
+
+	free(dev_path);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/sysfs-lazy/settings b/tools/testing/selftests/sysfs-lazy/settings
new file mode 100644
index 0000000000000..6091b45d226ba
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/settings
@@ -0,0 +1 @@
+timeout=120
diff --git a/tools/testing/selftests/sysfs-lazy/sysfs-lazy.c b/tools/testing/selftests/sysfs-lazy/sysfs-lazy.c
new file mode 100644
index 0000000000000..6599a589366b3
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/sysfs-lazy.c
@@ -0,0 +1,777 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sysfs-lazy.c - kselftest for sysfs lazy initialization
+ *
+ * Integration-level coverage of the per-file lazy sysfs populate
+ * mechanism by loading the sysfs_lazy_test_mod module and exercising
+ * teardown, leak, and bind/unbind invariants that can only be
+ * observed from userspace (module load/unload + driver-core rebind).
+ * The per-call populate behaviour (visibility, mode, groups,
+ * idempotency, atomicity) is validated in-kernel by the
+ * KUnit suite drivers/base/test/device_sysfs_apply_test.c; duplicating
+ * those invariants here would just add maintenance overhead.
+ *
+ * Requires: sysfs_lazy_test_mod.ko loaded (or loadable).
+ */
+#define _GNU_SOURCE
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+#include "kmsg_cursor.h"
+
+/*
+ * getdents64(2) is exposed by glibc on most distros but not all
+ * (notably some musl builds and older glibc). Selftests build against
+ * KHDR_INCLUDES which gives us the syscall number; wrap it directly to
+ * avoid a libc-version dependency. The struct definition matches
+ * include/uapi/linux/dirent.h::linux_dirent64.
+ */
+struct sysfs_lazy_linux_dirent64 {
+	uint64_t	d_ino;
+	int64_t		d_off;
+	unsigned short	d_reclen;
+	unsigned char	d_type;
+	char		d_name[];
+};
+
+static inline ssize_t sysfs_lazy_getdents64(int fd, void *buf, size_t len)
+{
+	return syscall(SYS_getdents64, fd, buf, len);
+}
+
+#define MOD_NAME		"sysfs_lazy_test_mod"
+#define DEV_NAME		"sysfs_lazy_test"
+#define EAGER_NAME		"sysfs_lazy_test_eager"
+#define DEV_DIR			"/sys/devices/platform/" DEV_NAME
+#define EAGER_DIR		"/sys/devices/platform/" EAGER_NAME
+#define DRV_DIR			"/sys/bus/platform/drivers/" DEV_NAME
+
+/* ---- helpers ----------------------------------------------------------- */
+
+static bool file_exists(const char *dir, const char *name)
+{
+	char path[PATH_MAX];
+	struct stat st;
+
+	snprintf(path, sizeof(path), "%s/%s", dir, name);
+	return stat(path, &st) == 0;
+}
+
+static int read_file_str(const char *dir, const char *name,
+			 char *buf, size_t len)
+{
+	char path[PATH_MAX];
+	int fd, n;
+
+	snprintf(path, sizeof(path), "%s/%s", dir, name);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+	n = read(fd, buf, len - 1);
+	close(fd);
+	if (n < 0)
+		return -errno;
+	buf[n] = '\0';
+	return 0;
+}
+
+static int write_file_str(const char *path, const char *val)
+{
+	int fd, ret;
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -errno;
+	ret = write(fd, val, strlen(val));
+	close(fd);
+	return ret < 0 ? -errno : 0;
+}
+
+static int count_dir_entries(const char *path)
+{
+	struct dirent *de;
+	DIR *d;
+	int n = 0;
+
+	d = opendir(path);
+	if (!d)
+		return -errno;
+	while ((de = readdir(d)) != NULL) {
+		if (!strcmp(de->d_name, ".") || !strcmp(de->d_name, ".."))
+			continue;
+		n++;
+	}
+	closedir(d);
+	return n;
+}
+
+static int load_module(void)
+{
+	return system("modprobe " MOD_NAME);
+}
+
+static int load_module_with_twin(void)
+{
+	return system("modprobe " MOD_NAME " eager_twin=1");
+}
+
+/*
+ * load_module_with_inject - load test_mod with inject_errno=@val so
+ * dev->type->populate(dev, "inject_target") returns @val unchanged.
+ * The lookup path then forwards that errno to userspace open(2)
+ * without caching a negative dentry.
+ */
+static int load_module_with_inject(int val)
+{
+	char cmd[128];
+
+	snprintf(cmd, sizeof(cmd),
+		 "modprobe " MOD_NAME " inject_errno=%d", val);
+	return system(cmd);
+}
+
+static int unload_module(void)
+{
+	return system("rmmod " MOD_NAME " 2>/dev/null");
+}
+
+/* ---- fixture ----------------------------------------------------------- */
+
+FIXTURE(sysfs_lazy) {
+	int dummy;
+};
+
+FIXTURE_SETUP(sysfs_lazy)
+{
+	unload_module();
+	ASSERT_EQ(0, load_module());
+	/* Give udev a moment */
+	usleep(100000);
+}
+
+FIXTURE_TEARDOWN(sysfs_lazy)
+{
+	unload_module();
+}
+
+/* ---- test 1: teardown_partial ------------------------------------------ */
+
+/*
+ * Realize a subset of attrs, then unload the module and confirm the
+ * partial state tears down cleanly (no leaks, no crashes, device dir
+ * gone).  Integration-only: requires module unload.
+ *
+ * kmsg cursor: snapshot at start, drain WARN/BUG splats at end.
+ * Test fails if any kernel-side warning fires during the window.
+ */
+TEST_F(sysfs_lazy, teardown_partial)
+{
+	struct kmsg_cursor kc;
+	char *warns;
+	int kc_ret;
+	char buf[64];
+
+	kc_ret = kmsg_cursor_snapshot(&kc);
+
+	/* Realize only a few attrs */
+	ASSERT_EQ(0, read_file_str(DEV_DIR, "basic0", buf, sizeof(buf)));
+	ASSERT_EQ(0, read_file_str(DEV_DIR, "extra0", buf, sizeof(buf)));
+
+	/* Unload module - should not leak or crash */
+	ASSERT_EQ(0, unload_module());
+
+	/* Device dir should be gone */
+	EXPECT_FALSE(file_exists("/sys/devices/platform", DEV_NAME));
+
+	/* No WARN/BUG splats in the captured kmsg window. */
+	if (kc_ret == 0) {
+		warns = kmsg_cursor_extract_warnings(&kc);
+		EXPECT_EQ(NULL, warns) {
+			TH_LOG("kernel WARN/BUG during teardown_partial:\n%s",
+			       warns);
+		}
+		free(warns);
+		kmsg_cursor_close(&kc);
+	} else {
+		TH_LOG("kmsg cursor unavailable (%s); skipping splat check",
+		       strerror(-kc_ret));
+	}
+
+	/* Reload for teardown fixture */
+	ASSERT_EQ(0, load_module());
+	usleep(100000);
+}
+
+/* ---- test 2: no_leaks_on_unload ---------------------------------------- */
+
+/*
+ * Realize everything, then unload with kmemleak scanning to catch any
+ * lazy-populate allocation that escapes teardown.  Integration-only:
+ * requires kmemleak and module unload.
+ *
+ * kmsg cursor: snapshot at start, drain WARN/BUG splats at end. The
+ * kmemleak read below is best-effort; a kmemleak hit is reported as
+ * the buffer mismatch, while any other WARN/BUG (e.g. lockdep, KASAN
+ * use-after-free in the unload path) surfaces via the cursor.
+ */
+TEST_F(sysfs_lazy, no_leaks_on_unload)
+{
+	struct kmsg_cursor kc;
+	char *warns;
+	int kc_ret;
+
+	kc_ret = kmsg_cursor_snapshot(&kc);
+
+	/* Realize all attrs */
+	count_dir_entries(DEV_DIR);
+
+	/* Unload */
+	ASSERT_EQ(0, unload_module());
+
+	/* Trigger kmemleak scan if available */
+	write_file_str("/sys/kernel/debug/kmemleak", "scan");
+
+	/* Check kmemleak (best-effort - may not be enabled) */
+	char buf[256];
+	int ret;
+
+	ret = read_file_str("/sys/kernel/debug", "kmemleak",
+			    buf, sizeof(buf));
+	if (ret == 0)
+		EXPECT_STREQ("", buf);
+
+	/* Device dir must be gone */
+	EXPECT_FALSE(file_exists("/sys/devices/platform", DEV_NAME));
+
+	/* No WARN/BUG splats in the captured kmsg window. */
+	if (kc_ret == 0) {
+		warns = kmsg_cursor_extract_warnings(&kc);
+		EXPECT_EQ(NULL, warns) {
+			TH_LOG("kernel WARN/BUG during no_leaks_on_unload:\n%s",
+			       warns);
+		}
+		free(warns);
+		kmsg_cursor_close(&kc);
+	} else {
+		TH_LOG("kmsg cursor unavailable (%s); skipping splat check",
+		       strerror(-kc_ret));
+	}
+
+	/* Reload for teardown fixture */
+	ASSERT_EQ(0, load_module());
+	usleep(100000);
+}
+
+/* ---- test 3: bind_unbind_cycle ----------------------------------------- */
+
+/*
+ * Realize one attr, unbind the driver, rebind, and confirm the
+ * created attr is still reachable.  Integration-only: requires
+ * driver-core bind/unbind plumbing.
+ *
+ * kmsg cursor: snapshot at start, drain WARN/BUG splats at end. The
+ * unbind/rebind path is the most likely site for a lockdep splat or
+ * a refcount imbalance, so the splat check is high-value here.
+ */
+TEST_F(sysfs_lazy, bind_unbind_cycle)
+{
+	struct kmsg_cursor kc;
+	char *warns;
+	int kc_ret;
+	char buf[64];
+
+	kc_ret = kmsg_cursor_snapshot(&kc);
+
+	/* Realize some attrs */
+	ASSERT_EQ(0, read_file_str(DEV_DIR, "basic0", buf, sizeof(buf)));
+	EXPECT_STREQ("42\n", buf);
+
+	/* Unbind driver */
+	ASSERT_EQ(0, write_file_str(DRV_DIR "/unbind", DEV_NAME));
+	usleep(50000);
+
+	/* Verify driver symlink gone */
+	EXPECT_FALSE(file_exists(DEV_DIR, "driver"));
+
+	/* Rebind */
+	ASSERT_EQ(0, write_file_str(DRV_DIR "/bind", DEV_NAME));
+	usleep(50000);
+
+	/* Verify driver symlink restored */
+	EXPECT_TRUE(file_exists(DEV_DIR, "driver"));
+
+	/* Previously-created attrs still accessible */
+	ASSERT_EQ(0, read_file_str(DEV_DIR, "basic0", buf, sizeof(buf)));
+	EXPECT_STREQ("42\n", buf);
+
+	/* No WARN/BUG splats in the captured kmsg window. */
+	if (kc_ret == 0) {
+		warns = kmsg_cursor_extract_warnings(&kc);
+		EXPECT_EQ(NULL, warns) {
+			TH_LOG("kernel WARN/BUG during bind_unbind_cycle:\n%s",
+			       warns);
+		}
+		free(warns);
+		kmsg_cursor_close(&kc);
+	} else {
+		TH_LOG("kmsg cursor unavailable (%s); skipping splat check",
+		       strerror(-kc_ret));
+	}
+}
+
+/* ---- test 4: transient_populate_error_propagates ----------------------- */
+
+/*
+ * The transient-populate-error contract documented in
+ * Documentation/driver-api/sysfs-lazy.rst guarantees that an errno
+ * returned by a driver's populate hook propagates verbatim through
+ * the kernfs lookup path to userspace open(2), and that the lookup
+ * does NOT cache a negative dentry (so a subsequent attempt - once
+ * the underlying condition has cleared - succeeds). The companion
+ * KUnit case walk_enomem_propagates() covers the walker boundary;
+ * this case extends coverage to the userspace open(2) boundary.
+ *
+ * Mechanism: the test_mod's dev->type->populate(dev, "inject_target")
+ * returns inject_errno when negative. inject_target is intentionally
+ * absent from dev->groups, so the standard create_dev_own_groups()
+ * row of driver_core_sysfs_entries[] returns -ENOENT and the
+ * dispatch falls through to the type hook.
+ *
+ * Step 1: load with inject_errno=-ENOMEM, open inject_target, expect
+ *         open(2) == -1 with errno == ENOMEM.
+ * Step 2: reload without injection, open inject_target, expect
+ *         open(2) >= 0 (success).
+ *
+ * Cannot share the FIXTURE_SETUP load because that call uses the
+ * default modprobe arguments. Reload explicitly.
+ */
+TEST_F(sysfs_lazy, transient_populate_error_propagates)
+{
+	int fd;
+
+	/* Step 1: reload with -ENOMEM injection. */
+	ASSERT_EQ(0, unload_module());
+	ASSERT_EQ(0, load_module_with_inject(-ENOMEM));
+	usleep(100000);
+
+	errno = 0;
+	fd = open(DEV_DIR "/inject_target", O_RDONLY);
+	EXPECT_EQ(-1, fd);
+	EXPECT_EQ(ENOMEM, errno);
+	if (fd >= 0)
+		close(fd);
+
+	/* Step 2: reload without injection; the same open must succeed. */
+	ASSERT_EQ(0, unload_module());
+	ASSERT_EQ(0, load_module());
+	usleep(100000);
+
+	errno = 0;
+	fd = open(DEV_DIR "/inject_target", O_RDONLY);
+	EXPECT_GE(fd, 0) {
+		TH_LOG("open(inject_target) failed after clearing injection: %s",
+		       strerror(errno));
+	}
+	if (fd >= 0)
+		close(fd);
+}
+
+/* ---- test 5: readdir_order_abi_guard ----------------------------------- */
+
+/*
+ * Readdir-time ABI guard. Confirms that the lazy populate_all path
+ * surfaces the same set of top-level entries as the eager device_add
+ * path would, by reading the device directory via getdents64(2)
+ * directly (no opendir(3)/readdir(3) layer that some libcs sort
+ * post-hoc, no qsort).
+ *
+ * Order pinning note: kernfs orders sibling entries by name hash in
+ * an rb-tree (fs/kernfs/dir.c::kernfs_link_sibling /
+ * kernfs_dir_pos), NOT by insertion order. The on-disk readdir order
+ * is therefore deterministic but a function of the entry names'
+ * hashes, not of driver_core_sysfs_entries[] table order. Pinning a
+ * literal hash-ordered list would brittle-couple the test to the
+ * kernfs hash function. Instead this guard pins the SET of expected
+ * names: every name produced by the test_mod's groups plus the
+ * stable driver-core / platform-bus contributions must appear, and
+ * the diagnostic logs the actual on-disk order so a regression that
+ * reorders entries (e.g. a kernfs hash change) shows up in the
+ * artifact.
+ *
+ * Skipped names (noise out of scope for this guard):
+ *   - ".", ".." - directory pseudo-entries
+ *   - "driver" - symlink whose presence depends on bind state
+ *   - "subsystem" - bus symlink, presence depends on bus state
+ *   - "numa_node" - platform_bus_type dev_groups attr hidden when
+ *     dev_to_node() == NUMA_NO_NODE (host-config dependent)
+ *   - "uevent" - present universally; not asserted here because
+ *     it's covered by the eager_lazy_tree_match invariant test
+ */
+TEST_F(sysfs_lazy, readdir_order_abi_guard)
+{
+	/*
+	 * Required names: every entry the test_mod's group tables MUST
+	 * produce. These are an upstream-stable contract: changing any
+	 * of these implies a deliberate change to the test fixture and
+	 * this list together.
+	 */
+	static const char * const required_names[] = {
+		/* lazy_test_basic_group */
+		"basic0", "basic1",
+		/* lazy_test_extra_group */
+		"extra0", "extra1",
+		/* lazy_test_link_group (named subdir) */
+		"link",
+		/* lazy_test_bin_group */
+		"bin0", "bin1",
+		/* driver-core stable rows */
+		"power",
+		"uevent",
+	};
+	static const char * const skip_names[] = {
+		".", "..",
+		"driver", "subsystem",
+		"numa_node",
+		/*
+		 * driver_override comes from bus_add_device() via
+		 * device_add_group(driver_override_dev_group) when
+		 * dev->bus->driver_override is true. Platform bus sets
+		 * it; skip rather than require so the test stays
+		 * portable to buses that don't.
+		 */
+		"driver_override",
+		/*
+		 * modalias is a platform_bus_type dev_groups attribute.
+		 * Required by the platform-bus contract but skipped
+		 * here because we don't pin bus-specific names - the
+		 * test_mod-contributed names are the load-bearing
+		 * surface for this guard.
+		 */
+		"modalias",
+	};
+	char buf[8192];
+	bool seen_required[ARRAY_SIZE(required_names)] = { false };
+	int dir_fd, i;
+	ssize_t nread;
+	size_t total_seen = 0;
+	char order_log[1024];
+	size_t order_log_len = 0;
+
+	/*
+	 * Trigger populate_all on the lazy device's top-level dir.
+	 * The opendir(3)+readdir(3) loop performs the readdir(2) that
+	 * drives the kernfs populate_all() callback; we intentionally
+	 * use opendir for *triggering* and getdents64 for *reading*
+	 * to avoid any libc sort.
+	 */
+	count_dir_entries(DEV_DIR);
+
+	dir_fd = open(DEV_DIR, O_RDONLY | O_DIRECTORY);
+	ASSERT_GE(dir_fd, 0) {
+		TH_LOG("open(%s, O_DIRECTORY) failed: %s",
+		       DEV_DIR, strerror(errno));
+	}
+
+	for (;;) {
+		struct sysfs_lazy_linux_dirent64 *de;
+		off_t off;
+
+		nread = sysfs_lazy_getdents64(dir_fd, buf, sizeof(buf));
+		ASSERT_GE(nread, 0) {
+			TH_LOG("getdents64(%s) failed: %s",
+			       DEV_DIR, strerror(errno));
+		}
+		if (nread == 0)
+			break;
+
+		for (off = 0; off < nread; ) {
+			const char *name;
+			bool skip = false;
+
+			de = (struct sysfs_lazy_linux_dirent64 *)(buf + off);
+			name = de->d_name;
+			off += de->d_reclen;
+
+			for (i = 0; i < (int)ARRAY_SIZE(skip_names); i++) {
+				if (!strcmp(name, skip_names[i])) {
+					skip = true;
+					break;
+				}
+			}
+			if (skip)
+				continue;
+
+			total_seen++;
+
+			/* Append to diagnostic order log. */
+			if (order_log_len + strlen(name) + 2 <
+			    sizeof(order_log)) {
+				if (order_log_len)
+					order_log[order_log_len++] = ' ';
+				memcpy(order_log + order_log_len, name,
+				       strlen(name));
+				order_log_len += strlen(name);
+				order_log[order_log_len] = '\0';
+			}
+
+			for (i = 0; i < (int)ARRAY_SIZE(required_names);
+			     i++) {
+				if (!strcmp(name, required_names[i])) {
+					seen_required[i] = true;
+					break;
+				}
+			}
+		}
+	}
+	close(dir_fd);
+
+	TH_LOG("getdents64 raw order (post-skip, %zu entries): %s",
+	       total_seen, order_log);
+
+	/* Every required name must have been seen. */
+	for (i = 0; i < (int)ARRAY_SIZE(required_names); i++) {
+		EXPECT_TRUE(seen_required[i]) {
+			TH_LOG("required entry '%s' missing from %s",
+			       required_names[i], DEV_DIR);
+		}
+	}
+}
+
+/* ---- test 6: eager_lazy_equivalence ------------------------------------ */
+
+/*
+ * The core contract: after populate_all (triggered by readdir), a lazy
+ * device's sysfs tree must be equivalent to an eager device's tree.
+ * "Equivalent" = same entry names, same entry types (file/dir/link),
+ * same permissions.  We compare both trees recursively, skipping
+ * entries known to differ by identity (driver symlink target contains
+ * the device name, power/ runtime_status may differ by timing).
+ */
+
+#define MAX_ENTRIES	128
+
+struct sysfs_entry {
+	char name[256];
+	char subpath[512]; /* relative path from device root */
+	unsigned char d_type;
+	mode_t mode;
+};
+
+static int cmp_entry(const void *a, const void *b)
+{
+	return strcmp(((const struct sysfs_entry *)a)->subpath,
+		     ((const struct sysfs_entry *)b)->subpath);
+}
+
+/*
+ * Recursively collect all entries under @base into @entries[].
+ * @prefix is the relative path from the device root (empty for top level).
+ * Returns number of entries collected, or negative on error.
+ */
+static int collect_tree(const char *base, const char *prefix,
+			struct sysfs_entry *entries, int max, int idx)
+{
+	char path[PATH_MAX];
+	struct dirent *de;
+	struct stat st;
+	DIR *d;
+
+	snprintf(path, sizeof(path), "%s/%s", base, prefix);
+	d = opendir(path);
+	if (!d)
+		return -errno;
+
+	while ((de = readdir(d)) != NULL) {
+		if (!strcmp(de->d_name, ".") || !strcmp(de->d_name, ".."))
+			continue;
+		if (idx >= max)
+			break;
+
+		snprintf(entries[idx].name, sizeof(entries[idx].name),
+			 "%s", de->d_name);
+		if (prefix[0])
+			snprintf(entries[idx].subpath,
+				 sizeof(entries[idx].subpath),
+				 "%s/%s", prefix, de->d_name);
+		else
+			snprintf(entries[idx].subpath,
+				 sizeof(entries[idx].subpath),
+				 "%s", de->d_name);
+
+		entries[idx].d_type = de->d_type;
+
+		snprintf(path, sizeof(path), "%s/%s",
+			 base, entries[idx].subpath);
+		if (lstat(path, &st) == 0)
+			entries[idx].mode = st.st_mode;
+
+		idx++;
+
+		/* Recurse into subdirectories */
+		if (de->d_type == DT_DIR) {
+			char sub[512];
+
+			if (prefix[0])
+				snprintf(sub, sizeof(sub), "%s/%s",
+					 prefix, de->d_name);
+			else
+				snprintf(sub, sizeof(sub), "%s", de->d_name);
+			idx = collect_tree(base, sub, entries, max, idx);
+			if (idx < 0) {
+				closedir(d);
+				return idx;
+			}
+		}
+	}
+	closedir(d);
+	return idx;
+}
+
+/* Skip entries that legitimately differ between the two devices */
+static bool skip_entry(const char *subpath)
+{
+	/* The 'driver' symlink target differs (points to different driver) */
+	if (!strcmp(subpath, "driver"))
+		return true;
+	/* power/runtime_status is timing-dependent */
+	if (!strcmp(subpath, "power/runtime_status"))
+		return true;
+	/*
+	 * inject_target is a fault-injection knob materialised by
+	 * sysfs_lazy_test_type_populate{,_all}() and is intentionally
+	 * lazy-only - the eager twin's attribute tables don't expose
+	 * it, so a comparison would always show it as a lazy-only
+	 * extra. The transient_populate_error_propagates test exercises
+	 * it directly; eager_lazy_tree_match has no business asserting
+	 * its presence equivalence.
+	 */
+	if (!strcmp(subpath, "inject_target"))
+		return true;
+	return false;
+}
+
+FIXTURE(sysfs_lazy_equiv) {
+	int dummy;
+};
+
+FIXTURE_SETUP(sysfs_lazy_equiv)
+{
+	unload_module();
+	ASSERT_EQ(0, load_module_with_twin());
+	usleep(100000);
+}
+
+FIXTURE_TEARDOWN(sysfs_lazy_equiv)
+{
+	unload_module();
+}
+
+TEST_F(sysfs_lazy_equiv, eager_lazy_tree_match)
+{
+	struct sysfs_entry *lazy_entries, *eager_entries;
+	int lazy_count, eager_count;
+	int i, j, mismatches = 0;
+
+	lazy_entries = calloc(MAX_ENTRIES, sizeof(*lazy_entries));
+	eager_entries = calloc(MAX_ENTRIES, sizeof(*eager_entries));
+	ASSERT_NE(NULL, lazy_entries);
+	ASSERT_NE(NULL, eager_entries);
+
+	/*
+	 * Trigger populate_all on the lazy device via readdir.
+	 * The eager device already has all entries from device_add().
+	 */
+	count_dir_entries(DEV_DIR);
+
+	/* Collect both trees */
+	lazy_count = collect_tree(DEV_DIR, "", lazy_entries, MAX_ENTRIES, 0);
+	ASSERT_GT(lazy_count, 0);
+
+	eager_count = collect_tree(EAGER_DIR, "", eager_entries,
+				   MAX_ENTRIES, 0);
+	ASSERT_GT(eager_count, 0);
+
+	/* Sort both by subpath for comparison */
+	qsort(lazy_entries, lazy_count, sizeof(*lazy_entries), cmp_entry);
+	qsort(eager_entries, eager_count, sizeof(*eager_entries), cmp_entry);
+
+	/* Compare: every eager entry must exist in lazy with same type/mode */
+	for (i = 0; i < eager_count; i++) {
+		if (skip_entry(eager_entries[i].subpath))
+			continue;
+
+		bool found = false;
+
+		for (j = 0; j < lazy_count; j++) {
+			if (!strcmp(eager_entries[i].subpath,
+				   lazy_entries[j].subpath)) {
+				found = true;
+
+				if (eager_entries[i].d_type !=
+				    lazy_entries[j].d_type) {
+					TH_LOG("type mismatch: %s (eager=%d lazy=%d)",
+					       eager_entries[i].subpath,
+					       eager_entries[i].d_type,
+					       lazy_entries[j].d_type);
+					mismatches++;
+				}
+				if ((eager_entries[i].mode & 07777) !=
+				    (lazy_entries[j].mode & 07777)) {
+					TH_LOG("mode mismatch: %s (eager=%04o lazy=%04o)",
+					       eager_entries[i].subpath,
+					       eager_entries[i].mode & 07777,
+					       lazy_entries[j].mode & 07777);
+					mismatches++;
+				}
+				break;
+			}
+		}
+		if (!found) {
+			TH_LOG("eager entry '%s' missing from lazy tree",
+			       eager_entries[i].subpath);
+			mismatches++;
+		}
+	}
+
+	/* Check reverse: lazy entries not in eager (should be none) */
+	for (j = 0; j < lazy_count; j++) {
+		if (skip_entry(lazy_entries[j].subpath))
+			continue;
+
+		bool found = false;
+
+		for (i = 0; i < eager_count; i++) {
+			if (!strcmp(lazy_entries[j].subpath,
+				   eager_entries[i].subpath)) {
+				found = true;
+				break;
+			}
+		}
+		if (!found) {
+			TH_LOG("lazy entry '%s' not in eager tree (extra)",
+			       lazy_entries[j].subpath);
+			mismatches++;
+		}
+	}
+
+	EXPECT_EQ(0, mismatches);
+	TH_LOG("compared %d eager entries vs %d lazy entries",
+	       eager_count, lazy_count);
+
+	free(lazy_entries);
+	free(eager_entries);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/sysfs-lazy/test_mod/Makefile b/tools/testing/selftests/sysfs-lazy/test_mod/Makefile
new file mode 100644
index 0000000000000..f7f9bbc896531
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/test_mod/Makefile
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0
+SYSFS_LAZY_TEST_MOD_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
+KDIR ?= $(if $(O),$(O),$(abspath $(SYSFS_LAZY_TEST_MOD_DIR)/../../../../..))
+
+ifeq ($(V),1)
+Q =
+else
+Q = @
+endif
+
+obj-m += sysfs_lazy_test_mod.o
+
+# -rR forces no built-in rules/variables: avoids GNU Make's Modula-2 implicit
+# rule (%.o: %.mod) firing on kbuild's $(obj)/%.mod pseudo-targets when the
+# parent kselftest harness chain did not propagate MAKEFLAGS=-rR.
+#
+# KBUILD_EXTMOD= is set in addition to M= because the kernel Makefile's
+# sub_make_done re-exec changes the origin of M= from "command line" to
+# "environment", and the kernel Makefile only honours M= if its origin is
+# "command line".  Without KBUILD_EXTMOD, kbuild silently falls back to a
+# full in-tree modules build instead of building the external test module.
+all:
+	+$(Q)$(MAKE) -rR -C $(KDIR) M=$(SYSFS_LAZY_TEST_MOD_DIR) \
+		KBUILD_EXTMOD=$(SYSFS_LAZY_TEST_MOD_DIR) modules
+
+clean:
+	+$(Q)$(MAKE) -rR -C $(KDIR) M=$(SYSFS_LAZY_TEST_MOD_DIR) \
+		KBUILD_EXTMOD=$(SYSFS_LAZY_TEST_MOD_DIR) clean
diff --git a/tools/testing/selftests/sysfs-lazy/test_mod/sysfs_lazy_test_mod.c b/tools/testing/selftests/sysfs-lazy/test_mod/sysfs_lazy_test_mod.c
new file mode 100644
index 0000000000000..7a44e220c640f
--- /dev/null
+++ b/tools/testing/selftests/sysfs-lazy/test_mod/sysfs_lazy_test_mod.c
@@ -0,0 +1,319 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sysfs_lazy_test_mod - test module for sysfs lazy initialization
+ *
+ * Registers a lazy platform device (opted in via
+ * device_set_sysfs_lazy()) with 8 attributes across four groups
+ * (basic, extra, named "link", bin) so the userspace selftest can
+ * exercise the integration-level invariants (teardown, leak,
+ * bind/unbind) over realistic attribute shapes.
+ *
+ * When loaded with eager_twin=1, a second identical device is
+ * registered without the lazy opt-in (eager).  The selftest uses
+ * this to assert that lazy populate produces a sysfs tree
+ * equivalent to eager create.
+ *
+ * Per-call populate behaviour (visibility, mode, groups,
+ * idempotency, atomicity) is validated by the in-kernel KUnit suite
+ * drivers/base/test/device_sysfs_apply_test.c.  The selftest no longer
+ * wraps device_ktype to observe populate invocations; that avoids
+ * exporting a driver-core internal type purely for test observability.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#define MOD_NAME	"sysfs_lazy_test"
+#define EAGER_NAME	"sysfs_lazy_test_eager"
+
+static bool eager_twin;
+module_param(eager_twin, bool, 0444);
+MODULE_PARM_DESC(eager_twin, "Also register an eager (non-lazy) twin device");
+
+/*
+ * Fault-injection knob for the selftest harness: when negative,
+ * dev->type->populate(dev, "inject_target") returns this value
+ * unchanged. The kernfs lookup path forwards a non-(-ENOENT) error
+ * to userspace as the open(2) errno without caching a negative
+ * dentry (see kernfs_iop_lookup() in fs/kernfs/dir.c), exercising
+ * the transient-populate-error contract documented in
+ * Documentation/driver-api/sysfs-lazy.rst end-to-end.
+ *
+ * The companion in-kernel KUnit case walk_enomem_propagates() in
+ * drivers/base/test/device_sysfs_apply_test.c covers the same
+ * contract at the walker boundary; this knob extends coverage to
+ * the userspace open(2) boundary.
+ *
+ * 0 disables injection; "inject_target" then materialises as a
+ * normal sysfs file via dev_attr_inject_target on first lookup.
+ */
+static int inject_errno;
+module_param(inject_errno, int, 0644);
+MODULE_PARM_DESC(inject_errno,
+	"On lazy populate of 'inject_target', return this errno (e.g. -12 = -ENOMEM, -5 = -EIO). 0 disables injection.");
+
+static struct platform_device *test_pdev;
+static struct platform_device *eager_pdev;
+
+/* --- sysfs show helper -------------------------------------------------- */
+
+static ssize_t test_attr_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "42\n");
+}
+
+/* --- basic group (2 attrs) ---------------------------------------------- */
+
+static DEVICE_ATTR(basic0, 0444, test_attr_show, NULL);
+static DEVICE_ATTR(basic1, 0444, test_attr_show, NULL);
+
+static struct attribute *lazy_test_basic_attrs[] = {
+	&dev_attr_basic0.attr, &dev_attr_basic1.attr,
+	NULL,
+};
+
+static const struct attribute_group lazy_test_basic_group = {
+	.attrs = lazy_test_basic_attrs,
+};
+
+/* --- extra group (2 attrs) ---------------------------------------------- */
+
+static DEVICE_ATTR(extra0, 0444, test_attr_show, NULL);
+static DEVICE_ATTR(extra1, 0444, test_attr_show, NULL);
+
+static struct attribute *lazy_test_extra_attrs[] = {
+	&dev_attr_extra0.attr, &dev_attr_extra1.attr,
+	NULL,
+};
+
+static const struct attribute_group lazy_test_extra_group = {
+	.attrs = lazy_test_extra_attrs,
+};
+
+/* --- named subdir group "link" (2 attrs) -------------------------------- */
+
+static DEVICE_ATTR(link0, 0444, test_attr_show, NULL);
+static DEVICE_ATTR(link1, 0444, test_attr_show, NULL);
+
+static struct attribute *lazy_test_link_attrs[] = {
+	&dev_attr_link0.attr, &dev_attr_link1.attr,
+	NULL,
+};
+
+static const struct attribute_group lazy_test_link_group = {
+	.name	= "link",
+	.attrs	= lazy_test_link_attrs,
+};
+
+/* --- binary group (2 bin_attrs) ----------------------------------------- */
+
+static ssize_t lazy_bin_read(struct file *f, struct kobject *kobj,
+			     const struct bin_attribute *attr, char *buf,
+			     loff_t off, size_t count)
+{
+	static const char data[] = "binary\n";
+	size_t len = sizeof(data) - 1;
+
+	if (off >= len)
+		return 0;
+	if (off + count > len)
+		count = len - off;
+	memcpy(buf, data + off, count);
+	return count;
+}
+
+static const struct bin_attribute bin_attr_bin0 =
+	__BIN_ATTR(bin0, 0444, lazy_bin_read, NULL, 7);
+static const struct bin_attribute bin_attr_bin1 =
+	__BIN_ATTR(bin1, 0444, lazy_bin_read, NULL, 7);
+
+static const struct bin_attribute *const lazy_test_bin_attrs[] = {
+	&bin_attr_bin0, &bin_attr_bin1,
+	NULL,
+};
+
+static const struct attribute_group lazy_test_bin_group = {
+	.bin_attrs = lazy_test_bin_attrs,
+};
+
+/* --- device groups array ------------------------------------------------ */
+
+static const struct attribute_group *lazy_test_groups[] = {
+	&lazy_test_basic_group,
+	&lazy_test_extra_group,
+	&lazy_test_link_group,
+	&lazy_test_bin_group,
+	NULL,
+};
+
+/* --- fault-injection target (NOT in dev->groups) ------------------------ */
+
+/*
+ * "inject_target" lives outside dev->groups so the standard
+ * create_dev_own_groups() row of driver_core_sysfs_entries[]
+ * cannot match it. The walker therefore returns -ENOENT for this
+ * name and the dispatch falls through to dev->type->populate (see
+ * device_ktype_populate_one() in drivers/base/core.c). That gives
+ * the test a clean injection point at the type->populate boundary
+ * without perturbing the standard group machinery.
+ */
+static DEVICE_ATTR(inject_target, 0444, test_attr_show, NULL);
+
+static int sysfs_lazy_test_type_populate(struct device *dev, const char *name)
+{
+	if (strcmp(name, "inject_target") != 0)
+		return -ENOENT;
+	if (inject_errno < 0)
+		return inject_errno;
+	return sysfs_create_file(&dev->kobj, &dev_attr_inject_target.attr);
+}
+
+static void sysfs_lazy_test_type_populate_all(struct device *dev)
+{
+	/*
+	 * On readdir-driven populate_all, materialise inject_target
+	 * unconditionally when injection is disabled. On injection
+	 * the attribute remains absent so a subsequent lookup still
+	 * exercises the populate-one error path; this matches how a
+	 * real driver whose populate fails would surface as a missing
+	 * entry in readdir output.
+	 */
+	if (inject_errno < 0)
+		return;
+	/*
+	 * Best-effort populate_all: the walker contract discards
+	 * per-row return values on ADD_ALL, and any -EEXIST from a
+	 * concurrent populate_one is harmless here.  Capture the
+	 * return value so GCC's warn_unused_result is satisfied
+	 * (a (void) cast does not silence that attribute).
+	 */
+	if (sysfs_create_file(&dev->kobj, &dev_attr_inject_target.attr))
+		/* Tolerated: best-effort path; populate_one will retry. */
+		;
+}
+
+static const struct device_type sysfs_lazy_test_type = {
+	.name		= "sysfs_lazy_test_type",
+	.populate	= sysfs_lazy_test_type_populate,
+	.populate_all	= sysfs_lazy_test_type_populate_all,
+};
+
+/* --- platform driver ---------------------------------------------------- */
+
+static int lazy_test_probe(struct platform_device *pdev)
+{
+	/* sysfs_lazy is set before platform_device_add in init, NOT here */
+	return 0;
+}
+
+static void lazy_test_remove(struct platform_device *pdev)
+{
+}
+
+static struct platform_driver lazy_test_driver = {
+	.probe		= lazy_test_probe,
+	.remove		= lazy_test_remove,
+	.driver		= {
+		.name = MOD_NAME,
+	},
+};
+
+static struct platform_driver eager_test_driver = {
+	.probe		= lazy_test_probe,
+	.remove		= lazy_test_remove,
+	.driver		= {
+		.name = EAGER_NAME,
+	},
+};
+
+/* --- init / exit -------------------------------------------------------- */
+
+static int __init sysfs_lazy_test_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&lazy_test_driver);
+	if (ret)
+		return ret;
+
+	test_pdev = platform_device_alloc(MOD_NAME, PLATFORM_DEVID_NONE);
+	if (!test_pdev) {
+		ret = -ENOMEM;
+		goto err_drv;
+	}
+
+	test_pdev->dev.groups = lazy_test_groups;
+	/*
+	 * Set ->type before device_set_sysfs_lazy() so the type's
+	 * populate / populate_all hooks (sysfs_lazy_test_type) are
+	 * visible to the very first kernfs lookup that races the
+	 * platform_device_add() bring-up.
+	 */
+	test_pdev->dev.type = &sysfs_lazy_test_type;
+	ret = device_set_sysfs_lazy(&test_pdev->dev);  /* ONLY here */
+	if (ret)
+		goto err_pdev;
+
+	ret = platform_device_add(test_pdev);
+	if (ret)
+		goto err_pdev;
+
+	if (eager_twin) {
+		ret = platform_driver_register(&eager_test_driver);
+		if (ret)
+			goto err_lazy_dev;
+
+		eager_pdev = platform_device_alloc(EAGER_NAME,
+						   PLATFORM_DEVID_NONE);
+		if (!eager_pdev) {
+			ret = -ENOMEM;
+			goto err_eager_drv;
+		}
+
+		eager_pdev->dev.groups = lazy_test_groups;
+		/* sysfs_lazy defaults to NULL - eager device */
+
+		ret = platform_device_add(eager_pdev);
+		if (ret)
+			goto err_eager_pdev;
+	}
+
+	pr_info("loaded: /sys/devices/platform/%s (sysfs_lazy=%d)%s\n",
+		MOD_NAME, device_is_sysfs_lazy(&test_pdev->dev),
+		eager_twin ? " + eager twin" : "");
+	return 0;
+
+err_eager_pdev:
+	platform_device_put(eager_pdev);
+	eager_pdev = NULL;
+err_eager_drv:
+	platform_driver_unregister(&eager_test_driver);
+err_lazy_dev:
+	platform_device_unregister(test_pdev);
+	goto err_drv;
+err_pdev:
+	platform_device_put(test_pdev);
+err_drv:
+	platform_driver_unregister(&lazy_test_driver);
+	return ret;
+}
+
+static void __exit sysfs_lazy_test_exit(void)
+{
+	if (eager_pdev) {
+		platform_device_unregister(eager_pdev);
+		platform_driver_unregister(&eager_test_driver);
+	}
+	platform_device_unregister(test_pdev);
+	platform_driver_unregister(&lazy_test_driver);
+	pr_info("unloaded\n");
+}
+
+module_init(sysfs_lazy_test_init);
+module_exit(sysfs_lazy_test_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Test module for sysfs lazy initialization");
+MODULE_AUTHOR("Kernel selftest");
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


