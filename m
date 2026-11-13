Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B013360A6F66
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OeYFEpwo
Received: by kanga.kvack.org (Postfix)
	id 92FCD6B05B7; Fri, 13 Nov 2026 12:15:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFF56B05B8; Fri, 13 Nov 2026 12:15:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5956B05B9; Fri, 13 Nov 2026 12:15:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5584F6B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:15:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6605120238
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:15:38 +0000 (UTC)
X-FDA: 85430747556.26.4475A95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E12114000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:15:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OeYFEpwo;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794590137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NnqtQ/mxknt+/WoqFvknhFyoHQ25ZnnIoL+B41Z9ONg=;
	b=H5GcXoC3Fv9VlnZQrr7n6pm74Z2kyigFy9I3SEHtgDbWct9CyP/UuzoTii6YZiSdaNTbvW
	oWqETsi+tHFetPjSU+0JX4kPGwbL+rxgCYii7I81JzzhiRqYkuxLOXKtOyYLU4gBg/qE72
	O0PS3k6yQWW7XdviC06MB7A6BSPpoW4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OeYFEpwo;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794590137;
	b=fXW5GhXVtPD37586A4q5rx3OnPKlw5F07yltDksdsNTUNrNh5ogoIuvZN3DU0MJkO3lQ19
	NZG9qQ3O1yUpEVbWGzVtfmfhTae/TWDXuvl+nvh4BflT9YoW0tppxij3hRyMnI8IqiPOrL
	CaC9lb7mhZHAd1W3JsxfOY71ggtS75U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D09946B1F;
	Fri, 13 Nov 2026 17:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5521F000CA;
	Fri, 13 Nov 2026 17:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794590136;
	bh=NnqtQ/mxknt+/WoqFvknhFyoHQ25ZnnIoL+B41Z9ONg=;
	h=From:Date:Subject:To:Cc;
	b=OeYFEpwo9dvd3uGZpOLMo2Syz6OFEvOSH/L7Y4msQumYLE5kba82C8Xh8S8gTrujC
	 yTO9frsKjaG5CeMV8NWtnKoxq9g49gZJWmvzBBWXtAYtr3XY6ULahd0EBjS1l/jnK+
	 OO95xkzWGJNDXDGDOc/MmptFQ+rQzQxYHW4MaKTj9dzOdkWM9Vje1qPJcInWKzRNjB
	 rJXZrgvWpK+BDEF8kKEF64uC/cmVyTFMtnBHkP0cRVbpqUB1NBP9J2Zm8ezKXZdxX8
	 CYB1JolFmX2IbVqE2W5uNqs/bUnH8vIjMSLWf0Z7G3ZjlGhNly+xpT9dH9L8dbyNCw
	 NQVqALn96qVaQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 13 Nov 2026 18:15:26 +0100
Subject: [PATCH] mm/huge_memory: flush dirty file PMDs before removing rmap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-dirty_file_pmd-v1-1-8c11f2a2e65f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAK1F92oC/yXMTQ5AMBBA4avIrDVplSZcRaRBByP+0iJE3F2x/
 BbvXeDQEjrIggss7uRonjxEGEDdlVOLjIw3RDxSQgjJDNn11A0NqJfRsJSjkirmZZJK8NFisaH
 jG+bFb7dVPdbre4H7fgA2gFgjcgAAAA==
