Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32D44C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450066B00B9; Mon, 14 Sep 2026 23:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429406B00BA; Mon, 14 Sep 2026 23:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3668B6B00BB; Mon, 14 Sep 2026 23:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0F136B00B9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04BD040303
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:10 +0000 (UTC)
X-FDA: 85214535462.02.2B7FE83
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf16.hostedemail.com (Postfix) with ESMTP id A6DF1180006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789442229;
	b=6Y4AeKAm11uJc6FJWidIioSeSoBAq0Ix4KZAghXZ+jVpGZ3gfc5I3DwmxUzuJN9aJL5lD9
	OdYd3fg/FOpc0bwOrx2hXIojaZbHABpDeji29Fmf+SkiTnfFiuhlG3i01dZtnAzc07Mcwy
	7fMZCiivxALG6ojpAUO4Asg5PEvl6WM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kEGTOux2V2eBDpOeD9IuYpba8jXpkIQcY1KaVDpg3x4=;
	b=XGwh/c5Q8kqhYM2y9iKQvXwjBjROlOpnIXJlP61bAbr+Hkl1J7IsA+EmIopx5e4sfe9l1U
	yEkrbYIuv2zrbGzI05jR7ALApTJlnao08pvygubKs0aseWOS0sI2oO3+P2VyO+SxtktLfG
	VjqR2OO0kFCWDfhiKoRuePI+OASyOqE=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:06 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	her0gyugyu@gmail.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH 05/10] mm, swap: hand the hibernation image whole free clusters
Date: Tue, 15 Sep 2026 12:16:53 +0900
Message-Id: <20260915031658.1505680-6-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A6DF1180006
X-Stat-Signature: ifsqoaqcey93pqpr8hmjc9ut47k4buk6
X-HE-Tag: 1789442228-991216
X-HE-Meta: U2FsdGVkX1+pfUVh5xZlhdAo+Ak9x7o08XNhFbu8Ce7u9IUGanADWOGp46hPw/iyvQfOpnDIePUq1hIuLfTKEhX/OQNogA+cqYRo2Fq4EhaGP1xblbuu85c5n87uBdwhQdt3x6t1DLOycZHBTdVtv/97w4SfzlngBVgLZaMaQSE98q7nCGJBFbpKnW/HiDH6b677LrUR0WuwXmJ6GaOtzdm/HfXT63YuWvokeOSi2Ugilf5hwKXpBsw2pbGTVdiKiPHXyBiZSdYi4oAZd89PUm8DjnbExndLiWlyCnI1CT5Xt0WbTGa4e6NCBSObDT7181JILNHRv6oKzbfufZtIreOGPUjCrQCh5r1jRQRmk5471kO9L2/5zPSfFxq3f3vwrwUyLDaVw6Rl+BHpc3xdWd7tjG8/8f2q+MnEt4Gn0/sLPoOp3fWPVFGFVK3DXk95poZwru3NPl9l/qmWTZr2eL+pb2NOPardiFjZDs8EbS0DV742PeaXOutI9Xyg2/ZDlf57FkiXbJ1XaEjjKqcknBrNMXpnn6DkyjG8PQuFEA+05UpaZn2/v5egrHozBMmGf5OFTGrNruN7RzraWeElu/fh0CJlRjX3xWv8B4vO4iypEDiGYDZSFHR3fDF4IffIDPEgLwxU3lkVUle0aa7uO6+tOjDr+XdjpqFDrUuLG52Gi4EIKXGT3XYHmcKYU55GaLJYMICGwDgDcLmH1HXQySOGEVaP/msLogvsijl1Cjc7sFj1wYvnKvBWk0HXuo2p6gxl8pddbH/WEzR/3/Wvqsigr3JnOoRy0QPweAW8dLYlIOCtig0vFSJT+dvPdaMFPCXS8FwSzyvFwII1wdM8sRja8damGfl0qBRCx/BHS+I9wOKdqNYt/q2S1wDtkMKfDcSluVsahJKEFB3JTxxJCDrIkXEuSM60XUv14ChOZo3KXX4n1VCBfaYShE197bpPVZqoInTuyiu3Im1avyj
 8Ovla+Ra
 V4kygHNetdewNxac2dSRCvWmjolXepYrKjRXLbU52Bu/KUwLys0vrgYIptdw+sBX3Kn6G8xLjxmtElHSx8Jj6cxBHrdlbzm6hTm/9nQbUZvtQ4VTrStCDryZjWwCgTD1q0ZCvhyXXQL9jdDYiweVcbdjEq6hCE2RZX7xF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hibernation takes its slots from the allocator one at a time, so the
