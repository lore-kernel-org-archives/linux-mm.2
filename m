Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C24EC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897786B00AB; Thu, 30 Jul 2026 05:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821E56B00AC; Thu, 30 Jul 2026 05:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8F96B00AD; Thu, 30 Jul 2026 05:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 421AE6B00AB
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:46:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B58EA120912
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:38 +0000 (UTC)
X-FDA: 85044963276.11.9C6ACC0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 14FB81C0010
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A2XQYDcY;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785404797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKgfN7YYGdbVRKUwIOj7pdgvpwPdRz/jERGh5InCLbU=;
	b=d5YfUU1N5lO3/GKENtK3TYhLHXNZzUcdX1GCZiPIUHIaiCZFA0VQgr71j3lYqZWaPGXA6w
	sXwcwcaV4JsoV4K9uBdMh4tPx//Plvmz2Ivj+BVs3r9rGPtyQsMjxSahP8l4Ow3xDTkPBr
	4TqukZDHQ3e90IPF4lzfOiH/fTcIwR0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A2XQYDcY;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785404797;
	b=FFKvqYo0o1CwVEaYF4teshENsrAvyXOppFEAkPIv6cdOOLOjZtVQjqNGHWtAN4uR3HtWxr
	Fu2lzu8O9AhBuGqlSBsuIfGCGVLV5pJvDAQ5zCwzftwqvRFnL8e4xr2O1VNVxfy6pLEcr6
	yeF8J44Ugpf3a/o53VjZlue1O+ZxVHU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E99681684;
	Thu, 30 Jul 2026 02:46:31 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BE52E3F763;
	Thu, 30 Jul 2026 02:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785404796; bh=ml3hDMc951hfxCEp24Za892tAl3WvI095gIkKqtQDCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2XQYDcYYUgRhC72cQtflDTyiASmK7g5hAdnpCdS2gwQ+jMCFf99+nYi5gno4T9yu
	 Eq7iir+1vTyKVV+KCIhf9a3TsE5IMgltH/uG5miVrN9PCQlBRm4tgbwFIjMHE8UHCV
	 zkwCBRYFDVP1YabtrETXkiAXccbSDHYsXoHkwfA4=
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
Subject: [PATCH v4 4/5] mm/rmap: refactor anon folio unmap in try_to_unmap_one
Date: Thu, 30 Jul 2026 09:45:55 +0000
Message-ID: <20260730094559.418003-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730094559.418003-1-dev.jain@arm.com>
References: <20260730094559.418003-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 14FB81C0010
X-Stat-Signature: fnon8zdb65yefjqhgrzf6m9gzdoroibh
X-HE-Tag: 1785404796-880143
X-HE-Meta: U2FsdGVkX19LMifOEnnLNfuodDwK5W3+yRq0W1Gv3RonCffeIGJ20lGjKQYyjzb1lyTnrt6UAiQ2mKErdaQhUL6doOmk5UTQ2ZDVBLuv4Py7zfg18g1C8mKQ3StZwaSfYUmmcEONS9P0p4ku8keEAQaHKSD/riQuBWCc7vQbUeYIZgbjcTaB+JA9Xa2TpyoxVUO2o41LW1w+uQY7jRk25pcp/ZUOwxj06dnEf8oCFAS+8RvEW5p9aArdqCd2nJrEwPjpAnzlGzkG/yv84cHW3hP404IGT+sXoBMDwJbe3EfjcxfIrRa7kb9ERDccKKcJUJjWJNtq9YhukOUrSo2LYXBJea/3lTem2Dz3NwoR3e+kf0KJFhh0+UVo/Pnip1gUFnY3DvSZlLbbOVk9FvxEoomEI/aKjSulPKmDaRw32kax/rdzT3KXjdMkHy4wa7FnzD+sTdxKV+Shcn3TPT2wmFSZIIeSf6GWcwJ8z3paR+ZEyYlmNGJ66RPe5+P6pc/PM48OL6gW+Y8MzL5L/Ob0JxsCrsFTbDIBbWBzyFAaWJV+jwO+e2t/3rj8GV9mttgBSXxwkqGqDZFGe2wq/lIT5qCkN4P8upvev7gIcEA0MzOZziwdEUOBoD6pQkfG/qpUGniZtnaZe8ufCyv1Ufn3z6XFbBioRvleVchdXjZ+O5G1mbJ56Ym86ps/C3xnV9u6BmQoohK0BeZPxfL4VIbP5R35s9fZUUHGzYvTfDd2nTB6sBN+36EQP1SHgZ0lmKIrdjNxX4/tEF1jbOIIOHWzC47n0K0O4iD7nVMKhSLLDufm4skdaBpC/qrAWF0AlaO13v4zGuDWUSVzfNUVDjHPeRCnpDh/iWFI3jVM6s5R6IEIZulXXlrQ+uXI1PU2V44V5tOjc8nvqkT0oCV67q4zvHQK9Og2yMd/gApdDXkBL5Xu2Bb1/UBWawojjqRq8eJFA9e0ii9Qs6CjkN/JCtj
 0a33wacs
 m5QL2eDHXen5tYEKyWF88WHlgZqJ+s949ceNThLklhjftsav5s9/nLXsiiiXmnW0Ywi+0PrXwvEUb9P1O09poesXcgDcqDSj+8gVBuEaEk0+3ml4Gojg/zoI6xVXwQ2p+0+xU8BwX+FcQXERt7jtnJbl6NE2QJQjpdlARaG3K9SwRXJCjhM8RvK1p1nQeF4A9AXiqm5FmkjZ3w25x5XGefv7OOcYKSxRY34P07kAHEcJPAB4JG+rVJyB0FJFgYgzTso45m812kGKJBc0b3ywNL90kKT2wE28fLx7P9jJ+zBOcwEmwWeZLxoTpaGVDbomP+MI/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor anonymous swapbacked folio unmap to ttu_anon_swapbacked_folio().
