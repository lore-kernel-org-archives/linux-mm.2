Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA393CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 03:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2718980109; Mon, 27 Oct 2025 23:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22224800E4; Mon, 27 Oct 2025 23:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1383D80109; Mon, 27 Oct 2025 23:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3F06800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:43:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAB961A03A8
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:43:51 +0000 (UTC)
X-FDA: 84046129062.07.7CB527B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1A31140007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:43:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hOea8Nhg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761623029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cGskdcEbPZaJiTVrpU62iK/1bqOuf0HQox86o8TsR4=;
	b=PcUcmAiynfYQhrghcfJLvEUIzz6D8QBrHOD7r5jRgtNbBUNk20Nhlpx7he6tYD/OQ1P7LU
	+NUe3KgftF4F+S9FFC3YAAs7SZkzfFmExpYBCsQMZ4gFpiQUJptz48QAFg153jYmuM7Nlu
	eWil1q9PgZvTNakWXIP53lLiePfHshg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hOea8Nhg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761623029; a=rsa-sha256;
	cv=none;
	b=SChwFqxallnAm5mIB2HZs18ilEjaeEgt+Xl81Utm744DDJVIM9oW22k9Ey6hfSkSRMCfrd
	eyi0e1k3Qh6GPsqMhq0kN936fW7N2Ix8jZa0/vwfRXusQ8z+0Oz4Oyx3UiwaVDiUmTnots
	xGF8bTh7pCeahiK8Knfxb9w8M8dd7f4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761623029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4cGskdcEbPZaJiTVrpU62iK/1bqOuf0HQox86o8TsR4=;
	b=hOea8NhgPQ2CVG55DEQ1CS909D2t5rc0AJZT0nhmHkJBCsMuiDZRGGGRC3XjSDDWUb+T1e
	da6dGgOrEgOJ883miErF8yarbwhPVa0kw2YZerR5F7qaOPIIPLSFnlONQBGlNKfyt1yA7G
	WXR9B/utOTIrPpLYfHeKkARlCU6SRec=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-qgH3qWwRNpS9TYFZkrVzZw-1; Mon,
 27 Oct 2025 23:43:44 -0400
X-MC-Unique: qgH3qWwRNpS9TYFZkrVzZw-1
X-Mimecast-MFC-AGG-ID: qgH3qWwRNpS9TYFZkrVzZw_1761623023
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D2B01808985;
	Tue, 28 Oct 2025 03:43:43 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.212])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1C3341800581;
	Tue, 28 Oct 2025 03:43:37 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	kasong@tencent.com,
	baohua@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 mm-new 1/2] mm/swap: do not choose swap device according to numa node
