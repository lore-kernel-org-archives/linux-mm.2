Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C46BC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125BF6B00BB; Mon, 14 Sep 2026 08:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0296B00BC; Mon, 14 Sep 2026 08:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08586B00BD; Mon, 14 Sep 2026 08:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D28146B00BB
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F7381403E8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:11 +0000 (UTC)
X-FDA: 85212305262.21.0A0F1B6
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4E878A0007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w3Vsb0hN;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmCcNrE6sfgvRudyAzXc6/C5+4I3nEgZFNYAMKzUkhU=;
	b=gGZWHJ3UaxyAFsGRfYa6uLopLmx8icn4gOb8oEwezCIZg29R0t65vY9ZgngTaLScumMPlB
	2EUmd9gteQUOgy2nuEbsQkMZsRiefX2kpYjLytwkOQXKh1FiRLxI3G+xl6FBogULle5Skz
	3VYoOCC4ReZWTaeuAGQJh5X9H7ybvYU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389129;
	b=GAG7aV8ro4yhdbF0VhbWYCdBhVkOPiLj8rZV1kFXSIGR5pZLCnnj2Tz3sLuW/AAC7GhoeL
	dOGqhDLmYWlXcaxgDjUnbrLsbpJwqpOWhHuCnQpqMh7dqM8Ea/0BgzGAsKZ6vL5Psmhzb6
	GIN1ivVlGYnwW2f3rrN8GbctaG1Gap8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w3Vsb0hN;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l9rS6hCS40oLFaHf8DDPyFgRnX3di/CMgWWuQWOguRk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389128; v=1; x=1789993928;
 b=w3Vsb0hNhcuTJVOFM1gCOUpSQravM71il3YZg6kCY59NTZkrirvExSnvUra2Aqsfiyau6eXW
 9eC1Rvz/ww0JpAVNsTDT9jOSCaFDK20Z+DS+FwkjLwEs7aWv+/JqE67YvEzzdOE3wkFjIxTuFRh
 ptrwjleA8srVMWg06h52LqsY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id def300bf9b7a4cdf;
	Mon, 14 Sep 2026 12:32:07 +0000
X-Mizu-Trace-ID: def300bf9b7a4cdf
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
Subject: [RESEND v7 25/29] mm: handle PMD swap entries in UFFDIO_MOVE
Date: Mon, 14 Sep 2026 05:28:15 -0700
Message-ID: <20260914122950.3283997-26-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dcma4cn4dop5rpy659h3kpwdd1f3k8zz
X-Rspamd-Queue-Id: 4E878A0007
X-HE-Tag: 1789389129-63670
X-HE-Meta: U2FsdGVkX19OAzYMXC4XMjH0BLecYqwsAwnpRIBbqm2QLx53slbHIwmgXrRKHuGabp1ws1hInFiQHcRiFVU4UxAFUu9PPypulxhNvf4LQpq5f6kqTMuCLW2RQLZDSWb5iYvXD2Yb9swuwqQk4H0itfkt0vcbLbEfTH1uTHd6jfAzCESm21aQF8Inty2z5aQb55CikLQBjNxNqNndXwSBYndNdie9jZ4iaeMYbqqpjE1wQ5bU+uk/4r++GFlPVP46og3la9gbhA9GkFY8e5CocFK7Rw2a225qjUy6MyoCildvaUkGJk2OEDrMzFyyCgZEygnPUQ/FAwXsMEXNVgboYWKz0gpYAt61QKFyqpIKUHxD/kFENMfD4x+Wv4kPtpbqRqRvPiytbUKgV/mUjep+YyCYFXiI18+qPH5LA7EzQo6a6wDpYnXU5e3WjGFQUtzc3z8b9DoR77lrY4BK7aaH2MeU2ZXshbzVbIxIYMEcnEccVoAfYgI4jAk+WrmRDCxL0y0f45TqXnW59/w4kBwzC5MeEj2PEfpJfrf+fRKHdmSo3hUYayPVRRITGdPcy1Us8zxxXVt0jd/VAulxaMJgV/BUb5hhpjUxa7Zh1idSgMUQB0OjjmorJneSTsUjYxclZHCVTsxr+CDLx18VfNkL0/xySPDbZRTDLxBD+sPMWsYi9XlAvvKc+pkm2VCifKtrpRJdLw00G3wuoWnbZdyxs7jDEOD4/byBmPhyEHCawv9tqlpJ1Bl7PcnVbLwYreCKInFn2kK1M1q+K9TkCPr4hqTjqcKqUYxLmYb8dyvZr5FmGNbvofNL8j6BieWJ00kaUx+iwBhUeOsyHeHbCNt/puJTV8EQ6WfScI84+MzRqSQ87gf1wDXl8lfvvs/QR6s9tVhTh1UjekO3soozqcK2Laf0GtQ5sxjF7kqVo4n1iH+Gsjz1Yj6iNEmW7DxfuRQxiZwNZN7oKY+r992ICiJ
 nFI+fhfH
 m1GakN0B3jUAzUeMFPb3ONysNjIJiBF4rQJrnRslkTtShKBvopfDIuxpUsKDuU88fEbuzmo/DTdfa+ybDkC8JKm70O980BwX671R0H0oCL4KxAG+wjAIt74dEWdA07sa0SiyCWc3zj8IGUNSexDe8qhaUNuVs4emX2KD1aGKERya24A/SUsexW3znUJOlk1X6v/8ElyuON4A2a+YuPNfL8GqkpyLNKN8nsz/hSq2VNcMh/oBEJAWfGWqvO7+ncvw7FXloOYReuCwIJlHvAiYx7Hd+rQ==
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
index 5f3d620c64a94..497f677a3ef71 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2972,6 +2972,78 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -3006,11 +3078,95 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
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