X-Change-ID: 20261113-dirty_file_pmd-90e63640a593
To: Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>, 
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
 Ross Zwisler <zwisler@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7929; i=david@kernel.org;
 h=from:subject:message-id; bh=HdL68kmUPC38EtwlODjudbsI/ECSjMkD6buFKlpLu3g=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+u65//2GJy4Yj5RMvLN+ayBVj2lBz4vm6XzKak/e7a
 x9Yzs21tKOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICbfIvhf7iG0dm2uPubWOJ9
 FBsX2X9t/3fuY+X6gr+Wyj/bVTKOuzP8Mze/nnM0Y/OCgIczkquqdLzWztnXmf3edYvD4WvtW/I
 v8gIA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: gmgrf7phqqaqocryscofwfaydxpxyuqi
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0E12114000B
X-HE-Tag: 1794590136-478154
X-HE-Meta: U2FsdGVkX1+nooKiJi0ES+5AE77YMzzg+5eCjJuY6l4CGINw+FlT7FXYhJLw2pHlhfPQcaPy0SuYjVvSPrZ00C3stKIM3fkJGSXnRTBx2iCSG7pMBHbAuml37nEgV7LjROFrNlBytS7BEVnmZGSICsH79lgpsaNWdRlwTtRK6+NUgtqsjO7FvPnAYLQThAT7/aDfXlH2LMPw8sGfpPNZnXe03UgWLRHP3XB3ShV/g1sET97RKsUXB5/njFEK3uYsY4JjE35Gl9N+mhc4cwn5bJzfz24IJPxQ8E0i8qbfqXs7jM4cEKNFlKuPU+bphMqWzqH7op05sk/qOS2Eazw4h8rnBrJe9IgPMAEBR+HQGe7tdEaayNXWv4zCiFp4itmCpIjuQBplssWWmRVsASO0dnylIdMOvWOqyyIOZ9dNH5ZLTmghnRcpEhp0hW6/8yJVcv/EQwKUiwu1Fba3PkV0V0ERtRP2SoE7eBV16lS2GpPX15fYlede0WVdZrGhWGwaM60+3smTuDWTsfC1pFq9NlU8yENl1yxXjYHe/sBi2Rks1H7amr4S3X0Yr9MMG0AwLdh1XXHvH5cU7isqTTOfJFxV0A7+oTrWmktSV3qFCTckquaVFNyHPLYTe3P3zH5/qU/K3frySWLBKcLH7LOe6YWBWd6eAbWafgazrK2MnI7u3zrkNYehAxRYexDxOgEgv+Vcx2nRhuUNt4K+KcXnGuEHYceTCljmGzHr99bF1MVHRWdp6+yM4hw/Psv3xkKPJRP/j/w68c6huaUVN86UZDC2SMgSM19HSq0bJeda7O4nnVopAX8xVTf6BU0/k5eK4OWFVPoRfe9fPx1rqQ89y1AGOZjQmxcrDZOUv08xWRMtfz8wnHWQm8igzoOJ0l9ZTqHOqF4dZl8QvPWnKeJOMgvJ7yRTeTqiFEfH4cuFh/UbyQ1NHmE3Pcy/nr7/Wqtxy6od++TPEp1jhvcz23A
 hps2bCMg
 +fx6U+r4dbPqx0ljhPaYXjwSbGINXMFPlihG/6BbtHojdbLTN6G7pNJv6ZVTa+2vf6AgpUt/Yov7KR/EsHfZ3KWUaJkjfM1nngrHH7yMDZT+WnGInGACRYs3HbdP/n3e5a0Yc36rNgvJOyEXXuh/fQmfThtioQmc891VWDE88d9OGP8rKERSgGDru5ZSKw5Z4QHSCQHzlhMAnZxxOvmiAQQtqy3yU0zelM28+bIhlOpuVg3s5NFwiaj1VSE6jm+7xMj8POL4kpuYt53+OGTKa2QQ/NNnhpcbwkB9TX/ZAJCZe+Eo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Unmapping a file PMD can lose concurrent stores when it races with
writeback. zap_huge_pmd() removes rmap and drops the PMD lock before the
gather flushes the TLB. Writeback can then clean the folio while another
CPU can still write through a stale writable TLB entry. Those stores do
not fault and dirty the folio again. Filesystem DAX has the same problem
with its dirty tags.

Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
has been flushed") fixed the same race for PTEs by adding delayed rmap
removal to the mmu_gather infrastructure. The PMD path still removes
rmap before flushing.

Flush the TLB under the PMD lock before removing rmap for dirty file
PMDs. Skip the early flush at address-space teardown, when no users
remain, and for mappings without writeback, including shmem and device
DAX.

Use tlb_can_delay_rmap() to share the PTE path's architecture checks.
On s390, clearing the entry already handles TLB synchronization, and
__tlb_remove_page_size() immediately drops the mapping reference, so
rmap must be removed first. UP cannot have concurrent stores from
another CPU while holding the page table lock. Make the predicate
side-effect-free and set the gather's delayed_rmap flag when an entry
is actually queued for delayed rmap removal.

Queue the folio before the early flush, while the gather still has a
valid range. Keep batching references and drain a full batch only after
dropping the PMD lock. The early flush resets the gather's TLB state,
so draining the batch does not flush that range again.

Although writing to files through mmap is generally discouraged,
unmapping such mappings may become slower: each dirty file PMD now
requires a TLB flush under the PMD lock. Future work should properly
extend the delayed-rmap machinery to PMDs and hold the PMD spinlock
across multiple entries, so their TLB invalidations and rmap removals
can be batched.

Fixes: 4b4bb46d00b3 ("dax: clear dirty entry tags on cache flush")
Cc: stable@vger.kernel.org
Reported-by: Kiryl Shutsemau <kas@kernel.org>
Link: https://lore.kernel.org/linux-mm/aoWw_iKEDLjKL2jr@thinkstation/
Reported-by: Chris Mason <mason@kernel.org>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/tlb.h | 10 +++-------
 mm/huge_memory.c          | 38 ++++++++++++++++++++++++++++++--------
 mm/memory.c               |  2 +-
 mm/mmu_gather.c           |  2 ++
 4 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4bba02fd5d543..2dcf4ce0de589 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -250,11 +250,7 @@ bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
 		unsigned int nr_pages, bool delay_rmap);
 
 #ifdef CONFIG_SMP
