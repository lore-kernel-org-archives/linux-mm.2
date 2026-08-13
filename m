Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3958FC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398CC6B0493; Thu, 13 Aug 2026 06:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370996B0494; Thu, 13 Aug 2026 06:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287136B0495; Thu, 13 Aug 2026 06:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F41356B0493
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:49:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83E581A05ED
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:52 +0000 (UTC)
X-FDA: 85095925824.12.267DC31
Received: from mta1.migadu.com (out-122.mta1.migadu.com [95.215.58.122])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9F4CF120002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MsZSQXuoIbUTxFi6yRbGkOu4h5dsSqeHjqpGHlAxnP0=;
	b=xSVgkHZklA7qhnFurnRL7nuEr+AZTpqXl8toWMTCv07ZiA+mFQQsKQDgV9bxONe1QUStsx
	0CUDH3FRzk/idTVrY0SmuF3KciD5eERSF0/Sm/PAXIlJmBNe8TkYaIe3Olcx7IrR+aMcCZ
	iVI1MBl7r8db1xECk6Ij6l099786PF0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618190;
	b=gh5ZK3pjwRQn0CpUe92h3psMkOVp/z2XfPIXfiOExUrK00btyRysqJT1vXtmW6ZAuuW2TM
	GERfWpfYezApfvk3X279+MEqH7DamNcewt8x0mGHoS/GNGKDxW3pjzisr9GmSuYQOWreJz
	sJI0LG9O3066FvvOZgjyr62DjNph+nc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 850d7674679054d1;
	Thu, 13 Aug 2026 10:49:49 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 06/15] mm, swap: add sysfs create interface for xswap
Date: Thu, 13 Aug 2026 18:48:45 +0800
Message-ID: <20260813104857.3450386-7-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rso5tt4db6onds1y7abm18ay76o9sq3g
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F4CF120002
X-HE-Tag: 1786618190-728327
X-HE-Meta: U2FsdGVkX1+oH721tWcRHZQt+tXIKEOk3FHEZtQOXfNoN93Mrfuf3mU2T01jvlPab3vrDMijskj5ETy2623aVCKhItQtthLxJ2GMsh+/6yW/Tw7yaDdJDnzl0ziQd4lRvoYlY3o/U6twEAJbaQlNv9LlJB4Sq02CP189k+8jhOsQPxqLtAebGke13mXRgeh7eWYc98MkPsXr2Mvy6lJzypOxJ9gWNl8OKaTACVIngdTvhZObQI+JGROb2aydxzeNedQLBQgfBfrzu4i0G2dueKQdRCXPbpDjRuRjOIwhUDvbzuBxC11/1UgHQ7ZeDlQhATywwlI5Hhk9uVKukTl4i6P+LOn69aq/E0HdGniDZJx7SH63zcDnDhkA8Sy9lAqIH++e30kA+4JsEy7nX3rEUonQqdNO+mHULmqpgKnFYOwft9mRggh9lX20nyR2PcjmdrKsJVP+J8nWzzg7nyel4EIhPKTykWUFkYEpbk28+fLrlqB17rekWYdSlLre7qDnUxTMMXFO6SC6hhs/wkeMvyT0bmAJSpv5wQvoa1ePyt1S702W3Yi/7YiRjCXThtzWy6SfRbeTSTCt8OmyESHkb2S1JoRBbUgUOGSWoL0dATfRTzqaBemlt7JyWGM7npM8y2AApuerTPRzoQ9kcINe840Ov46sdmGrhEzNm5aSohTKhQTw9v5cwD+XsqDUdrr+tMGwOo7tbHF0HpQwYJaPmRUwMPHNKHAI7RXcdtvOh977CdR714dQXMBq6ww6es8Xlp1S0hpYdimdxo91KMISztmImj2Mf0MR3DGLOS+uwsP+fii38TOQR2xs6Amtz9ib90KgU2ivsmCvCJ+TtqMQe8Yb6eoYA9D7/Z9iM32oiOiShsQGgWH1rEKSz+20UoljJQZSELHwpVVIJfSwaaj7CDSnLbvRyZB6G2qy3IT5+ALGksygz+SHDDDDEnKllDnm/JJgyL9hE7i8s7pUW1x
 GnrzWaNL
 zQgGjJ8gHYWoUot/7VWwIAG8BEX5h0BdKDt/iBJx4qw+ilyxvtPNi0u6pnijAI6wfvys2yv7i6c8J836fKv/6ZXyBWAHq0/u+7fb8KQxq4KFB1uwwPrddO8VSRUjJF/QLIWkuVfXMBVn/G6xq88MdlAGE3SQmoPv03MEwLW6FSAiwmD+dHJN6aVB94I+Y7I6IVj0r59w0sJM7RlB7nF3+pZr0bDLrfFPc0asWQZzhkO9fZ7Vg4/Sz2RopC+I6X2fHCgELvG0OQCiJQt1rcP4xy5vvgUkRkiiem92dcukotYGB876Gc8mZkJ7UU22ktYuDnzxSulqSjfiuyblhBRdsxiyxXSOU6lNCUj3xeKY5Mf6JAKBFML+xFkr9z+OjM1aHHdsWPfFw6Q+vDVM898qhbWCLVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap devices have no backing storage, so there is no file to swapon.
