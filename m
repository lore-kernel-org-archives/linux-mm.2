Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E5E606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF99C6B0963; Thu, 22 Oct 2026 10:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1296B0964; Thu, 22 Oct 2026 10:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9206B0965; Thu, 22 Oct 2026 10:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 706B66B0963
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:57:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EFC1D120152
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:57:29 +0000 (UTC)
X-FDA: 85350565818.07.9DBB321
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id C64C240004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:57:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792681048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QuZtSGqXLr085dyK7y5RKTFc5UVxTXFjTZMMP+q+d8=;
	b=Y/9u3QZBglG0pdh+asL3KryAY02HSDSxmHnk6XdGP9hd/ZcSk2/25FOrLUkPwg0gU3HUE3
	Z7TPF1dFj1/jma04YpHPAPZacbMh03cSPLKsSsph9oKfeifXUx/CSq46PNT6E4QlVuzz62
	wsGRBPiUMoHK6idw/KnGnl97Q9Z61fg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792681048;
	b=zuO0kfS51BvOaDoJQg3bSwSPUKiLw+/RYp5ERwMs4DRQQ4SQdsoHEGunDaDYQBfDCx5h0n
	s0BHCaoRKmBXEfdM2a1Ft8ah2ae6ekM7v++JhlpI4/VqzfF31Y3NPEU2+KZLwFJnpeFWu0
	ko/i/HEZTC7wUwAubjXhTR/o8kOt6fw=
Received: by mail.gandi.net (Postfix) with ESMTPSA id A2DCE3EC4B;
	Thu, 22 Oct 2026 14:57:21 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH 1/1] mm/swap: allocate contiguous swap slots for a reclaim batch
Date: Thu, 22 Oct 2026 16:54:46 +0200
Message-ID: <20261022145615.2184343-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022145615.2184343-1-alex@ghiti.fr>
References: <20261022145615.2184343-1-alex@ghiti.fr>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGGwXX605MRFxxh77C8bVeV69JHrqX9kX+xnkh/Rce3XBZErtXJpq+vDes15AACTqiSg4nggE5KsHicePpOkfxRVMG+ns0HbhmD4wcZPbz8/ScBKbWCgHGKJ+5MzLpLlnvrWbKAbFAm/ftl1/xiDURFwxp26OJKi1asm5yfuFdWJwuLlKp0u4vZlodO8kiarkRvwOdQoaDgzusQVGc1ptc4Wl1OGgbRiWmWuQCIp8MearuWAJP/C1l6wTrTn0EYOs2cXx+oJKNqFkp3hsf2vlAzBlvYkdVg01IprBEkFy1Y3r0jXoFhT/9i27g08AhG9wR0xsKDRH7QO3FoU5NUr73SOp3n2lIbRmw8I3OJUGA4+epLB5coGnASodirmpWsFVkFcdUoqDvN7oDQbmFQ0pMMfciNNYN9kic7qMxPhdQasDcZ3v30F6vlXlqBrpnm9PXaRVTKBjVCGis9tGIYoPocMtzyeqklwyKTs3MKm8mD3tb3AA9hvyeS301LysOlDIffdsolQHn1v6k7/JwKyNKcGrpSV74y3qVL150/rL+UkJ4tUZmiksBJBLfv/AH5GhIRH0EQ0GkaZ3zmi4Z5v1OByXAb1oDAD/nxIemkeGb/BFF1dupSZdRprz4iw7cfZgVEJt53iA6BgBSl7o86iTFE6NAu/RaTSlJOdp6VfqK6Vg
X-Rspamd-Queue-Id: C64C240004
X-Stat-Signature: k9gk3uqauwbbjnad9u4px96ft65asn1c
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792681047-243765
X-HE-Meta: U2FsdGVkX1/AnAro9fVXviU3VKk34FlHefWSsL4B+c9ghR0x4he2L1rRx3imTxPKOpvI6J9OQtmL5fBlif6VMI28D43RBTStEwNf9p8PvVOdOG4RACt1DFRWsQbR6NFczu0qn/LGSI7FnmJWHA6su8OAiIEC96jgatnlvU+m232CJa1G//1/hwTt63MRwVPG+Cq67mjoMECR5D47n1sD41tNsfA6NymRbw+U5rS6IWfNHLrCGH4wj+4594cYHg6nFs86kZi5FVFUMlVMJDNlSRcaVszbonyntg0eTAgTFwN02smsekrAf/KonXN7zNQB4I/14fGtp8lTxhng7cc3rC19IAk0JB1q3iHpvFS6S6+Y6DaMFCcF/BEXrQOOIphmrOXd/hqSr7zDTPg2IdTRZqQ9G84Oik6nvnFbQR8sQPGCsr1NSrXvM0U5kXfavnGHMOpNWlqGlcg3lktqtuvWJuXm2eYjVYD/c7FA2Vl2yXtMTr5H2b8Tm9TPAmND07J36F9cvPIessEswpPpn4TR1zku0EJTvsMRjDuBHef3J1PpJfNRl0qgmHXsUot45mvahr8pXZqZElYP991DGeB3c57HsTALmp3s7u9P+fP/McHmcHEpr1P5gEqbTj1fms6M3IKm1rUn7nS7BeNieJBnxiGlrD/KsV+ua2m0N74v4+EqgcgBMXF54lK0aYyYI2OjG7kd+uGx5clD1uuw1Xrcwkcs5qoJ8vZ8XJxuVwFQJ+j7uM/UbastTAJXSbQyfkrjTc9Q15IEyrIn8GNr9Gjir4kraoaW1aZs735vPTdfy3rHcEDj1cBqolKYVr0rdOW98aDeOswRjvEdbUCdsJB7Shq4M07aXJbQlRN7MQWJqe8YsuF49frDYCxYCu+PZPbGKlJT6pHkVNJ23XJIRg5Uc+c3BCIUlzuGI8vAQhnxe/YDF915n8ala1po19NAGE6I+CE0MOQgJahUNG0cukm
 GvVcx49h
 VIoo5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reclaim allocates swap slots one folio at a time and only then batches
