Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2C6606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NNUubsk1
Received: by kanga.kvack.org (Postfix)
	id 9D27F6B05C4; Mon,  9 Nov 2026 00:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB636B05C5; Mon,  9 Nov 2026 00:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFD66B05C6; Mon,  9 Nov 2026 00:56:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65BE46B05C4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:56:24 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1376405CF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:23 +0000 (UTC)
X-FDA: 85414520646.21.08E1D6C
Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	by imf01.hostedemail.com (Postfix) with ESMTP id E623740002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NNUubsk1;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203782;
	b=Ovh2usZs4kLGVCNVtMlIG+eTNEukJ7ioMZMKDnkBqIwqoOyvBJoGyd985/B0ldmbWkrdjB
	CdAM0yXI0jrHPvpa64nMeT8HVad9acJ6Pm1qQWgOkbqpadHgKBNt9sDSXrMSNuAjl37Yz1
	VcLHzJ8w2+nrYwyjNEZ6aTw2ruz1IbA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NNUubsk1;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dbJudx54IJdpQu2cr4+SphwgIU5JWBQZBI+ztPJly8=;
	b=XJscQx7qVB34Q+EvLmEVN39kpK7rOrVTzDyuUwlQx+Z7WiW+8+X5+xPGTzDrASI9lSJ+Tv
	W7+4t+/deYtyvTdIMRvjC/ZZmMt1bCgW/VR2FKubtuzZ6U1VJL8b3mc9qyCZ5x5dkoWJT6
	aVM7FxPqzgWh7R7jLHpW9f3z3U2r6xU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Vh+7s22EVTn0GGu5H5c88rcKYKb8CNWqRRtsh7RPBFI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203778; v=1; x=1794808578;
 b=NNUubsk1yzn4g6RkyrANA+bi6dWQTJ9RsyfqYMMGfA+aTDYrXVpc/AkIHYJmrl5mCI75t1g1
 oL7VFv8AF4GkdFG9jFNwlqn0sQ61eBslSYMxnZA0R1BV1m4tNHHatv8CozY60Z+sDzcmYD9Iuns
 QLcfnAMXQLCOio+rGPYR4Wyc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 627cd75057c981bd;
	Mon, 09 Nov 2026 05:56:18 +0000
X-Mizu-Trace-ID: 627cd75057c981bd
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 06/19] mm, swap: add a sysfs interface to create xswap devices
Date: Mon,  9 Nov 2026 13:54:42 +0800
Message-ID: <20261109055455.536925-7-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E623740002
X-Stat-Signature: 74qqam5cmog88k6nbhse6csiqw936o3i
X-Rspam-User: 
X-HE-Tag: 1794203781-802244
X-HE-Meta: U2FsdGVkX1/I8trkzk77cGyZg+II6Ht8/jV78Q6piAbrh1JcMbvvkKg/AGosUHzCG6hfm53gyZ4XVw3zAFsOf0mmqdaQ2/nkc6wMJ38+kVS7wr25IfduUR2HHdPtdk8EzxawRC2hzjXWCa9i+emlx4bToL7kN9B8NpshoL3khWdX9NV1LGKt9+VQQGv8/ymFEkUGgzddUa0kuZZdhaBRNvdqkM+MIfck7aLCQSefEZY/0NcWBDZKgU4kPR2GJUV5bK4egmuTVBxAk/vjqfv+T1ahBxo02GqtkQlLQlUJETn7chP2x7LqC5yuUHkdyT5QFYtYxdCySV/g0U8iccC0/sjMIDVvl8E+VkIXo2/8ZEoCIuR/pyO0sDCoQu1zdj3ACgKkDhKa8xO3qrcGrgaWk5T928mw8my7IxBePWNcAA56SJA8LlLSAvQ3Kv7V/QwhI8QT5OFP1AZbEs+e71NPEDf2szczVUnZyta9Sp8O+gIDbNnYZ86+eVyUN7/Ard0uL9Nih6on5LzNY7YQ/IVdV7OmCUKsP06ylXr+R3HS9Ws7csKY/fPnnjwi08hTN70u2wolO9l4bcfOyflt8OQZp9Q8xDLaw84to3WTjnYukZfPKJ1nUzNexwCr3zkPI4fwl65ByEPGxVj1bX/WLyN40t4kFLO7mDwHcFO6kDsvT2oPHsVgAske/kRVICG8ubJ3Xu5HpZCGBD0suIADpApPkN7sqbZFU7fcnzHLYsmEdnzIESF2TK6NK73+nVhMwWL5uAMitjM0phcfd6rGDQn6cvzhTD7G+BAmxRh3z/vmCdLM+uto1stnM0zDfJD0+w2j5bwC+rkiZHILyjjdb7GHXYZkqkg6pPW1TfqbHLOiYgOajIvbrM4zR3sNmp0zBOcV5uL41pa0Ik2wMkHXEEd8zI3ufogW4Te8JuHdOmEoS4vzTC0tBJvbCAoHu4oV/nOfIdkrBx4R2zVx3mwYvgO
 jHtksj2v
 3ONd5DQmbDICTcQNd4/0b9ya3jwBhNggGv1tua/sxej1CfN/zRlmHekv0YAZ+oWoe4Ls7+3ukv8PqyFyhQR1JDde5D/x+KyVc35TQmOlQX+HUgkEqcle31gE/xXV7hCqwZsoe5DRaiMkmP+v9swyPQ3FwPqT3Vx2wVYTJDzjRDgdYgN0toBvIr02zBEq4bUBoCZH78q1SYfzJUH0GzNSpo0r8zWSoR3JnVIb5PiofghB1NifpW3qcbiMFpzlKLJ+NXd4y61Opgs5fy9flcVb9rAKPTb6KEklwZPRhJQMhMcfblLfrEh9/9VIXWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

