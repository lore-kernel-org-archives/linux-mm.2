Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E504CC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF75B6B0088; Mon, 27 Jul 2026 10:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF5C6B0093; Mon, 27 Jul 2026 10:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5936B0098; Mon, 27 Jul 2026 10:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE0E6B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:05:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBF5F8074A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:05:24 +0000 (UTC)
X-FDA: 85034728968.24.69F5ACF
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0CCAA20014
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:05:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pjU+OTh7;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785161123;
	b=o32+5QmwPFOOONDnE7m/a3BIRkoBEJICpK+EsMDoGl/ardTI+MceEB9YlYX3FjCwsUPVtp
	i6nczxgETtHS/z3rMhAhWA/4wHLfGyplaPpEtaiNCHm+uJrIHTdVjP6pbUwLQZMA4vobjj
	l6bXElwUR1LoMsVeYsUiHCDNjA2K1D4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pjU+OTh7;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785161123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1guC9stZtNs1FbSf+QBPICcmcWlpa8QQY12wosAxqEI=;
	b=ua+STIOm5EuCUWnmk9fKOQfTm7YBHCfMy0Qmf2qI37RS1qIZ2f/ZaZXIUY68mSDCnxFvAC
	C/uBYHIsna6WeSnsY5cTpJXeVHfVeGM5U9YqMZdXjmKmTb6pOCa+q9ocsoLmWrMQb8fxhu
	Ft3rLO+L80IvIh8A6/VfH2tLjDZlRZ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785161121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1guC9stZtNs1FbSf+QBPICcmcWlpa8QQY12wosAxqEI=;
	b=pjU+OTh7mmGoTwPzPdTGP707faCv5tCNRm/O9qfRfkuCjRxF9lYbV33L3P83XqxH1DIhCe
	wBBaZM2o0Avc9uOQa3Rv7/sy4bPX9iZzZP4QDLqASXVkOI7BYCWIzHM/KEAVITvLDV1AeA
	74pLAP7R7MCP39JSb765Q660BAwDx5U=
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
Subject: [RFC PATCH 02/11] mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
Date: Mon, 27 Jul 2026 22:04:53 +0800
Message-ID: <20260727140503.1060918-1-baoquan.he@linux.dev>
In-Reply-To: <20260727135029.1059441-1-baoquan.he@linux.dev>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: t1bowimc9u7qgu9pzicbixfb379cp3et
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0CCAA20014
X-Rspam-User: 
X-HE-Tag: 1785161122-790979
X-HE-Meta: U2FsdGVkX1/MA9Z6qnkuGyMx8kpbhqzUK3RhOVqouoFznNpUjP2aQDvwlUSxltaW1IRJHJ/1EaV88iVqtZlZHjC3kVIXbt9OZLOuzfoceM/bdoXzcwaZvNxniqwBKSubcIJ10xjEncUelY2Tap2JcqFVjuyBoIk3UXWqP0miDyD17Mb9gAEYKlLMrqppOWjD2i/51/7Lfck7MU5baLTzghmZkU+TxA+GeUiyu/ExARX0EsxT0eFCm3IHHsnkdI5kfY1T1x4KHq0BoaNRH972PZ4l7Y9EfuIxaPBBIQX5sZexTNnAlIEuUqt2TEM1XWLZQFeXqL788o0Vr6O3OqpcEYA6u0nDksrzPj4ic9jMT1f3B2nDvKCMN2gisQ+WwO75bsgvaeTYhIvp9hKM1ecLx/faDwDp9qgVrCiLOkDCXQJ2tpqiwUKRGtNpVfjt+MslGxCyQU6ZJaYUCD0oqNiv+QVYoGrmNfS20f4GWC+8BmLdfx/NVlaBrYPCZa56BB+WI3mK9RdBQNxDksiGwpwhB7zuwjBTW1FS8zMvpR8xcb2Rh4xbx/cNatzLNQYOCs0a+UNVCKuPMB6m360SZPdrBet2wQVHHHGeltRebq1MhEzlsBMh0o6tuPPXKQdCYhcUgJMR3VgCR1rV3lKPLRenQwRJU1SnRaZA4M8IgRA1G5D3b/1jjRurv8mn4IhWGnwKu1iUkJGassbIpTNU6BanphkandWLJvBjA0/duz5I2oIXez49fjs39UzSMN1pcBLEz0R6GcoczoCgdMvhWPWKl0qhhoCPldFkCBEA9O4LvSQ5YLt3QNgREQxzy29/XudEJzrM3uSHNom60f2ahisAKBaNalcgiIhhMMsAHI2v/Z/nk0DCnq2SA4iQMwWKAZ4k2mdO7/JZTMouTKBtgP0fKNPSy/A5UnM7Sf5iEdyB2FssRTYzQkTOc7VXO+ltnUEzbKCttPVBsvGKfV30m+F
 o0p38jXm
 ZN6l5BixhQ7Syb5eqZ+hvqCK1g3gw1WhtVu3/VN+RLPeBz+y6IDPFgIGqT+jWDJfTBy8d9qTTokILYBpt3g33H8zTZomkJU6xoV7Eauj9jLh5q3R9fMOFMy+TgBIAZo3LpMi84rskC7UOKIONbyDy8JuhNVqjEdb2RKw1phGowpJUVLYDezhpxfdIDRSi7XQvF50TGoD9CCAhoUP+ffgDHACuQfk0DAIYkjXTELymXg6JyF48uwkvci9+cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add CONFIG_XSWAP Kconfig option (depends on SWAP && 64BIT) for
extendable (virtual) swap device support.

Add three fields to struct swap_info_struct under CONFIG_XSWAP:
- cluster_vm: the VM_SPARSE vm_struct backing the cluster_info array
- nr_clusters: total number of clusters in the xswap address space
- nr_clusters_mapped: number of clusters currently mapped (lazy grow)

These fields enable lazy vmalloc-based dynamic cluster management
where the cluster_info array is backed by a sparse vmalloc area that
grows on demand and shrinks when clusters are freed.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h | 5 +++++
 mm/Kconfig           | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 80c83dd8804f..5f6b14d30758 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -248,6 +248,11 @@ struct swap_info_struct {
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
+#ifdef CONFIG_XSWAP
+	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for xswap dynamic cluster_info */
+	unsigned long		nr_clusters;	/* total cluster count for xswap */
+	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+#endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
diff --git a/mm/Kconfig b/mm/Kconfig
index c52ab6afcb15..889d5ce20a55 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -122,6 +122,15 @@ config ZSWAP_COMPRESSOR_DEFAULT
        default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
        default ""
 
+config XSWAP
+	bool "Extendable (virtual) swap device"
+	depends on SWAP && 64BIT
+	help
+	  Adds support for extendable swap devices (xswap) that decouple
+	  PTE swap entries from physical backing storage. The cluster_info
+	  array is backed by a sparse vmalloc area that grows and shrinks
+	  on demand, avoiding static pre-allocation overhead.
+
 config ZSMALLOC
 	tristate
 
-- 
2.54.0


