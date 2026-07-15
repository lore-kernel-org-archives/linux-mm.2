Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B922C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629516B009D; Wed, 15 Jul 2026 10:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601976B00A5; Wed, 15 Jul 2026 10:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53EF66B00A6; Wed, 15 Jul 2026 10:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9126B009D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:14:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12D11C0109
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:35:34 +0000 (UTC)
X-FDA: 84990654588.14.78D79AF
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9552040009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:35:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lWVjevAk;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784111732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0PjHU3TbDnfGWF+iD96TKWS2XZ53YHp9da69Ponf0rw=;
	b=Dlsd2e7zfmNIaVkd0vMI8OtKhHbOJZm/auuXM7S0tfGn5frcxCAXhoecS8cNb+949actOu
	G/5bHrE7jGGG/+rwbRosAnbOu//Jk5D44eEY8ELkhdYsAhwsT9YZ7KA+urfng7eCVsUEl6
	S0CU3x3xO1GJiFnxxNrAWzc98WYSCCk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lWVjevAk;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784111732;
	b=0EOTPWtMasNmHQoHyCt5flsXusZkFRy4z+2sh2MBDm+QnqA7DuoCzfMbR0vpkkoS/M8kuf
	yMxXVIUrZeIz2NnrIYWsRL7SILIOWj22d8RgFtOj3hwY0OAbsByJKrttjrY8baKRLk2/Uu
	rzpy0DLQLuuWCAS3kwgtMFaJUKdeI2Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784111726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0PjHU3TbDnfGWF+iD96TKWS2XZ53YHp9da69Ponf0rw=;
	b=lWVjevAkYZ064aFltJs8lMrrHhbvW3jfDDXTJNUk7br0vYrO703lDuTQkLrrB6DW2oxclA
	CDTz4ntBIHKH7+v1OXbDtlB7q9AuF4Y9XDGtBTQ8/JYqvFRDPp3/uFjWpytuv6YlkxJ9HI
	zsJlgnUW59RhgT+41ErbmMD+ZA0Uy4k=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@fromorbit.com,
	dgc@kernel.org,
	qi.zheng@linux.dev,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	cgroups@vger.kernel.org,
	clm@fb.com,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2] fs: push nr_cached_objects memcg gating into individual filesystems
Date: Wed, 15 Jul 2026 03:35:16 -0700
Message-ID: <20260715103516.2410175-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9552040009
X-Stat-Signature: raniyuuw7w5z88pgnpi958ry54i9hh7e
X-HE-Tag: 1784111730-476873
X-HE-Meta: U2FsdGVkX1/Plso3uakGmN6BG2VPU55di5bM1hrqTuloezD5HRsjh2BCOFMvlgzK46Loik5Pbql06j3aFwulVxMaJsa3kuuwtlGvA8NKDBDl2ymnH1W9On2eetrlJjac3Xrl7pO0G9+0KFL7juRz01S2LrEDNJKyjBpqjMdhX/fzjk1Eq9TLFrtGJSLih6+SiSyZCXgUvoSy6GX6Th4fM4R1jfsQz6ZlMeqYm7rBCHyBJSwXfcOotXl5cHyuV6UUo0jsZdQDvZxJgC65qqLCG5joqME8kEQ6Mm5Tyl4LaT3Fcauz6DLxXNpnd8PD48gXqitds0epsbTrYoWph7lR2H+VD9Vm/2gXNPIQGlceoSs4/OjVrFnxivjDRPm6vIAsOTxnTxQirDhrx5eYiFE41dG0TWjba+aOH10SinIT4JSprOwFRFiUpQx62F2s7gT17IILhTLzYmTB9z7svmDqgDVt34du/mril3k+LqNwqVkfv9IvfS9PvOQkLZbGzIj4hsgLQyOSKZRpNx+RlTFsszEOwwRVyZ5x5sDGMOzGtzOwSbri7h/5aPqLKdtCaiQZjvqcdlXEO5i/LSv+QcxD3UFxcuc8MLJxiRZafRZJzhkAUkUtS7SK5lTpCd1G9lD9xIKuOsW6sHuLguX6o0zD7ANFKzZQ8ZI1Y6ks3ITh43rhhbXI4XmyNOE7Wb3NMq9c1Fh8Zyo5MZMEIpWQj5Zm6+J+drE9W6aG7BtBE+eOfaQr+WeuA5DX1hnhqr+ad79e66T8Qd3fH7ETXKmfVIsaM1YkezF/MmMwSvfQA50UNPeuAB49z88ktb+At3PHcGaGbLuVj9BiTr2w2emNkeZwRTM3FKEkiLtkhfmkBQxPyK1BatlMRw7wi7ge0nOKcaO7K3FCjRfuWzcjyEhONt8VY3ruNRMhhYTyuvqILG4E+Cgz5qGhKc6L83J/zqAH994nOkcbDN16jbENXkQ8RjD
 oQ8eFTIg
 aiVYPAJYv0lKUGpCtN+dfYwuTUCoDYdIfOJ8MVhKg16u8cwBXoYzOjzfIlgI4yAS9a38uSMY2m49o+cB0X7i9Sl2renN9U77cEvCagZE+hRIXYepEj/xvbiQsRV9xxHvXQGMEfUBOb6P2IlOhbNgdLHleKby/l7RqR/wGL1culSegiuMbYC8XfkMkP/pt4SxvmxBhNmsfhkTlZK6rMFj1hiH06rm/m/iy1MMIMyjk3CYQs32hDZ9BlsmtTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
v1 -> v2:
- Do not gate xfs_fs_nr_cached_objects(); XFS's inode reclaim is
  intentionally driven from per-memcg contexts to free memcg-charged
  slab (Dave Chinner).
- Add mem_cgroup_shrink_is_root() helper in <linux/memcontrol.h> so the
  filesystem callbacks don't open-code "sc->memcg is NULL or root".
  (Dave Chinner)
- Add fixes tag (Dave Chinner)
---
 fs/btrfs/super.c           | 10 ++++++++++
 fs/super.c                 | 19 ++-----------------
 include/linux/memcontrol.h | 21 +++++++++++++++++++++
 mm/shmem.c                 | 10 ++++++++++
 4 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a7d804219bec..cc4537435399 100644
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
index d2d04a6f4f84..a8fd61136aaf 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -24,7 +24,6 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
-#include <linux/memcontrol.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/writeback.h>		/* for the emergency remount stuff */
@@ -170,19 +169,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
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
@@ -212,7 +198,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	if (!super_trylock_shared(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
+	if (sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
@@ -273,8 +259,7 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 		return 0;
 	smp_rmb();
 
-	if (sb->s_op && sb->s_op->nr_cached_objects &&
-	    super_fs_objects_eligible(sc))
+	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..5407e4200460 100644
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
index 5789a0f5a346..dc8cd4f563f4 100644
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
2.53.0-Meta


