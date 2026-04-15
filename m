Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F26F4198B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7CF6B0098; Wed, 15 Apr 2026 07:14:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F9A6B0099; Wed, 15 Apr 2026 07:14:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F046B009B; Wed, 15 Apr 2026 07:14:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 078146B0098
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:14:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAD41E0263
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:35 +0000 (UTC)
X-FDA: 84660532110.23.FC9D8A0
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id D3D614000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EpD1OPhh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776251674; a=rsa-sha256;
	cv=none;
	b=qaS06mhQYZ/qNJpXcnrGeELuoeWhwcSLTJk/WW9QflXEShgzCE5KPe1W1NB3+j75dj5B+i
	ZcRB+F4+OGttLN86dPP1tcf0m0Q+9LEeFx4xzPXQhamSIYLWWp1Ibr/uDrVReZRt2AYrzw
	XsQ7tc9So0LIYw+dCArNrwoSWMqotrM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EpD1OPhh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776251674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5+/wr28ovMeZQg9qKyb97SWC0411ZRUTOfCSyd/WG0=;
	b=BewatROOEXxEa91ZaCDOA3UMeA3wNwLQlWXDFgOntZrOYis1Co0Q6M6QnkoetySU76NEms
	Rm3j9YseNS4YCYsfuLFwN1mC4+wJ7Nexbv/9vWVhH6Ze3Fpt/Idy8+s71zRU5CHskr37ql
	7E5e1N0ErRhj+90AsTm65+rzHZY1u3s=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ab232cc803so33533435ad.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776251673; x=1776856473; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z5+/wr28ovMeZQg9qKyb97SWC0411ZRUTOfCSyd/WG0=;
        b=EpD1OPhh4gjnCb63ld5MI1/Tkz7BNdOmFDXXYfG5AVO9eMlB3txFjyPqQU7LaUcF/+
         1OnbloW37AYgitYJdLy7nHF1YtSb6B4tEzxO/Pnt5dK9IhvPsVWqgyBGR3g9XSXH3qdL
         X9BHlgJ4/zBAXNecD6YSAyrt0VL0RI4Rm4E+uLhOcO7Jak0GYGmZM3EvTnqbUDHx3MiQ
         FNc9ybCAlJEsxkgfzuQfRuGGXC2oRoMyHcWboqcalI1bmC4TsR32++Z1Tt8PeHbo9zQF
         XenvdKcJ1D4oX7SO9JxRyyT1t4Oy2JUYGUBYl2CR+cyhDxXbGVF9rxgsPAxmwYsm/Wow
         SbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776251673; x=1776856473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z5+/wr28ovMeZQg9qKyb97SWC0411ZRUTOfCSyd/WG0=;
        b=E3+75hnnpFCSBmRE71FCneAsWn+slcaoRyUxpvvzzU6le/sqE1Q9gjqWHgo+qWXdc8
         kiC/6JTI5BpoE10+qGMAcg6FMCG5fNPoP0M3uJuMZd0GK26Ynd7KQW2pqT+/W95XG41C
         GO5zZKszSiNs+eYRupRPXKzv5SkAqvcyu7/0KWnUilJp5XUIOLUom44gJtHeeKGyzDrk
         ZWBImwE9hNvFGrBtyu96WtC9x1SXMJlwHVrVIUBGOv6YT1NQ/n+H5dPo0GigYfbqXT3p
         GfrA6O3sJbjHcVZFUMT3iFHlBSn6IdhSFfDT17RH4sYNXbCnQOpYsJrqnRwyj8Al0P6U
         h0VA==
X-Forwarded-Encrypted: i=1; AFNElJ/MWRh6LLIIgBUwNW3pMPzTQDlFHp9L03pPY5/YzA4NpM48RyY57VslI6QpNmasxuTAJ5PEHBjVAQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1TuDPJXkYXRrFm4Dl7ewXD9e1e+rGq7D45vHJHBa75yV+DWF7
	BkfA01ATxTJZ8Z2y9+CydiIvXTwe0pehET9/U5ZOhZMXlnHQ6xtW/l0SgGGUm3g1L3U=
X-Gm-Gg: AeBDiesmxChUcvPXnMZJWPX6MELJMmEmLUApXuDT38s6TTCUKAA0PYnzb67JJGZ/lvj
	Ndu5qQ1pWgrCtp4iO7R1VjESHXWQtISMwA4w5D1d7GXXZ4TQXOECSA+Y2nsPIOpnAPEqxSNKi5V
	ub5b12mYfZzAu1I4697l15xVOqMlQrYe9IIDIF1z1a19TtBqLZcdiil/P2PgUCQo9O7fF4YSQ8F
	/G3NYXGwNiYP7M4fc+xVmfKiCWp05fELye2gJ33thw0eJjaqEeHektWx2YpWBAmLuZWhwnoey66
	UjwyfxlCoKbzFYgksQmr61DeCrVfccM6Stq+M3WNE64v3AAXGCNnoMd4eRDWunIdI95d22HP6AQ
	PGtnAEoivrt9t0W+6/2VsCy3dSHZVHtsewDE+5DcSTJo7xSN8TZnUgNdkMH+apEJqIA39AWPAeC
	ZQVj476eP5KBQTLwqlKdvWBIQW0ENosp8FOWIKME1ISlk=
