Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEEB5C88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 01:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33AF6B0092; Fri, 11 Sep 2026 21:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE1F6B0093; Fri, 11 Sep 2026 21:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86AF6B0095; Fri, 11 Sep 2026 21:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 897806B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:08:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B5141A03DF
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:08:19 +0000 (UTC)
X-FDA: 85203324318.07.49CAAD1
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf30.hostedemail.com (Postfix) with ESMTP id D3A9880002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:08:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KQCHTF4U;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of rientjes@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789175297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=im53GbHEfLvUBZNrpRGu8UH4RSkvxvrAWZ/Fpm46ytA=;
	b=phB/vWwMGAJ+vYkx0lrWdo4dmrPail77cKS4zVzjOWlaXaJ5/nWVOxyKbgbY61B7RBNmoC
	71Djo3QhI2sRfoplbLoORvO+82x4DNGDsjgOS+ZYFsvcFuEWTQwlSpNwkvU/VHjY5Bmd0g
	7UwJeDVvC5RC5P2EHz/+qIplNKxnGSk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789175297;
	b=cHsU+KrAj0yTF6gENFVZ6fsbrRMakUIsM+uxnqNZj3sNE9aXaNkCijCoBlURKJczVswzDB
	CSVKKKk9H2hM1kant5fvbqAgemyReckTaEFr6s18P1eAusUnVvUZy81Fzi+w5+TtsJFJML
	iFYlqoS5+B7VNprM8e2VMonHYoJ9GLg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KQCHTF4U;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of rientjes@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd4b917769so14245ad.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789175297; x=1789780097; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=im53GbHEfLvUBZNrpRGu8UH4RSkvxvrAWZ/Fpm46ytA=;
        b=KQCHTF4UYbjgU1b+Q0a3IFfrpz8mdiQyTIOzdMnLU6bCTu/2etFk+/9b4uuPhWSbDk
         8fotK5cT9Lq5mJO5s1G61CHuahW5gDssxDdf/Z/6i4CcUammkKFJ58K/QkkcGIUoV0tz
         AnBTZ7LIu039ruZO7o3iobXP+356I24vsVootM5MlAi4E7HcG9P9eKTxKdcZKSrTWnXP
         JUJN/SXVTC2J9YkIrVzFzyeJq1veh5wvTdACLazl2ssouyzT0K3y1/+n+OfEwKMGKbRv
         ZluLkzcs5AYGtd3emlNQ1rqKisPoDgmkH1WuxYK3mF3SxOcdcpwn9CN1g5SDfqQqi/f5
         VqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789175297; x=1789780097;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=im53GbHEfLvUBZNrpRGu8UH4RSkvxvrAWZ/Fpm46ytA=;
        b=sxpuGjN7Q5A+aTYrtaLRze5+O2Ox9VmakI7gVd6ULhbIysRsm81F4R0piofXClFmys
         +La8j4xLklxv6h8sB7A8uBDdjGks+svGVwVYbi+9v/HORhc7fGLsvBsrYXSmztPrN/hj
         ZlEzvcMSyXIEAyQMeJtVNz0Vuhle+mDk1xwgd4wD6h90dFxXd6EbDrsPTmrgL3enLgxx
         g0TR673iQgWDDbuaAUpDzPy04837Ve+jiREoCAGKcCCDg84PInYFIJMgjV84k90mTiqV
         cmuPcXsqWwWGJg0gx8T52lEoG83zSY15J6aOgzJ68deYVbsoe1d8j2253jdsnP/o3PLx
         8HCg==
X-Forwarded-Encrypted: i=1; AKwUvBxsz66A6vAWpk4yI7ZJBCOtzdK0j6MAV85KyC4LL6BxNM9OGE8xIaj5r69Sqym/W51Czi1eqAyD7g==@kvack.org
X-Gm-Message-State: AFuF++n4mq1g8+Yw+sXkUOdNfZI8+UcFrfYjzPjVN1HM0A5BhbSunyb5
	19xVMrHLOBsJCnvlGl4jDmySotaWKv7zZc9hjF/MVW49BSeWyNlDXAn751ibJFV+yw==
