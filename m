Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C4BC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 04:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1D66B00C9; Wed, 22 Jul 2026 00:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1EA6B00D3; Wed, 22 Jul 2026 00:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490316B00D4; Wed, 22 Jul 2026 00:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E8216B00C9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:42:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 748881202D0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:42:30 +0000 (UTC)
X-FDA: 85015166460.24.6B9579E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCDE5A0006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:42:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Z+u3/XTa";
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784695348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EXek90LKAYTRZaSZMMcyYht1LmNZYnszoNkDm2vSwWY=;
	b=e6jnInKTPx6gzZWHxOUa3BKbnzV5ps1X/MKJCK15VKim7hL8nfr0f859gG/dMHNYd7gMVW
	4IM89zWg8FhEkTm7OieMesQpwUrW78zvRiUOHSQft3j+L8N03dXE4L3manzq2ZutY2zv63
	fJYBiQm3QyEGIDzHD7vh3Bh+ApYEDx0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784695348;
	b=jZ4CMgylH5sv9ylndGJeaO+fIUMJYYB6pmVCaIuZx0zaSFtiFIg6bBx/E92m+jhdy2la7A
	WCu25i2oIq57Z5YzdvJjIWdIvpiWDbwjgARwBEYiqDo3fSblswMm3b5B2Nx69qkYDuSl7I
	cpaq3cddX+bz80NKEmq6pLBP0gukUeg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Z+u3/XTa";
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784695348; x=1816231348;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=egqyx0xIHYO6pVjtq79Q7C2oe7YYIs3Mzn5MdOs14pI=;
  b=Z+u3/XTaoSYSvPiK7UWN6QJfhDNOXbmdtTVdCoakHxebargmvGY602Zp
   8PSnVlGF6zTobpvMvxr36Bmfy/qPQqXWqTW5Eyiv2FBa5vnwpgtSYJdeM
   zTyAFVE57uAoNGtoPaniPyLq6mBMutGoUj39jP71zJjHgs0gS/YTZUjTr
   HTGoyBsxtQI3xpwsC50fFLMiuB+zhRiTD1Ry6BA0iHEa2EsOQQVUvvEvf
   hdU6Zk87WgUVTGmhsthg3+GErE4M4KHJdvoX011KdO7SYs/6HMG3UXadk
   tIkMfJyyhSGOJCqwyGjEOAqFUNdK1pAdppfSDuB+4xiXfAUx30pZjWo5B
   w==;
