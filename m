Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E20E606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 22:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pQ1xnE8y
Received: by kanga.kvack.org (Postfix)
	id 71F8A6B00EF; Sat, 14 Nov 2026 17:09:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5C86B05B0; Sat, 14 Nov 2026 17:09:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6306B05B1; Sat, 14 Nov 2026 17:09:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 311FA6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:09:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 484D9804AC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:09:54 +0000 (UTC)
X-FDA: 85435117908.27.84B6D8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3EE69160004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:09:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pQ1xnE8y;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794694192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZRbRJI9Vfz0+GoIhf4fGkbxNtQ+z8NpL4ZipSXqN5g=;
	b=XR2qpjXTe7lvEPpa3jNh28NRA9IOC7iyASBzvA5D+TvusbbgsTKnccmODwGtS6fKLlFwC7
	DryVYcwPGNAJ5hWqLWOUjS8OS54VzQHfFy+Of9E/jPHv9BGl5/pA4s5FrcFp4h85f5wleQ
	Uu65ozmla6RkSjAYsnJXZM4jLY0itig=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pQ1xnE8y;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794694192;
	b=7zONushPYZBV4TiWMrQFwFeEPeRJPtsqQcX2a6Qq1JdIps1cyWLjnL2fWqFGvK8CIQcjzq
	KPh6azeXTvNwxIvkB5KMBO61EZZgaFBuiMn47PSjaB1VXkZgyp53RiQcnREGVLigkiqyH1
	3EjqiSxDJ/UTKVUPLOZYsdouUrItV7g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6268540C08;
	Sat, 14 Nov 2026 22:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF721F000C4;
	Sat, 14 Nov 2026 22:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794694191;
	bh=zZRbRJI9Vfz0+GoIhf4fGkbxNtQ+z8NpL4ZipSXqN5g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pQ1xnE8yPumAkeB71CPePY8aiJFttjOk57W09/iavHP6m48JR7RpUGWYzxnCCtKOY
	 FZ3CK9rV0qhKeAC1POMyJekHHFdfO+Y1xjv+wjfarsWzELIGgc0epGqWOCmc55l4d7
	 teVNR94jewpcIWV27YoNo/t6uDQ/JlBGwx9YQzFY=
Date: Sat, 14 Nov 2026 14:09:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: linux-mm@kvack.org, axelrasmussen@google.com,
 baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org,
 hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com,
 liam@infradead.org, lianux.mm@gmail.com, linux-kernel@vger.kernel.org,
 liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org,
 mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev,
 rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, wangzicheng@honor.com, weixugc@google.com,
 yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn,
 sidchintamaneni@gmail.com
Subject: Re: [PATCH v9 00/16] mm: mglru: fix swappiness behavior
Message-Id: <20261114140949.c47f9cf9c1ea22315092d880@linux-foundation.org>
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3EE69160004
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: j7uqrieatig8tpfb6wim9qnuj7qhwe1m
X-HE-Tag: 1794694192-691622
X-HE-Meta: U2FsdGVkX182LueDvDC7a0sUtBE8JBngnbknQnULAzo8kgpaqyaT25ARDRYtsZWVOdbTT71CN8S/lRGSe6ydX+VRNxf00vhUmF9SXTmdBpZErRTCkWNYxi5KAqUduYLF4POE1ezJCMyPW43r5Qgv1mNIVONMIU7NqIQy2DJxs6Ow7iDSXiA/zD/9IvrIsu8OWe6J/SefgQr3v18LCRB5isY5Y5NhKXP8CDs4mryzJZRPe8mR7/mkPBvuPMfDStjINiNJE/blcA2KOzAk9PITBz0LTAJE54XAaO2qmKR7dXuj8cX1/zeuUP3snplYAin8BRq0GtLuat+sMJ4sZK5pG1tWh2shWi1cyRM3h9YKCcqbaNVUyheVSFKCoowNZjnAPs3IQUAxnPiImreaCrIuCdhsvygydaMh6HvBozmuzk/XSpkoyo5T2XVdk2Sor2gfB87TthnBkuQKqaM0BNmGUbVP+7JsTdCxXA1wx2jfSo8oTYhEKm/xAC4M6EXev3MVIG6nd6UrCYXog4uP25m7SXJBaFiwJERkeHiuLQOFCXPraI9CQVpQhaQp/A6J3d0uIm9Ic7b1LiJVEToPC6IEBzBKFu55SIIPvyBIyj0Mwqeh7am1Mx+s3v7lDAiEpUNQgRNU+ZBzVfsku5c3ju9mJnnx3bRgn23rbTTiKRUhSySzmfTmhG0991EAmYGYuNMc1nnqEAbZozqoBd0St4PBZUtXvg7USuoxvrmUhvFTWDk9jghIeC+oog79UB8tt0r83JGo6G6+koG5qmR87HH++O/YMVAHaOC/NXWfD83ZxfEWP3/jfasgHaqrVvkMZ8de4ZMqI/kJyr/8cw21HLUAstvz9MT3LIozwYOsj64avmaVrv2GrqAY5WbvKe0nOaPavTX3OJB4x9QSMg/UuIqBoY4mjYEiTtK/qvkcRRlDOg/f//S0bE3SPbHjKIF5FtajQRDD59901mmZdoVhuD6
 kRtH34X1
 EBzJ4qIaioQe9V/a0yREAPyRCDN6KLrx15NUroc2cyDwnzLqx7/S++0u4QhbzwmkuzOFsYGUiF2LMnX8eceoMoTqXTpf6VlfAJCvcZHnygC/F1uZD0UR/126/cwg1EgUQIEInIXEl1fD9gYBc0E2a/96iHJ0/28hcoc9ZqgRBZluTCkmj+sROdv1c0UaCsw0r4tvhtnGX9Sf+Cfganlep0A88UbO0W8wV/xYo4+Ko4UAjfeI58YgVzbkLW8hz/6ip6FhjV1C83zIWn93OQ8mtp5sd7CstcDnit627DIAgtjPdeXsxPOUczq0hGvHKosCPNWOuWMLSQmNs4Erq424oYkYvYFiNMP7yrPMP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 04:07:47 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> Classic LRU respects swappiness, while MGLRU only weakly