image lands wherever swap has holes and is written in many pieces.

When the image asks for slots, move the free clusters to a private
list and give each one out whole, as a run of contiguous slots.  What
the image does not use goes back to the free list when the writer is
done, whether the write worked or not.

These clusters get no swap table and no memcg table, since the image
does not need them.  After a successful write the machine powers off
and the system resumes from a snapshot taken before the slots were
handed out, so they never have to be given back.  After an error or a
hybrid sleep they do come back, and the cluster count is enough for
that.  Taking a cluster is then cheap, with nothing to allocate.

Taking all of them is fine because this only happens once storage is
suspended.  By then user space and kswapd are frozen, so swap
allocation is rare, and writing the image fast is what matters.  Any
allocation that does happen uses the nonfull and frag lists.  A uswsusp
tool can call SNAPSHOT_ALLOC_SWAP_PAGE before that, and those slots
come from the allocator as before.

When the free clusters run out, the image shares the allocator with
everyone else and takes a slot at a time from the nonfull and frag
lists, as before.  Those clusters could be set aside too, but other
users still free slots in them, and a free can move a cluster to
another list.  The image would then have to stay in sync with those
moves, which the allocator already does.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h |   9 +-
 kernel/power/swap.c  |  63 +++++++++---
 mm/swap_hibernate.c  | 222 ++++++++++++++++++++++++++++++++++++-------
 mm/swapfile.c        |  11 +++
 4 files changed, 256 insertions(+), 49 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 78974da6810e..94c894c7ad9d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -423,9 +423,12 @@ void swap_put_entries_direct(swp_entry_t entry, int nr);
  */
 bool folio_free_swap(struct folio *folio);
 
-/* Allocate / free (hibernation) exclusive entries */
-swp_entry_t swap_alloc_hibernation_slot(int type);
-void swap_free_hibernation_slot(swp_entry_t entry);
+/* Hibernation takes runs of slots off the device it is bound to */
+int swap_hibernation_bind(int type);
+void swap_hibernation_unbind(void);
+void swap_hibernation_reset(void);
+swp_entry_t swap_alloc_hibernation_slot(unsigned int *nr);
+void swap_free_hibernation_slot(swp_entry_t entry, unsigned int nr);
 
 static inline void put_swap_device(struct swap_info_struct *si)
 {
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index dc65ec409207..09c6c50bf837 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -166,44 +166,73 @@ static int swsusp_extents_insert(unsigned long swap_offset)
 	return 0;
 }
 
