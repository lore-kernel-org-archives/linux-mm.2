Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 561D5C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDF46B0088; Fri, 10 Jul 2026 01:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F176B0095; Fri, 10 Jul 2026 01:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4858B6B0096; Fri, 10 Jul 2026 01:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2749F6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:59:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E2311203A9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:47 +0000 (UTC)
X-FDA: 84971815614.26.A10F79E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id E4150180002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=har37v1V;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783663186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daALWgF7+fLH2iGct4OIr/EA8+faUAoS6fX7I/3Aip0=;
	b=PpG6SHtBeAzvpFoSSA1Ya4BcrrYE1ik/nXgxgqPDJG+zVniiCw0DBF0UAkvy7tfaIefjGa
	jYT0lHX5BYW42WajSc1uZM7kqpN52BVQp/FOMjtQzpR7e6c2Ha6da7sC1NfRvpU5yo2QgW
	+cJJlRV2kCeP/TREuP8Podw6R0lhnv8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=har37v1V;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783663186;
	b=8bHpAolWmKKSr/sJy7uqflojf2QZY/d5m9x8oboTsR5JZ+8/ctcM/Fur/9Fe3ZeZX0zOUj
	YnNpasbvNCopxMQC84r2D7G27eeF/I041vc2Q70lgxIUxGyvez58/dTsXkDLL6uKYCoUQV
	32i1IzTEqEwHbk4AMGaduFfux+f7NF4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B56711F60;
	Thu,  9 Jul 2026 22:59:40 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B4FA53F85F;
	Thu,  9 Jul 2026 22:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783663185; bh=EelwukRgK1fGC5jOnxhJeJvP33DIxN6wBYt6cfMHEdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=har37v1VUc5JlJsbJCjCetXOqJwFyT8Ye6d3HEmOvDKH3TGBxN8669fspT4PX6asj
	 SXxmr85O8mTBP6ZorpwmZS/vq4IjvT2eT2sPjyEosKAsqeftg3wyCInMQ3FIoH9l6N
	 n+De2roZlP0GMZX144vKqPz3mO2z1n6BNgyCcoT0=
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
Subject: [PATCH v2 4/5] mm/rmap: refactor anon folio unmap in try_to_unmap_one
Date: Fri, 10 Jul 2026 05:59:13 +0000
Message-ID: <20260710055915.638659-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710055915.638659-1-dev.jain@arm.com>
References: <20260710055915.638659-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5j61pjdt8fyggpsagf7n4xcic956sfe3
X-Rspamd-Queue-Id: E4150180002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783663185-793621
X-HE-Meta: U2FsdGVkX1/fKlzTv+Of86thh1EQuPY4yoW8PVqLudZ36h3l3BUB9QhUdB1gXI7xPjKYi3MUFGif6ctlqUoh9PdJEX6TnGMUNhlQ7Pu7shASPNUt8GEOeLhw+0NAuZw9Mu8g3RtMgpr1AQh9GRJ5+F6LnwGFL9KuRgYHYEmI/F4lbDlRB8YHuUiAogfSk7TeiXLSE5elS+gqs6Jfr3afjbqrEqQhUorsXVLPeVlJoVDmHXw/DHHpr7oGxAl01pjlAXftmW2qwkZxk3Zgz0GSptoMBVGlJfWNMa85Urtklym81xQ+Mv2YR6BdLz5AQAHJQiGQ04f7tTXkbt6Au3+gpGxt7d9qAGSYtzfyRo8kUDaR/KFcb1jCt8CTLFysdJDWXAs5cmg1K8ffGI2y2PqRHCWtTnVLMgnugsTDknORvBPtsshIu2zaUfUzh+bO6p2nt5BX9LrjS98m2nhtxaFvLtIsDtSisgde7CeiDsUcekaXjQ7am12dQ9VzyTwPN/ker0R93MSybXMgIamW+VqAvvcwhOiefFRAnYGdwrgyAOAHJdj+MGLBHC9o1ZmY3WNRMMpBBnBbzYBw/tR2aSZ6SFvoh9zp6PwGtc1Pz/WaealQJVYs1aWlGcFtXLBXV7WTE5pxeLp9AMaQ9EEuL16bR37237fmcH4bjOSzLqgCQoSTAL5pmClpS7YBIS5bB3YOgeX/w5jgXClELnSxcxCbnmEqpG95QCNNF50H11doCdIpJ9ZAl+50Wub+CZ59laJSzl/0c5xg9RAqwDQ8ySCG1YaV3XoHF0zATGdU+7OWkqTpXfBscTcdRyi9VaDOijHmhxzqm4OwiLKMIy7pCyyFh4YDC690KRAhieCytjBhyZl02Yg0/vZWQUk+07QtTLDY8iQOdcaTzSUJc5KIDghIzh/b37mJ/ms/wEa89Vp6YhVNAtirfpWA1l/3c66hpbWjBp9oCGj9i4KceY/EP7m
 nZARf8lA
 KSn4Xa45DHdjrq4RvdQRGxnZ3aGZHKSo0sQJKc6BFXjIyBE7EpVblDLg0cQ2pRkvJa73pqKbwyXKor0V7WSblecftMxacX0EF86gmAI7JKXbpSRhuWKW9l8VSVAPETpuNHG0x4Z48hn1HCMlHfmCy+3rS4ESKepgOu6s0IPpm/obdUp1AeLkfULnTYa+KOyUG4g5MEPSDT9BGyPcEhhwlc0i0RIiaAjy0bmJ6G9yYrX2HKT+ij//92t+XE8THQLZEuOq+VAtqb105OhhFVeN4uhgCdjfbiZcmNOoE0EKIYCiI7fA=
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

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 115 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 47 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 4851c9f2a34e7..68459f23f5c0a 100644
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
+		if (pte_uffd_wp(old_pte))
+			swp_pte = pte_swp_mkuffd_wp(swp_pte);
+	} else {
+		/* Device-exclusive entry */
+		if (pte_swp_soft_dirty(old_pte))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_swp_uffd_wp(old_pte))
+			swp_pte = pte_swp_mkuffd_wp(swp_pte);
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
@@ -2277,7 +2335,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * folios here for now.
 		 */
 		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
-			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
+			pteval = swp_entry_to_pte(make_hwpoison_entry(page));
 			dec_mm_counter(mm, mm_counter(folio));
 			set_pte_at(mm, address, pvmw.pte, pteval);
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
@@ -2294,8 +2352,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			swp_entry_t entry = page_swap_entry(subpage);
-			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
@@ -2316,47 +2372,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
-				if (pte_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd_wp(pteval))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			}
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			goto finish_unmap;
 		} else {
 			/*
 			 * This is a locked file-backed folio,
@@ -2372,7 +2393,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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


