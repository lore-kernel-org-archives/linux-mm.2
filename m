Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD37C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E716B00BB; Fri, 18 Sep 2026 20:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6C26B00BC; Fri, 18 Sep 2026 20:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD59A6B00BD; Fri, 18 Sep 2026 20:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83ED06B00BB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9DFE14014B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:28 +0000 (UTC)
X-FDA: 85228617936.15.762B6EA
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf07.hostedemail.com (Postfix) with ESMTP id C57D640002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="c q0M3Ht";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Ce2n4BGQ;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777526;
	b=XI/IfsT3XgkIl2nTw0wmJ8CHLyJQ+hFJDztUsHNHMxdArCf1bioCDuqtj0y7AsUbj0nK5X
	Dy2LtVNp0VH+LrcSxwSk4g6LArd9lnexiRRGv8/mU3dHT+mwldzi9kAnnKGkq9L5yHuYcp
	hc7rPazOQMN97JpHgddkb2DzKNCbZUA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="c q0M3Ht";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Ce2n4BGQ;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mR9pCgBHcxHPmqpCWWzP1dD7seP1IcB/o66x6smjktA=;
	b=O5hypNBaqDtloVyBlcO8kPpjPuTP6As2E1cECVRs2BDeUAdn4Z35R8H9NpJRLjFV8QD+hN
	kgcWxN2Nn5fnbl/VIFzR41NuzT9y4iEixBVJAjK4PlAEElQq2qsGRZVIiQeWMFme19hi5i
	50VyQqQz9+3ZEk+XTiW8jRs8ZpnxcZA=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 679471400157;
	Fri, 18 Sep 2026 20:25:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 18 Sep 2026 20:25:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777526; x=
	1789863926; bh=mR9pCgBHcxHPmqpCWWzP1dD7seP1IcB/o66x6smjktA=; b=c
	q0M3Hta2n0HLYrDD2ASXF11Mqh/y3tR9ybQXSq+Walk/5i3cAjJMWdBPz3mJw9FB
	iV4NFmdzRVyfFbsO/Y2gqMAyjXUNpuD5RtXZAiFqhsiwzDM53003u2YDbXh8Zn7V
	KcKS0qU1Dlz1b+sQW0YtlYL1Gl5AHgvPA8tsLyMRpqNKWOBFmMYaow9TVAiPYqqo
	zfhBs35t/ng0aySv8QHurCwUbpk+snjRZn8Enc6tL8ur0NN5D7RhMBQNs4RiXyk3
	jcHZdcF/SVzUqx390A/kWhdxt/yj3pVXMW1CUGdJFDevGEXKKWonJuQS5tnRs0Wn
	ymDxHuGNg9TZb6xzM5KLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777526; x=1789863926; bh=m
	R9pCgBHcxHPmqpCWWzP1dD7seP1IcB/o66x6smjktA=; b=Ce2n4BGQbXgh8pkKt
	Qz74bilNXehWx3KxQiKv5LH2bygQEiyaSVUEk0Omh8Z0I78bfoTaLZVg6aJiCAhz
	/ho1DFvwFFeaRC2RhH35DbR7V39KzoVi06XpY6vydpgKjTuD3AVk8PikTHykb8PU
	33xfUsvmL2jm7L5WjdTQ/3V6f5dUEQKs27H7D3Qp2CFl5LG46tiqbGNnZPFwOP9i
	BcIxU04U67p8NvOdB+se50QH9oDcFsXDWHw6/10KLGeJAoITXioEJtP4UTOGwfM7
	W3F1G4poVrFpslX7ITJHismsc6sBEDHCKtUTghEvVvzIcVZAQpX7nyVbnxC6JuAd
	0JIWA==
X-ME-Sender: <xms:dtatamUyOgTAjsANvAyQ7T-5AZwIfdrZhUXtcOmm4KxpqzJSsAjh9g>
    <xme:dtataq_LbovjXJkriEh1HifQ0nzobKOKdQfv-kI_04CiXRNtUgzww_ZCqDTqGWH2Z
    xvdmluohfz7jf5stZKkPVJfBcuiDEGcW-Nxj18ngvRPOIPXWRsJWY6z>
