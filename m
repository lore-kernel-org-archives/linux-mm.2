Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C6F606A336
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tjR2XPLO
Received: by kanga.kvack.org (Postfix)
	id 7A7F06B05CE; Thu,  5 Nov 2026 13:41:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7582A6B05CF; Thu,  5 Nov 2026 13:41:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E5B6B05D0; Thu,  5 Nov 2026 13:41:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39A936B05CE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE4091A0C3C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:36 +0000 (UTC)
X-FDA: 85401933792.21.9C5AF00
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3005620008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tjR2XPLO;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qkSn5vEAHOMi4HEwjEOPW6fOkRTHM8LC6HdKX5XaNQ=;
	b=BuP1Y0yBS3TPSq253X5S986ONrjV2jGP2PCCP52mDzku3jnepwBnYVSJy0QERwovoHVzdC
	RyHzljOFyJ5JFzFqwu0BUo4RHMaaSp5LvT2WZKrgtSb7L/tnaz+wjvHGd0WGsRhTY+WK1h
	+MGV+OHvmc8aLTER4VMqnMk/uELxKW4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904095;
	b=oWsoiwQpTGQSZys9FofRr0JYc45m12jVa9TS+UuMKx7yVLvnRaD1AMEXVjuKN65sIDH6Os
	l8WVfp3DIAUDJ3lLFeSew4kfCHVj2dVERNpBeGU2E/DvT4aEFpEQ5IqhhSNL7gfqqBapS9
	zk/Upu1uVDjDdrVpOcb4LaRFnRBQz/g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tjR2XPLO;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3WlCqjX5I0DI62cy+ntKZLGWmH4JV5TyJqySjCacMLo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904093; v=1; x=1794508893;
 b=tjR2XPLOSh0Ku+ecCpKCoT0rSZcz6EmxKGtSnmSxRJO1tYAEEGCBRcPHEWfLI61wDh6VCHhH
 HspWrzvCYyTv4WkZiS/+KVs3zRXZpoFQU8Cpm23k88OCOL8tS7v1iaEQLX1bliYajBNxJPr/oE5
 KLESsYm3VQQHekjqMeRespxc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 346a432d1e363846;
	Thu, 05 Nov 2026 18:41:33 +0000
X-Mizu-Trace-ID: 346a432d1e363846
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
Subject: [PATCH v9 17/32] mm: swap in PMD swap entries as whole THPs during swapoff
Date: Thu,  5 Nov 2026 10:39:01 -0800
Message-ID: <20261105183940.2236717-18-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 7gaykpd4g45dq5k6bo1a6w4j76ars4pi
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3005620008
X-Rspam-User: 
X-HE-Tag: 1793904095-977786
X-HE-Meta: U2FsdGVkX19YFykaSzRMhunx8QoqoxrcRChOloMNiepf+igP+C/GN8hogurN3Jd2KwpxYHXq8OrflXeWxswbqzCroaRIraOMU4ULgTnHK1Noto86mi3lDsX3TrCtkoYoF9hncNsZLTt2FitIMdJZx5hZFgHNgFv6Y39+C/dsHfI6N8BB/nopiRYClgxMHb7Y3oNQGkgY7b07bMWTg0LjV4kls7I+pmf1287Ji/AsJPrN0x1MHdm3YYdKZC5jRF6JYqR4vqdD+/et2srHqLPFIUdX8x8Gc3ty2+gofgtHKAZTJps9gomWuanZLzspD/as64mzXpic+UeuaC8lRG5vqXmTGiL1HiEYwRyZyBzIs4SfYC/ouWqxUBdJZfA94vxweyM5NHg+r4s05OOz0Br17h4u1Eio2oN9i6NltQ0J/UTHZgLysP9grCMb44zIzbleuDJYdknU1PGrX9KVx7C2Trrg+5OEGsM66rWtlABTv3loR610o2jNwpWRehcIL6wZOhQGEaZ3G3uZKko5fd25NHrar1WJF9fwjCw8XDMe/dQ5lL1My7ovWtYnSdNGIHGkgmE+fs2PwQ59lrXb3vRZogELcSEPZIpqBgmjkEqAx9i/k5LJfRVP4urqroban7npV6hB+pFyC/7U7qlg7i0BwbQ7pCC9CyYy/IVsuzK/rZj4Kpxbbyn5blHCGK/njY3KFFAoTT8Zd0tV4zKaamuA8WBX+6Z/722Yf1UajvrUNbWqfEounx/whVpu7LgCAKkoFS+Ze2pYU3txIKi5gdOmCRUvsLIGQgtWXW+NDH8yIQK/xg1PKm01s5HWlZLuzp72mIcQZn0wUr8lGkYDKflDdd363KD93dqIoapbBFvny7WcylkRRELrLnA5fHHjarTv/zgrufEE2anCQk6sjwuQpj1zOxZcQ1ONZCnuHo/r4YsVOg7lu1e6N+DgOmjR0NKzd5KNS8/KU+QmzPCb0gf
 Hqy+lKhr
 nX+/opIxsuRypbO49fcp2Dd+E8ns1/bhxNxrAl2ejWOQbc4qWY4QgVBugNT3JnZLFw66KxRMLQJy6lQlGo3JE9HNt9/RKctf9fPXmVwOkExMg24hJ/Z24co46uCSQujjNeED3krapyg7ocdRzRyAunW1tOZKzwxPGRzQ7auIuR6QHZWFFg5kKWRH7aiD5g1GMITze2nDKe7oYyMWeIrR4QP761WKDZQLyUJSO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

