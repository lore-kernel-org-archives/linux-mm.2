Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3E6BC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5BCB6B00C1; Tue,  1 Sep 2026 01:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D330F6B00C3; Tue,  1 Sep 2026 01:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C221C6B00C4; Tue,  1 Sep 2026 01:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 830E66B00C1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:45:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83A591C1D80
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:45:12 +0000 (UTC)
X-FDA: 85164105264.20.BB34DDD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id C61CDA0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:45:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lIqXMwdd;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788241511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5UF2Zy9/ognCrvWD4nOSmj1L8LPwb/ZXrIZ+VMhGvY=;
	b=F5yoBQogP+Tyk+Ff9jJYM47BlrIsomm02fLVJYeuGS2fsh4/+NHpx2DEo7ZZlRZtDJxtsB
	rADE0jFdGKFnLY54Z3JxhWIp3Q4zLORDiVzTkrptSEZ6EYyLUiMJaFzYV93J+J/Sc5OpKW
	z30KZYaexiE1lOUiqJxHDjwmrA3G9oI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788241511;
	b=wz/ltdwjM9Ivom+bHGyyS/qFZTKjhS4KxmJlVzxvNK8VSKEfl/k0a93YMmoOuC4YpNgOg+
	Yo/vnvKK1B7x1DFL5nI6DiiROucSeNI07JfnjdnDpR1hi7RoXbxufvr+OuUMXDAM0b6dFt
	6YVN1aZJPUDynDbcj65UXI8jrHUqvOo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lIqXMwdd;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 445F61756;
	Mon, 31 Aug 2026 22:45:06 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2B6443F85F;
	Mon, 31 Aug 2026 22:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788241510; bh=ExzsBBQQzRLXmN5iM7ua3O1UxwNf7wasB8hjbJf/zWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIqXMwddZi+uOm9ZJisAjVtSPICoXG4TgBYeL3OwVXiBe3YuDLo86lqjl4CnIXSQu
	 hAAQNs6LM9tL+uABixrKnhZhHejKRN55E0CZS3bV2ebPGFWeTIcFC7IPuVMOaHGnxD
	 vX99fqxU1f1+wtDyVO5ioGry1vQqF96Jso7B3QCw=
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
Subject: [PATCH v2 8/8] mm/rmap: batch unmap anonymous swap-backed large folios
Date: Tue,  1 Sep 2026 05:43:55 +0000
Message-ID: <20260901054358.4049095-9-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901054358.4049095-1-dev.jain@arm.com>
References: <20260901054358.4049095-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C61CDA0004
X-Stat-Signature: zw6p43mdgipogyswqdzhfgmk5x75fnjs
X-HE-Tag: 1788241510-446588
X-HE-Meta: U2FsdGVkX1+nQn9Jx5FDKZCIDmJ7/EYi7NE8Z/g3ti3V+DT9iwPSJvmKqpz5FmbDHt9AZsyzFC5vVyC+HVnnj6y3taa1EFuDJLFSuFjZ1dobl3o5K389RePLCKZcf3dBpNQjXu1X4PTYUfG0mAGDdhs84WokKC4XwtX8wLDVDronbhmeWRGcgk6cuaYOPS8pMGIheZX/g5KfSU+iMd1T9IINDNDSSQVRNBZlO4814pIVPClS1smxDJ01KpYcXwsO9Nh32txTONgsPFZOuHRKsTTTTrYLhCrYPV20S254+K+V2KMCz1BFAIgyYuQvsrMIgBB+LN5/UWj8tPCKDW/UL6E69Tgm/ZZ0LkiFBTA0vAKEyAknbXPPyBzlsoPkYA2+Av6IAhdo2X9Kyk3gZOZNT8MmYADpJMT4yQ2kaWVrmB5bNDKlGjIJ+2w7qpw18kvzuqAHgugqQ5/ujwxyqfimO4afOjJunIY5SuN4ZZm8dn8q1bl1iWGv62XEluW/Shmak57MEEd6vNAHtPLGGT24SQZ68b9+KhR1GOHsVlOFrYTVxFLDxFHXKyFu+UUOkfGSuPK4NFsZx09eWos5/oaUSeR3WTlubwLHCLving9SN33zyZVxV26HlaWh4aVKAH9jUKBKA9hFlsszqVtidh0Z9V3dhZI0WliRbBkPFU3xNNHbY7Br8K62rG8eYzs23IY5fLwRJJ2mVrzg3AHIrTb+ToZOnMdv10W/9omKnG03/KXgdUcklQ/+rRK+wO1KdDv9BC2ImPSHNhlBihKtGXbGINFdOFzIamZQLViWSfyzpZ3YYfPWunJq2Wb0FPZp22WQZfE7fsRClmEin4YWYZuei1nUN1pElQuby/b0N34BiD3yDkNereiIphaGRCYFFpZ18BaU3Dk3WFjsL0wsyhAU8Ik2OyDXLNFNWA2Yy+o4rgDMHxFI8TIC9Fly8hOf8qq0uXoFdv7wETh5umKRWZ8
 IAlgO1II
 oEDgx2denhfSgZDXVgHComj7/Zp/Qz2iYmpyH7jOtqs5csfKZRR3oZsTtvrT8oSwFMx7GlkV9gDElC2SkqaBHf4s6TLtjx7XbaPu8UyG+Ux6fAIjXInouq4HdcyQ7CeXcKZIaUzE0+vtlpQpkFy/GxWHKXGX+lRL8KORZ1OnBrQKbFBhIdaYFnJ9U6cBLO6BXuIfZ9ejlXHYqx3gspW321TNaciKZ/jUOKcIxpWN69lDX8Z1/qbNAVYCLQA==
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
 mm/rmap.c | 110 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 81 insertions(+), 29 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1b9f07d4d1be9..68e0201ffd003 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1964,12 +1964,14 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	end_addr = pmd_addr_end(addr, vma->vm_end);
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
-	/* We only support lazyfree or file folios batching for now ... */
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
+	if (pte_unused(pte))
 		return 1;
 
-	if (pte_unused(pte))
+#ifdef __HAVE_ARCH_UNMAP_ONE
+	/* Add batching support to arch_unmap_one() to remove this */
+	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
 		return 1;
+#endif
 
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
@@ -2139,16 +2141,25 @@ static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
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
@@ -2157,21 +2168,57 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
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
 
@@ -2184,15 +2231,22 @@ static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
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
@@ -2370,13 +2424,14 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
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
@@ -2391,11 +2446,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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