the writes, merging folios whose slots happen to be contiguous. Order-0
allocations scan the nonfull clusters before taking a free cluster, so
once frees have left holes in otherwise full clusters, a batch of LRU-
adjacent folios is scattered over those holes and written with many
small requests. Since swap slots are freed on exclusive write faults,
this happens with any workload that rewrites swapped out memory.

Before swapping out a batch, record how many pages of each small order
need a slot, and make those allocations follow contiguous free slots,
SWAP_CLUSTER_MAX at a time: in a nonfull cluster if one has them,
otherwise in a free cluster. When neither has them, the rest of the
batch fills the holes as before. Nothing is reserved.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/shmem.c    |   2 +
 mm/swap.h     |  10 +++
 mm/swapfile.c | 211 +++++++++++++++++++++++++++++++++++++++++++++++++-
 mm/vmscan.c   |  11 ++-
 4 files changed, 229 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fd0953d55fd6..1415aeb72cf3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1850,6 +1850,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		folio_test_set_dirty(folio);
 		if (split_folio_to_list(folio, folio_list))
 			goto redirty;
+		if (folio_list)
+			folio_alloc_swap_split(1 << order);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		if (order >= HPAGE_PMD_ORDER) {
diff --git a/mm/swap.h b/mm/swap.h
index d5bf21f517dc..c52ad5ee262b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -243,6 +243,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  *
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
+void folio_alloc_swap_prepare(struct list_head *folios);
+void folio_alloc_swap_split(unsigned int nr_pages);
 int folio_alloc_swap(struct folio *folio);
 int folio_dup_swap(struct folio *folio, struct page *page);
 void folio_put_swap(struct folio *folio, struct page *page);
@@ -363,6 +365,14 @@ static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
 	return NULL;
 }
 
+static inline void folio_alloc_swap_prepare(struct list_head *folios)
+{
+}
+
+static inline void folio_alloc_swap_split(unsigned int nr_pages)
+{
+}
+
 static inline int folio_alloc_swap(struct folio *folio)
 {
 	return -EINVAL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c3288910b3e3..67161e184905 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -120,6 +120,8 @@ atomic_t nr_rotate_swap = ATOMIC_INIT(0);
 struct percpu_swap_cluster {
 	struct swap_info_struct *si[SWAP_NR_ORDERS];
 	unsigned long offset[SWAP_NR_ORDERS];
+	/* Pages of the current reclaim batch still to allocate, per order */
+	unsigned int batch_left[SWAP_NR_ORDERS];
 	local_lock_t lock;
 };
 
@@ -916,6 +918,41 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 	return true;
 }
 
+/*
+ * First offset in [@start, @end), aligned to @nr_pages, followed by
+ * @nr_contig free slots. Reclaimable swap cache does not count as free.
+ */
+static unsigned long cluster_find_free_contig(struct swap_cluster_info *ci,
+					      unsigned long start,
+					      unsigned long end,
+					      unsigned int nr_pages,
+					      unsigned int nr_contig)
+{
+	unsigned long offset, contig_start = start;
+
+	if (cluster_is_empty(ci))
+		return start + nr_contig <= end ? start : SWAP_ENTRY_INVALID;
+
+	for (offset = start; offset < end; offset++) {
+		if (!swp_tb_is_null(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
+			contig_start = ALIGN(offset + 1, nr_pages);
+			offset = contig_start - 1;
+			continue;
+		}
+		if (offset + 1 - contig_start >= nr_contig)
+			return contig_start;
+	}
+
+	return SWAP_ENTRY_INVALID;
+}
+
+static bool cluster_slots_free(struct swap_cluster_info *ci,
+			       unsigned long offset, unsigned int nr_pages)
+{
+	return cluster_find_free_contig(ci, offset, offset + nr_pages,
+					nr_pages, nr_pages) == offset;
+}
+
 static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 					 struct swap_cluster_info *ci,
 					 struct folio *folio,
@@ -1042,6 +1079,59 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	return found;
 }
 
