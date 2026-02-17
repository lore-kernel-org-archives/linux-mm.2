Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43FD2E9A03F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3C296B008A; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0C646B0093; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C506B008A; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 699E96B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00E7E1A0330
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:51 +0000 (UTC)
X-FDA: 84455031864.17.B80019A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1EBF3140007
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6uF1aGj;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358810;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agB/4TL8tvT2nOTji/obaSJzD1a3lD+0Apgh4tv7UI4=;
	b=7F0n+lP0pXJdx0lL2/M7mlZ2/MoOa/Yh4DrZNZjOGWjQlKYkTF0D828/PdZtBjvITYC0dx
	/Jkfffltiv20JXtFdX8fuaqGERx0Fn2XsPdSAmPYT/jzfSvHW4e1GLrrvke0qoEzrzU7kx
	99VKqWqa2NWCmh/K6wFwWqrTsTHWUkg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6uF1aGj;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358810; a=rsa-sha256;
	cv=none;
	b=0Mk6iKA29ekVS08SG6prvp7ScGtsTkYQg5FdSrekfoOO+zl8XUSir88oY6X+x2ZJxlZb6P
	KaFVwH+9ArUR2VrfM8UcoVTUuezf6FKVMk9p0SOnfvBvEMAsbUVCxk+WyCkx8e61fqqaEU
	IMc1+n28bb0CyOALnMJqo7Aufnn/9ps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 546CD61850;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E995CC19421;
	Tue, 17 Feb 2026 20:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=+eK6UewPnQmrxKYMsML4U0aU8M8z+8m0mhWJHISYPAw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N6uF1aGjuqOLKmVbR2TFQFrJAt4AsGAqGEMS+bcRAqDWg47BUqK0Wm2+fj8goKjAu
	 DDOYZpCALw3L1TWrRVZPuL4YLaXvJf/KZEYzNQebriQPf2Ah+Hc7nesS/AxCKQMHak
	 GuJV+1ZqPy/8VB0h3U+cYLsvh5CMF21istjcuzdhlZnRg92IyH+jWH7qxeTqnXC7zX
	 8bp+0ADjHdufyr8wpTYEgbbJaWftYaPuAT+UsZSoenE744JZgiam7LCbWvulH2rtLW
	 2r8JyIXkeVfVFv0bZ4Tpbipl78eJYrW98e5M0Ma3AD+m8XUknFHoIRjfGZeMW3ycpD
	 nKGHMawdW7gwg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C28E9A041;
	Tue, 17 Feb 2026 20:06:48 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:27 +0800
Subject: [PATCH v3 02/12] mm, swap: clean up swapon process and locking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-2-f4e34be021a7@tencent.com>
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=8467;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=cXxlqHGPfGLZ+xxFfflkhqzyXoFTJzecvgOjxPIT7dk=;
 b=debkdUGCJ8SWpduIqzZr3a91hAr96TjXndj2kwo29jnkA/RGFjU1eIWOHZj7hLrcYm7kJhTdx
 lWi1fc2bfSGBvmn3eLdYGOquSqZo+cxXuFQ0AZQI+JY7m2inQxRB/Vh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EBF3140007
