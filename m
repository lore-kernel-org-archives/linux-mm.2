Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD54CC5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51516B009E; Tue, 11 Aug 2026 08:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E285F6B009F; Tue, 11 Aug 2026 08:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E656B00A0; Tue, 11 Aug 2026 08:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D46A6B009E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:49:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A167C03E4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:36 +0000 (UTC)
X-FDA: 85088969952.17.61044B1
Received: from out-173.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf27.hostedemail.com (Postfix) with ESMTP id 30EC24000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w5fYj0iR;
	spf=pass (imf27.hostedemail.com: domain of nico.pache@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6ta4/4ra0Tw5nZckqXsY3oOBvaO5Y8KcpOP3NXktj8=;
	b=cVtLXNrMzwUkELtHMp43qWCLPxImgBqklNETEb4XvIcWIKCQKMc21yKpYFjC2Rd1ZrU7Vb
	JAA21ei1gm5YBdTcQFQ/SGSXy3w61ZfXcdIjxr15s9H0ls0PYxi5J8tJfn9KdF7KU2CCk8
	jiik/cbmXOKvZpx9iBd0ctj4eZYafgA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w5fYj0iR;
	spf=pass (imf27.hostedemail.com: domain of nico.pache@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452574;
	b=fYlrtioISyVo/cv9R2hLF+B9b10egAIbC72Smn5UuW+bsNGSNurhDfui4E8HLSPOOTXlQp
	b8Ha2IxF7IOhhcIS+KG8ug5EXKxM4F8SqAcumON2nDeV59CEzSiX19JwrWFRASlUnlStez
	WoBwFAWwra12omlBiPo5zvOOvNFjTzA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786452572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j6ta4/4ra0Tw5nZckqXsY3oOBvaO5Y8KcpOP3NXktj8=;
	b=w5fYj0iRsDLxOxggUbIL+61c1ZY1d1uv1umxa7TPztGFmeCgCBGlHAW+0/sWXhsojXHZQF
	9TU+8gLCn1EhnsiDeCv/ADHwGrkin6qpPFqY4kdjDouH/qIZMrlumFbE7WwA0k+y7ebiJ9
	tmxLqedbiqD0G+2ffZhBF5eb6xoHVGc=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 11 Aug 2026 06:48:37 -0600
Subject: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks into a
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: scyzqip96tfcstk46ermcn5pohhm3k9c
X-Rspamd-Queue-Id: 30EC24000F
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786452574-32883
X-HE-Meta: U2FsdGVkX18+taCqoG+K8dms2atnLD2Ue9BOdLdKp7KGGOINCJGvuvzj+w6akT5veXdR4qav7aW6CQJETRtHjndJ0xHawFPgmmA83ACN8CSQWgPj0N6nBjyVGwD8tbsez8PeFhEgd/sED6BIM6umnM3pz7rBexQ8y/mnKLMWV2+2yGjFeuRpQL/vs11AKQgvxZve+9VGypLPIpfRaGkFyK9lC5o2IQrfpLfx27GUPjj+qIkwuwpeln5WM8FSW4e/IZpjhS1SlHYtlxAEtOIml1RmQsccjCn9M/mg95J4Px3YCxYxYkOf1wMhIzCQNOwWt0WYPSmfLkNet9Ynrbq6SZa8/p86Ow8W34qrCk/Nw+OTRjgl777TMgiyf+TNyd6mAXpDoYhIDKC49aPCRnlez/Q3gbztutdNT9diYCv9+NUfnbTpMBFIx3ZnX2hExqoprBg/5h4imMYr7ZCQ8xWNLdOFC6A4kY7H0NRITdPOexGRZND3k9up3lOjIgdPI2CpT2aqKbTZjSOvhiQoqpV9M8Iip+ni8LOcCIeuLlsxybBmknPgKEa5vIifqcWtsjP2gbS9RwDqQgW3KQVrK8LMGT4H0/HBNJ3q7yu0ioKn/PfON6/c/QPIWwTOeqrKIydWNz9dVjng9HifOM27HYiWFf0mMw7UEeJS1mm60VkRKP2F0pvt2+vtUaSvAHiW1qgrk4lPumWqDMk/z2RcYiglbK2AX9n34CDqZS+ST3ueC8QDCRq88TQ9LSnOrfx+3DICtsDLCsx0FLuE8xJVWhmA26xZpBKtMiwbjZ2jnACbw3Pj24dbNCLkobR2zVtDb1PU6ujsERhGDcBXcsFGljRbqXJUyPMt3jijjKyMxKPgRjba6eFZlzhkC8Itl57cKYOy78aLhm+Q1cZHGyPgKTJNHzfBaM3Zf1GYuQMHYkc0MNbOxwCP5H9FdO9dkwyq6RJLYFhI6Mv2jpItuxszPFq
 KmThi8D5
 k/BIanhTJKa5IskB/5VHy2+SRgS2LR5A0uj3oaLikHcUj+z3Za9K+DICqpcDRk5l7nMSnU5IapSwbn2F8NDBQ0bROrqjmvqfNDP05+ByVNDAJGQHtS3kEUyCf5kvx+U0/ezJoSSaC3Gju3BzQEBjxH+4ageyRjJGahBZTsuPMCdqWZ0xH0VNNM+JNiqAi8UfL9pec
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For anonymous collapse, the collapse_scan_pmd() and
__collapse_huge_page_isolate() functions share a large portion of their
logic. These functions both check the state of the PTEs and verify the
following:
	- max_pte_* values are not exceeded
	- uffd is not active
	- lazyfree properties
	- non-anonymous

Merge these checks into a helper collapse_check_pte() to reduce code
duplication. We also add a helper struct for this function called
pte_check_context which allows us to pass the required parameters in a
clean and elegant manner.

A helper function is also introduced pte_check_fail() to provide a clean
interface to set the pte_check_context failure results and return
PTE_CHECK_FAIL state. This helps reduce code duplications across the new
collapse_check_pte function.

Two slight modifications are done to the original functionality. We now
warn (instead of crash) if the anon test fails, and we leverage the
vm_normal_folio function instead of page->folio, this should be
functionally equivalent.

No other functional changes intended.

This patch is heavily based off work done by Lance Yang, but modified to
deal with conflicts and feedback received during the review cycle [1].

[1] https://lore.kernel.org/linux-mm/20251008043748.45554-1-lance.yang@linux.dev/
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 298 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 157 insertions(+), 141 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 90d6e595d282..b7372aba4417 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -65,6 +65,12 @@ enum scan_result {
 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
+enum pte_check_result {
+	PTE_CHECK_SUCCEED,
+	PTE_CHECK_FAIL,
+	PTE_CHECK_CONTINUE,
+};
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
 
@@ -119,6 +125,20 @@ struct collapse_control {
 	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
 };
 
+struct pte_check_context {
+	struct collapse_control *cc;
+	struct vm_area_struct *vma;
+	unsigned int order;
+	struct folio *folio;
+	int none_or_zero;
+	int shared;
+	int unmapped;
+	enum scan_result result;
+	unsigned int max_ptes_none;
+	unsigned int max_ptes_swap;
+	unsigned int max_ptes_shared;
+};
+
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
@@ -696,74 +716,131 @@ static void count_collapse_event(unsigned int order, enum vm_event_item vm_event
 	count_mthp_stat(order, mthp_event);
 }
 
+/*
+ * pte_check_fail() - A simple helper to set the pte_check_context result and
+ * return PTE_CHECK_FAIL.
+ */
+static enum pte_check_result pte_check_fail(struct pte_check_context *ctx,
+		enum scan_result result)
+{
+	ctx->result = result;
+	return PTE_CHECK_FAIL;
+}
+
+/*
+ * collapse_check_pte() - Check if a PTE is suitable for collapse
+ *
+ * Check if a PTE is suitable for collapse based on the following criteria:
+ * - max_pte_* values are not exceeded
+ * - uffd is not active
+ * - lazyfree properties are not present
+ * - only anonymous pages are present
+ *
+ * a helper struct pte_check_context is used to pass and store relevant
+ * information between the collapse_check_pte() function and the caller.
+ *
+ * Return: PTE_CHECK_SUCCEED if the PTE is suitable for collapse,
+ *         PTE_CHECK_FAIL if the PTE is not suitable for collapse,
+ *         PTE_CHECK_CONTINUE if the scan should continue to check the next PTE.
+ */
+static enum pte_check_result collapse_check_pte(pte_t pteval,
+		unsigned long addr, struct pte_check_context *ctx)
+{
+	if (pte_none_or_zero(pteval)) {
+		if (++ctx->none_or_zero > ctx->max_ptes_none) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_NONE_PTE,
+					     MTHP_STAT_COLLAPSE_EXCEED_NONE);
+			return pte_check_fail(ctx, SCAN_EXCEED_NONE_PTE);
+		}
+		return PTE_CHECK_CONTINUE;
+	}
+	if (!pte_present(pteval)) {
+		if (ctx->unmapped == -1)
+			return pte_check_fail(ctx, SCAN_PTE_NON_PRESENT);
+		if (++ctx->unmapped > ctx->max_ptes_swap) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SWAP_PTE,
+					     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+			return pte_check_fail(ctx, SCAN_EXCEED_SWAP_PTE);
+		}
+		if (pte_swp_uffd_any(pteval))
+			return pte_check_fail(ctx, SCAN_PTE_UFFD);
+		return PTE_CHECK_CONTINUE;
+	}
+	/*
+	 * Don't collapse if any of the small PTEs are armed with uffd
+	 * write protection. Marking the new huge pmd as write protected
+	 * could bring userfault messages that fall outside of the
+	 * registered range.
+	 */
+	if (pte_uffd(pteval))
+		return pte_check_fail(ctx, SCAN_PTE_UFFD);
+
+	ctx->folio = vm_normal_folio(ctx->vma, addr, pteval);
+	if (unlikely(!ctx->folio) || unlikely(folio_is_zone_device(ctx->folio)))
+		return pte_check_fail(ctx, SCAN_PAGE_NULL);
+
+	/*
+	 * If the vma has the VM_DROPPABLE flag, the collapse will
+	 * preserve the lazyfree property without needing to skip.
+	 */
+	if (ctx->cc->is_khugepaged && !(ctx->vma->vm_flags & VM_DROPPABLE) &&
+	    folio_test_lazyfree(ctx->folio) && !pte_dirty(pteval))
+		return pte_check_fail(ctx, SCAN_PAGE_LAZYFREE);
+
+	if (!folio_test_anon(ctx->folio)) {
+		VM_WARN_ON_FOLIO(!folio_test_anon(ctx->folio), ctx->folio);
+		return pte_check_fail(ctx, SCAN_PAGE_ANON);
+	}
+
+	if (folio_maybe_mapped_shared(ctx->folio)) {
+		/*
+		 * TODO: Support shared pages without leading to further
+		 * mTHP collapses. Currently bringing in new pages via
+		 * shared may cause a future higher order collapse on a
+		 * rescan of the same range.
+		 */
+		if (++ctx->shared > ctx->max_ptes_shared) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SHARED_PTE,
+					     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+			return pte_check_fail(ctx, SCAN_EXCEED_SHARED_PTE);
+		}
+	}
+
+	return PTE_CHECK_SUCCEED;
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
+	enum pte_check_result pte_check;
+	struct pte_check_context ctx = {
+		.cc = cc,
+		.vma = vma,
+		.order = order,
+		.unmapped = -1, /* don't check swap PTEs */
+		.max_ptes_none = collapse_max_ptes_none(cc, vma, order),
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
-
-		/*
-		 * If the vma has the VM_DROPPABLE flag, the collapse will
-		 * preserve the lazyfree property without needing to skip.
-		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
-		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
-			result = SCAN_PAGE_LAZYFREE;
+		pteval = ptep_get(_pte);
+		pte_check = collapse_check_pte(pteval, addr, &ctx);
+		folio = ctx.folio;
+		if (pte_check == PTE_CHECK_FAIL) {
+			result = ctx.result;
 			goto out;
 		}
+		if (pte_check == PTE_CHECK_CONTINUE)
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
@@ -841,13 +918,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
-		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
+		trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
 						    referenced, result, order);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
-	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
+	trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
 					    referenced, result, order);
 	return result;
 }
@@ -1459,7 +1536,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 			spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
-					  /*uffd_wp=*/ false);
+					  /*uffd=*/ false);
 		if (pte_ptl != pmd_ptl)
 			spin_unlock(pte_ptl);
 	}
