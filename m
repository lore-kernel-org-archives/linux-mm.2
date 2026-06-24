Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 204CDCDB47C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE336B008C; Wed, 24 Jun 2026 06:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF1F6B0092; Wed, 24 Jun 2026 06:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5166B0095; Wed, 24 Jun 2026 06:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A14956B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:21:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0E601402F5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:21:04 +0000 (UTC)
X-FDA: 84914413248.27.491B6E7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 38A50140002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:21:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fwMSaeZr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782296463;
	b=epCQDX448iwKGw/NC+xZg4FkV7S3SKn1IJ3mWDRAUZWw+ijXma3DCaeTAa6TeLi43Wbx9t
	cO5RMba/y5Q0D60QRICHXT+VN9O6yK9XLNl1PuvLZgZfys4hMg8aCL7ev1TmuSzWX4I/n/
	UOfXtb6AoHZS+WIDp3wmWghwydRdLcA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782296463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rWm6A27NP93RGF4QPXYr6oPzrQP5LB1h1CZ91ay1T4M=;
	b=ji+7xh4m3EO66df/MEn6rZNw3A0zShvZRA8xrDoTw/Rt3l0JcQg8QTI3iUOwEbl19h9RPG
	hdi591097YLX/BClfVPFB2hyKCmYSuTWvO9DzD/yATQKESofGu9/mhi3FtrRW+8Bv4qCpG
	Q5bwKigEITObrj50xsisvkIsm/VdNDA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fwMSaeZr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84384263D;
	Wed, 24 Jun 2026 03:20:57 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C39083F62B;
	Wed, 24 Jun 2026 03:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782296462; bh=t1VQpQ7laQlNyz9qp87/eLwUQrZSrurLq+w1peXrccY=;
	h=From:To:Cc:Subject:Date:From;
	b=fwMSaeZrtCiQiDS9fc45B91I73Ow6YRz4gOtLju3Tod6mJWsPs1wYbZYm5mAMALaT
	 sFQnpYV3t7TTtyDoVkurzfXXHqk19sdyK7kTvPM3H6jiUGj59LWaAUIrs5fYleXf64
	 SKsJsArwKowZoXIiMmS/e6aNhGu3OHw8yYrEncuo=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH] mm/memory: refactor finish_fault
Date: Wed, 24 Jun 2026 15:50:47 +0530
Message-ID: <20260624102047.144543-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38A50140002
X-Rspam-User: 
X-Stat-Signature: yhaqrmzw6x9k1651b8dox75mrnwfnsri
X-HE-Tag: 1782296463-405823
X-HE-Meta: U2FsdGVkX1/4+4dov5ikz2mkj62uhlaIBSmfcKFV8+mmTP7CPPbbjwA0Mz6RVogtvvOM2kUMxxejzJJsfSsIMMjKYxk44kjjHdD55nmm02YTw9BVgYBWZRUurUJOsQUjFI9fiu2V8WQUQYTcbLmgi+IT+tdLiTSgQsEv9x0fvAzd6+lYirCYKomrzwsIFAKSvEllRyvE0wyObFcYe9COy98wPoJm+5sNbYMpB8LEclrSLoVbKHF5fFYlWYpb83UsNWR9tSTED6vfgHRMFFYa1nlh8voMV1ruxkMSsDTgS/X5PapB6yxbTMfshW8FsHc2kCXDHbTX0+d7ktsLCL29RBy4g5MaklOMkRiHzQRY+qSJSYLsaGFEZVB9Q9o3iloaFWYK/AqjHFSdv7EsHfFvF7fW0kLvlRFdc8XZlLcrTun6MIBt2f+67+7dxb7e9iXeYCw411DXZ8K6uWCOp5cot/8k80peZ9ZRExrhQQkO2D/CSwc1KJ9ZI9CaPZ0P2tLrA2lzokON4/EeAd8rRGSkpwL5zU6xP70SeU3gjj3brA9ZHVabAOacDk2FJ7AnalEfk/Oy2MKkQ0gTEUsYkJYMw3uHErXHt2W2b8PjnnjrvHh6bsGhP8i3ze1vlLNatgz7IdcoSw6TT31vgzRzPc1sSARpFtq5ZDdPIxOD5LabFF+mInV36Dd47Z7W1nYVq3DMyVcNQOdV/2xdO2UNUz/6sofK+kDzApj5S78hEuY2VWs6wglVWcXgeFELqBcy7W970YSXqF3dKMvn4WPyjPtdTESTEuVB1kcp9ytioCYdm12/WoFB5b93bFFB/ok8ZqI8xpapJTU0y7rUDRJyLC7g3410hco6mnvqGRmGyS9r/joTGm7+tqx7nj3fp3bn7o+b96+oMwWUQ0uPKsSTCe+Q6mazvXonQCiaH4Lekdu9WjpIo4CFjPYE0xCUqBQyOiOsJMNAwFj9SnHIEzVbD8o
 PqFMJ+mu
 YZhJ+LUPxcryKqmja6GgcWPfKG40SPw1GXhalwO4auwYSE5KeItA36Z1gpg/OI9I+0U41oxnaBpSyXmqQtnZsNNJ5aUMsD76xovcYDVjuipRmCSIwimL9BGcxmFDTBxb7sb+C+QKwKIiaZsm/TcAUvW2BYPaTQ42ClkLICHXX4smY8KkBpT8lBfC33Wo9KpFPauDT3t6eIfjnWlr2IicJkkqSvgeegyCOFUH7VbuatwNz0PLmD4zlxFEcOXW3PAA6Akc7AVsDF2b8N5zeJbVsRrQMO2/ZIMOPUxBbkFLhzH2Epfk9fRL8fsIYMv62zOUqEubP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

