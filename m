Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 522D8C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E736B00A3; Thu, 10 Sep 2026 02:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD04F6B00A4; Thu, 10 Sep 2026 02:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997AD6B00A5; Thu, 10 Sep 2026 02:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77A316B00A3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8D29A4B37
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:51 +0000 (UTC)
X-FDA: 85196887062.09.DB8FD04
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id D6BF1120008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=W4eZhS3j;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=W4eZhS3j;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022030;
	b=kyeEHoVsTtxFo6rRuCbB6Emx3WKF5mg68mrMKSiCi5l+qdb8+DgFOn6csaW+3O3Ve64f2d
	RsmRNCe2HU5utitLmmjr1B8KhOItAWcr+1JckOpuFVO+hcg9c5KnYG6CNl+nlj4moW9Mdb
	pT0Xn7Z0rfYxi/e0HofodApqb8+3evM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hiIQxlaJeEFoBo/L9xN4cjkO8AZZ+a3pO3zM7+AvDT4=;
	b=SjUejoRRancNpdV51ONHHtRxxhe1ShR8rkZ68aFy6wBHWo5oYux3LNK3MTH8/gqCCAD3dx
	BCce5de1LrPk0cy13YWKkiS32z1BkGcWHuz8VnYI7YdGzDZp+ePLl2JYeNqnGAVzG+0sXg
	tMU9HYpdy+NW5u9LnGTy9aGOU3bKUP8=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso8672939a91.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022029; x=1789626829; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hiIQxlaJeEFoBo/L9xN4cjkO8AZZ+a3pO3zM7+AvDT4=;
        b=W4eZhS3jC3k0HIqLiruyH0P6lvXwueTuD0GoT/aOCm3E2QQvCCl15NtNbvV618Kp1l
         7+qn4MtXBscO3y19FmgzGalYlTc8+pLwIdA9D0ZvLE4Ucr6I6PHbaYvsopQNhRS/sV8Z
         zsKuDgEWM3V19GlRprLuwNav1I96L2ugoN5fxQAHRfbt/DvkGc+Ts6GU9wXw0rRBYlrN
         ks+EJlmBaq5SbBMgkyAgyZLmtpUpt4pJLrxy6OXQYST4NM4YGQEYMLAvh+OPQB8SBjTN
         pDiWfE3+hxny1yyjUkSzosanM/8zo94HqdSZSKmEsnvmjNehV6Tpp8A1W/IDSfKTgzdR
         P72w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022029; x=1789626829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hiIQxlaJeEFoBo/L9xN4cjkO8AZZ+a3pO3zM7+AvDT4=;
        b=iJlgPbbZ77oxUx2YpSMgaTNkDUr7DsFcN4CvAJZ7aRS9h5GRkl+gYXtE/SCnhv7H0T
         5kZWujlqclLf4vHOrSqqrD8nqlRMai5UHXTm2pKcCN3MTxFVkpl+Gb4l3b5XtSXkOzR7
         cEVbfZdstO8R2hkzVxJA76WqDd4DS1wTIRMzYXj05S3WaK8Ey4zlkfxYc+3DNXcManmh
         GlPRHmUwqc5K26m6M9Pl5w6ZwcDUeOjhFgOGU+pwnNL9PloXxib0JSw1utbxS1CJZXI+
         JV8AT7Qjg5tjPW7zKcfsd1ucC50QmxMH6bVNLRZeY4J/A2mffIjK57VZBmTdVV01PBJd
         U3jg==
X-Forwarded-Encrypted: i=1; AKwUvBw1Ejm6s+3kGxE5B/Nm1PLmWQpwsx/ymuUxeYRntBMVMRzasNdHO+p6RG0JK7ttsbEq2gDgI3a0YA==@kvack.org
X-Gm-Message-State: AFuF++me1NQ32wYU33NFrlaqZixBC9qYWPLFSmcOAwvxhS2sj8fVrFTo
	UbTy+UxcnieN9cGC4mz3SY6yFyvpxqQF+PnXgoYLOakDzzk5oB0h9Ct4Ac99orHJMEs=
