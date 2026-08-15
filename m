Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 406E4C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B46386B0763; Fri, 14 Aug 2026 21:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D566B0765; Fri, 14 Aug 2026 21:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D2F6B0766; Fri, 14 Aug 2026 21:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3E36B0763
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0019C02B6
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:36 +0000 (UTC)
X-FDA: 85101847152.04.6F1A1CC
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf16.hostedemail.com (Postfix) with ESMTP id DBA73180002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="w UEtkP4";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AyEkDJyG;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OE+z5Z9t7XAE9Lh7e4xto9pNkr14mTVu0K4BOrQwVeA=;
	b=T2iEkzftrwoAyyYzrHiPyiK5/THrkMGO6HXjx5KVeKg7kd2vt2iwNPUS/kfKm+cSW4Pu/9
	C13yvfNb7XZZGXg8KZYP66j3YVCCJmbTP1cN4EVa8Zug3tU/VAPj++1t9M2zlpYZm25U4Q
	fsliYaE9C35s8XyMkWV6Y+q+iLi3Mpo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="w UEtkP4";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AyEkDJyG;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759174;
	b=Va+G4nJpG58JNTMEwU791VzXTDUEBtHaz6KcvLL5wMmsOy96fHo/4HX1i7HjRhm4hTxJZh
	Wc8mRg4B7i3FPIvocz+rn4/u8KvBY3xuJSjVREA8/R0/6UGdbxV2rw+vxvmeWrMYftHo7f
	K94L2O4PEJrW7yWU/OuVw6p9MuF6n5Q=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 6EAF3EC0223;
	Fri, 14 Aug 2026 21:59:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 14 Aug 2026 21:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759174; x=
	1786845574; bh=OE+z5Z9t7XAE9Lh7e4xto9pNkr14mTVu0K4BOrQwVeA=; b=w
	UEtkP4LaohjkY96dUrM2/Gg8v1SXvE4oyJieVcO/3ihCC/2FVBAXlb9IK9Bv192m
	8uzuj/jYsJxulejGiLNr0DoMsCs8KGQMBRB8g40buy4hLq6NEmRIzw1SFmniHJrS
	bOXaXgn0hEvlZ84bqBZhAjOEh4kCHn7qcAABhBjLT4kW2hWJ06N26RBpsd/o/PW/
	t69YZ+E3WYCgItp+vu6oer/AnnZTMH+LTkFXgc7r/uMV1dX4Ubt9QHkDwys3Nfs4
	P0bMi8/u64OEMAStvvpzXk0LGbuR+Sy43ntYzKxUjFPRPa5hJ74XUlUxmBXZIwM6
	O+/f3oet+Y6QB+2UzfAWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759174; x=1786845574; bh=O
	E+z5Z9t7XAE9Lh7e4xto9pNkr14mTVu0K4BOrQwVeA=; b=AyEkDJyGf1lb0vT8i
	u26VGfBvF2PeRMRwqY7FKd0mcxNsZVGFP11AIdffinftozZWOHOJE4F8iIV14zqv
	iUvGyPjD0EJiPsEtrvP2NzINUIaBIfLZB+HmP1VD/Py3hGOhFJCr5lPO7SByagyW
	mlR7bib4aJX5QibPO3vK0/24Xsek/zsX7BU/iQCvbcVHTN7K4nCT6QxtNUqxGk2p
	9KxTM8gfBVLHVYPEKzf9OHJawb8fSzcq+KbiIoLKO/mpT4ursaEOPgENXDebj40e
	MQ0C7QLRkKfHMnafK3TjFoJqbp0TKzMgWp2UuT7BecKeujq+1HsSBjho3xmaIiDc
	K1x9A==
X-ME-Sender: <xms:Bsh_apCj5imOw7h35lwKSOUh23S4jNuNK1n3CShZDNvFlQPSEuaXQg>
    <xme:Bsh_ardLEYUvY_TUfR_Ry3FyHi81DRF7QsFiSnAta1CGf-REg5T4Bcp3Lp_Wpu04z
    KV1wli2PKgqNDW9EsG3Uq2MtHuPFOAu0M5wc3boov0U6jPrsTAksA>
