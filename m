Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FABC61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C006B009E; Tue, 25 Aug 2026 13:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1B8F6B009F; Tue, 25 Aug 2026 13:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4D26B00A0; Tue, 25 Aug 2026 13:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 720906B009E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:29:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCCEE80115
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:29:36 +0000 (UTC)
X-FDA: 85140478752.12.50D6B24
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id D0DB1180003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:29:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787678975;
	b=R/W+gnStqPeCIEs+zpFXdN767CF9zpI4VHzHFVvqHxFVOsBpgXuoTmS9OQ+OHYtsmQRS8u
	sMVFCJkZLVgIx7aJTOXnYUXPlDDI+/aaP8sq7bHhc8DaOVm0ndeWycPzoOMRzyQz9vNU5P
	1G0j6/Ho4Gsy9yqLAqkZNVks60eJZKU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787678975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1RzqQ2WfeMv6KdsKXW9mhN4BOs5BnDYZ8s2HVTBrwvY=;
	b=wxOn1HcWAD2wgaZyUfQEVfGmhO5nN0RfQJezv3TpyY/Ok42Z0oGXyxrr0rGEB4n0vf9F25
	AnoD80jdMJeBAJ+PFIG94k6Akamj2RMCMj/quqN3ULF1Br8dj8Zt642TZhdXdY+eH0l+Oq
	ReZIOVrilGrWkXbpKKZ5+1U1Z8W521s=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1C8491F481;
	Tue, 25 Aug 2026 17:29:25 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v3 3/3] mm/zswap: preserve the workingset shadow across writeback
Date: Tue, 25 Aug 2026 19:24:53 +0200
Message-ID: <20260825172604.3243589-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825172604.3243589-1-alex@ghiti.fr>
References: <20260825172604.3243589-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTGDXuWbT66yr5MCMbgtYehx5y1CScnCd9e707Clw0nqT72RrXkYkE4A9e5w8tPS/YKbS0tB2AadKPxGrSK+qgD7OZksPvjTZgfACMn20CCwPgqC1SxZufZJmJiJu026JZPAx8fJRD+b84ZQAl/yxEdS5BjtTUGmHeQIxBBzcDFPMtbCjjQ+hacmMretZU20R9yfU+5ci3+YdxxIJwghtq25J5lqPQRJjBHFhPeEsHnnn0R0VZX5jCFh7Dg7lwtnw/2ICPEbP2HE/7m19vtmkMJsAgVWzCB/6s+QE6By70+lWl0Rr1ovrTBVlrV0xcuE9ARBW+32YVsmAshvu8IzsKIXsrKKEctf3FXap+hZNe7vfgvtj6qFZdjAHm73Q6CLn+kV5pje/07a2HBv9HMA7xda1lyP6ZrgJX6FZV3paKjlq2IgsUmj8NETAtMiwCc+3msaVaXsh3pfhMYl5oyZFw6+4epNxcnqZgE5OXgMNlR6/Dfb29TTdASd1GkN0wHp79HJO11ps3InwLCZVOjo0RWEPOyuRqTBNgC45jnZi/nBbIl+9vx6u0WHn9C+6GAijHUBQHminXkzT69VdNx1aDC/S++FIGv7ulJqOAECRiftVxxqlW4Ggg6qHR2e6hB+PtihDfsPiRm05Cd36i3YHQNekAJsHNWzuDNQCywt+ywPaQ
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0DB1180003
X-Stat-Signature: ydj19qq8rqjdb45ffadoucrdr1hxmytq
X-HE-Tag: 1787678974-850502
X-HE-Meta: U2FsdGVkX19Om8bMdr6qRc2znfZzfdgVmfWQTr9d4L99ZHx3G46jp1TDy+LwV1yqRjulJqgqVeBhy5aIzQLcxPPLuaHu/xEvDNyjTTSRa5PjjT7mScXbT0WvgKgjpKJklun5+2kg9jIztK8XUDxaaT7Z8khnfR0cbVkUpMjzR7PwNsIL82C2f2Q8R8yPOAvF3pPmk9y/Z3LExqDwx+CPXnQKJfaH1KG6p1SYxwrCfGVKz5SJ1mXP5YGfV0foOLPnSP8DGupLBcLdCTSt3wmbzo3y/cnKTradqsw6MVDRpA9RWsjOiiJ8UPE66PE0p3v59f6aHC98fGxKb8eCjCNGCHrlw5nO/parcib3YjHxJtzkGd9lc+IQYGTnCPdvW7UqGTldXJCGRkov2F75EtMOjrINR4oEDtb4f9NszxK1R+UZO8iSp3INN2tHV+EPuvCixpAndZ1wB/3wyRMMJxYBbEu+48cXiUsSTW3uqlJMuxiUe7eSZZDXWPS3F3m1MOdvwbjUMptUgpsX3fmLUUptzqVpyAjE6GPyjxhYIC3iPuRHKVD/y2ycmhGtW2EeiJvSGB8MCJwZG+mVIkyd1pxhnHlk8Rj9WpStGWQMDdcMLvAY78HJ0f8OJCtxysspg4SshYtj+dG8rCNrvQ3jwO2lwaECg8ZOeYLCrLRht2gdPk8pEo2yelEyX9UHBaMARjEsTxE/riN09/VHGheaILZOm+UD1xaeKogZGnbJG1ahmhUj3rtxQYKlycOQfabEH2Y79G/X94RZ1ogBTreTMMkeAwwETtUWrL8l8MEYPQudo2WpW1PhugdFR2HXMIgcpLOHWqF0W014uwto9i4JHtTR+Rkbdv6c7D2+/Pl2DChPxY6rqdLxAhRHRCDiX+6OTTrDOlxjnadFSWmHO0Y7oRn60PR99uPKQvUngU5VCdg6a8hUHT5hlPNqqzxsw3V9wRMyNMxFvYj4r6Ah03DsqZ9
 dC+vepZh
 Bw+DiiW+Zr6kQ9hhfsb4q/8bmDSfJYBecR1/Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When zswap writes an entry back, allocating the buffer folio in the swap
