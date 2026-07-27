Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 681BDC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40AF76B00A5; Mon, 27 Jul 2026 10:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1BC6B00A7; Mon, 27 Jul 2026 10:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2096B00A9; Mon, 27 Jul 2026 10:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDB876B00A5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:06:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A01FC0711
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:33 +0000 (UTC)
X-FDA: 85034731866.14.E857877
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf31.hostedemail.com (Postfix) with ESMTP id A4BF220005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mh1r5Igc;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785161191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VFSGu4QBN+hpnyuZeo9XJJjO+bFyU4xQyTIcewNSbOg=;
	b=AYKc35hjNdZrXGDlaTfHWd9ZXsmQ+0Cm+hJL3qD87yaZTYUXLqjYZczkWLXzSG5r8tEWtM
	QIOFqWEEwutpGAMb3Hfojw8OOESRGAlQCRJQkl5Py8XGdnCt9cnpJFvPKZvsIKS//CSa2M
	saciQi74FKi62ep5mwnLLRp3Wc794E8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mh1r5Igc;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785161191;
	b=faXv6TgnFZAtUqAXLpv1kT2/4V3gfOe757Q+eEmRcvXBWOrTTxsyKc9L2q406UUfNaymZL
	be8k2qVzP4w/6HYNCkoxUquloG/641xeETRIYqcrRvSJtBGxC65folaYZgfTxtl4NSoF7m
	czqezWTIOeHXIqBaXECKfCElOIZmmSg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785161190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VFSGu4QBN+hpnyuZeo9XJJjO+bFyU4xQyTIcewNSbOg=;
	b=Mh1r5Igcec+GnxgN3CUlBXSw6HXecZKAD2ykAwO91ASaXAuG60sz39RLT6bT753dU25GVe
	YDLEF6Awo70yHSfl+hcrtvdR7suPFC7VFLLpsAe9KPJQJIxmHB/J2x/DKcUXSfqwbNcZ4A
	w6KXRoF0r0Lm/plSPbL3YN2oB7YZQGg=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
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
Subject: [RFC PATCH 09/11] mm, swap: add debugfs knob for xswap per-device cluster limit
Date: Mon, 27 Jul 2026 22:05:00 +0800
Message-ID: <20260727140503.1060918-8-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-1-baoquan.he@linux.dev>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A4BF220005
X-Rspamd-Server: rspam01
X-Stat-Signature: qoe9rjpfu7af9d1sm5j6zrh8ijaro651
X-HE-Tag: 1785161191-496135
X-HE-Meta: U2FsdGVkX1+Tlne8DYtG9YG+W8Tas3lcHOMd6kj765uJE+HEZZTByWDW6Sn4/zFErEICBXq/PLKA/YSGRtyMJKEItcds0NTTGOHZ5/xYrNNc+AtfaUhY5V5hrmSJAAEcMWT1ubZLDNeUIG36lQHfjdgHISKxV6GiLKCH2pF2sEsCPV35K/bo/+t+N8xUie2P8SymNrjtrBWXRo5zO/hZdgGR5Ty6qG8VcGqSHr/bU6zJElQnaHPXB2ssgWxAmOMhg+dmQ+IzJxxUFvyRAbyG55RgOhEWJs3adyeMPhs0JIpzOrE8tkRTB6Qt+SE4sRTg3JH55hfa5QRHLuuJNwj64XXkGRUw2yTJkg1ySiJ3gMthfvP1cV+/6DQ4yI11NN2ypW7mf2l+2avWhGGpyh4lMjoOgN2sKRgvFx4askLq4V0Z3D0cUPNE+nD7TcprTzGNVAZmstOAI3qru441lagqQD4aivJ+FNtMFJqk7WV8iWK2trBVrFgaBTU2zAM8Fp8DpnmVMv/AbPwaef5vsD/WzLa8YRcGx1F7L+iHuemvSESomaxL0nwsJGRiJ1QGgIfbhTi2pVc1p8fX5g80oK9AD4YYaVOh3yNef2GRnmR+OGo3map5FK+OSGDEtSYlXOKlGWk1ubTQu1M5PhYRpYtglNZ83qFt47/RPyaQaq9JBHqCwr9j/Jt28RrZq6ooydr3gY2/No1ZpyTA0z/RBn/LnQUXLbCtNhFvF8MkknABHGdhbW5RHen68VyzX0qzw5z88gvQfmlGTzS2tDNCmF3peMOFp6gp2P+oo+6MtA8nZex1olL8qFpuUK5Fi42saq15OgwMceFnc5xtzcfxmFnlyDaPq/2kB/1+UHhCOcT/K/6yv5c4Xsf9bFHzslvqrbTJbezlnnCL0TS05OuTzD5E+vWRnZvmrPNa4tCbmY0YG12j1v5yXgrOqG/jEOOrK8vMp7+68qsBF86WDUoyZLR
 4dItcWUa
 tqt73avi2hDpf6Yl30pZ1Q225WH2qsYw5azHZ/JqAOP6YiR+vhgnjs12AiqP5qYarVPcXTQC2kEjN+AqqVx1d2Frt/W0gqRReM3ex7Alb6TOG62CtZs3NYvOfN6pNV0/4Z4qnOw0Z4t/2WStm6Z2+ow+pujIpGAst9gxWpbXeK2BrHXjF+5b5NEiwm4/kTlJq76MlNI1h58chU/rtZo+qL6Fj1253xTXt6guJ
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
index e4512aeead36..ebcd5eaa7924 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -254,6 +254,7 @@ struct swap_info_struct {
 	unsigned long		nr_clusters;	/* current growth ceiling (≤ nr_clusters_max) */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
+	struct dentry		*debugfs_entry;	/* debugfs: type<N>_max_clusters */
 #endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f57823d6449f..af62981506d3 100644
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
@@ -4048,6 +4137,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		/* All mapped clusters except cluster 0 are free at the tail */
 		si->nr_free_tail = si->nr_clusters_mapped - 1;
 
+		xswap_debugfs_add(si);
 		return 0;
 
 err_unmap:
@@ -4464,6 +4554,11 @@ static int __init swapfile_init(void)
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


