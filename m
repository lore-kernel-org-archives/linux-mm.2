Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43CB6C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B606B01A6; Tue, 18 Aug 2026 09:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CBCD6B01A7; Tue, 18 Aug 2026 09:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C7F6B01A8; Tue, 18 Aug 2026 09:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D646E6B01A6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42487160110
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:52 +0000 (UTC)
X-FDA: 85114430184.21.E8851C2
Received: from mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C12C1C0010
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UJA8fo0N;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.228 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28Zdlwxzz3lHUJUP7G43XylK3bhKftmWSdpHpJGyzXk=;
	b=xdbWj9zeAkjJgwbMxIWQgs8HxIrRl2AFYRe3/cElv/4965v6FCnUE6wfVaEAo9kRoXTWs5
	dwBaj8Zva21EPKhSug5Tnb8s8EfqpDdxO8tKvWOc+q+KpYRMWQ36U+AT3h3Dh3h9AwoCXq
	6N9bsYY7h5kSq9PFsNfvNuMatrlMnl0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UJA8fo0N;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.228 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058770;
	b=f7Oapf85uzassLRjm5JYGTYE4Jvr160L7/P8ic/CUlLGVhbPun9vSBaIyu4kLxR4ASMXcD
	RxADKyvIzb/FGGNv91Vntu99+rs+fuBS+FHdBHNFF8q/9ePO8A10I0QQbULHQr9UGABPlv
	Vcty7RzVgJZVn7RHQoZQOHS7nG3IdLk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=283hSMUTf8gUQjFzslSC5pHDKwFP9cHOoLBS8rXTLtE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058769; v=1; x=1787663569;
 b=UJA8fo0NMOR69hKHQibRS33CHzOeSWXnP30WedXLCzFu6kzymAsStkn6775HlO+POsYw9NL1
 91km0re/pHAnCWeOwOw/OgGfyF/fA6otJuUaaZdIMs/9iUO5nR0yq3Cct8n4fnv1eO7Z3cFn6QE
 0ySoVNMk9IIsDNeIyQJFjyPM=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:28::)
	by mta11.migadu.com with ESMTPS id 7b774479dcad1c3c;
	Tue, 18 Aug 2026 13:12:49 +0000
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
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 09/12] mm: handle PMD swap entries in UFFDIO_MOVE
Date: Tue, 18 Aug 2026 06:09:50 -0700
Message-ID: <20260818131202.494754-10-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C12C1C0010
X-Stat-Signature: 6mm9amgkgj6uckeyjcwkhewu6agztb4i
X-Rspam-User: 
X-HE-Tag: 1787058770-834185
X-HE-Meta: U2FsdGVkX18Y18AZyDUq/jPMAtB1AHx0pNeOXCKGQ3kIJCs7vK8IQclXb8MIGctoSGNmJ7CldpprX9D4jqr8iHsYDI5Q7F4UvxA9kn6Lq73GE0ogc28yw+aEK6gsnbCdd0t4WTZoF8o5BtDJDqzzSXeY9YHroI/v5xv3VlLqeZ4+vnNzlQ08v10hDJdAy2XtqMb+tsN7WBBogkNo9Zx85w3sIEeFoSxeCnL+ulgk3Axgh0y04xtNSfZbljnsF3c+DcbY7rCw6XI5tVixtX8JvLt6DphytyEDCPIRwCUaieui4fCQa/zb4DuHQWniyzBNyr4kHHzUJbvDHbRauxc5VYhNATeXoWtFsTwTyRtx/J5bVGilTP1aivv49TGdx3NbTNMGtt7dag/snF43ZNgD3gyKx3EZX1NtGluPfTbsFfjCS/yWTi0TbGYZrtYVTYR+UuguXwcrqaaMKHXlnPT7vPd0EBazA06pdq+HNx+mF9l/VHExQtD7NAVR2tcZ3g50UJUD96viQSdXQB/YewS2Uk/YRC+VdqDJf2lxF7CkEBWHgRfRXICR9vu6BaiM3lBX24rLDZqTI0pdP7pZYlCvoaq0BBH43qGpprkvnqhBYIQqC23RlT42dXHZEVevcaaQik+RWcmKdADdx2tgCZvAFVySADKLDct4C2Tq7K1BmZsOzGrzySU+jSr37tm4nW8+o3s7PiNxDL6nsAx6l9IC3cWMPVlfzME+2GqkEfpRgxFqtcEAEPll5TJZGLIXtqXjYEZQ1PEfUjxECj33p4JjynzvyspAST892tLJq9KXaD70te05HeyDZgWyCbFq5zvGhk9sEXck0pY5lgsUPsik+HLm7jpDivyByTVKw1Dk6svw/dAvOj9eDj4EBpeDf8Mo0bGfCkxXW6kNKCfrnlqlkiVT/nuKuNnlXOFeLjXRPNca4XJwehKoGdMXEcHvxnnnPiD1sRwLxmD9P8RpZdu
 /cDcFuUf
 /86B6716aroyPV8nTlOQeppf+UaZf5vDBaTC/jv2x6RTdM/nW4pLeLOJOMQMT4pzmu94BizsfZkT6/amCGAuQkcr41LsJTa4nOcmwpi6riLxiYT3JU0QoiDs/Wz0WZ2mAAh28+vfr4pPfs8sH3LwdeL8e5fhHCbo5l6EfGpNUp+5nA5Oor3C+O0xxbgwORm5or/YVmMVTvr5M8cD4eCujTvkYaySZertUU0LRqk/S/LZtaYz1t/JF+x2wm/WKJhHCejsE1sMZJ6GLnTeNDnNRfJy6RcNI6y3250aLNk+7Tb1ElsvXHecQ6/nktzNHgxDAte7y
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
folio, but move_pages_pte() refuses any swap-cache folio that is still
large and returns -EBUSY.

Add move_swap_pmd(), modeled on move_swap_pte(), that moves the swap
entry whole-PMD and re-anchors a PMD-sized swap-cache folio's anon rmap
to the destination VMA. Reject !pmd_swp_exclusive() entries with
-EBUSY to preserve UFFDIO_MOVE's single-owner semantics, propagate
soft-dirty, arm the UFFD marker for an RWP-registered destination, and
carry the deposited page table across with the entry. The marker
handling matches move_swap_pte(): the source marker rides along with
the entry and is additionally armed for an RWP destination.

The dispatcher in move_pages_huge_pmd() routes PMD swap entries
through move_swap_pmd() after pinning the swap device and arming an
mmu_notifier range. Both are guarded by CONFIG_THP_SWAP, since
swap_pmd_cache_lookup() and friends only exist under CONFIG_SWAP and
PMD swap entries cannot exist without CONFIG_THP_SWAP.

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

Finally, reject a PMD swap entry at the *destination* with -EEXIST in
move_pages(). Such a destination is not a hole, and unlike a PMD
migration entry it does not resolve on its own: pte_alloc() skips a
!pmd_none PMD, pte_offset_map_rw_nolock() then fails on the non-present
PMD, and move_pages() would retry the resulting -EAGAIN forever, only
escapable with a fatal signal.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++-
 mm/userfaultfd.c |  14 +++++
 2 files changed, 153 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54aef8394fa25..0076d206c6a8a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2913,6 +2913,77 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2947,11 +3018,78 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
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
+#endif /* CONFIG_THP_SWAP */
+		spin_unlock(src_ptl);
 		return -ENOENT;
 	}
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 23fb68fce000e..3692ffb326ffd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2106,6 +2106,20 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
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


