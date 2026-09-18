Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FB0C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66926B008C; Fri, 18 Sep 2026 16:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0416B0093; Fri, 18 Sep 2026 16:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0026B0095; Fri, 18 Sep 2026 16:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85D656B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:39:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2120A07DE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:39:57 +0000 (UTC)
X-FDA: 85228049634.24.4314492
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 444C114000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:39:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OqRJtql4;
	spf=pass (imf26.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789763996;
	b=MepFmQgYzfoTjbQdO8fdqppWSU3h5UrsNZm1bBf/Y9NLpfAnHtElSB42dyfLOvCpMnVzjA
	NKyNA0YX4bVlfyuLK7XLq49k5GZIvQh84Vyv4hAQm7RxNAWyWEz/LZcObMWWuKZhTLnxQf
	dconQ7mWmPokRXOOsbdQS6HHz1EtjgA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OqRJtql4;
	spf=pass (imf26.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789763996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Q25J0u4Do4scrtd+2dKCqirjY+QQh+2yWmp3SOTbUjw=;
	b=aDUIGlYYyZyK+ZVfpJ3RN/vwYiWifI8xxVIbzO6RgSvxvR/APagrJ4qe5iKpEQAMtkCmEd
	U0vkoXcsOn7kPeE2TMrqRLTYptzDUQtPj0+0yfVp0jZkYJQz67PSVEzu72XR9up8ui774L
	p1vDgovfMO0A79khy89LMPlvVXtUR18=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d8facae850so26425ad.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789763995; x=1790368795; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q25J0u4Do4scrtd+2dKCqirjY+QQh+2yWmp3SOTbUjw=;
        b=OqRJtql4wcAVb6hwOYXzLlPVy5HLIfNKzXPFWyaY4GdIoKzMwQtFTLRVjxn0DwYNs4
         rskMdABYtqESns1rKLp62XvHWhdP7OecuJt4rHIGVJJ/E5Nhcv6t384+Owh5qUFaeTXc
         XPn2jYXSPtgIQHIvb1My/rLJ1ttlNFpctVEq3PtSSFpjB/gwTmCwMWE/Mm199OFtwXjk
         iGhaXdGaNaZlKiHJWcACKobcRC7KBIQLSr9DrhYMGbyuPrgQh1AvZmYn/7M3wJh75pIX
         hQNjqDXzUJg+70tlCO2ZIRXKwEFe893Wv/EjSEwdIkfNdzwGgZjBo8Xbor2kJLgQkIjr
         Ep0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789763995; x=1790368795;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Q25J0u4Do4scrtd+2dKCqirjY+QQh+2yWmp3SOTbUjw=;
        b=qhBKEYxmN6i25APHFX7R8CIFHmzvDwZrpHDvEKd84Gxuakw2M/A2yWaEGvPamoK1K0
         bHdMY+4nWRUs5WWS37Ou/kVjnKZZkgGCTbpTCeHdRzIcoplwNe9Rv7K4embJGExkYu/V
         kdTXCdPSpzT4u3psYseZEVXAOPwzuoXhhYYHDEekS5Qruu/Sb2P0QfSTa6rBcPu6cEIQ
         eYSEm6pEp/TTcTxv39tEyrA0HTFY60jfSZLVVo3TfRHOXa21VB0W6jECBqiOcbPrcVZw
         ublBaZjMPWdj9J70fXoTah7NH+ljzVPfVuFeZtX9cPLd5/+79g9manPQRLPVW1C/jPXy
         5lMg==
X-Forwarded-Encrypted: i=1; AKwUvBy63DDK7y4PCHXVpUAWLJstGEpY90nmGsK/0HxlCQeV3aG4GbXuv5hgzS3uSGcuuR8DfNLpvpAYUQ==@kvack.org
X-Gm-Message-State: AFuF++m9JBcIpAfOgRyk9qAh/ZZ1RGYCMJWJUn5EHP/35QdQti/6sRj6
	6CwBp33RbEuTdQMqqTs56XUnZTFdgM9GoSYu9DVZjPqp3lYcShsTbErj0jP4YfoHFA==
X-Gm-Gg: AYBFou3cF5yNuJvpODgqeiuoxUT8MSefjCAkEyZew1HrWZHxDHWEqy93LAbh7YakSSu
	Jk9RXgThbIrbP3vRYxi9BeJ8rJIHHNFOdcdC8dc2ueqWZ9ZJP9g0eRFRySeMCVaSfjrCibjohNg
	vZ0eJclofGaRZavKLGD6VJWv4GShaVhD3UAWeVmMb0F33bcaj3eAJmAT87R+sjTr3PB7aXP/BR1
	VuXiHQ1a6T9clBHjNlsiKQWSFKuMyfOz1YrkffxAl9pjjhtsUdS820X42P1RkfVuxV/oQOUZgIj
	P5oe0w1xSHQ+z359ELIWoyfr/kk+/1TZvaNefkrncLD5mi4WsyC0xffFSYuRetfQUN3H9YZAzkP
	qYgH9pkbwiKPWrHyd85WMRHO9oZ88rmHoPSYSmQ/SwltBlWS3AxzrRz3yzw7+Q/4F6o0FEacwMX
	+Fwn+ZNDd+P9z/2BTfJ5WaOa88H5l6L8UtMP/2XWIXzA1+lSdefVkHyG/jGtwsfIsKXkNz9hf6n
	lyqLmd1yFO7GLPeR02/akfCnJzTBxAFj30yQ9EMKnJucdioGpN0UmNHwDHqkxo3uwceXKcP+tCk
	ZbhXHzmsZMxG2ttusYA5BcHw2xoQ6899IAuy9P+QqWYLyiKXtZGMMdueYa0BkwL9phxhUSjNCIw
	V6L9j/Dk=
X-Received: by 2002:a17:903:26cc:b0:2ca:bf8e:360b with SMTP id d9443c01a7336-2dea2e93c73mr403255ad.9.1789763994508;
        Fri, 18 Sep 2026 13:39:54 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:9a8c:9370:b2fc:a09a] ([2a00:79e0:2eb4:9:9a8c:9370:b2fc:a09a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877a6be0d58sm260861b3a.7.2026.09.18.13.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 13:39:53 -0700 (PDT)
Date: Fri, 18 Sep 2026 13:39:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>
cc: Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [patch v4] mm: vmstat_kunit: add synthetic benchmark for vm stats
Message-ID: <cfc1edae-8aaa-8fd0-95de-af3d4774c6dd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 444C114000C
X-Stat-Signature: m66yztniwga3y7h5dp78w6psc791f16p
X-HE-Tag: 1789763996-789040
X-HE-Meta: U2FsdGVkX18Aewo5K8UNJ34r7IabivlUlFT/yFYAza/FYlQILjE2jQLC1o794SnGcHmfESflgjLUeQfM4UoiWRmWjun43w90G8z6PJZRN0a6pmSShc9eV2p+Obduq7ljngnhTi/zkeZ+/50StnRkECfTh+QgxRTXyxA+PbYTi0LVRc/JmjeYgin6snIHcAM/3tud6UGSCJ+TR/67Une/HYlBwocos2IjFROw8nsdM+HcIE3XfrqZx1SXdoZGmgF9UCt6dTCeqSNm3a8/M05iMPWsKQKiMPzZdRVqWm7ptvuQ/3Fc/kGARYyP0PwzuDM2qyIejuneaUYqXbQd0LjPCbL5x2g2ba/Z9ziFrwpMHBr7cFPn3w6NtEyErWz05EZQpaDgmnqds6wqCbCA+onCUdE4PQUEgreoI3JK2909HQ0CCq2amM0rZ77Spiutf5Xy+6eK+kO6SM5e2NLKAygLnWBGVCSMXOOJ4XALpZ0eEkD82fqohyn2wUrrsOpYXu5oQaPq0FF0mgvPB5dUzhPEvuTyN74EvO57IacQqCZDo8xLlu7P2Y0g7a6zfyfbJTF8Q6lSuq0XSa5pqvDMvuS7Bg2DI/taXN33DbIHbzRloJcS1qsBrihpZx3S2oU0MLuaYagkrfZ9YhCPjxdeFPtjXphUU8CrBXKYhqPuUdRKRKKjKEFkKU9HipT+FePSguRKGzriVEigyBDpmmc55/ua0aCzH1HwjYYSf153tepAFPVrJ2FdNr8H8NeOA1oURRmmPDZ377aj0ftSev5/vbdj6Hjic6zLjF4zv91qCHNcWG0P6U+j7ENHrSyW0yP9kwd57fWnUPrhAeslQ4WnBrNxDCOQ4SYPJxVxxh50uUmLs/W1RqT+FVLxkX8/41+d5ueIg7SDFqHfZv6afibiJBu5epAExKsuWEKYoUBk9XD6CBzoxlhEQOUZNdwy819c0RhVuM+CvkOzHdIMg6Cs3Cx
 hux+URqt
 NZ85BqFIUfbzQVXKKm3aXWC9l9C4/Zsp4XPZZg60PLWNTYc+iG8A6YrxekMo7AtvC3XPYTr8GzO5KYFCALVDsFzwiwTP1fU3kirfEm+SYGgIQPUwiSvlTqsOCfV0FMmLoRvAiyRk56k21zD43Un5Q0vaCSftVPS63MEE6YpuHyYRMXTf6S/c7thllwcVJ9ZABCcdThlXeWFUyVUY1rNrhq+EeoX38BzSeYoCoQWpYl9nFfVo/hgcvAetAiG8Iq9ii40SalM/otJy4wRZupcKYqb0FBdHlmjmR3+86KKUeqiMjq18jTScqo8gyNRMVRa4x8ciKv+xbnbmJoS331CQNAFPnZFTsgKlCerUjBm+Z83j4s0KMuYoMT5ZGgQ1A/esuZ0NAxi2FU5MtkGQcmcHL6blDFeQJqwy+XUqvme1Jg8LCE/ELQ43hiljmFaKEhQl2JUuA6FSw0SAcYYpuRNilU4S9eA==
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
v4:
 - included sample output in the commit description
 - switched to NR_MLOCK which is display only so no side effects
 - remove unnecessary "rem" variable

Once we're happy with this change, I'll apply the same treatment to the
proposed pgalloc and slab tests.

 MAINTAINERS             |   1 +
 mm/Kconfig              |  11 +++
 mm/Makefile             |   1 +
 mm/tests/vmstat_kunit.c | 157 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 170 insertions(+)
 create mode 100644 mm/tests/vmstat_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b2eb2a7a89a..de09076d91b9 100644
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

