Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC7C4EEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D4F6B0092; Sun,  5 Apr 2026 08:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F58B6B0093; Sun,  5 Apr 2026 08:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B5F6B0095; Sun,  5 Apr 2026 08:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F25C6B0092
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:53:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D11D9C3324
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:50 +0000 (UTC)
X-FDA: 84624494220.13.CEA4782
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id EA1D91C000E
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jPCpC3Yw;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqZiP5IDxjx5eZ19SJ749S5+pviMXDrT55UzwpoHOxo=;
	b=LlLNACXcGTdGLA3yRDYHaUxVJ7mXnefGitnMmXSxnSZIwUMVRlpzH+u08eqsn4UbKQp4D/
	iZA+oKe3hbLkkW3cunbeNqdtGzVsYus4fXp3+7aL9WQFkT/GcEYtm6/VbKc2/k+SuAGD0f
	yvJGrXLWWLNvuYGmOD39aQ41JL3yA70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393629; a=rsa-sha256;
	cv=none;
	b=55sNrNgZPMbgexNDTNn+shrUEeTVvUaYy3Ryxy6DgLE+XQEkCoaR5ncUgiGgZlSkX4Aib5
	AIvZRvG+N+C7/6mZfJx5yHSfJZGP7TUpaVd30XOMrgPArUqv2tITdBUAgzlYsBF1vUVRxV
	g2X10NFf5FHjPeiODfiRh+NvHrs/kck=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jPCpC3Yw;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35d9c7bf9a1so2804193a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393628; x=1775998428; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqZiP5IDxjx5eZ19SJ749S5+pviMXDrT55UzwpoHOxo=;
        b=jPCpC3YwR8tv4CyCAvsE4KibjH0fscTRmLwLkBov6dYynrXsRF/k9HQ0dQRsKBJnFH
         HAbL6TwCF4rtI7meXN0FGt67oDSU6Gml+4tn9rcNay9d6d2+M6Ze3X4Gdrf7qgzJMwf+
         xEhG2Qh5CShalb43GYXIwiKbQR9E/oRIqnaavFjuigUJW/dGA6PRFlCwJ6+dTfnFqi/O
         f56BpTTnrmCLZjQnRTJZOJX+t5GkyaZ4bPYmZPURBhPuHCtvKRVi77gXeG3oVwKQlksX
         pTQOV1giptqaEA+nCHVsWoM5lGlX+HusXL6dCylvIBK1TCVZxG1/KB1Q5H6HSpb/mhlY
         u/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393628; x=1775998428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qqZiP5IDxjx5eZ19SJ749S5+pviMXDrT55UzwpoHOxo=;
        b=W0yzK08gvfeMmfgG8RHxM8ybz2qU+T0+YuoryK/oH1ymEqM1D2rDIiLTvUCrSUZ3pT
         ez5fGLHazzGW+BvSlTnm/eVLJ9qbB8wb4Kan9snziX+YlClIAArijwdBSorv4wqbYWsr
         QSmkS3TxBqWsWfw207Wzn4lXo0Uo6BXfodOvaLx8m4DI7OuhVjRAsURMxaIJyDT0X54V
         fWQ3+37+a74NkiRX1N+MdrasV1Ds8Nz3fHGulYjmwjTzP1lRtGTUMUZb/pNmLF7NbTgY
         /+Gv2mZlnvW7P64LVThPpZ5EiHCq0Yc/ShSZEZw0Fak6815JD0vGqfz3dsYXKs7cAr+u
         dbSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtVGnj3+cH/UncNv3ErTWKj5N91LEXhQM3nSeyexvOsj+qdUD2+h3HQgNmC1NTdOulY2pvccXptw==@kvack.org
X-Gm-Message-State: AOJu0Yym4R/aLc40ddimPyBB0XGc3BoyzbGlFIPO3gB9s+yIdkkJqEmB
	letN/LmZVmQqnuwUwXiYMCdzbDpSU46CUxa2ZDMJMP5TqOu/XV+hDWLoGF1vdxXKdfg=
