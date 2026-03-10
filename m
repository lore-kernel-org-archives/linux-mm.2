Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74484FCC9D4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B256B00A3; Tue, 10 Mar 2026 03:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2BE96B00A5; Tue, 10 Mar 2026 03:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00976B00A6; Tue, 10 Mar 2026 03:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA9486B00A3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:32:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 571378BF84
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:32:13 +0000 (UTC)
X-FDA: 84529334946.08.000F7E2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9510E18000E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:32:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K8NjpFqZ+b95hZrx8Gr9ZSjjZWVkk6Htb0xa2KJwvBI=;
	b=wSJF+nNjds4JcA34+tWB/2lTsyBJGKRVfwNTQBlyfGm4KAPB65h+Q/AFb3JXJ8Q9sDvmjf
	23CG4TwvI0sTbKAaBf4YocQPyDdmvZ/6Nwfn3K8MaPjvZPuIkZrl93+HnP15GYRjyAWFCS
	KQn6mlLuO1BgZGT0oVsomKojUYplA0E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773127931; a=rsa-sha256;
	cv=none;
	b=zczDBhoXD1TX10C+zxWS9WTHB9jlJBorQzqVDYEI69u1tm5XNRSI3qa3yR9FlB7UTPAVAg
	2EHnlnbp7Q6ErNUZj0Cg8CW4qtfivLWzXBUALcd9BRH/kJ0pXO37X8KQ7u2QT525x6g1XL
	0/CUG0qxdqdKiJiu4FJT2ncD7U3v0WU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 886A01FC4;
	Tue, 10 Mar 2026 00:32:04 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DE7BD3F73B;
	Tue, 10 Mar 2026 00:32:01 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: weixugc@google.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	ziy@nvidia.com,
	kas@kernel.org,
	willy@infradead.org,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 9/9] mm/rmap: enable batch unmapping of anonymous folios
Date: Tue, 10 Mar 2026 13:00:13 +0530
Message-Id: <20260310073013.4069309-10-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9510E18000E
X-Stat-Signature: kj895yneptgq6bjc51qjz5p4hy1wcasx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773127931-626999
X-HE-Meta: U2FsdGVkX19aOYxhkKHTzoFoQ5NXCC3SYjW+Nw4dONbzdRgqYiE2GMAvrElC4HXy0k/+Sww+/f/we4y8ZlzmxGvJaxsMQCfZDKsxUdwQfuYyf/QMd60UDLnnwjICIsReeaIX6XgTy+hpef1HopHF3Xij0BeZDAUzM6/CCPM8NfnTxFRh+sjcXakQIjEWyAOgeZtpFhg1bRj61UYNo8ZJlYMQP32lNvsjH+FeliSiYa2VJuNu0MsUSG2SRdoaxVUIcILtX5FPU7KOhAvzXM3r0Ufup9M+vJ060YoMP/raFmHbtsObKrIWdo/JYZGqM0KdBlW1snnlqGQMe0O9pvamMOCf6Iakn1uVAaMpFa//b25M3enDh+5fjkHnrchF5Q4Oh1cSXi33zYTny+gFxVrNixHzV9Wsf8B07vI9QkqZbz2YdeFXYU1eesC3D8rl7zxlJ3MnjRoe81zK5emxjxglK++qkn76xjoai4EVj+1AsT4/P4zXtTuBwrvYXCffoFJJufRG6pdgnnZxJNBqzjLREmfu7xjCVAjs2YuG4+Q0kYOhNe6cmX2lYFW/tv9NFmjRwGqPqcNQK5EArHQe8jQWnuOr6vGnHA6IBmWLtnKoGW00aGKqBhhirspMaLIPa8ZTi8M6zO3C1UBT34RSREt7o8rLHNAaUfQNcy5L1VSVJmwc3mQu2norgWa2Y24FYleSSE2/LXX19Nr1V5F9KfTZYMrXGOffS3Hot9NyLLynnykdtlT1AIFwWRfUtlERULeanvCjo3ICVEa12jdzUIEw8R+j5Zw4naJ/N+vqi76Q/D0tHpxx7zzOw4OQUqsj0gUJApOlnIYmjwrlLtpdckRGWCI7nFcXmpncQkCCjKSqGedfIG47c04psYEFJQDTzKzLqjhnCwkyeHzUAZxn3Gl2alsCqvWWBPH/+C/1W/k+mv97Z5Y+PiGQ6T23dSu2AIO3QNagN5fZe/yTmF6190D
 0m0VxlGh
 Aouh+DxvIMfCaVAY+lBi9+4Zy1mZJ9UN0m2WJKsqEd/KQ6g3dNBiJl3MQGYIVw+7atSI2y+JKHaos1DWc8pln297bpCOFIXK1O1NuH3wBQw9C0OSleaISo7w8sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable batch clearing of ptes, and batch swap setting of ptes for anon
