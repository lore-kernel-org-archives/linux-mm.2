Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F146BF3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66FFD6B00CC; Sun,  5 Apr 2026 08:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647EE6B00CD; Sun,  5 Apr 2026 08:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55DC46B00CE; Sun,  5 Apr 2026 08:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46FA26B00CC
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:56:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 169EF5C013
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:42 +0000 (UTC)
X-FDA: 84624501444.17.DA864D5
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F2C68000B
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z0qWpOyq;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393800; a=rsa-sha256;
	cv=none;
	b=V8UXQBD25l5VtnHiZIyoAObtjlihAIlP/AeqG1QSA/4OKJCSd4UVa5MV/ATc4HioNMNUVS
	67DUNL6LajzSA870RXrmo+coNwWdFnhR4dlB2mXSWXYCagm6kNGcF+9mgHvriynlOPFEkz
	fuAix/FSHZCst+LhebbO+K+NKXTvFw8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z0qWpOyq;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAH/SBWDnTjIq0A4CWltUgbBq7R5GiJqy6Ep8VuXWKc=;
	b=5HOZBqbdzTL+XrC349AfyNFtl+060CVmLvUQY9Cx1RAY84Qpy5mG5G2DgfyIGDPlwi/PKM
	N01b99uvljyyq+rWt0IyB/A+c15APB9TtP6amrw1lJMsGEE725GjFUSq81fgkFmJq09w5r
	7CmpHcao1g/Y7iInJz475BUkmxxDKXk=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35d8e548a05so3517343a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393799; x=1775998599; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAH/SBWDnTjIq0A4CWltUgbBq7R5GiJqy6Ep8VuXWKc=;
        b=Z0qWpOyqb+sI9SZ9tPyxpCYf9pPzFerw8MR/P33ljoXQiUWlHWEmG9fB5E3E+bwd5V
         oS1oDcQ8LdJac/qtTWgi82SzNkhQ6s0WMk+RHpy9wPBVjHSd7HtcK0HT+w5YsrUTi/i4
         lrGP6x/zBPpDQBmSd7QUxUE6Kb0v80dXoW1TA/Rr0+KVvThhbmmPTwtb551oziWREqS6
         aYGWcTUz9T5fVBuP+wTI97uHiXo+w5letT+YYacrqeoapBLhE5EA9wkOzYHHMP3jIUIg
         +ipeONzU8bYhaoktWfkNeQp3Oa+T1GQM+FKD5G0bVtOvRMap5QICRVqRVD8voflBFc7I
         WDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393799; x=1775998599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MAH/SBWDnTjIq0A4CWltUgbBq7R5GiJqy6Ep8VuXWKc=;
        b=jC+eaNT2z3CkQw/++RrK91/FfZeFneA/oWPPhL9PUpMPiwgBkFAZRvoE8wXxO0yaPG
         9U3nxXRTgp9Zxz0xLhzeU0lB92UPrx0nzbfXA+ND+rj70MsJMtTq+A3+g9RHxmvANhRl
         L4eHBh0w0bgjVPgW1Bh8jXM8iIS5lMj5tnWCVWpS9T4kwZDUTnHmcg/frcHksu1QpJHj
         TlX8rfqHkR+aUDmTx2OkAHwiYc2TXqXZOEv2/4I5XMA5abokE0zbHpSC8aaYpF1DnLHU
         lUelIF6e3nU+G3jBYmmBIHZ40stTYKuNzlrsjTbfpCIoXLm3bFx50oilQfy1akV0IYQJ
         DWYA==
X-Forwarded-Encrypted: i=1; AJvYcCVx8W1p+twd2pk82xhMJaXEctjEpxWUZvlX5kqSc/IQMZE7VrdQsFOXKyhIbA/A7+Bh4cDUvt4bqw==@kvack.org
X-Gm-Message-State: AOJu0YxlZ5sUcYDlcAMZmMoK9AOsiVG6Ls9QT3vECuvAwY8qPLWQpeLn
	H2VrwpWmjR/HthL86Bs8KxfwD1pdZT8s1y7g4N1tbx5eLhK6sUCKEVUfrduxLnWwQsI=
X-Gm-Gg: AeBDieuWaL67QvGepFtREjDwf9i+gRiiFVShYADat3CMUjw4x76Zgt0k9y0vN8iYwLa
	8VvhouCf7pViVpBkKui1pfUZi9r7l6QZFGsgVX1Lsx/KxE62DCchTtDvKEc+jZGrfEx38Eg0viW
	kpwbwIeUpJ9SBV5Z3ZS2793mvxuP2RHmgYWOlvyLJVWGD3iSaFzmWJBoFmhiWMKcB50x2/pjsuR
	QnAA1HuozMKbND70zHW21l9rmOPWyDAkUYOmdFNFaOUm27XH0ivRf7DL0BMh7Ts0xO1K8hYGzeX
	O4FKc+mDeMqhG4CBTKlxrwxEOGIRJrnUOcRU5+GHd8J3SN1SwqkKMBFjwR5LsEIGLQD8VFHMe0R
	a+9Wj6xu9ECL3aDTrywIQ18bHZ3lwWgoehHjXvlEYw1bIfur+8uL9tzLvIWLBcknbYY8ui5+2kC
	3sICk3THcGsmVr16u4+zBVDLel4rlfBinxKuKLUJquAhX/LZPgkUP2+A==
X-Received: by 2002:a17:90b:3c85:b0:359:9014:99e7 with SMTP id 98e67ed59e1d1-35de69b84bamr8528565a91.29.1775393799189;
        Sun, 05 Apr 2026 05:56:39 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:56:38 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 30/49] mm/sparse-vmemmap: remove unused SPARSEMEM_VMEMMAP_PREINIT feature