Date: Tue, 28 Oct 2025 11:43:07 +0800
Message-ID: <20251028034308.929550-2-bhe@redhat.com>
In-Reply-To: <20251028034308.929550-1-bhe@redhat.com>
References: <20251028034308.929550-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lJIi910kzeCGP75lJ0WGClfVi1l_WeM5jwS_NcA-RAs_1761623023
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C1A31140007
X-Rspamd-Server: rspam03
X-Stat-Signature: dj8ekj41gytjkub5maou63t467u7a7w3
X-HE-Tag: 1761623029-978851
X-HE-Meta: U2FsdGVkX19YHZDh03P8VAQTHZLNdMil7efX08fv/I0kqUvZWj1xeYsbKq+Ku1R0P6xJ7JWPhAPeUsjBAqW/MPAFZqdCtvb+WkYnTVSn0D5Alhi3tza0GBVlpaHuTwe1HLAe6Y2lt7J2lPWVwfZKyFf7WgxdaB4PqE21tOv7K9FXZHIHtpr+IvBaDilaqq4esf4qKBiNH4Be3+JrB9nXBB5xKnynzLO0BAhaZ6vKgieJjIqL22UL7Tnx3qpb0We49iiAmwTo3D6YLPCXY3fuA3q+nxrbL/ekW3bDXXjgKudQXNxrqKdIp7rDyxUyef8xXDnSO7abua/gnjNBJsV0ihD37tNnDG5v3naVOtSGCInxj1myibYqJ067KGkgJFTZ0eopETqxLImAIW2CGpmr/M3NstovHU67U3DVRFOY6BnfvSsNgVwatdc6oQ6HWR2pZ2fwwQ8xg8JC/4n8r9/ajP/r0vnrXfcwzcJd6hPZaJkhUBTVyLDIA90PVYY2sLQ131U28IyRqjyKXlwGZXAPKkOphKJrcoznvnBzAogEwG2NWpQtGy3cKlFxEHM8r9PJYXo6USnJWnU3jlHPhIAzFaWZnuqfRtJGECa86C8kfZrt5PuLtz7fB4EytPmNkRav5a2Iim5HFNcHddn2HAqUIEjk4sROFV4xGempySr8/JHll8toHLgWp5AbozhEEWiHCaKjGrsoB4P1kPIOqbt6heI2ns2Z6wjqG3p/ZSXf3HStGj97aoWd8+98RKN4p4IqF10xlKdYbaOThQQ4hO9swTHV3CB9O7PjHtYZwUzmOxVvsoNpI8QLK3cBgzhEQC+ll86LrS7JrCUzMKD/E+ioBeT9lNr1Rg2DvpWPYzB25j+K2hwZmw+QbKYN5dpTkrKhrUyf3nfb/yaO1rTmiIW75P4nMiOtVB7ajO5aJB525MYCuBqMWyH76yV44RvcJzgUHc+imM5PXAo0uYLSNqk
 fYhmSPi2
 ZnEllic+XyPSagg9PJZtCP/jOp7Pu4k5KiD0HN3Jh++vjtsOe/GCncHATfsQ7rxGKJbJK8y2sXpEoW4KiIvLyuPEruJKGJ1U67+EsI0wTd2K4RkO1m0iAkJLnkQbl4laKbLP5Gerogf5D8slsWvQ/FZVGQ0uRNnZjMEfuwvu4kck5J7no58arN1qFZTq22QD8tnRLg3Q3MRMXvy1ltLMTEszRcBtZBsBejzxy2a2VBgm976EydvAOzIaXdEUyqBoxB1ZBo15QyB6z3XP7/r+Rsltvq6xVsvGBrsjfdwGQxqr71v79MKoMrSFanZB6HA3uPh4dvgCAyqE9CNuyL6DosCceHAfQGrfQSXl3mPa3VWKZRXE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit a2468cc9bfdf ("swap: choose swap device according
to numa node").

After this patch, the behaviour will change back to pre-commit
a2468cc9bfdf. Means the priority will be set from -1 then downwards by
default, and when swapping, it will exhault swap device one by one
according to priority from high to low. This is preparation work for
later change.

[root@hp-dl385g10-03 ~]# swapon
NAME       TYPE      SIZE   USED PRIO
/dev/zram0 partition  16G    16G   -1
/dev/zram1 partition  16G 966.2M   -2
/dev/zram2 partition  16G     0B   -3
/dev/zram3 partition  16G     0B   -4

Suggested-by: Chris Li <chrisl@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
---
 Documentation/admin-guide/mm/index.rst     |  1 -
 Documentation/admin-guide/mm/swap_numa.rst | 78 ---------------------
 include/linux/swap.h                       | 11 +--
 mm/swapfile.c                              | 80 ++++------------------
 4 files changed, 15 insertions(+), 155 deletions(-)
 delete mode 100644 Documentation/admin-guide/mm/swap_numa.rst

diff --git a/Documentation/admin-guide/mm/index.rst b/Documentation/admin-guide/mm/index.rst
index ebc83ca20fdc..bbb563cba5d2 100644
--- a/Documentation/admin-guide/mm/index.rst
+++ b/Documentation/admin-guide/mm/index.rst
@@ -39,7 +39,6 @@ the Linux memory management.
    shrinker_debugfs
    slab
    soft-dirty
-   swap_numa
    transhuge
    userfaultfd
    zswap
diff --git a/Documentation/admin-guide/mm/swap_numa.rst b/Documentation/admin-guide/mm/swap_numa.rst
deleted file mode 100644
index 2e630627bcee..000000000000
--- a/Documentation/admin-guide/mm/swap_numa.rst
+++ /dev/null
@@ -1,78 +0,0 @@
-===========================================
-Automatically bind swap device to numa node
-===========================================
-
-If the system has more than one swap device and swap device has the node
-information, we can make use of this information to decide which swap
-device to use in get_swap_pages() to get better performance.
-
-
-How to use this feature
-=======================
-
-Swap device has priority and that decides the order of it to be used. To make
-use of automatically binding, there is no need to manipulate priority settings
-for swap devices. e.g. on a 2 node machine, assume 2 swap devices swapA and
-swapB, with swapA attached to node 0 and swapB attached to node 1, are going
-to be swapped on. Simply swapping them on by doing::
-
-	# swapon /dev/swapA
-	# swapon /dev/swapB
-
-Then node 0 will use the two swap devices in the order of swapA then swapB and
-node 1 will use the two swap devices in the order of swapB then swapA. Note
-that the order of them being swapped on doesn't matter.
-
-A more complex example on a 4 node machine. Assume 6 swap devices are going to
-be swapped on: swapA and swapB are attached to node 0, swapC is attached to
-node 1, swapD and swapE are attached to node 2 and swapF is attached to node3.
-The way to swap them on is the same as above::
-
-	# swapon /dev/swapA
-	# swapon /dev/swapB
-	# swapon /dev/swapC
-	# swapon /dev/swapD
-	# swapon /dev/swapE
-	# swapon /dev/swapF
-
-Then node 0 will use them in the order of::
-
-	swapA/swapB -> swapC -> swapD -> swapE -> swapF
-
-swapA and swapB will be used in a round robin mode before any other swap device.
-
-node 1 will use them in the order of::
-
-	swapC -> swapA -> swapB -> swapD -> swapE -> swapF
-
-node 2 will use them in the order of::
-
-	swapD/swapE -> swapA -> swapB -> swapC -> swapF
-
-Similaly, swapD and swapE will be used in a round robin mode before any
-other swap devices.
-
-node 3 will use them in the order of::
-
-	swapF -> swapA -> swapB -> swapC -> swapD -> swapE
-
-
-Implementation details
-======================
-
-The current code uses a priority based list, swap_avail_list, to decide
-which swap device to use and if multiple swap devices share the same
-priority, they are used round robin. This change here replaces the single
-global swap_avail_list with a per-numa-node list, i.e. for each numa node,
-it sees its own priority based list of available swap devices. Swap
-device's priority can be promoted on its matching node's swap_avail_list.
-
-The current swap device's priority is set as: user can set a >=0 value,
-or the system will pick one starting from -1 then downwards. The priority
-value in the swap_avail_list is the negated value of the swap device's
-due to plist being sorted from low to high. The new policy doesn't change
-the semantics for priority >=0 cases, the previous starting from -1 then
-downwards now becomes starting from -2 then downwards and -1 is reserved
-as the promoted value. So if multiple swap devices are attached to the same
-node, they will all be promoted to priority -1 on that node's plist and will
-be used round robin before any other swap devices.
diff --git a/include/linux/swap.h b/include/linux/swap.h
index a4b264817735..38ca3df68716 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -301,16 +301,7 @@ struct swap_info_struct {
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
-	struct plist_node avail_lists[]; /*
-					   * entries in swap_avail_heads, one
-					   * entry per node.
-					   * Must be last as the number of the
-					   * array is nr_node_ids, which is not
-					   * a fixed value so have to allocate
-					   * dynamically.
-					   * And it has to be an array so that
-					   * plist_for_each_* can work.
-					   */
+	struct plist_node avail_list;   /* entry in swap_avail_head */
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 125d893bb706..ce3580e2f4f4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -74,7 +74,7 @@ atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-static int least_priority = -1;
+static int least_priority;
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -103,7 +103,7 @@ static PLIST_HEAD(swap_active_head);
  * is held and the locking order requires swap_lock to be taken
  * before any swap_info_struct->lock.
  */
-static struct plist_head *swap_avail_heads;
+static PLIST_HEAD(swap_avail_head);
 static DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
@@ -1130,7 +1130,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 /* SWAP_USAGE_OFFLIST_BIT can only be set by this helper. */
 static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 {
-	int nid;
 	unsigned long pages;
 
 	spin_lock(&swap_avail_lock);
@@ -1159,8 +1158,7 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 			goto skip;
 	}
 
-	for_each_node(nid)
-		plist_del(&si->avail_lists[nid], &swap_avail_heads[nid]);
+	plist_del(&si->avail_list, &swap_avail_head);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1169,7 +1167,6 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
 static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 {
-	int nid;
 	long val;
 	unsigned long pages;
 
@@ -1202,8 +1199,7 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 			goto skip;
 	}
 
-	for_each_node(nid)
-		plist_add(&si->avail_lists[nid], &swap_avail_heads[nid]);
+	plist_add(&si->avail_list, &swap_avail_head);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1346,16 +1342,14 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 static bool swap_alloc_slow(swp_entry_t *entry,
 			    int order)
 {
-	int node;
 	unsigned long offset;
 	struct swap_info_struct *si, *next;
 
-	node = numa_node_id();
 	spin_lock(&swap_avail_lock);
 start_over:
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[node], avail_lists[node]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
 		/* Rotate the device and switch to a new cluster */
-		plist_requeue(&si->avail_lists[node], &swap_avail_heads[node]);
+		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
 			offset = cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE);
@@ -1380,7 +1374,7 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 		 * still in the swap_avail_head list then try it, otherwise
 		 * start over if we have not gotten any slots.
 		 */
-		if (plist_node_empty(&next->avail_lists[node]))
+		if (plist_node_empty(&si->avail_list))
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
@@ -1394,11 +1388,10 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 static bool swap_sync_discard(void)
 {
 	bool ret = false;
-	int nid = numa_node_id();
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
 			if (si->flags & SWP_PAGE_DISCARD)
@@ -2709,25 +2702,11 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static int swap_node(struct swap_info_struct *si)
-{
-	struct block_device *bdev;
-
-	if (si->bdev)
-		bdev = si->bdev;
-	else
-		bdev = si->swap_file->f_inode->i_sb->s_bdev;
-
-	return bdev ? bdev->bd_disk->node_id : NUMA_NO_NODE;
-}
-
 static void setup_swap_info(struct swap_info_struct *si, int prio,
 			    unsigned char *swap_map,
 			    struct swap_cluster_info *cluster_info,
 			    unsigned long *zeromap)
 {
-	int i;
-
 	if (prio >= 0)
 		si->prio = prio;
 	else
@@ -2737,16 +2716,7 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
 	 * low-to-high, while swap ordering is high-to-low
 	 */
 	si->list.prio = -si->prio;
-	for_each_node(i) {
-		if (si->prio >= 0)
-			si->avail_lists[i].prio = -si->prio;
-		else {
-			if (swap_node(si) == i)
-				si->avail_lists[i].prio = 1;
-			else
-				si->avail_lists[i].prio = -si->prio;
-		}
-	}
+	si->avail_list.prio = -si->prio;
 	si->swap_map = swap_map;
 	si->cluster_info = cluster_info;
 	si->zeromap = zeromap;
@@ -2919,15 +2889,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	del_from_avail_list(p, true);
 	if (p->prio < 0) {
 		struct swap_info_struct *si = p;
-		int nid;
 
 		plist_for_each_entry_continue(si, &swap_active_head, list) {
 			si->prio++;
 			si->list.prio--;
-			for_each_node(nid) {
-				if (si->avail_lists[nid].prio != 1)
-					si->avail_lists[nid].prio--;
-			}
+			si->avail_list.prio--;
 		}
 		least_priority++;
 	}
@@ -3168,9 +3134,8 @@ static struct swap_info_struct *alloc_swap_info(void)
 	struct swap_info_struct *p;
 	struct swap_info_struct *defer = NULL;
 	unsigned int type;
-	int i;
 
-	p = kvzalloc(struct_size(p, avail_lists, nr_node_ids), GFP_KERNEL);
+	p = kvzalloc(sizeof(struct swap_info_struct), GFP_KERNEL);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
@@ -3209,8 +3174,7 @@ static struct swap_info_struct *alloc_swap_info(void)
 	}
 	p->swap_extent_root = RB_ROOT;
 	plist_node_init(&p->list, 0);
-	for_each_node(i)
-		plist_node_init(&p->avail_lists[i], 0);
+	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
 	spin_unlock(&swap_lock);
 	if (defer) {
@@ -3467,9 +3431,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!swap_avail_heads)
-		return -ENOMEM;
-
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
@@ -4079,7 +4040,6 @@ static bool __has_usable_swap(void)
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
 	struct swap_info_struct *si, *next;
-	int nid = folio_nid(folio);
 
 	if (!(gfp & __GFP_IO))
 		return;
@@ -4098,8 +4058,8 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid],
-				  avail_lists[nid]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_head,
+				  avail_list) {
 		if (si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
@@ -4111,18 +4071,6 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 
 static int __init swapfile_init(void)
 {
-	int nid;
-
-	swap_avail_heads = kmalloc_array(nr_node_ids, sizeof(struct plist_head),
-					 GFP_KERNEL);
-	if (!swap_avail_heads) {
-		pr_emerg("Not enough memory for swap heads, swap is disabled\n");
-		return -ENOMEM;
-	}
-
-	for_each_node(nid)
-		plist_head_init(&swap_avail_heads[nid]);
-
 	swapfile_maximum_size = arch_max_swapfile_size();
 
 	/*
-- 
2.41.0


