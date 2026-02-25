Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC071EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184BC6B0095; Wed, 25 Feb 2026 02:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C5D6B0096; Wed, 25 Feb 2026 02:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0724B6B0098; Wed, 25 Feb 2026 02:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E466F6B0095
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:50:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B129058D6C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:24 +0000 (UTC)
X-FDA: 84482206368.11.BF48EF2
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id 27B468000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:50:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=utLtwzTr;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=776a3yXyenvO+S9oFBjCtWS3YtcAt/IfBD8X6MP7Tkk=;
	b=XYvl6BFryjEsMzPdXxfYeMTRH0mIABxzHSDzP6mVvnk8lNYbd0FA+mvQx4bax4JtjMN6vZ
	SCCGXU8UK4Zxh3m60MEgAeo5aB8PphuiNDV2HCIpzrkOJ17Ec957T/wEd7ueYLg+oelP1+
	zxCWElFJM0gwg0xjI8l37FcanNiq9Lo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=utLtwzTr;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005823; a=rsa-sha256;
	cv=none;
	b=4yx8EuncEvcxjfC5lfot+L+uigODpc4+bhjOOlT9+9Y7YyAAX+woU6Wo8GrpbTRKUqav6b
	7s97GnCA4AyGbB3yEstCv5D8DaWEWqnDgjDtZ9B0kvGfA/lshxs3X/jFWHvvzfo0/3J9KD
	gtUVzu2MhmYO5J/K/vybUkeu3aUALNM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=776a3yXyenvO+S9oFBjCtWS3YtcAt/IfBD8X6MP7Tkk=;
	b=utLtwzTr3i6olwHUdGoyBR6/JfFqUQPZnypuGaakWQxNy4W+neVfwkE919k6yRwc6k7CSG
	2yNerGg1sgIts/FVJY8PsMJwpVlVySwHPFqFrebx+m8GQQrU326J7gfICIubwOZ6jR5+eB
	TmQcZCdA3oT+V8X6aSVo64OKqV03oYc=
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
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 05/32] mm: vmscan: refactor move_folios_to_lru()
Date: Wed, 25 Feb 2026 15:48:38 +0800
Message-ID: <6f1dac88b61e2e3cb7a3e90bacdf06b654acfc15.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 27B468000C
X-Stat-Signature: jg13kaowie68atz5zzuakim9qo1k83fe
X-HE-Tag: 1772005822-468852
X-HE-Meta: U2FsdGVkX1/7YDFsXyKBvyLPKVUTb+1WISBlJPY+grpbNCB0epzQ9tTPALt+TtoBLVV184Gs1ddvA6rjx4e89lnQr+wpw93UPuAjpDJ/f6wVVHJV/duuQLvQdWTGSHKe6IoVpm/ICXRf5rvjOB9l9waapcyYDz3H7Z7cykFr/moVGpN2raGZD045tSxTJ22yBxR/MABBJcMTP2yHKa/ftqQpJX4OAiZjHG/WxNrCs6cHDxGKV6/IjdoxABk0pUo0HBwIRxtb6kDRx8ePVUURP2q8JMFbcr7/WWaFEa9To69aAnZvQE4YiKE/mg847OV6K95Q0HDusVU2ZeCTIiBdHgc1NI+odG8GAyG8otKDLmig0rSsnhmKjUBd9dF13o155ZfcrdpHZXgkLIoohh2DIxLcfBIUcumX9qaKuInO3wRcxgzTwYhvWzLgoYxxc96LjqVRnN74+oGQN5W50WiccvRBSEAyiTs8nF0Fy1rXuzQ2LaEItLw/dpIRcefTZAvwY5FbvodCO024BSJelhaWJZz2erptStxp99ikrcvb0F2vA18Nbrm4PQxOT5HO0KdZIj8FLp9+s6OHx7WHPbNmxywcxLbkgslNnLnUJdvkQMnjwgQu9B7442jueMD6OTJqEaZhPGnhISBufrGOXnwlw4xTXHyNoSP3xDxCEXMhgYZsY/WeHWAHsUWdkvV7acw02h0uXwCwuQ/6OKKeYC63TEjhoSrh8EwQGxTl25uauT/OC0lkY4UmcZE5wJxLkY41lRvGDHHhcb5kn9CkbKutrNPD6z8SYNqW8DFw9FAB5d6K9UGeUXNaZmRT97h7UopcOtuHhe5WTt1VIIOtNyJY+AK9SKOvSKyvzzcppDQUZ3ToN9k4JwFbBflsD14ZBk0Gd5DHDecu3lZhhzc6Tt/u9v70dbiy+mO9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In a subsequent patch, we'll reparent the LRU folios. The folios that are
moved to the appropriate LRU list can undergo reparenting during the
move_folios_to_lru() process. Hence, it's incorrect for the caller to hold
a lruvec lock. Instead, we should utilize the more general interface of
folio_lruvec_relock_irq() to obtain the correct lruvec lock.