X-Gm-Gg: AYBFou1EZkku/6EdKpgWage8+tfhhypTJibNyd5Sbc1yzbOqiTjQhdfHSFpmAD/I4hS
	Qr5+3FRKToYQP5XgXu1ye6QE8+XeK/ThJh0BAgYzynFOC2R8CK0O8TujL4Dk9xFad/AgA31MfAY
	fgdWhL/6unCfCtB4UN1SJ06KAdQzuhDebJ/eclq91gijtxlIYKNSZTgoqCc2xk6HyOEifSdz7mT
	TqZLCqDXEbpDo9QF5HqF7whdY1Wqo2w8V/hwHjnz2JxKvXtngw81VxPPIOgfwxDMi5utPrpX/GR
	ObF4yeQNfYJ8x/FEVi6Cz9u+E2pQp86a8aDpFNAPytJBp2NLBCsbvvEwyJdVR3ikbGlqGt4y/KB
	9Dm/cTpUM8aUmN60f5WZzeN1ikKBbctt413H1Eiyn65ZMpHM4+/Iu0s4otkU6i0mwG5nGtxK9It
	/6Zh44O97i//VEvjiT+zbhAhcd4zSiiljWUL0RXp16EIN/TnW3evAP17X1GQHV9uamyCaQKe6xG
	YMOtS7vzEKOWqS2YmjCfVD4CDcKAe4NOoZwdn3Kwwhccw==
X-Received: by 2002:a17:90a:c106:b0:398:e1f4:bda1 with SMTP id 98e67ed59e1d1-39b2624cf3fmr61513978a91.21.1789022028572;
        Wed, 09 Sep 2026 23:33:48 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:33:48 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v6 07/17] mm/sparse-vmemmap: move helpers ahead of future callers
Date: Thu, 10 Sep 2026 14:32:46 +0800
Message-ID: <20260910063256.64386-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D6BF1120008
X-Stat-Signature: 46toxmecm3eku581ithiy73kcysch4do
X-Rspamd-Server: rspam01
X-HE-Tag: 1789022029-813394
X-HE-Meta: U2FsdGVkX1/+jM+NOaDBI9l/vbHKr87YyNfHGbKexXjWrKVSR5cOfqxjTNj38SzMSIXnEkE+VEleVejiQLIIGPd9t5ssWABCV0W6hN+lyBOso/h2TFIGD7wiGFlo7LIktjLHqKFVsMSsC+/VKcfqPFn2GYn8Kcs6UhTP7QpRfmqjlXd/kOAROBzpojij81E2rNSCwjP93PWu/cCYxJjXgX4MUZ8B6HRjeqFKNFt3mm7ioZSSHsG3zsG0KabMe1Hl8nbK9LGhy0622dwSyqVvROwro9arjA2KOxffkfNR6RXDPMj22bEiOYOWH5o7O2AWk2+ct3VoXka9esoJ9deDMw7Kz73kmsva4rLADaDrzDzGP1+EmK1PBPwWZuUkkwTGI6jwkSmYckC9j5iopVlS+ZpS7wcpl6RD6tsYvNoaLxihlwm6iLtRdoW946GdVHN5/CYnc5kV8jvNdCPIKG3zuGnVLMXTMRBpPY+BQ5VmVBCmCAEnZbvzobIIQ1lxzQo51rp/p/d4AdTPQCi03bpS0C+xysq26wNFF6T0QrcSjkskEI8lMlp9KcqnjlOM8sluf6Ljv9H25twF044v6qSD6DYTY1W6x9OAzv6yBf05rBwpx/lTaAtUWtiw9NNNCzqaRxRWS0smUKi32exyTc54Ee5BGWV6SDMx3LKs9yBQx/8aKTHMuq/v2lk/rjuklu29h/gtbriD/z+GvPDyR5mK05GCdilpH8qqausPONuqrtSpRafNwlwNg8RjR8zzV54AlMZvjFSmno+cWSgxUN1b20kthiBHKLnBwXqZqojY0RjCHEgHKldmDxgN6/eK2foCGUYy+dX9Cv/zzFaG1Kpd8SwFuQ7aaUHFXjsqx9KCKM1DtS4dtKnj2nt1KBRo6PTyuBOz7GWejhkiJKu5zjnZiahnUAbMsqRPsLcDGAZ0QStoGFREtTUjonimlSqIG0yO1Ri/rPYP6tTpYAb1N+8
 hWsDlvFS
 ykbddJScUo3TY7dQgFWJT7mI/abFAfjFxqd4NwfG4oY7B68ESx8sBCddYClQCwJCGQGJ+vUFTwvIZGfNBv4nQVSO6k0AyJo2knoVvxL7j5gsTuFfEPU1IrkTsTy4aHHRRZDouKuhsiB7nwQ2fQLUEvmxOFpdZ3ZDUqBpyIX63cTQLvOEtuzGbNRpxkWqcxi+OtMYPY/Wj78HabGRUJCy8T+1U1jma6U2Lytb++doHW2/qoXMAjMU8nXaQLWyPOaruDbstNUXzqfXPAYs+Qw2IZntXq9fPcJ/5wk+Kp2pzvHftj/9Q95apqjjWpBzteKkRSgCrSEkBJCuCd8i7GOLRKPJfXb/3RIj0fBcC+sujcDlnqbdJ0BcZfYMf7kzLi+JdDom54wwY7kbmDI+Sn3BIs0MIn8MDDjSZEcLy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prepare for section-based vmemmap optimization by moving helpers that
