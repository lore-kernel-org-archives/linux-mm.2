Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D66606A338
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyzr08bL
Received: by kanga.kvack.org (Postfix)
	id 5794D6B05EA; Sat, 14 Nov 2026 15:09:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551616B05EB; Sat, 14 Nov 2026 15:09:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2126B05EC; Sat, 14 Nov 2026 15:09:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0504D6B05EA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:09:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 585C7C048E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:12 +0000 (UTC)
X-FDA: 85434813744.12.9AC8010
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C2480C0009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyzr08bL;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686950;
	b=bd5KX+wxFDpQfolGIiV7qBSDLoZoQQchlS9rAglWt9tb7AGbuF4hY99mxw4AIDB/CD4rvW
	v4RuArA7zL1NZRLpG5gbYil1Z/IIA7yFSQiRy6xwIVNNxALDZj2XL7ZvwVUmPFLiJFStpT
	MT8QrRI+uH8RaDaM0ePZUjkzDXSWklw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyzr08bL;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/THqEh73uO5IZ1+KcP40L4GxFwbCOfpeNn99UA8KJ4=;
	b=r4qP/MlKhWrBVsQD+oNctm3NC5GA5Yt8Tws0XyZprNJnZ7/iW1j/uu5QE5mLbrhgbhxVyJ
	ozKXOvLu1at3Z6xXJwbxEhSPXH/2pxHqjOXXEwXHKO8XhDLikqcPMsfEVKBKCoYFt7v/R8
	8RfMmz5v7onRS5qclKEM8NUUJHjmN6Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B2346148C;
	Sat, 14 Nov 2026 20:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7271F000C4;
	Sat, 14 Nov 2026 20:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686950;
	bh=j/THqEh73uO5IZ1+KcP40L4GxFwbCOfpeNn99UA8KJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyzr08bLFQ3J4EKZzrDOjhs3pNLwcIyBS98MmFtslUMoWO10x+Byk3ltevuhZy/vi
	 Tib/re5qNFDRCXF2Nhx/q22C/BKYeVk4GUl4lsjCEMyniw9ZxkHgmABNbD8SJFYGGO
	 fmMqt+kMVIAhMN7Ko7u4pa5ryBVLSXmHRv087fnmT457XeRZCCSeBWU2Dcx05YtFUq
	 ecJTishbOaDhToHB9FtKZKs2SA6MBVHH/j2CFBvm4ch6OFN+Ty5YFU7s/7gcW9jxKL
	 2KHOF2jfFWHoN0s4x5WFjHmqZrbskSDnxeweHzOd2s5VKzLoohdh+HOmkJRkrj+rvq
	 5kDNZuH8SzbEA==
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
Subject: [PATCH v9 11/16] mm/mglru: Run aging when one type is drained
Date: Sun, 15 Nov 2026 04:07:58 +0800
Message-Id: <20261114200803.23129-12-baohua@kernel.org>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C2480C0009
X-Stat-Signature: i8rk4pd4hy7ap91gz885t7z3rh1dpygs
X-Rspam-User: 
X-HE-Tag: 1794686950-268773
X-HE-Meta: U2FsdGVkX1+mDegxxY1kb7XOtXcDlFcJO4kkcZxBBiJb9fJbG6rm6Pf/6D6M+A9GSLKzAKCY3+Qj7T5p7+Ic0E9nrPj2479DgtF3g5vSas5rBjC7a/EeMippp04cPVsvFXlJwl6v/O58aHYcOBO32acb2MtYvnIxVP4zIQnl3i03Z9GFbl183KckPsL1SO9BKTMh+gM0HHizMNGzCPL//ocC1GbxLjZ7tgp3rUxYKks+l7L6wJQ9ov7C4wRq8wUJITwttxg04HHlUYtv7mEm3uhqDgviLX6sHQn5AQ8PoWBs2pX/u2UpDtzb+FKelsMCm6vJZhpScVNRJk8g1PN1rnI0+WTrpuS2xAbO/JsjC03sKIYaAFayD2wJlck3YffT1wpAqI6oyPSzcbwtAFf94PCOwKeBnQRIYxbHlgKRbVpsGqolZWnuArZZ7mKfd0eUf5uiQrMXScf7w8MA33jItOLb0jhdsUq1vFvJtcEeWtOMXZE+tvuTHqmXxbQR2k2y7oV3q3zSD/kEmiftoeemJpZbu1cHxKROuEa328/zy7i++xnePF6xN2J8Q9UbN/1oKKQXV+WoIg7ozpKnWVZ36NgckUODbjxyZIDJxIbja+XTzv1AkSEJFYdqN/NgOf5enKNWAufjrjoUHKfBsPmmdDtxZ64+yyAyPC+uuElt57HfedRMIZ+nVj0SB/w8JghznyNcHfQ7kY3dSJgVLWhemP0i5oHDpS80BivGRm0K5DxCJ25/yL6xq/y0TPwl3auXf3Vlx1hESzGC87VGqqCzF09Be+w4qygdx53eKxuTq7Hc8tPUKpbZlk4ncsAWjWVZsWM1UrTpJGrB4CjrwSAeGVLNyO/ntdb6/DV6+iwh08K+PhCOObpExTj2RVSv6/cF5Kn2MpJ2tlWun04uk6GgdLgBhbWOo0S5SDuT6FoG+bBEgn4Ci+xUcSNp1wqsEwM4GGMSmP4YD3o/3qZrRcT
 8nRYJk4Y
 9hj114hR/tuHc2/xXSv4NVpauy/bipaeBDuugv8jn3bzlMFYRyvLwC7i9/s0SQwXjNDilfpq8dTCMvAAXywvoF5ZcMv0HMkXxAxiT3IiELb1k4mG9mn/UzEruOgv/Q8qA58YKZhmIkDwjrhgyd5jNYXDZrZ700CfBQA0oQMpK5g8i6aaJt9CVNpkngUCQ4V3JgjwrSExuOzLKkdK3qV5WlZ3uXXuFwICEfNTEzx8zXB578ALz4F4ASS5Q4GmzwDxNkKVl1JWFZNECSC0BCFbVTcBKgymGSB5MVr3pnjOac72BYJzyr9c5USuicg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We may have remaining scan budget for anon or file but no folios