cache overwrites the swap slot's workingset shadow. It is lost and later
re-minted inaccurately, which corrupts anon refault/workingset accounting
for the written-back data.

Preserve it within zswap itself: at writeback, park the shadow in the
zswap tree in place of the freed entry, so it outlives the writeback
buffer folio. The buffer then meets one of three fates, and the parked
shadow is handled at whichever happens first:

 - swap-in: do_swap_page()/shmem_swapin_folio() find the buffer in the swap
   cache, take the shadow and feed it to workingset_refault() to account
   the refault of the now-resident folio, then drop it.
 - reclaim: __remove_mapping() skips minting a fresh shadow for the buffer
   (minting would double-count the eviction) and
   __swap_cache_do_del_folio() restores the parked shadow into the slot, so
   a later disk swap-in still refaults against the original eviction.
 - slot free (e.g. process exit): the shadow is not needed and is cleared.

The last two both go through __swap_cache_do_del_folio(), the single point
every swap-cache removal passes through, which is why the shadow is read
and cleared there.

Fixes: aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/zswap.h |  12 +++++
 mm/internal.h         |   1 +
 mm/memory.c           |   5 ++
 mm/shmem.c            |   5 ++
 mm/swap_state.c       |  10 ++++
 mm/vmscan.c           |   4 +-
 mm/workingset.c       |  60 +++++++++++++++++++-----
 mm/zswap.c            | 105 +++++++++++++++++++++++++++++++++++++++++-
 8 files changed, 188 insertions(+), 14 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..dfb7153236f5 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,8 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+bool zswap_folio_is_writeback_buffer(struct folio *folio);
+void *zswap_lookup_and_clear_shadows(struct folio *folio);
 #else
 
 struct zswap_lruvec_state {};
