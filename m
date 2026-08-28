Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC46C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 11:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B75F6B0092; Fri, 28 Aug 2026 07:10:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967856B0095; Fri, 28 Aug 2026 07:10:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A57C6B0096; Fri, 28 Aug 2026 07:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6037D6B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:10:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8014802C2
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:10:02 +0000 (UTC)
X-FDA: 85150408644.01.575C5B9
Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	by imf03.hostedemail.com (Postfix) with ESMTP id D7A492000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:10:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s3AqYBR7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787915401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5rY6Y8AhYSF++znfL6lSmWcX+XcB9nyGU/oCS5UvPk=;
	b=qOMe7oNrvFaMXWg9sJxeA6rap0PB69ILW//lbhz2v2fl0iBXd4kY+AA3x4pXYYe3xxUZHX
	u3QT9Os8t1889lr9KKM+pmfrxrlfoEikjCC+vP14h10q1SDoBsdlDjL93xi8r2RiFgN7E5
	SjUr5GzHIBnYIrOpDOO9FITAn9Z6pYg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s3AqYBR7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787915401;
	b=SqHponSPRX5XaZbkU3OanAsRtFYA4CTG/D9irMi74v4bfDpDfNGI8W7421sDV4d1awKys3
	Yb/m1qKQC5wCuJG7xdhlBXF4Ea8Odwn90hPjwjnEfqX47YziVLT7k7hydpweHeNjUyDAhw
	OoCAOvogvq4Ces3keMRMF6mTMqAj0Rs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eE7AKtJ5rHDjCHFP0sbjzrcKFX6z6p2ntCRRXg0JHB8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787915399; v=1; x=1788520199;
 b=s3AqYBR7xq9lQCJZeMNj5AAuqsD0kfS4MXgdsvZddFFOpu51QVN5ntOKtjk9abTPFIikO1Q1
 1wABoFLL6nAwe13oy0Dis2s3dVLZA9RL65FsMa+Dg7M8/WBIk7iao6ZVo6prAeBvwQB8AhgTbOy
 1gG5UEZmbR/djDug+B6vMruM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 103cb01acecf7077;
	Fri, 28 Aug 2026 11:09:59 +0000
X-Mizu-Trace-ID: 103cb01acecf7077
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
Subject: [PATCH v2 2/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Fri, 28 Aug 2026 19:09:19 +0800
Message-Id: <20260828110919.1324028-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260828110919.1324028-1-ridong.chen@linux.dev>
References: <20260828110919.1324028-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D7A492000A
X-Stat-Signature: cm9mww8dywiscfigaeafuofuiwnn46en
X-Rspam-User: 
X-HE-Tag: 1787915400-76247
X-HE-Meta: U2FsdGVkX1/cYbsPHiF2dnWmyHEQUSTrlIEEJFzZfFvOMtpXCt6Dck/My/xIGxKM+Dlj+J6FFDiAPnc8XMwYHLm8BLEO+BNEN2e49A5RRDtzDMolhCQueshVM6ZEpjuxmZFgSekpU4ZQe09wnvvfO8kTdjPDSp3ANi9Irc0TITJeFclA4iVcTSNgoHM5vh6efWz2a9i6gEzrH7kbF7z2jOQ/N58fukRMFrKGMHmVu/WpaLE27u9Q7ZRxv+33/GqLNwBSvx1hF/jI2xf63Wz4Bzda7c5P4W/K6b2InD0hFApTuPrMVvZnNNTSru/sVaNguSjJVFJojxPdOGUXzU9nuUJpCa3BdWGGJlqjYXU7QWx0dcFQ86MLgQrudLc8Ml6A9KWH1yWx033sIJKVg0LbdrwQsNvqxiKmTIeEs/Qmtfct3lh8yhsGDk5GnwK6v6Bpa39Aw/axEtuepR7K5BnLm1rs0cWZESI3MXUVd+sqjYj+BuDYA1DKT6PNK9N1tGv9paUfACGHJJkQodbJ5zHmLssxTMaAySYkVXMy34S6tVoBxFWJV9tlKroM2hoDrKZRUz22uukyZXCGVvuMvW4CRSTgkDOoPRhzcnbCQZDPhKwazzxp9mD2f47PCszyStisDvOwogfzKgyIB4Kw8uw/r2RaNCNEvaktbiRwHp06ZCXU8O9iaw9RS9mUfJbsIE+TMXZCDOZR0Ej/otlsFgmfF4IFLEsQJW4xTekdv+kwDEkZ9HWfTUIQrlY+rPajI6Z+g5RBqohBmnW2U8GMPSC5/AddktxFPA/FmSYPRDCjex2JhfONVIJwl2qyKEIv/E+oOANFBnuyNUXTjHk7jyS5vJicpCjlvLpsO5F45lFipdpCizdfxMwNUjbdx0nMpe0Haso/h663elGILjtr8QeP+NcXzvBnYKHeOGTEp/ne4ywLZEIBrczxAP+xVLfpiwu5Jd4HJ8S6/ZrogWp+dkt
 sFFdBqRF
 BngtNSy/HX7DbhWt1RryLRDCGqi6lRN12Abl0eryRBa82ULXCOxuLbzl3xnIGLPv00j1DutiH9ivzwHZRhJXibcW77x1OGzeB43cQcZ0i212bNXP/6AYj7OYmweD4PEYwCgc9IF374RVvS25McEVC2In9oEphCSTOUzIij/KVPlUXIWkkmu/FaVoBTMH8cWc/UAwWU5DE8E5ALk0h8OFGuo3996ba3CX+fTVp3Swxt+hNjlSoznde1lQaefgcuNvVuxLj1Amkq9oUurHBxqtC37/rV1xfI0TerwXvBdZoBv4oZwdIceM/5H52piz8+5fv725dQmCq/i/rL/hJXvVpZedRAvwUT2Y4adv0wqdP7fZpI9xjYOf1zYn5T16D0FaFQDhwXSrRHjijw3POw6b5xxDIOwbvLhdQ8xc3d8c+X8Gr9GGaMN5T5uiHL5OuOAag0G571pfA+5s0IPTY+iRQoUe+sCgNW3O7nwUaeAODewu+DEkxu1jCLx3YX4Es6d0K60t7fXngBYO3Xp/c3Oy6Ef9+f34K/Z0cw3h0lZVwvStVgK+tA5e0m9QBWiVtDKbqmM8NNOZSbjBykLxCIQAv0BKANKMqQphltJ9kcvgbiew/0VkOBOqHvIhCUiDfQmZ+UothZHBOCESbStppvW0j4bp41jzg/8uBt8vzikZkx8zQ4b1TaIWDQgv2iZeIGZSjzXhUDfxKmqO5DXUbjK08Ih6Cche32RYqqd9xiqjk4vyRWIwabWrANnftsGOnXZ6v4HQlTE7ooIKW6bHXmB/7/sC4woGswSenY9iK99Zv6G3qpKqurIJ5L/i5Bw==
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


