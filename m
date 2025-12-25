Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEBA0E7AD4B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 23:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F07B6B009E; Thu, 25 Dec 2025 18:23:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1246B00A1; Thu, 25 Dec 2025 18:23:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1A66B00A2; Thu, 25 Dec 2025 18:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DAC66B009E
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:23:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BCDA1408CE
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:23:30 +0000 (UTC)
X-FDA: 84259572180.02.84CE0D9
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 96E9A4000D
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:23:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oRUyGsqf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766705008; a=rsa-sha256;
	cv=none;
	b=soMi3m+drtSl94s7ciULF0WugQlTzuY+P85TzeoGoWlmdP+89QCF5Q4Y6QMTHnVmPol8tQ
	yyK9lGDHTb7PJ3AkV3RQMOWXa4h4Q+27KJTym1s1fWanZ8b22rTXXJchDfGOjL9BrG7eI2
	Qk49r8RumeS2IPWuEAXNb3rRMib3N3c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oRUyGsqf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766705008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ipsZ9pFNe593ot4ifmspllIFtIPZMuP1LeaIWTARIM=;
	b=BdLHVfMSUDwxMNC4Or0p+HeFbjhwyBFdneQTc1EtYQi7lpv9kt6p4lUYaa4MkPcA99PRDE
	jfejIWjvU+ef4+hpByFfL5bfQOPnlYYn0zeizvpH1p7HpDL1s4Z1+ndBb9IuSf4ZjXs8At
	YUTjt45N7olLxgmTbSGcOXz86F2SCk4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766705007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ipsZ9pFNe593ot4ifmspllIFtIPZMuP1LeaIWTARIM=;
	b=oRUyGsqfO8oIu0XGd1vMKX/zDnb+h/rLJ2bnmz5ROXbpXWcqrk1YtqliVCg/prB5bSjhN+
	w9UrtORb08uds/G7Wk0VYMylP0zhakfDgUnt4d5VYs3HbRsKCYHo2q/BJCltTzf9lyK251
	VobCXnbIvW3KJuSDm0yEZWfPIvuFzRM=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] memcg: rename mem_cgroup_ino() to mem_cgroup_id()
Date: Thu, 25 Dec 2025 15:21:16 -0800
Message-ID: <20251225232116.294540-9-shakeel.butt@linux.dev>
In-Reply-To: <20251225232116.294540-1-shakeel.butt@linux.dev>
References: <20251225232116.294540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 96E9A4000D
X-Stat-Signature: 7gr4zxcf8kwd4mwhsybh7zijpngccsdg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766705008-24589
X-HE-Meta: U2FsdGVkX183eIPGGCZ7bW4OrCP5+WyKcKc5K5XIvwDY96hc5ZN51kf/AZbV7idIZ3qbIm6SYl5Z52pagu9YboUpBXCXHBhwT164lqT2hA9K0Wb6fpQDqPpeXiS1G3TwZAJDCJ6jxoen7R7QgljFp3ybarv+HQ0i2L0DVIUj44LBRelKW48GtQBkbz4E6YyN6cW80i6BubB4NMbJlQ+D0eTwIWvfaalBr7sjdPPDb0o8VFrlB4fMuBUjq8zlXsOp9d5vFkssoFjMY0/e+41TIquhEfAx2Kni2Pl6CNPpRXH4qSpY/UtTT3k+sTNmcB3teWF+V2oaTJNa8symE5Awa4p8w76TPwS8CJe8KyprrXbOnSI1yOL23r0EzsFy34NijO2ba2MHj9mJuBnTr2/6xcFK8WnXoMjbXSmyguiRFP/4jRfBJEJ1MJpuDKOPs2NUkh6sIojni42xmMX6LbO2B/M+EoA0E8hHKydUgRwOmG2fWzuXg2pt1hG3TQaSxxufabIk/uoGmjMYgEJlOtBZstTKjXTNhT/3dHjVyY0PYtiKFUKuuxM2N2JY3yr38lH7W75+Ioe8Hos5Djdeug0OmSEJk/lyeAq2BFdak4Dj06Pcw9CTM0QpwIpkIf6vkXPzZoiB+McIQUiLkkPpEkVnSXxp8Lq+QkA5pn1np3K2KaWs6H06VYRr4YX6TIaKScTbRmL8ul/Xou/ZRsHTeU5ulB5Ys0V2QQTkgO3kXXboL+rx/7T5ZO/PV2Cg8b8XhiakQKx1FSa4xhsWCfY6X1OSFFR+sXdYA2fywvCw1Za4ExlxkEBeNBJyAdSXTOcZBTwzIjueKLMLX3Ps4h24r+ktKYn26vv0qX3OqCF7xdAUF7Cipdz9lc8fxQ5TrddXQF9QDLalBUmqpTsSL2ssZP2B+68DM+pzlMjuy9ECjRxwKVpvw1b1C/e9bvyiYoBHE0uXdAv9o6NXANFIMdVQInZ
 OXuTWaWg
 ULH9Hh05sVoAAHeXR5t/jQOt25A87rxFNrHFrM8fVRaCYb1fBrYN4BqYKHkYv7aFRHAvLZiXNPUypBv2FOjlHM6s0ZBUMNRRv8SAbvi2j2AsfrxkuZlsLpoKnBUSED+fEU0U9zrFKz4y4aHkQibYMV2hJe5jH6iBZhsrCJpnBpy49Kh1sD5rbOcGt9Kja1SUpTveFABWHj7wmyQEJzFcw8u7xex7KDB5Y6C550nYwy7MWQNZcPgoDW+Ik1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename mem_cgroup_ino() to mem_cgroup_id() and mem_cgroup_get_from_ino()
