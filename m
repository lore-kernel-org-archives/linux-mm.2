Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C57AC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF476B00B4; Wed,  5 Aug 2026 03:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADBD26B00B6; Wed,  5 Aug 2026 03:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC5D6B00B7; Wed,  5 Aug 2026 03:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE066B00B4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:55:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 131791A03F8
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:55:29 +0000 (UTC)
X-FDA: 85066455978.04.50CDF62
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E36540008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:55:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pyc4i7e3;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lEj0de+6RdDBzrWHGVYXCvS0Mqk6pZo6dba7WT6t2E=;
	b=vMZ3MeFx7w532hB1sOobxTLF91OkWUUe8FUNMZNMpzC8e8+22HGi9vBB5kzL6Xq68u7Znz
	6jPb5ARREFoWJXQwsrI9FXOrGV4M93A9y4VGLaKpOeOVSZN08okXw6/ji3PFha7zn2EfoV
	plbAxaus3Wt/QZOJdtzr8AYfNrV+yDg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916527;
	b=8WI/H5susrMaihP1fF3aV6PDQj1jpGIdYLULzxe3NfibGBPAtMUR1wigk002zwakUgKxnw
	F76Bw9KA+WOMv05aQFy+fU2RItWft3V0uP0JjmnEo0j2TTpEhhnswwkc7w2FAtSbf6FeBT
	XqN4k3ZZ91WDFAxXeHKofIqfe05WbU8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pyc4i7e3;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3lEj0de+6RdDBzrWHGVYXCvS0Mqk6pZo6dba7WT6t2E=;
	b=pyc4i7e3V7GAwOHRbjgP022+4yb0wxUFzkJor0j4yxH7X3QZ6m6S92NaTu7tPaeMdETqz4
	Kxp+0xEtMUKaOHZyFsEclJU/kMdGQbRZo/bfns17uVIaW92yeQhcoCGqsYSbDK8JfkH6aW
	o1v7Fm/ifbDVSk4DoPKF5mdxhc4gLg4=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	david@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH v2 09/10] mm, swap: add debugfs knob for xswap per-device cluster limit
Date: Wed,  5 Aug 2026 15:53:32 +0800
Message-ID: <20260805075336.3579395-10-baoquan.he@linux.dev>
In-Reply-To: <20260805075336.3579395-1-baoquan.he@linux.dev>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E36540008
X-Rspam-User: 
X-Stat-Signature: c7m6e9j5pojyu9cwhwocya5bp9h7qz64
X-HE-Tag: 1785916527-408254
X-HE-Meta: U2FsdGVkX19jPqoEZDrB2vDdS9GQUjTQu76F2kyk3pBTETABmlqjCvGu7NDf3gFgWfV/cQlh9N7Yn5rw6C/L7CDm7S2yg1exdCnFIud1Pf/up8UnVVuiFE+gYcNjFMqUYrIpD24NtTMXfV+qTfyRS7WceUx/dli12nret8PRq6Qyy4FyUGwLFQtgMwSY7bxDollvmxwtnNBJCEjv3q8wGj0gbMsvPocA+7m9DTDkbWVQS5piG/KwA/Ffvr+mSRQXIUWshj1V27oA8DZLSQgRcOjIIbvQ1bWypi/H2pRGOFoZ20uq74+T65WtzWzH6PtmQbc+WY7tVaRXFhEYhbzYEI65YZcy2a8kl/phefe0T++NlozAMgxB/i5LWhIGwH3qynmJlwmCrBxZm1kWSwhTnj5IBkB+RrtqrJ83Lk6hhY3zs1aIgmRewtHq4zkxk4KqUPKJooqKvJYAu7fCvb9vxv8GDQUDCT6E6g9wP8Un2ECSLfCnsXRHEZck78HAB5MDMhD555vVyxXRQtJoaWMCoVSjkXfCMiQ+5FZMs6sd/K0EsavdMpfjnwlJil1OpAwQPMVAy3QsAV92YxSk5cNHiMyt/TjHX8O8iWbPfsDK62z/5/SIIxs8ZXMxir3/NdL0asL2Wp/+bl5NBwXad1W2/4esYQ0okJZA3HfND71hiKdTqESVYv3QxG9OhpvhT7q2aDr4NpcKxiOfwrIsoHzkzpc+631+I4AD6OZRmFuYqtnpMCuD3FLhmXigc+FQx8o/nBs+Xo+NitHgQnYliFo49/lF8XLDMZPG1cxMDWhy9GX91iyZg0yen2SswjBxO01amLyzJaWRKoJ61NAnF82GOl0DKC/NZuGmqIZ/l1pRcP3mKoyJsdhy1cnmGfVgLcdjPu4+X4EcVZE3JEwJo0vdrvWy84AdCoYpiN7yMK5cv5JM0bvMc+gHDR2KlpimFaSS/3K8vgMrC5mOrqdWtyX
 BJ/dAhbN
 8Rb9jq5Mn7bRCKZQUWENWZdu3O5dvt/Ovv7JshLtkOBm5X7LkI9rTKdGVpnoba5l/pF2UPBEKU7ZtreHUY98zrpWJMwjiRs8GXqyCxPlPr9zmW0zqJiXNvLbOu+akBFP3MvHL4TNUOBRJMAPHzjy3csON+By+sGYdUKsWZIB3GBakKGizl1//57bjtvfXoS/pT387vq3ZJTbp66QwkuM76+jhhCj1TNduKwmj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-device debugfs file for runtime adjustment of xswap cluster
