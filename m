Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C5BDCD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 09:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E050B6B0005; Sat, 30 May 2026 05:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD576B008A; Sat, 30 May 2026 05:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD8A6B0092; Sat, 30 May 2026 05:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B80CD6B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 05:09:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C6B88D286
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:09:47 +0000 (UTC)
X-FDA: 84823513614.20.8E6DC3D
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id EEABA10000A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:09:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780132185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JFYzluw4wVZxsOPGF8RYpu47556eohkgroQQAX76KsA=;
	b=LX8KVccRpUGKYu7QltBadL/Y3cOQQjJOBKTtt7R8btBN8+kq+n0JVAegUsr8yyUSruC/K5
	AbehSFExsLD9pGL9xXXZRr5omBT2CizdZjFjH7jjpRmLzBpaCndoMrumQsHB2l+h9Kd1cF
	bCMWrsJNd0BPNN4KfUO1/7ea1C26hmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780132185; a=rsa-sha256;
	cv=none;
	b=4oAVk9C6RXZTzWwwwLjCmZvRr16j6FlyfBIDB9udMOAUhL3Hiymf86fRHJGjyrkDSbdNYH
	tdZghTsKGcrNHcszvD6HsogKCi3MAvGEKKrOgxW8Wlrf96SknPXGCEinZWGJnrEuvSOKY/
	8mc5Amyt2Elgtm14qhiK8PjWKU/5aCc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gSDv94Rk8z5BNRf;
	Sat, 30 May 2026 17:09:41 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 64U99Xrc036532;
	Sat, 30 May 2026 17:09:33 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 30 May 2026 17:09:34 +0800 (CST)
X-Zmail-TransId: 2afa6a1aa94ec63-2a360
X-Mailer: Zmail v1.0
Message-ID: <20260530170934343YM7yiZrS2RbZYpLrAJWHN@zte.com.cn>
In-Reply-To: <20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn>
References: 20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn
Date: Sat, 30 May 2026 17:09:34 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>, <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY3IDUvNl0ga3NtOiBPcHRpbWl6ZSBybWFwX3dhbGtfa3NtIGJ5IHBhc3NpbmcgYSBzdWl0YWJsZSBwZ29mZg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64U99Xrc036532
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 30 May 2026 17:09:41 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A1AA955.000/4gSDv94Rk8z5BNRf
X-Rspam-User: 
X-Rspamd-Queue-Id: EEABA10000A
X-Stat-Signature: 9dyum8dhnnrbtthbdu5abhn1oqm5q63o
X-Rspamd-Server: rspam06
X-HE-Tag: 1780132183-997272
X-HE-Meta: U2FsdGVkX18zhFqhadbAZT0eo5BvTGszx96w7H7gcT/BHDTT1wcXC7MdRMfNFu0KOXOpsYT37e0w5KSHE1hsw5aKbfT7gmLArQDUFoN6vGTJ2xh/T8NwtfIjuEEBbLAIP5pM/P60t6zqUrARUnw2CeIxyNdXIGHIKC1jCVazjwv4umh8j66aon8439urNuiOpsvBwr6U0lijAbf7ok0wRPF/MSUnt1SFUj75Tx3P48/gRfx3U24RM3DEwgSt3Ef+dJpUu6Y0wxQ5T2idqmGSF7g2kHxw2aasTPMKpJS8JTO1ODZ2qPpYdJwluQHt5uQ0SOILg7u6BIsXr5GIMf4kRtvOTbmt3cRAwYydEAccDGsKn6QIo0xzBZndPPvP74KY1eFUKTxFsVWIIYkmV3fgeGsLf3iafckvltuaj6ryrgoLeacYAPF8ntUuPSqnvvN7PhUVgQ433qMkJinBQoIE5fds3M7cxjV1k6oGgedVbin8EMrPq7lEXJXn1rNUV+i+4tUvA3gFgXkgFhBCvzdEt6Xbz4dUhF6vgc95TBPVYXqeJPeddh9O68iXmIrBTOxkbJdTf2eQa/dZrypgZWT2dvVGe2MvwEzHkZslSih0vtdCjjaJcDD0Kc4Oo1gv5qmqhFRLzvbeo1Ht494vJUQSmKvyOsBG1SD4byRbehZnPbV9hnw8rg6oTGMaaOxSIchxIQrgj6cjm2PghvV15Z2dCWOtQgiFbMpNFOsfel2/Qwypv4DBfLPmQatfEOsyBuBlgshpgiJi362n0JVkEa9HYuGZMcZrMkrixPIq5j+ho7KWiywPjklfoLjzc/nP2pWJT2z5MmYbAc43kTHfup4kPFHATkTDb+hvoFf82UDiZoC5o+UmkxWLQOO2eRxTtOFc1YAOaR4wyVI8LgxVwG4gHsKCj5Axic1sIZgbHsKQfY25UevcRRmei7EtNo6zaKd31IrcjqiYhvNlLwsuG7g
 EXRhV7Ru
 hD7EDQgaDbX8Z2MmuBjfCFoQJqw1JRqg1zz9HDD6oEdRTc9Cq/rjPXm9cDVhMGr2MGdPU5VMK4dr0o3va/yzapmEFjiwQ2DY4b4NxNok89ePFt3g9SglPGC/URkm6cL2eUW1yy63xTL3nSdcNFfOm0wHLMPhDoxA2rWn5a6xaX5dTEdOGfzJt0/uXoG3MQQEUZ+OShdrQnEwU+vvU/5/wGMmBhFbg4dygiMsz33FKy62II21AY4dG9MkRkd4XRXssqSxbEWomMmE5zzG5nv+gjko5Pa4rUTM67gt3syfcUB49RbFd1Tdml3H9Up5YoNoDwLkrNKAmmXN0+6sYlAjm0Jk+Wg==
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

  • Page faults: do_anonymous_page(), do_wp_page() (especially during COW)
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
or anonymous mappings are managed with madvise(MADV_DONTNEED) to release
specific pages, which also splits VMAs.

