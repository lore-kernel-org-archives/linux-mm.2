Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 511A0C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531B36B0095; Wed, 26 Aug 2026 03:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E30E6B0096; Wed, 26 Aug 2026 03:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8C06B0098; Wed, 26 Aug 2026 03:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2FF6B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:53:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B123F1A02D4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:52:59 +0000 (UTC)
X-FDA: 85142654478.15.100CA53
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4837280005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:52:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=EC5u6CFv;
	dmarc=pass (policy=quarantine) header.from=unisoc.com;
	spf=pass (imf02.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787730777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1ljfxh0QQvke3/JuhIoWXsbYDuhyNNb2x/9KR07BP2M=;
	b=UJ7y8NFge8bC4q/cI1bhP5hgDN2EjvbFwAkhx1DN12wfN+wZHTx/Jqqx/HuqE4JwZdKEP2
	YfobRZD0olM0C1QGYsDDsnfmxoZfhgIry93UHBveP+mUbhe7QG5jP6DKqcWdq/F/xU6NQK
	8HtQxwuAAzRdHiDC3nxv+vijkIgCIkE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787730777;
	b=rsD/XjjGNIpHG8KxTB+U/4+R7U64okEDZvf5U0oeN2LXb6vaGgGxRwRCyIpnd0BUZbiMXY
	ffDqQ7cwMg/sMdgIXq7J2fWaLqPwt+9J65JUIS9hMy+qHvx26o97CXl8aBfTtHVzqj8o72
	RStqAMHcBhwiTEjq6hDjQ0bBjYqsEI8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=EC5u6CFv;
	dmarc=pass (policy=quarantine) header.from=unisoc.com;
	spf=pass (imf02.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTPS id 67Q7piCL006362
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 26 Aug 2026 15:51:44 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4hVGzP6wZjz2K1r9x;
	Wed, 26 Aug 2026 15:50:41 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Wed, 26 Aug 2026 15:51:41 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand
	<david@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Johannes Weiner
	<hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Qi Zheng
	<zhengqi.arch@bytedance.com>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo
 Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang
	<huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH] mm: workingset: judge cross-memcg refaults by generation age
Date: Wed, 26 Aug 2026 15:51:33 +0800
Message-ID: <20260826075133.751049-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 67Q7piCL006362
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1787730717;
	bh=1ljfxh0QQvke3/JuhIoWXsbYDuhyNNb2x/9KR07BP2M=;
	h=From:To:Subject:Date;
	b=EC5u6CFvKVqzykWYyhm1uLick9XrvOidGA+taumg/amu1lxTKY4075bAY/oFlXMxR
	 xd8vEU/rA2vhK3/iolI7WDGlw6f+wanBP2RqtDqookzwFm+IL0CjevzmRpReQlItLZ
	 cRaYr7fDWnbJAXbcKi5GxzToUpEVPq4p87mBkW6QNF8ugI5M718SPf07F+oveUqrnF
	 +r1caHAJjRbi0lbRU9bBpCbDa2iKgvjk6jxjyeq6QZLMep8EIGz/BeYlSYW5YrIm9e
	 r1CXqiPkZf+P1nNiySx7PGMSo9Otue/7td6UFVInF4Ip7LjIw2x8Fq10jz0FEshMSc
	 p06Emn4bgyqsQ==
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4837280005
X-Stat-Signature: mgsipysqdk4jzoknyur8uodbgf9p73g9
X-Rspam-User: 
X-HE-Tag: 1787730773-679499
X-HE-Meta: U2FsdGVkX18PVnVCsieWIfLHU4N7YjB+F5VVX7iBVoX1sqS661oP6fv/rFQ3yHOrr5Uyzn9CNNvBIUEEkG2VwL/Tzg7l5H3TI2KwBFx9TfzELZ951Xel7oxDFMuVsskQGh5LLpdiotWi3rJf4bHNdMCC65hSDNdD6p49QyOyb/2G4TnnrYBCQuUw70jZI3EMrp6z/diZaPLGe8cJJjpNGcfeC0MwYmn5BIgLxl8hOHwn3skp9DJY90hD8LCNXtH0kspHpdUplSimJMemzYFiltrkl5ZqfS99jKGq9/WDN4nANL42SiVyhkMyRUz0VZCnDk5I5hzxNbyXmcLVbbP0LtynXZAORuMnoW/J+bejNTLPM4i1i2Gs/bJIrdbMN+zN8DrH5uTqHikGsi5Jt9sfH4FKdKjgEri7+MFoOTPkeEMscMBj4uinzF4wDuB4M0TKt+jKeWPsSf2i3gK4qWesqe613MpEobAFSXP6PviSLd5fHehxPTNwQ7PH7FWVdxNL5xiEHRHgcPqy1ErRpk0izlVX+gjUdUzF+ycTrbamcP3eqy77+qxFeYwLt2qjBvrdhwEsw7/et7DObgAbUCnsCFJGk/RynJBcMiS/ke90nvwbmVB2oItEra9jFA6MYU5oQlMdpri22HazKD8VH1DQ5kcRLYRGCrm41Sv7TnA2ufYfNIS5HURK63qcWqCbrvE4l+lxJSvs5wOGEM+u1t+Vxm/I4ftpi29OmgMGyOmflh2jNKC8Shag6J2JsyqwHWWrVgvjGDu0k60QOhNrg6K+UUAqFccCU2oX6cPdFRgZj/S++AYj+2FkCzPGdyDkpWY8F2J2fZnxusTveTYeFfPZBgi+Y5X4j7gKOFC2UOi5ugP/vBcdPq5supUqLj8FGxA4cNoVNLDHahv9AHsqmXSl99ICKmMAmPzMSEzPL4Oaelv8WoAbt2UEp0sKtK7jObskR0qkoTF2MiY5iICfJAv
 GjZC48ry
 W62pzhyG4nwE2hWUsA8hYH/Wg0fHSwADY2yJjoKO1LYcmS4pYwUuMeT8VB4zldvlwajRTnulQsHqVXMS8B3ARx4lGOIy5+4xyQpP9BtPj2oJRoSuhAxi1e7crEq6knmIjbLYWzh8kt8sYVThzRGkJDE0AmHSHcPtt26pzyWFnPhT9ah1ivVVJ4EG35ejzyW0hsBz8XZN9ArxkiowY8iqXrrjZ8juwp8bToy6S8v4QnjhjJreaP2jJbs4DBrmx1hKPEUbavHFdGTYLM0jNq3oHXPGYCQxnvnpX02YrImIgq+iUL8u55kjrOOr5KiHp9fW/Ggf+yrfw6NxDtDdM3xGloop4D6A90WAholU3PaiLx5oYr0ZupsrziQxrXzThmVU9kUKzo7ZAR2R3+uI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Unexpected anon folio scan rate is observed in a per-pid topology
memcgv2's hierarchy even with swappiness=150, which is believed as
the concequences of belowing rule which discarded all feedback for
the destination cgroup: no WORKINGSET_REFAULT accounting, no
activation hint, and no tier or workingset restoration. Shared
mappings faulted back into another memcg could not signal recent
usefulness to MGLRU in that cgroup, weakening thrashing detection
and protection for cross-cgroup file cache and folios that moved
between memcgs.

	if (lruvec != folio_lruvec(folio))
		goto unlock;

The failure mode is structural: min_seq and max_seq are per-lruvec
generation counters with independent sequences, so their numeric
gap is meaningless across lruvecs.

Store a truncated eviction timestamp (jiffies) in the shadow token
next to min_seq, reserving at least 16 bits for min_seq so the
same-lruvec sequence test does not wrap at the shorter LRU_GEN_WIDTH
interval. Same-lruvec refaults keep the existing sequence-based
recency check.

For cross-lruvec refaults, compare elapsed time since eviction with
the age of the middle generation in the destination lruvec's
MAX_NR_GENS window. Refaults inside that window are treated as
recent and workingset feedback is attributed to the destination
lruvec.

This restores refault-driven reclaim hints for shared cache without
comparing unrelated generation numbers, while leaving the common
same-lruvec path unchanged.

With this commit, we can observe the anon scan rate raises under same
enviroment.

Co-authored-by: Cursor <cursoragent@cursor.com>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/workingset.c | 65 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 6 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 07e6836d0502..e55e5a75acb9 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -199,6 +199,28 @@
  */
 static unsigned int bucket_order[ANON_AND_FILE] __read_mostly;
 
+#ifdef CONFIG_LRU_GEN
+/*
+ * LRU_GEN shadow token layout within the eviction field (low to high):
+ *   LRU_REFS_WIDTH bits: refs
+ *   EVICT_SEQ_WIDTH bits: min_seq
+ *   EVICT_TS_WIDTH bits: eviction time in jiffies
+ *
+ * Size the layout for the tighter anon mask so the token fits both file and
+ * anon shadows. Keep at least 16 bits for min_seq so the same-lruvec recency
+ * check does not wrap at the much shorter LRU_GEN_WIDTH interval.
+ */
+#define EVICTION_BITS		(BITS_PER_LONG - EVICTION_SHIFT_ANON)
+#define EVICT_PAYLOAD_BITS	(EVICTION_BITS - LRU_REFS_WIDTH)
+#define EVICT_TS_WIDTH		(EVICT_PAYLOAD_BITS > 40 ? 24 : \
+				 EVICT_PAYLOAD_BITS > 16 ? \
+				 EVICT_PAYLOAD_BITS - 16 : 0)
+#define EVICT_SEQ_WIDTH		(EVICT_PAYLOAD_BITS - EVICT_TS_WIDTH)
+#define EVICT_TS_PGOFF		(LRU_REFS_WIDTH + EVICT_SEQ_WIDTH)
+#define EVICT_SEQ_MASK		((1UL << EVICT_SEQ_WIDTH) - 1)
+#define EVICT_TS_MASK		((1UL << EVICT_TS_WIDTH) - 1)
+#endif
+
 static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction,
 			 bool workingset, bool file)
 {
@@ -250,13 +272,19 @@ static void *lru_gen_eviction(struct folio *folio)
 
 	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
 		     BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_ANON));
