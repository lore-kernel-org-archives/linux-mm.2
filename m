Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 605A2C5DF87
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF996B00AF; Wed, 19 Aug 2026 05:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C71E6B00B0; Wed, 19 Aug 2026 05:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619D16B00B1; Wed, 19 Aug 2026 05:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 338C76B00AF
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B75CEA04D4
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:46 +0000 (UTC)
X-FDA: 85117557252.25.1361940
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id EF37C180006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="JRRW/Wl7";
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133224;
	b=6/gSDRNlMIyArCr/Wtb+FQUwzT96PpAgj/DBqZDxrdF7M3ExBgJtjPMAK+Qmd5DgKsK9sv
	5cD7eULqj7Et1FLXL2u8XfpIInnNkXMNqKGy3Gezoj8IQJr97xMXtJG14cPZiIyOf3FrFj
	1V753vHf8QZCePL25gpAb3m/hHzmm/8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="JRRW/Wl7";
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/kRQ1gy7AyeNmujGKY3KUegeF2WIa8rEbuBkgyiams=;
	b=TTNVBxoItFEiCxLUIH0EtsHGqJMY9m1srCbJLCZ2WDfFfbgLcRla1IjEI99ukEibfnC2QA
	3UwQxsmQyvMjz9BGbIsYsfH1jwh4LwvnIJa+0uANNxwpBWliOKY7KFyz1SEZmECv9Tjm+E
	So8yxAhJt+/jY7/xkwCWGEaIvvTMdwY=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so9079425ad.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133224; x=1787738024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8/kRQ1gy7AyeNmujGKY3KUegeF2WIa8rEbuBkgyiams=;
        b=JRRW/Wl7U1u1M8ilBkEe/WtiwcgqLn7nrKjLmARmBKripZasBeCZg7ZSPiQM5kDo4d
         tcyVoIJdQJ+d5U5EVEhN/7ayxhDuLUMaezeWnFXSxIVLz2EgtGqdD9A/D/gs2P6KJ42u
         s4DwYt1vH10QIqqHkWgPFTrD3SpbR7EkOhpHBKdKruv1zKRx6nSOcGjATSWz9peLuW9M
         daVdznYc+58IhWEsKiioOUGQ4wIpW/PXQux5eys2GqrLF0dv2dp+CXoyuSWoxMLlBVBv
         tGn2el+2faVq+Pz6Xjbta2KllDSdvspMoTNGhCKjOc79QhQrALKJeG1Sj1shlt6uc8b5
         Ji3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133224; x=1787738024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8/kRQ1gy7AyeNmujGKY3KUegeF2WIa8rEbuBkgyiams=;
        b=LK/sCyHWV8QLfItMqL9L/simd0imVYIv8H3uL/xDXmUPsWhAAgF3syjG1E8lcPjZx5
         WZxKLknyRjLEdHJplyNUG9pDR7sPFQSDb5Fmgoe4lK8x157pE3CgSZh2z7gfG4FCrFMv
         BRr0DguT4QMSMi8eqngJktHSlNqS5EaXcyYrxtFYIeiy12PvXQkzPmSPSue986EqGFD+
         GUlXmMrpIv2uz+Kr8a+pq+yzMJ/1oV6JyOFEV4O+ILtTLctKFZpOTue9Emuot7uaLTMl
         1ghooG234CzdgaiWStaUBmQKVdLLSEOu4totXI/fZnrEg/lQfdO+1Yu2uBzvkJBbtmzm
         o3hQ==
X-Forwarded-Encrypted: i=1; AHgh+Rql4RqLf7vsDfb9yr7KqhAsOYIpAtGcyItzbFjv3c4dSnvHVB0zub24XkTlENteYiqoSytbdOsFvw==@kvack.org
X-Gm-Message-State: AOJu0Yw1Y+NO7/78lbZPZkTGGaHROfIutoFlVZu/v5waFEr/EXd/or5z
	AmfXg7J6Y1BhTkjCZh6LD5sJbmQvEDeLguXM/WnoWNknlr73qAkP9BU2o09hSaL5bpY=
X-Gm-Gg: AR+sD11G2rwIQeGf6g79+XlmeIukU8Yo+MVcySn2UgVoSsUFQqwyIQ/8NfC8/ggzXcV
	9iRrZ3esYdDdd47J99YdTfEhey4MJErFU6b5c1qGSmRhftHRDhKYBw4O1CquEwea9GQp6gQoqii
	4f3BCc8YKh7S3MRd2VJ9Yle+1ThGRDKt+7Q5ApTHL4856tjxOCPRNzBH4ydtfFCWa27Q4bzdu1q
	WvOalZIWQLA9YzT6xSdutT1HFtVn6LZ6JnqgreoNKwZtWrh/0qUr23Gl8Hs/bmcINMDi8LyIDo5
	SRRGX40MhIILDjQVjwYvvzP1udw85rtFdrjtwq3zVE3qNjjUY0r/fKyw4Hs/frb9rmqqKwVOrGt
	82uKjIy+jfi9LjOQZynxkohVJYZtWj7rsRB8NEKhbYrrVBQTHzzsXCAWOQvBjuaA0PoEvchquMr
	RBhuRS7ERVqlOVvHcIZUSUVGtjtYzo8c0MRLKZnPmNyL52VZ6kvAEMqbd6Wwv4YDSgVLfZptjCB
	J2k8QBYYmSmuMa0YgwwZ78FjQ==
