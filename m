Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 308C7FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464476B009D; Mon, 27 Apr 2026 14:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4148B6B009E; Mon, 27 Apr 2026 14:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD176B009F; Mon, 27 Apr 2026 14:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8316B009D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC9B81A0270
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:13 +0000 (UTC)
X-FDA: 84705117546.06.8F8004E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7B6814001A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qf1NlhNj;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313231;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=or3iEZCr2lNax0MyG6woC4u6EQFAtxUW0Lp6aexg2NE=;
	b=KQFZNQ/DwSp6B9qKZPJESQikSlqLS19Zd3vTUFyEJupCQlfALrM45EnxFM5YhUn2y4I6tY
	t3xwwESGdpAnsktKhVPU/pnH4Vy0vgs48ceBPpp1YqcBdmW6lX2OuLkPkxrRTe8ppoxNe/
	BgiLkNktl0wyRqhInQs5dHhbYjN/9fY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qf1NlhNj;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313231; a=rsa-sha256;
	cv=none;
	b=KRi9yDuupJJWTVJimOe2ANi6/7WhQj0aLlVMxHvniZnpBS6v2dA/teEGWFslZwMcGhQTZa
	2vpaMVYqcivjYykUVAYS2t190d6qf1xRpFaHcikP+Zyd8XA8aKnOO6NTNWyXgctgmrnXcR
	jyXB0Wm9bEIKqJJ4C05I9J/Z/3PR95c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8583144728;
	Mon, 27 Apr 2026 18:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 934FBC2BCB7;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313219;
	bh=1YOeQEMsoIFWUlmmBdc5ofmMnY6LcY7a0cvpJ2cw9hQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Qf1NlhNjMxWgdJ9/hNjBGEbJgT5N6caTYKuMNJY35U12SxhHv12B9pwCLqvXev8hC
	 w/jK5DDsE2gd7AU+ykE79FMoDeaxm00OANL60Jb4Pi7MZ4eK4xcjEc3rqvIPjm9b45
	 p6kMRlAfoOf4OKr1UVHcFQUmRnujQGsCQZb1o/Q1pcwQmODsHrgjXQ8kiOdijKqrOJ
	 EVMQ19xUFQAgFQMBUKO27xJDT5AXmWbTdg1vuSQZEC8fO7eE8Wrj6RUo4t37LPnNxM
	 seiIo8+KmcaZ+pNRWyJhpbQYjyO9Fyojr5SqNwd0ts/hJFqK08tOIlg5HQkL27Duf7
	 bTWaVJK7k5VsQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8978EFF8869;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:06:53 +0800
Subject: [PATCH v7 02/15] mm/mglru: rename variables related to aging and
 rotation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-2-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=2995;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=l0/ENeR1KIeJ87GpiJHayLU6igooeuma0gin50pY+k4=;
 b=u1dVE5TAmHFfJL1qnXcusicdetBNFOfQxBq0Bpg4qA0VOA+gkKEIUWTffNES3eyyzd1vrRD29
 RzjmUIb5Ci1DmT1Iby976126yCWEdp6egFcQc5r5Ii9BLh6gFv9PpaQ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7B6814001A
