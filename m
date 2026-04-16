Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123F7F8A157
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 11:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED8A6B0089; Thu, 16 Apr 2026 07:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5106B008A; Thu, 16 Apr 2026 07:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC146B008C; Thu, 16 Apr 2026 07:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8B36B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:07:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D998EC29D2
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:07:07 +0000 (UTC)
X-FDA: 84664142094.22.2243CC3
Received: from mail-lf1-f73.google.com (mail-lf1-f73.google.com [209.85.167.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 02A39100007
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:07:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TbgksF0j;
	spf=pass (imf14.hostedemail.com: domain of 318LgaQoKCDYeUdShafkcaYggYdW.Ugedafmp-eecnSUc.gjY@flex--mclapinski.bounces.google.com designates 209.85.167.73 as permitted sender) smtp.mailfrom=318LgaQoKCDYeUdShafkcaYggYdW.Ugedafmp-eecnSUc.gjY@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776337626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5dV2LMJtAOOBBBsjxKBUavRi9Ccqee2XzO+Iu2tpbA=;
	b=KoeixAj1JqU22JlVMRZOrh++weEkPg25J/HgVtzUDkkAM92VTiYu7WVHSiuGOPeX3kGtJU
	7EzYxTlYYU4E+OIJXfUXDCZNdrs/atmbBAGhafFTu4P2j7wfbFb3nv/c2Ckqh/qRxBiCK+
	nIsUoS8qRrZt3SK1E/IfF8SnS3aDyRI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TbgksF0j;
	spf=pass (imf14.hostedemail.com: domain of 318LgaQoKCDYeUdShafkcaYggYdW.Ugedafmp-eecnSUc.gjY@flex--mclapinski.bounces.google.com designates 209.85.167.73 as permitted sender) smtp.mailfrom=318LgaQoKCDYeUdShafkcaYggYdW.Ugedafmp-eecnSUc.gjY@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776337626; a=rsa-sha256;
	cv=none;
	b=tdTTqEABT0kVjm8Wcq85YEMbwpWyFl1PtkLC/QquVFnv2Dq3XPSqOEY875H8drcAPc1hR1
	R+SN2DxZ3lThcW0NoLpluHHrKfSBzKEjfrns+mZ0rO41UvlVF0+kt82K3b0V50CMp0AMak
	gE96i+L8il5vMidl3BT+CGVPov0ow8Y=
Received: by mail-lf1-f73.google.com with SMTP id 2adb3069b0e04-5a406666270so2068073e87.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776337624; x=1776942424; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v5dV2LMJtAOOBBBsjxKBUavRi9Ccqee2XzO+Iu2tpbA=;
        b=TbgksF0j2yTCo+nQqYAXAXhVgRVkAHbmJa39v5lavfOHidnC+VKDD8mCmG/Z4V+xWv
         WyjBa6sccPTpxsYvDOiIFHNmwD+sW7M3rFYWI7WfpmWMpFdT87gFfKTMmddZzjobJlSl
         PrSE1s98mtrcN2zmAX2IrmYtWtz2Tu/iLbh7jVMTgEF/zsIiQjR1Kn3fx5Gs60Np87l/
         2ZAbKi9efcVi6LE63oOwVX1GJKDvDi2a0aiU4A2X0b1R6MscFTkhfaUOdvvGjhQwn9W4
         JaKw6kCpaiHO84e00g4pjIz/lDrb488JUpywnIKX20PXo2mdLhM1Bd7ZvRcphcyLs+AP
         v35A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776337624; x=1776942424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v5dV2LMJtAOOBBBsjxKBUavRi9Ccqee2XzO+Iu2tpbA=;
        b=gDPIggjyngA/pG/2ffRlvIzN30wd39u8mYoe7B6/hPIWEKKpzPFbSvprVowjHC81YQ
         C2Ysf32Dc1SksJBDeaySMOKzRSSknpAYrMfj2XYJ2ULRoJX/4wVLE4FK4E62yfSyPalG
         p/LRTwCDrVkj5i/YS2T83/KCzlP4KQ8qG71jZ4B26uv9NMhqeKFU9vdb3rgx/aNI2qHW
         kf9KeAgYfUwnODA1Hhm7VKkc7/WpSPi5NoZpoW9pTx1CQLTcDFeWSnsZcIotf0tIm4LN
         tL4PVGa8eCWBAEqHVf1BGcRRmEgnqnPDZatvfBHRoqPIk+aJPCnNq6jNKHfw+PXY1CA9
         K1cg==
X-Forwarded-Encrypted: i=1; AFNElJ+nSVNoRKj5hv/EgRWR4mJBWISc+fjj0UFASVr4QsW4cwwaXOHNyjXw6iwkneVauG16gvgaGF3zLA==@kvack.org
X-Gm-Message-State: AOJu0Yy+UE7eifjI8qpapSA4H1a/JdMUzB5LQGs8+Y2ZrzU++eGiTruU
	I6YNlwRZU163Lugby1ku6zyTUxxjZ8boJKLdsVHrm2SZhjJsQYU1p1WoBVtOvcd7hwQdCRoKmNf
	W3ct0RUpA38WsIoa/takB4Q==
X-Received: from lfe15.prod.google.com ([2002:a05:6512:290f:b0:5a4:5d8:6190])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6512:2252:b0:5a4:d21:de07 with SMTP id 2adb3069b0e04-5a40d21de29mr1675847e87.1.1776337623788;
 Thu, 16 Apr 2026 04:07:03 -0700 (PDT)
Date: Thu, 16 Apr 2026 13:06:53 +0200
In-Reply-To: <20260416110654.247398-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260416110654.247398-1-mclapinski@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260416110654.247398-2-mclapinski@google.com>
Subject: [PATCH v8 1/2] kho: fix deferred initialization of scratch areas
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bddcnexs3mftw6719j9opqk9isfbpjei
X-Rspamd-Queue-Id: 02A39100007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776337625-358699
X-HE-Meta: U2FsdGVkX1+ojyQXxi1MTbMMWCorHVzPwQ/SpYqpJoXlGtNluVV0gfg4k9lBKLGhRZ77gooFcRM3Kg6qS8yxNVmY0GNxMWvTlv/8uKoPJWOBS970V/ikfVb70c8Je6+MAPEZBse54r5WH8O7KsqyEcUcOvwrVjVn6dqK/GvNJE3VsPiBcKBSgIcL5WOPyrDSDrBOd+AlvtzKIRhss9i/ubrtkcuB2UT2hvJtYXQXQb5/FGK5ZeydlS1xE66YQABec325HHrm32aLWzcLIBz9GB9yJo42B0x01OHGMc0tAxs1U08z17ldTG1cXjj+HDFrV5eH64/U4xxCyx5LucGSC3W8kyfVd/rRorPE27SIRvjjIW0n9F9aBU7tJ4RjvDO9K7JwMdXqefJvvsrRwUMvjBNTliVwSXH+RWEavt+u/iV9Mco3IHoVfOdgVFELn4Ee+F4cTzLkVqx1wI0RL/ERLW0/m80JD96MSsn0UmhzeJw1OqmysBuEroKCxAx11+hKTx6AORoWAbCMDQIWcvALg70dYxCQZhEyJVHjnwTjBWzVms8bUFa8vMVw4L27CIoFxJErnMauYCgYIv15EJJip2EEl5O5gFCi91rGoonQ+RHizH66yAi4Sm1SkQMIgdimCxaAgSwCHL2SUQBuRU0B3ZdNLcv87gLxkvnh3rygLxore8cYsXCoIFCgNASYxdkZqVSu3vKtFFthCDBb/TegNO5cLcrda1Dc7QANeQn9a9auAgVQPEOJAa3V0Ugtiu1WqzniauOXJ2Jg6ufXKvKcIe1ri4dMDozu647GRNtL6Af5bWMZpUFZfsRZJqpbvkRPnXrJw5LhFKUaEHCyuZFVGLGkXSVyBFsoEGjkPPHKEKi4QWVeNN9JEGYHvnOzeiUIZNMKZGKsmcUSvlcAh1dxNN44n0+WOFa/jJuT/MXzxsccdbfH3ar1td8+YlWwPVZaEzk0vSvFBVyD063Jl8l
 pOogL2Yc
 Qb7eRGl9CtdQREiO6XYgiEL3GyWVGFrqB5/fJyTZjWOhb0GD9eM2piILbTZhJItfogFgQcbU9PajvMM8lBm9EfoYT+0Qd5Qz34piD1cJQy9qjLrWOZLFm+l2BrXA232FYDUxtqIoxbhoAU+QblWu8tHaR9xr2I1MEGw5ppE+OBDAfMAq+8at3mM7dDasfoUsD3xsu22dmIbY0BrGX2Jp9eHRH8nEuIhRxA7/euyz1tRs85XiGqWg2D5Gvjj/vNEmBj+e7E4Ipshh/pIp1zj8bde0liZwApLFC2Ww2U0ZaPktTJ61XBtcGT2b7yIGC7/Zk/Q2vB7gvC3HrOu+RhuXaiY96jvy8LHAkMdls6j3eKV4klmz+yqcciLXdDaxmtg6U8tCu2z0El9lGaAu1XGCAcX/bh9NqtPlFyPO2Lfevf+/JiPz1Jk3sNyOmSd53X4vB6aBAY9giKr7X+XZcu3KzAbcxfWb93K4O4McTP+gnvRCsKYcNH+AxCu88me+pmbTdhqZobxPNqSRxXtUNAt89rPAsGhkHX4BWsNO7hn0rYlQAad1+mwE+Ldn50A5nr/rFdo3ilR6S64TPW4NUd8Nb5Xu69XV2Aga/lPIQ0+MqTwLsLv0k0tuOCFDWLAY4zz4BSJjI/zjvD6TnhgYnEkDU4/+EannNeDdUPKK3gXHXRBsFWyW+01PlvV5AqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled,
kho_release_scratch() will initialize the struct pages and set migratetype
of KHO scratch. Unless the whole scratch fits below first_deferred_pfn,
some of that will be overwritten either by deferred_init_pages() or
memmap_init_reserved_range().

To fix it, make memmap_init_range(), deferred_init_memmap_chunk() and
memmap_init_reserved_range() recognize KHO scratch regions and set
migratetype of pageblocks in those regions to MIGRATE_CMA.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/memblock.h           |  7 +++--
 kernel/liveupdate/kexec_handover.c | 25 ------------------
 mm/memblock.c                      | 41 ++++++++++++++----------------
 mm/mm_init.c                       | 27 ++++++++++++++------
 4 files changed, 43 insertions(+), 57 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 6ec5e9ac0699..410f2a399691 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -614,11 +614,14 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
-void memmap_init_kho_scratch_pages(void);
+bool memblock_is_kho_scratch_memory(phys_addr_t addr);
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
-static inline void memmap_init_kho_scratch_pages(void) {}
+static inline bool memblock_is_kho_scratch_memory(phys_addr_t addr)
+{
+	return false;
+}
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 18509d8082ea..a507366a2cf9 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1576,35 +1576,10 @@ static __init int kho_init(void)
 }
 fs_initcall(kho_init);
 
-static void __init kho_release_scratch(void)
-{
-	phys_addr_t start, end;
-	u64 i;
-
-	memmap_init_kho_scratch_pages();
-
-	/*
-	 * Mark scratch mem as CMA before we return it. That way we
-	 * ensure that no kernel allocations happen on it. That means
-	 * we can reuse it as scratch memory again later.
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
-		ulong start_pfn = pageblock_start_pfn(PFN_DOWN(start));
-		ulong end_pfn = pageblock_align(PFN_UP(end));
-		ulong pfn;
-
-		for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages)
-			init_pageblock_migratetype(pfn_to_page(pfn),
-						   MIGRATE_CMA, false);
-	}
-}
-
 void __init kho_memory_init(void)
 {
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
-		kho_release_scratch();
 
 		if (kho_mem_retrieve(kho_get_fdt()))
 			kho_in.fdt_phys = 0;
diff --git a/mm/memblock.c b/mm/memblock.c
index 4224fdaa8918..fab234f732c3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -17,6 +17,7 @@
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
+#include <linux/page-isolation.h>
 
 #ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
@@ -959,28 +960,6 @@ __init void memblock_clear_kho_scratch_only(void)
 {
 	kho_scratch_only = false;
 }
-
-__init void memmap_init_kho_scratch_pages(void)
-{
-	phys_addr_t start, end;
-	unsigned long pfn;
-	int nid;
-	u64 i;
-
-	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
-		return;
-
-	/*
-	 * Initialize struct pages for free scratch memory.
-	 * The struct pages for reserved scratch memory will be set up in
-	 * memmap_init_reserved_pages()
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
-		for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
-			init_deferred_page(pfn, nid);
-	}
-}
 #endif
 
 /**
@@ -1971,6 +1950,18 @@ bool __init_memblock memblock_is_map_memory(phys_addr_t addr)
 	return !memblock_is_nomap(&memblock.memory.regions[i]);
 }
 
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+bool __init_memblock memblock_is_kho_scratch_memory(phys_addr_t addr)
+{
+	int i = memblock_search(&memblock.memory, addr);
+
+	if (i == -1)
+		return false;
+
+	return memblock_is_kho_scratch(&memblock.memory.regions[i]);
+}
+#endif
+
 int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
 			 unsigned long *start_pfn, unsigned long *end_pfn)
 {
@@ -2262,6 +2253,12 @@ static void __init memmap_init_reserved_range(phys_addr_t start,
 		 * access it yet.
 		 */
 		__SetPageReserved(page);
+
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+		if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
+		    pageblock_aligned(pfn))
+			init_pageblock_migratetype(page, MIGRATE_CMA, false);
+#endif
 	}
 }
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..890c3ae21ba0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -916,8 +916,15 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		 * over the place during system boot.
 		 */
 		if (pageblock_aligned(pfn)) {
-			init_pageblock_migratetype(page, migratetype,
-					isolate_pageblock);
+			int mt = migratetype;
+
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+			if (memblock_is_kho_scratch_memory(page_to_phys(page)))
+				mt = MIGRATE_CMA;
+#endif
+
+			init_pageblock_migratetype(page, mt,
+						   isolate_pageblock);
 			cond_resched();
 		}
 		pfn++;
