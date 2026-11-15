Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ABF4606A333
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HvBscOVE
Received: by kanga.kvack.org (Postfix)
	id 83F8E6B05C2; Sun, 15 Nov 2026 09:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817046B05C3; Sun, 15 Nov 2026 09:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753CB6B05C4; Sun, 15 Nov 2026 09:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 570356B05C2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:40:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1E2F1A0769
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:40:28 +0000 (UTC)
X-FDA: 85437614136.08.0B4EA7A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 38D8E140009
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:40:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HvBscOVE;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hx44ZHmrhNF96yWNr3bPcGAUNP+WpBOTwlC2lOoq7IE=;
	b=NasYBCxFzGqBkbevG78ZDzabQHL1ZM2ih7GQbIMZZ2IjHZa9Q4hHRvHMDsm+beWgklClgL
	DF4jAvxkjt3XM9BcgxcrRR+GbvUygS2XC8qnTXFAO8kvEyfPYoSr+PzHCSMVs5oShEa6/6
	dzzRCmLWzW81hrwqCTBpN6dKOxi6gms=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753627;
	b=UBcvG7+yUITFM+sTKS3E0CRofVCBKfGv58uf3RJg0r6whfZCFfIIKMa7+qlkO9TSsammHZ
	PkunN5K9sVqQDVM78HFBx9/eeh9G1Bx4NU73nYL+C4Rs1hdE/h/ICEm6GnsGMeq1qMbt47
	iYrK5u40AuRERqnM0YS91gTg0HnzbTA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HvBscOVE;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DCD51476;
	Sun, 15 Nov 2026 06:40:23 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 886413F85F;
	Sun, 15 Nov 2026 06:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794753626; bh=pEGYl0oKaox0/tIpp+Mu8b4JwZHSKDn4/w2uu0eAooI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvBscOVE7Wh1gfLKHZocrujZENq+hZ9WcOEpASJ9TMhQ9BHC2UC6hGPPD+GaX+LUG
	 LUwZQQ7tLQxIJBHyBvChZrz1uf+WPpIxWDYsyXIUimzOey1qyRzDPoCawxEhMKDKjS
	 euu+KycvP/FHpezXUAho7MZITo7YDwKcAHCflI8c=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
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
	anshuman.khandual@arm.com,
	geert@linux-m68k.org,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v4 8/9] mm/rmap: batch unmap anonymous swap-backed large folios
Date: Sun, 15 Nov 2026 14:39:03 +0000
Message-ID: <20261115143905.3045084-9-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115143905.3045084-1-dev.jain@arm.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ejier9xd6pgjg455kk8pkr9aobhpzr88
X-Rspamd-Queue-Id: 38D8E140009
X-Rspam-User: 
X-HE-Tag: 1794753627-381268
X-HE-Meta: U2FsdGVkX18CaQoOgTVSKEBZ90beKaa55RC2eIPyF5GcDfhk9qiWRGo6/0SFAYD7Jn8RVAYoSayVufy29h47QZ2U3bWr8tpH/feIvB6dl0ubgNSqKzEWEMxoVIo7lc35Nynd2U29uQ2DQXWv3HouSD1CiYwqhv1ll3Q0s8LmX7Q7LmZDv28MWDfe0Q2f2y6obiuUKNf3rlc1x8TXG1R2TbqmiWk4v4MEPybu7p8QXADBJ4E71vs9GIsrrbGkDIToG6SsOWM2rX/MQxZ5fv4sYLPchpKYAg6cCgHr3w4FkNnhm2eHyJGVfXPErhS2d7mgZ4O1gkTrbBHUYl4XeYfRR7/BLXrSjr0WQd3Ab6k26P55/aWpRP7aDvZ0hfySlXavqkk4sPbJdxFNCxoWVj+KseMO3fxSzJDwW3IVl3PyWLXsi8qRn8MLlF00qEfRtSdEuaneGN9z762Um9mR5gyBst2OpOJ2lcjMrqqh04KLQXoyzoFbCKv4dBWuJTTl1DV/7S32TteYuDFIVygtL+felZTClQiyuACNwn365CPTGMNSFbSO+sIkujUtjI/BY1qV8VbpMM4j7Xs3w+fyQim1w8ehQxntAlrn+NYJCXDhSy+jTTT/cnuhiwO0MqHoVaCbX8PmUwfVx2MFLx0+38of4JASCP3AQ1/EsvaIySiP8aJKtqNpzv2PXjmMTA5giKle24p2wLc7DYLynQyuoEFOtcBF4MJ3KC3UrnXiwrKuq9H0qZdFc0uPffG3zWm+jzRlfUVc+2TrgZTdfKz46ZRM7toev8RcAUvl3FQK23RxoX272wXqU3alBC05vf6ewSD0HWRdGFmrD9dVVutzXUyHFSjM2mtpHu95YxchYADxV7o2BI6AyZV/PfkCBfQywELWA6ySruyMFcy9AhQHpO2SS5HemlORbEiexjVWibsAnpkGQYexAn7Xtalh80aX4oBWcEEotr7T0xLWualtdZH
 y3dzJOb/
 JCtd1QnLWqdbvL5W/w3gv5Vv2hzxFs6/hDxYA9iHejE34OypspzLjlqwPook37gBwIyb9BiBSb561tIFjMv9eW7USomc1lb+6MP/NJ9OtMAPoxUhJVj7QJDzL0iS7cvpiIPfwUvQ4uLXwbVGxqtZsVszOdjsZSrO0kJ2sKKzjA5luds7tYPbZBIP9BmOGuIX0Oz6Q+VefXo6Kh3n92uEnJCDsUdFuvkn4+q0SqLRGRr0BENyEHNEqlonK4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Enable batch clearing of PTEs and batch swap setting of PTEs for anon