X-ME-Received: <xmr:Bsh_atHm1PniLhswtsIW6CT7oelwA8WUR6QL6VLGo6S7_gxaAJXte59Xh3k>
X-ME-Proxy-Cause: dmFkZTEHOB8klcfpaewZ3k5dhFGq+0NT52m0JgfrBhlsrZZ6/wIFkiWFy9BKVmBRzT/M60
    afg3IBZlSt5ygR3bwXNIcW5ZM0yyzN/pf9UTr2aIVxu9PRgCvu2oUUNVujSBw7FeHwFBsc
    cXVjrQP9UQmJU5OZxw2U7sN+BvQMOJwzXPSq8ovjEuIpT5m3q0hBt7II5b5sCGi7gkG3/G
    fAkJjKG33ZxocRSbFLEDKzhP8eL3QUGAVXaSl2VxURMVZW4QVvv1Ki5M31XaRzn4+ok0bg
    hGdz4SdlVbJh+GxMS7w8oKVQIiajy/o8Z9eSxaHEz+PVJrdtO9FMEbFO2si+6c9liGB/Ff
    wTXUAXs77/qsjTCBHYxKGokLOK18ZP4RunQBJXnW9+ILE0Q8RXfNQjiO2b7MS7IStm3xGm
    9ZTMP3wgI0RcearR/x3pfcMGh1sX409I5pLYM4jEiOqo50fkI/rrfVeQsURZyXI4FPNhfv
    6HlOxn/FFx+/3Onfi4EM1QN2/WuBLFP908hXPCTSbsDyuE9vtDgUkEJaOMOcu7tO/57tBx
    5VjfcRA6iqSAiym7JeLBedzNgZgvBks8ft3zse8ViQIoSeY82Brpm0EMkCQgHaAfpr+Kga
    ar1+NqX/iZktB0Uc07Ogq4Na5lrgEbypKolD52EtT0mVHSZl2kffM2vXdC6g
X-ME-Proxy: <xmx:Bsh_atUdjh-RAkPSfDjNcj0GW0A9OZUQ5LX7FOfQoDqfhHznYVE82Q>
    <xmx:Bsh_alxkdCO-VTiaswKMLcxPLpXyRipYbdgemMhlkFjfb5CK1Ihgqw>
    <xmx:Bsh_agt10vYBYyaBGITuK9iLEgRddWY0JmDZ1JzaUyGZ1pqV8Q8uwA>
    <xmx:Bsh_auDd2Oy8piH8YHSEzvlpaFybvpxtBAER9WrhSwjGJGrxe4fj4g>
    <xmx:Bsh_aug08D5X0yARbQiToWH5R58YK_SByBzFdU2VXNax7E6Fr_eh2q9Y>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:33 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v4 15/19] selftests/mm: check that one khugepaged pass collapses one window