X-Gm-Gg: AeBDieuQeXsBjovC+A/20/eR5gd0xQdrpDP7v6qdU6gkWvWBpLNwGLqbh0zBWnquUFu
	ZJiihKBN1BRCIOuCZHtgTxpCfHzUcg29KCPMvn7Q/Z2AI4HLeGGkI/4T9J20XpFipGmbmoPGJgK
	XH1g00GR12MMCvH8S831FbHjNQSVAkdiNvQvT4In3KgXXdGt+v+i5G+RdfxxrKVB66laVFLSbP0
	hplSpHTSVt7HDD4UZMA6LHIMfWaRS76AeCjndWYjgnkkRWDaJI9cierSW1LLjGZurLs7TkWxd3O
	yhDsZ7cYZL3bmdNI5qFFQzUc0mqwv7SvVrTblqiEseh1Y7tc8jgg+z3ZIa06f9qYwhlhrIposkS
	4csj2OCPwPuHgCp9MRhXNihn+LXpcpX4Z4LFAqlRJHlXajj7vGSuTboRNhx/4l2Rb14wVE5E4z4
	UbyVEtU7yEjbL9/+gxenxqN3/kwmDN+/PgdD1OOIUW5U8=
X-Received: by 2002:a17:90b:1dcc:b0:35d:a3b4:2f00 with SMTP id 98e67ed59e1d1-35de6810254mr8790455a91.8.1775393627679;
        Sun, 05 Apr 2026 05:53:47 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:53:46 -0700 (PDT)
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
Subject: [PATCH 04/49] mm/sparse: add a @pgmap parameter to arch vmemmap_populate()
Date: Sun,  5 Apr 2026 20:51:55 +0800
Message-Id: <20260405125240.2558577-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: x7rokhc9q3b63zspuayjyfoa65oct3d7
X-Rspamd-Queue-Id: EA1D91C000E
X-Rspam-User: 
X-HE-Tag: 1775393628-701162
X-HE-Meta: U2FsdGVkX1+OjhObrcnD84dmCSf15dyfQSeQNjKaCO6b8l3XGVImIJXwnD9Plzml0keBVzyb2Gfa6LobJgVO6QmwdtQ1AJ2X+vknrZKir79ClGiZ80SKdA4/R4zH7Y1OzMJnvLtzR9DvOA/9mX3Uxf+FIXOxXhGX4Hq9T0MaxX6KdRxDfgBPUU4zAC6HE/H6Y2ubcN6YWOK7sXg5/Nc5jmaAebUajyADXidwAf7EUJJ2tfYPopZdDi9i12IlXykTfAye5Q9YA2BebLWPy/YFOnketR5D+hYi9pAxTSd/1hks8290Ia0XjICsOYuldwNtnsUP7KyR7yOWJb+6SD5vZMyLWhZ7tQSA5rHTZidIXsL4hVmJAwvLdbF2nyT3Fz4QuKpGGyWS0Dnl7HtOCtVdaDmC/n+vnXyxOqN+oQVE2wbK3Lm5Y2pOXV1LiFHl1pLzv3AiKWq3INCQ45CmUmPlMDY1O4nxGhXbJtUl2J+S+PC4lqqLtxbudJkXaPk0ZkhzRpZzVRWr0b1Erai9Wlebhl+PQhL9xEVzWT1YijV4Ch7HMnONtnYGC3QJItAqOJdwhwYhShZ9uZkPi7hnV8n0ia/5Y8ZRMlz1G98VoojkDrFDlCNK9Va5DiaQV3mYWtX1W62fn7h9DHRBifZ9stafmqAR/0aHAb3iq81fRuwdyoJNmeaOiFtl9wCJ2l/uTw10fQz+08pQDKyaaLjS9BuEzNgxB9RV0iln1kacGu7pP/0grjMpR50YmkSxRBYgarpuehHzJpcNDyJCDZdyiLdbS/rSmfAN3IRRR5Zeml4eIUXvX3d50YEUtXGiRctK8UCCy9CnbNZfObG0Vv/ERvzPjMVP1hVX6UUUCmyGBdRq2REx0OJ94aX3yfxldycM5MWFQyDhArthNfKiTKBuA4S0Uirz4A3UyUcgBrJTYFxdsUqXyLZYp1jdaaYSXamF0P6iAl3rFhQpWEOGzbeSN+R
 YBghV46L
 Lvt9x9Sj+2mg+yQtohesHeLcpRKFKfRgBqE37Bc5exNgIb/M/8elbxstQlr04K1k8k7X5y28LVSQ+1rDhLEN+rInVO9r0ds/7oRGlD7lJXO9Iw7DFEECrcZMOTbU0QDBjainHh+yS3CDEhJ7dN/stsdGiUEQe0PjEQlClFTyWRYshsjGnBu3VGjKwXxjGNqmjjr+ilHVnfemizgtb5mzGIPOJHw578dWP9GqD3v64VMBoYfw7yx5K1G77Fjpm+0QFZ2CJdK6lyf23Rf+i/Z97bpIpfqdCyocu9fWfpI5C8Lb40/gDuluvfQ4/Gp6Wm6yYI4GDsFHlifxJICAFt9fh5n8ZbyI3W0QKGmv6/tAmGSlDLPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the struct dev_pagemap pointer as a parameter to the architecture
