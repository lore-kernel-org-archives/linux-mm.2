Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0453BC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 03:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0680D6B008A; Mon, 13 Jul 2026 23:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A096B008C; Mon, 13 Jul 2026 23:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49A26B0092; Mon, 13 Jul 2026 23:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE746B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:19:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08C1A120256
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:19:43 +0000 (UTC)
X-FDA: 84985927446.27.4EB6049
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3BD54160003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:19:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bXg2gctA;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783999181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=alps6hWuCsfgbK5PMQqSSoX0zJN9Car9QULf3pXnrhc=;
	b=wA5dexiDV379DXzvVOLECTGrNh71+f5WbE9lIMAjxVF4sa8sQw6QkWnNvveJSmxpyyfVb8
	hzYuCzTOhl8hZOrCQPUOHeq3NQHz0DYPMH3u08pKNs4IRZsagdO0XMOAbUHIHHkNO/Tdp0
	PAGWKVk3R2VJkgdcVQn1fKuhkBqdS3Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bXg2gctA;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783999181;
	b=sEb+Af6BgHYOXqcX+Cvu6AcQG+6xXU6QeOivrr6lHKRGOZOzehHj13uS0gZPYssR0gurPX
	JdYbFZnDuhUsBZjt71vgzn7d5B7dkzZvjIipRmML19GnD8vJQBdE958OkSLiATk2wIprx2
	QUjI9GMSJNI9NjguWmU+482gHS2poV4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783999177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=alps6hWuCsfgbK5PMQqSSoX0zJN9Car9QULf3pXnrhc=;
	b=bXg2gctAQ3TAZ9Fqr/zweZsh7VAigTgKQ7ogJD74ChWlKQ7WbOMk/1Jcz6kFaMxNkWA2I8
	itAPU3R4tt1h5+vQmBLHfP7oqloebG9Iyoc9AML9QL9Le5KoPmFg9a0l/T/jndp7X8BEXi
	jsj5O6MuU/PvOmC5fXaYyeiNPx45xHU=
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	usama.arif@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH] mm: shmem: make unused huge shrinker memcg aware
Date: Tue, 14 Jul 2026 11:19:18 +0800
Message-ID: <20260714031918.308-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3BD54160003
X-Stat-Signature: x18i5971yzn6f9pbs3yejxfm59oenkkt
X-HE-Tag: 1783999181-170003
X-HE-Meta: U2FsdGVkX1+QzyLZcn8yIE6OfHlQabqyPTMVOPyrBy0BQy70etKOpsC8KIiCKd0VVOVrmtwPHUq/eCbYwgNkO0EiUy/u9KaX6nws6uaDcvIo9YzEcyV+r0R9xiQ2tKd2qFyXqREvLjuMd40qWnItoLjDOYydFMgI5FrYcAQdxV5F1xOsEKnblK6j4yk21R3yirtw0FJZ9LbT4lCTmrpkMRnszjtFlmTvdQN1I8fJejmSyCI527CNEHbZsY7dA2xiefoMAZ5BYKP2ClRTe4LbB8TrEWdh7N0SoDSqOR4vI2kPy/RPmolX2TUBHhNrP4NWvwjfgIKkfyo0uTb69joSqlkpwrCWZu5GmuJKa1AbrT/FoKhfuAHkdUMDdvOZGgnD2A3kk60GRAIEIyLasBrB1r9QSTNWZhvNWc1yhplGLe0CwdFo90sEOwdX1/kWHyIGJ8gpqCPIzhS59uIdJbE14pb7qlHMY7nBLswFTNjqRzQlfXSpCor7Kz2DYX+ZH/2tTFF9w3/CPjxFCZfMZhcu54ug3G3/cObmXUgdPns5p9H37t6mHQus4SMHVqHE0dAcJmiI25Xu+ijB7GpmrK/petAMkkDCYFHC0tbK/MCo/sOgLaXFbAY0R8TRA3e/7lokeMCZVlFZVlD79oQCplqza+Av4zV5sIDeAzv4NXddgxNnNPTCto+B0sSc+9vP8kCOL3ho9r25d36OOtthsE9/T6Hh0VdMAvLQRGIpeJnaorgK0v8YtYaMvOvMbYUpkYeAOLRy3iBbnMZJkZVoKnOns7S7BABPIsDYmz0g2Zp+CjWPdtAiotNvibyDyRbZyOvVuKDbwE26/zv50Z5TWzk3Y9IT1Yi0vpgWZ3LrbOMPPfeTuUOIFjleZ8llTgrc0t83XCcO0mFMwkKQ0i3YJ1DdqanKAYPMfFMwtmMh2UJOciX3drxsrVQ8aQnUBaeNSlD8R+20YVogjNAxPKG+2N+
 WJuXnE7n
 vv2SGjT/pUdr0ZEEdJ2/HAutBB3AddPDuYKKSfpHF4xLtxRptM7kZzDecLHZjtSx1CScIPQhUyxV6BE+4isdPBBb/Ms6rmKn0Fdw0wLD6M839hgW6D6c7Innha0UKVhl7Ti+wIHIIFhAwbp3JcEi2uMXVGsH0HT1z9uca1NhHhoXCa0VbWUdszC1l+OY1ON5HxZeTQcHNRokHrzn2cwqv3h9biZG40GIkYh+8RL6Ndh4cBTrNuuOsbN+Mbg==
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

