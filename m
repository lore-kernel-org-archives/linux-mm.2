Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 619C0C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37E476B00A4; Thu, 10 Sep 2026 02:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355806B00A5; Thu, 10 Sep 2026 02:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293046B00A6; Thu, 10 Sep 2026 02:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 077146B00A4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E3E14043B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:55 +0000 (UTC)
X-FDA: 85196887230.15.3223A62
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id C5FAFC0007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cLjjywS3;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022033;
	b=llIQLvNE9doR7pEfUAav0swRfcQO8mb2ZNSB15sPpPOxIPDYzvWx/EhztpvQaD9Zc/MpO4
	hIyIKf4gmSx3maX8UcuEP/WaErm7K38mf2ZZMtx1emqP3/nS8UvADSKi68DH1eXYiE2Pgl
	lvGn+6MvmVxkfE/WETf3DkeGTLuTpsM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cLjjywS3;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fScr4mRCKk6xdGZOiQP1hnWEEEG9rl2EUQeAyvKGaqc=;
	b=zM+8AGrJxXM8WUf25Yvm2w4VWfcnm0d3QzoMsRUcTBR7gA/+fPYpOhWxDnRH7R7763xat/
	J/3ymDv0GYKZLjy4cbMPEnfcU+wTtc9IEM+mSPt0gpT2bMUbF+puA9l1B8d5p5dPzLujgg
	f04YxN6hEj1AIJ7mxb0OHkBGEF6oHI8=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-39b24d114d4so7341440a91.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022033; x=1789626833; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fScr4mRCKk6xdGZOiQP1hnWEEEG9rl2EUQeAyvKGaqc=;
        b=cLjjywS3IrXnBCtWJbAWipeXCzkuRPaeHdSSPLDa67pv4IOv2+xl/JhF7ZSXtfYsxs
         EzGtwTaTkKQHqKvtR4dpKn8V5eqsuTMb8H/NioAahXH6+k1t47fbC9fGBEtSddrtJP+V
         BlCLz04FYpcNKDtSWS+RVibn+67s4i9G7UuBZZQnYqg5xygXWJVMurz30MTpBgXI+ieJ
         jf54kmqQJbSQopbHpZwlRSaOSnc2emubtAOcVIBtGEopsPReKYoE7PXyk2Unx2vhEPfG
         9VnsXWjs5RIPIfzOeqnt6qtOP0jayM2qW36cubIp51igJbbugWBb3+IP6TBmzP54c3Qm
         wEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022033; x=1789626833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fScr4mRCKk6xdGZOiQP1hnWEEEG9rl2EUQeAyvKGaqc=;
        b=R/NsWTw8YHR5QyTr8KnGcRAyVtjzTbur8QLTOF+LHPyMohWXWWEzqJm4jr7p0LcVf+
         ndXvahWc/QQy3C2xU3ZfjgTrzi6ZHBPPbe+KBJs+XJFHpapEBeRq5ZhKLnl5yAmjD1E+
         33lsQFHq+Th/iWHlJX9erS2nKIv1s9/Qgco54MzNpY66Zi/DSSBl+gPQ2+YTvHNCQGFE
         nWY0P306wxwCGyZEDkOtjs0JV9FvNKV/0orlrJzLDPULoV3wiM7GrlS8uknxtN6owiU3
         2GRXPdXST/KEAbFM+spmLq/FVex2siL14AqbcdQrRhrd9Dp7vMOU4yi21XhI2V4yfzDM
         1JPw==
X-Forwarded-Encrypted: i=1; AKwUvBzEyMwO4OKyyr4Iw6/Vk1K2kf7eaxR8v/4VGHDgJGsE6VffDb8Ol5j5LeRu+0iCmQ8KmPL4fZYIBQ==@kvack.org
X-Gm-Message-State: AFuF++nP7o6rcY9nNuyEHzfGLLrLdgUutcC7xXvD4ggPR+hLNMT7N5DZ
	lKglwPHS0qFKCx0u8TEzfxELNE4/ZyrkIJoOIipjVSbtws7jC3mog1L4OvvGlZMcZaU+1lrUycB
	u7t8J
