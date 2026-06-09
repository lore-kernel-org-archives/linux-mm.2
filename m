Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D10CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 04:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17CCD6B0005; Tue,  9 Jun 2026 00:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107346B0088; Tue,  9 Jun 2026 00:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38046B008A; Tue,  9 Jun 2026 00:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E37CA6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:47:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31B63164486
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:47:14 +0000 (UTC)
X-FDA: 84859139988.16.AAD9330
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf05.hostedemail.com (Postfix) with ESMTP id 83AC4100003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:47:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780980432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AKlO42fFPyST8BKqpEyePU480PrCTAOh9mq0itKVS9Y=;
	b=wkE8cnjyWYcGHW4N6nMI//Qb9lysoBtYC1wP3W2byx1SBKmgF0P7HVyThObWoBFRjKgesq
	igg/ytOVpTsRtFpkxRfDoa/FTBRneKGqhHzPEo7LrXINgK4jyHpzh8I8wZmW6aM8pMeGWX
	BXma6tiJiafz2g2Izhs/A7IzCQM1J28=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780980432;
	b=Dc/5sw0kooX5u2Fy2judWTfkEp3R6MGssq6ZmFW2mrNHcNcZmAgYQpqLcW67z49eRO54u0
	gV5Em2Qz7fDCvRkNkvsgwb07uA2o1eqFkkL4ATHrVocFdVMkwyiS0sVLwejh8kmcarUBK/
	JIuZ+E8HrZG1CU2EZHF2+sL2awNn1aA=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gZGbd0m4Xz8Xrnt;
	Tue, 09 Jun 2026 12:47:09 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6594l2TW043114;
	Tue, 9 Jun 2026 12:47:02 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 9 Jun 2026 12:47:03 +0800 (CST)
X-Zmail-TransId: 2afb6a279ac771f-05576
X-Mailer: Zmail v1.0
Message-ID: <20260609124703736MQ6Jkpc_7wR7HaeDDPk6k@zte.com.cn>
In-Reply-To: <20260609123931349fw0hnPPf7UBWQT0P7Ej2L@zte.com.cn>
References: 20260609123931349fw0hnPPf7UBWQT0P7Ej2L@zte.com.cn
Date: Tue, 9 Jun 2026 12:47:03 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHY4IDIvM10ga3NtOiBPcHRpbWl6ZSBybWFwX3dhbGtfa3NtIGJ5IHBhc3NpbmcgYSBzdWl0YWJsZSBwYWdlIGluZGV4?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6594l2TW043114
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 09 Jun 2026 12:47:09 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A279ACD.000/4gZGbd0m4Xz8Xrnt
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83AC4100003
X-Stat-Signature: 6tf3445fekcmufeqjoxh49hh34875bt4
X-Rspam-User: 
X-HE-Tag: 1780980431-676227
X-HE-Meta: U2FsdGVkX19tC6CpJrS1O02kVTRlOUXLkPtDAfCFz2CjYU/7NW3H6yZkSkV/eSButec7q1xEnbAH3Jx7xXWn7zpkQa8rz9yxEU9SflMfqCp+RSAw/u4oIuInG5Qv7d/HnPZxd9gJRpX4hZlPJKVzbKSyEHCA4kIvMAqhSRLvUq+kSKI5hntc2zJG+IEcLlIy0KcN9w1xrzjgFE9n7s33OI9qZnSZoN9H0xREYq1HpA4fgLdcEf/JQKAAk5Nu1Zo6N4MfP5WKYCCHwN9pCYalIOBn9vNB2b8x21ib2YEYnproJbz5eKihPoV+/xWTl2wTSdGhF+Uirdawx0M4doX86UurlFr4JQDo8y8Ig4WeLYvoZHU6AFHtVC5dEChnFQpg6IEzt0p89EIpliNiYP7jZ4sSvArY4ne+YZcYTzr1hm6fIZUsjWlI4bShHV0hZNlqwNVa70OI0uRAXTp79c6T7uhZgdnDbB8Jqpk9gSIn8yc1wz/w1CVoXRDhc0He0PJwMuzpHRh84TViRr7QVBkMyXyUbiRRRpUvj749oTZrCBBjAticegVMiOqK21cjUzvrWUMQItCn/VNO/6rMT7KYE4q5xPhhZ5hq+xgdcZrbBo8Zi5B9pWPUC1mfDsAIY8p6liAFVEbkOdxzUlgEUx/uOlt+EyIJlAS6N7NJnpP+CXNwJS+HX+wM4FJti3autANvTaibxxujrlgmszNxmUs5TC0Bc872RwJuTLr4XoBpqGvV2GPqHW92PkkIXqgcaDvIXuMQl0ry4jaB20bdOdb2lKCYG5K/5qR2m8qQCy8gD5uKqbXeYbum73pxqPvpHyAOp1/su8OyKfnGnjv2ViJH4vM4RNUFQsP3YzRd3A5uU/NydSABTPA6zzhpZAaL7hYVmFHy/xQRAtX3MTClU1uEX1V2mWBy9Q127zLRFg1N9Ts2/vGTT6+BKroH2BJFwyEoUtPWVY65n5+TlgrDYsB
 TGXOFWq7
 zTyiKiM6YBI5YRKYYms7jwGeTlsW/Fpo44ju5NbKh47MkPN6FyMtvpgGAkwG2x5YdWNX5nBudNfQmU8PGri74rYbmUqcz9MZ1oUU5iG0i9VoUW20OefOQCEnCfuBB+knn/gTP8ciNLHMgS9th9NHZsIx6zFbF9Ep3yxiDBlB3AZ5jS+ruu0S4izU6SdDPZm4TE5L3raR6yvI/7TTl8AWEOQSTWmQU5gm6Y5PSozUQFfmVs0MGBbdsZDXbKreIMK3HBNSIibaLF2190Hyhc6Ji8bl8zGwXygTIllLDzUxZ+Qk89evXYLD5WBdSbpKDRpTByv78Vdn5a66zOV93aMSod9utdoTbrR6hlBl/j0b8PzJcwas=
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
because of an inefficient KSM rmap walk, any other thread that tries to
acquire the same lock (e.g., an application taking a page fault, kswapd
reclaiming pages, or a migration thread) will block.  This leads to
stalled application threads, increased latency spikes, and in extreme
cases container timeouts or watchdog triggers.

