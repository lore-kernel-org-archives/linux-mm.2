Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A55C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081006B0917; Mon, 17 Aug 2026 05:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031926B0919; Mon, 17 Aug 2026 05:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63126B091B; Mon, 17 Aug 2026 05:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0B9D6B0917
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:04:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 549131C1A7F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:04:24 +0000 (UTC)
X-FDA: 85110175248.25.A617912
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4E5B640006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:04:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a+rvmxUb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786957461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dul+5OQpYY2h3M7rDg82QHrDhMrmv2usqDmjLVGh98=;
	b=gzwbkCM1aACcTYFgqyijcIQtIxlBt4U+GtrVS1IX20A3CJdzbdCcoL9FjIN3GmDCmJff++
	q+Lx0yJALR4xyyx1SRL0ijDFYstHGNlKTkeVqcKWCdqadLttnDfbfl7XBLxqm1PZkilK/e
	cL12CEVV0oO3TTdZZNtd/hz6zjV2iv0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a+rvmxUb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786957461;
	b=gsL6JmFXKzcD6Im5DgQihTXeBjZ2ky7RoDo0aFLzLQg8kd4en7dc/ZJdOGSvNv+0b0JTX8
	vXodUi2YVH/CHUFWDgv43KPfkd47xjPYvMCUwOd9TPDcMN6PHaR6HT1GAmHBP5IQB670l3
	u9BapRgw5GbT76pY3Ti05jqBDkxoNQc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ea5Yqr6I+deIe5xymxuyDwuxLGjUOxpr3WkREZqF68g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786957460; v=1; x=1787562260;
 b=a+rvmxUbsr0mW1sB7zqO4KXGq7YDgY9SPhj32vIDOoYhE/5gLzH05xgjxp7ZGqGRdfpTn1KZ
 h4WywfwO3TV1EX/v2rF+2bhIAcFa3vyMGfkcaNXsTHdwr7LVb7YWx69X+VsgMmiAF4bLg6WHq97
 LHSWFCy0NERh1D2Ml91GaM40=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (221.194.171.228)
	by smtp.migadu.com with ESMTPS id 22212118ec296bab;
	Mon, 17 Aug 2026 09:04:20 +0000
X-Migadu-Flow: FLOW_OUT
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
Subject: [PATCH v4 4/4] mm: shmem: make unused huge shrinker memcg aware
Date: Mon, 17 Aug 2026 17:03:28 +0800
Message-ID: <94cc7fe1fd645254ae90effc1c0687678438d940.1786955972.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1786955972.git.zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E5B640006
X-Rspamd-Server: rspam07
X-Stat-Signature: znc8s7a4rzs5jtc1yc8rd3zpwn164s1x
X-HE-Tag: 1786957461-30822
X-HE-Meta: U2FsdGVkX18XrqExLlX2OpjMqOHzyXmKNuxXCmNu5iiEUwUkzeRfOuyikGe3bPjTYN849u6sKdTnG8WR2gt7nW3xG+P2OVgviU+fFY33FMEbIKzZ9z/xOI3q9Tj0F8NzksmSLpW+S9Kg6qsRewaRHb54/TNF/9x5mGnG1wKAAuWhAzuL0lEFnsbIWBdNKrKH4arblcSz2k6pCBPBMLxD/unWol0qfVjem2yBv+qVDSAVaNJOoAwQGePYfPPpJjNY62w5VPMd/pdA90+rK6/5DM+tM4HG0cvprw3vQPNIuO2OYDdf3c4xXRUrFtx+fTHmKp/vHjj7sVmkdkleBPtXGdUrbLKVhZ254zbAn2/rpl4M7OBRECdQsuZT14oCULvPAsnx89jfFwhyyq7NFoTNINQiCCmOz1IXE3IO/2TovlXdNXUMK8hMWCtxX4f2xSzJQNzuKGkcF5jsBBOQJ52mf+nxJgFd27/iylnmMjGKhhiZAXDJaiK/H68OZghPl3DfhwgZLepa1kADMmnBJ9nlMS4p4se9nGF3Iy34BcRro0p9sBC43vPysDfCnF7BEYmJwNIrSmU2rGhFjnSryQxwfWmf9vW+1OUsYsygUm+O3xflxUK1knmzI2IU0o0Dh/4V9eDSjEBqISU3wJqySHMH12f02LhrSoQnodUT+XpXZ8z2p+ug5CJ1YmJCUY6hW3JjHtXwKnLuRau63vjbA0jlEJs+kCuo2nGAa2IShG3QABNuNsuB1jzWu9OdQiU7QtH6K5OSvMCD7ADb/cC6VpvdyvenuqK02b6w29C/NDJV07g5gpwu+EwSmnkVS2MG0rqYBkVF/jqly/nVSTdHE9o7VgFeOANvEmLo0ttvwDKX3xFW8XZceWYiHTODGbFVqwhnb7y31/P/piDh2iq8fxnRP9J/m1b1pzBC4v0VTBJAV/A/lD+DHDeWNkNGN+SZBC1d4zygNAQaHzNDoWvbyux
 aFQo66vt
 ld18AfSM/n4gQUak5NCSPfoDE/JOLDz10A4vpgVkcjBr6waa47SKPZi3EIphOwnoAGjonGS+WQxK7Gn/G7CNR2iyPaAyUoZ9p0sWezhgxO6HhJ4igj+Q50hn20eDFxQcCi/WCkgI9fZvXMUzzJfR6P3WrSbBdRXZnJ1e/nXn3ccaSxbXzugBXbw6al83rTeEV9mJc5oSncMRrFyEIp0bjfvLgaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The shmem unused huge shrinker keeps a per-superblock list of inodes whose
