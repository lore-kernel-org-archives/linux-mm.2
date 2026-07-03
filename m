Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EC2CC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47566B00B8; Fri,  3 Jul 2026 04:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6CA6B00B9; Fri,  3 Jul 2026 04:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D546B00BA; Fri,  3 Jul 2026 04:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A83D6B00B8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:26:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A034140448
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:26:05 +0000 (UTC)
X-FDA: 84946782690.30.E65A971
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf21.hostedemail.com (Postfix) with ESMTP id 74C661C0005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:26:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783067163;
	b=AKidQLRcvH/iTQzveWpaQDEJt7S3qoU9M8B5A/SIRdMcX32P6OKIsJ+3P/+opowZAINS2b
	obDVvJxtEUklDHexXKsfmOnjLlT7ookjc5/VEuI75dzcc7dieY2VeO1cH+nBbJtEIjUDCV
	4k3L/neUvt54pk01e1VV3FMysWJBChI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783067163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qXryB378gF61ZnIJgEpFRDhysWY7WdpcGR/dbYzxjK8=;
	b=vMq43Nv5tlFxZ24XBi+OXS3WpJ5RNJGqE/RAcmJa6wiOnGptdLOWH1OyRjHcSTLbE5QZXM
	lCQumx8RfJFEiDPuWPjgU1njUlRxtkkTZFtZvCyWH1v5KoO4Q/Y6fl9bvw8hBSMFoMMJV8
	aJDtRTnKxtEsz3gKEAr7B5Z8EzCQvSE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gs6K05bBtz57KTq;
	Fri, 03 Jul 2026 16:25:56 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6638P80n051368;
	Fri, 3 Jul 2026 16:25:08 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 3 Jul 2026 16:25:10 +0800 (CST)
X-Zmail-TransId: 2afb6a4771e6293-92e22
X-Mailer: Zmail v1.0
Message-ID: <20260703162510242nxmjbcLy5ccp1dbZSK3EU@zte.com.cn>
In-Reply-To: <20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn>
References: 20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn
Date: Fri, 3 Jul 2026 16:25:10 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYxMSAyLzNdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGXCoHBhZ2UgaW5kZXg=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6638P80n051368
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 03 Jul 2026 16:25:56 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A477214.000/4gs6K05bBtz57KTq
X-Stat-Signature: fdreqeueqfezfw16azpzbpjgos89aq99
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 74C661C0005
X-HE-Tag: 1783067162-691307
X-HE-Meta: U2FsdGVkX19reQBL93YZhO8PygiK/mt7KqD5+RXFIAuads9q/ZSSoh885Ay92jWOf0877m54HuMX7n4KdBABalFxM1WytPsAve6nDgMusfBMfZZ5srF1+vxanPhLJy84KEzRN/fkCGxIr/K1xbJv0PMCATgOK2ST1QTa0ZchHLtp3OoozbsoLLBzOz7aSDSYCconLH1sH2TIRGvN5JMfJWh6IJuK4Vcdcfe9xe5CA8pSGy6Dchmzqgtzb8eAX3FHPE+XhxGxj+uUBNbQiV++vr5JOFv7iIVOl1l7zKNsuZFs5J32gcSn4p42eWVFvwqvpvKyhVYGgenctk/y1RHglDcdgI363rOFdWBajvfjQjyHBVFn04n/yonCa5KxsoASQIL8COk9A0cHal7FhzSm9FWwu36iG6WQxoBsnTo44PR/S19V4F5CscFQbWJFBh9zRou/tENeoHfXQ2bHGQT/SuOzjhn6Jv+Fuzfx57Ku032J4zZrMCGy39a++fESWDtpFKwZWue+VHb3Wdp53/znmxlmr/g2BQc5wFdBr2K/D2f5kiGyWLgsvZkcaVFo3BXu4703tbLEI0ieP/1L9S/thJUY5lEsxjDFIzBW2nlRR5Qz60R4yU+36vF6F1htdPip44D+ioHObYgpFqv6nFU1+TjXx+napG/Rr3XBirfH2TFeVyJXEIqpHNGlvTxlk03lTMXOKExTRcstkGKWuUlIxVxvfXSiWImF7rPmRvEc5Xh3XP/shbxM5qgCRMcIR2w5CnCOZ3uZIrr4Qc8zVyWOPRgy5GqP1iXTtXuxZdDQnvsVjDlL+GBEWeAxcaTJjSVu9u2Nn6gUklPLmmKOiGmv2ZeGPUtivJZq2Rpg0jghys8F+nsZ4obqjohXv8p5bmLhSH9pmnfYAZXCB2BiRE/TOqxwcmfiDFqQGMoFqdw0/LsX3BpzBZs8VaTJrb9X+Ee39qeB5f6FFy9t3H608Nx
 VbJv0a5Q
 1t88LYM0FvBCC4Ux0DT1OCYNAkkZKkJz+jV4BhyuOW4333cWsulNP3SfZHeiVnjhq1H6Gwbes21I+2C9w6rdJjuy5S8K4Dax96sUEwSwCcmynI2njfuqPL0ICkvIcyF+z03BZ53DNaZXZ3LdhRz+0BqVpwt+3zXlSmNPQY80qqS8qzESHcU99ttZsuj0K18D+4FpPxRybSTCO6+UtxUQ8SCgK5O4LFl1F900+I9THgDCIwjCPjNbYk7ANzV3SALJvR4SWxpd18V8GmexJD5vuETNRg0sxKF0QZ+gHcqIRl4CzniXPIfwMzIBFQ8Gco5286u01/TcPF9RvjI4=
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
2.25.

