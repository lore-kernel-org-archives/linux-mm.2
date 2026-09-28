Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5D8C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4982F6B00A1; Mon, 28 Sep 2026 04:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F496B00A2; Mon, 28 Sep 2026 04:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385CB6B00A4; Mon, 28 Sep 2026 04:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D40C6B00A1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:23:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5191C40133
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:23:32 +0000 (UTC)
X-FDA: 85262481864.07.6AB5017
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4F4D020005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:23:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790583810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DexB/VLv+pGdi76zwH3vWRbZ4gWFCiN7awC3QtS10k0=;
	b=LfPz/igRZgTg30UvkjDne3w7RRsgGp7q0s/Gfh3buXXUXklDGjvwD0Wsad795sQxhIaQd3
	tBIPCZyVo4vmLmVjVJCRy1uaRd/U3L/gyq/ijbX3WbOy4bkzO7rYveaoFwpgzOND+868YM
	2gUgHjVcEDvXAsUOpBqOyNtpWE2CboU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790583810;
	b=1/oOYqkh9pRg0gh80HHT3hDjMOEAF+6XLW2HwNj4zOZ3LgcGwXz8im3mcEkbG/a46A+VDJ
	tKZyZquCFA+Iysjz9BfIVSI/vk0X/IcDMJCIjKT9ZIdp7K2w285Drj+il/PGRubhtYNP2f
	x8oZWsAUs/ITwGpBHOaByteeiSFnPMo=
Received: by mail.gandi.net (Postfix) with ESMTPSA id E7DDC3E9C7;
	Mon, 28 Sep 2026 08:23:26 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH 4/4] mm/zswap: move reclaim-driven writeback to a kworker
Date: Mon, 28 Sep 2026 10:18:39 +0200
Message-ID: <20260928081900.4187482-5-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928081900.4187482-1-alex@ghiti.fr>
References: <20260928081900.4187482-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTF1WgxKY+Hx+MtLkqEgf14qdcr1+2vySI3bPfHY+1e8WxR121fR9tKBSxFip9SAGz/LvBdHvHURU5+G+dwzUt09iiq1wE3u/EHqAwzzEtlg4IMZOeNhPxPzSc9Uzifz6IYqgn5FLZVG9qr3g56tJJl4H8J2OgtauXWmUKBlt1IplD2RgOku62CESjw9LcQDTtUf/ICC5/zRwNwZyrFSztrjsUVnoJyVucdK2zN8x1uyIzlti9OL3wCKheHKfivkHF6geQ0S7oQQmvlhSwicKWbPULQiJ23wOo8guz3FvZd8zDnUMxN9Lnzo/rFNv/4HjE06/cnet6PfajsYTKqYCGjEoedDt074YXXB/ocETchPZ6++FXT49b8yP7OUW7y11uMMnC6bKMh8b4wMgbsl6QtihmlAPHOyzeGCNLc5kvkSpsHSCQaWDlA559xhkpX0g17VdSI3AzXGJQ3xQgLgGoagcXoTmeyzt30p4W8jizMqOqVogiv7G1UpJDN4VsT++qN+jASbIGaDIlmRb8wqCS4s48nL8gU85MuDBtxWyeYhuaNtoMUbe/Fw/DcQl5IHkIr61HxFwYnn3yqnxfXKmxHntll1p24yt9zzHioR8pllX2oT0AKwc/uO7jY0oCrhSDb00jNQBqgd1YPde/+Pn9125xji3XrHW46YOVxy8VMo9g
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Queue-Id: 4F4D020005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: kadgtpwy68prrbagbxs9q9royfsiet14
X-HE-Tag: 1790583810-872889
X-HE-Meta: U2FsdGVkX1++/GPmH6QYtnI3+kqJ0GH0EPGCzcnq64iK95IU6qpyx18Ic/srz2+oGxK/MpYmgiDLFVQvfjP7+OCWkfIblolZN6w6yhZopCRMQek1TLsT8kk3b3/Kak2EIp201JLMZO2NojLBDwtidIotKYqLbKya1Y+P9eiyjIJi4yba/9Nj0CUtcnRNx9FhRuBnxFivVsSOTZ3n2DVTPl+qxeRhTk33ma8q8BtEXp5FhXTsrMfP1OzoVGPJ5wljhafiEQuy+B0fUxWo53yelwtsd+Na3ypRX3W57JYoqP/qT3MYLKVdr2wb0Xm9wmQbO8yCawR3ja19PahDkL+SEiwB0Wxa7ISs6DCpNTZq++fm+fQdHOKwh4Q5FGSsRKmpF87+cy5ujUqo1phLh5I1tb+XVauufBV3ms6SRNUGHao0BRl7a9IQQOvhZ+m6lfJzQ2Snq5lbDoTyPPuhbZfnFLAuDksxXLucayNsaFODXI5e0X4See5E6d4NSyHkNMjVKlnEB512sLjx+CaCt/sMdpRaZAjFPIsflntMQQbnA9g2MgSCkB5hqEU1EVX8PL2n/5bx9REqDaZHxFOoS13zjNhys0FpqXz4a+MicZLiGrzz1/uG/+9/FEYggXY/geLtW1VH5VvVCuw3RflAQN2Afv/ub3o0AsNCIuP1FuEjybOYNCgz0sCtHt0vyqJLCxL2ctbgzJUc7pNPpkCjVSyeH3aRVYM0CzNKZaSqFVqox3dYQhe59SA6f98qgjb4BvPscX/7llUFkGV9WzM3INut2RSv5zjAI9Uzkav2wQhI1RnrLnAu1rXxnenEL4KevZbF5hMwR0eFRLsf6fjOp/2r3VXFGOmFA4z0tPRo5fzOplzqKo8l52+SQb9bTRE6X6SydD6tAyZhRLXTmhgWI3hxLyla3iewtjaH2PAHukVmg1ZPsfwHTXF7DDA6PmeQo6rFLrISpk8vAHQNNWWdXUr
 UJnT4QhD
 Vkaeu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_shrinker_scan() writes back in whatever context reclaim called it
