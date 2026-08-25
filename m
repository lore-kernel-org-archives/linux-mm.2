Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F2DC5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99016B00AC; Tue, 25 Aug 2026 04:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FAD6B00AD; Tue, 25 Aug 2026 04:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84F26B00AE; Tue, 25 Aug 2026 04:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABF006B00AC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 383C0C0387
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:48 +0000 (UTC)
X-FDA: 85139168856.17.452D4B8
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 67A631C0009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Mrw/jgD5";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5ifo7rguHpO8B0NJYkiw/UW3AMLKwMeqysag7KMPVw=;
	b=0NFAbs+h6oqGz5d9T0gRRc09hFvsixYNFpb5cSEHkNAmwrCfGQ9WILCvXLmNLYsuiWbFy2
	EMF8hbFBB3O7xZeEAN0imFCKo1QWTu2tvCvYPYHS7gv9B+MfIKphR+tQOpNobN797g0Vva
	FAH9mDAsk5/L3YqZFWvkoxO/IRxbg/8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Mrw/jgD5";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647786;
	b=o/vGguFMHthQ9PzVDPvfLx4uh3ZdN24NrtrPT1PjZot5HIi2iH6aq/BqbSBvdjo3syS3kC
	VX0lUobj0maeI55eOVSfGJNrvL+NkGVn8iW4zjZiPnGkre7njEV5DTNqG2h5CgPUmFIWGl
	Y6BobeKcdJpfo4K0AC6JUwS6o6zxuAk=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38e041ea211so3831644a91.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647785; x=1788252585; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q5ifo7rguHpO8B0NJYkiw/UW3AMLKwMeqysag7KMPVw=;
        b=Mrw/jgD595FckZFCpkUO5iORje8glunE+STUiKwqrbMpvVpRaK/ZHraIZmoRhdXyNR
         v2FLBngPVeJw7koeQF6/0LO70Jr79XfiWfPoVTbeR1wVADqM4al45Zal6IY4X2nClMn7
         tVcVo+3xzT5hWpPzA2SXpKgUNwTfG/OzieKFaQlJYOjqe3SBLx2YXfTwisR0KIP0qGL5
         WGbxdQmqYexzxq0VqlOuTULZGnPXRXl/vwm+pNnhCAsZKo+j/OysNju2oL77Ld0rcvwK
         8ugBa2FtZJ7W+BMhE9t2//HvVMrXadidbKshrpMVOKqqgnoyKufqDNgAcB8aS92ZHinH
         HLwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647785; x=1788252585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q5ifo7rguHpO8B0NJYkiw/UW3AMLKwMeqysag7KMPVw=;
        b=N3Kr08o9cKlVUNuRrT84chMyq0oI2cnmflwDVU/ncojvv/6zrK3O2tBjVh4McyVdy3
         dUrdOd2mbOkdCUsOf+7HD/WthyISBUcHmqGAGyrkZzuF0d5td3r/ZxsgWaL2X5q6ewjv
         2Ul3dF5cllT5/d4w2fJS0/mYe+if31LNue9oxXT3WFM00MHIbDUb7fFLlDpW9KCpmMoW
         ZJ6oEQc9d5XSKGjcK8SZe+8QpvQOvTet3pMVFtx+4afZEp+ab4tgrB32WIsOqaYed6cr
         9Ka5y2TpXmkDjb/6XWO/jpQS8sUOgdWdHFeVExF7+UZDgGZRBAnAbI5O88+OqizJKm3d
         cQBA==
X-Forwarded-Encrypted: i=1; AHgh+Rqv67yjWEPNex+OLgvzHfuAiZep2qNd9wIRQO4m7pwExPur4aVdWjvf8jd26/r25GMuRpweZ/SASA==@kvack.org
X-Gm-Message-State: AFuF++kkTpAinkYwUG7jXv/YiS1IjRXfxUhuMioTw2wdn2o/cv8Zqe2Q
	AkjNctwGi/WTNtdk57X4JOZKngoxyGN1ARnZIs26u/pPueRTyXXkLqXkyQ+Ux+osbzw=
X-Gm-Gg: AR+sD13K5RLtwPJw20Ec/PI8D88EDYF8gla4T3UilrLYTVPm7Bd40cicNKR7n+9g03e
	fUIJ6/aaJPUa40z55G3P5Y5Vggia+/yk51xNRLkOBvsC5p0kSZT0XW2eUkXe3dLPlDhHX26G4GU
	YhWbhE9C2VIH9EPLvC1t9lbgTHjyVafNe38H7R4L4d+bQIU4F3Qv+HyvODXmUWfEV+5U/72ITQZ
	JTXsO+cLlE3dJhMkY3cmzUL+jvhtwbAWEy4DXD0SUDJHjYxcfS8uXZcNSUIGzq5IYehysLBjrKC
	+FHKXZKMwIAjcuxQuJUNzY7ARDHfQp/FJ4aO3Nk6g63XB3wXssPjysoSbu11DVQUZzsWyNlA6cd
	hVTNHNqiXCzaAn493niWdIAL6yc3+SbEM4X81Xk/G+D2OzIRdfPWt8HVvMfm4t7wFluwshebJ9g
	iY0Z+CCnXwu/nxlnaEpG3SLKCgaAUC+10Obp1b2vGb6JTHCliO7Z8im2muGrLJmJch4U9OGpTj7
	oasT/KWBr1WKCm6+iTCoywH0w==
