Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14074C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9866B007B; Mon,  3 Aug 2026 09:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91666B00C9; Mon,  3 Aug 2026 09:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCEA46B00CA; Mon,  3 Aug 2026 09:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB5076B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:34:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A4F4140664
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:47:05 +0000 (UTC)
X-FDA: 85059328410.03.A984B23
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F9F4A000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:47:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rdIF/+cI";
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785746823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+pKwPDWRPjJewglgrqfaa4UpZIwUSVvaCrT3G7tc/w=;
	b=T8bplcq0ltkllo91LDBmY28ze57aTawq26uScWRYS9Yp0ZcJkKY+sy/VrW/yfUhkcR24lq
	Yi4CX1h4eIYwPD1A12F380rtE760GpIafJtPkjaRJExCTw3Bapxo2iyrivZoLGBOzGky7i
	HrzvQd95SNi8FpWy7eC181jGNLKkE3A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rdIF/+cI";
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785746824;
	b=PBlEon5J48jD4nXXl93UJgjE+wjmf3wvbTvtWm7YaofriIsT3Yi3yigQzRF+591opETGe0
	00k9aZlwnQ+PUTTX/PPC5S6MN0rIlRSwSeHm5Jf/pBTU6aCSBGTlXY+QIm+J5JWgB7xgTC
	gsxXkTZH0GSSleawwDGRqATDRATO7fo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785746819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K+pKwPDWRPjJewglgrqfaa4UpZIwUSVvaCrT3G7tc/w=;
	b=rdIF/+cIxmBJbdzNyCffyhenN1Ho7gnjwe/UlnaI4xdthQjf8eM+S+ngWZwSjKR8sDxDKk
	goursia3CDKW7i6ZsNtX8Tw1D9RCv+o0AnSBsA6uxX4I9/ghJPddVeR0TFcUg6kSJQky6q
	XRukTscTuGUQn5XkHhMfz3Mhb3AUdPE=
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 1/3] fs: fix missed removal of super_fs_objects_eligible()
Date: Mon,  3 Aug 2026 16:46:33 +0800
Message-ID: <139ec7ff190eeddc52f40e215ca5c950af5d087d.1785746588.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1785746588.git.zhengqi.arch@bytedance.com>
References: <cover.1785746588.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3F9F4A000F
X-Rspam-User: 
X-Stat-Signature: yfmkpmj61dqauwn7fd39jxr636dc94e4
X-Rspamd-Server: rspam04
X-HE-Tag: 1785746822-382863
X-HE-Meta: U2FsdGVkX1/cjX3dYln1Q+uJmroA9M8KCcgLIoDyldXynpQ5WBWtOQa9bdmZhwyezW1kAzyvJPdX09bwyIsCjvJL74b4juX6Id3PU3N4ozG2jQFUhSbT1Br+loq7j4kTSQnWX/g1bCg0xD+aWV5Wvm63JI9ibyMLuk27RNlgY6RZKAoa6SiQKfBeeQrK5chPBLfCVJUmNWPA9hGle9Ktknsvh47Q2IaAuXCKHYjr7msb2EbIyA7qJ8CIdUbP/UU/iVmIvANgJphOAI76J9727yKZ0tlh8NRRQEq3rYXWUWoDy2xZemhzqpSi4kIOPG1n5FF9X6nwOxIxp2Mp9Pfuphurj/TwywiGUVaOQRUuVGtU7no1UZnh8CaK36mYsNz9s6GzDM0RvZGqtUy/0cfdPNXn0QDPjmrRVlZjtAVTaIsmLIkn7uHQvmousUpyvXX1E0H/h3E3zWwF7572SO8KRZFq6HjK5Lxyy+jaidA6TijPmBtpU9F+ZNjZfG56ojh96psNruuFYF1gJASJfseTorQiki1+0UwNoUunt5F7MwBhRzv0Df2DzSAz0DptBM6Q8PzKI7siKQldCNyCd4Vs8BZQ4NNkjD+JrE4iW35MBfPPajq6gAawirZVhIUSyWbyqa5sIS/2zfdPLD2C7sPjR7eJIj/9qSczmCjiCV42EHi9o1NU8IP0S7s1XAt4/C3ZciM/uYLYlza4DgLnEgOYZk1cmJ75XW0hE7gpxOdzvm6Za5SfkT3dwG1TFXHvzGJX4Z+BuPLYkk0ElOvVqctj05YNswiobuBEiV/isDaygaWgCURutOE7J/NU5HxUUROrfQEgCl+sb1hYlus43dexGFLNMrTll5854ILExapgEkJ4sDSnW1wfZY28UVWn3j7nQf0Od5NmezSHGLSMquEcqucWytLvRVi5aSZRg5c8QpVC+cQTJoZ15I3N/71kXdHcmdD9ThPISvSS6Jhfev/
 y7nLkdrQ
 4NwCKz76yqy+rJMCWgJqo5fh1bM2YrraEdIBhKvHFBGmcTukD6rAxh/un9T+9ndcZRMxfn042pbgqEM1o83KnyAvq4srOZg8EiLKrwoIK0blQZPUKymuQXGtcqQzsWphA1CYvrI/LoxGoGzIRO/CvE2Ri3n7Kjdr6oXTfhFTfwebgjaOYSV35CLyg+fmXj9/mecZC8Etx7M2Ss/q9o7e4EF7Ixjqm1Ge2WtFSxWYHROi3pWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
individual filesystems") forgot to drop the super_fs_objects_eligible(),
just fix it.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/super.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 5feecf5d9038d..36b249f002a9a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -171,19 +171,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
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
@@ -213,7 +200,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	if (!super_trylock_shared(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
+	if (sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
@@ -274,8 +261,7 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 		return 0;
 	smp_rmb();
 
-	if (sb->s_op && sb->s_op->nr_cached_objects &&
-	    super_fs_objects_eligible(sc))
+	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
-- 
2.54.0