An xswap device has no backing file, so it cannot be created with
swapon.  Add a sysfs interface to create one directly:

  /sys/kernel/mm/xswap/create

Write an optional priority to this file. Write nothing to use the
default priority. By default the device gets the highest priority.

A new device gets si->max and nr_clusters_max equal to twice RAM.
The cluster_info array is a VM_SPARSE area and is mapped lazily.  At
this point only the first XSWAP_GROW_CLUSTERS chunk is mapped; the
grow trigger comes in a later patch.  The device is shown in
/proc/swaps as "xswap<N>".

Hibernation device discovery skips xswap devices because they have no
bdev to store a resume image.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 175 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 170 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 83aaf00b75d3..616adbb298e7 100644
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
@@ -48,6 +50,15 @@
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+#define DEF_SWAP_PRIO  -1
+
+/*
+ * The highest priority a real swap device can use: one ahead of xswap
+ * would take the page directly, and taking that slot is what xswap
+ * exists to avoid.  At equal priority the list is FIFO, so a real device
+ * that asks for this priority too and is added first wins.
+ */
+#define DEF_XSWAP_PRIO	SWAP_FLAG_PRIO_MASK
 
 #ifdef CONFIG_XSWAP
 /*
@@ -73,7 +84,67 @@ static int xswap_map_clusters(struct swap_info_struct *si,
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
+	const char *p;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* "[<prio>]" is optional; a lower one is allowed, not a higher. */
+	p = skip_spaces(buf);
+	if (*p && *p != '\n') {
+		err = kstrtoint(p, 10, &prio);
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
@@ -101,7 +172,6 @@ atomic_t nr_real_swapfiles;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -2284,6 +2354,9 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* xswap has no bdev to match a resume device */
+		if (sis->flags & SWP_XSWAP)
+			continue;
 
 		if (device == sis->bdev->bd_dev) {
 			struct swap_extent *se = first_se(sis);
@@ -2471,6 +2544,8 @@ int find_first_swap(dev_t *device)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		if (sis->flags & SWP_XSWAP)
+			continue;
 		*device = sis->bdev->bd_dev;
 		spin_unlock(&swap_lock);
 		return type;
@@ -3452,7 +3527,8 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 		return SEQ_START_TOKEN;
 
 	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!si->swap_file &&
+		    !((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK)))
 			continue;
 		if (!--l)
 			return si;
@@ -3473,7 +3549,8 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!si->swap_file &&
+		    !((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK)))
 			continue;
 		return si;
 	}
@@ -3515,7 +3592,14 @@ static int swap_show(struct seq_file *swap, void *v)
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
@@ -4026,6 +4110,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		return 0;
 
 err_unmap:
+		/* swap_cluster_setup_bad_slot() allocates cluster 0's table. */
+		swap_cluster_free_table(&si->cluster_info[0]);
 		xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
 err_free_vm:
 		free_vm_area(si->cluster_vm);
@@ -4108,6 +4194,83 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
+	/* A cluster index is an unsigned int, so cap the cluster count. */
+	if (maxpages / SWAPFILE_CLUSTER > UINT_MAX)
+		maxpages = (unsigned long)UINT_MAX * SWAPFILE_CLUSTER;
+	/* Cluster-aligned, so no cluster holds a slot past si->max. */
+	if (maxpages > SWAPFILE_CLUSTER)
+		maxpages = rounddown(maxpages, SWAPFILE_CLUSTER);
+	if (maxpages < 2)
+		maxpages = 2;
+
+	si->bdev = NULL;
+	si->swap_file = NULL;
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
+	enable_swap_info(si);
+	pr_info("xswap: adding extendable swap type %d (prio %d, %lu pages)\n",
+		si->type, prio, si->pages);
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
@@ -4454,6 +4617,8 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	xswap_sysfs_init();
+
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.54.0


