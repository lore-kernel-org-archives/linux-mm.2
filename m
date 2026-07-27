Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EFA1C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD17B6B00BB; Mon, 27 Jul 2026 10:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0BD46B00BC; Mon, 27 Jul 2026 10:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD316B00BE; Mon, 27 Jul 2026 10:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7262C6B00BB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F214612074A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:39 +0000 (UTC)
X-FDA: 85034812758.17.BDF00D2
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id F2E5D20011
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jv7O29+8OcGqwEl2vBUQVmb+1wAYIcnuu+nItqkJyt0=;
	b=EE88hqw77lzExCqfOt72UpnLRg+C5IGtG8pMfHnsXtr0O+khY9CEJPuymH17MvGrP23PF5
	jcwGBrzPWxsxMcsvgo2/ekwbc8DlK9a039Koa7G1PlSwjOOKWERV1d9kqll3CxK8PRLNjT
	PJoANpwVnSixEzeqtN5LcHh/z8C4d1g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163118;
	b=1hJYSaaH883wZCGm0CyAImTwgEU2r9YfcnLcPGJD3gdq8JvEihdv8+bteSb1mlfiP+am5N
	z9zTFLeaiZ72cUZbyx1LUecTd1lvJ6CMn6ei2Vk39YVc5zl2BJnjKEfIsQl8hY65Os++PX
	XM5XkNNmLce7N+GzPMhK/CginGNwXkk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 80C913EC07;
	Mon, 27 Jul 2026 14:38:33 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 2/3] mm: swap: drop dropbehind swap cache folios on writeback completion
Date: Mon, 27 Jul 2026 16:36:09 +0200
Message-ID: <20260727143618.1582318-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260727143618.1582318-1-alex@ghiti.fr>
References: <20260727143618.1582318-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTGOfRGj+Y4aE1VYke1+m8o+GKG1gCm5Y7xcpj4upAxgjCYkun8pANvrTiq+OY0pCfJ40eTlWHQlkQZespmOciWdf4WlCT5C2JVQoaWVrFfVAhx0n88NKH+5xp0JJPNnW+EwBwtjBPLtFrR0+WDMgpUF0JeAmL+LQuc2RlQAdCb3HedO6zlMyxwA86n6Sd9l/w67Y8/zZMIHf4omdFOtHtrRjs/QQXKs8hNc4I4Hmk6ozkTKRZGYF4gghB/LL5qykh+PrAmMDRfxCGengayYEGk6oSH12wABQcn8jmeBsoXSSAl+AW3hNZu3sWejmOZD2ieLlBf9CVtvEVKZB3eQ1WzJL2rM686qbCbSdLNLe23Zrms0th+pKAo0Jwtx8xVwIKvLUW9UpYbbidFxTsHCNwWdeyFA7l2VeaaLlhG3OqUlt4K8s3m7pzvvCy9m8/veOhpKi0QVElzYqd4dsUV3S/UU6WLvPfrCukMF4Xm7VJl85gH+Iv5VFusRDxsmr95ToAHYXIF2W6dG4qzTopS9RwRwTOktEE9+KroYaXUA79LOqlwjQEem1+094rNzOP9+wer+tBJH+pcXzghPfOj/l8UAtQ8Vq3rDLYJNZw/syRvB6JZ4TiTRCByoBGjEXqH4ofaRKaVvzGnXjYWMWoeFK7j4zGic6/BHGTtG1FHhvbRFDA
X-GND-State: clean
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F2E5D20011
X-Stat-Signature: 39ja9g7k1hu3ig85g3osbs5q9wjj6wg7
X-Rspam-User: 
X-HE-Tag: 1785163117-287017
X-HE-Meta: U2FsdGVkX1+VKaC953WbQamEeB9YVE3l64mVH5WiXxUt4qO/gCENaLTq1xbh+w+XsFh5KNYpl6wrs0w4kwrmHRFg83AzcnkdIBC6KCrKuJsIDi1yC2jIzYQJ/rlQJ5osznu96cvaNwU1H1BJAGKoqWT3t0keJx1gipkktvzr7I1NbrwRKjJ9ZuJ0cVOrxEY0V1cIz5mHT69CAWeNS46ekGXMwpybn4wRvui+ycIig+Q7I8RwpvXe7gpGSC5nybvF0bmC+fEm2higNlYaqHtbDtdchHuBtnJD1cpsWVmcZUQU/YjkES3FMPABM+CRIv7U46WmjLOaLzOtrf4soi39fDm1mfcANX1Vrn7CvYdeICKVi4Gni5U04h5Ta1rRjbZpe55qMhDHq3UoXCjMuh3LbS4yJ2mgLgC0R2Xn1R8cmzoPeFg7ywcXDG0oe6T3m7DPlHd1GbMXk7MPAMM4hllH4wchWpqbi+LRy1tbnmMu5stpxi9IaJpxV0Qfd056Od/4muupfdwxEZldvBcYRY1uSq+6XMUr/LLfVTQ7XHLSuDAazRy9qJCTFq0aBX04kUUOYIDQK0LAy++ryKtHS6z0vdEgRpCtarXrpDvPilsq+2uRiCixd4fc9AfUiC6LX5ZvPHFacArR7/a77REWYH2VMRSFPe13r6Uk4gt0wUO6ewZEwf3vDhTqeWuDlp/aePHq1dGMnM5z/X4q3YEhEvglSn+uoe2bdfywOLqGzjo29Rc8IxyXWPexove4SdiGjw1flcwLIvnidQwuO7xhMiEedNQT6yLJ/HXATWdU/ZI+mC1yY5GQCpN5+MogJRGTpDR3c1B39RqgBdbE3d/j9IJY3Cz8id5nyQ/oNG5hLovhwez8lOf46LFzYIpkDWwaXJe7VP2UMkx2JYkIsWzg0op5u4WGNyHauqOxa9HgN+QMeUkqnS6Y7dMT1R5ttZse1Lfyz4Wuyy2OQTFhwZzILeh
 VawYv5PQ
 tH/juYXdummHKFMHkzegs0K7p+MdUIWutDmo6Mjvolb86sgXI+pIAXJC0MXOIeHiRnT8KaYDAOmYmMqcZoXObYQQQyrI1FZr8+HVEUnMscb8u6qt4gVVJ5011Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A PG_dropbehind folio is dropped from its cache once writeback completes