+/*
+ * Swap gives the image whole runs of slots while the writer asks for one
+ * page at a time, so the part of a run that is still to come waits here.
+ */
+static struct {
+	int type;
+	unsigned long offset;	/* the slot the next page gets */
+	unsigned int left;	/* slots the run still holds, that one included */
+} swsusp_run = { .type = -1 };
+
 sector_t alloc_swapdev_block(int swap)
 {
 	unsigned long offset;
 
+	if (swap != swsusp_run.type || !swsusp_run.left) {
+		unsigned int nr;
+
+		offset = swp_offset(swap_alloc_hibernation_slot(&nr));
+		if (!offset)
+			return 0;
+		swsusp_run.type = swap;
+		swsusp_run.offset = offset;
+		swsusp_run.left = nr;
+	}
+	offset = swsusp_run.offset++;
+	swsusp_run.left--;
+
 	/*
-	 * Allocate a swap page and register that it has been allocated, so that
-	 * it can be freed in case of an error.
+	 * Register the slot, so that it can be freed in case of an error.
+	 * The slots behind it in the run are recorded nowhere, so they have
+	 * to go back here together with it when that fails.
 	 */
-	offset = swp_offset(swap_alloc_hibernation_slot(swap));
-	if (offset) {
-		if (swsusp_extents_insert(offset))
-			swap_free_hibernation_slot(swp_entry(swap, offset));
-		else
-			return swapdev_block(swap, offset);
+	if (swsusp_extents_insert(offset)) {
+		swap_free_hibernation_slot(swp_entry(swap, offset),
+					   swsusp_run.left + 1);
+		swsusp_run.left = 0;
+		return 0;
 	}
-	return 0;
+	return swapdev_block(swap, offset);
 }
 
 void free_all_swap_pages(int swap)
 {
-	unsigned long offset;
 	struct rb_node *node;
 
 	/*
 	 * Free swap pages allocated for saving image data.  It also frees the
 	 * extents used to register which swap entries had been allocated.
+	 * Whatever the last run still holds was never registered, so it goes
+	 * back before the extents do.
 	 */
+	if (swsusp_run.type == swap && swsusp_run.left)
+		swap_free_hibernation_slot(swp_entry(swap, swsusp_run.offset),
+					   swsusp_run.left);
+	swsusp_run.type = -1;
+	swsusp_run.left = 0;
+
 	while ((node = swsusp_extents.rb_node)) {
 		struct swsusp_extent *ext;
 
 		ext = rb_entry(node, struct swsusp_extent, node);
 		rb_erase(node, &swsusp_extents);
-
-		for (offset = ext->start; offset <= ext->end; offset++)
-			swap_free_hibernation_slot(swp_entry(swap, offset));
-
+		swap_free_hibernation_slot(swp_entry(swap, ext->start),
+					   ext->end - ext->start + 1);
 		kfree(ext);
 	}
+	swap_hibernation_reset();
 }
 
 int swsusp_swap_in_use(void)
@@ -347,6 +376,9 @@ static int swsusp_swap_check(void)
 	if (res < 0)
 		return res;
 	root_swap = res;
+	res = swap_hibernation_bind(root_swap);
+	if (res)
+		return res;
 
 	hib_resume_bdev_file = bdev_file_open_by_dev(swsusp_resume_device,
 			BLK_OPEN_WRITE, NULL, NULL);
@@ -418,6 +450,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
 err_rel:
 	release_swap_writer(handle);
 err_close:
+	swap_hibernation_unbind();
 	swsusp_close();
 	return ret;
 }
@@ -492,6 +525,8 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 
 	if (error)
 		free_all_swap_pages(root_swap);
+	/* Give back the free clusters the image did not use. */
+	swap_hibernation_unbind();
 	release_swap_writer(handle);
 	swsusp_close();
 
diff --git a/mm/swap_hibernate.c b/mm/swap_hibernate.c
index 45359b664f46..3431443716d4 100644
--- a/mm/swap_hibernate.c
+++ b/mm/swap_hibernate.c
@@ -4,30 +4,102 @@
  * use the allocator's static helpers.
  */
 
-/**
- * swap_alloc_hibernation_slot() - Allocate a swap slot for hibernation.
- * @type: swap device type index to allocate from.
- *
- * The caller must ensure the swap device is stable, either by pinning
- * it (SWP_HIBERNATION) or by freezing user-space.
- *
- * Return: a valid swp_entry_t on success, or an empty entry (val == 0)
- * on failure.
+/*
+ * The image gets whole free clusters first, then single slots from the
+ * allocator.  Clusters it does not use go back when the session ends.
  */
