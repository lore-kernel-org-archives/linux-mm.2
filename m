Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39FFC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5A56B00A3; Thu, 27 Aug 2026 05:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96616B00A4; Thu, 27 Aug 2026 05:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3786B00A5; Thu, 27 Aug 2026 05:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5FF36B00A3
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:46:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44C2DA0374
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:01 +0000 (UTC)
X-FDA: 85146568122.08.A85C6A9
Received: from mta0.migadu.com (out-205.mta0.migadu.com [91.218.175.205])
	by imf08.hostedemail.com (Postfix) with ESMTP id 55D3C16000D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.205 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UbbacjzJ78AC+Fd5mVSuVyRhBVgGzvDShVKwzIKV94M=;
	b=syEAfeO6aPu4VsoMpGVAdZElibOLJzg4CTZUfnIognnoTqrMdAH9Qfk7NOmCZjDj+3g3C1
	ybFVb/h+mxXQJUTC0jCvTjKTArfC1ZNYbzjeJkQjEzVHTbMlPuPZrpgRAAXoRH7aSm42Az
	a4txwt4Vz0QK4yKzSVND4hVfSI4ZH8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823959;
	b=YpOfbhpwudeCUMDQgfoBb8iFd1JNOKusFxzQdxSCqOXbWZQio7cV/uDBnAp9NzYmfpHRr9
	VDBBGFxXdI7DjNMDHLIEUSxwPa/JNH+gVWVosxWMOehvbiGfohEO6L747LIALQa4p5Rjxl
	55W9ogG9tMxHcB+sOrutTRmPJXQg958=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.205 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id f679bda5c98230fc;
	Thu, 27 Aug 2026 09:45:58 +0000
X-Mizu-Trace-ID: f679bda5c98230fc
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 08/16] mm, swap: add xswap_try_shrink and shrink trigger on cluster free
Date: Thu, 27 Aug 2026 17:44:58 +0800
Message-ID: <20260827094509.1016740-9-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 55D3C16000D
X-Stat-Signature: tmdi6h134kdzefdrsbo33j7arsafq6tr
X-HE-Tag: 1787823959-20197
X-HE-Meta: U2FsdGVkX18UXRZssG4L2vzCTYx4gtJCdLy6ViiIGS//yk+LNQZtB2Ezuicv2MhHLq3kZlCD+WrVZB5FUs739FSSzJuv/oFN8iTEfrQaKkGr2A6vN+boKlxFGGTPHx4oAay3da5DzJcWrRCJxssgaWa1utB5MySJpHQn03ILa34uZ+jWgfAGSkC6AdKgJlmdvNWY72kiJaH247/zQga98YMGD7CdNY8dx0fB4LiI2JA19giqGvUBIE3MAWcsAvZcUNjx41JBxWyvQTUU1O2M9QGAOiiRZ+oCScr8PBPZlenGfBVkx1Hhv1Jfn5zjlQM/ld4A6frm5cZgkF4Ik7rS9NfrI/4D71o+iPqO2935U6UgUdcuznGGLTN3C5vdostFD32CkuEqTr+mX0mubDPclKouoqq07s6st/LTWXcdRE9o1CI6FUeklcbWDpXFOb7xRkCY4BdGd3a7hzOOI3IubSE/lccU0tL/iqGZZ0g1HFfXHjwSnH46ysnTlOSy0nF7PlM8/LPkUvKHAtWBHHRTUzWU2hZa7TuyUV4EN2kwseeZyEW/NBDfE1wAI73mHyKeOL2b/NwUmKUH+CvtIAYJbs9UqEFO3uwZ+/bKcycUBJ+rj7QLKcJtRskizVGJKnyKvg407VfBLVUc7w57J+9/4S65HIAgGazsHQSmpsAYJqsyvqfo0Xjl869VxQxTz1qzdHvAMuec251tFUeragdpAZaLfYVrFLsF2XkwFzJWl+PWqifRx83MuSt8Gw2OEuTEs6Sdk/Kzq1o9vdxkVzHgdb5xDIZoSyyanekEDMPsPoKw/yRKbY3P/g+Huw4CHl1TzCkEdtrK7QvNKtZEevzlGDGv7BOvtwOX15KfNn/AusDL8K/3Vkvw04klO3GaLl+ZGvlv7+nbhWgqEHZomwI9jjVu03lMwVe/rb13cwXOCY1EwDCJzYhoGnSaag9FTzGGV0GzlqeH2a9LonWwdVi
 +cW3w8Hc
 fnu/BozqUlf7EwF0Z0og720l8E5nlCi3DG4B7KleKCkMHuB1sOQiaEVoovLxbvzeOgF5FHzbN2CXaRWSpD9WyG7q0pGp6Daatmp9J7XhC4gAI8QIJMr+FwP6NVXInyCmEYLYE/AGtqMDXQpkMG0uQDf+98thSjbp1O3xa1/q/3i0nhJOZk6myRtH2jv0ZwjHTpnDUAWRdLSY21A+8/y9uzkaqQBFprcobe0UGBj/9UEzze9IJdK9bs9AGf2fKLyQacV8eTQfpqJo+vxXlGmZ9Tdernfwaxm4r+00Tb13wgQ6RiJBHNQuof64v4W0hhijR6wIlQM40SlVPINJ9UwFu8KzV6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add xswap_try_shrink(), the shrink logic that scans backwards from