This patch involves only code refactoring and doesn't introduce any
functional changes.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/vmscan.c | 46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2a32dce8d8394..61303ec85d587 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1889,24 +1889,27 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
 /*
  * move_folios_to_lru() moves folios from private @list to appropriate LRU list.
  *
- * Returns the number of pages moved to the given lruvec.
+ * Returns the number of pages moved to the appropriate lruvec.
+ *
+ * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_folios_to_lru(struct lruvec *lruvec,
-		struct list_head *list)
+static unsigned int move_folios_to_lru(struct list_head *list)
 {
 	int nr_pages, nr_moved = 0;
+	struct lruvec *lruvec = NULL;
 	struct folio_batch free_folios;
 
 	folio_batch_init(&free_folios);
 	while (!list_empty(list)) {
 		struct folio *folio = lru_to_folio(list);
 
+		lruvec = folio_lruvec_relock_irq(folio, lruvec);
 		VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 		list_del(&folio->lru);
 		if (unlikely(!folio_evictable(folio))) {
-			spin_unlock_irq(&lruvec->lru_lock);
+			lruvec_unlock_irq(lruvec);
 			folio_putback_lru(folio);
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec = NULL;
 			continue;
 		}
 
@@ -1928,19 +1931,15 @@ static unsigned int move_folios_to_lru(struct lruvec *lruvec,
 
 			folio_unqueue_deferred_split(folio);
 			if (folio_batch_add(&free_folios, folio) == 0) {
-				spin_unlock_irq(&lruvec->lru_lock);
+				lruvec_unlock_irq(lruvec);
 				mem_cgroup_uncharge_folios(&free_folios);
 				free_unref_folios(&free_folios);
-				spin_lock_irq(&lruvec->lru_lock);
+				lruvec = NULL;
 			}
 
 			continue;
 		}
 
-		/*
-		 * All pages were isolated from the same lruvec (and isolation
-		 * inhibits memcg migration).
-		 */
 		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
@@ -1949,11 +1948,12 @@ static unsigned int move_folios_to_lru(struct lruvec *lruvec,
 			workingset_age_nonresident(lruvec, nr_pages);
 	}
 
+	if (lruvec)
+		lruvec_unlock_irq(lruvec);
+
 	if (free_folios.nr) {
-		spin_unlock_irq(&lruvec->lru_lock);
 		mem_cgroup_uncharge_folios(&free_folios);
 		free_unref_folios(&free_folios);
-		spin_lock_irq(&lruvec->lru_lock);
 	}
 
 	return nr_moved;
@@ -2020,8 +2020,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	spin_lock_irq(&lruvec->lru_lock);
-	move_folios_to_lru(lruvec, &folio_list);
+	move_folios_to_lru(&folio_list);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2030,6 +2029,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
 
+	spin_lock_irq(&lruvec->lru_lock);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
 
@@ -2166,16 +2166,14 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	spin_lock_irq(&lruvec->lru_lock);
-
-	nr_activate = move_folios_to_lru(lruvec, &l_active);
-	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
+	nr_activate = move_folios_to_lru(&l_active);
+	nr_deactivate = move_folios_to_lru(&l_inactive);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
-
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
+	spin_lock_irq(&lruvec->lru_lock);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
@@ -4731,14 +4729,14 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
 	}
 
-	spin_lock_irq(&lruvec->lru_lock);
-
-	move_folios_to_lru(lruvec, &list);
+	move_folios_to_lru(&list);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
 		walk->lruvec = lruvec;
+		spin_lock_irq(&lruvec->lru_lock);
 		reset_batch_size(walk);
+		spin_unlock_irq(&lruvec->lru_lock);
 	}
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
@@ -4748,8 +4746,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	mod_lruvec_state(lruvec, item, reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + type, reclaimed);
 
-	spin_unlock_irq(&lruvec->lru_lock);
-
 	list_splice_init(&clean, &list);
 
 	if (!list_empty(&list)) {
-- 
2.20.1


