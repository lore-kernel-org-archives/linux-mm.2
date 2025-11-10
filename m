Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E4E7CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 23:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8AD68E000D; Mon, 10 Nov 2025 18:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A626A8E0003; Mon, 10 Nov 2025 18:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F688E000D; Mon, 10 Nov 2025 18:21:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89D7A8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:21:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 080CC1402F0
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:21:22 +0000 (UTC)
X-FDA: 84096270804.14.78E3205
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3CCDD12000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:21:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X4c+7Vyx;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762816880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lysW96W1EmnFFHlgmtNEYrJza4enbLaPzVpDvxDjGNQ=;
	b=fyYo/j6TAEfkF/Q9fWzdxYHgPdien8rsDlx4q7gcg/31L0pmx/HjpiFOt5zErD5eyw4q+m
	Ly8X+dQ6Oh+iZgYUnfqwvtuEP3jxXNq1hBpt8mPT16E8dFcbY0wE5Wba/qNxuLU3XlFaw7
	5PA6A1/dEgUKpp1acNgyJfLTbj1ZSZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762816880; a=rsa-sha256;
	cv=none;
	b=J8ppC78movYIyzC3aBugd174gPHauHKNBjkgcEAmZU4oqTD+3KzfGybODoYX8/CgS15m51
	0vR2zY4M5eKVpjja9C4ieGeT/jam0fzUoardmyAT/jfLz8IwqGt0GfWXGFsy0+VxEX2iju
	XGX5e3iL6Q6OgXBE3vh1LmGQ5dTyWT0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X4c+7Vyx;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762816877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lysW96W1EmnFFHlgmtNEYrJza4enbLaPzVpDvxDjGNQ=;
	b=X4c+7VyxY6HfvIJvlc94nZqVXjd6UGao/+wY3ZSW8aRNNVfIQBFkDBtQKgi0EPUX+AOmpz
	EyOywj6kMmJdY5bFDCW/9ay/25AgeaRzgBZ4JO5btKLtAfePuPV9Jl8k3tMg/1RhpW9y9R
	WSJR52Vcc1McW39v0PLZZvvceHO1+0c=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH 3/4] memcg: remove __mod_lruvec_state
Date: Mon, 10 Nov 2025 15:20:07 -0800
Message-ID: <20251110232008.1352063-4-shakeel.butt@linux.dev>
In-Reply-To: <20251110232008.1352063-1-shakeel.butt@linux.dev>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3CCDD12000A
X-Stat-Signature: 33hfu6z77rguks3re18j848nz5ma7ygr
X-Rspam-User: 
X-HE-Tag: 1762816879-548712
X-HE-Meta: U2FsdGVkX18+nAqeufrKCvhfqG9eH9Hnh5PTu3PaaqvOe6oOJcQg8LcbN3Algqmf9PJkcoWb3STDMvh0W6OoQVxI1BwS5CS2qHdrVjRiUXiNJtIAIeg9IgHgB7R2/Dpt9YccTv2fOyB+W+XaaaGsUDjxDiAA6JlKidIr3O14U9+UTCWxzZ3tEZM+VOHvFwmNKufJZWuaiEuGINz3kKjDYqbrVoA3iMasUwNC2dT0zj1FEB5DpqgwqF9ya9MQ/C+pVRAfF2njeyr3Wmb4HpmnMQRzO4qA9mABIW3F0FDKT+r2UiEsa3x8JwxxAZmPmx3rY9S1YPviiEeznz3pwPkC0YMhBJ38RVm8Zt6Ob0y+1ZcOKbXZMkusiHUaVcckS4zOnKT8tB9hwrd94zREnXiAfDXTLMjD4xISlDdaGOSiM1zaT7JX1QjDmHYtT5rXAU0JDDQLbBi8FOuHXSjoAzLAmPc+yPawSCmoziFbivCZXNfmTkA7YO9ALJON4qC1Dt6sBWAWY1tAzDM6+MHijEnUoB7qhU0yzEvqBK1axc6+GXwux3CM2vqcLD0uYwI+bvULMpHxl8Qe0lh3c5kBemN9VihC1O/DGjZkiNqwX1ZViugLlHzOTzfYwKhf41xG/u2/srcbGfFDHUDemUeDU/8dnbFjlexIiYcWxY1ykm1BNwXJv/NW8poAhvFwrjsrbgLzN/Ej/fixHG8n24sNUyrTqi8SnDZiDMYcq3pxo3Q3pqTjOV3hYACMHzq1JNnr8K1dqZnWycFwFXXSsZWt7H3fsBucLqf8dudYsAaAHqzaSJXYaNIZEG4LQagnHKCe3Uu6T7uRQiRqoxbhz/TvueUjrTHADJyxiVaje4E+E7U4QeMA2MFGZ5kYcxriYnV6ItYJogj9jyhu7zg+K7/HPmcOtr64+Mq1Emg2wGPqYESgGd1HNkktVUCjxaM78m5ZDSfMCWru3Q/VYr/Coz0QD/J
 uWDETeHL
 kjCyFjmlXGKHaMPfAoStAIwCwrZUCJVQ+zvQTYW54EQoK9i8mFa0b68WdfQo+3w5howjOIycQfCzi+rbCpyqAEw67rjcCSJPDwiLfbumPClkHLy4OWtuKJZIM9wAFpFnmtN7pPZzBjun0IglWiKV0Nmtc00tITfDKc0wTtl1FhfAt3pwoK1m8mTL4p1B9iurFE91IOB0gwj2i2pfZ5EZFeZTSHzCngVT9fn3EIHGcJyIkmUPDQ3EEzlJpv3AKKrruMV+qIpul9S5ZOXxSwCphaWj2RBogJBEVYCLR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The __mod_lruvec_state is already safe against irqs, so there is no
