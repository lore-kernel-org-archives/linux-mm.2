Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF87C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3FA6B00A9; Thu, 10 Sep 2026 02:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7FA6B00AA; Thu, 10 Sep 2026 02:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923E46B00AB; Thu, 10 Sep 2026 02:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58D2B6B00A9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1198160428
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:08 +0000 (UTC)
X-FDA: 85196887776.30.7FCEC9D
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 27948100002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ClTzwUdB;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0F4KwhTuI2kCSSXKNIULS4SoWuNBUuvow/5FgUy1rc=;
	b=uItKf19f/LOV8b9+gp3g/ep4nynp/d3G3JEziaL5eYLzH2ZMCgyyLPJQVzLRIIVreAbBGf
	0u8CmOwHrXZzWIR5LZ3Q11EnC6WzGVH+hporopl9Hej+dr1Adux0onajXIw3fkkEnZkjjk
	dMoG8Xkibx1L3whfdBd4D3gRKJe6Lak=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ClTzwUdB;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022047;
	b=RQIqQpZ599iVwK40PScHxHXbtqONt7G2OTi7YIjGRSz77gzUtPsY4i/jsoQkGK4Kcf0cfR
	NVwPlW8B3TNceNW193U5M6xYrgI8dp88MjV1yCBSjXG7SAeBGF3tNHmnQAoU8May0vz/j4
	r4l8PSdi+k1eza7/14MUfEcQo6bMv7g=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d560775ca2so48193205ad.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022046; x=1789626846; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b0F4KwhTuI2kCSSXKNIULS4SoWuNBUuvow/5FgUy1rc=;
        b=ClTzwUdBgMHUadhmcjijeZCFn3U8x2pzw1V/i/ihRq33dgYIF7GgD1YXnw+nD2uhmW
         s2Uw6hSk6txJhui9JSJXbf6ggOOlozxWI2n0IXKU5yK29MfUxyDhjlGAS+PVWvIjmnYd
         b16WlxAvFdkMy6B9Auglh1bGbxKUr+MH9gcSDtBbObYFx+lwN1yGwFPpIDOX9/5qCvTh
         EDEnRyaiaI/sFTOcYZhzEAqajmKOXOXdW9kaDMCYyIGPO+dhWF3bPmlMC5mSTcx/5MoY
         2OAir0/TYQ/w3pEmBOAG+BuhQddgnjV8FqqanhhwnVNLdMAn91Mg7hVxfYhmDAsh0hAl
         u2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022046; x=1789626846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b0F4KwhTuI2kCSSXKNIULS4SoWuNBUuvow/5FgUy1rc=;
        b=J+gUCZe854eawEA9txrUEWEak+MLZCH1PbcvcAMWsVeTwIlhy+03AnTQVow78lGFbM
         QurEkhDcBzzAO1g4OxNFBGl0rqkITN32gkRciZGZJH7krIlyB62ChVtE7GGUXUFEShis
         KjWJFJ1HMjUAjlJH9CV1iJ5F75c2P+MTbyawl4WFSuOiLlM3LBhS1eb64hLMrG1h/BL5
         kmmcmZHAF+GZzJLfaGL0TG1l/nsmmsOtMZTVz5DxWYI4lFvb692fx7M9w6Zn4n6q7sN0
         1YpfPyauw/a3mfbARKgJbcrep7eCYdX1AV2qMod8RTkYv8+TLnBjkz6csaxyhMp2Vb+H
         IBqg==
X-Forwarded-Encrypted: i=1; AKwUvBzW+ynysW2aAR8rCexQd5HqYPlcFzUmRcAKQR17SKsCVZvgTJ2l9c63eDdDJM12Gu11az907SYuFw==@kvack.org
X-Gm-Message-State: AFuF++letUzIAh2Z+GC4ZyHNfZ04oqRfnj0Qjvh5LxW7GX+Bx+MiQi3u
	ZDNMIChUwG119GF5bkhS2mIa3D7/FUlJeND1hQq1AevsA/15AQw5WjyL9GYy4qNIdvw=
X-Gm-Gg: AYBFou2bHlA3IbupKKxEGIQt6Ie/FwdalL7e3PDXESRzzhiPsxtiWOXHF8HPlzEDjSM
	cWTmKIWbyvxua4WQlcHTUU+hwj0uuFt+lGHE8QXXJssPgKGkmGVyPJjyc75xdOyS3sR9kk6m1MZ
	l+YIp8ayGpEBW9+suPbDtO+sM264JifHqTQ00/GS3yT39+vMeWLFTbKTSB0216Fy9BkUGwfYt08
	027sDARsq2l6VwZIvSVMRfu2MpPskxpR97OJLTAdM1LshBJBfXj31iensmSHgvsw4rRFwZWc9X8
	RJSxNDLdXE6dpDKjqYmQl2+Ybft6o5wgB7YmpQu3Va0X0YAhi1vg3PDwA79iP8ZA4xX152pGufF
	hKgPKOigAcClW1e6hOjXl06IoGVqDTiWLvROlIIS0pmWRlk32Di+VkRvetqSjXdPqH/kaTwhOT4
	n1Wz7GbnFAHNTsMCsU7rr3VVuemlUTxCUYmlASFID/kS/C1x5t6+7cLFiH5y2MHQyYU5ktkjbMy
	PANYuogoNRdQU0iIeHKfKL4pQ3Aa7Z/mV4=
