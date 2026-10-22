Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5B1606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VzDfR6OR
Received: by kanga.kvack.org (Postfix)
	id A73F26B09DD; Thu, 22 Oct 2026 18:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B566B09DE; Thu, 22 Oct 2026 18:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961456B09DF; Thu, 22 Oct 2026 18:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7BB6B09DD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:02:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47564A7BCA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:41 +0000 (UTC)
X-FDA: 85351637322.11.B4C200D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 214EE2000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzDfR6OR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9+3sLxZCw5Ski2B87sWd7DjW86k/wfvF35Fe6Q48wI=;
	b=phBvOSJLsjEEeOgSngj9T2f9yXy1DcIlrSTDoLBS1Kyff1/niKc2/V6HRbTfa8px4hpIYo
	4X0mpS+gmRtImVpf9zTIfTkLAR3EG8n4W4XxqUYHSxfWKCrhBxOb+SOj60TvSi6x/nyAiJ
	Xl36zg7H/Rs7v9FqKs5LSZxTJtdRPz0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzDfR6OR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706559;
	b=h5gW9kzPKltZn8RIUuL5yiGaS4CErjw6PdPoexgviqn04ncBmO/xwrolZ8PozBqRFwqtbF
	RbTuF/DPM3M125F5/yT6VuzjDbpNEk882bMuDKRWn5uKSmHJ+LcXKuhn5y+RIGpybeDrcr
	g6QjdcMN8jvEpygz5IN1Z1PPfbhA0Og=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52EB960233;
	Thu, 22 Oct 2026 22:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFA61F031E1;
	Thu, 22 Oct 2026 22:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706559;
	bh=E9+3sLxZCw5Ski2B87sWd7DjW86k/wfvF35Fe6Q48wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VzDfR6ORZzpYBVCmwKBU/amT+u9+7yQ3f9//NyPPH7uOdGDreEAmU86iCwYAn8NO6
	 Xeus9hNTB2w+PZPNP9jLXpXhycjci6mibTmx+Q5yA61DljK7hUaXAGEdtY4vWQxaUj
	 SJxrIRqXiQAr2by+4R3PfYoll96o/qBIXUbk0Ems1sER436qgXDMtFxjwkoF4KprXX
	 oJZGc24pi0nu2PeqVi8/VfKY2uI+N32jFA7j60EHW44VGfIs+PQHRZZt0biklTDFlh
	 x14OWp2IbJx795B5FYf08ai7pcS9NQ2vAaWand5/yyk/PYp0cAJ9NpByjKT8xAAdr2
	 x/JX0Kb4hguXg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 05/14] mm/mglru: skip zones above reclaim_idx instead of rotating them
Date: Fri, 23 Oct 2026 06:01:54 +0800
Message-Id: <20261022220203.91911-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 214EE2000C
X-Stat-Signature: 9ipi8yg1r9xdbuxn9dke69yywf8wiuyh
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792706559-132772
X-HE-Meta: U2FsdGVkX1/prObIUEBVbXeibuvTZVnBPjjA/9DSwU2udbwa8d+IkZJFKVb4PWu0aCpcZTtH72n7pso1s4Z+CcqCpAv4F2CWV1IHyK05jEQZAMo6RP7wQYOHZmHwpWqCute6cRJDt3lDTHgbgiwM7CzS+OK4Yb4IwkBSWgdJrairTuo3/S0Lfj2BdCac/viefp7IZP2dfYOKq/yRBdaI7We7LOWJbprBvJhjzUigaEILZAuCLN9B/oMwh73lZEcqVUoqnlz6s0G5Mk4Lhvc4fBE1Hv3sq6w1SmnhX5uwiOq83dBY8dMYbkDCUNcLNEAuX4yoegEyNGPguFY5+iiIx+fpR3sz4jW8gnGEEboWlWfIbk9/3tnE6IJQNkm47MuNJ6yZdQDQbhR7r8Ub/qJwD7Zz8s6MYRAwwLSaaJudD67gk1ZdswYUcIIzRyXjLQ1dNJ8WHQmgQPEJaTx72Y6bLirpVYI1evfIzYQqvKFVmcqm+qh0m5Ep9Ad15GmiqmhYu1gs7iIgUPIN19hbJ07U+1FGuyInOEYabdtmZaX78iVGkJ940aYdHyDHrTFYFCM5EF8nsIylIzNQIQP/3e81SEaaoOq5xplBO4L9J8TXkfvEcNT7O3gfSHc1IFfeb7FywwGD2/Y3FwAINIIZswk4/9GYViTwvQjb1ANxq1Mk998QwStDnKjUHsynkCtcRLmXxDN8nhY9prmufggg4/l5o6BDNSQ3Cl1N0tsK+4fhNsHNQqWQt69DrWpqJCgTr/aTuXM7ZBNpa10lw4hsBJ/+OHMLTMqSLg+KUayK5HMrGqemnAOCfNikAoyfJSwaJ8vvPczsyV6GC4BPzt/5ApCO8mzjH6WdtBdWashqu+d8mFif89/SqFsTt5eiQPBjbbsN8mHST0acrYBwhzqrW73+EQSFiNllVwF19yHcXIvavaDpVGOpWD6GMgbaZevX7QCn1NIifZLL1HXYqeYbgPH
 l6AeLf8F
 9N6CJFFcsQFHSoeJxmuLXCb1NXwvgiJ6wdgwLfKIz/1Btr+VfmM5YSKCYg52xwtMITnh7anhi3CUBArpEdDV75OKgo/SqSKaiF0VoXH5qpflE0DMAfiNWAabXexvIngVGRvvqOfQlmP25c6Jj0aBOY2Lyx0/3ZhDdvmcWbc3pFrQL0+nNVl7wJLhTYQqRv6hCtPCFCe+kfv8Gb2HpzA868hKo4wvPQoqa+2N3GH4G0R/ZbolrSnPChQ4nR+zRFbZiEmK1xwI8UyRmos3hoBBa1ho8jawH5+FjGyTaB13eu5ksdWgfkcNt2QjxWgzb9cKGgcKKSuCWCSoQuXdorHKnxEGrZ5adEjviaw3UPBs+4zcy0kX2GMsquyYgz8SEm79Reg4a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