Add a sysfs interface to create them directly:

  /sys/kernel/mm/xswap/create    write a percent (0 = use default) to
                                 create a device

The initial cluster ceiling (nr_clusters) for a new device is set by
XSWAP_DEFAULT_CLUSTER_PERCENT of totalram_pages.  The device appears in
/proc/swaps as "xswap<N>".  Per-device runtime sizing is tuned via the
debugfs knob added later in this series.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 165 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 161 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 178c3b798f8e..006241558128 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -16,6 +16,8 @@
 #include <linux/kernel_stat.h>
 #include <linux/swap.h>
 #include <linux/vmalloc.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 #include <linux/shmem_fs.h>
@@ -60,13 +62,79 @@
  */
 #define XSWAP_GROW_CLUSTERS \
 	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
+#define XSWAP_DEFAULT_CLUSTER_PERCENT 30
 
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr);
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data);
-#endif
+
+#ifdef CONFIG_SYSFS
+static int xswap_create(int percent);
+/* /sys/kernel/mm/xswap/: create.
+ * Per-device runtime size is tuned via debugfs type<N>_cluster_limit.
+ */
+
+static ssize_t xswap_create_store(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  const char *buf, size_t count)
+{
+	unsigned long percent;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	err = kstrtoul(buf, 0, &percent);
+	if (err)
+		return err;
+
+	/* 0 means "use the default percent" */
+	if (percent == 0)
+		percent = XSWAP_DEFAULT_CLUSTER_PERCENT;
+
+	err = xswap_create(percent);
+	if (err < 0)
+		return err;
+
+	return count;
+}
+
+static struct kobj_attribute xswap_create_attr = __ATTR(create, 0200, NULL,
+							xswap_create_store);
+
+static struct attribute *xswap_attrs[] = {
+	&xswap_create_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group xswap_attr_group = {
+	.attrs = xswap_attrs,
+};
+
+static struct kobject *xswap_kobj;
+
+static void xswap_sysfs_init(void)
+{
+	xswap_kobj = kobject_create_and_add("xswap", mm_kobj);
+	if (!xswap_kobj) {
+		pr_err("xswap: failed to create sysfs kobject\n");
+		return;
+	}
+	if (sysfs_create_group(xswap_kobj, &xswap_attr_group))
+		pr_err("xswap: failed to create sysfs group\n");
+}
+#else
+static inline void xswap_sysfs_init(void)
+{
+}
+#endif /* CONFIG_SYSFS */
+#else /* !CONFIG_XSWAP */
+static inline void xswap_sysfs_init(void)
+{
+}
+#endif /* CONFIG_XSWAP */
 
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
@@ -3305,7 +3373,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 		return SEQ_START_TOKEN;
 
 	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->swap_file) && !(si->flags & SWP_XSWAP))
 			continue;
 		if (!--l)
 			return si;
@@ -3326,7 +3394,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->swap_file) && !(si->flags & SWP_XSWAP))
 			continue;
 		return si;
 	}