swapoff walks every mm and faults every slot of the device back in.
unuse_pte_range() only understands PTEs, so a PMD swap entry would never be
found and swapoff would never complete.

A PMD swap entry is a compact encoding for HPAGE_PMD_NR slots, not a
promise that the swap cache holds one folio for them. Add
swap_pmd_cache_lookup() to classify the covered range as empty, one
PMD-sized folio, or already split, and unuse_pmd() to map the first two
cases back in as one THP, preserving soft-dirty, exclusive and UFFD state.

Everything else falls back to PTEs: a split cache, per-page zswap state, a
failed PMD-order allocation or read, or a poisoned subpage. Check
PageHWPoison on every subpage rather than the folio-level flag, which
memory_failure() only sets after taking the folio lock.

All the fallback reasons are observed without the PMD lock and possibly
after sleeping, so they share one exit that re-checks the PMD is still the
entry we were called for before splitting it. That exit also drops a folio
that is not uptodate, or that has never been mapped, from the swap cache:
the PTE path cannot re-read the first, and would add a single-page rmap to
the second.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/internal.h   |  19 +++++
 mm/swap.h       |  17 +++++
 mm/swap_state.c |  44 +++++++++++
 mm/swapfile.c   | 189 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 269 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index 78a7f17b9934f..8a5bbfebe6270 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -28,6 +28,25 @@ struct folio_batch;
 int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags);
 
+/*
+ * Check every page in the folio for HWPoison and return true if any is
+ * poisoned.
+ *
+ * Unlike folio_contain_hwpoisoned_page(), this does not rely on the folio-level
+ * PG_has_hwpoisoned, which memory_failure() only sets after taking the folio
+ * lock and so can lag a tail-page poison.
+ */
+static inline bool folio_has_any_hwpoisoned_page(const struct folio *folio)
+{
+	long nr = folio_nr_pages(folio);
+	long i;
+
+	for (i = 0; i < nr; i++)
+		if (PageHWPoison(folio_page(folio, i)))
+			return true;
+	return false;
+}
+
 /* mm/workingset.c */
 bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 			    bool flush);
diff --git a/mm/swap.h b/mm/swap.h
index f028bd10c2cea..cdf18cfadc53b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -317,6 +317,23 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
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
 struct folio *__swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 				       unsigned long orders, struct vm_fault *vmf,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f41e740a91b87..89c7812ac03fa 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -135,6 +135,50 @@ bool swap_cache_has_folio(swp_entry_t entry)
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
index 6b5149b88fa43..7e91dc50a5131 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,6 +42,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/huge_mm.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -2695,6 +2696,182 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
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
+	/* Let PTE fallback reread each slot, or isolate the poisoned ones. */
+	if (unlikely(!folio_test_uptodate(folio)))
+		return -EIO;
+	if (unlikely(folio_has_any_hwpoisoned_page(folio)))
+		return -EIO;
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
+	enum swap_pmd_cache cache_state;
+	struct folio *folio;
+	pmd_t pmdval;
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
+	/*
+	 * PTE fallback cannot add a single-page rmap to a newly allocated,
+	 * PMD-sized !anon folio, and it cannot do anything useful with a folio
+	 * that failed to read. Remove either from the swap cache so each slot
+	 * is read back into an order-0 folio. An uptodate anon swap-cache folio
+	 * can be mapped one PTE at a time and must stay cached so poisoned
+	 * subpages remain visible.
+	 */
+	if (ret && folio_matches_swap_entry(folio, entry) &&
+	    (!folio_test_uptodate(folio) || !folio_test_anon(folio)))
+		swap_cache_del_folio(folio);
+	folio_unlock(folio);
+	folio_put(folio);
+	if (ret == -EIO)
+		goto split_fallback;
+	return ret;
+
+split_fallback:
+	/*
+	 * Every reason we get here was observed without the PMD lock and
+	 * possibly after sleeping, so re-check that the PMD is still the entry
+	 * we were called for. A racing fault may already have swapped the range
+	 * back in as a THP, and splitting that would demote it for nothing.
+	 */
+	pmdval = pmdp_get(pmd);
+	if (pmd_is_swap_entry(pmdval) &&
+	    softleaf_from_pmd(pmdval).val == entry.val)
+		__split_huge_pmd(vma, pmd, addr);
+	return ret;
+}
+#else	/* !CONFIG_THP_SWAP */
+static inline int unuse_pmd_entry(struct vm_area_struct *vma, pmd_t *pmd,
+				  unsigned long addr, softleaf_t entry)
+{
+	return -EAGAIN;
+}
+#endif	/* CONFIG_THP_SWAP */
+
 static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 				unsigned long addr, unsigned long end,
 				unsigned int type)
@@ -2705,10 +2882,22 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 
 	pmd = pmd_offset(pud, addr);
 	do {
+		pmd_t pmdval;
+
 		cond_resched();
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 		next = pmd_addr_end(addr, end);
+
+		pmdval = pmdp_get(pmd);
+		if (IS_ENABLED(CONFIG_THP_SWAP) && pmd_is_swap_entry(pmdval)) {
+			softleaf_t entry = softleaf_from_pmd(pmdval);
+
+			if (swp_type(entry) == type &&
+			    !unuse_pmd_entry(vma, pmd, addr, entry))
+				continue;
+		}
+
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
 			return ret;
-- 
2.53.0-Meta


