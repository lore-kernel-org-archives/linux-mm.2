Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64955C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0646B00B6; Thu, 23 Jul 2026 03:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A75D6B00B8; Thu, 23 Jul 2026 03:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E48E6B00B9; Thu, 23 Jul 2026 03:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C96F6B00B6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:10:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 966721A03F0
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:10:21 +0000 (UTC)
X-FDA: 85019167842.22.63E9CAA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id D7DCA40008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:10:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=R5MPS6w6;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784790620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIoKGEePLaBcdqBNiIRu9M84lwec+W6DGlNhgHzjGSc=;
	b=ntfrP8Y+/Y+lflcdXMVCzqAll2ChnmBL5NtJhitaNNzidfsozvmMkXpMVti62wcAs2J2Cm
	iKKzGGxmnGjVeEJpTpEf7nsLYLtAqnI6PKzW4p6yhKJaJM2mWfl1SSUBcNBl4INaPmvjbI
	SczD/m/fS16PX5M6O56CuAHqhibvig4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=R5MPS6w6;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784790620;
	b=sDxAb7BXkNlqDqrjxl4ySwIn1uRNlEhtTS9KndopnP4r8/munG2eUfv2IA6cInHpcTmhLI
	ImOn5dhDZgZsZHToIxjOmITJYdLj5WsVpnAXapqlVxlzCE543b0RbGoTTdhkymxdLF0rAo
	Ftw6WaO9SS4//DiR+4aQd8A38GLEsbA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D31DC1AED;
	Thu, 23 Jul 2026 00:10:14 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 238753F66F;
	Thu, 23 Jul 2026 00:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784790619; bh=PxwT6mWSPP9EyD8pHEjnkgPbq1rD2M7Uz/EHtUtZK2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5MPS6w6WsooTFscBvjQ2SWWUz9XC1/NrthfP05QZsEBYHT46n4gn6a7Wpo7JBfwx
	 ZQPUhLhlBOTSgNxBssd/kY6lKUoyp9z0+Fb8aGYjpXMlUwx/0F9MQ4hM2x7fYzEGmK
	 lbPpjvgsyS1/UxxXP0sy1oUJgnRNgzP2I/wBZNvM=
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
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 8/8] mm/rmap: batch unmap anonymous swap-backed large folios
Date: Thu, 23 Jul 2026 07:09:04 +0000
Message-ID: <20260723070905.3422276-9-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723070905.3422276-1-dev.jain@arm.com>
References: <20260723070905.3422276-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D7DCA40008
X-Stat-Signature: rwpqdrfy5k87pejc8rhwhqcqc9thkub1
X-HE-Tag: 1784790619-302505
X-HE-Meta: U2FsdGVkX19gVS/SjLq6qgBGq6LeaqFdM7qbFTUn2BTFBFNVcfhguTEaGGfd7hKFbI1R1BTLe06yOb5QTTddB9tj0D9y1GH1nzUd8CXMidoupVYk35vkrS1xBV2KZ1rFdyCMjWDIbTelmGhL35dqyjyQPJXLq/Voi62F/cIO5UzS4pSkC+4M1T/EY5/olEhjn9d7Pve5IZhMP2Onk6io5owMlCh7XqLwBvybqBUXvf/Rx2Y+dC5omi2pU5CLb//OuKlytP618hcyrfxSWD98a+Do30mCEiiONmoZuT17NVteqqa2EhYZBSnIex3NEbWx9mDaxV7pnPZfqbadVS3nDjubv2A0o+7JI/boL7j4+BBvOas7ra58g5ykUdUAeVqpb5bMOmtMOOveuGG+r84k2wusFCy/OAZwNcdiiA4VtRnvtkDJ/q0vu4QwYU+sBOa3NSqd5JJC+0f1RixBXkmMmwVopaUxHPpjccNWXh8WsOvMnONHJTxp2eDm66VB4aNx/8f9KtT0UWMKxr2dE6o0D960agJFurEI091SLFyn7r6hVEdVwhUwhYrjqo+YqkynSKcCw+DoOxACtotl+9yN6dbnIZ+TrqxMFm/wmnDS01MLE4IqM75EXX55L/SSM3T8QkwDrfd6lhzpsVSfxGepf0Kx92+EsX3H98R9uFRKPv7JAR3u5mfFOOvTybiMCChNQdCN4utYi3hSG7UjMeCLSb6630cpZ5RlGvAibdXCwG2mLqtLxbE9Uq4m834i5xnzPYZGddAUI6pgaxcGZIfXZlvl+4PE8moxsmL2wyDHfMFZdOKfJv9YoAzcGL/R5nHml3sNLN6chnA4EQ6Na6lQirdaJD0CYXXMuYPKJC64X3qWIP/kQC6h/8qZY9y/EVTFj/B18khWG2qKLUYtzJUy6KaWjt2oLhKqj6bAo3echqt+ai2SWrdIviW0Zu7M/j9LI+d9quFWqTunGJVo50J
 jO7YoPlY
 CWGeg8Kasldg4U2ChxZ0chLbZaai+IIJdZ8wAhCaUneRzGl1f65IcluxFI/sCqXvu3CfOlyYO5CUZcmkvrM66LPfttTUacCeG3kgSaaUfWqCVRdrQxOJ0Z54CY8ox2mbYfvaz0MXcA6FDMsezkhG2roWuYqDFRulsbC/3LGwXuQCpmrKdR4BPRhkbJvei7KTlBFmxx1PNSPn0tmKnclfc2ALdstXEqvNZBM38xIzPfFQORYrHOejAu+Nn5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable batch clearing of ptes, and batch swap setting of ptes for anon
