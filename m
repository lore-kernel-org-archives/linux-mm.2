Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337A3F3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559C06B008A; Sun,  5 Apr 2026 08:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5318F6B008C; Sun,  5 Apr 2026 08:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447746B0092; Sun,  5 Apr 2026 08:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 323886B008A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:53:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8AF913BFAB
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:37 +0000 (UTC)
X-FDA: 84624493674.26.311507C
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1AEF4120008
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NrfNS4Qz;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyPeWfsO418Re5hKKT3eSnZkoPoEx5W3lIDo032LUZM=;
	b=I2hJYXOg3qflk/Q7l1k5uHzZjcJlfD18b+JeflmVTuG5vsUNtrgxgF1wXalR53XZIBLiA0
	51RvsWx6BUKBTz3zZJyH2vcfd/AYQLeuthgGyn/kQlHzJXfYFyIztGzuUoFxnbbA+2OWYj
	gr38/olnceVavFHexEcJAKPpLxt+Lss=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NrfNS4Qz;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393616; a=rsa-sha256;
	cv=none;
	b=6XM5lRDzo7+Rh52W86R77ATxhpiq+NbrtXPxBsBsctUcHZj7/ArbOW9UvOdCMoCyh8LtFK
	+u5xIDTLb+aq7jabS0gSEUOhELSK5JA5X4sdmzgUvwT45nlx7eVv42kOCaMcbNeky6C3mO
	b+pRwSlHqQy8+olXG6mrMozHqRt3sW0=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-354bc7c2c46so1787115a91.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393615; x=1775998415; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qyPeWfsO418Re5hKKT3eSnZkoPoEx5W3lIDo032LUZM=;
        b=NrfNS4QzQiqLEk0td+Nx+Y2oZuFV2Ispsfd06kMY7C9F8yNVXJ/5IR/0AEsWwv0Z3o
         R8nPVKTu9C/Atj4TYiBWKHscB1+aSL/VI1BNiHZq7iEXiGfGebgZ3OC3B9GJgMpjhXCV
         DnJwgNPeqeQ3lghK/m+al1KDu4WMLyNiteN/u9KMiz4Xz8cOH9mCNv11m7Vl2+ncnO1z
         yVLX2fNzy0jINqylHpWTB9KsyROyPwF6iMtMjFYpdsVcmjTyn2s0d+vixzYsFlEuWjm9
         EqqOaWpp+sJ7r/L4Jib9cMnuOJHMUlcc0dkw/PMxncmZjOqvKf8WdNuDBzFf6Oq2C3r5
         JjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393615; x=1775998415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qyPeWfsO418Re5hKKT3eSnZkoPoEx5W3lIDo032LUZM=;
        b=Uz7QGikJVRVdTBgJWFY+jkBuUb/5s9Xk1uGDAJOWTvk4mJTgOicEjmzsWPXysi1CR5
         fIdb0BHUheiSflb9qpFbB024yrDsc+Y6xYaGDsWh0DOEZUBLFBBb4pdmPjRp/aeQSfEQ
         8RPVl9Vwcmoi73jNtA2w3c8O7qNGTPOWzoyZO7cLRXOTXIdHez0wWen0TGUzFbF0FejR
         2juLgeNDUDx3wsYF8E6GF34xSojx5zgi5VppOyFb/rnqPRDMRfZ4NcqW0unYcWbaKZi9
         uV9nW/X9yzsiqGr0bmFJKC6aDxJ/dZNWWQ+if64aX61kzEOAMui9h26GfUSuE6azAs+C
         DAkA==
X-Forwarded-Encrypted: i=1; AJvYcCWT0ax4uQGicJLbLcir4NgxnMheAsgZWgL4IXrUdCdTEcmQo7NzoUyQpSXa7gG0EwkMzR5BxeM87A==@kvack.org
X-Gm-Message-State: AOJu0YzxvHA7dEMwC4sEzFScZnb8RU085G2Jkw9B9pkcd2sOoHjwLwKm
	A+2Qv3On8ujamW7Su/UHKCJC12Oej++w1qIZyrEKXz6rk6SOJsqNdaoVQ5RC1qHvGU8=
