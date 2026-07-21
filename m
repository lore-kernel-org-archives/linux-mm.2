Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F74C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B942C6B00AF; Tue, 21 Jul 2026 04:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B456E6B00B1; Tue, 21 Jul 2026 04:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B4F6B00B0; Tue, 21 Jul 2026 04:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0836B00AE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:34:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2D4F14036B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:34:45 +0000 (UTC)
X-FDA: 85012122930.18.3E40EB4
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id A9AB9140005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:34:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LilJ1sp1;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784622884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCj7XSmsxBjrVxiF7/9uQ7nx+3RtZpYl5ddOsQ/0xcI=;
	b=0tqosNz9N7ijhSvbB6n+kH/6Vq+OwYU/BBA+aC0OOHsoiVVoSwCvupKs9+3f+5foIBfL9M
	1MUPB49wEn5CyAWv4pqGPGTWdIc7kxtnllWDm7ty1fU6UiI7DOQ+VyHvGHwPQVFCeGJY+e
	WPpQQaNXPGCWY3AW2Yvl5R+rzhdahTA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LilJ1sp1;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784622884;
	b=WNyGfz7P398p7a4ZkH86ffTUrdvVFGB25MRlDxwUoN4ah+rDbgHIWaDytiqBdCXq2EuRAQ
	k0q8rZwRSlbMP0oLHdxz7XwtS2G90X26ZXZrDgceL4bA6YlhZBQCF8TuENfzbb2o+yRlfD
	N7WPf3m4GDf3rj/dHsBj1FNo0plO0kc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784622882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aCj7XSmsxBjrVxiF7/9uQ7nx+3RtZpYl5ddOsQ/0xcI=;
	b=LilJ1sp17Jtz/hU6iDMqSjxaljIKFBII1v07xnfTM3sCVCniZElZbmLPq0Nj3SXT9rViVa
	svo2uYHG1TUR90UlRbkzozoR7hETPeoGSOjJXIfy1/lmrJNweaBzIiTH9n2StnipLtdgQN
	Kg686tJql/Xltn7PWFtZaduX/PgFrk4=
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	usama.arif@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <qi.zheng@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 1/2] fs: push nr_cached_objects memcg gating into individual filesystems
Date: Tue, 21 Jul 2026 16:34:11 +0800
Message-ID: <637bea7714269d381dc811ef9293f9a3264a822d.1784621804.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1784621804.git.zhengqi.arch@bytedance.com>
References: <cover.1784621804.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A9AB9140005
X-Rspam-User: 
X-Stat-Signature: 3ndwk4hd5yrqiknwbs35q3to1ebhjmw1
X-Rspamd-Server: rspam04
X-HE-Tag: 1784622883-876876
X-HE-Meta: U2FsdGVkX18VPu9hqRXUYoEap6gpAjb389tirYYO55FJ0eVd0ZX91Z60kg0KQtWyYOoQsSiKRrn3GsXYfhBEtRGEMstOeYI1RzZ0MU6yPbmat57xT6v7EkxHMylWaPm98E+0pKSRO10NrK+scL6O8+hsXQY8rJsAsKnInSSxwCj5c2X0pKETw+xXOuHcRrPB4HGhBfBpFN4AGJd/sjgVES82ejWaq6bpw5YNTYs++lJKAD3q53C6hGmsQrFs6w6/pGstyI5Ny0hp0kYO3GSHO0r16HvHrTZdfN31Ka5i+dm927G840HIClfrDelX+HkSf2zT1v0iNcN6EJOa6G+zIj1dyfUOQsPyfmBJQsdeQTk+GIj09W+IcINwi3wNAW8Jbiw2SEgoxd1EiJj9bP8NNJDhOPyWVVrH1efXDTZFPsoYemBUW80YNKuhi8IgIFCfb9GYpTsHO1sVQUYSxwnsSAeLsv9x30Azgm/RDfL4Md+wd36z0MVKEV9McQH111oEpbP4Pfb8qOly5nSX6x1BDkuI2XN8YjDg3S804cG/g4FJTEnd23IOyBcFCva1OjCVAi4cWrtxKQ6o6qX7znNucBYg4e8gSiIFzavbaqnomWjM5odB+wo18pmioBy7LDdWOXwJX12z2kBN/AmFoaoOWm8/GeGOXk3ngcM7xwrYCjsxjIqTkGhLCeynhgVctWgLbrT4T+PHW/d2D5fBuwVVf6SYf//xuri/y95/ZNgzskatYqVd9uYBKeem8mD9mR0Kw+o+prqie9splzqkvIbfow1mldk9bnan+44GR5Om+eTUKOP5njKkwfkbzgjJzhw3LKyrCr3/70IUkUWKbQvhzuNJ98G5MuTU4tbGAJ/jAkDkUaMbmhte4FeUKjGlTjkbuzZt0oHaue1kdhOFiG33upPkaeiGiNupaMh88dKdD503w8gESiKgZpJIIQaeSGdJznXmljcw+xeXA5YwhNF
 J+rABHTf
 cCW2R/op5oUgbGZsm0NwGIQIsH896is3UnbNXbtqVoI6M6yzB3XIKQ/4vVBNbIEPR+R3oh1bfR/y7/z1GkNzNIy18KiIkAroje+lV8iH3gLmQdr2RNe2cs6omQuB2UmBUKce8JEcdGmTB5kQFavNR9tx3tbbL/zwigmYgwQQj/iqsnvMbXKGmNNmpaZ49nimJyuV+zYzyqiBKjNScqxYHOp8e6WzilFVsKAFuOIiDaJKSLZ9reaOlp+PZ1R9T59zpfI3i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Usama Arif <usama.arif@linux.dev>

Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
in memcg slab shrink") added a check in fs/super.c that skipped every
->nr_cached_objects() hook whenever the shrinker was invoked for a
non-root memcg, on the assumption that none of them honour sc->memcg.

