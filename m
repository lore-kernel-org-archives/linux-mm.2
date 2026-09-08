Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB6CC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC81B6B00B9; Mon,  7 Sep 2026 23:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E756B00BB; Mon,  7 Sep 2026 23:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DAA6B00BC; Mon,  7 Sep 2026 23:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C42A6B00B9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1DAF31A0350
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:29 +0000 (UTC)
X-FDA: 85189101858.12.CE5D0F1
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 599AE1C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CxDnx3sI;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uEGgQCKJvggw1Narb1WaslYNRsxnnnRwg14YCHWkvvU=;
	b=oXuW//0X+j9NUDP5uuEClNyImJ+tORr3KqDrTEQto0pyL5HSDqweq0Lq6Q62jsMIiVq5y9
	eu+rTq8JT+1hGZDEDeR8NuebFjkcHliWRuK9jRKg6NhaGHxU4j77OpJ58YOMx/SFSp/AYN
	4ZEgc1ICAf781k0/mbdDD3B/5n9e1ZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836667;
	b=HyBQ/kq8qKp/QKbM2VQIzaQo+84mulnbjVqJqNcTG3OCsvRTpdRquPx1r77/tmUqXPD8Dm
	VWFHnInJYoMWwCQHUEczoRi6rJBFS/5mLYOMfw0k5UfqikEEwCR5pTHuYygrgXh9eQrJL8
	ErXSJ5yNFPT/UNAu6O1cE7c/ygjXomE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CxDnx3sI;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469e2254dso66655b3a.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836666; x=1789441466; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uEGgQCKJvggw1Narb1WaslYNRsxnnnRwg14YCHWkvvU=;
        b=CxDnx3sI/DIL3Ixa1VdBXAflnmkg03yVel5VggFrvQf9HgstKHoCx74hpIRC8QhJTk
         I4aWS+tNE7TaHBqz8YE0rd/WtXhSGM9Q4vysBHjGH/9sdhn+lwJ6TgTZY8gQ30caalum
         VcDqCY+qNwd5EkcRq5z8huDt+JjARaH+OGIcxBmBGo5qMkJMmwdm3w64pWQsQLgfre8P
         CVS4cl3ZkAAeZJz6sGX46Ssh/qF2kNFxUxVA81werhGYNSpoZWBX0XVVfXNrsvkDBhrO
         SOTOSDlffI5E6xE9SQtZ/4y4xihLEevbu41qjoagxOV26UrOHMsjZ1B09kW9HY6nyVPF
         gexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836666; x=1789441466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uEGgQCKJvggw1Narb1WaslYNRsxnnnRwg14YCHWkvvU=;
        b=D+39jnWvAOdTkEBajSPMgbjEH+mx4XyEgwaqJ/2Mf8zMUuvwIsq/VZLDj+cA/ar2+0
         lTMwZBMHaffOg56UslIagWIYijklNIUIDM7V9Zug/qjMgl07FHhfi10LuOoWDqX0pBSy
         C9lk5PYUedOG/fKCB3hKJtAQmvk61kEX6+bO+0VnDhFn/s7xP2THkXCGt5VgnxqqS0R9
         uLFJzU1H2f6xP04S/rb6cL3dupsgL1mZk2Rups+lKh4myU3Kj8nA/wGfiTYB6lyn9j/7
         NPE3UmLgobe3NFH27VJ1n6kNNjrnnTWrPQMqhfDUiIlR9Ig67bskS7tagcDuHpUqUi3b
         THVA==
X-Gm-Message-State: AFuF++k0+IJXxNH9ySC9LSSJPWwkKIJWPptWJ2k69GyXFMq04T1edVMt
	K4BM09O1/WB1vkWehNpLb+WgpI+I4FrmlD0G03h6LtQRZ8UR4DeTVoLpNIwX1zh9Yo0=
X-Gm-Gg: AYBFou2BG1J1CfrCFipM3229rz4/J34Pq081euMba79BkR2MkSIaFmb7MyPhk1m2Wa4
	9iRiMUUkoykJWn/B+xXra1ekw2Ey8Io1U37My0LA+ystIn2y37aTEmjUPlwPUQs9LOPgK8+R6B8
	hd9acViVWYpjuIHY4KvS5V2Qh2k3J+NhwOOT7bfbfVrCc/iWfZMLKeP5/MRMdgt5YJqx6l7nDTG
	2oXgklSaJfdyUIib7OBkMuybHQ1459jr3FUSNkshvMF4sVK2D8X076h62ebD9+Kn9FYv6UTZXD4
	pPhrd3ZvtMqNhqknOfDnp9QkDVZhlxk528DG2AxkpBudPlxL1NrAa9aY4SXc2cEn80pCWjTR8v4
	kVB+EGSPyiBV2aohiOGwlU/iPGlY3npws2K5N3vcJFOOdiLc/F2CPvQrcI9rjctkDUuTZR6TlcZ
	oxmshptn+CpevDF36eGR+Y3jq8kij7+4rWYl5KF1OCKYo6sN7gMANmFYrbHBqk5sQdQuMngD2gC
	oe7DZRjKv42tVo5d4qhNGU7tP+USTPox38=
