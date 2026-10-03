Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD832CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6C16B00A4; Fri,  2 Oct 2026 20:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7EA36B00A6; Fri,  2 Oct 2026 20:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC466B00AA; Fri,  2 Oct 2026 20:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9AFCC6B00A4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:32:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 236AE1208C2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:24 +0000 (UTC)
X-FDA: 85279438608.17.58B0ECC
Received: from mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31135C0005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZccOND2PSd7mILVPnaYlMt3jDsRpOPbNPQi/MWfrIxM=;
	b=qlku2lt8irPqJ3tkJsW0eqJl2L9Le8nUG8OeMOlbac/d9OiVKEDQ7Gcscmdvoi5XB+xEx4
	egFUWCGRo39my3SpVl7i35giSqTpcZvMxQyi9OxZQzgEytsAf0PW1oNTnzDQpYTDVDxPuJ
	SJerv8mxa3r19VdtVX+Wbur/REBx7Bc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987542;
	b=aJUWhK8K0PctVWVU+26LIlyQ/LL3e/5LKrtfE85KOPUmLOTkmJw/aEqDiO3rAusT53v5Fu
	t8dXUzADdjQwmCLOj1NCRCK9fgvHtx17wi/zYWEWsPTnSO5oFeyK7+1mAAqZfziDJMEhO/
	Z9bVbzUmIML5ssQoV2MmLfpBLat5PhI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6711e8c646215ae2;
	Sat, 03 Oct 2026 00:32:20 +0000
X-Mizu-Trace-ID: 6711e8c646215ae2
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
Subject: [PATCH v4 05/14] mm, swap: add xswap grow trigger on cluster allocation
Date: Sat,  3 Oct 2026 08:31:27 +0800
Message-ID: <20261003003136.750633-6-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mm4dw44ook31nuqgkmgwizam9f564wgf
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 31135C0005
X-HE-Tag: 1790987541-81482
X-HE-Meta: U2FsdGVkX1935gSYu0f1cLUhXIge58m7HF92edaS0OHYRVBGsSjmn4B51gr4/mRWKTL7ahaK2sq4aYaU3g/bamFHakk1NbnSYUEC3oNEfN93w3RR845o79D0rsTcu8nNZOUCi0x4VUdgCNQMx7SkArGkxp3W6120KnABXDSDKsOq3nL21YjNvQhdadDFJqum9AbEqlfIKZNcI4VRavGd8mw9vBrpiNrO8Qy+s1rqACwmqeD6/BE0zgWJcn8YK42GHUGlUdMCFVnW2Aea/WGDwTcfYBTk4D9BJDNHn+iBtm2CyyBfRB3bUI7ODxY6V/J1qGpZ3KTjckbu8BCDMeDqK0/st2ZKzUUJsDUl4r02xrQF+D4oi8vEW0kgdMplPZz8GTsV3FtayTxdi6r3xj48aVumvpOCt8xQ2pYRSxCYA6SMSzv6et4WRTaUEGYTWO1zkJQ5m0BcTwidQXSey8ehBA3K6OyWKluqbtcNjKW2IJ8KK9tRzl1/mxsFAnkB1MSmwnoBiOVp4JxP0QdaSIYYs1INCiTi7YgiUJBgPSDa+T4jGlteWVp5WwNChJWGRnQVrwZ4cAUh+UmD2eBg/vF+qXMhqKEwK3ciSiukp0t7OJGsTudcKqIoGG7YbaK8UhO8dbfwTfGRRSni6q89LFUk6oVNOv43T/P6n9jEqgvG3FRCC2hZrauto0OTDoHh/FHThMjiBsQw48SsAngXsm9fRtdQe4u96YtXsmW9y1px5ZHlwWxk4vFnn400wbouYeiMU34KdfBysMe+1zgT4OjmI0QOD54jkm7b5hT2I9b4Fr4J7bCcQ2m6gyNEzI9oe936e7N8ffWon4BnRJS8LEV5I4KC1cX4RKs9RMma6So+iRoN/adjfz3DNys1AC6GHAv80zNRhR9VKkA+3uLjVTrbwS+8tyedg75v/I941f5JqTbppMEChh+UyejR+OuXHvJ0xI0Q2O6X+9//eolFXYr
 hPNq412T
 8CNNVHwhuJkBbQlT5RjbUB91EHfkgCudqvkJET6TZ35JFxu0ZuhtVvx5hal98w+ILuL7Ds8XKR7qVqSuehn91gVG5G0tYrgw2jOn6347BH62ftm9zD5h9nXdLvwW9w29+Ww+NvFIijJTgQx+290bxEKJwNYjbBPRNkXH3nD9HXDPuPa+NZ/EQu4nUVefrALb7ox+5mLCVefnFUy38dhAwYvxdNXc3dSwqG7OgvAQ1OOuevdnrl91qwdj8TnHfL0CFWqLcfp8tyjhfqPxlT0CIXYV96UWgv3lVtHKvYR8pJ4K7RAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Grow the mapped range before it runs out rather than after, from
