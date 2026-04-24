Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0EE2F9936A
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612556B00AB; Thu, 23 Apr 2026 22:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4376B00AC; Thu, 23 Apr 2026 22:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B166B00AD; Thu, 23 Apr 2026 22:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8DF6B00AB
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:56:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC3F31C0EC9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:14 +0000 (UTC)
X-FDA: 84691935468.21.769D4B8
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id C55D4180010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LDo7o6YW;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tVvEy0n8Q8boUwkyPz7NIWKrGY6MN5PZ12u/TRimec=;
	b=Ac0q7S3Oe3zttGF7hFJ57U7ACrQUWTL6jLagzTvVR8VFK4t519NFulTXVFrA7VUwe7u+tW
	pVt8mJNcCAUApKtTjzT4Df9eoaet1CBSPRDWMzZ0gi1DHmLsbO16XA9QRFt7OWS5f03e77
	qNI/FB0NC/Gf3lJWRuTYCGKEvBicXdo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LDo7o6YW;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776999372; a=rsa-sha256;
	cv=none;
	b=mDYOq4z/yTTvM7kNmM+MVJ2ra43/dMtR7Soa4iwvb19F/AhwZXwo0tjICYfKknKcgcVYpC
	W+YR9fNStnshvMIf1Epe/uiY00JF16O5vYOEcXSNAgeusX81uxi31VE9+N0E+dgraritQx
	2t4KwvaN+nWALTXaKwBWGaMcWvZiRfA=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b24fcc2b5dso46629785ad.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776999372; x=1777604172; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tVvEy0n8Q8boUwkyPz7NIWKrGY6MN5PZ12u/TRimec=;
        b=LDo7o6YWDduxQLcdKjVgXH2nrwGKGtDbMRRHEAAp1NSZY2K2VCnWJwNUMy9UFIti7V
         ZGLYYk1tJekZjgoUyX//BLCuzUhr6kcwUPKWfG1Z/KJwZlsSSav4RoTGBi9UuUEWpcjy
         BeVpY44ZLw5XcQs96QD1bXoZENByrR3huA6jr2dSFU7dQ1VB8B536Bgn602B1Fo8xRk+
         owpOlIfpCMMkd/1P6c81y1tE6VRFhYue6SjQ/394Eiol9C7sBckfUxltk7wOBt64IAhR
         7x7LqJU4V6jTvIlUFNo2vTaQ/a/B+SEYv6OEFX2dtMmle8bH+0ZJQBvNI0CHhHu7iTVo
         w/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776999372; x=1777604172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4tVvEy0n8Q8boUwkyPz7NIWKrGY6MN5PZ12u/TRimec=;
        b=QDWkO+aQckKZRcmh1L6R4ST+c90kQQBWAyfR8QLNNt+QpJLZIA/vwCwVrotmYbch55
         uGjtWZZ66EFbNe15uBm/EGbZvufTP75N+IP1paYfolOb94GcI3QkQL/u4wtEZ8+Ty/tb
         /SWXl+3kDRYfDrgNQnoPpmF0ZFzpHJBQJprhC/ulbzDBSsNwZMz3li+szIZ9bY6SW7KO
         pu8gx0pPpOhNl9oowCyT4pdQ4fLhJtRIc3DkZjmYRI/v0EOrCMwmRTRf4Q23RHWUmXr1
         FhKUhsNB7f+axUp1A3XetSJLf6L9NijzndWsm8n3BJrzixF0NRQEsB9y/csvOouEQg6m
         w8ng==
X-Forwarded-Encrypted: i=1; AFNElJ//vxabBvNM+7jwhVzTqpKuzdGLtOoSN50ygQs5M57hFi6EI12ElzjxR52uVkxr9ZqbHj8fyvv6zA==@kvack.org
X-Gm-Message-State: AOJu0YwNAaoElunMcvZLXwT5Mi7KbfevFCrITAiU3YefRVubRdpfvH/A
	IVN6UpPUlR65OW9aNJFkHX53RXbmyMwgg7bUR9w01gmtlv7bXjo1CtdYjMZzcZ+zFJ4=
X-Gm-Gg: AeBDieuRmiePB5OJgd9milZmWPz+e9YFAdpe+lyFZAPMy6Phn/9nQ8dk2UzApOYqeEa
	kM5ZfKtK05FTrOQpmfPsm6L5V00cCEJTRdtd0NuX0AAI3J5QxsYgUW3AgR7GBFu56VhHZr5cnVL
	DToygRwWj/8DA7Sr3CpDZB6QuIzK78aSFgv6lNcAL3pgQ/Znnd2+Qpz8VucgeieI+bayUaFdPVZ
	TTEJcSXzQycrssoFThhH2eIh088QKdcnqazUmGv6allLNRKWcXpQgVV7OuuDG/w0hQ/jPs3dA5x
	r+zJYuanrKQrc3qXmUnq5Mp+zzsM4f7KPGbG3qQklvbbRn++2Cm3QgRiEOllc+SGF/nhvzEc39C
	mSAxkv7rCBfsb+3i2Kipoabtgz0QqwAmP1oxOpzIYZGgK3BxkHWc6IrEtuEfhXcrt4zdTo/yeM3
	rJ8DhK/rMNkM10Ij6Gv8Z0sniqNZQ9G4YnxdJ328oebktUeVFJmtRA54o=
