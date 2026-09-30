Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5936CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55146B008A; Wed, 30 Sep 2026 10:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E309D6B00A2; Wed, 30 Sep 2026 10:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43106B00A4; Wed, 30 Sep 2026 10:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A56E26B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:08:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30CE5C07B2
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:19 +0000 (UTC)
X-FDA: 85270608318.07.C128F33
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4443D1C0006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OrZiP2tH;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwIkzvmvri0jNuEZQ8eiZ6f7IsoamN6cu2j85HlYjLQ=;
	b=65oWZ0zBlGbWP7dxcg91B1igsgD3SGUdbrTw/Y6bXJwFoBug8Xn6jogi2w7S5B4B92P3RB
	8LHHVQWBTmNWbmoWvUsgTTlzVVKBtq3ckRwv4zZeNqRhqdkrO5iV5RQy604VhcgkuOy1zS
	F1/0nosg7IAzTxLv3C27b2t997y3q9M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OrZiP2tH;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777297;
	b=5EGuvVgBZMgqapI56jZrJbqPimn2kPeCcgS81HXwge0OXL0cf7vBs+m4tE4bGuwTqoMDkt
	IgqcaPKZFSD0H2R7K4LVEZNbAAmufVDtEBpZzhKLuw//TlqeXm4/JPdwUQ4ZCeyTnp0Yce
	Dm31aHi977HAxBKCxDHn7YA8inT0UjM=
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0eeda3e03so2132737a91.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777296; x=1791382096; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mwIkzvmvri0jNuEZQ8eiZ6f7IsoamN6cu2j85HlYjLQ=;
        b=OrZiP2tHp7Z96Jn3ddMxb6bC0E7YxMQB8ocd1oryGqEhkRQFqKg8BvkQaGUzvcWd8E
         8Bs3XCN+hGM3tePgMRKGAXcMloN49VttryfObELYvTqDSVBA+8eNfk868eqx6OxoUya+
         xQPZKB0WUv+CMCLUaFeI9CaWqwSeROCATUtpjNIZz2UCOMdqFmq7yna6EZyytuyd9JYo
         JyJh5qO73qFk54QCFj9uRIkxypNxCSRuHWvoSQQ2velbbJiTgWKXQhdOG0TIYXZZL+Qm
         vwQKU8uDNe463KsmaMCSarAYvAArTmaMqWqa8RV6OIbeTGK9vDrck/vwS0b/CADYJQXe
         ow6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777296; x=1791382096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mwIkzvmvri0jNuEZQ8eiZ6f7IsoamN6cu2j85HlYjLQ=;
        b=wNLw/W+0LJJUVHudLxtggxaHacasfxYa+2PGMb7H4uVnlp4GWkLAeKJNA5XVA4PBTE
         vDm0ksNeNdAgPQ8iIiUnK2g9CuarSMYGbwFJGRjjOPMtQrPvqNZCKcDlW6TyYVPmbZF6
         2VFbvVGjY8gpgbCwRxTnEyP2AXFMlIkGmYhgc5evI8UpDf8opcEZ7bVe5bzwo5JqvKk3
         yXnSMmXC5OX4iO1WhGfQMRYZQf2Z1G0ok4gUwABU9XVOSuGT3nWcxp+kevcJjrLLwQAc
         Ml2RzBMKNLPOGAXtwefiUtSgXHxyWtpxIQCvdYCguxFvrGFueFcDTbOnL9+7kXBR5RA0
         jz1A==
X-Gm-Message-State: AFq9FYI7T3MEMlPhWrc4Ua3kwMGzMVn/Ch4KarOrM4i+M0rM2EpEqQGE
	VZemE3XYudIVoWgy7fUxwtpmvlMVUKORP6FDaSqAc6c6g850h4aXKe4i4Dv3H9g8HY4hmFOrdmz
	XBjlE44I=
