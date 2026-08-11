Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6965C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6332B6B007B; Tue, 11 Aug 2026 12:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A9A6B00A1; Tue, 11 Aug 2026 12:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA6A6B00A2; Tue, 11 Aug 2026 12:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D59E16B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:20:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF63D1C14DD
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:20:41 +0000 (UTC)
X-FDA: 85089501882.16.EE6F805
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1810E1A0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:20:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lDqdrDdO;
	spf=pass (imf19.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtZDYtapHGPfDE5SUp54DB2aVTRW+WWOIXswrMm3f4g=;
	b=x+Yk1QMk1+jiuw1GSxEe3RuWW6VvkwjlsNLOwxtZjBVcnoOzyKIGHWCNljdnv7UEw6+us0
	r6bdr5TPNHYCh02o4oIn8hndGms8EZ0mPvnp1Mi6weiL09WgRGVofLxGIPwLIHSOgrUl4M
	y8eY8htIBps38RpsojR8eFZ9wLeGWPk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lDqdrDdO;
	spf=pass (imf19.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465240;
	b=uMzEY153PBYiWyohzZtxW3sWQRFqKVqR9NuQMvLUZyQzzIDmDEn9wXMYYzpNvJ++9pw09G
	KYxbYd3nzzl6HA0BBereemiHXAFW0z0RJaz29krnnw7ljBo5ePDJp7AfIBpOhDC1HZY+G5
	PEJbS++0Z1BYz5NS1JPKuNAJCCZox7Q=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cedda2ce6fso992425ad.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786465239; x=1787070039; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xtZDYtapHGPfDE5SUp54DB2aVTRW+WWOIXswrMm3f4g=;
        b=lDqdrDdOpSL5tK2mWZeC/6Sv1VRyxqqLS/2mbITqcCkzjqBe2y7AxzDIcvowrFiwm2
         LqwRgB8pVq9cHXvA63L6ThMTDgRRcYJ9pOhxDrQwRAfUq4zIH948EIAJORccGqa/vrla
         vUAbrIKNqrsPLukMeVFBr23a5Ok4Mi9eFiIRb3G8NCdM+gwRwJ246S/WiOCEuRaW/A7H
         LSAXCzf9o0PlV1gO+ptriampv17vWh+7eNNDQ7l9wNVW8GnE2ICd41GBIRtM3QqfEuGU
         iMoWNTbkUCH+mRoG05oLiXFGnxiWTzARpTBG6t6I1hcABGvUwinZ2u6p5j6yEnqEy97G
         mpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786465239; x=1787070039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xtZDYtapHGPfDE5SUp54DB2aVTRW+WWOIXswrMm3f4g=;
        b=Ab4j6TH2YSPHPiJME3/8kMLltVxwsvKU0tXpIuzEPLGHODponQamI6vlcTAcY9yzuB
         aFoPhC2wj7+jRj54BMgzQXZVuRRsFvFjVlyq602IWQk2skMaDaX6grWSuunwMLWVzsul
         vhd5uokCwLlE6R0gt8etOCwsaafq1wMwQj6jLNiSvo69Pp72fYJaQdtx+HMW57FyjCDa
         sXXigQPSTtclcGXFSvnT0fwQcY2Cp+KXfprCv+ksK0pX7p1X+p9bdHls8rFyFFUUyoda
         3IvMaYhZ3OlrW6HH+/HEwk+0Nu6Ef8ug4ISJdsjPbjJ7LbtTtFfjHvh70Jr0XftOPD7/
         GtcQ==
X-Gm-Message-State: AOJu0Yzh1+sz0fgfvTk3HUPm/YlQG7YMvlNDPQ1Ai5ueBjNlKDPm4qsL
	oKLZDR3M23nefr3J93fAP+0LgGN175o/CScqZVt0M3Lz+ITj/PfGToyR
X-Gm-Gg: AR+sD10ObRq+QMD3Ln55gK7vM+JMFEZ8xk+or8Vs1SYsSBg3GIwh7h8LGoZ0mtGtubD
	hrxwPJqHdK+C+OkrbDPHB0TXxjP4VdUvH1okl3AdvSL9Eu3NJmS9oal5R/EMBzxC2WAcASRarKC
	bJ3mvnxJ+m2KB53kXIFdJ9hU4ZPnKKSjasQUyrmCYII4bQL+iMfVITvSs/hZWjN7YD1gmUdkJbN
	Wqn6cORvGTWElfuOCSqoh5HvlPvFk2Unplh9qbkS6Ur0tsrPPlW1ucPOg9xzO04lWXJhFVXvS7T
	XXLtJWez+L0QL0qFdfPmWmIyb+5vNEq45Be2lfLaVVXGxxVf6zcxj8IiLcmgnK+Q8+IFYsQV/Fl
	SydDvpXz9aRrH+dlzZIzUKMrXIZHKQgOhm+dq8KvCjHHYhDM9jRjAgC6tRf74qf73BSvbVyIBsQ
	oJruRUKZf1UTIszHJ37EMuS+azVbpIYMuKuZp9/lb31u/RcU91GQaUNY992kXnWPtAS8mvi5+bC
	I1Wm9ne+lE=
X-Received: by 2002:a17:903:947:b0:2ca:d151:383a with SMTP id d9443c01a7336-2d32c0cc361mr22791465ad.20.1786465238672;
        Tue, 11 Aug 2026 09:20:38 -0700 (PDT)
Received: from v4bel.. ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d315f30027sm10547465ad.25.2026.08.11.09.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 09:20:38 -0700 (PDT)
From: Hyunwoo Kim <imv4bel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	imv4bel@gmail.com
Subject: [PATCH v2 2/2] selftests/mm: add stale walk->action race test
Date: Wed, 12 Aug 2026 01:18:58 +0900
Message-ID: <20260811161949.3879321-3-imv4bel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811161949.3879321-1-imv4bel@gmail.com>
References: <20260811161949.3879321-1-imv4bel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1810E1A0007
X-Stat-Signature: crrxj884jerrjto86z9jiwaa9nk87hro
X-Rspam-User: 
X-HE-Tag: 1786465239-39594
X-HE-Meta: U2FsdGVkX1+2yEMwsERiopUECNWX30yhoxeutFhCuzwe3yzUBj3KpOp0PUdNm4bKmM5Lp2kqD9/YLyJTG0P8H1MRxSvxGyKDmcwseXHwBgmuVHJLN9xtR3TQ5n2D7bGuwslJS9QIMCxH3bMXRUdQLnzUSKrslhFz/t1CS48ZTFwl8hVTa8A6FwDCcr2jC+PAXpHnbjTt4mek1qlC/LntgB8riN90N7pzTnv5XinTuX9/pzB47cL0q0FXzLhRsWY8r/u4R30W8zddyKkz83mZDUqdm7Fnqv+BLNeuJu8eK0GrheetdgpCqm8Ew4QNn38NG6B6i7T7WwamdleIsQkozrBbXO0aQ2gxxgWRdlmeEOVM9aQij3dSdHR3MousXtVdPcrxl8+MHuF4/5r0dibV9DMgk4NwjPFAOvnhGFxW/45NzyHjO/PhIMuKQTDHviTLoJ+8+2PLhGSA1vT9bKWRNgP8TIN7Rap4KGBErRKqrhZ8EizaTJYqLme1MZJehIx5TZTUuEf25HW+CBSzK3aINW2mzmIyg/9dNA0qz5XJt5gmzoC9c+0jqBjJJw5Dg8ukeTKjLNLYEiyxxWQSdHNP0+cLlHCgcWPkcCfKRrXAB1XoKsM6UnTPwhUPdIW0RmE+VfSQGxqHuOYO6IdZHhOHo62TQ6MRcF4MT/Z4zHfE3tlV5wVcTzY8Iu/ZuBDoq2fgujKSj6be6JP6ZjkTWhXGPjl8EZsmBlGAhn3K9A+BqIW6nLgICypk3cSMM6n0uLObdLCG8SJY3drQG5KCuOUO5GOSoCcsu4j21o135+JIBOq9A7D3CtZzArN+Rf3tXFy16mlxBxNNEGfmvHXeyv6ffp2DefYEnoFKUFds6XReL8StlWZhuO4zvE7cGfHSpYwYptU2ell7hq6toSiIlO+VavoYpWVR0D9N8TIUFyYBAYwZSCqi4menWKMFGVYCnMGsTm35ujVf07sKg8r5Ten
 1KlYnBHO
 eo0me0bAj+CLC+FNYjuavanTkpbTxp49K/psjhauK0uCCfRz5b4QmocGeQxABNOEgJ9/YF+njeqrL0u8wOKk6i5yH+12myeEfqPPFkz2DRyvNIWRSLnJoB40r6L1btcfHaAdOMP8wmBeIAuqHpmXvUMYI++XwLu1Lv7d+woW6t1lVmFA75QHqoAlaxsDCpEyVnOVL6tp22Kx7X8W6pyDwK+IdTVWjRYxPLj0w2JLVH5IIehx051eSmLs2CtlTipXCXwp/9m9cI2DUbHoz6BxKWti+qe6DTmnsrpJoZ2hIiTJBwZ4Gp5k2CL+TOQnJ/hdWJuPmxstnqLPmhbiI+ScmXi1xT/4/GJFeaiVa0EQvCfsaxTEMZE3h41YacMaPiiMZtMJ44v4mtZAbfZ/tC02j0TDPNGLqgYQF5IX0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The added pagewalk_race_test maps two PMDs and faults in 2MB of the first
one.  A second thread then faults in the second PMD and drops it again with
MADV_DONTNEED in a loop, while the main thread reads Rss for the mapping
from /proc/self/smaps.

Clearing the second PMD while smaps_pte_range() runs leaves walk->action
erroneously set to ACTION_AGAIN, which causes the PUD walk to be retried,
so the first PMD is counted twice and Rss comes out twice as large as what
was faulted in.

mincore() is the caller named in the fix, but the second walk writes past
the length mincore() copies back, so it cannot be seen from userspace
there.  smaps reports what the callbacks counted, so the duplicate shows up
in Rss.

A failure can only come from the kernel counting the same page twice, so
missing the race is harmless.  On an unfixed kernel the test fails after a
few hundred reads at most and takes about half a second.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   2 +
 tools/testing/selftests/mm/ksft_pagewalk.sh   |   4 +
 .../testing/selftests/mm/pagewalk_race_test.c | 138 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/vm_util.h          |   1 +
 6 files changed, 148 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_pagewalk.sh
 create mode 100644 tools/testing/selftests/mm/pagewalk_race_test.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index 9ccd9e1447e66b..92f981f97740fd 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -66,3 +66,4 @@ merge
 prctl_thp_disable
 rmap
 folio_split_race_test
+pagewalk_race_test
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e6df968f0971c8..cde9b22f121d4b 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += pagewalk_race_test
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
@@ -163,6 +164,7 @@ TEST_PROGS += ksft_mlock.sh
 TEST_PROGS += ksft_mmap.sh
 TEST_PROGS += ksft_mremap.sh
 TEST_PROGS += ksft_pagemap.sh
+TEST_PROGS += ksft_pagewalk.sh
 TEST_PROGS += ksft_pfnmap.sh
 TEST_PROGS += ksft_pkey.sh
 TEST_PROGS += ksft_process_madv.sh
diff --git a/tools/testing/selftests/mm/ksft_pagewalk.sh b/tools/testing/selftests/mm/ksft_pagewalk.sh
new file mode 100755
index 00000000000000..6f6c3ee1c13ef4
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_pagewalk.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t pagewalk
diff --git a/tools/testing/selftests/mm/pagewalk_race_test.c b/tools/testing/selftests/mm/pagewalk_race_test.c
new file mode 100644
index 00000000000000..42fd6e75e821ed
--- /dev/null
+++ b/tools/testing/selftests/mm/pagewalk_race_test.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Regression test for a stale walk->action escaping walk_pmd_range() and
+ * making walk_pud_range() walk the same range twice.
+ *
+ * The mapping is two PMDs inside one PUD. PMD 0 is populated once and left
+ * alone, PMD 1 is faulted in and dropped again by a second thread. Clearing
+ * PMD 1 under smaps_pte_range() makes it raise ACTION_AGAIN, and since it is
+ * the last entry the stale value leaves walk_pmd_range(), so smaps accounts
+ * PMD 0 twice. A kernel that does not reclaim the emptied page table never
+ * clears PMD 1 and so never hits the race.
+ *
+ * A hit can only come from the kernel counting the same page twice, so the
+ * test cannot fail spuriously.
+ */
+#define _GNU_SOURCE
+
+#include <pthread.h>
+#include <stdatomic.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "vm_util.h"
+#include "kselftest.h"
+
+#define NR_PMDS		2
+#define NR_ROUNDS	20000
+/* Cap on how much of PMD 0 to fault in, so that a large PMD stays cheap. */
+#define POP_MAX		(2 * 1024 * 1024)
+
+static char *area;
+static size_t pmd_size;
+static atomic_int stop;
+
+static void *racer(void *arg)
+{
+	char *pmd1 = area + pmd_size;
+
+	while (atomic_load_explicit(&stop, memory_order_acquire) == 0) {
+		/* madvise() below keeps the compiler from lifting this out. */
+		*pmd1 = 1;
+		madvise(pmd1, pmd_size, MADV_DONTNEED);
+	}
+	return NULL;
+}
+
+static unsigned long smaps_rss_kb(void)
+{
+	char buf[1024];
+	char *entry;
+
+	entry = __get_smap_entry(area, "Rss:", buf, sizeof(buf));
+	if (!entry)
+		ksft_exit_fail_msg("no Rss: entry for the test mapping\n");
+
+	return strtoul(entry, NULL, 10);
+}
+
+int main(void)
+{
+	unsigned long max_rss_kb, rss_kb = 0;
+	size_t size, pop_size, i;
+	pthread_t thread;
+	char *raw;
+
+	ksft_print_header();
+
+	pmd_size = read_pmd_pagesize();
+	if (!pmd_size)
+		ksft_exit_skip("Cannot determine PMD size\n");
+
+	if (sysconf(_SC_NPROCESSORS_ONLN) < 2)
+		ksft_exit_skip("Need at least 2 CPUs to race\n");
+
+	size = NR_PMDS * pmd_size;
+
+	/*
+	 * Align to the mapping size to stay inside one PUD, then trim the
+	 * slack so that smaps has exactly one VMA to report.
+	 */
+	raw = mmap(NULL, 2 * size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
+	if (raw == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	area = (char *)(((unsigned long)raw + size - 1) & ~(size - 1));
+	if (area != raw)
+		munmap(raw, area - raw);
+	if (raw + 2 * size != area + size)
+		munmap(area + size, raw + 2 * size - (area + size));
+
+	/* A huge PMD never reaches pte_offset_map_lock(), so keep them out. */
+	if (madvise(area, size, MADV_NOHUGEPAGE))
+		ksft_exit_skip("MADV_NOHUGEPAGE failed\n");
+
+	pop_size = pmd_size < POP_MAX ? pmd_size : POP_MAX;
+	memset(area, 1, pop_size);
+
+	max_rss_kb = (pop_size >> 10) + 256;
+
+	/* Over the limit before racing means this is not our own mapping. */
+	rss_kb = smaps_rss_kb();
+	if (rss_kb > max_rss_kb)
+		ksft_exit_fail_msg("Rss is %lu kB before racing, expected at most %lu kB\n",
+				   rss_kb, max_rss_kb);
+
+	ksft_set_plan(1);
+	ksft_print_msg("racing smaps against MADV_DONTNEED, %d rounds\n",
+		       NR_ROUNDS);
+
+	if (pthread_create(&thread, NULL, racer, NULL))
+		ksft_exit_fail_msg("pthread_create failed\n");
+
+	for (i = 0; i < NR_ROUNDS; i++) {
+		rss_kb = smaps_rss_kb();
+		if (rss_kb > max_rss_kb)
+			break;
+	}
+
+	atomic_store_explicit(&stop, 1, memory_order_release);
+	pthread_join(thread, NULL);
+
+	if (i < NR_ROUNDS) {
+		ksft_print_msg("walk ran twice over the same range\n");
+		ksft_test_result_fail("Rss %lu kB exceeds %lu kB, round %zu\n",
+				      rss_kb, max_rss_kb, i);
+	} else {
+		ksft_test_result_pass("Rss within %lu kB over %d rounds\n",
+				      max_rss_kb, NR_ROUNDS);
+	}
+
+	ksft_exit(i == NR_ROUNDS);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 8c296dedf0474d..d90c6370814f7a 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -398,6 +398,8 @@ fi
 
 CATEGORY="pagemap" run_test ./pagemap_ioctl
 
+CATEGORY="pagewalk" run_test ./pagewalk_race_test
+
 CATEGORY="pfnmap" run_test ./pfnmap
 
 # COW tests
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ea8fc8fdf0eb0b..62292e2417d162 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -88,6 +88,7 @@ bool pagemap_is_populated(int fd, char *start);
 unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
+char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len);
 uint64_t read_pmd_pagesize(void);
 unsigned long rss_anon(void);
 bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
-- 
2.43.0


