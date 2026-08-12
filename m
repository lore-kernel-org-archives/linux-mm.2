Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47407C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B0C6B00F8; Wed, 12 Aug 2026 05:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5026F6B00F9; Wed, 12 Aug 2026 05:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CBE06B00FA; Wed, 12 Aug 2026 05:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1986B00F8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:51:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C4591A01A8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:51:46 +0000 (UTC)
X-FDA: 85092150612.08.FD45DC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D753F40003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:51:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JSPhKf8k;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786528304;
	b=di2rDvdsoINVpl+kJsbZzPRkT8NoXxCINqM/jO63coZC2hd7Fjy+TP2FhS/p7/4UpWyo3V
	+7Loy04L9NVC54oKZf1d90vrLps8d7XbARYzOLDykpfrA8VSXDWxPgErxqd2Rjca0P1WfK
	qqN96xcsc3dPSYb0aTzb3B1Bfuzvz04=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JSPhKf8k;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786528304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uM8nl4Pv9YdNTUss7cCir3KkdF9+wXEeo+Ka2ElSpgg=;
	b=uINZc18GHu0yB59Z/zwGmVAxJ60u08cwAhLG3hSdrLAUUKCbpjggcIX7KvWLFqx3vkkar3
	04PYjTZgQH0Op+iiYtyXDgdT82/u4iwiyRWTuYBNvdIHa5NHiVk52N2UO+NnUXCrSTrAmG
	r2hP/g0THfZx4gzVHHDNg4FWxHyM7Hs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A75660A85;
	Wed, 12 Aug 2026 09:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573C41F000E9;
	Wed, 12 Aug 2026 09:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786528304;
	bh=uM8nl4Pv9YdNTUss7cCir3KkdF9+wXEeo+Ka2ElSpgg=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=JSPhKf8k4Z0Uodl3jE4YtkmDS+22SJ4+joZBleIbyT4O1lzOPMWbYZUHX4TmIue5d
	 eW3OcPI4WzzQIN5uoa4ELsUfK1L3YGwAnsPSE3X01YxuanIUEOiWMzLMLmyJ8lnqDK
	 BbjXx9rpvaSAyzYYpSP6Zyt/5yNoWXLCCwmaO8IYDHsUIrNgn6caSxk+tVbgAnBo7M
	 cvZu5UEA6l4KAvtpIEhA4cr6K+k6rKWYHfoec8Hf+xCWd2IF+7gxi2xdm8Lgal4PkO
	 Ld9VPjbKz2I43R2mcVyVDLqpPOPcF66dW4NGlG61keM3NDOI6WMSUOMpCJQ4dWHkZM
	 lMP6rSGPKmniA==
Message-ID: <753cb38f-66b4-4bd0-8b53-7480efe30ec3@kernel.org>
Date: Wed, 12 Aug 2026 11:51:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks into
 a helper
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
 <f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D753F40003
