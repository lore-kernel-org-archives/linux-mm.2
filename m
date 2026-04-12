Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A473FE937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BFE6B0089; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673386B008A; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5616F6B0093; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4271F6B008A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D33B81B91E8
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:22 +0000 (UTC)
X-FDA: 84650486844.27.3755246
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id EE62440002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ouOCkUpg;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ouOCkUpg;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012500; a=rsa-sha256;
	cv=none;
	b=2JaS/kqyF64avZ5DpaGlDmQEU1kcMlbvgUB0wM+MU3UpE1Rts8WtqSbPk6/OJXCnYfklwG
	vJOM3eG/9wxQ8m8Dw9x4Gg7vK0xHfxxViVl02/cb1ByuC/LirABqvm+QOCZ1/AiYELp6+K
	a9gfA58fQwUly3bUUNlvbuoAWOhrupU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012500;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80l7G9HqcO9QO1QwVtrY38+Qx4dX+Um/VFNib5/fNWQ=;
	b=gFUFwhaGkeiS+vef1XCJxQmyUxAiRQmNEvHhlW5nCA9Hc7H3hn3LPpPZ/K8Rw/Glqm6djf
	LLJWzoOddkyDU7RiSrUCy4zsRYcE9SHoq1CtOphg87QE4KwIiEqNYc04y0flY08r+gCPjS
	gVgRg5zfphm4okuxL0uIlXC4RQda0YE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BB186111B;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B629CC19425;
	Sun, 12 Apr 2026 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012499;
	bh=pu/4aSrd7KSa0bxFp6wbeBj72fjrUtTNvGBmWMpcIZ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ouOCkUpgJEZ8yDu5iiO4dONOFGA2rLUNyCloKovqHeNmXeKZ+dsagd8g4gDYc9rtU
	 WUOPJWUQU1R/ITq20WeYQkIUYZf8wIkdey6qMhlsQFUSRm+YmbReqYdhkZm5d9d9eQ
	 Dq2XQhhn4W2wlrl/j0iZDHduewjBC7ZuH0xXa4IhD7FTgZ8qPif3wsLafAyUnFlH2x
	 L6VjIZUbpgk8pJ6ssLBpxDDnxSXUzldaVG0Xz0AKg9PHQVfFYx9CCXXUBpK+lAhhdd
	 SuIfbgagAgeUM/JVjS14y46+I2SS1kOg2jF7D/dHxx1uFKbH3FTGgBO9xH7viJYV4Y
	 X4Mru0iTBgnug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3806E937EF;
	Sun, 12 Apr 2026 16:48:19 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:15 +0800
