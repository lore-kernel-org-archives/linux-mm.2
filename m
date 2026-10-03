Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D737ACA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFF26B00A7; Fri,  2 Oct 2026 20:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F3E6B00B5; Fri,  2 Oct 2026 20:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95B76B00AD; Fri,  2 Oct 2026 20:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF4F6B009B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:33:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EBB4C08B2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:33:13 +0000 (UTC)
X-FDA: 85279440666.14.A486D13
Received: from mta1.migadu.com (out-216.mta1.migadu.com [95.215.58.216])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D10940004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:33:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.216 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9JWYIo7GkUWz/x2BJfJuENmtjS7cl8ZMbgjV6/J42Qw=;
	b=aAubVBdYFEDPje5B4EyrUyfbPlVHs19T9/+OiqAsAdjQVdOPpfRthyqu5y+bTUyzg0T19e
	b9GWqbYXiL/nV57twTZCV3pQWD0thZugNAORWnZeQJdKc4WHW99VB3ND4OJwa/AFO5cF7c
	XnEjDlUV/FYfDGb6/9lmP1yG3fobATo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.216 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987591;
	b=o793KLoukbIYOR01XLYOx3P3/EQhXEPmrRqEWq9vM4SyziOhGgXqsQkiGt7DaNO9tIdzc2
	ONdjfvaSqJ4xnhqhGqvxTPsuj7h8K/+VU2lRvAKtke9lqz6Ex+giNETY8AHYjRTXRaPs2H
	Km7xUlRLc7lRUurZW5ucP37evwxm3fo=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3b95ecdd6348a054;
	Sat, 03 Oct 2026 00:33:10 +0000
X-Mizu-Trace-ID: 3b95ecdd6348a054
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
Subject: [PATCH v4 12/14] mm, swap: widen swap_info_struct max/pages to unsigned long
Date: Sat,  3 Oct 2026 08:31:34 +0800
Message-ID: <20261003003136.750633-13-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2D10940004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: eifte34k6jpeeftzsxs8um49f9bt9tug
X-HE-Tag: 1790987590-995578
X-HE-Meta: U2FsdGVkX1+m7i8uxSMA1wgm+Mow9ag44rPeQKUsFwyAWCNQLFCCmSEE2aCPhgrfNLNyzRsREDaCXjedOjyDRzCEBXX/6uhirhCGuq/zFJzfskqFDJL2QzjEGBFIXnwI7REdvDRgjudUEwrSzRQrlrdZMfj1y/u6/Gp8Gp6YnKU85qkwwf2jcE8pqe3gVLgYXloTLUxRhBHFQPIbdj5T7+q9wdXWY9VKXpU3XYjKhM/QUfUyjI0y08jhlI4Jg0FGr5C7WARgrnnutNzcQ1jaqfSpqY3TQZZIBvtkb+Q+gKUUQI8Ub4QBsYuNEDysLpuxEYk3rq9nLRaxmpmjHFfT3+sEHyKirXrM7XeJfs5uvq7OxiuM0IJFLUaP9fNxcWf96bdHKz1VdSPFn41vkgqm6lH8q4V36RISuu+6M05VBPrkbckGrCAhqU791m1QSpDwdHPtao4o8JHz3vpjKwcgOtJajC4Jel6qYvD/v3VfPKHOKgXRbCor6YHx5lJHZPiVe4V/ahGLygZpKQxI6pAiS1tSj6NbVJvYhtGbNhGUq3x313bkE6q4i2QzG6om2cLV0/1glvqe9CmcwuoGsfNNSDcMpxOTAlmqlScYCaFZO87zerYbosX5YUZFJedgKSobbw6qQGo6oAvoddmaPA4KqC5qWSBJ5BCLiLvVTvpEYvZOAP8pD1lZKnc4Do7Snat2/cBBs4ttIspYOxTSt4ZTBmVsd9qPBecJBC8eFfBBbUY9L/D+d3T3lo+rmgjSo/G7BXYdkuL0QD1UJfEYOwRxeyeqqIBryLVIpwbEyTDaoFvUX8y5xOZwQ82kV8IJ0rvG/29Pbf/h8sECb1CxjHBP0HXmHV9DuPvKdKlSSiJkOc6kKNPdw/3V1Eyw8DWIwszQGwrr8oTPdz5f5Sul1gpWgosXw2556dUjCJ6s83e2rNxdXHvYl3I0D6X1Kk5wORlBqqjPOriOkrxgg7cw9+E
 WLk0E/wa
 FkLYWISElvaNYIJ2kQXGJSkR02KRTDdL8aMdd8Av6IuYxdp3Qp7y4JWxREotDtVT8d9yBLUckBioztnPQAGebNnFJZqnERP+CnYuiWj5d+iyU9bIQzpwqQsOgCZSerSguQ6zIQed/9JGXx53md2hEJwcsim9d5Ae1uEiW2NBbSTpxOFzeB51w9xv1SZTPxjzgf+9DfpttS2gbEvyIWZwGus3N4L6pi1kRZpEfdr5Vm5EHZi/iLm5+IbTjMtpfaWa0M5YmEBxNrxgyZ0wF5wDeYhpJZAe2xeUBiLL+5/vQ/oKLA2a9/AbfqX277cIQEZ1uN1Wdp8Jzl2nFZIcmDtIjTqxscg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

si->max and si->pages are unsigned int. This limits a swap device to
16 TB with 4 KB pages. read_swap_header() need to clamp the size to that
limit, and xswap_create() has the same clamp.

