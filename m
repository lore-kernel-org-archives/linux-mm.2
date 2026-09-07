Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D663C79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 02:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3FA6B00A1; Sun,  6 Sep 2026 22:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC8C6B00A2; Sun,  6 Sep 2026 22:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4306B00A3; Sun,  6 Sep 2026 22:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB2B6B00A1
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:55:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E33E680647
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:55:31 +0000 (UTC)
X-FDA: 85185450462.27.F187C6E
Received: from mta1.migadu.com (out-98.mta1.migadu.com [95.215.58.98])
	by imf20.hostedemail.com (Postfix) with ESMTP id CBBDB1C0004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:55:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cyPkrCpm;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788749730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8edSZP/05bNRtKZUAEXERm2K3TUPoQfI7ZtdFLanlnE=;
	b=ExnPdwXlTwJSI9VOQrEwLsUudZR9MdLBPa0bdy7A+k8zCcF13QyRPdGBDCZ3EUbIzV6MMG
	NtgvYDWYeErme6x9Rhz3+lc7G2AAtyA89AgmTtrUxUFUTOhIfpU8myFWELEbviaPsWhaI4
	5ASHZHLamBdYbVzq8oDFYlnC8FCHxXQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788749730;
	b=brmXkn6vsbN9Fk+dZ4qKPzYJQEoozTZwCCB2k1cFkjAayrUN0LwFP3qWLgbHuvdpBoCwDK
	zRbmF8AhxGPRSU9mE6NMqov6MLU09MlNndeVZpCPPJk0EGeWasvYfNQ/+dL8ozP704Ni6R
	a5GZZtX+6nDwWA1Ky88uh3AII5J/ADU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cyPkrCpm;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rHLKkqj9+AnMNB8Bzjtied3AhPjbeZr0topGLVp+bxQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788749728; v=1; x=1789354528;
 b=cyPkrCpm7owhg9wR2jRknZq/f5GpZrFhZ3ZVBPufOmQ+vUR4n8TEkaXxc9dYwR5G3OjCGDWc
 dfozPmmNAY+cQ5NgPjbvD+Szv2/z58zs6eTzHe9j4r8xHQDYARfAZxNYJc1nHRcRMYSSGSBeSD9
 cnTw3Bmt1I7YmqW091W1Rux8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 12f2adc598a284d7;
	Mon, 07 Sep 2026 02:55:28 +0000
X-Mizu-Trace-ID: 12f2adc598a284d7
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
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 2/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Mon,  7 Sep 2026 10:54:45 +0800
Message-Id: <20260907025445.1836238-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907025445.1836238-1-ridong.chen@linux.dev>
References: <20260907025445.1836238-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CBBDB1C0004
X-Stat-Signature: bao4kr8md4otnuhstxmuhz9o5t8hutci
X-HE-Tag: 1788749729-420012
X-HE-Meta: U2FsdGVkX1+A6nEjYiz6jRJs3kZ3noK2xD+cWeQxsNZeIKxiaKJbDrblDU7rPFRIw0yQ4YxrXGhkYCjRl56lyx7b1q7vd1kTcXVhEZ9B30928MJvkxboO0gdh6HoU4mjV1qlDPFt3Yo+T1Ff6UCEopi1t8+X2I6CnS66S61BuRtxSn72L+apRRqoVO21KoER5PeqBGmVd4eJvH9ZRoVCk956D+US3lirYyxuNgAzHLFSQlgYL0KNXzhhEgdOUfYeiA+02H1IaJqlYT3rHND4EV5fVTwvKy3b/EN0MuPv2DYgXgleJcsLbM24EyKHtO4Wys24ptrW7c4KvLUulN6yvS4bxL8+E+Lw7uWirFQrT08rzgw48Q+512G7OwWWOJPZRtkAv5h6Kjwk/4OdBYusOdKy8AZTA2E5j6zMkBkXng9giXSyTopxAqR8iFOnKDz27KO4BkmV7AT9NoveWl4eX+nBJSdQT7StCNrKtqiEQmWIW4T8ieEr2G2w+Pc238HkEUxWHACarqIaoeR+D2oUGra9TQoMVowZLx98UNegGuLJbm+KeFz0H0ANXa00QAnk0o8U+Ux2waM98Bv8IQ8BzlAqSz2nWj6GEpIv1tGF+D18PNCbBiaVeZF1R5Ru6yS6pg2eUVhc+1bT4acj3Wc6aaXFoHTNPrePG93QV5CwegLqRDPlCYpoVp8ENjl9BQGzpcFvU+7+AjLw+SQEX8gKwqo1soSYdcnGYm5Vl21j9xMlY6/Gpb3kQ44jZiyZXn43Ft2T31GEv1iiy/IteOTYd1ZwluAIPgKG0kpaO5YtDJNf0aAu5FtaPAlFQ+FU8iuAF3aG+qDhg6ezzAOVmNjdUAdAPZhQP+puRBSrfa0Pb6DWMdWlN/0zEGvJqIpqgbukskFoVJ7Ik4ggwBgWrQPnq1xERt02f5LYiEJLJmtN4IP7+bVTSoOY6QvC/5pekZYwhpnh5YEbdiH3m2sKa/s
 KWENkpes
 79SwxZmRQVJrzno/YPEEXtJYBD01hloLNaeTMerf5tBzOdGPkjaTpXho5Tc9yYksXJS5McBOV3+Aksdwsbyl6B2zUCltevNV8lKUUVkThArHsCJScpVxiYVPiOno8eGvpWAJTyazHJ55r2YtyJFX8ee08Y6m//IMcDFIUl6hfUBfr7TKGSWloTHuxpO/dgQeLUDM4JdrdnF5eoQcyC0Ed4IsoGuE+IbKjB6/llV0kpVIQ0+2nUbEzai7WvouFhzCitoyfZf6/cRMU/GtICPBMThtjKjwLbxGD60yNSYoZBHO9EkTD2Y/eD3nadlOCsl1VUn58RqrEg+PQa8ia6S7QWHMdZpYarIXhcntZqoxRiNn8jlZl1WG2yDiyLwDH1Av7SOhgAvVBMcJ9e+RYpaWq1zVatXEsJ+PqwfeZcdVwQRPYpqDu+ncewDptEcgg1joMsx0RrMQzDFq0Ve/5smWYLk7+OddLIoM3JtOQoH1RjuS/i2HiPqvIt1QSVRnd7iJTynBQXFx4q2wMOkHRaxhLcB2ttKfmow3E8p7Wdzg1aDR27gZ4XukxViTyA71l5KZpxb6lNkoxQtpwCE+voDqRCrJ7W5qDygFK24nuhpNIlQV/VAfK6cvW7QBGSeOyogpMC/HKRartK2eske7ceYSIq05PFe9IUlmiMBBtVKoNXphyspUSFN8Xdo1+5PE+LsB1c9YFl1tDRHSB/I3IzhqxsaAW2GDY7tIkKGOJjxYoVsNiSPD2L3gFwYEa9PDzFeLud9R0MDpivyk0vwD6XNZUgBhqUuzf23fwYNw+rWZzppdFbN5+MVq1zuVdPUz8bU69SSP7CWEB9WICvzfC4qQed7pK5VuOWWtt12M7bzlLcuprq6EY3q/v27Hfgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

