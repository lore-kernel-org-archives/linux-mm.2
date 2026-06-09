Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D251CD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9C86B0005; Tue,  9 Jun 2026 08:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98B156B0088; Tue,  9 Jun 2026 08:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0866B008A; Tue,  9 Jun 2026 08:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79F2F6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:31:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E8A2C1CE0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:31:00 +0000 (UTC)
X-FDA: 84860308680.19.8197130
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id DBD2A2000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:30:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xL6tUdLv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781008258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gSmhLbRZiCMLmvUSNQ09XQZBUjKHV+qKidrVgGQPtjM=;
	b=nZuMEkCyEEZ0XfVdoAV7zkb6fwAe+2dHYemvbNJjK9KgPvyHrnQrkop7hJxgWmLg49HBa8
	BSq7c+sW+pCfKA2r9ryJf1UxwJ7njrLtEdkszxrFsHTpFPC9hUmq39BrZWeq0VPQj9wKmQ
	Tz8aIfYQ9iVbaJV5Iqrlima2w6xQiRQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xL6tUdLv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781008258;
	b=R1uP2yiR1/03D37Z3h7tPQSGf1mbUFNLaXiO2tAimZiuAd17Zt6nwJLQvDqK2ujmo07gMA
	MibZKkm+gHTCdaZxe73OO4O67FNGxS5TWO9ZgwQRu5tT3cj4FEx9fZKxJQsU+v0F1Mtsxp
	sG5GKWL3EeWPs2+U818zRw2dSDEyxig=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781008254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gSmhLbRZiCMLmvUSNQ09XQZBUjKHV+qKidrVgGQPtjM=;
	b=xL6tUdLvO6wGf/3x5Mz4uaE7Lf7/4EskVXo/P2dSlSfwoRuhGCMkji/5Y2L2/fQPurQWhF
	vjGt7pbV7bzOhX82Yj03E58N+R5IWqGcIM0UJL7FGy6s1Jb4gIrp6RYHf7nIsd3i19HxhV
	mjaJZlEr5mJaXetgmCzeJfrWRziwUbE=
From: Usama Arif <usama.arif@linux.dev>
To: brauner@kernel.org,
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
Subject: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink
Date: Tue,  9 Jun 2026 05:30:47 -0700
Message-ID: <20260609123047.1948242-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: kwxknakfpaw55hrua1c74z6obmyhq6w1
X-Rspamd-Queue-Id: DBD2A2000F
X-HE-Tag: 1781008256-275919
X-HE-Meta: U2FsdGVkX19sZC0hf8exsYPbc89O9O9SD1XuCUH0iz9LARXWCnoJKyR2j241DJR1tunbjF+EiFLx/97syoV+6JHNvMshNk3Ui9oBP4JkpwOIdehUHR8YCAlQOB18zIjGjd+3sOaTKesy+pO1IKO7yM792JyenaY3UNeQtwIfGRCr64wQSXf0FWvAoyVt5k9ZeHd0zj3efH0YPFTUnU/PhRaoQpDXwP5/YGDxqU1tE+QAddahKfYZqkOd8ihNztSpu6KfvinZXq2f0CDWAyclOtxIwMDIWQV+D7FtoVCgB/b7lR6KzaBsJMrKlEt4cKGn0Ldg+1whjLV9Jh6KJRiHN54wyc0tmQS+K49DKq4KBc3/lhJHhVvBO1n8avMTfAjSFKSJJYumDrXFEnQkKzfjnBsd+gnE+PP/puajDt1C2TWjkjmF3NYQyfrfIKU1JtjhZwZj0RKbVFYqwyau8cr4ItoXaysDMnHHe50ZSxH4zLxB/W/Ed1Ld2CGWclHb/mqsBCftJF7uovQBJk77rQcf7wW2/NuOBdSf6WVHREOqhDarsul+0VoHlERqtUXYJ6zczkL1wFaGU1hX0A3LaAccB8tqJB9n/X+XlVjSYF5gWexhAxvLQ5f0kQCK6dThNhQ0ryOWCoZ/qQNOBlJ9rXeS/HXRNN//70jV2D891JJAForvtrG01KdiGrFZhDyFjgPu5BNd/t3rCYEfje49vCiHGyFzTV7N4uxcEtpgCgLikVtaWGxV0tL9GpwJH/6pl+E4sMMpww99P4rS9123RoaanC/Xu5T1jzwtd3jkAGBMvt9OnJ/qBZHSenMehXdF8m9Q/f0lCth+121K21RqAC2T7QIsn3ol8F8o1BOivHDPykd0jFRcCRU1b2oxylUEfUnfHJtIf/AeS6td6rfBKARZeVwIosuT4G0nRxeCv9/gpS7HcTlid9eXJJMSnla+ejl/eiAaxNIVsLKqrMmwfKH
 +YQ8UG5i
 I72/56nf7A9G7mlh12+tTTzCHQLpI0yycePpo2RjR0CDfBMpCLZTGcYIDkxNyDPOXW/p/8UGs/aHGcnE9wyRCIxenJHnZ7aMqmcE4+0jeHfy3hHht1drrqYP2fqOlga3xI8IcQpWnvjaWCNVntauT8WTyzPAcKuWcnJBDQhnInR5ljC2uTbHa8y0CIbbpaG2DRPsgDfjD0c4bx4+Rx/r2dJJtAOu4Bmd+d1uYjXTtwVyu8tvLAhTkXHuvfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
dentry and inode LRUs are memcg-aware (via list_lru). But the optional
->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
btrfs extent maps and xfs inode reclaim operate on filesystem-global
state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
None of them filter by sc->memcg.

The mismatch shows up under memcg-heavy slab reclaim. shrink_slab_memcg()
calls do_shrink_slab() once per (memcg, NUMA node) pair for every memcg
whose bit is set in the per-superblock shrinker bitmap, which on a busy
host means hundreds of calls per reclaim pass. Each scan queues the same
global shrinker work item that's already kicked from the root path.

Because btrfs/xfs global count is typically non-zero on any in-use filesystem,
the returned total stays positive even if a memcg's own dentry/inode LRUs
are empty. shrink_slab_memcg() therefore never clears the SB shrinker bit
in the memcg bitmap, so subsequent reclaim passes from the same memcg
re-enter super_cache_count() and pay for the global counter walk again.

Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
or root). The memcg-aware dentry/inode LRUs keep being counted and
scanned per memcg as before; only the global fs-specific hooks are skipped.
The root/global shrink path still drives those hooks; only their
invocation from non-root memcg slab reclaim is removed.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/super.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 378e81efe643..5216c5dbd4c4 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/memcontrol.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/writeback.h>		/* for the emergency remount stuff */
@@ -169,6 +170,19 @@ static void super_wake(struct super_block *sb, unsigned int flag)
 	wake_up_var(&sb->s_flags);
 }
 
+/*
+ * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
+ * operate on filesystem-global state and ignore sc->memcg. Driving them
+ * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
+ * per-cpu counters and queueing duplicate work: the actual reclaim happens on
+ * the global path (kswapd or root direct reclaim) regardless. Restrict them
+ * to that path.
+ */
+static inline bool super_fs_objects_eligible(struct shrink_control *sc)
+{
+	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
+}
+
 /*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
@@ -198,7 +212,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	if (!super_trylock_shared(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects)
+	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
@@ -259,7 +273,8 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 		return 0;
 	smp_rmb();
 
-	if (sb->s_op && sb->s_op->nr_cached_objects)
+	if (sb->s_op && sb->s_op->nr_cached_objects &&
+	    super_fs_objects_eligible(sc))
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
-- 
2.52.0


