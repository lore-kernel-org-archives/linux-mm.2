Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A332C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB1F6B013B; Thu,  2 Jul 2026 21:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B116B0139; Thu,  2 Jul 2026 21:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E37F36B0141; Thu,  2 Jul 2026 21:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F43A6B0139
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:00:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86E9F1C6ED7
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:54:46 +0000 (UTC)
X-FDA: 84944586972.25.BEBFFFA
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2AB0CC000A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:54:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=N+7MVlH5;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf28.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014884;
	b=f0E04nbUUDIPyVoyAfOWinfmBF6pJLzufN5/LXwubfPJYi+NQRPT2a2fsRA3ErTt+Sf083
	jetvDxy0PdvlohlvQS+3plZrZ/akJsbhv1uwgk17Fw2AU0X/C9Wqs21XCIiyZJ5poFZ9tz
	5VzZ4bpsk3zlDtnlkaieEy1xTKumUgw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAzy83SIWmBfg5huO6TZwNZomAyrpHHnzZR8JGT1F4Q=;
	b=M2/uHug3yG6TuG58ku+CXZKiQNrEp0867PfV6Q9YokqLd1nyAqSj/uXylgnybLy1lXlTHS
	WVSUNfX/cssvP4vchrA6coK5sM87XkNodqMG1nQzaYUMDryj7Lyzs+jhd3+Cq2VtU1Rm6c
	ZL8DhMGHvW45ZpAcQ3SbcEqtVYE/Zt8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=N+7MVlH5;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf28.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014884; x=1814550884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pAzy83SIWmBfg5huO6TZwNZomAyrpHHnzZR8JGT1F4Q=;
  b=N+7MVlH561Qogbu6LEzburwV6q3DmBsuQqVOUW/JLTd1s66Ww8QzXxzw
   uCmHoGWLBP0HPIFUAm+M65SGa3uK0tTSG29qkQGjXapO1npjeSx/UhiFz
   brCLSG9lA5nEmwbd/o9FLvR2bR8sNTQ6xgdfujPZsNJgaaamJIeGBRtAj
   OX1l/OY2523hO1c4EBsASBmMQJ1jt+Wws/FSJADZ5DjEEDluWf5GoTwHZ
   6b8/+3eHPf2TUud2AJW0dOwkK7BR6s2w+g31SvqGfOt8rmZzwgaVAqmXH
   YtQsAWtCzvLAq5478Yk2Y7nzldiSLmnhsFnW90HaQS+ezI4pt4GzD+55w
   A==;
X-CSE-ConnectionGUID: NM0UgZ4uQnqZ/9cxIL3iHQ==
X-CSE-MsgGUID: K8xKNFvNS2OlR4JQ0j4mGQ==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22928879"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:54:43 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:5140]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.244:2525] with esmtp (Farcaster)
 id d3f271ca-8197-4545-b309-d250c5924bf7; Thu, 2 Jul 2026 17:54:43 +0000 (UTC)
X-Farcaster-Flow-ID: d3f271ca-8197-4545-b309-d250c5924bf7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:54:42 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:54:39 +0000
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
Subject: [RFC PATCH 12/14] driver core: test: add KUnit tests for device_sysfs_apply
Date: Thu, 2 Jul 2026 19:51:12 +0200
Message-ID: <20260702175114.24659-8-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702175114.24659-1-sakacpav@amazon.de>
References: <20260702174033.32116-1-sakacpav@amazon.de>
 <20260702175114.24659-1-sakacpav@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D042UWB003.ant.amazon.com (10.13.139.135) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1xdk87m1fccmq9yjgs47oqtx3as6obhz
X-Rspamd-Queue-Id: 2AB0CC000A
X-HE-Tag: 1783014883-718582
X-HE-Meta: U2FsdGVkX1+sUVVP8UKrYqg29onyMQCKc/2TmZ6mTBCLjL2/nlXza90FRp/zQnFo8vlMwBO59F2nfOkdii7TbDGYDQg10mqEtSd88FtwRijvSXxgLLXPH0FC5XqUcxtqzrVG+2q3xEGqTNYqw2keFAB7M0QaEXKz3TWK91Zhk1lGaNku7TjUhYxchghFAjckipjIh9b+puDJ4QYORSENOwoLw4VNOo8neGHjrLSeugp6w9E9QpJ/TRYQKwXMYIuiuQvYMo/+vPBCXRgjIIGl4/yJS1JMEA7T4TNoA+M5p8oALiO6OUfOwhF4BryGJ+N5oGarSsBkqIPktIGSrQRvxNczsvTBpUvnwZ8OJRGcOWXEFezRuSp0B6V0p6eL/rLHC+LJJ8E/oJTH7l5yY9HVyKG55iTkp6RNv6OGi8OOefxd/Thzqet/ZQ9zLOy6/wKFqAD6W1z3R0KDa0asZwxgcacfLPRQySfT3qA/LyG07nUiDZ4m5pBdxmhEvv/X9E7hTxNtj+WwKKqsrO7TjzoB4vgYhVVzMW60mR7E0xv6iIdYX3m75ZF/B/flZGzO58bY85DYaeVe0oc3teq72NX+EYbsTQQYkn2duDfskej9BnfhN9JWNz4I8yQxVOPtE+jmLQ5p9JN1ZtOWy4vb3gyEYEE3vDAkRTyPTn6dFQA8UcTIf+B0VG7Wo0eQpfBOC5MdJOLRLhTtj/wfAN5rrYCNVJ0Au7WN5GGT9b4zeAsVxdo1bBTDWhR7uUq/3Jx+AKru1fixbmgVOrr53n9PDiWgEApCiIc6C4K4q1EhuEWC7Urvcxj0bAUMjxYCp8fJ9ax0DIlgHtVGzIUeOmaCbL4HJ0hUX22Bqkv+iMoSNWBKRafJgAGYuGWE+N39ZTyR2+SiOVMERKbGpNN3JXhNbIqdfQTB1bGP8OSfh9C102QyLlBWmhWGe4+5AdmcODTDH0MqhjfrjO4lRk4a/OzYkI/
 AOe+/91D
 thw6kU5m7RzKXMXSfwxQfQIwP1agTiWDYYJLriX3to2sYnUFMKQWeCuvqcalTur5JvxDcNpdVdnhS3v+WB8L5TAusAInbOLvWi0Ofxf+MbHDUP6+u7vPx6IFRD05eG3i965IgkyE4k0qo8PurCsjlEYh2J6q9Ktr2pq6IVH+vYklD82zfogaX/qgBJa3GVe3nAR9UNpq4q7s2Oly5EB34uij+2pBvTeQ+/Q9Dyn3p7KpoPBEoe/KMJ7whJMGOc0ct+NC/nmJa6OPGRBWKZ5Ags5Hzg0VbuRx9XiiQSdWLJ8wQrsNJ6GU1sPTcbdtZFHxRTk1ahJzgJt2mE3KdmridV8A6r5nu046xQ/Rz4pJ84ndhyF+WPV7p9WgUddgrwf8d9zYR90criX5We6agOcLg5/ivFqTgd6BeCjZWUgfUWtIprcYRVqUpyeamT4AJWz/QD/KE7Q0gl8U3jzX5R8tzFyglMb1KYHYqlxH2F1sBl+jVyMDRp0LhD0zEVuHW69graXsoxXGbnqmE68Di2QcM+HhjqB+7VYXm2kP35wUlxHwAA5Fa4FqWF/WV9U2xlcmVr/t65dQ+7ACBkKDewynkiNfxOKEvr5p61rJLANf3+eoTDNkJjAwKHZEJqat9IzZ9Ns7poibE3iQGxoKleBJDMGKp26UrVxPVdEh79ZwUjpGCx4sdWntJ5E8d+m11IWfbffUOk5xghX4v2hcfYrLi72FfJMUFNCMswhL8PP5gHchiDq4BRlnimbrd/SMQXSMBHslwvBLn5dtkENjXgENUvZDc2EMRYsgZTP1WWO44mR5s/bs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add KUnit tests that exercise device_sysfs_apply() - the declarative
per-device sysfs walker introduced earlier in this series - in
isolation from real sysfs I/O, plus dedicated tests for the
kernfs_set_lazy() input-validation contract.

Each walker test programs a small struct device_sysfs_entry table
whose applies_to / create / remove callbacks are file-static mocks
that record invocations in a shared state block and return
programmable values. Race and fault-injection tests use freshly
allocated lazy platform_devices and drive populate via the device's
ktype function pointers. The kernfs_set_lazy() rejection-branch
tests build standalone kernfs roots (no platform_device) so each
branch of the input-validation predicate is exercised in isolation.

Coverage:
  - dispatch correctness: ADD_ONE name match, wildcard row -ENOENT
    fallthrough, ADD_ALL best-effort, REMOVE_ALL reverse-order,
    applies_to() filter
  - lock + populated-latch: per-device serialisation, latch set
    once, lockless fast-path
  - fault injection: create() -ENOMEM propagation, sysfs_warn_dup()
    expected to NOT fire under the lock-then-exists-then-create
    protocol
  - eager/lazy equivalence: a device that fully populated lazily
    ends up with the same kernfs structure as an eager device
  - kernfs_set_lazy() input-validation: -EINVAL rejection on
    namespaced kn (kn->ns set), KERNFS_NS-flagged kn, and non-DIR
    kn (KERNFS_FILE), plus the happy path on a plain DIR kn that
    must return 0 and set KERNFS_LAZY.  Defense-in-depth: each
    rejection test also asserts KERNFS_LAZY remained unset on the
    rejected kn.

fs/sysfs/dir.c gains a CONFIG_DEVICE_SYSFS_APPLY_KUNIT_TEST-gated
atomic_t sysfs_warn_dup_kunit_count incremented inside
sysfs_warn_dup().  The race tests sample it before/after a
populate_one vs populate_all kthread storm and assert the delta
is zero - confirming that the lock-then-exists-then-create
protocol prevents duplicate-create WARNs in practice.  Production
builds (KUnit test off) carry no overhead.

