Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C90606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OisvzzoE
Received: by kanga.kvack.org (Postfix)
	id 8E13E6B05E3; Thu,  5 Nov 2026 13:42:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892E96B05E4; Thu,  5 Nov 2026 13:42:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE066B05E5; Thu,  5 Nov 2026 13:42:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41A926B05E3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:42:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B18A9A0BE9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:22 +0000 (UTC)
X-FDA: 85401935724.04.5E125CD
Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	by imf03.hostedemail.com (Postfix) with ESMTP id B487420008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OisvzzoE;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6r6GoXW1wRqpm8rEahDU+Q8nnjGuPny+39kE7OA6eE=;
	b=Nwv3V9L5/tFxG/uu/tpJk/dW7PK639cGy7c6ZzaYpJ1H+tizYolLT/JIqsX0/Gad27oy+0
	JpH5oOnZKW/TJtBGPxiRHzbFr36+9BqkhTtrTD9B158ROZiFA+G4UTZ0bQiajt3RvyGOnm
	clI14H7Hh712Fwn8DK23OubdmRyoAyI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OisvzzoE;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904140;
	b=mc3wMquB+mF7BDGm7cM/3mphKgC5IdMCmjwYf7ghTp7q40tHzAKdajEPQ/v5d60qldSoyr
	bPBpllCZrCq1+SAHNZGJ8VfXEEJ6+1PfI70NFUvFcveubPdFy2C4Zusqv7phHg0zflp887
	AN/xkfb5SP6fRMxL0vc5FlWtgizedbQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PHxg677bAXHmE86OEOHfaYS/DR37rbS34zhEGHcc7/4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904139; v=1; x=1794508939;
 b=OisvzzoEL38wZ2fCiKaL25KL7kY+7OIbX6qavcsa1i6geIbVt2RH8A73WxbREa3Mi5EQmFFs
 0bkrHx3u6fhrtv8Octmw2zAqyYHInkiJ62l/dgm0cyURWz0OIXRy8TyC4344gRnHJGUux58k6UO
 Gs0pcsy18gF3/HoJPC3Mgysw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 97c62b23eea458de;
	Thu, 05 Nov 2026 18:42:19 +0000
X-Mizu-Trace-ID: 97c62b23eea458de
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 28/32] mm: handle PMD swap entries in UFFDIO_MOVE
Date: Thu,  5 Nov 2026 10:39:12 -0800
Message-ID: <20261105183940.2236717-29-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jyt6smppru8b59fczgumcoa79smtqipq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B487420008
X-HE-Tag: 1793904140-406270
X-HE-Meta: U2FsdGVkX18lypgmlfBhdyCMAn6+qrCVmNn2y0d1hNwg6MsCadntpkzyPlaTtZ50lkA3iumYvX5Eja0u5qyTEQ+FUFZa32KdqmRoBTCC2HXx6BBVrZjsm0IJwrNu2N88tGpRcWys+QHOvNFE+scGRCvcc5gXk39N8UFU5iGaWruaRHcF920RpOzawO/IMS6z9GjKWs4eF1fIVA5hDxGSjUPAE2651jdpXZBQPzJkj6dMk3UccUX40ANUXDkrQ4ZzCinrkfMTSIHKSBvlCECJUi8hzSS5/L9hDtSMFeD/Hudxi2FWf5wRQu/JDJFMBS8FrRQ192gmCyL6HSL7dcK57dp6fjvTfQJ8b4b7XkqQmCh/Q9e2GEU4K4qrfbSHHsMs7L86S7H+fj+/14PB3c1ndxLiQOB3hrwUo/jUJNBWldZ+XQ1yu0OY58HEozkkCtZu9LBnE3gCl/HVJYLYal0pY8ExAdCLF7+zzPyvhZVL1RG73+npHlnQKaBNO6qJtHLWILgB+A6EmPBGr6RiGtUSIeCBTwbFsYvKjgSGDC1c+aC/cuiJUnHDgIVWoQmIJCOC1C9RVcyt8KTTXBWAe5f2quTsmaG6PIUE80fsCu8Ivti7p6+vPJvY6c4hxfhji0kP3lsdzd1IwPQ0RY4oYhAQj/CmXc1/aph9h4zNbF1Uk7P2qdKYHrnCYTKlss5DKvyNBwHt0D6RnTWsbfKlEB25td5jXGs0n9FSEPydbjItPHdFrlf29sZ5dBKothIrblWi7xf/zoIsMYPY5uiw7ATNk41fo4pTeA5Y1dTDbPuNacpFYsYinOg4qRI1Jg2vbuzG3tHv7T6aK/T8MEIIyMETQBqF2PJKPKIYHIviKhTCILy+YiCiNEPRT6b5v0BiX7YlbegIB6SIUOYzfGU/hjqkvtjfLNywnCR2/0SpmmFly0w+H0UQB6oOmmRUBbcjjRBJI969P/5xU6bhR8qCC6l
 6YrwbRU2
 A6VPNaCGcoL13CLB+pt5XbZqHOnlneJQ54As2w/LMV0KLf7PJptZPS/RemFRRIkXHr4NJQgWD58ohZROLxSIWIJ344Hu/dROyLLL58/NQ0MW8OhXNuNJpRijQjqCBojEzuc80sT46uCnlcgES4K3DutYO6ZG2zH3QQShUgU993fWG5HWg9RhNQdgKTD42HxSK2JfZAwlcBece/YqARbF+RG0nd6qAaJOeQJLpxV4JvGwpjZdb/WroMaaFixX/uAFft9qgnQ85z5qgao4RT8Uxp4v1eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_pages_huge_pmd() returns -ENOENT for any PMD that is neither
