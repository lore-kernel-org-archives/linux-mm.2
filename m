Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB1EC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50896B0099; Fri, 28 Aug 2026 05:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27DC6B009B; Fri, 28 Aug 2026 05:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65E46B009D; Fri, 28 Aug 2026 05:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3A46B0099
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:25:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9083C8025F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:25:26 +0000 (UTC)
X-FDA: 85150145052.29.1260BA0
Received: from mta1.migadu.com (out-235.mta1.migadu.com [95.215.58.235])
	by imf18.hostedemail.com (Postfix) with ESMTP id 94F871C0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:25:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qLJlYmEQ;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.235 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787909124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5rY6Y8AhYSF++znfL6lSmWcX+XcB9nyGU/oCS5UvPk=;
	b=gM0iiyyw/j4wzIxpYZIQOz4kIqBQzyAtIXmZNUgKxVCdFEPr0ZhQeMvXPsz9rpCaQLnzQ4
	7bBA00EUyp4k6MYRJ34pTsyc97V3U1AArvCKKKPpYyXoiyhAdMipkOD4Vnf4YU8ob02E2A
	g+uiCKlwL0I2fTDWm5VTJY0HDFhhz4U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qLJlYmEQ;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.235 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787909124;
	b=gZRNq528E8fvt/JuIiXzn3UWELC4q4XYZIqzkz8dQTM5tfYK9fNUIzS78m4NTUM5UNvWRR
	mOpXW5m/POVGvsdRLecwv0t/s2bVT6a1jdA/mcn1DMQzn7OycwQSpBi6pWkz/bfvkVYLu/
	EQU8Cv3PFh/i0D0X4oNSv+itdRdOIcs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eE7AKtJ5rHDjCHFP0sbjzrcKFX6z6p2ntCRRXg0JHB8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787909123; v=1; x=1788513923;
 b=qLJlYmEQsg2nGJ/WAESfsZ/t9JC5CFBWxE2aegEVKi8U8bbevbLb//xflTlm5GQeXfE7XX8T
 5XQHjx9bsh3uYTsSO8TuNRk142VfY1KWzZ3Y89MRbduq6e38gvfY6LcZhrB2jfiB+BoN8dbwazT
 CMElWu1CgruvFk3htBtBNN90=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ae2bfd24aaee5f26;
	Fri, 28 Aug 2026 09:25:22 +0000
