Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C265606A33E
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sqoBuSux
Received: by kanga.kvack.org (Postfix)
	id 4810A6B05C8; Sun, 22 Nov 2026 07:48:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A356B05C9; Sun, 22 Nov 2026 07:48:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8886B05CA; Sun, 22 Nov 2026 07:48:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4106B05C8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:48:34 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A88EC06E5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:33 +0000 (UTC)
X-FDA: 85462733706.13.77D7E3E
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7F26B40003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sqoBuSux;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351711;
	b=hpJhvZfcUkIlnzYFswm2LZQTziMl85dB7n6+aJHAyzGEr+XdIV1+HYOznCXXjr2zehrV64
	UXZ6/Eu5aOtDOsOLEULkQQEugyeFfmeXU94wGZMhonMaS9HNxZzbGMIew0AQxfE9VifV0T
	7K2ijhpAjPKhWuYDjJGzA8cvJCT1Hoo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWpHC929BGRiYzSAL7uFn6Yn75mqyH04ZOQRNnEh5E4=;
	b=vA7e5mP2bn0MHJ8oHY6CQWuRlNs9MyLtPaTLV/J3r/guJTF4DAZKNKge+xd3elTZUNJLYh
	OdCefZFImHDHQzZAVVPCwPXI9tp6sVx47Vh0vpNi5tpknLni8zv8wXP2mycXzn/4ZeMdBQ
	xzY5LyvdPPEeGf3Ce7N0fWaZW2QkL78=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sqoBuSux;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6v8sTTf6pcb85Lo4OtoCE2QJ+satgIKb50EQR+2ySec=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351710; v=1; x=1795956510;
 b=sqoBuSux8Js1l1iFt02kPszQ1/xsLzn1M0RlCTmyNjqog8l3SdbUabO2IA2gfwQMZ0m8BNB1
 AI38qLrYfjZ/LYu9y+lDsia6A/F7/KhO4mC9h7WbDLdJGyFKvUGoYZR+cL/4UWYTW5gzoTHKDVv
 KPcp6MPlfGvMdihBLgH27uRk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id adc6a1e29aeff931;
	Sun, 22 Nov 2026 12:48:30 +0000
X-Mizu-Trace-ID: adc6a1e29aeff931
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
Subject: [PATCH v6 11/14] mm, swap: add xswap grow trigger on cluster allocation
Date: Sun, 22 Nov 2026 20:48:11 +0800
Message-ID: <20261122124814.3489077-2-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122124814.3489077-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
 <20261122124814.3489077-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: padap4mbhnukw9fjgopxjijgto4p9rdp
X-Rspamd-Queue-Id: 7F26B40003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795351711-130853
X-HE-Meta: U2FsdGVkX19+Lq0ZQQt2OxyBQe33R27lh21PDLBCMejEkXkztWEl5Rx4/+vgC0djilMDvZPkBdaSQ0ziL04zMW/O6guzCK/usjdosgpjlAmpo0ZpK0US+8mkyw5uqyHCefaBo2dpe6aH8HGvBBq87+SfsSQ8sHo8wQzIqvjdkmWNBTg80Lm8sJYE57Q3KdZ4EHcImc+cEsd383IG1DWL9yDXTJ99ZjNjXTNcR///1j5Vm0gGYQNbflexEZChGYSfuNixAtKy1OrutJxX+DIPuwUMnA7j3B8IVlYELBmhaKtopZRgwxj6AMmfQ3nxyYhEhvTyKHQWbqMZyy12ORN87wbsxcPqz43g5ZexQkyJaM+qhDUjWeb/c+sYB05GiOLfd6VOnGYc5d2VEWnj+ut7JzEfaFkEkm0Shsnq93ukiwkuxlXilmsXhgkZhA+pwdZIQs85b9Rv/HTp9fhZdBgG89AH1VRRvSjSngwCMAeao+HCEk/cyMd99shOmryguuLmSV3i2rlm3zcKm6bnFypgHRr5t9/zTu+W6XsaON3AwdRwtlx4DoPPuOzURneQazcgjHbjajxfFCoaVSJyJuAVOUqNjAjOkCrmNZY9hKk4DC3yhX2e0r++tsaGDowW4m4bQFicTtj3ix0tIfGrln0as45danfauvo1W66K4wXT8ge0uuX+cIlSLVdOdWyME2kc8LJmXChQBZJ47sxC0GPHo61oLTS4A3h4Zxs7p1PEa1sTnUWsepB2fthllwk//+jeEJsoglzC/d/HYegdVevMdS9bmJIhR6EOf/gX5vDh9BHEN0Xh3qdZxVvY9O2CCMnvuqruerK/dLzoRqtFR00ZyXSHGfz+oX5LJbfihpby8igXm0Pk4X0DZ8NrhUBRxNFd2YkIVdhjv+o5KdW/S9qm30XSx6ioI4M3ZKFy8eIZgkqEMsrAS6G1vxGFZzfYaJ8wihGDVM4VkFQlZBw4K1N
 x+XKyb3t
 fvpIEbyUW4iJgeAZgqpOXKSkrlmOZHr4kuYD4x7JyrO+ZIGGGit0GgsXKTJUOE9ECPfZUi/R6WoXugEe1TOtGJwmUmtkbiDwjd6eeT2+vTTxBTCcxqTuOz2WQkQqlZK67U9+G8PAFP0LPEnQ6PEFIJgRk10icDCbcRnDmBXEnp5pUamtDTPbzd58Xjb+ba2JZBSBp4PPWUQw+H141L1DpiuUhFFf2IOdfZIm+EC5CSIcdT3FbAySAaDHzlkHK/mJIljkP3LsNEYSiIf5c6NQZLdbvZ+6ctco/Gej1tr4FMZxIM4CyveHzHNwN9XDQTRjMocc2qPgzzcesQ813I4LHg85QkE92XUhQGJoouWuZerIY6LHCahFeqy25snMknpBl3dfILmQorOqIapg1UVIn2B5Z2PRqi4FyfVK7vrobv27fTrlGKOu8sjzRrD1Z3r9uaPySIPNZ4GICo/gRu0GH2Lj7iQYxIvq6w/PZp7PeDxabEfOR1ghnwP8AsG1Jm+whnET1hOieiFnvhmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Grow the mapped xswap range before it runs out. When usage reaches 85%