X-Received: by 2002:a17:90b:3c45:b0:398:9beb:5c19 with SMTP id 98e67ed59e1d1-39b26232bb1mr58422244a91.20.1789022045807;
        Wed, 09 Sep 2026 23:34:05 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.34.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:34:04 -0700 (PDT)
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
Subject: [PATCH v6 11/17] mm/sparse-vmemmap: remove SPARSEMEM_VMEMMAP_PREINIT support
Date: Thu, 10 Sep 2026 14:32:50 +0800
Message-ID: <20260910063256.64386-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27948100002
X-Stat-Signature: 98kfqs3we818wpjhxfi776hni7q7hcb7
X-Rspam-User: 
X-HE-Tag: 1789022046-284082
X-HE-Meta: U2FsdGVkX19VQ/L3HpwWKZ1zEAdIaa6wNikxpIVzwPOyf0dtaAjcKq74IExFewTnURhXPiRmSy2LRVET3DJB9V6i7vsdA8HVy7f46OgTFOyV3OcesC6Ixk00iAXOpskH6N1sxJ/NKgnnWwIUWtht2F068Nknzdj1XqxqXimHGsOFBVBAw9/qaGoTX4iPoEo17yi7kB/8kiIvtCFUW+CgYezPRwjoyoKU6kZL2kedJytr4L5yPkK+DFLbZ7JKkwfmJNAdcHz6lQYBHg6nIpyNXJBgkXSQ6/GF9NMmBzTqlsR9jPyu1kh6BGm/bZnzyL9T0j7OUO+KG8LChUlTpH0hjtvX99CD+mwfqh6/KSDq2cs88shvkf1NzaJACBET8id9dGx1ksHcY66yE3laqbNynyU+b5c9EOXxl0bsn1ibKN4E3xpai2YhikoXwN0smi6/H4faS6zJSLjPufXpCJTWUUsyDp0unhQHJ8WEZRNkMWLs8FWL4Xjm49Q1si+SL55WuT95m+GkJaYlsuc3NUE79WBLRrjVaq+cLbBV7QuGR3CmIKjyUGKQOkmepbp7sHWgeg433i1C3FMYwkJaY5M81U6KNe1s/3MAG62HsCzSiQq5F0vw7CKJ9Cr7OQ7I5cl7HTcWZIgGCWdQiZpRfcrqWbiUvQG7G/XGErUOsTm/sgwjM5WXmkq3orU/SmNnGG1OVsRFzWeUMPOI0ZGZuKuBeEDVEtCZ5rux+oF2GwpS0nKlq0ryAnyhNk8gNhHacWf6VVpyg1556dqCsCi7YQ8qctkwPe5XpHA0EFdL6ZNvSM/oyuDvtiuEjdgBcJXehVHCXELDfyUBD4+WlpJqUErwNJYV21OPaLJ+aOH5n6UN+7Ht8CoPlrLyNeLX2hsghaGRf/wA2wxYW/hEnHgl4TMXswCFBH4oTYco0NM5SorPYXCPS+ZhofTfMgXnobKNu/5YhsBG2emiu6+0dPXPToY
 Jicu4St4
 oZdCNmcNBh7xfNOuk8g8hok397Us+ERzDZCZ0kUvq4TJaSzW16XSTL3P0/ymy0d7uLBaFTMN6f1muTf0RihZeewLd13W9uPko7uDIIdhaEAk3XX5rcy4Pzsc14DDCKdbckzzgAHOlXReTSTZEthxOsJFfr+ub7Q8O7Jz0f4E8JJmbEosqa20CY7UCcELEbvTWxWjwXv14lcZUoaTrt6iiEP+FYcd0qnTV/OwB0yR2qJfMQXkoJ90gJILoVU2g53ymvEVTIIcttxIi5JuCHcrHTyUuUUZvHxXqSon93Cuh8Pncd29qNrUznKy7+AakugcvZ1tleVrm98i3KbOTlNtQ/lqOZgEOMfC7A3Cs05Wu0g5kNdgYTUs5+0rHtTSJmE8IwcX+2jKUhQloGGOuxPGoxaNyFF61hrivfcyXan2tmRRqPHi4zfx3UM0SSsYB1uUnZKsd5sJaTxt4bu0=
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
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Collect Acked-by from Qi Zheng and David Hildenbrand

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
index 15fd9ec5ecac..7aa74bcc72f9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -150,7 +150,6 @@ config X86
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
index 2c4f63e379da..f2d39a888eac 100644
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
index 8c2b9bed236d..f22d815d7af0 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -594,19 +594,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
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
index 428d81838ece..f4f393a033a4 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -283,27 +283,20 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
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