X-Gm-Gg: AYBFou3XQxuNmWv1z0SVWR5L9bnDP3O1xfCWmFhpf9sQsQBtUJ5xPCFVUZfEMtr/uGH
	Y+0NyO8trJ/tQmj9Vh4b+vlqWanr/hVfSEDR9xHaGSnWXWDeB0o+h+gT+1XixhNhja0rpCp0jZ/
	2TEnusLx8tmRYi3AyeNDUTQfZDn1s2nnjQUHbbxmJicgyO5V2pqM+GyG5swaKpdloodlJ+7h/s3
	7H545zazGrTmQHEOIKHLEpKlvJN42mje+ItDckRUszNAfJR2Fs2xRkdyQJYwKrEKlnKvrazi4Y8
	w0pwrnrTRxC8Cn5we2xqp0TgYudxO6p6vy2pYdMmbxX43o9FcoQic9BoYRGHFlKdcxbK3kS3LuW
	S5rnM2z4XB1XZrbkbv+F++fjRCHwcPqWmsb0e0Z0Zfa+rqE2A6jwIieJz3bo2A7new3FiHvCQ2Z
	p4jxRao/904K+AOYyv9g4SflaBuHQ8q6JUG1rNYS9ueuMFJYC32geLoGTtbLmaiFjFBsD0MzTBf
	OY+EO6ITLoJsQ==
X-Received: by 2002:a17:90b:4b11:b0:3a0:d79d:b6bf with SMTP id 98e67ed59e1d1-3a4d14de36bmr642331a91.20.1790777295537;
        Wed, 30 Sep 2026 07:08:15 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.08.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:08:14 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 07/12] mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
Date: Wed, 30 Sep 2026 22:06:22 +0800
Message-ID: <20260930140627.57431-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: to1kdqbsw64xwuo71pr7eohryr7i96fs
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4443D1C0006
X-HE-Tag: 1790777297-633762
X-HE-Meta: U2FsdGVkX1+uZaWqT0rwEGBysqXncApW5urBunCsOvQDuIq2AWRF1XfHrHJYtL080zQoS2voXwEiI3+4RPd1RpnBCW5F+gkEZVNIFj1jI6qI+lseFb2mmzRNRq5gDd5EiAXEq3hIc8FTKezvmyMfEDjycuAxyEe6qQ5Ba3+SqFu3lobiLRYuR6B3b3U+4l1IZCu2f8aAYQxqLQwRwP+kxdUG47vRL81E27LeOCqa9MoGunTTLIsNFB+VM10o5j0XpIzr/hZ7/pe8ulyNBlkwS7w5f85l1WEAZv0ORf5OxIogw/d5yT45pui0CylkJlGWa9ukyOUl8V19ouNJ7mavckbAhAlMiAWb8OCeDIB5BewZKdNOd1UE9Eoqw4mvKGztOUJre4h7LIJ6LNK3gAWKiw3XZ8yCTj05+Zb6oB7JndHPvh9a2cr6Tn/Hk6MouDTy8Offw2HURK80NzGDlAzA5R6bZ8q9pF4jSbZZ63qkt9EEMKBmVi3Pa5L3eQJLAhz2Ay7kKkjs9m8V/NWcDnHjLtWyhG2xdHoH6zO2Es0VWouh/1Cra70rQeeIyLFnAJ4iDvIWU3UsQKwgDrSrbLeqykJYG0T2Vj8n2TejOrOzQ7y/sdDtJ3wN1ViG8wNS4V/V7xhbhNQgF+DJN5hUZwtyEqguYeVEFn0kv/wmjCDYF/RoDUjISZy8F4vZpGnoi/khzB8xmvAm14bFbWdiDK/T+PyYDYB5VkPTL/GAiKfh8ZHIG4x0w3kIT89at8+j5d4lwUWqQ6l7sLWkQovIaWo7JffpMls0UiEZcy9cnXPiLhou/u9ijDJyL7gKvbvDmx+ZXBmwyb4cr7vt7wuHosa5EPHhBZTZ710ypI8zLphKZRBAG+oVMtocypojmGU7WZv8dkDhqZFTgZDnAqwYRHZQ8BIbiaHly0tzTLq6yymGq1XtKR52Cn+zKlXJpSVdyuf3jcDAJ78jcIG1/7+dWJ3
 kkUMnYNq
 8hGy0GKFrv/O2bpvPZMtWi4e2ZU2lIZ08/Lvx9BYU38pjAOAw9Jjr6tkHngxN4HmqFItnyJG3DPZgkYZtXKP/RzrSaPywuplQsky4S/N8mNWkxt1OO0tV+Gxqj7DUGuNwQaadcqcZv3eoS3IVDG1peq6szAGOMT9x2ggpZUZd35D/QzeJ/ay7Cu43hUrtWKsfYmFcdIbjf1JWc8TZqCEDLPExQjhoKGKLrIe1CGZASIl0uGODJpwJKAHo6cUpcJqLKVCnPozjnU4/CY7pukG7Z6CYNqVKArfq3bYM6mfpurLEOZ5qztqDnC7BfCB4ZrVtEgVI5Rwq0MjoSMPLZot+R60IH2BetIZF+TNwzbTxoqfn77+Jqm/6jhZ6CFJ2s3g4RKwB8ry8ntg7+sAKj5fHEexydPqkwOqfYTJu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap pages.
