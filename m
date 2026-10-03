Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC5B3CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF14B6B009F; Fri,  2 Oct 2026 20:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1206B00A1; Fri,  2 Oct 2026 20:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE726B00A4; Fri,  2 Oct 2026 20:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B84C06B009F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:32:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51042A78E0
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:14 +0000 (UTC)
X-FDA: 85279438188.01.E945293
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf23.hostedemail.com (Postfix) with ESMTP id 713B8140005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J6hWGrl553Y1gjJcVta5gIxHjb/ViTFRKUp9DJCSIs8=;
	b=hN8XE6rZ4BhCRhr3qJQeorasHfys6L+VeclpyOJPDF10tmpBZnoibRHsimNAZr8RxN89dR
	IePakcwhe+XE2CpkQjoa74esZAUzz0W+YbPH0TiTeXaRaf6cDNh9j3R6ZS7xmVSw2CgFaN
	hJHMEmDOQSQ489Kc3qipUnPRuq6HBN0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987532;
	b=0mn0JDckHjsdkDuS5zF/k88RpN2RMtUwMwTTlU/HiexwXRP0h1vZ5yXiMXFC/LPCuux5ZV
	EzD4fJUTuhQiADETYzUNl6GZfDYL8r3bCTxQ1MYhDws4Bq/QyKKZOG5y0vs1nsPmccrPwq
	oEFlF86UtJIUNMPKCQMdMyjG86OAFvg=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6c1a1b7cb139e64f;
	Sat, 03 Oct 2026 00:32:11 +0000
X-Mizu-Trace-ID: 6c1a1b7cb139e64f
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v4 04/14] mm, swap: add sysfs create interface for xswap
Date: Sat,  3 Oct 2026 08:31:26 +0800
Message-ID: <20261003003136.750633-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 713B8140005
X-Stat-Signature: skpksnfhw136wk8kcywu6z9415koe98e
X-Rspam-User: 
X-HE-Tag: 1790987532-165491
X-HE-Meta: U2FsdGVkX18wObNUTaqbfIS+WPbOpDScjWStUGEdaCqjFcCdRiMUpU87QRmm5tbtYc2Y3+a2R/GBHTD0yuSm6T5RyDDOJ8dxY/pSViKOdMPaLeHcj5e4Tf0IOOOe9Ss+uwTNT8YUHE03oWoE/d9PgfuA4X8BQZPe7+NwE5z1IkvQ1Dowrr3IdzQ5Dgt4zcYEvgN1DC5wPCAiYqNwnxWUcilQqLbHq/RW9aAU2ovU4HFNiHhJNnoliJtfWcRNARVbSl45XeygGk0xf2OM2sXo0MU4hafa1Q5qAk4+BUhZ5XaGTAAQYX6euDpDTOO/FX4a6Wd3axK45Uws27p6LMPDpDGtIgHvWM20Ezb9HdAJYS/Wz0Gg5zPkfmx7P3c9mNzD4OrcqaMMcCgtRrelpUqXWadaYpKvrq12nuR0PXrG9fAwQySr24eEqsB9ep0J+yTJXFFkVnIYPJ924pBE1gq5ldYRWMbQoWTxw60aAeOcQbAuL8jMDnOdijyaBVsXVLbdX3ZKq4k1UX8Oa0NxRjkPuBC4XLelPEQbeVqvTq5xvBd0InYT0dWvEPLiT0yBzdVpqBRk7x41oZzlBPCIDpKmD7skkuE8FSxqLhbyiPTKAQ4BG2i8XllodLWpH83OTyVeW0LoybIG9Q1qTkXNaNkhx5QGvbjK4DOy2LKj8Eeqtq2y86TXH8vif+uC5NCVogtzvh+hyis3xOT9DcoYt4zsjM7tSQxK7tquONl6R/k2Gkm7XREJZAmebpCHPqrHDu56pye2BWO8L3xsObqaXhC1fs8EvwcM85EzXWyYQSAxwGqCVuKbqOxiUmPKwzpS47JL1C5JLHraqtAJfy2VIzkttSSY0gWoSYd+9vvA2s2Kvpvsa2OyisRaajwM3HhGUvlKcHw4yTzKqEYB+Vz+B0X68TLu4T0QUa7pHxrWMPAMcuYDzK0JRe+0pVkBwbJPkm86P1DOc31+7n2dX4JMgZF
 DEAEZwe2
 NTflOvS870jSpLSw3MmBrvBRANzSwEtEHwcM+xWLxRpuWdfq2OdKPfaqtw7flTd8ZTbn12/JEYbA+TjuDDJlv2arbbpSk+vHo6Dm8fqtF7tRKzmA3ffZmFvPWfXbywCgbN01V+njukM5jkxvUqJ7ChOzpuZKAtMLxrMdtCUnq/xIEeEqdObjXmRB/CVU6EvB8hEqeinK92EFulgTiaEp5JiWYc8WHV+eFZ1qal9aLNS/ofz1uYrCkxTQg30nHSVR2MaBdLpu31e8LFU525D2Q7AN8ng7tOkM4F5Z11MNFC4YUetA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap devices have no backing storage, so there is no file to swapon.
Add a sysfs interface to create them directly:

  /sys/kernel/mm/xswap/create    write an optional priority to create
                                 a device, empty for the default