in populatable generations to scan. In this case, `scan_folios()`
may repeatedly scan that type without making progress, even when
the other type still has populatable folios.

Run aging when a type is drained to make more folios available for
reclaim. This also helps honor the scan budget distribution
determined by swappiness.

Move aging after eviction to detect a lack of scan progress and
avoid unnecessary aging when eviction can still make progress.

To avoid excessive aging, allow drained aging only once per
`try_to_shrink_lruvec()` invocation. Also skip drained aging if
another reclaimer has advanced `max_seq` during eviction.

At extreme swappiness values such as 1 and 200, reclaim initially
focuses on the preferred type. Rely on imbalanced aging once
`sc->priority` reaches `DEF_PRIORITY / 2`, rather than triggering
drained aging for the unpreferred type. This avoids unnecessary
aging and has shown better performance in testing.

If `evict_folio_lists()` returns zero, retry eviction once if
`max_seq` has advanced since the aging decision.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1450542d709c..6d942f192e63 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5175,7 +5175,8 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 }
 
 static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec *lruvec,
-			     struct scan_control *sc, int swappiness, unsigned long max_batch)
+			     struct scan_control *sc, int swappiness,
+			     unsigned long max_batch, bool *drained)
 {
 	int type;
 	unsigned long batch, scanned, total_scanned = 0;
@@ -5191,6 +5192,8 @@ static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec *lruvec,
 		batch = min(nr_to_scan[type], max_batch);
 		scanned = evict_folios(batch, lruvec, sc, type, swappiness);
 
+		if (drained && !scanned)
+			*drained = true;
 		nr_to_scan[type] -= min(nr_to_scan[type], scanned);
 		total_scanned += scanned;
 	}
@@ -5206,9 +5209,15 @@ static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec *lruvec,
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[ANON_AND_FILE];
-	bool need_rotate = false, should_age = false;
+	bool need_rotate = false, should_age = false, retried = false;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	/*
+	 * Avoid aging the lagging, unpreferred type at extreme swappiness;
+	 * rely on imbalanced aging once priority reaches AGING_PRIORITY
+	 */
+	bool allow_drained_age = sc->priority < DEF_PRIORITY &&
+		swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAPPINESS;
 
 	/*
 	 * Proactive reclaim initiated by userspace for anonymous memory only.
@@ -5226,22 +5235,17 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
 
 	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
+		bool drained = false, do_drained_age;
 		DEFINE_MAX_SEQ(lruvec);
+		unsigned long new_seq;
+		long scanned;
 
 		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
 			need_rotate = true;
 			break;
 		}
 
-		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
-			trace_mm_mglru_aging(lruvec, sc, swappiness);
-			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
-				need_rotate = true;
-			should_age = true;
-		}
-
-		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
-			break;
+		scanned = evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH, &drained);
 
 		if (should_abort_scan(lruvec, sc))
 			break;
@@ -5253,6 +5257,27 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (root_reclaim(sc) && should_age)
 			break;
 
+		/*
+		 * Allow drained aging only once per invocation and skip it if
+		 * max_seq advanced concurrently during eviction
+		 */
+		new_seq = READ_ONCE(lruvec->lrugen.max_seq);
+		do_drained_age = drained && allow_drained_age && max_seq == new_seq;
+		allow_drained_age &= !do_drained_age;
+		if (do_drained_age || should_run_aging(lruvec, new_seq, sc, swappiness)) {
+			trace_mm_mglru_aging(lruvec, sc, swappiness);
+			if (try_to_inc_max_seq(lruvec, new_seq, swappiness, false))
+				need_rotate = true;
+			should_age = true;
+		}
+
+		if (!scanned) {
+			/* Retry once if aging advanced max_seq */
+			if (retried || new_seq == READ_ONCE(lruvec->lrugen.max_seq))
+				break;
+			retried = true;
+		}
+
 		cond_resched();
 	}
 
@@ -5885,7 +5910,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 		lru_gen_balance_scan(lruvec, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
-		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
+		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH, NULL))
 			return 0;
 
 		cond_resched();
-- 
2.39.3 (Apple Git-146)