@@ -69,6 +71,16 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline bool zswap_folio_is_writeback_buffer(struct folio *folio)
+{
+	return false;
+}
+
+static inline void *zswap_lookup_and_clear_shadows(struct folio *folio)
+{
+	return NULL;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..c191887c1fed 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -38,6 +38,7 @@ void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
 void *workingset_eviction(struct folio *folio,
 			  struct mem_cgroup *target_memcg);
 void workingset_refault(struct folio *folio, void *shadow);
+void workingset_refault_lru_managed(struct folio *folio, void *shadow);
 void workingset_activation(struct folio *folio);
 
 /* mm/folio.c */
diff --git a/mm/memory.c b/mm/memory.c
index c6a9242d1b5b..771197b3fcc5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4894,6 +4894,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	unsigned long page_idx;
 	unsigned long address;
 	pte_t *ptep;
+	void *shadow;
 
 	if (!pte_unmap_same(vmf))
 		goto out;
@@ -5018,6 +5019,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out_page;
 	}
 
+	shadow = zswap_lookup_and_clear_shadows(folio);
+	if (shadow)
+		workingset_refault_lru_managed(folio, shadow);
+
 	/*
 	 * KSM sometimes has to copy on read faults, for example, if
 	 * folio->index of non-ksm folios would be nonlinear inside the
diff --git a/mm/shmem.c b/mm/shmem.c
index 599665a3d6e7..1ef6cc76605e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2266,6 +2266,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	struct folio *folio = NULL;
 	int error, nr_pages, order;
 	pgoff_t offset;
+	void *shadow;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
 	index_entry = radix_to_swp_entry(*foliop);
@@ -2377,6 +2378,10 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	 */
 	arch_swap_restore(folio_swap(swap, folio), folio);
 
+	shadow = zswap_lookup_and_clear_shadows(folio);
+	if (shadow)
+		workingset_refault_lru_managed(folio, shadow);
+
 	if (shmem_should_replace_folio(folio, gfp)) {
 		error = shmem_replace_folio(&folio, gfp, info, index, vma);
 		if (error)
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 8046fea015c9..df9e0452f19b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -24,6 +24,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/sysctl.h>
 #include <linux/swap_ops.h>
+#include <linux/zswap.h>
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
@@ -263,12 +264,21 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 	unsigned int ci_start, ci_off, ci_end;
 	bool folio_swapped = false, need_free = false;
 	unsigned long nr_pages = folio_nr_pages(folio);
+	void *shadow_parked;
 
 	VM_WARN_ON_ONCE(__swap_entry_to_cluster(entry) != ci);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
 
+	/*
+	 * A zswap writeback buffer parked the slot's original shadow in the
+	 * zswap tree: restore it into the slot for later swap-in.
+	 */
+	shadow_parked = zswap_lookup_and_clear_shadows(folio);
+	if (shadow_parked)
+		shadow = shadow_parked;
+
 	si = __swap_entry_to_info(entry);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 73a81b4a3e16..9905753b7a10 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -48,6 +48,7 @@
 #include <linux/prefetch.h>
 #include <linux/printk.h>
 #include <linux/dax.h>
+#include <linux/zswap.h>
 #include <linux/psi.h>
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
@@ -733,7 +734,8 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 	if (folio_test_swapcache(folio)) {
 		swp_entry_t swap = folio->swap;
 
-		if (reclaimed && !mapping_exiting(mapping))
+		if (reclaimed && !mapping_exiting(mapping) &&
+		    !zswap_folio_is_writeback_buffer(folio))
 			shadow = workingset_eviction(folio, target_memcg);
 		__memcg1_swapout(folio, ci);
 		__swap_cache_del_folio(ci, folio, swap, shadow);
diff --git a/mm/workingset.c b/mm/workingset.c
index 7ac2b88c80ae..e203d631f61b 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -536,16 +536,8 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	return refault_distance <= workingset_size;
 }
 
-/**
- * workingset_refault - Evaluate the refault of a previously evicted folio.
- * @folio: The freshly allocated replacement folio.
- * @shadow: Shadow entry of the evicted folio.
- *
- * Calculates and evaluates the refault distance of the previously
- * evicted folio in the context of the node and the memcg whose memory
- * pressure caused the eviction.
- */
-void workingset_refault(struct folio *folio, void *shadow)
+static void __workingset_refault(struct folio *folio, void *shadow,
+				 bool lru_managed)
 {
 	bool file = folio_is_file_lru(folio);
 	struct mem_cgroup *memcg;
@@ -577,7 +569,16 @@ void workingset_refault(struct folio *folio, void *shadow)
 	if (!workingset_test_recent(shadow, file, &workingset, true))
 		goto out;
 
-	folio_set_active(folio);
+	/*
+	 * An LRU-managed folio may sit in a per-CPU batch, which cannot be
+	 * determined here: setting the flag would race the drain and leave it
+	 * disagreeing with the list. folio_activate() is safe, but misses the
+	 * activation for such a folio.
+	 */
+	if (lru_managed)
+		folio_activate(folio);
+	else
+		folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
 	mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + file, nr);
 
@@ -590,6 +591,43 @@ void workingset_refault(struct folio *folio, void *shadow)
 	mem_cgroup_put(memcg);
 }
 