-swp_entry_t swap_alloc_hibernation_slot(int type)
+static struct swap_info_struct *hib_si;
+
+/* Free clusters set aside for the image, out of the allocator's reach. */
+static LIST_HEAD(hib_free_clusters);
+
+static void hib_claim_free_clusters(struct swap_info_struct *si)
+{
+	spin_lock(&si->lock);
+	list_splice_tail_init(&si->free_clusters, &hib_free_clusters);
+	spin_unlock(&si->lock);
+}
+
+static void hib_return_free_clusters(struct swap_info_struct *si)
+{
+	if (list_empty(&hib_free_clusters))
+		return;
+	spin_lock(&si->lock);
+	list_splice_tail_init(&hib_free_clusters, &si->free_clusters);
+	spin_unlock(&si->lock);
+}
+
+/*
+ * Take a whole free cluster.  It gets no swap table, so cluster_is_usable()
+ * keeps the allocator away from it.
+ */
+static void hib_take_cluster(struct swap_info_struct *si,
+			     struct swap_cluster_info *ci)
+{
+	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON_ONCE(ci->count || cluster_table_is_alloced(ci));
+
+	ci->order = 0;
+	ci->count = SWAPFILE_CLUSTER;
+	swap_range_alloc(si, SWAPFILE_CLUSTER);
+	/* Only clusters that are still free may stay on the free list. */
+	move_cluster(si, ci, &si->full_clusters, CLUSTER_FLAG_FULL);
+}
+
+/*
+ * Give back slots of a cluster taken whole.  It has no table, so it stays
+ * off every list until all of its slots are back.
+ */
+static void hib_put_cluster_slots(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned int ci_off, unsigned int nr)
+{
+	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON_ONCE(ci->count < nr);
+
+	if (ci->flags != CLUSTER_FLAG_NONE) {
+		spin_lock(&si->lock);
+		list_del(&ci->list);
+		ci->flags = CLUSTER_FLAG_NONE;
+		spin_unlock(&si->lock);
+	}
+	ci->count -= nr;
+	swap_range_free(si, cluster_offset(si, ci) + ci_off, nr);
+	if (!ci->count)
+		free_cluster(si, ci);
+}
+
+/*
+ * Hand out the next set-aside cluster.  Clusters are only set aside once
+ * storage is suspended, since that takes them from everyone else.
+ */
+static unsigned int hib_take_free(struct swap_info_struct *si,
+				  unsigned long *start)
 {
-	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
-	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
 	struct swap_cluster_info *ci;
-	swp_entry_t entry = {0};
 
-	if (!si)
-		goto fail;
+	if (list_empty(&hib_free_clusters) && !list_empty(&si->free_clusters) &&
+	    pm_suspended_storage())
+		hib_claim_free_clusters(si);
+	if (list_empty(&hib_free_clusters))
+		return 0;
+
+	ci = list_first_entry(&hib_free_clusters, struct swap_cluster_info,
+			      list);
+	spin_lock(&ci->lock);
+	hib_take_cluster(si, ci);
+	*start = cluster_offset(si, ci);
+	spin_unlock(&ci->lock);
+	return SWAPFILE_CLUSTER;
+}
+
+/* One slot from the allocator, trying this CPU's cluster first. */
+static unsigned long hib_alloc_slot(struct swap_info_struct *si)
+{
+	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
+	struct swap_info_struct *pcp_si;
+	struct swap_cluster_info *ci;
 
-	/*
-	 * Try the local cluster first if it matches the device. If
-	 * not, try grab a new cluster and override local cluster.
-	 */
 	local_lock(&percpu_swap_cluster.lock);
 	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
 	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
@@ -41,28 +113,110 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	if (!offset)
 		offset = cluster_alloc_swap_entry(si, NULL);
 	local_unlock(&percpu_swap_cluster.lock);
-	if (offset)
-		entry = swp_entry(si->type, offset);
+	return offset;
+}
+
+static void hib_session_begin(struct swap_info_struct *si)
+{
+	if (hib_si)
+		hib_return_free_clusters(hib_si);
+	hib_si = si;
+}
 
-fail:
-	return entry;
+static void hib_session_end(void)
+{
+	if (hib_si)
+		hib_return_free_clusters(hib_si);
+	hib_si = NULL;
 }
 
 /**
- * swap_free_hibernation_slot() - Free a swap slot allocated for hibernation.
- * @entry: swap entry to free.
+ * swap_hibernation_bind() - Point the hibernation session at a swap device.
+ * @type: swap device type index.
  *
- * The caller must ensure the swap device is stable.
+ * Return: 0, or -ENODEV when there is no such device.
  */
