Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD0E2C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6576B00A3; Wed,  2 Sep 2026 23:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EF96B00A4; Wed,  2 Sep 2026 23:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616386B00A5; Wed,  2 Sep 2026 23:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 399F66B00A3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:20:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEC28803E3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:20:51 +0000 (UTC)
X-FDA: 85170999102.28.156F547
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id A64281A0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:20:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j76dF2sJ;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788405650;
	b=S4tXMiu7hWsMyN0RvBZgiU1wdL8adi1/Q96Tn7ekf0+GZjyrdlJ7vmFGEeZx/qSREX1B1W
	9zRofV5OMydeXFrqSn0JEzmBGLavJiEeZu1s6bCp3k4DAJqpgDVZ1ppyglck6cmQKEHEH5
	Wsm4VyIykPwhnJwnQcLdTEsIntrks78=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j76dF2sJ;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788405650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEBZVVlgfi7/B5Wa70F9uyqJ9z5paq3EJHsc8E+ImE0=;
	b=Ug2GdsgaPNRtU6vz+DrdxaIfLJjDlZe6YS38w7g5GE1IEkMOsN87eqcGTy2XtTvIZg0jzC
	oQNTkG3kOneATDGsE135xvxhW7f7tXSOH6bY8KENiam8i9Y04zpxI7ctw0g6bkFPtUAZOn
	eO90X5DsdmrZkw4mkFD0fvz+slpXFHw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gV2iAlnyroIqHvYCikGMSiDdJzetMM/dbS3MYN3DzYc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788405648; v=1; x=1789010448;
 b=j76dF2sJAXKSqCq3t+oFQZwG7Vrk+zPxk+JPRNrYlblKR2bv4gZ4O223kIWkUAVr+wUNIu+9
 niu7mT+ZCGCAMhN3gtaD682/95Ms7OjFpdTAClFH2TZvz4aR7BQB0uuV9hWXDinGdHEvAiZAg3B
 Vg3aIyEn0a0S8pOBPU8bNRC0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0f653951e6c46c55;
	Thu, 03 Sep 2026 03:20:48 +0000
X-Mizu-Trace-ID: 0f653951e6c46c55
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Thu,  3 Sep 2026 11:19:52 +0800
Message-Id: <20260903031952.1120321-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260903031952.1120321-1-ridong.chen@linux.dev>
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A64281A0007
X-Stat-Signature: i14d4g5axuye13hksbxofxuufc64d679
X-Rspam-User: 
X-HE-Tag: 1788405649-662062
X-HE-Meta: U2FsdGVkX1/dNYy5kJDeZK2LhfnQvaH/t8I+ktVyfZKNqMrmbouIIk9tOe/ZZIJJONADoATRRx36A3ipSXabgIhavX56mB127M6m4O8O7Ci1wN1cdYYP4WEnMqoCKqs5su/+K4EUbWre1hyX77m8/dvmla8egwPC4xUx4K9SkxzZenmv4Hqa/puvHOy57EVXXRgycZ5pv7K2qxarDE0+cg8mgcWWxPmWnMVzAxiYl/UzrpyxsSHNhRlVL3OYdTo9XgvQbRL/Zyg3uq1ilzrpSagPtUaZTYqQMzz9yryOaHigwxBXEYg3h/UEMRlHAj4y42O+zFg5KYwAILBG7blPkETjA+sP9mP+wrirl30SVeQ2c5rZBzn+A3ys7Gc0mPCwGj/VQenG3o2cobJ36yKa0kubC8w6vLkQvA5U3alPTmUuFqK47aoeahlS6ee1x8BYnkPUTZpvscdFF5LEBvD7cdOdePkY3sB6b5+Mb3VclOvogD5ktmwt2Hg6k7qIcGybgwiuBbRbipRKBH83GAgy/K5LYakf+65u44AP8di0ZF+EAFWUTVWrmZWHN+/8/WT0Avi2ZbCbMTvd1jQvVtwRwV4ZegerdLQmhCN45uUWrrWVLgdvrXPhHt+/fGdT1Syu5bOHNYGVkXyl7EgnqFsXnJR/ObBkmV45sLa42Yq04Oln/gTnR4gW1R17s0St/wytLvHgbmS961nmsO4GS+0gB+2NHU2G5GdmKPrIB/+zfuVOXtGBjiw9vFFZTC8czQhVrc2LkIw+cIroAOcvqPbLT1CxB6Hrle5fbybRT441QNvQuFs5HYRBVJPXIMblkgKzj+7z+fscE7igVr5eytt/QVXU2nkO2TjxUUSBRMx2prExbDby7hbzG1X/WVVxeagVRdYRt5+2ji1WryXmYc3E0rc0YyUWp0DuL9Mv699tsL+djeOh1uVNK0vlPOSUDoHr74Knn97iVaxP362SFTO
 djjM3DYv
 NIDO/8OMWsc1s1qO0xTOI3CvydSFY5sLeBujU7fNjsvmGBef8LSv5ffBI1oXjNuD3PdBCp1tmbCcl8gzWMDtTSl74u3HuhCgAynKWERjfho7wkKubpGata6PwQkoM66f0IrNNtJJsgQc/XOxvy+6gvz3WwI+sNUtyKezbCb4iBcLG/8wL5x7KK4IcmlEg1wKs3mDwhlYNXmK90qrMj8V8wujFwxX3ihgxHggwVtR3ee/LnS8TALfuuZRk09nQSkyds3+ozmA7Q4OrQAu4OFWO9owVlC1spRB4dObUsoKfNLOANN3vPdpOgaZV6oO+FWMTNZipD0Mr4xC0yBWdiatAj6spiZ8Hug2CZ+D/GIzPcR6mG9QwjVCKoqymINRvUjwvqOKR7GI0pysuPEvMq0rViTtxD3aqswVYTO0Fhp+ke83gCPSbcMa1StU8t52+pgBchxSVSPm9TTTCEl0jeZZB9OYmlK3zYjUak1UgbAvhQRroR60JRgX+V9Heom+h1VayUdneQhuNnTFMnSIdooX/fMmVeSZb1YKqdjfeUF/UIi9TrSv97d6XtIrT9bN5Vfoz+t6rNwdhMiZ4medw9yRMXT93oKr3f1pjmzBAEbYUTBnFiBWTsU+vS0xBQyJIHprOCLopkzU6gH1zyUGXt82lQepXtFmYrY4LyHV3JVbBZw+6XMyiG1jxs7leosv7d6wBgLxjGPa6ZNSQZs/kkfluDOy10UuRRX5HQy//EkQ1/hUg4CVbPCoFgvZ9PLqyqkRItwJeEZthxlpkNGZtBdj8hDqIgY6x3RT7+e/QjTAzYLRLFe8EXbC5tyXBOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

For MGLRU, memory.min/low is not honored during global proactive reclaim
(writing to the root memory.reclaim) and global direct reclaim, because
these paths shrink memcgs using stale or effective protection (emin/elow).
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
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/memcontrol.h | 10 +++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |  8 ++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f227348a3f24..a65a516adc66 100644
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
index 256b68ffca70..ae568fc68813 100644
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
index b4c9b8f3dfe9..500cc2051d13 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5111,7 +5111,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
+	/*
+	 * For kswapd, lru_gen_age_node() has already called
+	 * mem_cgroup_calculate_protection()
+	 */
+	if (!current_is_kswapd())
+		mem_cgroup_calculate_protection_path(NULL, memcg);
+
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
-- 
2.34.1


