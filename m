Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8231BCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85136B00A7; Wed,  6 May 2026 05:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5CAC6B00A8; Wed,  6 May 2026 05:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72896B00A9; Wed,  6 May 2026 05:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3E566B00A7
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:46:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E4981406F2
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:46:38 +0000 (UTC)
X-FDA: 84736515276.05.3D9666D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2215C0003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:46:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Hz1siJal;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778060797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mt2fpXDwXQ3T8r0WOa9KdTvNWuCrso1QeUfJ/OMSl0Y=;
	b=nlO7G20oMiUAER9OuzslYIZAEfzcrbVs3hqGYOvxrZqdVrEAO9IuSma2BR9FH7hVDz959b
	7E0cTaxSogf9k/rE5fpg+tNm1ty4Z7whNfamyns0Za7AW+0kms4vgBThYDsulunH4bAoRH
	DNW393FireuPj4WSjefpWL4YnxkM8/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778060797; a=rsa-sha256;
	cv=none;
	b=Os573/bQ4mC9D3JnA/0Tksk87ISRnKC+abQW8wZjTDm5z1FT0xPTDjE5xifMJ5P0QIPyHa
	Cx1KSGOQ44M0l8lOwJLk3ALNOYplc69fmyO3Mhl5XpCzJWL/0aw/7u4xx3GDTsrCmVMkvb
	ndPy849pmOKEC+xdIl44zSbBwRhgD80=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Hz1siJal;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 813FF344A;
	Wed,  6 May 2026 02:46:30 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EDF2C3F7B4;
	Wed,  6 May 2026 02:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778060795; bh=wyD0+DSn4ClswBHo+WnIVVOfijYqmBR41s18B5OKO3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hz1siJalwPr1peOZ90qGM6tXwcZnLftuKnf7I+dFr6g047sBFUPOpwboUnceJhXnk
	 hxV4mjVQv9xHPVyrVmzmUNq8jpZETAU1iQyNsvL9FkIL+QUP80ZrA4064cm+1m+MYN
	 +PIQFEpPQXd3r20hsfv17dprmYyOKVPTbU+lQD/w=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 9/9] mm/rmap: enable batch unmapping of anonymous folios
Date: Wed,  6 May 2026 15:15:04 +0530
Message-Id: <20260506094504.2588857-10-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506094504.2588857-1-dev.jain@arm.com>
References: <20260506094504.2588857-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2215C0003
X-Stat-Signature: e3e8tpo8tzwo7gced1b7hmcos3ca6fop
X-Rspam-User: 
X-HE-Tag: 1778060796-58016
X-HE-Meta: U2FsdGVkX1/koDv1CeKM8j+myUxKUzpZLPnLeC40Ek9DLuOz4agRPb8zCn7jbWh+CFHMuIfoVTtqk4E44bMDzGSINS0Cco++7u6Z8W6IfxdFK+XYi2cJhaRIizJLtLlxBJv1eg8J3bnQ1TmyJK/5A2X8uU43nNkSdRq4h6RdmQIAEoGYSy8zNqm1zYbXgqCiiNsyOXdCOt4edvl2OzaLFeA/oJn+Br9sUJand3HqyKjQ5/8UQT4QsxT4bmBACEEjUXJApJPqab8zeYbNEzCNzT9Id66crivLThawPjS3ZqvuG2kisxoKAJHsS/oiiYOubazUwIa/wQVEPK5qxzzZk0FsXtnI2VdqYlcn7qSzlSsQRa7dzD0Rto/N8AHIZQ8I/JVaxbkPZ53Sx6ADXYc9by1Ojqx68gG1s0o46OzJ0BnvpPwoVfLlmxfYNL0Sz7B5LoJk97VbK8kV5My5MoDxx7Y9I6C/B1BXB/ykrNCzxlX50dG/NTjnSJTDl38XimmRiYtNvIk6c/MOU36sO7Xk2ZwJwuDgGpDi8RQSs8cpqrihNReELC1ezGzBg4FCOj1ZfxDpHrKu8c0QOsgURN3G9GB8G4p/mZft0Mpt5x+09ZlCjzHk67S3b1EteQyOc8Vs8lBHTZlVRpzo2pDkdvjwVpsVJCyIWAh+Cj3ZfwmVvH1SGSmjN2p37POpFE3syo3hW8Tz6cQMOzKGHuuMUXED642KflrvfLA4zh+2n1USufjLgokuSQT/84ZrlTlcV8Uzy8lGANv1snpPNgBxEwfsuTEbq45kHF4qlTFADeRouDHShuWdHopLlQUfsCBYXP65ZG2jKaPcu9l6s+vpxkyO4o/g/RIG35uPjdZMrcFVHGXpUmIY5heXHpKYJXdfVtkLBiWA0Noxzlt+ZKQMPxnITYwyu9JJFVCRQHs/hFB1gOAXllGInRxK0TmlnAuJheCXsH8cPXD8oCz3/mDxhvZ
 O+dKGy80
 oNnDuRby0GslWaQeK0KZ1uj8swTX6KFDI+zifQ+7kN8gx2I+ryBmRxGCh96TgxNgBXqWpGgku/7Qn8MKftAiJ9+U7UU0c40EaiROZ2uIoQ7OX/weE8gkvnevRneBVdgxnb/duaBu+ADyjpAtDbTmi/Iy9R/G+GXTMWP4azut6TjgtssAuaM/RKSJbj+sdW+uyNwAqg7pq9bbXIsStJGQ0Ux3T0ZoMx6lKEVglJ4jRbffNgwvxHUJYrIQ9dw==
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
index 5a2ddcf68e0b6..65ccb959f6220 100644
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
index 7cbf850182187..fc953f36d4527 100644
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
@@ -2095,7 +2211,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	bool anon_exclusive, ret = true;
+	bool ret = true;
 	pte_t pteval;
 	struct page *subpage;
 	struct mmu_notifier_range range;
@@ -2220,8 +2336,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		address = pvmw.address;
-		anon_exclusive = folio_test_anon(folio) &&
-				 PageAnonExclusive(subpage);
 
 		if (folio_test_hugetlb(folio)) {
 			bool exit_walk;
@@ -2255,6 +2369,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			if (pte_dirty(pteval))
 				folio_mark_dirty(folio);
 		} else {
+			/* Device-exclusive entry */
 			pte_clear(mm, address, pvmw.pte);
 		}
 
@@ -2292,8 +2407,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			swp_entry_t entry = page_swap_entry(subpage);
-			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
@@ -2309,57 +2422,17 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2375,14 +2448,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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


