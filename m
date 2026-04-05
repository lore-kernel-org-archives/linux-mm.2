Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27EDDF3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904216B0093; Sun,  5 Apr 2026 08:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DB836B0095; Sun,  5 Apr 2026 08:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1DE6B0096; Sun,  5 Apr 2026 08:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7F46B0093
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:53:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C7FFBC87A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:57 +0000 (UTC)
X-FDA: 84624494514.09.BCE4D56
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3E182180004
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NAcoD8CY;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXznDGdcvbijOjbb/LymBNzIqLALuLwKxylcqGtnQjA=;
	b=Tu/uMRc0k1gju1IawpbCMrQVQl4GNcrZ90nJ0O8pZ8jFlClyhtHOZbxVlTwR8+PDgg/R3S
	8ikmBXFYbHh/obPO1NSfrqS0Ygf7Vu9H78WXgJoFpKGFvsTG+Ga3pvp7jfU9YR9R8h4Tt9
	JP7AXcY03zX7LUYcVx50kvME13dwdaQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NAcoD8CY;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393635; a=rsa-sha256;
	cv=none;
	b=8oV2Bh7XqUiJBY/cirq9qR52/i4qALjbvvEk3Ig8GggzFb0HIVTcltbbJUYncvAPFZcHhy
	tXuCTWh70KhnhtGm6+6yl6qrWIRpNZBT/PpLomPa1qvXutMc1XcxY34SwlOvv8h/Kj/F/N
	iWDyGMicgU9sveSIy1dcG455VYt50jI=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35d90833cacso1831908a91.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393634; x=1775998434; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXznDGdcvbijOjbb/LymBNzIqLALuLwKxylcqGtnQjA=;
        b=NAcoD8CYDHdG+5v2pAXiL+sqTRY0bnx3Xkn9FT8yCLejsOGebP3sD9ks7xtJ1KQlaW
         qm/HrQVSEHJliyJznACD8yYXqf1Cv94nG3RJFn7ajzZcFPM2g0xBSWRLzMeGjhqCIWvx
         o1gxzJALB94bItOWr9mHeDQ4uQAO+Zu1CJFcw8YkVmsSsgOzxBX1AOoLxwnUuOvvPPbA
         aiyGRqDobEtV+3C80IqCRGJ40FMtn6YO6Y21ttIO4Yjn2Wf4Lnn4ZwZaTrB/tTpFORVZ
         IxCXNnY1+DFxw31e1+GLAAdypKIkD4hjfD3/JO8DXEuRbhkJCe66rg/BdZpKTlsYTpC/
         Bnpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393634; x=1775998434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UXznDGdcvbijOjbb/LymBNzIqLALuLwKxylcqGtnQjA=;
        b=qZrL+7uFUQOQEaTL7rj3AwuxosAieNaMP3fEBpItJK6GJvGmtnBO4DmTPx8zYlFDot
         sbiJtcpqgr6soMERzy43jmxDRQdPe8FNL3vie+zUj2Ek4XtOC/jLOfFnEwSkCb4j3HwB
         7jrzxKCii6R9DezzGSlgHqUAo3ZHjSTHuDINbDWaMpTRMnxcT19hfTxJBOumWVBW8Gkn
         D0b7kpu2m0GaYqwkeURH88mbEyKCfAD2n/xl3lfFkNCBL5zNMaRassEe8G9pKO7A6TzZ
         hGU2kYdZP8R63wAXzVrTJju/abTFFvZo+uSUyfWwyvLHhu0CPK5ptoVkyyN1sTxFBcSN
         5KXA==
X-Forwarded-Encrypted: i=1; AJvYcCVaeI5z5BmAmG8jk3r0f9N0+8XE6UGYa1uAzt3DMVeFGkDrzkTM8DfN2Du10w/Cv8c/my4wA18+Sw==@kvack.org
X-Gm-Message-State: AOJu0Yyi5R4Vcuf2/IR2YY7+bf0x9nIMSrrd2x58vODkIMvSRdiG0q0f
	abh/8/rXW4DsLzbL91ghPvl69O8pu/yEl2ccwr6C8v2yeIgFIzmXxj5k+eUtmlU1N8Q=
