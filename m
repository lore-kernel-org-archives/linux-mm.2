Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB94C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879116B00B9; Mon,  3 Aug 2026 09:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE8B6B00BB; Mon,  3 Aug 2026 09:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B1C6B00BC; Mon,  3 Aug 2026 09:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44D786B00B9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7EC6C40653
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:47:12 +0000 (UTC)
X-FDA: 85059328704.06.C013276
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id A05E2A0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:47:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rleupwvm;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785746831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3f+0xEs3P53DlK4ELKZv7+ZiQst6jm95znwRrhos9Ek=;
	b=yUd98HYkooHocpOBjm2UEHJvhXh6Z5QWzhDeGToMu6U7e7xE6c4M7MQowkF7psinetLxs7
	o103PBw0uRC2O9ec5bkXTIXOdp0iU3KWAX4ZPqqFAybsEDg1JVxrwTtTjrg/jEwpAJgzDQ
	XNqgRmtDo40vAV0objK4cTHuyEp6IUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785746831;
	b=zUZCGayj+1QKsiIKcMczlhLtGFuRoAsDFGT0gzpcsBw2aIoKzN3Cbco9x+9LnjBACTS/pR
	IeOgsKJSAEAGOQqCo/n1+JCcLmghq4cyKSJzProKhPMtCFQiY9ygDCw4ISGWvvqV4atPHZ
	4dyWXcvldH/maxEiz1XKJmYGnjtWAwg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rleupwvm;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785746829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3f+0xEs3P53DlK4ELKZv7+ZiQst6jm95znwRrhos9Ek=;
	b=RleupwvmKXXbx2oK6zVCCMAFb33S/+9DAxWmSm/LUas1HiC576yo482kddw/nLD3QBrVyO
	+NnHURtRy50uZv5otTYD/EZtWxwOGlWuePT869zpUInneRRO8ow3BD9xpTtUiNnd0fThAv
	HJeywPrG25lXi6vZMf+eJ5iDZdab2gw=
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
Subject: [PATCH v3 3/3] mm: shmem: make unused huge shrinker memcg aware
Date: Mon,  3 Aug 2026 16:46:35 +0800
Message-ID: <d23cc0d06527e8085bdef645bdce489d9aa15bfc.1785746588.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1785746588.git.zhengqi.arch@bytedance.com>
References: <cover.1785746588.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A05E2A0002
X-Stat-Signature: a444jmqn8yb1dumncttxshgqp6z1bwiw
X-Rspam-User: 
X-HE-Tag: 1785746830-732157
X-HE-Meta: U2FsdGVkX185m4AUTV+WD2PkZ0u9xLMAa7RtWr3eRPr72AxBirYleixrZbDaIEFt5n5+5ZH6+Jze0PaQJkyzA7mZ/ziUTS8z27tHpdSPcBtdbXjMh3lp0veUfdz2oaBBs0Ib7lD5PN9C+BEGdkZ2damxKiB1DRue1ipuEpDz/rgtfW/ueflQ2no9GbUIW4mZtd6Q67PkrqCshiyjduwpu5xDzaSZIVA7UCwZZ9Y37mK0boH5MjnQEu/2ukkLlYdcPfcZ4rnDhh+HQ/DbQJnkYQpgT69r7ZTdD/YYtPePfTs8dUf1lAehyeyeV1Fha5RMQkUEr7ZCgmrtYNrfcmDaC5DXt6lD6RWQHrdKWPj8bz12e2tygJ6gJbFBuO2oU4nYbnoFT5iQB1Yf95QJ/o835Gqxrc/giGiIaCNfFkeXBMMUawGa9TyYeHNp2mrDDHSSqqQRGBZY3kXbDyTpe8bUfJ6Ir8EwinuR5yPCyUhek55wCg3N2ees1PlK/3PMMnXUBNZdYpotCgcSxItWb6riofzPkMV+jn9eS75IFM/YwYSClvepiXU8GrmVT/5KxMo8UXqG2Q5S8spuBVRBvCtJOI5fudSZIl07BH5tCf31vALX8iWe89R/COt5yhx+1XSj20cIWV4JUgFiF2YuD/Wg6tBRiyGukd1IyPt2rP/0m4cjidtvlP1KLwnXW7BXle2tZsLOXqQ9hE4hVs8rJOK7aBhLVbuJpGAZf9GrqYNnvE/NBvvwDuqfNhNVg7mT6JUw7BxjWFYSmNIDR4MKGUiOtnPwgTrhwnjGc2gMsplJH7+gzAinQADnoZRPQiTcsMfUVVAaRjdHE9lUQZpkXi+JL00G4hoo1t8Lv0btoqTmRuPCI4norM8zcexKgynucsfLs3gn+JeSbzKWYunLez+bBIkSh+XFaqObAQiTeSSJ3ZzRve6EgtGjIZp96UuhrKsPaZ1KL201UBdTgspm0bW
 vqGPGwpV
 HiGc0Mgaal4I8DUDDN2/8g9FafPjqKBVjtTNHXuepQBa578Z/XQ3X+DiLjT/M9GQZQozKDwXCW4/ekKMvn57Jtyo7RGdRTR0pCPAejQj/I6A8nVMqkCWXMNzyuetk8XM3vSQugoyiIrfghHLESWxRI5toSgF/qcLwyRuuZeZ2CSuUhHTps32L6ADZ+Q==
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

               before A scan    after A scan
  base         A=64M, B=64M     A=64M, B=64M (per-memcg count is skipped)
  patched      A=64M, B=64M     A=0,   B=64M

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/shmem_fs.h |  12 +-
 mm/shmem.c               | 341 +++++++++++++++++++++++++++++----------
 2 files changed, 268 insertions(+), 85 deletions(-)

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
index bc0b768135113..704353852ae26 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -724,51 +724,237 @@ static const char *shmem_format_huge(int huge)
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
 	struct shmem_inode_info *info;
