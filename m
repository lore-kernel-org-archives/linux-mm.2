Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E233606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=miFoIWG3
Received: by kanga.kvack.org (Postfix)
	id 52DBF6B05CB; Tue, 10 Nov 2026 15:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FEA56B05CC; Tue, 10 Nov 2026 15:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C066B05CD; Tue, 10 Nov 2026 15:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3906B05CB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A684160A98
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:55 +0000 (UTC)
X-FDA: 85420330590.10.2DB2C8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 96B5C40007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=miFoIWG3;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JJu+pEdf5RpGWIdVT2qEG1znfhrEKZZwrV03y/iAoI=;
	b=OeTEqm+XitXbRM1cXrgCKn3tgKRHfXHIWTHTsZtOAt8FGd0rGX5UYxzX6Bx7mcj0yuPE4S
	kfbyK27fULKX3WVv2yCS7dwHtinxxibE/C6YWjzxvHkd7XrqULk+l4zncf9qNUHEMqi3tT
	jcjQQVKfuow/W7bglwaK+wqjrIuM/X8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342113;
	b=WznGaHA8PGH++gR2qJwBqg03qxjfiOTI71cJ92vlvqgENJajeMy/wGiyjRAOKKk0RGY0vl
	TpXx+V2JCp6Zj8ARqk8qF+57t6i+L9KuncvE6BaiIk5SreYiHH6KFTW/YdCdH4sr5rKSgA
	YWeUYh1gkeLtaEML80pGneQZdkTsnII=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=miFoIWG3;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D592245B24;
	Tue, 10 Nov 2026 20:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D905E1F008A2;
	Tue, 10 Nov 2026 20:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342112;
	bh=7JJu+pEdf5RpGWIdVT2qEG1znfhrEKZZwrV03y/iAoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=miFoIWG3dgLkKgXAj1MJKO5fngFq5HWLOOs4WJ/f/Orob1wWYcjdTWw/j+T4tRVN0
	 BnI7+CLwya1zmINYBZxcTChBr312r/qscW2ZELYLZK4hA1HMoHyeC3r1+aYD3Ffzrf
	 q3VVIBdamdMDlXGzDY2VnLRYS5YCOm/lOdVWAscZmUa5amK0xr8EzTn5NJsnbkcB3B
	 Ot0sA1N+nMV7B3jRYn4WnIVtRIy9zARMLn9lwrIeERuCokDb4YjuU6d2GiA/BEiEiv
	 rhUYMMIcaO1fU2juotsMOIg4eKrWV0vjx4jNWd+KvQLxl9AWEe2QHj+yMgybjJBfu5
	 tPboBO33YPqcw==
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
	Barry Song <baohua@kernel.org>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH v6 15/15] mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation
Date: Wed, 11 Nov 2026 04:20:25 +0800
Message-Id: <20261110202025.25736-16-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: h8m1zkfjxkjbau4tfw6z4gtktuiuoty5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 96B5C40007
X-Rspam-User: 
X-HE-Tag: 1794342113-729668
X-HE-Meta: U2FsdGVkX1+YNMoHLR86bvycUgbHx+6hRTIB8qk7pc+MWYLTYWTdOuJUKvJbFcneaNc8Ow9R8cWYsFBFw+4m2TIRzhO/NMz/XQaOFxBYPojFKZaY1vlpHupzGc1330iKBOJoISpc8d/XeEZyFb1FYATO8oPcVO67eln/Bi/d1xnGerhR2k0QUqvkQQBWPyVoP0ZvqalqsGCqjA0MBl9I2QYWfL8dOsE83tOSeRfX5j1bidHnWwVPskQkBHd55avW0svXXB+tZyL6GwcYYlnDkgxfn6CzQooXcHr94LgBsBPrq+//t9ymeWTLBwiO2WQ73ixwOfXjWkByyHF+ObFGxBa4lKhF+S8kNxl9rJZLwMiSJsog3ii2E8a+0oKP+tknJZ6lF2b50JG17yEC825P1TAMClcYblyjOmEAT9flsAA/FZER/ay6THY2gVV9TElzrwjhKERVaTzfM1KwL7Tv17Azo4fyz2DPki8iPD/06UHKf4xEryjVclXAGvyOrIKcWhFbtO+DkI2AwWQQ/yC4cKNWU7a2jkrmsK4YUU0upHWmbxfSrRWXW0OBSWOJniAvvJutD+Oi/ovfPQd4J3MCiFPvcguKhqOvvjhMDkv5pUnSExfhfJS7F+AmixaJhi8iutZ7PMDzaJZlD0PbL0tzZ+t55JzTSvhV5MdSrFXmO4RaDfR1ObQWrXPpyM9j/CIi6LiPW65zIttColxA0v1I2Sq0Kpefh4K0aF8KpHo6BxyiB9xJnxini0/qXa96N+yBAfHkqz7IPsuKgoaNC3b8vMV/QDot3FrWhJwTAwvaYBmMrcPyGPVPsgtKBzCHcoB3O7hobBdKLjsHqo34cEYVC5k3r7lyiqQSab1mVqah3BWMiFLUx2vr4HOdeYWlDnIETlDdcxlN76b/0y1CIMsfEDx6ZzrpKPOAsBLHAWVnorfsLSe06kKQsbx1IL7Ovn+fhiYSnwfGVvP2ook2DVX
 VOxDaX9c
 wou1+68AJjWzJmQImxOH9vEGtoh9af8GKn514AAABjl6luarlYFA2Wk4hb+1zSSIS1juPnQ/xaSvh1jcSmOedWqP20lu2QnBWYxfDtigLkIfHsXL25dH8EAMJccywdR73Nw682Y9KHGHQbuvlOpxdlWTY6OrwwW79psTK7kWxb69k8Q0wJJMlQs8Eeoem3mithfvR1KFU0ptJjp9xIkbq9eCdr9WKtw0VKs9D3SoxjJDYl1w4Et5Ll1M+yCPPWy8S0gVWAJvZ8Vxdx9+IC7HeekIMujhRe8VlLbkyn03ZbJmQI0b+rldHRM+9jdjwCeECM+4f07GgABHFzpyni/bykaeiGhzdtBcSo3EgiLB8ynB/lSAgtLcUevOrPvUxRoObWpJWVe45X6YwISKS8uzpskH0xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Bo Zhang <zhangbo56@xiaomi.com>