specific vmemmap_populate(), vmemmap_populate_hugepages() and
vmemmap_populate_basepages() functions.

Currently, the vmemmap optimization for DAX is handled mostly in an
architecture-agnostic way via vmemmap_populate_compound_pages().
However, this approach skips crucial architecture-specific initialization
steps. For example, the x86 path must call sync_global_pgds() after
populating the vmemmap, which is currently being bypassed.

To fix this, we need to push the awareness of device memory optimization
(via the pgmap) down into the architecture-specific vmemmap_populate()
paths. This will allow each architecture to handle the optimization while
ensuring their specific initialization routines (like page directory
synchronization) are correctly invoked.

This is a preparatory patch only; it changes no behavior. The actual
architecture-specific implementations and fixes will follow.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/arm64/mm/mmu.c                        |  6 +++---
 arch/loongarch/mm/init.c                   |  7 ++++---
 arch/powerpc/include/asm/book3s/64/radix.h |  3 ++-
 arch/powerpc/mm/book3s64/radix_pgtable.c   |  2 +-
 arch/powerpc/mm/init_64.c                  |  4 ++--
 arch/riscv/mm/init.c                       |  4 ++--
 arch/s390/mm/vmem.c                        |  2 +-
 arch/sparc/mm/init_64.c                    |  5 +++--
 arch/x86/mm/init_64.c                      |  8 ++++----
 include/linux/mm.h                         |  8 +++++---
 mm/hugetlb_vmemmap.c                       |  4 ++--
 mm/sparse-vmemmap.c                        | 10 ++++++----
 12 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dc8a8281888c..86162aab5185 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1760,7 +1760,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
 	/* [start, end] should be within one section */
@@ -1768,9 +1768,9 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 
 	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES) ||
 	    (end - start < PAGES_PER_SECTION * sizeof(struct page)))
-		return vmemmap_populate_basepages(start, end, node, altmap);
+		return vmemmap_populate_basepages(start, end, node, altmap, pgmap);
 	else
-		return vmemmap_populate_hugepages(start, end, node, altmap);
+		return vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index c9c57f08fa2c..d61c2e09caae 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -123,12 +123,13 @@ int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
-			       int node, struct vmem_altmap *altmap)
+			       int node, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap)
 {
 #if CONFIG_PGTABLE_LEVELS == 2
-	return vmemmap_populate_basepages(start, end, node, NULL);
+	return vmemmap_populate_basepages(start, end, node, NULL, pgmap);
 #else
-	return vmemmap_populate_hugepages(start, end, node, NULL);
+	return vmemmap_populate_hugepages(start, end, node, NULL, pgmap);
 #endif
 }
 
diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..bde07c6f900f 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -321,7 +321,8 @@ extern int __meminit radix__vmemmap_create_mapping(unsigned long start,
 					     unsigned long page_size,
 					     unsigned long phys);
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end,
-				      int node, struct vmem_altmap *altmap);
+				      int node, struct vmem_altmap *altmap,
+				      struct dev_pagemap *pgmap);
 void __ref radix__vmemmap_free(unsigned long start, unsigned long end,
 			       struct vmem_altmap *altmap);
 extern void radix__vmemmap_remove_mapping(unsigned long start,
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 10aced261cff..568500343e5f 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1112,7 +1112,7 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
-				      struct vmem_altmap *altmap)
+				      struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	unsigned long addr;
 	unsigned long next;
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index b6f3ae03ca9e..8f4aa5b32186 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -275,12 +275,12 @@ static int __meminit __vmemmap_populate(unsigned long start, unsigned long end,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-			       struct vmem_altmap *altmap)
+			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 
 #ifdef CONFIG_PPC_BOOK3S_64
 	if (radix_enabled())
