Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3F3606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CMJAylua
Received: by kanga.kvack.org (Postfix)
	id D06056B05C2; Mon,  9 Nov 2026 00:56:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDE166B05C3; Mon,  9 Nov 2026 00:56:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1B026B05C4; Mon,  9 Nov 2026 00:56:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 927266B05C2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:56:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E8B9C05AF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:17 +0000 (UTC)
X-FDA: 85414520394.01.04CE83C
Received: from mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 30F4040002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CMJAylua;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCJwY+DdwqZxBCMRTX1FWlqdIowtf+5OPns6jt+c8gE=;
	b=CcY1ZIiZpq1NA7AHsM1KxmLjl4oDAuH7eXE6UOKzfa4Y04hwRLreqLnPyuYrmXWm90hYrH
	7v5HqImHfwfPikXSchyXY3Ki+RAMvSZgGLTXwu0EUeBHryOXCo8w4uYTB1oTeRgn4oXMzN
	B7HODInomm06jUe3fm4A2zzyY8Myvys=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203775;
	b=cSNyrgSxqH8Yjse6wUMO/GTWRt/KJxRkxzgzcHwI5xd1ZHrUot5TVLIe59O+4dZm854fxO
	G8m3lHRNhIKZyLeg/2gxrkATx4Tir+74MG/qXdgtUA5tXZvcnG4v2OIz3z7LtvsJwpRG71
	7e1g/NiLhYMhfg571gIYrKUAioC3se4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CMJAylua;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uhVAgDjfU+twOJuyAfnvA+TpcEkp7IgyeJ9VbEIlhAo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203773; v=1; x=1794808573;
 b=CMJAylua15Y3TZLDlI7BENtmT9Phf0JFsUEo0hwxPbsEjGHDkPjuwn/wu4pfd+hp8q/ZRDW9
 X0jELW4y865Jaih/YqRp0uy55hfUk/z87sTO8hJOPqUmvMHpUQhDXilaXxsaNwCMd56kYY7w1sM
 8NIC0VbCvonKduRpR+nQMLmk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d96a14a4a47fae48;
	Mon, 09 Nov 2026 05:56:13 +0000
X-Mizu-Trace-ID: d96a14a4a47fae48
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
Subject: [PATCH v5 05/19] mm, swap: widen swap_info_struct max/pages to unsigned long
Date: Mon,  9 Nov 2026 13:54:41 +0800
Message-ID: <20261109055455.536925-6-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jck84gu3bpfbms14yfpkmstpjkn149wq
X-Rspamd-Queue-Id: 30F4040002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794203774-683710
X-HE-Meta: U2FsdGVkX18wSleoNq7AwMpAG+VXey37HAp7/9JZwzsC7jF0FnyMtM+l3OH2AddIPb4EBrGYsFFUDwcUV7yFiIB0QqDWWZFPQYrve4pd2OxVSliy8FeeWLTaCdylwbOeeaHpaYf9Tn+W8mL5AoutnAcv67T+3w2BLNSx4Ovgdq7GIdNPLViGq2c2c9PiPAMj6ABPpbrCtKZbdvDKY4XxzzEe4rcchyr+BUAhRwQh6sfVO1GILQ4tY+UvBmS20gDb58YNA8Rovorz+s0mKVqcigRDLKkYc2SlvI4Ue2Q+PHzqaYjoLooQYwNYyfmFEfO0UIw44sO4BpcnAiVCn2i19RJVwwaz7Cc/at8MtRBDynUQpcgFutjCI+3QhUMgqIyoiE0ouHPrnn4n3P+emnRHE3V5suyzzujMreWnQHejsDdSZg2Glvv4hYyQpOze+5PL7EBC5xq/m+2Shh2oWtkL3dECFuVEpbg/iRhRy1TjAi/8IiGd0a+blMAXoLLZeFq8NxLIimUtKqnmA1bAbK6GS11pDIWxwjhJQ0dcY/d1dcUX9tWO3VNPIklf+dxp2yzVcdQGmnEResFMwq5jX3OTyUqZnoAyVyDJowEZPI+ijW4Sky/+jRsJ9I6uwabzr5YsEvcr8Ufn08i7otiEwoEo8b+Lyc7KZOGNM/l45+5SQOg6aOh6dVM7t/YtkKxROlKUepUTVEE/31TuOjudBA2qd9ZD6l8E7PG7AVj/9ZVRzY3+FnCRwvFXDlIRD4GMKg1OZRLdB2ffe14XLFOeKAhMxhEecJXUcd0wsjmh2vtjkjvfp03xRzJmToZp+5R/8t/J+bxiweXbCR0CTXTp8BLKehSNuLlDZlOJG1XrEWZac+JEbRW7zeQelatvhYVGuqQGGG8uO1CnjR8li/xDS4hKQP3ExR474NkqEK8x+fnkbxyFkrlD7WR+f+A8ejX1vQD749YP3IqikPvhtdXm4ui
 jtX5Gmk6
 9tJ6+3FBI/VKhGgJGwDcWOglCnDANg9Gn/FJCk9t5V+7VnW/+OPhRI7yZAwOukQD2a6QmWShASWdDJPznGDrTRDijZX4m9rkldsxJYrTPdiOgLZ5ujsc3pamE8MNhDT/Ncn+3MD78I9Oz8CvLnWNGFiFrzFBj5iyGQNO2885Jr+kwNYiDbYh2Am9fvizo2NFkisvkqMt13Yu9mrzkmERoeo8rmu2Udkw3uUeLNG8tNLqnYeFToLg+pWTwGeXWkE4hpM1vBO3CkT1tqF/FaV+Xwbu4yJe4dy5DDk3cVo++oUYCfG4+MLM4QJH68+OOd1o44zH8XbpGtKDn3p0TE7ZD+0rhqVV96a2d3XllOu3vq0Rk87H7EoPuZAUf5sP/cUGkq7LqrU3yp+U+G7HYv3UmCQP7siaBztSMYPYk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

