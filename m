Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4087BC55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541026B00AC; Mon,  3 Aug 2026 23:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1436B00AE; Mon,  3 Aug 2026 23:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9D46B00AF; Mon,  3 Aug 2026 23:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4ED6B00AC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFDE3A236E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:35 +0000 (UTC)
X-FDA: 85062225150.01.53960DD
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id E57A1160004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VCHStoWK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obMgSt9JudTp6IA7cwyJwAbMqHf5ZvnKhdpNNbjote4=;
	b=Xg9rdOFVMI6Z5vvrWv7SrHaxwtIBl+WOZRoqKA1ldDvQaie1VJwVQx0gvtg1UP8J/rnkZi
	KrqE06byu5R3RALr39FEKwNfzVPp7MfKlM0Bbnfcwe0RxGc47iXh2nkGaeXvOtKYUYdOkd
	/T9LYFMZ2GLJlD0StR6iFcHZ36KmXEw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VCHStoWK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815793;
	b=RqAhqURjfhzQJEnv1baDpJjzHj33c8QADafekziLDprw34xLk4XdOMsWiQ7mcvP4CQaSB0
	s3aiPG3EMa/gzHm2UWLp4RSF3s13lpfVBzZ8GCtcB3MMM7XmAqPWiwvjmw90vgOWE7aSTr
	yu6xddq2lAHT6a8nOdQYNZ6Hy8fmK9U=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38dfe910e9dso3874139a91.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815793; x=1786420593; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=obMgSt9JudTp6IA7cwyJwAbMqHf5ZvnKhdpNNbjote4=;
        b=VCHStoWKMBnQHtEN8QQraYNsVFhCeLxzk3lPlSy1vPfwGRR8eGLq3+9zZU6A2L+/Tx
         TayjzqahtutQKdw6rWtFe++wHYX216LZfqQSouXzPIR7Zp+P4MtNjBBlGrMdXpL/yFGF
         vY/2r+p/BGGjY0EfGhMwcjPS/DX6bn/bGiNgTqoJ7V9QiPGJDK/QJQMNvDU4LRKoSWdC
         RebpMJIaVkCeFbOYdWxMIrsVCL3mptuf+OgbGgBx6/LodKkryZ7WsmtwOuhqCuta+J6Y
         lm2dtYJHbLxFHaT0AHFOIjZrYnYE6gVKQUshGd4zzyzsZmV8v4bKz78xAU8dNa2F2WE6
         9cBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815793; x=1786420593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=obMgSt9JudTp6IA7cwyJwAbMqHf5ZvnKhdpNNbjote4=;
        b=XW7ENNBfqXWgm8KqAh6+da+mfWVWaR2KKEckm0i/j9h4gT6SLNCDR/QRRW4zJIuNRc
         qodFxZB+PGMcL3Q11YZggStFRhJ0cG3pTUhMQHhDxQO2ezgzupd6YRXl3M+09pgY1Yci
         9zdWJjPefkIDyVCCaQAAOyZJMrBh4VI91FtaY8d6QelRslPg9fqpkfAsodnpVXnr1tp8
         e40K+l3oqk4CaYcO0m3RRZ3YdFiGNBZcAjVDuRPDfPBy/KG5hvtBTUxH9SfEJui7tA4b
         0tplmMbB2WqErm/FNITCn9fj/Id+cK9k6l0WA6tOz6+SsGZYnaz74EsahsMnIasZwWy4
         c/nQ==
X-Forwarded-Encrypted: i=1; AHgh+RqAdgtcKDV3EkSSozQC6+hiEoftGcuLnjJtUrTuts+/byKQKGqiYAsOyVxVH39nu6tjUuiEI/4yvg==@kvack.org
X-Gm-Message-State: AOJu0YzxaFiIriy/8ioEuQVc0tJwDuGdkmsulLhJw+TpFVS2KCz2m7IN
	nVnpYX59cjDMnrf8xqGD2dvZwNxqXZVAZt3Ig1oN0TMQuKra49JsMoJPJaVcWqOLm+s=
X-Gm-Gg: AR+sD10dj0bGdhgZBsD1RF8LKbNvX8BRhLmyGNSkxGr1Z2DanO6kmM9pOfPxnzWTEcI
	K5bAzu7uOtNxj9VVtVX/mdQp1aVBTxJhHVRmWM2Bx4R9TQMWYzsngliBJgcym5S8xvdmQBnaA/F
	jkCvrcyqFFcjVnBCb4pm91xlTM2eMmm9DgjoG0AI8crlDKWex2fNsp3clQuvFXzsjjUbRmyaH1C
	LZlw64AdwTqtgW3ghTSAsa5KsKybrBZXm6uvuZ5QufFzEcwrtU6tzHLqIl8K/Ep5LpkcQSMbrfV
	rzCHV4z8kbNlmQ8nzrfgpvA+0BQAi7E2Y0O69y3eNDHLUX8kycXoVl04Z8v0zQKmFlqL6RoP56j
	rs3jzzkvy/QH4OrOvMR7e7OJk6+Ki15S0O8mJAaaRXHJyIM9Aeu7vsJBB2p5R5zw4JFFk1mM/yr
	A7v99BNTJ4/QZdDUWYH4zJsjGQLl9MtkfgN/kARNASDyns/6aH5Xf7uTCklr43w4tPFhLxrh501
	xMQSzSx
X-Received: by 2002:a17:90b:5867:b0:381:96a2:14d7 with SMTP id 98e67ed59e1d1-38fbc4ae4e7mr11397300a91.22.1785815792669;
        Mon, 03 Aug 2026 20:56:32 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:31 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v3 11/17] mm/sparse-vmemmap: remove SPARSEMEM_VMEMMAP_PREINIT support
