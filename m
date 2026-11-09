Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2CF606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=phIM00cV
Received: by kanga.kvack.org (Postfix)
	id 0AC226B05B2; Mon,  9 Nov 2026 00:57:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083FC6B05D1; Mon,  9 Nov 2026 00:57:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDBBF6B05D2; Mon,  9 Nov 2026 00:57:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF5C66B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:57:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44353405CF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:09 +0000 (UTC)
X-FDA: 85414522578.16.B6E2040
Received: from mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
	by imf02.hostedemail.com (Postfix) with ESMTP id 55CA780006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=phIM00cV;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHIuvULbA0fqevzvPsgDGnoy3CmrucFTgFOStDNRHTc=;
	b=s9sfQ5eIHKVSn2ebktCnoOqGtomdkeg6BLYfnk3Fw4HJa1uM76ju9X8IPC/kDL+mm8H/lF
	1JsNrjGvZc1VADcxknTPR3bQSMuzpTNlEeyBKYnGjuncRr6fooBJ2b0HkqAJ5bvyks99I/
	IHx+L0n8Vtp/txXPjPAvIE4KLG/+4JQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203827;
	b=esF0uu6kZ4PD02UI5P18J5Cp5hmj+egMmYa4hDmcUDbwm0fuLGpwK25rE/ov6wtPtx17mj
	FaIhFxyEHruccp94GCMhdNTs+u8yiwdI1IP/GLus8iyfn/N27nBw6czqW9BPv/YPRIU+ux
	aaikqy472HvR4KFrU9Ogxq+ON2Sho4U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=phIM00cV;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=grvGazueux9g/dh4Ox9KldXCRFLinqH44M5UkMCzZds=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203825; v=1; x=1794808625;
 b=phIM00cV1lVLA2egzIg7wCZD3ns8L33hpQSkCQyHSqN1m57/jq1Jhmvj5zNos59f0TykoKda
 q6SnGLceQSQYo/Iq7DtwIdQVylXuNUVKnGEK8hrdabFGYRSX1Mv5DYIvv1wBh4hqqd5u3Q9G87j
 bBC2jEL06cPLVbnzkW1Z1mEM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6e7fba55756a7293;
	Mon, 09 Nov 2026 05:57:05 +0000
X-Mizu-Trace-ID: 6e7fba55756a7293
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
Subject: [PATCH v5 13/19] mm, swap: add xswap grow trigger on cluster allocation
Date: Mon,  9 Nov 2026 13:54:49 +0800
Message-ID: <20261109055455.536925-14-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: h4buxj75dpt4drkustwu6eii1p4trquo
X-Rspamd-Queue-Id: 55CA780006
X-Rspam-User: 
X-HE-Tag: 1794203827-325074
X-HE-Meta: U2FsdGVkX18faS212tleurQgagrxCJ2kj6MRVJwZJJx6YvNACFcOS4wfsdb4WevqA+NH9q3RioGu/ciLahWKzMuc9pB3AA8I4wW2HFXTPHh5fH/ZfYkuQ96nkD9qNCLe5Sll+Et87vEiJB84jVdfNtoposEBTG4Ymh3B9MYYUJNcptf/g1D6+HVZ6NS0w91SVG3HyDh55Oh5VMwVw93jelo51XfXmPQ1njgGHSA6csu4Rxeer1zQ4kh0xRFBnz2CzBIUrIdZdCMlwWSA8AIkN7nhnW62zxIyeA7BxyLB8elN5xq0OcockqfcGGaHjQZ8VQamXdpu7lukoX+zTK2/ZV7xvhsR1GM6T3JO/HjFbwr0cgTvTKQ4Oh3qtDX5mG+rKfoXSbKLqNOVN+obQ+1SuKXQSLYHCTE1PlXzEF/6ITHDJq88nUFtoXVI1l3ZTs4nldny/fGscAPFVG4uFh5kt30amAIGxVJJPH/jZ4ZgvDlozr2e5GLhKI7EDeuDGWO9az2uLYga7Bi77rTuwAncFo2wQ/s42N+3rvWMa/tproI8hF4bNBzGCww5K4QxofzVTGim0DxdKPAF8H95BckFGJIL//m1EEbqB3l8eh65Rewx1W1wIvO9TSoAm/ja45MsX/Mj+EN4fA2gt+cl+b3GQ80B4FLPCjCgHpaJxrPaUPfSY/Jo8cTS6BqVPoj4KdMcfWsvh3pou+mRW9PFATxWPMGkWQqe2ELs69exihETB1ibfD3HNMuEH+aYvZnFwfPVFeV72QLLNtzpAfG4gFnHYP63MPQjEdbi16KUu9TCNJGKNbql9CdxJ4S/Lg2/kcqa3FpVZEwdSRUEm0m/sIXmL/wBM0WYD/7bbsGZatk+3u34bdQPzu6Tvm1RqA2vK5x+2NdeK3iZ0Y1JcXX74mdwmkBlKgMdCFPxQ3Rp/sbLsvoWdJgzR7MDqxg/GNmesuWIsZkELof8qrxdPZ3JcYr
 hREvAVDo
 MpPf0Rs64Mk5YF3EnX1m069hjvOWa/v9zUbkhaFmVFUByrs4BfmZNqXYmew4wxVFRrGCW8eAD51rs8/rKFANWa0jvnpn/a/5iJUcXLXVYPwPPQ/CO9jrTDd3dI4TsFPVs/lvKv83eU6akks/RrrD9K20RQUhnduMF3TjLlhuD5orOYgm/mYYd7VaUyJMeJx9LCyHXO7prY20Y9C3G7LbU/2FfSwaQPVmVZO6PtdqS8X07tKxgHLYksaMMIEKcnijOICPLgDflz5h6rXd4GnmXZGttXzNzaJawwhJkSRHiWluAYRaqYLildV/E5A==
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
not after it fails. xswap_grow() drops the per-CPU cluster lock around
xswap_map_clusters(), because mapping can sleep and the lock only
protects the per-CPU cache. xswap is always SWP_SOLIDSTATE, so this path
does not use global_cluster_lock.

