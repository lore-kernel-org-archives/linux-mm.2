Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A045FCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36BC6B0099; Thu, 11 Jun 2026 09:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7316B009B; Thu, 11 Jun 2026 09:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23F56B009D; Thu, 11 Jun 2026 09:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C23E36B0099
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:21:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F0CF8EA85
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:21:47 +0000 (UTC)
X-FDA: 84867694254.10.99F8E92
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf23.hostedemail.com (Postfix) with ESMTP id DEA1D140006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:21:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf23.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781184105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nb+leNmDuDT8F3/hr+jBl62ymHPLvbKegkssvnF8LGs=;
	b=xX4fuOD7x/Sld26SiBm6dk0WCkLYK9FEulVxPkyQUueBfNOWDl2zHfr7QVmpHjh3Yv1HQA
	OAsMVAefzaBr+5ylgXs2yOaLwDtoesMEnCmi9geOVpFKSsWsD+Mnfu5jBfBhgBcFy8cjcl
	SkaBS3NeI2l0/YT2wF6dInRBsrMHfow=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf23.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781184105;
	b=2w28fax6OMsXawdn1++iCJ42IfYGLN4JbWUBLAbLLiK1X75r2sz6Kg1MustuPlVoGvSRbK
	2y2FoJPjk82vq9d6XhBFuJ9LOQzsaTr+3FP17YsC3Zyx8cXR0hOCCaLdU92a5YPOU8dM82
	1FK+zYLiOFRGWe4w0tol0kX8uRH9mPs=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gbjwP20wJz8Xrrd;
	Thu, 11 Jun 2026 21:21:41 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 65BDLZif054376;
	Thu, 11 Jun 2026 21:21:35 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 11 Jun 2026 21:21:38 +0800 (CST)
X-Zmail-TransId: 2afa6a2ab662fbb-95d91
X-Mailer: Zmail v1.0
Message-ID: <20260611212138619BRrXoKru-JeX9_5F1yX4l@zte.com.cn>
In-Reply-To: <20260611211311025VA1q1gTA-X5NMF0aZjnvh@zte.com.cn>
References: 20260611211311025VA1q1gTA-X5NMF0aZjnvh@zte.com.cn
Date: Thu, 11 Jun 2026 21:21:38 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY5IDIvM10ga3NtOiBPcHRpbWl6ZSBybWFwX3dhbGtfa3NtIGJ5IHBhc3NpbmcgYSBzdWl0YWJsZSBwYWdlwqBpbmRleA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 65BDLZif054376
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 11 Jun 2026 21:21:41 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A2AB665.000/4gbjwP20wJz8Xrrd
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bz6yeifa3awq9eidhje7odrwsfc6qr43
X-Rspamd-Queue-Id: DEA1D140006
X-HE-Tag: 1781184104-789989
X-HE-Meta: U2FsdGVkX1/JkhP6iMHNPA0XxE9AEK3VU/lvbd3CDVCjGmVFWR97dcicZFCWzmbiXpFeKqfFveX2TxH3oT/xHCxxSVrez22t//9ndwg3WXo3EFq6U6n7EcBcpNyxxAS4GqifaZus5xlk6g0EhJXg9djg2YREs6ptzsf4UWWu2mduICaddmV7LJe2h/y+4wbOC4EUCuzs2O1ANPlSFOnVqfDWemv6/8X5hOB/ZSwJ9qPcA1KGbJ2+4rzUqPN/DAnfQkXMJoD6QVAEyweENoENnmhn3+7pCc9B1+39R1pt2af4wy/yN8cXMMSndoyuJIRuNUQdA1BNaPPbrzRDNKaZrtm8cWxPIOlAjvmTaxW6r7iXc0dOMjs7dW+exXB/rO+ns+tsvxP1NxQ7FjFWipBh20g4JU9hpRtDpl6DPp2WNZNYm7fUUYVyVXq+4K5bX2dCO/7m/LnbefCua9qIfrbXNQA5u5C36Bg47UzXW1kE0yv4Dl3FM5RXLuXAxaKfpLcrgC/B7h2m+C/5O10IM3MSXhD3oSoBqXCjlnNGvzcHeVDL9aeywdRJ3JyCrvsmRXvkoisw3eiHlpDJzkSUWn5MJD2B8EkyMLMlkXJe2vhkBlaiGs0+WtOQuwzNTJuh2bHTTRo3ONxT8O/GS+XiWV8dBFiZqRnIZFJxa8x1n6dz++UqMsZCWhqB4Wj2oWxSO2SzcTQ4vavzfXU2jiwNGZ04+DcIxQU2EjQqZ3vqZPaYjNTsC+TabP06P7t47itGF+iXQio6sJiXTAHXsxntVau+HW37YsN7hXBTkkjKjbEyl0c7GtpdNIKmow+50eBQAAxjliIjixwPyKP1M2xUECmWnG1YdX5KFhvNNGcvhcId7iBvLn+nPR3R9uFvSme1qyUFV9Gp4VDrm/lZaHFTKOg/EF8k/m0NgF2fP0Db3CCxOSsjrtcRerZAk3EGc2cvcqyet/6LSOVJXQhna0K+9Tk
 f1Nn98RT
 Jn6+8R1UQqP+/ZVDIgilI5TKh2F/dAO11pkvVGVd4xfKIeUicnMBT3DayazDsa5UtdOrU8kp0ysJ88NwAXnmJaYolGJ1ZcdkYxffUJCHyfqRrY3v9yDltXvnMveRLBirj23Cv99Gsqdv2mYecskZaxkPTNr88NoqGQ8RRg2ocwumYCTC7B6QDY9AN+DWbeDb54dJA9U9Cz2tW/2td7nEyScWog3IwzNHWxretzbwJCknCT8qy5xTURRZNg36VwSDWrs68KclwU/eJGnuO1JPLuRcHXk57OJrtuWHOwGa7di4ShmlFWiJElfMZrb77+ZGyLC3EWvWsvsyvvF8=
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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

