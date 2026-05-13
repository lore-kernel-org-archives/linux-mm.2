Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A2FBCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A1F6B00D3; Wed, 13 May 2026 09:10:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951FA6B00D4; Wed, 13 May 2026 09:10:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8674D6B00D5; Wed, 13 May 2026 09:10:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 744CE6B00D3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38B30160D92
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:38 +0000 (UTC)
X-FDA: 84762430956.13.62B8527
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4A70840005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PsxoUsuB;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOmi79uUam5ycb0mnRYplgXKnDDShon/X8fwxFGausU=;
	b=AZQi5/aKw+E1K2tg+XfYmOYp8Ia7gmvZbV//V0E4UY7tt94kkb27xDBpxH9+81q7CXkb1K
	/kgtBkohU6OYblFYWl1wh/EZpNYt1sXsqleiJqNIyAewXetdwZKv0uTTXIifFmSMWpla80
	C6SCSf188NbOkWdEyAY4j7aipjiA/hU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677836; a=rsa-sha256;
	cv=none;
	b=4V7QB51rI4N9Y4oDNkXZTGojFwt63ivhoPI43Iv/WUdcECDF4Dnork+rXPpfJ9G/k6tHoS
	gjsLsGqpOuIHjfy8aJSGwoscKJ8sFGobrUszf586AkeoacUu/IlPbxtGPXN5m94ULIqbIx
	Z+VoM0CySuIqXcEzYbzSTBPDLHJWDTs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PsxoUsuB;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c80148ae949so2951503a12.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677835; x=1779282635; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOmi79uUam5ycb0mnRYplgXKnDDShon/X8fwxFGausU=;
        b=PsxoUsuBv15O5G/Tza8pH7HHm9+CEWDMU562wyym8PzRhTFwUtzP0fuCbx5hnw8NnU
         mzpZMjgOvDaLVNSv67f5clZwdaJRsWsqFIL6ze0n2Ha36qGF7j/x54EgIEJhUTrtZdr9
         xbvbWfH5ZFKSR8WUhCH7Vkw1zgfmVlnvTWbmlUsSbwdWG7+WxypuKolDFU3eHWBDr8/w
         kcaqHNfDgeFV74AlBLyGsRNOlpE2U6aM8pPMW9gYZTcECibMBi52BN8JquL1mKptcenN
         P049TWD7nutfdK+kYr+7VpvoG1QrzVcF+obc/SPRyJTun/73jvNjG79TQX9h8I6W5ryM
         3aeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677835; x=1779282635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UOmi79uUam5ycb0mnRYplgXKnDDShon/X8fwxFGausU=;
        b=CiOKn1+2OWq5ir4XCtMY7dkI6h/N4mdACaGBbT8JfX+ZuEG1Nkb9h8LPH8f7pxnEO7
         QNNy1jIIOFY5F5kg9iTsmkxQsglLccaCT6frsRpWYabIm69hm5qGBiUrzJthlAthAZQY
         VHm/jzx16Sa+dCtcVTYuNG6BiK/HcY/EVplbG2/mTS7a3Vr7J6eE6+EQzOeJ4fKmLG7A
         ShKTQWEBqu7xXoe/JcOAlXjp6dNVOCPCSvhDiImRDVhmrKKpgUlTi32w9HNhAJ8qUzK7
         Zc/Lcw1/7wPKmFy7pIB+k9sTUeDhLgU8ASbs/OthtNphWnd8LX7vvbeSrPBz0NbQO6Jp
         jUeg==
X-Forwarded-Encrypted: i=1; AFNElJ/TXH1eRJh7dW06nfxG2pj0eCYzy8pwyLa1JLni//Fb5Noaj/U4UzMjqQTnxtuzDA3coEBeRHcy7A==@kvack.org
X-Gm-Message-State: AOJu0YxRCshkVd4YEZzkxplylol1Bqsnx70VchNFNwioPrb/D5HMFGjW
	LnJfDYOxbcxN6aYPPrfdqPTPVej7sITg1D+BN2S6pUef4P3EAmqP1Cyev5x4D0j7g0I=