* Why the benchmark numbers are realistic: We observed ~20,000 VMAs sharing
one anon_vma on a production system running a Java application with KSM
enabled. The lock hold time before the patch was measured at 228 ms (max)
during rmap walks triggered by memory compaction and page migration.
The benchmark reproduces that VMA count and lock‑hold behavior in a
controlled environment.

Root Cause
==========
Through my local debugging trace analysis, we found that most of the latency
of rmap_walk_ksm occurs within anon_vma_interval_tree_foreach, leading to an
excessively long hold time on the anon_vma lock (even reaching 500ms or more),
which in turn causes upper-layer applications (waiting for the anon_vma lock)
to be blocked for extended periods.

Further investigation revealed that 99.9% of iterations inside the
anon_vma_interval_tree_foreach loop are skipped due to the first check
"if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
number of loop iterations are ineffective. This inefficiency arises because
the pgoff_start and pgoff_end parameters passed to
anon_vma_interval_tree_foreach span the entire address space from 0 to
ULONG_MAX, resulting in very poor loop efficiency.

Solution
========
We cannot rely solely on anon_vma to locate all PTEs mapping this page but
also need to have the original page's pgoff. Since the implementation of
anon_vma_interval_tree_foreach — it essentially iterates to find a suitable
VMA such that the provided pgoff falls within the candidate's vm_pgoff range.

vm_pgoff <= pgoff (original linear page offset) <= (vm_pgoff + vma_pages(v) - 1)

Fortunately, we have already pgoff in ksm_rmap_item in the previos patch
of series, so that we use it to get the pgoff to accelerate the searching.

Test results
============
We provide a rmap testbench: tools/testing/rmap/rmap_benchmark.c
The testing result in QEMU is shown as follows:

KSM rmapping	Maximum duration		Average duration

Before:		705.12 ms (705119858 ns)	532.04 ms (532041586 ns)
After:		1.67 ms (1665917 ns)		1.44 ms (1443784 ns)

Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 4761ca3fa984..7fe1a8753309 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3200,6 +3200,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const unsigned long pgoff = rmap_item->pgoff;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3213,8 +3214,12 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}

+		/*
+		 * Currently KSM folios are order-0 normal pages, so pgoff_end
+		 * should be the same as pgoff_start.
+		 */
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       pgoff, pgoff) {

 			cond_resched();
 			vma = vmac->vma;
-- 
2.25.1

