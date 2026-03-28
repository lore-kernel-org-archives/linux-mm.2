Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C53AE10F3DF8
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4BF6B008C; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 095D66B0095; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC68A6B0098; Sat, 28 Mar 2026 15:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC2EE6B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74E5D14022E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:34 +0000 (UTC)
X-FDA: 84596519028.13.EF81DFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 94A5B40002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aJT1dYUy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727552; a=rsa-sha256;
	cv=none;
	b=L74oZDKbnM6WyH24q7GV7qtAmBIrh/QtNUWKG01znaoIfGdzM7ch2BMguVp/X+WLhV0UzB
	MnXlsHRPYVo56DTBMaWGH9CqK9FmOSyEH8zviIbiW+46aYYcCMbUru8/9omz4jD6thdGVs
	PWT7F0ZH9bxLbyPV1lbAAzBPO1Tn6Iw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aJT1dYUy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727552;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80l7G9HqcO9QO1QwVtrY38+Qx4dX+Um/VFNib5/fNWQ=;
	b=Fwo65E4lm+05TIlkMgrmOHqIngEBbf+/OrwCPOT6PHGCn0ObKcCT5y1B7j4M+gbJ7iXdBw
	9Q+/GukNmtFKBFYdVHyor1vBTNVxPrrjA7YyiVG25iRRb/MHUxPMHCuwMCnqeF0F9pFpmd
	LE4dJO4n1THa0dN6Tie4lRew95kwi8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF79E60054;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FFADC2BC9E;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=pu/4aSrd7KSa0bxFp6wbeBj72fjrUtTNvGBmWMpcIZ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aJT1dYUyNuZFIazRsyNJ/qM06xTk8MMsVQ54NlxE8kIYlPSS1XP2RRRKd5tK8aQBo
	 vqYiLoBQ0/34wZOK1FPuyAFC5uOpEcDPU+L3+2zOjVfIYfecQjPAX3HOpL6391S0BF
	 3RRgB4TqQHW4Vr5mGEr+j9m2WDstmphTlZkgbt1hnU2Kh0lPMEeRpD74CfbXk0yu+o
	 fML2o9so/dudx3hdW86dNLB9swnbnvuhah0CYqoTO5QANAPzT7tPcbcI/qmIsoz+SM
	 IrTkXPCvLGTjAxcVG/DCvS9q3sLAQQMpyoPkhdeZomr4TF/E/bl8+xb40FV0zLfs+H
	 tTx2VA/dObO3A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A7D10F3DF4;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:27 +0800
Subject: [PATCH v2 01/12] mm/mglru: consolidate common code for retrieving
 evitable size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-1-b53a3678513c@tencent.com>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
In-Reply-To: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
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
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=3179;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=lovGNHm1LZYPq5LXk6kp/WVa26J2TdTx/242vg8RH/A=;
 b=hj21ORrtZUdpOHmPYaiMvHKxSRm7TyFCW8gCpjAv36+6LS9wHgaZodmMBJOM/fXMIulXhR2HX
 3PH781p7nFRA0yC9EulTtuByYWOmLHfk+hMTzmS1fYftr7+Eg03L4XR
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 94A5B40002
X-Stat-Signature: gh675nq6fz668kq9dynqk97nudewex76
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774727552-275673
X-HE-Meta: U2FsdGVkX1++k2cbixHn3C5h7wmKlWtktJYhjhBbmktMdwZAaZGHBkh/tR/7B2LoQyP+58iD0oBa1msa+6UbBG49ewn6tA4ARVzRwIqbCOSAbLOBR0aCQCuNsojd9fnTm5zDs0bE4uks4zuqzCXZx3nZ4x96QMenCF7WnzalqDZRpoLPFWLARi/f3EgLf9ywUKs2I1K8mgU/ecB+X+P+8dSGcEu3tvcpvbKAakFDONXDvMd45IS3X72FPItWjMA6K3WszsAYVhbbjqPMn3BFdNzM5/nKXJFOZLTiOWnvs5L0pNhhU15qOC3FbYxglsdL4uDh5zHfhsQczMX/mJUTFAXfsKga8KCsDp2tcJM7ySfvBdbRAjG2xdL/l03sa3A0LKb2vnuUxlV2qXqZTqKi5p7nUYl1OxB6RdfdFSnr3+GbiE9oWbZqklXlTYVKFnCbwb5jSoxEenaaKpC9a1XQyMLwvk2p97xNZFopKPkZkztywLzYulctzg+koDuxOIleQ7Y1YGJLovKiPY2DHSPacZV1Ptry6CPobZoGKpv/+TmndXh4ov2gggtX1+te/pRxMXHLXxhZcxnb7ujNEnx1RbznnSlBtBifasb1DmQLi63YA9y7T/XQyyx0c/62uf/76PzUIu7kXQwP2mWF5AERmbZ47WJ+U9eeflZutayNX09gNAZM1sMtqZTO6y52bjZKPVjhCWoycTpdyoRqz37D32rzIbD7a3vOjeIy0Qk1t7yAz2R1qAmZQ66YorHZqJR6ic2sSSkjRZRscNTSSPqnHhwtwGTJgL9mOnNjMVM/8a3ijia+9vNTQlkT2J2pVKmPX0Ow3ipZGtsS6OU+Qx0pyL1gY7IITt8VVH0roYeCiPvh0U9EDh7V7MXZfxTaXTLi73tr4Ix+ahMH/AWMgT7zSi2B/WoQRFZ64l8z58Pv5ubvkzWNXOtwkYKrM1oICMvaFScu9ebr8/TlmhHS1PY
 4AUpY0bR
 bZcuKwKtzfuHQAhpzR0UEcwtsP0FmJHjqb52qHYl7dZUNXqbXp1hQd8gG4/2s5C3G/wJbh1U8qwI+qwT4ZCfQKw6T+3C48T5ZJfINh7G3SdmSLutrhqDkjXaN88cgAtIZ3fcg+Wjwd4H06elIrPG32RywHkXdt4KYA3xklU8jIJc1xgBPFOBw0hqq0XkEj5+JQ3opiue5PPipNKHVbM1y+77G6ssjqJAk77Fld8UxyhNvYxzoVXj5dLbfdXkmXjFCwV5YOBSCpStZ12MT027QYUytftcAgH7Ay2ODMIGRev272zEOEOkxPxPKifKnEkSnBym0rrlKmo+dLBXCDO4eJ+qkQNZBQCKLQuowrVp3xQGF2SIdCUfghjY0cUWJ/zJzH9Z39Hm/HadnfsAHwU628uTOypSHLwyJX+P+qnsUfvwfx31+fbYdvDxVtLmcJricQrwYkbqH8par4bb+nlpKHJB/Qx16TAj50IWG9kByMtliwAkbgJJFW1/6k5HTZM83/n2oV65l6U5rQsMhFcudmbYMxw==
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



