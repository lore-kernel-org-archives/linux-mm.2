Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A17DCC98328
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C3F6B0096; Sat, 26 Sep 2026 22:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC776B0098; Sat, 26 Sep 2026 22:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312E46B0099; Sat, 26 Sep 2026 22:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0342F6B0096
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A696A076A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:18 +0000 (UTC)
X-FDA: 85258025916.02.F28A0DD
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf22.hostedemail.com (Postfix) with ESMTP id BB355C0002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Rse/kR/I";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477716;
	b=oxWoeLUrTLSEDini5CNYB98OEHdDRu8s9YjhZAuYbFaL032GCFrfzHOoCKDo0q/P7Bmm6y
	+O8+vsL9iBfcWHQwVrtDJ2609i6PfH97mmaUKFybtNlKoIiOGtWZTixYC6BAE8MGFjr3rI
	0twfe2eYlbUF/vMYCF3fSPhxX6T28TM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Rse/kR/I";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUj4I6qYRPvWCdYjNQvAZHgpJ85hBpDlWBdY9AxEym4=;
	b=5de8qUF2hGxOS1XThGbs7HKWVYsFJx0OTFe3lTooGKzk1O36FxY0ZT7dvKyr/KSBQBDkGw
	kWP6ZIHBxQiod2WIGFN2QGIAV/uJaM74/8TdpmMMwlgKVGcJG6EZeFUlZdLDZJhMZM8I75
	+6k/bSkAVeeAS5HTXMQS51Tx9wdeVhU=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so1039622a91.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477716; x=1791082516; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LUj4I6qYRPvWCdYjNQvAZHgpJ85hBpDlWBdY9AxEym4=;
        b=Rse/kR/IxUZzxqE4xj9hY/H4Lb7T2Eg+WMWgwTjimxo7YxIw5yH5zC850TAIHZrBiU
         bgHT+Jyt+tehb5VR3UVNMoIhQOOj/1HBDiz9TgPv7n6ayRXE1xmjPCRa4sb5ZzCV9dxO
         dz0gyqf+HKSbh9pX111FOHPsktoXj2yFiHg9+knWCcq8EEp8IPIVJjwQfBeVlIn2/fsI
         EklD2uSbcpXoqR0yjqj1oxKQR5Bnz7ymBB0jLte2MgN7RpehzZ7bMKQsOEOplBmQmk7S
         R02KLkHMYsB2B+DIP0ceJSLDPplgeSdF6/iTj/I+8YLtWwnO0xWI/ms8jMcuUtSmPDv8
         dwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477716; x=1791082516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LUj4I6qYRPvWCdYjNQvAZHgpJ85hBpDlWBdY9AxEym4=;
        b=APmJz8rV2P0elCQw3nOxTqvJLZen9hA+upRRxNdNhRtQoWBewRyUUnLZ9mXu6Dyggg
         mtBaerqWdy7qwHdjkCgpBHA8SPluHrZWl7tXHMw6K41zLYmJXPGHuhfyp+28nkBNUJ0M
         pnmuDVZSRPZ9RD5MY3w7R4WfG9pgPfKDCKITF2JYK1U9QlRGAAAam9ywSL7PxTZxEcxY
         /8iMHCIA+enUREjdziLuywPrrYDnlEDqaWiplLvDBhbnBvyHkLLK+rKcNFW5P7T8OWf3
         A1pqlYG1b0ROCq0z0BAv0oO7284qwRaDae6LGqZdHDJvpQ6036q5eh8iGkKpZd+SeJaR
         7Ogw==
X-Gm-Message-State: AFq9FYIrLouAEx8y965R3RyLubaDQmZTT9WHUwP0l/oupMg76UpockRr
	h7juB3FQJHLvQkcGsRceqe/EH70csx5tUDGIw+vlE1jeSR/RYReS8BCauuhJzoTsFeQ=
