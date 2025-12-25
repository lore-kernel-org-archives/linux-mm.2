Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A0C6E784A6
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 09:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598146B0088; Thu, 25 Dec 2025 04:47:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545F86B0089; Thu, 25 Dec 2025 04:47:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451A16B008A; Thu, 25 Dec 2025 04:47:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33A776B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 04:47:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D14CF8B9BF
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 09:47:43 +0000 (UTC)
X-FDA: 84257516406.30.169C2AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0B397180005
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 09:47:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sy3CW1cl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766656062; a=rsa-sha256;
	cv=none;
	b=yGSaBaqgsqr1aO3o0r9D8zw8H0PLZPoE/X4lAnC5K9NSUNoHPJAyfuTn+MQ6eXlkPdfWRR
	hAlpnen9+4Gyol6x15MWve32HVJwuYXIM9VJyExzCIUrEBaopt+Ah6esxN9bMqY5V1CoG1
	x4BylNTYm7WQuxqJFVrWJvYlxkVGtH4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sy3CW1cl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766656062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZXTP2ZUk4arfREjkMm6Q4PS3AP5arrYTzHbTKPmO8w=;
	b=ECr6wQbAYyUFWJuz6sz2N+VfiNw81dE7Uzbmpd0RrOkd8v6WCXVGgQhHG1p6cXAApvy+U+
	zMx/hEjdYlvu6GHvyN4aI0AdRO31+KrBU95rbnuJTj5nYCKX0JCU8U9MdvTimGLiYtZ55v
	3A78/mNo8E8ruBc7o7EzryDbL/tcTiw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2ADC740612;
	Thu, 25 Dec 2025 09:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31718C4CEFB;
	Thu, 25 Dec 2025 09:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766656061;
	bh=4iBf9Ig+t1xZ4dvyb20eBO6tby258MpacRjtRiuO0x0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Sy3CW1cl1V3JPg70g8bQsB4iA48x8OjbpxmQgLkgWCBxjDa/fzZujnEiktu0asc8W
	 EgJNXpxsQNA3GmAva2xgyf7XtosKOHAm5KVaHeZLxbhBCra2qoZBHXy8+zRehzGgVJ
	 ybiG8m1WcwgntsV43LgQmro+YiovZx4zqyM7TFiDdNScPYSRLKmcqe1QROJ/NTDn0T
	 5UAZS4Z6cv6d4irIbm5f5d2u2UAzRef6Y3nLoFGCTDFsLEXvhzVk87CuErhbuokTe9
	 WxtgpfE1EZT8EnaSKuVUwcBIsm2et6EEIWuvoqYu+zdLJL23l33c9NGF4yKnfkF7b4
	 EHU5dKggAUUhg==
Message-ID: <f223dd74-331c-412d-93fc-69e360a5006c@kernel.org>
Date: Thu, 25 Dec 2025 10:47:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 4/4] mm/hugetlb: fix excessive IPI broadcasts
 when unsharing PMD tables using mmu_gather
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Nadav Amit <nadav.amit@gmail.com>, stable@vger.kernel.org
References: <20251223214037.580860-1-david@kernel.org>
 <20251223214037.580860-5-david@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251223214037.580860-5-david@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B397180005