@@ -3368,7 +3436,14 @@ static int swap_show(struct seq_file *swap, void *v)
 	inuse = K(swap_usage_in_pages(si));
 
 	file = si->swap_file;
-	len = seq_file_path(swap, file, " \t\n\\");
+	if (file)
+		len = seq_file_path(swap, file, " \t\n\\");
+	else {
+		char name[16];
+
+		len = scnprintf(name, sizeof(name), "xswap%d", si->type);
+		seq_puts(swap, name);
+	}
 	seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
 			len < 40 ? 40 - len : 1, " ",
 			swap_type_str(si),
@@ -3888,6 +3963,86 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	return err;
 }
 
+#ifdef CONFIG_XSWAP
+#ifdef CONFIG_SYSFS
+/* Create a file-less xswap device. si->max = full RAM; @percent sets the
+ * runtime nr_clusters ceiling.
+ */
+static int xswap_create(int percent)
+{
+	struct swap_info_struct *si;
+	unsigned long ram, maxpages, init_clusters;
+	int error;
+
+	if (percent < 1 || percent > 100)
+		return -EINVAL;
+
+	si = alloc_swap_info();
+	if (IS_ERR(si))
+		return PTR_ERR(si);
+
+	INIT_WORK(&si->discard_work, swap_discard_work);
+	INIT_WORK(&si->reclaim_work, swap_reclaim_work);
+
+	ram = totalram_pages();
+	maxpages = min_t(unsigned long, ram, swapfile_maximum_size);
+	if ((unsigned int)maxpages == 0)
+		maxpages = UINT_MAX;
+	if (maxpages < 2)
+		maxpages = 2;
+
+	si->bdev = NULL;
+	si->flags |= SWP_XSWAP | SWP_SOLIDSTATE;
+	si->max = maxpages;
+	si->pages = maxpages - 1;
+	/* no backing file: mirror the xswap branch of setup_swap_extents() */
+	si->ops = &swap_bdev_ops;
+
+	error = setup_swap_clusters_info(si, NULL, maxpages);
+	if (error)
+		goto bad_swap;
+
+	/* VM_SPARSE covers full RAM; runtime nr_clusters starts at percent. */
+	init_clusters = div_u64((u64)maxpages * percent, 100 * SWAPFILE_CLUSTER);
+	init_clusters = max_t(unsigned long, init_clusters, XSWAP_GROW_CLUSTERS);
+	if (init_clusters > si->nr_clusters)
+		init_clusters = si->nr_clusters;
+	si->nr_clusters = init_clusters;
+	si->pages = min_t(unsigned long, init_clusters * SWAPFILE_CLUSTER, si->max) - 1;
+
+	error = zswap_swapon(si->type, si->max);
+	if (error)
+		goto bad_swap;
+
+	mutex_lock(&swapon_mutex);
+	si->prio = DEF_SWAP_PRIO;
+	si->list.prio = -si->prio;
+	si->avail_list.prio = -si->prio;
+	/* si->swap_file stays NULL: this is a file-less device */
+	enable_swap_info(si);
+	mutex_unlock(&swapon_mutex);
+
+	pr_info("xswap: adding extendable swap type %d (%d%% of %lu pages = %u pages, max %lu)\n",
+		si->type, percent, ram, si->pages, maxpages);
+	atomic_inc(&proc_poll_event);
+	wake_up_interruptible(&proc_poll_wait);
+
+	return si->type;
+
+bad_swap:
+	kfree(si->global_cluster);
+	si->global_cluster = NULL;
+	destroy_swap_extents(si, NULL);	/* safe: xswap never sets SWP_ACTIVATED */
+	free_swap_cluster_info(si);
+	si->cluster_info = NULL;
+	spin_lock(&swap_lock);
+	si->flags = 0;
+	spin_unlock(&swap_lock);
+	return error;
+}
+#endif /* CONFIG_SYSFS */
+#endif /* CONFIG_XSWAP */
+
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *si;
@@ -4231,6 +4386,8 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	xswap_sysfs_init();
+
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.54.0


