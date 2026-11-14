Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6868D606A332
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WMu7WC2n
Received: by kanga.kvack.org (Postfix)
	id 837C56B05D9; Sat, 14 Nov 2026 15:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1A46B05DA; Sat, 14 Nov 2026 15:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663936B05DB; Sat, 14 Nov 2026 15:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 304836B05D9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:08:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17F6B14044E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:31 +0000 (UTC)
X-FDA: 85434812022.11.715B5CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6396F1C0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WMu7WC2n;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686909;
	b=Yh8TIir13RSjnzkLknNPBiKD3/jkiSfHNOG0xgkVTume4y3wBSL4Z4aK4r7pLm3rA85/XT
	OmQ/TpN0fUBne7Cm8SW15aP/caxh3viJ68PJAKzzQQCQn6NqHkdBKCY9tbhg7xj4aL+K8B
	tCfDt0TG9nyte7vM1p3MBZvG0+C4+JA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WMu7WC2n;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXoUqML7mEBlG9YfP/qGkHleFIA4Us/MYTiwOeE/Oqg=;
	b=VwOs3g2/8TpLeIBtQ0vCvAYMA9VDKA31KQI348qBD+/IKb9I/HiYwBZD9h0YFzPNB+qi0I
	+mJeIWdE80zz0gp8+ElCtmvW4f18be4Q68zceeby33K7Lph2yCgaPTV7VRUGw9kAypNC2k
	xNsnBFPF0pQExeUe0UFd/rKD7B9HxYM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A240D400B3;
	Sat, 14 Nov 2026 20:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DDA1F000C5;
	Sat, 14 Nov 2026 20:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686908;
	bh=HXoUqML7mEBlG9YfP/qGkHleFIA4Us/MYTiwOeE/Oqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMu7WC2nE1B7J0kUwsQtpGJEhWVCljh4nyn7guibBdUhLkM2/ww2nJYdBOh9XnumC
	 pZi/DZFNSumCTJrQAQWwe+KBpuJ43UMKPCE4HWujsGhRjG6xCY7wyCdY6lqEOdcOkY
	 pMsv6Ivler1iNEuejYw4VkaXHxSI5cQC+P5VzCIj/AoM6WIA3BunaQJOP2EwGvnCUD
	 D6Wt3ds4MDKp5YubOz+aP55/06NewqdFBhxajqmtHQtgD93uEZBZi29lI/vVM978gD
	 3XiIDAjeywqSbIQifYoYUxRrZLDssjSG8mt/zSsxI16YgPC5bR0m+fgqzPSm90D4Kv
	 ITHe8ntQcTa2Q==
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
Subject: [PATCH v9 03/16] mm/mglru: reclaim from the oldest populated gen
Date: Sun, 15 Nov 2026 04:07:50 +0800
Message-Id: <20261114200803.23129-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p7dp4f4uesg7ruzrw9ei33dp7758hz5t
X-Rspamd-Queue-Id: 6396F1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686909-425915
X-HE-Meta: U2FsdGVkX18hBELOUg972zLJX2ldGGzk7Y8l8s28tinEdCxEryOZqSDs9+CtNkXsv13nZwhnfBDC7UxX18yu2xKDS5V8MZtDUJdUkbb++Gdj9o9yvSPftYuXluotykJ2soIllJQ8A7Yc6D58FrqkLIHxBEcilRp22gvQYNJ7QxVgn8i20efFPuQaOroK4OJQrE6iH9Sn37lnYGcGpVACRtP+PBypicGJgU4bLDGzDdn/XsFtTEXpGW+QxwPtgvApaHdlxqMgLwvThoGE2tXJSgfRhwO6mzbfk8uG1g1snyCsoUrtfexlXXnT5Kysb6QMgbCn/a2bv9PcXUcgjU2h/HdLFEiJQ9iqCOE5w51Pwz/yiWt6Y9F67NIhvLiHrL0gp6UOphPxswu1FUWcC5VU681S9EO/yZH+Gj8Bn9xK9x3bMwCPxuiGrdqXt1DgDeyXWBJyrkQ/yGjPALxy9alCdzmLyurf/IQrebq+pbIqMCUg4rSTY4/c3j2PHhxxgdGy1WgWRqwZNFoekGmtA6w0kssaqwinOI7bbY2aHupXYGZq53fNEB1MWhgByOiX+5sivWa102NIe8SHLCkLG9RvASaUcLVoqOL+CN9+a215SHPDjzdM8IeEBe7kt+O36qBuuIc2B4miep/SEKWqSNG83AXm/iW8BTPtm3bCWWZ2GRa5bDscDsagAU6qeoPY8FId+VcJvPQnvQ39AuA+92bevXCRxZ9bYZ0+ca8secOEWt6oJ4FKmq7vk4l2fYj0SLVM5oh/VVzpS4BFlUeBaDhrSaXY1ICCMULJCMnzUrHdTnbPaMGkNXLALX1kqvtGXLcHtlg7dN85RuNZD/KTME1OtQLRpH50xE1xC8lDD4ofu7dihAzEEXC3nCQc7ztfs8SSrDR9PHQ78pz/imAsftQcAYBuNxKHA7BMgoApEtDIKmbLMAs8uskegWHD7sPAp5WCL8JB4glS6u4Rxu1klE5
 0N6ZRjn3
 OrMEg3H/S27nPg9JXC5Zqf7torh6abGan9VJ/EV6y08+Q3k/wEnjLWpOB7TzmR+LbhmHRq8QG5AzqpgDkzc0iyG3rxJ+R1re72B5fmS6VHZ8v+GGtfGfGjacSsmCW9HhigJB/uushXG8Yim7YK17xza5CeWfElaBGX3ZkRcEQ0h6XowlTimJ+Reh/BSuryRicNPBBsHM4EZpsn55U91ZCQoW8WeZi9DhhMgNh/R8XeqA5E0jP7i2vz2/RwL5rAQkGsa52MXjv7JaZwn6zNWlVorHix5dQsa4+zaV79ymgbEhkzIvn81TBrAY3T2jAXkh/RLrfBREpjeJSQks/5PMmNb/pd8GxTxDkhDA51t60353Y/h8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Currently MGLRU tries to keep the gen numbers of the two types in sync,
