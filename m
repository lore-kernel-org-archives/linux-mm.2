Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C39BA606A334
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hd4Pz3nn
Received: by kanga.kvack.org (Postfix)
	id C12F26B05B9; Sun, 22 Nov 2026 07:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA1C6B05BA; Sun, 22 Nov 2026 07:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD93D6B05BB; Sun, 22 Nov 2026 07:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86FB06B05B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:40:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51CB91A06A6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:28 +0000 (UTC)
X-FDA: 85462713336.07.3DE4E05
Received: from mta1.migadu.com (out-127.mta1.migadu.com [95.215.58.127])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B4B6C0006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hd4Pz3nn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.127 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351226;
	b=VH7TlkLCQXs9W43wkxfdxn8NiKAuOh80SPmsEEg5aC2Or1flb8LHr7pFWZBHoO3z/gTxHo
	XGiCsRxy8WUZz/ThWm8MX+kltU+uC1ytNNPMpKXGoAgqNZ/rJzXzSmdezVCjgMa7lbvto5
	KmQ5yKYpFaFts5edA6xHwXFDSl0HAJY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmuX2nULtaCu0DlZk7+Ehu05Yz7Br28oRANfAi7CAao=;
	b=J7ZGbp+KT6oJdCtORh2sOkbQdWCWuf1dsLbcJHB7sthrMYUdFWlpipE5s2IYl8LppGWJVs
	oD/4NTKK2mzcQ7GEUEjd8T8jr0AD6HA18FVKmI9zau1cmlVxPphUrvVzYjAL0U2mpl7S1m
	J/26xvqBZIpGqcrRtZ2WPpUpayeAu0E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hd4Pz3nn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.127 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mJoRwEwPu4sOHEs8+cS+QIvfYy4EQvodVZryXdseOYo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351224; v=1; x=1795956024;
 b=hd4Pz3nnudngEg9N77zKOJgEc02KxYjV9MS5vZaXTNM4m11Hh3N4eJVOWN2kaPzn58hHnz9i
 Jb6iUoL7EAOtGFbbVxC9OJL8HB1YqOWuoFA3eCS1ZCsTBK/xWGe4He2/sA/k6Tf/apdNvbsiMpt
 /YEuhB8X8IMlEs4OzL6JCOjc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 93b88276732dad48;
	Sun, 22 Nov 2026 12:40:24 +0000
X-Mizu-Trace-ID: 93b88276732dad48
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 06/14] mm, swap: create the xswap device from swapon(2)
Date: Sun, 22 Nov 2026 20:39:10 +0800
Message-ID: <20261122123918.3486916-7-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122123918.3486916-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x4s8xtmipb53tjw1c8s67pphtrqmb1tc
X-Rspamd-Queue-Id: 4B4B6C0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795351226-990624
X-HE-Meta: U2FsdGVkX19vmfP2cH/Es2OML56G8ZzR+E/ZKMJmTj1rmLbC1NyW4YecGGT9RT7vwOl51Sy5jYEoZJG/xRTFbMZSN7bH4oqnCEsE4PBYPv9vYbvlTCxCkKK0DhHHa+Cwrobo1y5/dJtkvGG1GbsAvMsj0rg96zwtf7e0gz5KPoa3px0Lc1ExrBzlo6dQl3/9XrGZHsv8ILtHd0OxnUl59qKYihWi5qMYACPrfcSAG133wYJ50mm0Rw/zJjpJYHrPEIVf0bG4mdVlQDVudsIOurz+risLKiFps0b4Fg5uCqt0pF+PzkZ7/cxupcnOTHF4kaEJ1NmAHtrMvlrk0XqM4wANg+Rz7xhwzQ7ej7L8sj5uBqrsfzTS1qynvqFKbysG0MQVtsTqzWSyQnihboSysTEikGDLDCy0BdDCmJRvRZ5k7UY96C5MRzEJtSdKWnQZzIDMuJDbKerer9pecl+3oFo75vZH5UPmoVEUWsxeukqPYxIVIxbZboRSW2o+lGykzn/u3XHLOlaTF3wjJE1gSb2/RktZ/uh5/H4TcIWaP14RVH9n2Y9YWZoT71beJvrTahl1bPRVKcCz2D1KF08mPr/iIW03S9wu5nka5hdd/T0uIWm9ZhY+tkCl+f/ZOiMj9N1U5Yzx37zrO7kExHxrb3BJSL2gwfNz+6ncfOy4TOYUWvdCnDzZbmgdXar9Fsxe51aLjGsYg37Uy8dUMixuXLiFJWsJWdvaiHFhmzJyiLMokdw52fHxQqiZIqQkIjHLS/oPAfj8AmSOPbiBgG8wE1rmmZcZqvUmYRfMsoK49MUyyFnTFgM+TeHjFeGI45iHLxOF69ZAFcJerOINbGXvqP5LHtXeHYHANPR4FOsTICrrUjIXasURmxTPqIzA8/c+VZYRSpv98x2Aufh/qgCfcNWqZRYmJbratj5uo8wofEEMFCo1Xu6kBPdmRoVvdH6o5PcAyxwLa3xzcx6KCh0
 FZ+yLXtz
 uxfDsV10CT0XMyOfmkoAkCntG/wyCIdQb5882ykqX/+ZoKFn4Ut9B4RnjJce40XOdwVvR5GZdU514p/zBVoRNtGmmYflldYTtqndmaa6xvSmSl0vy1+jXN9GIMUaDdk9kbOjWE2CQydDDDgHqPO0+K9oXvCDGTTHaWq7hj404t/udNZhf6KiWQCA0lDgoi+l7dpgAt1wvNx3hhVB8ToMVVIEjy2GK1pCYK+Mojj0wT7RxATXTpp3jJoUKrJ3z6n9hyeuV5SjGtro/qwPWTqN7kARrBZ652ruwfjQ2o3gR9q+dI2CEo81oIkFVn+XIgU6t1+9rRucFhivL2cSPWqhvLPHiobVjvzg6hNm/FUeKOYu02UfUsg++54dfYnAy7rvlmL7kubuKFwj0Fdz3NmSFcpClgxqi3UN1p6zz3uA9y5G4ulx2HoEEJdliDA/EK9RqavONFfXL+paWcNZ7nCfIhBuyrUYH6b9XVBR7tVO+mue/JnHdP0yFhD0qbyfGEtqPOJKL5J8cYTs6tm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

