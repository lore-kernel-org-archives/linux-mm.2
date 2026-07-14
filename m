Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D8EC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EEB6B0092; Tue, 14 Jul 2026 06:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5714F6B0093; Tue, 14 Jul 2026 06:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4602C6B0095; Tue, 14 Jul 2026 06:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09D436B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:15:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 667ABA0331
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:15:09 +0000 (UTC)
X-FDA: 84986974338.14.F149F66
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF3DD12000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:15:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o7OshBKp;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784024107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=56WaBc6KXQyiipU+GOph11PsAxOVbA6Vo71DO1epUmU=;
	b=Tk6ciVpRyUu9YnNbalBsxGG2uAIE25v6lpzDqlb4PQ3lGq+osz6MBQwYgh4ZH227Z6q19g
	1WX8DttsP/Naptbfarq0JOAWKDKFNUcCI3amE51KLywOQsNQw+Jea9TZ7Jkba+qQaxB9k+
	6pMBuVDtemE0y7+6oJ0idsE21D86E4Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o7OshBKp;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784024107;
	b=vmaAGiD+VxltXswhrya6jHA/sPwTaHw288PNW8cl49RfbECSL0U4nErOuGG82Mg2951yW7
	104UOYqqBv/8e9mwFyaO8iHed5yA20sNMPK96TkC4s7WUO3X/8636VZyuOwBqdmnuFeuDr
	sC55aLPa3/DhGc8yc3Va32ozqBaO+wY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784024106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=56WaBc6KXQyiipU+GOph11PsAxOVbA6Vo71DO1epUmU=;
	b=o7OshBKpJ96UBIQa6AkejMkZQiPGv9LV20o8q96VoBIHxr5DI02vQGJoH6/Rms4+sbJWYo
	l3+EccFU9tEcAmYpRR7YTLNB6Bx69xoTQMKcDdqKvi2CC7Gh7W6W71zYW4zTaAVUEPL87x
	Adi41BX+7qZ8wEaW2Sx8IuXJzH1/fEM=
From: Usama Arif <usama.arif@linux.dev>
To: brauner@kernel.org,
	qi.zheng@linux.dev,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org
Cc: hughd@google.com,
	boris@bur.io,
	clm@fb.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	cem@kernel.org,
	linux-xfs@vger.kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] fs: push nr_cached_objects memcg gating into individual filesystems
Date: Tue, 14 Jul 2026 03:14:54 -0700
Message-ID: <20260714101454.1202449-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: m4s76c5d5na77m7ohgo7tn54eeopsy1o
X-Rspamd-Queue-Id: CF3DD12000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784024107-381279
X-HE-Meta: U2FsdGVkX19WhcTbgP1/IQuo4zpYSgGvD4LKKtuyOIX+qBuneHO8jsq7m3trT2O/BnF2TPjffk/rEpyG1w7KQFi2wR2yUnT0MFTb2kCWfdTr8rIhbqR5u3RMaW0M1Y1e4Caqq7IZCQAAoW4qEjBJtSxeb/z2ABhK7eub3jkyxg0JY7RYM20dZZrw1Vd3elREtaf/+VFOxTmm1KMkasrTkrIpjoHi1u1p5sU72UkKoT7c/VwgK0OO5SIWJFCNLri+4IzamU5yzuOngn3/azlJhPmVZYH0Q/ja2/jGP8nPrUIZbylCiJthdd8qFkgeOIoxqOe7LfvAqGp0Wt44l+S9VyozywOag0hit5PZmNRPV1VWIiehlAmksXLCSNdKUKb5eP7drZajUVgJIZ6q3MbYbPakCm9Sh3NFnAC99S7aQedHQUc+JViKEAQ23u1Kk59/IOSA4M+fcmOIULgI+ovjL3oQkAbMGbtezL6xkDvptOhg3uKm/b1f8CZLnYm/L02KoWkSV0tyf7hCfACfDLGNIQbvDjk4yeB6FFGD66sMdvrWU7vDD1qZXVxAmc6ADJH6o4XZdQwhnr+qet1TxIk1KB962CCehoiWRcLhjmqyXFW3+3n7wREN/MfZBuV2X3lBTWHBa9EXw+QHjVjMir05zY8EGXAOvvPQJf3Qu5bhOEkYZH2mNMKjKpiEFeVa/iUhBIu+JLTzh2fSKiDRAMrH5HdAcnsFII40FAcbl/ssG9QEzTk3F8odYBQTTiORI8jmJJYxXSp4WkLG7ZRUxpxkOw9gHd02n5aUA5R/odqKd14j74Hs4Lakw31kJa2dgcM2FYzuaDvB/ziR2fuEmqpvEqJuzCfLAos9Ye4zqYiWn9nL5fpGIixfB7I0yqGshRDcwvqM31FbZ24tkzXq/3dQAchRMshwsKB+0d9SAvB9HmUsi7kFtsrwSEqVH4LxDgjPvBoZOgX6WHPc+rxodV4
 6UOmWawP
 waL7BVPxORpGeKt9FIeXAHQ6z9enCM+jxjU0NU8Lhlp1taH3568iXZdWhl4vZjLPOmNW22phRWo5ji7mWGxo+vb2b6is7gmxGw9RzMk1hP8rQwqlcjns0cDMFJwDVqK4h7OLfo/i4UHveTo2UcV+RbMysrti9dgZpMi1NrZnl8ukJZz7a23SxWrjJQHgG6on1g+4hCw0SCCoImYgPjyoE8o/Htkws/KbWPHPXIVQB2A5m1CsiJYxY/4FR/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