Subject: [PATCH v5 01/14] mm/mglru: consolidate common code for retrieving
 evictable size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-1-8eaeacbddc44@tencent.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=3179;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=lovGNHm1LZYPq5LXk6kp/WVa26J2TdTx/242vg8RH/A=;
 b=mm1ALcPtxy72WxszOQTYS6hmftpu2D3p4pu7xLjkN7rS/KWxHwNJRH6AABRR63NWn1FpC9rmK
 NNXnEKZrk8/DyyBWhy8g+W8dHUQqU+VTYWXsLGdCmkvDAL4NTqVIQJz
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EE62440002
X-Stat-Signature: 86pg4845ow1dniygshyt3wy5w1h1y8yp
X-Rspam-User: 
X-HE-Tag: 1776012500-282491
X-HE-Meta: U2FsdGVkX18We+XWs49QA9dzRMu536EfLJBis3VUjfZ6UwK96crYQdSvggqqYWPgqQCES8IvmlTMTNA5WV9kz1b0mHLDhx3M/CBCU7hNdq8XYoQx9XOxs7a501QNFYK9E1VvAOKLlhZ0QZgeQuEXdW/ZQHH5Je1RyT3GnWtL3vEWcLcqoqI6aOZjwNfawdidNwBFUJDOcmG9Fpv1tv0+9sL2IB/AW2EHXc0YA5axTPAkYriWRIYJRp2JCQvWSuhTH1iN22nfg2VSRwC3frrnliMpR8rfjZwuH8kDb7O8Tzn4KJqSytImzd1wllc1kiZiasIC8MHmf3t9UQpK/t1SH5Xg128pKjB8XMPAcI4G/EaWx24MSvLrHQc9WgMoan8kVMAWec9E5AT8veoqseAAMczh+1QgnKE/F2T5atCvReXIfZ29cl6/gr1aJKUgwL7F0b7rhI9SR7nFQeFQTRFW6iSNj0k4PIvEnmPmRXdnMhzfMJ7vLxaoZnW9XzrJATunI85GZFMsFLUvo/yYL7VZtibDxTHkNWz+buUv5WNua8lO2WR7ZxxGgcRthtaZlOEz2PgL03m8/gHqz4gfwrQY0H/8qNIckgxZPFhgmKsq983+to3hblOS/TTw0TAMC6u+OcomN4XHJ2hM6qpdWQBrPcbjbQOMBfQtRDyK72IjFRkGFgyOjDCSGBoKJrOosiPf6hy+ErFunaz3mCL0kSglqibBQFb8hNOIjkz/Yh2u8qVVyDmxoYFfIid7fvwA0JNiV0FrRwI84i4SqYWrzEpBKTTP7JVByCRP8yiQ093oThoIxFG/M47k1LOjA1fTh/tunfJ1FSoatMECbbsxs3CPATUfiKXUMx8jnHvoOB1RzClljxbKyflfW2pdrRDG0aog9gU2DHeJW+WCzFozLJ55ob+Ptk+YpvAvHT2AhIAvJ39DbdUqnvmgmceNaXQmbyvzIKS+L05m65u156yQQvZ
 z43Yl2Uv
 19O5uDkOIk52tauonKpbn2ehJ+4i20nG+mW7ol9Zir/xCScLnEyOzIP1AtF9TqST/VVKnNJukC40tkywySqWbMi2bMephEvc/yEYXTW57Kils24zfSgZcUu8t3GPhmN5Iz+lPDN4qASRZXQ44OuJGem0YVPQifys/P8t0i32SHOebs0bYgi/KmBKXLHE7mRQSsb79UBnUDPHedQDA99yOslpPoAavx2z1rOPlHF0tyqUlBN7rLYVy4xlvBvqGrlyjnX39mESQ0ctGzaJKoDKdRpIqhbVoHiGSFTQXuvn8F4FihFE90n/6SYa18T8Z1SskRR9+VQOVQs6ywfADL9DA5HSWbOZy3o1IktIdi7NO9b41FklmKN3H62B+aEWlOlzwYkf16Vlz8bABKDsMpL6yA+DTSuulJlIfbNTRgiGix67bL/lGoZYm6SLFwHs0DFXBOVmo/9tIm4g/dT/Cbball9Uh8G3qe9DwmYYd3W7WYRJU6MpST+/fu5gQ3IL3E4Av6TSOoEgxSvyt5Qp2ewszYV5bog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Merge commonly used code for counting evictable folios in a lruvec.

No behavior change.

Return unsigned long instead of long as suggested [ Axel Rasmussen ]

Acked-by: Yuanchu Xie <yuanchu@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5a8c8fcccbfc..adc07501a137 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4084,27 +4084,33 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
 	int gen, type, zone;
-	unsigned long total = 0;
-	int swappiness = get_swappiness(lruvec, sc);
+	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	for_each_evictable_type(type, swappiness) {
-		unsigned long seq;
-
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
-
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
 				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
 		}
 	}
 
+	return total;
+}
+
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+{
+	unsigned long total;
+	int swappiness = get_swappiness(lruvec, sc);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+
+	total = lruvec_evictable_size(lruvec, swappiness);
+
 	/* whether the size is big enough to be helpful */
 	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
 }
@@ -4909,9 +4915,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     int swappiness, unsigned long *nr_to_scan)
 {
-	int gen, type, zone;
-	unsigned long size = 0;
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
 
 	*nr_to_scan = 0;
@@ -4919,18 +4922,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
-	for_each_evictable_type(type, swappiness) {
-		unsigned long seq;
-
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
-	}
-
-	*nr_to_scan = size;
+	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
 	/* better to run aging even though eviction is still possible */
 	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
 }

-- 
2.53.0



