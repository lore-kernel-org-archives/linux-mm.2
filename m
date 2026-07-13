Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8198C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7CE66B015A; Mon, 13 Jul 2026 13:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D7B6B015C; Mon, 13 Jul 2026 13:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C616B015D; Mon, 13 Jul 2026 13:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67F306B015C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:16:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 030B9892F7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:37:19 +0000 (UTC)
X-FDA: 84983855040.23.772EBCD
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4C86D40008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:37:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Emoa6QQ3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783949838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtWebUj//4zHLEaAYlPy0cK7ae9CikSRWhDrI9+mSdA=;
	b=TGsJVYFuhREy+D+LW8ES26KvFcPGpagixSUKVPACRpbmyYGd2xsi3mxYY6A47M2yNH4xvT
	1O/Y1+VrYa+1/6OQ1dkg+6y3JjwhfsdZu8h49sLdxxZ42+jmfGCUzSn69Of0hlb33a+CkH
	uMM2bqkjXr42SadbtNGezM0ugV/OoIY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Emoa6QQ3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783949838;
	b=SMJo3SSVMXurlF62/PoNvC1HEpfbRYzr9wIe6VhfdTWV9iC6rGiihT7xG+twMEw1Zyv3w5
	srRFa8fUW6vrZ62Efy5B9i3m6lvVH5JV+6r5CM3CZy/aigqZNbmMLu70wvVbutwLOa2FIY
	e3B+WY8jrEbR08WzPpunbt0S11blEIs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783949836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JtWebUj//4zHLEaAYlPy0cK7ae9CikSRWhDrI9+mSdA=;
	b=Emoa6QQ3ocNBAiKqF9g2zYAZ7ndnflpEbY26WPCX1tR4De1HNkRlkEcO+Fg1p+ozYwaIeR
	6lzsU0UotNO4TECLbEvTy6RakTdXxF+5RmQOVcFbYmo0jx3ISldGbQsoiqyM534NRIcCAh
	3MwHfAvxWxCBrLUH35pJ+8IUiJMmPi4=
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
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 08/11] mm: handle PMD swap entries in UFFDIO_MOVE
Date: Mon, 13 Jul 2026 06:35:43 -0700
Message-ID: <20260713133613.2707815-9-usama.arif@linux.dev>
In-Reply-To: <20260713133613.2707815-1-usama.arif@linux.dev>
References: <20260713133613.2707815-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4C86D40008
X-Stat-Signature: 43ewrhq9hkfgp8nizh57ziojrz5z65z8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783949838-794778
X-HE-Meta: U2FsdGVkX1/MGxSwezkcUvj9vfo84hiiDkZ8gaODsMaqajc8u1yq9oFQ7QfTz7YIwzPFLviqGvg3K2VreN7Zcd5/edgtuaBuSOr/4cdnWVpL75flXeXKY+9eg9oJNhrWzbmQOtCE972BQSWFNzregtrFW3KZc3seDnc0kXERCajpXjHZt+dxLdEfthH97mVOmkrHWyB6VmZHR76SU1bZ70H/kNGLmDg2ooTgtzzyCEhGs6tc6rdMIEEB+t+IQOKHHqV7GirPdidDd4iSqlylt+i3XsRm0bAg38kwptUS2btgVFyixu23jPnyWTgzv0cBJn6is42aitK45q8MKmrjH3h8m3yoQAq8VXuAx7bPi87HRTW8UFIjPgb+7/BzEw6A1n3xg7ye6iLt9LofBYLH5c70W5A3PnTA/TBjG3l9HQp/s+4iJRKbhOG8cN3jYwPPPzE+U7IwxNFApok1GfA+I/tAPhNpUtWPQFVqGOPoS542CVTGXotRk54terEeReKc/rQJSzV3Rz6FMETNXkN/iW/uQGkcgKi7qDbDXMOT0TDuE9B9R5AcxkK+b2mXMzXdF24pGdvxE0a0ipulUSE3WviF9bZH6Ti84LasGeGomEPvKgLJRWTwJxPEoFmklsY/uQlpBevs2ECAxby853wzMmUBq+3OFG0niQhFgns75pKrQ3np0VtbaseEp0M6l0FLexS7DZRN2TuAGQJZeTwEFWdGS0pPzkVz2QD12/nSXx3LwPRuCgzlWLBDwdMSPAx4eY0K8Qk5r32z5Qp5YQoXAjRzD0AHdD3eg6F6P0P0+xhYmkS2zw1Fzwag2IxYewl7bNtNflzHWIF23HA3eX9p54JwT2pooBP9ZUeyRKYVqbShlUVfunBQKLgPH9DUsxOGwVEgqjjZda7kxJQAHoL4RpzLZ743ncfKXCSnprMMuSB1yGYYlLDD9TaXq/qrwXRRENhPBxfsa0RubbZdAN6
 nul/T9ap
 VQHJm31fRn2EgDZWLU5Zfq1pa1B+TKg1UwK+qVysb7a8kl7t3rKSyGiHOkr7pYfBKluStPoI/2c76U3W83yFuye3AkZRGVfGr09SdXyJK7woj1rvGZ7gqZkflnTNXgVq7Qt6HvKddusPqCnyktlxkHhWgWgd2m/sscLWR2W/UniLT5LaYJzew7AoAhL4yH0G8OOQo687BIGHMF4PGRw9Sfy/3cz8W71a3q4LR72sxvt9XCVAYZ4W51ZVxgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_pages_huge_pmd() returned -ENOENT for any non-trans_huge,