+/**
+ * workingset_refault - Evaluate the refault of a previously evicted folio.
+ * @folio: The freshly allocated replacement folio.
+ * @shadow: Shadow entry of the evicted folio.
+ *
+ * Calculates and evaluates the refault distance of the previously
+ * evicted folio in the context of the node and the memcg whose memory
+ * pressure caused the eviction.
+ *
+ * Context: @folio must be locked and not on the LRU yet, the caller adds
+ * it with folio_add_lru() afterwards.
+ */
+void workingset_refault(struct folio *folio, void *shadow)
+{
+	__workingset_refault(folio, shadow, false);
+}
+
+/**
+ * workingset_refault_lru_managed - Evaluate the refault of a previously
+ * evicted folio that is already on the LRU.
+ * @folio: The folio the eviction is refaulted into.
+ * @shadow: Shadow entry of the evicted folio.
+ *
+ * Like workingset_refault(), but for a folio the caller has already added
+ * to the LRU, which has to be activated by moving it between the lists
+ * rather than by setting PG_active.
+ *
+ * The activation is best effort: a folio still sitting in a per-CPU LRU
+ * batch cannot be moved yet and is left inactive.
+ *
+ * Context: @folio must be locked and already added to the LRU.
+ */
+void workingset_refault_lru_managed(struct folio *folio, void *shadow)
+{
+	__workingset_refault(folio, shadow, true);
+}
+
 /**
  * workingset_activation - note a page activation
  * @folio: Folio that is being activated.
diff --git a/mm/zswap.c b/mm/zswap.c
index 0d2efe21f18a..c1a78edfa0b8 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -972,6 +972,79 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 /*********************************
 * writeback code
 **********************************/
