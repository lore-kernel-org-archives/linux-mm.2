Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A74C5C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A116B009E; Sun, 13 Sep 2026 03:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C674A6B009F; Sun, 13 Sep 2026 03:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77C96B00A0; Sun, 13 Sep 2026 03:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE3A6B009E
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:50:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F4CDC05EB
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:52 +0000 (UTC)
X-FDA: 85207967544.17.A3ED8CC
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	by imf12.hostedemail.com (Postfix) with ESMTP id 41DDC40003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285850;
	b=4zaBQY2aDxjq5t9SZxzkBUxaVwDp41k7GAMmjtFKY8VIENDM0zFl8FBk1Gk/TkPlkqsPvB
	bx3wZ46nMGPzBmAb1odfIfzeDH2/mFkv19/d1H/XT7ToxoqpPaexlR46QoaFPyq2v1/2CU
	ni/4k6ZMcYN1UWQXu7+1kXdxuRkZe3U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K/mkRtMge03ZE0IlcFGyVbXsik3YgcFeAV3ZXT6dqt8=;
	b=xMPHTYrsptbqr3UTR2PZcrCmSKI1p29/6IOc/ElaRzGbvdOfuWoPGJQ0p5uRXdl2RV+gbx
	Uj5nUTEzy+0oQR3nOZ+qIr0+DU/Yq+CHAMQ2QZSB+d7GaHlrxQP6lwLUq7b7Kq2wOQQn3F
	bybTBg2B101Y1bLauFXlPeni/erIfQY=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a3aade24c9dce5ce;
	Sun, 13 Sep 2026 07:50:48 +0000
X-Mizu-Trace-ID: a3aade24c9dce5ce
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
Subject: [PATCH v2 05/12] mm, swap: add sysfs create interface for xswap
Date: Sun, 13 Sep 2026 15:50:07 +0800
Message-ID: <20260913075014.1732524-6-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
References: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41DDC40003
X-Stat-Signature: ermwwyyzg6j1fz45hnjdokiptwc4uzas
X-HE-Tag: 1789285850-541528
X-HE-Meta: U2FsdGVkX1949Mid9Nxn9bjT3+RFAbJ4dgyVAmY4LwA0Z6EqanhY3zFf9kj+EI0aRjGX/88OXjF1A3oBQjgKBkIFAGINfsLX3kfYEpJJoIAaWVzxs00aiHgTAMRwxPE6J4JfbMXafTuTIVy9PWhGyuZBYrdPJyqSdlw8tO3BpGypq2/tbW/c8aAcK8VSrjN85orE37/dcErx+QT1KoiAkrKYEcYsxxaG9RUqUHAtg05Zz0zM0oyqkL7/K1nG3Axhn8hkBjWtLWzK7o4fRG5JY6yeoXC5d28SoDQBJedPAA0mdcmPKTNvMXavYnumT0oYkJJTuu3U0sqmvcKJ+hyORWzOJY9D0VPNaJupLBMya6fwOka7c1rYnvlqfmC+hKAXzal8go+suDeBGEM7b5TfF+0kM+AyTZAuQ/Gh9YrDpFp9EgNpuvBttnegFCNL4ZrN9kIzLvoqUnAjt0xYfZ4MKBGxFNQTGXIampAxU0sHP4leT56TklfbBBIriSof/ApOv7pDCR4jW/ix6bHWzVNY2KJdO754JYXnCMip68wnToEFg69bCUyYPR0M7bxWZeCcXa3pnC5SMhJ1TJDpMGL7F3/+MlEFmdnMmGBFM6qHkFTElJGU0HarlWz0qofk3GFOT557G27fs9DmgModn7UWsEf0zR3UphgynVIIF1bmkOmlgHjjmhDObsoqM8lRfleq+vKrJ5SXz0EXfLBcLc5dmNQ2dbBiRcl5bno6pBET1E9+A1aqoA/vR46VyLAZZhX7Emixio6Wc50aj/0KxZMpLa9hN+5otRrJlTm+RfLuaECxhAAgHBP2UlVEkEz/XBvkfSeLXjttGAVL0DiLo0ZFhFaug7NEuotWYYKZCJlpByZeJRXvdrusNzqDdQrmsycj5ccGi/vL4A6S2J7757VMlHlliY8yQ64M2dj3VAqOo3/5+uPVoW0Z3k0vXp5VVyl3jpG1QJ/5H+kjyT5B5u9
 MgK0njjZ
 Jflq6pQC29uZ+bxHIbmlrPK2nNTwAA+hjTwVbvCFKzl/7mJYFOh2e0j3dnhEXgu4VII9OOI9OkCw60XURwjHbR42UVPyryKxN/ELqFVyrOcnnWwkzYdiprniLew3NpJNCH6ob8XF4W2h/aZUeAfmZSK9hDpvzJfgFdf/HqMWLUhJdVIJKrI0DKpmwgtXTRBYFw8EfpcuxfnBcplTpeYQJt6b4YriocJ4axX4P
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
full RAM: the cluster_info array is a sparse VM_SPARSE area mapped
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
 mm/swapfile.c | 165 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 160 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5140b3f846b2..4861e2d49e36 100644
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
@@ -66,7 +69,70 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
-#endif
+
+#ifdef CONFIG_SYSFS
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
@@ -94,7 +160,6 @@ atomic_t nr_real_swapfiles;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -2255,6 +2320,9 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* xswap has no bdev to match a resume device */
+		if (sis->flags & SWP_XSWAP)
+			continue;
 
 		if (device == sis->bdev->bd_dev) {
 			struct swap_extent *se = first_se(sis);
@@ -2381,6 +2449,8 @@ int find_first_swap(dev_t *device)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		if (sis->flags & SWP_XSWAP)
+			continue;
 		*device = sis->bdev->bd_dev;
 		spin_unlock(&swap_lock);
 		return type;
@@ -3313,7 +3383,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 		return SEQ_START_TOKEN;
 
 	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->swap_file) && !(si->flags & SWP_XSWAP))
 			continue;
 		if (!--l)
 			return si;
@@ -3334,7 +3404,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->swap_file) && !(si->flags & SWP_XSWAP))
 			continue;
 		return si;
 	}
@@ -3376,7 +3446,14 @@ static int swap_show(struct seq_file *swap, void *v)
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
@@ -3926,6 +4003,82 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	return err;
 }
 
+#ifdef CONFIG_XSWAP
+#ifdef CONFIG_SYSFS
+/* Create a file-less xswap device.  si->max and the initial nr_clusters
+ * ceiling both equal full RAM; the runtime size can be lowered afterwards
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
+	maxpages = min_t(unsigned long, ram, swapfile_maximum_size);
+	if ((unsigned int)maxpages == 0)
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
+	/* no backing file: mirror the xswap branch of setup_swap_extents() */
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
+#endif /* CONFIG_SYSFS */
+#endif /* CONFIG_XSWAP */
+
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *si;
@@ -4269,6 +4422,8 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	xswap_sysfs_init();
+
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.54.0