Date: Tue,  4 Aug 2026 11:55:29 +0800
Message-ID: <20260804035535.2846016-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rimqs6sjxufzxy34txxf1qw7hgai8k9m
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E57A1160004
X-Rspam-User: 
X-HE-Tag: 1785815793-557500
X-HE-Meta: U2FsdGVkX1/FqjvMsH44ZConGetDM+GIuha5DkVFjoV4HlKEWK9xTRIHPJCf1oWh7b5pNJ0vI7hWZFLSVDNzzlMt4PnpJ73qXKuvf7NnYN7Ce59ZNdy6V3Tnn8+LU9MY+WMy5T8xSL86uZSZgxBKf9+EhJhAxzoMrJrwhRKEPgnUWBq5MBNbW6Nl9jfkxrxcvIKQCY+8o8M/KqxDdkvWQ30Nho40Nej9FHUPBoRr5hhGApZ9VOiSZnsFUyC2EVFBzgG8bAT9IjBfgRHlQK2DhSzNnFgvQ1pU1hqge8HqHmpTwRPi8RpIOQ6R1mdgP8I3yloPuuguJLFJR2gGwg+g3/ZVMpP0UlQa8jiMtEkS6bGf8erUWJgSHCaEXAZ7tfVA5WO4R1RrVB3nq3BgsgLHtWf2fh050WTcJR9IIBRQ9hvHiENgvDm3JQzkQP8rxEEU48jnVl38ZzPovfNnCO6fvHJ4ck9EwvcWYguyS6l9/lfGizMI+MCamw4E0JQSWHbnHTnx2aKVzgbYoZazZE8BkE5tDdEXDWdtspgqKtIB4lRCQjjLnQmD44AcyAVWKa3bKncIUoHtcn6FqpZeAgC1PD/U4snhk5KaOhocg4fM9W0fYIlHg4uwwVvszNxOV6SgzBGRoHW5qdr4evRfzf1iLO1/0Sbd5uYMmNcNDjHF++yclEMd2UiOJPgcb1v7h5Hpb5loOr4vH9fB69Kx1XGh7rOnYfNDa8/r54NXHSs/fkKwpRoNUftZrH0oAl1E9BFikkQqWIFpH1RkAml2b65cMk4iQmcS3n1CVFoOIIbh00YH6IQN2lr/Y79jdEEaOuWsR9zaXrE9jdN+AEzFFXQ4rpPSifqNJq8zVzn1DpX/hQNyGshB29LH+3Cv4JbX02lZH9DkV8YHj/RWQTHmq6wGFl1UxdVthA2I5z9g5gnVUfYCd4Si5zByk/5dp+7DU0cdANELp23wEFx53VpEltl
 0WNP8ze0
 4wfvLS+vwq3mmDum465/b/mmt2NtMQqVKlRXLTITUpPq/TxlaGeSRzjEG6TafRrhY37f/U3D4a/9Pxe47GscdWlBpAovcvfbJG4Y7+JHenxlR4LE2LXoyU+ihzfMO5NWzfba7Sive/7hwMJyRo+cmchGsA1rtgdvarCYLp5gTIhNACR59QXVqEoMnRQlzN4kn7ln3gh5nVZhDja56IcBgqXPe6D/BWNrX420oZciRWZfgUv1nVgS5dsZ3TorM+DVweZxaEjUxN74V90o1UcxsUsBjMqV4g7TUGkVV+Q07fPcvV/IMTr8cf0T02oCZNfXKO2vZyDlrNe/oa/7v6DcqlEFo7ytDi0oqmfd4dE5LqUR8tgEBd8Bctg51sIXVxR28aC09ySj0XiAU3tc7XiHzedArTjYqVV5P5IuSiQsrL+Wu/gRNxuyXfg7A5S4sDgbcACzMMtvxXiQ+2UY=
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
index f7b6735db7ed..c851dc47ad9c 100644
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
index 663726dd6463..db019fea5152 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2097,9 +2097,6 @@ enum {
 	SECTION_IS_EARLY_BIT,
 #ifdef CONFIG_ZONE_DEVICE
 	SECTION_TAINT_ZONE_DEVICE_BIT,
-#endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-	SECTION_IS_VMEMMAP_PREINIT_BIT,
 #endif
 	SECTION_MAP_LAST_BIT,
 };
@@ -2111,9 +2108,6 @@ enum {
 #ifdef CONFIG_ZONE_DEVICE
 #define SECTION_TAINT_ZONE_DEVICE	BIT(SECTION_TAINT_ZONE_DEVICE_BIT)
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-#define SECTION_IS_VMEMMAP_PREINIT	BIT(SECTION_IS_VMEMMAP_PREINIT_BIT)
-#endif
 #define SECTION_MAP_MASK		(~(BIT(SECTION_MAP_LAST_BIT) - 1))
 #define SECTION_NID_SHIFT		SECTION_MAP_LAST_BIT
 
@@ -2168,24 +2162,6 @@ static inline int online_device_section(const struct mem_section *section)
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
@@ -2387,7 +2363,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #endif
 
 #else
-#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 060190e12bce..adf5ab53dc25 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -459,8 +459,6 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
-config SPARSEMEM_VMEMMAP_PREINIT
-	bool
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
@@ -471,9 +469,6 @@ config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
 
-config ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
-	bool
-
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 7759f9de748c..d9d2f4d02420 100644
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
index d4641aa70497..f0d9b7263bb2 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -294,27 +294,20 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
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