+	BUILD_BUG_ON(EVICT_TS_WIDTH <= 0);
+	BUILD_BUG_ON(EVICT_SEQ_WIDTH < 16);
+	BUILD_BUG_ON(LRU_REFS_WIDTH + EVICT_SEQ_WIDTH +
+		     EVICT_TS_WIDTH != EVICTION_BITS);
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
-	token = (min_seq << LRU_REFS_WIDTH) | max(refs - 1, 0);
+	token = ((min_seq & EVICT_SEQ_MASK) << LRU_REFS_WIDTH) |
+		max(refs - 1, 0);
+	token |= (jiffies & EVICT_TS_MASK) << EVICT_TS_PGOFF;
 
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
@@ -275,18 +303,21 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 {
 	int memcg_id;
 	unsigned long max_seq;
+	unsigned long token_seq;
 	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat;
 
+	(void)file;
+
 	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
 
 	memcg = mem_cgroup_from_private_id(memcg_id);
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
-	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_WIDTH;
+	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq) & EVICT_SEQ_MASK;
+	token_seq = (*token >> LRU_REFS_WIDTH) & EVICT_SEQ_MASK;
 
-	return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
+	return abs_diff(max_seq, token_seq) < MAX_NR_GENS;
 }
 
 static void lru_gen_refault(struct folio *folio, void *shadow)