X-Gm-Gg: Acq92OGKmZblMBGCck1XWuG0lILTcojDxHmvj4XslIRKq7Y5+N1AVH2/TkbLIxJFEZc
	Rpt87s/uJ5bbNbd0+2yeX0snQQMgBv4BHRqFE2QA9wxjMmlpmoRrx33agevfmlIWXPJuxAgMTRj
	1XQpxczkrJ07qxtnSjSiNGh9Z3nW2lQ3BMeUmnYLC1JrRWMNYwy/tbfasCvYKL9x1fiRRWkIwq6
	FA+m2B5BD8M+F2OsuxIXdKeatmnIr1+dy53S3pvUFGkzWNI8yyPL1y1yzXklSsmKALBG4C+4Umx
	3QViazupa+ZF/gzp7TgEJ6LH8YvYf7vOsI9iLXKY6GqvD6XSAITT3KL/5L2GGJm53ZDnTKC9qqB
	B8/ghdY2Jl4khNURUWbCDhH25vzVSvS/xnBsbolk6mtZAIxDcUe+7rncwo5U4oJypq9O7CPKWCr
	4Q/dMEkJdSEq3DvARA1Zria2p1adyYRSBGe8xHPq9U2JpOuFAsuM7RJFMGwis=
X-Received: by 2002:a17:903:8cf:b0:2ae:ba5f:3ac3 with SMTP id d9443c01a7336-2bd27133c5fmr20492895ad.2.1778677834864;
        Wed, 13 May 2026 06:10:34 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:34 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 33/69] mm/sparse: Remove SPARSEMEM_VMEMMAP_PREINIT
Date: Wed, 13 May 2026 21:05:01 +0800
Message-ID: <20260513130542.35604-34-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A70840005
X-Rspam-User: 
X-Stat-Signature: zjh7twyb3z5rzg67b84c3oczrg8djcjx
X-HE-Tag: 1778677836-118366
X-HE-Meta: U2FsdGVkX1/fnw2PtLJSBZF3MHDLH/qjt1DP6/RussEIwaFSwVbzcSu8//KwJnPxvWrExRE7YDRQ9UYAHtK8s+WR7CsWKwyOZ1M6ErCxYL2Voz9UNtSEvweDe/vt+59lsCBAdjbiX6HK1Ea26uok6Rjf4zJ/iI2IF/5lQ6gd6hEuGhCQUNuM13THZFS0v33/UDRDJeOlU5yFAXZ/V0qXfFV3TWf2ZwXrlRF2odlR97Uiz7R/D3E6Co/6EgPS1d6fw97KxMcAxllADwB8uN0ho5dwjk4FKBi17RsgEUtFbNnScOuAZ3dCU8DkbHtjtrSJOocOZIsz5ogGyDOrycVIEbEwWvzAhUIrhwE9LXI9oQr5QsE3RS5ua7VrJeGWLczHJsu9aPw1EWBYgEQGYpXFoDEb4EQJpETdxgYN8yQxgbwNRpWbc6gczY2W6Iw1j4+Vt6+LdSCtgEbWf6DUy8hjmugqULgjcv3Bnsx52zD5faWVTzQdocJOoVhEBjWfywyC68XvOs4SsOSGxZasKDYeFiK4wv777vwJ599gq/hXX1/+mhrSKyJ5ENC2fwxuqrPlWgiSd31+/rdWP/Su9spOEqAetpxu8NNEIXpVbFYjRXSu3IDl5OFcaDhON+BBWWVu1PWmPe4HD6rMI6nEa6pM6eWfxScIwxI1bz3F80nzUv+OqQNmy872W11SQgeR4tuY4OaeiLRpmC3zzQRa78w+r9sHlS26KzklrdtrG65pb4Bga+d4TE7Pd6HX7lDlZgOgU9MLRGHI8XWjotoU++8Ge8bwMP6RX9p5tZte0MjzIhvpQctduUbifZLPdc78ralGGbpKpdlYSvgdwCh6NYt8x+3yefXcQgaIfEFrwYyUwG72Nh/9fSvhXb15hfMl2ETnH4xcQ/1GMHWyOxn7cB4MRefxoVLcKuCKcH1AM7qB+c0WkcxZJViDr5LkDNsvt4Jl7O+FG9HRcN+GKuNf5/m
 kNQTgDuf
 vyp8IVDTWkHgF32/HEfNp+X5kyeeV536XzvUYeuKgbgSm6+gbIhSE3MFsDRJMVz6uCswUdXPgVKDGU9bF/I6GThg26MiGVfMgCVdL369QQO0S35NUBOUoCCHav7BCJwRa8N0Tky7pyJ0u7ytr7vPHmSu7gOgWn53EpHRiApwNZtyzPy4qCreP+4MJ4O5szr0cKjzxpHi/omijcLzyY/idTkGh8BNldps144DYD420Vw311b25ldsuQvSjgdOMnUukXb3KpPm91rPaYfZktRlHPm8o5NucveQvSSia1f+qTUragoYjMawm52x+136NaZjKyaJpELcjcSpE//8okX8xoGV6g31EEgFZk/gk2usTb+iLNHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SPARSEMEM_VMEMMAP_PREINIT was only there to support HugeTLB's early
