Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECADAF94CDC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CCD6B008C; Wed, 22 Apr 2026 04:14:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BDAB6B0092; Wed, 22 Apr 2026 04:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ABF06B0093; Wed, 22 Apr 2026 04:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37F3A6B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:14:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3CB38CBBD
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:14:58 +0000 (UTC)
X-FDA: 84685481076.26.6A00392
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id C6C1C180010
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:14:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LdP1UzRF;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776845696; a=rsa-sha256;
	cv=none;
	b=rp45j20Yb/EcUPZRii7aHNFwo4hh9HJeS2Hvhumui/fWnoRDM9fPnx2doxJMt2gta5yKmo
	JBtghqRvXNXLq/1j2AJBTLCmC/54cIFiVBX4KTea4jZ23TNnYhKEdJkkQVdK3NDfiOJiCQ
	jy3vdHFJltJ18g+CLE5miuolwUuYlfY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LdP1UzRF;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776845696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9jQcBqjOBMyMvaKc/0bmbd5llByfHuxAmeKteQfaMc=;
	b=a45jUUDrAWiuLWAoE3GllK8VMciF9yJJKsB9RJr7eWrOsdUjKlJktIhORbcmPzZOFYtR7g
	mtIGSHMt1U0lyxATr6HkcCoyaGTBDzWEGqEVhlnFtF/NtYCYXGiKR7C0qED1TAFhgdjR9I
	t2twQP25iY6VvNNcCgTVdsgVkpfxVok=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82f351ca23cso2578855b3a.2
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776845696; x=1777450496; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N9jQcBqjOBMyMvaKc/0bmbd5llByfHuxAmeKteQfaMc=;
        b=LdP1UzRF3mlXX4KjNnyqzkVFrvMr3w5anaqZrR0xnVbu2CHUl+ZOwf8ugKlVHE2DAk
         Ia7kBjVocMuedyrbYGYBdG4XnkumfAzz4QUQMWlOpNTZqbt8iDisZHWJO80FhyeW8X5Z
         u96uNa1883fcvVo6WpJd+yOQ2ZbOy43JNNgPhcNpn1iUNITfCgSnPDlmlp9f6TSEt6g4
         0z3LpLqMa5/AZFeMxemQxpv1zIfue3R0ewZ24MCzQW12y6wJti/yy2PPFUWI+ZTl4rT9
         PU+Mk+2B23Aj8fUhqWGMLAUlM++PeXWMlWF2W6Tw4iYP4apD7J3wZBltUMRgsxQL0EV8
         yCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776845696; x=1777450496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N9jQcBqjOBMyMvaKc/0bmbd5llByfHuxAmeKteQfaMc=;
        b=X3UJX+1APDepqofegqV+BlnMr8+J4k7EguViKppc2yRlGv/K9Ofn/DHSMz3/eebQVq
         n4kCASOgGBw9BWlf/URCTLzH5tUgI80JW0XYkROQnKg9tuXsjht2uOwMdMgdqXD3AiEw
         ljT78AzwDMx8z+14CKoSWtT1Geb7l8JWz1o7Wr5nTxq8ZPwYcg445LV6a7diHGSIYYl3
         2bxiP81HC4E2g7T3wvF42T7oLG889tPR6j50FrsTj7ycD1cwYE9dfvyNpoisMbzxkiZM
         CESbnpnm/drMmVZp3TQb59K/O4baU84tyLzS9uxJgjIVY+FDsojgX75AVVMB0Gfgubjb
         K/EQ==
X-Forwarded-Encrypted: i=1; AFNElJ+JJN9zSRp5Gp37HG9EvvymSBZ/3xz7f1X6yNUOR3UyKumU62fY88zUhoKIZg37qQECCLQRY4FVjQ==@kvack.org
X-Gm-Message-State: AOJu0YzB2wil+Q8MU9PeUdr7bEPNJbE6Y1ulNXN9cC4NgIVWx7MYBBil
	vKkZ0HDvS9rFHp7UeYRAt2v5/DN+AsMOcV/1lMn65O8j8ID26I5IkNnHf+Lmhlls78Y=
X-Gm-Gg: AeBDieuFmtWlkHDmyfVCU036Igm4sPFq8s7LnEpmvgMMGWn/d1YqAeiet8vugjceiQZ
	MHBsVOwRRpW0UJ4buhuQCEyfb5KgV5HZxtqambC7bR+i+JlTAdtWdzmtQRMAv7gRCaM3CztadtU
	NQMHPRu3WW1j9gdYbG4dirWinL8dZyOTJ5xkH/aqdcBlh8b4Wzjy0lRKGBGXNbY0FPpD3IkvfeE
	+4SCmI1wEwWEKBtIBkHXYqtIF7WGLEW0upA0MvFr/a+oDs4nelDWzUil/Og3EVXWFeoBLR7ovoV
	qhR/jBXga8DkNeagAW4QfIAzMb2FyQhJhqMy9mVQErdZV7y2GLWtel2D88/7Sn6g3CqV0csXUrL
	OHaIPzbl0DJugc3h2HIvBTkxCSGRi87J9v6Rq9U+uuvjlpwssAQjvmgr5tdpywMl2VLZyn2cihC
	WM4rNyQPNdtgSP05IR55zbljUBrZTlTUCgFf35uDI=