trans_huge nor a migration entry, so an aligned UFFDIO_MOVE over a
swapped-out THP fails even though a PMD swap entry is a perfectly good
mapping to move. Falling back to the PTE path is no help either: splitting
yields PTE swap entries pointing at the same swap-cache folio, and
move_pages_ptes() refuses any swap-cache folio that is still large.

move_swap_pmd() is modelled on move_swap_pte(): it moves the entry under
both PMD locks, propagates soft-dirty, clears an inherited UFFD marker and
re-arms it only for an RWP-registered destination, carries the deposited
page table across, and requires pmd_swp_exclusive() for the same
single-owner semantics.

The entry can only be moved whole while the covered swap cache is empty or
holds one PMD-sized folio. A cached folio is locked and revalidated, then
its anon rmap is re-anchored to the destination VMA; an empty cache is
re-checked slot by slot under both PMD locks, because a per-slot folio that
appeared meanwhile would need the PTE path to fix up its rmap metadata. A
range that is already split is split and retried through PTEs. Revalidation
failure just returns -EAGAIN: its usual cause is a racing fault that made
src_pmd a healthy present THP, which must not be shattered.

Finally, reject a PMD swap entry at the *destination* with -EEXIST. It is
not a hole, and unlike a migration entry it does not resolve on its own:
pte_alloc() skips a !pmd_none PMD, pte_offset_map_rw_nolock() then fails,
and the resulting -EAGAIN would be retried forever.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 159 ++++++++++++++++++++++++++++++++++++++++++++++-
 mm/userfaultfd.c |  14 +++++
 2 files changed, 172 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 65922d9e4bec1..e02a885ea1d0b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2938,6 +2938,79 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 #endif
 
 #ifdef CONFIG_USERFAULTFD
