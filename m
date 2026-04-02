Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A48AD6AAFA
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E2C6B0096; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8EF6B0099; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531346B0093; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8256B0093
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D432A8C54D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:44 +0000 (UTC)
X-FDA: 84614514768.20.86EB183
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EB8931C0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ASiGTN3V;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156022;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvSGS8wu7qb+VC1d0XkubdBQaGU1xw1X3GtI1Jc07G4=;
	b=LfS9fSdy4J1LOZqfXM+dIv3bO/e8UDeqijjwZ4oVp4j/8WZI0tzeCNdFgYZuSO7oDDBEl/
	ZllpZfaY8lOhtO6ZpMAVC2rxAw1M7HhwCgTrnvxs+XpubPX6/W90w5cWpl56OHK2B5QL/P
	KxoqK2BjJtx1vWqeMQRFaDXCDFDqPoU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156022; a=rsa-sha256;
	cv=none;
	b=Wbze+xmfTOv+AjFgCWC20S2RAwAGWh2zsBdpo7G0FB7eGS9WhO4Q79E0n4BJA2ci3a6uSd
	tYpoWq3AdWzxCmFV+dVeiScAR6AsZdqnJg8P5tGHrNYz/kPBwyqEvcGGwMXjvIEkJpXG8q
	09cQ28jFJGU9RiZLEei0zXaHiaFxous=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ASiGTN3V;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 181056013D;
	Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6244C2BCB5;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156021;
	bh=63nEWfwkNNkk9J++qrkxrJVSy188Dx52Qvrtm+1BaGs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ASiGTN3V5lLKskHiafX2Q0dnO62ymSFp7sdXqmcdYIkkHkHv+uw7tGvC5QDnUljO5
	 ktke/cSdCLHwUtMklH0OXxA12xD907BwJtEu1H2dp/qilvY7/Ghp9JWaHyQ8p5NGse
	 5JemgLRflD+d9u8qfHZ+iWuFheOKmsBeg5uziv/eQoo6oJWXNh2S2RxrlshBLFiQgy
	 2zAaAVTQmkD+emqmIFoxQdo+VM/yF2BU2Rwy38eeFj91QXa1WMD4jyUDnUeLeJ4Nnx
	 nlEqnicDmX35zHsuUm3m4QQHyaY9iFhCsH4cscY/JiP+tjwg8mZ2FFrhsRuCMhvEQL
	 L1Nj5Pz4/+pPw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F16D6AAF9;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:36 +0800
Subject: [PATCH v3 10/14] mm/mglru: simplify and improve dirty writeback
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-10-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=4353;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=hVu3ISonYulOgbgDjpADHQN2QCCwFiXdmGgk/BQPxSU=;
 b=kkEuh+8AqhlfqE5nr5RrlNP81wjM+EdWclsP/JUJJxh32ldb9EaSVYEdYH+0la/BG+SZlGhMe
 fp6Kn8c2mXcAzxSGGt/ekc4X+n3yxuXsgAFprbRwFbWETApZovUH9ht
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: EB8931C0005
X-Stat-Signature: 9smesakff8b17n1zperbqy74q169a133
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775156022-273147
X-HE-Meta: U2FsdGVkX1902nsZp0hKjMBTflFXvupohghs8bfhFyt4GbO5Ae3yXcrnSjdorNEtZWT1BJ84VhP30PN0MP7Ltm2Eprw5IyEEmiexJ577tDmGE1qJFwtmV0DFc9xc8h4PQ0CftRkFaFuQWt62w2iZKd4zf1PRJb6dKBpDiOHXIBc3t0GVWwboYakVUoiQpSn2zf24dJhG8cicV65otdJdq2G92pSPtvkJ89wB7DMFwgnhJT9xo3y1mHg0FIfG2LQP+5ivPcTD9aWkLt6J708mk2ZtRBhiSYtQe4kDWh7tKg8bqCl3jn2WKxU4dzhtqyjbD9Y2zGzT9mcbO1u7EV2dE+Q0VvgQ8Xe30vnaaLwd/IcqgXCRTaHC9WyreqCeEGLhC0shu2dJ6byOD3nSgtHGgwVs2V1ABs7b5gkSw030Gzex+TGqGm4R1lDjS2HAwnA3HtNn7MCsWr7u4VGtmpbsoieD9N2N0kKgfXQgjxfop4SZsAhIasZBzQ4g6fQaRdUFBjG5Y1eshEau7aP7G4h+1yg9jOWmrrGsrBrVP7HgEVRZtDAhSX+Z141a68DEyudWv5Uj8NFWivXwnjtwDWYc0hYGWz8zbI4hLd+4RBB/zs/lXuBM2oXZm4WP8e7D2pwF0Pl0zZBBGG6NWtS/o9XFAjcYfYKtB87H5E1xDXJOVLJ0lU79yPSofHZiPXgtvPQhP1wz3bLp/emnuSbalV3hmY0PE70Tr6ozUUXwI/mIuC5LT+YO7iWJjqOvF1RuBRFK5q04OUFpwbR5SptSNeJizihztfh2788supnAk7TIaD/y+15lZ397fUOcsAaytXBY+kVdWvO9HO/hwEGgbwCk6gdwi+XcWROtz2+n8QWN8wAoiJ14ZTn9LJ4kQUSQuQ3DkqbDrFRfIuNG9VKjHldQRpXz3f0yygygIM880PWQhYlMx+Mboo1HNLib+nMYK/6vDrwl1sKC77BdAyGjYB9
 PmiVw65V
 hq/DNqi4XkYY8/bIZmKLZ1txPnUI15ZR0HpnjoSgLGZoDAhJ5lgzmL/gOOXtgPLjqyNIGRQBmguFDzU4sIamm8ROQLdo4yXf3lSFrXXglqrtcvDQ8uG0Z4jUqPsbTEEGpHC3fpj5Y/Uc08SP05h35DKR6lG64WRI620S2ZbePuBvkOjdJXC5Ctc5zJFZ2ISGRGPMuCDkXnqkT0mLMT701hm/BhIjPB+o8V51NZwooeTnxCxCwF5rXcfP+FjqdnuwdxXC0d/Deg75aAijKnw7i+nQ2NDv8dAjiojSspGws6icubqgyu72XIokdn3sk9ehkj7S2HHR4+lKzEu+6+GIeOGXNNJTy/K13s4bTetdi8N2h+x8U0GNI/KGRdj4J8IaBEQDtGNsIppdPErqXbFhyTYJf+nvyxI6abtmAflNd7yPeT7TZHyL9I997C7q2eT7m/Q6RcmTBVmvg6Wm2U0/WuV+zHb2rqqgk2d+KihVcf8TgyrLOic58XA7UumdI/LvMj5zq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Right now the flusher wakeup mechanism for MGLRU is less responsive
