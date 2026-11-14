Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4B2606A336
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MU8/PM9A
Received: by kanga.kvack.org (Postfix)
	id 330296B05E5; Sat, 14 Nov 2026 15:09:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9836B05E6; Sat, 14 Nov 2026 15:09:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10BE46B05E7; Sat, 14 Nov 2026 15:09:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF8466B05E5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:09:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF5FB120407
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:01 +0000 (UTC)
X-FDA: 85434813282.14.C24313F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1E1F040005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MU8/PM9A";
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzl9uKxDxuGWSa9/rVnIBZinQJOI3Q+lDPTPYjD7Ps4=;
	b=M8nkGrqv64OCca7lbZgZ7BYZ2Ii8pgblM2/ikIdZ+z89wAC7qMCb4n/RhmVsGf+vKAnjcA
	9fSN0Ha8vUCwWJv+UMKei7sJt3F312JI+PaNwWQsF0Z9ed7dmaz7rIsh2EUhqKu+lF4E+A
	zbuzyNhhGr+kQr+KPc/7ZNbvbnb+uLA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686940;
	b=tdIqt7+3yXmzlSOP1H4Rb+RnThNhXwiU4JrWqpnz9pCTLC1G2k1w2htRWwOKSmG7w3kxvJ
	fLNCJdR2dkm7R6rCGoQd1rcdgeTCZjb0goV4c+Dk+pZ0nVJXa3D8bZteAVVaW9UOZ6srxc
	RiHSl+yJ+StCRbbO1E9EjwG10ClHQRE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MU8/PM9A";
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73B944358E;
	Sat, 14 Nov 2026 20:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984651F000C6;
	Sat, 14 Nov 2026 20:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686939;
	bh=lzl9uKxDxuGWSa9/rVnIBZinQJOI3Q+lDPTPYjD7Ps4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MU8/PM9AHX16c1sgnIDmJFrqqhX7443lqPH63vsyXvytOM1S8iug23bUFEIWz5D2d
	 4MKJwYaencqFEe3PBCotA9bWREeBNM5nnlL4cSvKwWiXJ8ra/s+owHV5HpL8Eo+6LS
	 L2gn1w2OgzQcX5hXNO4LD1qz74wSYimYdchCoGLK2YtLfUuQOaAsWtxtTaHYxSYCv2
	 4zwtVzlnF+FpHnnq897OoH9pi5jwgoZg6NcpLBNShSs8bjxMGVkvL9+rjhcr1qloG/
	 mScyEvBfUZcFNeJQr7hKJpUBrp6d1tu+NeN4Z0EML7Jwhelzl01IFs7nLvO2ElGPEX
	 o9xoKxCGdfMCA==
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
Subject: [PATCH v9 09/16] mm/mglru: Avoid placing rejected folios below populated gen
Date: Sun, 15 Nov 2026 04:07:56 +0800
Message-Id: <20261114200803.23129-10-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: exfzxjixe36xxua6yzu5wuhsyxhwbznb
X-Rspamd-Queue-Id: 1E1F040005
X-Rspam-User: 
X-HE-Tag: 1794686940-633772
X-HE-Meta: U2FsdGVkX1+YpR/tUECRenaBYDTzwum2F1P+bpzKQX0FRNDmCJk2A0LzYpTB9lxA/XD1c4qcIRQ3w20m/JmK0ZscSYBzXHrSo8oWowHt5p7z7mAP3HX33EI77Mt41Xk32XbAbT7PQaXMurn0AwJ7l2wl5sIpaAy0HWmCZkx9MwHdg61KBjpGhlJ3Z0eUyZJdr7XCZ0nUbQl63HxYC6s5LesShgVYNrHioqNTbrCj0RPjn16RDK3fVMbrPd7rGmiNbickxQrTHmBWvMEWA7bXUvlFzcnQJ7wHiXpw7pX2LyTmWNyTlXPNgLacHZ117xC/8OIjt1BmlpTMEuYibiraKgTM0WGeq0H7C3CTWmBulgiau6Z0u9f/2002qxBp55jeYtVMsvFLgsFgkP9HpU7WPvrakoZuN/aV9Xw0l65FX6BrKzQE3k1dSshDnBIEd1OhbwD4D4nuVMA89l1h5NTgSZg4dB+0DYHdn3VJhNfd0BSs7kAg/c8xUg+0hiL0d9oiFXgeVfgHsAZCe/45rlGBI+5PjSaPwba3SvcKC+DB5wlmAhBfGqBdQUK70WOXAK4ucnoHpKHVbe6J/oSo6s4hxe8wcyO1H+pngoXUDRPMdYmYosD6/3tFzuk3By4mU/d0qWxtUfHZlPrLwc8HphEew1pvHFmd+4qad7wIvdnsB6UrudNX9pt37Zc4md0Pu+bC9MVNOtrDGcnwBgZyAhIwXZW2RaBTOEVcSMl4jgVxYtn34xYSMsQRI0PBWeQDOv1Kg9PdLrGxO0Dh0aKlnCFkLVTpABktieWo1zZX0ZDmYwTu6+BARCjz8SNZIqpWE67zzC+yh6dfDMzUzgWWu35RBsEChAlHeFS5enjC6xCMHJphgpSdlkwORgKCMAVAPCWsdF4rC+fMxEj3hsZYxtKltSd9h6Qc9O1ZYcxmxdRwAi4L97JyPkAW1ii9A8J22V76sFxv+3RWj6TFTKOUi18
 Zdg1oQs5
 4xa3mzqZgQlVwf2L6rkmF/x+iZKDUK6jEkHbMaue3UdxA4Cwxoo2BGRbLQNoprKUZqU7iugXFKM2Lw7XwqF2n0n45h6hHAdSqV0kSJgGcVxf7DacsCaY1+5N0AT/6td7vMb+xn2i3QNyx5Gxrd3KabG/BmsVGjvbV8y382Q4WauEecEFTrNGQII+C+uBCNVAPz/LIT+6L6EZC+ZBjTPZWztH5Ze99DJyeOS/+M4s77eMmdW8wNDyu1d+/4jR5HD9tvJn6RtVVJRw/kFNo8yAafiuO49mkc3M9fjU92ZEEm/FVT6iiwUZGSe5HmpAfINMuv9SuBUleNQTm654=
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
index ab69b9930893..f6f4bc9a704f 100644
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
index b538abf02578..0fef966b0a14 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1865,7 +1865,8 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
  *
  * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
