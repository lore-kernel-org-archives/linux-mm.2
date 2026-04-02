Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3CB6D6AAF8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5DD26B009B; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98A26B008C; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2C26B008A; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8C76B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E507C1A0896
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:44 +0000 (UTC)
X-FDA: 84614514768.01.71D4233
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E1B89140002
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sftjierH;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156023;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Cod3VrGvXgOcezwy2UirAtirrWOOu/9YbaINHX0LRM=;
	b=UptwisITBATeJS1AYZ1WR7gBW4DR0+fFOOrqQdqXudgM46kCdCXvNWzZcm61azYP1xO/Wh
	Ht7dsPtBDY8cescvzZzlPwXNkG62irp7rJjEtFloFXvpd87NlX9mhY6v9kDgz4X8K7o/Tm
	3fstzwKjKpWgu27PRC3UVZ/Jkubzn/o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sftjierH;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156023; a=rsa-sha256;
	cv=none;
	b=qqPpBQrAPvEFG47jQfJpaaATtBRM7geEmfzx9ZDZNTAffyvH4ea6mHPTGEUnEhvHIyKZfN
	Yt2ERxi7auBavYLJUFC+cN89fVO4qXvveEHlex4Z9iBB7SsL6VGNPINyq9bf7e17n23Hvk
	aYydrjG1QEFCmNmJcu8N4d9mnchfkm8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ADB7F4443D;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6405DC2BCB0;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156021;
	bh=hFax/AJR7bXH8oWQu+9VlOcr2nxZvl2KLMxTavwO1yQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sftjierHx+QAPwJU4sSL/inATfAl9632hi7PgveGFykQPscPPeSTxP1tm21AXqCpy
	 Yndwpgn0xQ5Fthh/p8elPDArPRpswmExNmKWvCWQwj2IF3/0g9KRks7Wm2Y4NNS5zi
	 HViVifu057I8FmAOrvAQ0imIrOU5HZe6xteFqPAgLg3F06JQFRPgsQm0AJdK64MuWO
	 cjb04enNHyIHSSUdceSQBOH3wJDiBBPH2eVdj/CAdnpm8VTMlZ0Hg5rZDSzlqmofyl
	 LVTg6W1nASm9MsSF19dxk6Jj3OilnasP0770WaMwICerHjOs7AmND08H62zzsZSRO5
	 S6YyM8ZWuzFRg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59554D6AAF9;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:30 +0800
Subject: [PATCH v3 04/14] mm/mglru: restructure the reclaim loop
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-4-a285efd6ff91@tencent.com>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
In-Reply-To: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=6279;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=n1QR1XMc/29NkkvOx9rKp1KXHPY21ys1yUuIEmcMTFs=;
 b=G2FlHwh8fkci9hkqgt8brGGRiFDG3vSgUQKIiPALDlcX9XXO7hjk0OmtODfv1ItaZGTgJN5e8
 wl31xAq/atNCjkLJtnO4p+155BUSX2PKlRhdTZPG/V5WmwIHXdwQ6gU
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: rhu1g8md88qun3dq5q8r35fhy5c5gybi
X-Rspamd-Queue-Id: E1B89140002
X-Rspamd-Server: rspam09
X-HE-Tag: 1775156022-772714
X-HE-Meta: U2FsdGVkX1+7SVuu1IRN3jGt8zMkvqrEsVtxFANj3rO75KYlo3M4ffkS5VLOCUvuq0vrtcVB2uArdm6oUK0m4+6gbQ9iIcPQymC/uwDaNT6DbIyPoBmGXvlyYKmAXhgtupKusfP312c7+mops99Vpomu+bA3Cyu9pxMNYdNn3pmq3AR1EX44EcmozLV1QM5gsaJ6Gn6hbqmeOo9EjTN7CCtkAoPO1bZb2/hx8AKV/JnrtTagqCMXPFo+AhdS5y2Hy5ac82Sje6673dZclvCkm+QTnwQdMoAeOoBJdn96K+TvTKez7qyiyVbHq2d0q3q1b/2KExEBodAiHbLUgSA0+QxDKwOtZgxx9gGGKN+MKkZJDqXQoF/ezEiiyU5KLuzZJMpClWKyjXT0J6ILmEl6prtyTU07ekDiSCm42yuWiScofnTqndg2MjsjR1YFbpAg23gu9b/gWr6dS68dlSXTPLHOzW9IRsXp85dW2L3KAUm9SqLoMMcS0563lI7Rm4Mp4zFlzHG/89wAxv1yu4zvnkc+/17pBVrAJK6YKI/YFCY+RlD+eHVSALz+enlo2aOHO3alL7B8Z66ggJtxF1Ru+uDen4HVtUZQFkpbXAEGO7hiUp2r7X5UaCbmtBjg+1Au+ccmsLSNSg9K8aUeZ/5cEpxgLMVOKdDRFQWUxH14ATERNEGdxmBCQ/0UeZ+50881Tw7nMZPXcDqDGjL+EueN2u+dMSfSu/cdouHrsMdwtzVjdp5Ncp7nZsS9kMy72mnxSh75lumxpHyCLoQkHaZEqIUbbEq19sjSrFMnq2Jc/UWtgytteAoHj/SQCwzo7QOlUiN6tssrfjxolJuuOBBlslf5NF9WPf2etEFgg9DRNUGsBY3uVfshbaJpvZo1RfF/VeIDeXTxh6yVw/OtN4qHC0URp+Vcxphualfu7VEuTWr6g/Kybn8VnFgZpBrPCD5HTX1f8OSkwP3HWua7K13
 cxaGP177
 nDHuxAwKbADAcTcyB7ZJ0CbbB2Or+zVoet8av6e4+iI07sstwr0rvfduk4zDeoFZXK0DyiW+N7u5XQnnKfRCyg+LR8kxJYCuvq5LQwbqSSxCgbYKIY86gYUkAb50Pj2uzOe1/bR4hKuqYcXWKqCpBTzclzsWu0iGLlIXk2cbSsiw0rFivm+aPH9u4hS1ARHswEG52F/DyGDrJO/Px3Fe9nRDstvkMxyXRzt7AF7wp+AIWCRgfSy32Z7lpVqUXDgHt5hT87ZhOwlcTodHpFPl356/CeeuK79nBmY5kBazb8UOX2txhFqXQgxtPG/2O6cFF4+cJymSkPVJ4QOHrVqoIu1s+rdZjINN6A3aFigpYGQRodQL5BkUbcNimKTAGJ5r9e2LAb91o8+ySSxzAvH55h/OvuBeFbgMyLqM0DdZBo4oWUXuo5+B3tWLri3XxwvLOBozmsiEDh0QV16ltPRuR43IMJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current loop will calculate the scan number on each iteration. The