in memcg slab shrink") added a check in fs/super.c that skips the
->nr_cached_objects() hook whenever the shrinker is invoked for a
non-root memcg, because none of the current implementations (btrfs,
xfs, shmem huge) honour sc->memcg.

That policy is really a filesystem-owned property: fs/super.c should
not encode the assumption that these hooks are never memcg-aware,
since a future implementation might legitimately filter by sc->memcg.
Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
and shmem_unused_huge_count() so each filesystem can lift the
restriction independently once its underlying counters/scans become
memcg-aware, without needing a coordinated change to fs/super.c.

Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()
still early-return 0 for non-root memcg contexts, keeping the shrinker
bit clearable in each memcg's bitmap; the global (kswapd or root
direct reclaim) path still drives them as before.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/btrfs/super.c   | 11 +++++++++++
 fs/super.c         | 19 ++-----------------
 fs/xfs/xfs_super.c | 12 ++++++++++++
 mm/shmem.c         | 11 +++++++++++
 4 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a7d804219bec..16c24bccc897 100644
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
@@ -2434,6 +2435,16 @@ static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_contro
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
 
+	/*
+	 * The evictable extent map counter is filesystem-global and does not
+	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
+	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
+	 * shrink_slab_memcg() to avoid queueing duplicate global work and
+	 * pinning the shrinker bit in every memcg's bitmap.
+	 */
+	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
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
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index eac7f9503805..f0d8251fad3b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -54,6 +54,7 @@
 #include "scrub/rcbag_btree.h"
 
 #include <linux/magic.h>
+#include <linux/memcontrol.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/fserror.h>
@@ -1242,6 +1243,17 @@ xfs_fs_nr_cached_objects(
 	/* Paranoia: catch incorrect calls during mount setup or teardown */
 	if (WARN_ON_ONCE(!sb->s_fs_info))
 		return 0;
+
+	/*
+	 * The reclaimable inode count is filesystem-global and does not honour
+	 * sc->memcg, so it is only meaningful on the global (kswapd or root
+	 * direct reclaim) shrink path. Skip the per-memcg iterations of
+	 * shrink_slab_memcg() to avoid queueing duplicate global work and
+	 * pinning the shrinker bit in every memcg's bitmap.
+	 */
+	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
+		return 0;
+
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 5789a0f5a346..3ba812e4f5ba 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -846,6 +846,17 @@ static long shmem_unused_huge_count(struct super_block *sb,
 		struct shrink_control *sc)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+
+	/*
+	 * The per-superblock shrinklist is filesystem-global and does not
+	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
+	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
+	 * shrink_slab_memcg() to avoid queueing duplicate global work and
+	 * pinning the shrinker bit in every memcg's bitmap.
+	 */
+	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
+		return 0;
+
 	return READ_ONCE(sbinfo->shrinklist_len);
 }
 #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
-- 
2.53.0-Meta


