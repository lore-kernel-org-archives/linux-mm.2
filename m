Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD829E9907D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F086B008C; Fri, 10 Apr 2026 06:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFD66B00A3; Fri, 10 Apr 2026 06:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF666B00A4; Fri, 10 Apr 2026 06:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2840A6B008C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:33:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF2D4C1BD7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:33:41 +0000 (UTC)
X-FDA: 84642285042.28.E2BDB83
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3C91C1C000D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:33:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SSUwwv6K;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817220; a=rsa-sha256;
	cv=none;
	b=ppQ+5c/dNBMsNBLMGMhhaS+0eOQgYkrHlh3ILC80dYJ2Vlite2IiOdDS0LLBUshSV+sMWY
	SdcQeuVwg6NSeuE236AyOm9aS5DSFe1L9nx2jv9Or77s/vE6Tw+I3AjsxcF/Z5ZRCdlOHl
	4i9bNUIRv5hEPtYvLXG8D9c00z6iYfQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SSUwwv6K;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9dqg6HjJK784/LHcnQoms47tYKmS1qrM/lvpdOp+i4=;
	b=aq+H9YGFf5mFjKsD9SmB5sGOJ9eGD4GJEquT1cxGvoK+U+67BJKobNCImVhsyIsciROQDe
	iW6mGXYRgBnuorn/jhGjGU2L7Q6n83oXmpusnTCsRg4Y9U30inAbVxG2DKgR9kBm1xgVtu
	gPHBgfI5Pu7Djm/+em0CAprzy+24CBw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C265A453F;
	Fri, 10 Apr 2026 03:33:33 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 503083FAF5;
	Fri, 10 Apr 2026 03:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775817219; bh=IYbaIbF+HIELGkWoWytxfeLOJBlJUqn4EEQxhn4v5mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSUwwv6KmxM5an1P1ml4mo9ZiDEOcCqJ17Cgua9iP7oh/FRV8mDjV5mh6zBIWMCzA
	 AE2brYwiBSZR1LQT8DiuVrzHIUpBplvp5Yw7emuhH4tLT5Ke616mYWLa6iJWd3h76k
	 HZ6tHKFGrynXQ/RJFk6cYJvf6fOBwhn5+qIgOh28=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 9/9] mm/rmap: enable batch unmapping of anonymous folios
Date: Fri, 10 Apr 2026 16:02:04 +0530
Message-Id: <20260410103204.120409-10-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260410103204.120409-1-dev.jain@arm.com>
References: <20260410103204.120409-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 177pikeixmooxazz6oh4mfyrsf8io63k
X-Rspamd-Queue-Id: 3C91C1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775817220-857118
X-HE-Meta: U2FsdGVkX1+zWaYKHYUB7FbgovRFxL6itmoWzk57Sy7PEamjy/v4PNWWZ66PnlR782YSPBK2puQuiFrHpJktpKjVJEH7iKAW4DlmjIxVWbubKWUwhyzQ61XRdGG0XyQLvpINyyJ6yrjg/9z7EfuShHkyx/9wnGY2lVNApE8jnxWcF8a299iVdlfMLKmDdgsho54Rsm54trpy6ZMECtpqsTMCr0whIS6VmhuAIsxlHp57h8ac4V9B5ExuludHZmSz6NOd0vk57FiOY8jClkcMkZ2z9Di5YAiSoppWV4Yol009NMUSCqwVC54ClSGIegox45LkxqQJShiTvLfsJF5le0+NJYptHooeK0I7THGiv8eECGR/bAaofZi1Iww96V+jLhlPQQIY8V7Sullt3QmMtFcPYF3DF6v3a72H3siaSOdeT3My+/UaNq4pajN1KliMKd4pNpVNnpjHIT3Dzvaewc11wUKlV6TnXSFcvfWnYm7ZUwfpwU3Zgl3xuvaLWA9eSESLS0NWcJseHfbYP1ApF5/3t/XWcD+ZHCYWE/nzyYR809ZB+fNW1/js+E+IwHQPi1nOUg5L/DNRFf1X3L0jyPNZtsGmz3Kg/NuG62874IJYihLHUe6yskIl+mZFIPgvt51w/YA9/YWAAzc38spuGgbje82NBIveW/VnIsphoZynYRpfGE7ySa0iWVt4tbVdJaIPhxdBF1s8H6ZYaMecSAWVGOIiHarty4CNbd3tKB63XPRuSneBtSCqdASedCxBbKSkoVkSkrV9p1OPQRCOaXQtQhoiK73jxSMCKmTkzHBvQ9r5e5C2xtLM0U6IDsZs+aiGLoY1b2qTz9oGL4JwBLxwqWc7k1gk3wwzFR9Zq69/CoNZ/nRflLBDdXX9B4zT760IR9XrPLf2k6D2oII6CWHER4Or90ZiAXaf5DfZw+pG3nJ249QeEV0K4HL4BmZF35NmtlE58naucz4hjW9
 xwenkfeR
 R8PdqGoel2wxIhbO51zrtzvMIWG/9vJSDQop+j1QzkwrzpHsU8EGyzl6I3PPm1Gaf9/ZwM/pb4ALDCZkV1lFQcd4Hm2M8Do/s1+EcNGw4q5WaY50DBIeySNlww5r6ZyNJIP0ZSKt4kV4u1jLbSYbW6fyOR4waHO8k96+lKMHCI2Z6AvTQnKk5E9bEV1dbWdC304KvlwlwUAxAaXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable batch clearing of ptes, and batch swap setting of ptes for anon