rather than left for reclaim to find later; this is implemented for file
folios in folio_end_dropbehind(). Extend it to swap cache folios.

Synchronous-IO swap completes writeback in the calling context, so the
folio can be freed right after the write. Asynchronous block devices and
filesystem-backed swap complete writeback in interrupt context, where the
folio cannot be freed, so defer the work to a workqueue that runs once
writeback has completed.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 fs/splice.c          |  2 +-
 include/linux/swap.h |  8 +++-
 mm/filemap.c         | 19 +++++++++
 mm/swap_state.c      | 94 ++++++++++++++++++++++++++++++++++++++++++++
 mm/truncate.c        |  2 +-
 mm/vmscan.c          | 13 ++++--
 6 files changed, 132 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9d8f63e2fd1a..79424bbee1b0 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -90,7 +90,7 @@ static bool page_cache_pipe_buf_try_steal(struct pipe_inode_info *pipe,
 		 * If we succeeded in removing the mapping, set LRU flag
 		 * and return good.
 		 */
-		if (remove_mapping(mapping, folio)) {
+		if (remove_mapping(mapping, folio, false, NULL)) {
 			buf->flags |= PIPE_BUF_FLAG_LRU;
 			return true;
 		}
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6d72778e6cc3..93eb8003ec04 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -373,7 +373,8 @@ extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						unsigned long *nr_scanned);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
-long remove_mapping(struct address_space *mapping, struct folio *folio);
+long remove_mapping(struct address_space *mapping, struct folio *folio,
+		    bool reclaimed, struct mem_cgroup *target_memcg);
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
 extern int reclaim_register_node(struct node *node);
@@ -467,6 +468,9 @@ void swap_put_entries_direct(swp_entry_t entry, int nr);
  */
 bool folio_free_swap(struct folio *folio);
 
+void swap_writeback_dropbehind_folio(struct folio *folio);
+void swap_dropbehind_free_one_folio(struct folio *folio);
+
 /* Allocate / free (hibernation) exclusive entries */
 swp_entry_t swap_alloc_hibernation_slot(int type);
 void swap_free_hibernation_slot(swp_entry_t entry);
@@ -477,6 +481,8 @@ static inline void put_swap_device(struct swap_info_struct *si)
 }
 
 #else /* CONFIG_SWAP */