+/* Larger folios already make large enough write requests on their own */
+#define SWAP_BATCH_MAX_ORDER	(ilog2(SWAP_CLUSTER_MAX) - 1)
+
+static inline unsigned int swap_batch_contig(unsigned int left)
+{
+	return min_t(unsigned int, left, SWAP_CLUSTER_MAX);
+}
+
+/*
+ * Like alloc_swap_scan_list(), but only allocate at the start of @nr_contig
+ * free slots. Order 0 clusters without them move to the frag list until a
+ * slot is freed, larger orders stay nonfull as the folio may still fit.
+ */
+static unsigned int alloc_swap_scan_list_contig(struct swap_info_struct *si,
+						struct list_head *list,
+						struct folio *folio,
+						unsigned int nr_contig)
+{
+	unsigned int found = SWAP_ENTRY_INVALID, order = folio_order(folio);
+	struct swap_cluster_info *ci;
+	unsigned long start, offset;
+	LIST_HEAD(skipped);
+
+	while ((ci = isolate_lock_cluster(si, list))) {
+		start = cluster_offset(si, ci);
+		offset = SWAP_ENTRY_INVALID;
+		if (SWAPFILE_CLUSTER - ci->count >= nr_contig)
+			offset = cluster_find_free_contig(ci, start,
+							  start + SWAPFILE_CLUSTER,
+							  1 << order, nr_contig);
+		if (offset == SWAP_ENTRY_INVALID) {
+			if (order)
+				move_cluster(si, ci, &skipped,
+					     CLUSTER_FLAG_NONFULL);
+			else
+				relocate_cluster(si, ci);
+			swap_cluster_unlock(ci);
+			continue;
+		}
+		found = alloc_swap_scan_cluster(si, ci, folio, offset);
+		if (found)
+			break;
+	}
+
+	if (!list_empty(&skipped)) {
+		spin_lock(&si->lock);
+		list_splice_tail(&skipped, list);
+		spin_unlock(&si->lock);
+	}
+
+	return found;
+}
+
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 {
 	long to_scan = 1;
@@ -1109,6 +1199,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	struct swap_cluster_info *ci;
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	unsigned int left;
 
 	/*
 	 * Swapfile is not block device so unable
@@ -1129,7 +1220,14 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, folio, offset);
+			/* The batch's contiguous slots are used up */
+			if (likely(folio) &&
+			    this_cpu_read(percpu_swap_cluster.batch_left[order]) &&
+			    !cluster_slots_free(ci, offset, 1 << order))
+				swap_cluster_unlock(ci);
+			else
+				found = alloc_swap_scan_cluster(si, ci, folio,
+								offset);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1148,6 +1246,21 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 
+	/* Keep a reclaim batch on contiguous free slots, not in small holes */
+	left = likely(folio) ?
+	       this_cpu_read(percpu_swap_cluster.batch_left[order]) : 0;
+	if (left && order < PMD_ORDER) {
+		found = alloc_swap_scan_list_contig(si, &si->nonfull_clusters[order],
+						    folio, swap_batch_contig(left));
+		if (found)
+			goto done;
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
+		if (found)
+			goto done;
+		/* No contiguous slots left, allocate the rest of the batch as usual */
+		this_cpu_write(percpu_swap_cluster.batch_left[order], 0);
+	}
+
 	if (order < PMD_ORDER) {
 		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order], folio, true);
 		if (found)
@@ -1390,7 +1503,15 @@ static bool swap_alloc_fast(struct folio *folio)
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		alloc_swap_scan_cluster(si, ci, folio, offset);
+		/* The batch's contiguous slots are used up */
+		if (this_cpu_read(percpu_swap_cluster.batch_left[order]) &&
+		    !cluster_slots_free(ci, offset, 1 << order)) {
+			swap_cluster_unlock(ci);
+			this_cpu_write(percpu_swap_cluster.offset[order],
+				       SWAP_ENTRY_INVALID);
+		} else {
+			alloc_swap_scan_cluster(si, ci, folio, offset);
+		}
 	} else {
 		swap_cluster_unlock(ci);
 	}
@@ -1729,6 +1850,86 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 	return err;
 }
 