A new device is created with si->max and nr_clusters_max both equal to
twice RAM: the cluster_info array is a sparse VM_SPARSE area mapped
lazily, so an idle device costs nothing. The device shows up in
/proc/swaps as "xswap<N>".

It takes the highest priority by default. Swapout picks the
highest-priority device that has room, so a real device ahead of an xswap
one would take the page directly: zswap would still cache it, but the
slot on the real device is taken either way, and not taking it is the
point of xswap. A lower priority can be asked for, not a higher one.

Hibernation device discovery skips xswap devices: they have no bdev
to carry a resume image.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 169 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 164 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 767d3f46877f..9c204e455ef9 100644
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
@@ -48,6 +50,13 @@
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+#define DEF_SWAP_PRIO  -1
+
+/*
+ * Above every real swap device: one ahead of xswap would take the page
+ * directly, and taking that slot is what xswap exists to avoid.
+ */
+#define DEF_XSWAP_PRIO	SWAP_FLAG_PRIO_MASK
 
 #ifdef CONFIG_XSWAP
 /*
@@ -66,7 +75,65 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
-#endif
+
+static int xswap_create(int prio);
+
+static ssize_t xswap_create_store(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int prio = DEF_XSWAP_PRIO;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* "[<prio>]" is optional; a lower one is allowed, not a higher. */
+	if (*skip_spaces(buf)) {
+		err = kstrtoint(buf, 10, &prio);
+		if (err)
+			return err;
+	}
+
+	err = xswap_create(prio);
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
+	if (sysfs_create_group(xswap_kobj, &xswap_attr_group)) {
+		pr_err("xswap: failed to create sysfs group\n");
+		kobject_put(xswap_kobj);
+		xswap_kobj = NULL;
+	}
+}
+#else /* !CONFIG_XSWAP */
+static inline void xswap_sysfs_init(void)
+{
+}
+#endif /* CONFIG_XSWAP */
 
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
@@ -94,7 +161,6 @@ atomic_t nr_real_swapfiles;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -2275,6 +2341,9 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* xswap has no bdev to match a resume device */
+		if (sis->flags & SWP_XSWAP)
+			continue;
 
 		if (device == sis->bdev->bd_dev) {
 			struct swap_extent *se = first_se(sis);
@@ -2462,6 +2531,8 @@ int find_first_swap(dev_t *device)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		if (sis->flags & SWP_XSWAP)
+			continue;
 		*device = sis->bdev->bd_dev;
 		spin_unlock(&swap_lock);
 		return type;
@@ -3425,7 +3496,8 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 		return SEQ_START_TOKEN;
 
 	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!si->swap_file &&
+		    !((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK)))
 			continue;
 		if (!--l)
 			return si;
@@ -3446,7 +3518,8 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!si->swap_file &&
+		    !((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK)))
 			continue;
 		return si;
 	}
@@ -3488,7 +3561,14 @@ static int swap_show(struct seq_file *swap, void *v)
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
@@ -4011,6 +4091,83 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	return err;
 }
 
+#ifdef CONFIG_XSWAP
+/* Create a file-less xswap device, sized at twice RAM. */
+static int xswap_create(int prio)
+{
+	struct swap_info_struct *si;
+	unsigned long ram, maxpages;
+	int error;
+
+	if (prio != DEF_XSWAP_PRIO &&
+	    (prio < 0 || prio > SWAP_FLAG_PRIO_MASK))
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
+	maxpages = min_t(unsigned long, ram * 2, swapfile_maximum_size);
+	/* si->max is an unsigned int: don't overflow it. */
+	if (maxpages > UINT_MAX)
+		maxpages = UINT_MAX;
+	/* Cluster-aligned, so no cluster holds a slot past si->max. */
+	if (maxpages > SWAPFILE_CLUSTER)
+		maxpages = rounddown(maxpages, SWAPFILE_CLUSTER);
+	if (maxpages < 2)
+		maxpages = 2;
+
+	si->bdev = NULL;
+	si->flags |= SWP_XSWAP | SWP_SOLIDSTATE;
+	si->max = maxpages;
+	si->pages = maxpages - 1;
+	/*
+	 * No backing file: setup_swap_extents() is only reachable from the
+	 * file-backed swapon() path, so set ops here.  Only ops->flags is
+	 * used, by may_enter_fs(); the IO methods are never called because
+	 * swap_writeout()/swap_read_folio() short circuit xswap.
+	 */
+	si->ops = &swap_bdev_ops;
+
+	error = setup_swap_clusters_info(si, NULL, maxpages);
+	if (error)
+		goto bad_swap;
+
+	error = zswap_swapon(si->type, si->max);
+	if (error)
+		goto bad_swap;
+
+	mutex_lock(&swapon_mutex);
+	si->prio = prio;
+	si->list.prio = -si->prio;
+	si->avail_list.prio = -si->prio;
+	/* si->swap_file stays NULL: this is a file-less device */
+	enable_swap_info(si);
+	pr_info("xswap: adding extendable swap type %d (prio %d, %u pages, max %lu)\n",
+		si->type, prio, si->pages, maxpages);
+	mutex_unlock(&swapon_mutex);
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
+#endif /* CONFIG_XSWAP */
+
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *si;
@@ -4357,6 +4514,8 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	xswap_sysfs_init();
+
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.54.0


