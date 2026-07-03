Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E36C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E0E6B00C5; Fri,  3 Jul 2026 13:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34ECB6B00C7; Fri,  3 Jul 2026 13:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E716B00C8; Fri,  3 Jul 2026 13:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E66936B00C5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:40:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EB4BC1614
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:40:15 +0000 (UTC)
X-FDA: 84948179190.26.A0BF434
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id BBEE618000B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:40:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oZqBeP8/";
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100413;
	b=URHvN4ikhC9F81wilmvPm7V1UlrZpPw14e8Sn02KMIAoqeY32GeMRnUMecYkG3jIGpvYc/
	Hu7OQkXGMq+EHajBGQDQaywdXrBxTzljcEsagP2LG+say7CcceysEdl9n3OPokkSH1wIU7
	7Io4cpXPe3uVV229H6Ig5Z/Gf/EnNLA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=As084j8Bxd/V9UM/a2BtJ4OJ/h1WlvQKkdgEnEZfc5o=;
	b=SKAOrNOlcQUvZxnpCOeoRaQ0KFZ5eQIWx2F59X6SlkRCPp3JmiFUFcEO7BsPTZRfqPGCs1
	guNUNSQVETmT5HUaTPjcLU+fGvgYqFFj6eCivGbzbe5vtdfcqiymOd7bQsab0QGi4DSYj0
	fINzOzvYcH8NSMtmjld5QVwrSAS2WKs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oZqBeP8/";
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=As084j8Bxd/V9UM/a2BtJ4OJ/h1WlvQKkdgEnEZfc5o=;
	b=oZqBeP8/kGBE46LLgBRaGUqkCbIPXwac8oEs3LFm9qlkgK5hq6owH/x6SFlxWqSe2jpyJ/
	r1c8VqBAw+3tOTn4dfTZbfdI1yFzU9l1qN74lyZc1DQUA9U1KPeoaGsOIscfwkyn0olzgi
	4H87r4MU2okMZbSKr6nFwHsA68SxDAI=
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
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 08/11] mm: handle PMD swap entries in UFFDIO_MOVE
Date: Fri,  3 Jul 2026 10:38:25 -0700
Message-ID: <20260703173903.3789516-9-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BBEE618000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ozt6d3u8hdfnignzp6pmo8qztkbiyjyk
X-HE-Tag: 1783100413-648837
X-HE-Meta: U2FsdGVkX1/W0UNZk2ag8TXouRmiYUIPRSSYNcJUfF5ugJ89BuaE2Pc/zJKsnCnUvHAyCMuFvg0JMfZNfZm3FJCjAs4rmP96jb0hAWc+9nZ4FFjDBu1e8Z8CHFIQycanJE2EgPVsrDEeKSFWNxqUVLN1nHNyODOUpuSIEIKn5ZYIaHuhl7Law0VmViDCN37tkS3a/7E8MkXQpvtrRXljaHTjnzeMrQ82DBss75eZfmROwrOWOtIUn3DUFmIXhd/TkQVAV9VyCYZipS3RFSogBnQldLja9fu3wk+4l77KBFTx+4IzJ/d1ju5L2f3i4tcSCgITC7p0oxc2TgUDPOu7G9WwbveaI6+X81HlVx3FIedF3OAqy/BKLf3qcf6XSdj0Nv0sNMzfczOCjB69a6DBCPoMhIN5X9oGT2drMkNNo0PHe4RXkObCGv2Y6Dthn6CaL4YppnW+1Yvo6badx9lLiBJmEPps9jydcRpPliqZr7se0OIrSbVblbi9o+jmNAK16hpNnxvJM8X8NjYG1NSE63iTFx37TA7DP2yQeMB0fDhtENmCGTigYlCSfkiY81R4Zd4HSGckfRnNVgRjK2tc0OVIgB8EmpjTrcHRXAEB9+IFJearPEfU7Xd6ku7gby5a5m7OMcbho3pC2Wv1g0rUuShRFm6K+8iFiQXbZ9wXancSadktDUobz2L+GBSlzInpBbdzpEZpfkUfrTlJvvVs7rRl4RnwacDn2qq0eBboHTVI1kGfRZh1xLbAyjXdDDInk00q6JRnrzuJ92tm2Qk9o353znznqUupDpO71jv6PaDULXjMKS48AvnQpSzRqGKd8oCHkHV8aV/a8XIxTwjUzSnSJ6xqSIkpizZ6eoBhI8UUgivNRgQ5uPu5w8h0Qhup+wNLEa3ecr07nHG2/Qb8/hY+r+YmRFiBxl9g66p92BX1AA3wB57yv3tP4ffATtXfV+JnSC/dGDtvBCs0f+g
 tFYuEzDt
 OI+4ME2N9ATMseiHquwbh90hxJcF6ZAiALbrV8+3k35p/6Sv7cEOkC4p5o20Z6OcasLQKd09+x2tgMtMjwObbb/m6hAzjllteTO8DppLKLifaqnCY36BFCETUtmfqlPtN6/VXoKxCW13EX46UcoRcC4jUw20nDunDa13uawWgtKlWphkY//32P5oEI2VeHTc05mcqfG7KXU5zrbAyHox2tJKYOQbu0+erVBfqCzv0ZjKFeFgmMFdprjk+Ug==
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
index 4cbd6123bf18..fdc1a503c609 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2810,6 +2810,72 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2844,11 +2910,76 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	}
 
 	if (!pmd_trans_huge(src_pmdval)) {
-		spin_unlock(src_ptl);
 		if (pmd_is_migration_entry(src_pmdval)) {
+			spin_unlock(src_ptl);
 			pmd_migration_entry_wait(mm, &src_pmdval);
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


