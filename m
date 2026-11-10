Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2549C60A2603
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dhiBbyjx
Received: by kanga.kvack.org (Postfix)
	id F11446B05C1; Tue, 10 Nov 2026 15:21:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8636B05C2; Tue, 10 Nov 2026 15:21:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89036B05C3; Tue, 10 Nov 2026 15:21:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98F1A6B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2609C140991
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:24 +0000 (UTC)
X-FDA: 85420329288.01.ADE19E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8D78B20002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhiBbyjx;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342082;
	b=Rhenl0xWFDs/ACJHtXGvcgGG6El7kAENZQFofulG6g0M5VLHURgR1wKmdkSk2ajDHaeZu9
	n43KdnhfnSmJ0x3OkcI2DcH7dCFv5Kzm8rYcN9c3aq2dJuX7GXT7hGhtEqg04Q9Cbyv8ZR
	JA34I5yAihfFCr123IUz5azWNhdu5JY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhiBbyjx;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFLZOYJrqY9tE+xJALupz4N3NajBhGjqdphLEqi1j3g=;
	b=O41N3seWFRu8cOukKfPC+tzlgK63fFd3QsRXx37eyath4DTd1GaQ5UsH9qpt7gQ+DvRzFU
	zmD1T2EmiSmSta+iI69aSuex67ihR1+iIsBX36QCuHrVtIQwxez0BEg1VPmAueq7WqE4Ii
	0XFXIo0Of/M0mDAqFZcS1IntRiI0pWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27154601DF;
	Tue, 10 Nov 2026 20:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2027B1F008BE;
	Tue, 10 Nov 2026 20:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342081;
	bh=GFLZOYJrqY9tE+xJALupz4N3NajBhGjqdphLEqi1j3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhiBbyjxKj2saEGJX6WzQjY+BLCz7Wi0typqjs1E9lNG87qyaYqMhNs3AUaC1DB4L
	 j/+6HwL0G8OibZ67dSJ2+7yGmu7aYJjBFegdrBx1yQvgP50BdE3lHXK47tz6YFGlhw
	 BByrtc0x4uAd4BK7tk1eHSX7Dx894NhsOTpYudeSv0YJcaQUvardLCLdR4xIYeoH6O
	 eBKjsUev5Xb7nl0ouwfDbCXZq0Lg935OQsBLtAlrZxGFnCwlQ8xVVC8qLx0IsYh+3d
	 vro7qeVepJX++grmnAh/42EZQKfCgQ08M5Qd7m2kX9QCvfel6drWkn9LJcyArcqwrs
	 55W4ehB4zwJrA==
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v6 09/15] mm/mglru: Avoid placing rejected folios below populated gen
Date: Wed, 11 Nov 2026 04:20:19 +0800
Message-Id: <20261110202025.25736-10-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dtqb853eiqg78c8x4cqsterz66h4966p
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D78B20002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794342082-53478
X-HE-Meta: U2FsdGVkX1/48AqmyeXd7r3cSfNHHsGX1b+Hb7tGCf1yZJQ6ghz6aeeeVIh8NtB3biQxUbOf4jzR2bzhMMgEIqBem972zbp6yVIvZb/4d1G2XVmDuzHjan0LTl/P36bXPGqp87uZu5fywPsxm0mD83Ijb0qK6T2NGf1DVIRTvNGBKZm4XIoDdmMy3/WRkdwi3sOEc2F11CebTsDa7G8Z+js1KCNqShXzIOuAIuR7c+DylHuESzxA2LKRDGAuUdmDGLWO1HTuUCvOOfNzYlizNgM+5gTJbkqnEGoUozVaB1a0hNknoKJV6mgd4P/dBjdYi7W+FTA1gVS9SIOGR/HnzV4HJVCqoLpQHpkM6E2RG9Ay4Bx2e6TmHcyQ5fRNeIgkvfBzvWT06PL5PLUZKrrf9VzNgwlvT/NIX7XKT8HqaXv60qtDHR9CQ/Xgwf+E8SaW2RdFA2tdRn/xwuF5+eGGq0mTWljpGqr3iTXCROzWMAp+O1XI8ViA5G1Y6oK3h++bMrEO+vWZXM2LTy6gtxgKRP43NKKPradQgeZc4Va6I21vXTj0IB6OwTv2KQll0K/IRfdC2n8ZTei7YL4Z2AhOSl/klNuTC2yINqTMJwrOuYAHz51nfMeH5yDy7qKTYIQdj7c9oz9DJqykcDrPeXvaZblNBPBQvJHW2V7dCSTZpVxW8fJFI6Mdyb32x0YsafbVMffKDLX16yVntLBIzdAkSCyQ7kovdoiturLoz/bRGRLw5h1qATXQKM6usr01NWWtkVhRqOrIZUjcouYEEadcQyrMY5OC9mRn98YeoPyQKz6f3frYj1U642Q8i8q2QguK+f/fio1AuQ+ZTWxPt8lJkh9D+fkFWi9AkuB4pAq6bpXrXkpAEsgMbzjbs8f06A8DPdBK/d6FVjKnaal56PasdNxgG1oHSy4KWy8wLbt3kD9Ga1ycYusWDLUQCcqO0HIgr6Y7qrho1XH75M9817+
 tTJE8HHE
 /FKjC/tvhq67/WSAXFAF367letYmAscrpxolWK4y1aZPre/ZH4lTNLgO0To5OnGkBf0Pvi7McEAlSVNo7arxVg7D0SY8bZnoSAi1JlSUgYoMSTCZI6JPmhAJxBDJXktReMSd6S1ZvRoGbzGfKzvDOv1OiKtM3RbKFnFljlCdD7kJT00kihc6JmfwNwj/PCfrda3GPOaF8/DFoipnGpi5Qmmm8z23X01aY0ryTTdCMPH9z9CNivLRBgD0wVVZNKrQCLvHbzshgzo5STMj/tuDrDqkQEnNmCz7CQQeNtbONmX/wr4mcUMG39eOJLQCcFRZ1COgQ98RQcAOqLB8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We used to scan only the oldest generation in scan_folios(). In