swap-backed folio unmapping.

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
and batch set only those ptes to swap ptes in one go.

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
this accounting code (which is finish_folio_unmap()) in
__ttu_anon_swapbacked_folio() itself, instead of doing some horrible
goto jumping at the callsite of ttu_anon_folio().

Similarly, do the finish_folio_unmap() in ttu_anon_folio itself for
the non-swapbacked (lazyfree) case.

If the batch length is less than the number of pages in the folio, then
we must skip over this batch.

The page_vma_mapped_walk API ensures this - check_pte() will return true
only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the pte.
There is no pfn underlying a swap pte, so check_pte returns false and we
keep skipping until we hit a present pte, which is where we want to start
unmapping from next.

Remove the label finish_unmap since no goto callers are left now.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 109 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 80 insertions(+), 29 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index c1988dae8d4a2..d28a113e8c705 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1964,11 +1964,11 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
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
@@ -2139,16 +2139,25 @@ static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
 	return swp_pte;
 }
 
-static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+static void finish_folio_unmap(struct vm_area_struct *vma,
+		struct folio *folio, struct page *page, unsigned long nr_pages)
+{
+	folio_remove_rmap_ptes(folio, page, nr_pages, vma);
+	if (vma->vm_flags & VM_LOCKED)
+		mlock_drain_local();
+	folio_put_refs(folio, nr_pages);
+}
+
+static bool __ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 		struct folio *folio, struct page *page, unsigned long address,
-		pte_t *ptep, pte_t pteval)
+		pte_t *ptep, pte_t pteval, unsigned long nr_pages,
+		bool anon_exclusive)
 {
-	const bool anon_exclusive = folio_test_anon(folio) &&
-				    PageAnonExclusive(page);
 	swp_entry_t entry = page_swap_entry(page);
 	struct mm_struct *mm = vma->vm_mm;
+	pte_t swp_pte;
 
-	if (folio_dup_swap_pages(folio, page, 1) < 0)
+	if (folio_dup_swap_pages(folio, page, nr_pages) < 0)
 		return false;
 
 	/*
@@ -2157,21 +2166,57 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	 * so we'll not check/care.
 	 */
 	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-		folio_put_swap_pages(folio, page, 1);
+		VM_WARN_ON(nr_pages != 1);
+		folio_put_swap_pages(folio, page, nr_pages);
 		return false;
 	}
 
 	/* See folio_try_share_anon_rmap(): clear PTE first. */