+static void swap_alloc_prepare(unsigned int order, unsigned int nr)
+{
+	unsigned int nr_contig = swap_batch_contig(nr);
+	struct swap_cluster_info *ci;
+	struct swap_info_struct *si;
+	unsigned long offset;
+	bool keep = false;
+
+	local_lock(&percpu_swap_cluster.lock);
+	if (nr <= (1 << order)) {
+		this_cpu_write(percpu_swap_cluster.batch_left[order], 0);
+		goto out;
+	}
+	this_cpu_write(percpu_swap_cluster.batch_left[order], nr);
+
+	/* Keep the cursor if enough free slots follow it */
+	si = this_cpu_read(percpu_swap_cluster.si[order]);
+	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
+	if (si && offset && get_swap_device_info(si)) {
+		ci = swap_cluster_lock(si, offset);
+		if (cluster_is_usable(ci, order)) {
+			if (cluster_is_empty(ci))
+				offset = cluster_offset(si, ci);
+			keep = offset % SWAPFILE_CLUSTER + nr_contig <=
+			       SWAPFILE_CLUSTER &&
+			       cluster_find_free_contig(ci, offset,
+							offset + nr_contig,
+							1 << order,
+							nr_contig) == offset;
+		}
+		swap_cluster_unlock(ci);
+		put_swap_device(si);
+	}
+	if (!keep)
+		this_cpu_write(percpu_swap_cluster.offset[order],
+			       SWAP_ENTRY_INVALID);
+out:
+	local_unlock(&percpu_swap_cluster.lock);
+}
+
+/**
+ * folio_alloc_swap_prepare - prepare swap allocation for a reclaim batch
+ * @folios: list of folios reclaim is about to swap out
+ *
+ * Record how many pages of each small order the batch will swap out, so
+ * that their slots are allocated contiguously. Nothing is reserved.
+ */
+void folio_alloc_swap_prepare(struct list_head *folios)
+{
+	unsigned int max_order = min(SWAP_BATCH_MAX_ORDER, SWAP_NR_ORDERS - 1);
+	unsigned int nr[SWAP_BATCH_MAX_ORDER + 1] = {};
+	struct folio *folio;
+	unsigned int order;
+
+	if (!total_swap_pages)
+		return;
+
+	list_for_each_entry(folio, folios, lru) {
+		if (!folio_test_swapbacked(folio) || folio_test_swapcache(folio))
+			continue;
+		order = folio_order(folio);
+		if (order <= max_order)
+			nr[order] += 1 << order;
+	}
+
+	for (order = 0; order <= max_order; order++)
+		swap_alloc_prepare(order, nr[order]);
+}
+
+/**
+ * folio_alloc_swap_split - account for a large folio split by reclaim
+ * @nr_pages: number of order-0 folios the split produced
+ */
+void folio_alloc_swap_split(unsigned int nr_pages)
+{
+	local_lock(&percpu_swap_cluster.lock);
+	this_cpu_add(percpu_swap_cluster.batch_left[0], nr_pages);
+	local_unlock(&percpu_swap_cluster.lock);
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1771,6 +1972,12 @@ int folio_alloc_swap(struct folio *folio)
 	local_lock(&percpu_swap_cluster.lock);
 	if (!swap_alloc_fast(folio))
 		swap_alloc_slow(folio);
+	if (folio_test_swapcache(folio)) {
+		unsigned int left = this_cpu_read(percpu_swap_cluster.batch_left[order]);
+
+		this_cpu_write(percpu_swap_cluster.batch_left[order],
+			       left > size ? left - size : 0);
+	}
 	local_unlock(&percpu_swap_cluster.lock);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ea2d4c8d1890..86245036872c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1175,6 +1175,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
 	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
+	if (sc->gfp_mask & __GFP_IO)
+		folio_alloc_swap_prepare(folio_list);
 
 retry:
 	while (!list_empty(folio_list)) {
@@ -1378,9 +1380,11 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				 * We can free the unmapped pages without IO.
 				 */
 				if (data_race(!list_empty(&folio->_deferred_list) &&
-				    folio_test_partially_mapped(folio)) &&
-				    split_folio_to_list(folio, folio_list))
-					goto activate_locked;
+				    folio_test_partially_mapped(folio))) {
+					if (split_folio_to_list(folio, folio_list))
+						goto activate_locked;
+					folio_alloc_swap_split(nr_pages);
+				}
 			}
 			ret = folio_alloc_swap(folio);
 			if (ret) {
@@ -1393,6 +1397,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))
 					goto activate_locked;
+				folio_alloc_swap_split(nr_pages);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 				if (nr_pages >= HPAGE_PMD_NR) {
 					count_memcg_folio_events(folio,
-- 
2.53.0-Meta


