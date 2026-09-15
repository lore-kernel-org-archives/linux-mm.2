Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CB7BC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5F36B00BE; Mon, 14 Sep 2026 23:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49CCC6B00BF; Mon, 14 Sep 2026 23:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CA16B00C0; Mon, 14 Sep 2026 23:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA4D6B00BE
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C9FBA02F0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:13 +0000 (UTC)
X-FDA: 85214535546.22.B6EBFBE
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7153FC0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789442232;
	b=zvt3tOkt9PoUAJLjUji8Gl/MQfrPykkVKORcG7xoeciYxJjGYpGaNtzTyuNYdS6tgwKeR+
	Tx8Vy/jNf9pQgqCuLpY1dHEoTKkp7YRuatKn+5RHRhaaYEbIxQOY32atN3DGjIAJ4st+Ya
	7yg3/l9sFLA+2LDkXG8xD1+feGQqH94=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cch3BT23Zv1nucK8xn1vQ4dMuGTzQVTedPP4PycMe4c=;
	b=4L5/srn77bwAS9KsMDFCq6BvK1pxOupXplZ8/DQO49SSHgcPtI3/1x0we4Md4Nxj71Wn7F
	A3cL2rUGvCnMMcQwl5rQVq+aoj0q0fxThTcM8poTZxlfa7cB+2OZPuQh0mDiUxr9bPt2mi
	r6qlF6Zt1v/Kq1ck0AsSdaolxBpqKQQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:09 +0900
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
Subject: [RFC PATCH 10/10] mm, swap: hold swap space back for a hibernation image at swapon
Date: Tue, 15 Sep 2026 12:16:58 +0900
Message-Id: <20260915031658.1505680-11-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7153FC0005
X-Stat-Signature: r54htimcigxrh55t3zioyuwmi8moihqw
X-HE-Tag: 1789442231-452023
X-HE-Meta: U2FsdGVkX1/LAprlyHE435dwheGSSYgWNjmd6AwuF/OYjFVBAJRfr1Y9MIoK2SkEtsvMNAA/StN7iP14+27Hmy9jCDlp4VDRYsS+YYu6fB62ON0c5KDr1Aw+lSOGhBv2vuq166IIsBAy613FV6AIUb32UKcqQOVxkwWQUgw+gGxbqIfajoArgttRCrcZu9Y47gBzpsMAVZZdlT1h9cfYgjNmG8OaJuu4S8DNQyUYxcYwVEa68EW1LScoRjuNQlP99ZmHBaDzmvSmtJg/Dm1212XS0wLqziRffZOWiFrDy0YCw69oRrCL28GZ1liNKQhU+BSRbvMYnpAkkKAqpwwGCwT6YZ6CCBb6xZaobyb3sFThxg/M0OUJeOHdRfoYbXNHCe9XfAHEq3tBq0sQF8JiBbb5bFu2QPwNhcTQbr9V6FwDV38V+W9vjsz79Ht4K3ygTr+tRG3NCRWfxktTdz4e/ZyTvKfKf1s2sphrdnfOGQq+Hyf2lOnY5ulKfiWY15wbLtBtvJMAFw9muzyvP2UxuO79kv4c3Fa2+Of6kg8UtlNA8SEBr0ZLq7zAt3dg2/ar/zG2kRpffgGPgnIQdY/MjJn9f5fLfI6rycgWHdVf/7MDmLJp6AU9AvR61rjx5HzXPcNgu8jn/Yg6Ce8OELpOwbwAIcsJOl0InG1NXlpRy+nYNsxXLiJMEG/yT2vuBEfCikQ9JETl0/jApOOf3JUi5aIV++mri7Jh0NwevSLMHhtd+5etNBoMWkFhnhJFi3oqOqVDpSOLQyymzPmZW++AGSBThXh3erQ568ffJ6XWeTE/3kq8Aecyunk/hmeYiDCy5DPmhB/kGue5HW6TgWqy9AX7zwVJ3BALRg9GKUYoij+1mz+gmnNufPWuHaBIGJt9hi9WkpBe+74pk7XyS9oXErs/WajUfk7PehKSjTFRejko3ApkaASNktZV+YLmRejuOgBd/fDqB1pqLygA/zM
 sbZZJX8n
 VQdWKdisymub3/9W6g6XVJ4Mj/s5EaDEX4LV+b8Q6nWKvt7GUg2QIDmPP6cZAMCkChqEnyrkY3gfuix8LN5Mct3MLoCpXgQCD8FrGfyZkknQPRjcRYfR2uFpS9IfrV3RadoKMXM/7R+0ThKjl6eg91NpXKDH1uyBkqE/f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hibernation takes whatever clusters are free when it runs, and an aged
