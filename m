Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34CFBC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAE86B008A; Wed, 26 Aug 2026 09:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ABD46B0092; Wed, 26 Aug 2026 09:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8DB6B0095; Wed, 26 Aug 2026 09:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB7E76B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:31:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75770A038B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:31:34 +0000 (UTC)
X-FDA: 85143507708.09.D9607E3
Received: from mta1.migadu.com (out-53.mta1.migadu.com [95.215.58.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id D6A011A0011
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:31:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vDeC/xKS";
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787751092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ybBYFsWV0RkdYXDOifD6FYIYBznP3ZofoO2/JA1HNM8=;
	b=UqE6eVpNhnibi7SS4cbOHt5PZYWhz+d0Rpwx4/5qy2XcM91JTJlVaMqZhzE3jLExVF0fwZ
	XVtEP5VD8Rx1apFzrnV8FPBQ8orotHI13yRWSmFNh1SSinOlVLVYoPN4l3KDt0Kt7sPu8o
	LXWe9GA4mmhK+RkhWGFCczN3QnvFsWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787751092;
	b=Ys0Z4K83l4hrUVEaf9WOinEQdvZPXqp94kz2vHOg8s5iO141dyNSqW6pNU+Ul5UM/Dzd1e
	/GdloLReUHTCFBnCgS4YGD0aoRnWoA1b1hFPUhZa7Sebx4FyPCk4W6sbdBuLY68BwGZwH3
	QEqgPwnmIltqPZBdLb29yyOUg3FoCio=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vDeC/xKS";
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lR4mZ8qczUfYMvA6XHhKi70YkLbB/IMG+ilRAttzYlY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787751089; v=1; x=1788355889;
 b=vDeC/xKS72xq6on1IBD9TTHTMWdk482q+EU/+ACiO/M1dr7lUIMai1G8Bhsrez5QIgKhag9f
 gtNSnxpXN9jvCsgFxCcRYyXrA8TjjHBM8auipJWn5hs8dbIOw6Fmcw5fqTNeKA4kd5zK3OSa/Vk
 G7kAHbDoGPTUToGcY43B8xvc=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 57b289fe451a8707;
	Wed, 26 Aug 2026 13:31:19 +0000
X-Mizu-Trace-ID: 57b289fe451a8707
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [RFC PATCH] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Wed, 26 Aug 2026 21:30:54 +0800
Message-Id: <20260826133054.88529-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6A011A0011
X-Stat-Signature: 4zhyycr7eut9k6fpi8kg7dueixksanxu
X-HE-Tag: 1787751090-302889
X-HE-Meta: U2FsdGVkX184XrcWN7C7IVsserX/T2EeVsC8KeuwnKZzj4Ej+SdndQ8gUTAX/G6X3LP6o3Fy3Iv8TZJU6chK24MZPvPY06jZz5Yt3xf+FGRP2ecFKBFatftapnLG9WsveIRgD4Fi4QvZ3n8yWGU2L9WHjcFQAYjtHCgwuln4f6TxAZ4/H/9If2RPMPelE0kD7BUt4s4rLp5heyYvQUqTUKUtrjuzgJwtt7UIxg0LByVCPZU+eilzXXsO0Rvf5lob08oOsLjzAqk0/G4r9/JVBARHBE0LIUpjALsHPZmKne6DFgoGS2z67O5lc7r4Ssab5UmqbK6+H6LubYDSgLReq0kDSAedf6rCdUfEZgT67/uZuxtLNU1+eD0ycxpTqlIEVSH4F+a2yrg/hANIHy3B7zcg1AEutBnllfCku0Jhj3eFfZGl0GNxPEK9CsVpCx5jBSzNQDMZOohj/aK6cosSMEuBKT2Mu47iZo8IrMZExhZGRLmmCpzm/6us9xbKUbWUxb4oCcpG0ZWIVsfaVaY1KY7B/xUsk25UN89eLLyT1qBjOlHwN/Q4NFg4rV0N0OR/dBFj0R51vJdrrseVV7WNGMxYKSmTHOc26FamjBf9CBAKNo+HDdFILRRPn0uIvivYOwGXbTyRwVH7XlyhsRicLEDIQZPnPSoZ63bZC88rg0T884OzEAXuD1RJ6P86s8ib6fCPK6m7sLOd4MFzhRUaeG9cH3MG78uHFeOU89k2XO9pZMv6IaxVOHi2qLgjlMYqxpYYcSJBhIZWgWocyUVt1hBAqZnkmMsJJdu88bNj96Kzv7L8hKcx/fCsAE7f84zL7s+TDc0/eLOywAwRkMjxEEWgECfjhjs29vUsUAyM+TSF4CkNgkKvTkyPSGdsP3GRQB1obQr+mYKHCaCKuK0vri9fPecWJXVfy79lIs9vOVrwqkBP/yamOuXpeCOSnSSlXwOFmRDSiT6BGCy4u35
 71SrI5zP
 S29iIE3NgllSYWfbCeFqAtNNgrQvk8XPIH5EtkEgqlUVAedbjbRZSMW+NApdQdZb3vk+yaBQZvyrNde8aJGqs3cHWBnKCPqdUPTWLxHpSv6rTfnylKd4+dG5dBbOTe/61CzoFiWx8ZeFUskHuenXM2vKjPuUqF4gTYCrC1kBpEfFBZdK/EvLNhNq+JV5lueZSzXhMxEXXaI23mYQRFkrumpbnn9sr73en1JI9h5DwYHm4+8p2vxUBcqwVeZKUPB8jXgoPraTP8U4bKH348isTdhvh/6hWdClXLXVGO17ZWUBdX3qTE543LOaAxf6fgzn+FxfjS7BJacj/1jCRtaiy8f5vDSgPVTeR7vbhHOHBSzqPQFV21nEwZqx8ZFd0VGmgskyOubG6+y+KR0ZJwPxlk1L6pt/CNExs//SXyxDfd/pV0cSg1J1yGqDJ350IYAgBm8JLq5lFDByNPkRLwe4cPQRwGAqhDnk88BPm0L2jMzOLCu4WUrT9Nja+7roGf6onP7cAJHkYCsO3L6V4cQw3yhCFCl7GzlNOtzaiEVYcmIuZl7knLfk7fDawrKbu9Akf7chGC/Y/gbfYUAGqYrVSH7ISR+C3VQa4SKhX/A8t4a9n/t2CIj02r8I1t/3tGTPPrhlPVvnisy5H/aTCT1JHiRF15ZW/DgGL8lsPsAQZZKhbVU+Kf5N/0cqQ2HKS6BjDZSk0bVGnV2lwJEOXAMVvGTd1et5ANDREEQ3r3PEtqHsIypYlJ4xylkQhTwj+shoTRNTj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

memory.min/low is silently bypassed for MGLRU during global proactive
reclaim (writing to the root memory.reclaim) and global direct reclaim.
It can be reproduced as follows:

  # echo 7 > /sys/kernel/mm/lru_gen/enabled
  # cd /sys/fs/cgroup
  # mkdir -p a/b
  # echo 100M > a/memory.min
  # echo +memory > a/cgroup.subtree_control
  # echo 100M > a/b/memory.min
  # echo $$ > a/b/cgroup.procs
  # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
  # cat a/b/memory.current
  222650368
  # echo 500M > memory.reclaim
  -bash: echo: write error: Resource temporarily unavailable
  # cat a/b/memory.current
  6070272

memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
protection.  The traditional LRU path is not affected because
shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
visits during a top-down tree walk.

Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
moved the protection computation into lru_gen_age_node(), which only
runs for kswapd.  Non-kswapd global reclaim reaches shrink_one() through
lru_gen_shrink_node() -> shrink_many() without any protection
computation, so emin/elow remain stale or zero.

Introduce mem_cgroup_protection_path() which computes emin/elow along
the root-to-target path only by iterating through the cgroup ancestors
array top-down.  This avoids the full tree traversal that would be
needed with mem_cgroup_calculate_protection(), limiting the cost to
O(depth) per memcg - typically 3-5 levels.

Call it from shrink_one() for the non-kswapd path so that each memcg
about to be shrunk has correct protection values.

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Cc: stable@vger.kernel.org
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/memcontrol.h |  7 +++++++
 mm/memcontrol.c            | 42 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |  8 +++++++-
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..26be8277d64b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -605,6 +605,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
+void mem_cgroup_protection_path(struct mem_cgroup *root,
+				struct mem_cgroup *memcg);
 
 static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 					  struct mem_cgroup *memcg)
@@ -1133,6 +1135,11 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 }
 