swap-backed folio unmapping.

Processing all PTEs of a large folio in one go helps us batch across
atomics (add_mm_counter() etc), barriers in __folio_try_share_anon_rmap(),
and repeated calls to page_vma_mapped_walk(). In general, batching helps
execute similar code together, making the path more memory and CPU
friendly.

On arm64-contpte, batching also helps avoid redundant ptep_get() calls
and TLB flushes while breaking the contpte mapping.

The handling of anon-exclusivity is very similar to commit cac1db8c3aad
("mm: optimize mprotect() by PTE batching"). Since
folio_unmap_pte_batch() does not look at the bits of the underlying page,
process sub-batches of PTEs pointing to pages with the same exclusivity
state, and batch set only those PTEs to swap PTEs in one go.

Disable batching for sparc (because of arch_unmap_one), we will batch this
later.

Rmap accounting and reference accounting must happen when anon folio unmap
succeeds. If a large folio is only partially batched or a later sub-batch
fails, account only the pages that were actually unmapped.

If the batch length is less than the number of pages in the folio, skip
over this batch. page_vma_mapped_walk() handles this: check_pte() returns
true only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the
PTE. Swap PTEs have no underlying PFN, so check_pte() returns false until
the walk reaches the next present PTE to unmap.

Remove the finish_unmap label since no goto callers are left now.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 118 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 86 insertions(+), 32 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 6a6fb9b56f2cd..a2481323b778a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1981,12 +1981,13 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	end_addr = pmd_addr_end(addr, vma->vm_end);
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
-	/* We only support lazyfree or file folios batching for now ... */
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
+	if (pte_unused(pte))
 		return 1;
 
-	if (pte_unused(pte))
+#ifdef __HAVE_ARCH_UNMAP_ONE
+	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
 		return 1;
+#endif
 
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
@@ -2156,16 +2157,25 @@ static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
 	return swp_pte;
 }
 
-static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+static void finish_folio_unmap_batch(struct vm_area_struct *vma,
+		struct folio *folio, struct page *page, unsigned long nr_pages)
+{
+	folio_remove_rmap_ptes(folio, page, nr_pages, vma);
+	if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
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
 	swp_entry_t entry = folio_page_swap_entry(folio, page);
 	struct mm_struct *mm = vma->vm_mm;
+	pte_t swp_pte;
 
-	if (folio_dup_swap_pages(folio, page, 1) < 0)
+	if (folio_dup_swap_pages(folio, page, nr_pages) < 0)
 		return false;
 
 	/*
@@ -2174,25 +2184,61 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
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
 	return true;
 }
 
-static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+static unsigned long ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
+		struct folio *folio, struct page *first_page,
+		unsigned long address, pte_t *ptep, pte_t pteval,
+		unsigned long nr_pages)
+{
+	unsigned long batch_idx = 0;
+	unsigned long nr_to_unmap = nr_pages;
+
+	while (nr_pages) {
+		bool exclusive;
+		unsigned long len = page_anon_exclusive_batch(batch_idx,
+				nr_pages, first_page, &exclusive);
+
+		if (!__ttu_anon_swapbacked_folio(vma, folio,
+				first_page + batch_idx, address, ptep, pteval,
+				len, exclusive)) {
+			/* Restore the remaining PTEs that were cleared. */
+			set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
+			return nr_to_unmap - nr_pages;
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
+	return nr_to_unmap;
+}
+
+static unsigned long ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
 		struct page *page, unsigned long address, pte_t *ptep,
 		pte_t pteval, unsigned long nr_pages)
 {
@@ -2201,15 +2247,21 @@ static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
 	 * See handle_pte_fault() ...
 	 */
 	if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
-			 folio_test_swapcache(folio)))
-		return false;
+			 folio_test_swapcache(folio))) {
+		set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
+		return 0;
+	}
 
-	if (!folio_test_swapbacked(folio))
-		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
+	if (!folio_test_swapbacked(folio)) {
+		if (!ttu_anon_lazyfree_folio(vma, folio, nr_pages)) {
+			set_ptes(vma->vm_mm, address, ptep, pteval, nr_pages);
+			return 0;
+		}
+		return nr_pages;
+	}
 
-	/* nr_pages > 1 not supported yet */
 	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
-					 pteval);
+					 pteval, nr_pages);
 }
 
 /*
@@ -2378,13 +2430,18 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			if (!ttu_anon_folio(vma, folio, page, address,
-					    pvmw.pte, pteval, nr_pages)) {
-				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
+			unsigned long nr_unmapped = ttu_anon_folio(vma, folio,
+						    page, address, pvmw.pte,
+						    pteval, nr_pages);
+
+			if (!nr_unmapped)
 				goto walk_abort;
-			}
 
-			goto finish_unmap;
+			/* partial success: finish for nr_unmapped and abort. */
+			if (nr_unmapped < nr_pages) {
+				finish_folio_unmap_batch(vma, folio, page, nr_unmapped);
+				goto walk_abort;
+			}
 		} else {
 			/*
 			 * This is a locked file-backed folio,
@@ -2399,11 +2456,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-finish_unmap:
-		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
-		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
-			mlock_drain_local();
-		folio_put_refs(folio, nr_pages);
+
+		finish_folio_unmap_batch(vma, folio, page, nr_pages);
 
 		/*
 		 * If we are sure that we batched the entire folio and cleared
-- 
2.43.0