For MGLRU, memory.min/low is not honored during global proactive reclaim
(writing to the root memory.reclaim) and global direct reclaim, because
these paths shrink memcgs using stale protection (emin/elow).
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
protection. The traditional LRU path is not affected because
shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
visits during a top-down tree walk.

Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
moved the protection computation into lru_gen_age_node(), which only
runs for kswapd. Non-kswapd global reclaim reaches shrink_one() through
lru_gen_shrink_node() -> shrink_many() without any protection
computation, so emin/elow are whatever a previous kswapd run left behind
- or zero if kswapd never ran on this node. Relying on a prior kswapd
pass is not correct either: a memcg's emin/elow are derived from its
ancestors' memory.min/low settings and from children_min_usage, both of
which change over time, so emin/elow go stale even after kswapd has run
and must be recomputed at the point of reclaim.

Introduce mem_cgroup_calculate_protection_path() which computes emin/elow
along the root-to-target path only, by iterating through the cgroup
ancestors array top-down. This avoids the full tree traversal that would
be needed with mem_cgroup_calculate_protection(), limiting the cost to
O(depth) per memcg - typically 3-5 levels.

Call it from shrink_one() for the non-kswapd path so that each memcg
about to be shrunk has correct protection values.

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/memcontrol.h | 10 +++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |  8 ++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f227348a3f24a..a65a516adc665 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1885,6 +1885,16 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 }
 #endif /* CONFIG_MEMCG */
 
+#if defined(CONFIG_MEMCG) && defined(CONFIG_LRU_GEN)
+void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+					  struct mem_cgroup *memcg);
+#else
+static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+							struct mem_cgroup *memcg)
+{
+}
+#endif
+
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 256b68ffca70e..ae568fc688130 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5214,6 +5214,51 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
 }
 
+#ifdef CONFIG_LRU_GEN
+/**
+ * mem_cgroup_calculate_protection_path - compute protection along a path
+ * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
+ * @memcg: the target memory cgroup
+ *
+ * Walk the ancestor path from @root down to @memcg and compute the effective
+ * protection at each level.  This is safe for isolated queries because it
+ * ensures parents are computed before children.
+ */
+void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+					  struct mem_cgroup *memcg)
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
+						     &memory_cgrp_subsys));
+		if (cur)
+			page_counter_calculate_protection(&root->memory,
+							  &cur->memory,
+							  recursive_protection);
+	}
+	rcu_read_unlock();
+}
+#endif /* CONFIG_LRU_GEN */
+
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 			gfp_t gfp)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b4c9b8f3dfe99..8409ea4bbf379 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5111,7 +5111,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
+	/*
+	 * For kswapd, mem_cgroup_calculate_protection() has already
+	 * been called during the top-down cgroup traversal.
+	 */
+	if (!current_is_kswapd())
+		mem_cgroup_calculate_protection_path(NULL, memcg);
+
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
-- 
2.34.1