folio unmapping. Processing all ptes of a large folio in one go helps
us batch across atomics (add_mm_counter etc), barriers (in the function
__folio_try_share_anon_rmap), repeated calls to page_vma_mapped_walk(),
to name a few. In general, batching helps us to execute similar code
together, making the execution of the program more memory and CPU friendly.

The handling of anon-exclusivity is very similar to commit cac1db8c3aad
("mm: optimize mprotect() by PTE batching"). Since folio_unmap_pte_batch()
won't look at the bits of the underlying page, we need to process
sub-batches of ptes pointing to pages which are same w.r.t exclusivity,
and batch set only those ptes to swap ptes in one go. Hence export
page_anon_exclusive_sub_batch() to internal.h and reuse it.

arch_unmap_one() is only defined for sparc64; I am not comfortable changing
that bit of code to enable batching, the nuances between retrieving the
pfn from pte_pfn() or from (paddr = pte_val(oldpte) & _PAGE_PADDR_4V)
(and, pte_next_pfn() can't even be called from arch_unmap_one() because
that file does not include pgtable.h), especially when I have no way to
test the code. So just disable the "sparc64-anon-swapbacked" case for now.

We need to take care of rmap accounting (folio_remove_rmap_ptes) and
reference accounting (folio_put_refs) when anon folio unmap succeeds.
In case we partially batch the large folio and fail, we need to correctly
do the accounting for pages which were successfully unmapped. So, put
this accounting code in __commit_ttu_anon_swapbacked_folio() itself,
instead of doing some horrible goto jumping at the callsite of
commit_ttu_anon_swapbacked_folio(). Similarly, do the jumping-over-batch
immediately after we succeed in the unmapping of the entire batch, and
continue to the next (unlikely) iteration.

Add a comment at relevant places to say that we are on a device-exclusive
entry and not a present entry.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h |  26 ++++++++
 mm/mprotect.c |  17 -----
 mm/rmap.c     | 170 +++++++++++++++++++++++++++++++++++---------------
 3 files changed, 144 insertions(+), 69 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 95b583e7e4f75..c29ecc334a06b 100644
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
+static inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
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
index 9681f055b9fca..9403171d648b6 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -138,23 +138,6 @@ static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long add
 		tlb_flush_pte_range(tlb, addr, nr_ptes * PAGE_SIZE);
 }
 
