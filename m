Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592A0606A339
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YbjhB/hf
Received: by kanga.kvack.org (Postfix)
	id A25E76B05E6; Wed, 11 Nov 2026 18:27:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD436B05E7; Wed, 11 Nov 2026 18:27:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89EC66B05E8; Wed, 11 Nov 2026 18:27:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6CC6B05E6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:27:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C152D1A03B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:00 +0000 (UTC)
X-FDA: 85424425800.20.8F9E1D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2709B20006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YbjhB/hf";
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439619;
	b=eywSnd0DCfahNChtxl8pCS59AfZWzEAA/8ECYNZCS7E5zP0c5eiZyUarWkrPVuy1pjnvlP
	YfLEkeg9jgOMsfIlY89jLrmpMxOfElx0VtkINuEuoVLGiCEOKutk9j1wdMcQLwRqtNoSJa
	yrFt0M4EIW6/OZWfyuuojFo+JVpLFDY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YbjhB/hf";
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJxYHKJjwXKsu2hlwRaRpHsizHesobIZOm9pboS/Wn4=;
	b=X5dSYUXNKC+8v5bJI6aA0vp5l9w4ANbqSY7uwG295vV5ltRPZf5K6h32ZlQEp9O9BXjlLh
	jxRI8WGKgr/Lu+O658yp62Z+RZOX3XMFoO1lc5rUmjDcF+5+g2lbNYIsMyWZkhkeMXjeIz
	8mFsEjeLIMZTqNhOEPx8os4FOlnRrR8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83646405FB;
	Wed, 11 Nov 2026 23:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32301F00A05;
	Wed, 11 Nov 2026 23:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439618;
	bh=FJxYHKJjwXKsu2hlwRaRpHsizHesobIZOm9pboS/Wn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbjhB/hfjup11wsQFRtDV1m9sJwxcn+/JrqA+rMeex5Qe2ZAYXFrUUYjuAQ3SwdBj
	 3c/IXt2IL5MCvVa8lPUOmA9b7tHFOnP0ioYzyZoZHU+DQgejo+N+tRceksZi9Vcjzc
	 h30/CHx4n8ZUKGQvXTTHzDtS7QmjmqlJ0C3Y7RHQQJdYUNPXrFXT24TrcC3Tdp7F17
	 gN4t2A1nccE0cgvSxITDdV/9MSrzzYCDsbBcDgwPOMjs8Pt3xhULOBDS25VdKRI01I
	 7RChjCqLEmlYLdm5xFllSY8ONXx95iKvP2yG8uiV61C18fM1qPQjL3pXB4uQlILVc0
	 O23lb8rCI9yKg==
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v7 09/16] mm/mglru: Avoid placing rejected folios below populated gen
Date: Thu, 12 Nov 2026 07:25:56 +0800
Message-Id: <20261111232603.9934-10-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x3ndz3p1y64shbyzfzm4z151wmkgot8r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2709B20006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439619-490279
X-HE-Meta: U2FsdGVkX1/D2iaGkUXPwqiR7zWAcasbwgao6mFecsvn+954MTTeAOA+yKF1zErV9xAdbbuXEjqHKXW3+sWlQ1AkAIwGOjU0QC2mOvFnOFH29OJGMv9vF+n6ElZxr08hEeeKnIQqSuy9dP5ylN5ZgDwdNnzQBDLFeuQxB5enozGd+x8NpgRVQCBeJeNEKXusngt4TItlNW0wPpDVYTwO92x4+kcoE/Kcdg4oEtTYR7FM4W+GKbWYIR5uS/gvCC7ZbxIpD+xy5/Kn2ZklOAhqFr9WMrjUn15fy+lSaPi6efrf7+XWCPIvVe624xCu/gYpPqC5LtgIMZtLzs977Xq5GgSIvDwoFoDX/Zdvo9nrqWDxOeXdnXQ6nhxUddO9rjl8UdLyUpT5svjVILdc4AjlaqJB8wgIM+74/5CEqCENhCBA0mRQ2B2sgmkIzmeC1mL/z5lB7u0n2qljQe8u1tglUVmX69hvJV7MRYRa/klznTyY6XHvHQCTZjLHTM6O3xIEx45NAHX8D98ywV+Dzq4mzFX6yZds1N76G0jzYCiduMvU8Xp8us+VRb6ELUr7fCQuamy5199vQcOjAiKZw1K2DRIzSq7F4A4g69l2Gzamv+5my/5DWHn/znC+ROd3c5KAOz00Jwm2T9qGkrqkAeSoncAxpUZFgEn8jfIG2SPU4GdlR+9rSKHSVmBqx1bERhhRfbEWqbFofPchJGcb21ffh7bs+KAly0jYzEymMeiCCsxvnfJ/oIgTXKORF1knUOCVj319l9SoBPUYFRGNtIORaGwdZkBw/D99KDS1GckUdtEUDS6L11ncXEYeY5HQYAcsFnsLh0gHY1mUOSJRf2mHTK0HTh9JfOuNpPqPl+wo5IsXKe0hhVqL1oqt7TUUnBGg9WjaC+eX4R3+cWLQlXZ3gERUvILSB8XL2OL7jfid6p+Avxfk6/4W1KZN/3hMpNcsFeFxsui94+QNxBwIzWt
 hWe9XJ76
 mhYhrGZAmTYQeWer630RsmMkfOW/GrB3fCj6CK3x+Ao2G4fqoGvQEfYU16fqXVf1sngQn3Vyp1V3dhdVPpVykIfLASNmLRdiG3pOweX9kiUGk9zXEkQA+yQfY63lK69S5RznjVET3zfJh0LX3K8ZA3/UFklboNGV0Cv7C3SSHbtiMnQXqMDaLbx2A10wp6JSN3jklVWD4l29RKrtc2Tsr+4OXDxKZpR+JSXsmfv2QyWE64YOFQ1UUgG7ZnUhaK00CavcoF4Ux5plILpwrb8rmCe4I3vPVamdYFJ4OoImVM1PDUaLZU1wKIjdnYjNjyr0+upbNe0DeBdQKS48=
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
index fff7ee17eb0d..c5c4d6418d46 100644
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


