Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3141606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lDJze0Vl
Received: by kanga.kvack.org (Postfix)
	id C8FA66B05B4; Mon, 16 Nov 2026 10:07:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66056B05B5; Mon, 16 Nov 2026 10:07:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BE66B05B6; Mon, 16 Nov 2026 10:07:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4B06B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:07:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 118C11A0128
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:07:36 +0000 (UTC)
X-FDA: 85441311312.07.A0859A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 39B144000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:07:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lDJze0Vl;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794841654;
	b=HhyZP+LfmxuCDsmyA9fEIdObyvSi+xzKpIh6jlJ05en+JQUMiV+rlgfiaEp2vlNOrkzmPT
	KGmk4/aumvA+diw8UUq2a1gz9QxFYyWBLjf0svhpDIbr7rfvJ11Fiprrzj8b0+0o26PK1y
	8m6YmknEnorrMGiWt7axz2Tw1XzvnSo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lDJze0Vl;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794841654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QD0cZDtrkR3rLOoBjHXBbjLwcVi1FoKhT6W4AU5zZQ=;
	b=mBGbf6pRrCYLNKgFADdYbL3GaSUQe1Kwz5EkBY1wF5tJV9Rpo9y4puG1xxKyrM3JIlD78g
	b51SFoSODRDxRRroeIYZ4GZHpUdYpd0xEZSmEJDOMTsrdPqa8HGOWLwxqNtVoCU3LAOHKs
	NbJ+kZD+s2uTT5V5V5ilvpefvhlnjdQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86DB443660;
	Mon, 16 Nov 2026 15:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF421F000C4;
	Mon, 16 Nov 2026 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794841653;
	bh=0QD0cZDtrkR3rLOoBjHXBbjLwcVi1FoKhT6W4AU5zZQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lDJze0Vlbcx2eI74aKzEKn3KdIydzUfHMgoquUwTd1TIfaHSoBe4IUcA8Q/Ji2wGx
	 vNp5ihS9PBvh+TrfzNxZ+wsc2SQyq/Meu2xMk2XXFeocT0Msokui/0QltUAAgwy6C/
	 IzbJlS4fQ5eo2ZlMlp7HMTGDG/oJRHExa0fZuae76wNsCukjWGfE5eoeBD9M258zEH
	 wAsR5dqz3416tpYEZ9L2EyvtrJeRGhJks+x6+1ma3dAhNJF7QGvlWKihEwst2r61C3
	 VcLlAhpXDlaXAFAuX7WPzc46yuI4zmex34ot50jrBtEa/2cioFCf41wC12ND/waBta
	 +RxPsW3jWFfBg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 16:06:59 +0100
Subject: [PATCH v2 2/2] mm/huge_memory: flush dirty file PMDs before
 removing rmap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-dirty_file_pmd-v2-2-571883053174@kernel.org>
References: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
In-Reply-To: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
To: Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>, 
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, 
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, 
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
 linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7977; i=david@kernel.org;
 h=from:subject:message-id; bh=e1ViBoVjr5NiC44orqqaZsOgVGlVMLZ0SYLciR+I1cE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+y0hPXpmnL9fb0Tx9W/Sha173Xfc9nlEVvr/fQz72c
 1Iv55rqjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACainM/IcLp807aAq1qzi39p
 TO/64svCr3XGd8uBRSuYuHYcDRJL+8/wz/bMatebSZ7vJISCvnd+cP0ov/6JcLOIdUMK6zfnKKf
 7nAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 39B144000B