need to have a separate interface (i.e. mod_lruvec_state) which
wraps calls to it with irq disabling and reenabling. Let's rename
__mod_lruvec_state to mod_lruvec_state.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/mm_inline.h |  2 +-
 include/linux/vmstat.h    | 18 +-----------------
 mm/memcontrol.c           |  8 ++++----
 mm/migrate.c              | 20 ++++++++++----------
 mm/vmscan.c               |  4 ++--
 5 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 795b255abf65..d7b963255012 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -44,7 +44,7 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
-	__mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 11a37aaa4dd9..4eb7753e6e5c 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -520,19 +520,9 @@ static inline const char *vm_event_name(enum vm_event_item item)
 
 #ifdef CONFIG_MEMCG
 
-void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 
-static inline void mod_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx, int val)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__mod_lruvec_state(lruvec, idx, val);
-	local_irq_restore(flags);
-}
-
 void __lruvec_stat_mod_folio(struct folio *folio,
 			     enum node_stat_item idx, int val);
 
@@ -554,12 +544,6 @@ static inline void mod_lruvec_page_state(struct page *page,
 
 #else
 
-static inline void __mod_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx, int val)
-{
-	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
-}
-
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3a59d3ee92a7..c31074e5852b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -757,7 +757,7 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 }
 
 /**
- * __mod_lruvec_state - update lruvec memory statistics
+ * mod_lruvec_state - update lruvec memory statistics
  * @lruvec: the lruvec
  * @idx: the stat item
  * @val: delta to add to the counter, can be negative
@@ -766,7 +766,7 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
  * function updates the all three counters that are affected by a
  * change of state at this level: per-node, per-cgroup, per-lruvec.
  */
-void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val)
 {
 	/* Update node */
@@ -794,7 +794,7 @@ void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 	}
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	__mod_lruvec_state(lruvec, idx, val);
+	mod_lruvec_state(lruvec, idx, val);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(__lruvec_stat_mod_folio);
@@ -818,7 +818,7 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 		mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		__mod_lruvec_state(lruvec, idx, val);
+		mod_lruvec_state(lruvec, idx, val);
 	}
 	rcu_read_unlock();
 }
diff --git a/mm/migrate.c b/mm/migrate.c
index 567dfae4d9f8..be00c3c82f3a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -675,27 +675,27 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
 
-		__mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
-		__mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
+		mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
+		mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
 		if (folio_test_swapbacked(folio) && !folio_test_swapcache(folio)) {
-			__mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
-			__mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
+			mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
+			mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
 
 			if (folio_test_pmd_mappable(folio)) {
-				__mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
-				__mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
+				mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
+				mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
 			}
 		}
 #ifdef CONFIG_SWAP
 		if (folio_test_swapcache(folio)) {
-			__mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
-			__mod_lruvec_state(new_lruvec, NR_SWAPCACHE, nr);
+			mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
+			mod_lruvec_state(new_lruvec, NR_SWAPCACHE, nr);
 		}
 #endif
 		if (dirty && mapping_can_writeback(mapping)) {
-			__mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
+			mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
 			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr);
-			__mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
+			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
 			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
 	}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ba760072830b..b3231bdde4e6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2019,7 +2019,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	spin_lock_irq(&lruvec->lru_lock);
 	move_folios_to_lru(lruvec, &folio_list);
 
-	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
+	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
@@ -4745,7 +4745,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		reset_batch_size(walk);
 	}
 
-	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
+	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
 
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
-- 
2.47.3