Change both fields to unsigned long. The clamp in read_swap_header() is
removed. The clamp in xswap_create() becomes a limit on the number of
clusters instead: a cluster index is an unsigned int, so the device can
hold at most UINT_MAX clusters. swapfile_maximum_size still limits how
much a swap area can address.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  4 ++--
 mm/swapfile.c        | 57 +++++++++++++++++++++-----------------------
 2 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 12cdc00f78f9..c56adbbcfd3b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -240,7 +240,7 @@ struct swap_info_struct {
 	signed short	prio;		/* swap priority of this type */
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
-	unsigned int	max;		/* size of this swap device */
+	unsigned long	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
 #ifdef CONFIG_XSWAP
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for cluster_info */
@@ -255,7 +255,7 @@ struct swap_info_struct {
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
-	unsigned int pages;		/* total of usable pages of swap */
+	unsigned long pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
 	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 818b5a147b73..f823cebb7937 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -541,10 +541,10 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
 	return ci - si->cluster_info;
 }
 
-static inline unsigned int cluster_offset(struct swap_info_struct *si,
-					  struct swap_cluster_info *ci)
+static inline unsigned long cluster_offset(struct swap_info_struct *si,
+					   struct swap_cluster_info *ci)
 {
-	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
+	return (unsigned long)cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
 static void swap_cluster_free_table_folio_rcu_cb(struct rcu_head *head)
@@ -948,7 +948,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
-		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		pr_debug("Ignoring bad slot %u (max: %lu)\n", offset, si->max);
 		return 0;
 	}
 	/*
@@ -1114,11 +1114,12 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 }
 
 /* Try use a new cluster for current CPU and allocate from it. */
-static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
-					    struct swap_cluster_info *ci,
-					    struct folio *folio, unsigned long offset)
+static unsigned long alloc_swap_scan_cluster(struct swap_info_struct *si,
+					     struct swap_cluster_info *ci,
+					     struct folio *folio,
+					     unsigned long offset)
 {
-	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned long end = start + SWAPFILE_CLUSTER;
@@ -1169,12 +1170,12 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	return found;
 }
 
-static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
-					 struct list_head *list,
-					 struct folio *folio,
-					 bool scan_all)
+static unsigned long alloc_swap_scan_list(struct swap_info_struct *si,
+					  struct list_head *list,
+					  struct folio *folio,
+					  bool scan_all)
 {
-	unsigned int found = SWAP_ENTRY_INVALID;
+	unsigned long found = SWAP_ENTRY_INVALID;
 
 	do {
 		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
@@ -1261,7 +1262,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 {
 	struct swap_cluster_info *ci;
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
-	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
 	 * Swapfile is not block device so unable
@@ -1556,7 +1557,7 @@ static bool swap_alloc_fast(struct folio *folio, bool may_zswap)
 	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
-	unsigned int offset;
+	unsigned long offset;
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
@@ -3010,8 +3011,8 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
  * Return 0 if there are no inuse entries after prev till end of
  * the map.
  */
-static unsigned int find_next_to_unuse(struct swap_info_struct *si,
-					unsigned int prev)
+static unsigned long find_next_to_unuse(struct swap_info_struct *si,
+					unsigned long prev)
 {
 	struct swap_cluster_info *ci;
 	unsigned long i, cluster_end, end;
@@ -3081,7 +3082,7 @@ static int try_to_unuse(unsigned int type)
 	struct swap_info_struct *si = swap_info[type];
 	struct folio *folio;
 	swp_entry_t entry;
-	unsigned int i;
+	unsigned long i;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
@@ -3950,12 +3951,8 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 		pr_warn("Truncating oversized swap area, only using %luk out of %luk\n",
 			K(maxpages), K(last_page));
 	}
-	if (maxpages > last_page) {
+	if (maxpages > last_page)
 		maxpages = last_page + 1;
-		/* p->max is an unsigned int: don't overflow it */
-		if ((unsigned int)maxpages == 0)
-			maxpages = UINT_MAX;
-	}
 
 	if (!maxpages)
 		return 0;
@@ -4550,9 +4547,9 @@ static int xswap_create(int prio)
 
 	ram = totalram_pages();
 	maxpages = min_t(unsigned long, ram * 2, swapfile_maximum_size);
-	/* si->max is an unsigned int: don't overflow it. */
-	if (maxpages > UINT_MAX)
-		maxpages = UINT_MAX;
+	/* A cluster index is an unsigned int, so cap the cluster count. */
+	if (maxpages / SWAPFILE_CLUSTER > UINT_MAX)
+		maxpages = (unsigned long)UINT_MAX * SWAPFILE_CLUSTER;
 	/* Cluster-aligned, so no cluster holds a slot past si->max. */
 	if (maxpages > SWAPFILE_CLUSTER)
 		maxpages = rounddown(maxpages, SWAPFILE_CLUSTER);
@@ -4585,8 +4582,8 @@ static int xswap_create(int prio)
 	si->avail_list.prio = -si->prio;
 	/* si->swap_file stays NULL: this is a file-less device */
 	enable_swap_info(si);
-	pr_info("xswap: adding extendable swap type %d (prio %d, %u pages, max %lu)\n",
-		si->type, prio, si->pages, maxpages);
+	pr_info("xswap: adding extendable swap type %d (prio %d, %lu pages)\n",
+		si->type, prio, si->pages);
 	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
@@ -4739,7 +4736,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 	if (si->pages != si->max - 1) {
-		pr_err("swap:%u != (max:%u - 1)\n", si->pages, si->max);
+		pr_err("swap:%lu != (max:%lu - 1)\n", si->pages, si->max);
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
@@ -4830,7 +4827,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
 
-	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
+	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
 		K((unsigned long long)span),
 		(si->flags & SWP_SOLIDSTATE) ? "SS" : "",
-- 
2.54.0