folio unmapping.

Processing all ptes of a large folio in one go helps us batch across
atomics (add_mm_counter etc), barriers (in the function
__folio_try_share_anon_rmap), repeated calls to page_vma_mapped_walk(),
to name a few. In general, batching helps us to execute similar code
together, making the execution of the program more memory and
CPU friendly.

On arm64-contpte, batching also helps us avoid redundant ptep_get() calls
and TLB flushes while breaking the contpte mapping.

The handling of anon-exclusivity is very similar to commit cac1db8c3aad
("mm: optimize mprotect() by PTE batching"). Since folio_unmap_pte_batch()
won't look at the bits of the underlying page, we need to process
sub-batches of ptes pointing to pages which are same w.r.t exclusivity,
and batch set only those ptes to swap ptes in one go. Hence export
page_anon_exclusive_sub_batch() to internal.h and reuse it.

arch_unmap_one() is only defined for sparc64; I am not comfortable
regarding the nuances between retrieving the pfn from pte_pfn() or from
(paddr = pte_val(oldpte) & _PAGE_PADDR_4V).

(And, pte_next_pfn() can't even be called from arch_unmap_one() because
that file does not include pgtable.h) So just disable the
"sparc64-anon-swapbacked" case for now.

We need to take care of rmap accounting (folio_remove_rmap_ptes) and
reference accounting (folio_put_refs) when anon folio unmap succeeds.
In case we partially batch the large folio and fail, we need to correctly
do the accounting for pages which were successfully unmapped. So, put
this accounting code in __unmap_anon_folio() itself, instead of doing
some horrible goto jumping at the callsite of unmap_anon_folio().

Add a comment at relevant places to say that we are on a device-exclusive
entry and not a present entry.

If the batch length is less than the number of pages in the folio, then
we must skip over this batch.

The page_vma_mapped_walk API ensures this - check_pte() will return true
only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the pte.
There is no pfn underlying a swap pte, so check_pte returns false and we
keep skipping until we hit a present pte, which is where we want to start
unmapping from next.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h |  26 +++++++
 mm/mprotect.c |  17 -----
 mm/rmap.c     | 188 ++++++++++++++++++++++++++++++++++----------------
 3 files changed, 153 insertions(+), 78 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index c693646e5b3f0..f7033c9626767 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -393,6 +393,32 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 		unsigned int max_nr);
 
