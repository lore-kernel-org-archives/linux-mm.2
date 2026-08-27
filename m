Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78691C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856FD6B00A1; Thu, 27 Aug 2026 05:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D0A6B00A2; Thu, 27 Aug 2026 05:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C2E6B00A3; Thu, 27 Aug 2026 05:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4340D6B00A1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:45:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB4EC14039C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:47 +0000 (UTC)
X-FDA: 85146567534.11.EEA527A
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0B78A0002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823946;
	b=3lt/RGmYAnpHCZyxZPGlsTfwnmskv9wircPMHOhVrVXOm0AXPmPVakRAGgG611zilew49j
	zd3Y1HIIKRvi2uStQkTFQagdVmJ5MlQozE2GTj6cxbKjhpvDjyFVb1EDwWHAyFnga+bmdw
	qa8POyq1qJ8yMKFHg1l0YuJYUOXAtGQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H7h+El96CoYTVkoMxKyyNzgGk8GTLACXph/tsfZq1Jk=;
	b=eI9cC5ZJ31yiapM16y8pgrNmIWFO/EsRL/CEJvTtKzy08fiKJyEhJ0x6Ggq9GqzwvzXIQS
	PpStiyccIBJzbdTQUwpHfho9plWZVu0xgIgPGIb528GRSD+BIpsc/GF8d5bMuC4POElB6l
	LKfV0+OSp5I0EeSxKVHc91gcLPYKVuU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id fe1cfcd6d97b5eae;
	Thu, 27 Aug 2026 09:45:44 +0000
X-Mizu-Trace-ID: fe1cfcd6d97b5eae
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
Subject: [PATCH 06/16] mm, swap: add sysfs create interface for xswap
Date: Thu, 27 Aug 2026 17:44:56 +0800
Message-ID: <20260827094509.1016740-7-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0B78A0002
X-Stat-Signature: wa6jhc5ksdhtmq1ttc1j6prjycdutjsj
X-HE-Tag: 1787823945-193629
X-HE-Meta: U2FsdGVkX1/CO0RysNLaqu31UdgP2rFsM468KzcuPcMjRhzTNbbiXFy857gOxC46py6JyhK0aii9j4MUUkv9krn8eKJSbiS1GpO0E8zCLoxYGAVVbmSKp/zQNlLhKXlnmDMUWrrkfr5UzFDQQ0Jy6uHncd7PLZZqf1tR4tKV7LXyiLIEz4GwoMIGRSvxUVW42O4dtiYKD0sNU3VKAEaAe/yMhfptAJ/BpQ2y4FpaxlU6ApJ3IOr2pVF3pCIUPnLe4AuDINhLWO5zyn/d2abFNpWOUFb9YGHj0GbKXi7pok4y23nodwZV2WarQN7S7LQNZIcueZdTxQx/p0lqevtZ8lhTdbB8EG5VTn46rLBW5nIa8SJmJTB7oz2Lnb1nGUdhSf3sTlPfR3sEbLlS92739vlP3zvOuAYbbbXHOgXDLEbdAX5NJ5exg9jffTuveE1Dib2nFZqSDSTVMcbg9vyqcO6By9fXSZeGDA4SE9k+Y3+ASqJ1dxHSdffIup2DWbTyVCvRmaOTlJdEAaS/tn7NyfLV41yusJ2UhdwZd0+5k25IRuFVGKBMLR8z/7+WAT1ZA68Zl5kXm5Qv/n48fq2oUElDVcgJNGXyXBDcEgLn7/X5qJK/O4jdpDFQSf48m+AETD+PcqY3AeU2iLukQeQQ8ztKpCPU7+BFU+OZvaXLZn2hFMC+q/9hmqZKx7uoR6JoI89rpT826axutw+xvRN8UrUhINsw8ISj5oO4v/3fTUL+6mBIbyE7tIB5PxDnsO3A0uxuCUAUBIYaNLLJcKF9iSWgbT1PQRU+fJqvKz4kd+mxM6Yw0y7SJywJfP/IThvhCttbGLmmqcD4vQLoHsicdK1bpn113HC4pSL/OXrDL8uPMpHefZHqOvFvxoGdLtRoBzYDtOVV9+TsSLv3g5h/8MZmbfHRsLHXyQ/8StSIPKi+Tm9+iRQynmuXhhsZWPWJ3BDNgopVv2bbyC45osR
 +wi8gJhq
 BREgxB8RgG38elCh6awxeWrTEEyyoaQun8f8lktO/u+Yi+D2FmEk4H76jZPCUpa5ugkhQNCu7t5wUZJuEQayfZXXvfA32Jm2zP2ZlBQsiUS8DTPaYl6mIqzjQxqM41BgXbzjgelwFkRVxi5R/DMry0P+S9im/IiQBWv/H/oBvP4xoigVGQ890k9zPAaMJW+MKsyDvONs9V3cG+OYTCRkXsrsTKMKveZ+XD963
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
index 06f73c0a504a..1127e3d6596b 100644
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
@@ -3312,7 +3380,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 		return SEQ_START_TOKEN;
 
 	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->swap_file) && !(si->flags & SWP_XSWAP))
 			continue;
 		if (!--l)
 			return si;
@@ -3333,7 +3401,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->swap_file) && !(si->flags & SWP_XSWAP))
 			continue;
 		return si;
 	}
@@ -3375,7 +3443,14 @@ static int swap_show(struct seq_file *swap, void *v)
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
@@ -3897,6 +3972,86 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
@@ -4240,6 +4395,8 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	xswap_sysfs_init();
+
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.54.0