X-Gm-Gg: AYBFou2T5f6AcVz6cdMPb36fFEqSZdQVctT0jgbXJvfr4cOYD9YutR8vdSCDd5A0bhZ
	x0WM2x3JCCDVDImJy7TMhG9C7oVD2Mkv4w286DxqPyxDBRm0SMsELsnx0L4nBE0ClkIGt9KGKjn
	RMBPjXCCL3Ff7fmSuYjQqg4vXjN92DZ1ggh7X4tzW9dvWwVMw/tnUosqLpXagLTQZ5dP5w/pK7b
	EGR44QVRuWjGEmp+A0tBRzKtEPz8/J71FPzPjEnX4auY6/UJPUDO09rr5A3cfmeQa/uOz/prtb3
	lpzmlBAK97tRgjtbdodJDz2uBleSBLGtQxT2bdFMXHixTFVnKg01YC5ifGUZ5NgEtAyUqx2BROY
	/8OdHHdc0o9k7fcqVRF7u+8SbEpg3Y+Jc9MpO9wxbVQxT7VVLn88HqzlQtnWQBCBJYYebukDV7j
	SsRlBDio2Ab1T7mb7vXWi27WHSsMXmEXsfmGKLK5sjK3nZbj1RJXQG5TzO5brJ6alMOND7DuFsO
	Y2/neLvGDd5TNAZeUIWgcg/TjSkpXaUsIFi4HsLmPM1pQq0VlxniKwsifSJgJdqUxsqhrbJQ5Uc
	Swwne6lHSciHQT/xJl1LAMBXwNDsAOqCjSmr70649ZmjYrsEwxtDArv79fSfYXFdp/Xj65Ltuim
	PF7kKxjfOC7DifCIciw==