X-Gm-Gg: AeBDievTtotHOiXnPLZaHNc/TB+LRclEkubLPJkfbcdFBA4BFBh/vhX95CeRE76fFdu
	hLhm/VWkxbepIZBJumc/ojkwfUA11zg3BNAkgfKeMP77rzWICHC6r9fSo5lM4xCONItEfS04AgI
	hKQLmyQOl0c+tfILYt06NKiW18J4rGu5vdfrerGjqyocFUnQTkHnF0Egry5K+50WTFHGsX3kduJ
	Eve3x42kf9CIj4AvgQQVVXceGPA8c1HNc/5Ek8FUDwreNZAt7CnjOv2MIQel4uSyaYp5hnOh5Sz
	SsX90YO+rGJkFrVteGS/gwEUpfIFWNu0SZ/9g6CTpyVJyjPKrYJrlb4rCfIOtP6OdfFshQNrSAM
	s4RCBSMsrVG3SnUJwe+17E4qfP30Y+yIhx/j2k8x7wKgKlC37+mSEawzBzvPP0yzml3WzLu7ET+
	0lWV5jnDKYHOVOK5y2Dfw0ZPTGBznRfqGsOENfrej5lzrkjlv0ZvmwAg==
X-Received: by 2002:a17:90a:e70f:b0:35b:e52a:6fe5 with SMTP id 98e67ed59e1d1-35de683b19amr9190466a91.5.1775393634044;
        Sun, 05 Apr 2026 05:53:54 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:53:53 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 05/49] mm/sparse: fix missing architecture-specific page table sync for HVO DAX
Date: Sun,  5 Apr 2026 20:51:56 +0800
Message-Id: <20260405125240.2558577-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4pka6gn5t9gpfum58epbj565qn8xmdb1
X-Rspamd-Queue-Id: 3E182180004
X-Rspamd-Server: rspam09
X-HE-Tag: 1775393635-328543
X-HE-Meta: U2FsdGVkX1+kwrsV2O5K0zVlpitSbPXCGANkIRkIxrook+gOVA+qy04UH7Tfbq+ZgxsYOgTlV0OaNBhjCeQfRZ6jL1CEnjlFx8AIs1sL2sNAT6nDKFjbBxu3lbXUaLtcFejugtnzju3BzLpjklNL7vx/epMqfKNO51XFiaowXEMS1Vx5w4b8bb4n9Kc0GlQfOJP09gkYzzS59BYUMKxc+lA7Yj4U9mdmddYz1CAjKWAQ171mpjQSdg6DvCPpe5hwUAVDnzM8EO46k51oed+rY5YEE0abciEhk4zB59bOOagp6TxFsNlUf5IdOe444C5NuzjcZIT71fces9H6O8sOqO89RpA1JIKRGlnSHiumtZx2TW5baWzVPniuLRZcyiUfiGHRZZcMV4uVslb6EXUG0/nIH3x1gqWNdP7+smtbQdGy2unU/0LeKHVq0+kmCKYYcVRbst4v0GXntg234boJR6gN92qMKkf65Q4aP1CiH4QbpBeKtDDqC2g8BoxHhl4KTIrv7vR1QmmRax6liKWbHitPZilIDRgNHrse4rbGx0MRMtCZsPaVm3AkvA+NfzlRFURVskmwjzc7sgPQG8CO7+wBg2kdv0JDXFdGZRhsaw0xbTm4pZ2oDgkNB/M4i89cGBV9EXk388b+ODvruMEiDELJTVQ3unrjvSkZDZxyLv1dEfauAu5DOqEhvZOylon1jnYjMERyX6Fn/iRrxMPqXxk7TRpPb2PgziYOnfo8RBz0/VVPSuuX34YtyqaeAuvMaiFunYZyu7cpI/mOh/FnznrJ0qdu9QGHkfMEW5mhw0Crh6a8BuWIOWTIQHy0M+zOy9nowxQAxX6566Miy4zc1jKIB9/mEMDH8jyFrAZ4bgpot4GAGZjgLNj4/7b2seuoTtK7VxtgLG7TtR8ePa1EHb8G/yNmTwkBZfWp9g2FEWcIQhJ2OLFczFjMssOF2wIHIcSvU5NMF7Ac0JiF1JG
 sW8VRTtj
 NP8j64Kh1GLJywzOFYlZI28yxSsiZ86cdxlIRb7ZyBU27boi2pwS3P6Ou0JmZNV66sd8oBHjxa/YmUDixZagX9jBeHVEG9XA0gOlcZfHvjvIVlmeYPMtYfE7VP82md5oG1uBDu5Y1gSxM9FQ13atRUAnY1xAcDxzIx83PQKAxuiwJRH/ust4QTuJrL1f9y5wVrp+sYcIc9wqiWsZjdiJQPcItiv8CaHNNCR7k2Witz1ZGW+KCMgy+usZvl0+cqsLPo81LLnOySfgghOtdofQys7kzqcT2pqmYOeUWci0Spe5imuquxPapeiyG3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On x86-64, vmemmap_populate() normally calls sync_global_pgds() to