> honors it when selecting the scan type. The fallback logic
> can easily override the bias established by
> get_type_to_scan(). As a result, swappiness has a much
> smaller overall impact when changing from 1 to 200, as
> shown by the data presented later in this cover letter.
> 
> In this patchset, patches 1-8 from Kairui introduce a model that uses
> refaults to determine nr_to_scan[] for both file and anon in MGLRU.
>
> ...
>

Thanks, I updated mm.git to this version.  I included that Sashiko
fixup.

The patchset does seem to be changing pretty quickly so I'll continue
to hold it in the mm-new branch until things have settled down.

> v9:
> * reduce one iteration for lruvec_populated_min_seq();
> * let lruvec_is_reclaimable() count all zones, for min_ttl;
> * refine lru_gen_imbalanced(), AGING_PRIORITY macro, roundup/down swappiness;
>   per Kairui;
> * let evict_folio_lists() return "drained" per Kairui, thanks!
> * one bounded retry for scanned=0 and reduce concurrent aging
>   for no-populatable(drained) aging;

Here's how v9 altered mm.git:

 mm/vmscan.c |  131 ++++++++++++++++++++++++--------------------------
 mm/vmscan.h |    2 
 2 files changed, 66 insertions(+), 67 deletions(-)

--- a/mm/vmscan.c~b
+++ a/mm/vmscan.c
@@ -2736,6 +2736,8 @@ static bool should_clear_pmd_young(void)
 #define get_memcg_gen(seq)	((seq) % MEMCG_NR_GENS)
 #define get_memcg_bin(bin)	((bin) % MEMCG_NR_BINS)
 
+#define AGING_PRIORITY	(DEF_PRIORITY / 2)
+
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -3995,7 +3997,7 @@ static unsigned long lruvec_populated_mi
 	lockdep_assert_held(&lruvec->lru_lock);
 
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
-	while (min_seq <= max_seq) {
+	while (min_seq < max_seq) {
 		gen = lru_gen_from_seq(min_seq);
 		for (zone = 0; zone < zone_limit; zone++) {
 			if (!list_empty(&lrugen->folios[gen][type][zone]))
@@ -4199,7 +4201,8 @@ static void set_initial_priority(struct
 }
 
 static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
-				  int swappiness, unsigned long nr[])
+				  int swappiness, unsigned long nr[],
+				  int max_zone)
 {
 	int type;
 	unsigned long seq;
@@ -4216,16 +4219,17 @@ static void lruvec_evictable_size(struct
 		if (type == LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc))
 			continue;
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
+			nr[type] += lruvec_gen_size(lrugen, type, seq, max_zone);
 	}
 }
 
-static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc,
+		int max_zone)
 {
 	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	lruvec_evictable_size(lruvec, sc, swappiness, sizes);
+	lruvec_evictable_size(lruvec, sc, swappiness, sizes, max_zone);
 	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
@@ -4244,13 +4248,8 @@ static bool lruvec_is_reclaimable(struct
 	if (mem_cgroup_below_min(NULL, memcg))
 		return false;
 
-	/*
-	 * As in __alloc_pages_may_oom(), avoid triggering OOM for low-zone
-	 * allocations. Also, defer the LRU size check until reclaim reaches
-	 * a very low priority to avoid premature OOM.
-	 */
-	if (sc->priority <= 1 && sc->reclaim_idx >= ZONE_NORMAL &&
-	    !lruvec_is_sizable(lruvec, sc))
+	/* counting all zones to avoid premature OOM */
+	if (!lruvec_is_sizable(lruvec, sc, MAX_NR_ZONES))
 		return false;
 
 	gen = lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));
