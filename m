Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C081062896
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 12:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7E86B0089; Wed, 11 Mar 2026 08:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08D9E6B008A; Wed, 11 Mar 2026 08:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F416B008C; Wed, 11 Mar 2026 08:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4CB86B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:55:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 648081B6BB2
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:55:55 +0000 (UTC)
X-FDA: 84533779470.20.38F7B8F
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 98F4016000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:55:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vtIdYuI6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3V2axaQoKCD4rhqfunsxpnlttlqj.htrqnsz2-rrp0fhp.twl@flex--mclapinski.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3V2axaQoKCD4rhqfunsxpnlttlqj.htrqnsz2-rrp0fhp.twl@flex--mclapinski.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773233753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TW0km3bXDENe5wGoGb6FEEMiWhpRGEIF35PCM40YhbE=;
	b=X0twELYbCdIpvlopMv13l0zHUlMrSgBoxllHDoGcmeJw8l7SHQ+z6L3pSDkPbhQDnDhjBQ
	4QT7o3XCcQC5UP0RAQWO08LDSdIyw2WlA0COJRg3GcqDRlvRcL9X1uSEU7O4UT5S2H3HwM
	BJWXbEVE6JiFayDx+XGBVERVIIOothg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vtIdYuI6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3V2axaQoKCD4rhqfunsxpnlttlqj.htrqnsz2-rrp0fhp.twl@flex--mclapinski.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3V2axaQoKCD4rhqfunsxpnlttlqj.htrqnsz2-rrp0fhp.twl@flex--mclapinski.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773233753; a=rsa-sha256;
	cv=none;
	b=p8pzVFXTnZ3am9RMcPHMt/2Ufct6u2hJgbOeNma4Jsd9FDRSscEovf85yt62aeL5qLjlBO
	XwQaClnfWA3LNQGKXGzk8d0zlJSjl1awZ1u8eRxUIm1H7uxZ6x4CvnsSHVxs2kF9EwyKDq
	SfWSxX05UFWOPsWNwWTaYf33E8wGYzk=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b94e9ac2fbcso411165566b.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773233752; x=1773838552; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TW0km3bXDENe5wGoGb6FEEMiWhpRGEIF35PCM40YhbE=;
        b=vtIdYuI6noeLH6HDCnI+sj8wmZ1myBjRQZGjpwZzrAYnIbBO7tCxRPWTOA7tyrMlig
         EQOZYUQ3Iwcs0WFVucq5dtEM5KZA+UAV5PlXlvhq+JVcQXAAxBcHe47k06z7XNMA2pga
         tg06/n6tKPdBj1GvJHEALpUcidXZFphLlfgg8TSeth0dsLsWhgsVhAeawZh7xHdzfWBw
         mjR66/orKj9y5S31x513hIO1XS9i+UXZVQh7Axx7co2fhhH1CQUiAv76dj7Z+DCQooTQ
         614uDx4yKpoY1EfffI9vyQmF6qVCXxKVw8RcdzrC3OkAdNKxGNkNKXgLV3RKVjemweK8
         kPWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773233752; x=1773838552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TW0km3bXDENe5wGoGb6FEEMiWhpRGEIF35PCM40YhbE=;
        b=a1foRrZqyi2G/nI3TqCDY6FAC/hJBRTDUx/+hHOalL4MsBmIzmz1kyR9tGWd2uT8d+
         2iSH7/CbZNTuXzzGe998SIbYtimpyxTXkO1HkyP9jwEElVECxIAa4HxvgDGL7iZm3kDj
         HmVysUUTXMKzqe2RL+oarcmvVs61KpM1P/6Ztdyu8E10zbRwVx8kvPl02Q1cpE5bXyRz
         MhYGz9y7sL2jbVICTo865djlV2Cdrod42f7olA6H7N6Isa7MSlWR8VSH7WbWXYsPtpq4
         CBvVMmgVR9zO56zlHr87UdJv6+feWdbFFCjhRr9DHFsrcgClB/5cPF30yd5FOExl9vuy
         WFcw==
X-Forwarded-Encrypted: i=1; AJvYcCXo8SvmqKPoUzuegGDyVScVV1WqnJrZMOw9/SmqfLDAsXt1tJ4wTH6gqbYT+Zg5NqaGM5nHiGC3mA==@kvack.org
X-Gm-Message-State: AOJu0YyG8CPvadorAEJTc+aXVDxZMnB1OIyyT6dI0EKQTUNtIr2zGXEG
	dvY/Trgci6ntiYBlrkbrLhLbYPHfiifk4ecRqv8ihI2cOfcXLreNwPQ/ytaYfY3nei904aTyfop
	vvIfAYjKpw0kk4AxUY5PbXA==
X-Received: from edfg22-n1.prod.google.com ([2002:a05:6402:a256:10b0:65c:72cb:9cb6])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7286:b0:b88:5e32:5357 with SMTP id a640c23a62f3a-b972e5ae4e0mr140513666b.59.1773233751844;
 Wed, 11 Mar 2026 05:55:51 -0700 (PDT)