While at it, rename the remaining subpage variables to page; folios have
pages, not subpages.

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 115 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 47 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index dd1309d72e37..15efde4d1fc9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2112,6 +2112,66 @@ static bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
 	return true;
 }
 
+static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
+		bool anon_exclusive)
+{
+	pte_t swp_pte = swp_entry_to_pte(entry);
+
+	if (anon_exclusive)
+		swp_pte = pte_swp_mkexclusive(swp_pte);
+
+	if (likely(pte_present(old_pte))) {
+		if (pte_soft_dirty(old_pte))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_uffd(old_pte))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	} else {
+		/* Device-exclusive entry */
+		if (pte_swp_soft_dirty(old_pte))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_swp_uffd(old_pte))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	}
+
+	return swp_pte;
+}
+
+static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+		struct folio *folio, struct page *page, unsigned long address,
+		pte_t *ptep, pte_t pteval)
+{
+	const bool anon_exclusive = folio_test_anon(folio) &&
+				    PageAnonExclusive(page);
+	swp_entry_t entry = page_swap_entry(page);
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (folio_dup_swap(folio, page) < 0)
+		return false;
+
+	/*
+	 * arch_unmap_one() is expected to be a NOP on
+	 * architectures where we could have PFN swap PTEs,
+	 * so we'll not check/care.
+	 */
+	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+		folio_put_swap(folio, page);
+		return false;
+	}
+
+	/* See folio_try_share_anon_rmap(): clear PTE first. */
+	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page)) {
+		folio_put_swap(folio, page);
+		return false;
+	}
+
+	mm_prepare_for_swap_entries(mm);
+	dec_mm_counter(mm, MM_ANONPAGES);
+	inc_mm_counter(mm, MM_SWAPENTS);
+	set_pte_at(mm, address, ptep,
+		   swp_pte_prepare(entry, pteval, anon_exclusive));
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2120,9 +2180,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	bool anon_exclusive, ret = true;
+	bool ret = true;
 	pte_t pteval;
-	struct page *subpage;
+	struct page *page;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long nr_pages = 1, end_addr;
@@ -2233,9 +2293,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			pfn = softleaf_to_pfn(entry);
 		}
 
-		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		anon_exclusive = folio_test_anon(folio) &&
-				 PageAnonExclusive(subpage);
+		page = folio_page(folio, pfn - folio_pfn(folio));
 
 		if (likely(pte_present(pteval))) {
 			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
@@ -2274,7 +2332,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		/* unmap_poisoned_folio() only refs order-0 folios */
 		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
-			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
+			pteval = swp_entry_to_pte(make_hwpoison_entry(page));
 			dec_mm_counter(mm, mm_counter(folio));
 			set_pte_at(mm, address, pvmw.pte, pteval);
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
@@ -2291,8 +2349,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			swp_entry_t entry = page_swap_entry(subpage);
-			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
@@ -2313,47 +2369,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto finish_unmap;
 			}
 
-			if (folio_dup_swap(folio, subpage) < 0) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-
-			/*
-			 * arch_unmap_one() is expected to be a NOP on
-			 * architectures where we could have PFN swap PTEs,
-			 * so we'll not check/care.
-			 */
-			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				folio_put_swap(folio, subpage);
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
-
-			/* See folio_try_share_anon_rmap(): clear PTE first. */
-			if (anon_exclusive &&
-			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				folio_put_swap(folio, subpage);
+			if (!ttu_anon_swapbacked_folio(vma, folio, page, address,
+						pvmw.pte, pteval)) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
-			mm_prepare_for_swap_entries(mm);
-			dec_mm_counter(mm, MM_ANONPAGES);
-			inc_mm_counter(mm, MM_SWAPENTS);
-			swp_pte = swp_entry_to_pte(entry);
-			if (anon_exclusive)
-				swp_pte = pte_swp_mkexclusive(swp_pte);
-			if (likely(pte_present(pteval))) {
-				if (pte_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			}
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			goto finish_unmap;
 		} else {
 			/*
 			 * This is a locked file-backed folio,
@@ -2369,7 +2390,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 finish_unmap:
-		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
+		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
-- 
2.43.0


