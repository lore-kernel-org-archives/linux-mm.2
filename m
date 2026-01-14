Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85317D29FF0
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE666B00BB; Wed, 14 Jan 2026 06:35:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C116B00BD; Wed, 14 Jan 2026 06:35:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCF7A6B00BE; Wed, 14 Jan 2026 06:35:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA0546B00BB
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:35:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F8D41AD7A3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:40 +0000 (UTC)
X-FDA: 84330364440.29.625639C
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id EC221140002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lHtmZUQd;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egA9OCpvJUUfZlVg68Gp5bUnsvQAjKiqm/PvYeVMrFQ=;
	b=aMjMCLmg7OXfokI9pOQamtvkv4W7TbiN55rZPnvRskstVeRrnwTKjQFz98cfG31BnbWY+x
	/F4dqms20RfU4uzEzWVnb3RvW42qQWcgeKhQ0zg61Wi2EaIvLwCr9PRo5pfoxn+ZgUHu2D
	qDHFElAtP/ReBkxf824YKf57hJT513o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lHtmZUQd;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390539; a=rsa-sha256;
	cv=none;
	b=6f2ayNa2vhEEqeJ8Z3/6Org4VLz5vydrOG6TAd3QeGu3pkCgp8a/Nj1eBBNBBA/QBmndLe
	k3arPcXR9DeS2kfGF+28I3B9uDg3uv1QDYtXfR99qQKt3WHdJoUqRnNLmNvaiYCarMMdgS
	tt+J3hM1d1vt+79dM4821FQM6rxbyAY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=egA9OCpvJUUfZlVg68Gp5bUnsvQAjKiqm/PvYeVMrFQ=;
	b=lHtmZUQdxzcSHug7u6aLnbAP2ZssjbFwLCca9btr5YQ4kWE//QnuhiDJXybsJtvIgKJ28a
	0MFrVPqOxTxCcrqVJKy2o1MmXRRB+XWy/GgAFZyMjvVUpsUdzJtOEKVoi/QsQm/eKiB41M
	nVMyUjNd8e72GBYUHikZEDz7JbD8boc=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 23/30] mm: do not open-code lruvec lock
Date: Wed, 14 Jan 2026 19:32:50 +0800
Message-ID: <33fef62fd821f669fcdc999e54c4035a4e91b47d.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EC221140002
X-Stat-Signature: s194gg799nfi75cmguf9ea5gpy6n9473
X-HE-Tag: 1768390538-152627
X-HE-Meta: U2FsdGVkX1+4l5r6f6nR64yl7iKvI/M8eMDBDgXKioWAF6OB3hWbrXhLKYrg5WzZ3fertctoRtdnrUnfO8q8sJ9SlFTolUuIYZSuiBZ8PXdMhkfScxgNQs5npw8CWHjHNBt1CJBJ9xxe7bVymw4VzC/T5Psu+WF7rsEed0VNapeiVsEoxueTw2TKvj5dMlvno0Npi/IbjwRAdbDGg0OvUpdqRGAo0CBu9Y2gSphc73Y2lj0FUSCrRN8mkhIqb/FAGuioIh5Kal0A6u34aDS6guy1g+sqb86uA1ErJys97ZiQc7ym4WJB3Ekjfoy1LcYz7ZEspwf623MJUPvR3zbgvySptzjwLV6nz2LrRIMueqkmHtWI0iNMt4zb+5k1GA4xzaKJR0HiFbm996WQs9Yyp0jKDsiRlWCS10sk60jtpT3t4339OMiy8XrPmHOptd1AlCIFjfDKd0qj5D+MbonGEaB8kUu6F9K6ofBGPfb8lJMJf+zHaiPIBMUbVy+EU7dG0en2Lzr5Tm8aky2Nx+KsXrDIva1B13BHBpuKeTMhvYA5xPrJFIkYEh5BuUiHZ6a+nu83XUApn81waFCsa57bStQ7mQrUMqjTMOcPOhpaGD0P5E8NVR9K6sjso/nuxqbmaXz5WDyepAlI3Q3wolEMMVS1CmDwD4wReldshZBOSYUt7PFkOv/CVaZ68/bKZys3xALo1+u2sxliJkLuXrXQcOwKY0j69rQJuYQukG8PjnOLx8dTmOWKg6PSkgKIfH8S4SUKEfpT9OAlK1snhFXBbeHr+kb0V1RvgQs4xltjcWiykWg0fEsmzxKykw83uoJP28yb86g54w3Ic7S7iiXSzJ1dU2BO6L3U6AjfZmKxGw85zfH4QAdkFknULkXL6bcaqqOu9eqBJj60A8tmA231tA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Now we have lruvec_unlock(), lruvec_unlock_irq() and
lruvec_unlock_irqrestore(), but not the paired lruvec_lock(),
lruvec_lock_irq() and lruvec_lock_irqsave().

