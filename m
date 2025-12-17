Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA99D64086
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8E06B008A; Wed, 17 Dec 2025 02:29:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2666B0095; Wed, 17 Dec 2025 02:29:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2946B0096; Wed, 17 Dec 2025 02:29:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA3E06B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:29:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8903A160917
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:29:46 +0000 (UTC)
X-FDA: 84228138372.07.6C57BAF
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 92310A000F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:29:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G49xQSCD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956584; a=rsa-sha256;
	cv=none;
	b=L5xRlzyFjhRAxhlSVXU087VQrq1L0cSG2j4XrBYJR0HvGSjxI6ShIffRPM19aCPjhQ+4u1
	NWHySS20t/RdwdqmUc63PFnOHUzER1RpUsIplMkgXZYXLoXEulJkov1pnwm71IHJoZ4Ryy
	yPeX35aF/Jd++9T5aDzPs9tVdxWhxtU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G49xQSCD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0OheEBAXk7XPYwqSkJ0Le26eixYKExsbR31tbstIws=;
	b=mAMC/YnUmTITuddrm/317LIp7NpIfVtvQxmDzEd2p+apMqGrBnyeexu+W7VkafXD7/iony
	Iqu59b5/ddufmaOkkrLLRTrpCDkTxDAMCz+gzMOGbE8+Aus1KCibQd2jrcKpek/yvXd1nZ
	XDwHTFeseTmz38cd+XJd0AZEcBklEBM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q0OheEBAXk7XPYwqSkJ0Le26eixYKExsbR31tbstIws=;
	b=G49xQSCDDpZAppo/wZsDsqQWibcEkNZSb7m2ERxT7qti7MrBuU10SmnxCYBc+WUIHf4TCS
	iMR8QuBNfphzQC4ptasTWFpd/SM2MIr5k84EuasV7jJsBHSTrlV0TZPz/uS0quxKVuaEio
	Rs436+PJI9YW/vq4R6xRXGnOPF2R2A4=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 05/28] mm: vmscan: refactor move_folios_to_lru()
Date: Wed, 17 Dec 2025 15:27:29 +0800
Message-ID: <0140f3b290fd259d58e11f86f1f04f732e8096f1.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 92310A000F
X-Rspamd-Server: rspam03
X-Stat-Signature: asdg4ti4xhhy6njohtc483tmgipmq9n3
X-Rspam-User: 
X-HE-Tag: 1765956584-743404
X-HE-Meta: U2FsdGVkX18U/kzcL5FPx/FH+vqqs4SeS7kW485aE6iBmG30Q+LyBf3avSek/O+JJxx8NshnRO/i0uWybTYzMwCC9KqqkyzwByV8cEiM19Ty1wvLpm/bBXSzlnmp9KS9B9zzSc/LVtttb679P6YMmXtHD2rPuwGjcjOlVZHumSg4ghbqfyxn3UsZxoO3LpVuPWC2WmB6JYMfMXjg7gt/fttbFDmhIgfIhDFLHC6yNKG8p4MFnBGBylykiSTmltDDBBzX1Wk8i0J45YPYXO45JECx2YqoHg4yq/ewllX4ZVqQGsFiX3KlYI/oaHOvMTa5qv2AogGBfJ2sVby4e+2xqabfzvU/zPf1mDENm46U9bH7nTczXxC5DPS7s/DExGf4HMA7101yNL3Bh0iXgv/awREeeX4yhebAIa7hUFI+R3rea3T4PO0qa1EVBfXadDOytlMDpaVBVk0Ms7+I8FxJ2ddeJI/GA6uCrM+Cg/r43HDgtVPPDAalT74PjRwAbn6kJ+JLGz7sURDU2Wcmv7GeYrrqCG8XQGcDuc9FyEVUhYGkRy4aF9XCLxJMSpk4hQlu0S3xiLjmFZ97pb0d0z6sFLzuuY5qmnRUKlfYwuRvqvG6A36I3uyBd36ZED53cCL8d7vs0eGMer8PvpFevdxxhSOFveZkZTagbWm3/GtrTnxoFvgZKFqaIMrBUjoOzCjr0ANj6Sn0X2zFwpFYLfg+aG23EPO3Z1mykUMtSFcLeIWqxVkpKoFQVVkMA7cVno/ShwTVkmk/iUYD26EDdCXtk+t0p6f5gMytNN24ybJhcgAZ/6Sq+VZSQs1x59ZaXnhpoMw5FMscuhu4LTBeMIGegA04HCf0Ds7yoig1xDjFMj0dOXDaNQ2KfagOqUJhKOSokOp/3tCURFt5cchNOl0fAfetZkVTgnmj6PStpLivTHmvcK5SUA9vMtKLUr7oEonocGNSSaRzWXy3cVADzB4
 b1gIdB9x
 mYnh64mbEehev9Ah1xaFFwHDYuTmYMYBPcLQO8zu+Ac3tTH+wcwlpAC/B4McnSyIHZDpfmhJoPydnZwARy0LLFK6Be5nkwMQU40bR1o0NTGFekjzdF/NgHD63aKt/hiutDjxB88D/m4USwI8FsWCaInaQ2EI15Yrj3eyq26boVFe2noagqzKLUzn8vHutYNguR4MXFpgJbgE9QmihV93XWVgU6HRYSAOHDxaY/WqrUYFPSeLrJ6/yRKqNrOhrR2knOaKsTqbR4b9BANKLehggBHlbyPj0zFGE3uGB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
---
 mm/vmscan.c | 46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 49e5661746213..354b19f7365d4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1883,24 +1883,27 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
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
 
@@ -1922,19 +1925,15 @@ static unsigned int move_folios_to_lru(struct lruvec *lruvec,
 
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
@@ -1943,11 +1942,12 @@ static unsigned int move_folios_to_lru(struct lruvec *lruvec,
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
@@ -2016,8 +2016,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	spin_lock_irq(&lruvec->lru_lock);
-	move_folios_to_lru(lruvec, &folio_list);
+	move_folios_to_lru(&folio_list);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2028,6 +2027,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 
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
@@ -4736,14 +4734,14 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
 	}
 
-	spin_lock_irq(&lruvec->lru_lock);
-
-	move_folios_to_lru(lruvec, &list);
+	move_folios_to_lru(&list);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
 		walk->lruvec = lruvec;
+		spin_lock(&lruvec->lru_lock);
 		reset_batch_size(walk);
+		spin_unlock(&lruvec->lru_lock);
 	}
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
@@ -4755,8 +4753,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	count_memcg_events(memcg, item, reclaimed);
 	count_vm_events(PGSTEAL_ANON + type, reclaimed);
 
-	spin_unlock_irq(&lruvec->lru_lock);
-
 	list_splice_init(&clean, &list);
 
 	if (!list_empty(&list)) {
-- 
2.20.1


