Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 455BEC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A566B019F; Tue, 18 Aug 2026 09:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FAE06B01A0; Tue, 18 Aug 2026 09:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601E16B01A1; Tue, 18 Aug 2026 09:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39DF16B019F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2FE78011D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:36 +0000 (UTC)
X-FDA: 85114429512.24.A2DC46A
Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	by imf29.hostedemail.com (Postfix) with ESMTP id C699D12000F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oLdvZbYB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZS46aBRGnEuZt8/MSSmlLvjWqEPaqj0LQqMc9oieGyo=;
	b=b7iVq3W/famWB+VVDw9ZFtGb7eDn9xpKG7OG82/FRmn8WnYK8uWyEBX8m3AZPwwcO1bCjo
	iEcyUIrKO+uVNX778bcKxFDIL+KAxBxygExrTqhnM/4cXwCXyzlE31j3ZTY7bUJp/j6o3n
	cO54+pZQ3OYgJGLKiLD6oj4LGQjzP9I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oLdvZbYB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058755;
	b=JCl7dfGqjUGwzw+icdsf54At7NF2gGhS9RPGTyzU82r4SKd90lqmqVZfkMloDUPJMOIW1B
	NOcGL0f1AfrVi8Fw74F8/h0EQ5+FO3mwdSJjV9rW4tm41Gq/QhwAaZKJNoHZskHGXeaYNS
	wU8uY3NA8SPf2nGQCq3WE15W0jgSsyA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=669qLI089dH17Rw7Kr9YX56S160m9VKovF8ZGZBWnlo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058753; v=1; x=1787663553;
 b=oLdvZbYBjeHUUhHBs4AsNXLNoGAVbMHDEFgg3PsPhLzE6sOmYPPyzlKoN57ZFwRbTC5E1b3y
 1jmM44ii7akcjig3aFLrYysiknx+ll3AQXVHUILXyRsls4MKwxn+oaJCZ2bAfIzoeZFGI9RaTnj
 RkYm7cIhBHK/CEcen+rO7LAg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:d::)
	by mta12.migadu.com with ESMTPS id 0dd70e55678ba656;
	Tue, 18 Aug 2026 13:12:33 +0000
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
Subject: [PATCH v6 06/12] mm: swap in PMD swap entries as whole THPs during swapoff
Date: Tue, 18 Aug 2026 06:09:47 -0700
Message-ID: <20260818131202.494754-7-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C699D12000F
X-Stat-Signature: je9jafs5ijmeqw864jp1fcxxccod4kdi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787058754-687133
X-HE-Meta: U2FsdGVkX19LPHM+xvtn71NimQaIyGzHLR/eF62ECiyH0/WhtsyUL7sasVMPmKqGAScQGIQTEKasQZOct+ZnlfamqFat6V61Zerfp5OAYegqSFlQ4oI2a1V18YDAnTYKobVQUpL56XSIpuV0nLlBFY3iDmCpKvxtssJjfaByN/liModjAh1FJQhv2iHKn5q0wOjVq4Onae+ISdBWPr96rFAI3bk743RTQHi0YYicWL+RCwRLcLw4M0aNGXhiPnFF9hQDiIH5ESDfFHad1lCripJDvYodq0EuUtpeubHb3F2fH+wy8Woy+g25QZpNjQQT0OtnkmhasejLCE0QuXXDeqoo71YV53yls7KAUlwLEnjKBO2sLOcMVK/zDEOaCwzv0oPA33zx5kxqXdmnh8pOdHXfopdKeSiRYvBQbpzzQvTedgG0iXp9lhbI74jfidhyff8Z6iDNEEQErPMdj9fYTYW1M+g7GaYNrjzIQCVHQ6BQxVWMHiK9RcTzUAOKkbOzjvB4NHerENFOkx/5PveHrAI/aX48AVWzTnjqJhwdMCi3FtERbkNz1arYZdn+1I6qlIAx9YfDEPQzaZRqlDGdwV2mDyCD1r/2mJ/Bm5+Qk2bLUXyTQjgEP5zhX+2eIqaWbduzfoMeugqAQNmCAYH8ZvT8HDVicbABhucOBDTCQsU+zh3IdNfUMIlg5ON6dSYJYYx3RuuDGdEZ2qMJlO4vtj7GmkYMNwd76+9wgjSUkpDW2SLUpBVyK8Gpn9tjixq5VPuOGgSwWVLFBzdRrAjqkitJHlSiLMUDkEBev6aES9aIrVQqqAZIjuVRL9yfaOsU+ygRnesWbeFIN09jv4XmNlFD0YKRkBt9ByJedSQJKGEvXWnHWnkMHJyasmPOQttqtUwQx4relpu38shmTbVMQu4qdw//o4OvfgI08F/pzJ5CFHp7ZtbJmZlFLXOBY2nfV+dOY67OFQPLFVSw3kP
 qSxZ5V9U
 6bytY1O0e6Q0dqumHRMjn4wMPvuTq2EoTfK4uaqwfYfIUTJXovEndsgv0L2SMjcwPCWkqBAz5ccAUi2A9v5SjL5gDDppmnCL8gXs36axx7Nbo6rjjVJsmP5rfYeclcgJl3x+uEwZiIDRmmgHkdIISAzyjLcJTR0lGE85oGxULnu4WPjgjIyZiOyAGxseCKh4kNVnj55ff4KeaKS7pEmU1kW1NPQM7UnpCd09quTw6jEKgVtNaTseV26AvuaIhe2TySo5gTqNPMdE6OSrhiH3wNz1uXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add swap_pmd_cache_lookup() to classify the swap cache behind a PMD