There is currently no use case for lruvec_lock_irqsave(), so only
introduce lruvec_lock() and lruvec_lock_irq(), and change all open-code
places to use these helper function. This looks cleaner and prepares for
reparenting LRU pages, preventing user from missing RCU lock calls due to
open-code lruvec lock.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h |  5 +++++
 mm/vmscan.c                | 38 +++++++++++++++++++-------------------
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f1556759d0d3f..4b6f20dc694ba 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1499,6 +1499,11 @@ static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
 }
 
+static inline void lruvec_lock_irq(struct lruvec *lruvec)
+{
+	spin_lock_irq(&lruvec->lru_lock);
+}
+
 static inline void lruvec_unlock(struct lruvec *lruvec)
 {
 	spin_unlock(&lruvec->lru_lock);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f206d4dac9e77..c48ff6e05e004 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2020,7 +2020,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	lru_add_drain();
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list,
 				     &nr_scanned, sc, lru);
@@ -2032,7 +2032,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
 	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	if (nr_taken == 0)
 		return 0;
@@ -2051,7 +2051,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
 
@@ -2130,7 +2130,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 	lru_add_drain();
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold,
 				     &nr_scanned, sc, lru);
@@ -2141,7 +2141,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 		__count_vm_events(PGREFILL, nr_scanned);
 	count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	while (!list_empty(&l_hold)) {
 		struct folio *folio;
@@ -2197,7 +2197,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
@@ -3832,9 +3832,9 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 		}
 
 		if (walk->batched) {
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec_lock_irq(lruvec);
 			reset_batch_size(walk);
-			spin_unlock_irq(&lruvec->lru_lock);
+			lruvec_unlock_irq(lruvec);
 		}
 
 		cond_resched();
@@ -3993,7 +3993,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	if (seq < READ_ONCE(lrugen->max_seq))
 		return false;
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 
@@ -4008,7 +4008,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 		if (inc_min_seq(lruvec, type, swappiness))
 			continue;
 
-		spin_unlock_irq(&lruvec->lru_lock);
+		lruvec_unlock_irq(lruvec);
 		cond_resched();
 		goto restart;
 	}
@@ -4043,7 +4043,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
 unlock:
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	return success;
 }
@@ -4739,7 +4739,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
 
@@ -4748,7 +4748,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
 		scanned = 0;
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	if (list_empty(&list))
 		return scanned;
@@ -4786,9 +4786,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
 		walk->lruvec = lruvec;
-		spin_lock_irq(&lruvec->lru_lock);
+		lruvec_lock_irq(lruvec);
 		reset_batch_size(walk);
-		spin_unlock_irq(&lruvec->lru_lock);
+		lruvec_unlock_irq(lruvec);
 	}
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
@@ -5226,7 +5226,7 @@ static void lru_gen_change_state(bool enabled)
 		for_each_node(nid) {
 			struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec_lock_irq(lruvec);
 
 			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 			VM_WARN_ON_ONCE(!state_is_valid(lruvec));
@@ -5234,12 +5234,12 @@ static void lru_gen_change_state(bool enabled)
 			lruvec->lrugen.enabled = enabled;
 
 			while (!(enabled ? fill_evictable(lruvec) : drain_evictable(lruvec))) {
-				spin_unlock_irq(&lruvec->lru_lock);
+				lruvec_unlock_irq(lruvec);
 				cond_resched();
-				spin_lock_irq(&lruvec->lru_lock);
+				lruvec_lock_irq(lruvec);
 			}
 
-			spin_unlock_irq(&lruvec->lru_lock);
+			lruvec_unlock_irq(lruvec);
 		}
 
 		cond_resched();
-- 
2.20.1