X-Gm-Gg: AeBDievIbm6aRavv4O3fkHynBUfUCSdGe0Np5zLoECHWCRgWEFhadl5hSisyTx6erq8
	VMBF+g0zsdINWlZioX435wAPrVUCMAWnVknFa5cDpofo482/fgsyYaXj+R0kJ3wzDG9e36pW7k0
	+6YvAkv6SR1jw5h7AspFTuFHOoO3ki9A6cWNMb9YgBr3oBrF8nUC8dUaCUz2ez+4HAix9ordjUw
	/tq5PDrbrUZY3jQpMuZDDPEsONC+RloqXslvJ5v8hbtATU0pVN2nrXsvi90W3HCj42LSCV8zRIt
	adFX6H3M2WCapZuP+TI+BlK2k4ciIheYe3qQJQ8OTTHN3XM1mbk0SR13umfTkerA2RbPZ3+0ycO
	2b97jlgIv4zUoZ0zK8zOEjhIADzl9cryGuDGAnUxm1AkQghE+AMap4jBaoG9odrZBNYSTjI5deK
	VItGHKirsjzFUsRe5AfCWu/vtHiaeeWwG1ViQ6aPFt88I=
X-Received: by 2002:a17:90b:4ac7:b0:35d:a8d9:3b4 with SMTP id 98e67ed59e1d1-35de678f7d7mr8776631a91.4.1775393614559;
        Sun, 05 Apr 2026 05:53:34 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:53:34 -0700 (PDT)
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
Subject: [PATCH 02/49] mm/sparse: add a @pgmap argument to memory deactivation paths
Date: Sun,  5 Apr 2026 20:51:53 +0800
Message-Id: <20260405125240.2558577-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: s7b73sbpx8tpg9ewwqxpj8zxomqxtwxy
X-Rspamd-Queue-Id: 1AEF4120008
X-Rspamd-Server: rspam09
X-HE-Tag: 1775393615-943209
X-HE-Meta: U2FsdGVkX1/qFOTFfMsa01rEHvg+IRqVztBdRhV4/ZBJ+idtKs2i645TDcsZrsPPbv/12TBzSbjPFjzArfALOZKraBvEdzkQ70zNJBbiBuzRfa3gZEJAcWe4SM13hVGRDULz+UVAyYdKWhnuU9qHkhFLpIyJbVeYQ+FdYo1RWAm/9Ec2WEyQWgoI0djO5ZSteLXdRpeIRuPb3OVWSGD0CR6bdZ8EQFD4CC9gdCXt6GWGykLqkl3dF15LJ+yN3LFu9ExT/AlHlZ1IE4NLDBVQ2AgZAsxdrbolhIiyltXtmE6S0B6zJCMgiFBZSekE/2PCHTpeVIdmdjr2AummO9EvdMy0UNrBEurA8XHKVvsRkBsT2eK3O2uOaPj1BWVMJQHeM/AJv+LTinlVRHYK1m3qVoTKSy1lHm0CayuszhLI4BC6s/E/G9OMscp+i8H94N6epCkuTr1aPzFot4R+0RsSjvKg+rX3Rgh1mB0iT9aKvdM91z3/XHKAnKmp8o4QT4fXnlYjMTVqkIoPkrJsT3+/aQ6P25zhyf1ACfwsIz0H8DKAcgfxfUZxFuWhKixoZfU0m9vnTvuLK2/cGa5EpLPURl6Y3uMQYfZtZuqkc2v8qpnVAM4a+JOfHhfOAGLaTIMy4quyOQFK8LPA1LSlWt6O3L3rSc4nYxr5EMXvVFpYJFJ8ucuNLK4ANQQsQ/iAzDsrotxadwOJoQ/0d7CVpSgUCJohb3sIDDt0ZDyhEOaw3XErsKGmgljAJV+obQLuFxrsL3x8soHGSFSzeKZ2MxpnjJkV+OctnqrVre1ynO5OPX1GenUPbmFuiASZ6TT0gpoWjFvZv1DZSa3/waAFGKcGeW8gbcpT0K6VEu3ZpoUyRV/ufR8UFQ3Bhn407ECNFXtsacyJuOOw3s9/KcsVpuMVO5VreZBvz57XIiQQybUF6rWRm1OckrTn91/Qj+RqE7Vzw5QtkgJ48SEisnxrdd1
 F4rTiJQy
 CMXg0HgahrP0X+HuTrdDpEk4hUNKdYCSgJGatL0feLZ9NHRmW6zU32eEEGyciK5UNfa04Kl2w45Gcu3rm/mFmVL2IjJNu1xQ7XLM9B5kwMXYbJtTbcawpihVJ7Bw/17EgdzLRcF8fElWDAVbRMgx2SAsvKMvu6bQp65P1gPlqWSzkxNPO/dERuA4qA7UcFr8llfho/JoXYMo1sJ58V6+3d58jfhRBe2ovqW1Wb+gFvnI0NtanxbEHIKSf8l+fDzqpqVbZxR8mDMKBVoZuZrdBwIvoi4wXYygoMKlDcddNXY6tWpFwtg0ouWO1+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, memory hot-remove paths do not pass the struct dev_pagemap