Date: Sat, 15 Aug 2026 02:58:57 +0100
Message-ID: <20260815015901.1236937-16-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: oxjpfq48p4c7mnio5oqhcnmnzrhzbpie
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DBA73180002
X-HE-Tag: 1786759174-477271
X-HE-Meta: U2FsdGVkX182vUgyH2vwsiy9P/ZIwBcl7GFIhnvvOfO56QRN2UfKAUunUB58upttt55DasQymqYkXzoCXxg//NPRTpg975X7YEoWdZDGwwuier4RSxcX8Kt2SVBzoQoTr3aj9fYRM+QO/6wN8TBwLslqvXm8ydetDQWYn/f1bUiNDKLFhMbLhK/+A/2qDh263Z54qdVySqh60pZFXW7QR477kCmsLIWAP2FXZHz86SB/W679dTfar3KpO3/pvaYkCFlO5j8PIDJ7wgzZVilrYCwx8WSsQBdcw9adKB5hUilmKIknLR3t1YQhWtgrGwWSctRd4pLXwVp48xbgaaXcc1BDs3E3LMKqZNmrMWP0kYNPkcnnSgrOhJN/x7c2tz4UFELmwfwxabglzz3ieSGFk0qS6bNSV/wB8CR3RACwfNSFhR+cwEZWMhZ9D/2z9OwwAcjmuSZ5MDLmP7DM75BiT86tV4wWpW+3cEtJyUd20H97LdMHYq3uvv8meuR9sLt+hOYOYCoe4z9WNK4fu2s4PrOivlEpT43d9xkhUrE1yVKBc/zJz3Kse7O+dKpe2OUyBxFE7BpwCbIv7KVPQdacaYzp61DSmQzeLb9sUTGlsLclBIoN4CmKfHe/Xq/cmZUjUtQM7gu0668W8k6Q9fuxIuDZJC1MqBT0Qc2REUMF85Z2zXxlWfzMrxRK78EZWgwnDuzN5/tWqnMYksC1L4ttTlcvHZRMBtc/iraQQ2cMl45HdjvKcTwoABUEh4BedUc6JRSoP9RXQvoiw8tCQk750sbfO4zhsvkE7peKJtml1/FjDc4txmbsgtUG0VtyiTmdFMKBERKRS7gYAq48Lo3AY4b40+QJ9e9Znkj4ZimrtoJMRCcj5vu/aUW0vHGiRqPbO1DmBi3Fic99lYsfiBecd5EzbjFspO3+MqofIDi3FG0Rw05NxHO0hVK2WrxVEAUolrifyaT7qwY3+u/QYT9
 YPpSEFCQ
 Z+iOcn2S0qRDCv7JWCnEav9J+1PDfWjQxWi9cRNqFgGqDLSjDUT1qDkFcdq+d1blDYlTK+kpqJNILFMci5vTD3ycZ5hBIoqF+IKTSgCtt0N/+nRW5hgiUuWeKyQKHEXcDRGSV9M5ypMYkqa0aboUopO76Rnk5wGEkZkM5pfEUX1MZuE+1nH1oLalHt32MY8Tt7tDrrbbWEj+hxrS/WfFALRVxraYB0Gx0wqqs6OlkWjXtlL6+aK8+g58xiXOQpInHRMYg2PdrrtxwBG7JBjLPhBZDzZ334sTH7Cb1g9yRwA8FE2BiI2ub1vjC3oGVc6WZ8i2WvmVTNjoGi2Xw+9OB7uZgxbL2cFXx2hFxyGqtQYlA5/86aRnU/eyhC6nPJj8xfOr/Kv0GNeMhmfJtyoivTonn70NBUg2UNUpdpBoGQ0kWnkbKsmOWoFS//CvlL68zsMgE+OYY2wHrOYkLRn/6CgOfkYUkTsx5pCr5/QKG5aZwVMIFExktb8ARYS/dz5xTe6bN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The khugepaged cases drive the daemon through sysfs: a store to
scan_sleep_millisecs wakes it, and full_scans advancing by two marks one
pass that started after setup.  Every khugepaged result in the suite
rests on that pair, and nothing checks it.

Add khugepaged_sync_check.  Each step:

  - prepare one aligned window
  - record its source PFNs from pagemap
  - run one khugepaged_full_pass() barrier
  - require the window came out collapsed, with exactly one collapse
    attempt attributed to it

The anon events carry no virtual address, so an attempt is matched by the
source folio PFN and order that mm_collapse_huge_page_isolate() reports.

Reading the trace buffer takes four small helpers in vm_util: open an
event subsystem's enable file, flip it, clear the buffer, and open it for
reading.

scan_sleep_millisecs is set to a minute, so a step that took a sleep
instead of a wake would blow the budget.

Passes 5/5 on x86-64 4K and arm64 64K.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/khugepaged_sync_check.c      | 196 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/vm_util.c          |  41 ++++
 tools/testing/selftests/mm/vm_util.h          |   4 +
 5 files changed, 244 insertions(+)
 create mode 100644 tools/testing/selftests/mm/khugepaged_sync_check.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2093fcf6e915..b2d6e5c12934 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
