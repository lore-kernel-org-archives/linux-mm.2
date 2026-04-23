Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B08F589AE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A086B0099; Thu, 23 Apr 2026 08:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A215A6B009B; Thu, 23 Apr 2026 08:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937696B009D; Thu, 23 Apr 2026 08:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 857B26B0099
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:25:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33D781A014A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:50 +0000 (UTC)
X-FDA: 84689742060.17.F55EAD2
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 616F04000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TWDFXoxn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3yQ_qaQoKCOYUKTIXQVaSQOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--mclapinski.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3yQ_qaQoKCOYUKTIXQVaSQOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--mclapinski.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+Dh7KSlcp6Lw1KRHGg/D7cc8wD+JiYC9HaMh3gpNxs=;
	b=SrTHNisMs+msNmShNUcmRCrZ9TIDlG7egByLn3IegARxJG+D+hRgQz430u4Ubw320XQ2rk
	4VbeQ0ULB3TuxQ0yImJFbyq2zd90z0W/WCjUYHLZWOQ94DBcS7tjKOcX7u6BhtKzaRk3Gp
	uMhTvKW3Gu0f3+e8EX+gAompaDOWHJw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TWDFXoxn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3yQ_qaQoKCOYUKTIXQVaSQOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--mclapinski.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3yQ_qaQoKCOYUKTIXQVaSQOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--mclapinski.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947148; a=rsa-sha256;
	cv=none;
	b=mj6HiWMBhnsYRZWRlA1IooctbiJ/cr/bLf/xkYCRIWQw2GF8+OKZ6JHvq+WGB8jyYt++cs
	2/79E8dYhS9XjpiLIhNmsP1PukWC7L66Fi4CIisOKD1UtYSxQJTXEt0EgvAisNwns//rN1
	AZhrP6bRHcRqn+a2wEvw0X+dBDU2OJQ=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-ba47bfada67so587939266b.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776947146; x=1777551946; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+Dh7KSlcp6Lw1KRHGg/D7cc8wD+JiYC9HaMh3gpNxs=;
        b=TWDFXoxn6Kc+4OjCmdy4cPp8Rzz6cIvmg/GQdy2yifTAe4tHr9shAKd83o/9SmnCHn
         9nhGJCHiUevDB7iASIXfD4INb9p90kXCuRPhg6nmCdM5VkgU5L9sUEkTQI3FYkV0RjQY
         gbCL+NYMvu4f0cM/Z3/GD+jbkSxAAug5hLG6pnwTUf+k3HD+s77QYXmSF/kr9J/ffM5S
         23FofNY8qN+iJwIQ/85m9tVUFX/cxNRX6uMCSsj1L/+OvzZtgiOG+0xChLbbBG4S8L0a
         bPHWellaG4IUF40PZWooRVF3G2EbXC/S7vRI+dNOXvP5+a+SoYsiAqLX1n0NG9/sWrD0
         bwiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776947146; x=1777551946;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n+Dh7KSlcp6Lw1KRHGg/D7cc8wD+JiYC9HaMh3gpNxs=;
        b=JumRHuW0pWVcIMawLq7LzzTHx7Go/l2x/9Smqxpih88orLisOzXpq8rXQNCMDSVfEb
         SHRoMmiyDA+6x/59Z9Vo2zakF6LpSq5e+XC8102eaClTaEduF5ag5bqvcXLMCtqEM3iH
         BXL7bMgvDYiJFNpfmRGw2JJeHURgrlpicoUXuR46paHhptVO14iH7HDd144GSVzy+BCt
         Eac7/Gm1qW4QMC30lCpcuMrnkvEq5lrTa+XpPLPgENPG+IfC6/QcwyFVehQjTqBk+Duh
         kZZvqEUe52/KeWN3qFSdivJj3tyf3T/JXwaXzF2tQS8OrvlvCgcJyYjgfy98SMvV/Oa/
         mBTw==
X-Forwarded-Encrypted: i=1; AFNElJ9iOKbx6/dilVmxzONfjCIm/ufUCzoY+FVF0Gszcf6Uv/wyjxGPhsW919336zrrIxSr2UBBjMdXsw==@kvack.org
X-Gm-Message-State: AOJu0YywuWjDRN9vUuEVUm5p3rNCpfbqIszdzKV+IWBHCPG5RULQns2F
	tSSgU0745AWhuiQElb0FIrNFBvNB1CI1OAXDuy8kBIlNnfhkgtJXA4ScctJPEUPF4bEhWpRFG1c
	DYarpjoVBgY6zMuQjWdz6IA==
X-Received: from ejchd40.prod.google.com ([2002:a17:907:96a8:b0:b9c:3f30:f4d9])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:d03:b0:baa:2d37:cbf9 with SMTP id a640c23a62f3a-baa2d37ce1bmr465780066b.1.1776947145985;
 Thu, 23 Apr 2026 05:25:45 -0700 (PDT)
