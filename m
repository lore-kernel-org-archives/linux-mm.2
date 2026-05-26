Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37642CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7977B6B00A8; Tue, 26 May 2026 02:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E3A6B00AA; Tue, 26 May 2026 02:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6844D6B00AB; Tue, 26 May 2026 02:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 576DB6B00A8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:39:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3B68A0282
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:59 +0000 (UTC)
X-FDA: 84808618398.30.53B4B56
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 47CDCC0011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="aK/FuvGy";
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXsNaVNEmRnlxmep/eN0kjEdgzy7nVmSUpv3ornav34=;
	b=r0QYMlmy2CHMCYuZyRR5VX9/SypzEGdgpMQeHV6896iWpZoZoxGDgr1+rSRFiwQ+8QaXpR
	uLEVbR8WZENlyqeveBktd+CnstmBoVqnTTrxgZa1upDRcoPOAFdFP77XcXoZh0jxYfJepS
	A4QLIGddNvX3ptfHL27Jr3q6JAIoLXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777538; a=rsa-sha256;
	cv=none;
	b=2T5bHm5YlqDaYDCVUjeRfTMn4T2P23A2B2MTVtuDlnus6eRNTB2WCBn2x5v/k1vs4UrelJ
	/GJjhM//oCu1zOKjCiUh3bDx6R8YjAI/AXaczKesjC4ssQYLwJsNQxb329CplArWlqwSpw
	ypq16bBQYyLvFySqMlCieVEIJai+ins=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="aK/FuvGy";
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DDFA293B;
	Mon, 25 May 2026 23:38:52 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D001F3F7D8;
	Mon, 25 May 2026 23:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777537; bh=Ls/apOXLhjT7Z049Y9VwgBHk8+bkx80IkmMGzbO429E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aK/FuvGyLF3nHGA8VCui97SKqS9sFhLN3VI9vUhuRgkhFQuUo6bRYyHuppuutbq+L
	 BIKw+LGLlH0pBtzMhUmBZqYrxUK2XKOjlUole/5PbqQdT6cPc1YtjceJpw8PBZxghH
	 TQJpF4TMp0a/0DoGwVTb4oE9q9T+Ri/FaYJsh4yc=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 12/12] mm/rmap: enable batch unmapping of anonymous folios
Date: Tue, 26 May 2026 12:06:35 +0530
Message-Id: <20260526063635.61721-13-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: ssmt5y6e1663jr7mopot4awcdiku7ini
X-Rspamd-Queue-Id: 47CDCC0011
X-Rspam-User: 
X-HE-Tag: 1779777538-667329
X-HE-Meta: U2FsdGVkX1+tfLcn+Uu8C+tcmWRd/JYc9/N4yoh4qrmWIt+1vjLv9s71TFhpE5Pp5D+nwMio9qQ8kIPv0JXdMpF3RCXAaz3d2WXQMqFFG9MaPeWvPMK7wgnXGasdbkUCUCaNYZyC2dBs35lCgPPU37859oeuM5YWnawnrX58WfY+dfNErlsZp9G2XZsr8lu7QKFU1LH0Jtgh+EZHuSXD7sAyrWLtreWRqloZnbd99rhLOG2aFzHdE6oZWnxvbxH2wNdV4+siBGxUCp6JYikJrg5DTuEvbFHPl0RxKThk5RJ6aTeONHOcoQUZtrgX8PB6uiVGTznLHm0V0LB5PCBTpyAcdlFiX1gRNvsWxoiE4ybbp6vuITcgwXeW7AlZTxA/Unl3JYWVahEd2FTnA2So8ueAY6ZOYBnfsMRfyv3xj98ow3DRFsG1hqTGntLC/p3ZE6SS6Lz1L/kzgjglDACWnL/+mlEsqN6I+IJM4TViFFtCQtjv0lKEp0MtuoOJ0JaUkhEBVQUFyjIxgEmG0+pQvbWjqe0MC5yDwYB5bknOyxFU+StUOR8fYsa9bQpAy7jMTRUJ9MTdwLKb8q90N0jo0Rlf0ZlruMekw912Cqcq96QLJCkXEem5GQV+xRHdU0hnLjqz1GzUegQzbUN2CNnIXXe0mjsD/Bw/E12xrpFxCFLB6Eh1lwPANkT1AAob0MkEoWlyQhbRXFsYe1avHbBgT/hj5y+nvCIAyaDBjcaQGeHY7WYRw/1DdzkHN379bYDT399Q9dUYqgLNm8DIkekOxcyri2nXs6oQcMJokhUbwTBJXdcwuTyG5WcrTOwwLfPEal/a6ycCGunYucnDMuXG9xse12Yj0Oo5ElWWCbNzUdvlaGhA5L8rR+pjhoHSIEHdopgglMc2KG6n4rwrasRyOlM2f4bG8sAT2vlZFme+CLBirUKhjjBNdbq2JZz9faXlkKa/CqoviAj1d9Bun7f
 J5tkmOpi
 fNBhJEwpaAyDHLGtEjkUVgTmuULJi0OQfp2mPOZNwYciJJF5v8I+mFX74jSKlpT2/vup9eWG9LmqgGI/ovYQ/kXtF7SdC+lU4ZuuoywQSlxWql7wSWUyifFVZ+sfwOzY0s+BKIsc3veGaI2IlFsGqLsGR5sDGtM83yiV/c4ZNsyXQ2NUMMEokXK3mbsW3zuyKb3/12dqPRW8vO/8usJ7NR1EhcdNn1lU49Er/9SIB0qoq9Go8KDAuVslB+A==
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
page_anon_exclusive_batch() to internal.h and reuse it.

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
this accounting code (finish_folio_unmap()) in __ttu_anon_folio() itself,
instead of doing some horrible goto jumping at the callsite
of ttu_anon_folio().