End-to-end VFS -> kernfs -> sysfs -> ktype integration is covered
by the userspace selftest at tools/testing/selftests/sysfs-lazy/.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: kunit-dev@googlegroups.com
Cc: driver-core@lists.linux.dev
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 drivers/base/test/.kunitconfig              |    7 +
 drivers/base/test/Kconfig                   |   13 +
 drivers/base/test/Makefile                  |    2 +
 drivers/base/test/device_sysfs_apply_test.c | 1601 +++++++++++++++++++
 fs/sysfs/dir.c                              |   18 +
 5 files changed, 1641 insertions(+)
 create mode 100644 drivers/base/test/device_sysfs_apply_test.c

diff --git a/drivers/base/test/.kunitconfig b/drivers/base/test/.kunitconfig
index 473923f0998b6..662e404797f14 100644
--- a/drivers/base/test/.kunitconfig
+++ b/drivers/base/test/.kunitconfig
@@ -1,2 +1,9 @@
 CONFIG_KUNIT=y
 CONFIG_DM_KUNIT_TEST=y
+CONFIG_DEVICE_SYSFS_APPLY_KUNIT_TEST=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_DEBUG_ATOMIC_SLEEP=y
+CONFIG_DEBUG_MUTEXES=y
+CONFIG_DEBUG_SPINLOCK=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_LOCKDEP=y
diff --git a/drivers/base/test/Kconfig b/drivers/base/test/Kconfig
index 2756870615cca..43ef11f4100c4 100644
--- a/drivers/base/test/Kconfig
+++ b/drivers/base/test/Kconfig
@@ -18,3 +18,16 @@ config DRIVER_PE_KUNIT_TEST
 	tristate "KUnit Tests for property entry API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
+
+config DEVICE_SYSFS_APPLY_KUNIT_TEST
+	bool "KUnit tests for device_sysfs_apply()" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y
+	depends on SYSFS
+	default KUNIT_ALL_TESTS
+	help
+	  KUnit tests for the device_sysfs_apply() walker that
+	  backs declarative sysfs content via struct device_sysfs_entry.
+	  Covers walker semantics in isolation (empty table, applies_to
+	  gating, wildcard rows, two rows sharing a name, errno
+	  propagation, and reverse-order teardown). device_sysfs_apply()
+	  is not exported, so the test must be built in.
diff --git a/drivers/base/test/Makefile b/drivers/base/test/Makefile
index e321dfc7e9226..c061374f6c4f3 100644
--- a/drivers/base/test/Makefile
+++ b/drivers/base/test/Makefile
@@ -6,3 +6,5 @@ obj-$(CONFIG_DM_KUNIT_TEST)	+= platform-device-test.o
 
 obj-$(CONFIG_DRIVER_PE_KUNIT_TEST) += property-entry-test.o
 CFLAGS_property-entry-test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