An xswap device has no backing file, so it has no path for swapon(2) to
open, and it needs a way to be activated.  Give swapon(2) a name that
says exactly that:

	swapon("xswap", SWAP_FLAG_PREFER | prio);

The name is not a path: swapon(2) opens specialfile the usual way first
and falls back to the device only when that fails with -ENOENT.  A file
or directory called "xswap" therefore keeps precedence, and only the
exact string matches, so "./xswap" and absolute paths are files as
usual.  This is the same rule swapoff(2) uses.  There is no separate
flag and no second way to create it.

The call is still an activation: it takes a priority, it fails with
-EBUSY when the device exists, and /proc/swaps shows it as the fixed
"xswap" next to the real devices.  Discard flags are rejected: there is
no storage to discard.

The device is sized at twice RAM, and its cluster array is mapped
lazily, so only the part that is used costs memory.

Hibernation device discovery skips xswap devices: there is no bdev to
store a resume image.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   1 -
 mm/swapfile.c        | 187 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 172 insertions(+), 16 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6747b577c405..02c3861a336d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -21,7 +21,6 @@
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
 #define SWAP_FLAG_DISCARD_ONCE	0x20000 /* discard swap area at swapon-time */
 #define SWAP_FLAG_DISCARD_PAGES 0x40000 /* discard page-clusters after use */
-
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
 				 SWAP_FLAG_DISCARD_PAGES)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 912cfa68ba01..4e598ab8da65 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -48,6 +48,16 @@
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+#define DEF_SWAP_PRIO  -1
+
+/*
+ * Highest priority: xswap must take the page before a real device does.
+ * At equal priority the list is FIFO, so an earlier real device wins.
+ */
+#define DEF_XSWAP_PRIO	SWAP_FLAG_PRIO_MASK
+
+/* File-less, so /proc/swaps shows this name; swapoff -a passes it back. */
+#define XSWAP_NAME	"xswap"
 
 #ifdef CONFIG_XSWAP
 /*
@@ -56,7 +66,18 @@
  */
 #define XSWAP_GROW_CLUSTERS \
 	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
-#endif
+
+static int xswap_create(int prio);
+static int xswap_create_by_name(const char *name, int swap_flags);
+
+/* Serializes create and destroy: at most one xswap device exists. */
+static DEFINE_MUTEX(xswap_ctl_lock);
+#else /* !CONFIG_XSWAP */
+static inline int xswap_create_by_name(const char *name, int swap_flags)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_XSWAP */
 
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
@@ -84,7 +105,6 @@ atomic_t nr_real_swapfiles;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -2334,6 +2354,9 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* xswap has no bdev to match a resume device */
+		if (sis->flags & SWP_XSWAP)
+			continue;
 
 		if (device == sis->bdev->bd_dev) {
 			struct swap_extent *se = first_se(sis);
@@ -2521,6 +2544,8 @@ int find_first_swap(dev_t *device)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		if (sis->flags & SWP_XSWAP)
+			continue;
 		*device = sis->bdev->bd_dev;
 		spin_unlock(&swap_lock);
 		return type;
@@ -3497,7 +3522,8 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 		return SEQ_START_TOKEN;
 
 	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!si->swap_file &&
+		    !((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK)))
 			continue;
 		if (!--l)
 			return si;
@@ -3518,7 +3544,8 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!si->swap_file &&
+		    !((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK)))
 			continue;
 		return si;
 	}
@@ -3560,7 +3587,13 @@ static int swap_show(struct seq_file *swap, void *v)
 	inuse = K(swap_usage_in_pages(si));
 
 	file = si->swap_file;