+#ifdef CONFIG_THP_SWAP
+/*
+ * Move a PMD-level swap entry from src_pmd to dst_pmd. Both PMD locks are
+ * acquired here; src_folio (if present) must already be locked. The deposited
+ * page table backing the source THP is moved across with the entry.
+ */
+static int move_swap_pmd(struct mm_struct *mm, struct vm_area_struct *dst_vma,
+			 unsigned long dst_addr, unsigned long src_addr,
+			 pmd_t *dst_pmd, pmd_t *src_pmd,
+			 pmd_t orig_dst_pmd, pmd_t orig_src_pmd,
+			 spinlock_t *dst_ptl, spinlock_t *src_ptl,
+			 struct folio *src_folio, swp_entry_t entry)
+{
+	pgtable_t src_pgtable;
+	pmd_t moved_pmd;
+
+	/*
+	 * The folio may have been freed and reused for a different swap entry
+	 * while it was unlocked. Re-verify the association.
+	 */
+	if (src_folio && unlikely(!folio_matches_swap_entry(src_folio, entry) ||
+				  folio_nr_pages(src_folio) != HPAGE_PMD_NR))
+		return -EAGAIN;
+
+	double_pt_lock(dst_ptl, src_ptl);
+
+	if (!pmd_same(*src_pmd, orig_src_pmd) ||
+	    !pmd_same(*dst_pmd, orig_dst_pmd)) {
+		double_pt_unlock(dst_ptl, src_ptl);
+		return -EAGAIN;
+	}
+
+	/*
+	 * If the folio is in the swap cache, re-anchor its anon rmap to the
+	 * destination VMA so a future swap-in fault at dst_addr finds it.
+	 * Otherwise, re-check the whole PMD swap range: a PMD swap entry is
+	 * only a compact encoding for HPAGE_PMD_NR swap slots, and any per-slot
+	 * cached folio would need the PTE move path to update its rmap
+	 * metadata.
+	 */
+	if (src_folio) {
+		folio_move_anon_rmap(src_folio, dst_vma);
+		src_folio->index = linear_anon_page_index(dst_vma, dst_addr);
+	} else {
+		unsigned int type = swp_type(entry);
+		pgoff_t offset = swp_offset(entry);
+		int i;
+
+		for (i = 0; i < HPAGE_PMD_NR; i++) {
+			if (swap_cache_has_folio(swp_entry(type, offset + i))) {
+				double_pt_unlock(dst_ptl, src_ptl);
+				return -EAGAIN;
+			}
+		}
+	}
+
+	moved_pmd = pmdp_huge_get_and_clear(mm, src_addr, src_pmd);
+	if (pgtable_supports_soft_dirty())
+		moved_pmd = pmd_swp_mksoft_dirty(moved_pmd);
+	moved_pmd = pmd_swp_clear_uffd(moved_pmd);
+	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
+	if (userfaultfd_rwp(dst_vma))
+		moved_pmd = pmd_swp_mkuffd(moved_pmd);
+	set_pmd_at(mm, dst_addr, dst_pmd, moved_pmd);
+
+	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
+	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
+
+	double_pt_unlock(dst_ptl, src_ptl);
+	return 0;
+}
+#endif /* CONFIG_THP_SWAP */
+
 /*
  * The PT lock for src_pmd and dst_vma/src_vma (for reading) are locked by
  * the caller, but it must return after releasing the page_table_lock.
@@ -2972,11 +3045,95 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	}
 
 	if (!pmd_trans_huge(src_pmdval)) {
-		spin_unlock(src_ptl);
 		if (pmd_is_migration_entry(src_pmdval)) {
+			spin_unlock(src_ptl);
 			pmd_migration_entry_wait(mm, src_pmd);
 			return -EAGAIN;
 		}
+#ifdef CONFIG_THP_SWAP
+		if (pmd_is_swap_entry(src_pmdval)) {
+			swp_entry_t entry;
+			struct swap_info_struct *si;
+			enum swap_pmd_cache cache_state;
+
+			/*
+			 * UFFDIO_MOVE on anon mappings requires single-owner
+			 * semantics; refuse to move a shared swap entry.
+			 */
+			if (!pmd_swp_exclusive(src_pmdval)) {
+				spin_unlock(src_ptl);
+				return -EBUSY;
+			}
+
+			entry = softleaf_from_pmd(src_pmdval);
+			spin_unlock(src_ptl);
+
+			/*
+			 * Pin the swap device against a racing swapoff. NULL
+			 * means swapoff is in progress, which resolves on its
+			 * own, so ask the caller to retry. An error pointer
+			 * means the entry names no swap device at all: that
+			 * never resolves, so report it instead of spinning in
+			 * the caller's -EAGAIN loop.
+			 */
+			si = get_swap_device(entry);
+			if (!si)
+				return -EAGAIN;
+			if (IS_ERR(si))
+				return PTR_ERR(si);
+
+			src_folio = NULL;
+			cache_state = swap_pmd_cache_lookup(entry, &src_folio);
+			if (cache_state == SWAP_PMD_CACHE_SPLIT) {
+				put_swap_device(si);
+				__split_huge_pmd(src_vma, src_pmd, src_addr);
+				return -EAGAIN;
+			}
+
+			mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0,
+						mm, src_addr,
+						src_addr + HPAGE_PMD_SIZE);
+			mmu_notifier_invalidate_range_start(&range);
+
+			if (src_folio) {
+				folio_lock(src_folio);
+				/*
+				 * Do not split on failure here. The usual cause
+				 * is that a racing fault swapped the range back
+				 * in and dropped the folio from the swap cache,
+				 * so src_pmd is now a healthy present THP;
+				 * splitting it would destroy the very mapping
+				 * UFFDIO_MOVE is trying to move whole. The
+				 * caller's -EAGAIN retry re-reads src_pmd and
+				 * picks the right path, exactly as
+				 * move_swap_pte() relies on for the PTE case.
+				 */
+				if (!folio_matches_swap_entry(src_folio, entry) ||
+				    folio_nr_pages(src_folio) != HPAGE_PMD_NR) {
+					folio_unlock(src_folio);
+					folio_put(src_folio);
+					mmu_notifier_invalidate_range_end(&range);
+					put_swap_device(si);
+					return -EAGAIN;
+				}
+			}
+
+			dst_ptl = pmd_lockptr(mm, dst_pmd);
+			err = move_swap_pmd(mm, dst_vma, dst_addr, src_addr,
+					    dst_pmd, src_pmd, dst_pmdval,
+					    src_pmdval, dst_ptl, src_ptl,
+					    src_folio, entry);
+
+			mmu_notifier_invalidate_range_end(&range);
+			if (src_folio) {
+				folio_unlock(src_folio);
+				folio_put(src_folio);
+			}
+			put_swap_device(si);
+			return err;
+		}
+#endif /* CONFIG_THP_SWAP */
+		spin_unlock(src_ptl);
 		return -ENOENT;
 	}
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8cff0f820ca51..38b63e9cff62d 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2072,6 +2072,20 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			break;
 		}
 
+		/*
+		 * A PMD swap entry at dst is a swapped-out THP, not a hole,
+		 * and unlike a PMD migration entry it will not resolve on its
+		 * own. Nothing below faults it back in: pte_alloc() skips a
+		 * !pmd_none PMD, pte_offset_map_rw_nolock() then fails on the
+		 * non-present PMD, and the -EAGAIN that produces would be
+		 * retried forever by the loop below. Be strict, exactly as for
+		 * a present THP.
+		 */
+		if (unlikely(pmd_is_swap_entry(dst_pmdval))) {
+			err = -EEXIST;
+			break;
+		}
+
 		ptl = pmd_trans_huge_lock(src_pmd, src_vma);
 		if (ptl) {
 			/* Check if we can move the pmd without splitting it. */
-- 
2.53.0-Meta


