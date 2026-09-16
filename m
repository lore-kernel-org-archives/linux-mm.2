Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC3AC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4EE6B009F; Wed, 16 Sep 2026 02:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200E06B00A0; Wed, 16 Sep 2026 02:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A20A6B00A1; Wed, 16 Sep 2026 02:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0AF26B009F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:44:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54C55A0637
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:23 +0000 (UTC)
X-FDA: 85218686406.11.6A2BEA6
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 993C6A0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="W5Hhjlu/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1EqIpH0CyAwdpMqjXcOe7F5BCJx4eubUzqhI5rvq2s=;
	b=nKGwvri2qlsOl0NH4uwmUMlh1W2W0fKt961tspKlEQYxKpiUPTnCRcUonH3IsAHVRqGbXn
	L+GowJgjSAUrTOS7y/TUKwF7nUm65F1H3WlCd0rZGLt5mkBNxdMiUrEeDx1OuyxJytes8V
	Qcn3fMwPYGnHaJgO71PYvcU5Ye3H/MI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541061;
	b=29AlycS7rIARIc59tLjvHKg5XeM632PQkadUoBEwwUYEDgnnhrrfBppRfjK4PzKKcuqBGJ
	UKud4xWG+M1d4JUJmvyMjA3nC+QzKhy5+UBnqRL1PzmzIXQ/Z0mn6dd3ZnxQXLqCPpsTF5
	kRk0NMUqApL4zzkHhLrx4YMrrJguBZ0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="W5Hhjlu/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d747ed6d6eso4852325ad.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541060; x=1790145860; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b1EqIpH0CyAwdpMqjXcOe7F5BCJx4eubUzqhI5rvq2s=;
        b=W5Hhjlu/fuxhiISliLeUUo2tSiQMI3e0sxccYgTdGMQMoIqsFQEJDnNxYZS/CDKQsv
         nB8Ggl0DKXM9Fw+abavJOBV84mo8ZbQh+/Kj3cMOlX+sKkaLUH5WzW2axaXYMLPCXgOd
         V/ozPoBTD7rCjvAjzl0leUjUknqluQtQVx0jbFNT9qhdPXoIARfE0lL/JK5KHUUtufaS
         xJJHN88qgUioJjHf0GFvDvlBX9Iifq/MJ4cG27/WsoBqCXHT52Eq7rrJsTVJzolZmlE6
         3iVzsPeS2PJaIPvYN+sfmjmqbQ+hh63g4jPsxP8mc8gekae4vDte44VXqV7KZSGqyk1Q
         P6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541060; x=1790145860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b1EqIpH0CyAwdpMqjXcOe7F5BCJx4eubUzqhI5rvq2s=;
        b=ZUqK3tB0OVbVJCkQzVlz3KWUjGLip0nia7yZHPPWvJhYB70eGBM9C0MLuZsbER4D/4
         wdycWI1J2ffRGaMqKyAuiSE3cH0ieAtMxWMgD00QlNcE18sLDjY6ZBEFT9rLI6pNmAQW
         uwiHo0t8iXY7q87M/fg8KN+2URYnCF64Z+e/UVCwqkQRrDem/dVhXk5keHE0/ODV0KWR
         B5h/DzXPK0BuOZDzBvAFgyFXhsQIihQGKvD0zrufdZAydRNcuv2E8wglDqAVqdNoWwlv
         IA9YzvSyJdqtL/bJHjHl5Z6/VNL1x+zfrhip3jxf73+wDiWLSvKI2S9iYySOLVAyxO/r
         b9kg==
X-Gm-Message-State: AFuF++nS/UvLUgjBaSaRQj9nD5KwLKkFmHTK4efi8Z5J3f9bUS3N5VDN
	HJu/oNBFiUxRQYWfZMLHlRafIVx9sgXi6rDE7t0ZS4YKJ5CU39C11FK5SB+rgsNjxYI=
X-Gm-Gg: AYBFou0VlVRMmQgMPzmr8yxO0kre9qV/kXghq3IZoD/Z9+X23t4x2Y9wQaoE/9N7LiG
	OUi96F9AppwW5T4wP4RNRZ+i/U2ytSy+APZ7yhJZ4hdyTe0ysLP9uiCg4dqB2ej34+j6v0dEkpx
	8wI8gEiHTr1kqyqhWWvznwP1dMVsoMXF8Iop9elPTDTYJvRoATr6gIGzDakSTkGtk7KUydgWaKe
	wKmzzVSGspf1RMApzzz6JqXkkTNL7ROgiwJCeq2rYCg72qiblvQ7vtV7PWY70iIlJ10u41frdhI
	VqAF/G7M3FhGHentVPDadI0YCqeNIESoCIrZUWTzRweCq+q0GCMQcXv70NDEmfDjRhUxZlwDpI0
	jhG0fqh28Rjm5Fi8VSOnZYD79LLPRPHdR+7w5qRngdQ1ZEV5+j+3ZH64HiohwUBACwMFjMRT95h
	jRqtafb6rla1Fy58Y8Q4YfkJyc5E2HuqF9Jjzh9YVdHLc3QuYv+jCn9mCPiy2sOSF2PvJiQmHbI
	OJu+MMOhZ0x65V2uYY6