Date: Wed, 11 Mar 2026 13:55:38 +0100
In-Reply-To: <20260311125539.4123672-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260311125539.4123672-1-mclapinski@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260311125539.4123672-2-mclapinski@google.com>
Subject: [PATCH v6 1/2] kho: fix deferred init of kho scratch
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 98F4016000E
X-Stat-Signature: 4san8fhaf34sg7s8yqckpqcn8r4dxm8j
X-Rspam-User: 
X-HE-Tag: 1773233753-590917
X-HE-Meta: U2FsdGVkX1+jmoRsFuekcl0cOtIq439dpzUg/37noXtBtcRfst1cA3CZczPXir+IaOoTCrtWYK1SrIgMseDMO+RQcaJuFisKOcEeEz2sw6pnmLxooJnfNDn9eE8/IzKfi7hv+ZXp/W60MPW79AJ+IFRJ8jF7omKMBIiEDM3Jt9WnG61Cm3k56aVakhHdhrl01YjoKaNXdT+VDVJOpV/pU1oyddoZEowTOVoC0uFjs4NUz6/OB8obMndKYhZgfuoWeQv+na5D2NOJINEMCrB28hTB1mdvUA5q8tQooNcPO+7/2R/1RWYPdr0LmoQCP4CisBM7kTE2NSYErhi649KMJELEJ3no4Yvzi5lOKrHBf7TSp9GIWoJTb3zt/EVsJPJKjYKwk4RYwzoyZlQ4yAkkEqHvZNMeTr6YR8f7e+2hjYj3wEpsFvsRk+fclFiBHdKgZisGYfPyO8t1wbodwJGsTv8L/P2mjqRZ429JdYqHLflgfZQQDLAEWgrvBXJ0WUl/84QWs4HHneb2HsTY3O4YhbBV1ggsgsU1qHXpIisdNqBgG9cDSm4lAUr/4YdJw2m/MQiZb7u4vMe4JetJRcYVj4RsyHsEMPXDpWPlb4Gpi3A3enpXfv/1KrWUwE+O5vYtvo+vzPXM1bPKbG9lf6k2sYWgBQP/Luz0AQXIkZ8vo/TbiI0sadc1oDOL9wccbUY+ENS7F7SFjZ2hquA18MTnQkYQla3SuOHDw+utFl+XIwOCQRXYOuTnoal3dh78Cp+N0MbPwjCbKcicZLfwT2miTbJUR5fu/nSZYxPNMNeBpFj/6pJkpEr6tGCo/GZeEz2BIXAYKuQCdcY1ng0mtwS1QhEyWVv8vptjyHIVJ4UBm4HLjHzVAK5F7XXZPsDKqQeRrThgmMvt7fApVHGzwR0VTjkmoBfSy/l7mlMWWbRvkZfWrnJ20Z0EE2iPpH1quQhyMV7hlkQMoDugNtlrXQ6
 StRr0+yg
 nTN9Jc8tMmrEDWb9+Wvp4bVVuv50MaoTiJyzhBaeb3Rp3Y7Wat6N/9PpbNJyUPwfMAzPohA6oxBKfy1Ho4w15FmBNE4n+N462mXl7PGdkIZPBjYqTanLE7/f6qBIsdMFagTHiOZ5hxIxZA4X/aR/wCwLqlqZPc9sxAswSfnw10a8xICyZLuYmGwvFLX3vK/JbA81/Ce2s2tDMGtrbNiPZOpD1v7UqG7SUL2v3CmpBhze9z2S+IoXkxNt+GZY8wCOvYIvgsiYaGDKc5p1HmGa8Go9495ulQGw2uVNgSYdtHMAAKBNMzT/UpitxjSP7kJahBCwPbrVLBfgyRuU4rNQgxITKXlP/DPIk5B290kQezFKWY7rA2DN5dCrzgkKCuh9Ghyd+k8p4fEvicA5XRnuQaehy2ruja0a+Y8gRpVPIka0pHWnAbdCovCbb8VPnJig7jJ3slAfOV+Kfb14c3t+/cL94kg2Bge+1YnooHISlJOzi2bpn8dZRGeFXmV2a6GdkC8mJ5PabJGCqDMH+111oIPi3WpSnO2n1uQgg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, if DEFERRED is enabled, kho_release_scratch will initialize
the struct pages and set migratetype of kho scratch. Unless the whole
scratch fit below first_deferred_pfn, some of that will be overwritten
either by deferred_init_pages or memmap_init_reserved_pages.

To fix it, I initialize kho scratch early and modify every other
path to leave the scratch alone.

In detail:
1. Modify deferred_init_memmap_chunk to not initialize kho
scratch, since we already did that. Then, modify deferred_free_pages
to not set the migratetype. Also modify reserve_bootmem_region to skip
initializing kho scratch.