swap entry as empty, backed by one PMD-sized folio, or requiring
per-page handling because at least one covered slot has a smaller folio
in the swap cache.  PMD swap entries are handled at PMD granularity only
while the covered cache range is empty or backed by a PMD-sized folio;
a split cache forces the entry to be split and retried through the PTE
path.

Add unuse_pmd() and call it from unuse_pmd_range() to swap in
PMD-level swap entries as whole THPs during swapoff.  This mirrors
the existing unuse_pte_range() but operates at PMD granularity.
Preserve soft-dirty, exclusive, and UFFD state when installing the
present PMD.  If an RWP VMA has a UFFD-marked swap entry, also restore
PAGE_NONE so the first subsequent access still generates a userfault.

If the PMD-order folio cannot be allocated or read, the swap cache
already contains per-page folios in the covered range (e.g. split in
the swap cache by deferred_split_scan() or memory_failure() while the
PMD swap entry was installed), or any subpage is hardware-poisoned,
the PMD swap entry is split into PTE-level entries via
__split_huge_pmd() and a non-zero error is returned so unuse_pmd_range()
falls through to unuse_pte_range(), which handles the individual
entries at order-0.

Remove a failed !uptodate PMD-sized folio from swap cache before
splitting so PTE fallback rereads each slot independently. Keep
hwpoisoned folios cached so PTE fallback can isolate bad subpages.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/swap.h       |  17 +++++
 mm/swap_state.c |  44 +++++++++++++
 mm/swapfile.c   | 169 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 230 insertions(+)

diff --git a/mm/swap.h b/mm/swap.h
index e225527b2eb7a..441e017afc67b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -311,6 +311,23 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
+enum swap_pmd_cache {
+	SWAP_PMD_CACHE_EMPTY,
+	SWAP_PMD_CACHE_HUGE,
+	SWAP_PMD_CACHE_SPLIT,
+};
+
+#ifdef CONFIG_THP_SWAP
+enum swap_pmd_cache swap_pmd_cache_lookup(swp_entry_t entry,
+					  struct folio **foliop);
+#else
+static inline enum swap_pmd_cache swap_pmd_cache_lookup(swp_entry_t entry,
+							struct folio **foliop)
+{
+	*foliop = NULL;
+	return SWAP_PMD_CACHE_EMPTY;
+}
+#endif
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 				     unsigned long orders, struct vm_fault *vmf,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 15e200d6966b9..559dc00b28f95 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -125,6 +125,50 @@ bool swap_cache_has_folio(swp_entry_t entry)
 	return swp_tb_is_folio(swp_tb);
 }
 