+/**
+ * page_anon_exclusive_sub_batch - Determine length of consecutive exclusive
+ * or maybe shared pages
+ * @start_idx: Starting index of the page array to scan from
+ * @max_len: Maximum length to look at
+ * @first_page: First page of the page array
+ * @expected_anon_exclusive: Whether to look for exclusive or !exclusive pages
+ *
+ * Determines length of consecutive ptes, pointing to pages being the same
+ * w.r.t the PageAnonExclusive bit.
+ *
+ * Context: The ptes point to consecutive pages of the same large folio. The
+ * ptes belong to the same PMD and VMA.
+ */
+static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
+		struct page *first_page, bool expected_anon_exclusive)
+{
+	int idx;
+
+	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
+		if (expected_anon_exclusive != PageAnonExclusive(first_page + idx))
+			break;
+	}
+	return idx - start_idx;
+}
+
 /**
  * pte_move_swp_offset - Move the swap entry offset field of a swap pte
  *	 forward or backward by delta
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028cf..949fd7022b5cf 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -138,23 +138,6 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
 		tlb_flush_pte_range(tlb, addr, nr_ptes * PAGE_SIZE);
 }
 
-/*
- * Get max length of consecutive ptes pointing to PageAnonExclusive() pages or
- * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
- * that the ptes point to consecutive pages of the same anon large folio.
- */
-static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
-		struct page *first_page, bool expected_anon_exclusive)
-{
-	int idx;
-
-	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
-		if (expected_anon_exclusive != PageAnonExclusive(first_page + idx))
-			break;
-	}
-	return idx - start_idx;
-}
-
 /*
  * This function is a result of trying our very best to retain the
  * "avoid the write-fault handler" optimization. In can_change_pte_writable(),
diff --git a/mm/rmap.c b/mm/rmap.c
index 9b20ef7f211e1..ca071641965bd 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1958,11 +1958,11 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	end_addr = pmd_addr_end(addr, vma->vm_end);
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
-	/* We only support lazyfree or file folios batching for now ... */
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
+	if (pte_unused(pte))
 		return 1;
 
-	if (pte_unused(pte))
+	if (__is_defined(__HAVE_ARCH_UNMAP_ONE) && folio_test_anon(folio) &&
+	    folio_test_swapbacked(folio))
 		return 1;
 
 	/*
@@ -1975,6 +1975,122 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static inline void set_swp_ptes(struct mm_struct *mm, unsigned long address,
+		pte_t *ptep, swp_entry_t entry, pte_t pteval, bool anon_exclusive,
+		unsigned long nr_pages)
+{
+	pte_t swp_pte = swp_entry_to_pte(entry);
+
+	if (anon_exclusive)
+		swp_pte = pte_swp_mkexclusive(swp_pte);
+
+	if (likely(pte_present(pteval))) {
+		if (pte_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_uffd_wp(pteval))
+			swp_pte = pte_swp_mkuffd_wp(swp_pte);
+	} else {
+		/* Device-exclusive entry */
+		VM_WARN_ON(nr_pages != 1);
+		if (pte_swp_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_swp_uffd_wp(pteval))
+			swp_pte = pte_swp_mkuffd_wp(swp_pte);
+	}
+
+	for (int i = 0; i < nr_pages; ++i, ++ptep, address += PAGE_SIZE) {
+		set_pte_at(mm, address, ptep, swp_pte);
+		swp_pte = pte_next_swp_offset(swp_pte);
+	}
+}
+
+static inline void finish_folio_unmap(struct vm_area_struct *vma,
+		struct folio *folio, struct page *subpage, unsigned long nr_pages)
+{
+	if (unlikely(folio_test_hugetlb(folio)))
+		hugetlb_remove_rmap(folio);
+	else
+		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
+	if (vma->vm_flags & VM_LOCKED)
+		mlock_drain_local();
+	folio_put_refs(folio, nr_pages);
+}
+
+static inline bool __unmap_anon_folio_range(struct vm_area_struct *vma, struct folio *folio,
+		struct page *subpage, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages, bool anon_exclusive)
+{
+	swp_entry_t entry = page_swap_entry(subpage);
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (folio_dup_swap_pages(folio, subpage, nr_pages) < 0) {
+		set_ptes(mm, address, ptep, pteval, nr_pages);
+		return false;
+	}
+
+	/*
+	 * arch_unmap_one() is expected to be a NOP on
+	 * architectures where we could have PFN swap PTEs,
+	 * so we'll not check/care.
+	 */
+	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+		VM_WARN_ON(nr_pages != 1);
+		folio_put_swap_pages(folio, subpage, nr_pages);
+		set_pte_at(mm, address, ptep, pteval);
+		return false;
+	}
+
+	/* See folio_try_share_anon_rmap(): clear PTE first. */
+	if (anon_exclusive && folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
+		folio_put_swap_pages(folio, subpage, nr_pages);
+		set_ptes(mm, address, ptep, pteval, nr_pages);
+		return false;
+	}
+
+	if (list_empty(&mm->mmlist)) {
+		spin_lock(&mmlist_lock);
+		if (list_empty(&mm->mmlist))
+			list_add(&mm->mmlist, &init_mm.mmlist);
+		spin_unlock(&mmlist_lock);
+	}
+
+	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
+	add_mm_counter(mm, MM_SWAPENTS, nr_pages);
+	set_swp_ptes(mm, address, ptep, entry, pteval, anon_exclusive, nr_pages);
+	finish_folio_unmap(vma, folio, subpage, nr_pages);
+	return true;
+}
+
+static inline bool unmap_anon_folio_range(struct vm_area_struct *vma, struct folio *folio,
+		struct page *first_page, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages)
+{
+	bool expected_anon_exclusive;
+	int sub_batch_idx = 0;
+	int len, ret;
+
+	for (;;) {
+		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
+		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_pages,
+						    first_page, expected_anon_exclusive);
+		ret = __unmap_anon_folio_range(vma, folio, first_page + sub_batch_idx,
+					       address, ptep, pteval, len, expected_anon_exclusive);
+		if (!ret)
+			return ret;
+
+		nr_pages -= len;
+		if (!nr_pages)
+			break;
+
+		pteval = pte_advance_pfn(pteval, len);
+		address += len * PAGE_SIZE;
+		sub_batch_idx += len;
+		ptep += len;
+	}
+
+	return true;
+}
+
 static inline bool can_unmap_lazyfree_folio_range(struct vm_area_struct *vma,
 		struct folio *folio, unsigned long address, pte_t *ptep,
 		pte_t pteval, unsigned long nr_pages)