finish_fault() currently has a goto fallback implementation
where we try to map a large folio with PTEs. If that cannot be
installed, we goto fallback and go through the fallback mapping
path again. This looks weird and is tough to comprehend.

Remove the goto fallback implementation and try to map the
whole folio if allowed. If the whole folio cannot be mapped,
fall back to single page mapping without repeating the whole
function.

The cleanup of finish_fault() was suggested by David in [1].

[1] https://lore.kernel.org/all/3684c55a-6581-4731-b94a-19526f455a1e@kernel.org/

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
Tested this patch by running mm selftests on baseline and patched 7.1
kernels. No regressions were observed.

 mm/memory.c | 78 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 37 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..f883b3f3850e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5666,18 +5666,16 @@ static bool vmf_pte_changed(struct vm_fault *vmf)
 vm_fault_t finish_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *page;
+	struct page *page, *map_page;
 	struct folio *folio;
 	vm_fault_t ret;
 	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
 		      !(vma->vm_flags & VM_SHARED);
-	int type, nr_pages;
-	unsigned long addr;
+	pte_t *fault_pte, *start_pte;
+	int type, nr_pages, nr_ptes;
+	unsigned long start_addr;
 	bool needs_fallback = false;
 
-fallback:
-	addr = vmf->address;
-
 	/* Did we COW the page? */
 	if (is_cow)
 		page = vmf->cow_page;
@@ -5695,7 +5693,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 			return ret;
 	}
 
-	if (!needs_fallback && vma->vm_file) {
+	if (vma->vm_file) {
 		struct address_space *mapping = vma->vm_file->f_mapping;
 		pgoff_t file_end;
 
@@ -5727,56 +5725,62 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 
 	nr_pages = folio_nr_pages(folio);
 
+	/* Initialize for single page mapping */
+	map_page = page;
+	start_addr = vmf->address;
+	nr_ptes = 1;
+
 	/* Using per-page fault to maintain the uffd semantics */
-	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
-		nr_pages = 1;
-	} else if (nr_pages > 1) {
-		pgoff_t idx = folio_page_idx(folio, page);
-		/* The page offset of vmf->address within the VMA. */
-		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
+	if (nr_pages > 1 && likely(!needs_fallback) && likely(!userfaultfd_armed(vma))) {
+		unsigned long fault_page_idx = folio_page_idx(folio, page);
+		unsigned long pages_to_folio_end = nr_pages - fault_page_idx;
+
+		bool fits_vma = folio_within_vma(folio, vma);
+
 		/* The index of the entry in the pagetable for fault page. */
 		pgoff_t pte_off = pte_index(vmf->address);
 
-		/*
-		 * Fallback to per-page fault in case the folio size in page
-		 * cache beyond the VMA limits and PMD pagetable limits.
-		 */
-		if (unlikely(vma_off < idx ||
-			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
-			    pte_off < idx ||
-			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
-			nr_pages = 1;
-		} else {
-			/* Now we can set mappings for the whole large folio. */
-			addr = vmf->address - idx * PAGE_SIZE;
-			page = &folio->page;
+		bool fits_pte_table = pte_off >= fault_page_idx &&
+				pte_off + pages_to_folio_end <= PTRS_PER_PTE;
+
+		if (likely(fits_vma) && likely(fits_pte_table)) {
+			map_page = &folio->page;
+			start_addr = vmf->address - fault_page_idx * PAGE_SIZE;
+			nr_ptes = nr_pages;
 		}
 	}
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-				       addr, &vmf->ptl);
+				       start_addr, &vmf->ptl);
 	if (!vmf->pte)
 		return VM_FAULT_NOPAGE;
 
+	start_pte = vmf->pte;
+	fault_pte = vmf->pte + ((vmf->address - start_addr) >> PAGE_SHIFT);
+
+	if (nr_ptes > 1 && !pte_range_none(vmf->pte, nr_ptes)) {
+		/* Single page mapping fallback */
+		map_page = page;
+		start_addr = vmf->address;
+		nr_ptes = 1;
+		vmf->pte = fault_pte;
+	}
+
 	/* Re-check under ptl */
-	if (nr_pages == 1 && unlikely(vmf_pte_changed(vmf))) {
-		update_mmu_tlb(vma, addr, vmf->pte);
+	if (nr_ptes == 1 && unlikely(vmf_pte_changed(vmf))) {
+		update_mmu_tlb(vma, vmf->address, fault_pte);
 		ret = VM_FAULT_NOPAGE;
 		goto unlock;
-	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
-		needs_fallback = true;
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		goto fallback;
 	}
 
-	folio_ref_add(folio, nr_pages - 1);
-	set_pte_range(vmf, folio, page, nr_pages, addr);
+	folio_ref_add(folio, nr_ptes - 1);
+	set_pte_range(vmf, folio, map_page, nr_ptes, start_addr);
 	type = is_cow ? MM_ANONPAGES : mm_counter_file(folio);
-	add_mm_counter(vma->vm_mm, type, nr_pages);
+	add_mm_counter(vma->vm_mm, type, nr_ptes);
 	ret = 0;
 
 unlock:
-	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	pte_unmap_unlock(start_pte, vmf->ptl);
 	return ret;
 }
 
-- 
2.39.5