X-Received: by 2002:a17:902:c401:b0:2dc:fcfc:bdeb with SMTP id d9443c01a7336-2dd8e76f78dmr28974185ad.22.1789541060351;
        Tue, 15 Sep 2026 23:44:20 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:44:19 -0700 (PDT)
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
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 06/11] mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
Date: Wed, 16 Sep 2026 14:43:36 +0800
Message-ID: <20260916064341.1825793-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 993C6A0005
X-Stat-Signature: f4ajqpzibw3kijf5ekuor8y47f11q5m5
X-HE-Tag: 1789541061-130082
X-HE-Meta: U2FsdGVkX1+BLc1fqoFDRMYh49RpUe9smsyz0gEK2D8Iiz8SMAzAtWxNjFeOu3aRrY21mRsm+j6QJQuYnYSNzkj1Wsx1PWonEckxkSXHvgSO0LoU53obfBXrLrutiV+yrtXV94oX68aLzz91L8mjU0DNJQenQKn2TSupmktHigKPuPxbjsWPiSyOXdp7HTIbzY9vMqyGectt+CvSNROKd1C0bqfxbt/YGxPXU0xEFnewYUOFEmkxpmGsCGTkGSDfBuOiCfSx+lleX3/viKmAaLiRtc1AI86ndlB4gc4MkW7SUpMKIJcwIwKs6sM+Kc8pjFuT229r8FtyAz6uGcwaOcVaFg3jecpwc47zPv64srBqrB0kE0EtDeJUGMzelTNQW5OY01SOgi0qzT9GdzLZBzELjIJpzapwKnnRHurm7TjT4GqRsq9aS0QVmYTMYfV6U4pYQUCK5H9YJbp5WPZa+UEM5NX4pxcN6VLsirkl73IoY5pQCiUi7WJgj7Mx0BjP+Us0NISEPY7sdQvyTPlGGpuvq/mTEvJ5R9yJq9NOMxa7rR4BwDTMvsJ8JJW3i3ALNUVDBMh5MhyxNJ/rk1mkxV3H69A+gjSxcly39eoWVfXVM3jTvo/1rH6u2sX6C0Qx+KC7KyYFlKyicPw39TtE8ZrE7eUD6Ki2ymTaApq9c8YhN4K9+r2LtLWt5JkV8Uz8gZIii9DIBbDHJWVq0xJFb63vZ2enBJrcOk1UcIJVsLMw0EF1oGeyy2bIL6so/WLAMjwgbSonbkOkFZA9WdvA3LV8q2EJa0fobdSQWdKkhKiiFyqI8+YLbLmsVmXxgibmMzOrW48GZa9RnlFF1bAJg4MQc9y2WL8vQz8i1l4xrXFNW1NyijgcUl3/LL9qyJa3h5deLOr44yvF0LxyVda3BtxT+5DPr9yPqq/2hs166hggsSgFW5HduT5zk5Zf8d4rmJ8F8Zn60hYGrFcG8fL
 n6uxdGoA
 rGW6OLV8JK0BKY6TlGUb/7qRnootE6J4JlUEn3cYPAfEJyX26YU8PQFeJFuFeekzolA3sIG2AW7apbjfqkTqqlRHDQqfk7kBydp3Hh76GOocnycK553u2t5v15FaKQQ4/GN/rInbM8hxwSoXSLAsLEimesNmJYIQcUkOsGAVbOn5HZjbNnBh1UUaaKYGTovIPVktRBELcPuNABR+vA53JyVDTQiiTai+opKzT9JOOgAJcoi4NhYv1RXR0xSuoLn0DiCILXqWHPKS8W2YAAUb7NTujlmMuTjk0FO24IGLmhcqDsb3SEreoHrZLow==
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

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
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
 include/linux/mmzone.h | 10 +++++++++
 mm/memory_hotplug.c    |  6 ++++--
 mm/sparse-vmemmap.c    | 47 ++++++++++++++----------------------------
 3 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 97147c764658..ebbda6f31139 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2149,11 +2149,21 @@ static inline int online_device_section(const struct mem_section *section)
 
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
index 02da1321197d..7b5b9ceec697 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -193,6 +193,8 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 		set_page_node(page, zone_to_nid(zone));
 		set_page_zone(page, zone_idx(zone));
 		prep_compound_tail(page, NULL, order);
+		if (zone_is_zone_device(zone))
+			__SetPageReserved(page);
 	}
 
 	page = virt_to_page(addr);
@@ -490,23 +492,6 @@ static bool __meminit reuse_compound_section(unsigned long start_pfn,
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
@@ -516,21 +501,18 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pte_t *pte;
 	int rc;
 	unsigned long flags = VMEMMAP_POPULATE_DAX;
+	struct page *page;
+	unsigned int order = pfn_to_section_compound_order(start_pfn);
 
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
 
@@ -546,12 +528,12 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
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
@@ -883,13 +865,14 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
+	ms = __nr_to_section(section_nr);
 	/*
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	page_init_poison(memmap, sizeof(struct page) * nr_pages);
+	if (!section_vmemmap_optimizable(ms))
+		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
-	ms = __nr_to_section(section_nr);
 	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
-- 
2.54.0