to mem_cgroup_get_from_id(). These functions now use cgroup IDs (from
cgroup_id()) rather than inode numbers, so the names should reflect that.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h |  8 ++++----
 mm/damon/core.c            |  2 +-
 mm/damon/ops-common.c      |  2 +-
 mm/damon/sysfs-schemes.c   |  2 +-
 mm/memcontrol.c            |  2 +-
 mm/shrinker_debug.c        | 10 +++++-----
 mm/vmscan.c                |  6 +++---
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 3e7d69020b39..5a1161cadb8d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -830,12 +830,12 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
-static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
 
-struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino);
+struct mem_cgroup *mem_cgroup_get_from_id(u64 ino);
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1288,12 +1288,12 @@ static inline struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return NULL;
 }
 
-static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	return 0;
 }
 
-static inline struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
+static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
 {
 	return NULL;
 }
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 23c44811ff7f..a2513db59aee 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2065,7 +2065,7 @@ static unsigned long damos_get_node_memcg_used_bp(
 	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
-	memcg = mem_cgroup_get_from_ino(goal->memcg_id);
+	memcg = mem_cgroup_get_from_id(goal->memcg_id);
 	if (!memcg) {
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 			return 0;
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index dd81db95f901..a218d9922234 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -274,7 +274,7 @@ bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio)
 		if (!memcg)
 			matched = false;
 		else
-			matched = filter->memcg_id == mem_cgroup_ino(memcg);
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
 	case DAMOS_FILTER_TYPE_YOUNG:
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 79aa917ab3c0..3beb4456aa51 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2511,7 +2511,7 @@ static int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
 		if (!mem_cgroup_online(memcg))
 			continue;
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
-			*id = mem_cgroup_ino(memcg);
+			*id = mem_cgroup_id(memcg);
 			found = true;
 			break;
 		}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ede39dde05df..5b2925a68832 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3615,7 +3615,7 @@ struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return xa_load(&mem_cgroup_private_ids, id);
 }
 
-struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
+struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index 7ef16a0b2959..affa64437302 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -70,7 +70,7 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
 					       memcg_aware ? memcg : NULL,
 					       count_per_node);
 		if (total) {
-			seq_printf(m, "%llu", mem_cgroup_ino(memcg));
+			seq_printf(m, "%llu", mem_cgroup_id(memcg));
 			for_each_node(nid)
 				seq_printf(m, " %lu", count_per_node[nid]);
 			seq_putc(m, '\n');
@@ -107,7 +107,7 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 {
 	struct shrinker *shrinker = file->private_data;
 	unsigned long nr_to_scan = 0, read_len;
-	u64 ino;
+	u64 id;
 	struct shrink_control sc = {
 		.gfp_mask = GFP_KERNEL,
 	};
@@ -120,7 +120,7 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 		return -EFAULT;
 	kbuf[read_len] = '\0';
 
-	if (sscanf(kbuf, "%llu %d %lu", &ino, &nid, &nr_to_scan) != 3)
+	if (sscanf(kbuf, "%llu %d %lu", &id, &nid, &nr_to_scan) != 3)
 		return -EINVAL;
 
 	if (nid < 0 || nid >= nr_node_ids)
@@ -130,7 +130,7 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 		return size;
 
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
-		memcg = mem_cgroup_get_from_ino(ino);
+		memcg = mem_cgroup_get_from_id(id);
 		if (!memcg)
 			return -ENOENT;
 
@@ -138,7 +138,7 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 			mem_cgroup_put(memcg);
 			return -ENOENT;
 		}
-	} else if (ino != 0) {
+	} else if (id != 0) {
 		return -EINVAL;
 	}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d78043c7e4af..9ad2c2f06bfa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5426,7 +5426,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 		if (memcg)
 			cgroup_path(memcg->css.cgroup, m->private, PATH_MAX);
 #endif
-		seq_printf(m, "memcg %llu %s\n", mem_cgroup_ino(memcg), path);
+		seq_printf(m, "memcg %llu %s\n", mem_cgroup_id(memcg), path);
 	}
 
 	seq_printf(m, " node %5d\n", nid);
@@ -5522,12 +5522,12 @@ static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
 		return -EINVAL;
 
 	if (!mem_cgroup_disabled()) {
-		memcg = mem_cgroup_get_from_ino(memcg_id);
+		memcg = mem_cgroup_get_from_id(memcg_id);
 		if (!memcg)
 			return -EINVAL;
 	}
 
-	if (memcg_id != mem_cgroup_ino(memcg))
+	if (memcg_id != mem_cgroup_id(memcg))
 		goto done;
 
 	sc->target_mem_cgroup = memcg;
-- 
2.47.3