Date: Sun,  5 Apr 2026 20:52:21 +0800
Message-Id: <20260405125240.2558577-31-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F2C68000B
X-Stat-Signature: qbox9pmz5gp8xfe5c158nh8crb4y3rk4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775393800-250739
X-HE-Meta: U2FsdGVkX1/pf8+4Kvav7sDcvvPH7dKAwIxLfrfS1VXVyMZWYNSNTtajyx1/qtQn1bc2XPX1UvaHrBYRDzin0tVEN9JlS1BU9taUYfiDJ1Tx2JgwSG7IcVakL47w8SXjYzL0zkoxus0NhUTguYXsi0rm/+hhLoDthdhH1+4NarPpszkoq7rMbUocA5eL3BWanrnP4xp30eBBv4YRu+zyKD6sRaz0tH3YKjcz5YZ0MooNHqac/PefeSs5PIVttdlP4CvDNAQYHX9MeEPauMGh+95Hiryt5Ii/6bOLtWRkJ6n2mS4G+1gjP3MifxuVR9F3SsW4md52/leH9LAn+osr9sR0ZjYfsLMJjJwcM6KewrjHXR7wXyYPx5rF9+brskZRySn60xiju/x0ZvB7BY4lzpc299wYqrOMQcqKiLaltEPGsVCZgzGnsG3sWTAKjTH9liHxcrKcgf30VrzIdv0W8axBQi12UHivv7nEeAtKpIzYWfY+oUWECxqsOZa/8ZDIr/r+qtucCIqmw+vVni2jYuDSZ7b1uO9kjojWRoK/Ds693XzSj3RG4Cd3S+pV3lraTUEw4IuDbNdxcWOr4Dn/iTXCODAlyprNYSkr4N7QQWya+jd7r4J7boZS1g1ADMnPWA2aikDcUdSMFe/nmf7omXRvuU/wLcEBcoi/VW2JmAaRYrkOLFC6V7V3jPATpS5I93c1OlSWOu3Hph98eYSO+4viOKEOWTL+3TWPuM5+kPe3XAVWt4EUaqIK1fT2YOi1kSjfm4hqFgrEhl5hN/BHHCTkwTrvgG44ZbvCYSsEFa9rI12Fu7yzfd2ZZCTfXFi71a0DL4RUv0kVkTI1kknZOb6/Yb28ME2SGGl5qCAyvUVXhx9OEfnqhkSKAkIyWupvCvFkJJOebf/f1r97MWZzDNN1GPnmBfsWNTXI5gtPNYoN8tBD/xYvklioqPfTHzmmPnByubhzNVQG5inT7JO
 uY6QheHK
 UjY9nes4i2ncDQJRg59KngeOnJF6VHYrst71I394EmPr9SV6cXXRtmeNdRTEPGnanQs8vwx/S1kSSynl/JqBPm+kAow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the bootmem vmemmap optimization has been reimplemented to use
the new early compound vmemmap infrastructure, the old
SPARSEMEM_VMEMMAP_PREINIT feature and its related code (e.g.,
sparse_vmemmap_init_nid_early(), preinited_vmemmap_section()) are no
longer used.

Remove them to clean up the code.

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
index 99bb5217649a..f19625648f0f 100644
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
index 43cb06de297f..e70aa5f0429a 100644
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
index 0bd20efac427..75425407e0c4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2078,9 +2078,6 @@ enum {
 	SECTION_IS_EARLY_BIT,
 #ifdef CONFIG_ZONE_DEVICE
 	SECTION_TAINT_ZONE_DEVICE_BIT,
-#endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-	SECTION_IS_VMEMMAP_PREINIT_BIT,
 #endif
 	SECTION_MAP_LAST_BIT,
 };
@@ -2092,9 +2089,6 @@ enum {
 #ifdef CONFIG_ZONE_DEVICE
 #define SECTION_TAINT_ZONE_DEVICE	BIT(SECTION_TAINT_ZONE_DEVICE_BIT)
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-#define SECTION_IS_VMEMMAP_PREINIT	BIT(SECTION_IS_VMEMMAP_PREINIT_BIT)
-#endif
 #define SECTION_MAP_MASK		(~(BIT(SECTION_MAP_LAST_BIT) - 1))
 #define SECTION_NID_SHIFT		SECTION_MAP_LAST_BIT
 
@@ -2149,24 +2143,6 @@ static inline int online_device_section(const struct mem_section *section)
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
@@ -2407,7 +2383,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #endif
 
 #else
-#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..3cce862088f1 100644
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
index 9da49b0d03f0..c35d912a1fef 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -543,19 +543,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
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
index 7779554c5a0c..04c641b97325 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -385,27 +385,20 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		panic("The node[%d] usemap allocation failed\n", nid);
 	sparse_buffer_init(map_count * section_map_size(), nid);
 
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
-				panic("Populate section (%ld) on node[%d] failed\n", pnum, nid);
-			memmap_boot_pages_add(section_vmemmap_pages(pfn, PAGES_PER_SECTION,
-								    NULL, NULL));
-			sparse_init_early_section(nid, map, pnum, 0);
-		}
+		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
+						nid, NULL, NULL);
+		if (!map)
+			panic("Populate section (%ld) on node[%d] failed\n", pnum, nid);
+		memmap_boot_pages_add(section_vmemmap_pages(pfn, PAGES_PER_SECTION,
+							    NULL, NULL));
+		sparse_init_early_section(nid, map, pnum, 0);
 	}
 	sparse_usage_fini();
 	sparse_buffer_fini();
-- 
2.20.1


