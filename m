Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4458CF30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9677F6B00BD; Thu,  5 Mar 2026 06:58:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B8E6B00BE; Thu,  5 Mar 2026 06:58:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830D86B00BF; Thu,  5 Mar 2026 06:58:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 714BA6B00BD
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:58:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 392DE13B2C3
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:58:14 +0000 (UTC)
X-FDA: 84511861308.30.77FD926
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7A41014000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:58:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ujqCsOj+;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTdOluh/9ylRlwKeMfFMFMRs1I9w1KAVDyJhidoOplQ=;
	b=3MYHUmy1QHJTa2q9fDfB/45C0zUyDh11IsDe7AoJWW7RRxI3uel3QAnlvhi1tFo0AFOmCz
	wQN/xW63/ajnQq8eCNjyBMLNXHYU8x3vu0iUjEG/qUSPxcKQofBQbCV0QHKc+75sMPqg6G
	F4354cO7Yy8DEFlN2ZcTOQsmZ3jqNNg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ujqCsOj+;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711892; a=rsa-sha256;
	cv=none;
	b=WP3qlXstkoi54UhaA0aYlpypqK+tKwRKMWCr3vDfA+yNcYAu25e9gTUEM7bEi3A8A2cUqC
	Zux0jut9HPSftjhzmZsKLKIpgfi3jyGwCjzoTE69P1MxktJHaQVcJC1ppMc/5pKAnC4nLG
	g0PGw4NBiuhCD0OJ2qMNqrGE1VfoYKI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTdOluh/9ylRlwKeMfFMFMRs1I9w1KAVDyJhidoOplQ=;
	b=ujqCsOj+84waaPYa2xYnno8KBb/Qm+dSd/c6JqZOkI6RM+gFwqp6n2JuRJqkK1rcXXat4H
	XjgzQd8S7LX3qY7gbhceVX88qiX6+EqxKpZnCPnBj5ocrSlYGlx22GDbCpMj1ZDk1S27TU
	fDyhVT+ARwZLcmddSa0x3SdCYBNT9VQ=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 23/33] mm: do not open-code lruvec lock
Date: Thu,  5 Mar 2026 19:52:41 +0800
Message-ID: <2d0bafe7564e17ece46dfd58197af22ce57017dc.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7A41014000B
X-Stat-Signature: g8nkjrsyiij4gz1tefirwpt8qmeq7aud
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772711892-128428
X-HE-Meta: U2FsdGVkX1/a8hSKVfLH4RVIaRF5gn73FNCTuE2y0nuhFLEAOzAnas5b/FyhALzokHm2eEoX6tO6H1OJb3b+MptylmySahQK6LHCuHymqItGVccVZx7yELDAUgMyMdHOUnGdG4LACgpTU9mZvSzOIpR6rfXMz4Z0rI2tuuSZr9JD3o97jwdd8IrC3KPErwd+E/YT9wgJDL6mQlz3dnQyw6jGmznch+/g9gXx6PraOl4+31uOgsZvHPzfvgo/c0DWJPkvLMAxn5pAbk0hCrWESDp+VMYEKmfbjokA1ln5njWuwdvRg9E2zTGLpo9nGK9di6XNlxdwpbSg8OKZA2QV2vmk5/6/JeCyEd5sO1b5POPuDYeQxoYkWVlDTTHpIZ7h9sKTIOGBitFXYJCzGTpbndnM7zfT53OLQGzsE9rziqHZffb88U4dYhf1l67bkjUpzGaVNxiMxDSB7cJd7Q/Pelb0b/yrnWIdh6bbTpXMptDpjPg5VsiRXUxji3mX6daiEnNdyYq6cM2VM2p4vROaKGtJvbPqXJ0JN0gjGrYwluimGCiCjatfy5VmLUuygsSxzhk+eirwwpNKLh7hAWUbpzeEPWZl3VCaSMBy4VIrpnipxekkSG/rwM0E7EODVER/dauGOFQ4k9vJQgwJjVhXLS+jvlYiKavegdlxS1gI0+O8fQIqKBbL8A2VJvwiOy2IOt8o9jiW2LfiM0ciZSOM3ju8gyoECogUT7KjL7eJfE/RFauycJsD6c7VUX5oE9bH/0BnrCF+6x2LrjxkXiXw4BQjh+2Qw5Yb7YDUYVvJCSKATG0vlz1EIIOBtsuPmo9TbuR6hQPhktewjm3t0z6EMIHlZM6+IYXhDggTzL2gK/6lXATMBNNGZyxwH+Cvpe3vw6ZGZWYAKdnse91WrndSqwFm51sYjfHy53T89ClEnW2aZdoXOP+C97w1vS+NcsL03h9tsBUG8F5UYesJ/Ic
 dqW7CwVT
 A9WJeODDjyG069G7K6UGK9rBVEAfpXAop5nTeDdxgAAtKsPiszBbhQ1su3h84LxjgRMzFINmnJ9UnoKMw2tAL8og4bXlixT8TzrJPg0kPVywXv2/3s7aFN1L8xlMhrCfNdeeaFe1PgqEwonrhSHuCvMaaO2s0A8o9nAlIM1eQir/SAn2dAUA0WEWVI32XFK5kCwOobV4XjNodpEpkYy7Xx37cUU6LOo/4Lr0q1enuxPD8vVw4Q4m4iwaoYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Now we have lruvec_unlock(), lruvec_unlock_irq() and
