Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C7DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E9F6B00A1; Tue,  7 Jul 2026 08:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716B36B00A2; Tue,  7 Jul 2026 08:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62BDE6B00A4; Tue,  7 Jul 2026 08:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39AE26B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:11:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D7D5403F7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:11:56 +0000 (UTC)
X-FDA: 84961867032.19.8D0B4B2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id BE4BA40002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:11:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XBReOm5R;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783426315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7D7XFj/eh5W6fzYEhKm8WyzXy5PcnLEniXrUDaZJjwQ=;
	b=7u9afVQJDR0Q0IIwdgyq2reEED1A27p49yw0aeEL6PCHCeMYz+4HYWLdAZ5S5zyy/HyTYK
	lokl+/OcaoMtrwdGsn5VbTx9MZPAhkSt52lzUE85VYMVlTMikh+xP5yfsJrKveu46eb0dz
	frcKA2KrCMzFN810A2qPxySO2W05E9Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XBReOm5R;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783426315;
	b=f3JteLvGf9vPVGV1u+4U6S/QeULmPuLcTOqNXQF1ReuVnQA0i1p/T7Rb8VRAdynR6dyj73
	d848uqYR0UbBFlrxop/IcFpUX+xRPNdEV9oSsRz/9AZKOQlwqi3XxElhI+oSoeZZHSZyL/
	Ru25ymF1CBnZVr4t4JV432fTURkH7fw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A57691A00;
	Tue,  7 Jul 2026 05:11:49 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BD8543F7B4;
	Tue,  7 Jul 2026 05:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783426314; bh=/RFbSK9dN8trHTjRue1p+mJ7OAtMSXL0eJsUJFtBm8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBReOm5RsRnx/Vscm7oDn0k+nvvIqbi9D8CD4TnJS8pranuGfl1jzkin3WyIH7EfT
	 kzPkj4iN2ckPwyyBgBC/t2PLXXvl1AwO4oSSTduPrKj7Wh94Q1VMmy/QF0P3u9z5ce
	 SYbtEYxppmnJG7qhCqlhknrjmGht7mkAq2ReiluM=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 2/5] mm/rmap: Add try_to_unmap_hugetlb_one
Date: Tue,  7 Jul 2026 12:11:20 +0000
Message-ID: <20260707121128.373192-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707121128.373192-1-dev.jain@arm.com>
References: <20260707121128.373192-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE4BA40002
X-Stat-Signature: d7m4b89aup3f8s7ykscf6ste9j4bmc87
X-HE-Tag: 1783426314-53800
X-HE-Meta: U2FsdGVkX1+BcjPb13HnudNVeNllAC40M4rtVxzDNmUvoukANo970TDCefrdYqxXAIbu1cD1+mqMJWzCyU2Z4kTHd7AhNKqMJIuw+xcLlSnHqvtoMAIvlQg03rV4mabC+uam/JginLnNbz2dLDYlhC9NSlY9Xw92mEA1gSUNUuvnaVpoZUvHDOpuzBLej1f5XB3snA2ho0bqid1BiqGOkli0fjRD1eTUNwTOqubVpfAtyXkjHl1uzTDLorzl1DVDk/oTxq3OtwCeW04qeAS6QVlkmotAsxNJAg2+OstcqD9cjJJKEDp+jAhbNUZHF+pVL28TZUILTT0PQ3x28YLSDTIlEeS4E6CBQ0vzuHFnr1jbG48QWMmtT73l7de3HTwhz51Q/J6yvpR0gVjrMtiRNJ/r0u7I53GtSl9ZzzJw41H96Ww4F8PvdosdlvjwiLdjSI9ddptB81IqFm65VORfE97ri0GPC01PfwjA8t7nfRLS0RqIdzjWS3oxMI+5daBRJ8RpeMXheHaNxjj0hDRJX4GXmcMzzhl9amN7xLk3037DOdMHl6bk+16LKymSuTDhpfPj0xFIsFX/qdAsBdSI7PpmmySCiqmwOq71RBi8CJftFwTvgPwIOuzlXSb6rhoF0ZFWyAZXxgm4al1i7Cw4IHMw6/BxF7B11TLpULBWATZR6Fh2kloFVBK2jKVCilnFOzH1Yu3FrcnemVaqg5Lfybl9zlQcqrIYMRB9a9WqsCrZGsaFGn0RVVMkDokB8CmmX7/kEex1vFgy7cQajZqYSj6DBuGdG6S4sF+pOYWC116gDK0KLM0BUaVpQUoTP9zf3zV9dlnMBSTYpcK9tTs0cuXSkFaMX1tKf6xUTMhncdpOgCAU10rQCWjYZdLGGowTXkUJJ9sHu5papOuZn7qV0F7434aqZ5E2a67d25sVL40pkqzKhBdFt2VS0Q60kRwny/ZePDPFeUy79xHBtO7
 jyaRVsot
 14n1FLh/D7u48uo9rKQSym67K4kZSJYi77aLdrq3RXmUOFh96T4bRUMPlLCRd6V4DamKbfR8tBu2TjwuF1zb9shr//ODHa/ok1u1q4O+tfRxVN7jSPcUvHKM9dwCStc/EJjOec6b7CddwBp18qi6TVjTQINlv/oO+R7MeYwRxcs7Z4c8HnQL4bgYHTk/hTCqjKyTPou/4FOYWWHs/8Ri5TfW/n/FgKT3G4MH9UaU19MJY4NgpvbSsITiaphifDfGgDMmvhW299LtQDuz+uIjO6wiRxIqop2vZ06DeF0oD2W4GWMm6Ge5KzY7Pw9NEHF9dSwZT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify try_to_unmap_one() by separating the hugetlb parts into