vmemmap optimization setup.

Now that HugeTLB bootmem vmemmap optimization uses the common
section-based sparse-vmemmap path, sparsemem no longer needs a separate
pre-initialization mechanism.

Remove the Kconfig symbols, section flag, and empty sparse-vmemmap early
hook, and always initialize present sections through the normal sparse
setup path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/x86/Kconfig       |  1 -
 fs/Kconfig             |  1 -
 include/linux/mmzone.h | 25 -------------------------
 mm/Kconfig             |  5 -----
 mm/sparse-vmemmap.c    | 13 -------------
 mm/sparse.c            | 23 ++++++++---------------
 6 files changed, 8 insertions(+), 60 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f24810015234..ed2aa0e4c472 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -148,7 +148,6 @@ config X86
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
-	select ARCH_WANT_HUGETLB_VMEMMAP_PREINIT if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
diff --git a/fs/Kconfig b/fs/Kconfig
index cf6ae64776e6..ccb9dd480523 100644
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
index d6a5dd042c25..b9baef8cca91 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2092,9 +2092,6 @@ enum {
 	SECTION_IS_EARLY_BIT,
 #ifdef CONFIG_ZONE_DEVICE
 	SECTION_TAINT_ZONE_DEVICE_BIT,
-#endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-	SECTION_IS_VMEMMAP_PREINIT_BIT,
 #endif
 	SECTION_MAP_LAST_BIT,
 };
@@ -2106,9 +2103,6 @@ enum {
 #ifdef CONFIG_ZONE_DEVICE
 #define SECTION_TAINT_ZONE_DEVICE	BIT(SECTION_TAINT_ZONE_DEVICE_BIT)
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-#define SECTION_IS_VMEMMAP_PREINIT	BIT(SECTION_IS_VMEMMAP_PREINIT_BIT)
-#endif
 #define SECTION_MAP_MASK		(~(BIT(SECTION_MAP_LAST_BIT) - 1))
 #define SECTION_NID_SHIFT		SECTION_MAP_LAST_BIT
 
@@ -2163,24 +2157,6 @@ static inline int online_device_section(const struct mem_section *section)
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
@@ -2427,7 +2403,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #endif
 
 #else
-#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
 					   unsigned int order)
diff --git a/mm/Kconfig b/mm/Kconfig
index bb0202cf8b15..c26d2d2050d5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -410,8 +410,6 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
-config SPARSEMEM_VMEMMAP_PREINIT
-	bool
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
@@ -422,9 +420,6 @@ config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
 
-config ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
-	bool
-
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index f1c3b2d0f23c..dde4486195ad 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -548,19 +548,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
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
index 47349f6f463f..eab37504819d 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -316,27 +316,20 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
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