X-Gm-Gg: AYBFou3KtZIjGSR3YN0bIf+f8YoHlRJTsuulHP52QOoH+Ym/GfW0WB/UadhX8rlLnAq
	nta78EzUVN3TSSaIc1wjFUXR9bCYgKTIpooBo178YIpFR8/OTIgqYp+RdDZRWuVZtr8dIxdXOUW
	wifKIJkBCowru5a8ibelYqhc+8r1LtJgqtCuAXrcNYWxwVt3c9muyL8hNPR0xnPGGb6pVq7/Xp3
	vCd73uuB+jlIPH2Od8JAYnKigd71xo+z5Fu0ughP+ba3+hpCAIt49HNgMyxJuQNdUFP8NnZKoUI
	FyGYlgSRThp0l34S18vWT6LgIq5BO4kHmSDwEkFhVgBOhLMLwBn7ZrhQSIDaEW7T9L1jPIc71an
	KnIryNBqslXSvtQ4YnO3zVJNrdATrV3HH3Qr+OFfEpCpDGC25bbbrsfCWgjdYm9Bt71i8STtFMp
	AObHQU4K+EiUNPXunORxiX9C6xVMHd/QQoi06bDRAlnBljBEe/O8eBd7eTklQUcQ64Ne9mohSV4
	O/MRCB4QNwNZUJSf5bBog==
X-Received: by 2002:a17:90b:3888:b0:3a0:cc33:2287 with SMTP id 98e67ed59e1d1-3a0cc3324ccmr4179593a91.6.1790477715477;
        Sat, 26 Sep 2026 19:55:15 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:15 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 05/12] mm/sparse-vmemmap: prepare DAX vmemmap population for compound page orders
Date: Sun, 27 Sep 2026 10:54:34 +0800
Message-ID: <20260927025441.741633-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 8yk8jiq8e83ntfk7zy8g7zxabnf4xz1z
X-Rspam-User: 
X-Rspamd-Queue-Id: BB355C0002
X-HE-Tag: 1790477716-951637
X-HE-Meta: U2FsdGVkX18604S1cmzKRCzKG2uXAzSUAaZOGf5L6Naeoxb1zvxuVUuf1gqtwkVdWVsOjde/fC3vUeZZKV/O3b4ua99i/aK88ljVVmilAnjSOVGL9fwdfyfV3//EUsdYEBlDhIuND0yuinTZq0Pm5fEMLyUz7MsUdPI7C+CISwrIGPcIQ64CE3ZwC6rBz7EG9/tU9RIL+yseV4I9BE+HsE58yRpFtiMHPk+DA8jrdSQadmcVTJOHDmMC26IDcB8xKQu3v1Wg0+LM1phkxMZ9agBcD8EEE8aRhvUkx37miNy/RUy6hGjZqTF7Ba1rQNh4teyZceIHp91zIchEwGKQRweX2i28WP9QM0GoXjqA0JHcHJGlXDnyD/GccxGno4Ad2ObO3FlrdlcZaoVYS4P2rvlJpnDOtx4kXeaduhUwTqrtg+gb73sH42kF4+Xh/zqazvOndiT1JYshu/fikiV2Btjo3PvJr/t2Ow16jB8uiz+dE+5e0wAXrBXzHoL0eFhyU+g8vyU0sruhKFenBjUZZRG+B6H/FuLNS/bP6t0LsT6Mom8BuS5VP8No4YVroOPq6opV/KpoW0tyJYqYhK6dqpZE0BT7mst5IA8e+O1cX1nyUJeuw6fRNHHSGow+EBVP5LrRaQDDkG62/5rQMgraSNYb70KPIRaHFZqgjN2I/oVtIbV0rlRmqouM11tkjrUhQ9PLXxLDAcRphItLi46XQV3m43ySoqxmA8+aEkHfJ6//oshnlX58/ytgdTJEJFQp9NwoKV9vZcqe7qUaUXHqfU4T5vy2p6lrTsFp1g8W/2W7Qr+9ibMpJz+e8K0ScgsbfRiaK2NaE5hhbQyafOoA1/HChPbpFXFzCnRdhZ5OqjnGFYiozLmP/J/WjtzCHZpr19bijqklnQa11wWseP3OR0U+N0WhiKWS8UPDN/UEqcybA91zd17SCLikmJZ1X5aXbyccJ1DFQUxUVUayCul
 N0XPyojc
 j/2JTi4ola1aKN/V0Bpp/PPY9krOMmahI9Jkz+8L+CF0mw50lS7q9O7Qmbmt2lE1y5D+PHh57OKGTpWzw97BTdbmfP8BlJQ+SvbbKZJ2k8Ip9bWcQJCCABMGELMqsZ8UEbbpmKWcfN1OOM4dqUpvBbyRK4R1R8K9jB4WCg+bLt0OAWnaOCPLQDUeFLfR3NO1cuL6+mueurygwiNRA/0/MOL7fwYsjQSilT10pLLgZVl7aN6otfgd/ajzHJE284ADjwZ/ckez7XPWLGUvuqmCfbB3Ag4MWj/VCq/7rxqJgL8GLJcMr+uVxxNLqhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device DAX still uses vmemmap_populate_compound_pages() to populate its
