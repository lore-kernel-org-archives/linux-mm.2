Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62C596071056
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cEAr2HQs
Received: by kanga.kvack.org (Postfix)
	id 72C426B05C3; Fri, 13 Nov 2026 13:56:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703896B05C4; Fri, 13 Nov 2026 13:56:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB4D6B05C5; Fri, 13 Nov 2026 13:56:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35F816B05C3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B00D7C016F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:16 +0000 (UTC)
X-FDA: 85431001152.11.AED0F6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0927418000E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cEAr2HQs;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596175;
	b=hMyVxH+kOjc+0FXz9XQltvEOYNYcAN06601mBQuLbPHsuczQiU4op2KNLv8f6pFYwoBqIV
	JG2s920XptCvMAtXPSdDR5YR+MlBOc+sxShECeHZD4DM6ocUnXB909K9ozFsPsDgF6wWw9
	ECV61fx/1ZeIGo2Gjytmvync+FJOmk0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cEAr2HQs;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFBgz9a6PFaeiektq38l4AMQg2WGrNsoRVRJuqkI91Y=;
	b=aOhF5oEgJvm9HCQOI4ySGfSojR4m0hO6Oa1fxLK+WYYi/UeS/ktBCHyvEyUPbUXB0Kp/R+
	9WWV+tQ1h9J7zLNiJTTJT1K6nAfO2VsoKAxQQJumvGswhlPiqjRnkle9hjw3iE5kI+lQB3
	99HNXvHqkqyj9DfdtoA+9AwoWqS8GPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59E564008C;
	Fri, 13 Nov 2026 18:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B1A1F000C5;
	Fri, 13 Nov 2026 18:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596174;
	bh=CFBgz9a6PFaeiektq38l4AMQg2WGrNsoRVRJuqkI91Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEAr2HQsZ1HHjKxIxtST4/NiLm1Wyc+KIlItjQzOcfqY4hu5Up643evmj4GyrtiMS
	 Vmget5swEPwDuETHXtENzVK7cop367Y+vCrQRjVKr9/r6w5IPPj6Nu0t7iks9jB9xB
	 54lFYd8qrBvUvp/cFDJxeQYA8xMsQSm9QHU8+cM1JovcYqJBFxfd1aMDzzK57Q5xlK
	 +/mPscj9NRkLLkP+/OUqeAhkXINVdceKIv7zjqKTaSCLVtt3m0QQEoMswGKd++D3sl
	 XK2MDBNAb9E1FcpXxWMVQCsbkK56bTAu85pFBjaV0u2VjicjXs4eyiyObhBIL6tgUt
	 Vum8wnlpS71lg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v8 05/16] mm/mglru: skip zones above reclaim_idx instead of rotating them