X-Received: by 2002:a17:902:c3c1:b0:2b0:6d33:e7c0 with SMTP id d9443c01a7336-2b2d59766c2mr159851625ad.1.1776251672541;
        Wed, 15 Apr 2026 04:14:32 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b477fd3724sm19509485ad.0.2026.04.15.04.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 04:14:31 -0700 (PDT)
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
Subject: [PATCH v2 2/6] mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
Date: Wed, 15 Apr 2026 19:14:08 +0800
Message-Id: <20260415111412.1003526-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260415111412.1003526-1-songmuchun@bytedance.com>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D3D614000A
X-Stat-Signature: 8yu7rfzk84fkpkzdpiscrjocecy9emf5
X-Rspam-User: 
X-HE-Tag: 1776251673-551461
X-HE-Meta: U2FsdGVkX19+6KISr/lcF1bW2qXRaAMeXRRZ1zpkfbZ9m1uUVhdKD9h9y9IYs2tXTNbynMQ2afusibB6Ru83Qg7FFGtjT8tXY3H4SEtsvFpwjY9voBQezcTj9LxsDNvWTXr1Zl40oKT1/ZG/IN9v3TKvX88AiS31xptNPRyKxImwi2nADJ7h7QJi/bxj5pjpi7mYdq6y/HOtMNyqgZLVphsKLdbot9dpMSZOHeiR6aoCu+icZD3NlJyae/4hBQQq0b49jMNpMPQ49z+UqWJR2h5GRy6PzNBpjRpXA6WQ/soKfA8RXsibs08N2E93i++9+iRV+755k8GB1D4tNpFc1raHKhWaGgWXy2rr+jwSQ5i8Fy0QuFzp4MolE1TgRprdloJff+LIG1LNWEQPXWVKpK94pIaInS98s84jvIKvutIL65moX5QEnIARvxpOLcckpBEXRXQEw3qb8kmrK5gII4MHBR6GswIgwxXf5JRM//2IBzUjqBCqSeWVS3yJBIQTzNS9PINyoQF7WkRkTuYkrFSyaZrhVEzKXn28OvvKJNjyvtYkBpMgOo0vMUR8tcHaytS4FoF5R8Y1dGch87hIbnRsOG//bSq+t01lABm+KrW6vz9ii4Qs5OBrUfYF5g3mWMH6E4EB8+IYpuc1/zVbl2I6n5l6HkhlOv34/4/mhrj3/PC95lQHFcn9+V0RSReruk+rQ/UY72GTy49hGjDKvGJQCPE6ho6plgmAYc7tHcHek1ezEBLIQxPXH28wviEbvAwXQPvHF5CNX6X44JN+H6k0Bwfz0r1yEOcAAHJsxW19lJJsGYRCMgz99IeWyurthYZatrgYoMGrLiu2hDrzmmdvk/F9YGvdpafXshHxiHUzgq3n2vqAGCMns3vMFNJuvpNV7+EaheCuu/kLm76yGQIUJXlCC0SeAGp9M4I7ZTKD1d7g2WQSriYausa094nN2ZAFh3Pm5RpQ+WqxBAs
 zAiXDiiH
 PaiWdfxYto1NEVgloBRVTjWxK3xivLjPp/DWWfx/kWgkuP/31sazCXhHfWRz3yNC8lU34/BXUi/7PGL+n044sAuOl6rKO0AEY7PqodD2aUYdnjyE9OmRhaNisXxPYvCRgfP08pwSz66ZZ1l/L6O5/7kILW35W09KKHM8YYXiK3DNeRXQDAdsN/TdzLnYhOHguFH0cSw1ZNlyxqkeCc6F/iNNhaLZFsrz6DonxORf0ZaLikuQ9eH2P6psHNUG5JjIrRhwiisIxby50GTHaeiRSUpI1c5715q9tJf5+xlXY+qp/t0bAAF97JYNZBg==
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
 mm/sparse-vmemmap.c            | 17 +++++++++--------
 10 files changed, 40 insertions(+), 31 deletions(-)

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
index 2a943ec57c85..6a9e2dc751d2 100644
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
 
@@ -1425,7 +1425,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-		arch_remove_memory(cur_start, memblock_size, altmap);
+		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
 
 		/* Verify that all vmemmap pages have actually been freed. */
 		WARN(altmap->alloc, "Altmap not fully unmapped");
@@ -1468,7 +1468,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, NULL, NULL);
 			kfree(params.altmap);
 			goto out;
 		}
@@ -1554,7 +1554,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap);
+			arch_remove_memory(start, size, params.altmap, NULL);
 			goto error;
 		}
 	}
@@ -2266,7 +2266,7 @@ static int try_remove_memory(u64 start, u64 size)
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
index a7b11248b989..40290fbc1db4 100644
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
@@ -674,7 +674,8 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	vmemmap_free(start, end, altmap);
 }
 
-static void free_map_bootmem(struct page *memmap)
+static void free_map_bootmem(struct page *memmap, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
@@ -746,7 +747,7 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -784,9 +785,9 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
 	else if (memmap)
-		free_map_bootmem(memmap);
+		free_map_bootmem(memmap, altmap, pgmap);
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -828,7 +829,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap);
+		section_deactivate(pfn, nr_pages, altmap, pgmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -889,13 +890,13 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
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