X-ME-Received: <xmr:dtataslLRJtMvwSpcDVV4dLFr_8KQx5xfkHnewb5-zV61sFzcvBOToig8XE>
X-ME-Proxy-Cause: dmFkZTEr5yKr4sxuQbXqh6mxNPhLx5TPKhba5+X7XnlS/zJ9vgRk2t0FxRNN7MLg+r6CPW
    Mu6PNIlmN7ZPoxynBFUAJAPtPIX+NuZRIFaOEVqo689ggMVwgiN48ZIazRbbn8524IbcBa
    VFaAXtPPhux2zoqYNSaL4fhjV7u8LwweVoGm0ycn2eaUICY9i4xSWPBSrUzWeffPDzxnz4
    WggCaU37X5tXMmNpoupzaGNfQ+amnYr5ymN7dEq2+UMtHRoF6bcIpmQfw03IlrWSCYa/Ho
    OSQdXdtFB8WyOz/pBd87oZ5qPprkCNYTXqaz9hCIAMLkvF6M+JOqCuEaEpX/p3iuKuZ/AY
    3wxej3Gego0TQyMZGd62Y7jQDn9PLpumtTSUuXVHq454jXGAT6Ba2Z/FsPe8qJEYGhY67k
    vzCYolx/jEcg+uZOjcRd76zRadiBiUEmJ7sMB+W5Gb0kpRKuykuMwrrhYEOA21lvkP+Fbk
    AY7HC6MZAegvs4/v8DQiLii18SYYFeAn8dlhftmhhBP8RhMVZNb8ZdGxvPVPb3loR3f5cv
    MQDOtOocmxOIlkKwi8hKXHgq+rBjWqbGc00gA6jYR+2TWCCj5MM9sybvHkhwb40rXI8tBH
    vbpdn0WPErWiSV5aDb0TUZvxFOIaL8+c1xMombQG0h+Arjkx5JerQ2n7Lmpw
X-ME-Proxy: <xmx:dtatalIM1ZRXO05ePStJnyWIegKJ7f34mVATv4I73Izb7RR0h8OqPA>
    <xmx:dtataipUMYm4CU-yzAPa_u9EKU07ZzNRiVenapLkRpiO5HLMYAtsyQ>
    <xmx:dtataiTxZQI0UIUsuqoKTLA8HxbqtuGi6DyQJfgmLHk1boVR-HymrQ>
    <xmx:dtatal6uL8WIsneQo4g_2709vu7lQ8HLSk4TK9f3PI6F21CdMyrKvw>
    <xmx:dtataoNz9RVI4GVY3Q9Y7JuPcgzeBC6F7OPsKQciVu5Ccw-MsCD_aMIU>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:25 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 15/19] selftests/mm: check that one khugepaged pass collapses one window