Device DAX has not been switched to that mechanism yet.

Switch device DAX to vmemmap_shared_tail_page() as well. This aligns DAX
with HugeTLB by using the common per-zone shared tail vmemmap page.

The optimization is enabled only for DEV-DAX through pgmap->vmemmap_shift,
which supplies the compound page order recorded in section metadata before
vmemmap population. Unlike FS-DAX, DEV-DAX does not modify tail struct
pages, so sharing them is safe.

Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
initialize its entries with PG_reserved for device zones. Also skip
poisoning vmemmap-optimizable sections while their struct pages may be
shared.

Each PTE mapping the shared device DAX tail page takes a page reference.
A sufficiently large range could therefore cycle the reference count back
to zero if population were allowed to continue after it became
non-positive. Use try_get_page() so further mappings fail at that point.
The section population error path tears down mappings created for the
failed section, while the warning makes this currently impractical limit
visible.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Prevent shared DAX tail-page refcount overflow with try_get_page()
  (suggested by Andrew Morton)
- Make order const and move it to the top of the function (suggested by
  David Hildenbrand)
- Clarify why optimized tail pages must not be poisoned (suggested by
  David Hildenbrand)

v3:
- Move device_zone() after the definition of NODE_DATA() to fix
  non-NUMA builds.
- Update the commit message to describe the compound page order stored
  in section metadata
- Collect Acked-by from Qi Zheng

v2:
- Explain why sharing tail vmemmap pages is safe for DEV-DAX
  (suggested by Qi Zheng)
---
 include/linux/mmzone.h | 10 +++++++
 mm/memory_hotplug.c    |  6 ++--
 mm/sparse-vmemmap.c    | 63 +++++++++++++++++-------------------------
 3 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ee9cbaaa63f4..cd68c1904c91 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2143,11 +2143,21 @@ static inline int online_device_section(const struct mem_section *section)
 
 	return section && ((section->section_mem_map & flags) == flags);
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
+}
 #else
 static inline int online_device_section(const struct mem_section *section)
 {
 	return 0;
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return NULL;
+}
 #endif
 
 static inline int online_section_nr(unsigned long nr)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b428da66d279..d7a59167bec4 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -43,6 +43,7 @@
 #include "mm_init.h"
 #include "page_alloc.h"
 #include "shuffle.h"