X-Received: by 2002:a05:6a00:2d1f:b0:82f:bd8:70eb with SMTP id d2e1a72fcca58-82f8c876febmr21354185b3a.21.1776845695323;
        Wed, 22 Apr 2026 01:14:55 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec0307esm16522874b3a.53.2026.04.22.01.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:14:54 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/5] mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
Date: Wed, 22 Apr 2026 16:14:17 +0800
Message-Id: <20260422081420.4009847-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260422081420.4009847-1-songmuchun@bytedance.com>
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: iijmy5pu8r9j86ut5dmxoqyrm7r4noik
X-Rspam-User: 
X-Rspamd-Queue-Id: C6C1C180010
X-HE-Tag: 1776845696-866646
X-HE-Meta: U2FsdGVkX1+fdmxDTaMFVO2DSojLzSG0sVRUStyQvbUJ2C91DEF9bC9jc0Nx6fjiYsshShR+6CjfDLtcAJFXyBEIyRqNRmzVNpNgr96BVWRGW+sBfXlGOYGHyVAO1qWqeffrUV3Z2G0GHmcF2zvX8O/xKh6pMriQ+wD/UlGVGfVs2GiHrDuW1hT2ouEhorbmesqpP6O8PwvRyV84VUWHdq/rvuRL280Tc5lN896xbKj6ixyKsbIZPzkHGk4jhYqN9MxBc7Y9dO2XQADDaYQPkLiHDhsm0s3ec7XIDgAmC36Escb111bn0Z0xpsEsnTDg/kv8XirkJ1T60a9VvAfJFxYobBa9HhYama14NL/7rUuNOQImtfdsOP4UZsWqaLsYa+H/UsDT/uaQtNluKyM75AD+/5fWH6gU4/TufWHhbnEu+8jGsWyX7YFUwVY7Y87PfzCvmWLMPiHJD+N8sVhkchD4ldoCyluSeH3jsedWNPGgOS4vaF8uSsy3Bhfy/IfdDn+gg5HbNfSJJIvon3Kms/o96IS/G0z/GXBsoG3RoEC5la3c6IiA+jc9CKFyiFC67ODaE+fRGCG7LhKWlVtmMICU73z/FEHQV4UMvBuF/vRUPHBD0PypL3yz6b7H0hiLNkiwODPyk9orvyt6B6epwN9uRkdSnTXqkXtEo6Uz0yQTiDzB3B+4tLMPXQ8ckJB2Yo0W/5bl79ja9YLlayk1FsRiS1PjYxYrWHpJkNiPyeBAhao0vSOWOMCauvnIbFjyokMQJoTUrm/Z9Ya+PenW60uro+RdLWgwY4DowgGKS4KGHrtV+pTM7l8arEp/JuXf+eI2KrHLD346vbyAW1oWlPwfaTjjt7iCBqM7AvomXicgklrg8apX9WwbHVZ1lFy9+lIred8B5EFB+aJeBFOcYed0tqZS1WPL3lUKmvkY2Z/DrTKDouAk52sRnv6CuT6Pcr/lvIGdguk2gQKFvkm
 /IhWVKHT
 WE0fwHlbQVCb4TDet812uSL+oecgpvh2WPZBNkC8lkhAe40Ta19KdGLU/USR4MYaAFRCn8mElVythVhqYEsK8dboLfjTPgtpLUDLLX18zm3KFNKDRnMTK2zuz+UJim0GKcA7zxid2SAs4iJh6OAcfdrNDO55mJ3JiS9Pg60JhNoFq9HeZRG6JWUQ9wLX0pFzvZxUnasgWvVHpORwXioEWilcXygyK5uwsf/H5lsXqUfu6mR4+mwZLbn3VtnsOiW/iX3CK2KK1bD9vrhOrymUD5fi7JZO98Ice/+7ULHRGegP1Edrp7gBpfveAqkAR6Ip6Dl464RxJmdyaz/hOVMizBjHLJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the memory hot-remove call chain -- arch_remove_memory(),
__remove_pages(), sparse_remove_section() and section_deactivate() --
does not carry the struct dev_pagemap pointer. This prevents the lower
levels from knowing whether the section was originally populated with
vmemmap optimizations (e.g., DAX with vmemmap optimization enabled).

Without this information, we cannot call vmemmap_can_optimize() to
determine if the vmemmap pages were optimized. As a result, the vmemmap
page accounting during teardown will mistakenly assume a non-optimized
allocation, leading to incorrect memmap statistics.

