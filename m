Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE44FF8860
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 09:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015B66B0093; Sun, 26 Apr 2026 05:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2EC66B0095; Sun, 26 Apr 2026 05:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E449A6B0096; Sun, 26 Apr 2026 05:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3B116B0093
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:27:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69E0A89AA7
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:26 +0000 (UTC)
X-FDA: 84700178892.30.91DAF1B
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 99DD6C0002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Y4keclKL;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777195644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zr+2FRsXkOuluyT7nhch5RLSTRKRMggfn+zHryGzliY=;
	b=s/r2Vee//M+IdwcJyR+lb5O6r17KwJhrC82mxp/N5WMVZM1bw3t2U0c+tNJ37+AYM540an
	7VH2HhdjS3t3uGjXVbXSSRroEm2eYIIlyFlgN/zJsaJZ3sWxBMYgfAR/g1WCNOjzbqseJJ
	0g+T9W/pQiLXyRpLxDGkl+wbFDUYaiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777195644; a=rsa-sha256;
	cv=none;
	b=4WJzLAzV2p+uZib6Ab+59H9vDSZCwJU2w+AycjWsOojcS+CrBfsPJkweOK56ijH2/MJJD7
	qMubhDbajam8srZZlyYvUdBRdo6yAW33SezuA7a/QgjqUpGNKf1WJSSf8E9B00tOElswc6
	KMzuc8USDplpg6R0/soSWCAj93azhjc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Y4keclKL;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so78570605ad.2
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777195643; x=1777800443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zr+2FRsXkOuluyT7nhch5RLSTRKRMggfn+zHryGzliY=;
        b=Y4keclKLQ1sezvUjBWmLL5cbOObPg4+QtDfOZddT4flijG9gr86/JStlfEfEXsABAe
         9uwzOIbp6eJHNyhNkoCq0hhCrBDUR1W39YGAEYWbaDtxRiGz60klWKxRgn7uX/PxYbn8
         35ToAmORMTuQLnlHDqeRT0qdYT3QqGcBWfczhrpErAADa2OKKU0F1+G59yU/DVdE6d83
         cKacCteK6HfBjxAGcTvL3Tz3fxCt2QBKBC+VM4qvsPmKJ+vjaQgAk0Jwnb0Yz74iC9qU
         QOk2JKP8ePd6fJvO7PxDOsVH+sgKJQpkoGvBjVcRR/pvNximflO7PfTWxsnqgWU5WNDA
         V1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777195643; x=1777800443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zr+2FRsXkOuluyT7nhch5RLSTRKRMggfn+zHryGzliY=;
        b=PVk0uSfxy3ZF4kZkJ9/y4YDzeVzmlIOWiG5g5QldyaAqQ1BZKrHb+WJ7VQh7JkimnF
         n8R3HFBj/5lfU8Q9AaqsVMpWN+J6jMAq3YmLWWgQtcsCVqKH+GWcmSmXd2nggH+5dNTF
         ldin84o7Pmqh9Y1LTqpQlh3D2j83/DSgK0x+DXAaJL5BZlgFldBdLb9TygrYILcYabnQ
         zo3g8SnPJX769PKbsu+3/QS8F7Fu8zOtDTY+jKjKLKtRdifNSYMYSrq83MSRn2NDC5PH
         3L2kPxUWpkaeoVrtQRE19aUJVn/U+fCcptzVJXCmXox+Zkxryra2V5G+LsznM2XliZwp
         o7xg==
X-Forwarded-Encrypted: i=1; AFNElJ+jHbOFYf6C+aSV0g0YNrm81NqCqtL7FoJGO7bsbq6HcSjmnRIKb0HEHRCs+uJhgBENerQ77QJedQ==@kvack.org
X-Gm-Message-State: AOJu0Yyhfm0RDaXWt9P9noX5t/hom2nNgV1yvmj5JwU1ElssZdgOGTph
	aPQihy8gbSIuq0RFrKFREGyBLmFnAMFYdDD/dpuSMwjyXNFmzfaswZ4dd8k053TYfvE=
X-Gm-Gg: AeBDievLy75YIaWrVXISmtuyILPpcHRmh+jP7Axqi80SYdDli5eru2McY11i07pDGtu
	S22qrMyIbta1OPEfjaTI157XqraQEBZfSzjbdMX5rZWT/6ftoww3COTpZFjA+5J2J9Ev04XENpg
	+tDAndj/indmnfUPqDugpzuE9wRSZtZOHOlcu1VaBLaS31O+mdQSIy5UFluCNOyzKFgMkFdHPY0
	DyERAXJegTtP/4Ihj82hhBjL1xcZQgi9wJx4h+lrSPsSPnfcJZP9fncdnV+d3FpeJZFPUN1ORYP
	Y4P4iqzQlgfsL9L3n9mt5/1AfOfL9esi/S4M3Nb4W+5BTa7U6UybMhZ5sT4XaMytq1DSPQhi6D2
	AsWVTQRHbyH+aj4jZrFcchXvJIdJdFc0LUynMC25yXHCNwEBkUgnQCGsbqJQ5edm/FdFzuZhtGW
	DMSKhbWyn1zOuEZuWiFAPo9O3gaPFZ
