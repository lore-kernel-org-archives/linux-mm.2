Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 601EECD37B7
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C385B6B0106; Mon, 11 May 2026 05:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8C46B0108; Mon, 11 May 2026 05:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF9E6B0109; Mon, 11 May 2026 05:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7896B0106
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:04:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F4F240690
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:25 +0000 (UTC)
X-FDA: 84754552890.05.68B1897
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2F78710000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h2FEv1XF;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tewXfhJCZs85isDfaCarY9OYs1rdE/frw9lqrB10rtM=;
	b=2F9zpJ5wCswmz1gcA76OGyk3+KVnd/OYzWx8knZreWXLcUM7qVGpQrZtwRM4DnZ4MtjXt5
	0E+GldosPRaQJRIOQ+jArr9AePcBgEKoflUizwWjOLUVcWoiqn6PgNlYwH3/29T/WtEEgt
	lrN2e6l72lSsIEA7RrKSFAF7pTU+Mso=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h2FEv1XF;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490263; a=rsa-sha256;
	cv=none;
	b=gepI7a2FLTcswGjPfWLDDhq3tKlhUvaVh+GKRpDF5TTNJVXnG4mOq+GTP24/+IlmDjtPYH
	E/ReQM0pbRxjpZmyvzeLkTkOMVo5hOo8Ux4LRvoA5bmWZp4pquzU5zYNlfDavlcWMk2fqH
	SWK45L1wu+8zHaIHKGD5ODYCC1v4DDY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tewXfhJCZs85isDfaCarY9OYs1rdE/frw9lqrB10rtM=;
	b=h2FEv1XFdBWh73aQZs8s1fbKMKyNK4PGKSSAya8Q0/0LpwOoHog51cci1tI0UtJbToVXDu
	+DGNqyHsnxdvst4xp4gTDn+1Xjo11/Fiuzln/E5L7LmICNaRtrxe5WlUyic41ZT3YnX30L
	IA2fwqeGhLt+cs3BTjFLghwiRTtoN6c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-yzFARk_JOmyQpLqqc7ELEQ-1; Mon, 11 May 2026 05:04:21 -0400
X-MC-Unique: yzFARk_JOmyQpLqqc7ELEQ-1
X-Mimecast-MFC-AGG-ID: yzFARk_JOmyQpLqqc7ELEQ_1778490260
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44ffa15dc73so3687735f8f.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490260; x=1779095060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tewXfhJCZs85isDfaCarY9OYs1rdE/frw9lqrB10rtM=;
        b=NUdP1GIxz6xeXP3q+2dwifzG3iK+FEM7NrdtpKGQez4kEfa9qt2xR+Q2XARo4sV5L9
         5x59NjxzDokhphxqJyLgh7lP08Hf8MtQlJtLPp6sm6+OKJtnXCNPrK7Cu680kZNsqk/5
         NMdN3y5BoePjN0Okh3k7tBlpqNlea95JCFbXrd1+kJCj+VIiwDXR9iYTcOz1+oxTawxm
         h4BGrYGDMWJhqOhRgYPN4T32keNJKecYAmFeJZLvnzw93QRESaD1TR8X1hOYZRsFamTF
         y/QlhXhwPb4OruOPvthd2RQ2BJ67yylb0dNtkRUT/vntUZW8xVX9NhezQ2BsRO42KZHS
         FIBg==
X-Forwarded-Encrypted: i=1; AFNElJ8TVbwYnfrY4zB7ed75i/XwJXXniYJ9NGH5LAGcoeTWSRhQJFN47NHRgWeKF2yvQFdH7XZd/mHX4A==@kvack.org
X-Gm-Message-State: AOJu0YynG4szcYc4G4eLH40RINxCCQUGhI8yuCG9G6Ci93oZRCVbDvwf
	9yGtsgqPwPiq/6d/Q74Ec/WHB2rgbhgjlN85TSu645MqONFURrwuobOSqlR8/cJJHLGTjPXuTWh
	DdwqvWVRZwtLsGluTaMaNP1P15zu97DNoe0q7htxqLC4yPtZ6Dtci
