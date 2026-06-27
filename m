Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 394EFC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F336B00B6; Sat, 27 Jun 2026 03:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6EE6B00B8; Sat, 27 Jun 2026 03:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5016B00B9; Sat, 27 Jun 2026 03:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9BCE6B00B6
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:28:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56B1B1C2368
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:28:23 +0000 (UTC)
X-FDA: 84924864486.21.60B43AB
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id B2CCDA0008
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:28:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="X7Egz2Y/";
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782545301;
	b=D5ScUM7h74Jj9IwT4K1FVtCc+Q4ODsEpukrvzEiZ0e3H7HX/ssMSQKQUwk2QJ4B1UMQSZX
	Yy/RURCl0fQDYELykMJT9OkFQ5oNhjSgRDkFNgnEdDNpyo6Ok6wmY59ByriVgQ1MOocGe1
	LEMpEx1k8TeWxp40ZsHhrM/VWLJU1OA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782545301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smajn29rHFOT4MtyJVi/R4P7juDmV113b9H8N2iquf8=;
	b=SBR2lHxs3fIrq1h9bkZeiqKEv0TRqq1aLOERz6PvxsDW7BHBfSHlNtZrcVoMJES5TAcnXd
	8m7zN7c/PpOaiyF0njtOprUXTSVg6nkPg5MLvT5KzFhQqC+7eCSDQXu4ajxIGMjXKaMHI0
	nsDwjXjfmv1dyx9+q90Dnlbgtxz5YJM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="X7Egz2Y/";
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782545300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smajn29rHFOT4MtyJVi/R4P7juDmV113b9H8N2iquf8=;
	b=X7Egz2Y/3kNgx936KgThNiTP1CtcNpl89b1xaYU349h/ZUp1X1ciL0yJVdsMVamhVtvOhu
	tHt1ZySq9gv19gJ1Y3mMFbiVURl6A0d1o3Jh/F62VE+klH8Dt6bnpdTRDY1r+ySuRI1R2l
	7ZgQOSH83Y2dJVk21qRAj9Y3qA3BB/8=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	usama.arif@linux.dev,
	willy@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [RFC PATCH 7/8] mm: support reserved THP VMAs in anonymous faults
Date: Sat, 27 Jun 2026 15:26:43 +0800
Message-ID: <8d14f837be754414b9eade37b8409be10a91c7b8.1782538002.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1782538002.git.zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B2CCDA0008
X-Stat-Signature: harjqt6a54db6148g675ukde3648fmzk
X-HE-Tag: 1782545301-806280
X-HE-Meta: U2FsdGVkX1+Hy3qGlW6M6C4/1ywtIU833GzFxPP+9unYvWphKc6GgteJyGz8VvF10EbjoWJp7KikRSDg628MgDGnKsrY3NE5A16bHTJ4OG0PxvnvjtfA3Nmndo3u/vrndJ8wg8sf2WO6r1S19uNOVtM3aqJKeUxfB12qUqfItl//CFz4di5kW31aXDdsRNre9UQFX4E6JZ1hmBil0aRg3oRQrRSarYFg+5y6nligysp6cEpL6pvvFWw2N5a7cnJrFDvFYxP3XmNGkSdn3iXNeuEDHrLwcaVviW3O4bJ+DUFkzK/vLXNCN8OGYUhHOD32zN6Vbm9lW+fqGUm7q7yjRsg+VWzmfyCguf0oae3Dw3VvEYCUE/qylfMmp4b4LTnhkHlNJd3Yzg5pbCQPCD1P6tY0Hr96GcwUye0q2+z6rODWaf+lYRm1xnErgwV8bQZxZRKRQi0ZNNvPCew98rVCJASr9dTE7mWuQfYSFaMj82RIPN4cjH2jiKV/WD/rSSww0AotnO2B4rHoHthycZ+Skb57JkgqzMKobKNnhN5OL3JhIUKTr5hun4RJsN20TzLKLgwiso41NLjjnDI2jwkUij1bkWTqbrUFSMSoI2QvWM/mTcUqRBU/af0TyLJBJB1vaKaLHh/shjytUI3WECaeggjxQa+MafLcUhS8pK1G1c3dXDromfaxNAUoE1L+963LW6AlgQyU9W3JGV8pv7sGnKqadfCtDJAzpeih099lgvacWjrHgEy5I/aZLZj1Ursdlqbs5wKXBiMm0DVKNG8FAjOMUslNG9ehuZWdCBNDeUGiQuo8cwFJV5ggCacax2KYxT7eKKta21Kd6xTz1CEHjn4E5ysGK+sUimYn4k/OfIyRup/7jlpR01nfIVfIKb+IB42B92hO7D4IMvtA4lguptpPMrbXS0Gbhb7UDyfEGefcO9UQ44dWh5UI917tMNUw/G35oVjPtm7EDmpJJBn
 F7+XI2w1
 T7TvdKC6BkCGFFF97W2gFwPvMVlDq8MguQ/ySfCpfNqtMdEizkSvjoIdUrjDzbD3z+f/gJEWq7jpd2Hre0ebcpqEUwuODiGecTaT0LYqSrbr+Q+6BFaW5I0GzKXWU0rhQ5Se9u1XhhAjRUGOqhEa0TOaTBLO3sf63jGnXhmPyXa9X2wFX1gLHACi2rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Wire VM_RESERVED_THP into the anonymous PMD fault path.