X-Received: by 2002:a17:902:9696:b0:2b0:4fb6:85ce with SMTP id d9443c01a7336-2b5f9f7cec4mr281168935ad.21.1777195643190;
        Sun, 26 Apr 2026 02:27:23 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0caa9sm270352885ad.40.2026.04.26.02.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 02:27:22 -0700 (PDT)
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
Subject: [PATCH v7 3/6] mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
Date: Sun, 26 Apr 2026 17:26:37 +0800
Message-Id: <20260426092640.375967-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260426092640.375967-1-songmuchun@bytedance.com>
References: <20260426092640.375967-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99DD6C0002
X-Rspam-User: 
X-Stat-Signature: qnwtqr8cc78xbespjd18gyz9kqs6xepy
X-HE-Tag: 1777195644-462313
X-HE-Meta: U2FsdGVkX1+Xu+puEN8wtyhFGFJO59EEkc7dJiRkYTw/R/UhZ9rngSuoRIr/cmQkg4KBd2AZCimDrbAZRD9PaWy0Kfj9qlhJqVsK65eNXs0AUqFb4w0jVxXs/y3Exh2zcHStF0iD3lm5qHvrKauDzIzn0cblk9VjbuHzUvJOTR2O4rwue9EFrm4SWdxk/uu0xQ6qM97NEdGIhc5zMaKR7ahfOt7PxcFgKXBOtHIt0t3t27gOvhWMS5DvLfkSTpqCGw481P2h1p3gA+kTVCPAYhv+uyDUulbqomecTY7eTaq7fZRLhMMQgFcK0UYiSBirHqwU8nG9yNDnJ9c6WvI+NendusH93MKUzcu/VbFZBN0HGK3grZqQU3ilGSGEt8ml58XSSaN4JjCi47B1RTYO76dYUWEY2JKVj3tiRoP+ivWQxSb4v41V90rZsQfN0JG2UEZQWzddj4q7x+kyX1iyGFSBK5FzpEXE5he2EuLlAfdkxKf0R10enl4di2T4O0RZ2pOBduhCouLRKoxKuiflzeE7s7fNggD/ZA0Tn4uJWx6hnBW23KL1aSzolDgbmENF55MYStaGDFyGY6o4Dw80aQjOGRFujx+8NtiQGyIFcETx+78WUdUnjBdoZDzlNpfqhIhY/AIp+MePBY9rnjNlVPu3/HNH7azC5VkaMviMk06mGr/VkGu+IUwfgcVRAAe4JBIqFyrHlcEaeg8HF6KMsIod+ABncFd1RwKFbe3G6KZuZBYlONykdqEVK+3sassubCVaNH8ZY1EOc1jB2ZZuttc22QzoE0wNBfaJ5D+zZoTijBcj+xvGF/7APWuLfvi5LaTeL19sR+QHqNOp6+EUExqiawDIIuszNVG6VwSmvNO+uihwlMmDLuwMEZbtDTpACvjUg1WXiMbo9Qz4gvYier1leJAvFYH93MdaxRD41+h1/ELcO+qslXDQNAmFiU0e9RnVdh/VPqwOXmkBBBx
 Ff7w65bO
 xC/PxOBES6ESXxkld8fPI0FfIt+AcSRDFYnWlw/rPMTiwVrGkinwTlnGV1ZUvu2s6i5Ey26fZCm+NiudP3mbm62LoildcH4oGDrSWFBHEUCzGrBm6uNU+6Rgi9APg1ZiAMDALDr2Iyn8pVq9dOW6jVPAiJ9MKx/CVXy6S/lYuX36bgwrOID/ItND0otY07CX2vzc1IQa1LWps/TmPb+EOJZ9U8eqKmm2vDqKyuxFWf3pnv6Avfe6YI7OPksceTMzz+EKSlvqowWvNuLc9p9NivDJFOX3l85oBRkg4zNJmm8cVeL6Hp76Q6S1X4by319YfyD5nBKK0SLV2G4OH/OSCiJshvQ==
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
index 3f9ab54114c5..055ecd2c8fd9 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -119,7 +119,8 @@ int arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *params)
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -128,7 +129,7 @@ void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
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