The list_lru still tracks inodes while the actual split target is the
current tail huge folio, so validate the folio memcg/node during scan. If
the folio no longer matches the reclaim context or splitting cannot
proceed, requeue the inode according to the current tail folio; if the
inode is no longer shrinkable, drop the scan entry.

This can be tested with the shrinker debugfs interface by allocating 32
tmpfs tail THPs in each of two memcgs, then scanning the sb-tmpfs shrinker
with memcg A's cgroup id:

               before A scan        after A scan
  base         A=64M, B=64M         A=0,  B=0
  patched      A=64M, B=64M         A=0,  B=64M

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
This patch is based on next-20260701 because it doesn't include this patch:

https://lore.kernel.org/all/20260609123047.1948242-1-usama.arif@linux.dev/

Later on, Usama will consider moving this restriction down into the fs callback.

 include/linux/shmem_fs.h |  14 +-
 mm/shmem.c               | 379 ++++++++++++++++++++++++++++++---------
 2 files changed, 310 insertions(+), 83 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e729b9b0e38d4..0b14de1e890a9 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -11,6 +11,7 @@
 #include <linux/fs_parser.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/bits.h>
+#include <linux/list_lru.h>
 
 struct swap_iocb;
 
@@ -56,6 +57,13 @@ struct shmem_inode_info {
 	struct dquot __rcu	*i_dquot[MAXQUOTAS];
 #endif
 	struct inode		vfs_inode;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	struct list_head	shrinklist_scan;
+	struct mem_cgroup	*shrinklist_memcg;
+	int			shrinklist_nid;
+	bool			shrinklist_isolated;
+#endif
 };
 
 #define SHMEM_FL_USER_VISIBLE		(FS_FL_USER_VISIBLE | FS_CASEFOLD_FL)
@@ -85,9 +93,9 @@ struct shmem_sb_info {
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
index b06c1ae2f50c3..a17150e6107c6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -724,50 +724,252 @@ static const char *shmem_format_huge(int huge)
 }
 #endif
 