X-Stat-Signature: isbba7461535o6akz4i7iofhup5rdqoj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794841654-872317
X-HE-Meta: U2FsdGVkX1+gsQxcpoZcUkXQ17dNjhutLvX4gMbCVwowBzi+WNMzLZFa7cqt3vqqW63mrMsmPiWl8URi/TViW/dkVLoOSUJLWASGvnlyLSG5pWib0tLUgWkCQrpX7vLpF97+yCtHOJybtwt+ye7tItX7fCdoi81FbWkD7WBDNabjwuFAN1b1ZizEx00Rc20A17VkCNj7+ugvIMaDyhU+iEhWrAdiwXUYjuM5pYY9LhUD+QFaIZJCepOCacZ7x+Mar2FGkuTld4ijuc+D/roPSL7ZkGAFXLyNX7nGr4bG3f7JTlqmNIZe/eEypO6OJoQDkC9snPYAWBB2bWHgC4Y47ac7kpZzJPRwV4++xF/m/WR1UrUhRr6fBmjYGDviWhUkMk7EbCB4cQpQzd9B7RxmhwCAKnktvlzrjaDo9qKIJ0JkFrtrosartYDLH3CjO3LtrM4P0KL1q0nTKFTwjqtF1yTzQfioOzUbLvhp1anAHHGerO8iq1EMja3iClVfE/43A0Sz1D1RaldZS9n+9lr6WztjKhlWnn2aZoHvcNLy1EsgFXzloIL2OTO+n4HaH1wvqaGOe/Zoo/qcr6g20KioX9NxzMFSYnl0JkqQah9AtdtoDRo1X4/fzvUAS5vcgLHjI+KXoE/74ie6fVx4LXtf5k74/fPumPzbvutRQpQAIdzvLCwnhgvEPTxT7QDYdBxuX+P5DDk/a7oPJe4Sc/5IpkSxrd4FrTBDOgKwo4CxiqheTeSCzotlSHAN+Bwf/SDFpuDHDe6X/29PPntSYGCDg1g50eNfLY9q0wb37ORHDmQu83LGBo1mnXMlpNogVImpadHR+h8osA5fhUPe/1nuGkJNOZu9rwPfk6UPBrNqllMPcLZ56qg6YsfAecM7MTRe2x4Wnf7DwC3oz7l+daYAudPSSyhG3QW0dzB/T9lDyM6XiojoMYnhRCHj4//A8aeplPNPnUsNLs6vtgJVaPf
 9THdSd+d
 vA+16X5Dauv2V0kDaUMsy7F2bUwG+Es6bFtIuGsJTqZvKdch6i+VETX5O1iGbIiN4wW9f9DJ9ldhm2uMxDMqD1zyxiGc783YcSBM845aQD1yJMF5K1DeOaoWKBJymhgfqSnuF3J6paJ731OuMDQe56NkD1UeMLb8MEuwzhycpjdDEqWr4TS3kOHiaDUGDI/IRelhjla5jFyyPY4Nbb4j302cVH/HsgxK8zVJOA/5dYryEZjEcDtr0inBMO4rF+YgPqAD+AgrfJljS1aGfys9ZKtdKmPOo5Pgj+cvqFspOuYfJehCJ8OTaH7v2+oJrAca7aI5K
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
thread can still write through a stale writable TLB entry. Those stores
do not fault and dirty the folio again. Filesystem DAX has the same
problem with its dirty tags.

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
rmap must be removed first. Make the predicate side-effect-free and set
the gather's delayed_rmap flag when an entry is actually queued for
delayed rmap removal.

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
Closes: https://lore.kernel.org/linux-mm/aoWw_iKEDLjKL2jr@thinkstation/
Reported-by: Chris Mason <mason@kernel.org>
Link: https://git.kernel.org/linus/5df397dec7c4c08c23bd14f162f1228836faa4ce
Suggested-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/tlb.h | 10 +++-------
 mm/huge_memory.c          | 39 +++++++++++++++++++++++++++++++--------
 mm/memory.c               |  2 +-
 mm/mmu_gather.c           |  2 ++
 4 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index cb087315b4e72..b318e3e9e66a8 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -249,11 +249,7 @@ extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, in
 bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
 		unsigned int nr_pages, bool delay_rmap);
 
-/*
- * This both sets 'delayed_rmap', and returns true. It would be an inline
- * function, except we define it before the 'struct mmu_gather'.
- */
-#define tlb_delay_rmap(tlb) (((tlb)->delayed_rmap = 1), true)
+#define tlb_can_delay_rmap() (true)
 extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
 
 #endif
@@ -263,8 +259,8 @@ extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
  * delay anything. That is used on S390, which flushes remote
  * TLBs synchronously.
  */
-#ifndef tlb_delay_rmap
-#define tlb_delay_rmap(tlb) (false)
+#ifndef tlb_can_delay_rmap
+#define tlb_can_delay_rmap() (false)
 static inline void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
 #endif
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7791872f14af7..79d400ea9553d 100644
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
@@ -2519,23 +2521,42 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		add_mm_counter(mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
-		if (is_present && pmd_dirty(pmdval))
+		if (is_present && pmd_dirty(pmdval)) {
 			folio_mark_dirty(folio);
+			/*
+			 * Remove rmap after the TLB flush if stale TLB entries
+			 * could still be used to write to a mapping that
+			 * supports writeback.
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
@@ -2573,6 +2594,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
 	bool is_present = false;
+	bool force_flush = false;
 	bool has_deposit;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
@@ -2597,13 +2619,14 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
index c022aeb7c84d0..fc547be33a919 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -169,6 +169,8 @@ static bool __tlb_remove_folio_pages_size(struct mmu_gather *tlb,
 	struct mmu_gather_batch *batch;
 
 	VM_BUG_ON(!tlb->end);
+	if (delay_rmap)
+		tlb->delayed_rmap = 1;
 
 #ifdef CONFIG_MMU_GATHER_PAGE_SIZE
 	VM_WARN_ON(tlb->page_size != page_size);

-- 
2.56.1


