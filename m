Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A95C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6FF6B00D6; Mon,  6 Jul 2026 11:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E126B00D7; Mon,  6 Jul 2026 11:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3BA6B00D8; Mon,  6 Jul 2026 11:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EB676B00D6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:45:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88A9F1C69E5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:45:08 +0000 (UTC)
X-FDA: 84958775496.10.BAA81F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 902018000F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:45:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CZ7GB6rn;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352706;
	b=YiVhni0Dre25dHVGbI9zlgfy9fZpojeX7g7lqRBAPXu4SGVT0QrrKle0xYPQ2A4ci4WU3h
	oHonVb2UkxkNKL6TQzhoj38/vMtDjIcBMT0UQODkf4tGJ5Hz7xxejSECTaPR7kWWnsHQAv
	rEvFWBIJr4Qdr5DjlEgXf8TvqJI6Tj0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CZ7GB6rn;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UImAYT2NpHnBWtVaSbpsrLwKhtieXrfYKA2luRUhl24=;
	b=0qdFcdICCmyHLaj0V1Tqgb1kyhGvebFNayaR/Oh2vDs+G5yZ0YrAzrK8BvSzOjK/XIzmVW
	xTaIkkr7vIsAF3gyk2rukts47iDie2bwAiWSOABH9h4X8KZlkxBgO03Wc/JlsyaZM9LVEM
	6vLxQ1oX9wxUkDz9pOu1T3k4DHL6Dco=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UImAYT2NpHnBWtVaSbpsrLwKhtieXrfYKA2luRUhl24=;
	b=CZ7GB6rnKxsKdZ4hZTFuxufBpw0srShmg2MyrKq5YuP3wvws6i+wF56LKbMOsLsr1n+y/U
	LPAoFCMBZ7gz6azUWAgcRSU+d3LfOiqyP9hYLAgyroJkHaGVZXD1CZArzOtJ8bfl1XN9Cd
	8GJ7abePCWgxU7B8Vq+YRG4OZT4TGS4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-6jYtQVULOwGf3zqxEOSBrQ-1; Mon,
 06 Jul 2026 11:45:00 -0400
X-MC-Unique: 6jYtQVULOwGf3zqxEOSBrQ-1
X-Mimecast-MFC-AGG-ID: 6jYtQVULOwGf3zqxEOSBrQ_1783352697
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23FAF18007E9;
	Mon,  6 Jul 2026 15:44:57 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.58.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 98E5A195604E;
	Mon,  6 Jul 2026 15:44:48 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5/8] mm/khugepaged: Refactor the PTE state checks into a helper
Date: Mon,  6 Jul 2026 09:44:52 -0600
Message-ID: <20260706154500.39178-6-npache@redhat.com>
In-Reply-To: <20260706154500.39178-1-npache@redhat.com>
References: <20260706154500.39178-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: u4Nfxs-dsno24KsDwt7EH4EF7EiHhALml8K81Iyhvtg_1783352697
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 902018000F
X-Stat-Signature: og5nmf15zefi917m74gt6m9fms5yq8ze
X-HE-Tag: 1783352706-180036
X-HE-Meta: U2FsdGVkX1+cHYxBxuZUhQwmiU4qdejGMbFbr0uEG4otS84kPV6UMjNOfAA52cIiNvKFYlrSrUP5hQhwT/boSZCDsNuKLFg0I9p4NzMSa/FiZSH9dDrgMJG48NzZ6HsLyBciQe0oHkVH8fRqEXyTIWDNklb5ALLHQBl44YvCG0EyDcqFnRBQkBjd9s49Qw5BjjuE4dVd35MvAj/lgAdl4V8PbP1HnHsk5pc0X6sA1YbJaJMXQXRgqfxJQ1bRMDcGlooD8wPS86tmJ8AGrazSbh8G5elRySPT70fdaYmMQsQhjAk3pvtiU6GzwBJjR3VNJzynXoB405FNsus/PgZm8UXoZwJsvTwe36CD5eNJxY6I82Qu5ULkvgSyBFf/TlSAReTsp04Ltg8s6Lk0n5GNQVw3GvNdzdrFUc9wrySxIgYylmwUHbr4We6Or9UbwaH0IXdMW5aJSlFPJyzmwygCgBSR5hz9XFVKM2vWJXE8fGAjP5BGZlbCmnGRwKQnsEYEgsAlkFv0NI2tvzebEK1VTMafOe7v4zVr8Y6SwGFCH6wnfCjJvS7tsP5a+5SECIp4Z83Grm2DLNxmIiL6PgHUSs3WgHlygsLZrrRF3u/GJeheN3DxZYCb3zO2NTwzDnSwW5A+NIfC8o5oSN/DR6NIZnTodkkoW+v7hGpFM+qe6pHCOtRV8nXqQ2DfZSQ52KguBkOTNiSA8ViTQgMlCtbNXg+4oFpfVYxr6bGqISjWrHGfAxUgG4cxNl9+w1DIQU7MejJLAW6GOVegCvhZWunyB7LppsSmb9yLiwnUWjB2ObCMFHKrrDE93uH62nHQsyZWBycNXAXHH9V9CGMnQLw1ctFkt/arc4YwPBUaJ0lWAsrHvQH5KctHIpeB4iBw9F/37q+0PJIsDW/l6Cememl2um0KWdCK8MLr55ARw4N/YAl9vQcqaWqS5rLv+q0AjjLIvtRErzu9befaTpc0Bso
 gUDCjqJ2
 1bIeVVL+VVzy3gLRnA2pSnvzeqbdejS+FvpOx0Wn2Qbrxs2SK8h6uM1rHeSa6r3KMb5ZU3DDafuk7fDOT29KGJciQ68GZaEuvzFUDgdBB2vGMtvXh80pz5lfiDCsj9G02vbfLiM5U4ykLS9ZSugMMfM17LugMIsTC761MNB4LPE3RLuewKAiSjHwCJf7Zaws8PgDIMWJj9dj8PIcwF71hBjUZjxKKdUJErSEurIngr++oDihJPC668CNkq7+IHqzUfpbd4IkxgcPQ8YF1IkoBuEGB77buIfUpqG13SI5/peeKERx6pN9KmEzAQi7ARAMSHkf5H76HlbJUVr1M/Swgc2pxf6HEWwSElkZ/opwYP63HFN4=
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