To lay the groundwork for fixing the vmemmap page accounting, we need
to pass the @pgmap pointer down to the deactivation location. Plumb the
@pgmap argument through the APIs of arch_remove_memory(), __remove_pages()
and sparse_remove_section(), mirroring the corresponding *_activate()
paths.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
---
 arch/arm64/mm/mmu.c            |  5 +++--
 arch/loongarch/mm/init.c       |  5 +++--
 arch/powerpc/mm/mem.c          |  5 +++--
 arch/riscv/mm/init.c           |  5 +++--
 arch/s390/mm/init.c            |  5 +++--
 arch/x86/mm/init_64.c          |  5 +++--
 include/linux/memory_hotplug.h |  8 +++++---
 mm/memory_hotplug.c            | 13 +++++++------
 mm/memremap.c                  |  4 ++--
 mm/sparse-vmemmap.c            | 12 ++++++------
 10 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dd85e093ffdb..e5a42b7a0160 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2024,12 +2024,13 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	__remove_pgd_mapping(swapper_pg_dir, __phys_to_virt(start), size);
 }
 
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 00f3822b6e47..c9c57f08fa2c 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -86,7 +86,8 @@ int arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *params)
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -95,7 +96,7 @@ void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 	/* With altmap the first mapped page is offset from @start */
 	if (altmap)
 		page += vmem_altmap_offset(altmap);
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 }
 #endif
 
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 648d0c5602ec..4c1afab91996 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -158,12 +158,13 @@ int __ref arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	arch_remove_linear_mapping(start, size);
 }
 #endif
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index decd7df40fa4..b0092fb842a3 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1717,9 +1717,10 @@ int __ref arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *param
 	return ret;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
-	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap);
+	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap, pgmap);
 	remove_linear_mapping(start, size);
 	flush_tlb_all();
 }
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 1f72efc2a579..11a689423440 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -276,12 +276,13 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f98..77b889b71cf3 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1288,12 +1288,13 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 	remove_pagetable(start, end, true, NULL);
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 815e908c4135..7c9d66729c60 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -135,9 +135,10 @@ static inline bool movable_node_is_enabled(void)
 	return movable_node_enabled;
 }
 
-extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap);
+extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap);
 extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap);
+			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -307,7 +308,8 @@ extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-				  struct vmem_altmap *altmap);
+				  struct vmem_altmap *altmap,
+				  struct dev_pagemap *pgmap);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a943ec57c85..ec1a86b12477 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -576,6 +576,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * @pfn: starting pageframe (must be aligned to start of a section)
  * @nr_pages: number of pages to remove (must be multiple of section size)
  * @altmap: alternative device page map or %NULL if default memmap is used
+ * @pgmap: device page map or %NULL if not ZONE_DEVICE
  *
  * Generic helper function to remove section mappings and sysfs entries
  * for the section of the memory we are removing. Caller needs to make
@@ -583,7 +584,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap)
+		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -598,7 +599,7 @@ void __remove_pages(unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
 	}
 }
 
@@ -1425,7 +1426,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-		arch_remove_memory(cur_start, memblock_size, altmap);
+		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
 
 		/* Verify that all vmemmap pages have actually been freed. */
 		WARN(altmap->alloc, "Altmap not fully unmapped");
@@ -1468,7 +1469,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, NULL, NULL);
 			kfree(params.altmap);
 			goto out;
 		}
@@ -1554,7 +1555,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap);
+			arch_remove_memory(start, size, params.altmap, NULL);
 			goto error;
 		}
 	}
@@ -2266,7 +2267,7 @@ static int try_remove_memory(u64 start, u64 size)
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL);
+		arch_remove_memory(start, size, NULL, NULL);
 	} else {
 		/* all memblocks in the range have altmaps */
 		remove_memory_blocks_and_altmaps(start, size);
diff --git a/mm/memremap.c b/mm/memremap.c
index 053842d45cb1..81766d822400 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -97,10 +97,10 @@ static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 				   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(range->start),
-			       PHYS_PFN(range_len(range)), NULL);
+			       PHYS_PFN(range_len(range)), NULL, pgmap);
 	} else {
 		arch_remove_memory(range->start, range_len(range),
-				pgmap_altmap(pgmap));
+				pgmap_altmap(pgmap), pgmap);
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
 	mem_hotplug_done();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index a7b11248b989..c208187a4b00 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -665,7 +665,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -746,7 +746,7 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -784,7 +784,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
 	else if (memmap)
 		free_map_bootmem(memmap);
 
@@ -828,7 +828,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap);
+		section_deactivate(pfn, nr_pages, altmap, pgmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -889,13 +889,13 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 }
 
 void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap)
+			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
 
-	section_deactivate(pfn, nr_pages, altmap);
+	section_deactivate(pfn, nr_pages, altmap, pgmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
-- 
2.20.1