follow-up changes will use. vmemmap_get_tail() will be called from the PTE
population path. section_nr_vmemmap_pages() will be made visible outside
the memory hotplug code and called from sparse_init_nid().

Move vmemmap_alloc_block_zero() together with vmemmap_get_tail(), since
the tail helper depends on it. Move section_nr_vmemmap_pages() earlier
into its own CONFIG_MEMORY_HOTPLUG block. That lets the later patch change
its visibility and callers without also moving the function body.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Keep the moved accounting helper on compound page order naming
  (suggested by David Hildenbrand)
- Collect Acked-by from Qi Zheng

v5:
- Move section_nr_vmemmap_pages() earlier under its own CONFIG_MEMORY_HOTPLUG
  block to avoid code movement in the later visibility change
- Reword the subject and commit message for the helper movement
- Collect Acked-by from Mike Rapoport

v2:
- Add this new patch to move vmemmap_get_tail() before PTE
  population (suggested by Mike Rapoport)
---
 mm/sparse-vmemmap.c | 134 +++++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 65 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index dea7179fbc90..e2a2a5eab4dc 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -148,6 +148,75 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const int order = pgmap ? pgmap->vmemmap_shift : section_compound_order(ms);
+	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
+	const unsigned long pages_per_compound = 1UL << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
+	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
+
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
+		return vmemmap_pages * nr_pages / pages_per_compound;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return vmemmap_pages;
+
+	return 0;
+}
+#endif
+
+static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+{
+	void *p = vmemmap_alloc_block(size, node);
+
+	if (!p)
+		return NULL;
+	memset(p, 0, size);
+
+	return p;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	struct page *p, *tail;
+	unsigned int idx;
+	int node = zone_to_nid(zone);
+
+	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
+		return NULL;
+	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+		return NULL;
+
+	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
+	tail = zone->vmemmap_tails[idx];
+	if (tail)
+		return tail;
+	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	if (!p)
+		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
+
+	tail = virt_to_page(p);
+	zone->vmemmap_tails[idx] = tail;
+
+	return tail;
+}
+#endif
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
@@ -181,17 +250,6 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 	return pte;
 }
 
-static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
-{
-	void *p = vmemmap_alloc_block(size, node);
-
-	if (!p)
-		return NULL;
-	memset(p, 0, size);
-
-	return p;
-}
-
 static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
@@ -323,33 +381,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	struct page *p, *tail;
-	unsigned int idx;
-	int node = zone_to_nid(zone);
-
-	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
-		return NULL;
-	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
-		return NULL;
-
-	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	tail = zone->vmemmap_tails[idx];
-	if (tail)
-		return tail;
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-	if (!p)
-		return NULL;
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
-
-	tail = virt_to_page(p);
-	zone->vmemmap_tails[idx] = tail;
-
-	return tail;
-}
-
 int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 				       unsigned int order, struct zone *zone,
 				       unsigned long headsize)
@@ -646,33 +677,6 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
-static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
-{
-	const struct mem_section *ms = __pfn_to_section(pfn);
-	const int order = pgmap ? pgmap->vmemmap_shift : section_compound_order(ms);
-	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
-	const unsigned long pages_per_compound = 1UL << order;
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
-	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
-
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
-		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
-
-	if (order < PFN_SECTION_SHIFT) {
-		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return vmemmap_pages * nr_pages / pages_per_compound;
-	}
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
-
-	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
-
-	return 0;
-}
-
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
-- 
2.54.0