@@ -1613,24 +1690,30 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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
-	enum scan_result result = SCAN_FAIL;
-	struct page *page = NULL;
 	struct folio *folio = NULL;
+	int referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 	unsigned long addr;
 	unsigned long enabled_orders;
 	spinlock_t *ptl;
-	int node = NUMA_NO_NODE, unmapped = 0;
+	int node = NUMA_NO_NODE;
+	enum pte_check_result pte_check;
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
+	struct pte_check_context ctx = {
+		.cc = cc,
+		.vma = vma,
+		.order = HPAGE_PMD_ORDER,
+		.max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER),
+		.max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER),
+		.max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER),
+	};
+
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED) {
 		cc->progress++;
@@ -1647,7 +1730,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
-		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+		ctx.max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
 
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
@@ -1663,81 +1746,14 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
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
+		pte_check = collapse_check_pte(pteval, addr, &ctx);
+		folio = ctx.folio;
+		if (pte_check == PTE_CHECK_FAIL) {
+			result = ctx.result;
 			goto out_unmap;
 		}
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
+		if (pte_check == PTE_CHECK_CONTINUE)
+			continue;
 
 		/* Set bit for occupied pages */
 		__set_bit(i, cc->mthp_present_ptes);
@@ -1780,7 +1796,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	}
 	if (cc->is_khugepaged &&
 		   (!referenced ||
-		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
+		    (ctx.unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1791,13 +1807,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		/* collapse_huge_page() expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
 		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
+				       ctx.unmapped, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-				     none_or_zero, result, unmapped);
+				     ctx.none_or_zero, result, ctx.unmapped);
 	return result;
 }
 

-- 
2.55.0