@@ -295,7 +326,10 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 	int hist, tier, refs;
 	bool workingset;
 	unsigned long token;
+	unsigned long evict_ts, refault_distance;
+	unsigned long max_seq, middle_seq, birth, window_age;
 	struct lruvec *lruvec;
+	struct lruvec *dst_lruvec;
 	struct lru_gen_folio *lrugen;
 	int type = folio_is_file_lru(folio);
 	int delta = folio_nr_pages(folio);
@@ -303,8 +337,27 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 	rcu_read_lock();
 
 	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset, type);
-	if (lruvec != folio_lruvec(folio))
-		goto unlock;
+	dst_lruvec = folio_lruvec(folio);
+
+	if (lruvec != dst_lruvec) {
+		/*
+		 * min_seq values from different lruvecs are not comparable.
+		 * Judge a cross-memcg refault by whether it happened within
+		 * the age of the middle generation in the destination
+		 * lruvec's MAX_NR_GENS window.
+		 */
+		lruvec = dst_lruvec;
+		lrugen = &lruvec->lrugen;
+		max_seq = READ_ONCE(lrugen->max_seq);
+		middle_seq = max_seq - MAX_NR_GENS / 2;
+		birth = READ_ONCE(lrugen->timestamps[lru_gen_from_seq(middle_seq)]);
+		window_age = jiffies - birth;
+
+		evict_ts = (token >> EVICT_TS_PGOFF) & EVICT_TS_MASK;
+		refault_distance = ((jiffies & EVICT_TS_MASK) - evict_ts) &
+				   EVICT_TS_MASK;
+		recent = refault_distance <= window_age;
+	}
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + type, delta);
 
-- 
2.50.1


