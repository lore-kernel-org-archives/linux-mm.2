Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3348CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D916B0099; Tue, 19 May 2026 10:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E386B009B; Tue, 19 May 2026 10:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BC16B009D; Tue, 19 May 2026 10:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2828B6B0099
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:14:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C462D1C1425
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:14:36 +0000 (UTC)
X-FDA: 84784364952.19.2399D28
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 503594000F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:14:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779200074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hTlgPHi81bFv9I0uqoXAjxUyDf2nnFaqH/Okosg7eFU=;
	b=ratTe8E7C0R/MoElhshz4POEih8c8k1XW3Gjd7bmPSePu/eGBsWpeIJIP0Xj4zu1mmwTQ4
	cWPw7H2P4FyKP7nHzTJEpcGon5JfmbAVZTlLI6BDC7vi+0tjolmiKptHw2ctTxLehQuOAG
	ONzypU/Q7QY146w2itapWbWTiXI8Ux8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779200074; a=rsa-sha256;
	cv=none;
	b=XeT7cgkD885Aa4tIVoZ7d18xMJa1oFfNwDpEgwZpHd7qg0PviDe97JAUBZSCatvQswQuUc
	wwFhOZ0KPfrJV51d66PlWBRD3FsPdhm8O1Ymsml41z459twMz5SRws5KzJ/VHflPuQ7SDl
	Xo48zvVXq8yS0vtKNIdcUMJBhvyDHbE=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gKc9z57cfz57DCd;
	Tue, 19 May 2026 22:14:31 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 64JEENPi060712;
	Tue, 19 May 2026 22:14:23 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 19 May 2026 22:14:26 +0800 (CST)
X-Zmail-TransId: 2afc6a0c70424a6-f4a24
X-Mailer: Zmail v1.0
Message-ID: <20260519221426579UmohTh1ABCHAeJWQ2gA7t@zte.com.cn>
In-Reply-To: <20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn>
References: 20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn
Date: Tue, 19 May 2026 22:14:26 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <hughd@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>, <corbet@lwn.net>, <wang.yaxin@zte.com.cn>,
        <xu.xin16@zte.com.cn>, <ljs@kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHY1IDQvNV0ga3NtOiBPcHRpbWl6ZSBybWFwX3dhbGtfa3NtIGJ5IHBhc3NpbmcgYSBzdWl0YWJsZSBwZ29mZg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64JEENPi060712
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Tue, 19 May 2026 22:14:31 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0C7047.001/4gKc9z57cfz57DCd
X-Stat-Signature: 3mxd7fenonnrpy9syj6ghg6u1b6gh7am
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 503594000F
X-Rspam-User: 
X-HE-Tag: 1779200074-319210
X-HE-Meta: U2FsdGVkX1/aLWPbhjwZ/Pd6DDPtwGR8TRu/sBIcvrlGUFzML2js2/j5E0+6YKmX2hrY1kH7m/g04qMDNQzKeOKY8UoaTzoqTVh82VrJ3xl+rvT2A24iYKoTamik0/Bn8GML6rWLkCIVy5hrIGM8ovpUWku7+Sy8augY/aQ2h4rLtjVfcnoeDjsWU1G6t7onWLSxrtQux/3UDIbwaeT5U55oFZL3GbIQuev1smnAV2VT1RjjbqjyITo6TK8+Ac7c3i4nDPIBES5+z7SQQH7oCutJPOlIPBag0RTvgwG+pcjsd7/6/rdJAIYxLRadAa99yD7lxTTkWqJpZUHiyMfhYyp8GIn7Ey6eDsM6vc8OrhhzLnIOqLUtPzMzw2G2lyJPFlfCZVlnAjfr1lva0aT0UtgC9JCZpcfza0MF4sMCRhaD+aSBKAQBZIZfgsH/eJOGt/BK+Xoa1DODW8MPfCnXXWTa6RYV0g41AMppZB8sB2ppXS0ZGy8bIwCbO/JVelSwL/w4RPNRWItyvLmJ1VR56W+Ct5Hdz3l9eWC6jI7WyXa25ylz2AAYDat1DRk79cSLsZtHwF53iUXnxvWQF6WkfPcetdupg3UURPEMAQ3eJwsTrFgE4cxayzBDO/WT3xRnk/RFtu0ioTIQ5TtLjHKeOdhMCRH4P6AD6WrqoteZpW5TQSRZ0ltxnrRkkeAGH4DikoQ5xB/n6JyPXpusvdEyAcKS8VF124MLgYw+n+zX/zGFGFmoXcM0tsIVYfUAXwk3d1BUSvDuVgkxSomN/cu1JI6ygqJYByZiGh4CdTuwEyYeK4UsFFtCaDhEyGuxx1zKuqhiOQLrCCAPjYbW6P+VOldBCEX6Axh538hmSokjQcBQ+93Pa7I8c7aLiILzIP10/NF0Q9XfapiflH4OgMw29HJ52OkA1U2OnQNkiVQKowXKihP8AgGmOGD5mcBGTrTUiwy0p3b7g9uxUfdQxYd
 9rjXmVnE
 Mx94L++NXfNTRq+hsKd90vBIqnBecXsKrC6d/zrk9NIIMKkU6qAYyH27gg2z/j/Ko2JwmwISr+64RNHvddE16sEFhmFEKP+vL+lPOG+8J1mUVmFZJPDP0zxPhGHYjuksOBhRKjlzTVbyelqMOPWCD/uiHiQVJoQ40UHBq20qBlfW8y0I/cMdDyNFgldUGyOZTGXgtoaEAUJc7EIvfbOlcKDmFuADUNru0yFH+B3edqSzuwwbo6TxUfgStucoYKEsUxtLKz6YHviiqH60ghFBLCoNyzgjIaiIe4ZXD3yKi6SwdzYDHxIUPsZslfb+c17TzyTonFEqccBw7hu+fHZ6Gypulow==
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
walk to locate all page table entries that reference these pages.  This
walk must traverse every VMA that shares the same anon_vma.

A large number of VMAs can attach to a single anon_vma not only due to
fork(2) (COW sharing), but also due to **VMA splitting** – for example,
applications frequently calling mprotect(2) on different parts of a large
mapping, or memory allocators that use madvise(MADV_DONTNEED) to release
sub‑ranges.  Over time, a single anonymous memory region can become
thousands of small VMAs, all still linked to the original anon_vma.  In
our embedded test environment, we observed ~20,000 VMAs sharing one
anon_vma without any fork – purely from VMA splits.

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

Problem
=======
When available memory is extremely tight, causing KSM pages to be swapped
out, or when there is significant memory fragmentation and THP triggers
memory compaction, the system will invoke the rmap_walk_ksm function to
perform reverse mapping. However, we observed that this function becomes
particularly time-consuming when a large number of VMAs (e.g., 20,000)
share the same anon_vma. Through debug trace analysis, we found that most
of the latency occurs within anon_vma_interval_tree_foreach, leading to an
excessively long hold time on the anon_vma lock (even reaching 500ms or
more), which in turn causes upper-layer applications (waiting for the
anon_vma lock) to be blocked for extended periods.

Root Cause
==========
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