si->max and si->pages are unsigned int. With 4 KiB pages, this limits
an xswap device to 16 TB. xswap may need a larger address space, so
change both fields to unsigned long.

Several places still use unsigned int for offsets and indexes. Widen
them as well:

- the return value of cluster_offset() and the cluster scan helpers;
- the allocation offsets in cluster_alloc_swap_entry() and
  swap_alloc_fast();
- the indexes in find_next_to_unuse() and try_to_unuse().

Also change the related print formats from %u to %lu.

A real swap device is still limited by swap_header.info.last_page,
which is __u32. So this only widens the xswap address space. The old
overflow clamp in read_swap_header() is no longer needed; the header
check still limits real devices.

count_swap_pages() returns unsigned int and is only used by
hibernation. Hibernation never selects an xswap device. If that ever
changes, WARN and return 0 instead of silently truncating the value.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  4 +--
 mm/swapfile.c        | 59 +++++++++++++++++++++++---------------------
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 382a578140b5..569989856c25 100644
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
index 00c7b398bafe..83aaf00b75d3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -429,10 +429,10 @@ static inline unsigned int cluster_index(struct swap_info_struct *si,
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
@@ -836,7 +836,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
-		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		pr_debug("Ignoring bad slot %u (max: %lu)\n", offset, si->max);
 		return 0;
 	}
 	/*
@@ -1002,11 +1002,12 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
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
@@ -1053,12 +1054,12 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
@@ -1141,7 +1142,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 {
 	struct swap_cluster_info *ci;
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
-	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned long offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
 	 * Swapfile is not block device so unable
@@ -1418,7 +1419,7 @@ static bool swap_alloc_fast(struct folio *folio)
 	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
-	unsigned int offset;
+	unsigned long offset;
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
@@ -2509,9 +2510,15 @@ unsigned int count_swap_pages(int type, int free)
 
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
@@ -2832,8 +2839,8 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
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
@@ -2903,7 +2910,7 @@ static int try_to_unuse(unsigned int type)
 	struct swap_info_struct *si = swap_info[type];
 	struct folio *folio;
 	swp_entry_t entry;
-	unsigned int i;
+	unsigned long i;
 
 	if (!swap_usage_in_pages(si))
 		goto success;
@@ -3722,12 +3729,8 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
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
@@ -4209,7 +4212,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 	if (si->pages != si->max - 1) {
-		pr_err("swap:%u != (max:%u - 1)\n", si->pages, si->max);
+		pr_err("swap:%lu != (max:%lu - 1)\n", si->pages, si->max);
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
@@ -4300,7 +4303,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
 
-	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
+	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
 		K((unsigned long long)span),
 		(si->flags & SWP_SOLIDSTATE) ? "SS" : "",
-- 
2.54.0


