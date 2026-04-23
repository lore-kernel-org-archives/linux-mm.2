Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58281FDEE38
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B416B00A3; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325526B009E; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F5B6B00A1; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DABEA6B00A0
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83C37403BC
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:37 +0000 (UTC)
X-FDA: 84690542874.07.DA1E099
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 759771A000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ov2EWquW;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNdW5msyrpg5rNKZjE2nmeNay/C723YqLig4EzKvbhU=;
	b=5gdJwni/XVSSxE0P2qrGnHdEKA8cxdjIGn4/Eh+WeCEnvT3aLmhrRhMVW5vcfD4Pg5UNh4
	wOrHPGcPbEkYownscecHb2dhPRKQAhR4ZERVnKFDNURKuCTXQzdD2HSq1ZCLza9GIbcLAI
	nI1ov5rhmG1G44RWh+bM5N/bId3bePg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966215; a=rsa-sha256;
	cv=none;
	b=t4kVA0nNKbre2sF24xdKy5pbPbFGfg2tHY2XoranK8alYBSalvOv3AJ+UAQ4/fhHXvTZ6Y
	nogBvs6fPXgjtuiszmWJaQnYO9FmssuMjgarfZUtt1Ixm7qqb0vH+2g+BbWReUwLii2YS2
	09wm7L0bG/VELDpmTAD+wd937we5HyA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ov2EWquW;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 003AB44740;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6D91C2BCAF;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966211;
	bh=Kzbku/F4IhWLVRQA4XKEmpWT4XsvM1A8oBihbauYwAM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ov2EWquW8bvpBFhrddByuGy14AeV8xBoIgdlN5R6lssrcxmIKtUu8Zd/i3MO3q0wY
	 VRgfpE1bzVSQYB1Hks37zJnIW7fp3jDAC05QmnyOgQNmUeYZ/u9c7FfUvFuhglmT2+
	 QZKoX4m4LQb24Rzrf6guK8H/VwXPszu9hrQa4ZP8sE9mIxEh/V+BeF5MzQpzBgqBmX
	 jgGkJm6aXaZnh8uf3VXVaVAaWJGcE7euiF6KpmNnBpDbqaQAi9dhgDokO+H1GssULu
	 pO5fhEiPffTZ3yeq5DHslLQH7iB+xHcUcCA6H6jgW5RoDX98WhSTzMiePrSBZ6qB2t
	 4r8nVAXVXa5PQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE9CFDEE39;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:18 +0800