+TEST_GEN_FILES += khugepaged_sync_check
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/khugepaged_sync_check.c b/tools/testing/selftests/mm/khugepaged_sync_check.c
new file mode 100644
index 000000000000..45001996b57a
--- /dev/null
+++ b/tools/testing/selftests/mm/khugepaged_sync_check.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Synchronous khugepaged driving check.
+ *
+ * Race tests drive khugepaged through the existing sysfs controls: a
+ * store to scan_sleep_millisecs wakes the daemon, and full_scans
+ * advancing by two is a completion barrier for one full pass that
+ * started after setup (khugepaged_full_pass()). Verify the pair gives
+ * deterministic, attributable results: one barrier step over one
+ * prepared window produces exactly one collapse attempt on that
+ * window's source pages (mm_collapse_huge_page_isolate events filtered
+ * by source PFN and order) and the window is collapsed
+ * afterwards, repeatably.
+ *
+ * scan_sleep_millisecs is set to 60s to prove the wake path: without
+ * the wake, one barrier step would sleep multiples of that and blow
+ * the timeout. It also keeps the daemon from free-running between
+ * steps, per the khugepaged_full_pass() discipline.
+ */
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+#include "hugepage_settings.h"
+
+#define BASE_ADDR ((void *)(1UL << 30))
+#define TARGET_ORDER 2	/* smallest order khugepaged considers */
+#define NR_ITERATIONS 5
+
+static int pagemap_fd;
+static int kpageflags_fd;
+static int trace_events_fd = -1;
+static unsigned long hpage_pmd_size;
+
+/*
+ * Each step switches the events off again, but a helper can still give up
+ * on us in between (a failing sysfs write ends the test from inside
+ * thp_write_num()), and huge_memory events left on are the whole machine's
+ * problem, not this test's.
+ */
+static void trace_events_off(void)
+{
+	if (trace_events_fd >= 0)
+		tracing_events_enable(trace_events_fd, false);
+}
+
+/*
+ * Count collapse attempts attributable to our window: isolate events whose
+ * scan_pfn is one of the window's source PFNs, reported once per attempt.
+ */
+static int count_attributed(unsigned long *pfns, int nr_pfns,
+			    unsigned int order)
+{
+	char line[1024];
+	int count = 0;
+	FILE *fp;
+
+	fp = tracing_open_trace();
+	if (!fp)
+		ksft_exit_fail_msg("Cannot open trace buffer\n");
+
+	while (fgets(line, sizeof(line), fp)) {
+		unsigned long val;
+		unsigned int ord;
+		char *s, *o;
+		int i;
+
+		s = strstr(line, "mm_collapse_huge_page_isolate:");
+		if (!s)
+			continue;
+		if (sscanf(s, "mm_collapse_huge_page_isolate: scan_pfn=0x%lx",
+			   &val) != 1)
+			continue;
+		o = strstr(s, "order=");
+		if (!o || sscanf(o, "order=%u", &ord) != 1 || ord != order)
+			continue;
+		for (i = 0; i < nr_pfns; i++) {
+			if (val == pfns[i]) {
+				count++;
+				break;
+			}
+		}
+	}
+	fclose(fp);
+	return count;
+}
+
+static void one_step(int iteration)
+{
+	const size_t window = getpagesize() << TARGET_ORDER;
+	const int nr_pages = 1 << TARGET_ORDER;
+	unsigned long pfns[1 << TARGET_ORDER];
+	bool collapsed, passed;
+	int attributed;
+	char *p;
+	int i;
+
+	p = mmap(BASE_ADDR, hpage_pmd_size, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE, -1, 0);
+	if (p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap() window");
+
+	/* Prepare one window; record its source PFNs. */
+	for (i = 0; i < nr_pages; i++) {
+		p[i * getpagesize()] = i + 1;
+		pfns[i] = pagemap_get_pfn(pagemap_fd, p + i * getpagesize());
+		if (pfns[i] == -1UL)
+			ksft_exit_fail_msg("Source page not present\n");
+	}
+
+	/* Clear first: with the events still off there is nothing to undo. */
+	if (tracing_clear_trace())
+		ksft_exit_fail_msg("Cannot clear the trace buffer\n");
+	if (tracing_events_enable(trace_events_fd, true))
+		ksft_exit_fail_msg("Cannot enable huge_memory events\n");
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	/* Wait up to 120 seconds for the pass to complete. */
+	passed = khugepaged_full_pass(120);
+
+	/* Off before anything that can give up: the events are system-wide. */
+	if (tracing_events_enable(trace_events_fd, false))
+		ksft_exit_fail_msg("Cannot disable huge_memory events\n");
+	if (!passed)
+		ksft_exit_fail_msg("khugepaged did not complete a full pass\n");
+
+	collapsed = is_range_backed_by_folio_orders(p, window, TARGET_ORDER,
+						    pagemap_fd, kpageflags_fd);
+	attributed = count_attributed(pfns, nr_pages, TARGET_ORDER);
+
+	ksft_test_result(collapsed && attributed == 1,
+			 "step %d: window collapsed, %d attributed result(s)\n",
+			 iteration, attributed);
+
+	munmap(p, hpage_pmd_size);
+}
+
+int main(void)
+{
+	struct thp_settings settings;
+	int i;
+
+	ksft_print_header();
+
+	if (!thp_available())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+	if (!(thp_supported_orders() & (1UL << TARGET_ORDER)))
+		ksft_exit_skip("Order %d is not a supported anon THP order\n",
+			       TARGET_ORDER);
+
+	hpage_pmd_size = read_pmd_pagesize();
+	if (!hpage_pmd_size)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open(/proc/self/pagemap)");
+	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	if (kpageflags_fd < 0)
+		ksft_exit_skip("open(\"/proc/kpageflags\") requires root\n");
+	trace_events_fd = tracing_events_open("huge_memory");
+	if (trace_events_fd < 0)
+		ksft_exit_skip("huge_memory events require tracefs and root\n");
+	atexit(trace_events_off);
+
+	ksft_set_plan(NR_ITERATIONS);
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+	settings.thp_enabled = THP_MADVISE;
+	settings.thp_defrag = THP_DEFRAG_ALWAYS;
+	settings.khugepaged.defrag = 1;
+	settings.khugepaged.scan_sleep_millisecs = 60000;
+	settings.khugepaged.alloc_sleep_millisecs = 60000;
+	settings.khugepaged.max_ptes_none = (hpage_pmd_size / getpagesize()) - 1;
+	/* One wake must complete one full pass; see khugepaged_full_pass(). */
+	settings.khugepaged.pages_to_scan = 1UL << 24;
+	for (i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+	settings.hugepages[TARGET_ORDER].enabled = THP_INHERIT;
+	/* Base of the settings stack; the bottom entry is never popped. */
+	thp_push_settings(&settings);
+
+	for (i = 0; i < NR_ITERATIONS; i++)
+		one_step(i);
+
+	thp_restore_settings();
+
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 8bf898b71350..c0f69da3fd3b 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -404,6 +404,8 @@ CATEGORY="cow" run_test ./cow
 
 CATEGORY="thp" run_test ./folio_order_check
 
+CATEGORY="thp" run_test ./khugepaged_sync_check
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index c9bd6c92fa41..ee1334778391 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -598,6 +598,47 @@ bool is_range_backed_by_folio_orders(char *start, size_t len, int order,
 	return true;
 }
 
+#define TRACEFS_ROOT "/sys/kernel/tracing"
+
+/*
+ * Open the enable file of one ftrace event subsystem (e.g. "huge_memory").
+ * Returns a descriptor for tracing_events_enable(), or -1 if tracefs or the
+ * subsystem is not there.  The events are system-wide state: whoever
+ * switches them on owns them until it switches them off, including on the
+ * paths where the test gives up.
+ */
+int tracing_events_open(const char *subsys)
+{
+	char path[256];
+
+	snprintf(path, sizeof(path), TRACEFS_ROOT "/events/%s/enable",
+		 subsys);
+	return open(path, O_WRONLY);
+}
+
+int tracing_events_enable(int fd, bool enable)
+{
+	if (pwrite(fd, enable ? "1" : "0", 1, 0) != 1)
+		return -1;
+	return 0;
+}
+
+/* Drop what the trace buffer holds so far. */
+int tracing_clear_trace(void)
+{
+	int fd = open(TRACEFS_ROOT "/trace", O_WRONLY | O_TRUNC);
+
+	if (fd < 0)
+		return -1;
+	close(fd);
+	return 0;
+}
+
+FILE *tracing_open_trace(void)
+{
+	return fopen(TRACEFS_ROOT "/trace", "r");
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ce05bce4670d..10c7be46e44c 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -119,6 +119,10 @@ int close_procmap(struct procmap_fd *procmap);
 int write_sysfs(const char *file_path, unsigned long val);
 int read_sysfs(const char *file_path, unsigned long *val);
 bool softdirty_supported(void);
+int tracing_events_open(const char *subsys);
+int tracing_events_enable(int fd, bool enable);
+int tracing_clear_trace(void);
+FILE *tracing_open_trace(void);
 
 static inline int open_self_procmap(struct procmap_fd *procmap_out)
 {
-- 
2.54.0