tail huge folio extends beyond i_size. Since that list is not memcg aware,
reclaim triggered by one memcg can scan inodes from the whole superblock
and split shmem huge folios charged to unrelated memcgs.

Convert the shrink list to a memcg-aware list_lru. Queue each inode on the
list_lru sublist matching the memcg and node of the current tail huge
folio, so non-root memcg reclaim only walks candidates charged to the
reclaiming memcg. Global reclaim, root memcg reclaim and shmem quota
reclaim keep global semantics.

Rather than pinning a struct mem_cgroup reference in shmem_inode_info,
store a struct obj_cgroup reference instead.  The list_lru add and delete
paths resolve the current memcg from the objcg under RCU, so that memcg
offline and list_lru entry migration remain consistent: list_lru migrates
entries to the parent memcg sublist on offline, and obj_cgroup_memcg()
follows the same reparenting, ensuring the correct sublist is always found
at delete time.  This avoids pinning a dying memcg through a long-lived
CSS reference.

The list_lru still tracks inodes while the actual split target is the
current tail huge folio, so validate the folio memcg/node during scan. If
the folio no longer matches the reclaim context or splitting cannot
proceed, requeue the inode according to the current tail folio; if the
inode is no longer shrinkable, drop the scan entry.

This can be tested with the shrinker debugfs interface by allocating 32
tmpfs tail THPs in each of two memcgs, then scanning the sb-tmpfs shrinker
with memcg A's cgroup id:

               before A scan    after A scan
  base         A=64M, B=64M     A=64M, B=64M (per-memcg count is skipped)
  patched      A=64M, B=64M     A=0,   B=64M

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/shmem_fs.h |  12 +-
 mm/shmem.c               | 362 ++++++++++++++++++++++++++++++---------
 2 files changed, 289 insertions(+), 85 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 5663dff53186e..a7c7a96a7cbf9 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -11,6 +11,7 @@
 #include <linux/fs_parser.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/bits.h>
+#include <linux/list_lru.h>
 
 /* inode in-kernel data */
 
@@ -54,6 +55,11 @@ struct shmem_inode_info {
 	struct dquot __rcu	*i_dquot[MAXQUOTAS];
 #endif
 	struct inode		vfs_inode;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	struct obj_cgroup	*shrinklist_objcg;
+	int			shrinklist_nid;
+#endif
 };
 
 #define SHMEM_FL_USER_VISIBLE		(FS_FL_USER_VISIBLE | FS_CASEFOLD_FL)