try_to_unmap_hugetlb_one().

To understand the correctness of the refactoring, the following points
are noted:

1. try_to_unmap() is called for hugetlb folios only when they are
   hwpoisoned.

2. A hugetlb VMA cannot be mlocked.

3. page_vma_mapped_walk() returns at most one hugetlb mapping in a VMA,
   and that mapping points at the head PFN.

4. We won't ever process a softleaf entry that encodes a hugetlb folio;
   hugetlb folios are never swapped out, migration entries will be
   skipped (PVMW_MIGRATION not passed), and device-exclusive does not
   work for hugetlb.

5. The hwpoison entry is constructed from the poisoned folio, just as in
   the pre-refactor code. Any previous uffd-wp state is deliberately not
   preserved for the hwpoison entry.

6. TTU_HWPOISON is always present; for it to not be present, either the
   folio has to be in swapcache, or mapping_can_writeback() is true (see
   unmap_poisoned_folio), none of which is true for hugetlb folios.

7. Hugetlb uses separate counters from normal rss counters, therefore
   update_highwater_rss() need not be called.

While at it:

 - Change VM_BUG_* to VM_WARN_*.

 - Do not declare variables which are only used once.

 - Use huge_pte_dirty() instead of pte_dirty().

 - Add 3 VM_WARN_ON_ONCE asserting that TTU_HWPOISON should be present,
   pte_present() must be true, and the pfn derived from the huge pte
   must be that of the head of the hugetlb folio.

Except the BUG->WARN change, no functional change intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/hugetlb.h |   1 +
 mm/rmap.c               | 177 +++++++++++++++++++++-------------------
 2 files changed, 96 insertions(+), 82 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 4115076e4922a..bf7e163e3779d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1271,6 +1271,7 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 }
 
 pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+unsigned long huge_pte_dirty(pte_t pte);
 
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
diff --git a/mm/rmap.c b/mm/rmap.c
index dbb077f8443e3..934773dfa2f2a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1978,6 +1978,95 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static bool try_to_unmap_hugetlb_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long address, void *arg)
+{
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
+	struct mmu_notifier_range range;
+	enum ttu_flags flags = (enum ttu_flags)(long)arg;
+	struct mm_struct *mm = vma->vm_mm;
+	const unsigned long hsz = huge_page_size(hstate_vma(vma));
+	bool ret = true;
+	pte_t pteval;
+
+	/*
+	 * The try_to_unmap() is only passed a hugetlb folio in the case
+	 * where the hugetlb folio is poisoned.
+	 */
+	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
+	VM_WARN_ON_ONCE(!(flags & TTU_HWPOISON));
+
+	range.end = vma_address_end(&pvmw);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				address, range.end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	mmu_notifier_invalidate_range_start(&range);
+
+	/* There is only a single mapping in a VMA. */
+	if (!page_vma_mapped_walk(&pvmw))
+		goto range_end;
+
+	address = pvmw.address;
+	pteval = huge_ptep_get(mm, address, pvmw.pte);
+	VM_WARN_ON_ONCE(!pte_present(pteval));
+	VM_WARN_ON_ONCE(pte_pfn(pteval) != folio_pfn(folio));
+
+	/*
+	 * huge_pmd_unshare may unmap an entire PMD page. There is no way of
+	 * knowing exactly which PMDs may be cached for this mm, so we must
+	 * flush them all. start/end were already adjusted above to cover this
+	 * range.
+	 */
+	flush_cache_range(vma, range.start, range.end);
+
+	/*
+	 * To call huge_pmd_unshare, i_mmap_rwsem must be held in write mode.
+	 * Caller needs to explicitly do this outside rmap routines.
+	 *
+	 * We also must hold hugetlb vma_lock in write mode. Lock order dictates
+	 * acquiring vma_lock BEFORE i_mmap_rwsem. We can only try lock here and
+	 * fail if unsuccessful.
+	 */
+	if (!folio_test_anon(folio)) {
+		struct mmu_gather tlb;
+
+		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
+		if (!hugetlb_vma_trylock_write(vma)) {
+			ret = false;
+			goto walk_done;
+		}
+
+		tlb_gather_mmu_vma(&tlb, vma);
+		if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
+			hugetlb_vma_unlock_write(vma);
+			huge_pmd_unshare_flush(&tlb, vma);
+			tlb_finish_mmu(&tlb);
+			/*
+			 * The PMD table was unmapped, consequently unmapping
+			 * the folio.
+			 */
+			goto walk_done;
+		}
+		hugetlb_vma_unlock_write(vma);
+		tlb_finish_mmu(&tlb);
+	}
+	pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
+	if (huge_pte_dirty(pteval))
+		folio_mark_dirty(folio);
+
+	pteval = swp_entry_to_pte(make_hwpoison_entry(folio_page(folio, 0)));
+	hugetlb_count_sub(folio_nr_pages(folio), mm);
+	set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+	hugetlb_remove_rmap(folio);
+	folio_put_refs(folio, 1);
+
+walk_done:
+	page_vma_mapped_walk_done(&pvmw);
+range_end:
+	mmu_notifier_invalidate_range_end(&range);
+	return ret;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -1993,7 +2082,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
-	unsigned long hsz = 0;
 	int ptes = 0;
 
 	/*
@@ -2007,8 +2095,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
-	 * For hugetlb, it could be much worse if we need to do pud
-	 * invalidation in the case of pmd sharing.
 	 *
 	 * Note that the folio can not be freed in this function as call of
 	 * try_to_unmap() must hold a reference on the folio.
@@ -2016,17 +2102,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	range.end = vma_address_end(&pvmw);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, range.end);
-	if (folio_test_hugetlb(folio)) {
-		/*
-		 * If sharing is possible, start and end will be adjusted
-		 * accordingly.
-		 */
-		adjust_range_if_pmd_sharing_possible(vma, &range.start,
-						     &range.end);
-
-		/* We need the huge page size for set_huge_pte_at() */
-		hsz = huge_page_size(hstate_vma(vma));
-	}
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
@@ -2111,66 +2186,13 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			const softleaf_t entry = softleaf_from_pte(pteval);
 
 			pfn = softleaf_to_pfn(entry);
