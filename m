Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79F12CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2EE6B00C5; Fri,  2 Oct 2026 05:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33C1C6B00C6; Fri,  2 Oct 2026 05:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2035E6B00C7; Fri,  2 Oct 2026 05:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DDB436B00C5
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6056CA06AC
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:34 +0000 (UTC)
X-FDA: 85277234028.06.B5BF015
Received: from mta1.migadu.com (out-232.mta1.migadu.com [95.215.58.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4C0EB40008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QjBsDm2n;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.232 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5V0soM3OyExeCF2SHvNSF4CrPeFNFPk9LhkyB1itN+o=;
	b=e4opf3W+RgHk4xReo9TLomDjVHf+RpkN+sSoAeQAPsp1TjNd8RxzxMbsnn+VFFj0FA1mW/
	12vo2gafK/Xtue0QYknmAdXn2YgnZVTG1MS1mKTTGMhISg1DAgS1osIsad5U5PTLrwEbV/
	hBitNbLqocRLJO79gWJ7pkOip6qz06g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QjBsDm2n;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.232 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935052;
	b=qnQ5uJTatxozRrltbKKfW3W/rIbDq9r/g0lq5EZ0xL1P252FBqRNlyAsa72oUgOI0GsGqz
	i6TiZi5mLvzPvkvF9MGOTSURG+DgodJA0K/bJFTAxrDXCjgBEmAR9anuCkJ1m/8LeMnCiF
	Gr9NUlc6p4UjpGp29pMEl0Fdeb4uH/8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cxNvel52tVWL46OxxvA4uj/zJ6WJChTmYu9YRvvOH8c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935051; v=1; x=1791539851;
 b=QjBsDm2nZogmHSxex5ZxKBNl/RoUA71D5BIOrwnSApLXfio+/40KUqEFBiHJe2yTkU/HJpRU
 j9+cJwpvvkV/BLPVgTxDVN8v7TqeneYyCdsFPIHm8J+H3M3zvcN0JHCvO4jrWWPK2sh8Uwa+CP3
 FRN5rxiXoJPeDZUtyZlECEcs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 93ef1d54995e1355;
	Fri, 02 Oct 2026 09:57:30 +0000
X-Mizu-Trace-ID: 93ef1d54995e1355
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
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
Subject: [PATCH v8 26/30] mm: handle PMD swap entries in UFFDIO_MOVE
Date: Fri,  2 Oct 2026 02:52:40 -0700
Message-ID: <20261002095503.3585565-27-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C0EB40008
X-Stat-Signature: 3yh5apdbqac8dt4oxuhsna1r34t3n1ek
X-Rspam-User: 
X-HE-Tag: 1790935052-47238
X-HE-Meta: U2FsdGVkX18E4CsAke6wOyra6u57bA4ie9CRHta2hhYgzC5cvPuwKSJDiMqChiiKihMfKB8vWb11Rcz8fIwAqgokxqxA0QvqKX3ahl59Nr6XKanBfS4dDjGjNE+3/QS85Mf+w26vK0m02eWNbvpIj1m8oieClcibJPHcExble+GHe+HBogpPktoDcFp8i3PXEnnFLIoY38cLkUrkDA8iTCpCsAQGqhKO5LYF5rcfiD/Myhwg5BVPC+CiPhrMjgvddCvW1Q2rB95j9U3bYe12uOQUCUmePJvQARXltOrnlsmknuVLVIGzwdkYm8mGz7lvFUVdwY+hyUL87QCiiKLAP7AoYeYDRzrdhzoNivgv0Un/VAJZlqv5dQSIZtcB0tPW8qp1xuLa91EyrXjgemC4c3jTB5hXLY5Jqkma5Elx1yNzYHKw9Kp6qLNwoXWKkRzSP+3oo7UVz9EYtBqqXqVtT/v9GFV0mD09uulSf4IqnDSSgnKIlmEvZ4grZzgHm51+0G/LfoGW5Tp2YlchHLHBka9jhmdLMFeOX/GoGrP+/e7Rb8nagwKQYjlXk3EsbYpF6n7dOPQ40AHa/UZRscQFfvD47mtW7L4aotCGxZDLEuic+vwdcuMQRPfwseViy9by0lZj68AWlz9V6TrDyMbDNHOWEL/xdCSWGk78gzoD0Za9rQ5M7n4BGy8JwKsoXq6xf6WZps5fRq4MoXwWpXa2YldRN5GL32phx98cn/NZ/urvK+yzNP21OCzBUMUqxYFv1d059B6xw64NR+cvqqEeRFjQvMqwbJeVKKcjQjQMy9YMrQldOXGUSXVWXIoXzT7S2A00wUTJyG2UWO6Vq4hUZ2Y0vBUUtSgFILtpfCk5woJlS5WWA3yYYeLKgrgTHKO6W8whU6O3wXHBnXDUehYrTU7qSOR505hr24XhA5ZDUIxyi3w3ZIzDBoE1r9nopvX29Pu6K5HRJM4zYb1gfKO
 X2lD0+31
 xmDFsxdc67GKmIIsK+EqZphDLNIAKlQOdb/kKfmZKcmYaUVJRaUOoAO4tTQfcexXFFELu48tQWGPzzDVmH9X5Ji1FhBo/jxzoaj4U/bShU/VgCMhfGDT+bOHS3HUgx916khAhHqM3mnFQ+WGHcqbEQtaYwVcbvUbZUdu7SMWlq52UVdMCtNmWk+gTvgoeYQKrrrPrGEERl+POp5WmewMu3ZZI1llHTM4cmRqe1Xf9PgeLqUSRzbw5grMtnhj5CfXskTzQvYm0HjRG+oIRy1bvx5AGzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_pages_huge_pmd() returns -ENOENT for any PMD that is neither
trans_huge nor a migration entry, so an aligned UFFDIO_MOVE over a
swapped-out THP fails even though a PMD swap entry is a perfectly good
mapping to move. Falling back to the PTE path is no help either: splitting
yields PTE swap entries pointing at the same swap-cache folio, and
move_pages_ptes() refuses any swap-cache folio that is still large.

move_swap_pmd() is modelled on move_swap_pte(): it moves the entry under
both PMD locks, propagates soft-dirty, arms the UFFD marker for an
RWP-registered destination, carries the deposited page table across, and
requires pmd_swp_exclusive() for the same single-owner semantics.

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
 mm/huge_memory.c | 158 ++++++++++++++++++++++++++++++++++++++++++++++-
 mm/userfaultfd.c |  14 +++++
 2 files changed, 171 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c3d37dd84f523..8641e1726472e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2949,6 +2949,78 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2983,11 +3055,95 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
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
index 79cc7b546f130..e9e1df254fd72 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2053,6 +2053,20 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
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