-	struct folio *folio;
-	unsigned long batch = sc ? sc->nr_to_scan : 128;
-	unsigned long split = 0, freed = 0;
+	struct inode *inode;
+	struct mem_cgroup *memcg = NULL;
 
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
+		memcg = shmem_get_and_clear_memcg(info);
+		spin_unlock(&info->lock);
+		mem_cgroup_put(memcg);
+		return LRU_REMOVED;
+	}
 
-		/* inode is about to be evicted */
-		if (!inode) {
-			list_del_init(&info->shrinklist);
-			goto next;
-		}
+	list_lru_isolate(lru, item);
+	memcg = shmem_get_and_clear_memcg(info);
+	set_shmem_unused_huge_isolated(info);
+	list_add_tail(&info->shrinklist, &scan->list);
+	spin_unlock(&info->lock);
+	mem_cgroup_put(memcg);
 
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
+	if (IS_ERR(memcg)) {
+		shmem_unused_huge_drop(inode);
+		return;
 	}
-	spin_unlock(&sbinfo->shrinklist_lock);
 
-	list_for_each_safe(pos, next, &list) {
-		pgoff_t next, end;
+	spin_lock(&info->lock);
+	/* Requeue the inode to shrinklist */
+	list_del_init(&info->shrinklist);
+	list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
+	info->shrinklist_memcg = memcg;
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
@@ -781,13 +967,19 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
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
@@ -795,35 +987,30 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
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
@@ -836,7 +1023,7 @@ static long shmem_unused_huge_scan(struct super_block *sb,
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 
-	if (!READ_ONCE(sbinfo->shrinklist_len))
+	if (!list_lru_shrink_count(&sbinfo->shrinklist, sc))
 		return SHRINK_STOP;
 
 	return shmem_unused_huge_shrink(sbinfo, sc, 0);
@@ -847,21 +1034,21 @@ static long shmem_unused_huge_count(struct super_block *sb,
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
@@ -1417,14 +1604,7 @@ static void shmem_evict_inode(struct inode *inode)
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
@@ -2572,25 +2752,12 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
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
@@ -3067,6 +3234,10 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
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
@@ -4933,6 +5104,9 @@ static void shmem_put_super(struct super_block *sb)
 #endif
 	free_percpu(sbinfo->ino_batch);
 	percpu_counter_destroy(&sbinfo->used_blocks);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	list_lru_destroy(&sbinfo->shrinklist);
+#endif
 	mpol_put(sbinfo->mpol);
 #ifdef CONFIG_TMPFS_XATTR
 	simple_xattr_cache_cleanup(&sbinfo->xa_cache);
@@ -5026,8 +5200,11 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
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