-	len = seq_file_path(swap, file, " \t\n\\");
+	if (file) {
+		len = seq_file_path(swap, file, " \t\n\\");
+	} else {
+		/* The file-less xswap device; one per system. */
+		len = strlen(XSWAP_NAME);
+		seq_puts(swap, XSWAP_NAME);
+	}
 	seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
 			len < 40 ? 40 - len : 1, " ",
 			swap_type_str(si),
@@ -3874,7 +3907,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		/* xswap: only cluster 0 slot 0 is bad */
 		err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
 		if (err)
-			goto err_free_vm;
+			goto err_unmap;
 
 		INIT_LIST_HEAD(&si->free_clusters);
 		INIT_LIST_HEAD(&si->full_clusters);
@@ -3903,6 +3936,9 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 		return 0;
 
+err_unmap:
+		/* swap_cluster_setup_bad_slot() allocates cluster 0's table. */
+		swap_cluster_free_table(&si->cluster_info[0]);
 err_free_vm:
 		vfree(si->cluster_info);
 		si->cluster_vm = NULL;
@@ -3985,6 +4021,117 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	return err;
 }
 
+#ifdef CONFIG_XSWAP
+/*
+ * Create the file-less xswap device, sized at twice RAM.  Called from
+ * swapon(2) with SWAP_FLAG_XSWAP; there is at most one device per system.
+ */
+static int xswap_create(int prio)
+{
+	struct swap_info_struct *si;
+	unsigned long ram, maxpages;
+	unsigned int type;
+	int error;
+
+	mutex_lock(&xswap_ctl_lock);
+
+	spin_lock(&swap_lock);
+	for (type = 0; type < nr_swapfiles; type++) {
+		struct swap_info_struct *q = swap_info[type];
+
+		if (q && (q->flags & SWP_XSWAP)) {
+			spin_unlock(&swap_lock);
+			error = -EBUSY;
+			goto out;
+		}
+	}
+	spin_unlock(&swap_lock);
+
+	si = alloc_swap_info();
+	if (IS_ERR(si)) {
+		error = PTR_ERR(si);
+		goto out;
+	}
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
+	 * setup_swap_extents() is file-only, so set ops here; only
+	 * ops->flags is used, and the IO methods are never called.
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
+	pr_info("xswap: adding extendable swap device %s (prio %d, %lu pages)\n",
+		XSWAP_NAME, prio, si->pages);
+	mutex_unlock(&swapon_mutex);
+	atomic_inc(&proc_poll_event);
+	wake_up_interruptible(&proc_poll_wait);
+
+	error = 0;
+out:
+	mutex_unlock(&xswap_ctl_lock);
+	return error;
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
+	goto out;
+}
+
+/* A name, not a path: only -ENOENT from opening it gets here. */
+static int xswap_create_by_name(const char *name, int swap_flags)
+{
+	int prio = DEF_XSWAP_PRIO;
+
+	if (strcmp(name, XSWAP_NAME))
+		return -ENOENT;
+
+	if (swap_flags & (SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE |
+			  SWAP_FLAG_DISCARD_PAGES))
+		return -EINVAL;
+	if (swap_flags & SWAP_FLAG_PREFER)
+		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
+
+	return xswap_create(prio);
+}
+#endif /* CONFIG_XSWAP */
+
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *si;
@@ -4007,26 +4154,36 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	CLASS(filename, name)(specialfile);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	swap_file = file_open_name(name, O_RDWR | O_LARGEFILE | O_EXCL, 0);
+	if (IS_ERR(swap_file)) {
+		error = PTR_ERR(swap_file);
+		/*
+		 * Only -ENOENT is the request name; a file of that name
+		 * keeps precedence, as it does for swapoff.
+		 */
+		if (error == -ENOENT)
+			return xswap_create_by_name(name->name, swap_flags);
+		return error;
+	}
+
 	/*
 	 * Allocate or reuse existing !SWP_USED swap_info. The returned
 	 * si will stay in a dying status, so nothing will access its content
 	 * until enable_swap_info resurrects its percpu ref and expose it.
 	 */
 	si = alloc_swap_info();
-	if (IS_ERR(si))
+	if (IS_ERR(si)) {
+		filp_close(swap_file, NULL);
 		return PTR_ERR(si);
+	}
 
 	INIT_WORK(&si->discard_work, swap_discard_work);
 	INIT_WORK(&si->reclaim_work, swap_reclaim_work);
 
-	CLASS(filename, name)(specialfile);
-	swap_file = file_open_name(name, O_RDWR | O_LARGEFILE | O_EXCL, 0);
-	if (IS_ERR(swap_file)) {
-		error = PTR_ERR(swap_file);
-		swap_file = NULL;
-		goto bad_swap;
-	}
-
 	mapping = swap_file->f_mapping;
 	dentry = swap_file->f_path.dentry;
 	inode = mapping->host;
-- 
2.54.0


