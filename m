Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCACD25031
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 20:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E92E6B008A; Sun, 11 Jan 2026 15:59:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0967A6B008C; Sun, 11 Jan 2026 15:59:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7A66B0092; Sun, 11 Jan 2026 15:59:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCC4B6B008A
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:59:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A31C1AE94A
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:19 +0000 (UTC)
X-FDA: 84320898438.06.0285EEE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4FC63140008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NWzrfmBR;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768165156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SzcAdXKobZEjXIa6mTiYkJSdZHh3FBXqGV58zJC6AaA=;
	b=0q0gxC9j2hFybx7kVEF816qCvYGRWjuoeQb4FgRDR6EJl8b2dm4AqXvEnGgs0CHVtNcEUx
	8qnCHRuuVeegGWoiTQ0ksg5velP9W5msWweiNBsGLi2QgU1TFVqwXXu5Yo1gYGch0UfSX+
	EAj08ZITKE9AFON/FSaWnttzs10IyEQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NWzrfmBR;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768165156; a=rsa-sha256;
	cv=none;
	b=WMtaoYWkU0mU7zlYiPMfot5bhNE0zZ9hlL7Su4N5gOVeUuxjXaSGk8WgaSLgvfSg1ZPhjo
	KV70yJ2X0CqDuZWKRH71d+VwdcaPRQXrA3CqGChnpVQntA9i2GkhHPrWULHjZuPxuIJSHV
	9Mkm9m5GaCSHcf6dgjoSdpOD/a86M+k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768165157; x=1799701157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LNpnDim8q3+dLb7XU5TehbNGB6MpSqAnHM9U6qmRx90=;
  b=NWzrfmBRa/6Nv1Uf6c7Hyu036J6kMD2rvJJaKq/Ol6jDitcbgxnntcyB
   qDxLJ4wsffDnWt2jWdAUDPEKy8Vrpg41JbanAKCM3DgHT1IV9ESNywT+A
   FVuJcpzEpilVIgtnT2SafFXzr5mCMxuEP4Mz/uWDxbxpTY1ZsU7/eJ/8a
   RfCUFaMYPbP/0BKN0fQeWJLNThfKUS0oFG/lvoStdWASpLQ/KPdR8Qao8
   vUlcp2yM8yS1U/zyzpvHmgxDDoDu3pilucuCU7oTJgLbC4iVOs1DmvbPu
   EJSwOI9EJGy5Xg3JTpggkr3px9SXidpqcHItg8JdDu7Z2vc9gRnqbzwy9
   g==;
X-CSE-ConnectionGUID: D9Ygm1/5SbOUH5eiPs4NbA==
X-CSE-MsgGUID: c34gjmYqRm2IwGGgFqkSQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80904693"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80904693"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:16 -0800
X-CSE-ConnectionGUID: Bkff/IltSoKRlj2s67sD2g==
X-CSE-MsgGUID: HR5Gkm0nQJKuc017WtcF5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208419967"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.11])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:12 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH v4 2/7] mm/zone_device: Add free_zone_device_folio_prepare() helper
Date: Sun, 11 Jan 2026 21:55:41 +0100
Message-ID: <20260111205820.830410-3-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260111205820.830410-1-francois.dugast@intel.com>
References: <20260111205820.830410-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tzmqd4k7k13ymnboffbjewiwytsxcjtp
X-Rspamd-Queue-Id: 4FC63140008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768165156-210850
X-HE-Meta: U2FsdGVkX1+luVVQA/7MNqZfJ3qZTkIALkugQP+R3hAwQWaJZYvv+B5ZZNEDPL/5c53oAV16x8wq890DnB5Oazo2PwzrIGbwSW8Ca2Key4//GblewMoRYL+wMDkbWPR+JjgM/CWpjjyqpQhz+tieJ/b2b9CRSBENcn+6T8ufgcrNdCr5Z9fwoEFwTgS1kWTee/Mg94LXttlqXtYl2OXLMGLke9vo8cZC2qlLnjpH/BfTngLv4tiBHZrTNgo0NHeO5gFI6znPSZHegnBArQI1bHS9pdFPLuvBjBFBmaVX4k1XlGYoDoLGD18LqLWMHsQ8HHjSYwasLhfKDbFeBf65zCrROXZRWqz//X8a6FD7Ojx8rqhzAB7SnRXnASTIZVDXxk01liOhR2i5tL0LM/s06rkZ6jHwcjPDP8iih3xUODxq/Xg6km6nOQN5gdIR33/qHg1NxLZlTxuaM7IPcNPVqIR/eVBTlKby2bHSN4kpoDDITO6zaPIFsF85TEP7A5UUu/I8ld7YZQRloZptXAWi5TiE6nDYcXA4MUYKRrE4BfTRn++0s8JQfw5AidCmnfOxwA6T897SqMGOZeOWe2q/S4rEd/wX/8qGL9KkS+Due8Qfp9l75RnE3LjVxGFGAhfOUTw24PW0Wmz8VF7OeEKMpN+Bl0yQta+W4O0cHtILmn7uUk0qUWDnlH5XcS/HbvRaDRVY8s+uaQHmV5EgfZRjZ/UfXskF53ueHiiUIKd8b1eFUkd/JJtxUh6OtfPzFALyqrNPne7F+ldCUL/3fnSn/QSzfo17Ov7Wch0VgT/wEaaYvlhb8FldECVXN0STfHO/9WinomFjVRJa9YltE/n8lutVftCHt/Co/FKf1RjkYot1njA/YDnqeyeCbNhGYjc/bFTAVBCIrMutPUyESa9VYsu4WoKTp0JdWCwrjowzr4S437XhqGsHPA71eYySBUeDEXdSNcnY2f2xVYw2J47
 BNRVSrRx
 DPh1aptEMrqSkowrmvtRzAMNJSIcaIJVbHns3P1zRdmtWab6+kmyZVLyMeIVnC+hzpyvqo+0OFHmRIeIZPr9GgPd+EF16yqjGJ7ZksTfUhoudQ3zWD32SBoRx0R4TszbDIFKqMhAWLtD/hXuyO+YTDhTESAlKY3WF+2wPzO7poPEDvlVFhwXUH6V7VF8SFTY20PFORWLYQqk250AWIEs+dNHdVC+VvrkPCOxbLaoVXcIarBRO9T9hUEkn1AP1oIEmSBXDXdRtD4wiWFOcR0BrH0GFCDcor1VCgaa7BmuMwxoriPirpECdQSkg6opfvQPEN0WI45BrX/r26XO5BDJLef0vDAKxqhwktuBeVCICg25AvaJgwIvWuK2tsTiEYv+rZYlByBGOGZbrDgqEzvxsgG00r7eSGZTv8/xKjk9boBfTwFbGz8HULrSdm0+MLZD2QRUdzqQGjFVoxY3FA//ckZ2/dla4F9uCSW8TUSQ7BiXVPbMVQabtV3bH4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Add free_zone_device_folio_prepare(), a helper that restores large
