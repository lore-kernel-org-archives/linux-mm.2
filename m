Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BBFACAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02DC38E001D; Tue, 30 Sep 2025 02:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20318E0002; Tue, 30 Sep 2025 02:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE398E001D; Tue, 30 Sep 2025 02:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CAD988E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:33:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9668D1605E5
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:33:33 +0000 (UTC)
X-FDA: 83944950306.14.84655B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8F67B8000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:33:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P2c6fbyn;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759214011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaKuZHl8ULOi9Y3OWhrZVdv7KUYUV7Vg4Znf+WJn6ZY=;
	b=3RnHnq0Z8p487Z3dIMktz95VZCi0SCHqfQjhd+ZVe7NP7xIqF1r7ZRZ5XK6v3sXiE3OToF
	FPWkU2yhmCiyf9928TTL1ZQJ+b66uV/LQqh9W/v8002gtqf3tq7ifcgwynYTfbZpyHoiIy
	yvFnaIbex+p4ZULWQqPQlj/ciQgKpDk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759214011; a=rsa-sha256;
	cv=none;
	b=5jrQIsOJjGMjWOhQQBQq/xTdqpYVTCuKwGhiAvWqu3F+YnXXhRQWj7VEe56UXY1cfaneeZ
	avBYCLoPu8rHF0MNY1/F+Rr1Q6HHHyr6RfhLtbH4xAsGTFhvSt70oWOmSdAdfMN8o+QkHs
	lYI0Z+XtIj8o1QnM95APjG1/vFwL75Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P2c6fbyn;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759214010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UaKuZHl8ULOi9Y3OWhrZVdv7KUYUV7Vg4Znf+WJn6ZY=;
	b=P2c6fbynDOkdwSxs7zx0m+WrAlhbIDLR1yCwLB1LTWAWU3kdRhiPXJ/7XONh0G/+uLwdK4
	DuoIT8SD4vv28HN8Qe55WhOfDfoIKJEQ7QqnrTIUswGLqiz733QtS2nvTD5PiEWagp3UAY
	6yA3aO7+j1S0LeuTxoJTOlYqZNa8Tvg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-qlW79qn6OmGa25nljM4iZQ-1; Tue,
 30 Sep 2025 02:33:26 -0400
X-MC-Unique: qlW79qn6OmGa25nljM4iZQ-1
X-Mimecast-MFC-AGG-ID: qlW79qn6OmGa25nljM4iZQ_1759214005
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 334D019560A2;
	Tue, 30 Sep 2025 06:33:25 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A57CF180035E;
	Tue, 30 Sep 2025 06:33:20 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	youngjun.park@lge.com,
	aaron.lu@intel.com,
	baohua@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v3 1/2] mm/swap: do not choose swap device according to numa node