X-Gm-Gg: Acq92OHOKU6aUfIir7uhWQjdXbzRWbhS5v0IHpIahQGKuLwz79LJeVM9aFNsxXWzJED
	EoDqyjnwQ9aVirM6an1JIIfXmkO1Rg9pfQ6IYko5yhXP2DzhhBUGFzEsyGSY1KC6AcTj36VV4JG
	3T36HG5oVbcJz/xXtqJZlRUwk1os+4xJ/3tTIsGiMdtYq1IaKYLzBL8a/+RDcY1dMqYF6a0EfT/
	JwJRw56k/9bj3Z8seoFgg4NS02sI1SvwbLnmgn1RP+6xy1VIxsOgeeJDdop8wwN7URyD0odqVvD
	2txFZjEVEA5ByGisGTyI0GZuiXOcvF9hlhz37vcb79Y+v6oO+S4xYO8azlQxhvd2Bov2GwIWzft
	apiB5+/45x0HRLO7lvCP1x307I22WbEZ9Lu+bKvDlLqn32uEs3W0=
X-Received: by 2002:a5d:64e8:0:b0:43b:5672:efe with SMTP id ffacd0b85a97d-4515b056cf3mr37638785f8f.9.1778490259778;
        Mon, 11 May 2026 02:04:19 -0700 (PDT)
X-Received: by 2002:a5d:64e8:0:b0:43b:5672:efe with SMTP id ffacd0b85a97d-4515b056cf3mr37638683f8f.9.1778490259026;
        Mon, 11 May 2026 02:04:19 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e4bb87bsm23423788f8f.2.2026.05.11.02.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:04:18 -0700 (PDT)
Date: Mon, 11 May 2026 05:04:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH resend v6 27/30] mm: add free_frozen_pages_zeroed
Message-ID: <94ea0046b290ffd74a1db6c5e89962366dbc1a1a.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mreCT85c87NXL9LyLh4hHJf5geF8owLvYGPJAuERwVo_1778490260
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ixmmt78bt7th5t9fe93jiqxcz4ma83mz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2F78710000B
X-Rspam-User: 
X-HE-Tag: 1778490263-219862
X-HE-Meta: U2FsdGVkX18a3FcyBXaqanQ6SglRG6S7MR3wZC4SD8YtglJEexxehcEb6pxU+HiMpNZfoHOLxkPb/jZiiBZObZxmnLAdUVMIsaVXTKeDC7JZ8+JhgZvnX5tgyqNhgvzCJp/K0KYYGNpuPq2Ggi2OGOA0J7tK03cTFCfHclq7+fC4YNFj7qdE6SvngvoI1WLm4w/DvfcONLYw+EMaCtYXp+HwYXUQN4+iE8S26V68NZwwlpPC5jG4/CGHhOTcP1N27dHoFGxlm4jdojq+zDaTmDMOhnwRFDSOD/oVKK9417bFs4hf+EYJRPmTYBwnxl9RT6FSwe8XdxwoPau7wMeBvMgv+Zbr6UwYUsE5F8gKsy74vhCZhbF3xqCEDgDL6EFPU6urWFiXxD9STonCR9OHEGOfT4DO9iKw0LdfpvooIuqm888Xgd2jVi4vzzpwQWjsUouqvfXu/7ThzgYkUogZEfR6clw0IKPnRdoylJ6Q3aJiaWJBxasLKxUhriSC1l2/MiStMatGxtmANxFxLmy5qUCRfUK9HMtEM0piScxY4Bt777w//xiHlShAyZx8pjOcTSZn+usVBsXlnHFvKv18hsYEABK7c3QPEFyTiRRLqJB37Xj6NfB/R1465Lj67aso8618QHLjXHdi+EtmaVw0fBKDVOvlJ/f0+JUk0VHG4a4sDCfXuaYxeuMNhiLmfBEOr5vHYlK9K2jWJGt+E5s8v148bTfEps3pPzlwRtQ4neCF7RX3yMhEbBYwgRSj8MsthIZEFtlkb1Fb6oJAOMFdSdjOauCqI+Yx2kjxFxbFqNBmF5noCAIu+a9grERfZeJM/kqKWkfbSTLwrxIUkXHqQ9OQjpm40P5DbfVuPtnd7+b/xssFn76GT7Bnj/ez3M3kai9+qVVXRIXy2qEj9BvAJD3r4vFh+aOF+ai5rLfjteaZEX7mhtal8p1TxxZ1fDh9dYSlGK6tH20CUU1gYb1
 NNBse959
 3HC6fES5365vM8H4M4FLIyWxS7qJM34a7mZpgIQmAzElIQ7rmzxIvwSXRIYdq4LjdQV8Li5GdUhAajV1SVsiMP9oxordMzX1OEdSXSN0ftImtv+7Ao7L4kZ2lewLEeQayBgQsIT7Vw5KdOJieJqKD8i+2JGg6RqDpnFkV9RrxAbSX60L1yHr+1F4uNW04tD5NPUvIugTBlVo/fK58tXwEXLsZA3OocploFKAgJUHoDTHiTmwBoVpE+IUqFEKd3vZn9F7dqSN0T/Irr/O+yTIUjjjyZBtGNku5fey7Yy7LFceyVCxhKMZcgA6E9JE6MKPcvmx6DJ6lL/nIOc3t4/WyPcpODnB0dz5N5R1iPNJzup7f1Lhqs6d6A3OPm7zfg7S+GHpGScaOIAi/jsDEkapCO9rnNAmkKSWNWemxJoJugcbsleM0g8ZR9hBY40JXnuHErM2/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add free_frozen_pages_zeroed(page, order) to free a frozen page
