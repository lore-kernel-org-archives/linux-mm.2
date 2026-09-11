Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE8AC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B066B0098; Fri, 11 Sep 2026 01:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632266B0099; Fri, 11 Sep 2026 01:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548526B009B; Fri, 11 Sep 2026 01:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35E466B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:04:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2189D806D6
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:59 +0000 (UTC)
X-FDA: 85200289398.27.2972FDA
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 638FE18000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Jn3yqWnA;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SoYJ7WMuU/pqlbOJzY7F/meqClQuD0NoJ+12TnNHPs=;
	b=pRNKYqCZ93ru1q0UIz3evuHp8a5EBzNPLutpPrWw7hZMcxylIm7jhP83TJMxPWuzapU8+N
	jTPecw5BmUy3ORSJbDI3HKS0hHQ2RGjniIftaFhDRTRDfzWzPCXyNE9CL3D/KZHsYFV7g2
	n6VMifFaSLBOzSZmtMvmWZQhEOnCRlM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Jn3yqWnA;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103037;
	b=uY0Yv/BNB/dxiuZ5mX8m55SLY4AJUzMawwnMwecOaV4/+EBSDwXWQ/qgqCJYI69epEZ2rT
	ydDpxcFVuLq1PNWhwhI2b137VgkH270Rmbd8pEyqbBR0YncYNnvozY/ERlXEv/KOOuB8ec
	cVssNMnFP8ncFS2joEu2iwz5NCKrzb4=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso482425a91.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103036; x=1789707836; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4SoYJ7WMuU/pqlbOJzY7F/meqClQuD0NoJ+12TnNHPs=;
        b=Jn3yqWnAWkHB6Jkudy+XOrcmE+ulFBcY6flqAKqiTjIwNz9qWLrX6ZcHpxhjSxEBQ9
         stuz9IxuSSrEuCh7kCX3YsUrp/jRB+ASXDKkvaELsNitcr57mNrRsqVcQVzvMSE3A/GM
         xh5Fq4FrOdQYvGSqcH1WUf1qH6bd0hTE1aybQkJJlEUlYgGV5IOgosFAIfQPKL67veui
         LtB41W4x0KYh3IkDC1teHjKLBHrdeGWYEf8sS5Vuy6rfREW61rEy2wEJf3Q/1d7BO5ix
         R2lCkSSJhzKJe8o+oKHZ6p15r8wd4p4aqalg/xH93M6PJhjP8/VMf6HMnQIukhVxyOJs
         fLHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103036; x=1789707836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4SoYJ7WMuU/pqlbOJzY7F/meqClQuD0NoJ+12TnNHPs=;
        b=FeX68D7AXnEHgQFdcp7EZHH1TsLd4ET9kvPUFudoRLYQ2GOK5JIOIbJtJRgMJXx2UH
         UmdmRlpwNh7V4RWy3wcnPjbhw/UHVbzuCminX9NNAcBqADPSYjI1LRJzBLG1obj9liB9
         3TWM5s4xFYP2QJdKJrJeQmlqiv2zKks2otS5/tQEE3GPsbFjK6fMufedsgk6XbE0PTYq
         u3xc+PvVln3Ybe+TumiCyxkRdShrU2zMIW05RzlTUwBs2GKtIETX5F6xVjWok4UU5gUk
         4A2PlNpHyxxHbr5QRGc4EbXO2zcyUinC0KBVOThHI0RrnHobLlByBNzCV11zPRaxaL20
         EDCw==
X-Gm-Message-State: AFuF++lljHygWlSp1sJEDQBTHuKRniAPrGvIso137tQOwVH12KAMPinV
	d76it3xNXY5sUjj1geMRvaa+yMUz28PYECLtCRGQ0VlP3P9O0llxiUczeswryS7rTgw=
X-Gm-Gg: AYBFou3tVzOoVcIuVlA7fctgCqGTyHxU2wnF6xBfGNysMSbksJt4NQuheOTPnDD2+y2
	89yPdkKLRbE1y0RZgp4s8vxcnYvj4homY2piXcsYXF25D84h1Mr+rRVK9G57UvYX67obRhIZHcE
	a6tDzoUecYwLyS6Ea8opy+gUtwZtnMSJx+BbzM+mZ62z3tdmrOkiu+PL4j9NO6JW9DsIMfH++CG
	anxcydPSvJaPJEgCNUn2+R1SH/kWQRso3HsHUL4p0iIU2FmF0dtxWLu0WsT69O8R5zFR+4maE9L
	aNm15os0YvItGWHczltKmP1C8VEAL5PTJ7S4s76Vn4WM+39G9ndmffJMot/axILaRopYsCPVR6C
	SWVYD58GbcQLEql3WCkGLYQTCN40Fgicze5wNGj997q4AAsqHSu3+yQzY4+VtwxXym/sr67TSs8
	HqQI5LPB9ZVVkKbHsUzrV2VPoNh2vGPVBndBOGaYuBm6zDFSYvowOtpTIrcd+lvVbhsOiKk26Ef
	VaxcX/mqDkx2c1GbYpbWUg1mZikLQTCP3Db