Date: Sat, 19 Sep 2026 01:24:45 +0100
Message-ID: <20260919002451.496763-16-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C57D640002
X-Rspam-User: 
X-Stat-Signature: eo6wpfheo4jeo7k4qqusom5kw5z6fdkp
X-HE-Tag: 1789777526-924374
X-HE-Meta: U2FsdGVkX19xhQVn1Kf3Q11I0t1eRfEUQkieWN5fLvHfQjCSUP7Iuw18zsdzb3YzPmhmqzGQB6ENbpJo+lez7vZDMn0quSNJApwtXiVYCOEoWXFQwRkZlgxTbuRv3d0DPRLtUhRVOdEGxkuusvL/xY/c+Ap5ga8aXYgwwvilET/ZqyiQzcTdEEfSq10bcB5T92GQAUVCVnH0aXfQv+0DuLRHvTnwgUv4YyNorTyk1udxDC1aedVRrJNPo6gEHlNRSYZPe1U5IMr4V2Aep6J1MGZvMZpkPuzzOauLwXIXa7rfLcl0h4lc7qBcgmyTUc22CLLxYYoEgcYCJCb4ndqgX4nk1r6oL7ylgZyNISDuimqNO6/WP0ff13FoabrmPbiEpfri1IFt0YiCH7j5AMh0K+kfZgBIY0rw8vajcCKyfYWACYYDf6BH97ugHTLBeT8ueIr/zGdSc1PbfG96mZ/pNUcsnY4hUWYWUtmwpzdW6mXLzeN9R4+tjHE17xlLFdyVS7AX6Fk6QJ1Q+6Q3OpEpTV1/oGuCv2M+Nf+TU71sbnV0RGax1tPjbKuZ1UGllzT9eo8dusU4FEN2UUjpqrIfIMU1GMYxy+IgtsFriUZ8MgG+E0XRubBRxHa+ifObBraguup6qPwv3OdfKE45PM3p1DYHwxFOPJzSxQbqBP3I+/Q8Ri7SP2nFjCTO20Nt+GyZl/rQP2gUG+PfXV3TSVGFlIbyDxF8PbUNGl6HIVmOtOIJk0KghzhuZ2MvE8RexT56JVoEO8xlY855A4xE5yVl9C6Twe8ZEEmVI3z0VQ53GVQ3CdobobNGfJX9L6FsgoCYRwnpPTr0R7rXa9vsUnfr8nhsd3aAUsSkg1ga3H688QqTau/Y6Ok1jLpagRd22QmKVDHCU99JFWrnEOfKZplExWx8Wb9dabhB7VK6uGkhks1WhO7YpeQN26PQQjR8/EF8I2nWtDP5dR5Rihv6Uv/
 eOUGExUA
 0CZJ8vUEQvgvECrO8txSTeO9IjRN1ez5LrMkhDay58ESW/l8ytii1VMmJIJf8ob5TQGvjFMir7CD68zg1I+Ad/t61iEJUli+bKuhmKNM2L8RwAdZ6aLWZkA6BMYojaGpwCsnxx0VcXSNcKJ3lELeyl+12RtGGL9PV+hqhaGD0qtyXp52hiWIPTELBpB2J1D6V2Ro64NyVnKjhcbvrJXe7gOYpmq/Ql+r7Q23V2DefJBXcLp6Hb0U96dLxljjO/iIRL8KmmA3b73FDES0lx4UAz4GY7JwxPzKIYz4xmMVLTPwQTReHsqr5ahe4mcS1+wDBUSEs9+dg2aKK7nQ378rUrYGkq0NduSCg2H6tZ+YuoiDL2C8r7A0ObxPt5CMVaTUzTG72G1MbxBjMrbgwqzMxujVhgrSEUcmUDE+spcr5CeynNXQMkxpw2u0vFo/ov8PBaXIZRn2Vk6k/QDYiivBwXqNhawk/X0aXd4vLcdstpA1pu6dlS74Qax3PbHuyJrRo9PW6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

khugepaged_full_pass() drives the daemon through sysfs: a store to
scan_sleep_millisecs wakes it, and full_scans advancing by two marks one
pass that started after setup.  Every mTHP collapse result in the suite
rests on that pair, and nothing checks it.

Add khugepaged_sync_check.  Each step:

  - prepare one aligned window
  - record its source PFNs from pagemap
  - run one khugepaged_full_pass() barrier
  - require the window came out collapsed, with exactly one collapse
    attempt attributed to it

The anon events carry no virtual address, so an attempt is matched by the
source folio PFN and order that the mm_collapse_huge_page_isolate
tracepoint reports.

Reading the trace buffer takes four small helpers in vm_util: open an
event subsystem's enable file, flip it, clear the buffer, and open it for
reading.

scan_sleep_millisecs is set to a minute, so a step that took a sleep
instead of a wake would blow the budget.

Passes 5/5 on x86-64 4K and arm64 64K.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/khugepaged_sync_check.c      | 179 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/vm_util.c          |  38 ++++
 tools/testing/selftests/mm/vm_util.h          |   4 +
 5 files changed, 224 insertions(+)
 create mode 100644 tools/testing/selftests/mm/khugepaged_sync_check.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cb32cf5d867e..2ed881324911 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -106,6 +106,7 @@ TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
+TEST_GEN_FILES += khugepaged_sync_check
 TEST_GEN_FILES += soft-dirty
 
 ifeq ($(ARCH),x86_64)
