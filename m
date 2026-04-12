Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1144E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207246B0098; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C676B009B; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A3E6B0099; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E03756B0098
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AB7BC36C6
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:23 +0000 (UTC)
X-FDA: 84650486886.25.194512B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D5D7C0003
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ErdFdSoh;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012501;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9onS38a/+xa4xtBFUcC9z1dNXkQev9YIZSMyQ0UjTKs=;
	b=G18qLo9lsNxAgfv/R6dTj9UpgxnI4fWOECmm6hW93i6FVcBlrDmnlwCuDzVuBlP3UaWzrK
	816RxpdVW+QTe4RdBKp3/UJyQ1g/XCIGacrcUtTNnRVahG7Flb+ak321wXhjRxOXMcok/6
	SR6wMoWgxnMygufZRhe9bQpRqFnPeGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012501; a=rsa-sha256;
	cv=none;
	b=MyZNFD4E0Eoz4ILAwj+4V+YeAWcq/JmEs60EhKpR/vEgsO/h8wE1o/uN5lmrT+w5x75MCH
	n+PL5/SoN42MLRD9oJozTdytBWtXsTAbcVdP7bz9k/VuAKe81WYyDtURKxVt5lSgq0OPZm
	c2gJDQlwJLaT2it7MxKFAmCL4tUbL2k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ErdFdSoh;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4449244559;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1283C2BCB4;
	Sun, 12 Apr 2026 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012499;
	bh=nf8UOchn9pxNiBANW4ySdYqzcmGuZiLDqUsnkRCZFnk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ErdFdSohAPG7hEx5fLRcBg4LN6gXekrA5Cbwi++uy3MhUt7eNoeN2vecyo/8tTm1r
	 vPl5xaYNgdR7waZdNGGKnr/RlV/U9z9vbnxxyN+YgGNOdIlYH8+CxjK8IcpYSiVLCC
	 Hp3aYuJO/rrDTCtrSSyijo27RkHj6Aa8lDjTDQ2MGmRjkiiyQF97J4kneTPCMdptJw
	 2wLMRv8YCHFNecXOBccnFunFMw2lIjGCB3flNlFRunAiU+i9s7tFZegNKikjijmaK8
	 6NVhccWLH00TmdflNyr1aqRzhWoWnHJga1j/6EOyash25LidtwmxogGAQVxx0lxfIb
	 5etczCe3Mdpxg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CB9E937F1;
	Sun, 12 Apr 2026 16:48:19 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:16 +0800
Subject: [PATCH v5 02/14] mm/mglru: rename variables related to aging and
 rotation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-2-8eaeacbddc44@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=2994;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=uhTQOpFFZDYAXHD7SVVg5W6PNjRmTF38550AcmIU3G0=;
 b=rzmC+e22/YJ/zjhP/Z03E6RXgQMSbo8ah/UP53ZdGbMkSdGPfGN4T7j73W/Nt5qr44FtFOQ/q
 gu08pkmZOblAnf7vHx4258Vxc1WbCj7bDwRItBsoDqB/sA+a1eU7F1B
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 8D5D7C0003
X-Stat-Signature: t4zrc3deeosmfdxnaeznbp6j1gswudco
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776012501-142945
X-HE-Meta: U2FsdGVkX19DYJnJIHenyEyuN07tDMdu73TqNLHRI/Omkb6wYN+3MhzF6bBRMEj06z66aJ6+sqV+ARu9vgmuUdcdp17R2LScWJIP8cs6ElMisiBiEDFUin8LPekG8JuRuu65nuMz4VwtViXxdj4AM0BrMSrmc84BcbH+X/TA7XiqTE3FMziGVYF7r1vJDN0JFQ4TcQaMSJRDcFtknCZrufhSKdyYF/8LAMisuKj9dktt5rXLlmMowuCJTw7O4O2pe8U0em4SomwyjMCfh1JVRfiZWMvv0k3z1qF/KVfmEslkUJ/B2WFRnR6upbmYT7hJ3GFLjXflqqxy06BdKjrrzOHorsNgZNCZTas56PgSa32L5IfSUj0NhLai3JQ3ClMy4CxC+wLpF2p5sB9p+zLq+pU6PZJAB/mBepf5cEJCphXB5ycnLrrQ529a9wrRDRz9ISJ8iYszRaLtI00ZXxka2hvIFONAZkWaZLpmSuxhZffrrc2Xq4CrEUo2gy4p+Mu+yOuNwge49h1WdZd+BhF5LiAH1NZzBxLRluV1Gqei2vQNz30cnlW7wXe3gHcBloWCoUf9YOmooglDH1UQ10/O0uYnBf+iC7SBBXSpI9vv+pbo265Qm9PUDx7Q5RutySZPN2RyfcRDYp3sIPXsHD8nFSAX+DabtVFlSJJ/57HUVEu8Zj8wX5+gQzCOcrdQbAgmLC1Qt/wf5ij/kcss3/5Iwh/phnoTuY0U2XbvY6EGn8RYsML3l1p6pzjIkU9kYaHV+55Xm/fOF0h2u+2f/alUofHf13wqEtCAxk5jN3iMwys5Dt8xpUgs8HJ3LUIM8g15eTln25bYeZD/a7cDm/X/y33VaFbxAxZwBqizJpYrK5FgpEIINwUMy3VSpW1lcGxpRX8MdwjH623bUhlhHMpyzQWCSH788R9A1U21o2dk8q9EpDqtftGDFIr1ts6X0aXT/WbP0/wgJarTdtqI6Co
 PwKs8btT
 IZfzP5uO6UnWIvmlOV4VJC6WtBoO7QVx9xAn4vnypqtbFBXUoQVDC82A54OwabLIu6H4J1MGNhi0+yRCbLlIIusxfkUoBVnZKVCgVdvX6fgFpJdXNL7LNH76FH3q+hD1IY9Q78UMmWG9Ci5ZqUNA3UjPwiBbMqtoxh94KaovwgFAS77lNy3tYbpZ8P+IeO3CB+9pZLuYFoxd4OwJCbWpCGtaKGO7w+E2OhCVS/0v90g2daNDoNr7kClKQpooj/oIys0rFVd5U5n6V780zLIH3/NikRlzFfDpP/G1x8cnQ7xP7135dgHwkdGNBDum7Fq39hMBCCiqY++t+ekxjCPXfUIYFSQPYQ5IDJFwTtD3Xa6D/VcCx9ZehLB0gjuG2eVhzYUOKA3w+XZ0nVX6Dcgsg45XyhrX3meO8XhZd3p3cjWWOlgD1uqoo2WQUBH2T/swQwH2WnPcQWyIUmLQvJ4cig7bTFEdqk78TDz7/nFzWj22MLnKu/18dKwnmDw9FElrx07cYDk42sKIYZjDXl0n6TYehLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current variable name isn't helpful. Make the variable names more
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
index adc07501a137..f336f89a2de6 100644
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
2.53.0



