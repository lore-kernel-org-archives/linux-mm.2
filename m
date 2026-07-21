Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD473C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5676B00B1; Tue, 21 Jul 2026 04:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8869B6B00B4; Tue, 21 Jul 2026 04:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727D96B00B5; Tue, 21 Jul 2026 04:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 349716B00B1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:34:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 897ECA03C7
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:34:48 +0000 (UTC)
X-FDA: 85012123056.15.FC8BA1B
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf02.hostedemail.com (Postfix) with ESMTP id C993C80002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:34:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JHQiPEfg;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784622887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bM+I/4mzHE/eeLqMpRlBPWeTcaMyu3+Grki+D5Vavts=;
	b=Rqx9dzk41NnMdMk60CX01icKc/yKTYVNCOXtseUuCU3iTJ2enV4E9yowft53I/vl1EVK3X
	jtzwq3/Dw2YO1UePGvFi2IrGunemHui4xAjBB5zZ3xYUkVAj1O1yggdS+R3CzW4BUvu6Lg
	G9tWlnn9B1QUCN1sIjN7b/1JsrQnUg4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784622887;
	b=V7Ry1YYirWkfpP1ImdOs/HVY3GrXAKcrfFKAvi/dQ3fuB3Y5at3c2Sy52C28Vd9kEJk9HN
	0X2ViQuiWw1d6AC9KzGmJsLNEu8vwCqhVq0DpX8tVhBplHms/vgtshpwXH2qKZICHit5Kg
	cYv4EY4ZqI/CX9NMrRE3Ehu6+dRfy4Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JHQiPEfg;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784622885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bM+I/4mzHE/eeLqMpRlBPWeTcaMyu3+Grki+D5Vavts=;
	b=JHQiPEfgjRFHVjd/8y3v5qnqpFR4bc4ATM3V1JhrFyhWOksKZMyTkRO/JRANvFuLqLsj9a
	wRRdO+HgkjRbkBzqJQ0KFzsVbB8S9/nZGe0GdD0loAoawEOwgZ0E0+VRLF9LL75+yDuUHU
	C39Rd1ATtMvJHD2Y0mQXm/05wNL1vko=
From: Qi Zheng <qi.zheng@linux.dev>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	usama.arif@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 2/2] mm: shmem: make unused huge shrinker memcg aware
Date: Tue, 21 Jul 2026 16:34:12 +0800
Message-ID: <889581093179462979dbfb5458620fcca531787b.1784621804.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1784621804.git.zhengqi.arch@bytedance.com>
References: <cover.1784621804.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C993C80002
X-Stat-Signature: ua5xbq1kw8tgfryprcahjaqb14feciim
X-HE-Tag: 1784622886-604167
X-HE-Meta: U2FsdGVkX192/VmE2zFKgnPHke1Mvq2aC0gkK9R8xVHJ7gcMyvC1+kJ+XVVvYWdmLFAy2pB2K/07FeP7Cq8pFDyF+xPg2FNAWzgXMJ21b7HQN5qDTLTZUWo0KJN9fNp+OQQifxJnsLVPAehMfBdZa1nzghcx/owR3N/SESjhaFTzxF3BBadJ3NAdSQn3s/JZFkKv0qvOG3eDFeXdT3Ap8Ia+EYlr4KgdHDOoE6iwcwsxacPMfZwELojosKwiiB4MBypzOuStO3J5bojCIJAtnANVb70YDYx7fC9T1rgpkmtxXWn+sYxI3mQtPZ6yE/XU3Dkody9LGPhx7zwzZN+mNrM4xjCZlycysSDTOLK+ZvUwK43GVIC1Rsh8T+lxoXuVZ52C467vRFl8AMIW6IITcvOdrfSZhLm7JjtYXo3RBNC1UWj7JbbBNQcl0+nNH19KGKlr/Z0yE/Vg1LOVhftkOhxblfUIT1WN5qYV3k8OMHDeDCB9JZKzkV2koqXtdlPVthTDgVV3iKj8xmcopn5m3yotbvx8cYniA5lfUUorxrANGwkt4AVk/S/vX2RF7OQr0CtdZbaJTRwag+K1jDr0E1nbyFdz0QeAA6bfBnYbm91sK02Y311n9TzzGrpS5WqKGpd3NNKdkv3bBuydENv/KAA72WmUj894j5RCOhTxVqjL1e1IQbgSyz/+Wa92T3fCq6yu0ZU1lOUVtpLgPKc7J5VSc82cvcA5oiuC94+U2Gk3WNc5REiQCoSJHLOrfAWZlaah1dbt1gBVmz/4U3B0vEKu6kPUMRl2JbUr3ZxE2XprhBtJsQx+arBPGJ0lxiXV4AqbaBz6h3EGZpMH5j0T9bZTu2fnLRV7jq34o3Mt/AB/9+JvKeZrGmlyfjBvA8sMwa1o9gdMfi/55xPbKfp4KGPQUKokEW7UcGjvfrEi/U2RtfNwXvqsImbfQBXcxzjsF0mW3nnIi7OaafwXBKK
 Rv3mtpCH
 j74EbpzrfhHHAP9nstio0FcAIhIYqlOF/kHnvenSNlgUM1lG7XpNw6uqD2W9TN/bwR/uwAJ6e782jh3q+61a+5Lk8Cz4B3AX0XEgzU9qtD0VcJjzhqm1nGDPCGxEMqbvQBYQhW3JmvSDD36xCNPnsHrWiekyRlzpN6U55El4Hf/3xzz52TfDeK65Xqg==
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
 include/linux/shmem_fs.h |  12 +-
 mm/shmem.c               | 378 +++++++++++++++++++++++++++++----------
 2 files changed, 294 insertions(+), 96 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 5663dff53186e..aeb59901a840c 100644
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
+	struct mem_cgroup	*shrinklist_memcg;
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
index 20c24d92da430..8bf6dd850f85b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -724,51 +724,242 @@ static const char *shmem_format_huge(int huge)
 }
 #endif
 
