Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56DF3C61DCB
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E68B6B00AB; Thu, 27 Aug 2026 05:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BDF16B00AC; Thu, 27 Aug 2026 05:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FAD26B00AD; Thu, 27 Aug 2026 05:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18DBE6B00AB
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:46:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79243C037F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:31 +0000 (UTC)
X-FDA: 85146569382.12.3EAEFBD
Received: from mta1.migadu.com (out-162.mta1.migadu.com [95.215.58.162])
	by imf26.hostedemail.com (Postfix) with ESMTP id 79D2A14000F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nP+s6MHWnHtGC6GQUaPlSXfnePs77XbWBS/kc7Yj6zw=;
	b=F55crm1hkNk+fzJIKTqKLD0EN2PN5DrLVLIgIqSSoQ2N9z7/rCvRuDA7uYtpMq1s3ma0ni
	hfnyTXERtphPj83x3PI970yjSYSnM/uQxQDaqh7SjT2xBTIgujRizbH56Ly4yv0B196k38
	rKjFf7HP9ausdmWyGAf3u+c9IrCpsPc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823989;
	b=ePn5iESgdq4CMtxo03Yd6TE8E8be1AOKglgObqufINdilXE0ipTSM2rqtCH5YNrC0td1i2
	QUD49HTeS+mcMlocSgWfm7BD9BYSi/KGleoH9oDxcokCdplDhkGkQgxke8wgaPId6jRGY+
	Iaz9lhFq93LMmCWjYqrJnJjbsdQ8AkY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c2b175c1ae2981f2;
	Thu, 27 Aug 2026 09:46:28 +0000
X-Mizu-Trace-ID: c2b175c1ae2981f2
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
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 12/16] mm, swap: add debugfs knob for xswap per-device cluster limit
Date: Thu, 27 Aug 2026 17:45:02 +0800
Message-ID: <20260827094509.1016740-13-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 79D2A14000F
X-Stat-Signature: qrj3bd4w5iuqh15ghjgh1pup5su1wg5b
X-HE-Tag: 1787823989-148295
X-HE-Meta: U2FsdGVkX1+qX7POq3g2dzNMBP4Wuay3PpVs58cXCWzJo1Ldm3yzJxsAahi+ulXTKnImn7o5/pGABItLVCzqv1hhWNI4HrBe0Y7f0ACl41yKmUwK5Nay/jrb56mT/odCXG00wMFpMdbqO9zjwTTI7Amc1orweriMMnrse9Q2UIGnIwlHaCRaUtHRWeW6GNTojwhWw/4H8u+hTGzZ0zrt1QCaIdS6mo2aLz1wn14Kj012vvcBADtXSC4I0sU77XZlRQEgknM+U+KkH/hgORlOGXR1RPQC+C8oxXqJlW0j3MFkukm4Ii46zpvO0SJuujI2+JJjSDrM2V6pMTRgx6mHHObWUfgyOTf/MbekYmlNQEXnKFBOV16Yqk12fB7CWRI2XmPbffVSOms2e1yRdzr3NaDvR3NgCVCBG1jxTdU/xjWzsiT50Bm0jl6qeor9yt6Y0dut6PycHx2WCtaLsq/FQERXoAdpKHPSjgImLZ4E5HzdEv7SP06M8LugX4uHF5uilkGXIMUFayCWjib0i0RT+kjBgV8pOoduw+hG1GbLD7eIIwWf+m25E7qp+9Tle7EyIz6umRB+sjTysJIlb7EuvHAvS9i5Xq5hHljbuCU+75H5witCeVZmLCTkdSk7JbqI3S3IEOhsj67H7Fh6Fcy323412jelx/iJkNY/iQAjIVHwuubxPsIQOUl+VlDbowjxxP60BD8WIEf8ZvfaNDhxvTG/T5uVqRe9GdFlwzLAQyp4ri/LDtvA2TInhIXYIgPC1yhX6NHZe+Idh7MLc+qGMHr9qkfhH1EaBla0ruxt4SF/z6zftf+FYraUWomZawFkRPOTMttjwBbLdQmnvcn4MYNEUf+sCfXZHRmjVMn9YJyGRqmAC8X9Nl2K+kW3O5aazE+1B28ShEBVLjonZfSCQqcgeWZheed0Btu1nE78RWsJqS4v4QoppuMpBTJAZPAzJyybtO7bKI6hfYN2WpQ
 y3cmKqGu
 1pMQKwzkUtelCKE/6+2Jhb4hSbKb8OcnXvuv4YPGA0cFwcZ/+sAtqx6lmWHxBsQej+WueYVIaZ4od2O5wy6O3NI1TArXXM5YvKvdN/NxTdpimeZPYMsJMx3PtVdqhuLyhpNTQB3mBF7FwR94Pi7AKdjMB33YhvuhPPK+9N4teSVezvKK3g7JEm14JIYEBWnfCxjEQ9W4VYejRHu/aSAit4y9Wm1h3zfKhicTDiOJWgUEw0nf9ZA2BY3zpHQ==
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