@@ -83,9 +89,9 @@ struct shmem_sb_info {
 	ino_t next_ino;		    /* The next per-sb inode number to use */
 	ino_t __percpu *ino_batch;  /* The next per-cpu inode number to use */
 	struct mempolicy *mpol;     /* default memory policy for mappings */
-	spinlock_t shrinklist_lock;   /* Protects shrinklist */
-	struct list_head shrinklist;  /* List of shinkable inodes */
-	unsigned long shrinklist_len; /* Length of shrinklist */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	struct list_lru shrinklist; /* List of shrinkable inodes */
+#endif
 	struct shmem_quota_limits qlimits; /* Default quota limits */
 	struct simple_xattr_cache xa_cache;
 };
diff --git a/mm/shmem.c b/mm/shmem.c
index 81eff314cfab8..bd5b53ee3a189 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -725,51 +725,258 @@ static const char *shmem_format_huge(int huge)
 }
 #endif
 
-static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
-		struct shrink_control *sc, unsigned long nr_to_free)
+static bool is_shmem_unused_huge_isolated(struct shmem_inode_info *info)
 {
-	LIST_HEAD(list), *pos, *next;
-	struct inode *inode;
+
+	return info->shrinklist_nid == -1;
+}
+
+static void set_shmem_unused_huge_isolated(struct shmem_inode_info *info)
+{
+	info->shrinklist_nid = -1;
+}
+
+static struct obj_cgroup *shmem_get_and_clear_objcg(struct shmem_inode_info *info)
+{
+	struct obj_cgroup *objcg = info->shrinklist_objcg;
+
+	info->shrinklist_objcg = NULL;
+
+	return objcg;
+}
+
+#ifdef CONFIG_MEMCG
+static struct obj_cgroup *
+shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct folio *folio,
+			    gfp_t gfp)
+{
+	int ret;
+
+	ret = folio_memcg_list_lru_alloc(folio, &sbinfo->shrinklist, gfp);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return get_obj_cgroup_from_folio(folio);
+}
+#else
+static struct obj_cgroup *
+shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct folio *folio,
+			    gfp_t gfp)
+{
+	return NULL;
+}
+#endif
+
+static void shmem_unused_huge_lru_add(struct shmem_sb_info *sbinfo,
+				      struct list_head *item, int nid,
+				      struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	list_lru_add(&sbinfo->shrinklist, item, nid, memcg);
+	rcu_read_unlock();
+}
+
+static void shmem_unused_huge_lru_del(struct shmem_sb_info *sbinfo,
+				      struct list_head *item, int nid,
+				      struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	list_lru_del(&sbinfo->shrinklist, item, nid, memcg);
+	rcu_read_unlock();
+}
+
+static void shmem_unused_huge_add(struct inode *inode, struct folio *folio,
+				  gfp_t gfp)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	int nid = folio_nid(folio);
+	struct obj_cgroup *objcg = NULL, *old_objcg = NULL;
+
+	objcg = shmem_unused_huge_alloc_lru(sbinfo, folio, gfp);
+	if (IS_ERR(objcg))
+		return;
+
+	spin_lock(&info->lock);
+	if (!list_empty(&info->shrinklist)) {
+		/* isolated on scan list, let shrink handle it */
+		if (is_shmem_unused_huge_isolated(info))
+			goto unlock;
+
+		if (info->shrinklist_nid == nid &&
+		    info->shrinklist_objcg == objcg)
+			goto unlock;
+
+		shmem_unused_huge_lru_del(sbinfo, &info->shrinklist,
+					  info->shrinklist_nid,
+					  info->shrinklist_objcg);
+		old_objcg = shmem_get_and_clear_objcg(info);
+	}
+
+	info->shrinklist_objcg = objcg;
+	info->shrinklist_nid = nid;
+	shmem_unused_huge_lru_add(sbinfo, &info->shrinklist, nid, objcg);
+	objcg = NULL;
+unlock:
+	spin_unlock(&info->lock);
+	obj_cgroup_put(old_objcg);
+	obj_cgroup_put(objcg);
+}
+
+static void shmem_unused_huge_del(struct inode *inode)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	struct obj_cgroup *objcg = NULL;
+
+	spin_lock(&info->lock);
+	if (!list_empty(&info->shrinklist)) {
+		shmem_unused_huge_lru_del(sbinfo, &info->shrinklist,
+					  info->shrinklist_nid,
+					  info->shrinklist_objcg);
+		objcg = shmem_get_and_clear_objcg(info);
+	}
+	spin_unlock(&info->lock);
+
+	obj_cgroup_put(objcg);
+}
+
+struct shmem_unused_huge_scan {
+	struct list_head list;
+	struct shrink_control *sc;
+};
+
+static enum lru_status shmem_unused_huge_isolate(struct list_head *item,
+						 struct list_lru_one *lru,
+						 void *arg)
+{
+	struct shmem_unused_huge_scan *scan = arg;
 	struct shmem_inode_info *info;
-	struct folio *folio;
-	unsigned long batch = sc ? sc->nr_to_scan : 128;
-	unsigned long split = 0, freed = 0;
+	struct inode *inode;
+	struct obj_cgroup *objcg = NULL;
 
-	if (list_empty(&sbinfo->shrinklist))
-		return SHRINK_STOP;
+	info = list_entry(item, struct shmem_inode_info, shrinklist);
 
-	spin_lock(&sbinfo->shrinklist_lock);
-	list_for_each_safe(pos, next, &sbinfo->shrinklist) {
-		info = list_entry(pos, struct shmem_inode_info, shrinklist);
+	/*
+	 * Use trylock to avoid ABBA deadlock: add/del path takes info->lock
+	 * before the list_lru bucket lock, while here the order is reversed.
+	 */
+	if (!spin_trylock(&info->lock))
+		return LRU_SKIP;
 
-		/* pin the inode */
-		inode = igrab(&info->vfs_inode);
+	/* pin the inode */
+	inode = igrab(&info->vfs_inode);
+	/* inode is about to be evicted */
+	if (!inode) {
+		list_lru_isolate(lru, item);
+		objcg = shmem_get_and_clear_objcg(info);
+		spin_unlock(&info->lock);
+		obj_cgroup_put(objcg);
+		return LRU_REMOVED;
+	}
 
-		/* inode is about to be evicted */
-		if (!inode) {
-			list_del_init(&info->shrinklist);
-			goto next;
-		}
+	list_lru_isolate(lru, item);
+	objcg = shmem_get_and_clear_objcg(info);
+	set_shmem_unused_huge_isolated(info);
+	list_add_tail(&info->shrinklist, &scan->list);
+	spin_unlock(&info->lock);
+	obj_cgroup_put(objcg);
 
-		list_move(&info->shrinklist, &list);
-next:
-		sbinfo->shrinklist_len--;
-		if (!--batch)
-			break;
+	return LRU_REMOVED;
+}
+
+static bool is_shmem_unused_huge_match(struct folio *folio,
+				       struct shrink_control *sc)
+{
+	struct mem_cgroup *memcg = NULL;
+	bool match;
+
+	/* shmem quota reclaim has no NUMA node or memcg restriction */
+	if (!sc)
+		return true;
+
+	if (folio_nid(folio) != sc->nid)
+		return false;
+
+	/*
+	 * Only non-root memcg reclaim needs to match the folio charge against
+	 * sc->memcg. Skip the folio memcg check for global shrinker reclaim and
+	 * root memcg reclaim.
+	 */
+	if (!sc->memcg || mem_cgroup_is_root(sc->memcg))
+		return true;
+
+	memcg = get_mem_cgroup_from_folio(folio);
+	match = memcg == sc->memcg;
+	mem_cgroup_put(memcg);
+
+	return match;
+}
+
+static void shmem_unused_huge_drop(struct inode *inode)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+
+	spin_lock(&info->lock);
+	list_del_init(&info->shrinklist);
+	spin_unlock(&info->lock);
+}
+
+static void shmem_unused_huge_requeue(struct inode *inode, struct folio *folio)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	struct obj_cgroup *objcg;
+	int nid = folio_nid(folio);
+
+	objcg = shmem_unused_huge_alloc_lru(sbinfo, folio, GFP_NOWAIT);
+	if (IS_ERR(objcg)) {
+		shmem_unused_huge_drop(inode);
+		return;
 	}