X-Received: by 2002:a05:6a00:1d9a:b0:847:852f:c28a with SMTP id d2e1a72fcca58-86698ee5c1bmr4207907b3a.5.1788836666149;
        Mon, 07 Sep 2026 20:04:26 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.04.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:25 -0700 (PDT)
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
Subject: [PATCH v2 06/11] mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
Date: Tue,  8 Sep 2026 11:03:30 +0800
Message-ID: <20260908030335.96549-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g8h3h8juq9z6k7mcfybx5xgnpngyk3ow
X-Rspamd-Queue-Id: 599AE1C0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788836667-515735
X-HE-Meta: U2FsdGVkX19csz79povFj35oMIqQG0OIXxJhUzQNF+8Kyxq+QuJ4J3mOJBulx17GXYU49BvrmNwgX1R23BLZLYaGfNzJ6Sn7gMptdpVcOSpExLNa6UbUA/EBL+JbzqZJuOoBoGzdptQJmZ9RUWT1JFbEmepcauVvik/euNbOGf6OpYs31ZJZjbprG3x8KCJ7CHCQqOlJE+gdw1/g9FTWS/ry6445Jyw0BKQv++MQjwiSYjGOeK1tzhVusfzsH2wzsHxHchmdCRSyAaXfnToS0jrk9dCsjrU1SADKCeuNBNWLDGGmegxGcG8cskqeReBELFipTiYtKAJ/659cX4dolsdbcbUahCy1XAACHEKkA9mwduNajbIfsg/vEetlwJhjjn3FDJXUZPfJz8ENrdnPfKkWkDHgKMlXJRS02KB8AFhP0CbZcgzKalZRGLnx5cjlN9noIXOd2S14HGKgng9V0sL3GM2tyk7z3c6Z75OPiwGWg1zdFjJhXF32AoekXEh1ot01iA4Dn3K+GfbrY8yj7NJb9G2/DuS/Zc1duKbyHDG3JgEpediVlDA6Tq1rBNFgME+VE7+Wpfj3p66tRnTO5aEPXJLnx78yBkdV9CRtHbqW0GpFWkhx3rcBvaoIAorDRngobvPVTJ6tlC3DysjOHnD1ZeRtpvkEojiJ9fyHElceKjEUXBxtn/jMnxZmwaAWSSF7w7hCatsmVOLFJjQdVOrfc1k2/yaiNTP+uwwnLlOo8AyyebW19YrkN+3GgUh003bR0wC96fp5uazZhETbCd5eCER3Y1hvNFy3TfAzTePwiGhs/BYJxSLFiW0qGID1HKDnJ+fGONMPZs8rjcD6+9FvPXcZHJPoMFxsl1qP+hJ1snqqAwTh6U+QrawoxkJazGkdZ9lzmT2fwqYPmArEYotp+71uXhVyzk1jTc/uL0ZjlPDr3HII5CVp/lRXwr1vjxSJbr0CmzpVOc29zdF
 E+ef1K5i
 QUsAFc2AVm6N7LehVkBu/i9RAX/0nmMqlEqsaIm3jx4FinWC9HfWDoM6q8maUGl0Bc2lG09xAEiSxT+4Umpl59tNLijmDGiPkhq3AMVFrL98VK1wul6LPqLCyqhkH/a1Z2gUjnFsXVBB7TIWnN+cU6S3qvsp3OMgqILG2ycwY4ykzFMdokSXTOlyFOASwtkgW8pbeL7oKdXA+hOSsUmkOh2zZdECCHLOdQd93M39UpKP55jjz4FaMlafWYfxc2XgAPcfLzTsVCa+buNVSdemvavOt4n3lxD71Ik4yWCxVQFsOrqn29Bua/fiffg==
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
which is assigned when a DEV-DAX device is initialized. Unlike FS-DAX,
DEV-DAX does not modify tail struct pages, so sharing them is safe.

Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
initialize its entries with PG_reserved for device zones. Also skip
poisoning vmemmap-optimizable sections while their struct pages may be
shared.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Explain why sharing tail vmemmap pages is safe for DEV-DAX
  (suggested by Qi Zheng)
---
 include/linux/mmzone.h | 10 +++++++++
 mm/memory_hotplug.c    |  5 +++--
 mm/sparse-vmemmap.c    | 47 ++++++++++++++----------------------------
 3 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d3778ba976a5..03ed9232f186 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1686,11 +1686,21 @@ static inline bool zone_is_zone_device(const struct zone *zone)
 {
 	return zone_idx(zone) == ZONE_DEVICE;
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
+}
 #else
 static inline bool zone_is_zone_device(const struct zone *zone)
 {
 	return false;
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return NULL;
+}
 #endif
 
 /*
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b428da66d279..0db0379826df 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -554,8 +554,9 @@ void remove_pfn_range_from_zone(struct zone *zone,
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
index aed1e7429daa..0201877a7f80 100644
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
+	unsigned int order = pfn_to_section_order(start_pfn);
 
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