X-Received: by 2002:a17:903:17c5:b0:2d5:e3ce:3988 with SMTP id d9443c01a7336-2d5fd74019dmr65164905ad.11.1787133223772;
        Wed, 19 Aug 2026 02:53:43 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:43 -0700 (PDT)
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 11/17] mm/sparse-vmemmap: remove SPARSEMEM_VMEMMAP_PREINIT support
Date: Wed, 19 Aug 2026 17:51:33 +0800
Message-ID: <20260819095140.17252-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF37C180006
X-Rspam-User: 
X-Stat-Signature: qidrfowfef9szm9wokippxn43jedxrbe
X-Rspamd-Server: rspam06
X-HE-Tag: 1787133224-415936
X-HE-Meta: U2FsdGVkX1/19FsLiD6JMuFaf0Pf2stznkf6cw0s2Sa86bha0+SvG4+76eQPMwEfX7fUTKcixoT92Et9UI/OEfNhPqRXmXqdZUgAKxOy2K5IG0cLBQYdLFO/Enz2KP0GRCjcnHIhpVANgGPVSQkUbT8MbTcmAER4H+KqtAijCcSKvVckiE3UoNjaHTo64AAA74HNmF4hrOXbCsS8tbl3t0cmLvp0dP/Fsxb1UCaxQak0nX8KhxIZ7Yy2xNcS4omveU90wD200+TGQtqRarq3nEE/EOWK5Z/2l3/fX2TtBM8U3c6lsEwpaPpE29V+WHlWqrehl8eTHEiQxlObt4hBGcrITlwef+4bvSyP22RFJLhxoGwlOcU3BQWC40IAJr378WA3KGOGGNwtgGEv60FkmUU6jwaeun9a2Qcp/++VlCGCgguqB9yp1F6eidR8gqpVey54kj4tB5zfPg4VKuKvmc52CpKt+TMui9os8kr9KtsTGzlfLnEOSrTPekTo6N0VM16GXlgKLLc9bqnGezPOYWr7oRwZSTMGkJYhrtHt91Zdh5+FIl8luXUmJlNRe0fTkFPahUyYq9+lCw8TP9HT4IAY2H/GoFRE/3/ocBfspHxTKCvE+rDhRYiYXNUysIspXvtoYVrqqb9rcvLjoH90awpK5riaUnz5sDlkDRyB85WsTLKXAQ0JDIHwrKlVIKEiEde/n5yQh2yIOPA5mwN4/VBicXF7wuQFkhJMsMP+VnR/jU8KgTOQMVpQKvFK3ol4Y2qEoUks/icVuIWj+hoIkV86fBI1pPkI+apYZTCAAMzuh1d0W/JXAgEoA5yhT18r43lM0u34o1m8QBzvR3QA2z74yRCBc+XqgCOQwpl/pbFsf/rs+aEovWYA7vMFJYE03GHZdGzGmQJ8sHfktc8/nDRKAusXZ9wyo0u572EnTfjkTUpdnpc7BFQwzy6jDsMR1sBkZhqaxqLnF/ilaj0
 iR6Tg0ei
 AWA0jV+g2ptcoGHU+9rPMnT/tLkD2gMJU8nnqL4aFoU3q8TrCHR0chd44ICW4dUzMn4/ilbMHQOAkDrRLpVZy7+qFWW2NgbracqIZWVQLXxs95O2IqWSyXfqHv0XduuZrCiDQhwZc/yZwlnZH7yLXUHAchlmCKUajwK7dTzobW+QkL91UK8Ofyzb/GEUcn7b7K25tKKRbeMTrCiL0qqe9MizIdQAWXwSCXxU+YzvKhVyuG3LpwL3ETucSMpD8iRcOF7IzHxxeWmaqzQViqcG9xKc1p4ADcc1vpew6DhPjc8boKJ3ccRs/4Hzq60HUe2cjvqslYus099I2eVtRcpRT2GXdOvXgMu90+rzJgHUoVaKnML+JPQ51yctVJ0FugE0+XulUMquZWPuWg1YhMrOj0C7GzgpOAlQvCw0RW6qmH8wSgY6rTS8DI+s8x8+FvDmtGDbKz65yGMochr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SPARSEMEM_VMEMMAP_PREINIT existed only to support HugeTLB's early