Date: Thu, 23 Apr 2026 14:25:36 +0200
In-Reply-To: <20260423122538.140993-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260423122538.140993-1-mclapinski@google.com>
X-Mailer: git-send-email 2.54.0.rc2.533.g4f5dca5207-goog
Message-ID: <20260423122538.140993-2-mclapinski@google.com>
Subject: [PATCH v9 1/3] kho: fix deferred initialization of scratch areas
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 616F04000C
X-Stat-Signature: 5zp49jqzzmu5sh18dmazht7zg5b9g8b7
X-HE-Tag: 1776947148-481032
X-HE-Meta: U2FsdGVkX1+GPBt8YiuuXG0KDesQ9cMfELfcCPfm4C65Ubb70LYxRBDh9BbvOSHaTWWPe9aFV5rm6pYIzwcEFcDOJCkeEIaq2K3cOS+wtfhXYt0/XgVED9mbTv1XtKh13VmvG5zFQHV1+cBhHtjxAMIFnn6+J9qDizd2dk7zi/iziRuRa5K+PmSiHrt5AwGaqnDCCV41INyNB9MqKNhmG13nseOG0fk/HC2RrmEGndYALSrRQ85AcFJb31YrpFga7AKelQYYax3psUAHkscgbqx+WNJOB6KlqoBPh5CfoMMRO6zhBURku/msW2SQl7fdq9/nv17qqcDMWE/mU1nZD1ZWx/U5JxxuK8KsqsyxdHIDMbdgaKN+ozg9XnjPrBbsumTa2YSVrE2QBUaESVgQ4qQNRskn2EQChY558WLwaqRt45Jls0PeMXK3RDDor45+D89TGdKl1a/n16Ara9lzhcXa0Ycu0hv7lEv1nqx9PrXC4m2vBk4pfwRuHl5RrHFtuWoYl4ddAI/R4ue+NKSByjIJqhS5UN8zzj6VYWCes7/qZhTToB1A8U82ySgP9WBE1xDSAbJSWS30Rb0DGX/G8HccyqACDcjhl+cjny+0OCweGlcMU+HI9zKUeJzu2MHJ8ARbfI17g4vPxeLFWH6DiOpbNpcQ/uZon/TsOo7G3WcuYi8xu4+0WgX64Q6GCqCfR9DVUuVmYrWo3uLfPWpMp+JGd3vGuG3qpVkUFg0QZWd1eh0Zj4QTwqbzNB0yUEC/FtWBKX0uEjC55Gc7eIL7ZkPpQ2Ix51FtgrsWT3UHkr2JCGFyW09CChu+hy0rZTXvN0Ee3W82bOS9n9L/xgwtyp3hmCQoPeYkfJsGFrUK8Sxk3fQN6OaqvJGDNcQrj0OVKagvdCLpZe+UL6MHSeCGSrQahIhosh8bGoxwnUSd1llnlrzyz/wD0DcmMixUsK9oMxDMEKQpE0OjOMCnhC4
 M3kjpmP2
 AGzHGpQY+0BvLPs0mju5/35A9QrneNKKtgCC8cTEb3D+njHnXm1Wdzm/RbhxV3MDqD1PBAhS5kqjeB+g32B7LiS0nElvqXJz2iWcy9021GdXs+3ePCKjAxTL3/w2PJQMU1UTD00Igm5OFP5z58WIrkIaT8Ya2SujboBFosan/9NsgsM3PZfVAGvDYbPCIkf/ED6XyHERPrZdiCxSdqdhfJK2PXwNhlKi8AUERVDDZq4xqnxNWoslcsgnpP7E5y3QhzhIPu9wyhj/VLP+SNc9ZZHYhtrNkT95DZSy0qEUeu3Js0rPtchZ6rj0ihf2Jeaw2I1zpnN2F8BPmtjpL6zHgPqzkI+dRRq+kHcZHKwR0/346vyzQEe0qcfosbyefo2nvWJcg6V3kaxiHbevvIR6UP8ij9Kcpqkqqv5RyyKySiXs8j3k6hp+wF3zTrXYA+wlQUM9NtQZRLluw9gnpDKOj09+Y4CyYySQmNHJ7t7ZVBc8Z7dRhep5TG0Lwdhaj995+FeL+iq4JzedT9ye0GuEqu+PdRU5p98rdEEhsaxRv+N4jzj7bCAW2yhbyhQ==
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
__init_page_from_nid() recognize KHO scratch regions and set
migratetype of pageblocks in those regions to MIGRATE_CMA.

Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
 include/linux/memblock.h           | 21 +++++++++--
 kernel/liveupdate/kexec_handover.c | 25 -------------
 mm/memblock.c                      | 56 ++++++++++++------------------
 mm/mm_init.c                       | 30 +++++++++-------
 4 files changed, 58 insertions(+), 74 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index b0f750d22a7b..5afcd99aa8c1 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -613,11 +613,28 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