X-Stat-Signature: wyzrjbug9c8fhc49pzanzbxsr6spiqq6
X-HE-Tag: 1786528304-766153
X-HE-Meta: U2FsdGVkX18Ge7ptKnbX9FdwnXsLKeb8pb1Zb2P3vd9xEb/PAzWREh72+iO7+odIpZlUh2rSfrcXuVt3hzZM/AOM5Pr7tOHF5eDce1+vJI7MnZAZGFaKj3mdParfD9AYAEbiUNkmr4b/uRXH8BFWBb/fi0E76/RebMo8UcCFSRLEpomhhUkVm+69bwyut+fW7CEdiDDfVmRumafeO4uL315W0fH8pfWPk8b4rXBEYmX+GtPg54ni3jqqP6adNBPudNuTglcP/aZcSqPz7rBIWmM3AvhnWbthCfY4vNtrqnj8h1MEc9jiZJa8+5hwFU4avHmh/w0jOs9Xq5u2ZXeN6eJqdIevCWvDQIphfcTAzdPI/foxl3jDzgBYB0gBGfo6V1hB1/kKhBbqzvCmFpvG0uykzdz6BSslYm67FphTjfKSuf+gAxSkaxy6lggh0oESUcK+dUrQxxZYH6R9K2Eg5SzXxL5jx+aecXBUXinsFmdDF+MlcOX6ajc+1oZi+f4H8ArrR24WK/RFApMBifEQove0oFb3pvsBqOs1EJVU+p7k1y49WQIHzACh8TEnmzAha/4UCbNFNKbQzBqRhHyW3FwqDbHNtl/F1DOgiHQK+QyGQbjNGO2e1fA5U+KjQAm+bti9O/00ZGn+AbiX+hCUfEXXp6/HmyuQI33KRa984ed1lT/oDLjl5UuaSn//rtnlDbzBWch7rdQPjplRK1gmDUH602r0yPim9kdRdZZ2BbvT9isrwjGZMHc12wBWZ6k/a+w0NrY90QwrdGreAp85+YdpQvz4k+xGt5vLd2DeM3m8xhn/cjieEg9Dos9O4wYJkBKZCPqLKIYTbaHyQmA7uqJzBU8tuQEP10HGNOCa5RnXR1I0pGYeWOWNGEiPO4nPDPyVhrygRxjlu0qnUg5ADYab3p1WF7eA64c90K6X/3RTV48bArwL4OSwc6dHIFLYlIaZreVs6QjgkWPxxAS
 yw1is8lD
 phZ7d5J9rAdAJeMc1oLSrS/Z8UQbhrgArVEGLITzJTpTC1nR8vgbqSBCrrWFwDU1IF+/oK4Tg5qo3BpIocryMhC9F0HuM08HgoUeIq10Iw5BSp8n+1uDinWOk6CyxND63xL8PfIg7oK2U0DhzogS30rQGc3oBG0Nvt+cGVSPeepD0YuUilnQ5gz15pZFg8iZWtdx7FNJkHDLshApogNiKYgKWrBtaKi1QEFwsyN5rZK6nMOFTUfHXxGJaAlxIIQhoijQW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Huh, that looks odd.
> 
> That should just be a VM_WARN_ON_FOLIO(true, ..) or sth like that.
> 
> But in collapse_scan_pmd() that warning never existed? So this raises eyebrows.
> 
> [...]
> 
> I'll play with it to see if we can do better and will reply here later.


Okay, I think below is what we should do.

There is one behavioral change: we now longer trace the last folio, which is the right
thing to do IMHO.

And I think there is one fix we should pull out and evaluate first: A zeropage with a
uffd-wp marker is not checked properly, IIUC.


diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5a06e3942e889..8a223659fce2d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -119,6 +119,18 @@ struct collapse_control {
 	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
 };
 
+struct collapse_anon_pte_check_ctx {
+	struct collapse_control *cc;
+	struct vm_area_struct *vma;
+	unsigned int order;
+	int none_or_zero_ptes;
+	int nonpresent_ptes;
+	int shared_ptes;
+	unsigned int max_ptes_none;
+	int max_ptes_swap;
+	unsigned int max_ptes_shared;
+};
+
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
@@ -696,74 +708,104 @@ static void count_collapse_event(unsigned int order, enum vm_event_item vm_event
 	count_mthp_stat(order, mthp_event);
 }
 
