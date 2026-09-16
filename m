Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95DABC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8456B00A6; Wed, 16 Sep 2026 06:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E4F6B00A7; Wed, 16 Sep 2026 06:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3CB6B00A9; Wed, 16 Sep 2026 06:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 748CE6B00A6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:21:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF6B140672
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:21:22 +0000 (UTC)
X-FDA: 85219233204.19.142127F
Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	by imf13.hostedemail.com (Postfix) with ESMTP id B677D20003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:21:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554080;
	b=MByFtmYWmQ2Z21zuu67VHsfn+vDEW85Cnebfu2sjMgKVZ+IER/v8/bQIMBxgfRvfxUYjJJ
	Muaqb9HttY1oM4FuiZ9P8RX5uQqsvtej6UNUYZRTD8fu5mvi92Vqix8aEIxtVo/b0acsxO
	LKhUK12Cp8emG/bfjOchKqtybpkHYww=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6iFifDlhm25XovhWh7FDQROqshtL1/zeSkkv0+1bCw=;
	b=4qEEsCgIAB6P6QjjXgIrwbLgugFj+qYnYGjTer9tPio+Ny+JZAWtCHSz/iET2giE/kGWap
	eQWFK8UhDn4JrZJyDhDQ4Qoikw4aTFzlmKWlqALRAAgx3IQgNPalJUl0FtfEaTWN2p6Lez
	/ezTr8nCKQSkVH9+rk4ec2Q5NqAj9kQ=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 152d4e0bf57540cb;
	Wed, 16 Sep 2026 10:21:19 +0000
X-Mizu-Trace-ID: 152d4e0bf57540cb
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 13/14] mm, swap: add sysfs per-device size limit for xswap
Date: Wed, 16 Sep 2026 18:19:20 +0800
Message-ID: <20260916101929.149106-14-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B677D20003
X-Rspam-User: 
X-Stat-Signature: t7oqup7dthwg78est5ydziy1cdbjigpb
X-HE-Tag: 1789554080-726761
X-HE-Meta: U2FsdGVkX19pABtZFpuZZDN0yRo4C6PN3rGIq09iP9exMw54zz078GCs+pVY9IrjEpxMSmbgYR5hHLdp6Cw7iP4VncKtp3f7eqmQ0j3ApIrtP6QSSOSi19UwSwdd9QLgzLz611maHg8i+pPjyz/MGw9jKFoNPL16HJGUZMcA1cdSpkCMTxTUSO7gcPWm9qTh1OONCARQX6wUdgFD1DtyDRCnOAnXZSET/SOHu30MyzCmGONkikWcxzhyFkKJFgKZDocFd24Qk3FKyNvg5gmviLkXl1MVfz6EzhhTkcU0ZdszkVa4L0z+sV+4fbuuHjI7yb00mnzR5jrB0UGPViW1VomW8JHYHnw3QccPMUTWkAj4TuymCJm/npx5g34rFpSJsfieXy3hdGSPrXEmzAwWH7SfTb+atjq61RFrdPKeU0XCNjyAxC6HyajzCfqXjLyw7uU3KDHSg8BO0YsOTvA9KYKyOsNS1GO727GbxoVtwwCsPbl4J56DRFCxx8ZlAUKjapS/qpEe8+/5XQsQw8c/7C467Y3+x+84obmcbOt02xoD8yMactuoSXg6yWqZU0DbwMYWBQQ+zfmN/Bst3zMzMtvK/1/QFliAsFXbBI+o81juhYg36wIVuJfgDbgTJ1bQ2wMZMP2Xroa4h5yIPUrOPWMwK+o1BCbSVCcC2P+cerIjYBZnRyKuLPHlZhDH2hPjqWTMIW6wD9KwRnOXLNzVZusoN1n8NG64etY3Mir1h+nqXuW4m/4HDHl2jtXVEfSWu9umcvwmpOpu4ipa5/XCWKnlUjO2SXINtuwtMleXIthzSYgrW77Ma56LDDaf0/a0mFQ9AdkFgVHwXq/OedxzUuiD2XgYtd8i1diF7/b8T9cfU/KM7ZPVYH+Hhyv6WhuOxzZhsx5bHSL2yrGpKAwAr6aY1AKw1OWm+ltxliXCAUoz/fUaDL6T1OiKTT9RAtZyJ5vEIqF1tbm/SfE0xP+
 ZSgM95QH
 OVg1Pl37Y2Cj8+cqFJ5OhH4UU8OEAHMRDUnISS1bEQbVWcdZLpnnydRahjHU9W4lvM2Rl12dCTlX6Q64c+MhiFrKMeezqyOJjclIoiX6AlOsKvng2GafLP8fjhzbbwcrCqWLbzrqKLRAZZ9GktTw+y2QMoBNQF9jCrNO4ZxXYYha47quoq2EXaAchOEquvw6bgDqqqfEUppXWG5JAn/nskV7/bgJwTHhpkrd2RyOil5V4LOdBbHrRq+zIyDYkliaSzrRJsOwCAX9UnDoB3C4QbgeI27ahsuNS2cu1vz/SUuhxkbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-device sysfs knob to limit the xswap usable size:

  /sys/kernel/mm/xswap/type<N>/limit    read/write, in pages