of the mapped range, map more clusters from cluster_alloc_swap_entry().

Grow to about 65% usage. This leaves free space in the mapped range
before the next grow at 85%, so one grow is not immediately followed by
another.

Mapping pages can sleep. Grow before the allocation that needs them,
not after it fails.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 124 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 118 insertions(+), 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 02c3861a336d..5d9e5b6f2bd6 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -246,6 +246,7 @@ struct swap_info_struct {
 	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
+	atomic_long_t		xswap_grows;	/* grow operations so far */
 #endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 074c5114d129..213b66bb1d6d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -68,6 +68,21 @@
 #define XSWAP_GROW_CLUSTERS \
 	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
 
+/*
+ * Grow thresholds, as a percentage of the mapped range in use.  The target
+ * sits below the next grow trigger, so a grow that follows a rise in usage
+ * does not immediately trigger another one.
+ */
+#define XSWAP_GROW_UNTIL	65
+#define XSWAP_GROW_WHEN		85
+#define XSWAP_GROW_CHUNKS	4
+
+static bool xswap_should_grow(struct swap_info_struct *si);
+static unsigned long xswap_grow(struct swap_info_struct *si);
+static int xswap_map_clusters(struct swap_info_struct *si,
+			      unsigned long start_idx, unsigned long nr,
+			      bool link_free);
+
 static int xswap_create(int prio);
 static int xswap_create_by_name(const char *name, int swap_flags);
 static int xswap_destroy(void);
@@ -1325,6 +1340,13 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order && !(si->flags & SWP_BLKDEV))
 		return 0;
 
+#ifdef CONFIG_XSWAP
+	/* Grow before allocating: mapping pages can sleep. */
+	if ((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK) &&
+	    xswap_should_grow(si))
+		xswap_grow(si);
+#endif
+
 	if (!(si->flags & SWP_SOLIDSTATE)) {
 		/* Serialize HDD SWAP allocation for each device. */
 		spin_lock(&si->global_cluster_lock);
@@ -1397,6 +1419,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (found)
 			goto done;
 	}
+
+#ifdef CONFIG_XSWAP
+	/* A concurrent free or grow may have added clusters; retry once. */
+	if (!found && (si->flags & SWP_XSWAP))
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
+#endif
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
@@ -3986,8 +4014,39 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 }
 
 #ifdef CONFIG_XSWAP