number of folios to scan is based on the LRU length, with some unclear
behaviors, eg, the scan number is only shifted by reclaim priority when
aging is not needed or when at the default priority, and it couples
the number calculation with aging and rotation.

Adjust, simplify it, and decouple aging and rotation. Just calculate the
scan number for once at the beginning of the reclaim, always respect the
reclaim priority, and make the aging and rotation more explicit.

This slightly changes how aging and offline memcg reclaim works:
Previously, aging was always skipped at DEF_PRIORITY even when
eviction was impossible. Now, aging is always triggered when it
is necessary to make progress. The old behavior may waste a reclaim
iteration only to escalate priority, potentially causing over-reclaim
of slab and breaking reclaim balance in multi-cgroup setups.

Similar for offline memcg. Previously, offline memcg wouldn't be
aged unless it didn't have any evictable folios. Now, we might age
it if it has only 3 generations and the reclaim priority is less
than DEF_PRIORITY, which should be fine. On one hand, offline memcg
might still hold long-term folios, and in fact, a long-existing offline
memcg must be pinned by some long-term folios like shmem. These folios
might be used by other memcg, so aging them as ordinary memcg seems
correct. Besides, aging enables further reclaim of an offlined memcg,
which will certainly happen if we keep shrinking it. And offline
memcg might soon be no longer an issue with reparenting.

Overall, the memcg LRU rotation, as described in mmzone.h,
remains the same.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 74 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 34 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 963362523782..93ffb3d98fed 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4913,49 +4913,44 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     int swappiness, unsigned long *nr_to_scan)
+			     struct scan_control *sc, int swappiness)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
-	*nr_to_scan = 0;
 	/* have to run aging, since eviction is not possible anymore */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
-	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
+	/* try to get away with not aging at the default priority */
+	if (sc->priority == DEF_PRIORITY)
+		return false;
+
 	/* better to run aging even though eviction is still possible */
 	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
 }
 
-/*
- * For future optimizations:
- * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
- *    reclaim.
- */
-static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
+static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
+			   struct mem_cgroup *memcg, int swappiness)
 {
-	bool need_aging;
-	unsigned long nr_to_scan;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-	DEFINE_MAX_SEQ(lruvec);
-
-	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
-		return -1;
-
-	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
+	unsigned long evictable, nr_to_scan;
 
+	evictable = lruvec_evictable_size(lruvec, swappiness);
+	nr_to_scan = evictable;
 	/* try to scrape all its memory if this memcg was deleted */
-	if (nr_to_scan && !mem_cgroup_online(memcg))
+	if (!mem_cgroup_online(memcg))
 		return nr_to_scan;
 
 	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
 
-	/* try to get away with not aging at the default priority */
-	if (!need_aging || sc->priority == DEF_PRIORITY)
-		return nr_to_scan >> sc->priority;
+	/*
+	 * Always respect scan priority, minimally target some folios
+	 * to keep reclaim moving forwards.
+	 */
+	nr_to_scan >>= sc->priority;
+	if (!nr_to_scan)
+		nr_to_scan = min(evictable, SWAP_CLUSTER_MAX);
 
-	/* stop scanning this lruvec as it's low on cold folios */
-	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
+	return nr_to_scan;
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -4985,31 +4980,43 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	return true;
 }
 
+/*
+ * For future optimizations:
+ * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
+ *    reclaim.
+ */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
+	bool need_rotate = false;
 	long nr_batch, nr_to_scan;
-	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
-	while (true) {
+	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
+	while (nr_to_scan > 0) {
 		int delta;
+		DEFINE_MAX_SEQ(lruvec);
 
-		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness);
-		if (nr_to_scan <= 0)
+		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
+			need_rotate = true;
 			break;
+		}
+
+		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+				need_rotate = true;
+			break;
+		}
 
 		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
-		scanned += delta;
-		if (scanned >= nr_to_scan)
-			break;
-
 		if (should_abort_scan(lruvec, sc))
 			break;
 
+		nr_to_scan -= delta;
 		cond_resched();
 	}
 
@@ -5035,8 +5042,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
-	/* whether this lruvec should be rotated */
-	return nr_to_scan < 0;
+	return need_rotate;
 }
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)

-- 
2.53.0