+static inline void mem_cgroup_protection_path(struct mem_cgroup *root,
+					      struct mem_cgroup *memcg)
+{
+}
+
 static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 					  struct mem_cgroup *memcg)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..c739db33b917 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5198,6 +5198,48 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
 }
 
+/**
+ * mem_cgroup_protection_path - compute protection along root->memcg path
+ * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
+ * @memcg: the target memory cgroup
+ *
+ * Walk the ancestor path from @root down to @memcg and compute the effective
+ * protection at each level.  This is safe for isolated queries because it
+ * ensures parents are computed before children.
+ */
+void mem_cgroup_protection_path(struct mem_cgroup *root,
+				struct mem_cgroup *memcg)
+{
+	bool recursive_protection =
+		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
+	struct cgroup *cg;
+	int root_level, i;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!root)
+		root = root_mem_cgroup;
+
+	if (memcg == root)
+		return;
+
+	root_level = root->css.cgroup->level;
+	cg = memcg->css.cgroup;
+
+	rcu_read_lock();
+	for (i = root_level + 1; i <= cg->level; i++) {
+		struct mem_cgroup *cur;
+
+		cur = mem_cgroup_from_css(cgroup_css(cg->ancestors[i],
+						    &memory_cgrp_subsys));
+		if (cur)
+			page_counter_calculate_protection(&root->memory,
+					&cur->memory, recursive_protection);
+	}
+	rcu_read_unlock();
+}
+
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 			gfp_t gfp)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6dff207ad8c6..e572d2742c8c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5102,7 +5102,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
+	/*
+	 * For kswapd, lru_gen_age_node() has already called
+	 * mem_cgroup_calculate_protection()
+	 */
+	if (!current_is_kswapd())
+		mem_cgroup_protection_path(NULL, memcg);
+
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
-- 
2.34.1