+static inline struct mem_cgroup *shmem_get_and_clear_memcg(struct shmem_inode_info *info)
+{
+	struct mem_cgroup *memcg = info->shrinklist_memcg;
+
+	info->shrinklist_memcg = NULL;
+	info->shrinklist_nid = -1;
+
+	return memcg;
+}
+
+#ifdef CONFIG_MEMCG
+static struct mem_cgroup *
+shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct folio *folio,
+			    gfp_t gfp)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	memcg = get_mem_cgroup_from_folio(folio);
+	if (!memcg)
+		return NULL;
+
+	ret = memcg_list_lru_alloc(memcg, &sbinfo->shrinklist, gfp);
+	if (ret) {
+		mem_cgroup_put(memcg);
+		return ERR_PTR(ret);
+	}
+
+	return memcg;
+}
+#else
+static struct mem_cgroup *
+shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct folio *folio,
+			    gfp_t gfp)
+{
+	return NULL;
+}
+#endif
+
+static void shmem_unused_huge_add(struct inode *inode, struct folio *folio,
+				  gfp_t gfp)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	int nid = folio_nid(folio);
+	struct mem_cgroup *memcg = NULL, *old_memcg = NULL;
+
+	memcg = shmem_unused_huge_alloc_lru(sbinfo, folio, gfp);
+	if (IS_ERR(memcg))
+		return;
+
+	spin_lock(&info->lock);
+	if (!list_empty(&info->shrinklist)) {
+		if (info->shrinklist_nid == nid &&
+		    info->shrinklist_memcg == memcg)
+			goto unlock;
+
+		list_lru_del(&sbinfo->shrinklist, &info->shrinklist,
+			     info->shrinklist_nid, info->shrinklist_memcg);
+		old_memcg = shmem_get_and_clear_memcg(info);
+	}
+
+	list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
+	info->shrinklist_memcg = memcg;
+	info->shrinklist_nid = nid;
+	memcg = NULL;
+unlock:
+	spin_unlock(&info->lock);
+	mem_cgroup_put(old_memcg);
+	mem_cgroup_put(memcg);
+}
+
+static void shmem_unused_huge_del(struct inode *inode)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	struct mem_cgroup *memcg = NULL;
+
+	spin_lock(&info->lock);
+	if (!list_empty(&info->shrinklist)) {
+		list_lru_del(&sbinfo->shrinklist, &info->shrinklist,
+			     info->shrinklist_nid, info->shrinklist_memcg);
+		memcg = shmem_get_and_clear_memcg(info);
+	}
+	spin_unlock(&info->lock);
+
+	mem_cgroup_put(memcg);
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
+	struct shmem_inode_info *info;
+	struct inode *inode;
+	struct mem_cgroup *memcg = NULL;
+
+	info = list_entry(item, struct shmem_inode_info, shrinklist);
+	if (!spin_trylock(&info->lock))
+		return LRU_SKIP;
+
+	if (info->shrinklist_isolated) {
+		spin_unlock(&info->lock);
+		return LRU_SKIP;
+	}
+
+	inode = igrab(&info->vfs_inode);
+	if (!inode) {
+		/*
+		 * This inode is being evicted, just drop its stale active LRU
+		 * entry.
+		 */
+		list_lru_isolate(lru, item);
+		memcg = shmem_get_and_clear_memcg(info);
+		spin_unlock(&info->lock);
+		mem_cgroup_put(memcg);
+		return LRU_REMOVED;
+	}
+
+	info->shrinklist_isolated = true;
+	list_lru_isolate(lru, item);
+	memcg = shmem_get_and_clear_memcg(info);
+	list_add_tail(&info->shrinklist_scan, &scan->list);
+	spin_unlock(&info->lock);
+	mem_cgroup_put(memcg);
+
+	return LRU_REMOVED;
+}
+
+static bool is_shmem_unused_huge_readded(struct inode *inode)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	bool readded;
+
+	spin_lock(&info->lock);
+	readded = info->shrinklist_isolated && !list_empty(&info->shrinklist);
+	spin_unlock(&info->lock);
+
+	return readded;
+}
+
+static bool is_shmem_unused_huge_match(struct folio *folio,
+				       struct shrink_control *sc)
+{
+	struct mem_cgroup *memcg = NULL;
+	bool match;
+
+	/*
+	 * Only non-root memcg reclaim needs to match the folio charge against
+	 * sc->memcg. Skip the folio memcg check for the following cases:
+	 * 1. shmem quota reclaim (sc == NULL)
+	 * 2. global shrinker reclaim
+	 * 3. root memcg reclaim
+	 */
+	if (!sc || !sc->memcg || mem_cgroup_is_root(sc->memcg))
+		return true;
+
+	if (folio_nid(folio) != sc->nid)
+		return false;
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
+	list_del_init(&info->shrinklist_scan);
+	info->shrinklist_isolated = false;
+	spin_unlock(&info->lock);
+}
+
+static void shmem_unused_huge_requeue(struct inode *inode, struct folio *folio)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	struct mem_cgroup *memcg;
+	int nid = folio_nid(folio);
+
+	memcg = shmem_unused_huge_alloc_lru(sbinfo, folio, GFP_NOWAIT);
+	if (IS_ERR(memcg))
+		goto drop;
+
+	spin_lock(&info->lock);
+	if (!info->shrinklist_isolated)
+		goto unlock;
+
+	list_del_init(&info->shrinklist_scan);
+	info->shrinklist_isolated = false;
+	if (!list_empty(&info->shrinklist))
+		goto unlock;
+
+	list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
+	info->shrinklist_memcg = memcg;
+	info->shrinklist_nid = nid;
+	memcg = NULL;
+
+unlock:
+	spin_unlock(&info->lock);
+	mem_cgroup_put(memcg);
+	return;
+
+drop:
+	shmem_unused_huge_drop(inode);
+}
+
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		struct shrink_control *sc, unsigned long nr_to_free)
 {
-	LIST_HEAD(list), *pos, *next;
+	struct shmem_unused_huge_scan scan;
 	struct inode *inode;
 	struct shmem_inode_info *info;
 	struct folio *folio;
-	unsigned long batch = sc ? sc->nr_to_scan : 128;
+	struct list_head *pos, *next;
 	unsigned long split = 0, freed = 0;
 
-	if (list_empty(&sbinfo->shrinklist))
-		return SHRINK_STOP;
-
-	spin_lock(&sbinfo->shrinklist_lock);
-	list_for_each_safe(pos, next, &sbinfo->shrinklist) {
-		info = list_entry(pos, struct shmem_inode_info, shrinklist);
-
-		/* pin the inode */
-		inode = igrab(&info->vfs_inode);
-
-		/* inode is about to be evicted */
-		if (!inode) {
-			list_del_init(&info->shrinklist);
-			goto next;
-		}
-
-		list_move(&info->shrinklist, &list);
-next:
-		sbinfo->shrinklist_len--;
-		if (!--batch)
-			break;
-	}
-	spin_unlock(&sbinfo->shrinklist_lock);
+	INIT_LIST_HEAD(&scan.list);
+	scan.sc = sc;
+	if (sc)
+		list_lru_shrink_walk(&sbinfo->shrinklist, sc,
+				     shmem_unused_huge_isolate, &scan);
+	else
+		list_lru_walk(&sbinfo->shrinklist, shmem_unused_huge_isolate,
+			      &scan, 128);
 
-	list_for_each_safe(pos, next, &list) {
+	list_for_each_safe(pos, next, &scan.list) {
 		pgoff_t next, end;
 		loff_t i_size;
 		int ret;
 
-		info = list_entry(pos, struct shmem_inode_info, shrinklist);
+		info = list_entry(pos, struct shmem_inode_info, shrinklist_scan);
 		inode = &info->vfs_inode;
 
-		if (nr_to_free && freed >= nr_to_free)
-			goto move_back;
+		if (is_shmem_unused_huge_readded(inode))
+			goto drop;
 
 		i_size = i_size_read(inode);
 		folio = filemap_get_entry(inode->i_mapping, i_size / PAGE_SIZE);
@@ -788,6 +990,18 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 			goto drop;
 		}
 
+		if (!is_shmem_unused_huge_match(folio, scan.sc)) {
+			shmem_unused_huge_requeue(inode, folio);
+			folio_put(folio);
+			goto put;
+		}
+
+		if (nr_to_free && freed >= nr_to_free) {
+			shmem_unused_huge_requeue(inode, folio);
+			folio_put(folio);
+			goto put;
+		}
+
 		/*
 		 * Move the inode on the list back to shrinklist if we failed
 		 * to lock the page at this time.
@@ -796,34 +1010,39 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		 * reclaim path.
 		 */
 		if (!folio_trylock(folio)) {
+			shmem_unused_huge_requeue(inode, folio);
 			folio_put(folio);
-			goto move_back;
+			goto put;
+		}
+
+		if (is_shmem_unused_huge_readded(inode)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			goto drop;
+		}
+
+		if (!is_shmem_unused_huge_match(folio, scan.sc)) {
+			folio_unlock(folio);
+			shmem_unused_huge_requeue(inode, folio);
+			folio_put(folio);
+			goto put;
 		}
 
 		ret = split_folio(folio);
 		folio_unlock(folio);
-		folio_put(folio);
 
 		/* If split failed move the inode on the list back to shrinklist */
-		if (ret)
-			goto move_back;
+		if (ret) {
+			shmem_unused_huge_requeue(inode, folio);
+			folio_put(folio);
+			goto put;
+		}
 
 		freed += next - end;
 		split++;
+		folio_put(folio);
 drop:
-		list_del_init(&info->shrinklist);
-		goto put;
-move_back:
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
+		shmem_unused_huge_drop(inode);
 put:
 		iput(inode);
 	}
@@ -836,7 +1055,7 @@ static long shmem_unused_huge_scan(struct super_block *sb,
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 
-	if (!READ_ONCE(sbinfo->shrinklist_len))
+	if (!list_lru_shrink_count(&sbinfo->shrinklist, sc))
 		return SHRINK_STOP;
 
 	return shmem_unused_huge_shrink(sbinfo, sc, 0);
@@ -846,12 +1065,22 @@ static long shmem_unused_huge_count(struct super_block *sb,
 		struct shrink_control *sc)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
-	return READ_ONCE(sbinfo->shrinklist_len);
+
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
@@ -1405,14 +1634,7 @@ static void shmem_evict_inode(struct inode *inode)
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
@@ -2510,28 +2732,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 
 alloced:
 	alloced = true;
-	if (folio_test_large(folio) &&
-	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
-					folio_next_index(folio)) {
-		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-		struct shmem_inode_info *info = SHMEM_I(inode);
-		/*
-		 * Part of the large folio is beyond i_size: subject
-		 * to shrink under memory pressure.
-		 */
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
-	}
-
 	if (sgp == SGP_WRITE)
 		folio_set_referenced(folio);
 	/*
@@ -2560,6 +2760,15 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		error = -EINVAL;
 		goto unlock;
 	}
+
+	if (alloced && folio_test_large(folio) &&
+	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) < folio_next_index(folio)) {
+		/*
+		 * Part of the large folio is beyond i_size: subject
+		 * to shrink under memory pressure.
+		 */
+		shmem_unused_huge_add(inode, folio, gfp);
+	}
 out:
 	*foliop = folio;
 	return 0;
@@ -3036,6 +3245,10 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	if (info->fsflags)
 		shmem_set_inode_flags(inode, info->fsflags, NULL);
 	INIT_LIST_HEAD(&info->shrinklist);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	INIT_LIST_HEAD(&info->shrinklist_scan);
+	info->shrinklist_nid = -1;
+#endif
 	INIT_LIST_HEAD(&info->swaplist);
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
@@ -4902,6 +5115,9 @@ static void shmem_put_super(struct super_block *sb)
 #endif
 	free_percpu(sbinfo->ino_batch);
 	percpu_counter_destroy(&sbinfo->used_blocks);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	list_lru_destroy(&sbinfo->shrinklist);
+#endif
 	mpol_put(sbinfo->mpol);
 #ifdef CONFIG_TMPFS_XATTR
 	simple_xattr_cache_cleanup(&sbinfo->xa_cache);
@@ -4995,8 +5211,11 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
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