Date: Sat, 14 Nov 2026 02:55:30 +0800
Message-Id: <20261113185541.70203-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a58aebpcksqshfn6ei6ekx6kyynz6b3t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0927418000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794596174-437897
X-HE-Meta: U2FsdGVkX1/A4RpnSHhfSqCY4+DHQC/IppFAdo24UsdsZMdC8q60H0MvwCD0y7ELTU1C/43yiIQ8hh+wYTGpi35V7m9yMZPnVrGUm+QwHDD5Zmy4sr4ZiN1YOh3mR1TevZrO4BvTfZSZ7V741j+mHq1zuwYnwu6oYZMps2rkpOYpS3j8oTXWuLCWdDyRfWMek52VNN1KXNrUHcfXPxnvKJtOojMYTKx7IE/P4JPItdemgAHqj6uQYw/5j0mZk1YoOzvskUM8EHeegUSDT22vTICm+b+5kDdLDdjFxAiHjvbJC8tbuR4pXmVLCwZNLM3hL5Nk/jd+Zw9PDf8OqbJvjq2p/Udgjubv45rg2zH8svWes34I03nuqEW46mFf+0EmE8sr2SilyMnR3Wl6/niSGRfIBue8rYytIsAGkThZBNyR96nu5OIYN/b35RexZE7PLZFxviTnyqxf1cl78SAW3sySGXgmMYjlRFMZDtitk2sYo/Uy4lqPkNi2hh73n4zh9QCIScQUoWN1gbLaH9J1tiysF66ix8/mkVMuReYHnb1wGKh3La2nRFHyDac6oK+pEKuqTyWiDyqFCXTsbLl9KUEGonpzU6d/1+0xmKtHsMFCAegigjve2N1CY7CNPuV4/bhcM/whU3BN2J6tTARQmH0ng4DFj2snCMiG2TW4GiCFjUZ5gDoaak/rXXi8sNCcquzmuaR47h0NKyY2G7JUtmKnWRXYsX8eN55q9j+gpZrXZYvQe/T7VFnrdIEakmqCmUlR+f0JVXwouWzXpxAKGm+jt97H2y+Tst/nf41LKYccly/sdC1TtNGw7gNc+yKKsdZPk54+3r91jjkqllpbPIQyqCLa6mpCy7QeDJXbP/aU9/0YoKMDjDywTxV79sFDSTn1ip9O8GEHE2+ZifJu53YZ8Ky1AkJqdWNe5+EluzhR+03S7Xk3MuUqvUt0mvOdvpkspZu74e8kh+y8RAO
 FtzR4lic
 H+p3XWHur1CBADQU4Q6Evx1PolIFR1/qpq3w1hQ1NMQ6vA7aDThLi1572IuC9SpJOhD3WCGhTnGPHCPAs7GKU4H2GTLgO5PZcv7JGjdJaWkBtxOYXgznuTvQhT5OOOkkdCPGj65UPy9wyYA+LZtqsmXzm6lWkq+5yZ7VjMb4C1rhMLtTNP5w7prrtWEep2F16Pw6EvyV/ml3JWCbaHDZcX7uy02mPU/W7wsCtUNR/GC+eMkgnl8yzEeGlE0b8F4N4fmRaOkd2QwLz8FPGAph2ks1gYbx4rDoASzf+r5klJLqUNfu1kROreWxDYShPGRZ4HSMgKVj5OzcpF7N9B97qDvbDh7LmY9CkQ5NetZpk8DU3gFSjDRs1vXKha44Spe7sGWYc
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
index 0e8b3161f8f5..a6e9e755e4b2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3992,7 +3992,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 
 /* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
 static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
-					      unsigned long max_seq)
+					      int zone_limit, unsigned long max_seq)
 {
 	int gen, zone;
 	unsigned long min_seq;
@@ -4003,7 +4003,7 @@ static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
 	while (min_seq <= max_seq) {
 		gen = lru_gen_from_seq(min_seq);
-		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		for (zone = 0; zone < zone_limit; zone++) {
 			if (!list_empty(&lrugen->folios[gen][type][zone]))
 				return min_seq;
 		}
@@ -4026,7 +4026,7 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 	/* Requires at least MIN_NR_GENS gens for basic functionality */
 	seq = lrugen->max_seq - MIN_NR_GENS;
 	for_each_evictable_type(type, swappiness) {
-		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
+		min_seq[type] = lruvec_populated_min_seq(lruvec, type, MAX_NR_ZONES, seq + 1);
 		if (min_seq[type] > lrugen->min_seq[type])
 			seq_inc_flag = true;
 	}
@@ -4689,6 +4689,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
+	VM_WARN_ON_ONCE_FOLIO(zone > sc->reclaim_idx, folio);
 
 	/* unevictable: let it through and the generic path will cull it */
 	if (!folio_evictable(folio))
@@ -4705,10 +4706,8 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
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
@@ -4725,13 +4724,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
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
 
@@ -4763,16 +4755,17 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4784,24 +4777,22 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4811,7 +4802,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
-			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
+			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone_idx, folio);
 
 			scanned += delta;
 			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
@@ -4830,7 +4821,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 		if (skipped_zone) {
 			list_splice(&moved, head);
-			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped_zone);
+			__count_zid_vm_events(PGSCAN_SKIP, zone_idx, skipped_zone);
 			skipped += skipped_zone;
 		}
 
-- 
2.39.3 (Apple Git-146)