limit:
  /sys/kernel/debug/xswap/type<N>_cluster_limit

Reading shows the current ceiling (in clusters); writing sets it
(clamped to [0, nr_clusters_max]). Setting below nr_clusters_mapped
triggers an immediate shrink check via xswap_try_shrink().

The debugfs entry is created at swapon and removed at swapoff.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 97 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1159153459a1..4f4583f9a4e5 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -254,6 +254,7 @@ struct swap_info_struct {
 	unsigned long		nr_clusters;	/* current growth ceiling (≤ nr_clusters_max) */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
+	struct dentry		*debugfs_entry;	/* debugfs: type<N>_max_clusters */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3037f428f217..265f2bac1a12 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -48,6 +48,9 @@
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+#include <linux/debugfs.h>
+
+static DEFINE_SPINLOCK(swap_lock);
 
 #ifdef CONFIG_XSWAP
 /*
@@ -63,6 +66,8 @@
 #define XSWAP_GROW_CLUSTERS \
 	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
 
+static struct dentry *xswap_debugfs_root;
+
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr);
 static void xswap_unmap_clusters(struct swap_info_struct *si,
@@ -73,6 +78,90 @@ static void xswap_update_free_tail(struct swap_info_struct *si,
 				    unsigned long freed_idx);
 static void xswap_try_shrink(struct swap_info_struct *si);
 
+/*
+ * debugfs read/write for per-device max cluster count.
+ * Shows/sets si->nr_clusters (current growth ceiling), clamped to
+ * [0, si->nr_clusters_max].
+ */
+static ssize_t xswap_max_clusters_read(struct file *file, char __user *buf,
+				       size_t count, loff_t *ppos)
+{
+	struct swap_info_struct *si = file->private_data;
+	char tmp[32];
+	int len;
+
+	len = snprintf(tmp, sizeof(tmp), "%lu\n", READ_ONCE(si->nr_clusters));
+	return simple_read_from_buffer(buf, count, ppos, tmp, len);
+}
+
+static ssize_t xswap_max_clusters_write(struct file *file,
+					const char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct swap_info_struct *si = file->private_data;
+	unsigned long val, new_pages;
+	int err;
+
+	err = kstrtoul_from_user(buf, count, 0, &val);
+	if (err)
+		return err;
+
+	if (val > si->nr_clusters_max)
+		val = si->nr_clusters_max;
+
+	spin_lock(&si->lock);
+	si->nr_clusters = val;
+	spin_unlock(&si->lock);
+
+	/* Keep the visible swap size in sync with the new ceiling. */
+	new_pages = min_t(unsigned long, val * SWAPFILE_CLUSTER, si->max);
+	if (new_pages)
+		new_pages--;
+	if (new_pages != si->pages) {
+		long delta = (long)new_pages - (long)si->pages;
+
+		spin_lock(&swap_lock);
+		si->pages = new_pages;
+		atomic_long_add(delta, &nr_swap_pages);
+		total_swap_pages += delta;
+		spin_unlock(&swap_lock);
+	}
+
+	/*
+	 * Lowering the ceiling may make tail clusters eligible for
+	 * shrinking.  Trigger an immediate check.
+	 */
+	xswap_try_shrink(si);
+
+	return count;
+}
+
+static const struct file_operations xswap_debugfs_fops = {
+	.read = xswap_max_clusters_read,
+	.write = xswap_max_clusters_write,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
+static void xswap_debugfs_add(struct swap_info_struct *si)
+{
+	char name[32];
+
+	if (!xswap_debugfs_root)
+		return;
+
+	snprintf(name, sizeof(name), "type%d_cluster_limit", si->type);
+	si->debugfs_entry = debugfs_create_file(name, 0644, xswap_debugfs_root,
+						si, &xswap_debugfs_fops);
+}
+
+static void xswap_debugfs_del(struct swap_info_struct *si)
+{
+	debugfs_remove(si->debugfs_entry);
+	si->debugfs_entry = NULL;
+}
+
+
 #endif
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -89,7 +178,6 @@ static void move_cluster(struct swap_info_struct *si,
  *
  * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
  */
-static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 atomic_t nr_real_swapfiles;
@@ -3147,6 +3235,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 
 #ifdef CONFIG_XSWAP
 	if (si->flags & SWP_XSWAP) {
+		xswap_debugfs_del(si);
 		/* Unmap all mapped clusters and free the VM_SPARSE area */
 		if (si->nr_clusters_mapped > 0)
 			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
@@ -4075,6 +4164,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		/* All mapped clusters except cluster 0 are free at the tail */
 		si->nr_free_tail = si->nr_clusters_mapped - 1;
 		mutex_init(&si->xswap_lock);
+		xswap_debugfs_add(si);
 		return 0;
 
 err_unmap:
@@ -4498,6 +4588,11 @@ static int __init swapfile_init(void)
 	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
+
+#ifdef CONFIG_XSWAP
+	xswap_debugfs_root = debugfs_create_dir("xswap", NULL);
+#endif
+
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.54.0