+/*
+ * Link the new clusters and publish the larger range in one si->lock
+ * section: linking first makes a cluster visible to an allocator only
+ * after it is on the free list.  @link_free is false for the first
+ * chunk, whose free list is not initialized yet.
+ */
+static void xswap_publish_clusters(struct swap_info_struct *si,
+				   unsigned long start_idx, unsigned long nr,
+				   bool link_free)
+{
+	unsigned long i;
+
+	spin_lock(&si->lock);
+	if (link_free) {
+		for (i = start_idx; i < start_idx + nr; i++) {
+			struct swap_cluster_info *ci = &si->cluster_info[i];
+
+			/* A concurrent grower cannot take these: xswap_lock. */
+			if (ci->flags != CLUSTER_FLAG_NONE)
+				continue;
+			list_add_tail(&ci->list, &si->free_clusters);
+			WRITE_ONCE(ci->flags, CLUSTER_FLAG_FREE);
+			ci->order = 0;
+		}
+	}
+	/* Pairs with the smp_load_acquire() in the readers of the range. */
+	smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
+	spin_unlock(&si->lock);
+}
+
 static int xswap_map_clusters(struct swap_info_struct *si,
-			      unsigned long start_idx, unsigned long nr)
+			      unsigned long start_idx, unsigned long nr,
+			      bool link_free)
 {
 	/* vm_area_grow_pages() takes an offset into the area, not an address. */
 	unsigned long vm_end = PAGE_ALIGN((size_t)(start_idx + nr) *
@@ -4023,14 +4082,62 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 	for (i = start_idx; i < start_idx + nr; i++)
 		spin_lock_init(&si->cluster_info[i].lock);
 
-	/*
-	 * Publish the new mappings and cluster lock initialization before
-	 * the count; walkers without xswap_lock use smp_load_acquire().
-	 */
-	smp_store_release(&si->nr_clusters_mapped, start_idx + nr);
+	/* The mappings and the locks are in place; make them visible. */
+	xswap_publish_clusters(si, start_idx, nr, link_free);
 	mutex_unlock(&si->xswap_lock);
 	return 0;
 }
+static bool xswap_should_grow(struct swap_info_struct *si)
+{
+	unsigned long mapped = READ_ONCE(si->nr_clusters_mapped);
+
+	if (mapped >= READ_ONCE(si->nr_clusters_max))
+		return false;
+
+	return swap_usage_in_pages(si) * 100 >=
+	       mapped * SWAPFILE_CLUSTER * XSWAP_GROW_WHEN;
+}
+
+/*
+ * Map more of the cluster_info array, up to GROW_UNTIL in use.  The caller
+ * holds percpu_swap_cluster.lock, which this drops while it sleeps.
+ */
+static unsigned long xswap_grow(struct swap_info_struct *si)
+{
+	unsigned long mapped = READ_ONCE(si->nr_clusters_mapped);
+	unsigned long nr_new, want;
+	int ret;
+
+	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
+
+	want = DIV_ROUND_UP(swap_usage_in_pages(si) * 100,
+			    XSWAP_GROW_UNTIL * SWAPFILE_CLUSTER);
+	if (want <= mapped)
+		return 0;
+
+	nr_new = rounddown(want - mapped, XSWAP_GROW_CLUSTERS);
+	if (!nr_new)
+		nr_new = XSWAP_GROW_CLUSTERS;
+	if (nr_new > XSWAP_GROW_CHUNKS * XSWAP_GROW_CLUSTERS)
+		nr_new = XSWAP_GROW_CHUNKS * XSWAP_GROW_CLUSTERS;
+	nr_new = min(nr_new, READ_ONCE(si->nr_clusters_max) - mapped);
+	if (!nr_new)
+		return 0;
+
+	/*
+	 * Mapping pages can sleep.  The lock only guards the per-cpu
+	 * cluster cache, which this path does not touch.
+	 */
+	local_unlock(&percpu_swap_cluster.lock);
+	ret = xswap_map_clusters(si, mapped, nr_new, true);
+	local_lock(&percpu_swap_cluster.lock);
+	if (ret)
+		return 0;
+
+	atomic_long_inc(&si->xswap_grows);
+	return nr_new;
+}
+
 #endif /* CONFIG_XSWAP */
 
 static int setup_swap_clusters_info(struct swap_info_struct *si,
@@ -4060,7 +4167,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		mutex_init(&si->xswap_lock);
 
 		err = xswap_map_clusters(si, 0, min_t(unsigned long,
-					XSWAP_GROW_CLUSTERS, nr_clusters));
+					XSWAP_GROW_CLUSTERS, nr_clusters),
+					false);
 		if (err)
 			goto err_free_vm;
 
@@ -4252,6 +4360,8 @@ static int xswap_create(int prio)
 	 */
 	si->ops = &swap_bdev_ops;
 
+	atomic_long_set(&si->xswap_grows, 0);
+
 	error = setup_swap_clusters_info(si, NULL, maxpages);
 	if (error)
 		goto bad_swap;
-- 
2.54.0