diff --git a/tools/testing/selftests/mm/khugepaged_sync_check.c b/tools/testing/selftests/mm/khugepaged_sync_check.c
new file mode 100644
index 000000000000..28a9b1ff5d44
--- /dev/null
+++ b/tools/testing/selftests/mm/khugepaged_sync_check.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Check that khugepaged_full_pass() drives khugepaged in step: one barrier
+ * over one prepared window must collapse it with exactly one collapse
+ * attempt attributed to its source pages, step after step.
+ *
+ * scan_sleep_millisecs is a minute so that a step which slept instead of
+ * being woken blows the budget.
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
+#include <mm/hugepage_settings.h>
+
+#define BASE_ADDR ((void *)(1UL << 30))
+/* Smallest order khugepaged considers */
+#define TARGET_ORDER 2
+#define NR_ITERATIONS 5
+#define PASS_TIMEOUT_S 30
+
+static int pagemap_fd;
+static int kpageflags_fd;
+static int trace_events_fd = -1;
+static unsigned long hpage_pmd_size;
+
+/*
+ * The events are system-wide: switch them off however the test ends,
+ * including from inside a helper that gives up.
+ */
+static void trace_events_off(void)
+{
+	if (trace_events_fd >= 0)
+		tracing_events_enable(trace_events_fd, false);
+}
+
+/* Count the isolate events whose scan_pfn is one of the window's source PFNs */
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
+	for (i = 0; i < nr_pages; i++) {
+		p[i * getpagesize()] = i + 1;
+		pfns[i] = pagemap_get_pfn(pagemap_fd, p + i * getpagesize());
+		if (pfns[i] == -1UL)
+			ksft_exit_fail_msg("Source page not present\n");
+	}
+
+	/* Clear before enabling so the buffer holds only this step's events */
+	if (tracing_clear_trace())
+		ksft_exit_fail_msg("Cannot clear the trace buffer\n");
+	if (tracing_events_enable(trace_events_fd, true))
+		ksft_exit_fail_msg("Cannot enable huge_memory events\n");
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	passed = khugepaged_full_pass(PASS_TIMEOUT_S);
+
+	/* Off before anything that can give up: the events are system-wide */
+	if (tracing_events_enable(trace_events_fd, false))
+		ksft_exit_fail_msg("Cannot disable huge_memory events\n");
+	if (!passed)
+		ksft_exit_fail_msg("khugepaged did not complete a full pass\n");
+
+	collapsed = is_range_backed_by_order(p, window, TARGET_ORDER,
+					     pagemap_fd, kpageflags_fd);
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
+		ksft_exit_skip("open(/proc/kpageflags) requires root\n");
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
+	settings.khugepaged.scan_sleep_millisecs = 60 * 1000;
+	settings.khugepaged.alloc_sleep_millisecs = 60 * 1000;
+	settings.khugepaged.max_ptes_none = (hpage_pmd_size / getpagesize()) - 1;
+	/* One wake must complete one full pass; see khugepaged_full_pass() */
+	settings.khugepaged.pages_to_scan = 1UL << 24;
+	for (i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+	settings.hugepages[TARGET_ORDER].enabled = THP_INHERIT;
+	/* Base of the settings stack; the bottom entry is never popped */
+	thp_push_settings(&settings);
+
+	for (i = 0; i < NR_ITERATIONS; i++)
+		one_step(i);
+
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 98a33f6d15d4..612a8c4afc53 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -384,6 +384,8 @@ CATEGORY="cow" run_test ./cow
 
 CATEGORY="thp" run_test ./folio_order_check
 
+CATEGORY="thp" run_test ./khugepaged_sync_check
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index c8c5cd8ab6c1..31d331c1c452 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -602,6 +602,44 @@ bool is_range_backed_by_order(char *start, size_t len, int order,
 	return true;
 }
 
+#define TRACEFS_ROOT "/sys/kernel/tracing"
+
+/*
+ * Returns -1 without tracefs or the subsystem.  The events are system-wide:
+ * whoever switches them on has to switch them off again, on every exit path.
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
+/* Drop what the trace buffer holds so far */
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
index ea48e6a7527e..072a6c756c51 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -121,6 +121,10 @@ int close_procmap(struct procmap_fd *procmap);
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


