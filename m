Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D11C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891F26B0095; Mon, 29 Jun 2026 05:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869A96B0096; Mon, 29 Jun 2026 05:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781D66B0098; Mon, 29 Jun 2026 05:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41B5C6B0095
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:44:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0CF08FB8B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:44:16 +0000 (UTC)
X-FDA: 84932464512.02.15A421F
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf13.hostedemail.com (Postfix) with ESMTP id 249A220006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:44:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782726254;
	b=7OmDyd6+D6rnGdHgHVHtIXqRyMiwD72pHEfTdCBosQfbK6fZnyC8RJ+6jtof/JR/B4U2A4
	jQsws0KtGD+CAX87xwWKsSwN3ADHxR/ITlkf5ajswdLtRszwu8w/Gsh+0L0C8vQjOD2fc+
	zn8JFc6w9U9hBFCkwVMTVRK0nCjuq2E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782726254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BOoNgkqkvXLukDVDk5hv2oPGUAiebiGbmWw3t32re0c=;
	b=FOTi4KEmyfNo8UGseJLhgkbVtdmd2ZMt1/OHmEhjNxGdctdfHCwknydcf6XIHhK/UEijaQ
	td6UaLRtHsXnAblvPEkOnF/31HOS/VjZruY1kqbDLzHul4l5izPg9TDo9wz+eiq8t+ggfI
	xpqvzNej9OPg1bB3TZRSn4OoJpYh03k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gphF819Hsz8Xrnt;
	Mon, 29 Jun 2026 17:44:12 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 65T9hdhe073463;
	Mon, 29 Jun 2026 17:43:39 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 29 Jun 2026 17:43:41 +0800 (CST)
X-Zmail-TransId: 2afb6a423e4def9-e561c
X-Mailer: Zmail v1.0
Message-ID: <202606291743418874MwSj1a9pQxI6vTW4AZDC@zte.com.cn>
In-Reply-To: <20260629174111989hvHNpXBxy36GgPPhOoPi1@zte.com.cn>
References: 20260629174111989hvHNpXBxy36GgPPhOoPi1@zte.com.cn
Date: Mon, 29 Jun 2026 17:43:41 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYxMCAyLzNdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGXCoHBhZ2UgaW5kZXg=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 65T9hdhe073463
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 29 Jun 2026 17:44:12 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A423E6C.000/4gphF819Hsz8Xrnt
X-Rspamd-Queue-Id: 249A220006
X-Stat-Signature: 5pgyzrsagd1pguhenyyh5dpc734h964c
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782726253-212737
X-HE-Meta: U2FsdGVkX1/O1FufSSORmJuOWTzYOAOfIFC7yElKX98a3qNmQU+4gO44r5N6TyTIk/QP+38ldmX3K5QekgivVxCrMqTrpTRGOVHU8KgvLMdcBalmPBfB1lIavzKFWDNe2WUHJ6Q1N5p9Pvef4rT4wp3ctcVHjyHCD9T76ykmVRiRQ9VTBzr0ekEojlYNxtuyr5W08CSdS/6w4GnDqP5542YWi2FI4Dv9LpEDx8i9NPPqi+uK9+5MVDkqRS0pfk9RcZEz4bIoa7hrO9vAkgB8Z0FKq5BZhfqJ+bPxxsT3pgH9Gv8zMAlIxR9LRG0zvIGg4V/d9ewJlpaY+wp2uIGRiVpeiKshWhQenlMiGu89sXWfIfSmbHkorJ0PRwxYK3/OPvaSz4Nh3RnEoTeQ0CZBImxmFhGOJWeh0nJu91MQ++R3oNDeoYXfllWZmNpyQKBo8W6CMBDfFiS0nrzkdSVDFqTui7n3czGEtuGLG2V3qTsB0LU5yI9ggMIf4w2AxDqHEfKIEExsAHn+mrIMrC/GVxGRstAfzmGG3EwDNrKZHfSKU82SgD7kbdJuXdxpj/41Er/EJQleU9dQGlZpr79gH+KYPTQ0BCo7XIK/QByu5TSKzfqkJxvqdwJgW03LBMp/sZNdagGsTmpGD3lseA0VHLDCcjjmeQuuaI+adHCE68ycaTtOMNIjaT5hYavbWoiyRnrg7U0LJqiO2Ig+RFhHsGYNdMsS/RedqmWOFc1ZquK5lr2n4pfMHmzaMOzWjUemqbVWCxSRKV8nZIPPUxITfPRe7qcVxZ4KfhwGW27JXZz7Qn3uTtOHMFDMGe+HK/+mA7mR0KooXR8nomWGCU1JStyOW0tXPhDUU+u/IHS2Y9ZwEN7U31hNMcMnk126pGAIESLZIXBEPO3zRKTgmJkjFmbNqnQuXJ9yVawlXtU9ERBT5tqslVNA2LTxlHphDF+/Zx3PXgz7ra6qugjumV7
 7ghaK5xq
 FSldvNQ0Bq/J6DzEW04UDuKlbxaGX3tUcYbxjd7jpnK42D+2GITmvZpT5DpIjMzuVLNbf4nLLdt0o4Auida6B8uY4yfmwtzT4RwP52mrveH5SnWVx/oPml+Po9/sXFofkzYnV0ehSuo0vhVHGzabmttALVrKV60eJb8kCiaNM97H6fyjiin0o4NhbU2dUrUhKTlmEgUeNvRnUIXzZLr9oAlU3VSuBRzwQyd2fPH6c1QXx3iPZBXo97ilbWD9CsCTHj3hT5AGRxORkW8o4COYDfefOivgsTmPxj6YQeyvu4x7YrGy9LA58piJCxUjzUSeEXzUA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