-/*
- * This both sets 'delayed_rmap', and returns true. It would be an inline
- * function, except we define it before the 'struct mmu_gather'.
- */
-#define tlb_delay_rmap(tlb) (((tlb)->delayed_rmap = 1), true)
+#define tlb_can_delay_rmap() (true)
 extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
 #endif
 
@@ -267,8 +263,8 @@ extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
  * remote TLBs to flush and is not preemptible due to this
  * all happening under the page table lock.
  */
-#ifndef tlb_delay_rmap
-#define tlb_delay_rmap(tlb) (false)
+#ifndef tlb_can_delay_rmap
+#define tlb_can_delay_rmap() (false)
 static inline void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
 #endif
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7791872f14af7..600a68a54ecf8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2508,10 +2508,12 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 	mm_dec_nr_ptes(mm);
 }
 
-static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
-		pmd_t pmdval, struct folio *folio, bool is_present)
+static void zap_huge_pmd_folio(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		pmd_t pmdval, struct folio *folio, bool is_present, bool *force_flush)
 {
 	const bool is_device_private = pmd_is_device_private_entry(pmdval);
+	struct mm_struct *mm = tlb->mm;
+	bool delay_rmap = false;
 
 	if (folio_test_anon(folio)) {
 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
@@ -2519,23 +2521,41 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		add_mm_counter(mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
-		if (is_present && pmd_dirty(pmdval))
+		if (is_present && pmd_dirty(pmdval)) {
 			folio_mark_dirty(folio);
+			/*
+			 * Remove rmap after the TLB flush if other CPUs could
+			 * still write to a mapping that supports writeback.
+			 */
+			if (!tlb->fullmm && vma->vm_file &&
+			    mapping_can_writeback(vma->vm_file->f_mapping))
+				delay_rmap = tlb_can_delay_rmap();
+		}
 		if (is_present && pmd_young(pmdval) &&
 		    likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
 	}
 
+	if (!is_present && !is_device_private)
+		return;
+
 	/*
 	 * Present and device private folios are rmappable. Remove the
 	 * rmap after transferring young+dirty to the folio.
 	 */
-	if (is_present || is_device_private)
+	if (!delay_rmap)
 		folio_remove_rmap_pmd(folio, &folio->page, vma);
 
-	/* Device private folios are pinned. */
+	/* Device private folios are pinned and don't need a TLB flush. */
 	if (is_device_private)
 		folio_put(folio);
+	else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
+		*force_flush = true;
+
+	if (delay_rmap) {
+		tlb_flush_mmu_tlbonly(tlb);
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
+	}
 }
 
 static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
@@ -2573,6 +2593,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
 	bool is_present = false;
+	bool force_flush = false;
 	bool has_deposit;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
@@ -2597,13 +2618,14 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
 	has_deposit = vma_has_deposited_pgtable(vma);
 	if (folio)
-		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
+		zap_huge_pmd_folio(tlb, vma, orig_pmd, folio, is_present,
+				   &force_flush);
 	if (has_deposit)
 		zap_deposited_table(mm, pmd);
 
 	spin_unlock(ptl);
-	if (is_present && folio)
-		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
+	if (force_flush)
+		tlb_flush_mmu(tlb);
 	return true;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 7f019afc35ca0..cd954afb146f4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1757,7 +1757,7 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 		ptent = get_and_clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
 		if (pte_dirty(ptent)) {
 			folio_mark_dirty(folio);
-			if (tlb_delay_rmap(tlb)) {
+			if (tlb_can_delay_rmap()) {
 				delay_rmap = true;
 				*force_flush = true;
 			}
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index e98397ac577c4..6a2d56970a552 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -171,6 +171,8 @@ static bool __tlb_remove_folio_pages_size(struct mmu_gather *tlb,
 	struct mmu_gather_batch *batch;
 
 	VM_BUG_ON(!tlb->end);
+	if (delay_rmap)
+		tlb->delayed_rmap = 1;
 
 #ifdef CONFIG_MMU_GATHER_PAGE_SIZE
 	VM_WARN_ON(tlb->page_size != page_size);

---

base-commit: 55c8a634fd238bc7e6e2c4010985192ae8163435

change-id: 20261113-dirty_file_pmd-90e63640a593

--

Cheers,

David