the tail to find contiguous free clusters, then unmaps full pages
when >= XSWAP_GROW_CLUSTERS free clusters accumulate.

Wire the trigger in __free_cluster(): after a cluster is released to
the free list, call xswap_try_shrink() to attempt tail shrinking.
Also update the XSWAP_GROW_CLUSTERS comment to reflect both grow
and shrink semantics.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c6a01d74298a..6b18c1b21adc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -53,11 +53,13 @@
 
 #ifdef CONFIG_XSWAP
 /*
- * xswap: dynamically grow the cluster_info array via a VM_SPARSE area.
+ * xswap: dynamically grow and shrink the cluster_info array via a
+ * VM_SPARSE area.
  *
- * XSWAP_GROW_CLUSTERS is the number of clusters to map in one grow
- * operation.  It is set to the number of cluster_info structs that
- * fit in a single page (at least 16), so that the vmalloc page table
+ * XSWAP_GROW_CLUSTERS is the number of clusters to map/unmap in one
+ * grow/shrink operation.  It is set to the number of cluster_info
+ * structs that fit in a single page (at least 16), so that the vmalloc
+ * page table
  * overhead is proportional to the number of clusters mapped.
  */
 #define XSWAP_GROW_CLUSTERS \
@@ -69,6 +71,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data);
+static void xswap_try_shrink(struct swap_info_struct *si);
 
 #ifdef CONFIG_SYSFS
 static int xswap_create(int percent);
@@ -697,6 +700,9 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
+#ifdef CONFIG_XSWAP
+	xswap_try_shrink(si);
+#endif
 }
 
 /*
@@ -3873,6 +3879,40 @@ static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
 {
 	return 1;
 }
+
+/*
+ * Try to shrink the cluster_info tail: unmap contiguous free clusters
+ * at the end of the mapped range.
+ */
+static void xswap_try_shrink(struct swap_info_struct *si)
+{
+	struct swap_cluster_info *ci;
+	unsigned long last, idx;
+
+	if (!(si->flags & SWP_XSWAP))
+		return;
+	if (READ_ONCE(si->nr_clusters_mapped) <= 1) /* keep cluster 0 */
+		return;
+
+	/* Find the last non-free cluster from the tail */
+	last = READ_ONCE(si->nr_clusters_mapped);
+	while (last > 1) {
+		idx = last - 1;
+		ci = &si->cluster_info[idx];
+		if (ci->count || ci->flags != CLUSTER_FLAG_FREE)
+			break;
+		last = idx;
+	}
+
+	if (last == si->nr_clusters_mapped)
+		return; /* nothing to shrink */
+
+	/* Only unmap if we can free at least one full page of clusters */
+	if (si->nr_clusters_mapped - last < XSWAP_GROW_CLUSTERS)
+		return;
+
+	xswap_unmap_clusters(si, last, si->nr_clusters_mapped - last);
+}
 #endif /* CONFIG_XSWAP */
 
 static int setup_swap_clusters_info(struct swap_info_struct *si,
-- 
2.54.0