User impact / Why this matters to Linux users
=============================================
When a system runs with KSM enabled and memory becomes tight, KSM pages
may be swapped out or migrated. The kernel then performs a reverse map
walk by rmap_walk_ksm to locate all page table entries that reference
these pages. If A large number of unrelated VMAs can attach to a single
anon_vma related with this KSM page, then rmap_walk might be severe
performance bottleneck.  In our embedded test environment, we observed
~20,000 VMAs sharing one anon_vma without any fork – purely from VMA
splits， which cause 200~700ms duration of rmap_walk_ksm.

When one of those VMAs mapped a KSM page, then this KSM page's rmapping
will become bottleneck with hold its anon_vma lock for a long time. The
anon_vma lock is not only used by KSM; it is a core lock protecting the
VMA interval tree and is acquired by many critical memory operations:

  • Page faults: do_anonymous_page(), do_wp_page() (during COW)
  • Memory reclaim: try_to_unmap()
  • Page migration & compaction: migrate_pages(), compact_zone()
  • mlock / munlock: mlock_fixup()
  • Process exit: exit_mmap() (tearing down VMAs)
  • Cgroup memory accounting: mem_cgroup_move_charge()

If one thread holds the anon_vma lock for hundreds of milliseconds
because of an inefficient KSM rmap walk, any other thread that
tries to acquire the same lock (e.g., an application taking a page
fault, kswapd reclaiming pages, or a migration thread) will block.
This leads to stalled application threads, increased latency
spikes, and in extreme cases container timeouts or watchdog
triggers.

This patch reduces the worst-case anon_vma lock hold time during
ksm_rmap_walk from >500 ms to <1 ms, thereby almost eliminating
this source of lock contention and improving system responsiveness
under memory pressure.

Real-world examples:
====================
 - JVM / Go runtime: These use mmap for heap regions and later call
mprotect(PROT_NONE) for garbage collection barriers or guard pages,
splitting the original VMA into thousands of small pieces over time.

 - Database engines (MySQL, PostgreSQL): Large shared memory buffers
or anonymous mappings are managed with madvise(MADV_DONTNEED) to
release specific pages, which also splits VMAs.

Root Cause
==========
Through local debugging trace analysis, we found that most of the
latency of rmap_walk_ksm occurs within anon_vma_interval_tree_foreach,
leading to an excessively long hold time on the anon_vma lock (even
reaching 500ms or more), which in turn causes upper-layer applications
(waiting for the anon_vma lock) to be blocked for extended periods.

Further investigation revealed that 99.9% of iterations inside the
anon_vma_interval_tree_foreach loop are skipped due to the first check
"if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a
large number of loop iterations are ineffective. This inefficiency
arises because the start page index and the end page index parameters
passed to anon_vma_interval_tree_foreach span the entire address space
from 0 to ULONG_MAX, resulting in very poor loop efficiency.

Solution
========
We cannot rely solely on anon_vma to locate all PTEs mapping this page
but also need to have the original page's linear_page_index. Since the
implementation of anon_vma_interval_tree_foreach — it essentially
iterates to find a suitable VMA such that the provided page index
falls within the candidate's vm_pgoff range.

vm_pgoff <= original linear page offset <= (vm_pgoff + vma_pages(v) - 1)

Fortunately, an earlier commit introduced the linear_page_index to struct
ksm_rmap_item, allowing for optimizing the RMAP walk.

Test results
============
A rmap testbench can be obtained with two Out-Of-Tree patches at [1][2].
After applying the OOT patches and building rmap_benchmark from:
tools/testing/rmap/rmap_benchmark.c, we can start the performance test.

The testing result in QEMU is shown as follows:

KSM rmapping	Maximum duration		Average duration

Before:		705.12 ms (705119858 ns)	532.04 ms (532041586 ns)
After:		1.67 ms (1665917 ns)		1.44 ms (1443784 ns)

The benchmark numbers are realistic, since we observed ~20,000 VMAs
sharing one anon_vma on a production system running a Java application
with KSM enabled. The lock hold time before the patch was measured at
228 ms (max) during rmap walks triggered by memory compaction and page
migration. The benchmark reproduces that VMA count and lock‑hold
behavior in a controlled environment.

[1] https://lore.kernel.org/all/202605301703094695zmVgcSC27BNR0rH0N8_x@zte.com.cn
[2] https://lore.kernel.org/all/20260530170404509QpJmBtpSjn3uQHeVKA2iA@zte.com.cn/

Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 60c6f959d81a..454ba2eb46e9 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3207,6 +3207,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const unsigned long index = rmap_item->linear_page_index;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3220,8 +3221,18 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}

+		/*
+		 * Currently, KSM folios are always small folios, so it's
+		 * sufficient to search for a single page. We can simply use
+		 * the linear_page_index of the original de-duplicate
+		 * anonymous page that we remembered in the rmap_item while
+		 * de-duplicating. Note that mremap() always de-duplicates KSM
+		 * folios: so if there was mremap() in our parent or our child,
+		 * we wouldn't have the KSM folio mapped in these processes
+		 * anymore.
+		 */
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       index, index) {

 			cond_resched();
 			vma = vmac->vma;
-- 
2.25.1

