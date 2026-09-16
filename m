Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB240C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B038C6B009D; Wed, 16 Sep 2026 06:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB41F6B009E; Wed, 16 Sep 2026 06:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CA096B009F; Wed, 16 Sep 2026 06:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7F86B009D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:20:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D6301406B4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:20:29 +0000 (UTC)
X-FDA: 85219230978.20.F9994D8
Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	by imf17.hostedemail.com (Postfix) with ESMTP id 78D2E40006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:20:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554027;
	b=SAEnfFZW1cYqW60i6hgz8xPh+7Dtw4teLZUOgtcW0ozWwsuk2AhcUWk1w7DUgd7C+bx1r+
	yfTL1u2rcfXe/8deV6FJcddnlCNasUmaaBB09WuAeMW2bb+EDhmitbTZajFCy4OhuKxgYP
	1rgE3wCHGoW2GG+CGkVTyJRKolOQKkg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j1H3cPIi+AUA0cjAy1OUAjQO32KHxIrFzhotMqLwy9k=;
	b=32hGB/egmskFBU+gpllyZnYiubtXDvdchHgRjHYD5sQFyt7vyfyz2ZuBK+rwQBZVasoPKE
	VbbVLuD6VSAfULBBcpZIu+foEndWXp1wBa0hUxzxbQ/pJ9kuqlK/9YhBtZ9C99kmZvJ6DO
	YiytlEFZlMdTEGNRu19XWL16xwWaUOE=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 702b54a055381590;
	Wed, 16 Sep 2026 10:20:11 +0000
X-Mizu-Trace-ID: 702b54a055381590
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
Subject: [PATCH v3 05/14] mm, swap: add sysfs create interface for xswap
Date: Wed, 16 Sep 2026 18:19:12 +0800
Message-ID: <20260916101929.149106-6-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 78D2E40006
X-Rspam-User: 
X-Stat-Signature: th4waenweuiakjc8sg61pf8jpnwkp8tj
X-HE-Tag: 1789554027-304528
X-HE-Meta: U2FsdGVkX18bn6/xzeclGfbKKndRy/gJe0eS7IrvdCryC1rN6I8TeHGAv3fafeCpYalIRQgzKu0y/1VQC6FSueSy/t06MBH7xIWfZ4aMEO7XfjVC9H/dNn38roPXw5+kNsADRvk4a898wfyY6z0YaGRvy2EMGjJ8mNDJ3qjUEclXJjeOvoAYW19Svia1toG5DcfXmHQo8JmKxO9a6wHvzW7NUB6lCggQq3xXHOza1QfqVPeG5fxPnrI/LlNuaX0pqkKiwViu0zeO4xP993VdZaHA2O6ArC93gcp5vEoWEo12QqE2hy7pOMPfOQJ7y1d5ErtRVKXUOVN2nkdiyqEUX3pbeNLiYXsfaYHNfg5OEni6UmYkCQsrfmwvvT2DWpL/qwWUxcAzuu/MRfzf066ZA99mc6he++fY2B5iZA0h307st9n/RiqDaoER5jRPOM//7nQiwQHsAKVEs748vVBuye0BLxxqaz7YELpnSJ2/1n75NjWnwbDnbG7rqRMdh+tOLPUdRFrJ+NdH9YJrwdZn0vL+yi7RH4Yo9e37xtVJgX83xaG6ZN6jXlqvrgv6j7I0GZr57jiYGi5jrfoNasSJDTI1ff4FAeFwAUHjGI65ck4mSBNok34fbEI3cuq+AiBNPjAbyVQmJacjobjZWe7ESRREnXxsjFwraS60jEGfTEieLttrECZRLaAaSCW6U03cjQB3lGh4Tk0u3BBouHr4/I+JhXL71SjCvZsVDhQlBU+RDCykr55BwigwZaFSCLgLC7hUSJzA0OpqTAPiL5NRQYHVWuK3cSqhCE47SlLgFv877FQzcE1j16ZQT2tIh5VXcn6NN+yBBUH7BARnD5beY7a5VqdE9Vhi54q3EKLDEohUx+m0Fa1hkVlVUrFIG/+qF0rmTJuBbmXxyg9iNlLSllb/LdHXonnDlx5QQtSrCX4686D6qFzYgck8ZIuvZ+I0XU7iHzGXNTmg694l9Y9
 kQElII1e
 65Yhd9Tp42ZQe1jFnav4CkvcdMtJquRa7HLdqUtux6eA7iQPV6s+24zLJaHBXTq7vKblpZr63Hu8lV1MpGS0VmwhRb7IBFWVxHaFaYPXuRG0tvLajbcv2YlQcN9lwue/Avvdo3m5TXsojmsMJsUB3PpIP9r8hg0BFp2Z89KsrbSM3p7Z4Q8pMhZCjxE+0SfOIQ6NxD37mF30WC4ZwTQk02S9hY45jygFXiFMoLA7317DWHjWqnteDKAdV8dbMwqcV7GxIlatQJNq5uN+gJR/ylEhPR2tcczeVT1JefglnlefjgZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap devices have no backing storage, so there is no file to swapon.