-/*
- * Get max length of consecutive ptes pointing to PageAnonExclusive() pages or
- * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
- * that the ptes point to consecutive pages of the same anon large folio.
- */
-static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
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
index bba5b571946d8..334350caf40b0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1946,11 +1946,11 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
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
@@ -1963,6 +1963,112 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static inline void set_swp_ptes(struct mm_struct *mm, unsigned long address,
+		pte_t *ptep, swp_entry_t entry, pte_t pteval, bool anon_exclusive,
+		unsigned int nr_pages)
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
+		/* Device-exclusive entry: nr_pages is 1. */
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
+static inline int __commit_ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+		struct folio *folio, struct page *subpage, unsigned long address,
+		pte_t *ptep, pte_t pteval, long nr_pages, bool anon_exclusive)
+{
+	swp_entry_t entry = page_swap_entry(subpage);
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (folio_dup_swap(folio, subpage, nr_pages) < 0) {
+		set_ptes(mm, address, ptep, pteval, nr_pages);
+		return 1;
+	}
+
+	/*
+	 * arch_unmap_one() is expected to be a NOP on
+	 * architectures where we could have PFN swap PTEs,
+	 * so we'll not check/care.
+	 */
+	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+		VM_WARN_ON(nr_pages != 1);
+		folio_put_swap(folio, subpage, nr_pages);
+		set_pte_at(mm, address, ptep, pteval);
+		return 1;
+	}
+
+	/* See folio_try_share_anon_rmap(): clear PTE first. */
+	if (anon_exclusive && folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
+		folio_put_swap(folio, subpage, nr_pages);
+		set_ptes(mm, address, ptep, pteval, nr_pages);
+		return 1;
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
+	folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
+	if (vma->vm_flags & VM_LOCKED)
+		mlock_drain_local();
+	folio_put_refs(folio, nr_pages);
+	return 0;
+}
+
+static inline int commit_ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+		struct folio *folio, struct page *first_page, unsigned long address,
+		pte_t *ptep, pte_t pteval, long nr_pages)
+{
+	bool expected_anon_exclusive;
+	int sub_batch_idx = 0;
+	int len, err;
+
+	for (;;) {
+		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
+		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_pages,
+						    first_page, expected_anon_exclusive);
+		err = __commit_ttu_anon_swapbacked_folio(vma, folio, first_page + sub_batch_idx,
+				address, ptep, pteval, len, expected_anon_exclusive);
+		if (err)
+			return err;
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
+	return 0;
+}
+
 static inline int commit_ttu_lazyfree_folio(struct vm_area_struct *vma,
 		struct folio *folio, unsigned long address, pte_t *ptep,
 		pte_t pteval, long nr_pages)
@@ -2022,7 +2128,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	bool anon_exclusive, ret = true;
+	bool ret = true;
 	pte_t pteval;
 	struct page *subpage;
 	struct mmu_notifier_range range;
@@ -2148,8 +2254,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		address = pvmw.address;
-		anon_exclusive = folio_test_anon(folio) &&
-				 PageAnonExclusive(subpage);
 
 		if (folio_test_hugetlb(folio)) {
 			bool anon = folio_test_anon(folio);
@@ -2224,6 +2328,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			if (pte_dirty(pteval))
 				folio_mark_dirty(folio);
 		} else {
+			/* Device-exclusive entry */
 			pte_clear(mm, address, pvmw.pte);
 		}
 
@@ -2261,8 +2366,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			swp_entry_t entry = page_swap_entry(subpage);
-			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
@@ -2282,52 +2385,15 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto discard;
 			}
 
-			if (folio_dup_swap(folio, subpage, 1) < 0) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
+			if (commit_ttu_anon_swapbacked_folio(vma, folio, subpage,
+							     address, pvmw.pte,
+							     pteval, nr_pages))
 				goto walk_abort;
-			}
 
-			/*
-			 * arch_unmap_one() is expected to be a NOP on
-			 * architectures where we could have PFN swap PTEs,
-			 * so we'll not check/care.
-			 */
-			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				folio_put_swap(folio, subpage, 1);
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-
-			/* See folio_try_share_anon_rmap(): clear PTE first. */
-			if (anon_exclusive &&
-			    folio_try_share_anon_rmap_ptes(folio, subpage, 1)) {
-				folio_put_swap(folio, subpage, 1);
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
+			if (likely(nr_pages == folio_nr_pages(folio)))
+				goto walk_done;
+			page_vma_mapped_walk_jump(&pvmw, nr_pages - 1);
+			continue;
 		} else {
 			/*
 			 * This is a locked file-backed folio,
-- 
2.34.1