+static inline void swap_writeback_dropbehind_folio(struct folio *folio) {}
+static inline void swap_dropbehind_free_one_folio(struct folio *folio) {}
 static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
 {
 	return NULL;
diff --git a/mm/filemap.c b/mm/filemap.c
index dc3a0e960b9f..aaffacdf5b1f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1680,6 +1680,8 @@ EXPORT_SYMBOL_GPL(folio_end_writeback_no_dropbehind);
  */
 void folio_end_writeback(struct folio *folio)
 {
+	bool swap_dropbehind;
+
 	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
 
 	/*
@@ -1689,7 +1691,24 @@ void folio_end_writeback(struct folio *folio)
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
+
+	/*
+	 * Dropbehind swap cache folios are off-LRU, so we must prevent a racing
+	 * swapin from removing the folio from the swap cache and keeping it
+	 * off-LRU: the writeback flag allows that. Afterwards a swapin may win
+	 * the race, but the folio is already queued and the worker puts it back
+	 * on the LRU in that case.
+	 */
+	swap_dropbehind = folio_test_swapcache(folio) &&
+			  folio_test_dropbehind(folio);
+
 	folio_end_writeback_no_dropbehind(folio);
+
+	if (swap_dropbehind) {
+		swap_writeback_dropbehind_folio(folio);
+		return;
+	}
+
 	folio_end_dropbehind(folio);
 	folio_put(folio);
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 90638a8d7232..e405b8ff3408 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -16,6 +16,8 @@
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/folio_batch.h>
+#include <linux/llist.h>
+#include <linux/workqueue.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
 #include <linux/migrate.h>
@@ -537,6 +539,98 @@ struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 	return ret;
 }
 
+static DEFINE_PER_CPU(struct llist_head, swap_dropbehind_llist);
+
+static bool swap_dropbehind_drop_folio(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+	bool dropped = false;
+
+	folio_lock(folio);
+
+	/* The folio was allocated off the LRU and nothing re-adds it here. */
+	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (memcg && !css_tryget(&memcg->css))
+		memcg = NULL;
+	rcu_read_unlock();
+
+	/*
+	 * Gate remove_mapping() on folio_test_swapcache(): a racing swapin may
+	 * have freed the swap slot (folio_free_swap()) and dropped the folio from
+	 * the cache, and remove_mapping() must not run on a non-swapcache folio
+	 * (it would trip __remove_mapping()'s mapping == folio_mapping() check).
+	 */
+	if (folio_test_swapcache(folio) && !folio_test_writeback(folio) &&
+	    remove_mapping(swap_address_space(folio->swap), folio, true, memcg)) {
+		dropped = true;
+	} else {
+		/* Raced: the folio is now owned by the swapin; put it back. */
+		folio_clear_dropbehind(folio);
+		folio_add_lru(folio);
+	}
+
+	if (memcg)
+		css_put(&memcg->css);
+
+	folio_unlock(folio);
+	if (!dropped)
+		folio_put(folio);
+	return dropped;
+}
+
+/**
+ * swap_dropbehind_free_one_folio - free a dropbehind swap cache folio inline
+ * @folio: the off-LRU folio whose writeback has completed
+ */
+void swap_dropbehind_free_one_folio(struct folio *folio)
+{
+	if (swap_dropbehind_drop_folio(folio))
+		folio_put(folio);
+}
+
+/**
+ * swap_dropbehind_free_batch_folio - free a dropbehind swap cache folio into a batch
+ * @folio: the off-LRU folio whose writeback has completed
+ * @fbatch: batch of folios to free, flushed when full
+ */
+static void swap_dropbehind_free_batch_folio(struct folio *folio,
+					     struct folio_batch *fbatch)
+{
+	if (swap_dropbehind_drop_folio(folio) && !folio_batch_add(fbatch, folio))
+		folios_put(fbatch);
+}
+
+static void swap_dropbehind_workfn(struct work_struct *work)
+{
+	struct folio_batch fbatch;
+	struct llist_node *pos, *next;
+	int cpu;
+
+	folio_batch_init(&fbatch);
+	for_each_possible_cpu(cpu) {
+		pos = llist_del_all(per_cpu_ptr(&swap_dropbehind_llist, cpu));
+		llist_for_each_safe(pos, next, pos) {
+			struct folio *folio = container_of((struct list_head *)pos,
+							   struct folio, lru);
+			swap_dropbehind_free_batch_folio(folio, &fbatch);
+		}
+	}
+	if (fbatch.nr)
+		folios_put(&fbatch);
+}
+
+static DECLARE_WORK(swap_dropbehind_work, swap_dropbehind_workfn);
+
+void swap_writeback_dropbehind_folio(struct folio *folio)
+{
+	llist_add((struct llist_node *)&folio->lru,
+		  this_cpu_ptr(&swap_dropbehind_llist));
+	schedule_work(&swap_dropbehind_work);
+}
+
 /*
  * If we are the only user, then try to free up the swap cache.
  *
diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..37f7d8278c1c 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -336,7 +336,7 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
 	if (!filemap_release_folio(folio, 0))
 		return 0;
 
-	return remove_mapping(mapping, folio);
+	return remove_mapping(mapping, folio, false, NULL);
 }
 
 /**
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3f3ff25e561a..37b093c4628c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -789,17 +789,24 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
  * remove_mapping() - Attempt to remove a folio from its mapping.
  * @mapping: The address space.
  * @folio: The folio to remove.
+ * @reclaimed: Whether the folio is being reclaimed (record a shadow).
+ * @target_memcg: The memcg to charge the eviction shadow to when @reclaimed;
+ *                the caller must keep it alive across the call. Ignored (may
+ *                be NULL) when @reclaimed is false.
  *
  * If the folio is dirty, under writeback or if someone else has a ref
- * on it, removal will fail.
+ * on it, removal will fail. When @reclaimed is true, a workingset eviction
+ * shadow is stored (like page reclaim does) so that a later refault can be
+ * detected and the folio re-activated.
  * Return: The number of pages removed from the mapping.  0 if the folio
  * could not be removed.
  * Context: The caller should have a single refcount on the folio and
  * hold its lock.
  */
-long remove_mapping(struct address_space *mapping, struct folio *folio)
+long remove_mapping(struct address_space *mapping, struct folio *folio,
+		    bool reclaimed, struct mem_cgroup *target_memcg)
 {
-	if (__remove_mapping(mapping, folio, false, NULL)) {
+	if (__remove_mapping(mapping, folio, reclaimed, target_memcg)) {
 		/*
 		 * Unfreezing the refcount with 1 effectively
 		 * drops the pagecache ref for us without requiring another
-- 
2.53.0-Meta