If the batch length is less than the number of pages in the folio, then
we must skip over this batch.

The page_vma_mapped_walk API ensures this - check_pte() will return true
only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the pte.
There is no pfn underlying a swap pte, so check_pte returns false and we
keep skipping until we hit a present pte, which is where we want to start
unmapping from next.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h | 17 +++++++++
 mm/mprotect.c | 17 ---------
 mm/rmap.c     | 98 +++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 92 insertions(+), 40 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b6..87a61742d1920 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -393,6 +393,23 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 		unsigned int max_nr);
 
+/*
+ * Get max length of consecutive ptes pointing to PageAnonExclusive() pages or
+ * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
+ * that the ptes point to consecutive pages of the same anon large folio.
+ */
+static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
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
index 3357058672016..950af1efdd661 100644
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
-static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
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
index b1639bad8e27f..e02d81840018c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1958,13 +1958,14 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	end_addr = pmd_addr_end(addr, vma->vm_end);
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
-	/* We only support lazyfree or file folios batching for now ... */
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
-		return 1;
 
 	if (pte_unused(pte))
 		return 1;
 
+	if (__is_defined(__HAVE_ARCH_UNMAP_ONE) && folio_test_anon(folio) &&
+	    folio_test_swapbacked(folio))
+		return 1;
+
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
 	 * upgrading write permissions for ptes that were not originally
@@ -2136,8 +2137,9 @@ static inline bool ttu_lazyfree_folio(struct vm_area_struct *vma,
 	return true;
 }
 
-static inline void set_swp_pte_at(struct mm_struct *mm, unsigned long address,
-		pte_t *ptep, swp_entry_t entry, pte_t pteval, bool anon_exclusive)
+static inline void set_swp_ptes(struct mm_struct *mm, unsigned long address,
+		pte_t *ptep, swp_entry_t entry, pte_t pteval, bool anon_exclusive,
+		unsigned long nr_pages)
 {
 	pte_t swp_pte = swp_entry_to_pte(entry);
 
@@ -2151,24 +2153,37 @@ static inline void set_swp_pte_at(struct mm_struct *mm, unsigned long address,
 			swp_pte = pte_swp_mkuffd_wp(swp_pte);
 	} else {
 		/* Device-exclusive entry */
+		VM_WARN_ON(nr_pages != 1);
 		if (pte_swp_soft_dirty(pteval))
 			swp_pte = pte_swp_mksoft_dirty(swp_pte);
 		if (pte_swp_uffd_wp(pteval))
 			swp_pte = pte_swp_mkuffd_wp(swp_pte);
 	}
 
-	set_pte_at(mm, address, ptep, swp_pte);
+	for (int i = 0; i < nr_pages; ++i, ++ptep, address += PAGE_SIZE) {
+		set_pte_at(mm, address, ptep, swp_pte);
+		swp_pte = pte_next_swp_offset(swp_pte);
+	}
 }
 