-void memmap_init_kho_scratch_pages(void);
+bool memblock_is_kho_scratch_memory(phys_addr_t addr);
+
+static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
+						       enum migratetype mt)
+{
+	if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)))
+		return MIGRATE_CMA;
+	return mt;
+}
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
-static inline void memmap_init_kho_scratch_pages(void) {}
+static inline bool memblock_is_kho_scratch_memory(phys_addr_t addr)
+{
+	return false;
+}
+
+static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
+						       enum migratetype mt)
+{
+	return mt;
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
index a6a1c91e276d..01a962681726 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1026,40 +1026,6 @@ int __init_memblock memblock_physmem_add(phys_addr_t base, phys_addr_t size)
 }
 #endif
 
-#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
-__init void memblock_set_kho_scratch_only(void)
-{
-	kho_scratch_only = true;
-}
-
-__init void memblock_clear_kho_scratch_only(void)
-{
-	kho_scratch_only = false;
-}
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
-#endif
-
 /**
  * memblock_setclr_flag - set or clear flag for a memory region
  * @type: memblock type to set/clear flag for
@@ -2533,6 +2499,28 @@ int reserve_mem_release_by_name(const char *name)
 	return 1;
 }
 
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+__init void memblock_set_kho_scratch_only(void)
+{
+	kho_scratch_only = true;
+}
+
+__init void memblock_clear_kho_scratch_only(void)
+{
+	kho_scratch_only = false;
+}
+
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
 #ifdef CONFIG_KEXEC_HANDOVER
 
 static int __init reserved_mem_preserve(void)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..eddc0f03a779 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -692,9 +692,11 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid)
 	}
 	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
 
-	if (pageblock_aligned(pfn))
-		init_pageblock_migratetype(pfn_to_page(pfn), MIGRATE_MOVABLE,
-				false);
+	if (pageblock_aligned(pfn)) {
+		enum migratetype mt =
+			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
+		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
+	}
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
@@ -927,7 +929,8 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 static void __init memmap_init_zone_range(struct zone *zone,
 					  unsigned long start_pfn,
 					  unsigned long end_pfn,
-					  unsigned long *hole_pfn)
+					  unsigned long *hole_pfn,
+					  enum migratetype mt)
 {
 	unsigned long zone_start_pfn = zone->zone_start_pfn;
 	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
@@ -940,8 +943,7 @@ static void __init memmap_init_zone_range(struct zone *zone,
 		return;
 
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
-			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
-			  false);
+			  zone_end_pfn, MEMINIT_EARLY, NULL, mt, false);
 
 	if (*hole_pfn < start_pfn)
 		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
@@ -957,6 +959,8 @@ static void __init memmap_init(void)
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		struct pglist_data *node = NODE_DATA(nid);
+		enum migratetype mt =
+			kho_scratch_migratetype(start_pfn, MIGRATE_MOVABLE);
 
 		for (j = 0; j < MAX_NR_ZONES; j++) {
 			struct zone *zone = node->node_zones + j;
@@ -965,7 +969,7 @@ static void __init memmap_init(void)
 				continue;
 
 			memmap_init_zone_range(zone, start_pfn, end_pfn,
-					       &hole_pfn);
+					       &hole_pfn, mt);
 			zone_id = j;
 		}
 	}
@@ -1970,7 +1974,7 @@ unsigned long __init node_map_pfn_alignment(void)
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static void __init deferred_free_pages(unsigned long pfn,
-		unsigned long nr_pages)
+		unsigned long nr_pages, enum migratetype mt)
 {
 	struct page *page;
 	unsigned long i;
@@ -1983,8 +1987,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
 		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
-					false);
+			init_pageblock_migratetype(page + i, mt, false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -1994,8 +1997,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 
 	for (i = 0; i < nr_pages; i++, page++, pfn++) {
 		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
-					false);
+			init_pageblock_migratetype(page, mt, false);
 		__free_pages_core(page, 0, MEMINIT_EARLY);
 	}
 }
@@ -2053,6 +2055,8 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 	for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
 		unsigned long spfn = PFN_UP(start);
 		unsigned long epfn = PFN_DOWN(end);
+		enum migratetype mt =
+			kho_scratch_migratetype(spfn, MIGRATE_MOVABLE);
 
 		if (spfn >= end_pfn)
 			break;
@@ -2065,7 +2069,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 			unsigned long chunk_end = min(mo_pfn, epfn);
 
 			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
-			deferred_free_pages(spfn, chunk_end - spfn);
+			deferred_free_pages(spfn, chunk_end - spfn, mt);
 
 			spfn = chunk_end;
 
-- 
2.54.0.rc2.533.g4f5dca5207-goog