+#include "sparse.h"
 
 enum {
 	MEMMAP_ON_MEMORY_DISABLE = 0,
@@ -554,8 +555,9 @@ void remove_pfn_range_from_zone(struct zone *zone,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages =
 			min(end_pfn - pfn, SECTION_ALIGN_UP(pfn + 1) - pfn);
-		page_init_poison(pfn_to_page(pfn),
-				 sizeof(struct page) * cur_nr_pages);
+		if (!section_vmemmap_optimizable(__pfn_to_section(pfn)))
+			page_init_poison(pfn_to_page(pfn),
+					 sizeof(struct page) * cur_nr_pages);
 	}
 
 	/*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 26be355aaa37..d40a2f5b5fca 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -225,6 +225,8 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 		set_page_node(page, zone_to_nid(zone));
 		set_page_zone(page, zone_idx(zone));
 		prep_compound_tail(page, NULL, order);
+		if (zone_is_zone_device(zone))
+			__SetPageReserved(page);
 	}
 
 	page = virt_to_page(addr);
@@ -288,14 +290,18 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			/*
 			 * When a PTE/PMD entry is freed from the init_mm
 			 * there's a free_pages() call to this page allocated
-			 * above. Thus this get_page() is paired with the
+			 * above. Thus this try_get_page() is paired with the
 			 * put_page_testzero() on the freeing path.
 			 * This can only called by certain ZONE_DEVICE path,
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
+			 *
+			 * Use try_get_page() to prevent the shared page refcount
+			 * from overflowing.
 			 */
-			if (flags & VMEMMAP_POPULATE_DAX)
-				get_page(pfn_to_page(ptpfn));
+			if ((flags & VMEMMAP_POPULATE_DAX) &&
+			    !try_get_page(pfn_to_page(ptpfn)))
+				return NULL;
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
@@ -529,47 +535,27 @@ static bool __meminit reuse_compound_section(unsigned long start_pfn,
 	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
 }
 
-static pte_t * __meminit compound_section_tail_page(unsigned long addr)
-{
-	pte_t *pte;
-
-	addr -= PAGE_SIZE;
-
-	/*
-	 * Assuming sections are populated sequentially, the previous section's
-	 * page data can be reused.
-	 */
-	pte = pte_offset_kernel(pmd_off_k(addr), addr);
-	if (!pte)
-		return NULL;
-
-	return pte;
-}
-
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     unsigned long start,
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
 {
 	const unsigned long flags = VMEMMAP_POPULATE_DAX;
+	const unsigned int order = pfn_to_section_compound_order(start_pfn);
 	unsigned long size, addr;
 	pte_t *pte;
+	struct page *page;
 	int rc;
 
-	if (reuse_compound_section(start_pfn, pgmap)) {
-		pte = compound_section_tail_page(start);
-		if (!pte)
-			return -ENOMEM;
+	page = vmemmap_shared_tail_page(order, device_zone(node));
+	if (!page)
+		return -ENOMEM;
 
-		/*
-		 * Reuse the page that was populated in the prior iteration
-		 * with just tail struct pages.
-		 */
+	if (reuse_compound_section(start_pfn, pgmap))
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)), flags);
-	}
+					      page_to_pfn(page), flags);
 
-	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
+	size = min(end - start, (1UL << order) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
 		unsigned long next, last = addr + size;
 
@@ -585,12 +571,12 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			return -ENOMEM;
 
 		/*
-		 * Reuse the previous page for the rest of tail pages
+		 * Reuse the shared page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)), flags);
+					    page_to_pfn(page), flags);
 		if (rc)
 			return -ENOMEM;
 	}
@@ -922,13 +908,16 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
+	ms = __nr_to_section(section_nr);
 	/*
-	 * Poison uninitialized struct pages in order to catch invalid flags
-	 * combinations.
+	 * Poison uninitialized struct pages to catch invalid flag combinations.
+	 *
+	 * Tail struct pages in a vmemmap-optimized section are initialized and
+	 * shared during vmemmap population, so they must not be overwritten here.
 	 */
-	page_init_poison(memmap, sizeof(struct page) * nr_pages);
+	if (!section_vmemmap_optimizable(ms))
+		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
-	ms = __nr_to_section(section_nr);
 	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
-- 
2.54.0