lruvec_unlock_irqrestore(), but no the paired lruvec_lock(),
lruvec_lock_irq() and lruvec_lock_irqsave().

There is currently no use case for lruvec_lock_irqsave(), so only
introduce lruvec_lock_irq(), and change all open-code places to use
this helper function. This looks cleaner and prepares for reparenting
LRU pages, preventing user from missing RCU lock calls due to
open-code lruvec lock.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/memcontrol.h |  5 +++++
 mm/vmscan.c                | 38 +++++++++++++++++++-------------------
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0fdfb8044458e..c7c207a830c50 100644
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
index 024ff870b1a03..08ed278115f70 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2002,7 +2002,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	lru_add_drain();
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list,
 				     &nr_scanned, sc, lru);
@@ -2012,7 +2012,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	mod_lruvec_state(lruvec, item, nr_scanned);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + file, nr_scanned);
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	if (nr_taken == 0)
 		return 0;
@@ -2029,7 +2029,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
 
@@ -2108,7 +2108,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 	lru_add_drain();
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold,
 				     &nr_scanned, sc, lru);
@@ -2117,7 +2117,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 	mod_lruvec_state(lruvec, PGREFILL, nr_scanned);
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	while (!list_empty(&l_hold)) {
 		struct folio *folio;
@@ -2173,7 +2173,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
@@ -3794,9 +3794,9 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 		}
 
 		if (walk->batched) {
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec_lock_irq(lruvec);
 			reset_batch_size(walk);
-			spin_unlock_irq(&lruvec->lru_lock);
+			lruvec_unlock_irq(lruvec);
 		}
 
 		cond_resched();
@@ -3956,7 +3956,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	if (seq < READ_ONCE(lrugen->max_seq))
 		return false;
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 
@@ -3971,7 +3971,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 		if (inc_min_seq(lruvec, type, swappiness))
 			continue;
 
-		spin_unlock_irq(&lruvec->lru_lock);
+		lruvec_unlock_irq(lruvec);
 		cond_resched();
 		goto restart;
 	}
@@ -4006,7 +4006,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
 unlock:
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	return success;
 }
@@ -4697,7 +4697,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
 
@@ -4706,7 +4706,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
 		scanned = 0;
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	if (list_empty(&list))
 		return scanned;
@@ -4744,9 +4744,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -5178,7 +5178,7 @@ static void lru_gen_change_state(bool enabled)
 		for_each_node(nid) {
 			struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec_lock_irq(lruvec);
 
 			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 			VM_WARN_ON_ONCE(!state_is_valid(lruvec));
@@ -5186,12 +5186,12 @@ static void lru_gen_change_state(bool enabled)
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