+static unsigned int move_folios_to_lru(struct list_head *list, unsigned long seq,
+		bool do_rotate)
 {
 	int nr_pages, nr_moved = 0;
 	struct lruvec *lruvec = NULL;
@@ -1922,7 +1923,7 @@ static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
 		    !folio_test_referenced(folio) &&
 		    folio_ref_count(folio) == folio_expected_ref_count(folio))
 			lruvec_add_folio_tail(lruvec, folio);
-		else
+		else if (seq == -1UL || !lru_gen_add_rejected_folio(lruvec, folio, seq))
 			lruvec_add_folio(lruvec, folio);
 
 		nr_pages = folio_nr_pages(folio);
@@ -2041,7 +2042,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	move_folios_to_lru(&folio_list, true);
+	move_folios_to_lru(&folio_list, -1UL, true);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2152,8 +2153,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	nr_activate = move_folios_to_lru(&l_active, false);
-	nr_deactivate = move_folios_to_lru(&l_inactive, false);
+	nr_activate = move_folios_to_lru(&l_active, -1UL, false);
+	nr_deactivate = move_folios_to_lru(&l_inactive, -1UL, false);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -4753,7 +4754,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list, int *isolatedp)
+		       struct list_head *list, int *isolatedp,
+		       unsigned long *scanned_seq)
 {
 	enum node_stat_item item;
 	int zone_idx;
@@ -4784,6 +4786,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		seq = lrugen->max_seq;
 
 	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+	*scanned_seq = seq;
 	gen = lru_gen_from_seq(seq);
 	max_gen = lru_gen_from_seq(max_seq);
 
@@ -4980,6 +4983,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int tier, scanned, reclaimed;
 	int isolated = 0, nr_isolated = 0;
 	unsigned long total_reclaimed = 0;
+	unsigned long scanned_seq;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4991,7 +4995,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	tier = get_tier_idx(lruvec, type);
 	scanned = scan_folios(nr_to_scan, lruvec, sc,
-			      type, tier, &list, &isolated);
+			      type, tier, &list, &isolated, &scanned_seq);
 	nr_isolated = isolated;
 	if (nr_isolated)
 		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
@@ -5017,8 +5021,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-		DEFINE_MIN_SEQ(lruvec);
-
 		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
 		if (!folio_evictable(folio))
 			continue;
@@ -5037,11 +5039,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
2.39.3 (Apple Git-146)