vmemmap optimization setup.

Now that HugeTLB bootmem vmemmap optimization uses the common
section-based sparse-vmemmap path, the sparse initialization code no
longer needs a separate pre-initialization mechanism for vmemmap
population.

Remove the related Kconfig symbols, section flag, and empty early hook,
so present sections always go through the normal sparse setup path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 arch/x86/Kconfig       |  1 -
 fs/Kconfig             |  1 -
 include/linux/mmzone.h | 25 -------------------------
 mm/Kconfig             |  5 -----
 mm/sparse-vmemmap.c    | 13 -------------
 mm/sparse.c            | 23 ++++++++---------------
 6 files changed, 8 insertions(+), 60 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7ac6c3173c20..db690f5e7dfe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -149,7 +149,6 @@ config X86
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
-	select ARCH_WANT_HUGETLB_VMEMMAP_PREINIT if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
diff --git a/fs/Kconfig b/fs/Kconfig
index e05917adcd60..d1c210c6508f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -278,7 +278,6 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
-	select SPARSEMEM_VMEMMAP_PREINIT if ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 177455d98064..8bcb522645ba 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2095,9 +2095,6 @@ enum {
 	SECTION_IS_EARLY_BIT,
 #ifdef CONFIG_ZONE_DEVICE
 	SECTION_TAINT_ZONE_DEVICE_BIT,
-#endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-	SECTION_IS_VMEMMAP_PREINIT_BIT,
 #endif
 	SECTION_MAP_LAST_BIT,
 };
@@ -2109,9 +2106,6 @@ enum {
 #ifdef CONFIG_ZONE_DEVICE
 #define SECTION_TAINT_ZONE_DEVICE	BIT(SECTION_TAINT_ZONE_DEVICE_BIT)
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-#define SECTION_IS_VMEMMAP_PREINIT	BIT(SECTION_IS_VMEMMAP_PREINIT_BIT)
-#endif
 #define SECTION_MAP_MASK		(~(BIT(SECTION_MAP_LAST_BIT) - 1))
 #define SECTION_NID_SHIFT		SECTION_MAP_LAST_BIT
 
@@ -2166,24 +2160,6 @@ static inline int online_device_section(const struct mem_section *section)
 }
 #endif
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-static inline int preinited_vmemmap_section(const struct mem_section *section)
-{
-	return (section &&
-		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
-}
-
-void sparse_vmemmap_init_nid_early(int nid);
-#else
-static inline int preinited_vmemmap_section(const struct mem_section *section)
-{
-	return 0;
-}
-static inline void sparse_vmemmap_init_nid_early(int nid)
-{
-}
-#endif
-
 static inline int online_section_nr(unsigned long nr)
 {
 	return online_section(__nr_to_section(nr));
@@ -2385,7 +2361,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #endif
 
 #else
-#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..2c385f8b2944 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -461,8 +461,6 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
-config SPARSEMEM_VMEMMAP_PREINIT
-	bool
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
@@ -473,9 +471,6 @@ config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
 
-config ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
-	bool
-
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 97888f146571..0aa0ab4f8b11 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -559,19 +559,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 	return pfn_to_page(pfn);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-/*
- * This is called just before initializing sections for a NUMA node.
- * Any special initialization that needs to be done before the
- * generic initialization can be done from here. Sections that
- * are initialized in hooks called from here will be skipped by
- * the generic initialization.
- */
-void __init sparse_vmemmap_init_nid_early(int nid)
-{
-}
-#endif
-
 static void subsection_mask_set(unsigned long *map, unsigned long pfn,
 		unsigned long nr_pages)
 {
diff --git a/mm/sparse.c b/mm/sparse.c
index 439802e6a6ad..948839621f83 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -284,27 +284,20 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 	if (sparse_usage_init(nid, map_count))
 		panic("Failed to allocate usemap for node %d\n", nid);
 
-	sparse_vmemmap_init_nid_early(nid);
-
 	for_each_present_section_nr(pnum_begin, pnum) {
-		struct mem_section *ms;
 		unsigned long pfn = section_nr_to_pfn(pnum);
+		struct page *map;
 
 		if (pnum >= pnum_end)
 			break;
 
-		ms = __nr_to_section(pnum);
-		if (!preinited_vmemmap_section(ms)) {
-			struct page *map;
-
-			map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-							nid, NULL, NULL);
-			if (!map)
-				panic("Failed to allocate memmap for section %lu\n", pnum);
-			memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-								       NULL, NULL));
-			sparse_init_early_section(nid, map, pnum, 0);
-		}
+		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
+						nid, NULL, NULL);
+		if (!map)
+			panic("Failed to allocate memmap for section %lu\n", pnum);
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+							       NULL, NULL));
+		sparse_init_early_section(nid, map, pnum, 0);
 	}
 	sparse_usage_fini();
 }
-- 
2.54.0