For reserved THP VMAs, the faulting folio is requested with the
__GFP_RESERVED_THP flag, restricting the allocation to reserved THP
pageblocks. The resulting folio remains a normal anonymous THP, using
the existing reclaim, swap, and buddy paths.

Additionally, enforce that reserved THP faults must either successfully
install a PMD-sized folio or fail completely. Fallbacks to the huge zero
page or small anonymous pages are not allowed if the PMD-sized allocation
fails.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/huge_mm.h |  4 +++-
 mm/huge_memory.c        | 18 +++++++++++++-----
 mm/memory.c             |  3 +++
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad20f7f8c1794..4fe9651cd86b5 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -330,6 +330,8 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 
 		if (vm_flags & VM_HUGEPAGE)
 			mask |= READ_ONCE(huge_anon_orders_madvise);
+		if (vm_flags & VM_RESERVED_THP)
+			mask |= BIT(PMD_ORDER);
 		if (hugepage_global_always() ||
 		    ((vm_flags & VM_HUGEPAGE) && hugepage_global_enabled()))
 			mask |= READ_ONCE(huge_anon_orders_inherit);
@@ -371,7 +373,7 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
 	 * Are THPs disabled only for VMAs where we didn't get an explicit
 	 * advise to use them?
 	 */
-	if (vm_flags & VM_HUGEPAGE)
+	if (vm_flags & (VM_HUGEPAGE | VM_RESERVED_THP))
 		return false;
 	/*
 	 * Forcing a collapse (e.g., madv_collapse), is a clear advice to
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a6..66d85a2fa855f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1267,6 +1267,9 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
+	if (vma->vm_flags & VM_RESERVED_THP)
+		gfp |= __GFP_RESERVED_THP;
+
 	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
 
 	if (unlikely(!folio)) {
@@ -1344,8 +1347,11 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	vm_fault_t ret = 0;
 
 	folio = vma_alloc_anon_folio_pmd(vma, vmf->address);
-	if (unlikely(!folio))
+	if (unlikely(!folio)) {
+		if (vma->vm_flags & VM_RESERVED_THP)
+			return VM_FAULT_OOM;
 		return VM_FAULT_FALLBACK;
+	}
 
 	pgtable = pte_alloc_one(vma->vm_mm);
 	if (unlikely(!pgtable)) {
@@ -1480,15 +1486,17 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	vm_fault_t ret;
 
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
-		return VM_FAULT_FALLBACK;
+		return (vma->vm_flags & VM_RESERVED_THP) ? VM_FAULT_OOM :
+							   VM_FAULT_FALLBACK;
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
 	khugepaged_enter_vma(vma, vma->vm_flags);
 
-	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
-			!mm_forbids_zeropage(vma->vm_mm) &&
-			transparent_hugepage_use_zero_page()) {
+	if (!(vma->vm_flags & VM_RESERVED_THP) &&
+	    !(vmf->flags & FAULT_FLAG_WRITE) &&
+	    !mm_forbids_zeropage(vma->vm_mm) &&
+	    transparent_hugepage_use_zero_page()) {
 		pgtable_t pgtable;
 		struct folio *zero_folio;
 		vm_fault_t ret;
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe923..225fc1ae22386 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5297,6 +5297,9 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	if (vma->vm_flags & VM_SHARED)
 		return VM_FAULT_SIGBUS;
 
+	if (unlikely(vma->vm_flags & VM_RESERVED_THP))
+		return VM_FAULT_OOM;
+
 	/*
 	 * Use pte_alloc() instead of pte_alloc_map(), so that OOM can
 	 * be distinguished from a transient failure of pte_offset_map().
-- 
2.54.0