+
+obj-$(CONFIG_DEVICE_SYSFS_APPLY_KUNIT_TEST) += device_sysfs_apply_test.o
diff --git a/drivers/base/test/device_sysfs_apply_test.c b/drivers/base/test/device_sysfs_apply_test.c
new file mode 100644
index 0000000000000..a62d383bd3182
--- /dev/null
+++ b/drivers/base/test/device_sysfs_apply_test.c
@@ -0,0 +1,1601 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for device_sysfs_apply().
+ *
+ * Exercises the table walker contract in isolation: empty table,
+ * named-row ADD_ONE match / miss, applies_to gating, wildcard rows
+ * (name == NULL), two rows sharing a name (disambiguated by
+ * applies_to), -EEXIST and -ENOMEM propagation, and REMOVE_ALL
+ * reverse-order teardown.  Three integration-style cases
+ * (walk_lazy_device_has_no_eager_children, walk_eager_lazy_equivalence,
+ * walk_wildcard_row_idempotent) drive the walker on real
+ * platform_device fixtures.  Two kthread-pair race cases
+ * (walk_populate_one_vs_all_race, walk_populate_vs_device_del_race)
+ * stress the lock + populated-latch double-check protocol
+ * and the dev->p->dead re-check that gates populate against
+ * concurrent device_del.  One fault-injection-friendly case
+ * (walk_create_power_enomem) exercises the -ENOMEM error path for
+ * create_power()'s power_added latch: it uses a
+ * structurally-equivalent path -- a lazy device whose
+ * create_power() never ran -- to assert the remove_power() gate
+ * skips dpm_sysfs_remove() without a sysfs_remove_group() WARN,
+ * which is the same observable state create_power() leaves behind
+ * on -ENOMEM.
+ *
+ * Each walker test programs a small, purpose-built struct
+ * device_sysfs_entry table whose create / remove / applies_to
+ * callbacks are file-static mocks that record invocations in a
+ * per-test state block and return programmable values. A real
+ * struct device is held by a platform device fixture so callback
+ * signatures match production usage; the walker itself never
+ * dereferences @dev, which keeps the tests focused on dispatch
+ * semantics rather than sysfs I/O.
+ *
+ * Full VFS -> kernfs -> sysfs -> ktype -> walker integration is
+ * covered by the userspace kselftest at
+ * tools/testing/selftests/sysfs-lazy/.
+ */
+
+#include <kunit/test.h>
+#include <kunit/resource.h>
+
+#include <linux/atomic.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/kernfs.h>
+#include <linux/kthread.h>
+#include <linux/panic.h>
+#include <linux/platform_device.h>
+#include <linux/rbtree.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/stat.h>
+#include <linux/string.h>
+
+/*
+ * Private driver-core header for the layout of struct sysfs_lazy_state.
+ * walk_create_power_enomem (Test 14) reads sysfs_lazy->power_added
+ * directly to assert the latch state that drives remove_power()'s
+ * dpm_sysfs_remove() gate. The struct's layout is intentionally
+ * file-private to drivers/base/; consumers outside this directory
+ * MUST use the device_is_sysfs_lazy() / device_sysfs_populated()
+ * accessors instead. This test sits inside drivers/base/test/ so it
+ * is part of the same build-locality scope as core.c and may peek
+ * at the struct.
+ */
+#include "../base.h"
+
+/*
+ * Counter exported from fs/sysfs/dir.c (under
+ * CONFIG_DEVICE_SYSFS_APPLY_KUNIT_TEST). Bumped on every
+ * sysfs_warn_dup() invocation. The race tests
+ * (walk_populate_one_vs_all_race / walk_populate_vs_device_del_race)
+ * sample this before and after the kthread storm and assert delta == 0:
+ * The lock protocol makes the lazy populate paths race-free under lock,
+ * so any "cannot create duplicate filename" emission during the test
+ * window is a lock invariant violation.
+ *
+ * sysfs_warn_dup() uses pr_warn()+dump_stack(), neither of which sets
+ * TAINT_WARN, so the existing warn-taint check cannot observe the
+ * dup-warn condition; this counter closes that gap.
+ */
+extern atomic_t sysfs_warn_dup_kunit_count;
+
+#define APPLY_KUNIT_DEV_NAME	"device_sysfs_apply_kunit"
+
+/*
+ * Mock state: up to 8 rows per test, each with its own counters and
+ * programmable return value. Reset between tests by the init hook.
+ */
+
+#define MOCK_ROWS	8
+#define MOCK_CALLS	64
+
+enum mock_op {
+	MOCK_CREATE,
+	MOCK_REMOVE,
+};
+
+struct mock_call {
+	enum mock_op op;
+	int idx;
+	const char *name_arg;
+};
+
+static struct {
+	struct mock_call calls[MOCK_CALLS];
+	int n_calls;
+	int create_ret[MOCK_ROWS];
+	bool applies[MOCK_ROWS];
+	int applies_hits[MOCK_ROWS];
+} mock;
+
+static void mock_reset(void)
+{
+	int i;
+
+	memset(&mock, 0, sizeof(mock));
+	for (i = 0; i < MOCK_ROWS; i++)
+		mock.applies[i] = true;
+}
+
+static void mock_record(enum mock_op op, int idx, const char *name_arg)
+{
+	if (mock.n_calls >= MOCK_CALLS)
+		return;
+	mock.calls[mock.n_calls].op = op;
+	mock.calls[mock.n_calls].idx = idx;
+	mock.calls[mock.n_calls].name_arg = name_arg;
+	mock.n_calls++;
+}
+
+#define DEFINE_ROW_MOCKS(I)						\
+static bool __maybe_unused mock_applies_##I(struct device *dev)		\
+{									\
+	mock.applies_hits[I]++;						\
+	return mock.applies[I];						\
+}									\
+static int __maybe_unused mock_create_##I(struct device *dev,		\
+					   const char *name)		\
+{									\
+	mock_record(MOCK_CREATE, I, name);				\
+	return mock.create_ret[I];					\
+}									\
+static void __maybe_unused mock_remove_##I(struct device *dev)		\
+{									\
+	mock_record(MOCK_REMOVE, I, NULL);				\
+}
+
+DEFINE_ROW_MOCKS(0)
+DEFINE_ROW_MOCKS(1)
+DEFINE_ROW_MOCKS(2)
+DEFINE_ROW_MOCKS(3)
+DEFINE_ROW_MOCKS(4)
+DEFINE_ROW_MOCKS(5)
+DEFINE_ROW_MOCKS(6)
+DEFINE_ROW_MOCKS(7)
+
+/*
+ * Fixture: one platform device that supplies a real struct device * to
+ * the walker. No attrs are attached; rows above drive all behaviour.
+ */
+
+struct walk_test_priv {
+	struct platform_device *pdev;
+};
+
+static int walk_test_init(struct kunit *test)
+{
+	struct walk_test_priv *priv;
+	struct platform_device *pdev;
+	int ret;
+
+	mock_reset();
+
+	priv = kunit_kzalloc(test, sizeof(*priv), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, priv);
+
+	pdev = platform_device_alloc(APPLY_KUNIT_DEV_NAME,
+				     PLATFORM_DEVID_NONE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pdev);
+
+	ret = platform_device_add(pdev);
+	if (ret) {
+		platform_device_put(pdev);
+		KUNIT_FAIL(test, "platform_device_add failed: %d", ret);
+		return ret;
+	}
+
+	priv->pdev = pdev;
+	test->priv = priv;
+	return 0;
+}
+
+static void walk_test_exit(struct kunit *test)
+{
+	struct walk_test_priv *priv = test->priv;
+
+	if (priv && priv->pdev)
+		platform_device_unregister(priv->pdev);
+}
+
+/*
+ * Shared kthread-pair harness for the race tests.
+ *
+ * Two kernel threads run user-supplied worker functions concurrently
+ * for a fixed wall-clock window. Each worker loops until
+ * kthread_should_stop() and increments its own iteration counter via
+ * atomic_inc(); the harness reports the counts so the test can assert
+ * both threads actually got CPU time. Cleanup is registered with
+ * kunit_add_action_or_reset() so kthread_stop() runs even if the test
+ * aborts via KUNIT_ASSERT_*.
+ *
+ * The same harness is reused by walk_populate_one_vs_all_race and
+ * walk_populate_vs_device_del_race; both worker pairs share the
+ * signature `int worker(void *priv)` so the harness need not know
+ * which population path is being exercised.
+ */
+
+struct walk_thread_pair {
+	struct task_struct	*t1;
+	struct task_struct	*t2;
+	atomic_t		iters1;
+	atomic_t		iters2;
+	atomic_t		bad_results;
+	void			*priv;
+};
+
+KUNIT_DEFINE_ACTION_WRAPPER(walk_kthread_cleanup, kthread_stop,
+			    struct task_struct *);
+
+static struct task_struct *walk_thread_start(struct kunit *test,
+					     int (*fn)(void *), void *priv,
+					     const char *name)
+{
+	struct task_struct *t;
+	int err;
+
+	t = kthread_run(fn, priv, "%s", name);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, t);
+
+	/*
+	 * Register cleanup BEFORE returning to the caller.  If the
+	 * caller's later KUNIT_ASSERT_* aborts the test, the action
+	 * fires and reaps the thread instead of leaking it.  When the
+	 * caller cleanly stops the thread itself it must
+	 * kunit_remove_action() to avoid a double kthread_stop() on a
+	 * freed task_struct.
+	 */
+	err = kunit_add_action_or_reset(test, walk_kthread_cleanup, t);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	return t;
+}
+
+static void walk_thread_pair_stop(struct kunit *test,
+				  struct walk_thread_pair *pair)
+{
+	if (pair->t1) {
+		kunit_remove_action(test, walk_kthread_cleanup, pair->t1);
+		kthread_stop(pair->t1);
+		pair->t1 = NULL;
+	}
+	if (pair->t2) {
+		kunit_remove_action(test, walk_kthread_cleanup, pair->t2);
+		kthread_stop(pair->t2);
+		pair->t2 = NULL;
+	}
+}
+
+/*
+ * Test 1: empty table
+ *
+ * NULL entries -> ADD_ONE returns -ENOENT, ADD_ALL and REMOVE_ALL
+ * succeed. Sentinel-only table behaves the same way.
+ */
+static void walk_empty_table(struct kunit *test)
+{
+	struct walk_test_priv *priv = test->priv;
+	struct device *dev = &priv->pdev->dev;
+	static const struct device_sysfs_entry sentinel_only[] = {
+		{ }
+	};
+
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, NULL,
+						DEV_SYSFS_ADD_ONE, "x"),
+			-ENOENT);
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, NULL,
+						DEV_SYSFS_ADD_ALL, NULL), 0);
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, NULL,
+						DEV_SYSFS_REMOVE_ALL, NULL),
+			0);
+
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, sentinel_only,
+						DEV_SYSFS_ADD_ONE, "x"),
+			-ENOENT);
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, sentinel_only,
+						DEV_SYSFS_ADD_ALL, NULL), 0);
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, sentinel_only,
+						DEV_SYSFS_REMOVE_ALL, NULL),
+			0);
+
+	KUNIT_EXPECT_EQ(test, mock.n_calls, 0);
+}
+
+/*
+ * Test 2: single named row
+ *
+ * ADD_ONE with a matching name invokes create(); a miss skips it and
+ * returns -ENOENT. ADD_ALL invokes create() once with name == NULL.
+ * REMOVE_ALL invokes remove once.
+ */
+static void walk_single_row(struct kunit *test)
+{
+	struct walk_test_priv *priv = test->priv;
+	struct device *dev = &priv->pdev->dev;
+	static const struct device_sysfs_entry tbl[] = {
+		{
+			.name = "alpha",
+			.applies_to = mock_applies_0,
+			.create = mock_create_0,
+			.remove = mock_remove_0,
+		},
+		{ }
+	};
+
+	/* ADD_ONE match */
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE, "alpha"),
+			0);
+	KUNIT_ASSERT_EQ(test, mock.n_calls, 1);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].op, MOCK_CREATE);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].idx, 0);
+	KUNIT_EXPECT_STREQ(test, mock.calls[0].name_arg, "alpha");
+
+	/* ADD_ONE miss */
+	mock_reset();
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE, "other"),
+			-ENOENT);
+	KUNIT_EXPECT_EQ(test, mock.n_calls, 0);
+
+	/* ADD_ALL */
+	mock_reset();
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ALL, NULL), 0);
+	KUNIT_ASSERT_EQ(test, mock.n_calls, 1);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].op, MOCK_CREATE);
+	KUNIT_EXPECT_PTR_EQ(test, mock.calls[0].name_arg, (const char *)NULL);
+
+	/* REMOVE_ALL */
+	mock_reset();
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_REMOVE_ALL, NULL),
+			0);
+	KUNIT_ASSERT_EQ(test, mock.n_calls, 1);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].op, MOCK_REMOVE);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].idx, 0);
+}
+
+/*
+ * Test 3: applies_to == false gate
+ *
+ * A row whose applies_to returns false is skipped on every action.
+ */
+static void walk_applies_to_false(struct kunit *test)
+{
+	struct walk_test_priv *priv = test->priv;
+	struct device *dev = &priv->pdev->dev;
+	static const struct device_sysfs_entry tbl[] = {
+		{
+			.name = "gated",
+			.applies_to = mock_applies_0,
+			.create = mock_create_0,
+			.remove = mock_remove_0,
+		},
+		{ }
+	};
+
+	mock.applies[0] = false;
+
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE, "gated"),
+			-ENOENT);
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ALL, NULL), 0);
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_REMOVE_ALL, NULL),
+			0);
+
+	KUNIT_EXPECT_EQ(test, mock.n_calls, 0);
+	KUNIT_EXPECT_GT(test, mock.applies_hits[0], 0);
+}
+
+/*
+ * Test 4: wildcard row
+ *
+ * A row with name == NULL dispatches to create() on every ADD_ONE
+ * regardless of the target name. The row signals "not my name" by
+ * returning -ENOENT; the walker must continue to the next row and
+ * terminate in the overall -ENOENT result.
+ */
+static void walk_wildcard_row(struct kunit *test)
+{
+	struct walk_test_priv *priv = test->priv;
+	struct device *dev = &priv->pdev->dev;
+	static const struct device_sysfs_entry tbl[] = {
+		{
+			.name = NULL,
+			.applies_to = mock_applies_0,
+			.create = mock_create_0,
+		},
+		{
+			.name = NULL,
+			.applies_to = mock_applies_1,
+			.create = mock_create_1,
+		},
+		{ }
+	};
+
+	/* Both wildcards signal "not mine"; walker returns -ENOENT. */
+	mock.create_ret[0] = -ENOENT;
+	mock.create_ret[1] = -ENOENT;
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE, "any"),
+			-ENOENT);
+	KUNIT_ASSERT_EQ(test, mock.n_calls, 2);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].idx, 0);
+	KUNIT_EXPECT_EQ(test, mock.calls[1].idx, 1);
+
+	/* Second wildcard claims the name; walker stops there. */
+	mock_reset();
+	mock.create_ret[0] = -ENOENT;
+	mock.create_ret[1] = 0;
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE, "any"),
+			0);
+	KUNIT_EXPECT_EQ(test, mock.n_calls, 2);
+	KUNIT_EXPECT_EQ(test, mock.calls[1].idx, 1);
+}
+
+/*
+ * Test 5: two rows share a name, disambiguated by applies_to
+ *
+ * Two rows may carry the same .name as
+ * long as their applies_to predicates are mutually exclusive. On
+ * ADD_ONE the first match wins; in this table the second row is gated
+ * off so only the first row fires.
+ */
+static void walk_two_rows_same_name(struct kunit *test)
+{
+	struct walk_test_priv *priv = test->priv;
+	struct device *dev = &priv->pdev->dev;
+	static const struct device_sysfs_entry tbl[] = {
+		{
+			.name = "subsystem",
+			.applies_to = mock_applies_0,
+			.create = mock_create_0,
+		},
+		{
+			.name = "subsystem",
+			.applies_to = mock_applies_1,
+			.create = mock_create_1,
+		},
+		{ }
+	};
+
+	/* Row 0 off, row 1 on -> only row 1 fires. */
+	mock.applies[0] = false;
+	mock.applies[1] = true;
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE,
+						"subsystem"), 0);
+	KUNIT_ASSERT_EQ(test, mock.n_calls, 1);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].idx, 1);
+
+	/* Row 0 on, row 1 on (ambiguous) -> first match wins. */
+	mock_reset();
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE,
+						"subsystem"), 0);
+	KUNIT_ASSERT_EQ(test, mock.n_calls, 1);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].idx, 0);
+}
+
+/*
+ * Test 6: -EEXIST propagation on ADD_ONE
+ *
+ * The walker forwards create()'s return value for any ADD_ONE result
+ * other than -ENOENT (which means "not my row" for wildcard rows and
+ * "no match at all" for the overall walk). -EEXIST absorption is a
+ * row-level contract: create() converts -EEXIST from a racing
+ * populate_one to 0 before returning. This test documents the walker
+ * side -- a row that surfaces -EEXIST propagates it, giving reviewers
+ * a clear signal of a row-contract violation.
+ */
+static void walk_eexist_propagates(struct kunit *test)
+{
+	struct walk_test_priv *priv = test->priv;
+	struct device *dev = &priv->pdev->dev;
+	static const struct device_sysfs_entry tbl[] = {
+		{
+			.name = "dup",
+			.applies_to = mock_applies_0,
+			.create = mock_create_0,
+		},
+		{ }
+	};
+
+	/* Row absorbed internally and returned 0 -> walker returns 0. */
+	mock.create_ret[0] = 0;
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE, "dup"),
+			0);
+
+	/* Row leaked -EEXIST -> walker forwards it (contract violation). */
+	mock_reset();
+	mock.create_ret[0] = -EEXIST;
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE, "dup"),
+			-EEXIST);
+}
+
+/*
+ * Test 7: -ENOMEM propagation
+ *
+ * Transient allocation failures must propagate unchanged to the caller
+ * so kernfs does not negatively cache the dentry.
+ */
+static void walk_enomem_propagates(struct kunit *test)
+{
+	struct walk_test_priv *priv = test->priv;
+	struct device *dev = &priv->pdev->dev;
+	static const struct device_sysfs_entry tbl[] = {
+		{
+			.name = "oom",
+			.applies_to = mock_applies_0,
+			.create = mock_create_0,
+		},
+		{ }
+	};
+
+	mock.create_ret[0] = -ENOMEM;
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE, "oom"),
+			-ENOMEM);
+	KUNIT_EXPECT_EQ(test, mock.n_calls, 1);
+}
+
+/*
+ * Test 8: REMOVE_ALL reverse order + ADD_ALL forward order
+ *
+ * ADD_ALL invokes every applicable create() in table order;
+ * REMOVE_ALL invokes every applicable remove() in reverse table order
+ * A gated-off middle row is skipped in both directions.
+ */
+static void walk_reverse_teardown(struct kunit *test)
+{
+	struct walk_test_priv *priv = test->priv;
+	struct device *dev = &priv->pdev->dev;
+	static const struct device_sysfs_entry tbl[] = {
+		{
+			.name = "r0",
+			.applies_to = mock_applies_0,
+			.create = mock_create_0,
+			.remove = mock_remove_0,
+		},
+		{
+			.name = "r1",
+			.applies_to = mock_applies_1,
+			.create = mock_create_1,
+			.remove = mock_remove_1,
+		},
+		{
+			.name = "r2",
+			.applies_to = mock_applies_2,
+			.create = mock_create_2,
+			.remove = mock_remove_2,
+		},
+		{ }
+	};
+
+	/* Gate row 1 off; rows 0 and 2 remain active. */
+	mock.applies[1] = false;
+
+	/* ADD_ALL: forward order, rows 0 then 2. */
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ALL, NULL), 0);
+	KUNIT_ASSERT_EQ(test, mock.n_calls, 2);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].op, MOCK_CREATE);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].idx, 0);
+	KUNIT_EXPECT_EQ(test, mock.calls[1].op, MOCK_CREATE);
+	KUNIT_EXPECT_EQ(test, mock.calls[1].idx, 2);
+
+	/* REMOVE_ALL: reverse order, rows 2 then 0. */
+	mock_reset();
+	mock.applies[1] = false;
+	KUNIT_EXPECT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_REMOVE_ALL, NULL),
+			0);
+	KUNIT_ASSERT_EQ(test, mock.n_calls, 2);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].op, MOCK_REMOVE);
+	KUNIT_EXPECT_EQ(test, mock.calls[0].idx, 2);
+	KUNIT_EXPECT_EQ(test, mock.calls[1].op, MOCK_REMOVE);
+	KUNIT_EXPECT_EQ(test, mock.calls[1].idx, 0);
+}
+
+/*
+ * Test 9: sysfs_lazy eager-leak regression guard
+ *
+ * Regression guard for the dpm_sysfs_add eager-leak: a
+ * sysfs_lazy device must have zero direct kernfs children at the
+ * device_add() return boundary.  Any sysfs_create_file,
+ * sysfs_create_group, or sysfs_create_link reached unconditionally
+ * from the device_add() path would materialize a child of
+ * dev->kobj.sd here and fail this test.
+ *
+ * This test uses its own freshly-allocated platform_device (not the
+ * fixture's pdev) so sysfs_lazy can be set BEFORE platform_device_add()
+ * -- the flag must be committed before device_add() per the
+ * Documentation/ABI/testing/sysfs-lazy contract.
+ *
+ * Phase 1: zero children immediately after device_add().
+ * Phase 2: children appear after device_sysfs_apply(ADD_ALL) -- proves
+ * the populate-triggered path still works.
+ */
+static void walk_lazy_device_has_no_eager_children(struct kunit *test)
+{
+	struct platform_device *lazy_pdev;
+	struct kernfs_node *sd, *kn;
+	struct rb_node *rb;
+	struct device *dev;
+	int child_count = 0;
+	int ret;
+
+	lazy_pdev = platform_device_alloc(APPLY_KUNIT_DEV_NAME "_lazy",
+					  PLATFORM_DEVID_NONE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, lazy_pdev);
+
+	/* MUST be set before device_add(); the alloc gates kernfs_set_lazy(). */
+	ret = device_set_sysfs_lazy(&lazy_pdev->dev);
+	if (ret) {
+		platform_device_put(lazy_pdev);
+		KUNIT_FAIL(test, "device_set_sysfs_lazy failed: %d", ret);
+		return;
+	}
+
+	ret = platform_device_add(lazy_pdev);
+	if (ret) {
+		platform_device_put(lazy_pdev);
+		KUNIT_FAIL(test, "platform_device_add failed: %d", ret);
+		return;
+	}
+
+	dev = &lazy_pdev->dev;
+	sd = dev->kobj.sd;
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sd);
+
+	/*
+	 * Phase 1: walk dev->kobj.sd's rbtree of direct children.
+	 * Expected: 0.  kernfs children are stored in kn->dir.children,
+	 * a struct rb_root; iterate via rb_first/rb_next.  No
+	 * kernfs_for_each_child() helper exists upstream as of this
+	 * commit.
+	 */
+	for (rb = rb_first(&sd->dir.children); rb; rb = rb_next(rb)) {
+		char nbuf[64];
+
+		kn = rb_entry(rb, struct kernfs_node, rb);
+		child_count++;
+		/*
+		 * Snapshot the kernfs node name into a stack buffer
+		 * via kernfs_name(), which takes its own guard(rcu)
+		 * internally. Emitting kunit_info() (which can
+		 * GFP_KERNEL-allocate inside the log path) directly
+		 * from inside an rcu_read_lock() section would
+		 * violate Documentation/RCU/checklist.rst section 7 ("anything
+		 * that the idle task does ... and especially nothing
+		 * that does GFP_KERNEL allocations") and trip
+		 * PROVE_RCU CI.
+		 */
+		kernfs_name(kn, nbuf, sizeof(nbuf));
+		kunit_info(test, "unexpected eager child: %s\n", nbuf);
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, child_count, 0,
+		"sysfs_lazy device has %d eager children; expected 0. Something bypasses the walker (grep call chain for sysfs_create_file / sysfs_create_group / sysfs_create_link called unconditionally from device_add path).",
+		child_count);
+
+	/*
+	 * Named-node checks for two rows that must stay absent on a lazy
+	 * device before populate: power/ (created by dpm_sysfs_add) and
+	 * the device-side driver symlink (created by driver_sysfs_add).
+	 * kernfs_find_and_get() does NOT trigger populate -- it walks
+	 * the existing rb_tree only -- so it is safe to use here for
+	 * the before-populate assertion.
+	 */
+	kn = kernfs_find_and_get(sd, "power");
+	KUNIT_EXPECT_PTR_EQ_MSG(test, kn, (struct kernfs_node *)NULL,
+		"sysfs_lazy device has eager power/ directory; dpm_sysfs_add() is bypassing the !sysfs_lazy gate in device_add().");
+	if (kn)
+		kernfs_put(kn);
+
+	kn = kernfs_find_and_get(sd, "driver");
+	KUNIT_EXPECT_PTR_EQ_MSG(test, kn, (struct kernfs_node *)NULL,
+		"sysfs_lazy device has eager driver symlink; driver_sysfs_add() is bypassing the !sysfs_lazy gate.");
+	if (kn)
+		kernfs_put(kn);
+
+	/*
+	 * Phase 2: simulate a readdir-triggered populate by invoking
+	 * the walker directly with the device ktype's entries table.
+	 * For device_ktype this resolves to driver_core_sysfs_entries[]
+	 * (static inside core.c; reached here via the public
+	 * kobj_type.entries pointer).  Children must now appear,
+	 * proving the lazy populate path is functional and the
+	 * zero-child assertion above is not just a dead-code artefact.
+	 */
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev->kobj.ktype);
+	/*
+	 * Production callers (device_ktype_populate_all() in core.c)
+	 * hold dev->sysfs_lazy->lock across device_sysfs_apply()
+	 * so the create()/remove() callbacks see the contract documented by
+	 * their lockdep_assert_held(&...->lock). Tests calling
+	 * the walker directly must hold the same mutex; otherwise the
+	 * assert WARNs (one per create() row touched).
+	 */
+	mutex_lock(&dev->sysfs_lazy->lock);
+	ret = device_sysfs_apply(dev, dev->kobj.ktype->entries,
+				DEV_SYSFS_ADD_ALL, NULL);
+	mutex_unlock(&dev->sysfs_lazy->lock);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	child_count = 0;
+	for (rb = rb_first(&sd->dir.children); rb; rb = rb_next(rb))
+		child_count++;
+	KUNIT_EXPECT_GT_MSG(test, child_count, 0,
+		"device_sysfs_apply(ADD_ALL) on a lazy device created no children; the populate-triggered path is broken.");
+
+	/*
+	 * Spot-check a specific unconditional row (uevent) to catch a
+	 * mis-wired walker that created something but not the expected
+	 * rows.
+	 */
+	kn = kernfs_find_and_get(sd, "uevent");
+	KUNIT_EXPECT_PTR_NE_MSG(test, kn, (struct kernfs_node *)NULL,
+		"uevent attr missing after device_sysfs_apply(ADD_ALL); populate-triggered path created something else but not the expected driver_core_sysfs_entries[] rows.");
+	if (kn)
+		kernfs_put(kn);
+
+	/*
+	 * Teardown: device_del()'s built-in reverse REMOVE_ALL pass
+	 * (sole power-group teardown path per device_del() comment in
+	 * drivers/base/core.c) tears down everything Phase 2 added.
+	 * A manual REMOVE_ALL here would invoke remove_power() twice
+	 * on a lazy device whose power/ group was realised in Phase
+	 * 2: the second pass would WARN inside dpm_sysfs_remove()
+	 * because the remove_power() gate keys on the one-way
+	 * ->power_added latch (set in create_power(), never cleared
+	 * - see create_power()'s comment on lock
+	 * serialisation forbidding re-realise without device_del).
+	 */
+	platform_device_unregister(lazy_pdev);
+}
+
+/* Test 10: equivalence -- eager vs lazy produce the same kernfs children */
+
+static void walk_eager_lazy_equivalence(struct kunit *test)
+{
+	struct platform_device *eager_pdev, *lazy_pdev;
+	struct kernfs_node *eager_sd, *lazy_sd, *kn;
+	struct rb_node *rb;
+	int ret, mismatches = 0;
+
+	eager_pdev = platform_device_alloc(APPLY_KUNIT_DEV_NAME "_eager",
+					   PLATFORM_DEVID_NONE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, eager_pdev);
+
+	ret = platform_device_add(eager_pdev);
+	if (ret) {
+		platform_device_put(eager_pdev);
+		KUNIT_FAIL(test, "eager platform_device_add: %d", ret);
+		return;
+	}
+
+	lazy_pdev = platform_device_alloc(APPLY_KUNIT_DEV_NAME "_lazy2",
+					  PLATFORM_DEVID_NONE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, lazy_pdev);
+
+	ret = device_set_sysfs_lazy(&lazy_pdev->dev);
+	if (ret) {
+		platform_device_put(lazy_pdev);
+		platform_device_unregister(eager_pdev);
+		KUNIT_FAIL(test, "device_set_sysfs_lazy: %d", ret);
+		return;
+	}
+
+	ret = platform_device_add(lazy_pdev);
+	if (ret) {
+		platform_device_put(lazy_pdev);
+		platform_device_unregister(eager_pdev);
+		KUNIT_FAIL(test, "lazy platform_device_add: %d", ret);
+		return;
+	}
+
+	/* Trigger populate_all on lazy device */
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, lazy_pdev->dev.kobj.ktype);
+	/*
+	 * Production callers hold lock across
+	 * device_sysfs_apply() - see device_ktype_populate_all() in
+	 * core.c - so create()/remove() callbacks observe the lockdep contract
+	 * declared by their lockdep_assert_held(&...->lock).
+	 */
+	mutex_lock(&lazy_pdev->dev.sysfs_lazy->lock);
+	device_sysfs_apply(&lazy_pdev->dev,
+			  lazy_pdev->dev.kobj.ktype->entries,
+			  DEV_SYSFS_ADD_ALL, NULL);
+	mutex_unlock(&lazy_pdev->dev.sysfs_lazy->lock);
+
+	eager_sd = eager_pdev->dev.kobj.sd;
+	lazy_sd = lazy_pdev->dev.kobj.sd;
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, eager_sd);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, lazy_sd);
+
+	/* Every eager child must exist in lazy */
+	for (rb = rb_first(&eager_sd->dir.children); rb; rb = rb_next(rb)) {
+		struct kernfs_node *eager_kn =
+			rb_entry(rb, struct kernfs_node, rb);
+		char namebuf[64];
+
+		if (kernfs_name(eager_kn, namebuf, sizeof(namebuf)) <= 0)
+			continue;
+
+		kn = kernfs_find_and_get(lazy_sd, namebuf);
+		if (!kn) {
+			kunit_info(test, "eager '%s' missing from lazy",
+				   namebuf);
+			mismatches++;
+		} else {
+			if ((eager_kn->flags & KERNFS_TYPE_MASK) !=
+			    (kn->flags & KERNFS_TYPE_MASK)) {
+				kunit_info(test, "type mismatch '%s'",
+					   namebuf);
+				mismatches++;
+			}
+			kernfs_put(kn);
+		}
+	}
+
+	/* Reverse: lazy children not in eager */
+	for (rb = rb_first(&lazy_sd->dir.children); rb; rb = rb_next(rb)) {
+		struct kernfs_node *lazy_kn =
+			rb_entry(rb, struct kernfs_node, rb);
+		char namebuf[64];
+
+		if (kernfs_name(lazy_kn, namebuf, sizeof(namebuf)) <= 0)
+			continue;
+
+		kn = kernfs_find_and_get(eager_sd, namebuf);
+		if (!kn) {
+			kunit_info(test, "lazy '%s' not in eager",
+				   namebuf);
+			mismatches++;
+		} else {
+			kernfs_put(kn);
+		}
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, mismatches, 0,
+		"eager and lazy devices have different sysfs children after populate_all");
+
+	/*
+	 * No manual REMOVE_ALL: device_del() (via
+	 * platform_device_unregister) is the sole power-group
+	 * teardown path; manual REMOVE_ALL here would double-run
+	 * remove_power() and WARN. See test 9 teardown comment.
+	 */
+	platform_device_unregister(lazy_pdev);
+	platform_device_unregister(eager_pdev);
+}
+
+/*
+ * Test 11: wildcard-row idempotency under populate_one-then-populate_all
+ *
+ * Regression guard for the pci_create_resource_files() non-idempotency
+ * bug: a wildcard row whose
+ * create() materialises one slot on ADD_ONE("name") and all slots on
+ * ADD_ALL must leave the ADD_ONE-created slot intact when ADD_ALL fires
+ * afterwards.  kernfs's lookup-then-readdir order routes a stat("foo")
+ * through populate_one() before the subsequent readdir() reaches
+ * populate_all(); a non-idempotent ADD_ALL would tear down the
+ * already-created "foo" entry and make it user-visibly disappear.
+ *
+ * The mock simulates a row with two slots ("0" and "1").  create() with
+ * a non-NULL name parses the index and sets created[idx] = true.
+ * create() with NULL iterates both slots and sets the missing ones,
+ * mirroring pci_create_resource_files()'s post-fix shape.  A buggy
+ * create_all that re-creates already-set slots without skipping would
+ * be detected by leaving create_count incremented past the expected
+ * 2 - exactly the disappearance vector the production bug had.
+ */
+
+#define WILDCARD_SLOTS	2
+
+struct wildcard_state {
+	bool created[WILDCARD_SLOTS];
+	int create_count;	/* total successful realisations */
+};
+
+static struct wildcard_state wildcard_st;
+
+static int wildcard_create(struct device *dev, const char *name)
+{
+	int idx;
+
+	if (name) {
+		/* ADD_ONE: parse "0" or "1". */
+		if (kstrtoint(name, 10, &idx))
+			return -ENOENT;
+		if (idx < 0 || idx >= WILDCARD_SLOTS)
+			return -ENOENT;
+
+		if (wildcard_st.created[idx]) {
+			/*
+			 * Production rows like pci_create_attr() return
+			 * -EEXIST here; the row contract requires
+			 * absorption, but ADD_ONE will not revisit a slot
+			 * twice in a real run, so this branch is purely
+			 * defensive in the test.
+			 */
+			return 0;
+		}
+		wildcard_st.created[idx] = true;
+		wildcard_st.create_count++;
+		return 0;
+	}
+
+	/* ADD_ALL: walk both slots, skip already-created (idempotent). */
+	for (idx = 0; idx < WILDCARD_SLOTS; idx++) {
+		if (wildcard_st.created[idx])
+			continue;
+		wildcard_st.created[idx] = true;
+		wildcard_st.create_count++;
+	}
+	return 0;
+}
+
+static void wildcard_remove(struct device *dev)
+{
+	int idx;
+
+	for (idx = 0; idx < WILDCARD_SLOTS; idx++)
+		wildcard_st.created[idx] = false;
+}
+
+static void walk_wildcard_row_idempotent(struct kunit *test)
+{
+	struct walk_test_priv *priv = test->priv;
+	struct device *dev = &priv->pdev->dev;
+	static const struct device_sysfs_entry tbl[] = {
+		{
+			/* wildcard row: create() handles both modes */
+			.create = wildcard_create,
+			.remove = wildcard_remove,
+		},
+		{ }
+	};
+
+	memset(&wildcard_st, 0, sizeof(wildcard_st));
+
+	/* Step 1: populate_one("0") creates slot 0. */
+	KUNIT_ASSERT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ONE, "0"), 0);
+	KUNIT_EXPECT_TRUE(test, wildcard_st.created[0]);
+	KUNIT_EXPECT_FALSE(test, wildcard_st.created[1]);
+	KUNIT_EXPECT_EQ(test, wildcard_st.create_count, 1);
+
+	/* Step 2: populate_all walks both slots, must skip slot 0. */
+	KUNIT_ASSERT_EQ(test, device_sysfs_apply(dev, tbl,
+						DEV_SYSFS_ADD_ALL, NULL), 0);
+	KUNIT_EXPECT_TRUE_MSG(test, wildcard_st.created[0],
+		"slot 0 disappeared after populate_all - create_all is not idempotent (would correspond to pci_remove_resource_files() nuking already-created BAR slots after a populate_one + populate_all sequence).");
+	KUNIT_EXPECT_TRUE(test, wildcard_st.created[1]);
+	KUNIT_EXPECT_EQ_MSG(test, wildcard_st.create_count, 2,
+		"create_all re-created an already-populated slot; idempotency contract violated.");
+}
+
+/*
+ * Test 12: populate_one vs populate_all kthread race
+ *
+ * Stress the lock + populated-latch double-check protocol that
+ * serialises lazy population dispatched from kernfs's populate_one() /
+ * populate_all() hooks. Two kernel threads loop on the device's ktype
+ * function pointers concurrently for ~100 ms on a freshly-added lazy
+ * platform_device:
+ *
+ * T1: dev->kobj.ktype->populate(&dev->kobj, "uevent")
+ * T2: dev->kobj.ktype->populate_all(&dev->kobj)
+ *
+ * T1 reaches device_ktype_populate_one() and T2 reaches
+ * device_ktype_populate_all() in core.c. Both take
+ * dev->sysfs_lazy->lock and re-check the populated latch
+ * under the lock; the loser must short-circuit cleanly without
+ * re-walking entries the winner already realised. The lock protocol makes the
+ * lazy populate paths race-free: create callbacks check existence
+ * under the same lock that excludes other lazy creators, so
+ * sysfs_warn_dup() inside sysfs_add_file_mode_ns() must NOT fire at
+ * all (not even once, absorbed by create()'s -EEXIST handling).
+ *
+ * Asserts:
+ * - Zero new sysfs_warn_dup() invocations during the race window.
+ * This is the lock invariant: the lock fully excludes parallel
+ * creators, so no duplicate-create WARN can occur.
+ * - No new TAINT_WARN bit set during the race window (covers other
+ * WARN_ON paths -- e.g. a sysfs_remove_group() WARN -- since
+ * sysfs_warn_dup() itself is pr_warn-only and does not taint).
+ * - dev->sysfs_lazy->populated == true (latch committed).
+ * - "uevent" attribute present in the device's kernfs directory
+ * (the named row T1 was racing on actually materialised).
+ * - Both threads recorded > 0 iterations (proves both got CPU).
+ */
+
+struct race_state {
+	struct device		*dev;
+	struct walk_thread_pair	*pair;
+};
+
+static int populate_one_worker(void *data)
+{
+	struct race_state *st = data;
+	const struct kobj_type *ktype = st->dev->kobj.ktype;
+
+	while (!kthread_should_stop()) {
+		int ret = ktype->populate(&st->dev->kobj, "uevent");
+		/*
+		 * Allowed: 0 (created) or -ENOENT (already populated, or
+		 * dev->p->dead set by a concurrent device_del - covered
+		 * by walk_populate_vs_device_del_race rather than this
+		 * test, but the worker is shared so we tolerate both).
+		 */
+		if (ret != 0 && ret != -ENOENT)
+			atomic_inc(&st->pair->bad_results);
+		atomic_inc(&st->pair->iters1);
+		cond_resched();
+	}
+	return 0;
+}
+
+static int populate_all_worker(void *data)
+{
+	struct race_state *st = data;
+	const struct kobj_type *ktype = st->dev->kobj.ktype;
+
+	while (!kthread_should_stop()) {
+		ktype->populate_all(&st->dev->kobj);
+		atomic_inc(&st->pair->iters2);
+		cond_resched();
+	}
+	return 0;
+}
+
+static void walk_populate_one_vs_all_race(struct kunit *test)
+{
+	struct platform_device *lazy_pdev;
+	struct walk_thread_pair pair = {};
+	struct race_state st = { .pair = &pair };
+	struct kernfs_node *kn;
+	bool warn_taint_before;
+	int dup_warn_before;
+	int ret;
+
+	lazy_pdev = platform_device_alloc(APPLY_KUNIT_DEV_NAME "_race1",
+					  PLATFORM_DEVID_NONE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, lazy_pdev);
+
+	ret = device_set_sysfs_lazy(&lazy_pdev->dev);
+	if (ret) {
+		platform_device_put(lazy_pdev);
+		KUNIT_FAIL(test, "device_set_sysfs_lazy: %d", ret);
+		return;
+	}
+
+	ret = platform_device_add(lazy_pdev);
+	if (ret) {
+		platform_device_put(lazy_pdev);
+		KUNIT_FAIL(test, "platform_device_add: %d", ret);
+		return;
+	}
+
+	st.dev = &lazy_pdev->dev;
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, st.dev->kobj.ktype);
+	KUNIT_ASSERT_NOT_NULL(test, st.dev->kobj.ktype->populate);
+	KUNIT_ASSERT_NOT_NULL(test, st.dev->kobj.ktype->populate_all);
+
+	warn_taint_before = test_taint(TAINT_WARN);
+	dup_warn_before = atomic_read(&sysfs_warn_dup_kunit_count);
+
+	pair.t1 = walk_thread_start(test, populate_one_worker, &st,
+				    "walk_race1_one");
+	pair.t2 = walk_thread_start(test, populate_all_worker, &st,
+				    "walk_race1_all");
+
+	/* Run the race for ~100 ms. */
+	msleep(100);
+
+	walk_thread_pair_stop(test, &pair);
+
+	/*
+	 * Lock invariant: lazy populate paths under lock are
+	 * race-free. If this fires, sysfs_warn_dup() emitted at least one
+	 * "cannot create duplicate filename" warning in the race window,
+	 * meaning a create callback raced past its existence check and
+	 * collided with another lazy creator -- the lock
+	 * exclusivity contract is broken.
+	 */
+	KUNIT_EXPECT_EQ_MSG(test,
+		atomic_read(&sysfs_warn_dup_kunit_count), dup_warn_before,
+		"sysfs_warn_dup() fired during populate_one vs populate_all race; lock invariant violated.");
+
+	/* No WARN should have fired in the race window. */
+	KUNIT_EXPECT_FALSE_MSG(test,
+		!warn_taint_before && test_taint(TAINT_WARN),
+		"TAINT_WARN set during populate_one vs populate_all race; sysfs_warn_dup() likely fired (lock protocol violation).");
+
+	/* No worker observed an unexpected return value. */
+	KUNIT_EXPECT_EQ_MSG(test, atomic_read(&pair.bad_results), 0,
+		"populate_one returned an unexpected error during race");
+
+	/* populated latch must be set after at least one populate_all. */
+	KUNIT_EXPECT_TRUE_MSG(test, device_sysfs_populated(st.dev),
+		"populate_all completed but populated latch was not set");
+
+	/* "uevent" must exist in kernfs; populate_one was racing for it. */
+	kn = kernfs_find_and_get(st.dev->kobj.sd, "uevent");
+	KUNIT_EXPECT_PTR_NE_MSG(test, kn, (struct kernfs_node *)NULL,
+		"uevent attr missing after race; populate_one or populate_all failed to materialise it");
+	if (kn)
+		kernfs_put(kn);
+
+	/* Sanity: both threads got CPU time. */
+	KUNIT_EXPECT_GT(test, atomic_read(&pair.iters1), 0);
+	KUNIT_EXPECT_GT(test, atomic_read(&pair.iters2), 0);
+
+	platform_device_unregister(lazy_pdev);
+}
+
+/*
+ * Test 13: populate vs device_del kthread race
+ *
+ * Stress the lock wrap + dev->p->dead re-check that gates
+ * concurrent populate_one() against an in-flight device_del(). Worker A
+ * loops populate_one() on a lazy platform_device; Worker B sleeps
+ * briefly then calls platform_device_unregister(), which triggers
+ * device_del() and sets dev->p->dead under device_lock. Worker A holds
+ * an extra get_device() reference so its populate_one() callees can
+ * still safely dereference dev->sysfs_lazy after device_del() returns;
+ * dev->sysfs_lazy is freed by device_release(), which is gated on the
+ * refcount and therefore does not run until Worker A drops its ref.
+ *
+ * Asserts:
+ * - Zero new sysfs_warn_dup() invocations during the race window.
+ * The lock protocol makes the lazy populate paths race-free under
+ * lock; combined with the dev->p->dead re-check, even
+ * a populate_one() in flight when device_del() arrives must not
+ * emit a dup-warn (it either created cleanly before dead was set,
+ * or it observed dead and bailed without touching kernfs).
+ * - No new TAINT_WARN bit set (covers WARN_ON paths -- e.g. a
+ * sysfs_remove_group("power") WARN, or a use-after-free splat).
+ * - Every populate_one() observed AFTER the unregister returns
+ * -ENOENT (driven by the dev->p->dead re-check inside
+ * device_ktype_populate_one()).
+ * - Worker A made forward progress (iters > 0).
+ */
+
+struct dead_race_state {
+	struct device		*dev;
+	struct platform_device	*pdev;
+	struct walk_thread_pair	*pair;
+	bool			device_del_done;
+};
+
+static int populate_one_until_dead_worker(void *data)
+{
+	struct dead_race_state *st = data;
+	const struct kobj_type *ktype = st->dev->kobj.ktype;
+
+	while (!kthread_should_stop()) {
+		int ret = ktype->populate(&st->dev->kobj, "uevent");
+
+		/*
+		 * Permitted return values:
+		 *   0       - created (only legal before device_del)
+		 *   -ENOENT - already populated, OR dev->p->dead set
+		 * Any other return value is a protocol violation.
+		 */
+		if (ret != 0 && ret != -ENOENT)
+			atomic_inc(&st->pair->bad_results);
+
+		/*
+		 * After the unregister has been observed by Worker B,
+		 * dev->p->dead is true; populate_one MUST return
+		 * -ENOENT. A 0 here would mean the dead re-check failed
+		 * to fire (and we'd be racing with sysfs teardown).
+		 */
+		if (READ_ONCE(st->device_del_done) && ret == 0)
+			atomic_inc(&st->pair->bad_results);
+
+		atomic_inc(&st->pair->iters1);
+		cond_resched();
+	}
+	return 0;
+}
+
+static int unregister_worker(void *data)
+{
+	struct dead_race_state *st = data;
+
+	/* Let the populate worker rack up some iterations first. */
+	usleep_range(10 * USEC_PER_MSEC, 20 * USEC_PER_MSEC);
+	platform_device_unregister(st->pdev);
+	WRITE_ONCE(st->device_del_done, true);
+	atomic_inc(&st->pair->iters2);
+
+	while (!kthread_should_stop())
+		schedule_timeout_interruptible(HZ / 10);
+	return 0;
+}
+
+static void walk_populate_vs_device_del_race(struct kunit *test)
+{
+	struct platform_device *lazy_pdev;
+	struct walk_thread_pair pair = {};
+	struct dead_race_state st = { .pair = &pair };
+	bool warn_taint_before;
+	int dup_warn_before;
+	int ret;
+
+	lazy_pdev = platform_device_alloc(APPLY_KUNIT_DEV_NAME "_race2",
+					  PLATFORM_DEVID_NONE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, lazy_pdev);
+
+	ret = device_set_sysfs_lazy(&lazy_pdev->dev);
+	if (ret) {
+		platform_device_put(lazy_pdev);
+		KUNIT_FAIL(test, "device_set_sysfs_lazy: %d", ret);
+		return;
+	}
+
+	ret = platform_device_add(lazy_pdev);
+	if (ret) {
+		platform_device_put(lazy_pdev);
+		KUNIT_FAIL(test, "platform_device_add: %d", ret);
+		return;
+	}
+
+	st.pdev = lazy_pdev;
+	st.dev = &lazy_pdev->dev;
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, st.dev->kobj.ktype);
+	KUNIT_ASSERT_NOT_NULL(test, st.dev->kobj.ktype->populate);
+
+	/*
+	 * Hold an extra reference so the populate worker can keep
+	 * dereferencing dev->sysfs_lazy after platform_device_unregister
+	 * returns. device_release() (which kfree()'s sysfs_lazy) is
+	 * gated on the refcount and runs when this ref is dropped.
+	 */
+	get_device(st.dev);
+
+	warn_taint_before = test_taint(TAINT_WARN);
+	dup_warn_before = atomic_read(&sysfs_warn_dup_kunit_count);
+
+	pair.t1 = walk_thread_start(test, populate_one_until_dead_worker, &st,
+				    "walk_race2_pop");
+	pair.t2 = walk_thread_start(test, unregister_worker, &st,
+				    "walk_race2_del");
+
+	/* Run for ~100 ms; B finishes early, A keeps looping. */
+	msleep(100);
+
+	walk_thread_pair_stop(test, &pair);
+
+	/*
+	 * Drop the test's extra ref. device_release() now fires (frees
+	 * dev->sysfs_lazy and the platform_device); after this point
+	 * st.dev is invalid. KUnit assertions below must NOT touch it.
+	 */
+	put_device(st.dev);
+	st.dev = NULL;
+
+	/*
+	 * Lock invariant: lazy populate paths under lock are
+	 * race-free, including against concurrent device_del. If this
+	 * fires, sysfs_warn_dup() emitted at least one "cannot create
+	 * duplicate filename" warning -- meaning a populate_one() in
+	 * flight against device_del() either raced past the dev->p->dead
+	 * re-check or collided with another lazy creator. Both are
+	 * lock invariant violations.
+	 */
+	KUNIT_EXPECT_EQ_MSG(test,
+		atomic_read(&sysfs_warn_dup_kunit_count), dup_warn_before,
+		"sysfs_warn_dup() fired during populate vs device_del race; lock or dev->p->dead re-check invariant violated.");
+
+	KUNIT_EXPECT_FALSE_MSG(test,
+		!warn_taint_before && test_taint(TAINT_WARN),
+		"TAINT_WARN set during populate vs device_del race; check for sysfs_warn_dup, sysfs_remove_group WARN, or use-after-free splat in dmesg.");
+
+	KUNIT_EXPECT_EQ_MSG(test, atomic_read(&pair.bad_results), 0,
+		"populate_one returned an unexpected value during or after device_del; the dev->p->dead re-check is broken.");
+
+	KUNIT_EXPECT_TRUE_MSG(test, READ_ONCE(st.device_del_done),
+		"unregister worker did not complete platform_device_unregister within the race window");
+
+	KUNIT_EXPECT_GT(test, atomic_read(&pair.iters1), 0);
+	KUNIT_EXPECT_GT(test, atomic_read(&pair.iters2), 0);
+}
+
+/*
+ * Test 14: create_power() -ENOMEM teardown safety (gate equivalence)
+ *
+ * create_power() commits dev->sysfs_lazy->power_added = true ONLY on
+ * a successful dpm_sysfs_add(); on -ENOMEM the latch stays false.
+ * remove_power() consults the same latch on teardown:
+ *
+ * if (device_is_sysfs_lazy(dev) && !dev->sysfs_lazy->power_added)
+ * return;
+ * dpm_sysfs_remove(dev);
+ *
+ * When power_added is false, dpm_sysfs_remove() is skipped - without
+ * this gate, sysfs_remove_group("power") would WARN inside
+ * sysfs_remove_group() on a never-materialised group (and PM QoS
+ * constraints would never be torn down because dpm_sysfs_remove() is
+ * their sole release path).
+ *
+ * This test exercises the gate via a structurally-equivalent path: a
+ * lazy device whose populate path is never invoked. create_power()
+ * never runs, so power_added stays false - the same observable state
+ * a -ENOMEM from dpm_sysfs_add() would produce. device_del() then runs
+ * the walker in REMOVE_ALL direction; if remove_power() fails to skip
+ * dpm_sysfs_remove(), TAINT_WARN is set.
+ *
+ * A separate CONFIG_FAULT_INJECTION-gated test in a follow-up series
+ * can additionally inject -ENOMEM into dpm_sysfs_add() to cover the
+ * exact path described above; the gate logic itself is
+ * identical and is the load-bearing assertion here.
+ */
+static void walk_create_power_enomem(struct kunit *test)
+{
+	struct platform_device *lazy_pdev;
+	bool warn_taint_before;
+	int ret;
+
+	lazy_pdev = platform_device_alloc(APPLY_KUNIT_DEV_NAME "_powfail",
+					  PLATFORM_DEVID_NONE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, lazy_pdev);
+
+	ret = device_set_sysfs_lazy(&lazy_pdev->dev);
+	if (ret) {
+		platform_device_put(lazy_pdev);
+		KUNIT_FAIL(test, "device_set_sysfs_lazy: %d", ret);
+		return;
+	}
+
+	ret = platform_device_add(lazy_pdev);
+	if (ret) {
+		platform_device_put(lazy_pdev);
+		KUNIT_FAIL(test, "platform_device_add: %d", ret);
+		return;
+	}
+
+	/*
+	 * Pre-condition: lazy device, no populate_one or populate_all
+	 * has been invoked, so the walker has not run and
+	 * create_power() has not committed power_added. This is the
+	 * SAME observable state a -ENOMEM from dpm_sysfs_add() inside
+	 * create_power() would leave behind.
+	 */
+	KUNIT_ASSERT_TRUE(test, device_is_sysfs_lazy(&lazy_pdev->dev));
+	KUNIT_ASSERT_FALSE(test, lazy_pdev->dev.sysfs_lazy->power_added);
+
+	warn_taint_before = test_taint(TAINT_WARN);
+
+	/*
+	 * device_del() walks REMOVE_ALL; remove_power() must consult
+	 * the power_added latch and skip dpm_sysfs_remove(). If the
+	 * gate is broken, sysfs_remove_group("power") fires
+	 * sysfs_warn() because the group was never created, and
+	 * TAINT_WARN gets set.
+	 */
+	platform_device_unregister(lazy_pdev);
+
+	KUNIT_EXPECT_FALSE_MSG(test,
+		!warn_taint_before && test_taint(TAINT_WARN),
+		"TAINT_WARN set on device_del of lazy unpopulated device; remove_power() failed to skip dpm_sysfs_remove() when power_added==false (sysfs_remove_group(\"power\") WARN).");
+}
+
+/*
+ * kernfs_set_lazy() input-validation branch coverage.
+ *
+ * kernfs_set_lazy() rejects three classes of bad input by returning
+ * -EINVAL without modifying @kn:
+ * (1) namespaced kn   -- kn->ns != NULL
+ * (2) NS-enabled kn   -- kn->flags & KERNFS_NS
+ * (3) non-DIR kn      -- kernfs_type(kn) != KERNFS_DIR
+ *
+ * Each branch is exercised on a freshly created kernfs root (no shared
+ * state with the platform_device fixture in walk_test_init); successful
+ * rejection is confirmed by (a) the return value being -EINVAL and
+ * (b) KERNFS_LAZY remaining unset on the node.
+ *
+ * A fourth, positive case asserts that a plain DIR kn (no ns, no NS
+ * flag) is accepted: the call returns 0 and KERNFS_LAZY is set. This
+ * is the "happy path" gate; without it a refactor that turned the
+ * rejection check into an unconditional return would still pass the
+ * three negative tests.
+ */
+
+/*
+ * Non-NULL ns_common sentinel. kernfs_set_lazy() only tests @kn->ns for
+ * NULL-ness and never dereferences it, so a single byte of static storage
+ * whose address is reinterpreted as `const struct ns_common *` is a safe
+ * "namespace-tagged" marker without pulling in <linux/ns_common.h>
+ * (kernfs.h only forward-declares struct ns_common).
+ */
+static const u8 kernfs_set_lazy_dummy_ns_marker;
+#define KERNFS_SET_LAZY_DUMMY_NS \
+	((const struct ns_common *)&kernfs_set_lazy_dummy_ns_marker)
+
+/* Empty kernfs_ops for non-DIR file creation. */
+static const struct kernfs_ops kernfs_set_lazy_dummy_ops;
+
+static void walk_kernfs_set_lazy_rejects_namespaced_kn(struct kunit *test)
+{
+	struct kernfs_root *root;
+	struct kernfs_node *kn;
+	const struct ns_common *saved_ns;
+
+	root = kernfs_create_root(NULL, 0, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, root);
+
+	kn = kernfs_create_dir(kernfs_root_to_node(root), "ns_kn",
+			       S_IRUGO | S_IXUGO, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, kn);
+
+	/*
+	 * Stash a non-NULL ns tag on the node directly. kernfs_create_dir_ns()
+	 * would also accept @ns but only when the parent has KERNFS_NS set
+	 * (kernfs_add_one() WARNs otherwise); setting @kn->ns post-creation
+	 * exercises kernfs_set_lazy()'s namespaced-kn rejection in isolation
+	 * from any add-time validation.
+	 */
+	saved_ns = kn->ns;
+	kn->ns = KERNFS_SET_LAZY_DUMMY_NS;
+
+	KUNIT_EXPECT_EQ_MSG(test, kernfs_set_lazy(kn), -EINVAL,
+		"kernfs_set_lazy() did not return -EINVAL on a namespaced kn (kn->ns != NULL).");
+
+	/*
+	 * Defense in depth: KERNFS_LAZY must remain unset on a kn that
+	 * violated the precondition.  -EINVAL alone is necessary but not
+	 * sufficient; a refactor that returned -EINVAL after setting the
+	 * flag would still leave the kn in a half-armed state.
+	 */
+	KUNIT_EXPECT_FALSE_MSG(test,
+		kn->flags & KERNFS_LAZY,
+		"kernfs_set_lazy() set KERNFS_LAZY on a namespaced kn (kn->ns != NULL).");
+
+	/* Restore so kernfs_remove() / destroy_root see a clean state. */
+	kn->ns = saved_ns;
+
+	kernfs_destroy_root(root);
+}
+
+static void walk_kernfs_set_lazy_rejects_kernfs_ns_flag(struct kunit *test)
+{
+	struct kernfs_root *root;
+	struct kernfs_node *kn;
+
+	root = kernfs_create_root(NULL, 0, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, root);
+
+	kn = kernfs_create_dir(kernfs_root_to_node(root), "ns_flag_kn",
+			       S_IRUGO | S_IXUGO, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, kn);
+
+	/*
+	 * Set KERNFS_NS on this DIR via the public helper. kernfs_enable_ns()
+	 * has its own WARN_ON_ONCE for non-DIR / non-empty children; we are
+	 * a freshly created empty DIR so neither fires here.
+	 */
+	kernfs_enable_ns(kn);
+
+	KUNIT_EXPECT_EQ_MSG(test, kernfs_set_lazy(kn), -EINVAL,
+		"kernfs_set_lazy() did not return -EINVAL on a KERNFS_NS-flagged kn.");
+
+	/*
+	 * Defense in depth (see namespaced-kn test): -EINVAL alone is
+	 * necessary but not sufficient; a refactor that returned -EINVAL
+	 * after setting KERNFS_LAZY would still leave the kn half-armed.
+	 */
+	KUNIT_EXPECT_FALSE_MSG(test,
+		kn->flags & KERNFS_LAZY,
+		"kernfs_set_lazy() set KERNFS_LAZY on a KERNFS_NS-flagged kn.");
+
+	kernfs_destroy_root(root);
+}
+
+static void walk_kernfs_set_lazy_rejects_non_dir_kn(struct kunit *test)
+{
+	struct kernfs_root *root;
+	struct kernfs_node *file_kn;
+
+	root = kernfs_create_root(NULL, 0, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, root);
+
+	/*
+	 * Create a KERNFS_FILE node directly under the root. The empty
+	 * kernfs_ops is fine for this test -- we never open or read the
+	 * file, only call kernfs_set_lazy() on it.
+	 */
+	file_kn = __kernfs_create_file(kernfs_root_to_node(root), "file_kn",
+				       S_IRUGO, GLOBAL_ROOT_UID,
+				       GLOBAL_ROOT_GID, 0,
+				       &kernfs_set_lazy_dummy_ops, NULL,
+				       NULL, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, file_kn);
+	KUNIT_ASSERT_NE_MSG(test, kernfs_type(file_kn), KERNFS_DIR,
+			    "Test fixture sanity: file_kn must not be a DIR.");
+
+	KUNIT_EXPECT_EQ_MSG(test, kernfs_set_lazy(file_kn), -EINVAL,
+		"kernfs_set_lazy() did not return -EINVAL on a non-DIR (KERNFS_FILE) kn.");
+
+	/*
+	 * Defense in depth (see namespaced-kn test): -EINVAL alone is
+	 * necessary but not sufficient; a refactor that returned -EINVAL
+	 * after setting KERNFS_LAZY would still leave the kn half-armed.
+	 */
+	KUNIT_EXPECT_FALSE_MSG(test,
+		file_kn->flags & KERNFS_LAZY,
+		"kernfs_set_lazy() set KERNFS_LAZY on a non-DIR (KERNFS_FILE) kn.");
+
+	kernfs_destroy_root(root);
+}
+
+static void walk_kernfs_set_lazy_accepts_plain_dir(struct kunit *test)
+{
+	struct kernfs_root *root;
+	struct kernfs_node *kn;
+
+	root = kernfs_create_root(NULL, 0, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, root);
+
+	kn = kernfs_create_dir(kernfs_root_to_node(root), "plain_kn",
+			       S_IRUGO | S_IXUGO, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, kn);
+	KUNIT_ASSERT_PTR_EQ(test, kn->ns, NULL);
+	KUNIT_ASSERT_FALSE(test, kn->flags & KERNFS_NS);
+	KUNIT_ASSERT_EQ(test, kernfs_type(kn), (unsigned int)KERNFS_DIR);
+
+	KUNIT_EXPECT_EQ_MSG(test, kernfs_set_lazy(kn), 0,
+		"kernfs_set_lazy() returned non-zero on a plain DIR kn.");
+	KUNIT_EXPECT_TRUE_MSG(test,
+		kn->flags & KERNFS_LAZY,
+		"kernfs_set_lazy() did not set KERNFS_LAZY on a plain DIR kn.");
+
+	kernfs_destroy_root(root);
+}
+
+
+static struct kunit_case device_sysfs_apply_cases[] = {
+	KUNIT_CASE(walk_empty_table),
+	KUNIT_CASE(walk_single_row),
+	KUNIT_CASE(walk_applies_to_false),
+	KUNIT_CASE(walk_wildcard_row),
+	KUNIT_CASE(walk_two_rows_same_name),
+	KUNIT_CASE(walk_eexist_propagates),
+	KUNIT_CASE(walk_enomem_propagates),
+	KUNIT_CASE(walk_reverse_teardown),
+	KUNIT_CASE(walk_lazy_device_has_no_eager_children),
+	KUNIT_CASE(walk_eager_lazy_equivalence),
+	KUNIT_CASE(walk_wildcard_row_idempotent),
+	KUNIT_CASE_SLOW(walk_populate_one_vs_all_race),
+	KUNIT_CASE_SLOW(walk_populate_vs_device_del_race),
+	KUNIT_CASE(walk_create_power_enomem),
+	KUNIT_CASE(walk_kernfs_set_lazy_rejects_namespaced_kn),
+	KUNIT_CASE(walk_kernfs_set_lazy_rejects_kernfs_ns_flag),
+	KUNIT_CASE(walk_kernfs_set_lazy_rejects_non_dir_kn),
+	KUNIT_CASE(walk_kernfs_set_lazy_accepts_plain_dir),
+	{ }
+};
+
+static struct kunit_suite device_sysfs_apply_suite = {
+	.name = "device_sysfs_apply",
+	.init = walk_test_init,
+	.exit = walk_test_exit,
+	.test_cases = device_sysfs_apply_cases,
+};
+
+kunit_test_suite(device_sysfs_apply_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KUnit tests for device_sysfs_apply()");
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ae97ab7e41939..f1259995b075f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -11,6 +11,7 @@
 
 #define pr_fmt(fmt)	"sysfs: " fmt
 
+#include <linux/atomic.h>
 #include <linux/fs.h>
 #include <linux/kobject.h>
 #include <linux/slab.h>
@@ -18,10 +19,27 @@
 
 DEFINE_SPINLOCK(sysfs_symlink_target_lock);
 
+#if IS_ENABLED(CONFIG_DEVICE_SYSFS_APPLY_KUNIT_TEST)
+/*
+ * Built-in KUnit observability for the device_sysfs_apply race tests.
+ * The lazy populate paths under lock are designed to be
+ * race-free; this counter lets the in-tree race tests
+ * (walk_populate_one_vs_all_race / walk_populate_vs_device_del_race
+ * in drivers/base/test/device_sysfs_apply_test.c) sample the
+ * sysfs_warn_dup() invocation count before and after the kthread
+ * storm and assert the delta is zero. Gated on the KUnit test
+ * config so production builds carry no overhead.
+ */
+atomic_t sysfs_warn_dup_kunit_count;
+#endif
+
 void sysfs_warn_dup(struct kernfs_node *parent, const char *name)
 {
 	char *buf;
 
+#if IS_ENABLED(CONFIG_DEVICE_SYSFS_APPLY_KUNIT_TEST)
+	atomic_inc(&sysfs_warn_dup_kunit_count);
+#endif
 	buf = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (buf)
 		kernfs_path(parent, buf, PATH_MAX);
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


