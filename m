Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 789C1C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359F36B00E2; Mon, 17 Aug 2026 10:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3311F6B00E4; Mon, 17 Aug 2026 10:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247386B00E5; Mon, 17 Aug 2026 10:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0BBA6B00E2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:48:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DE6E40741
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:48:47 +0000 (UTC)
X-FDA: 85111043094.19.F344179
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id 607FD80002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:48:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786978125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j7duFk7P/eySNsLbZZn2yFp/5Q/JGkBcx3YOSmB1xFE=;
	b=aDwjMEryH2N5aqQHzsHMMF5kASp5uRpiguMMj8tV4oYqyYUPijZyISVmjT1iPqlIjJIKRL
	voqhBOCBdQ5Y39a9df+h1cA7vnO54u3/XIH33RGDT9Bh+BnAl+95BSCprJ8ITooSxCQXas
	5DGPBJFaBBgh9eb0y3HWnUCSTEa9KMY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786978125;
	b=nCYspKP4KW0ehgoGx7Fel3SoxNkRduPT2kMsnu6S8Sxhv0KYhBQBfF8Ke8jfScKlqogboQ
	lWInHaeCJazKlpf8TTb8F7fpYZsT3/qYA4vu/Xz5dlMDAB5UwMAI9AS3sLa8ShtIEtpWai
	tCeW0etMKnF0+PGZueQu5eSf6DDcBDo=
Received: by mail.gandi.net (Postfix) with ESMTPSA id A6F2E3F55B;
	Mon, 17 Aug 2026 14:48:37 +0000 (UTC)
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
Subject: [PATCH v1 2/2] mm/zswap: preserve the workingset shadow across writeback
Date: Mon, 17 Aug 2026 16:46:13 +0200
Message-ID: <20260817144622.137133-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817144622.137133-1-alex@ghiti.fr>
References: <20260817144622.137133-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTED4s9q/4/Qo+67HVYmXfPx/DWQ2ffo8TdEuiLGkaYEK6JFkFSnKpYuTbm/uflEAuK90LSUZHIzNaUTD6DVphpajZ8UnCfvEzhzZLQXTjbs/JBGvdNmBdhVKu8wttvmjatS978s7TiytUu+oyhJWlSI56/ySJxvZZpuoBzaNfLZTOxHX/t6dPP60TR8/mUpLtyJMfMLSY8Os/2F4/8z6TkSJPjcZgfP3mF8cmH7uwH60gh+DCEePFUducuqtpZI/j4SD5gnILchD21ibWsikNvn1SxCvQ9d/2BLUyChpz6hQ6g85uT6FZDJwBie/YULdEyJJMw9AEkhlOtUJ8eNebqxlzGcabR702y5hFGMFAKwybopYXVfoAFO2NXqzd+Yd+n7qCHIAGH8RuCeafkSr8HZiWPCfZRk/Rwc0eReTCTKr+tdc6cbzL+Qu3toZLDcj37N5B6HCIUzpCogShw0ZcDanHJLSEg4+8PIx4BgJtXiggrlXpayhylDHoeVGylmg/gxtt1KaYGxN7IlX+e4/Urmfw5ukMNaK+75KjPyeElfCqRXuLf6ajMe348xvUcpKdlWXJz8nXdV1aqtKFDelBzhZjgcEM+6E+Reh5RklaVyaOiBSK3gPrBE1W2K1w5f4Bl+LDy27Wu9/FJW8xSN58HZx5992HBS02pDL5WNOPGMyQ
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 607FD80002
X-Stat-Signature: e5f9y1r9d7sb9jn1hmaunwd89ks8ruub
X-Rspam-User: 
X-HE-Tag: 1786978125-482089
X-HE-Meta: U2FsdGVkX19U20IrJsUPBtMEGOZTUCqh2shCYKUQmczG/CcMcDzR7TQgZhTgTGZ2mUDs7xzZXfNoVAbmHPU0Ck+rlHy1P2a7IPRdnhrICkszhVXH92Ev1yHJfAl6OxzEPrkFNebEfMWRkv9PCFIJblW/F7ARq+/h+7w85OmDgty4sThZJstKzig2monO+0zH7WHciLCp2bb41u+QViBp277Q7jd9c36LOmuEnTX69twd+tNtKibOVKEGVbk8mpuYT4ykUTW/AZ9MmH+/6Q0Lgkvz6R37RQdxVV7W+cn6TDCylM4pOZrUMOIIh/+ov11kyNgIaYjS6B6yVLVpV1rSO+keFfOzOPdqNIU2+2eCTZacJ2wC3LqTNqjXOLpXlC/qHfb+4ZuLpkLUXGJ5n4sD+F094b0+EbD4X2hLuwVh5qmFwuLRJXXSxGmppNZniC1sQr6pDh+EAhw3I0g7j+70OFN45oYjowKN0ik1hDnsXzVKkHAB+gzty8C8DzccJYTsL61DPVFf62CeDfv5JPc7MQzxtlqp455etORaAUTTpt7vSTReIjtncmEPEj5Y6xJFE9LWvnEqrB5Rn0Wt7R3c0sO8GFPyIWfUjiGUfrChFJjp7hvo8J/ykYRYBuK36FgMSfWqK3VNe4vRqHKVmuuyc1Ph6imVGYLKaaAGjwuC2GP5nhvYgPfHrxowT1Wue6icKl6Q6koM24VOwFdhIk+nd9x52sfCxDrLolPREJgi1Py/brewwyLdMHdmd8Kr64iXmYu8X8QUpGFTvo1yI7PIX8f1DFZk1brBwpHsbPyY8c/fdIh0fpCvuulFu5AaCKNXZ41LU8wSwx9F97EL4dtkadP+xosPXwIK3Gq0vd6iOyBS325yDknSVquNztSesXvyIgzggU4+xLXtqggBs+oVIglLcaq5dJwtRgTCpExM+0Sz0b1G7ZjZSwnG6bzDyi7XqhIHjWmmvraXM+LMH9n
 YOwLQaOf
 M2ZNs9mr7KSLkC8N7KgEZM8LsmZMJUuMWPQE3
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
 include/linux/zswap.h | 12 +++++++
 mm/memory.c           |  5 +++
 mm/shmem.c            |  5 +++
 mm/swap_state.c       | 10 ++++++
 mm/vmscan.c           |  4 ++-
 mm/zswap.c            | 80 ++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 114 insertions(+), 2 deletions(-)

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
diff --git a/mm/memory.c b/mm/memory.c
index 56be920c56d7..ebc332761c2c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4759,6 +4759,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	unsigned long page_idx;
 	unsigned long address;
 	pte_t *ptep;