Reading reports the current usable size; writing sets a new ceiling.
The ceiling is clamped to cover the pages in use, and enforcement is
best effort. The write requires CAP_SYS_ADMIN.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  18 ++--
 mm/swapfile.c        | 193 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 179 insertions(+), 32 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 9fe82d0f1740..804189b4b4eb 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -16,6 +16,8 @@
 #include <uapi/linux/mempolicy.h>
 #include <asm/page.h>
 
+struct kobject;
+
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
@@ -245,8 +247,9 @@ struct swap_info_struct {
 #ifdef CONFIG_XSWAP
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for cluster_info */
 	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
-	unsigned long		nr_clusters;	/* how far the array may grow */
+	unsigned long		nr_clusters;	/* growth ceiling, set by type<N>/limit */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	struct kobject		*xswap_dev_kobj; /* sysfs: /sys/kernel/mm/xswap/type<N>/ */
 	struct work_struct	xswap_shrink_work; /* deferred shrink trigger */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
@@ -256,7 +259,7 @@ struct swap_info_struct {
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
-	unsigned int pages;		/* total of usable pages of swap */
+	unsigned int pages;		/* total of usable pages of swap; mutable for xswap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
 	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
@@ -269,10 +272,13 @@ struct swap_info_struct {
 					 * inuse_pages and all cluster lists.
 					 * Other fields are only changed
 					 * at swapon/swapoff, so are protected
-					 * by swap_lock. changing flags need
-					 * hold this lock and swap_lock. If
-					 * both locks need hold, hold swap_lock
-					 * first.
+					 * by swap_lock, except for pages:
+					 * xswap updates it at runtime from
+					 * type<N>/limit, and readers without
+					 * swap_lock use READ_ONCE(). changing
+					 * flags need hold this lock and
+					 * swap_lock. If both locks need hold,
+					 * hold swap_lock first.
 					 */
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2cf6ba0bd0c0..0fcbaf1cf0e2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -71,6 +71,8 @@ static int xswap_unmap_clusters(struct swap_info_struct *si,
 				unsigned long start_idx, unsigned long nr);
 static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
 static void xswap_try_shrink(struct swap_info_struct *si);
+static int xswap_dev_kobj_add(struct swap_info_struct *si);
+static void xswap_dev_kobj_del(struct swap_info_struct *si);
 
 static int xswap_create(int prio);
 static int xswap_destroy(int type);
@@ -1369,8 +1371,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 /* SWAP_USAGE_OFFLIST_BIT can only be set by this helper. */
 static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 {
-	unsigned long pages;
-
 	spin_lock(&swap_avail_lock);
 
 	if (swapoff) {
@@ -1388,15 +1388,19 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	} else {
 		/*
-		 * If not called by swapoff, take it off-list only if it's
-		 * full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
-		 * si->inuse_pages == pages), any concurrent slot freeing,
-		 * or device already removed from plist by someone else
-		 * will make this return false.
+		 * Take it off-list only if full and not already off.  Use >=
+		 * and the current count: xswap can shrink si->pages at
+		 * runtime, so a racing allocation can push inuse_pages past
+		 * it.
 		 */
-		pages = si->pages;
-		if (!atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
-					     pages | SWAP_USAGE_OFFLIST_BIT))
+		long val = atomic_long_read(&si->inuse_pages);
+
+		if (val & SWAP_USAGE_OFFLIST_BIT)
+			goto skip;
+		if (val < READ_ONCE(si->pages))
+			goto skip;
+		if (!atomic_long_try_cmpxchg(&si->inuse_pages, &val,
+					     val | SWAP_USAGE_OFFLIST_BIT))
 			goto skip;
 	}
 
@@ -1410,7 +1414,6 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 {
 	long val;
-	unsigned long pages;
 
 	spin_lock(&swap_avail_lock);
 
@@ -1429,15 +1432,14 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	val = atomic_long_fetch_and_relaxed(~SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 
 	/*
-	 * When device is full and device is on the plist, only one updater will
-	 * see (inuse_pages == si->pages) and will call del_from_avail_list. If
-	 * that updater happen to be here, just skip adding.
+	 * Mask off the bit to get the count.  Keep the device off-list if
+	 * it is still full; use >= because a runtime shrink of si->pages
+	 * can leave it over the limit.
 	 */
-	pages = si->pages;
-	if (val == pages) {
-		/* Just like the cmpxchg in del_from_avail_list */
-		if (atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
-					    pages | SWAP_USAGE_OFFLIST_BIT))
+	val &= ~SWAP_USAGE_OFFLIST_BIT;
+	if (val >= READ_ONCE(si->pages)) {
+		if (atomic_long_try_cmpxchg(&si->inuse_pages, &val,
+					    val | SWAP_USAGE_OFFLIST_BIT))
 			goto skip;
 	}
 
@@ -1462,7 +1464,8 @@ static bool swap_usage_add(struct swap_info_struct *si, unsigned int nr_entries)
 	 * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
 	 * remove it from the plist.
 	 */
-	if (unlikely(val == si->pages)) {
+	if (unlikely(!(val & SWAP_USAGE_OFFLIST_BIT) &&
+		     val >= READ_ONCE(si->pages))) {
 		del_from_avail_list(si, false);
 		return true;
 	}
@@ -3360,6 +3363,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 	if (si->flags & SWP_XSWAP) {
 		unsigned long nr_mapped;
 
+		xswap_dev_kobj_del(si);
 		cancel_work_sync(&si->xswap_shrink_work);
 		/*
 		 * Cluster 0 keeps the bad header slot, so it never empties
@@ -3690,7 +3694,7 @@ static int swap_show(struct seq_file *swap, void *v)
 		return 0;
 	}
 
-	bytes = K(si->pages);
+	bytes = K(READ_ONCE(si->pages));
 	inuse = K(swap_usage_in_pages(si));
 
 	file = si->swap_file;
@@ -4337,6 +4341,9 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		}
 
 		INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
+		if (xswap_dev_kobj_add(si))
+			pr_warn("xswap: failed to add sysfs interface for type %d\n",
+				si->type);
 		return 0;
 
 err_unmap:
@@ -4429,14 +4436,143 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 }
 
 #ifdef CONFIG_XSWAP
-/* Create a file-less xswap device.  si->max and the initial nr_clusters
- * ceiling are both twice RAM; the runtime size can be lowered afterwards
- * via /sys/kernel/mm/xswap/type<N>/limit.
+struct xswap_sysfs_dev {
+	struct kobject kobj;
+	struct swap_info_struct *si;
+};
+
+static ssize_t xswap_limit_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct swap_info_struct *si =
+		container_of(kobj, struct xswap_sysfs_dev, kobj)->si;
+
+	return sysfs_emit(buf, "%u\n", READ_ONCE(si->pages));
+}
+
+static ssize_t xswap_limit_store(struct kobject *kobj,
+				 struct kobj_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct swap_info_struct *si =
+		container_of(kobj, struct xswap_sysfs_dev, kobj)->si;
+	unsigned long val, clusters, new_pages, used;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	err = kstrtoul(buf, 0, &val);
+	if (err)
+		return err;
+
+	spin_lock(&swap_lock);
+	if (!(si->flags & SWP_WRITEOK)) {
+		spin_unlock(&swap_lock);
+		return -ENODEV;
+	}
+
+	used = swap_usage_in_pages(si);
+
+	clusters = DIV_ROUND_UP(val, SWAPFILE_CLUSTER);
+	if (clusters > si->nr_clusters_max)
+		clusters = si->nr_clusters_max;
+	/*
+	 * The ceiling can never be below the pages in use: the clusters
+	 * covering them stay mapped, and si->pages is the ceiling
+	 * capacity, so the free slots in the partially used top cluster
+	 * are credited instead of being allocatable but unaccounted for.
+	 */
+	clusters = max_t(unsigned long, clusters,
+			 DIV_ROUND_UP(used + 1, SWAPFILE_CLUSTER));
+
+	spin_lock(&si->lock);
+	si->nr_clusters = clusters;
+	spin_unlock(&si->lock);
+
+	new_pages = min_t(unsigned long, clusters * SWAPFILE_CLUSTER, si->max);
+	if (new_pages)
+		new_pages--;
+
+	if (new_pages < used)
+		new_pages = used;
+	if (new_pages != si->pages) {
+		long delta = (long)new_pages - (long)si->pages;
+
+		si->pages = new_pages;
+		atomic_long_add(delta, &nr_swap_pages);
+		total_swap_pages += delta;
+	}
+	add_to_avail_list(si, false);
+
+	spin_unlock(&swap_lock);
+
+	return count;
+}
+
+static struct kobj_attribute xswap_limit_attr =
+	__ATTR(limit, 0644, xswap_limit_show, xswap_limit_store);
+
+static void xswap_dev_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct xswap_sysfs_dev, kobj));
+}
+
+static const struct kobj_type xswap_dev_ktype = {
+	.sysfs_ops = &kobj_sysfs_ops,
+	.release = xswap_dev_release,
+};
+
+static int xswap_dev_kobj_add(struct swap_info_struct *si)
+{
+	struct xswap_sysfs_dev *dev;
+	int err;
+
+	if (!xswap_kobj)
+		return 0;
+
+	dev = kzalloc_obj(*dev, GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	dev->si = si;
+
+	err = kobject_init_and_add(&dev->kobj, &xswap_dev_ktype, xswap_kobj,
+				   "type%d", si->type);
+	if (err) {
+		kobject_put(&dev->kobj);
+		return err;
+	}
+
+	err = sysfs_create_file(&dev->kobj, &xswap_limit_attr.attr);
+	if (err) {
+		kobject_del(&dev->kobj);
+		kobject_put(&dev->kobj);
+		return err;
+	}
+	si->xswap_dev_kobj = &dev->kobj;
+	return 0;
+}
+
+static void xswap_dev_kobj_del(struct swap_info_struct *si)
+{
+	struct kobject *kobj = si->xswap_dev_kobj;
+
+	if (!kobj)
+		return;
+	si->xswap_dev_kobj = NULL;
+	sysfs_remove_file(kobj, &xswap_limit_attr.attr);
+	kobject_del(kobj);
+	kobject_put(kobj);
+}
+
+/* Create a file-less xswap device.  The address space reaches twice RAM;
+ * the device is created capped at RAM, and type<N>/limit raises that cap
+ * up to si->max.
  */
 static int xswap_create(int prio)
 {
 	struct swap_info_struct *si;
-	unsigned long ram, maxpages;
+	unsigned long ram, maxpages, nr_clusters;
 	int error;
 
 	if (prio != DEF_SWAP_PRIO && (prio < 0 || prio > SWAP_FLAG_PRIO_MASK))
@@ -4464,10 +4600,13 @@ static int xswap_create(int prio)
 	if (maxpages < 2)
 		maxpages = 2;
 
+	nr_clusters = DIV_ROUND_UP(ram, SWAPFILE_CLUSTER);
+
 	si->bdev = NULL;
 	si->flags |= SWP_XSWAP | SWP_SOLIDSTATE;
 	si->max = maxpages;
-	si->pages = maxpages - 1;
+	si->pages = min_t(unsigned long, nr_clusters * SWAPFILE_CLUSTER,
+			  si->max) - 1;
 	/*
 	 * No backing file: setup_swap_extents() is only reachable from the
 	 * file-backed swapon() path, so set ops here.  Only ops->flags is
@@ -4480,6 +4619,8 @@ static int xswap_create(int prio)
 	if (error)
 		goto bad_swap;
 
+	si->nr_clusters = min(nr_clusters, si->nr_clusters_max);
+
 	error = zswap_swapon(si->type, si->max);
 	if (error)
 		goto bad_swap;
-- 
2.54.0