With GFP_NOIO, we cannot reclaim anon folios unless they are in
the swap cache. CLRU skips anon reclaim when the swap cache is
very low by commit 74d9aa0d8e98 ("mm: vmscan: avoid anon scanning
for GFP_NOIO with low swapcache"). Apply the same logic to MGLRU.

The new scan-budget-based mechanism makes this straightforward to
implement. Thanks also to Xiang Liu, who previously attempted to fix
this before we had the scan-budget-based model [1].

[1] https://lore.kernel.org/linux-mm/179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com/

Cc: Xiang Liu <liuxiang.277@bytedance.com>
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
---
 mm/vmscan.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 379339220878..fa0245a07caa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -272,13 +272,6 @@ static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
 	if (!sc || (sc->gfp_mask & __GFP_IO))
 		return false;
 
-	/*
-	 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() for the
-	 * scanning type, so only apply this to the traditional LRU for now.
-	 */
-	if (lru_gen_enabled())
-		return false;
-
 	if (memcg) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
@@ -4206,12 +4199,14 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
-				  unsigned long nr[])
+static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
+				  int swappiness, unsigned long nr[])
 {
 	int type;
 	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	int nid = lruvec_pgdat(lruvec)->node_id;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -4219,6 +4214,8 @@ static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
 	nr[LRU_GEN_FILE] = 0;
 
 	for_each_evictable_type(type, swappiness) {
+		if (type == LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc))
+			continue;
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
 			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
@@ -4229,7 +4226,7 @@ static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	lruvec_evictable_size(lruvec, swappiness, sizes);
+	lruvec_evictable_size(lruvec, sc, swappiness, sizes);
 	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
@@ -4893,23 +4890,19 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
-	u64 anon_scan, file_scan, total;
+	u64 anon_scan, file_scan;
 	u64 anon_weight, file_weight;
 	int size_bias;
 
-	total = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE];
-	if (!total)
-		return;
-
-	if (swappiness <= MIN_SWAPPINESS) {
+	if (swappiness <= MIN_SWAPPINESS)
 		nr[LRU_GEN_ANON] = 0;
-		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
-		return;
-	}
 
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
+	if (swappiness == SWAPPINESS_ANON_ONLY)
 		nr[LRU_GEN_FILE] = 0;
+
+	if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE]) {
 		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
+		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
 		return;
 	}
 
@@ -5113,12 +5106,19 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness,
 			     bool do_balance)
 {
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	/* have to run aging, since eviction is not possible anymore */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
+	/* run aging when GFP_NOIO limits anon reclaim with few swapcache folios */
+	if (swappiness && min_seq[LRU_GEN_FILE] + MIN_NR_GENS > max_seq &&
+	    reclaimable_anon_is_low(memcg, pgdat->node_id, sc))
+		return true;
+
 	/* try to avoid aging, do gentle reclaim at the default priority */
 	if (sc->priority == DEF_PRIORITY)
 		return false;
@@ -5137,7 +5137,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 {
 	unsigned long total;
 
-	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
 	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
 
 	/* Just scrape all pages calculated above if this memcg was deleted */
@@ -5888,7 +5888,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
+		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
 		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
-- 
2.34.1