+static enum scan_result collapse_anon_pte_check(pte_t pteval,
+		unsigned long addr, struct collapse_anon_pte_check_ctx *ctx,
+		struct folio **foliop)
+{
+	*foliop = NULL;
+
+	/*
+	 * Don't collapse if any of the small PTEs are armed with uffd
+	 * write protection. Marking the new huge pmd as write protected
+	 * could bring userfault messages that fall outside of the
+	 * registered range.
+	 */
+	if ((pte_present(pteval) && pte_uffd(pteval)) ||
+	    (!pte_present(pteval) && pte_swp_uffd_any(pteval)))
+		return SCAN_PTE_UFFD;
+
+	if (pte_none_or_zero(pteval)) {
+		if (++ctx->none_or_zero_ptes > ctx->max_ptes_none) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_NONE_PTE,
+					     MTHP_STAT_COLLAPSE_EXCEED_NONE);
+			return SCAN_EXCEED_NONE_PTE;
+		}
+		return SCAN_SUCCEED;
+	}
+	if (!pte_present(pteval)) {
+		if (ctx->max_ptes_swap < 0)
+			return SCAN_PTE_NON_PRESENT;
+		if (++ctx->nonpresent_ptes > ctx->max_ptes_swap) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SWAP_PTE,
+					     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+			return SCAN_EXCEED_SWAP_PTE;
+		}
+		return SCAN_SUCCEED;
+	}
+
+	*foliop = vm_normal_folio(ctx->vma, addr, pteval);
+	if (unlikely(!*foliop) || unlikely(folio_is_zone_device(*foliop)))
+		return SCAN_PAGE_NULL;
+
+	/*
+	 * If the vma has the VM_DROPPABLE flag, the collapse will
+	 * preserve the lazyfree property without needing to skip.
+	 */
+	if (ctx->cc->is_khugepaged && !(ctx->vma->vm_flags & VM_DROPPABLE) &&
+	    folio_test_lazyfree(*foliop) && !pte_dirty(pteval))
+		return SCAN_PAGE_LAZYFREE;
+
+	if (!folio_test_anon(*foliop))
+		return SCAN_PAGE_ANON;
+
+	if (folio_maybe_mapped_shared(*foliop)) {
+		/*
+		 * TODO: Support shared pages without leading to further
+		 * mTHP collapses. Currently bringing in new pages via
+		 * shared may cause a future higher order collapse on a
+		 * rescan of the same range.
+		 */
+		if (++ctx->shared_ptes > ctx->max_ptes_shared) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SHARED_PTE,
+					     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+			return SCAN_EXCEED_SHARED_PTE;
+		}
+	}
+
+	return SCAN_SUCCEED;
+}
+
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
 	const unsigned long nr_pages = 1UL << order;
-	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
-	pte_t *_pte;
-	int none_or_zero = 0, shared = 0, referenced = 0;
+	pte_t *_pte, pteval;
+	int referenced = 0;
 	enum scan_result result = SCAN_FAIL;
+	struct collapse_anon_pte_check_ctx ctx = {
+		.cc = cc,
+		.vma = vma,
+		.order = order,
+		.max_ptes_none = collapse_max_ptes_none(cc, vma, order),
+		.max_ptes_swap = -1, /* Don't tolerate any non-present ptes. */
+		.max_ptes_shared = collapse_max_ptes_shared(cc, order),
+	};
 
 	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
-		pte_t pteval = ptep_get(_pte);
-		if (pte_none_or_zero(pteval)) {
-			if (++none_or_zero > max_ptes_none) {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
-				goto out;
-			}
-			continue;
-		}
-		if (!pte_present(pteval)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto out;
-		}
-		if (pte_uffd(pteval)) {
-			result = SCAN_PTE_UFFD;
-			goto out;
-		}
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out;
-		}
-
-		folio = page_folio(page);
-		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
+		pteval = ptep_get(_pte);
 