from: an application thread inside a page fault, or kswapd reclaiming
for the whole node. Now that the cgroup IO controllers throttle zswap
writeback, that context sleeps uninterruptibly until the owning cgroup's
IO budget allows the write. Such stalls were observed on a large
production workload.

So defer the writeback to a kworker: each lruvec has its own work item
on shrink_wq, which writes back what reclaim asked for, SWAP_CLUSTER_MAX
entries at a time, while holding a reference on the memcg. The shrinker
does not queue more work while the worker has yet to claim the previous
one, and reports nothing freed, as nothing is until the worker runs.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/zswap.h |   4 ++
 mm/zswap.c            | 114 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 106 insertions(+), 12 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..80391c440e97 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/mm_types.h>
+#include <linux/workqueue_types.h>
 
 struct lruvec;
 
@@ -22,6 +23,9 @@ struct zswap_lruvec_state {
 	 * swapped them in.
 	 */
 	atomic_long_t nr_disk_swapins;
+
+	atomic_long_t nr_deferred_writeback;
+	struct work_struct deferred_writeback_work;
 };
 
 unsigned long zswap_total_pages(void);
diff --git a/mm/zswap.c b/mm/zswap.c
index 3b902f29ed4c..cf2dd7a5aff0 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -237,6 +237,8 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
+static void zswap_deferred_writeback_work(struct work_struct *w);
+
 /*********************************
 * pool functions
 **********************************/
@@ -702,7 +704,11 @@ static void zswap_lru_del(struct zswap_entry *entry)
 
 void zswap_lruvec_state_init(struct lruvec *lruvec)
 {
-	atomic_long_set(&lruvec->zswap_lruvec_state.nr_disk_swapins, 0);
+	struct zswap_lruvec_state *zls = &lruvec->zswap_lruvec_state;
+
+	atomic_long_set(&zls->nr_disk_swapins, 0);
+	atomic_long_set(&zls->nr_deferred_writeback, 0);
+	INIT_WORK(&zls->deferred_writeback_work, zswap_deferred_writeback_work);
 }
 
 void zswap_folio_swapin(struct folio *folio)
@@ -726,9 +732,15 @@ void zswap_folio_swapin(struct folio *folio)
  *
  * shrink_worker() must handle the case where this function releases
  * the reference of memcg being shrunk.