X-Received: by 2002:a17:90a:e7c5:b0:36d:9e0b:3801 with SMTP id 98e67ed59e1d1-395c34f47cbmr55316271a91.8.1787647785178;
        Tue, 25 Aug 2026 01:49:45 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:44 -0700 (PDT)
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
Subject: [PATCH v5 11/17] mm/sparse-vmemmap: remove SPARSEMEM_VMEMMAP_PREINIT support
Date: Tue, 25 Aug 2026 16:46:02 +0800
Message-ID: <20260825084608.47437-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 67A631C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: j8uuxtj9zrjj7edmhqef6nu4bgaszp39
X-HE-Tag: 1787647786-239076
X-HE-Meta: U2FsdGVkX1+LOHRYv7WlbPNTpAa4SVhVk1rBvKaKn1MjbT6Rvi1u1/0Aqcdr3MOGFETYw7pwYWRm/bj72TWLC1MwTAh7EqC201k0tOZ+6ntNK72z47H4gdAHhVAQeWCa2uqB5lFoCHN0TVKDEyqVO24uwm/NTqTgMGcleSJXje1jq9jbsv758xuKMGNPcYSawnKbipvse5tuuLiyUtRcVpO1KJJ2tNUr9dzJ98dFUIbnoAYdy+JpRI09t5C1rgVu+4BnZJRc1H2vZvRcPF8ZhqUh5M64mjel3peWI3RU9YIH+GQ+jC0K44B6RPidk4qtfpCNEXkAIlz5sAE4AtpOTAfb6PuxYRHjv4/7PRzYn2AWNQ+ZJhJkNy+WZcmdYQYPML+p4QdbrkAj6xvpRDzmrE7yug4s08K5/A26iW0dQe7zGaMKPJ3zsYGgEHykZwjyB8dJA6ZWo9yMC3dF8c+DZXiP913IuBkvqWHLxPXeld3dPPWFbJ4KH+iMVw7lmGEZYuSRAQyia22pgzGAnBY/6fBo+/RP/UJkxbpnjGXmKw4vzKk/nIflESafXBLEfq/oJ3FpfeCejysJXFAKyzDWNgB9emX8AGiJvfOBsjSxjzsGfm0dlp5VNq54o8MUYGZ0YEXZzJAGSTe2Nr39CjEVp6usxcMq0kpC1pZXjdimcJf+cwQ7UFtC5EhHeqzENiBcOX6rE6Py9E/X5bo8Mz73Xh0EgLsUh6jpAD9+SmMAfpxxpE66DR2EpwuT2J6mhPs/i8wnjp5DSLp0o2+yFZGtzjBecclZyFheatSRF42gCx1Vbk2dhxw9gDE37bSJWGXi8cT8ZUCotN+HN94iYsIIDw4qEH/7sRQAR9v/Ko7t7gJUKxRJia5xXra5EExA0AIzPXGyvB227+wy4VsHeXEjtrWl0qqY246GTnlJaoohorhsKP6R7GAuJSKAhlYaSmdlexXLqxelDPDoKYgT2xG
 +BaE8oPj
 2rLkc3vVsAkOubNPoXccRorS0K3AB74a/H60DWGDssDhjYIRtdN6MRxhhWn3+S15XnE+AJJ6fmVvojsMMMd+uVjXPOSkRnxxJlnN9ftJX5BgJBz7SWF03H92Je52R+1qUdlVHKHOSGgDAgnhNUBFazzRxTJ46Jxhap5++lT5CfqkWQW6hpu4Tjg6I3NCI1ptKDVwdVkfjrDH9dxvAhRgsZuHJQOnK1bxABrSzstTG+IrgiTqsW2M7lycSYv5fVgKmtYzMyTn+evifWHNwdxD42mgpgtJvaRIQ17FQxSHrUGI5RjJQZaTM1kr6GaeV3koNsO9xjDohMyZcEHeJmcUGe/tb0gUw8pjPNK+MqPAegsXyQskj9Zc39ExkZDoqsUQB5l3JqPZ4de3GPwFO6Z8SCP+iPB7LNUCzOrUEnw2pqj3rrCRLCJuD2O5hRpcRbfkuPtVBJZNue58GNgk=
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
index e48758805a8f..e62e6aa07f12 100644
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