Link the new clusters even if swapoff cleared SWP_WRITEOK while mapping.
The caller keeps the device alive, and the allocation path checks the
flag before taking a cluster. If try_to_unuse() then fails, the
reinserted device needs these clusters; otherwise they go away with the
device.

After a failed scan, retry the free list once. A concurrent free or
grow may have added clusters.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7b1d16226b7b..ba730fa19194 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -80,7 +80,18 @@
 	max_t(unsigned long,						\
 	      ((XSWAP_UNMAP_BATCH_PAGES * PAGE_SIZE) /		\
 	       sizeof(struct swap_cluster_info)), 16)
+/*
+ * Grow thresholds, as a percentage of the mapped range in use.  The target
+ * sits above the point where the shrink starts looking (50%) and below the
+ * next grow trigger (85%), so a grow cannot leave the range in a state the
+ * shrink would undo.
+ */
+#define XSWAP_GROW_UNTIL	65
+#define XSWAP_GROW_WHEN		85
+#define XSWAP_GROW_CHUNKS	4
 
+static bool xswap_should_grow(struct swap_info_struct *si);
+static unsigned long xswap_grow(struct swap_info_struct *si);
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr);
 static void xswap_unmap_clusters(struct swap_info_struct *si,
@@ -1359,6 +1370,18 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order && !(si->flags & SWP_BLKDEV))
 		return 0;
 
+#ifdef CONFIG_XSWAP
+	/*
+	 * Top the range up early.  Every path below leaves through `done`,
+	 * so this has to come first; mapping pages can sleep, and doing it
+	 * from the allocation that would otherwise fail leaves nothing to
+	 * fall back on.
+	 */
+	if ((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK) &&
+	    xswap_should_grow(si))
+		xswap_grow(si);
+#endif
+
 	if (!(si->flags & SWP_SOLIDSTATE)) {
 		/* Serialize HDD SWAP allocation for each device. */
 		spin_lock(&si->global_cluster_lock);
@@ -1435,6 +1458,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -4168,6 +4197,77 @@ static void xswap_unmap_range(struct swap_info_struct *si,
 		__free_page(pages[i]);
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
+	ret = xswap_map_clusters(si, mapped, nr_new);
+	local_lock(&percpu_swap_cluster.lock);
+	if (ret)
+		return 0;
+
+	/*
+	 * Link the clusters even if swapoff cleared SWP_WRITEOK while we
+	 * mapped. The caller keeps the device alive, and nothing takes a
+	 * cluster while WRITEOK is clear. If try_to_unuse() fails, the
+	 * reinserted device needs them.
+	 */
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
 /* Caller must hold si->xswap_lock.  Cannot fail. */
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr)
-- 
2.54.0