keep the page tables in sync; however, when DAX HVO is enabled,
vmemmap_populate_compound_pages() skips this architecture-specific
step, so omitting the sync on x86-64 can later trigger vmemmap-access
faults.

Fix this by delegating the HVO DAX decision to the architecture:

- Architectures that do not use the generic vmemmap_populate_basepages()
  or vmemmap_populate_hugepages() paths (e.g. powerpc) can implement
  HVO DAX directly in their own vmemmap_populate().

- Architectures that rely on the generic helpers implicitly inherit
  the correct operation logic and therefore enable HVO DAX safely
  without extra work in generic vmemmap_populate_basepages() or
  vmemmap_populate_hugepages().

This prevents the x86-64 sync issue.

Fixes: 4917f55b4ef9 ("mm/sparse-vmemmap: improve memory savings for compound devmaps")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/include/asm/book3s/64/radix.h |  6 ------
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 15 +++++++++-----
 mm/sparse-vmemmap.c                        | 24 +++++++++++-----------
 3 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index bde07c6f900f..2600defa2dc2 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -357,11 +357,5 @@ int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #define vmemmap_can_optimize vmemmap_can_optimize
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #endif
-
-#define vmemmap_populate_compound_pages vmemmap_populate_compound_pages
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap);
 #endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 568500343e5f..dfa2f7dc7e15 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1109,7 +1109,10 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 	return pte_offset_kernel(pmdp, address);
 }
 
-
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						    unsigned long start,
+						    unsigned long end, int node,
+						    struct dev_pagemap *pgmap);
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
 				      struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
@@ -1122,6 +1125,8 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	pmd_t *pmd;
 	pte_t *pte;
 
+	if (vmemmap_can_optimize(altmap, pgmap))
+		return vmemmap_populate_compound_pages(page_to_pfn((struct page *)start), start, end, node, pgmap);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
@@ -1303,10 +1308,10 @@ static pte_t * __meminit vmemmap_compound_tail_page(unsigned long addr,
 	return pte;
 }
 
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap)
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap)
 {
 	/*
 	 * we want to map things as base page size mapping so that
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 387337bba05e..d3096de04cc6 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -296,10 +296,16 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 	return 0;
 }
 
+static int __meminit vmemmap_populate_compound_pages(unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap);
+
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap,
 					 struct dev_pagemap *pgmap)
 {
+	if (vmemmap_can_optimize(altmap, pgmap))
+		return vmemmap_populate_compound_pages(start, end, node, pgmap);
 	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
 }
 
@@ -411,6 +417,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	pud_t *pud;
 	pmd_t *pmd;
 
+	if (vmemmap_can_optimize(altmap, pgmap))
+		return vmemmap_populate_compound_pages(start, end, node, pgmap);
+
 	for (addr = start; addr < end; addr = next) {
 		next = pmd_addr_end(addr, end);
 
@@ -453,7 +462,6 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	return 0;
 }
 
-#ifndef vmemmap_populate_compound_pages
 /*
  * For compound pages bigger than section size (e.g. x86 1G compound
  * pages with 2M subsection size) fill the rest of sections as tail
@@ -491,14 +499,14 @@ static pte_t * __meminit compound_section_tail_page(unsigned long addr)
 	return pte;
 }
 
-static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-						     unsigned long start,
+static int __meminit vmemmap_populate_compound_pages(unsigned long start,
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
 {
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
+	unsigned long start_pfn = page_to_pfn((struct page *)start);
 
 	if (reuse_compound_section(start_pfn, pgmap)) {
 		pte = compound_section_tail_page(start);
@@ -544,26 +552,18 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	return 0;
 }
 
-#endif
-
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
-	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_can_optimize(altmap, pgmap))
-		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
-	else
-		r = vmemmap_populate(start, end, nid, altmap, pgmap);
-
-	if (r < 0)
+	if (vmemmap_populate(start, end, nid, altmap, pgmap))
 		return NULL;
 
 	return pfn_to_page(pfn);
-- 
2.20.1