-	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page)) {
-		folio_put_swap_pages(folio, page, 1);
+	if (anon_exclusive &&
+	    folio_try_share_anon_rmap_ptes(folio, page, nr_pages)) {
+		folio_put_swap_pages(folio, page, nr_pages);
 		return false;
 	}
 
 	mm_prepare_for_swap_entries(mm);
-	dec_mm_counter(mm, MM_ANONPAGES);
-	inc_mm_counter(mm, MM_SWAPENTS);
-	set_pte_at(mm, address, ptep,
-		   swp_pte_prepare(entry, pteval, anon_exclusive));
+	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
+	add_mm_counter(mm, MM_SWAPENTS, nr_pages);
+	swp_pte = swp_pte_prepare(entry, pteval, anon_exclusive);
+	set_softleaf_ptes(mm, address, ptep, swp_pte, nr_pages);
+	finish_folio_unmap(vma, folio, page, nr_pages);
+	return true;
+}
+
+static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+		struct folio *folio, struct page *first_page,
+		unsigned long address, pte_t *ptep, pte_t pteval,
+		unsigned long nr_pages)
+{
+	unsigned long batch_idx = 0;
+
+	while (nr_pages) {
+		bool anon_exclusive = PageAnonExclusive(first_page + batch_idx);
+		unsigned long len = page_anon_exclusive_batch(batch_idx,
+				nr_pages, first_page, anon_exclusive);
+
+		if (!__ttu_anon_swapbacked_folio(vma, folio,
+				first_page + batch_idx, address, ptep, pteval,
+				len, anon_exclusive)) {
+			/* Restore the remaining PTEs that were cleared. */
+			set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
+			return false;
+		}
+
+		nr_pages -= len;
+		if (!nr_pages)
+			break;
+
+		pteval = pte_advance_pfn(pteval, len);
+		address += len * PAGE_SIZE;
+		batch_idx += len;
+		ptep += len;
+	}
+
 	return true;
 }
 
@@ -2184,15 +2229,22 @@ static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
 	 * See handle_pte_fault() ...
 	 */
 	if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
-			 folio_test_swapcache(folio)))
+			 folio_test_swapcache(folio))) {
+		set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
 		return false;
+	}
 
-	if (!folio_test_swapbacked(folio))
-		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
+	if (!folio_test_swapbacked(folio)) {
+		if (!ttu_anon_lazyfree_folio(vma, folio, nr_pages)) {
+			set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
+			return false;
+		}
+		finish_folio_unmap(vma, folio, page, nr_pages);
+		return true;
+	}
 
-	/* nr_pages > 1 not supported yet */
 	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
-					 pteval);
+					 pteval, nr_pages);
 }
 
 /*
@@ -2373,13 +2425,15 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
+
+			/* finish_folio_unmap handled internally */
 			if (!ttu_anon_folio(vma, folio, page, address,
-					    pvmw.pte, pteval, nr_pages)) {
-				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
+					    pvmw.pte, pteval, nr_pages))
 				goto walk_abort;
-			}
 
-			goto finish_unmap;
+			if (nr_pages == folio_nr_pages(folio))
+				goto walk_done;
+			continue;
 		} else {
 			/*
 			 * This is a locked file-backed folio,
@@ -2394,11 +2448,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-finish_unmap:
-		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
-		if (vma->vm_flags & VM_LOCKED)
-			mlock_drain_local();
-		folio_put_refs(folio, nr_pages);
+
+		finish_folio_unmap(vma, folio, page, nr_pages);
 
 		/*
 		 * If we are sure that we batched the entire folio and cleared
-- 
2.43.0