Date: Tue, 30 Sep 2025 14:33:09 +0800
Message-ID: <20250930063311.14126-2-bhe@redhat.com>
In-Reply-To: <20250930063311.14126-1-bhe@redhat.com>
References: <20250930063311.14126-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CMz8T0PHwtT7jCFwPWDinSzQsa-lihv_OcQcj1jUFcI_1759214005
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F67B8000A
X-Stat-Signature: hi63m86exgqff5ebxgymnjbe7cgxy5ph
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759214011-793839
X-HE-Meta: U2FsdGVkX183j/5gsr1QFWMEXQI7hmcHsXXf/PItaj2weCwJ6z8yzTqLyF7vuD3FOZtBMnQyk5hKDz6gHLCNQh5AQ66cmjsQVVcJ/8recuABMzh2nGH1N7IEmBk5JbEC6OF814QsdATvPT9EaNhb/a8suh6pF9Fz4xFD6P66zrmMbvEU1zQ4KkAZvwSAxKFWpZSyfmxW9JRiDhrCer9UwPVBKG0sQmiyhXva1ceiZHUSclrsVXg3zIebvJMiZsJgYlZ/bbAjZoF+63bYUhW3ggEyRq4PxrfleNKuMelivBcVXkcL1hK07wll8IRikEo+rvteMvIYBuFl4KP0quxx/+yc191V+JgNNFbQqUsMeHFGAEIZML7uynEKxubR+zoS7h/4VayI2EocIcUpNb5pLJ3bVxaePf0vVBb1IDtW2Petxe6lAnvrIk1vUFjBr7krQ3PD0+d64h5IDIMtvKhTb6STaouNQ96xEWKGpBkT5895BFj3k6BEgHpH/YmUybRWxcGp1+r9zipysueM5bUr164t6jxsVR8ON3nTWzpx5SZC+0UAjBJCoPALdHovjCfYpfROVrXIb/SdZkrFNb5LMYW1kYXHNBSPTKLPVp7HFbvbWE96A51V0S/hzR8WJPFnMPKf8gWHg2picbj1V6qDHTQTtDGZre9ZL5y/uTpuCyS2WCUhmnyNqyrP6MT70ff/EUoaU/UJnAp55lKUFTbUUoviytWu8q3q997Y6eM0rFIZ46PlJ9qP8lGvrNFFydcJvWKpWHRbv1gMOuqYtquCaLLcwX9+IdKgT74NfHlrkdeHqy72uscXlwAPyc57SQNpxShRwxQEe1wKH/MJd5z+FEqFrdT7Z9OnaKmiRZZvAOQVV8mT3gs2tVTMK+8iyF9hLo8kjXuh1bpMz1cVdVfsmAakrdYNhae8XRABol5mc7yTilGjtegd5LAzfE/kb/hZLEdWTjiP1mIFN/uWp1I
 Zp2pI+eN
 bO5c/XAIf72gWu4F6SZo+mWQppO8do3FqC2oysjGybhVE1KCjLPSKGZqiDNDQp4FpsCdwNJO/fdHYxLaH8nU2HbZj5NAhHgEaVwP3e5puaiSRVybb0IedQf2ZP9HDvk8rNAnk1Q6xDfgz1ZU4n4Yvoj83nyaO387b+YRR+OOqNOdD09GWdzYMR6QZQeiWaICUi+s289hjh9S1EmJmyncdcQW0uJl+ovBWM7c1oLVfyl17lSv8hNP7kOnFwW33+F49GmYx6sYGzQ6Kaf00zQFe/3nGlhx6Rpy+o79BiD6RcGED5hb12GYYAXdlE9qx1Xq5ZIC7+RZJpyZqatpqU5Oopl8XRQ==
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

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 Documentation/admin-guide/mm/swap_numa.rst | 78 ----------------------
 include/linux/swap.h                       | 11 +--
 mm/swapfile.c                              | 76 ++++-----------------
 3 files changed, 14 insertions(+), 151 deletions(-)
 delete mode 100644 Documentation/admin-guide/mm/swap_numa.rst

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
index 1ee5c0bc4b25..5b7a39b20f58 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -337,16 +337,7 @@ struct swap_info_struct {
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
index b4f3cc712580..f9b3667fb08a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -73,7 +73,7 @@ atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-static int least_priority = -1;
+static int least_priority;
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -102,7 +102,7 @@ static PLIST_HEAD(swap_active_head);
  * is held and the locking order requires swap_lock to be taken
  * before any swap_info_struct->lock.
  */
-static struct plist_head *swap_avail_heads;
+static PLIST_HEAD(swap_avail_head);
 static DEFINE_SPINLOCK(swap_avail_lock);
 
 static struct swap_info_struct *swap_info[MAX_SWAPFILES];
@@ -995,7 +995,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 /* SWAP_USAGE_OFFLIST_BIT can only be set by this helper. */
 static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 {
-	int nid;
 	unsigned long pages;
 
 	spin_lock(&swap_avail_lock);
@@ -1024,8 +1023,7 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 			goto skip;
 	}
 
-	for_each_node(nid)
-		plist_del(&si->avail_lists[nid], &swap_avail_heads[nid]);
+	plist_del(&si->avail_list, &swap_avail_head);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1034,7 +1032,6 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
 static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 {
-	int nid;
 	long val;
 	unsigned long pages;
 
@@ -1067,8 +1064,7 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 			goto skip;
 	}
 
-	for_each_node(nid)
-		plist_add(&si->avail_lists[nid], &swap_avail_heads[nid]);
+	plist_add(&si->avail_list, &swap_avail_head);
 
 skip:
 	spin_unlock(&swap_avail_lock);
@@ -1211,16 +1207,14 @@ static bool swap_alloc_fast(swp_entry_t *entry,
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
@@ -1245,7 +1239,7 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 		 * still in the swap_avail_head list then try it, otherwise
 		 * start over if we have not gotten any slots.
 		 */
-		if (plist_node_empty(&next->avail_lists[node]))
+		if (plist_node_empty(&si->avail_list))
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
@@ -2535,25 +2529,11 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
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
@@ -2563,16 +2543,7 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
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
@@ -2728,10 +2699,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -2972,9 +2940,8 @@ static struct swap_info_struct *alloc_swap_info(void)
 	struct swap_info_struct *p;
 	struct swap_info_struct *defer = NULL;
 	unsigned int type;
-	int i;
 
-	p = kvzalloc(struct_size(p, avail_lists, nr_node_ids), GFP_KERNEL);
+	p = kvzalloc(sizeof(struct swap_info_struct), GFP_KERNEL);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
@@ -3013,8 +2980,7 @@ static struct swap_info_struct *alloc_swap_info(void)
 	}
 	p->swap_extent_root = RB_ROOT;
 	plist_node_init(&p->list, 0);
-	for_each_node(i)
-		plist_node_init(&p->avail_lists[i], 0);
+	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
 	spin_unlock(&swap_lock);
 	if (defer) {
@@ -3282,9 +3248,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!swap_avail_heads)
-		return -ENOMEM;
-
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
@@ -3904,7 +3867,6 @@ static bool __has_usable_swap(void)
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
 	struct swap_info_struct *si, *next;
-	int nid = folio_nid(folio);
 
 	if (!(gfp & __GFP_IO))
 		return;
@@ -3923,8 +3885,8 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid],
-				  avail_lists[nid]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_head,
+				  avail_list) {
 		if (si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
@@ -3936,18 +3898,6 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 
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
 
 #ifdef CONFIG_MIGRATION
-- 
2.41.0