X-Stat-Signature: o9utmucupw7st8ojptjnye34qe9kf7s4
X-HE-Tag: 1777313231-528615
X-HE-Meta: U2FsdGVkX1+d0gnjv8mR7pi2w5kneAypnf5ys5EU8bcPwF38ocGquAokUsLX9x9MfPMzxpnzfQQ7kcY5bgoLiY7pJc3L/YoT+1uFx89kJx8LEdk2YHvsPNd00mZ6kcG81VH1HUY86fsP7hr7zELalbB+7UxpMAfbUtAfkOrwR5Om5O+tyyqgQHE9d0s/3isZyxsnBrHbrV+RpOx+sxR99z805AcfjdwLqQ8umW0+XZ22F+on/IUS2BuQc8b4m8ikZXrcayLYh4qnj/VGnHyy9z4tZ1BYsbvpEuDset1hMFilcTMSMfNrBO2fYti9yZ6dKMK2gS+GhwdmZ8cp4Z48SJb2yrNoYmolf4oCJUJltnpBcKSmDuXaFypqJ3XqiLCtk7Cc8lFUVxldXM+RsdjfkseVGDuXx/pJEDCHldytov2L+6xyTWgwSNQbVmNtYrMkii8BfwGzQPYGqmfi8T/zdvgYorUVfyWZS7VEMyK3xdhmHSz7esjWWu/rMA3jze2sjM1ZhwaGFqrLAb2FnvGtKOWOYL6KEBfLoKBuhpvkJeGE0UMeT1u8zpsZYaPLcfz9kjn+PqCNzCa2tZZ6jj1yITNu3n6vu3rXVHiGWKHXo68lelF7NoFKjkDR0gYZnRtUJHUYAzVqPLiTnoliPSvBJrtEyYDvotGuIc9LRcRLDU6eurvAzRWIHqY314RqvFVVvEObWKYs4F9ARbtA1WS6A4sjfggQiCvGUGQUVYSIc2NI2K4AaqPKuGYJL/MCcfc2SM9pQCPcu+e4rsJxqoiLcml8l5udoKeLdJLMT2YEhL5/pmhuykDHw2+rrLlI+yAL0Y1iooPcCtEvWVc9evbIyhj+HEvfkpTF/iFVdP9xk5ONdF6lRQwcoxdn/b1HnMnptX+QzJgEycHl71524NHNkSAtOja0DLc2G14kBjwX8Om12Cz2nVLh68LDgOAHoQHFaVTdqnfgWJ8we6qd5Wb
 ZasMGV9C
 Ss/EtLHMynJ7nFtkWHUiG/lNqmgCYQ9hPu+kAAb8508P1bfPFMBe3oybUg41yTMI4CRiPu1wzV8V5Px6yPpPojNZLrA9RInWE0U8reL0QAHyJ2iUFOeZR5noG3EoKbxbb29LyjFJBH53Ani4ae/D59puQbVJHVbjD+oXhU2kN7zd2TOZqD59AusVKSwIscWVs4Wry9UQ7VeuD0maH0OGx0rVkPEFDWOqizdjdwHSsXlk/RtyT936kfozVYn4zNBWjczMXw+sJwaM9apIcnGUh66uXr8BpuQfAO8NY5BRa5aKlopu/gQBZaEj0eIlrF7L0KqV2WqcrHqIVzkb4vl1Otyq7AmYyktocvxRPwGUuto6CyOUIceMZaL3b/ZO2SbSyWQg8KOZKSOIZXEnjRB/CspELBM4cDAQpSD8/5BBgpdL+s+Ko4BJq/8MQVkODf+NRTYsUZfq+Stb+TA6+yVWFKmygXbZRzuQtGQ0sBAwQRWsYRlYH/8RZcAiJQwD4NHp9gAl/BvChpk+xHkUYsjlNEd1/88CKAg/uOeez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current variable name isn't helpful.  Make the variable names more
meaningful.

Only naming change, no behavior change.

Suggested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b80fbc4fc285..7f011ff4c478 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4934,7 +4934,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
  */
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
 {
-	bool success;
+	bool need_aging;
 	unsigned long nr_to_scan;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
@@ -4942,7 +4942,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
 	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
 		return -1;
 
-	success = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
+	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
 
 	/* try to scrape all its memory if this memcg was deleted */
 	if (nr_to_scan && !mem_cgroup_online(memcg))
@@ -4951,7 +4951,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
 	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
 
 	/* try to get away with not aging at the default priority */
-	if (!success || sc->priority == DEF_PRIORITY)
+	if (!need_aging || sc->priority == DEF_PRIORITY)
 		return nr_to_scan >> sc->priority;
 
 	/* stop scanning this lruvec as it's low on cold folios */
@@ -5040,7 +5040,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool success;
+	bool need_rotate;
 	unsigned long scanned = sc->nr_scanned;
 	unsigned long reclaimed = sc->nr_reclaimed;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5058,7 +5058,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 		memcg_memory_event(memcg, MEMCG_LOW);
 	}
 
-	success = try_to_shrink_lruvec(lruvec, sc);
+	need_rotate = try_to_shrink_lruvec(lruvec, sc);
 
 	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
@@ -5068,10 +5068,10 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	flush_reclaim_state(sc);
 
-	if (success && mem_cgroup_online(memcg))
+	if (need_rotate && mem_cgroup_online(memcg))
 		return MEMCG_LRU_YOUNG;
 
-	if (!success && lruvec_is_sizable(lruvec, sc))
+	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
 		return 0;
 
 	/* one retry if offlined or too small */

-- 
2.54.0