@@ -2094,7 +2210,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	bool anon_exclusive, ret = true;
+	bool ret = true;
 	pte_t pteval;
 	struct page *subpage;
 	struct mmu_notifier_range range;
@@ -2219,8 +2335,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		address = pvmw.address;
-		anon_exclusive = folio_test_anon(folio) &&
-				 PageAnonExclusive(subpage);
 
 		if (folio_test_hugetlb(folio)) {
 			bool walk_done;
@@ -2252,6 +2366,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			if (pte_dirty(pteval))
 				folio_mark_dirty(folio);
 		} else {
+			/* Device-exclusive entry */
 			pte_clear(mm, address, pvmw.pte);
 		}
 
@@ -2289,8 +2404,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			swp_entry_t entry = page_swap_entry(subpage);
-			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
@@ -2306,57 +2419,17 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				if (!can_unmap_lazyfree_folio_range(vma, folio, address,
 				    pvmw.pte, pteval, nr_pages))
 					goto walk_abort;
-
 				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
 				goto finish_unmap;
 			}
 
-			if (folio_dup_swap_pages(folio, subpage, 1) < 0) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
+			if (!unmap_anon_folio_range(vma, folio, subpage, address,
+						    pvmw.pte, pteval, nr_pages))
 				goto walk_abort;
-			}
 
-			/*
-			 * arch_unmap_one() is expected to be a NOP on
-			 * architectures where we could have PFN swap PTEs,
-			 * so we'll not check/care.
-			 */
-			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				folio_put_swap_pages(folio, subpage, 1);
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-
-			/* See folio_try_share_anon_rmap(): clear PTE first. */
-			if (anon_exclusive &&
-			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				folio_put_swap_pages(folio, subpage, 1);
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-			if (list_empty(&mm->mmlist)) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&mm->mmlist))
-					list_add(&mm->mmlist, &init_mm.mmlist);
-				spin_unlock(&mmlist_lock);
-			}
-			dec_mm_counter(mm, MM_ANONPAGES);
-			inc_mm_counter(mm, MM_SWAPENTS);
-			swp_pte = swp_entry_to_pte(entry);
-			if (anon_exclusive)
-				swp_pte = pte_swp_mkexclusive(swp_pte);
-			if (likely(pte_present(pteval))) {
-				if (pte_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			}
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			if (nr_pages == folio_nr_pages(folio))
+				goto walk_done;
+			continue;
 		} else {
 			/*
 			 * This is a locked file-backed folio,
@@ -2372,14 +2445,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 finish_unmap:
-		if (unlikely(folio_test_hugetlb(folio))) {
-			hugetlb_remove_rmap(folio);
-		} else {
-			folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
-		}
-		if (vma->vm_flags & VM_LOCKED)
-			mlock_drain_local();
-		folio_put_refs(folio, nr_pages);
+		finish_folio_unmap(vma, folio, subpage, nr_pages);
 
 		/*
 		 * If we are sure that we batched the entire folio and cleared
-- 
2.34.1


