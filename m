Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 956A0C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BEA56B0092; Wed, 22 Jul 2026 11:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896806B0093; Wed, 22 Jul 2026 11:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760F66B0099; Wed, 22 Jul 2026 11:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 358136B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:22:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8E9D1401F4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:35 +0000 (UTC)
X-FDA: 85016779470.05.A4ED2A4
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 16E79100008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=isCMgnIz;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733754;
	b=kMJnbJCAFkMxYZG/0y2hxPRkVVxuavEvyG1FaJAc2IsJdnyFHiSN3CPvuUIEOy+rp9TV4z
	TZcEzWtYUs27NqSFt9AqrHVQ8Mq6d4xQtLuM0yFsuOFCvrs527dzsReawZFj2I9JXJPNHa
	/4jrQHasOKEG5nWuj1wh8UUIKHgcUVU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=isCMgnIz;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfMynZ4if4uEzZc1/SwTaCw8JSZ401quvxIZZ/Autek=;
	b=1jK90zTSeXB9eBFc+gAfa+Qlc66FFkrzHjK1I9jQFZHKFYryc37jj33dg4SXazx28Mbo/O
	qmqNCw3DWpqZ7631ue9KmlB70U8C2WxWtTUQYijRRI0HiJyqnCFZVEcT88RwSGjcOFCXeg
	62h7iQKOAFCH7IdodfSSaWAZ8XVw/wc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kfMynZ4if4uEzZc1/SwTaCw8JSZ401quvxIZZ/Autek=;
	b=isCMgnIzX2oUvH3asBJPAorv3yFHJJo4SqgjXWW7+RWOaP2gK3RGFxDlzpTBVvkPpKWe7w
	xyfE6eGGv7kjXZqZdojGagrW/o2t2Ek8uPjHT9IJXki5b5asQTKkxeean4ne8qV5XgE+Yx
	flsE8pnTgYLqsYrpfqN3e02bR+pbNJM=
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
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 08/11] mm: handle PMD swap entries in UFFDIO_MOVE
Date: Wed, 22 Jul 2026 08:19:39 -0700
Message-ID: <20260722152043.2273289-9-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nuh4bseahw88e3wf3pyh861pizg1xh8p
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 16E79100008
X-Rspam-User: 
X-HE-Tag: 1784733753-957
X-HE-Meta: U2FsdGVkX18COEhIo46Ri/ERR1g/9Y605FvUg/6xZFtaKv/LUgBzTzrAttvsJbnxGtf9jmUufTQVlfkxo1+OvaziTOSmnIlOMqALwdTYN4IN+owsUEeA7k+owPeZ+roFivzw0i4pDsTfdPJggjgi7WkM1UVr4vs2NqvK7dRjmc+lN1Pf/VFu4SFCvkpsfwziKURzhxwuk/JdRXKblYYGvy8UzcEaqrt5mvUAdYg6x6enWmoxOrKq13PyMFwAdFRqF7nZH4RBUAQsB+iFojuYnaSADVKr6bmA0ZYbeRzS4Fc/GZGMGZoSOosNhj7pbEEmA6LztxD9yPDCbf6fz31jq9C2bSPL1gbvElggxTF4eM+UXUwA8MklBdGW01ZjT8gFexGMvaMvA0PWfGTfAeUov4r0UvymT+4oaR+OJBvdQV9WMQnEtCk4GCh+DQfrxcLTvjRFpDlyNaUDdjm5nMpyXvhEkhElNPTk5Ozsr3dSyNNaaS4RS4lTr+W3tZewjVGN9NUKyDcGFYWHTM84B3NHKFXM6kjdjLosc71O57kmV0gxhuv9KncGjZWLHPOZCe8HuwwbgIK/iYw+fTwd0DrROnDUEE2aKxuEVyLcMjcQapisjP1NMCf7ZspNRBqtxSYxm1+PxR0nKwNrPOY8TopgyDQoxvBmIxlwyUximYcPRpX1ePo7J1D3gD5uo2R7ZX/hlKxc1NbY24HI2QCU/LO6AS7YXwiasT0LzWk4FfBk64sNiASFX7OxBBqwEbpalHrUZrt0omR4FD2JXrbLTJGZ6bUuQOWRRR60qOr2THFf5lG7Li7sDSWZPdbraNGnGunJXpTdTpuA53d/9SWV42JRdPcGRVjCEcwctE+wVcO9RCodjEYqhBJ1EmcQmoavfoHwZDo5Y19Qchw+DVkDcePMvu4gVQ646/UoO1XbrL4tcsnlL/S/YKC+SPyIopaN61zk6SVfn6qscUzrkmYEJon
 u/B6ylzx
 CCTGXeLy9ksNTYIC8cE8fAxaEnrBg4oPBDl5b797BYLjfYvTaF5W5F9bLfAn71HG3xir4Aqd4bHzRMzmdJ8KkxJP+i0ZLGloEVXWd12BF2dq9QYDqfgiVjgymK4LPcu9aBdNDGljRrj4z6t69cxErb7cK17NQttVmBmyV52NSeg9qHW8PPWhIjYklbIif4xG17pBXowbIV1BIuyEJuzkiqX7jTdPIs2MEbdwM3Q+71Z/SdGQG4bPVYHFVDQ==
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
soft-dirty, set the UFFD marker for an RWP-registered destination, and
carry the deposited page table across with the entry.

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
 mm/huge_memory.c | 135 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 134 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index eb2a66030438..07c421a16fda 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2865,6 +2865,74 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
+
 /*
  * The PT lock for src_pmd and dst_vma/src_vma (for reading) are locked by
  * the caller, but it must return after releasing the page_table_lock.
@@ -2899,11 +2967,76 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
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