X-Mizu-Trace-ID: ae2bfd24aaee5f26
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
Subject: [PATCH 2/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Fri, 28 Aug 2026 17:24:32 +0800
Message-Id: <20260828092432.1257917-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260828092432.1257917-1-ridong.chen@linux.dev>
References: <20260828092432.1257917-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ztsmp9m6frs69qugycprks1hsgshbq7x
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94F871C0003
X-Rspam-User: 
X-HE-Tag: 1787909124-843751
X-HE-Meta: U2FsdGVkX19k+WLuqOA2YC+1vzkriWz7oTKZeIvY7tatM5aBt+dTgZ2gHYrx6pnu0UkUvY75vlj0MXDP0WtKOyes9fkMmmkwRd5qq1yqsJLFD4A3pvLv/YA803q+WkYGLN++/SfLrc1ncORWHmpRq2uh06a4pFkJbtINrBe1IHitia60pluqZvZRAp1yaWDf/NDNMl6oGPk83ypgZhjOHf3Nd7Xjc2XrBSlHM6lOug8DQqA4GRS56OdI1PSf2+cuuiuCqAqXjtcDZ4jbLcTIQgKZmm2StdXCTmJXWxXVzAvak62h0C9Q30bbeX5jKqlK4FqNCRQz6iW/rWt2fMNwC2W3v7Aa5YZsZuEqT69GOLGWlVxRjbs0nbCCqeE0n9RwXGp6YX78wAoGuUC++1w7KxeuYR0f9X5n6/tcfl/d9+t+mP17whUtpb2Y0cbSkSGjhWLRRFtJaGU/tweQmknQg0Koq8BZZIbXDsdZ7vxQiMy7tmxZx1hKvlVrmMQr0z8X8+pFi0JZeIFnTF8Frzdx+HGMQRd/k0NQFjEfZ9uEAodzK5Q8/npU7Q6KmOB8c3Q3br2sGd/SsH7U0laKsDJDmwbfKCN2LCnPUBNFLXP9eSTAJvkgI+ESg8RCTUguHmbvGDbAarQ/GlGGAjPD/90XNurxGquFiBaF9C6n0KJzYtrLBdY3aT61RN4CDOXpZ8FZ26b9umaj1QeW7hwu6On92SUpTMSjKJiGOL/eCVeOS1au728ldEgtRoaSjErHnCfH9nEzX9WcrFP5qJqf4OojzniRzrwu/V/12Z0EqVKEhinGuIlZAYwELih6saDJis6qsOOm3hahwC+fBGUqDpEnHyw5YhGL449zoPaoE7aLu1//CKc8r2YHH2N6XqZ5CNc4F/Gnv56U3bOt/pfpoXsgJyF1/dgvX5L6i/637V1nVbMrPob90us/8yWP58IKwJQymbyB6GwnjGwypiZ2Gch
 T8U0Qhys
 UAZdm1caZnu8AuXuwxIoULquAntE/jVNo1QEBkX/oUD+zTL8fk8XOA0C6MoRowM1awWSy+bEIUSDtHw8aEkaVKWcljkw8CY5FoWbrY1cYEyFTVbftYzd1cJb7OiRQKIvobaPA05Ji4sXftAd2ZdwLILsaGA2FKFg4h8Trs3LCne/WxIbuvtntFhLYZDvgPg4hG5o3SiJe+UppBOu97gU9o7vR9GFh6sYgfKMOoAhn5cJqp71SREM6c3d2L0qrWHESMUJARR3CBR3nePnUf2dN/4DA/YJzEJJwoWccWEDL8Sg5h4AzuzOGz+YZPcxtFi98gKjxNqxVexoM1iCMODZ+jG7RYy60U4uebqnnJY1gv8XSJBgGxNM1Lmwi3fywH3kDWT5p7bE84cqMCRhlo+oKIV1jL4FJWSdGcX5cLR/aiT0gUTqTnR5zEEKkD1QUuGDSxqPEroWLwK3NPcFfuBdUu78aWMeSvNbd2Fc72N5157/jQqEIZdlYk6+faMJKN9wsm3dIrz9KDFitWxpq8/6XPQUYvHWuAH9JpV3MoPMMiflin7Ht3XJDmBntW7DtqPLh2nkz/u2RS3mt9qfyCvbwmcV8JNXyT9bRMWd0FPv9MxWD4n/lt44fOzRTMQ6OSHl1aawY/cCYi09kyGdrEKOz4C5p5S68hWp8L5OgJU3dYtUVbeEpdeOj72gRbXKQVZlPyfHrk75mFA2hbu2ELmiKUrkC6aNN5JzoLing3SrNFUtLxhgqgmdvoYpBnA+K6Smyxj5Xiua834CqTB7cfcdepqfgtUJLPGwlvPJg+f6NVczNBq0vqNpxGc6KeA==
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
protection. The traditional LRU path is not affected because
shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
visits during a top-down tree walk.

Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
moved the protection computation into lru_gen_age_node(), which only
runs for kswapd. Non-kswapd global reclaim reaches shrink_one() through
lru_gen_shrink_node() -> shrink_many() without any protection
computation, so emin/elow remain stale or zero.

Introduce mem_cgroup_protection_path() which computes emin/elow along
the root-to-target path only by iterating through the cgroup ancestors
array top-down. This avoids the full tree traversal that would be
needed with mem_cgroup_calculate_protection(), limiting the cost to
O(depth) per memcg - typically 3-5 levels.

Call it from shrink_one() for the non-kswapd path so that each memcg
about to be shrunk has correct protection values.

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/memcontrol.h | 11 ++++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |  8 ++++++-
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..8066b798a759 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -605,6 +605,10 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
+#ifdef CONFIG_LRU_GEN
+void mem_cgroup_protection_path(struct mem_cgroup *root,
+				struct mem_cgroup *memcg);
+#endif
 
 static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 					  struct mem_cgroup *memcg)
@@ -1133,6 +1137,13 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 }
 
+#ifdef CONFIG_LRU_GEN
+static inline void mem_cgroup_protection_path(struct mem_cgroup *root,
+					      struct mem_cgroup *memcg)
+{
+}
+#endif
+
 static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 					  struct mem_cgroup *memcg)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..095050d4296a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5198,6 +5198,51 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
 }
 
+#ifdef CONFIG_LRU_GEN
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
index f11491ee9ed5..e0ba68ede745 100644
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