X-Received: by 2002:a17:903:11c3:b0:2ce:b436:272a with SMTP id d9443c01a7336-2dd4b1042cfmr2077635ad.3.1789175295970;
        Fri, 11 Sep 2026 18:08:15 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:add7:30d3:d3cf:4f91] ([2a00:79e0:2eb4:9:add7:30d3:d3cf:4f91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cfcf48dsm18379755ad.57.2026.09.11.18.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 18:08:15 -0700 (PDT)
Date: Fri, 11 Sep 2026 18:08:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Christoph Lameter <cl@gentwo.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [patch v3] mm: test_vmstat: add synthetic benchmark for vm stats
Message-ID: <014ef68b-6312-bcdc-f432-34c31476fe77@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D3A9880002
X-Stat-Signature: ribtkkfbdwmabxr5f6pkntoi4pz1tz3g
X-HE-Tag: 1789175297-802148
X-HE-Meta: U2FsdGVkX1/SyeyRlBuGuN8rirWp5ytp4QNs0NEO8Z9wfLSFvcUFntV3cTq9V/LBtdXP+lIllFJJmmJBN7SY729tp2zS5JRhffkTSeIaqCV5JqxW6ukzeatpME5BaxHJFChbYJpOZovGNnCv2/UBi7/shjLREtKblK6/0gsOSswsxzY5o2gOMblzGdfntzGc9MLsJkKYUucMXchqyNLsq3mGHRD5i/6BsmKTVCtzQIdGghyCaEjeSPAFCZ4YLk8HMsqdPIR4q9emjM/LPPCDU9TOcy5CFS4bHG/syEBgGA6q4FXdgNkqE+clZso5oyrCFs6thxLnUMyHaX6WNbKWcm45jB6AHvt1DU9IYtjGoF5BPwxM+wDdv6Yu6eSsxB5WwSWFwWYypBmaoiII4xJZw6dkHPwSG4tS9cdb9U68jhiNtb1xjJmarmmaPr8IiG3JppaSFJgMJwkaUhXpwUczwDjrxWe40o6KwocK7STqKXXGkBQOM+B7k3vE3b4TwatpT8FX+F5rP9BXk5Ix3DkpgJbmrahytm77wzMMDBogAeHYXq7fz6gZE652u8xcaNCucrn0tu+SFe7V4uA/hk40WFlOKd6ejQFdC+15LSZtTPb2opPBxLNEYz++Eb5xGvgFmaoHbF6kqYKqdpThyg5zmZy+onZq5cCred231y2jak7AsC3rW091gSytTbO8roOGGtXWbZy9Ecj3aCzwEEPKd56llXnbXUIFpAZiTDSSAXqTUZig0Oj9+nbQr7O5xfXck4uMMXD/w/nZATNUglvyStxfParg8uTXbFV/iLgc0Kzm8IaQNTkjLt0DOHG5BHWOL8oEiVwDWCl0M2JgOP4Qj2Sjk30WTddDxF1ouCrmphqhhj8ADxR0fKgCDaIg7YeA4GwxNvcPCfFZ+nAtrnWnUCNYWalgXMEWgqKXLt7CFlyGLRpgeZ62YYebPk411uOmCkaBFtC6U5RrOhLtxOS
 lzNv1IQD
 MunBpEzqIWgsbnp+4fj5X8rZUv0pTPG0aCoXrFYi/XH2QUQNUfAzfyBd6cy/hWqQBhlFem6BuS2kZHot6UWvTpkSJK4aPFfOqgsr9KdnNGGr0PZjfU7DyLZ7irN0voZQzUo8W7ucdGG+6FceowK4EPHHvvvE/yKOw/TxDJstE/cWVjifalQzEpR6xrjrlZFRt9ngYlGDeOfb2cAp8fokRMCTePZPZu9gIs38swObUj8cPlUnX2iCMH2tK8pv2zcxk3q7ybhPbu0WShp7RxY1KU94BwnDCP587nv0cy31UyM0Sm4+WgR1o/CyJXsvZw1HIhLiRzxvk3WzbvLUkLM2xYTzjFszcWRzOB2uWExxSH+Z5aJlnGWIGG3hCujytmmuozF8no9R4IFuzuI3jAWSc7YY9ZR1HntMhicvjCzZTJ0ZeKnY5DgiOqtIHiGk5+kgohTetfGx0zRBExzaK4VnV/O7VrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Christoph Lameter <cl@gentwo.org>

Add a synthetic benchmark that can be used to measure performance of VM
statistics.  This is used to analyze any improvements or regressions in
functions that are frequently used in hot code paths.

The test is run by KUnit or doing modprobe vmstat_kunit directly.

Assisted-by: Gemini:gemini-3.8-flash
Signed-off-by: Christoph Lameter <cl@gentwo.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 v3:
  - switch to KUnit per David

 MAINTAINERS             |   1 +
 mm/Kconfig              |  11 +++
 mm/Makefile             |   1 +
 mm/tests/vmstat_kunit.c | 160 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 173 insertions(+)
 create mode 100644 mm/tests/vmstat_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index cc6a2d0e0d38..885c68a79490 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17161,6 +17161,7 @@ F:	mm/ptdump.c
 F:	mm/sparse-vmemmap.c
 F:	mm/sparse.c
 F:	mm/sparse.h
+F:	mm/tests/vmstat_kunit.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..2d021fb5ace6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1511,6 +1511,17 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config VMSTAT_KUNIT_TEST
+	tristate "KUnit test for VM statistics" if !KUNIT_ALL_TESTS
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
index 000000000000..5462e3d02800
--- /dev/null
+++ b/mm/tests/vmstat_kunit.c
@@ -0,0 +1,160 @@
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
+	int rem;
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, vmstat_test_free_page, page), 0);
+
+	/* Benchmark inc_zone_page_state() */
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++)
+		inc_zone_page_state(page, NR_FREE_CMA_PAGES);
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	time = time2 - time1;
+	inc_cycles = div_u64_rem(time, TEST_COUNT, &rem);
+	inc_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
+
+	/* Benchmark dec_zone_page_state() */
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++)
+		dec_zone_page_state(page, NR_FREE_CMA_PAGES);
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	time = time2 - time1;
+	dec_cycles = div_u64_rem(time, TEST_COUNT, &rem);
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
+	int rem;
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, vmstat_test_free_page, page), 0);
+
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++) {
+		inc_zone_page_state(page, NR_FREE_CMA_PAGES);
+		dec_zone_page_state(page, NR_FREE_CMA_PAGES);
+	}
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	time = time2 - time1;
+	avg_cycles = div_u64_rem(time, TEST_COUNT, &rem);
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
+	int rem;
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
+	avg_cycles = div_u64_rem(time, TEST_COUNT, &rem);
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