+ *
+ * The deferred writeback workers hold a reference of the memcg too. Stop
+ * queued ones here so they never start; running ones drop theirs when they
+ * finish.
  */
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
 {
+	int nid;
+
 	/* lock out zswap shrinker walking memcg tree */
 	spin_lock(&zswap_shrink_lock);
 	if (zswap_next_shrink == memcg) {
@@ -737,6 +749,20 @@ void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
 		} while (zswap_next_shrink && !mem_cgroup_online(zswap_next_shrink));
 	}
 	spin_unlock(&zswap_shrink_lock);
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		struct zswap_lruvec_state *zls = &lruvec->zswap_lruvec_state;
+
+		/*
+		 * Returning true means the work was pending: it will not run,
+		 * so the reference zswap_defer_writeback() took for it has to
+		 * be dropped here. A work item that is already executing is
+		 * not cancelled and drops its own reference when it finishes.
+		 */
+		if (cancel_work(&zls->deferred_writeback_work))
+			mem_cgroup_put(memcg);
+	}
 }
 
 /*********************************
@@ -1188,25 +1214,89 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	return ret;
 }
 
-static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
-		struct shrink_control *sc)
+static void zswap_deferred_writeback_work(struct work_struct *w)
 {
-	unsigned long shrink_ret;
 	unsigned int flags = ZSWAP_SHRINK_THROTTLED;
+	struct mem_cgroup *memcg, *old_memcg;
+	struct zswap_lruvec_state *zls;
+	unsigned int noreclaim_flag;
+	struct lruvec *lruvec;
+	unsigned long nr;
+	int nid;
+
+	zls = container_of(w, struct zswap_lruvec_state,
+			   deferred_writeback_work);
+	lruvec = container_of(zls, struct lruvec, zswap_lruvec_state);
+	memcg = lruvec_memcg(lruvec);
+	nid = lruvec_pgdat(lruvec)->node_id;
+
+	nr = atomic_long_xchg(&zls->nr_deferred_writeback, 0);
 
 	if (!zswap_shrinker_enabled ||
-			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
-		sc->nr_scanned = 0;
-		return SHRINK_STOP;
+	    !mem_cgroup_zswap_writeback_enabled(memcg))
+		nr = 0;
+
+	noreclaim_flag = memalloc_noreclaim_save();
+	/*
+	 * Once the memcg is offline, the IO falls back to current's memcg,
+	 * which is wrong for a kworker.
+	 */
+	old_memcg = set_active_memcg(memcg);
+	while (nr) {
+		unsigned long nr_to_walk = min(nr, SWAP_CLUSTER_MAX);
+		unsigned long budget = nr_to_walk;
+
+		list_lru_walk_one(&zswap_list_lru, nid, memcg, &shrink_memcg_cb,
+				  &flags, &nr_to_walk);
+
+		if (nr_to_walk == budget)
+			break;
+
+		nr -= budget - nr_to_walk;
+
+		if (flags & ZSWAP_SHRINK_SWAPCACHE)
+			break;
+
+		cond_resched();
 	}
+	set_active_memcg(old_memcg);
+	memalloc_noreclaim_restore(noreclaim_flag);
+
+	/* Paired with mem_cgroup_tryget_online() in zswap_defer_writeback(). */
+	mem_cgroup_put(memcg);
+}
+
+static bool zswap_defer_writeback(struct shrink_control *sc)
+{
+	struct lruvec *lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
+	struct zswap_lruvec_state *zls = &lruvec->zswap_lruvec_state;
+	long old = 0;
+
+	/* Do not accumulate work: back off if the worker is lagging behind. */
+	if (!atomic_long_try_cmpxchg(&zls->nr_deferred_writeback, &old,
+				     sc->nr_to_scan))
+		return false;
+
+	if (!mem_cgroup_tryget_online(sc->memcg))
+		return false;
 
-	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&flags);
+	if (!queue_work(shrink_wq, &zls->deferred_writeback_work))
+		mem_cgroup_put(sc->memcg);
+
+	return true;
+}
 
-	if (flags & ZSWAP_SHRINK_SWAPCACHE)
+static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
+					 struct shrink_control *sc)
+{
+	if (!zswap_shrinker_enabled ||
+	    !mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
+		sc->nr_scanned = 0;
 		return SHRINK_STOP;
+	}
 
-	return shrink_ret ? shrink_ret : SHRINK_STOP;
+	/* Nothing is freed until the worker runs, so report nothing. */
+	return zswap_defer_writeback(sc) ? 0 : SHRINK_STOP;
 }
 
 static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
@@ -1807,7 +1897,7 @@ static int zswap_setup(void)
 		goto hp_fail;
 
 	shrink_wq = alloc_workqueue("zswap-shrink",
-			WQ_UNBOUND|WQ_MEM_RECLAIM, 1);
+			WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
 	if (!shrink_wq)
 		goto shrink_wq_fail;
 
-- 
2.53.0-Meta