scan_folios() used to visit every zone. Folios in zones above
sc->reclaim_idx can never be isolated, so sort_folio() rotated them to
a younger generation, the "ineligible" branch, or, when only one gen
was left, skipped them. This wasted scan work on every pass, and the
rotation kept the protected folios from aging.

Restrict both the scan and the gen selection to the eligible zones,
like the legacy LRU, which only isolates folios in zones up to
reclaim_idx:

- lruvec_populated_min_seq() takes a zone_limit, so the oldest
  populated gen is searched only among the zones the scan can
  reclaim from. A gen populated only in protected zones no longer
  stalls the scan.
- scan_folios() iterates the eligible zones in the descending order
  of the legacy zonelist walk, draining the zone at reclaim_idx
  first.
- The ineligible branch of sort_folio() is now dead and removed,
  with a VM_WARN_ON_ONCE_FOLIO() guarding the new invariant.

try_to_inc_min_seq() still considers all zones, so min_seq[type] is
only bumped once the oldest gen is empty everywhere. At DEF_PRIORITY
the search bound stays min_seq[type], so the scan still starts from
the oldest gen regardless of whether it is populated.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 47 +++++++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2cccaa5dd4e7..d3caed8aa789 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4131,7 +4131,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 
 /* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
 static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
-					      unsigned long max_seq)
+					      int zone_limit, unsigned long max_seq)
 {
 	int gen, zone;
 	unsigned long min_seq;
@@ -4142,7 +4142,7 @@ static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
 	while (min_seq <= max_seq) {
 		gen = lru_gen_from_seq(min_seq);
-		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		for (zone = 0; zone < zone_limit; zone++) {
 			if (!list_empty(&lrugen->folios[gen][type][zone]))
 				return min_seq;
 		}
@@ -4165,7 +4165,7 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 	/* Requires at least MIN_NR_GENS gens for basic functionality */
 	seq = lrugen->max_seq - MIN_NR_GENS;
 	for_each_evictable_type(type, swappiness) {
-		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
+		min_seq[type] = lruvec_populated_min_seq(lruvec, type, MAX_NR_ZONES, seq + 1);
 		if (min_seq[type] > lrugen->min_seq[type])
 			seq_inc_flag = true;
 	}
@@ -4846,6 +4846,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
+	VM_WARN_ON_ONCE_FOLIO(zone > sc->reclaim_idx, folio);
 
 	/* unevictable: let it through and the generic path will cull it */
 	if (!folio_evictable(folio))
@@ -4862,10 +4863,8 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	 * longer be promoted or protected, so just isolate them. The one
 	 * exception is lru_gen_reparent_memcg(), which is handled above.
 	 */
-	if (min_gen == max_gen) {
-		VM_WARN_ON_ONCE(zone > sc->reclaim_idx);
+	if (min_gen == max_gen)
 		return false;
-	}
 
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
@@ -4882,13 +4881,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return true;
 	}
 
-	/* ineligible */
-	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio, min_gen);
-		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
-		return true;
-	}
-
 	return false;
 }
 
@@ -4920,16 +4912,17 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
 		       struct list_head *list, int *isolatedp)
 {
-	int i;
 	enum node_stat_item item;
+	int zone_idx;
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
 	int gen, max_gen;
-	unsigned long min_seq;
+	unsigned long seq;
 	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
 
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
@@ -4941,24 +4934,22 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	 * when under pressure to respect swappiness more and reduce IO cost.
 	 */
 	if (sc->priority == DEF_PRIORITY)
-		min_seq = lrugen->min_seq[type];
+		seq = lrugen->min_seq[type];
 	else
-		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq);
+		seq = lrugen->max_seq;
 
-	gen = lru_gen_from_seq(min_seq);
+	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+	gen = lru_gen_from_seq(seq);
 	max_gen = lru_gen_from_seq(max_seq);
 
-	for (i = MAX_NR_ZONES; i > 0; i--) {
+	/* Scan eligible zones in descending order. */
+	for (zone_idx = sc->reclaim_idx; zone_idx >= 0; zone_idx--) {
 		LIST_HEAD(moved);
 		int skipped_zone = 0;
-		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
-		struct list_head *head = &lrugen->folios[gen][type][zone];
+		struct zone *zone = &pgdat->node_zones[zone_idx];
+		struct list_head *head = &lrugen->folios[gen][type][zone_idx];
 
-		/*
-		 * If there is only one gen left, rotating the unreclaimable
-		 * zone become meaningless, just skip them.
-		 */
-		if (gen == max_gen && zone > sc->reclaim_idx)
+		if (!managed_zone(zone))
 			continue;
 
 		while (!list_empty(head)) {
@@ -4968,7 +4959,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
-			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
+			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone_idx, folio);
 
 			scanned += delta;
 			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
@@ -4987,7 +4978,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 		if (skipped_zone) {
 			list_splice(&moved, head);
-			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped_zone);
+			__count_zid_vm_events(PGSCAN_SKIP, zone_idx, skipped_zone);
 			skipped += skipped_zone;
 		}
 
-- 
2.34.1