and unlikely to trigger compared to classical LRU. The classical
LRU wakes the flusher if one batch of folios passed to shrink_folio_list
is unevictable due to under writeback. MGLRU instead check and handle
this after the whole reclaim loop is done.

We previously even saw OOM problems due to passive flusher, which were
fixed but still not perfect [1].

We have just unified the dirty folio counting and activation routine,
now just move the dirty flush into the loop right after shrink_folio_list.
This improves the performance a lot for workloads involving heavy
writeback and prepares for throttling too.

Test with YCSB workloadb showed a major performance improvement:

Before this series:
Throughput(ops/sec): 62485.02962831822
AverageLatency(us): 500.9746963330107
pgpgin 159347462
workingset_refault_file 34522071

After this commit:
Throughput(ops/sec): 80857.08510208207
AverageLatency(us): 386.653262968934
pgpgin 112233121
workingset_refault_file 19516246

The performance is a lot better with significantly lower refault. We also
observed similar or higher performance gain for other real-world workloads.

We were concerned that the dirty flush could cause more wear for SSD:
that should not be the problem here, since the wakeup condition is when
the dirty folios have been pushed to the tail of LRU, which indicates
that memory pressure is so high that writeback is blocking the workload
already.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2a36cf937061..bd2bf45826de 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4724,8 +4724,6 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
-	if (type == LRU_GEN_FILE)
-		sc->nr.file_taken += isolated;
 
 	*isolatedp = isolated;
 	return scanned;
@@ -4833,12 +4831,27 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		return scanned;
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
+	/*
+	 * If too many file cache in the coldest generation can't be evicted
+	 * due to being dirty, wake up the flusher.
+	 */
+	if (stat.nr_unqueued_dirty == isolated) {
+		wakeup_flusher_threads(WB_REASON_VMSCAN);
+
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
 
@@ -4999,28 +5012,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		cond_resched();
 	}
 
-	/*
-	 * If too many file cache in the coldest generation can't be evicted
-	 * due to being dirty, wake up the flusher.
-	 */
-	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
-		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-
-		/*
-		 * For cgroupv1 dirty throttling is achieved by waking up
-		 * the kernel flusher here and later waiting on folios
-		 * which are in writeback to finish (see shrink_folio_list()).
-		 *
-		 * Flusher may not be able to issue writeback quickly
-		 * enough for cgroupv1 writeback throttling to work
-		 * on a large system.
-		 */
-		if (!writeback_throttling_sane(sc))
-			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
-	}
-
 	return need_rotate;
 }
 

-- 
2.53.0