X-Stat-Signature: ssbammf7ac991gmun9mdannwn4y8t8yw
X-HE-Tag: 1766656061-300012
X-HE-Meta: U2FsdGVkX1+N0m34PyzNN18Subdlu6y6y2olOtWgDdlLg7ZD/Fg0w+P1l3NU7oa4mMi1GWwbNSwCvl0lOUY/Zo9p4vytPiMZZSoLNirip6Pw79j6NL9F+JeWRkf8imr7vwdfRIXgCWcntu5TrMG4PW4W8KMYwbfz0/AORYt8N2sT/is0BCOFeEwZs5baGfCVAGZjy/8lW7NhK38dHmze7FnBF2P7gRbuftLhw5H8rUOq9KBglj325pXuGPXQM3eq2DzBTRI0W9YsWeCdpGYg4PQ4mJCROochB/1etQ3/7U+sVDhqacInzP9+GyDysdY609OH6manKLHcGjuqLknYvq/wv6CuQ9b0n+vfix/47NEeOCcfgx1oPvPpYC4n/dhrIWUQFMCalfel5hbTN7CYvF1fUB1ZEXzKz+mGUnhRzfRkrEUD/DW+17ltUNfAI/JhV0aZneG9pEpp35H2v67mNvg57H1tVAuDMy2+8fhE3kUKAzwyfSGV2AkQAOu1ogwC/mUw7DLsxMGKXreayO/Q7MHQ35wjBMJD+aw4JObj5hx8z7cQ5hA5LOJFkP1qI5n6OQORzFViDzXK7Qj8KvSmt/hVmQsk4kTw/h4HxTd6knKAnoWcBT0cabmGBkEes0ctY5S3NkGWk0K2gUl0T5bLklR5LB8GCdvs1KCK7SgPZ5Xcq6DGD3GIsXlvnYSzctdXcwro7HpINCBMRF/Ayc1RELMt5M01qBsLO9pc5q82DUfp6NRReSG3lSeplbOyMhaUpElh7mYU2y02k/bKAvuLNBGL4Nk6TIwHHiZpkdK+mieU+P8q3m0ipMGQiJlkCrtHRASMmDHVoBC0btCCTP3X4yPcJH9tKe9++jaGHmsu8IJ3wOTUHJjn7sfgmMse/2KiegFYiMd9CvxkSaxnHBqIyDDGftrtPSBtRtU78fMoHezIuWGBKZBPCTvvVr3Imvv9oGYmWzcnfgYYv5bGANi
 YvT/eUdf
 2M1hxHSIYuo9JJt+2yZQhD/IykhxMPvtzh24wlkCTfDfFG48n5cD4ImbIsClCSwUyVPCqy91vpHyH0ZLZLBNvI0JzpygESCM3Pe/SJCKVMiNDWHkOpbzvqCBzTw0jw+EoG0L2yLMjmutl486876Bp4rJM3BLarcaa3bji3XmWTueGJ9+Squ2y9f0RcT/5wbOkPAyk1s3qKM9/K9EppXkgdCkeJicXbaJ75caeN1gY49a1vCxcKz+jSM9L9mte13eICT5z89bzpgTWugczEc8Z2HOPXMUX4xPFGEfHU6uk9eBQX+BhgJjeJoSkcq4isPpJa/FkK4eyITOOFraH/lhNGpWT92O699AKkVuh3mCtQAK7YhqOknmRiIMpEuJdBIu6WJcBcYd3BhlLqpvIhAg+YOYPkCJxsjL2YVgyRfeTwKHIKdg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/23/25 22:40, David Hildenbrand (Red Hat) wrote:
> As reported, ever since commit 1013af4f585f ("mm/hugetlb: fix
> huge_pmd_unshare() vs GUP-fast race") we can end up in some situations
> where we perform so many IPI broadcasts when unsharing hugetlb PMD page
> tables that it severely regresses some workloads.
> 
> In particular, when we fork()+exit(), or when we munmap() a large
> area backed by many shared PMD tables, we perform one IPI broadcast per
> unshared PMD table.
> 
> There are two optimizations to be had:
> 
> (1) When we process (unshare) multiple such PMD tables, such as during
>      exit(), it is sufficient to send a single IPI broadcast (as long as
>      we respect locking rules) instead of one per PMD table.
> 
>      Locking prevents that any of these PMD tables could get reused before
>      we drop the lock.
> 
> (2) When we are not the last sharer (> 2 users including us), there is
>      no need to send the IPI broadcast. The shared PMD tables cannot
>      become exclusive (fully unshared) before an IPI will be broadcasted
>      by the last sharer.
> 
>      Concurrent GUP-fast could walk into a PMD table just before we
>      unshared it. It could then succeed in grabbing a page from the
>      shared page table even after munmap() etc succeeded (and supressed
>      an IPI). But there is not difference compared to GUP-fast just
>      sleeping for a while after grabbing the page and re-enabling IRQs.
> 
>      Most importantly, GUP-fast will never walk into page tables that are
>      no-longer shared, because the last sharer will issue an IPI
>      broadcast.
> 
>      (if ever required, checking whether the PUD changed in GUP-fast
>       after grabbing the page like we do in the PTE case could handle
>       this)
> 
> So let's rework PMD sharing TLB flushing + IPI sync to use the mmu_gather
> infrastructure so we can implement these optimizations and demystify the
> code at least a bit. Extend the mmu_gather infrastructure to be able to
> deal with our special hugetlb PMD table sharing implementation.
> 
> To make initialization of the mmu_gather easier when working on a single
> VMA (in particular, when dealing with hugetlb), provide
> tlb_gather_mmu_vma().
> 
> We'll consolidate the handling for (full) unsharing of PMD tables in
> tlb_unshare_pmd_ptdesc() and tlb_flush_unshared_tables(), and track
> in "struct mmu_gather" whether we had (full) unsharing of PMD tables.
> 
> Because locking is very special (concurrent unsharing+reuse must be
> prevented), we disallow deferring flushing to tlb_finish_mmu() and instead
> require an explicit earlier call to tlb_flush_unshared_tables().
> 
>  From hugetlb code, we call huge_pmd_unshare_flush() where we make sure
> that the expected lock protecting us from concurrent unsharing+reuse is
> still held.
> 
> Check with a VM_WARN_ON_ONCE() in tlb_finish_mmu() that
> tlb_flush_unshared_tables() was properly called earlier.
> 
> Document it all properly.
> 
> Notes about tlb_remove_table_sync_one() interaction with unsharing:
> 
> There are two fairly tricky things:
> 
> (1) tlb_remove_table_sync_one() is a NOP on architectures without
>      CONFIG_MMU_GATHER_RCU_TABLE_FREE.
> 
>      Here, the assumption is that the previous TLB flush would send an
>      IPI to all relevant CPUs. Careful: some architectures like x86 only
>      send IPIs to all relevant CPUs when tlb->freed_tables is set.
> 
>      The relevant architectures should be selecting
>      MMU_GATHER_RCU_TABLE_FREE, but x86 might not do that in stable
>      kernels and it might have been problematic before this patch.
> 
>      Also, the arch flushing behavior (independent of IPIs) is different
>      when tlb->freed_tables is set. Do we have to enlighten them to also
>      take care of tlb->unshared_tables? So far we didn't care, so
>      hopefully we are fine. Of course, we could be setting
>      tlb->freed_tables as well, but that might then unnecessarily flush
>      too much, because the semantics of tlb->freed_tables are a bit
>      fuzzy.
> 
>      This patch changes nothing in this regard.
> 
> (2) tlb_remove_table_sync_one() is not a NOP on architectures with
>      CONFIG_MMU_GATHER_RCU_TABLE_FREE that actually don't need a sync.
> 
>      Take x86 as an example: in the common case (!pv, !X86_FEATURE_INVLPGB)
>      we still issue IPIs during TLB flushes and don't actually need the
>      second tlb_remove_table_sync_one().
> 
>      This optimized can be implemented on top of this, by checking e.g., in
>      tlb_remove_table_sync_one() whether we really need IPIs. But as
>      described in (1), it really must honor tlb->freed_tables then to
>      send IPIs to all relevant CPUs.
> 
> Notes on TLB flushing changes:
> 
> (1) Flushing for non-shared PMD tables
> 
>      We're converting from flush_hugetlb_tlb_range() to
>      tlb_remove_huge_tlb_entry(). Given that we properly initialize the
>      MMU gather in tlb_gather_mmu_vma() to be hugetlb aware, similar to
>      __unmap_hugepage_range(), that should be fine.
> 
> (2) Flushing for shared PMD tables
> 
>      We're converting from various things (flush_hugetlb_tlb_range(),
>      tlb_flush_pmd_range(), flush_tlb_range()) to tlb_flush_pmd_range().
> 
>      tlb_flush_pmd_range() achieves the same that
>      tlb_remove_huge_tlb_entry() would achieve in these scenarios.
>      Note that tlb_remove_huge_tlb_entry() also calls
>      __tlb_remove_tlb_entry(), however that is only implemented on
>      powerpc, which does not support PMD table sharing.
> 
>      Similar to (1), tlb_gather_mmu_vma() should make sure that TLB
>      flushing keeps on working as expected.
> 
> Further, note that the ptdesc_pmd_pts_dec() in huge_pmd_share() is not a
> concern, as we are holding the i_mmap_lock the whole time, preventing
> concurrent unsharing. That ptdesc_pmd_pts_dec() usage will be removed
> separately as a cleanup later.
> 
> There are plenty more cleanups to be had, but they have to wait until
> this is fixed.
> 
> Fixes: 1013af4f585f ("mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race")
> Reported-by: Uschakow, Stanislav" <suschako@amazon.de>
> Closes: https://lore.kernel.org/all/4d3878531c76479d9f8ca9789dc6485d@amazon.de/
> Tested-by: Laurence Oberman <loberman@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---

The following doc fixup on top, reported by buildbots on my private branch:


 From 3556c4ce6b645f680be8040c8512beadb5f84d38 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Date: Thu, 25 Dec 2025 10:41:55 +0100
Subject: [PATCH] fixup

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
  mm/mmu_gather.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index cd32c2dbf501b..7468ec3884555 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -462,8 +462,8 @@ void tlb_gather_mmu_fullmm(struct mmu_gather *tlb, struct mm_struct *mm)
  }
  
  /**
- * tlb_gather_mmu - initialize an mmu_gather structure for operating on a single
- *		    VMA
+ * tlb_gather_mmu_vma - initialize an mmu_gather structure for operating on a
+ *			single VMA
   * @tlb: the mmu_gather structure to initialize
   * @vma: the vm_area_struct
   *
-- 
2.52.0


-- 
Cheers

David