pointer down to section_deactivate(). This prevents the lower levels
from knowing whether the section was originally populated with vmemmap
optimizations (e.g., DAX with HVO enabled).

Without this information, we cannot call vmemmap_can_optimize() to
determine if the vmemmap pages were optimized. As a result, the vmemmap
page accounting during teardown will mistakenly assume a non-optimized
allocation, leading to incorrect page statistics.

To lay the groundwork for fixing the vmemmap page accounting, we need
to pass the @pgmap pointer down to the deactivation location. Plumb the
@pgmap argument through the APIs of arch_remove_memory(), __remove_pages()
and sparse_remove_section(), mirroring the corresponding *_activate()
paths.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/arm64/mm/mmu.c            |  5 +++--
 arch/loongarch/mm/init.c       |  5 +++--
 arch/powerpc/mm/mem.c          |  5 +++--
 arch/riscv/mm/init.c           |  5 +++--
 arch/s390/mm/init.c            |  5 +++--
 arch/x86/mm/init_64.c          |  5 +++--
 include/linux/memory_hotplug.h |  8 +++++---
 mm/memory_hotplug.c            | 12 ++++++------
 mm/memremap.c                  |  4 ++--
 mm/sparse-vmemmap.c            |  8 ++++----
 10 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index ec1c6971a561..dc8a8281888c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1994,12 +1994,13 @@ int arch_add_memory(int nid, u64 start, u64 size,
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
index 5142ca80be6f..980f693e6b19 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1810,9 +1810,10 @@ int __ref arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *param
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
index 8b18ddd1e7d5..05f5df12d843 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -583,7 +583,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap)
+		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -598,7 +598,7 @@ void __remove_pages(unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
 	}
 }
 
@@ -1418,7 +1418,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-		arch_remove_memory(cur_start, memblock_size, altmap);
+		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
 
 		/* Verify that all vmemmap pages have actually been freed. */
 		WARN(altmap->alloc, "Altmap not fully unmapped");
@@ -1461,7 +1461,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, NULL, NULL);
 			kfree(params.altmap);
 			goto out;
 		}
@@ -1547,7 +1547,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap);
+			arch_remove_memory(start, size, params.altmap, NULL);
 			goto error;
 		}
 	}
@@ -2246,7 +2246,7 @@ static int try_remove_memory(u64 start, u64 size)
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL);
+		arch_remove_memory(start, size, NULL, NULL);
 	} else {
 		/* all memblocks in the range have altmaps */
 		remove_memory_blocks_and_altmaps(start, size);
diff --git a/mm/memremap.c b/mm/memremap.c
index ac7be07e3361..c45b90f334ea 100644
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
index ee27d0c0efe2..7aa9a97498eb 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -737,7 +737,7 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -824,7 +824,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap);
+		section_deactivate(pfn, nr_pages, altmap, pgmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -885,13 +885,13 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
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