avoiding reducing the gen number of one type when the other type has
more gens, as described in the comment in try_to_inc_min_seq().

This makes scan_folios() stuck reclaiming the type with fewer gens: it
always scanned the oldest gen of the type, even when that gen was
empty, so reclaim made no progress on that type unless forced aging
created a new gen and eliminated the dead empty gen.

There are other approaches, like lifting the gen number
synchronization [1]. However, that would break the gen layout used by
lru_gen_folio_seq(): newly added folios would no longer have a
well-defined hotness according to their gen number, which reduces
accuracy. It is also not pressure-aware, since with gentle reclaim we
still want to respect the gen layout (hotness).

Instead, reclaim from whichever populated oldest gen is left, but only
when the default reclaim priority can't satisfy the reclaimer's
requirement. This is typical for swappiness limitations: e.g., low
swappiness asks the reclaimer to reclaim from file, but file gens are
drained, so the reclaim cycle fails and priority is raised.

At the default priority the scan quota is 1/4096 of the evictable
size, and the old behavior is kept there to respect the hotness
distribution. Once priority is raised, the quota is at least 1/2048,
so the hotness bias introduced by reclaiming from a younger gen is
bounded by that quota, which seems fair. Global reclaim for MGLRU may
start with DEF_PRIORITY / 2 (1/64); the ratio is still reasonable at
that point, and when global pressure is more critical, we should
reclaim harder.

Note that scan_folios() still refuses to reclaim a type left with only
MIN_NR_GENS gens, so a completely drained type still requires aging.
This change only avoids scanning empty gens when populated reclaimable
gens remain.

Link: https://lore.kernel.org/linux-mm/20260726122123.7614-4-baohua@kernel.org/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Barry Song <baohua@kernel.org>
---
 mm/vmscan.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ae3e13b1fb27..1197e15065fe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3312,11 +3312,9 @@ static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, int old_gen)
 {
-	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int new_gen;
 	bool gen_increased;
 
 	new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
@@ -4679,7 +4677,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
  ******************************************************************************/
 
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
-		       int tier_idx)
+		       int min_gen, int tier_idx)
 {
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
@@ -4697,14 +4695,14 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return false;
 
 	/* promoted */
-	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
+	if (gen != min_gen) {
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
 
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
-		gen = folio_inc_gen(lruvec, folio);
+		gen = folio_inc_gen(lruvec, folio, min_gen);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 
 		/* don't count the workingset being lazily promoted */
@@ -4719,7 +4717,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio);
+		gen = folio_inc_gen(lruvec, folio, min_gen);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
@@ -4762,17 +4760,27 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
+	unsigned long min_seq;
 	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
+	/*
+	 * Respect the gen hotness distribution at low priority to avoid
+	 * aging and scan cost, but prefer to satisfy the reclaimers request
+	 * when under pressure to respect swappiness more and reduce IO cost.
+	 */
+	if (sc->priority == DEF_PRIORITY)
+		min_seq = lrugen->min_seq[type];
+	else
+		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq - MIN_NR_GENS + 1);
+
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
 		return 0;
 
-	gen = lru_gen_from_seq(lrugen->min_seq[type]);
-
+	gen = lru_gen_from_seq(min_seq);
 	for (i = MAX_NR_ZONES; i > 0; i--) {
 		LIST_HEAD(moved);
 		int skipped_zone = 0;
@@ -4790,7 +4798,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 			scanned += delta;
 
-			if (sort_folio(lruvec, folio, sc, tier))
+			if (sort_folio(lruvec, folio, sc, gen, tier))
 				sorted += delta;
 			else if (isolate_folio(lruvec, folio, sc)) {
 				list_add(&folio->lru, list);
-- 
2.39.3 (Apple Git-146)


