Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702A360A380F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFo4ebXO
Received: by kanga.kvack.org (Postfix)
	id 8A7306B05B9; Tue, 10 Nov 2026 15:21:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87EEB6B05BA; Tue, 10 Nov 2026 15:21:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794FC6B05BB; Tue, 10 Nov 2026 15:21:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 540236B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B13FBC0A3E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:03 +0000 (UTC)
X-FDA: 85420328406.22.3348403
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 13AAA1C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFo4ebXO;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342062;
	b=fRCk2l/R8MK90BN3yMZLPtEg/8kfCgp5CrfNVKQZWdKyCchCR498bNZT12rSGpQkvwVzCC
	a8RsWkkkI7LOAqCvFfs/DOr4Y+z0YSkvTPM5tbZENVfRjKYouD/31eyNTHXa+7+KHIijqy
	q3LdJNRrxmW/AEaDcWc/M6wbMe93+hs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFo4ebXO;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7XUwUomnVCDK9aa962ZIpgMQ6QHHvHVmOdhzPQ+ujw=;
	b=gjqn4/DZAIysoEEKC4xvYFWG2SgKUmA0KFuql4Z6BKnSfI8u6WkjNoYjRT9azmJr4lQlMP
	hDxr8o4md3MAvF1YLfGXHbHakZKOdiEouPpYL+i5UTvPiS0I8/f/OdagaSpyQKG12o8MJL
	F1X0kdF1Akrgl1LWzHlH6cl9QDk3Yk4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6303C4140D;
	Tue, 10 Nov 2026 20:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9185A1F0089F;
	Tue, 10 Nov 2026 20:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342061;
	bh=s7XUwUomnVCDK9aa962ZIpgMQ6QHHvHVmOdhzPQ+ujw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFo4ebXO0/sbSYPbt13it/3NJXH8onj+DKc3QjHVT8/boFABuK33C4RKGLJvadBKg
	 f46g3qY5T/5Yvf9mMn36+lN8oXmEmb2dq+d1qsHO1Ht5jPthFm/1RydAfy4mQJglxE
	 CVFCC8vAabgmuC8RIP7sTTtD52mNwVn645oGOGYsJTYkF+xF3g3q8PoGjyZAsTA3S4
	 i0v7IrfAY2WEcwj6URpEuzsP9m+7DKnv4fLQR9feCiU0Iubls2OwMhUbBRDiuUJP5K
	 C0Uc2Xg/q/lgH9kfNN1hkFsvLcFbd3RwdBKEGoKzCyVz1f5MO2YyLFnBs3JF0H8Vxb
	 LcjvOdOurSPGg==
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
Subject: [PATCH v6 05/15] mm/mglru: skip zones above reclaim_idx instead of rotating them
Date: Wed, 11 Nov 2026 04:20:15 +0800
Message-Id: <20261110202025.25736-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5hqbsydo495rcnjzgbh7c5bx91gwx8bf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13AAA1C0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794342061-550806
X-HE-Meta: U2FsdGVkX1+9Us+0R9sj3fJWhg5RhtxTgQ46U/9fq0LhkAP82qGMfx9PlbSo573kPPRWmIyjI65B70wkDEfwj34xa8tXvzccPDFe5nj5xXg0vDibMhkkZA4aauFbjyYcm2dbL93zfa/EHe3HVuYXLmrB/foqt0nIYHxzyVt17pR3PpNeatdeqlL7vuQtZu6sSOKO3xn/fSXvQEPdv41Swe/UNk5/vDDRi+7zw7ljcrEDrj0qske83snQ84mOwMP04IOzghb8j7/4BjmsAZxhn8EzV8HbNw7cJXmNG+fw5BN0FMbZ/925xZfrlQkIpms4QGropeHmKPgotyCJ7Sk3ZIqjJuoS76hbXHz6MEXRpZzBCJ9L5H6hT0+7VDBaggbGcpoNLbDUHnb4J2zUdpYAgguj/lcLiaKAltNeoFBqt6/i6hQp3tCUoZh3Gw1FLo3jzIz58gvXZLPXIienqzRbZw1Tfrg/YHac1P/5RXyFa6wyCUvhV7d+Pr4rvUIEMdsukZ2NBmZ65M+6TxcHJZE3B30h2iaGxnKMX7ZuIAGpDWzaIS5148dXb2MmmvLJ8K9sZorOiWxSbLXtH2IXz6DWpIy5i4r2B+DoUvikGPNY4X2PStc7c55lnnDBV5zMEDK+ijvi5OKSqKp/nvBoDSDHIUZ89Lrxw1YFAlawoGJBG76IsY6kL90Ox5zVk5noxftFHVGXHao7hVQdxBWUl2ccFlKyz9L8SDREz1Cor6um0tUNY39CHtJWNXLduORxnki9+q17BkDjgsd60P4yBUGNpoYBuBtcDPOYp1M6+qmfM3s76cUyk33UkqHWoSSIrYrHjHtsHZBYSoODH/bXl6JvO+RLZbEyo7RQFuUE0PYru9XE8C1mmQoaoStpRovx8Kdz4xXRpf4eOKbDWp1JVqHojZXae/NbHms8DLHfRjYfDbULGFRqzxOFHYD8ySEnF6D2WD3NECGVEalOdGr7n+A
 as0VWBF4
 aUyNjdZT2D7CYQLOVO/h6rpgcbATacUcI0PNUQSANGjaueOQxU944EPSNLUxg6ztMGPYKPuSjUf6HFDgB0qUGvrlyEX6CmaZY/q4iGUUURsHLwMt+jAgAwCE+zbFNk6FzUSOw9aBsLgXWy1c+S3CFKa0xodV5oL26l5Luv5SSiE5oSkLfSBP+SlL2bQmjctVJPOO0UJgPANXi3slZ5wBh6oqmfwKl4DYX6DS3JDxjuRWHVgLGkgSEjFFTjpF+pY7D5V9MAXF5jovTy6n5+wnbHmiXsqvsiMZcgAbKnXu+svYXmLdnxh9/M2S9GwrtlvN1MUrYKd/canyBDDtL7z0abmINrzIURis1kI8lcuXJt5BotvveBZaiQxUkuuD5Xu9wtHkA
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
index db0a8a3e8887..6b1670677974 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3991,7 +3991,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 
 /* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
 static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
-					      unsigned long max_seq)
+					      int zone_limit, unsigned long max_seq)
 {
 	int gen, zone;
 	unsigned long min_seq;
@@ -4002,7 +4002,7 @@ static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
 	while (min_seq <= max_seq) {
 		gen = lru_gen_from_seq(min_seq);
-		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		for (zone = 0; zone < zone_limit; zone++) {
 			if (!list_empty(&lrugen->folios[gen][type][zone]))
 				return min_seq;
 		}
@@ -4025,7 +4025,7 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 	/* Requires at least MIN_NR_GENS gens for basic functionality */
 	seq = lrugen->max_seq - MIN_NR_GENS;
 	for_each_evictable_type(type, swappiness) {
-		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
+		min_seq[type] = lruvec_populated_min_seq(lruvec, type, MAX_NR_ZONES, seq + 1);
 		if (min_seq[type] > lrugen->min_seq[type])
 			seq_inc_flag = true;
 	}
@@ -4684,6 +4684,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
+	VM_WARN_ON_ONCE_FOLIO(zone > sc->reclaim_idx, folio);
 
 	/* unevictable: let it through and the generic path will cull it */
 	if (!folio_evictable(folio))
@@ -4700,10 +4701,8 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
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
@@ -4720,13 +4719,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
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
 
@@ -4758,16 +4750,17 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4779,24 +4772,22 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4806,7 +4797,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
-			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
+			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone_idx, folio);
 
 			scanned += delta;
 			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
@@ -4825,7 +4816,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 		if (skipped_zone) {
 			list_splice(&moved, head);
-			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped_zone);
+			__count_zid_vm_events(PGSCAN_SKIP, zone_idx, skipped_zone);
 			skipped += skipped_zone;
 		}
 
-- 
2.34.1