+	void *shadow;
 
 	if (!pte_unmap_same(vmf))
 		goto out;
@@ -4880,6 +4881,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out_page;
 	}
 
+	shadow = zswap_lookup_and_clear_shadows(folio);
+	if (shadow)
+		workingset_refault(folio, shadow);
+
 	/*
 	 * KSM sometimes has to copy on read faults, for example, if
 	 * folio->index of non-ksm folios would be nonlinear inside the
diff --git a/mm/shmem.c b/mm/shmem.c
index 56c23a7b15c7..3ac9abc7ba8e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2242,6 +2242,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	struct folio *folio = NULL;
 	int error, nr_pages, order;
 	pgoff_t offset;
+	void *shadow;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
 	index_entry = radix_to_swp_entry(*foliop);
@@ -2353,6 +2354,10 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	 */
 	arch_swap_restore(folio_swap(swap, folio), folio);
 
+	shadow = zswap_lookup_and_clear_shadows(folio);
+	if (shadow)
+		workingset_refault(folio, shadow);
+
 	if (shmem_should_replace_folio(folio, gfp)) {
 		error = shmem_replace_folio(&folio, gfp, info, index, vma);
 		if (error)
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0bb26d2ba2ba..7ea4a2ba0841 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <linux/huge_mm.h>
 #include <linux/shmem_fs.h>
+#include <linux/zswap.h>
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
@@ -257,12 +258,21 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
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
index 3f3ff25e561a..2c57e88421b0 100644
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
@@ -735,7 +736,8 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 	if (folio_test_swapcache(folio)) {
 		swp_entry_t swap = folio->swap;
 
-		if (reclaimed && !mapping_exiting(mapping))
+		if (reclaimed && !mapping_exiting(mapping) &&
+		    !zswap_folio_is_writeback_buffer(folio))
 			shadow = workingset_eviction(folio, target_memcg);
 		__memcg1_swapout(folio, ci);
 		__swap_cache_del_folio(ci, folio, swap, shadow);
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..f059206948ab 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -972,6 +972,79 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 /*********************************
 * writeback code
 **********************************/
+
+#define ZSWAP_WRITEBACK_NO_SHADOW xa_mk_value(0)
+
+/*
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
+/*
+ * zswap_lookup_and_clear_shadows - retrieve and clear @folio's parked shadow(s)
+ * @folio: the writeback buffer folio (or the swapin folio that consumed it)
+ *
+ * Remove any parked writeback shadows for @folio's swap offset(s) from the
+ * zswap tree.
+ *
+ * Return: the preserved workingset shadow, or NULL if the slot(s) had no shadow
+ * (sentinel only) or nothing parked. The caller either restores the returned
+ * shadow into the swap slot (buffer dropped) or feeds it to workingset_refault()
+ * (buffer consumed by a swapin); clearing here ensures the two paths never
+ * double-count.
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
@@ -992,6 +1065,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
+	void *shadow;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -999,6 +1073,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -EEXIST;
 
+	shadow = swap_cache_get_shadow(swpentry);
+
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
@@ -1034,7 +1110,9 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		goto out;
 	}
 
-	xa_erase(tree, offset);
+	if (!shadow)
+		shadow = ZSWAP_WRITEBACK_NO_SHADOW;
+	xa_store(tree, offset, shadow, GFP_KERNEL);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
-- 
2.53.0-Meta


