Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE247606A339
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JIN1dvfo
Received: by kanga.kvack.org (Postfix)
	id 0C0016B05B5; Tue, 10 Nov 2026 15:20:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F8B6B05B6; Tue, 10 Nov 2026 15:20:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E6B6B05B7; Tue, 10 Nov 2026 15:20:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCED56B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:20:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 868A7A0B07
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:53 +0000 (UTC)
X-FDA: 85420327986.21.728AFFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C975F4000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIN1dvfo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkOurhuE3F+xoJ1NIf+lBrhllBPRtPbJRVx8vBGAF64=;
	b=8PNu9cPnd1nH/m+XNp/XciylYrHm2Dqhm4gy+yVqWTHyK8nOyn/Tv40tuGU3zwnel6Lxg2
	+auQQhgEgsJWi/bU5Lj7RZ4kkMES9pWJ7eexvpS14QDzpRTR8Kk8tn45RcQuREa5QuWOTx
	iez4Sk430aCJRsO3lGFVVKxMQlmc13w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JIN1dvfo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342052;
	b=PbqEd0oI4BfKZsgHXEbZRXiDzP23OtdU2QrboOdTyIz8uQg5Es6vx95afDlM6LrcDpdLKR
	CoKDVZ0bDJ0KjTDKSeXSjWYVEt25/UOrj+8vMqxRGdWCG9ZIfv1mg5c6DlWhE20obsQcqf
	vc/o1oC/XhqDuPeGeTUSWn0B1DwbMSI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E82E419D6;
	Tue, 10 Nov 2026 20:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DF91F0089F;
	Tue, 10 Nov 2026 20:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342051;
	bh=wkOurhuE3F+xoJ1NIf+lBrhllBPRtPbJRVx8vBGAF64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIN1dvfo7VTI5Hp2AI1OZkrS98xwyT0b0AKLVFfd90XTjdKzbsbOXNLZByf1xxS2U
	 SXbQ9lBHQyyDJBkVEAzCvefxEqJejE32CludX4bnTTwaB/WXZ4xT0lW5vHpExvEnib
	 gULl31rFja/5eRo+zeUinXKdQqHgvLz2kelB81SvURBmAgfssoj48/6GmdQchfzVHc
	 FELFrd5oghsZXDOarpO5ErBTmlNU0FiPIa8phZoe5Vj2zkjNyuCwxHL18NMK0nkcdQ
	 vxlWgVMj34D5iyjbm3RLdmirEc9bFRxVSDh6faQafo0mNXCo7VPLLgZy2IDmT4V7Pt
	 LKvN9xtZxeBSw==
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
Subject: [PATCH v6 03/15] mm/mglru: reclaim from the oldest populated gen
Date: Wed, 11 Nov 2026 04:20:13 +0800
Message-Id: <20261110202025.25736-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C975F4000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ksso831ckordnt7xsyiftm6hct6itkuq
X-HE-Tag: 1794342051-234130
X-HE-Meta: U2FsdGVkX19mZUPUjysGVobpUVZ9ejZRL18/SeodOkiXH5oB0I8JgZdv3uK2eduommJBnCUsoCFEfJJk1/VQKyPAtVfAz494uEPzjeWFvZAy/JJf/BhY0GbtSpRWqg8zmvI5koDQ+3P8lj8JAoVPEFKToCiUHEX0ZAOhWV8GxL1b3Lq+9BgoMlLggEzb6CoIorAlKU8GffEdZ+8jp1KFFrqA4kZ4ODXT5dsUc9fAmWZ0oJk/UC66ou+UZ7/yPX5/k1QUWCqm8UWsrYOepO+dO+kURTYDb1kOugXyBPmTYbOi3HlHGhBH0fTOA+gmkssCGOFioopYDYE+Qb2wuC7VvV56YaCEQnqRCxnfugfi+DXOx8upCE8AJ7Xw8PxEu6rM0bekt26hbEDqHkKFi5h3WUQZR8OcE5gbXfbq2eERyHf1Ugejnl4ePLw/putYhv6lw1YZB9JSxzR9EdeYDglH1qjTNlgC1l6GZI30BApb4qZo7KetiEqVhHK7hu8Mabb4USNa/zIAjAll9PnyeKunhbMT6ZjeiCEoL906iSpSQW7UaFiLy/+bnQeKOhuWPlYNo1vMMhTY+E76eHlKVpGE778GV8wdfeDmFR885q4rc3cKCRqhRWWAMei7h8q1fMY7u062jNVu7PZNrGTVwWyD+02NEF+AUQ4sYjfwxxY5HPRd+Tn9BRs+b7MZxkgN2BU2+KzrncPx6NTeN1gTlnY80CGcemnjzbPf2gYJEMDMBrUgfdaWEDSKaDcLk3lg/qtyMm+AYUv+7R+cnFUQtejUx0UlIoqY6k4E1fesc/chqWk0Hn42YkiAzTjEL3XCZtW85Y5g+MR+06SxRQXwsp+J4w43kp8eTxdYD41KKeKOCNkonTfIcgRzxfViqNXwxwVGUQu18K1/aUbhQZgSfyZ3lruBVnkXGQxYRBNZa47DKLcccdQk6Ke/KDufcuZPR5p/IpKBm0tiV/7ys6AZIRb
 ZSgOKeBN
 ypg+T8OBwDnSsg3WfuGfQmKn2WgSkV8CGAMk6fLTkuE5C2HzDsjrqeryrPL2CWfFcuDjR1HE4gvFVUC0knTcBWef2aIUW4XytGAJ2jRmj/c2Dv7o50IMyXpypmBMDbr/lSDdRCFDKwKK73Jt0h2KP/+H8XROLU6p0ssrM0x4ZIW/DvYKsXOMJG8e3lbljuUzCoWwL7HzKUTHB5rZfwMJHKJ6gowP0VnV1eIgabYNKA/hashAAUqmGBip7SdpgCBpQL/I1yqpG+OR+mCb85W9KLRXEDvGCXgiACMtOL5dA5ifIjFna4bJAG6a0Kwe26VnR9omDkolWAVUe+YYodoIWdIwghr3XeBpvUGX0EqiuaAyt4K8=
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


