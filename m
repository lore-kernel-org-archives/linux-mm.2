Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F0F606A8B1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N7qTndZy
Received: by kanga.kvack.org (Postfix)
	id E6A0E6B05D9; Wed, 11 Nov 2026 18:26:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1AD46B05DA; Wed, 11 Nov 2026 18:26:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58306B05DB; Wed, 11 Nov 2026 18:26:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A48D36B05D9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:26:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2243240466
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:30 +0000 (UTC)
X-FDA: 85424424540.30.4CA581C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87424C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N7qTndZy;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439588;
	b=HCAI+RLSZjrV0LTdMaIUMHAV7XiUhET8VWvhZTTuhyr5crfUxsABbUPsH+eJmy5FnV5wNv
	LmRxNNJkISpaT9T5XFbsiCbMVlIp30ZFsX2Sboco5iirCFAHlT822SsajetofcYn5u5IH+
	ocQC/Xd7bhs2GHgzKbUo1o2pje+WfCc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N7qTndZy;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkOurhuE3F+xoJ1NIf+lBrhllBPRtPbJRVx8vBGAF64=;
	b=kC6vMt6sm5HQ1+pU5P+JsrNcoWwM2FWSQKw7nVB/iHYGHUetrQnbuj1oN14d0LWZ6jEQ9C
	odNNdu/vfmoBaRc5B0SEye0IgGlm679zGbRnzBHpZcYojYIyvFjJE2PlxMn5i2SAznM2/k
	UUFntQ4GfJA3ynuXbXxXsBdRZ7c7mN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EB476062A;
	Wed, 11 Nov 2026 23:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108291F00A05;
	Wed, 11 Nov 2026 23:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439587;
	bh=wkOurhuE3F+xoJ1NIf+lBrhllBPRtPbJRVx8vBGAF64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7qTndZy51hJSLb2jLsVlTO9p4LWaiKauDpNXcI9ENwwtyksDNVox1LnC8aguYU49
	 Fld5SISK+3jDxT1OJurHngw7fOIoXLbn6AfwID9QESU8/B2fx0rz/Clb0TrANrSR69
	 ENqVWZvnHEW8AKrHNx7s0PZWcl4xrjhCxLJvYwxidR07xFgmQ47eDTWbDwxCyrC4Fj
	 1F34Gp2kfcVL5pzG7nerRsnheauTM5uNGDTAHqu5x7BUrsRZn1NpcKwDYlC5OnWH1r
	 m2pWcTpNV6W6lk7FWAuLn3/so7R4Zg0KBlQ3jpAUPsS31C6KZCO5rYGuT/odnOZaOj
	 JJcLH0nkCMGWQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
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
	linux-mm@kvack.org,
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
Subject: [PATCH v7 03/16] mm/mglru: reclaim from the oldest populated gen
Date: Thu, 12 Nov 2026 07:25:50 +0800
Message-Id: <20261111232603.9934-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d4odop4zmmk3hosxmecshmwch5nnnnsd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87424C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439588-945216
X-HE-Meta: U2FsdGVkX1+aLyF/w2gA5MK/DXYtmUkQujjLWdPdl0PFv0ngRBq5UKCyP84GXnzkpxnjfCV7utLdvtfJIE7VtMAuFxDtrDrH74QLWiZ0S8WmS/nI1Yj+z+yfePCYYoX8TFMqE0ZTIW5jKASPKl2QBQFX1QBthhJuKD0FSEFDARcWsq+0MAlqgvWrD28hElOiWPKqLz9nk3N6wLd8Hy6NEILvfjOLEh/SCbK5Gc7rSP6MzrH4yHdxNoX3oHmGM6NlXRHUqKhWv+rAvbrXaeiDhtJsJqcHsanIsmsI/ltDj1N4U3/BWciKMea3RYnTsm2c3UGZIhaPwRkIg5pxMXaaIiL+sKMHwjgPf1kiqMGHf9jEisdlFKMi3zfC1pJ/S3bDxJmGJniGFbh4wn3+mjWkkFMLaJy1T6J0kKGFCvjUFETMnYuCznHN3yBYe0nndQEx2EpcolCs+03UGx4kLE408itfM3l6t4uQPp2xEjZkh9xnfq0AOQr6bkhimW7fBWHeJz1k2D8G7l2R7r4G72BR4zG4ZbinjY5Tm7P/ECB5ThlOZKP/qZfHFTJYGFseyt98uu6C1fmildwtUOHIDmKt99iaqU6oWT5RMqsMmQtELqBMxsZ9jyLS7lyz6pIn7V5KuXgqKEaCIlfJOAHfA3o+6Kas8Z2r33y5/IKX7Ou+jJyVEDH/937NOenMtpeCVAGePzl1Jpd6MD8ANMlUzZDeYqO4dmYKpvqiSK4MSiWE+ts3MHROerYbaRFnIlKEwCgm1mG9A+gnw1KZ0B6IbTwp6WRY1rSbcOPzDaCIozQqhOHz3r0MQlBvGHdd//nVkHXbDtg3ALRo0wdH8+nFZiI+9TqQXt7k56qab9jLAa6kGuv1C9YPCBfr4YxtAyqlxljxf93CvNzw8z9nGYcVg5I9Q7EfVk/g24/aAWiZYVMMUB8btOvH4FqC9DSdvb7sluTuqtzy5gPuE3hbkw/8jFS
 PD6vIC21
 oV5lx7yadaa3YURZlwM9sGFK/vz4wSwYRHS46QiBSN66YVP+4TKr+OL83cJ4zRY+TqhRPZPh9EeWrL/HvURmrgEnFLT0D6+58DieR/Mp4ZEwLjkP5xddAD30F/8/Df9QALraG/nDQW2w9EbHhuv2CIcK+arWj2gx5t/bNAdALFgV5ItvkiFhwpGy2q00WuFKJCBg18ZCUWFk/uhaXZouKX3RY1rubkl3goOLy5j0t9WZ2YhrlRL0Wvft84DCIvW7zMqZzaBowP92T2mnNzjSG9M+AnfY4eDGuLl9wlfJZ/oQWM5TyTHnhXDzRJfsfBWw7Gra+0IzsmADKAHtouLVUrs1Agl2xBMV4CHhW
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
index 4ac80968e634..593f407c0668 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3311,11 +3311,9 @@ static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
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
@@ -4674,7 +4672,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
  ******************************************************************************/
 
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
-		       int tier_idx)
+		       int min_gen, int tier_idx)
 {
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
@@ -4692,14 +4690,14 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
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
@@ -4714,7 +4712,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio);
+		gen = folio_inc_gen(lruvec, folio, min_gen);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
@@ -4757,17 +4755,27 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4785,7 +4793,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 			scanned += delta;
 
-			if (sort_folio(lruvec, folio, sc, tier))
+			if (sort_folio(lruvec, folio, sc, gen, tier))
 				sorted += delta;
 			else if (isolate_folio(lruvec, folio, sc)) {
 				list_add(&folio->lru, list);
-- 
2.34.1


