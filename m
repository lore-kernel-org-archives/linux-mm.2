Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C556606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KjCLR5VU
Received: by kanga.kvack.org (Postfix)
	id 97A826B05B7; Sun, 22 Nov 2026 07:40:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951A36B05B8; Sun, 22 Nov 2026 07:40:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88EA86B05B9; Sun, 22 Nov 2026 07:40:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1976B05B7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:40:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E43BD1A06AB
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:22 +0000 (UTC)
X-FDA: 85462713084.28.DC92F68
Received: from mta1.migadu.com (out-122.mta1.migadu.com [95.215.58.122])
	by imf14.hostedemail.com (Postfix) with ESMTP id DB322100005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KjCLR5VU;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351221;
	b=HrXOWImX8yIw2kNadAxx2WwPUdZ/CJQFR/G0rlTUn/KWR/H4oNYzVMJMdFX0JVXew58LIZ
	Y0AVJE2HsGRLxKCx3dR6OFpR5zD8GZBTeqZzcJjsVUQEmy9lkh3H1vw/jWRc02Uv++1ZiV
	8pJk7XNX2aJ6iY4ZUm/tMndnyIRhSeo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jicttz2Tug0UUdMEWKxEL9xaUFc72lSiLZb3dvi//0=;
	b=rJAy7RHrkMeXa9qrjdKFu5HR9BZeJogaxlirXqe/x+Y+acdHvZunCQTlfVClVHrW3IT2Az
	XunnM9RIRcsbaCYH+rHvOTEGbEIumDSKlMpfLXfZeKT95ydi1LWQXWG55DO+STM5DHGk+r
	NRt3K8EoFiOkOWnRwB0KxCXQ5DIQeFA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KjCLR5VU;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lU3NtvInReBUN7t36yriG8+GIjDSPYq4yW2yNxHwl2Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351216; v=1; x=1795956016;
 b=KjCLR5VUwoWxhajszSKANwqbbv+jaPN0+Msk8YmRIzfggMZ3uQfKV9lVXX712l8F1Up2ztxQ
 +vdXZ7u6LKUDfYFK3XMLA4rCqJsI04fi5aBtR3T63PCrlwQlW1dZuzFotFwuIXohqKkd5G26xAC
 pcvuTTaNG5BTWg+2oDwOghAk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 4c85a421546913a1;
	Sun, 22 Nov 2026 12:40:15 +0000
X-Mizu-Trace-ID: 4c85a421546913a1
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
Subject: [PATCH v6 05/14] mm, swap: widen swap_info_struct max/pages to unsigned long
Date: Sun, 22 Nov 2026 20:39:09 +0800
Message-ID: <20261122123918.3486916-6-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122123918.3486916-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: DB322100005
X-Stat-Signature: s6unm5nntre8o9eo9nzujes8ihx59hfm
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795351220-918833
X-HE-Meta: U2FsdGVkX1+e3ouYTQ3jfw92R0Xjze1rc5HenRY5ILJHyxU0t7wZjC+EfvlEHaYEzao5V1AQpsRd3g4/XRW1FEbj5buJ6SDhxyZCvUM17FezUZJx7NQvxDVDrhS8eB+livoEw/uemGNpoLx+PwDaE5Tdny/1LeZ+CWaawikjENpZuaHMqA0CXW3tBB10A9o5HAicsiNcZ+KnwM5MPLZF73LKocEkmPb87nui8w5W8qHsWvaERWyeZ2OMLH1ojNWvg02gF1+qatGiPJE0AZz+MtoByE8HnaMv5G+mvUc5BA4fqq6veVGPLA+zhZFPkxRcr++P4XOPrBaDdsdX5rclkmBD4lmvsaEBuKJzXxtkO0JcUgZQdT4Emu5OYIpUUswsee333le21/Np8y+7NSpDGxbeeWAR6UT1bgPWKBRLBveNkfdoJ3+DBAGNXa+BogsWwF3bdQukE/mklv5Iui1mcWbzH2LJpfsWu1ZOSS41sFZBGmmAUTrjvCbcv7lvQQB56AiQIsxBqOzOL9OJpUlkwnj0s95Hld/FStq4mNlQFfXmrF95tCHI3HUnxCr/JllV1p/GiLYde0DV5OM3gkm9/rk3Kxv+IF6pZexlM8eri1g5HrbXX//1ZKAxEVcC+Yk07OsC/4WXwHw/kKqmHzRMdiXFAEhLCFrT+K6uCvhp+Wc5yRx9DYIFMzptn+X84EKoOsj4sXtDjkKde3w8a8AVe/rXUIK9goIeQdVNcyefEHFnWv4ZLiWUIr4gywWTbTJZ4RkurKKihLsct65Hv1zDo2FDFGPKFWCXZHGBExchhX+6Wlaaiz/4dfD+Q1/BDQhgKdjzIlAjcEhpH82DGY+yh6J2hYahgzGqgpNkzYyaDPj0s5A2sHKZqDiOxuDbhBNnpcC/MbLZDJWfRBDCr6DNp0l1uvwCyFWIYERz+sejWgUxlu3jpKrc8MyB+J7Erp+qmTIjyfJ1JO0mysIiTE2
 IJ8ORYpZ
 HKB547/4XY9Eqt8kLyCm5anXJ2KFrYWkxDnJkIYRU5kGX+kG5qgbqVcD1Lkh7/ZUzY9oVp6ymBhIFmwMP/X7TlHmcqarhU6n6okLY0eexjYVabU8bo6ccjKtMFm22z6PZP4ntMkwmRgAK5P+sDPcuPqmqpIkiv97tRyPNWuwZXPG8NzqZ9xZ4c742s7Hnxy73sizhv4aiHe3mhAfMjAD+Ed6sp1V+37jPF4qlbotwnwL2QVzVLAnVAiBi/PbFb1Cq1p71WcrOg0NUcLtHcCJXx8Cd5nT14H28LzVMCIvCzWrCPI5g/4xJd96YZffBKMTaa2WZ0f5KE1yyAV/r8vBHnTWz4XXxCPE0F/6f/Ds8RUR/gZ87tsnrNBhTdWq3chGKh9dJcEY8gpAkxMvhfUbqU7Ir40/QzByA5WrI4K6qn6Xwefvtp1dqOOaZEwHTgnrjxXKxIsTrch0m5f/LX20DTWmHrWEHV89+vha0b9xmT+DKqZ1HLHsHgEeblC278z43Yk8BZhvhlxCs5GeL7eU4eaz1g+jUROC5uPbgzeKUBZ32lwOMvxYyjLtz6qZB8UzHQhzFgAl7QVNBTcZNQS3FOIIqVa0uTPyllWkJsSlOfeZpTWQ9z85x7NVu4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