-static inline bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+static inline void finish_folio_unmap(struct vm_area_struct *vma,
+		struct folio *folio, struct page *subpage,
+		unsigned long nr_pages)
+{
+	folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
+	if (vma->vm_flags & VM_LOCKED)
+		mlock_drain_local();
+	folio_put_refs(folio, nr_pages);
+}
+
+static inline bool __ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
 		struct page *subpage, unsigned long address, pte_t *ptep,
-		pte_t pteval)
+		pte_t pteval, unsigned long nr_pages, bool anon_exclusive)
 {
-	bool anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(subpage);
 	swp_entry_t entry = page_swap_entry(subpage);
 	struct mm_struct *mm = vma->vm_mm;
 
-	if (folio_dup_swap_pages(folio, subpage, 1) < 0)
+	if (folio_dup_swap_pages(folio, subpage, nr_pages) < 0)
 		return false;
 
 	/*
@@ -2177,13 +2192,14 @@ static inline bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *foli
 	 * so we'll not check/care.
 	 */
 	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-		folio_put_swap_pages(folio, subpage, 1);
+		VM_WARN_ON(nr_pages != 1);
+		folio_put_swap_pages(folio, subpage, nr_pages);
 		return false;
 	}
 
 	/* See folio_try_share_anon_rmap(): clear PTE first. */
-	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, subpage)) {
-		folio_put_swap_pages(folio, subpage, 1);
+	if (anon_exclusive && folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
+		folio_put_swap_pages(folio, subpage, nr_pages);
 		return false;
 	}
 
@@ -2194,9 +2210,49 @@ static inline bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *foli
 		spin_unlock(&mmlist_lock);
 	}
 
-	dec_mm_counter(mm, MM_ANONPAGES);
-	inc_mm_counter(mm, MM_SWAPENTS);
-	set_swp_pte_at(mm, address, ptep, entry, pteval, anon_exclusive);
+	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
+	add_mm_counter(mm, MM_SWAPENTS, nr_pages);
+	set_swp_ptes(mm, address, ptep, entry, pteval, anon_exclusive, nr_pages);
+	finish_folio_unmap(vma, folio, subpage, nr_pages);
+	return true;
+}
+
+/*
+ * Unmap an anonymous folio from the pagetables of a process. The function
+ * may partially succeed in unmapping some pages out of nr_pages, in which
+ * case it will restore the remaining ptes and return false. Returns true
+ * if all of nr_pages were unmapped.
+ */
+static inline bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+		struct page *first_page, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages)
+{
+	bool expected_anon_exclusive;
+	int sub_batch_idx = 0;
+	int len, ret;
+
+	for (;;) {
+		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
+		len = page_anon_exclusive_batch(sub_batch_idx, nr_pages,
+						first_page, expected_anon_exclusive);
+		ret = __ttu_anon_folio(vma, folio, first_page + sub_batch_idx,
+				       address, ptep, pteval, len, expected_anon_exclusive);
+		if (!ret) {
+			/* restore the remaining ptes which got cleared */
+			set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
+			return ret;
+		}
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
 	return true;
 }
 
@@ -2392,11 +2448,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			}
 
 			if (!ttu_anon_folio(vma, folio, subpage, address,
-						    pvmw.pte, pteval)) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
+						    pvmw.pte, pteval, nr_pages)) {
 				goto walk_abort;
 			}
-			goto finish_unmap;
+			continue;
 		} else {
 			/*
 			 * This is a locked file-backed folio,
@@ -2412,10 +2467,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 finish_unmap:
-		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
-		if (vma->vm_flags & VM_LOCKED)
-			mlock_drain_local();
-		folio_put_refs(folio, nr_pages);
+		finish_folio_unmap(vma, folio, subpage, nr_pages);
 
 		/*
 		 * If we are sure that we batched the entire folio and cleared
-- 
2.34.1


