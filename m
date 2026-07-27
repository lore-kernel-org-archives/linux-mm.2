Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58635C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62BE06B0099; Mon, 27 Jul 2026 10:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC1E6B009B; Mon, 27 Jul 2026 10:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAF16B009D; Mon, 27 Jul 2026 10:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 286026B0099
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:05:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B217E1606F5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:05:44 +0000 (UTC)
X-FDA: 85034729808.03.717F3D7
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 016E44000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:05:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J6KljxOm;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785161143;
	b=n2+skuxhM9hcyFosYb4VrjBsZV7DI+MLF1ITHXno14sTHNejNewmBOEUY67SK8EoDwSu3N
	1k1qly5Y3/Yt5x9227OsmdxPtaeMuyI9FxErnmCVery+PhUiaCFnVjN/zQk2Fsb65giRnT
	0qp4LeCUBZ75UgNOHxo8dx6sNPT1BBs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J6KljxOm;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785161143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YTkclNcH+X+o0Y2MtUBVm8stGCldjPA7veuag8ps3U=;
	b=FQOWJt9P69+MPhPJMR9QLGXwrqnBx83gXvPKxH4C+MQTtEdRH1CR1/M4KUuHxNF0oa+uUc
	rsrvTgTOWcT2hRnWXLZUUcHxUnZCszbI19GPlw632RgjNiCMyYEFNHFQYCw56nXdgkS4ds
	8ybag6EIQ5JB291NADiDM10nbAB4MEY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785161141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6YTkclNcH+X+o0Y2MtUBVm8stGCldjPA7veuag8ps3U=;
	b=J6KljxOmztOsaJ/KjJpUUiA6Ps2LjzX9nAZKeenrFj81isBREDZ+5OcrAviXhuLHCrxwv7
	coov+ZMVcQk/YDs9Pyr2y7uvgYUWOOrh69qOaHGAlHMz+I3tYE3h1YiR02wDCtHaQ8buol
	ctfocEPcffjcEzlbmtPIdU8E+lxXkAU=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
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
Subject: [RFC PATCH 05/11] mm, swap: add xswap_try_shrink and shrink trigger on cluster free
Date: Mon, 27 Jul 2026 22:04:56 +0800
Message-ID: <20260727140503.1060918-4-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-1-baoquan.he@linux.dev>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 016E44000D
X-Stat-Signature: 5k5zzrtkd33iij7odwuct5pnw9y37oid
X-Rspam-User: 
X-HE-Tag: 1785161142-846890
X-HE-Meta: U2FsdGVkX1/VDz57Q31zZXmem8P6zSOfoYiSX0ihAmzFEtps5h+Ip1ith8ooII0OaohozyWFoJjJmxE1scluo/bY81cLeccGtGNvixN1oq74RTv8+6cdLGFw7z1ell97VazdKwCmNCiReR/h1Vp23r4DNczXs8LN6PigNDwkLQ6OWbIF1nI0EY6iWV6lnf4XeYTY0oILNM1mjOTeoeQW3OzwsxbOLiaoTSOrSONCJOv9Vs4FRa70uoiaycN4TS6mBC7OuW5+oEinFKDnpBewLSbEdqcTJVtHfmFwDogxcE0kZFKmvRKBiAspHAuucthI1L5IqfWOd+FIUSoQFFErAFe3ZOMCSHk/YTESrFnKIG8tcEXwUa+AqAkQbXCHLTJPSnpTI0qVmNkkXU/6U9kNFWr3CLaANkmzxlCYR6YstHh75o5UojdCVYSP5alUr0OlryNW/lJHo7MuTYr1eIq5jfPmMh5XIbPkQcmatIfrx7XKQ9xBgkht74ui1u7MzktlTj2ovYEqM51wsFjrNpUOA4rULevy8FtZR230LezWRyo9J3gsNwY7zHHdiZxEDC+hh8cJ7ENJwGDeg6gwYoE1SALaEVRRX/o0yyziH/AygzuzI1KTAGQAtSF7Jiz0B4Y2sn6u5ZYbrwbGN6/SVLQPaOpYCClj6x1AWsbuxSpZEJZ/dZSmgLHourBYmOlzVPMcZU0u/pH3JrrCq7Dx6LSCujOU4JjVwFldrY/SRwrsiEfUm2SIuxHDUtcmkIh82mFZO3SWantk6ok4S1Y78QSeM04J7ZdD4eDejLdGgS+LOTcHvaYYv6+n1dS9dxdCLbZhS0MpI9Zdsx5P4xxAZGyd8Z4x9CJqF3beZ5Mrbdrte2bcocWMB4OVnZWy3CteXafFfSVpiTymwdvWI8BJ6h2PZdsRQJW6y3tfcGMR2KgHY90dTRfRDipyn/roN6KwFKQzlOxwId8y4YCKx+bK2CH
 7B76mvjY
 3w5xMwY9w+wWdezf4Ie9+K7C1R4rYvkbgyrUx6OTx2TU9YH43v9veIQkvQNyorvwkLgCv5K8Z/2tp7268dj3MGocbSe0pvY4bchur68P+TPKPpj9HEcgQbbO2KKZUR4iRgbhQgd5wBlj3Z7SmCTMrnOJ52eKm803mMvpOl1mrrQEHSEs/v6vqY4BLD+xecRnJVCxEEEPtmjKI17RHkbYPIB9aQUr/hLN2YYgJ7egtB3TMqFCkTdE5tLciaDNCwInVt2zPYSMn7cFZMCwrlTbK998fGP05hxYhVZKw9b4/reqR+rgcjKK3vQyWKJDYIQUxSh8fwt6YwDzylztz5S6Z736/Uw==
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
index 8a048b2897ce..e0f5fe64de2a 100644
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
@@ -3809,6 +3815,40 @@ static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
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