X-Rspamd-Server: rspam02
X-Stat-Signature: bfgsabsksfqyro8kr4ibuc774gb7czyp
X-HE-Tag: 1771358809-895641
X-HE-Meta: U2FsdGVkX1+RkpPsrmbVldZThbBUHkEa+CqATZfXgZW2SRDOKkM6IDGutOzxDUH5NtCDgv9RIjY1xyiZnWu1b3XjF56PoKZ19J+IM1pK5Dl+0O/CrUVsjNg84bn1HNA1AyHI5WXHoB9TfWlv4efezDydErUO8PLlBOtuCirl4xK3CQHEimVy7ptOvCcTLz+mJ//ZDpFmGzbNjjr2p8zc9tIpSVJL30bX2cxwl3c8ZyQ15l5B6MWmxe3Jshk7xLJqubhd9Mg4oaO8NmShFVHZHl4wZc4yDnnSIRGCHNF8lYxyz42f5dr5Nf9AohiwwGnzAHztxUcMb0zQ//EOAKHQ25iwYbS12QZ6fSGHJEzrUYtEqsguE/p10vTeL4TTj9WR4f7TDZTC9MrW5X7IaRzTvkzD3C1TwJMgRPD6LrGdXH0Z4T6JXWI3DQaPL1lnbUTdLhYv3bbpq2038O1+tlQp5WQbTDZYYOM5LJgcB+cTPhg0K9oo73D5VXQB4vi+ZjYghwqZkt2jnTdhujAKbmu4+5X+qo0SwwH63IBb/iKo9uwl1npC5vgDFDgnOjACMd/IG9xFS76k0X7iU/K5bHAgYVzRBKXKvKBpCfBgILwzmrqiOSHLwOYVeE8Uk+qFpHb3v0uTZnBSlYxJudW/g1I+ibaUT3vdeAZ2o5NZ1/EZKhSG2MyEE6gSjHpOG6Rr6bqWf9YFJtmrvyJoxfCpGqb5LLZehBPsg9fqng1pQSsKiyXJ5GehzRgbLMManoxnAqCcn8uhCsmSK4zg3ErIVRsc1i5WLgJfB+L4oxDrkqcti2W3YtgnjsQUu4dRjruqer1ZBCZEk2oK0x7Z3iOLITIplE3kDEjNm2p2wm5sqNyfskdrkUNFKa3dnj4d9wM7f4MjT5viMKgFOgO6e5xGakH8vQZoXJ5miz7sVjxNxkU7sn/UAxoVHXRDBTbzQ96QwLMQ1wQp7X4UEJZT94IHMFE
 dvlRGPQz
 yViAP5k6kOOkBGNUdy4dZqmVEqA/1NoBMi4QyEuX8lkIwjw7zSdoqovGKv+regPW+PV6y+L2wuv7XZzrN+dbX/BfJH+w8y0G+p5agHqFAOckSoSN1Vuxm9whde2aL0gKKPOzboixeQvVzLQGCppsyiNdn3bQK4S4z+Bsdi5XNuUgI+ogNYrh+tLgbNzlf6EDHP91KZoCnB0CfdjjNXdJMtPD+2NJGDPzvMIgw37P2+hOffhia7eCIR25NVwSUQrBbukH1fMP137CviyrUf9Sd9xCYcurC8TjpR233L/xUWkcm27baAdc1Pa5EqH3yDTws1bdsDZ3ywk2rDWQfdU8aeCLUZeGO0RZI6cHwIuk9X7cgJ7BGfJ9sp5GB3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Slightly clean up the swapon process. Add comments about what swap_lock
protects, introduce and rename helpers that wrap swap_map and
cluster_info setup, and do it outside of the swap_lock lock.

This lock protection is not needed for swap_map and cluster_info setup
because all swap users must either hold the percpu ref or hold a stable
allocated swap entry (e.g., locking a folio in the swap cache) before
accessing. So before the swap device is exposed by enable_swap_info,
nothing would use the swap device's map or cluster.

So we are safe to allocate and set up swap data freely first, then
expose the swap device and set the SWP_WRITEOK flag.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 87 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 25dfe992538d..8fc35b316ade 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -65,6 +65,13 @@ static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
 			 enum swap_cluster_flags new_flags);
 
+/*
+ * Protects the swap_info array, and the SWP_USED flag. swap_info contains
+ * lazily allocated & freed swap device info struts, and SWP_USED indicates
+ * which device is used, ~SWP_USED devices and can be reused.
+ *
+ * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
+ */
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
@@ -2657,8 +2664,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 }
 
 static void setup_swap_info(struct swap_info_struct *si, int prio,
-			    unsigned char *swap_map,
-			    struct swap_cluster_info *cluster_info,
 			    unsigned long *zeromap)
 {
 	si->prio = prio;
@@ -2668,8 +2673,6 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
 	 */
 	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
-	si->swap_map = swap_map;
-	si->cluster_info = cluster_info;
 	si->zeromap = zeromap;
 }
 
