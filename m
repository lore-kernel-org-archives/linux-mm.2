Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60252C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3176B008A; Fri, 11 Sep 2026 05:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9EB6B009E; Fri, 11 Sep 2026 05:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F986B009F; Fri, 11 Sep 2026 05:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 447AA6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:23:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A63080157
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:23:37 +0000 (UTC)
X-FDA: 85200943674.03.930ABD5
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1A56F1C0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:23:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789118615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WixuOm1tEcjyvGaAzmBma8FxuJvIiSpDNOZdMhlyJ6Q=;
	b=SN7XmEKBA2x+aWb+5c/wnBn2klEjVhXDzRn+h067qUeHERWROMu45MGXnMzcgiEvv23euB
	I1+zhq9KMegRx51H4XX6xgxjoHtuHy84knLm5sjsTBtNQFlA0GImqm/0Wht3KUyBNLYiLO
	sD2gGktqJLfdg0f9LMOrvkaOE/NibvY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789118615;
	b=vmfVnOnXqTNMO+9g2kX06+Ur+tbmIvl5/3fMFOmokOT9bsVruvu1I414kTWWLlhXJQxlIr
	0xweusho6ijZGQEGOljvhTTa4cFAKtTKyYcKrKhxyJ9tvYABaOnQssMaAiFpxwcSYHq1xg
	pNw00xAmWbIWM9z0SJ6HnE+cuT6HQpo=
Received: by mail.gandi.net (Postfix) with ESMTPSA id B417D3EBB0;
	Fri, 11 Sep 2026 09:23:30 +0000 (UTC)
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
Subject: [PATCH v4 3/3] mm: zswap: preserve the workingset shadow across writeback
Date: Fri, 11 Sep 2026 11:20:07 +0200
Message-ID: <20260911092012.92399-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911092012.92399-1-alex@ghiti.fr>
References: <20260911092012.92399-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTFmvPDg6sHy0qcTbgmjDTDTPeQqdohOvJ/cofgK9xrWUCND0IsVRmadmMr2N7zeDzkSwUImJvURgMPieP7rND95a2Ej/QAy8P6aI8ryIN0EXFI39I8bSjH8f0paP7zmLCg6Sos/dD9jQngGtbbhsoNT3BR+1jC49pGXb9pvnXwy+c/vMB67KrR4WYEiPmnFbNS08/cqYcmfllG4yPBrSxM8lW9rxVtuCK9Y5yfYAckmBcUIgp4FLIB1AT5oqqcgu84lKB6jGlOWE2D2oWcb5Db1/GjRr/hQkxe+ALkaU+C2m7WT2rjidFRAfyBJYzlr34OMnqyHokjg/uidVeFD/ylhUy6uvwADVYvBWTU8MlS9hnVMXpzO47oO4qwCwH2CxOmZ2shsGqB42E9ptEo3HAEPa/QEuq6M0LXrvVMI5fXlNF9ompv5d2c9pGCeJUAqmRG+HbmKm2DeD7jzRa+mAgcg6eVFEGYK1Wr0iYLjP3HhIt9QziFTBH4frVhtkMO968h2HcGuKsW6BQ36MeAVnhMvmyZhS3CO5xgGRsXdCwof9OCgcwPdAce76LHQwY0Uzli6JVAIQSHWBy76aaIzWB/IWkZl3Z9ilOWa2w34fuReEPC4ieVOENlY6qZ84uPnUxG9YoPqv6XyxFLwpVn8mcjuXcZbeEa0SzI0Pnvh7DtJVg
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A56F1C0003
X-Stat-Signature: hn6xohu834xo7gwezy9z6g15rkhzwnwt
X-Rspam-User: 
X-HE-Tag: 1789118614-471194
X-HE-Meta: U2FsdGVkX1/2kT6E/u+UxioY/EAcRMf7WjdeHHgjLOfmN2FaKPY9Ef6qzWy/0LBvEcAeEK51Cm1opFHuB9mxE3LXAGITdD6dM8wQhd/kDHBPIiKNcC2fd37QDVbyCdacd68L6Uu4m4P8jAvJoKVi9tyRGwWQbNuTNG4dLDBGpLB0HRA5Mq+iDoOXwq1VkS6YbkVHeeRLxPzNTuohHpCo14I6u9eNoDx/3ckGIiOETIknK7NHFQvaeli1Ts2fCRMHxiqtuvugHp/sQzGL/mtsNYJDVQE9kCpmk9vMtySy8J0tp+l00R5O0clwK7RnTTTF+qb825jMrleus0ijgQlRf1iHkpz6FatwWmVAYn9NwH56fp0ksed8tUtEB6NYLMKpuWfRj9uHqNgFOqRQrvB0zfFw+iceFhahwBQnyrqVk5nW+uPSz9AZH9kJ4nK/Y5NKaghdquZmjpfB9VKvVODu9lco69H9WvVl/KfGeJdT5Wij1+E4zmaQbsEoGJ3IU+R+i//KSZlTLiEwmyFebVqDJb/OiH3wLgKW80w0Vr5uLQoob44MeToW+GAXbk6WwpWpArUnWkkCVrwXuDEiMkZk0eo0t1TRxqxDbJLnfaMrtC061IKR0XkhWNY2ZYPfnO/zpwHljVm3haY/eQdIUvUHFYJVDPa5wxsPSnr2p2xfot7wGpygiUMX1NTA4lsiIEgeSTyiaCJVTzAw4u2ZyQDZviuZzR+QpljIdmi/bJs/e6evydPoI3ZcZ3wpnlghwRXwy7de/vop+dGbEl4AHYVRYrUn6SYEa6E9jx25N6cN9aHPXkwgLphC3V8qvrSk8a6teXfzm+OkUMTFkT1DlAgN4U+DCoY4tNv41QAvQKfvSs92pe3zwbZ0Bf1e8+9+FuiLD4HeUwZLGCLWwsIjrmsijC9m+NbF53zp25T+eoF/HGVmbwLP4zRsrqfDPWpcDPUve/CCSyqhpDZz1rwOVtc
 ZAII6USA
 R2cwWxggnBG2Ele+CfLWbu2iFPDnKgtlj+shU
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
   cache, take the shadow and feed it to workingset_refault_lru_managed()
   to account the refault of the now-resident folio, then drop it.
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
 mm/zswap.c            | 105 ++++++++++++++++++++++++++++++++++++++++--
 8 files changed, 187 insertions(+), 15 deletions(-)

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
index c95d1ddf3193..733829e9ae80 100644
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
index 16b78d44fdd0..d8cc55d61ea5 100644
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
@@ -1002,7 +1077,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	mpol = get_task_policy(current);
 	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-					 NO_INTERLEAVE_INDEX, NULL);
+					 NO_INTERLEAVE_INDEX, &shadow);
 	put_swap_device(si);
 
 	/*
@@ -1036,7 +1111,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
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
@@ -1056,7 +1136,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
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
@@ -1499,6 +1587,17 @@ bool zswap_store(struct folio *folio)
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