The debugfs entry is created on device creation and removed on
destruction.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 92 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index c55af4a95ef7..5e50486103b9 100644
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
index b2c3bb21f082..6916a8b3f63b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -50,6 +50,9 @@
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+#include <linux/debugfs.h>
+
+static DEFINE_SPINLOCK(swap_lock);
 
 #ifdef CONFIG_XSWAP
 /*
@@ -66,6 +69,8 @@
 	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
 #define XSWAP_DEFAULT_CLUSTER_PERCENT 30
 
+static struct dentry *xswap_debugfs_root;
+
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr);
 static void xswap_unmap_clusters(struct swap_info_struct *si,
@@ -76,6 +81,83 @@ static void xswap_update_free_tail(struct swap_info_struct *si,
 				    unsigned long freed_idx);
 static void xswap_try_shrink(struct swap_info_struct *si);
 
+/*
+ * debugfs read/write for per-device max cluster count.
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
+	/* Lowering the ceiling may free tail clusters. */
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
 #ifdef CONFIG_SYSFS
 static int xswap_create(int percent);
 /* /sys/kernel/mm/xswap/: create.
@@ -156,7 +238,6 @@ static void move_cluster(struct swap_info_struct *si,
  *
  * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
  */
-static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 atomic_t nr_real_swapfiles;
@@ -3230,6 +3311,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 
 #ifdef CONFIG_XSWAP
 	if (si->flags & SWP_XSWAP) {
+		xswap_debugfs_del(si);
 		/* Unmap all mapped clusters and free the VM_SPARSE area */
 		if (si->nr_clusters_mapped > 0)
 			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
@@ -4118,6 +4200,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 		/* All mapped clusters except cluster 0 are free at the tail */
 		si->nr_free_tail = si->nr_clusters_mapped - 1;
+		xswap_debugfs_add(si);
 		return 0;
 
 err_unmap:
@@ -4245,8 +4328,8 @@ static int xswap_create(int percent)
 	/* VM_SPARSE covers full RAM; runtime nr_clusters starts at percent. */
 	init_clusters = div_u64((u64)maxpages * percent, 100 * SWAPFILE_CLUSTER);
 	init_clusters = max_t(unsigned long, init_clusters, XSWAP_GROW_CLUSTERS);
-	if (init_clusters > si->nr_clusters)
-		init_clusters = si->nr_clusters;
+	if (init_clusters > si->nr_clusters_max)
+		init_clusters = si->nr_clusters_max;
 	si->nr_clusters = init_clusters;
 	si->pages = min_t(unsigned long, init_clusters * SWAPFILE_CLUSTER, si->max) - 1;
 
@@ -4624,6 +4707,9 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+#ifdef CONFIG_XSWAP
+	xswap_debugfs_root = debugfs_create_dir("xswap", NULL);
+#endif
 	xswap_sysfs_init();
 
 	return 0;
-- 
2.54.0