@@ -2687,13 +2690,11 @@ static void _enable_swap_info(struct swap_info_struct *si)
 }
 
 static void enable_swap_info(struct swap_info_struct *si, int prio,
-				unsigned char *swap_map,
-				struct swap_cluster_info *cluster_info,
-				unsigned long *zeromap)
+			     unsigned long *zeromap)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, prio, swap_map, cluster_info, zeromap);
+	setup_swap_info(si, prio, zeromap);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
 	/*
@@ -2711,7 +2712,7 @@ static void reinsert_swap_info(struct swap_info_struct *si)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, si->prio, si->swap_map, si->cluster_info, si->zeromap);
+	setup_swap_info(si, si->prio, si->zeromap);
 	_enable_swap_info(si);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
@@ -2735,8 +2736,8 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	}
 }
 
-static void free_cluster_info(struct swap_cluster_info *cluster_info,
-			      unsigned long maxpages)
+static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
+				   unsigned long maxpages)
 {
 	struct swap_cluster_info *ci;
 	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
@@ -2894,7 +2895,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->global_cluster = NULL;
 	vfree(swap_map);
 	kvfree(zeromap);
-	free_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(cluster_info, maxpages);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
 
@@ -3243,10 +3244,15 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 
 static int setup_swap_map(struct swap_info_struct *si,
 			  union swap_header *swap_header,
-			  unsigned char *swap_map,
 			  unsigned long maxpages)
 {
 	unsigned long i;
+	unsigned char *swap_map;
+
+	swap_map = vzalloc(maxpages);
+	si->swap_map = swap_map;
+	if (!swap_map)
+		return -ENOMEM;
 
 	swap_map[0] = SWAP_MAP_BAD; /* omit header page */
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -3267,9 +3273,9 @@ static int setup_swap_map(struct swap_info_struct *si,
 	return 0;
 }
 
-static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
-						union swap_header *swap_header,
-						unsigned long maxpages)
+static int setup_swap_clusters_info(struct swap_info_struct *si,
+				    union swap_header *swap_header,
+				    unsigned long maxpages)
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
@@ -3339,10 +3345,11 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 		}
 	}
 
-	return cluster_info;
+	si->cluster_info = cluster_info;
+	return 0;
 err:
-	free_cluster_info(cluster_info, maxpages);
-	return ERR_PTR(err);
+	free_swap_cluster_info(cluster_info, maxpages);
+	return err;
 }
 
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
@@ -3358,9 +3365,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned char *swap_map = NULL;
 	unsigned long *zeromap = NULL;
-	struct swap_cluster_info *cluster_info = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
@@ -3371,6 +3376,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/*
+	 * Allocate or reuse existing !SWP_USED swap_info. The returned
+	 * si will stay in a dying status, so nothing will access its content
+	 * until enable_swap_info resurrects its percpu ref and expose it.
+	 */
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
@@ -3453,18 +3463,17 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	maxpages = si->max;
 
-	/* OK, set up the swap map and apply the bad block list */
-	swap_map = vzalloc(maxpages);
-	if (!swap_map) {
-		error = -ENOMEM;
+	/* Setup the swap map and apply bad block */
+	error = setup_swap_map(si, swap_header, maxpages);
+	if (error)
 		goto bad_swap_unlock_inode;
-	}
 
-	error = swap_cgroup_swapon(si->type, maxpages);
+	/* Set up the swap cluster info */
+	error = setup_swap_clusters_info(si, swap_header, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	error = setup_swap_map(si, swap_header, swap_map, maxpages);
+	error = swap_cgroup_swapon(si->type, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
 
@@ -3492,13 +3501,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		inced_nr_rotate_swap = true;
 	}
 
-	cluster_info = setup_clusters(si, swap_header, maxpages);
-	if (IS_ERR(cluster_info)) {
-		error = PTR_ERR(cluster_info);
-		cluster_info = NULL;
-		goto bad_swap_unlock_inode;
-	}
-
 	if ((swap_flags & SWAP_FLAG_DISCARD) &&
 	    si->bdev && bdev_max_discard_sectors(si->bdev)) {
 		/*
@@ -3551,7 +3553,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 
 	si->swap_file = swap_file;
-	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
+
+	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
+	enable_swap_info(si, prio, zeromap);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
@@ -3577,13 +3581,18 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
 	swap_cgroup_swapoff(si->type);
+	vfree(si->swap_map);
+	si->swap_map = NULL;
+	free_swap_cluster_info(si->cluster_info, si->max);
+	si->cluster_info = NULL;
+	/*
+	 * Clear the SWP_USED flag after all resources are freed so
+	 * alloc_swap_info can reuse this si safely.
+	 */
 	spin_lock(&swap_lock);
 	si->flags = 0;
 	spin_unlock(&swap_lock);
-	vfree(swap_map);
 	kvfree(zeromap);
-	if (cluster_info)
-		free_cluster_info(cluster_info, maxpages);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
 	if (swap_file)

-- 
2.52.0