-		return radix__vmemmap_populate(start, end, node, altmap);
+		return radix__vmemmap_populate(start, end, node, altmap, pgmap);
 #endif
 
 	return __vmemmap_populate(start, end, node, altmap);
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 980f693e6b19..277c89661dff 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1443,7 +1443,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-			       struct vmem_altmap *altmap)
+			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	/*
 	 * Note that SPARSEMEM_VMEMMAP is only selected for rv64 and that we
@@ -1451,7 +1451,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	 * memory hotplug, we are not able to update all the page tables with
 	 * the new PMDs.
 	 */
-	return vmemmap_populate_hugepages(start, end, node, altmap);
+	return vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
 }
 #endif
 
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index eeadff45e0e1..a7bf8d3d5601 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -506,7 +506,7 @@ static void vmem_remove_range(unsigned long start, unsigned long size)
  * Add a backed mem_map array to the virtual mem_map array.
  */
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-			       struct vmem_altmap *altmap)
+			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	int ret;
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 367c269305e5..f870ca330f9e 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2591,9 +2591,10 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
-			       int node, struct vmem_altmap *altmap)
+			       int node, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap)
 {
-	return vmemmap_populate_hugepages(vstart, vend, node, NULL);
+	return vmemmap_populate_hugepages(vstart, vend, node, NULL, pgmap);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 77b889b71cf3..e18cc81a30b4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1557,7 +1557,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	int err;
 
@@ -1565,15 +1565,15 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	VM_BUG_ON(!PAGE_ALIGNED(end));
 
 	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
-		err = vmemmap_populate_basepages(start, end, node, NULL);
+		err = vmemmap_populate_basepages(start, end, node, NULL, pgmap);
 	else if (boot_cpu_has(X86_FEATURE_PSE))
-		err = vmemmap_populate_hugepages(start, end, node, altmap);
+		err = vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
 	else if (altmap) {
 		pr_err_once("%s: no cpu support for altmap allocations\n",
 				__func__);
 		err = -ENOMEM;
 	} else
-		err = vmemmap_populate_basepages(start, end, node, NULL);
+		err = vmemmap_populate_basepages(start, end, node, NULL, pgmap);
 	if (!err)
 		sync_global_pgds(start, end - 1);
 	return err;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0b776907152e..bebc5f892f81 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4877,11 +4877,13 @@ void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 int vmemmap_check_pmd(pmd_t *pmd, int node,
 		      unsigned long addr, unsigned long next);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
-			       int node, struct vmem_altmap *altmap);
+			       int node, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap);
 int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
-			       int node, struct vmem_altmap *altmap);
+			       int node, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
-		struct vmem_altmap *altmap);
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 int vmemmap_populate_hvo(unsigned long start, unsigned long end,
 			 unsigned int order, struct zone *zone,
 			 unsigned long headsize);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4a077d231d3a..50b7123f3bdd 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -829,7 +829,7 @@ void __init hugetlb_vmemmap_init_late(int nid)
 			 */
 			list_del(&m->list);
 
-			vmemmap_populate(start, end, nid, NULL);
+			vmemmap_populate(start, end, nid, NULL, NULL);
 			nr_mmap = end - start;
 			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
 
@@ -845,7 +845,7 @@ void __init hugetlb_vmemmap_init_late(int nid)
 		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
 					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
 			/* Fallback if HVO population fails */
-			vmemmap_populate(start, end, nid, NULL);
+			vmemmap_populate(start, end, nid, NULL, NULL);
 			nr_mmap = end - start;
 		} else {
 			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 0ef96b1afbcc..387337bba05e 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -297,7 +297,8 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 }
 
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
+					 int node, struct vmem_altmap *altmap,
+					 struct dev_pagemap *pgmap)
 {
 	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
 }
@@ -400,7 +401,8 @@ int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 }
 
 int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
+					 int node, struct vmem_altmap *altmap,
+					 struct dev_pagemap *pgmap)
 {
 	unsigned long addr;
 	unsigned long next;
@@ -445,7 +447,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			}
 		} else if (vmemmap_check_pmd(pmd, node, addr, next))
 			continue;
-		if (vmemmap_populate_basepages(addr, next, node, altmap))
+		if (vmemmap_populate_basepages(addr, next, node, altmap, pgmap))
 			return -ENOMEM;
 	}
 	return 0;
@@ -559,7 +561,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 	if (vmemmap_can_optimize(altmap, pgmap))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
-		r = vmemmap_populate(start, end, nid, altmap);
+		r = vmemmap_populate(start, end, nid, altmap, pgmap);
 
 	if (r < 0)
 		return NULL;
-- 
2.20.1