ZONE_DEVICE folios to a sane, initial state before freeing them.

Compound ZONE_DEVICE folios overwrite per-page state (e.g. pgmap and
compound metadata). Before returning such pages to the device pgmap
allocator, each constituent page must be reset to a standalone
ZONE_DEVICE folio with a valid pgmap and no compound state.

Use this helper prior to folio_free() for device-private and
device-coherent folios to ensure consistent device page state for
subsequent allocations.

Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 include/linux/memremap.h |  1 +
 mm/memremap.c            | 55 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 97fcffeb1c1e..88e1d4707296 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -230,6 +230,7 @@ static inline bool is_fsdax_page(const struct page *page)
 
 #ifdef CONFIG_ZONE_DEVICE
 void zone_device_page_init(struct page *page, unsigned int order);
+void free_zone_device_folio_prepare(struct folio *folio);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
diff --git a/mm/memremap.c b/mm/memremap.c
index 39dc4bd190d0..375a61e18858 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -413,6 +413,60 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
 }
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
 
+/**
+ * free_zone_device_folio_prepare() - Prepare a ZONE_DEVICE folio for freeing.
+ * @folio: ZONE_DEVICE folio to prepare for release.
+ *
+ * ZONE_DEVICE pages/folios (e.g., device-private memory or fsdax-backed pages)
+ * can be compound. When freeing a compound ZONE_DEVICE folio, the tail pages
+ * must be restored to a sane ZONE_DEVICE state before they are released.
+ *
+ * This helper:
+ *   - Clears @folio->mapping and, for compound folios, clears each page's
+ *     compound-head state (ClearPageHead()/clear_compound_head()).
+ *   - Resets the compound order metadata (folio_reset_order()) and then
+ *     initializes each constituent page as a standalone ZONE_DEVICE folio:
+ *       * clears ->mapping
+ *       * restores ->pgmap (prep_compound_page() overwrites it)
+ *       * clears ->share (only relevant for fsdax; unused for device-private)
+ *
+ * If @folio is order-0, only the mapping is cleared and no further work is
+ * required.
+ */
+void free_zone_device_folio_prepare(struct folio *folio)
+{
+	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
+	int order, i;
+
+	VM_WARN_ON_FOLIO(!folio_is_zone_device(folio), folio);
+
+	folio->mapping = NULL;
+	order = folio_order(folio);
+	if (!order)
+		return;
+
+	folio_reset_order(folio);
+
+	for (i = 0; i < (1UL << order); i++) {
+		struct page *page = folio_page(folio, i);
+		struct folio *new_folio = (struct folio *)page;
+
+		ClearPageHead(page);
+		clear_compound_head(page);
+
+		new_folio->mapping = NULL;
+		/*
+		 * Reset pgmap which was over-written by
+		 * prep_compound_page().
+		 */
+		new_folio->pgmap = pgmap;
+		new_folio->share = 0;	/* fsdax only, unused for device private */
+		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
+		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
+	}
+}
+EXPORT_SYMBOL_GPL(free_zone_device_folio_prepare);
+
 void free_zone_device_folio(struct folio *folio)
 {
 	struct dev_pagemap *pgmap = folio->pgmap;
@@ -454,6 +508,7 @@ void free_zone_device_folio(struct folio *folio)
 	case MEMORY_DEVICE_COHERENT:
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
 			break;
+		free_zone_device_folio_prepare(folio);
 		pgmap->ops->folio_free(folio, order);
 		percpu_ref_put_many(&folio->pgmap->ref, nr);
 		break;
-- 
2.43.0