evict_folios(), we checked whether
lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]. If so, the
folio was marked active and moved to younger generations.

This was itself buggy, as folios in generation min_seq[type] - 1
would not be marked active by folio_set_active(), potentially causing
a cold/hot inversion.

Besides this issue, the old approach also differs from the current
behavior, where we can scan fewer than two generations.
Now that we can scan younger generations, including the youngest
generation, this no longer prevents rejected folios from being placed
in a generation below or at the populated generation. Such rejected
folios would then be scanned again and again, resulting in extremely
low `pg_steal/pg_scan` ratios. For example:
  pgsteal_file: 2312605
  pgscan_file:  36465693
  reclamation efficiency: 6.34%

We pass `scanned_seq` to `move_folios_to_lru()` and make sure we either
promote the folio or place it in the youngest generation when the
populated generation is already the youngest one.
Also, folio_set_active() is no longer needed.

With this change, the results become:
  pgsteal_file: 2683815
  pgscan_file:  4224244
  reclamation efficiency: 63.53%

The sys time for building the kernel also decreased from 4m30.532s to
3m50.188s while swappiness==1.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 include/linux/mm_inline.h | 22 +++++++++++++++++++++-
 mm/vmscan.c               | 24 ++++++++++++------------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index da04d81a819c..0a055a3fe210 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -332,7 +332,8 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
-static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
+		unsigned long scanned_seq, bool reclaiming)
 {
 	unsigned long seq;
 	unsigned long flags;
@@ -347,6 +348,8 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 		return false;
 
 	seq = lru_gen_folio_seq(lruvec, folio, reclaiming);
+	if (scanned_seq != -1UL)
+		seq = max(seq, min(scanned_seq + 1, lrugen->max_seq));
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
@@ -362,6 +365,17 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+{
+	return __lru_gen_add_folio(lruvec, folio, -1UL, reclaiming);
+}
+
+static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct folio *folio,
+		unsigned long scanned_seq)
+{
+	return __lru_gen_add_folio(lruvec, folio, scanned_seq, false);
+}
+
 static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
 	unsigned long flags;
@@ -420,6 +434,12 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
+static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct folio *folio,
+		unsigned long scanned_seq)
+{
+	return false;
+}
+
 static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
 	return false;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0731059b169d..bde67da7db57 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1864,7 +1864,8 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
  *
  * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
+static unsigned int move_folios_to_lru(struct list_head *list, unsigned long seq,
+		bool do_rotate)
 {
 	int nr_pages, nr_moved = 0;
 	struct lruvec *lruvec = NULL;
@@ -1921,7 +1922,7 @@ static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
 		    !folio_test_referenced(folio) &&
 		    folio_ref_count(folio) == folio_expected_ref_count(folio))
 			lruvec_add_folio_tail(lruvec, folio);
-		else
+		else if (seq == -1UL || !lru_gen_add_rejected_folio(lruvec, folio, seq))
 			lruvec_add_folio(lruvec, folio);
 
 		nr_pages = folio_nr_pages(folio);
@@ -2040,7 +2041,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	move_folios_to_lru(&folio_list, true);
+	move_folios_to_lru(&folio_list, -1UL, true);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2151,8 +2152,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	nr_activate = move_folios_to_lru(&l_active, false);
-	nr_deactivate = move_folios_to_lru(&l_inactive, false);
+	nr_activate = move_folios_to_lru(&l_active, -1UL, false);
+	nr_deactivate = move_folios_to_lru(&l_inactive, -1UL, false);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -4748,7 +4749,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list, int *isolatedp)
+		       struct list_head *list, int *isolatedp,
+		       unsigned long *scanned_seq)
 {
 	enum node_stat_item item;
 	int zone_idx;
@@ -4779,6 +4781,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		seq = lrugen->max_seq;
 
 	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+	*scanned_seq = seq;
 	gen = lru_gen_from_seq(seq);
 	max_gen = lru_gen_from_seq(max_seq);
 
@@ -4975,6 +4978,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int tier, scanned, reclaimed;
 	int isolated = 0, nr_isolated = 0;
 	unsigned long total_reclaimed = 0;
+	unsigned long scanned_seq;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4986,7 +4990,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	tier = get_tier_idx(lruvec, type);
 	scanned = scan_folios(nr_to_scan, lruvec, sc,
-			      type, tier, &list, &isolated);
+			      type, tier, &list, &isolated, &scanned_seq);
 	nr_isolated = isolated;
 	if (nr_isolated)
 		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
@@ -5012,8 +5016,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-		DEFINE_MIN_SEQ(lruvec);
-
 		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
 		if (!folio_evictable(folio))
 			continue;
@@ -5032,11 +5034,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		 * so this effectively promotes them by at least one generation.
 		 */
 		folio_set_lru_refs(folio, 0);
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
-			folio_set_active(folio);
 	}
 
-	move_folios_to_lru(&list, false);
+	move_folios_to_lru(&list, scanned_seq, false);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
-- 
2.34.1