-		/*
-		 * If the vma has the VM_DROPPABLE flag, the collapse will
-		 * preserve the lazyfree property without needing to skip.
-		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
-		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
-			result = SCAN_PAGE_LAZYFREE;
+		result = collapse_anon_pte_check(pteval, addr, &ctx, &folio);
+		if (result != SCAN_SUCCEED) {
+			VM_WARN_ON_ONCE(result == SCAN_PAGE_ANON);
 			goto out;
 		}
+		if (!folio)
+			continue;
 
-		/* See collapse_scan_pmd(). */
-		if (folio_maybe_mapped_shared(folio)) {
-			/*
-			 * TODO: Support shared pages without leading to further
-			 * mTHP collapses. Currently bringing in new pages via
-			 * shared may cause a future higher order collapse on a
-			 * rescan of the same range.
-			 */
-			if (++shared > max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_collapse_event(order, THP_SCAN_EXCEED_SHARED_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
-				goto out;
-			}
-		}
 		/*
 		 * TODO: In some cases of partially-mapped folios, we'd actually
 		 * want to collapse.
@@ -841,13 +883,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
-		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
+		trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero_ptes,
 						    referenced, result, order);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
-	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
+	trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero_ptes,
 					    referenced, result, order);
 	return result;
 }
@@ -1613,21 +1655,25 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
-	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
-	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
 	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
-	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
-	struct page *page = NULL;
 	struct folio *folio = NULL;
+	int referenced = 0;
 	unsigned long addr;
 	unsigned long enabled_orders;
 	spinlock_t *ptl;
-	int node = NUMA_NO_NODE, unmapped = 0;
+	int node = NUMA_NO_NODE;
+	struct collapse_anon_pte_check_ctx ctx = {
+		.cc = cc,
+		.vma = vma,
+		.order = HPAGE_PMD_ORDER,
+		.max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER),
+		.max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER),
+		.max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER),
+	};
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
@@ -1647,7 +1693,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
-		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+		ctx.max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
 
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
@@ -1663,81 +1709,11 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
 		cc->progress++;
 
-		if (pte_none_or_zero(pteval)) {
-			if (++none_or_zero > max_ptes_none) {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
-				goto out_unmap;
-			}
-			continue;
-		}
-		if (!pte_present(pteval)) {
-			if (++unmapped > max_ptes_swap) {
-				result = SCAN_EXCEED_SWAP_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
-				goto out_unmap;
-			}
-			/*
-			 * Always be strict with uffd-wp
-			 * enabled swap entries.  Please see
-			 * comment below for pte_uffd().
-			 */
-			if (pte_swp_uffd_any(pteval)) {
-				result = SCAN_PTE_UFFD;
-				goto out_unmap;
-			}
-			continue;
-		}
-		if (pte_uffd(pteval)) {
-			/*
-			 * Don't collapse the page if any of the small
-			 * PTEs are armed with uffd write protection.
-			 * Here we can also mark the new huge pmd as
-			 * write protected if any of the small ones is
-			 * marked but that could bring unknown
-			 * userfault messages that falls outside of
-			 * the registered range.  So, just be simple.
-			 */
-			result = SCAN_PTE_UFFD;
-			goto out_unmap;
-		}
-
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out_unmap;
-		}
-		folio = page_folio(page);
-
-		/*
-		 * If the vma has the VM_DROPPABLE flag, the collapse will
-		 * preserve the lazyfree property without needing to skip.
-		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
-		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
-			result = SCAN_PAGE_LAZYFREE;
-			goto out_unmap;
-		}
-
-		if (!folio_test_anon(folio)) {
-			result = SCAN_PAGE_ANON;
+		result = collapse_anon_pte_check(pteval, addr, &ctx, &folio);
+		if (result != SCAN_SUCCEED)
 			goto out_unmap;
-		}
-
-		/*
-		 * We treat a single page as shared if any part of the THP
-		 * is shared.
-		 */
-		if (folio_maybe_mapped_shared(folio)) {
-			if (++shared > max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
-				goto out_unmap;
-			}
-		}
+		if (!folio)
+			continue;
 
 		/* Set bit for occupied pages */
 		__set_bit(i, cc->mthp_present_ptes);
@@ -1780,7 +1756,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	}
 	if (cc->is_khugepaged &&
 		   (!referenced ||
-		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
+		    (ctx.nonpresent_ptes && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1791,13 +1767,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		/* collapse_huge_page() expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
 		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
+				       ctx.nonpresent_ptes, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-				     none_or_zero, result, unmapped);
+	trace_mm_khugepaged_scan_pmd(mm, folio, referenced, ctx.none_or_zero_ptes,
+				     result, ctx.nonpresent_ptes);
 	return result;
 }
 
-- 
2.43.0


-- 
Cheers,

David