@@ -1970,7 +1977,7 @@ unsigned long __init node_map_pfn_alignment(void)
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static void __init deferred_free_pages(unsigned long pfn,
-		unsigned long nr_pages)
+		unsigned long nr_pages, enum migratetype mt)
 {
 	struct page *page;
 	unsigned long i;
@@ -1983,8 +1990,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
 		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
-					false);
+			init_pageblock_migratetype(page + i, mt, false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -1994,8 +2000,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 
 	for (i = 0; i < nr_pages; i++, page++, pfn++) {
 		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
-					false);
+			init_pageblock_migratetype(page, mt, false);
 		__free_pages_core(page, 0, MEMINIT_EARLY);
 	}
 }
@@ -2051,6 +2056,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 	u64 i = 0;
 
 	for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
+		enum migratetype mt = MIGRATE_MOVABLE;
 		unsigned long spfn = PFN_UP(start);
 		unsigned long epfn = PFN_DOWN(end);
 
@@ -2060,12 +2066,17 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 		spfn = max(spfn, start_pfn);
 		epfn = min(epfn, end_pfn);
 
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+		if (memblock_is_kho_scratch_memory(PFN_PHYS(spfn)))
+			mt = MIGRATE_CMA;
+#endif
+
 		while (spfn < epfn) {
 			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
 			unsigned long chunk_end = min(mo_pfn, epfn);
 
 			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
-			deferred_free_pages(spfn, chunk_end - spfn);
+			deferred_free_pages(spfn, chunk_end - spfn, mt);
 
 			spfn = chunk_end;
 
-- 
2.54.0.rc1.555.g9c883467ad-goog