That assumption is wrong for XFS, whose inode-reclaim hook is
intentionally driven from per-memcg contexts to free memcg-charged
slab. Encoding a blanket "never memcg-aware" policy in fs/super.c
short-circuits that path.

Push the check down into the callbacks whose counters really are
irrelevant to per-memcg reclaim - btrfs_nr_cached_objects() and
shmem_unused_huge_count() - and drop the fs/super.c gate. Each
filesystem can now lift the restriction independently if its counter
later grows memcg awareness, without touching fs/super.c.

Introduce mem_cgroup_shrink_is_root() in <linux/memcontrol.h> so the
callbacks don't open-code "sc->memcg is NULL or root".

Fixes: 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink")
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/btrfs/super.c           | 10 ++++++++++
 fs/super.c                 | 19 ++-----------------
 include/linux/memcontrol.h | 21 +++++++++++++++++++++
 mm/shmem.c                 | 10 ++++++++++
 4 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a7d804219bec3..cc45374353997 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -22,6 +22,7 @@
 #include <linux/namei.h>
 #include <linux/miscdevice.h>
 #include <linux/magic.h>
+#include <linux/memcontrol.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 #include <linux/crc32c.h>
@@ -2434,6 +2435,15 @@ static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_contro
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
 
+	/*
+	 * The evictable extent map counter is filesystem-global and does not
+	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
+	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
+	 * shrink_slab_memcg() to avoid queueing duplicate global work.
+	 */
+	if (!mem_cgroup_shrink_is_root(sc))
+		return 0;
+
 	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
 
 	return nr;
diff --git a/fs/super.c b/fs/super.c
index 9f82e6b38f07e..93f24aea75c4d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -24,7 +24,6 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
-#include <linux/memcontrol.h>
 #include <linux/rhashtable.h>
 #include <linux/mount.h>
 #include <linux/security.h>
@@ -171,19 +170,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
 	wake_up_var(&sb->s_flags);
 }
 
-/*
- * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
- * operate on filesystem-global state and ignore sc->memcg. Driving them
- * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
- * per-cpu counters and queueing duplicate work: the actual reclaim happens on
- * the global path (kswapd or root direct reclaim) regardless. Restrict them
- * to that path.
- */
-static inline bool super_fs_objects_eligible(struct shrink_control *sc)
-{
-	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
-}
-
 /*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
@@ -213,7 +199,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	if (!super_trylock_shared(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
+	if (sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
@@ -274,8 +260,7 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 		return 0;
 	smp_rmb();
 
-	if (sb->s_op && sb->s_op->nr_cached_objects &&
-	    super_fs_objects_eligible(sc))
+	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9572606776781..8170bb8066a22 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -520,6 +520,22 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 	return (memcg == root_mem_cgroup);
 }
 
+/**
+ * mem_cgroup_shrink_is_root - is this a global or root-memcg shrink invocation?
+ * @sc: shrink_control describing the current shrinker call
+ *
+ * Returns true when @sc represents a global reclaim shrink (sc->memcg == NULL)
+ * or a root-memcg shrink, i.e. not a per-memcg iteration of
+ * shrink_slab_memcg(). Filesystems whose ->nr_cached_objects()/
+ * ->free_cached_objects() implementations operate on filesystem-global state
+ * and do not honour sc->memcg can use this to early-return 0 in per-memcg
+ * contexts.
+ */
+static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
+{
+	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
+}
+
 static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
 {
 	return objcg->is_root;
@@ -1071,6 +1087,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 	return true;
 }
 
+static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
+{
+	return true;
+}
+
 static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
 {
 	return true;
diff --git a/mm/shmem.c b/mm/shmem.c
index f189d1ac40db2..20c24d92da430 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -846,6 +846,16 @@ static long shmem_unused_huge_count(struct super_block *sb,
 		struct shrink_control *sc)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+
+	/*
+	 * The per-superblock shrinklist is filesystem-global and does not
+	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
+	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
+	 * shrink_slab_memcg() to avoid queueing duplicate global work.
+	 */
+	if (!mem_cgroup_shrink_is_root(sc))
+		return 0;
+
 	return READ_ONCE(sbinfo->shrinklist_len);
 }
 #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
-- 
2.54.0