[1] https://lore.kernel.org/all/20251008043748.45554-1-lance.yang@linux.dev/
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 295 +++++++++++++++++++++++++-----------------------
 1 file changed, 155 insertions(+), 140 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 676f75773a6c..c4ea2dc1591b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -63,6 +63,12 @@ enum scan_result {
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
 
@@ -117,6 +123,20 @@ struct collapse_control {
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
@@ -700,74 +720,130 @@ static void count_collapse_event(unsigned int order, enum vm_event_item vm_event
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
+					MTHP_STAT_COLLAPSE_EXCEED_NONE);
+			return pte_check_fail(ctx, SCAN_EXCEED_NONE_PTE);
+		}
+		return PTE_CHECK_CONTINUE;
+	}
+	if (!pte_present(pteval)) {
+		if (ctx->unmapped == -1)
+			return pte_check_fail(ctx, SCAN_PTE_NON_PRESENT);
+		if (++ctx->unmapped > ctx->max_ptes_swap) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SWAP_PTE,
+					MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+			return pte_check_fail(ctx, SCAN_EXCEED_SWAP_PTE);
+		}
+		if (pte_swp_uffd_wp_any(pteval))
+			return pte_check_fail(ctx, SCAN_PTE_UFFD_WP);
+		return PTE_CHECK_CONTINUE;
+	}
+	/*
+	 * Don't collapse if any of the small PTEs are armed with uffd
+	 * write protection. Marking the new huge pmd as write protected
+	 * could bring userfault messages that fall outside of the
+	 * registered range.
+	 */
+	if (pte_uffd_wp(pteval))
+		return pte_check_fail(ctx, SCAN_PTE_UFFD_WP);
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
+	if (folio_maybe_mapped_shared(ctx->folio)) {
+		/*
+		 * TODO: Support shared pages without leading to further
+		 * mTHP collapses. Currently bringing in new pages via
+		 * shared may cause a future higher order collapse on a
+		 * rescan of the same range.
+		 */
+		if (++ctx->shared > ctx->max_ptes_shared) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SHARED_PTE,
+					MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+			return pte_check_fail(ctx, SCAN_EXCEED_SHARED_PTE);
+		}
+	}
+
+	if (!folio_test_anon(ctx->folio)) {
+		VM_WARN_ON_FOLIO(!folio_test_anon(ctx->folio), ctx->folio);
+		return pte_check_fail(ctx, SCAN_PAGE_ANON);
+	}
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
-						MTHP_STAT_COLLAPSE_EXCEED_NONE);
-				goto out;
-			}
-			continue;
-		}
-		if (!pte_present(pteval)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto out;
-		}
-		if (pte_uffd_wp(pteval)) {
-			result = SCAN_PTE_UFFD_WP;
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
+		if (pte_check == PTE_CHECK_FAIL) {
+			result = ctx.result;
 			goto out;
 		}
+		if (pte_check == PTE_CHECK_CONTINUE)
+			continue;
+		folio = ctx.folio;
 
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
-						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
-				goto out;
-			}
-		}
 		/*
 		 * TODO: In some cases of partially-mapped folios, we'd actually
 		 * want to collapse.
@@ -844,13 +920,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -1616,24 +1692,30 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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
@@ -1649,7 +1731,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	 * scan all pages to populate the bitmap for mTHP collapse.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
-		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+		ctx.max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
 
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
@@ -1665,81 +1747,14 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
 		cc->progress++;
 
-		if (pte_none_or_zero(pteval)) {
-			if (++none_or_zero > max_ptes_none) {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
-						MTHP_STAT_COLLAPSE_EXCEED_NONE);
-				goto out_unmap;
-			}
-			continue;
-		}
-		if (!pte_present(pteval)) {
-			if (++unmapped > max_ptes_swap) {
-				result = SCAN_EXCEED_SWAP_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
-						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
-				goto out_unmap;
-			}
-			/*
-			 * Always be strict with uffd-wp
-			 * enabled swap entries.  Please see
-			 * comment below for pte_uffd_wp().
-			 */
-			if (pte_swp_uffd_wp_any(pteval)) {
-				result = SCAN_PTE_UFFD_WP;
-				goto out_unmap;
-			}
-			continue;
-		}
-		if (pte_uffd_wp(pteval)) {
-			/*
-			 * Don't collapse the page if any of the small
-			 * PTEs are armed with uffd write protection.
-			 * Here we can also mark the new huge pmd as
-			 * write protected if any of the small ones is
-			 * marked but that could bring unknown
-			 * userfault messages that falls outside of
-			 * the registered range.  So, just be simple.
-			 */
-			result = SCAN_PTE_UFFD_WP;
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
-						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
-				goto out_unmap;
-			}
-		}
+		if (pte_check == PTE_CHECK_CONTINUE)
+			continue;
+		folio = ctx.folio;
 
 		/* Set bit for occupied pages */
 		__set_bit(i, cc->mthp_present_ptes);
@@ -1781,7 +1796,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	}
 	if (cc->is_khugepaged &&
 		   (!referenced ||
-		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
+		    (ctx.unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1792,13 +1807,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		/* collapse_huge_page expects the lock to be dropped before calling */
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
2.54.0