+static bool is_shmem_unused_huge_isolated(struct shmem_inode_info *info)
+{
+
+	return info->shrinklist_nid == -1;
+}
+
+static void set_shmem_unused_huge_isolated(struct shmem_inode_info *info)
+{
+	info->shrinklist_nid = -1;
+}
+
+static struct mem_cgroup *shmem_get_and_clear_memcg(struct shmem_inode_info *info)
+{
+	struct mem_cgroup *memcg = info->shrinklist_memcg;
+
+	info->shrinklist_memcg = NULL;
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
+		/* isolated on scan list, let shrink handle it */
+		if (is_shmem_unused_huge_isolated(info))
+			goto unlock;
+
+		if (info->shrinklist_nid == nid &&
+		    info->shrinklist_memcg == memcg)
+			goto unlock;
+
+		list_lru_del(&sbinfo->shrinklist, &info->shrinklist,
+			     info->shrinklist_nid, info->shrinklist_memcg);
+		old_memcg = shmem_get_and_clear_memcg(info);
+	}
+
+	info->shrinklist_memcg = memcg;
+	info->shrinklist_nid = nid;
+	list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
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
+
+	/*
+	 * Use trylock to avoid ABBA deadlock: add/del path takes info->lock
+	 * before the list_lru bucket lock, while here the order is reversed.
+	 */
+	if (!spin_trylock(&info->lock))
+		return LRU_SKIP;
+
+	/* pin the inode */
+	inode = igrab(&info->vfs_inode);
+	/* inode is about to be evicted */
+	if (!inode) {
+		list_lru_isolate(lru, item);
+		memcg = shmem_get_and_clear_memcg(info);
+		spin_unlock(&info->lock);
+		mem_cgroup_put(memcg);
+		return LRU_REMOVED;
+	}
+
+	list_lru_isolate(lru, item);
+	memcg = shmem_get_and_clear_memcg(info);
+	set_shmem_unused_huge_isolated(info);
+	list_add_tail(&info->shrinklist, &scan->list);
+	spin_unlock(&info->lock);
+	mem_cgroup_put(memcg);
+
+	return LRU_REMOVED;
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
+	list_del_init(&info->shrinklist);
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
+	/* Requeue the inode to shrinklist */
+	list_del_init(&info->shrinklist);
+	list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
+	info->shrinklist_memcg = memcg;
+	info->shrinklist_nid = nid;
+	memcg = NULL;
+	spin_unlock(&info->lock);
+	mem_cgroup_put(memcg);
+
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
-		pgoff_t next, end;
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
@@ -781,13 +972,25 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
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
@@ -796,34 +999,33 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		 * reclaim path.
 		 */
 		if (!folio_trylock(folio)) {
+			shmem_unused_huge_requeue(inode, folio);
+			folio_put(folio);
+			goto put;
+		}
+
+		if (!is_shmem_unused_huge_match(folio, scan.sc)) {
+			folio_unlock(folio);
+			shmem_unused_huge_requeue(inode, folio);
 			folio_put(folio);
-			goto move_back;
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
 
-		freed += next - end;
+		freed += folio_end - end;
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
@@ -836,7 +1038,7 @@ static long shmem_unused_huge_scan(struct super_block *sb,
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 
-	if (!READ_ONCE(sbinfo->shrinklist_len))
+	if (!list_lru_shrink_count(&sbinfo->shrinklist, sc))
 		return SHRINK_STOP;
 
 	return shmem_unused_huge_shrink(sbinfo, sc, 0);
@@ -847,21 +1049,21 @@ static long shmem_unused_huge_count(struct super_block *sb,
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
@@ -1417,14 +1619,7 @@ static void shmem_evict_inode(struct inode *inode)
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
@@ -2532,28 +2727,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 
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
@@ -2582,6 +2755,15 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
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
@@ -3058,6 +3240,10 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	if (info->fsflags)
 		shmem_set_inode_flags(inode, info->fsflags, NULL);
 	INIT_LIST_HEAD(&info->shrinklist);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	info->shrinklist_memcg = NULL;
+	info->shrinklist_nid = -1;
+#endif
 	INIT_LIST_HEAD(&info->swaplist);
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
@@ -4924,6 +5110,9 @@ static void shmem_put_super(struct super_block *sb)
 #endif
 	free_percpu(sbinfo->ino_batch);
 	percpu_counter_destroy(&sbinfo->used_blocks);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	list_lru_destroy(&sbinfo->shrinklist);
+#endif
 	mpol_put(sbinfo->mpol);
 #ifdef CONFIG_TMPFS_XATTR
 	simple_xattr_cache_cleanup(&sbinfo->xa_cache);
@@ -5017,8 +5206,11 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
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