2. Since kho scratch is now not initialized by any other code, we have
to initialize it ourselves also on cold boot. On cold boot memblock
doesn't mark scratch as scratch, so we also have to modify the
initialization function to not use memblock regions.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
My previous idea of marking scratch as CMA late, after deferred struct
page init was done, was bad since allocations can be made before that
and if they land in kho scratch, they become unpreservable.
Such was the case with iommu page tables.
---
 include/linux/kexec_handover.h     |  6 +++++
 include/linux/memblock.h           |  2 --
 kernel/liveupdate/kexec_handover.c | 35 +++++++++++++++++++++++++++++-
 mm/memblock.c                      | 22 -------------------
 mm/mm_init.c                       | 17 ++++++++++-----
 5 files changed, 52 insertions(+), 30 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ac4129d1d741..612a6da6127a 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -35,6 +35,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *fdt);
 void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
+bool pfn_is_kho_scratch(unsigned long pfn);
 
 void kho_memory_init(void);
 
@@ -109,6 +110,11 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 	return -EOPNOTSUPP;
 }
 
+static inline bool pfn_is_kho_scratch(unsigned long pfn)
+{
+	return false;
+}
+
 static inline void kho_memory_init(void) { }
 
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 6ec5e9ac0699..3e217414e12d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -614,11 +614,9 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
-void memmap_init_kho_scratch_pages(void);
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
-static inline void memmap_init_kho_scratch_pages(void) {}
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 532f455c5d4f..09cb6660ade7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1327,6 +1327,23 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
+bool pfn_is_kho_scratch(unsigned long pfn)
+{
+	unsigned int i;
+	phys_addr_t scratch_start, scratch_end, phys = __pfn_to_phys(pfn);
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
+
+		if (scratch_start <= phys && phys < scratch_end)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(pfn_is_kho_scratch);
+
 static int __init kho_mem_retrieve(const void *fdt)
 {
 	struct kho_radix_tree tree;
@@ -1453,12 +1470,27 @@ static __init int kho_init(void)
 }
 fs_initcall(kho_init);
 
+static void __init kho_init_scratch_pages(void)
+{
+	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
+		return;
+
+	for (int i = 0; i < kho_scratch_cnt; i++) {
+		unsigned long pfn = PFN_DOWN(kho_scratch[i].addr);
+		unsigned long end_pfn = PFN_UP(kho_scratch[i].addr + kho_scratch[i].size);
+		int nid = early_pfn_to_nid(pfn);
+
+		for (; pfn < end_pfn; pfn++)
+			init_deferred_page(pfn, nid);
+	}
+}
+
 static void __init kho_release_scratch(void)
 {
 	phys_addr_t start, end;
 	u64 i;
 
-	memmap_init_kho_scratch_pages();
+	kho_init_scratch_pages();
 
 	/*
 	 * Mark scratch mem as CMA before we return it. That way we
@@ -1487,6 +1519,7 @@ void __init kho_memory_init(void)
 			kho_in.fdt_phys = 0;
 	} else {
 		kho_reserve_scratch();
+		kho_init_scratch_pages();
 	}
 }
 
diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..ae6a5af46bd7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_only(void)
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
-	 * reserve_bootmem_region()
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
-		for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
-			init_deferred_page(pfn, nid);
-	}
-}
 #endif
 
 /**
diff --git a/mm/mm_init.c b/mm/mm_init.c
index cec7bb758bdd..969048f9b320 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -798,7 +798,8 @@ void __meminit reserve_bootmem_region(phys_addr_t start,
 	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_deferred_page(pfn, nid);
+		if (!pfn_is_kho_scratch(pfn))
+			__init_deferred_page(pfn, nid);
 
 		/*
 		 * no need for atomic set_bit because the struct
@@ -2008,9 +2009,12 @@ static void __init deferred_free_pages(unsigned long pfn,
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
+		for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
+			if (pfn_is_kho_scratch(page_to_pfn(page + i)))
+				continue;
 			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
 					false);
+		}
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -2019,7 +2023,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
 	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
+		if (pageblock_aligned(pfn) && !pfn_is_kho_scratch(pfn))
 			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
 					false);
 		__free_pages_core(page, 0, MEMINIT_EARLY);
@@ -2090,9 +2094,11 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
 			unsigned long chunk_end = min(mo_pfn, epfn);
 
-			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
-			deferred_free_pages(spfn, chunk_end - spfn);
+			// KHO scratch is MAX_ORDER_NR_PAGES aligned.
+			if (!pfn_is_kho_scratch(spfn))
+				deferred_init_pages(zone, spfn, chunk_end);
 
+			deferred_free_pages(spfn, chunk_end - spfn);
 			spfn = chunk_end;
 
 			if (can_resched)
@@ -2100,6 +2106,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 			else
 				touch_nmi_watchdog();
 		}
+		nr_pages += epfn - spfn;
 	}
 
 	return nr_pages;
-- 
2.53.0.473.g4a7958ca14-goog