X-Received: by 2002:a17:902:f645:b0:2ae:5163:c2aa with SMTP id d9443c01a7336-2b5f9f519e5mr295526205ad.20.1776999371428;
        Thu, 23 Apr 2026 19:56:11 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20d33sm221668325ad.63.2026.04.23.19.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 19:56:11 -0700 (PDT)
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
Subject: [PATCH v6 3/7] mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
Date: Fri, 24 Apr 2026 10:55:43 +0800
Message-Id: <20260424025547.3806072-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260424025547.3806072-1-songmuchun@bytedance.com>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C55D4180010
X-Stat-Signature: rdu83nmuxuxth1qghe9bza7m3ikt1nm5
X-Rspam-User: 
X-HE-Tag: 1776999372-965696
X-HE-Meta: U2FsdGVkX1+1bvbJdlY4CbawuPxGHvii4gRYNwl/bjuxJ9zVc4jxlqsWxr/ujYPnC5i4rFR6iFB34mzx82Wk+cM1ix0M/p/zf4J0po03lb2DkpEzuGptGoi4COyBJT+oXCV6uMHRem/0CcvgmFLJZSzQ1/58kq0Ege6/n92Yqnjz4sWtYw29SxIBDGaTkXeA/injzBGATHKMRQMbjNZsZp/p1emWa2YCBo3L7wq6Rf0IBFsC5haBVeLIH59b2zBztCX3TpClNGwEgrS1fYHIiYRrsnqdhwGRSh6RTNonA9ib7PuF08ltV/gvRJASDdZr6GDYoYAP9DTapZa3geTz0bzwdvSHP+8TCeBJ9W0gXPV6wd0jDz0ObX76KeavIzAlYRIjd7ZdEdI00tMuicRWFglt5SxtOEIH2YgvCDO/QBegcPhED4johUkI2XIjK0E9Ivf8tKzsmB6XZjaVrZn+FQM+7Oj1Swsv9FMGEDCVILjlJHtWQwDsstBOcHLiX1jxReAjAyZbFpWd6BlVSF8nKvPPvRo1yz5H0A6g1E5xNqweeiw+w/+m6ysmr/yO/TMuw/EyZCzGS7aMSCXCbRK0nAqfFnGYNv+dusFa58XKmCly99vaoAIzarlOID1mmjmR3+ROYq5ZSrfa7jTLBOYBqs0rZ1Z9bLwpsGuTPkOm6LDS+S+W+mkLbMElTisN1/ME9s4NIo4TzFXd4ZIuw0OBpRj/od+ue5RmzzEWlN7dYLlieqbJWHxuEHnuzNvaGfgx+P0UI1ZQW7yRns7but9wAuUriBg+jJwi0mAf7sW5j0l/VRIvFw04AadckLyBD3lIm71ZZAFnNFdrSIvwn1+TaEwywkj4+HphkgmfSauroGJzwp3Vq77dYB26aijav072eiaivWMMFYeh7NWnpneGEtguSSc0Id/XeQaO4xdWQz68Bt8qWKPyW+dtU8IcTuhLoa9JMWEv7LNOoBz3bHp
 JuzB9/oO
 FhPtmqRoAARepvFZh7hz5tOOxkuXw/1mAUEwciQnu60QwGBnM7/PYW0etWAYow2tD4YxDadpV2nSa12R/L19Ui4GWMcNScdQ88IUH5mBIdN2qdj6rewKWvXOw30s8OM1d0dWxVkDIrNRhjUYy2myNVGinyXIYIP8K01u/hxZ5S/Vb484wnF57pErcLQEa7zEuKvazwJtF/JOEKMhTT7mUgih9eyL8htAvbe2QEdPqtiCMdjFSabOYxSTku0plC3w1TKfajSegIigos1n63hzG6fC+erAVKrh/RWrEX1u3U7Bke0bmm1IXjYM0kAiXCbjA4Hbr4f0U04CHIdhP2ma2sYQcDQ==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
index 0bad2aed2bde..7bfdc3a99688 100644
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
-			arch_remove_memory(cur_start, memblock_size, params.altmap);
+			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
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
index a7b11248b989..3340f6d30b01 100644
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
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
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