+
+#define ZSWAP_WRITEBACK_NO_SHADOW xa_mk_value(0)
+
+/**
+ * zswap_folio_is_writeback_buffer - is @folio a zswap writeback buffer?
+ * @folio: the folio being examined (typically a swap cache folio under reclaim)
+ *
+ * A folio is a zswap writeback buffer when every one of its swap offsets holds
+ * a parked writeback shadow (a real shadow or the ZSWAP_WRITEBACK_NO_SHADOW
+ * sentinel) in the zswap tree rather than a live zswap entry.
+ *
+ * Return: true if @folio is a writeback buffer, in which case the reclaim path
+ * must not mint a fresh workingset shadow for it.
+ */
+bool zswap_folio_is_writeback_buffer(struct folio *folio)
+{
+	swp_entry_t swp = folio->swap;
+	unsigned long nr_pages = folio_nr_pages(folio);
+	pgoff_t offset = swp_offset(swp);
+	unsigned long i;
+
+	if (zswap_never_enabled())
+		return false;
+
+	for (i = 0; i < nr_pages; i++) {
+		swp_entry_t e = swp_entry(swp_type(swp), offset + i);
+
+		if (!xa_is_value(xa_load(swap_zswap_tree(e), offset + i)))
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * zswap_lookup_and_clear_shadows - retrieve and clear @folio's parked shadow(s)
+ * @folio: the writeback buffer folio (or the swapin folio that consumed it)
+ *
+ * Remove any parked writeback shadows for @folio's swap offset(s) from the
+ * zswap tree.
+ *
+ * Return: the preserved workingset shadow, or NULL if the slot(s) had no shadow
+ * (sentinel only) or nothing parked. The caller either restores the returned
+ * shadow into the swap slot (buffer dropped) or feeds it to
+ * workingset_refault_lru_managed() (buffer consumed by a swapin); clearing
+ * here ensures the two paths never double-count.
+ */
+void *zswap_lookup_and_clear_shadows(struct folio *folio)
+{
+	swp_entry_t swp = folio->swap;
+	unsigned long nr_pages = folio_nr_pages(folio);
+	pgoff_t offset = swp_offset(swp);
+	void *shadow = NULL;
+	unsigned long i;
+
+	if (zswap_never_enabled())
+		return NULL;
+
+	for (i = 0; i < nr_pages; i++) {
+		swp_entry_t e = swp_entry(swp_type(swp), offset + i);
+		struct xarray *tree = swap_zswap_tree(e);
+		void *parked = xa_load(tree, offset + i);
+
+		if (!xa_is_value(parked))
+			continue;
+		xa_erase(tree, offset + i);
+		if (parked != ZSWAP_WRITEBACK_NO_SHADOW)
+			shadow = parked;
+	}
+
+	return shadow;
+}
+
 /*
  * Attempts to free an entry by adding a folio to the swap cache,
  * decompressing the entry data into the folio, and issuing a
@@ -987,12 +1060,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
+	struct swap_cluster_info *ci;
 	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
 	struct swap_io_ctx ctx = {};
+	void *shadow;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1000,6 +1075,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -EEXIST;
 
+	shadow = swap_cache_get_shadow(swpentry);
+
 	mpol = get_task_policy(current);
 	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 					 NO_INTERLEAVE_INDEX);
@@ -1036,7 +1113,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		goto out;
 	}
 
-	xa_erase(tree, offset);
+	/*
+	 * A slot with no shadow already reads back as ZSWAP_WRITEBACK_NO_SHADOW:
+	 * the swap table marks a swapped out slot with xa_mk_value(0) and holds
+	 * the shadow, when there is one, in that same value.
+	 */
+	xa_store(tree, offset, shadow, GFP_KERNEL);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
@@ -1056,7 +1138,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 out:
 	if (ret) {
-		swap_cache_del_folio(folio);
+		/*
+		 * The allocation above overwrote the slot's shadow and nothing
+		 * has been parked for it yet, so restore it as the folio leaves
+		 * the swap cache, or the eviction it records is lost.
+		 */
+		ci = swap_cluster_lock(__swap_entry_to_info(swpentry), offset);
+		__swap_cache_del_folio(ci, folio, swpentry, shadow);
+		swap_cluster_unlock(ci);
+		folio_ref_sub(folio, folio_nr_pages(folio));
 		folio_unlock(folio);
 	}
 	folio_put(folio);
@@ -1499,6 +1589,17 @@ bool zswap_store(struct folio *folio)
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
 
+	/*
+	 * A writeback buffer whose IO failed is redirtied and left in the
+	 * swap cache, so reclaim writes it out again. Writeback already
+	 * decided this data belongs on disk, so send it there instead of
+	 * compressing it back into zswap. This also leaves the shadow
+	 * parked for the buffer in place, so it is still restored into
+	 * the slot once the folio leaves the swap cache.
+	 */
+	if (zswap_folio_is_writeback_buffer(folio))
+		return false;
+
 	if (!zswap_enabled)
 		goto check_old;
 
-- 
2.53.0-Meta