-			VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-		if (folio_test_hugetlb(folio)) {
-			bool anon = folio_test_anon(folio);
-
-			/*
-			 * The try_to_unmap() is only passed a hugetlb folio
-			 * in the case where the hugetlb folio contains a
-			 * poisoned page.
-			 */
-			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
-			/*
-			 * huge_pmd_unshare may unmap an entire PMD page.
-			 * There is no way of knowing exactly which PMDs may
-			 * be cached for this mm, so we must flush them all.
-			 * start/end were already adjusted above to cover this
-			 * range.
-			 */
-			flush_cache_range(vma, range.start, range.end);
-
-			/*
-			 * To call huge_pmd_unshare, i_mmap_rwsem must be
-			 * held in write mode.  Caller needs to explicitly
-			 * do this outside rmap routines.
-			 *
-			 * We also must hold hugetlb vma_lock in write mode.
-			 * Lock order dictates acquiring vma_lock BEFORE
-			 * i_mmap_rwsem.  We can only try lock here and fail
-			 * if unsuccessful.
-			 */
-			if (!anon) {
-				struct mmu_gather tlb;
-
-				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-				if (!hugetlb_vma_trylock_write(vma))
-					goto walk_abort;
-
-				tlb_gather_mmu_vma(&tlb, vma);
-				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
-					hugetlb_vma_unlock_write(vma);
-					huge_pmd_unshare_flush(&tlb, vma);
-					tlb_finish_mmu(&tlb);
-					/*
-					 * The PMD table was unmapped,
-					 * consequently unmapping the folio.
-					 */
-					goto walk_done;
-				}
-				hugetlb_vma_unlock_write(vma);
-				tlb_finish_mmu(&tlb);
-			}
-			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
-			if (pte_dirty(pteval))
-				folio_mark_dirty(folio);
-		} else if (likely(pte_present(pteval))) {
+		if (likely(pte_present(pteval))) {
 			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
 			end_addr = address + nr_pages * PAGE_SIZE;
 			flush_cache_range(vma, address, end_addr);
@@ -2211,14 +2233,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 */
 		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
-			if (folio_test_hugetlb(folio)) {
-				hugetlb_count_sub(folio_nr_pages(folio), mm);
-				set_huge_pte_at(mm, address, pvmw.pte, pteval,
-						hsz);
-			} else {
-				dec_mm_counter(mm, mm_counter(folio));
-				set_pte_at(mm, address, pvmw.pte, pteval);
-			}
+			dec_mm_counter(mm, mm_counter(folio));
+			set_pte_at(mm, address, pvmw.pte, pteval);
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
 			   !userfaultfd_armed(vma)) {
 			/*
@@ -2346,11 +2362,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 discard:
-		if (unlikely(folio_test_hugetlb(folio))) {
-			hugetlb_remove_rmap(folio);
-		} else {
-			folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
-		}
+		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
@@ -2398,7 +2410,8 @@ static int folio_not_mapped(struct folio *folio)
 void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 {
 	struct rmap_walk_control rwc = {
-		.rmap_one = try_to_unmap_one,
+		.rmap_one = folio_test_hugetlb(folio) ?
+				try_to_unmap_hugetlb_one : try_to_unmap_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
-- 
2.43.0