X-Gm-Gg: AYBFou2qOTaaIKfFRV/TuZc4McgLhp30g6jAeaGwvxDhZM/ypLiN8oj1AD/CKjKwHSH
	qcDrvMEsVGH5wTFoarWqzoOZZIXZcCzIDHg8VGaRPm+3ZLaErSuuxV+PvfGb2/apsWB6zcTT0Vr
	HpA9C7QQI6m9IbCAucr2/Bwd/reOFPJbham9fRvMuH+5n3RKV0lAYR9JiAbjHaSDURNQAF26+rK
	1+7tCtQdiuUOpj+OS8N9uG2NoJzECCMHYiuNaWmlGpwjS8v34VzHlOIo+7d8v/RbsTZBzVGon+s
	cnBrTqrTveIGU7zYIA+1wCwbyD/pDmEKxLlozrDgRFB+6JXkU8cxMGtbxKQ7R+f6OT1KVjqKJ1V
	2H3lU97a+9GlzLPhp/BNWKBUThg7rJUNEq+4s5aH5t34QLZ9/qWL0K7V/rtyaYz5gzK002iUIR8
	0mY/Z2vEGjYOJjMBt0ykXgWXWX7gAZwQw+4YZzpIcNnOi2ii5u7QqSuLtEJr0iFSeZkvHuj55+k
	X4toFXL6wW7zHmVIo2C1+wWAl0cPYbBhClgBZ5VbqKQ7A==
X-Received: by 2002:a17:90b:50cc:b0:396:65dd:4093 with SMTP id 98e67ed59e1d1-39b26202ebamr61815629a91.14.1789022032532;
        Wed, 09 Sep 2026 23:33:52 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:33:52 -0700 (PDT)
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
Subject: [PATCH v6 08/17] mm/sparse-vmemmap: support section-based vmemmap optimization
Date: Thu, 10 Sep 2026 14:32:47 +0800
Message-ID: <20260910063256.64386-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C5FAFC0007
X-Stat-Signature: zjm4n4qmi3g5e34y8r87m36afsytwc3d
X-HE-Tag: 1789022033-47042
X-HE-Meta: U2FsdGVkX18ZaMLDHhTTaTXcmTih/RLJLan6cJ2bdwHzBg8oq1QDddoyEozRddlbszCkb8ODO4qohYCdSMa8b217+b9gB/uy2omfu4YZjBNI4PHwdDWy3/x1q/ceQc/8TrxkDddC+HYxXVBIMY85LReE4+8Bu0jJC0X2MP3FIPOP/aQrn76UWF0D89a+EMjpK9F34qMgHZeqDjWMo514ZL0L46UJ2tBCbT+Ja2yc7+GXSWKRvPTd+j2tTa4Qd8tSse5YnAD9FlG+/ghgPFfRk5zNN4AC2D4NpaB0ZWLXKVdMSnKGtBYvydcnnNdekjEFat+SclTWYZZ9Xz4qdW9AsHWH4a+aLBCa3WITE2BPg4YZLOa09KYG27sIM191kMiimi50PR5Gbjj8zeQMr/M//mdWOibI8O8+XKnSzc33PDebqadu0tJzO2HiWbMuBfiJ/HWuPMzfjrGsdbVP4zFxK0j5Eptr0sGb2G43eLjzoftzYfcLqdXCrYZsKsPzFwaKyLKXisN2gu5mb6uLr7bHjdpDhsoPPG9Jmzkitq3tvcYjx1s7aazVpgF3joboK0J7gX7nbWac5n1Fk5+NYmdicEvYPQu49Fb8NcBXMi71QPcAU9fV8iFHXM9T2IrZIAkxmtvWJMh4DimAOZwag841sqk3d7wI1AC+sq98edVuxVk5UdnzNWr4a5q8IM3GIkL82Bi/TtdKrJPhShPMRlwnDvz8uHBE98/JwOBvxxzt/N2u26oJGfchCUs9QXykxtauDLOWtvgNJqsJfAS4rPUd5wgTaGNy9ibjWberkfHSYndvvKZQJOj7lOorUa+CP8oYZcYJixmCWenfGnxBhpbdAihu037lsrhhbKolvFQgiZ0EDSpdHEOuSv+/HLAwK8rWPgGFa6OTSjV8zYGkTzKlvSA3ZScRx0pbtsrsAefHaBuCzGnW6KznhUtoL7r8aTi4KjGuESM7dmbBUY4Ps78
 oSch7fFJ
 0Kna5Csrul2wHKDOICjzUb6pbmADTGcYC+PFwrL0PBSHuszhrAYPLdbxX+mUgdWb+YmeYqMykn22gjEGFTdRMfC3QMl8WGd85+kYBcIqoIs+sSAO/l6SwyN8GVf6d+uDDJ97H04425gwZ7Q0fMZR4GRy/3CGjzzTYCy7NKJXbB7dFDXHRTuweTVC2+2rrKrPL9XoC+2mxg5uUPsbWyDNM4E1mfJBh/bp62GCIYrDYJqqLiXzFQFCWoM2IFEmsVM9FLaNO6VuWS6O3RdquTePjbpeO0tVokvTROW/09r2SWSRhDEfSBgrvzVun3596B1mSy4ybN9XCBm2ma4alN7GCXFU5QIRPrI7V2Td8hRoAeVemfbGonP/xplyCCLoFNW9Ai5a23FLOESfwPEJ+USd/L9VofcxFwB+4W6QQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach sparse-vmemmap population code to use the compound page order