X-Received: by 2002:a17:90b:2b50:b0:380:21b7:e727 with SMTP id 98e67ed59e1d1-39d9c1c199dmr3979201a91.14.1789103036192;
        Thu, 10 Sep 2026 22:03:56 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.03.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:03:55 -0700 (PDT)
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
Subject: [PATCH v3 06/11] mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
Date: Fri, 11 Sep 2026 13:02:23 +0800
Message-ID: <20260911050228.58884-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 638FE18000D
X-Stat-Signature: ts7sf1mhh5kib51zzzbjm6zqz6am13cs
X-Rspam-User: 
X-HE-Tag: 1789103037-738682
X-HE-Meta: U2FsdGVkX1+/mXBkvLFzKVJq2L465VMEUeyD5KLydVGpCMhqK9m1N4mw/wfM4W9m5lE454LjqCkYP+HAlid1/v8r8EIKtljw/RDgFgyO+0ptlVFDEI/IQaxBDGLvlqMTmbbRvL+IwozvnLjCpnnxPRCTbl93oh1b7c4TYxk6eoPlx6uYTuaZybtGdST6oOuurCcq561X7baJ9WBtp98t0332waqZmm3Py5FtG+RJPrKf8m8oJZ8D5nGec8TOQ/mf4DZnhX1xpk3WxNpXjJBUQLMRmTlgOTt+kbQmj/t5jq7bvxJVAblgbBwAI1tfg5pU6dHFJKkgsolSNhZ/BIwAvJtmChDxisBMSZwvlvvoWJ4vqFw97h6gNLHXU74iBRspGJAlkleRMCrtt9b/TGz9IHGJLatbcZktP1DMSvZLPugntJ0oOOmuLfR4HQzRPvVBXSNp/k1WkKfxcnLD3se/N7fvdrXdYa/uvP0ZNxpligNC0ACBE6WAIyJaNCgddFuzotOtqoqnuHIfvA9Awp1WZk2LD/FJAN2NPRvq9WYUKjdldQW6PCF9nymSV6esAQBoX/f3r0QthHHJXAcWaxKMsT+gBWGk9buZ7W4aLsa0Oi77d8jGKQDtQ0LwsPuPtJSnvmIaaH/dS2m/gvEMVCnRHYypGcfohvCE45k/oNczs8vZTEKFkW6/xTE9ue9e4cbBXsh5Nw1X8SpnkIqu/PsAGBRNJ8VJTnFSqyJPrBEcm78ghu4gwFe5wqk3UiXCxvoQ0+OFrrMviXM5BJ5Fn8x/tUzfI3elUnRTV6CSe4QzwMdGSfXrg4BN/zqgrZKHOXj70zq8bWcjks8vfnZjSouEboollsE9hvUdlQUtq8qYkYrsco063yJunE9URnCnP84ZlvmBmNK17tUeL9rwfQsGHXyXaIFbKSSqxjxf9iVqnjsp1FKYeR1JPd8dkP2KVtsjZaLqNDfPWgqUFoB8DeH
 mLkqNyYf
 UL6PMVjKd7CITC7xuqpjEqgnL009As0DR4oyHEEbpd2ii3zXnmUZ+ll4c5eL/w0XWBzG5bdYg0kpgCRT6DssnzugKKlcoetGUV8gVzzSO+LNlZ2jjXizq8fc3gk+weq7vnWK5OP1tBzttrXj2+7OBfxsOUQ6O612MdSY4d1eKdsrHUBGqa2WfZdxaoBOjqO5sElUMn2fe+Fe5OIwcHKA+HUDb2qNavujMjl8+BpKUJWTShM6NqtBmIor4rdQHuKe4VtdsjmJmZJZ+ZWKB7RKg4awWDGjlz2SzXPoHwjUlMMm5qqucsSxSf8j2Xg==
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
index 1a18c1c40c8c..f8a2d823f7de 100644
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