device may have no long run of them.

At swapon, ask hibernation_reserve_pages() how much to hold back and set
aside that many empty clusters in a row.  Nothing uses the device yet,
so this needs no locking.  The run leaves si->pages and goes on no list,
so the allocator never sees it.  Hibernation hands it out whole, before
any other slot.  More than half of a device is refused.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h |  2 ++
 mm/swap_hibernate.c  | 78 ++++++++++++++++++++++++++++++++++++++++----
 mm/swapfile.c        | 23 ++++++++++++-
 3 files changed, 95 insertions(+), 8 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 94c894c7ad9d..66d59828b327 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -249,6 +249,8 @@ struct swap_info_struct {
 					/* list of cluster that are fragmented or contented */
 	unsigned int pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
+	unsigned int hib_reserve_start;	/* clusters held back for hibernation */
+	unsigned int hib_reserve_nr;	/* how many, 0 for none */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
 	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
 	struct rb_root swap_extent_root;/* root of the swap extent rbtree */
diff --git a/mm/swap_hibernate.c b/mm/swap_hibernate.c
index 23dc766f04cd..7475ae0966f3 100644
--- a/mm/swap_hibernate.c
+++ b/mm/swap_hibernate.c
@@ -5,10 +5,12 @@
  */
 
 /*
- * The image gets whole free clusters first, then single slots from the
- * allocator.  Clusters it does not use go back when the session ends.
+ * The image gets the run held at swapon first, then whole free clusters,
+ * then single slots from the allocator.  Free clusters it does not use go
+ * back when the session ends.
  */
 static struct swap_info_struct *hib_si;
+static unsigned int hib_reserve;	/* clusters held back, still to hand out */
 
 /* Free clusters set aside for the image, out of the allocator's reach. */
 static LIST_HEAD(hib_free_clusters);
@@ -38,6 +40,56 @@ static void hib_return_free_clusters(struct swap_info_struct *si)
 	spin_unlock(&si->lock);
 }
 