This patch reduces the worst-case anon_vma lock hold time during KSM
rmap walk from >500 ms to <1 ms, thereby almost eliminating this
source of lock contention and improving system responsiveness under
memory pressure.

Real-world examples:
====================
 - JVM / Go runtime: These use mmap for heap regions and later call
mprotect(PROT_NONE) for garbage collection barriers or guard pages,
splitting the original VMA into thousands of small pieces over time.

 - Database engines (MySQL, PostgreSQL): Large shared memory buffers
or anonymous mappings are managed with madvise(MADV_DONTNEED) to
release specific pages, which also splits VMAs.

* Why the benchmark numbers are realistic: We observed ~20,000 VMAs
sharing one anon_vma on a production system running a Java application
with KSM enabled. The lock hold time before the patch was measured at
228 ms (max) during rmap walks triggered by memory compaction and page
migration. The benchmark reproduces that VMA count and lock‑hold
behavior in a controlled environment.

Root Cause
==========
Through local debugging trace analysis, we found that most of the latency
of rmap_walk_ksm occurs within anon_vma_interval_tree_foreach(), leading
to an excessively long hold time on the anon_vma lock (even reaching 500ms
or more), which in turn causes upper-layer applications (waiting for the
anon_vma lock) to be blocked for extended periods.

Further investigation revealed that 99.9% of iterations inside the
anon_vma_interval_tree_foreach loop are skipped due to the first check
"if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
number of loop iterations are ineffective. This inefficiency arises because
the start page index and the end page index parameters passed to
anon_vma_interval_tree_foreach span the entire address space from 0 to
ULONG_MAX, resulting in very poor loop efficiency.

Solution
========
We cannot rely solely on anon_vma to locate all PTEs mapping this page
but also need to have the original page's linear_page_index. Since the
implementation of anon_vma_interval_tree_foreach — it essentially
iterates to find a suitable VMA such that the provided page index falls
within the candidate's vm_pgoff range.

vm_pgoff <= original linear page offset <= (vm_pgoff + vma_pages(v) - 1)

Fortunately, we have already linear_page_index. in ksm_rmap_item in the
previos patch of series, so that we use it to get the index to accelerate
the searching.

Test results
============
A rmap testbench can be obtained with two Out-Of-Tree patches at [1][2].
After applying the OOT patches and building rmap_benchmark from:
tools/testing/rmap/rmap_benchmark.c, we can start the performance test.

The testing result in QEMU is shown as follows:

KSM rmapping	Maximum duration		Average duration

Before:		705.12 ms (705119858 ns)	532.04 ms (532041586 ns)
After:		1.67 ms (1665917 ns)		1.44 ms (1443784 ns)

[1] https://lore.kernel.org/all/202605301703094695zmVgcSC27BNR0rH0N8_x@zte.com.cn
[2] https://lore.kernel.org/all/20260530170404509QpJmBtpSjn3uQHeVKA2iA@zte.com.cn/

Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index e0ba29e3c0a4..9e1879d96751 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3208,6 +3208,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const unsigned long index = rmap_item->linear_page_index;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3221,8 +3222,12 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}

+		/*
+		 * Currently KSM folios are order-0 normal pages, so the end
+		 * page's index should be the same as the start page's index.
+		 */
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       index, index) {

 			cond_resched();
 			vma = vmac->vma;
-- 
2.25.1