X-CSE-ConnectionGUID: nBwlIeWHS0m6lVz1LbL3rg==
X-CSE-MsgGUID: jS95LRSGT3ugnc09qFRofg==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="102865781"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="102865781"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 21:42:26 -0700
X-CSE-ConnectionGUID: f5jNSLotR9G+hsgBQa+nlQ==
X-CSE-MsgGUID: NNhGkjL0QKOHHVPYPaELjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="254063555"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 21:42:26 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Dave Airlie <airlied@redhat.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 1/3] mm/huge_memory: add folio_split_driver_managed()
Date: Tue, 21 Jul 2026 21:42:18 -0700
Message-Id: <20260722044220.1110278-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CCDE5A0006
X-Stat-Signature: uamaq6t1k3mhe5bs69knmdx6xqw7e1i5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784695347-234100
X-HE-Meta: U2FsdGVkX1+ydqabGRgcQLLKXMQTyS7ZFuuFXQU/cUBgT4V5WZYXcyNEkpkzjXjn4THvpvpTxD458zujtYJWCOnBLOPp3qnn3UHvw648Gi/PxETjI4WdWH96JSymRv5L0lL/Y86T/zluH9MIytP3MsYx26eLr91iOOdmi/aFTXtG4xKCMG2i7CpUvopka9oTmvSaGJPa22x2Eoce5eIJO+6HVrtvh43p/Zye1g4P/k4f6WzlpTgMxxbRxeU4jjL2nSM1D1VywfAFasnp4rfUp4FK/Ph0bLYYCTBwRT7BD9gKKmiRZ7St5CQFrC99Xq7fRsC1zcVfiRsV9peWMQkbkTe9pcTNBUvXPLR5KTTwYS/W+Zo/9BZPVB/Xx4EfU/3PD4Per2i9Vaf9kXRC64VUHSNt0ozRooTxjh+GrDm6lWixYFg6ptUsz4OnlEVydVxC32lnJgD68eNHyYgAoyz/kc0iJZamwnzBHVo8NTXey8OZhFwMrV0DXQ4rGR+L4ts4j38UggLKv1/hscVqpJrhvE8Oy/4uSBJsMeItOzs1/YaJW2xst4JxIp51d81FXzFWaqug8UNaLen/lv+2Lex3UpvbfnUNLd+nOTgm9NOVkgPbrb44h6sDIsAvEpoiA/h+L5VTNYtNrVaBQF4/90Q3aI/SXC3m2N/XjdkF2JgWFbx2fTDXYnMFw/CGXdVFjMn5/8QBUCKPSg00J3aocx6fh/c3+rn3ASAXdPRqXcqTI2VVApEp3WyrLJvkBhQO4yFYrgOrybTCdCWtu7wESVYDkmPzNnmOZSF4STXH7duaq6laRCse7YzsSodhS+pZBX9iPJdU0mliFxtidw84DpuvCEv3KO227xC0sOVq4cik7P0ZHjL0lVlc5VsKXpX4uxKdeXgDsycN06pqmaTwhv56dypbxbGEVs5VNAW00lf2IAEZ7kafmXE5HHHjDIb18qryxniE6Hctqm0xK9oWNBY
 iuJrN87Z
 MKdB1K/nX+mx2pbfoJCcv/A+ivlA56RXpOMJqYjoWQ4ABb5KGPfYVObbAQdiqR5LZGnPQzpKyUCeNYSAw/xJid+xzWIGxSFWCcSdnbH86iU+qtIOTJ9XemPNCpZe65+AF9mPTxzkEHseFfeXw7lw7qvMe2jG4h5Y5eCbbtdbng+xyJe2UZf5qP4NdtUfjNSajx8EdzGMhoMZvKvoetab9R5xnTAcMyQQinDAKXqBNKLP3ljy/kTg8L1GTJNrfuCScwCFxwUpin9lZuCwSw2AiBpWrPCgoL1STpdHa1nhcXw+LNrmRXQODBwtaQ0gd4MoHT3qZYKU1JfXC6tag4xSZ8ZxRsqbu+rzP8hif2PcbjGpySg2Z80NQPzERGtUnRqSR2Q8W1m1PFZUcDUHYpxKEsPmZraIl77OIVGRAwGLPJliH5wezgfRmxNhPzIlrMQYqj5iVr3FSU6aYccd2CxqC0uKi7pOyZQrBUz4SA1C3QHgPre23UCAsQH1Zh5wCT8UGh6D8ig+CNiUW6XAgehzyrZJ6i2SRkyxz1R3CTkVQ82arVjfdS1wbPzaYDi4YPxnydTYyWkm7JOXUFZEyTGGZ0XZ7BqINyryakOSq2pqoevIlhSCCLPG+wnVLfWRO34rhwvFC3U/wuFTg/r3825KiIdMqzqfQmkQ1o5JzNKd8oKESofubq12iYyxmqnIlpPLR1RGfw1x/zwfpi38HaL8SLIC4zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a lightweight structural split primitive for large (compound) folios
that a driver allocated with __GFP_COMP and manages entirely by itself,
outside of the core mm's view.

The existing split paths - split_folio() and folio_split_unmapped() -
are built for folios that the mm owns: they perform a refcount freeze,
walk and remap the rmap, and take the anon_vma / i_mmap locks, and
folio_split_unmapped() further assumes an anon, pagecache-style refcount
model (nr_pages + 1). None of that applies to a folio that is:

  - singly referenced (the caller holds the only reference),
  - not mapped through the rmap (folio_mapped() == 0),
  - not in the page cache or swap cache (folio->mapping == NULL),
  - not on any LRU or the deferred-split list.