when deciding whether a vmemmap page can be optimized.

With this information, the common sparse-vmemmap population path can
allocate or reuse shared tail vmemmap pages directly instead of relying
on HugeTLB-specific handling.

This centralizes vmemmap optimization logic in the sparse-vmemmap code,
based on section metadata, and prepares for sharing the same mechanism
across different users of vmemmap optimization, including HugeTLB and
DAX.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Use the compound page order helper in the population path
  (suggested by David Hildenbrand)
- Collect Acked-by from Mike Rapoport and Qi Zheng

v5:
- Add vmemmap_alloc_pte() to keep PTE allocation handling clearer
  (suggested by Mike Rapoport)
- Move preparatory section_nr_vmemmap_pages() changes to the previous
  patch (suggested by Mike Rapoport)

v4:
- Move section_nr_vmemmap_pages() outside CONFIG_MEMORY_HOTPLUG to
  fix CONFIG_MEMORY_HOTPLUG=n builds (reported by kernel test robot)

v2:
- Keep vmemmap accounting and population logic in sparse-vmemmap.c
  (suggested by Mike Rapoport)
- Move vmemmap_get_tail() before its first use instead of adding only a
  forward declaration in the previous patch (suggested by Mike Rapoport)
- Simplify the PMD path handling for HVO-covered sections
---
 mm/sparse-vmemmap.c | 46 +++++++++++++++++++++++++++++++++++++--------
 mm/sparse.c         |  4 ++--
 mm/sparse.h         |  7 +++++++
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e2a2a5eab4dc..faebf344cdac 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -148,8 +148,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
@@ -175,7 +174,6 @@ static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long n
 
 	return 0;
 }
-#endif
 
 static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 {
@@ -215,19 +213,44 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 
 	return tail;
 }
+#else
+static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	return NULL;
+}
 #endif
 
+static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
+					 struct vmem_altmap *altmap)
+{
+	struct zone *zone;
+	struct page *page;
+	const unsigned int order = pfn_to_section_compound_order(pfn);
+
+	if (!vmemmap_optimizable_pfn(pfn))
+		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+
+	zone = pfn_to_zone(pfn, node);
+	page = vmemmap_get_tail(order, zone);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
+	unsigned long pfn = page_to_pfn((struct page *)addr);
+
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
-		void *p;
 
 		if (ptpfn == (unsigned long)-1) {
-			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+
 			if (!p)
 				return NULL;
 			ptpfn = PHYS_PFN(__pa(p));
@@ -246,7 +269,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
-	}
+	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
+		return NULL;
 	return pte;
 }
 
@@ -435,6 +459,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	pmd_t *pmd;
 
 	for (addr = start; addr < end; addr = next) {
+		unsigned long pfn = page_to_pfn((struct page *)addr);
+		const struct mem_section *ms = __pfn_to_section(pfn);
+
 		next = pmd_addr_end(addr, end);
 
 		pgd = vmemmap_pgd_populate(addr, node);
@@ -450,7 +477,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(pmdp_get(pmd))) {
+		if (pmd_none(pmdp_get(pmd)) && !section_vmemmap_optimizable(ms)) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
@@ -468,8 +495,11 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 				 */
 				return -ENOMEM;
 			}
-		} else if (vmemmap_check_pmd(pmd, node, addr, next))
+		} else if (vmemmap_check_pmd(pmd, node, addr, next)) {
+			if (WARN_ON_ONCE(section_vmemmap_optimizable(ms)))
+				return -EOPNOTSUPP;
 			continue;
+		}
 		if (vmemmap_populate_basepages(addr, next, node, altmap))
 			return -ENOMEM;
 	}
diff --git a/mm/sparse.c b/mm/sparse.c
index c84b4c7b8c70..e6cb67ca9c8d 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -305,8 +305,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 							nid, NULL, NULL);
 			if (!map)
 				panic("Failed to allocate memmap for section %lu\n", pnum);
-			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-							   PAGE_SIZE));
+			memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+								       NULL, NULL));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
diff --git a/mm/sparse.h b/mm/sparse.h
index 563fc1f4d717..74dd79c51e75 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -111,8 +111,15 @@ static inline void sparse_init(void) {}
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #else
 static inline void sparse_init_subsection_map(void) {}
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 #endif /* __MM_SPARSE_H */
-- 
2.54.0