compound-page vmemmap mappings. That helper allocates the head and first
tail vmemmap pages explicitly, then reuses the first tail page for the
remaining tail page mappings.

Device DAX is being moved to the section-based vmemmap optimization
infrastructure, but it cannot switch to the generic section-based
population path yet. Once a later patch records the DAX compound page
order in section metadata, DAX head and first-tail PFNs can look
optimizable to the generic helpers as well.

Add a DAX-specific population flag for this transition. It keeps DAX
head/first-tail allocations on the normal vmemmap allocation path, while
preserving the existing page reference for reused DAX tail mappings.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Update the subject and commit message to use compound page order
  terminology

v2:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e4dae98ba7f8..2457ea2c6dca 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -35,8 +35,8 @@
 /*
  * Flags for vmemmap_populate_range and friends.
  */
-/* Get a ref on the head page struct page, for ZONE_DEVICE compound pages */
-#define VMEMMAP_POPULATE_PAGEREF	0x0001
+/* Vmemmap population for ZONE_DEVICE compound pages */
+#define VMEMMAP_POPULATE_DAX		0x0001
 
 #include "internal.h"
 #include "mm_init.h"
@@ -243,13 +243,17 @@ static inline struct page *vmemmap_shared_tail_page(unsigned int order,
 #endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-					 struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, unsigned long flags)
 {
 	struct zone *zone;
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	if (!vmemmap_optimizable_pfn(pfn))
+	/*
+	 * Device DAX still relies on vmemmap_populate_compound_pages() for
+	 * head/first-tail allocation and tail-page reuse.
+	 */
+	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
@@ -271,7 +275,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
 
 			if (!p)
 				return NULL;
@@ -286,7 +290,7 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_PAGEREF)
+			if (flags & VMEMMAP_POPULATE_DAX)
 				get_page(pfn_to_page(ptpfn));
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
@@ -546,6 +550,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
+	unsigned long flags = VMEMMAP_POPULATE_DAX;
 
 	if (reuse_compound_section(start_pfn, pgmap)) {
 		pte = compound_section_tail_page(start);
@@ -557,8 +562,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 * with just tail struct pages.
 		 */
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)),
-					      VMEMMAP_POPULATE_PAGEREF);
+					      pte_pfn(ptep_get(pte)), flags);
 	}
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
@@ -566,13 +570,13 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		unsigned long next, last = addr + size;
 
 		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(addr, node, NULL, -1, flags);
 		if (!pte)
 			return -ENOMEM;
 
 		/* Populate the tail pages vmemmap page */
 		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
 		if (!pte)
 			return -ENOMEM;
 
@@ -582,8 +586,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)),
-					    VMEMMAP_POPULATE_PAGEREF);
+					    pte_pfn(ptep_get(pte)), flags);
 		if (rc)
 			return -ENOMEM;
 	}
-- 
2.54.0


