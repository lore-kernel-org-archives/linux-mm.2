Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF104C55182
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139E46B00AB; Wed,  5 Aug 2026 03:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB296B00AC; Wed,  5 Aug 2026 03:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1B486B00AD; Wed,  5 Aug 2026 03:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D36D26B00AB
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:54:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C0271A035A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:35 +0000 (UTC)
X-FDA: 85066453710.04.573273B
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id C49451C000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:54:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lwo+LBGq;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1v4kpNGwyglXBeEENPVH37QuycHMC781xF2cHBH8qU=;
	b=L6dejSpKDnZZWp2Yfjz7R5vW2LrSgtyv4MgMeRjcv1NXWzTE7IuEIKVy2JuTHe5Jz4o0Hd
	ZYwBx7jUWSxiYZhxVs09NjX9VpJpMR9awSc6EaJqfIAXSykskpE0cTH/kyfwLx/u4Cy66L
	rjZJshS6+xFn2ZFkyB4FpIm9hTz58EI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916473;
	b=7+WUJ8D9NSPQKdh73y7D9LtAxjWs3I3rkYv8UrHCBwWsoplGEQCEd49hE1gJP+mSzLfwok
	D+Ny4rgBfOXxLiOHKjECTKy6mHS3iFuuUrUjxLXVlDVfIKP+1qiO46iHY8m/XJF7hP98i9
	FPZe9v6O5Nt8WCJhP6+iSIbf7wTuJe8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lwo+LBGq;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A1v4kpNGwyglXBeEENPVH37QuycHMC781xF2cHBH8qU=;
	b=lwo+LBGqUGfl4wpOaO9E8CN/JxJ1ABjebdqeWt+2Jb5ttg/9qvrmXbXUodRe8Xw/8+/rLO
	wU1QcRvzLdgnMeilGnm/Ax9BmV2ojOea+t9HHZxWqTts1wDL8wHzA5CppS+bAcT7WRzqE7
	cPXbnT7eE4cmO4RWb9v193K8nF5AYlI=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	david@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH v2 05/10] mm, swap: add xswap_try_shrink and shrink trigger on cluster free
Date: Wed,  5 Aug 2026 15:53:28 +0800
Message-ID: <20260805075336.3579395-6-baoquan.he@linux.dev>
In-Reply-To: <20260805075336.3579395-1-baoquan.he@linux.dev>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 47dftrznj586yxkd3xxzu7ezyqu1hnbb
X-Rspamd-Queue-Id: C49451C000A
X-HE-Tag: 1785916473-609452
X-HE-Meta: U2FsdGVkX1/ZwI9KF6pG8o/5/XSPYID9Hos2bhUBVkdgggzSgcPwGr4Xrei/2pAtTln6pQZUwerwktkgjYohau/8ew6R7gBPf8FyMiSOIBtYhzizIX7fjCoBgicNKIrJBbHyXeSpO/h7y5vZ2PrSjtFgmBYlz8ObTaAu9YyiOelCpYZqVZYDhGxwgdzAvJs8uzn02PKTtnkE5IpSaZ17L2wgvPSj2ez1rlzzRCMOkUc2Y8mSW9pJQqC99pwt2t1bwKAE7RVjum1mmrNb2DdOy5De4E5UXQrDnaQntVV/tEGRonpSmNwkTVBoBfmKNV1CBxBzTr5z0MejVeb6TDaN30cQAMT2/RvNsfTYXerjsa3eWFTCfSnKHF2NuZLePt8l4+avpTgx2WiDeV9dtmMvHEJQn9pH+KkbjOV0O5jcWkzNtCd15FVl1ezSmTaUKkwi2ASYhUy/0lmecOhQMAT5zD+kfoL2sb6ECIBp6mcCtcX2DJ4wWNOppKdiSueNnYqKsdxwUAQZ6bVepkpndE12WOaC9EYMUpxtJvUMQUURyt4dikahPEAWYkfocSQK4bz6zkZHV2jhLN8VeR84CU7GUtFnbCxaGF0z2O1ASmQgshaIOzoE2IBPVbVD/dWmxOnb/d3vsImqsUFxqlbc+dEDC6zg0q9h1CX07HjC6s95dNiqcZAt/jvHILeyV1VOJJvk0xVeJUB6CH/sarYezBT2isthjrz1wizIoLq2CBhIF4iPCODaJA4lWOpnV+wklDvkzTIeQ2rcD0jgL2rQviKIDqnOv2OYA8MpuVH4XpxfxzHoasbDAyIvrhFF7S9ffbITXgxXv38hCXK9HeL7m8V6jWhoQ2W2IZKFYnK/RBFju5Pwltmgfr6mAfmD0K/4MyrL+ww2HEmVagifhhwXBDSde8GdGD1mvrgc59twOhaBONviMl+2pSMtfD5gcmU9/4+WCLs1kNny/5XIp9qQe9b
 SyawLCV9
 pbwB1yuA2+RHG/9C2d5Xjv9+sHQou0ypz8/wXu/WfxbiSoiv+NRn9X6HA1TsObeG7hMHP9LhcC6ik/akjhON/Er4SmB4qp5pTD+lGDro5iR8lco8xzZWFYdPCP6s/Z2ehgT1cesvnvQdYB7U69q+T/8rdIWdKLKob77kEfHqPlDwwfz27X00k6pDHMYW9HFNyNMMvv9ARrPUV6UL17GFuGnyGbYQhZg1XT0cg/GOzMDZMTOujWezBU80PLddF49p7xKBcO/PG9+a6tuI7CI+ro6W1xP1PN3GaG/lXJcAJwJZohX000x8FtMRkZP+Ho0RI4vh99GNQB6DtjvR/Mhbp29anxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add xswap_try_shrink() — the shrink logic that scans backwards from
the tail to find contiguous free clusters, then unmaps full pages
when >= XSWAP_GROW_CLUSTERS free clusters accumulate.

Wire the trigger in __free_cluster(): after a cluster is released to
the free list, call xswap_try_shrink() to attempt tail shrinking.
Also update the XSWAP_GROW_CLUSTERS comment to reflect both grow
and shrink semantics.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swapfile.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5d8e10be0159..0d1d0c5e24c6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -51,11 +51,13 @@
 
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
@@ -66,6 +68,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data);
+static void xswap_try_shrink(struct swap_info_struct *si);
 #endif
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -629,6 +632,9 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
+#ifdef CONFIG_XSWAP
+	xswap_try_shrink(si);
+#endif
 }
 
 /*
@@ -3835,6 +3841,40 @@ static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
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