cluster_alloc_swap_entry().

Growing maps pages into the VM_SPARSE area and can sleep. Doing it from
the allocation that would otherwise have failed puts that sleep on the
swap-out path with nothing left to fall back on. Growing at 85% in use
instead leaves the allocation that pays for it a reserve to land in, and
leaves one grow's worth of room in front of the next.

The target is 65%: past the point where the shrink starts looking (50%)
and short of the point that triggers the next grow (85%), so a grow
cannot leave the range in a state the shrink would undo.

Since xswap is always SWP_SOLIDSTATE, global_cluster_lock is never
held on this path.

This makes the xswap cluster space grow transparently as swap usage
increases, without any userspace intervention.

The caller holds local_lock(&percpu_swap_cluster.lock) across the whole
slow path, so drop it around xswap_map_clusters() and take it again
afterwards; it only protects the per-cpu cluster cache, which this path
does not touch.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9c204e455ef9..45050f8a2ed8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -70,6 +70,19 @@
 #define XSWAP_GROW_CLUSTERS \
 	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
 
+/*
+ * Grow and shrink thresholds, as a percentage of the mapped range in use.
+ * Each one lands inside (SHRINK_WHEN, GROW_WHEN), so neither can leave the
+ * range in a state that wakes the other up.
+ */
+#define XSWAP_SHRINK_WHEN	50
+#define XSWAP_SHRINK_UNTIL	70
+#define XSWAP_GROW_UNTIL	65
+#define XSWAP_GROW_WHEN		85
+#define XSWAP_GROW_CHUNKS	4
+
+static bool xswap_should_grow(struct swap_info_struct *si);
+static unsigned long xswap_grow(struct swap_info_struct *si);
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr);
 static void xswap_unmap_clusters(struct swap_info_struct *si,
@@ -1204,6 +1217,17 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order && !(si->flags & SWP_BLKDEV))
 		return 0;
 
+#ifdef CONFIG_XSWAP
+	/*
+	 * Top the range up early.  Every path below leaves through `done`,
+	 * so this has to come first; mapping pages can sleep, and doing it
+	 * from the allocation that would otherwise fail leaves nothing to
+	 * fall back on.
+	 */
+	if ((si->flags & SWP_XSWAP) && xswap_should_grow(si))
+		xswap_grow(si);
+#endif
+
 	if (!(si->flags & SWP_SOLIDSTATE)) {
 		/* Serialize HDD SWAP allocation for each device. */
 		spin_lock(&si->global_cluster_lock);
@@ -1280,6 +1304,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -3909,6 +3939,69 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 	return -ENOMEM;
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
+	unsigned long nr_new, want, i;
+	int ret;
+
+	/* The unmap below is paired with the caller's lock. */
+	lockdep_assert_held(&percpu_swap_cluster.lock);
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
+
+	/*
+	 * Mapping pages can sleep.  The lock only guards the per-cpu
+	 * cluster cache, which this path does not touch.
+	 */
+	local_unlock(&percpu_swap_cluster.lock);
+	ret = xswap_map_clusters(si, mapped, nr_new);
+	local_lock(&percpu_swap_cluster.lock);
+	if (ret)
+		return 0;
+
+	for (i = mapped; i < mapped + nr_new; i++) {
+		struct swap_cluster_info *ci = &si->cluster_info[i];
+
+		/*
+		 * A concurrent grower may have taken these already;
+		 * only add the off-list ones.
+		 */
+		spin_lock(&ci->lock);
+		if (ci->flags == CLUSTER_FLAG_NONE)
+			move_cluster(si, ci, &si->free_clusters,
+				     CLUSTER_FLAG_FREE);
+		spin_unlock(&ci->lock);
+	}
+
+	return nr_new;
+}
+
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr)
 {
-- 
2.54.0