while marking it as zeroed, so the next allocation can skip
redundant zeroing.

An FPI_ZEROED internal flag carries the hint through the free path.
PageZeroed is set after __free_pages_prepare() clears all flags,
so the hint survives on the free list.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  1 +
 mm/internal.h       |  1 -
 mm/page_alloc.c     | 21 ++++++++++++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index ee35c5367abc..e0d5743de68d 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -384,6 +384,7 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
+void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff --git a/mm/internal.h b/mm/internal.h
index fa7ffea4d492..0ef6f8221e5c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -934,7 +934,6 @@ struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
-void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
 #ifdef CONFIG_NUMA
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ce43f5a3dbaa..8eebe01cda80 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -90,6 +90,13 @@ typedef int __bitwise fpi_t;
 /* Free the page without taking locks. Rely on trylock only. */
 #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
 
+/*
+ * The page contents are known to be zero (e.g., the host zeroed them
+ * during balloon deflate).  Set PageZeroed after free so the next
+ * allocation can skip redundant zeroing.
+ */
+#define FPI_ZEROED		((__force fpi_t)BIT(3))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -1596,8 +1603,11 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (__free_pages_prepare(page, order, fpi_flags))
+	if (__free_pages_prepare(page, order, fpi_flags)) {
+		if (fpi_flags & FPI_ZEROED)
+			__SetPageZeroed(page);
 		free_one_page(zone, page, pfn, order, fpi_flags);
+	}
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -3000,6 +3010,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	if (!__free_pages_prepare(page, order, fpi_flags))
 		return;
 
+	if (fpi_flags & FPI_ZEROED)
+		__SetPageZeroed(page);
+
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Place ISOLATE pages on the isolated list because they are being
@@ -3038,6 +3051,12 @@ void free_frozen_pages(struct page *page, unsigned int order)
 	__free_frozen_pages(page, order, FPI_NONE);
 }
 
+void free_frozen_pages_zeroed(struct page *page, unsigned int order)
+{
+	__free_frozen_pages(page, order, FPI_ZEROED);
+}
+EXPORT_SYMBOL(free_frozen_pages_zeroed);
+
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
 	__free_frozen_pages(page, order, FPI_TRYLOCK);
-- 
MST


