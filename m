Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E96DCA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 22:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028FD6B008A; Fri,  9 Oct 2026 18:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14786B008C; Fri,  9 Oct 2026 18:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E026A6B0095; Fri,  9 Oct 2026 18:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B38ED6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:46:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3913480336
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:46:42 +0000 (UTC)
X-FDA: 85304573844.20.71DB016
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 84CD2C0003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:46:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fGjFZBkL;
	spf=pass (imf10.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791586000;
	b=LsPMh3/48iZTrPqD9eVdV+AjC23E4nZuSc9Rl30qTtiBKdvNAGqgAHD4u0hcByrrWEgYcc
	k+j/2Hy5ZD4LYfRm4PvxCqFWoHhw6Z4lZUXflfcL+tqjkDbA36tmBgge54x+mWxnhS+gws
	LzWVs1SsAG+M/ZJWvvkHJwaTo8rvwWs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fGjFZBkL;
	spf=pass (imf10.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791586000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z+EiZ+T8dkX6MNnL1h4wdxZ3B6URBkx58GDr4lvpDVM=;
	b=Mzf5aP/2ViIiWoOpluT+rW6PC9+x3hi+Vj72LAoSu/mYf3sA2y+XG4MFbTBE+iduAyseGp
	mOPuN63a8iS9W5+wzrO3FKyc0E/AvGj8m7HfXgeO+B8XNeR9KOZbwjISM1XE9g4hqwvC/M
	2u2dOsum6zsvXuXInDRMckeNGzboegA=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so5345ad.1
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 15:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791585999; x=1792190799; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z+EiZ+T8dkX6MNnL1h4wdxZ3B6URBkx58GDr4lvpDVM=;
        b=fGjFZBkL4ixDkTUXS6sPsmCGVe4i1T0Vce9QXdYNXNBFYWcWjnPNeHmLR/nHotcKWf
         x3A5A1iXAQirrltYc/VROi60I8aSe8Y/pnpqNKhlvajkjbL5Addc0QmHCtf8Nfhs2apX
         agFO3ldBxow9McjriAfYfpMZh/IAkisv+YCvQf7Z30GnRbnqMZmGf574wCWQnPzvx18Y
         edMo9GqxhJrjIu0K2I1YUHKiy/Dp6pBas/ZBwhZhxW32dCcsN2ZlnwUFov5pa+Zf/JJH
         joHT3dMucEZZsp/iZT2Lwy2nqBFM/NYoi7ZphVAFA84VUG71bZeDsCLXS143baYjmAkc
         LZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791585999; x=1792190799;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z+EiZ+T8dkX6MNnL1h4wdxZ3B6URBkx58GDr4lvpDVM=;
        b=o4d+mOYAJd4nM3w8/nRkjVG2n9bNO53eqN5yU1guwxIN/m9YWecM/pc/RpRCL7bFSK
         Y+n+imIkWy+Sr1BxUQzymvjV3eN7Rt+oqzbbM/5W03VmRHVrO1meN87MTdj4mcp1M4e3
         B+gnxpPFl0Qp79EBr+sDzXbmwoiivqafrEXmw5dMifewdxS3KADGf9hfMH2qIzzrFvM+
         MkuzDewHW1cpRxDuSc4McWQ28601kG+ky41nCbXu+/w8svMmYXjNebJDGFmhr+qitIll
         LLt0AiroqyVU6TT+S5jDGuqSFSVmeosCIrMSS6fQiPSCy6X9/+obeQfFpAyG09z2/L+t
         Lh3Q==
X-Forwarded-Encrypted: i=1; AKwUvBzvw5re8B4tIPWHt4Zm90X5Gv0XdbjVpVccnEqtiVOW0/Mj7DeSeVrXg4iMgwhUwjjB1aNM085hCw==@kvack.org
X-Gm-Message-State: AFq9FYIWrdgaIrb67GSi9w8YQTohxBLm3cjq2Q7slU0e8+32YferNVDp
	Jn3zwFtRSIjMGFQaCxLYBW23Y5Je8XvKR7ILlbG1GOM4VPKFMqfpzuzqz6F/R4F7Tg==
X-Gm-Gg: AYBFou0itzf5JqApCTiZw2PrYyBjfXg0/bgp4pO5YKoteaPpYC8XNHCgIuOW9+I0S2d
	eKaf0XxkmVApKV4xiPrr1DzYnXbZ9lB2NzVf5LALUq8OeoSx961mcHeGkilclFKXxzJs54g0f0u
	zChz3CpHqakIhzMN1dYQzG3JHcbbPK6pVfRmNZglQR4D5VwHhifbTeM/daAISYBurx3F8XNtVq+
	KSag+RAxK6vH3gHZEOPBqP+Dqw/Ok3+Zarmz6q0jxuAZJrvSdrDVbpt3FWSdgjBS8ZDWyuoPuLq
	NniyRnGtT+G7mcX1Enmnp3KcurJ/sQvLxp4cCrENpyiyKfF0QXc5+ti118NDUpuDT9tXemif/Qv
	4kI50KU6+PlIbqVqNeXPhzukoZFyHOroxmzY6pxGKLwUakItiHEjAFev+p+2U/KOB0xvOoM+rbR
	X9VX7wcvwCrDZp/tq4qzzqwRcFSgMSsL/TjmntovO5st4Mxdj6sdOQOQO+uWNOQsYVfO0slr/Wj
	w6UV1c5UYTydogKvfGvA5F+TYcBHE9ArKnu9Bgb+DVotoSJ47KlDcX90zrOwUP7jYn9RYHbbaAV
	bk0WfmEac3XRh0ejlHi6rHrYnx5KQPujd0KiwOweorO1SvbeqAhIqVJZxI8EMpJGRldZ3k9EHYf
	Zm8Hp1MU=
X-Received: by 2002:a17:903:1a2f:b0:2d5:c090:3810 with SMTP id d9443c01a7336-2e87b1611e7mr478225ad.2.1791585998636;
        Fri, 09 Oct 2026 15:46:38 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:7802:e7b9:d594:8bbc] ([2a00:79e0:2eb4:9:7802:e7b9:d594:8bbc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab55e41eefsm3674314a91.10.2026.10.09.15.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 15:46:38 -0700 (PDT)
Date: Fri, 9 Oct 2026 15:46:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>
cc: Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch v5] mm: vmstat_kunit: add synthetic benchmark for mm stats
Message-ID: <920ba123-077e-c42d-ebdf-a5effccf2073@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84CD2C0003
X-Rspam-User: 
X-Stat-Signature: q8zhyreb8qpdmzeh6atksp7fyrhk1rg3
X-HE-Tag: 1791586000-870788
X-HE-Meta: U2FsdGVkX194ZKQ/EMqeBXpxl5GUghM+NX5sjkonxzQYb6UCciipbTCvaR2HJIysx4hXPtiEmjDns2UAWOA8piIaVFIFXkSkQ/MYnvBOEwB7NPE4F/hLbtFnJ96IwRxo1hYMHUadJ2kh1+ly0YuIHlSc4ow/pOL6H+AsBr0eZSZgoKO0Prgd/4Kk47bk+QstVUAB5cCSOKgsTCtXqIqyl1Ml3qT3GqN1h81B7SDzteNt1geFyRbvlXlPwSbQ6nwC2fcgdGm2NfD/i/0G4vhayDXJB891meVa8qM5k3fMlSmsCKXkG/N1d/qhzL/CfZkGzxhxj9vikmoJ+A7CiAB75Xn5AEnWJ7SBpPekvBQQ4CD0MP9FVSaZ10iQGtxwtakBfC3uGZax1coTpOw+XOXOVXzuounV6xCygG9zLXJXFmRcalOzAirwnvrMxEGvx6r/CH2bQjr+nigB2bxZtFViZUg/QswGzjATPGf2dECYNGLeBaM4r4rcHHcCrvYm1eNnMH2BXzV5JvKmvXHscs+OV33xJa7BObd0jUc9Tjd1sjotIpI/R2zxU+AI6ZsEI8pkmJI5AyjTgiL8c2XjlCvdCp/cRck9fSiSeOTcykf9Amh1PzYh+2WK19RIxJkwkBaFQkq3Gu6h/PSOOaHP9f77DMAwK3GIjGGS4em91wnL+ii/2goUY3e6QGNXCoy/4Rohl7EQLzjOTOBH9oSokG87LCFT4mBa+HI4woQdmVNo6GcFysfMzQc4N6T71iqZfesmuGl9dXjSyjVVuIGmr3HT3DRzK7A3PStZSAIPiYH5d/4XoyRMzxDXqfMGfZOmj53FNYPZ4sxvA6Ng6ibUkxIQp6yAc7E+QrNWnO2VOvrzpLXfKT9iC1xbzj8MK3KC7uFjIcOgctk0RDCGyHtMGuu8YcqxC2si4ymrVvgquye6J/osGJIfSRA2QEDwNbCAcYH6aeyzBZ8Ah5/qHRRIjxQ
 FklckPs7
 TpHjq05U5EiRRH0WVlmqf3IjMSZGBq5mMmd5HD/UqGcPtxDMaBhWWL5ToPlQde0kZyBhIL2+chPsGIHND1guD8nFqQKTwVnFijZccIWEmMwSHEsBTHoo3CqVocsslK5VgGkaNht2eX8S8a2xtnKIfcFFCPxwcypoayTAGigjfedG2R7LFOj13VdsQeeXKEo6ifPRhWbAsNzL2H/GJhsjQX42GYF/UVgMJiWTGF9yMB/js6gtEKCfZiTOs8SGBJOh/dZH9jjqYlVUjXAQRD9pcNJh9ins/Zsio3PeIQEpyS7vEOmtz+c0NNfLRzHJKdrn7CjCZQhJ9L46yPsVj7t90D+PqI1/g4NdaAC7LuUvCmDJiYjU0OgyQbruwl4qem9OOtGHRUNpUNEYaWdqbEUr26CTxltavw1m4NwjiKHaVwgONPBC/CiEHg4YgyYwNY5WlqaU1imHUykLzf1MqkK4LoUf3VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Christoph Lameter <cl@gentwo.org>

Add a synthetic benchmark that can be used to measure performance of MM
statistics.  This is used to analyze any improvements or regressions in
functions that are frequently used in hot code paths.

This is the first of three tests that measure the execution times of
critical MM functions anticipated to be used by developers to measure the
impact of any core changes that would end up causing workload performance
issues.  Vmstats are embedded into MM hotpaths, so any regression can
cause performance and scalability impact for users.  Google has carried
these tests internally and kept them updated since Christoph posted them
back in 2009 for this purpose.

This can also be used to detect regressions over time, from kernel
version to kernel version, independent of development use cases.

The test is run by KUnit or doing modprobe vmstat_kunit directly.

Sample output:
 KTAP version 1
 1..1
 KTAP version 1
 # Subtest: vmstat
 # module: vmstat_kunit
      1..3
      # vmstat_test_inc_dec_zone_page_state: 10000 ops: inc_zone_page_state -> 8 cycles (4 ns/op), dec_zone_page_state -> 9 cycles (4 ns/op)
      ok 1 vmstat_test_inc_dec_zone_page_state
      # vmstat_test_interleaved_zone_page_state: 10000 ops: inc/dec pair -> 17 cycles (8 ns/op)
      ok 2 vmstat_test_interleaved_zone_page_state
      # vmstat_test_count_vm_event: 10000 ops: count_vm_event -> 4 cycles (2 ns/op)
      ok 3 vmstat_test_count_vm_event
 # vmstat: pass:3 fail:0 skip:0 total:3
 # Totals: pass:3 fail:0 skip:0 total:3
 ok 1 vmstat

Assisted-by: Gemini:gemini-3.8-flash
Signed-off-by: Christoph Lameter <cl@gentwo.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
v5:
 - added dependency on CONFIG_VM_EVENT_COUNTERS
 - expanded commit description

Once we're happy with this change, I'll apply the same treatment to the
proposed pgalloc and slab tests.

 MAINTAINERS             |   1 +
 mm/Kconfig              |  12 +++
 mm/Makefile             |   1 +
 mm/tests/vmstat_kunit.c | 157 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 171 insertions(+)
 create mode 100644 mm/tests/vmstat_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index f53047aa8d3c..ab65720521a5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17164,6 +17164,7 @@ F:	mm/ptdump.c
 F:	mm/sparse-vmemmap.c
 F:	mm/sparse.c
 F:	mm/sparse.h
+F:	mm/tests/vmstat_kunit.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..85817820f867 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1511,6 +1511,18 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config VMSTAT_KUNIT_TEST
+	tristate "KUnit test for VM statistics" if !KUNIT_ALL_TESTS
+	depends on VM_EVENT_COUNTERS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test and benchmark the performance of VM
+	  statistics updates (zone page state and VM event counters), which
+	  are used frequently in hot memory management code paths.
+
+	  If unsure, say N.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index e7245cb88c66..3d4f2c43b8d3 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,4 +147,5 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_VMSTAT_KUNIT_TEST) += tests/vmstat_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
diff --git a/mm/tests/vmstat_kunit.c b/mm/tests/vmstat_kunit.c
new file mode 100644
index 000000000000..899c957091d1
--- /dev/null
+++ b/mm/tests/vmstat_kunit.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit synthetic performance benchmark for VM statistics.
+ *
+ * (C) 2009 Linux Foundation, Christoph Lameter <cl@gentwo.org>
+ * (C) 2026 Google LLC, David Rientjes <rientjes@google.com>
+ */
+#include <kunit/test.h>
+#include <linux/mm.h>
+#include <linux/vmstat.h>
+#include <linux/timex.h>
+#include <linux/ktime.h>
+#include <linux/math64.h>
+
+#define TEST_COUNT 10000
+
+static void vmstat_test_free_page(void *arg)
+{
+	__free_page((struct page *)arg);
+}
+
+/*
+ * Test 1: Sequential inc_zone_page_state() followed by dec_zone_page_state().
+ * Net change to zone counters is 0.
+ */
+static void vmstat_test_inc_dec_zone_page_state(struct kunit *test)
+{
+	struct page *page;
+	cycles_t time1, time2, time;
+	u64 t1_ns, t2_ns;
+	u64 inc_cycles, dec_cycles;
+	u64 inc_ns, dec_ns;
+	unsigned int i;
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, vmstat_test_free_page, page), 0);
+
+	/* Benchmark inc_zone_page_state() */
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++)
+		inc_zone_page_state(page, NR_MLOCK);
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	time = time2 - time1;
+	inc_cycles = div_u64(time, TEST_COUNT);
+	inc_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
+
+	/* Benchmark dec_zone_page_state() */
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++)
+		dec_zone_page_state(page, NR_MLOCK);
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	time = time2 - time1;
+	dec_cycles = div_u64(time, TEST_COUNT);
+	dec_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
+
+	if (inc_cycles || dec_cycles)
+		kunit_info(test, "%u ops: inc_zone_page_state -> %llu cycles (%llu ns/op), dec_zone_page_state -> %llu cycles (%llu ns/op)\n",
+			   TEST_COUNT, inc_cycles, inc_ns, dec_cycles, dec_ns);
+	else
+		kunit_info(test, "%u ops: inc_zone_page_state -> %llu ns/op, dec_zone_page_state -> %llu ns/op\n",
+			   TEST_COUNT, inc_ns, dec_ns);
+}
+
+/*
+ * Test 2: Paired inc_zone_page_state() and dec_zone_page_state().
+ * Net change to zone counters is 0.
+ */
+static void vmstat_test_interleaved_zone_page_state(struct kunit *test)
+{
+	struct page *page;
+	cycles_t time1, time2, time;
+	u64 t1_ns, t2_ns;
+	u64 avg_cycles, avg_ns;
+	unsigned int i;
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, vmstat_test_free_page, page), 0);
+
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++) {
+		inc_zone_page_state(page, NR_MLOCK);
+		dec_zone_page_state(page, NR_MLOCK);
+	}
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	time = time2 - time1;
+	avg_cycles = div_u64(time, TEST_COUNT);
+	avg_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
+
+	if (avg_cycles)
+		kunit_info(test, "%u ops: inc/dec pair -> %llu cycles (%llu ns/op)\n",
+			   TEST_COUNT, avg_cycles, avg_ns);
+	else
+		kunit_info(test, "%u ops: inc/dec pair -> %llu ns/op\n",
+			   TEST_COUNT, avg_ns);
+}
+
+/*
+ * Test 3: count_vm_event() benchmark.
+ * Restores counter balance with count_vm_events(item, -TEST_COUNT).
+ */
+static void vmstat_test_count_vm_event(struct kunit *test)
+{
+	cycles_t time1, time2, time;
+	u64 t1_ns, t2_ns;
+	u64 avg_cycles, avg_ns;
+	unsigned int i;
+
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++)
+		count_vm_event(SLABS_SCANNED);
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	/* Restore balance */
+	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
+
+	time = time2 - time1;
+	avg_cycles = div_u64(time, TEST_COUNT);
+	avg_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
+
+	if (avg_cycles)
+		kunit_info(test, "%u ops: count_vm_event -> %llu cycles (%llu ns/op)\n",
+			   TEST_COUNT, avg_cycles, avg_ns);
+	else
+		kunit_info(test, "%u ops: count_vm_event -> %llu ns/op\n",
+			   TEST_COUNT, avg_ns);
+}
+
+static struct kunit_case vmstat_test_cases[] = {
+	KUNIT_CASE(vmstat_test_inc_dec_zone_page_state),
+	KUNIT_CASE(vmstat_test_interleaved_zone_page_state),
+	KUNIT_CASE(vmstat_test_count_vm_event),
+	{}
+};
+
+static struct kunit_suite vmstat_test_suite = {
+	.name = "vmstat",
+	.test_cases = vmstat_test_cases,
+};
+kunit_test_suite(vmstat_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Lameter <cl@gentwo.org>");
+MODULE_AUTHOR("David Rientjes <rientjes@google.com>");
+MODULE_DESCRIPTION("KUnit benchmark test for VM statistics");