Add a sysfs interface to create them directly:
  /sys/kernel/mm/xswap/create    write an optional priority to create
                                 a device (empty = DEF_SWAP_PRIO)

A new device is created with si->max and nr_clusters_max both equal to
twice RAM: the cluster_info array is a sparse VM_SPARSE area mapped
lazily, so an idle device costs nothing. The runtime size can be
lowered per device afterwards via
/sys/kernel/mm/xswap/type<N>/limit (added later in this series).
The optional priority follows swapon(2)'s -p semantics (default
DEF_SWAP_PRIO, valid range -1..SWAP_FLAG_PRIO_MASK). The device shows
up in /proc/swaps as "xswap<N>".

Hibernation device discovery skips xswap devices: they have no bdev
to carry a resume image.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 163 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 158 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index dac5e0db0e94..b0edf5421fc5 100644
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
@@ -48,6 +50,7 @@
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+#define DEF_SWAP_PRIO  -1
 
 #ifdef CONFIG_XSWAP
 /*
@@ -66,7 +69,64 @@ static int xswap_map_clusters(struct swap_info_struct *si,
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
+	int prio = DEF_SWAP_PRIO;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* "[<prio>]" is optional; empty means DEF_SWAP_PRIO, i.e. the same
+	 * default as swapon(2) without SWAP_FLAG_PREFER.
+	 */
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
+	if (sysfs_create_group(xswap_kobj, &xswap_attr_group))
+		pr_err("xswap: failed to create sysfs group\n");
+}
+#else /* !CONFIG_XSWAP */
+static inline void xswap_sysfs_init(void)
+{
+}
+#endif /* CONFIG_XSWAP */
 
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
@@ -94,7 +154,6 @@ atomic_t nr_real_swapfiles;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -2275,6 +2334,9 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* xswap has no bdev to match a resume device */
+		if (sis->flags & SWP_XSWAP)
+			continue;
 
 		if (device == sis->bdev->bd_dev) {
 			struct swap_extent *se = first_se(sis);
@@ -2462,6 +2524,8 @@ int find_first_swap(dev_t *device)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		if (sis->flags & SWP_XSWAP)
+			continue;
 		*device = sis->bdev->bd_dev;
 		spin_unlock(&swap_lock);
 		return type;
@@ -3423,7 +3487,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 		return SEQ_START_TOKEN;
 
 	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->swap_file) && !(si->flags & SWP_XSWAP))
 			continue;
 		if (!--l)
 			return si;
@@ -3444,7 +3508,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->swap_file) && !(si->flags & SWP_XSWAP))
 			continue;
 		return si;
 	}
@@ -3486,7 +3550,14 @@ static int swap_show(struct seq_file *swap, void *v)
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
@@ -4034,6 +4105,86 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	return err;
 }
 
+#ifdef CONFIG_XSWAP
+/* Create a file-less xswap device.  si->max and the initial nr_clusters
+ * ceiling are both twice RAM; the runtime size can be lowered afterwards
+ * via /sys/kernel/mm/xswap/type<N>/limit.
+ */
+static int xswap_create(int prio)
+{
+	struct swap_info_struct *si;
+	unsigned long ram, maxpages;
+	int error;
+
+	if (prio != DEF_SWAP_PRIO && (prio < 0 || prio > SWAP_FLAG_PRIO_MASK))
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
+	mutex_unlock(&swapon_mutex);
+
+	pr_info("xswap: adding extendable swap type %d (prio %d, %u pages, max %lu)\n",
+		si->type, prio, si->pages, maxpages);
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
@@ -4380,6 +4531,8 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	xswap_sysfs_init();
+
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.54.0