non-migration PMD, which fails aligned UFFDIO_MOVE on a swapped-out
THP -- the PMD swap entry is a perfectly valid mapping that should
move whole. Splitting via the move_pages_ptes() fallback isn't a
substitute either: __split_huge_pmd_locked() splits a PMD swap entry
into HPAGE_PMD_NR PTE swap entries pointing at the same swap-cache
folio, but move_swap_pte() refuses any swap-cache folio that is still
large and returns -EBUSY.

Add move_swap_pmd(), modeled on move_swap_pte(), that moves the swap
entry whole-PMD and re-anchors a PMD-sized swap-cache folio's anon rmap
to the destination VMA. Reject !pmd_swp_exclusive() entries with
-EBUSY to preserve UFFDIO_MOVE's single-owner semantics, propagate
soft-dirty, and carry the deposited page table across with the entry.

The dispatcher in move_pages_huge_pmd() now waits for migration on a
PMD migration entry (matching the PTE path) and routes PMD swap
entries through move_swap_pmd() after pinning the swap device and
arming an mmu_notifier range so secondary MMUs see the move.

Before moving, classify the whole PMD swap-cache range with
swap_pmd_cache_lookup(). A PMD swap entry can be moved whole only if
the covered range is empty or backed by one PMD-sized folio. If the
range already has per-slot cache state, split the PMD swap entry and
return -EAGAIN so the caller retries through the PTE path.

If a PMD-sized folio is cached, lock and revalidate that it still
matches the PMD swap entry. If no folio is cached, recheck all
HPAGE_PMD_NR slots under both PMD locks before moving the entry; any
per-slot folio that appears needs the PTE move path to update its rmap
metadata. This avoids moving the PMD while cached folios still point at
the old anon_vma/index.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 132 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 991929ec17d8..b8e3566bd502 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2864,6 +2864,72 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 #endif
 
 #ifdef CONFIG_USERFAULTFD
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
+	 * only a compact encoding for 512 swap slots, and any per-slot cached
+	 * folio would need the PTE move path to update its rmap metadata.
+	 */
+	if (src_folio) {
+		folio_move_anon_rmap(src_folio, dst_vma);
+		src_folio->index = linear_page_index(dst_vma, dst_addr);
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
+	set_pmd_at(mm, dst_addr, dst_pmd, moved_pmd);
+
+	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
+	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
+
+	double_pt_unlock(dst_ptl, src_ptl);
+	return 0;
+}
+
 /*
  * The PT lock for src_pmd and dst_vma/src_vma (for reading) are locked by
  * the caller, but it must return after releasing the page_table_lock.
@@ -2898,11 +2964,76 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	}
 
 	if (!pmd_trans_huge(src_pmdval)) {
-		spin_unlock(src_ptl);
 		if (pmd_is_migration_entry(src_pmdval)) {
+			spin_unlock(src_ptl);
 			pmd_migration_entry_wait(mm, src_pmd);
 			return -EAGAIN;
 		}
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
+			/* Pin the swap device against a racing swapoff. */
+			si = get_swap_device(entry);
+			if (unlikely(!si))
+				return -EAGAIN;
+
+			src_folio = NULL;
+			cache_state = swap_pmd_cache_lookup(entry, &src_folio);
+			if (cache_state == SWAP_PMD_CACHE_SPLIT) {
+				put_swap_device(si);
+				__split_huge_pmd(src_vma, src_pmd, src_addr, false);
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
+				if (!folio_matches_swap_entry(src_folio, entry) ||
+				    folio_nr_pages(src_folio) != HPAGE_PMD_NR) {
+					err = -EAGAIN;
+					folio_unlock(src_folio);
+					folio_put(src_folio);
+					mmu_notifier_invalidate_range_end(&range);
+					put_swap_device(si);
+					__split_huge_pmd(src_vma, src_pmd,
+							 src_addr, false);
+					return err;
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
+		spin_unlock(src_ptl);
 		return -ENOENT;
 	}
 
-- 
2.53.0-Meta