+static bool hib_cluster_reserved(struct swap_info_struct *si, unsigned int idx)
+{
+	return idx >= si->hib_reserve_start &&
+	       idx < si->hib_reserve_start + si->hib_reserve_nr;
+}
+
+/*
+ * Hold a run of empty clusters back for the image.  This runs at swapon
+ * before the device is in use, so it needs no lock.
+ *
+ * Return: the number of pages held, to be taken out of si->pages.
+ */
+static unsigned long hib_reserve_at_swapon(struct swap_info_struct *si,
+					   struct swap_cluster_info *cluster_info,
+					   unsigned long nr_clusters)
+{
+	unsigned long want, run = 0, i;
+
+	si->hib_reserve_start = 0;
+	si->hib_reserve_nr = 0;
+
+	if (!si->bdev)
+		return 0;
+	/* Swap files sharing a block device differ by their first block. */
+	want = DIV_ROUND_UP(hibernation_reserve_pages(si->bdev->bd_dev,
+						      first_se(si)->start_block),
+			    SWAPFILE_CLUSTER);
+	if (!want)
+		return 0;
+	if (want > nr_clusters / 2) {
+		pr_warn("swapon: %lu clusters for the hibernation image is more than half of the device\n",
+			want);
+		return 0;
+	}
+
+	for (i = 0; i < nr_clusters && run < want; i++)
+		run = cluster_info[i].count ? 0 : run + 1;
+	if (run < want) {
+		pr_warn("swapon: no run of %lu clusters for the hibernation image\n",
+			want);
+		return 0;
+	}
+
+	si->hib_reserve_start = i - want;
+	si->hib_reserve_nr = want;
+	pr_info("swapon: holding %lu clusters at %u back for the hibernation image\n",
+		want, si->hib_reserve_start);
+	return want * SWAPFILE_CLUSTER;
+}
+
 /*
  * Take a whole free cluster.  It gets no swap table, so cluster_is_usable()
  * keeps the allocator away from it.
@@ -130,6 +182,7 @@ static void hib_session_begin(struct swap_info_struct *si)
 	if (hib_si)
 		hib_return_free_clusters(hib_si);
 	hib_si = si;
+	hib_reserve = si->hib_reserve_nr;
 }
 
 static void hib_session_end(void)
@@ -189,6 +242,13 @@ swp_entry_t swap_alloc_hibernation_slot(unsigned int *nr)
 	if (WARN_ON_ONCE(!si))
 		return entry;
 
+	if (hib_reserve) {
+		*nr = hib_reserve * SWAPFILE_CLUSTER;
+		hib_reserve = 0;
+		return swp_entry(si->type,
+				 si->hib_reserve_start * SWAPFILE_CLUSTER);
+	}
+
 	len = hib_take_free(si, &start);
 	if (!len) {
 		start = hib_alloc_slot(si);
@@ -218,10 +278,13 @@ void swap_free_hibernation_slot(swp_entry_t entry, unsigned int nr)
 		ci_off = offset % SWAPFILE_CLUSTER;
 		count = min(nr, SWAPFILE_CLUSTER - ci_off);
 		ci = swap_cluster_lock(si, offset);
-		if (cluster_table_is_alloced(ci))
-			__swap_cluster_free_entries(si, ci, ci_off, count);
-		else
-			hib_put_cluster_slots(si, ci, ci_off, count);
+		/* A cluster held for the image is left as it is. */
+		if (!hib_cluster_reserved(si, cluster_index(si, ci))) {
+			if (cluster_table_is_alloced(ci))
+				__swap_cluster_free_entries(si, ci, ci_off, count);
+			else
+				hib_put_cluster_slots(si, ci, ci_off, count);
+		}
 		swap_cluster_unlock(ci);
 		offset += count;
 		nr -= count;
@@ -472,7 +535,8 @@ unsigned int count_swap_pages(int type, int free)
 
 		spin_lock(&sis->lock);
 		if (sis->flags & SWP_WRITEOK) {
-			n = sis->pages;
+			/* the run held back is there for the image */
+			n = sis->pages + sis->hib_reserve_nr * SWAPFILE_CLUSTER;
 			if (free)
 				n -= swap_usage_in_pages(sis);
 		}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 98ed75708661..3b79cec6fd27 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2182,6 +2182,18 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 
 #ifdef CONFIG_HIBERNATION
 #include "swap_hibernate.c"
+#else
+static unsigned long hib_reserve_at_swapon(struct swap_info_struct *si,
+					   struct swap_cluster_info *cluster_info,
+					   unsigned long nr_clusters)
+{
+	return 0;
+}
+
+static bool hib_cluster_reserved(struct swap_info_struct *si, unsigned int idx)
+{
+	return false;
+}
 #endif /* CONFIG_HIBERNATION */
 
 static inline int pte_same_as_swp(pte_t pte, pte_t swp_pte)
@@ -3379,6 +3391,13 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 			goto err;
 	}
 
+	/*
+	 * Whatever is held back for a hibernation image leaves si->pages, so
+	 * that it is never advertised as swap, and it goes on no list below,
+	 * so that the allocator cannot find it.
+	 */
+	si->pages -= hib_reserve_at_swapon(si, cluster_info, nr_clusters);
+
 	INIT_LIST_HEAD(&si->free_clusters);
 	INIT_LIST_HEAD(&si->full_clusters);
 	INIT_LIST_HEAD(&si->discard_clusters);
@@ -3391,7 +3410,9 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	for (i = 0; i < nr_clusters; i++) {
 		struct swap_cluster_info *ci = &cluster_info[i];
 
-		if (ci->count) {
+		if (hib_cluster_reserved(si, i)) {
+			ci->flags = CLUSTER_FLAG_NONE;
+		} else if (ci->count) {
 			ci->flags = CLUSTER_FLAG_NONFULL;
 			list_add_tail(&ci->list, &si->nonfull_clusters[0]);
 		} else {
-- 
2.48.1