si->max and si->pages are unsigned int. With 4 KiB pages, this limits
an xswap device to 16 TB, and xswap may need a larger address space.
Change both fields to unsigned long, together with the offsets and
indexes that carry them.

A real swap device is still limited by swap_header.info.last_page,
which is __u32, so this only widens the xswap address space. The old
overflow clamp in read_swap_header() is no longer needed; the header
check still limits real devices.

count_swap_pages() returns unsigned int and is only used by
hibernation, which never selects an xswap device. If that ever
changes, WARN and return 0 instead of silently truncating the value.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  4 ++--
 mm/swapfile.c        | 57 +++++++++++++++++++++++---------------------
 2 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4a30cf7ee186..6747b577c405 100644
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
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE | VM_ALLOC area */
@@ -254,7 +254,7 @@ struct swap_info_struct {
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
-	unsigned int pages;		/* total of usable pages of swap */
+	unsigned long pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
 	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index de2feaa2a628..912cfa68ba01 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -412,10 +412,10 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
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
@@ -863,7 +863,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
-		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		pr_debug("Ignoring bad slot %u (max: %lu)\n", offset, si->max);
 		return 0;
 	}
 	/*
@@ -1045,11 +1045,12 @@ static bool swap_prefer_free_cluster(struct swap_info_struct *si)
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
@@ -1096,12 +1097,12 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
@@ -1184,7 +1185,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 {
 	struct swap_cluster_info *ci;
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
-	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
 	 * Swapfile is not block device so unable
@@ -1454,7 +1455,7 @@ static bool swap_alloc_fast(struct folio *folio)
 	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
-	unsigned int offset;
+	unsigned long offset;
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
@@ -2559,9 +2560,15 @@ unsigned int count_swap_pages(int type, int free)
 
 		spin_lock(&sis->lock);
 		if (sis->flags & SWP_WRITEOK) {
-			n = sis->pages;
-			if (free)
-				n -= swap_usage_in_pages(sis);
+			/* Hibernation only; it never selects an xswap device. */
+			if (unlikely(sis->flags & SWP_XSWAP)) {
+				WARN_ON_ONCE(1);
+				n = 0;
+			} else {
+				n = sis->pages;
+				if (free)
+					n -= swap_usage_in_pages(sis);
+			}
 		}
 		spin_unlock(&sis->lock);
 	}
@@ -2882,8 +2889,8 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
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
@@ -2953,7 +2960,7 @@ static int try_to_unuse(unsigned int type)
 	struct swap_info_struct *si = swap_info[type];
 	struct folio *folio;
 	swp_entry_t entry;
-	unsigned int i;
+	unsigned long i;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
@@ -3767,12 +3774,8 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
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
@@ -4086,7 +4089,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 	if (si->pages != si->max - 1) {
-		pr_err("swap:%u != (max:%u - 1)\n", si->pages, si->max);
+		pr_err("swap:%lu != (max:%lu - 1)\n", si->pages, si->max);
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
-- 
2.54.0