-void swap_free_hibernation_slot(swp_entry_t entry)
+int swap_hibernation_bind(int type)
+{
+	struct swap_info_struct *si = swap_type_to_info(type);
+
+	if (!si)
+		return -ENODEV;
+	hib_session_begin(si);
+	return 0;
+}
+
+/**
+ * swap_hibernation_unbind() - End the session, giving back unused clusters.
+ */
+void swap_hibernation_unbind(void)
+{
+	hib_session_end();
+}
+
+/**
+ * swap_hibernation_reset() - Return set-aside clusters and start over.
+ */
+void swap_hibernation_reset(void)
+{
+	if (hib_si)
+		hib_session_begin(hib_si);
+}
+
+/**
+ * swap_alloc_hibernation_slot() - Take the next run of slots for the image.
+ * @nr: set to the number of slots in the run.
+ *
+ * Return: the first slot of the run, or an empty entry if none is left.
+ */
+swp_entry_t swap_alloc_hibernation_slot(unsigned int *nr)
+{
+	struct swap_info_struct *si = hib_si;
+	swp_entry_t entry = {0};
+	unsigned long start;
+	unsigned int len;
+
+	*nr = 0;
+	if (WARN_ON_ONCE(!si))
+		return entry;
+
+	len = hib_take_free(si, &start);
+	if (!len) {
+		start = hib_alloc_slot(si);
+		if (!start)
+			return entry;
+		len = 1;
+	}
+
+	*nr = len;
+	return swp_entry(si->type, start);
+}
+
+/**
+ * swap_free_hibernation_slot() - Give a run of slots back.
+ * @entry: the entry of the first slot of the run.
+ * @nr: how many slots it has.
+ */
+void swap_free_hibernation_slot(swp_entry_t entry, unsigned int nr)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	unsigned long offset = swp_offset(entry);
 	struct swap_cluster_info *ci;
-	pgoff_t offset = swp_offset(entry);
-
-	ci = swap_cluster_lock(si, offset);
-	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
-	swap_cluster_unlock(ci);
+	unsigned int ci_off, count;
+
+	/* A run can span clusters. */
+	while (nr) {
+		ci_off = offset % SWAPFILE_CLUSTER;
+		count = min(nr, SWAPFILE_CLUSTER - ci_off);
+		ci = swap_cluster_lock(si, offset);
+		if (cluster_table_is_alloced(ci))
+			__swap_cluster_free_entries(si, ci, ci_off, count);
+		else
+			hib_put_cluster_slots(si, ci, ci_off, count);
+		swap_cluster_unlock(ci);
+		offset += count;
+		nr -= count;
+	}
 }
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
@@ -139,6 +293,7 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	si->flags |= SWP_HIBERNATION;
 
 	spin_unlock(&swap_lock);
+	hib_session_begin(si);
 	return type;
 }
 
@@ -187,6 +342,7 @@ int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
 	old_si = swap_type_to_info(old_type);
 	if (new_si == old_si) {
 		spin_unlock(&swap_lock);
+		hib_session_begin(new_si);
 		return new_type;
 	}
 
@@ -200,6 +356,7 @@ int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
 	new_si->flags |= SWP_HIBERNATION;
 
 	spin_unlock(&swap_lock);
+	hib_session_begin(new_si);
 	return new_type;
 }
 
@@ -225,6 +382,7 @@ void unpin_hibernation_swap_type(int type)
 	}
 	si->flags &= ~SWP_HIBERNATION;
 	spin_unlock(&swap_lock);
+	hib_session_end();
 }
 
 /**
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cf519c5569c4..86ed8c6adae7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -514,6 +514,10 @@ static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
 	if (!IS_ENABLED(CONFIG_DEBUG_VM) && !swapoff)
 		return;
 
+	/* A cluster that has no table has no entries to look at. */
+	if (!cluster_table_is_alloced(ci))
+		return;
+
 	do {
 		swp_tb = __swap_table_get(ci, ci_off);
 		if (swp_tb_is_bad(swp_tb))
@@ -777,6 +781,13 @@ static void relocate_cluster(struct swap_info_struct *si,
 		if (ci->flags != CLUSTER_FLAG_FREE)
 			free_cluster(si, ci);
 	} else if (ci->count != SWAPFILE_CLUSTER) {
+		/*
+		 * A cluster taken whole without a table has nothing to
+		 * allocate from, so it waits off the lists until all of it
+		 * has been given back.
+		 */
+		if (!cluster_table_is_alloced(ci))
+			return;
 		if (ci->flags != CLUSTER_FLAG_FRAG)
 			move_cluster(si, ci, &si->frag_clusters[ci->order],
 				     CLUSTER_FLAG_FRAG);
-- 
2.48.1