+#ifdef CONFIG_THP_SWAP
+/**
+ * swap_pmd_cache_lookup - classify the swap cache behind a PMD swap entry
+ * @entry: first swap slot encoded by the PMD swap entry
+ * @foliop: returned PMD-sized folio, with a reference, if present
+ *
+ * A PMD swap entry is a compact page-table encoding for HPAGE_PMD_NR
+ * consecutive swap slots. The swap cache behind those slots can be empty,
+ * one PMD-sized folio, or per-slot folios after the original folio was split.
+ *
+ * Context: Caller must keep @entry valid using the usual swap cache rules.
+ * Return: SWAP_PMD_CACHE_EMPTY if no slot in the PMD range has a cached folio,
+ * SWAP_PMD_CACHE_HUGE if one PMD-sized folio covers the range, or
+ * SWAP_PMD_CACHE_SPLIT if the range needs per-page handling.
+ */
+enum swap_pmd_cache swap_pmd_cache_lookup(swp_entry_t entry,
+					  struct folio **foliop)
+{
+	unsigned int type = swp_type(entry);
+	pgoff_t offset = swp_offset(entry);
+	struct folio *folio;
+	int i;
+
+	*foliop = NULL;
+
+	folio = swap_cache_get_folio(entry);
+	if (folio) {
+		if (folio_nr_pages(folio) == HPAGE_PMD_NR) {
+			*foliop = folio;
+			return SWAP_PMD_CACHE_HUGE;
+		}
+		folio_put(folio);
+		return SWAP_PMD_CACHE_SPLIT;
+	}
+
+	for (i = 1; i < HPAGE_PMD_NR; i++) {
+		if (swap_cache_has_folio(swp_entry(type, offset + i)))
+			return SWAP_PMD_CACHE_SPLIT;
+	}
+
+	return SWAP_PMD_CACHE_EMPTY;
+}
+#endif
+
 /**
  * swap_cache_get_shadow - Looks up a shadow in the swap cache.
  * @entry: swap entry used for the lookup.
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 44b9ebbe7229f..67a7e2053dc12 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,6 +42,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/huge_mm.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -2670,6 +2671,160 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 	return 0;
 }
 
+#ifdef CONFIG_THP_SWAP
+/*
+ * unuse_pmd - Map a locked folio at PMD granularity during swapoff.
+ *
+ * The caller provides a locked, swapped-in folio.  Returns 0 on success
+ * (PMD was mapped).  Returns -EAGAIN if the swap cache folio no longer
+ * matches the entry or the PMD changed under the lock (try_to_unuse will
+ * rescan). Returns -EIO if the folio is not uptodate or contains a poisoned
+ * subpage; in that case the PMD is split so unuse_pte_range() can handle
+ * individual pages.
+ */
+static int unuse_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+		     unsigned long addr, softleaf_t entry,
+		     struct folio *folio)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct page *page;
+	pmd_t new_pmd, old_pmd;
+	spinlock_t *ptl;
+	rmap_t rmap_flags = RMAP_NONE;
+	bool exclusive;
+
+	if (unlikely(!folio_matches_swap_entry(folio, entry)))
+		return -EAGAIN;
+
+	if (unlikely(!folio_test_uptodate(folio))) {
+		/* Let PTE fallback reread each slot independently. */
+		swap_cache_del_folio(folio);
+		__split_huge_pmd(vma, pmd, addr, false);
+		return -EIO;
+	}
+
+	if (unlikely(folio_contain_hwpoisoned_page(folio))) {
+		/* Let PTE fallback isolate the poisoned subpages. */
+		__split_huge_pmd(vma, pmd, addr, false);
+		return -EIO;
+	}
+
+	page = folio_page(folio, 0);
+
+	ptl = pmd_lock(mm, pmd);
+	old_pmd = pmdp_get(pmd);
+
+	if (!pmd_is_swap_entry(old_pmd) ||
+	    softleaf_from_pmd(old_pmd).val != entry.val) {
+		spin_unlock(ptl);
+		return -EAGAIN;
+	}
+
+	exclusive = pmd_swp_exclusive(old_pmd);
+
+	/*
+	 * Some architectures may have to restore extra metadata to the folio
+	 * when reading from swap. This metadata may be indexed by swap entry
+	 * so this must be called before folio_put_swap().
+	 */
+	arch_swap_restore(folio_swap(entry, folio), folio);
+
+	add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
+
+	new_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
+	new_pmd = pmd_mkold(new_pmd);
+	if (pmd_swp_soft_dirty(old_pmd))
+		new_pmd = pmd_mksoft_dirty(new_pmd);
+	if (pmd_swp_uffd(old_pmd))
+		new_pmd = pmd_mkuffd(new_pmd);
+	if (pmd_swp_uffd(old_pmd) && userfaultfd_rwp(vma))
+		new_pmd = pmd_modify(new_pmd, PAGE_NONE);
+
+	if (exclusive)
+		rmap_flags |= RMAP_EXCLUSIVE;
+
+	folio_get(folio);
+	if (!folio_test_anon(folio))
+		folio_add_new_anon_rmap(folio, vma, addr, rmap_flags);
+	else
+		folio_add_anon_rmap_pmd(folio, page, vma, addr, rmap_flags);
+
+	set_pmd_at(mm, addr, pmd, new_pmd);
+	folio_put_swap(folio, NULL);
+
+	spin_unlock(ptl);
+
+	folio_free_swap(folio);
+	return 0;
+}
+
+/*
+ * Try to swap in a PMD swap entry as a whole THP. Returns 0 on success.
+ * If the swap cache no longer has one PMD-sized folio, zswap may require
+ * per-page loading, or a PMD-order allocation/read fails, split the PMD so
+ * the caller can fall back to unuse_pte_range(). Otherwise propagates the
+ * error from unuse_pmd().
+ */
+static int unuse_pmd_entry(struct vm_area_struct *vma, pmd_t *pmd,
+			   unsigned long addr, softleaf_t entry)
+{
+	struct folio *folio;
+	enum swap_pmd_cache cache_state;
+	int ret;
+
+	cache_state = swap_pmd_cache_lookup(entry, &folio);
+	if (cache_state == SWAP_PMD_CACHE_SPLIT) {
+		ret = -EAGAIN;
+		goto split_fallback;
+	}
+	if (!folio) {
+		struct vm_fault vmf = {
+			.vma = vma,
+			.address = addr,
+			.real_address = addr,
+			.pmd = pmd,
+		};
+
+		if (zswap_is_present(entry, HPAGE_PMD_NR)) {
+			ret = -EAGAIN;
+			goto split_fallback;
+		}
+
+		folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
+				    BIT(HPAGE_PMD_ORDER), &vmf, NULL, 0);
+		if (IS_ERR_OR_NULL(folio)) {
+			ret = folio ? PTR_ERR(folio) : -ENOMEM;
+			goto split_fallback;
+		}
+	}
+
+	folio_lock(folio);
+	folio_wait_writeback(folio);
+	/*
+	 * If the cached folio is no longer PMD-sized (e.g. split in the
+	 * swap cache by deferred_split_scan() or memory_failure() while
+	 * the PMD swap entry was installed), the PMD swap entry no longer
+	 * maps a single contiguous folio.  Split the PMD swap entry so
+	 * unuse_pte_range() can swap the per-slot folios in individually.
+	 */
+	if (folio_nr_pages(folio) != HPAGE_PMD_NR) {
+		folio_unlock(folio);
+		folio_put(folio);
+		ret = -EAGAIN;
+		goto split_fallback;
+	}
+	ret = unuse_pmd(vma, pmd, addr, entry, folio);
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+
+split_fallback:
+	__split_huge_pmd(vma, pmd, addr, false);
+	return ret;
+}
+#endif
+
 static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 				unsigned long addr, unsigned long end,
 				unsigned int type)
@@ -2682,6 +2837,20 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 	do {
 		cond_resched();
 		next = pmd_addr_end(addr, end);
+
+#ifdef CONFIG_THP_SWAP
+		pmd_t pmdval = pmdp_get(pmd);
+
+		if (pmd_is_swap_entry(pmdval)) {
+			softleaf_t sl = softleaf_from_pmd(pmdval);
+
+			if (swp_type(sl) == type) {
+				if (!unuse_pmd_entry(vma, pmd, addr, sl))
+					continue;
+			}
+		}
+#endif
+
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
 			return ret;
-- 
2.53.0-Meta


