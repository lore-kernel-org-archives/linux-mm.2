Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA24E91290
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B662F6B00BD; Thu,  5 Feb 2026 04:04:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A916B00BF; Thu,  5 Feb 2026 04:04:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25EC6B00C0; Thu,  5 Feb 2026 04:04:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91A6E6B00BD
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:04:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D742B920D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:29 +0000 (UTC)
X-FDA: 84409817058.18.7A4AFE4
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id A625A14000B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ge7ayrB/";
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ls+hag+nayM3jVEUHM7mMc/ZdZhfxjGBqG8YziQOeV0=;
	b=0ci9GXjKXlcAS+zMh+jiMPHP9JruIyHGvkT3KrRWAtk7zAb1bVpAjKpWT68rvb4AIbID3I
	3ekA2LVzaRNbzRNzXKzPtFPRz9JjlSC+lTAlWyb+W9gp49SkO9g8beiSjZ4T8F8ZotPOHl
	x2yu3O13vvVQAY23TBJGcK+VmjbpQzg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ge7ayrB/";
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282267; a=rsa-sha256;
	cv=none;
	b=2WjuFuGAJAMLDhJgf+PtAphYmW3NNylU97PLObC1hP85UME/wsc3I90nk3gIOvvpakzb+J
	cMazDPQpnoA0IsVyB4HPU4n5URPvjNYHMF0ZbEy/BglyEdQDYCI8TFcdgWiJqTvCZ8/G7q
	5NyqLPeyVIIgv7UNbIz15Z785NtSxl8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ls+hag+nayM3jVEUHM7mMc/ZdZhfxjGBqG8YziQOeV0=;
	b=ge7ayrB/6XH5mXU0e0ui+Q+ALLtpaCYFheRfONVoZGF1Dts/2ae2rBNbgmYJUMGfTxq+WE
	zyvmBk3l8vjp2AsYA2kWMpu27/Bl/esjeTWjb9g9IKeYbgzJ4+br3wEdWxQG5NfbvRkc4c
	Uf7uIU+IORKfBbCi3dkcufr7hDlPdEM=
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
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 23/31] mm: do not open-code lruvec lock
Date: Thu,  5 Feb 2026 17:01:42 +0800
Message-ID: <679b1c28f5ee8f40911195d7984b287c5da39e05.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: d7oe7if6ycyk1tbekm91qg4gs347fffh
X-Rspamd-Queue-Id: A625A14000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770282267-102396
X-HE-Meta: U2FsdGVkX18pnSM1BsdG6wcgp1l64BsfiAqcEsCXRc7p1ndjUKT6ULA6EuEYJ8QVxa/k0q4M4Qyghlus2jEAbA1JuDJoxxEx+PKTBbuRDgahCR/mbYAgPlwbrewYNCXaXV0q1Rins6HBGRl2qcdeqCaPlFDa0LZumtGrFuIo4n4eF44QJU7pYHmjDK+Pt+EryRSbZjzORa5By9IwKHyuY5OqTim9OPFF5zk6MB6yLvS8zkF6gFSaK1pNH3jDKpbG2ISBEX45JQ/JmxUrRpce5XeG2L80imGiGplB2mAhRW+UEMDnaPR7KHhZVxoWid4rqssDFp9b4JuEeyABoG4aXvBGA9Cu+uz1PmAsR7o9JB1zUIcvvbxZCkIpE8N6amnjkSdsefeZTaH4WPsSHMQX/YN18fQhOLSU+RGM+97AK2zdsUEsx7+dvPIlZp1UhgKVHp2mgloGacSa0+Xq1usDeMYZ4whrWxOKtGMip0vGQyAW/aHHV+zI08gNiltuOEdVhVC8TaVKBeXzhJnjaO74LeP2FVaI2ytEbKd0EAL8VG5xjk6DHDb0XR8FiAXSNCBGMVwD1mG9rx4LBMju4j0qvnfVvoxraGp9CCFb2x2H3VngC6M9v/I/er8CfI6k8npWk8qWhRnnck5qIEXnDHrR5TsCg/pAjmaHFQk2lxGfz4UTyqBWFUp9Qdg6w/ns7WzvyXzbYzUwD6eyLPaNTJh4cQL8RGQAFObR6+q0cceRKvmahVToLYkc9O+ZNG3hFBWWKC05GkXuTaeNa+xfmlfUm8oe2QNYpanY/XdMAP2BrTAd+xl/vpS1buGIml7pNGOjaaA2/nS7dXBTuBQ0kzFOsdgexruOKgy4vrU+Z7NKkSd2okcjPDFVqdwhnRB+WXv6TpdTvFXXUSXdhLUiR3H01QZ5REDu3uFf96xNAdJyiBtjLk42SNIcaIKaFJBpMZhYFvOiYLr1+Dcy7oAdbEF
 8PP4uiid
 m5xLGc+4aebaJlmXozmawZ/UdVonu1ix4Jijx26rDWZEtfv8Tj//1yWOUDmZNJUX9v8OklDBJCWDHNXJnJPYnvwlqeEZAHkMuHj15LNw3gFmtoUW+ecdexii0qifqZ9Sy+H1k6XnMc448ut/Uqu+wyyvg9yYra9Wf0EguupLMnLbwuHBmLojBjlU8JkmIpVAHJV4CnbbAhoS6eDVuFkCqgMsP0Lr7Bey9vxh8kCCRa2wBFW0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 6a7eacd39bc5f..f904231e33ec0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2003,7 +2003,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	lru_add_drain();
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list,
 				     &nr_scanned, sc, lru);
@@ -2015,7 +2015,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
 	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	if (nr_taken == 0)
 		return 0;
@@ -2034,7 +2034,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
 
@@ -2113,7 +2113,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 	lru_add_drain();
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold,
 				     &nr_scanned, sc, lru);
@@ -2124,7 +2124,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 		__count_vm_events(PGREFILL, nr_scanned);
 	count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	while (!list_empty(&l_hold)) {
 		struct folio *folio;
@@ -2180,7 +2180,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
@@ -3801,9 +3801,9 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 		}
 
 		if (walk->batched) {
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec_lock_irq(lruvec);
 			reset_batch_size(walk);
-			spin_unlock_irq(&lruvec->lru_lock);
+			lruvec_unlock_irq(lruvec);
 		}
 
 		cond_resched();
@@ -3962,7 +3962,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	if (seq < READ_ONCE(lrugen->max_seq))
 		return false;
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 
@@ -3977,7 +3977,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 		if (inc_min_seq(lruvec, type, swappiness))
 			continue;
 
-		spin_unlock_irq(&lruvec->lru_lock);
+		lruvec_unlock_irq(lruvec);
 		cond_resched();
 		goto restart;
 	}
@@ -4012,7 +4012,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
 unlock:
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	return success;
 }
@@ -4708,7 +4708,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	spin_lock_irq(&lruvec->lru_lock);
+	lruvec_lock_irq(lruvec);
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
 
@@ -4717,7 +4717,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
 		scanned = 0;
 
-	spin_unlock_irq(&lruvec->lru_lock);
+	lruvec_unlock_irq(lruvec);
 
 	if (list_empty(&list))
 		return scanned;
@@ -4755,9 +4755,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -5195,7 +5195,7 @@ static void lru_gen_change_state(bool enabled)
 		for_each_node(nid) {
 			struct lruvec *lruvec = get_lruvec(memcg, nid);
 
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec_lock_irq(lruvec);
 
 			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 			VM_WARN_ON_ONCE(!state_is_valid(lruvec));
@@ -5203,12 +5203,12 @@ static void lru_gen_change_state(bool enabled)
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