For such a folio the split is purely structural: because nothing else in
the kernel can reach it, there is no need to freeze the refcount or touch
any mapping. folio_split_driver_managed() therefore performs only the
compound and split-accounting teardown via __split_unmapped_folio() and
then hands each resulting order-@new_order folio its own reference,
mirroring split_page() for compound folios. The caller keeps the original
reference on the first resulting folio and is responsible for freeing all
of them individually.

The immediate user is TTM's GPU page pool, which allocates higher-order
compound pages, maps them into userspace via VM_PFNMAP (never through the
rmap), and needs to split them into order-0 folios under memory pressure
so pages can be backed up to shmem and freed one at a time.

A CONFIG_TRANSPARENT_HUGEPAGE=n stub is provided so callers can build
without the split machinery; it warns and returns -EINVAL.

Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Assisted-by: GitHub-Copilot:claude-opus-4.8

---

The patch is based on drm-tip rather than the core MM branches to
facilitate Intel CI testing and initial review. It can be rebased onto
the core MM branches in a subsequent revision.
---
 include/linux/huge_mm.h |  8 ++++++
 mm/huge_memory.c        | 63 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad20f7f8c179..35661d82d54a 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -402,6 +402,7 @@ enum split_type {
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
+int folio_split_driver_managed(struct folio *folio, unsigned int new_order);
 unsigned int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
@@ -656,6 +657,13 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
 	return -EINVAL;
 }
 
+static inline int folio_split_driver_managed(struct folio *folio,
+					     unsigned int new_order)
+{
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
+}
+
 static inline int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *page, struct list_head *list)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..06f9a5f35df8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4185,6 +4185,69 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	return ret;
 }
 
+/**
+ * folio_split_driver_managed() - split an exclusively-owned, off-LRU folio
+ * @folio: folio to split. Must be a large (compound) folio that is owned
+ *         exclusively by the caller and is invisible to the core mm.
+ * @new_order: the order of the folios after the split.
+ *
+ * This is a lightweight structural split for folios that a driver allocated
+ * and manages itself (for example TTM's GPU page pool, which allocates
+ * higher-order compound pages with __GFP_COMP and maps them into userspace
+ * via VM_PFNMAP rather than through the rmap). Such folios are:
+ *
+ *   - singly referenced (the caller holds the only reference),
+ *   - not mapped through the rmap (folio_mapcount() == 0),
+ *   - not in the page cache or swap cache (folio->mapping == NULL),
+ *   - not on any LRU or the deferred-split list.
+ *
+ * Because nothing else in the kernel can reach the folio, this helper does
+ * not perform the refcount freeze / remap / anon_vma & i_mmap locking dance
+ * that split_folio() and folio_split_unmapped() require. It performs only
+ * the compound and split-accounting teardown and then hands each resulting
+ * folio its own reference, mirroring split_page() for compound folios.
+ *
+ * The caller is responsible for freeing the resulting folios individually.
+ *
+ * Context: caller holds the only reference and excludes concurrent access.
+ * Does not sleep.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int folio_split_driver_managed(struct folio *folio, unsigned int new_order)
+{
+	unsigned int old_order = folio_order(folio);
+	unsigned int split_nr = 1U << new_order;
+	unsigned int nr = 1U << old_order;
+	unsigned int i;
+
+	if (new_order >= old_order)
+		return -EINVAL;
+
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio) != 1, folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio->mapping, folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
+
+	/*
+	 * Structural + split-accounting teardown only. No mapping/xarray, no
+	 * refcount freeze: the folio is frozen-by-ownership already.
+	 */
+	__split_unmapped_folio(folio, new_order, &folio->page, NULL, NULL,
+			       SPLIT_TYPE_UNIFORM);
+
+	/*
+	 * Give every resulting head folio its own reference. The original
+	 * reference stays on the first one, exactly like split_page().
+	 */
+	for (i = split_nr; i < nr; i += split_nr)
+		set_page_refcounted(folio_page(folio, i));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(folio_split_driver_managed);
+
 /*
  * This function splits a large folio into smaller folios of order @new_order.
  * @page can point to any page of the large folio to split. The split operation
-- 
2.34.1