@@ -4783,12 +4782,15 @@ static int scan_folios(unsigned long nr_
 	 */
 	if (sc->priority == DEF_PRIORITY)
 		seq = lrugen->max_seq - MIN_NR_GENS;
-	else if (sc->priority > DEF_PRIORITY / 2)
+	else if (sc->priority > AGING_PRIORITY)
 		seq = lrugen->max_seq - 1;
 	else
 		seq = lrugen->max_seq;
 
 	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+	if (seq < lrugen->min_seq[type])
+		return 0;
+
 	*scanned_seq = seq;
 	gen = lru_gen_from_seq(seq);
 	max_gen = lru_gen_from_seq(max_seq);
@@ -4893,8 +4895,8 @@ static int get_tier_idx(struct lruvec *l
  * r_file / r_anon: refault rate for file / anon.
  * w_file / w_anon: LRU size weight of file / anon.
  *
- * We don't calculate the scan cost, MGLRU uses lazy promotion, which will
- * cancel the scan budget natually.
+ * We don't calculate the scan cost. MGLRU uses lazy promotion, which will
+ * cancel the scan budget naturally.
  */
 static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 		int swappiness, unsigned long total_scan, unsigned long nr[])
@@ -4950,12 +4952,12 @@ static void lru_gen_balance_scan(struct
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
 	if (swappiness == MIN_SWAPPINESS + 1)
-		anon_factor = sc->priority <= DEF_PRIORITY / 2 ?
+		anon_factor = sc->priority <= AGING_PRIORITY ?
 			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
 	else
 		anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
 	if (swappiness == MAX_SWAPPINESS)
-		file_factor = sc->priority < DEF_PRIORITY / 2 ?
+		file_factor = sc->priority < AGING_PRIORITY ?
 			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
 	else
 		file_factor = (u64)(MAX_SWAPPINESS - swappiness) *
@@ -5090,9 +5092,18 @@ static bool lru_gen_imbalanced(struct lr
 	DEFINE_MIN_SEQ(lruvec);
 	int type;
 
-	if (sc->priority > DEF_PRIORITY / 2)
+	if (sc->priority > AGING_PRIORITY)
 		return false;
 
+	/*
+	 * Round up or down corner swappiness, to balance the heavy biased
+	 * type better
+	 */
+	if (swappiness == MIN_SWAPPINESS + 1)
+		swappiness = MIN_SWAPPINESS;
+	else if (swappiness == MAX_SWAPPINESS)
+		swappiness = MAX_SWAPPINESS + 1;
+
 	for_each_evictable_type(type, swappiness) {
 		unsigned long seq;
 
@@ -5102,23 +5113,12 @@ static bool lru_gen_imbalanced(struct lr
 	}
 
 	/* the vast majority of pages sit in the youngest gen */
-	if (youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
-	    (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS)
-		return true;
-
-	/* Swappiness extremes: the corresponding type matters */
-	if (swappiness == MIN_SWAPPINESS + 1)
-		return youngest[LRU_GEN_FILE] > old[LRU_GEN_FILE] * MAX_NR_GENS;
-
-	if (swappiness == MAX_SWAPPINESS)
-		return youngest[LRU_GEN_ANON] > old[LRU_GEN_ANON] * MAX_NR_GENS;
-
-	return false;
+	return youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
+	       (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS;
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     struct scan_control *sc, int swappiness,
-			     bool no_populatable)
+			     struct scan_control *sc, int swappiness)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -5130,13 +5130,6 @@ static bool should_run_aging(struct lruv
 	if (sc->priority == DEF_PRIORITY)
 		return false;
 
-	/*
-	 * Run aging if scan budget remains but no folios
-	 * in populatable generations are available to scan.
-	 */
-	if (no_populatable)
-		return true;
-
 	/* better to run aging even though eviction is still possible */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
 		return true;
@@ -5151,7 +5144,7 @@ static void lru_gen_prepare_scan(struct
 {
 	unsigned long total;
 
-	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
+	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
 	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
 
 	total = apply_proportional_protection(memcg, sc, total);
@@ -5190,7 +5183,8 @@ static bool should_abort_scan(struct lru
 }
 
 static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec *lruvec,
-			     struct scan_control *sc, int swappiness, unsigned long max_batch)
+			     struct scan_control *sc, int swappiness,
+			     unsigned long max_batch, bool *drained)
 {
 	int type;
 	unsigned long batch, scanned, total_scanned = 0;
@@ -5206,6 +5200,8 @@ static long evict_folio_lists(unsigned l
 		batch = min(nr_to_scan[type], max_batch);
 		scanned = evict_folios(batch, lruvec, sc, type, swappiness);
 
+		if (drained && !scanned)
+			*drained = true;
 		nr_to_scan[type] -= min(nr_to_scan[type], scanned);
 		total_scanned += scanned;
 	}
@@ -5221,16 +5217,15 @@ static long evict_folio_lists(unsigned l
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[ANON_AND_FILE];
-	bool need_rotate = false, should_age = false;
+	bool need_rotate = false, should_age = false, retried = false;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	/*
-	 * Avoid aging the lagging type under extreme swappiness,
-	 * as reclaim of the unpreferred type is disabled until
-	 * DEF_PRIORITY / 2.
+	 * Avoid aging the lagging, unpreferred type at extreme swappiness;
+	 * rely on imbalanced aging once priority reaches AGING_PRIORITY
 	 */
-	bool allow_no_populatable_age = (sc->priority <= DEF_PRIORITY / 2) ||
-		(swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAPPINESS);
+	bool allow_drained_age = sc->priority < DEF_PRIORITY &&
+		swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAPPINESS;
 
 	/*
 	 * Proactive reclaim initiated by userspace for anonymous memory only.
@@ -5248,9 +5243,9 @@ static bool try_to_shrink_lruvec(struct
 	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
 
 	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
-		unsigned long orig_file, orig_anon;
-		unsigned long max_seq;
-		bool no_populatable;
+		bool drained = false, do_drained_age;
+		DEFINE_MAX_SEQ(lruvec);
+		unsigned long new_seq;
 		long scanned;
 
 		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
@@ -5258,9 +5253,7 @@ static bool try_to_shrink_lruvec(struct
 			break;
 		}
 
-		orig_anon = nr[LRU_GEN_ANON];
-		orig_file = nr[LRU_GEN_FILE];
-		scanned = evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH);
+		scanned = evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH, &drained);
 
 		if (should_abort_scan(lruvec, sc))
 			break;
@@ -5272,20 +5265,26 @@ static bool try_to_shrink_lruvec(struct
 		if (root_reclaim(sc) && should_age)
 			break;
 
-		/* Limit no_populatable aging to once per try_to_shrink_lruvec() */
-		no_populatable = allow_no_populatable_age &&
-			((nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] == orig_anon) ||
-			(nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] == orig_file));
-		allow_no_populatable_age &= !no_populatable;
-		max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
-		if (should_run_aging(lruvec, max_seq, sc, swappiness, no_populatable)) {
+		/*
+		 * Allow drained aging only once per invocation and skip it if
+		 * max_seq advanced concurrently during eviction
+		 */
+		new_seq = READ_ONCE(lruvec->lrugen.max_seq);
+		do_drained_age = drained && allow_drained_age && max_seq == new_seq;
+		allow_drained_age &= !do_drained_age;
+		if (do_drained_age || should_run_aging(lruvec, new_seq, sc, swappiness)) {
 			trace_mm_mglru_aging(lruvec, sc, swappiness);
-			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+			if (try_to_inc_max_seq(lruvec, new_seq, swappiness, false))
 				need_rotate = true;
 			should_age = true;
 		}
-		if (!scanned)
-			break;
+
+		if (!scanned) {
+			/* Retry once if aging advanced max_seq */
+			if (retried || max_seq == READ_ONCE(lruvec->lrugen.max_seq))
+				break;
+			retried = true;
+		}
 
 		cond_resched();
 	}
@@ -5332,7 +5331,7 @@ static int shrink_one(struct lruvec *lru
 	if (need_rotate)
 		return MEMCG_LRU_YOUNG;
 
-	if (lruvec_is_sizable(lruvec, sc))
+	if (lruvec_is_sizable(lruvec, sc, sc->reclaim_idx + 1))
 		return 0;
 
 	/* one retry if too small */
@@ -5915,11 +5914,11 @@ static int run_eviction(struct lruvec *l
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
+		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
 		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
-		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
+		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH, NULL))
 			return 0;
 
 		cond_resched();
--- a/mm/vmscan.h~b
+++ a/mm/vmscan.h
@@ -117,7 +117,7 @@ struct scan_control {
 };
 
 #ifdef CONFIG_LRU_GEN
-/* The number of pages of @type in the generation @seq, summed over all zones */
+/* Number of pages of @type in generation @seq below @max_zone */
 static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
 					    int type, unsigned long seq,
 					    int max_zone)
_