Subject: [PATCH v6 07/14] mm/mglru: don't abort scan immediately right
 after aging
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-7-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
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
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=3735;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=cyzkCao3l6tObidLw0rB9YIwMV9MllEksfGhK4Us/14=;
 b=0MXMmuZsZb1934LVkoZkqTiJqAyaKJhn4iq3J+AU0zWoPtHsgd+IWLlubb/4xiaYV+97NvQP0
 1e5BCs8PQcfDY8nxg9cC3PBEtPpWyMDipNHror9tUNf2Qd82b52WQ5A
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 759771A000C
X-Rspamd-Server: rspam07
X-Stat-Signature: osij69p5x4fzsia3i7y35e8dfra1x33w
X-Rspam-User: 
X-HE-Tag: 1776966215-668728
X-HE-Meta: U2FsdGVkX1/K5ktVLoa5J6yx3z9uUWIgfW878QY6OT/qoQb35XgsPKT/j2FF/8Mck/VpPzk3baQ6Mcz9oAR9wtb2MmKRJ+rvJI//0w7+n/LIkvT7VD8fpPxojzVh7dyhikGe0idTi//tIHIUKmnS4lF1kjtLAJ5wZO03wwkrIPWf+TNu/qyrWeiA8H77aZKvTyhw5Vc36mV4BfEhFSlMpLTTXcE+CeeAAKjNkp5UTjKZF4iR00V8SClsoNxNH+pX7GynUhV3n4K5kuszTzNoUImAlCymvda5pK4zefCvv+w6TlHIuuEpzbSujVfGWSpDXDIabKY7/E0WL84RGXBudtySoamQYAoMAwJIZ+tvs/eAyQPkg0+is+oGvAizNnYszjPZTcqRzL36GkC1Z/mjWRhUdCszFbfMj1iestKI7W5S42d47TpI+GEeYJUW2/8+GFV8Q0mjgHpjRgeHnbTStFXljapuehUOkunshNcp+AYdak8ZWaohq9r/AUaoSdS1HIMQJJFS67vNuMIbfBBTImMjiFOo0rUfVC9+TeJGFco7BMj49p3QFlq6JuftBinKxQMJE5LAT4lWF4UY5RDxYDVrhlEBbo/qBfg5Dlm+x/VqLmJec6cZLVabeWDKtfMDgrDUOy2r6xDVhurDlr4li6qQ51LEn5vLiagz8N75XN5EBbSJUucet0KaUEEsgvQrvNp6l/u3bdFoNkr9eb1rIiYRM2eLiX5AqURsll6C7c4kijYrvhHqCer2kb4ppO1Non43UtVmax4366s2K/1R97uR6wuBDY61fx8SCDZ+TNG1IezzRN8saw86sbPYAp4/mWdzvCOZIh8PaiRJ0SB0fo89NQvA7y85DVM3oQG0ZnohRGCoTgTJnUTgqJu4YKD3mDSrvCNk6KEUKAE1Pr0zVhQQArB6f5X6V4LIfftsEWtp1McdJOaBeUMRi2Rr5BcVKMOBFG3xhDOO9u1/l7e
 bHczcXO8
 e69++jLopYz/y3LPsekJXqZMTedqbdFTTiUOjQo+rIfCfNm51GcTrRPahwXIHmF+B41CMxoB3geI5hTDhktVp4puJS/ZDA++OCJb9UYQU3HiJqa8/Hwpx5syMXZF22GDSDN9x4YjoJ4pX9VvUlW0BgO07VdmPHtbDRCmQV2qOUNJ2BoH9OsRKxzyMBwx9abKXDbt2oiBWN58cIg4k6GjsLV3Wp9Yzh4N+zPZDpOsWrDr+bVE96Q/UZiG3XlM8M7nARFR71LDLaNHBEIXSIr1Hf25g8A2+L3ifUNe6IS/0VxBfVUI+PZV0vZpvIHtQguFs79NluwEE3CoDtLqGuesTLDyMfWgRiO3c8t3X1wnTMXUtUiWuF/0thyFL5DWr3OLLEvoVOHVXmuicIM4UXegk7D9SUZsD4U9+PEAPg8YvZLRIjYJzV2aMAyMLc1Yjht4U7BnFyXITeqLAu/C6+E8LFiNrrDDduWLLcbLHNIb3DCmhy68ppvrhBSTPlTduxyf5kiDO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Right now, if eviction triggers aging, the reclaimer will abort. This is
not the optimal strategy for several reasons.

Aborting the reclaim early wastes a reclaim cycle when under pressure,
and for concurrent reclaim, if the LRU is under aging, all concurrent
reclaimers might fail. And if the age has just finished, new cold folios
exposed by the aging are not reclaimed until the next reclaim iteration.

What's more, the current aging trigger is quite lenient, having 3 gens
with a reclaim priority lower than default will trigger aging, and
blocks reclaiming from one memcg. This wastes reclaim retry cycles
easily. And in the worst case, if the reclaim is making slower progress
and all following attempts fail due to being blocked by aging, it
triggers unexpected early OOM.

And if a lruvec requires aging, it doesn't mean it's hot. Instead, the
lruvec could be idle for quite a while, and hence it might contain lots
of cold folios to be reclaimed.

While it's helpful to rotate memcg LRU after aging for global reclaim,
as global reclaim fairness is coupled with the rotation in shrink_many,
memcg fairness is instead handled by cgroup iteration in
shrink_node_memcgs. So, for memcg level pressure, this abort is not the
key part for keeping the fairness. And in most cases, there is no need
to age, and fairness must be achieved by upper-level reclaim control.

So instead, just keep the scanning going unless one whole batch of
folios failed to be isolated or enough folios have been scanned, which
is triggered by evict_folios returning 0. And only abort for global
reclaim after one batch, so when there are fewer memcgs, progress is
still made, and the fairness mechanism described above still works fine.

And in most cases, the one more batch attempt for global reclaim might
just be enough to satisfy what the reclaimer needs, hence improving
global reclaim performance by reducing reclaim retry cycles.

Rotation is still there after the reclaim is done, which still follows
the comment in mmzone.h. And fairness still looking good.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f6ee7ccf4e81..084c6ea8910c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4984,7 +4984,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
  */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool need_rotate = false;
+	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5002,8 +5002,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
-			/* stop scanning as it's low on cold folios */
-			break;
+			should_age = true;
 		}
 
 		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
@@ -5014,6 +5013,13 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (should_abort_scan(lruvec, sc))
 			break;
 
+		/*
+		 * Root reclaim needs rotation when low on cold folio for better
+		 * fairness. Cgroup reclaim gets fairness from the iterator.
+		 */
+		if (root_reclaim(sc) && should_age)
+			break;
+
 		nr_to_scan -= delta;
 		cond_resched();
 	}

-- 
2.54.0