-	spin_unlock(&sbinfo->shrinklist_lock);
 
-	list_for_each_safe(pos, next, &list) {
-		pgoff_t next, end;
+	spin_lock(&info->lock);
+	/* Requeue the inode to shrinklist */
+	list_del_init(&info->shrinklist);
+	shmem_unused_huge_lru_add(sbinfo, &info->shrinklist, nid, objcg);
+	info->shrinklist_objcg = objcg;
+	info->shrinklist_nid = nid;
+	spin_unlock(&info->lock);
+}
+
+static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
+		struct shrink_control *sc, unsigned long nr_to_free)
+{
+	struct shmem_unused_huge_scan scan;
+	struct inode *inode;
+	struct shmem_inode_info *info;
+	struct folio *folio;
+	struct list_head *pos, *next;
+	unsigned long split = 0, freed = 0;
+
+	INIT_LIST_HEAD(&scan.list);
+	scan.sc = sc;
+	if (sc)
+		list_lru_shrink_walk(&sbinfo->shrinklist, sc,
+				     shmem_unused_huge_isolate, &scan);
+	else
+		list_lru_walk(&sbinfo->shrinklist, shmem_unused_huge_isolate,
+			      &scan, 128);
+
+	list_for_each_safe(pos, next, &scan.list) {
+		pgoff_t folio_end, end;
 		loff_t i_size;
 		int ret;
 
 		info = list_entry(pos, struct shmem_inode_info, shrinklist);
 		inode = &info->vfs_inode;
 
-		if (nr_to_free && freed >= nr_to_free)
-			goto move_back;
-
 		i_size = i_size_read(inode);
 		folio = filemap_get_entry(inode->i_mapping, i_size / PAGE_SIZE);
 		if (!folio || xa_is_value(folio))
@@ -782,13 +989,19 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		}
 
 		/* Check if there is anything to gain from splitting */
-		next = folio_next_index(folio);
+		folio_end = folio_next_index(folio);
 		end = shmem_fallocend(inode, DIV_ROUND_UP(i_size, PAGE_SIZE));
-		if (end <= folio->index || end >= next) {
+		if (end <= folio->index || end >= folio_end) {
 			folio_put(folio);
 			goto drop;
 		}
 
+		if (!is_shmem_unused_huge_match(folio, scan.sc))
+			goto move_back;
+
+		if (nr_to_free && freed >= nr_to_free)
+			goto move_back;
+
 		/*
 		 * Move the inode on the list back to shrinklist if we failed
 		 * to lock the page at this time.
@@ -796,35 +1009,30 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		 * Waiting for the lock may lead to deadlock in the
 		 * reclaim path.
 		 */
-		if (!folio_trylock(folio)) {
-			folio_put(folio);
+		if (!folio_trylock(folio))
+			goto move_back;
+
+		if (!is_shmem_unused_huge_match(folio, scan.sc)) {
+			folio_unlock(folio);
 			goto move_back;
 		}
 
 		ret = split_folio(folio);
 		folio_unlock(folio);
-		folio_put(folio);
 
 		/* If split failed move the inode on the list back to shrinklist */
 		if (ret)
 			goto move_back;
 
-		freed += next - end;
+		freed += folio_end - end;
 		split++;
+		folio_put(folio);
 drop:
-		list_del_init(&info->shrinklist);
+		shmem_unused_huge_drop(inode);
 		goto put;
 move_back:
-		/*
-		 * Make sure the inode is either on the global list or deleted
-		 * from any local list before iput() since it could be deleted
-		 * in another thread once we put the inode (then the local list
-		 * is corrupted).
-		 */
-		spin_lock(&sbinfo->shrinklist_lock);
-		list_move(&info->shrinklist, &sbinfo->shrinklist);
-		sbinfo->shrinklist_len++;
-		spin_unlock(&sbinfo->shrinklist_lock);
+		shmem_unused_huge_requeue(inode, folio);
+		folio_put(folio);
 put:
 		iput(inode);
 	}
@@ -837,7 +1045,7 @@ static long shmem_unused_huge_scan(struct super_block *sb,
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 
-	if (!READ_ONCE(sbinfo->shrinklist_len))
+	if (!list_lru_shrink_count(&sbinfo->shrinklist, sc))
 		return SHRINK_STOP;
 
 	return shmem_unused_huge_shrink(sbinfo, sc, 0);
@@ -848,21 +1056,21 @@ static long shmem_unused_huge_count(struct super_block *sb,
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 
-	/*
-	 * The per-superblock shrinklist is filesystem-global and does not
-	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
-	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
-	 * shrink_slab_memcg() to avoid queueing duplicate global work.
-	 */
-	if (!mem_cgroup_shrink_is_root(sc))
-		return 0;
-
-	return READ_ONCE(sbinfo->shrinklist_len);
+	return list_lru_shrink_count(&sbinfo->shrinklist, sc);
 }
 #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
 
 #define shmem_huge SHMEM_HUGE_DENY
 
+static void shmem_unused_huge_add(struct inode *inode, struct folio *folio,
+				  gfp_t gfp)
+{
+}
+
+static void shmem_unused_huge_del(struct inode *inode)
+{
+}
+
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		struct shrink_control *sc, unsigned long nr_to_free)
 {
@@ -1418,14 +1626,7 @@ static void shmem_evict_inode(struct inode *inode)
 		inode->i_size = 0;
 		mapping_set_exiting(inode->i_mapping);
 		shmem_truncate_range(inode, 0, (loff_t)-1);
-		if (!list_empty(&info->shrinklist)) {
-			spin_lock(&sbinfo->shrinklist_lock);
-			if (!list_empty(&info->shrinklist)) {
-				list_del_init(&info->shrinklist);
-				sbinfo->shrinklist_len--;
-			}
-			spin_unlock(&sbinfo->shrinklist_lock);
-		}
+		shmem_unused_huge_del(inode);
 		while (!list_empty(&info->swaplist)) {
 			/* Wait while shmem_unuse() is scanning this inode... */
 			wait_var_event(&info->stop_eviction,
@@ -2573,25 +2774,12 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	 */
 	if (alloced && folio_test_large(folio) &&
 	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) < folio_next_index(folio)) {
-		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-		struct shmem_inode_info *info = SHMEM_I(inode);
 		/*
 		 * Part of the large folio is beyond i_size: subject
 		 * to shrink under memory pressure.
 		 */
-		spin_lock(&sbinfo->shrinklist_lock);
-		/*
-		 * _careful to defend against unlocked access to
-		 * ->shrink_list in shmem_unused_huge_shrink()
-		 */
-		if (list_empty_careful(&info->shrinklist)) {
-			list_add_tail(&info->shrinklist,
-				      &sbinfo->shrinklist);
-			sbinfo->shrinklist_len++;
-		}
-		spin_unlock(&sbinfo->shrinklist_lock);
+		shmem_unused_huge_add(inode, folio, gfp);
 	}
-
 out:
 	*foliop = folio;
 	return 0;
@@ -3068,6 +3256,10 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	if (info->fsflags)
 		shmem_set_inode_flags(inode, info->fsflags, NULL);
 	INIT_LIST_HEAD(&info->shrinklist);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	info->shrinklist_objcg = NULL;
+	info->shrinklist_nid = -1;
+#endif
 	INIT_LIST_HEAD(&info->swaplist);
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
@@ -4942,6 +5134,9 @@ static void shmem_put_super(struct super_block *sb)
 #endif
 	free_percpu(sbinfo->ino_batch);
 	percpu_counter_destroy(&sbinfo->used_blocks);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	list_lru_destroy(&sbinfo->shrinklist);
+#endif
 	mpol_put(sbinfo->mpol);
 #ifdef CONFIG_TMPFS_XATTR
 	simple_xattr_cache_cleanup(&sbinfo->xa_cache);
@@ -5035,8 +5230,11 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 	raw_spin_lock_init(&sbinfo->stat_lock);
 	if (percpu_counter_init(&sbinfo->used_blocks, 0, GFP_KERNEL))
 		goto failed;
-	spin_lock_init(&sbinfo->shrinklist_lock);
-	INIT_LIST_HEAD(&sbinfo->shrinklist);
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (list_lru_init_memcg(&sbinfo->shrinklist, sb->s_shrink))
+		goto failed;
+#endif
 
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_SIZE;
-- 
2.54.0


