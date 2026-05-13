Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90E5CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FBD86B00CF; Wed, 13 May 2026 09:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2BD6B00D1; Wed, 13 May 2026 09:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E96C6B00D2; Wed, 13 May 2026 09:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF096B00CF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3F87C288B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:21 +0000 (UTC)
X-FDA: 84762430242.20.3B44FD5
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id F2FD6120002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ba3RMT7d;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OR7HeIKD4yKpxE8z6TINwIVqXU1D5zEjTSKwc02PFRM=;
	b=pqESRr2bOd0/ybo4dbMLPzl7nNhuDD242a+ZcOllGrGyjmpR47rAAPI0Q455cFsX3EBY11
	mey1YSXsQL64X1XxB6IczMGurGLfg9yaW9I8R/cTxbl/e0K037gjQhVchM0aD2fJA/LpQq
	nZ4t4AEdYBUk/0TlvAroq1n+GkmM0XU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ba3RMT7d;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677820; a=rsa-sha256;
	cv=none;
	b=YShjmhgb9Ac0GaLvzwE7a/1PaTetO38bByFhWPzQB7ZRPjt2HJd9XYTy87oMfoia0vXxeY
	VubEPUKMIxcIMbqQoZMe/TUYhDsAZ3zKrONAWOaEt6s83FaceimBQ0JYLfT0oJF8ZXzJRD
	7PlXn1lPiBRhv7gou+UYwRlUbJX/3Sw=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2bc763e2ba8so21660625ad.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677819; x=1779282619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OR7HeIKD4yKpxE8z6TINwIVqXU1D5zEjTSKwc02PFRM=;
        b=ba3RMT7dEkcWDrIexbSoWtGA0tjN1zTwjSuqtcgSSSi2ssURux+x5lw0/9oJjABvTe
         LIzVblBW009/B/tZJWaEPO/wvbZMahPciKhKGA13VhQ9F2mBxc2LRFAUKAPIg4KW/yGo
         rJls7hMu3bJEOLUUchi69/Kyf5ZCXlmjiLvnpZuqoigKu0oBctzv0Z3LqG9Y2tTWDnIK
         hLCarw9qj4aJ/4pc4ho1R7jVFTybODjlnCk0aIcN1uO61jOw9yFMtw4/zExTU9N+n68P
         sCF6JRmudNOCPUUp8AndoUR/Tyd+Sz6e1DE9PaD82d8of1V+8Rc1fYIb9abs0S17PBjB
         zUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677819; x=1779282619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OR7HeIKD4yKpxE8z6TINwIVqXU1D5zEjTSKwc02PFRM=;
        b=ds6hcgmOm3t8vt8DgbBhQiqvJSfQbYYv+Cnf9IQ6scBymYTdWSmY52Kp1U0QB8gqld
         Tp5v7AA+wDBXSY2oGeSVj5an3jbo3f/791dXKCt+1L5hB2ZhfW69IM0w+BaA12ZhFbpa
         8gQWRPqQ3JzQkLYaMxpN7eDvCRWcFpU9SYvTmhkxtTzNdTtqKB4pk8Fvv963mOhKdjpr
         hAq69K/iBQdn/dk+SRxSFhmcTrk3Mi/PAjJlZr5Ow68v4pO19CTvLK/mqPUoOPSz4L6h
         gk1K2um5j/RJCF4JgndWC6BiLogjqjQwqUyu0J2TpKb8MkyiNyRFuYliRS5it9yf6AkG
         3VwA==
X-Forwarded-Encrypted: i=1; AFNElJ8Sj+Z+LbkyHE+kZAjQXnAlyNBT7QOv1OwXltjrVQeW/oBwXN4Xhx7K49aL7eesBWvMFT5TBp8FWQ==@kvack.org
X-Gm-Message-State: AOJu0YxSky57CvFoliwMCg1QjU4qkpswZ6Tpl1lG2MyIV2+IcdMfwPFK
	M8WH/wOKD+X/e2CPlcZVYMrBpkbylHOsATMd8i/Bu3jmk9USMply6/6wKIW8Lv71h7k=
X-Gm-Gg: Acq92OGfj9r04Pc4kpicF6dtk27k1LnNnbM6qdECHcOTJgmDvBFwig+j4K7k9Y8e6SA
	/JdLWtWgjkR8o5wNdOyqhuu+op51ocVoSTsTuYH4FE9WWMxROBc8+lGKCGHcKqsDJnsD2EGqK5W
	PFj+f2KahwPwGe+dLuPpHYQjm7LaJoY2enP6TutMWmKwT3kVMBvgw/rq426Da7drLhcMjHM4LOJ
	6gmn1CM9gKXFAjsyuNUdRU7hqvIPgwQZ2Jpy95JcHnKmez6c0yfB+X0pWbXBk16bhDORwumwqxo
	OCv5Cx4XQkuswWrOCvMj7cDH6x23dArn1NmbgkazX6FYp14UH8zKQGSWR+hT5+ilecP33Ljo/0k
	KTgJvfj6fsvupOP9QSQ8z71diS6ZQ0tN6CNjX7wPm3PiUFPXKjWt72Rxdin9No87JbB5XjtGrI/
	xgd+qXScdTqiVHn2yrKWIAp3bk9YaTfEAhxYkjeLkpfW6WaNOpQkbLrmFhu2TfX2VIcTm+4Q==
X-Received: by 2002:a17:903:3905:b0:2ba:c453:ed3a with SMTP id d9443c01a7336-2bd2718da07mr36777045ad.16.1778677818683;
        Wed, 13 May 2026 06:10:18 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:18 -0700 (PDT)
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
Subject: [PATCH v2 30/69] mm/hugetlb: Switch HugeTLB to section-based vmemmap optimization
Date: Wed, 13 May 2026 21:04:58 +0800
Message-ID: <20260513130542.35604-31-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2FD6120002
X-Rspam-User: 
X-Stat-Signature: rpz73txetwrsnoxzh6rcd886brwm5tur
X-HE-Tag: 1778677819-123501
X-HE-Meta: U2FsdGVkX18Z76hG632Th1HFaw8Rdl/ulcFpCpKqg23rvklFLBg9mzRo7z78oAdU+1TqR4Y2Bl/LWAi4eyBHMUTE32mJP89a1aoKyyMkJA/ad3mw+bFEvcN+xE/X4UkdHhbQN46C+LAsacwBeF/ow8EQAuPhlsAJNupWhq5wF0iv7XSw2728JvAXerpPdrt/i+gk3mr3NpgX2BvOPjjSiceqSgPVVDF8uB4Rjo4vMqcpDWPIMjlkYM0cJmKIQPXRU7p8yKvxuK5+xasPXc6YX7Mtzntegbj6R6xGhZrNrubKZoo11R0W/7o9NFzcPw0fb9jGQoDEYhByQoymm6IvRrkIXAeTYRnH+FkibVpN8dSmXxV463SfNDJondwYMD3VW6CxlnQPk2IwKEN2cTdrzsfjK7m6rlGwWIaSv9laup7nD/UX1PZFL20leIBQFKiVpyMZPh54iuE6ZORSgnSyqmkjGHI07xoaqHVb4aWTgnZ3r1wA9iUvHHOOap6DBENNT7Uvovnp//yJyV5uLEwHcAsN5ZDQOwGVWFACWUu3BOHXbYLLVEebnr2wMSihLUR2RVoW4NyAtNiGKbeXXdm9QhzxURAnVjkL/9UvF2F4LxeuGYrhkGPMdMcPRt7+jJYiFx6HV0fChREDfh1SKEvPR+eIbmeUuKHQreBEGtowVd6RPFDh22Iad8a1QassSMk41oDanBwc3yBOcsyDYn7M+/L4bRmXurXGxPTX4aV3lO7sHM5dq+fIU3TMQ29mZjjJayXP9bVKOXJ4HMJkmMOixEtJm+pk1/6Fsyqnfo1/Q+mj0inRKE6aVgyq+P2Mer8W+QUX63rK6SbtbREyfTUvaxXNdNuC9sHx4MFLbzLXfMbqYrc4VIaXWoAjlZxi8honEmFeJ1v8l5mD6I67WazUEROpaXZXNCPN+CsIrmpQR8qzoMNvv4+JgvMYsW8EVkme6r68FVsPgXBJVxSNakU
 3Zy4ZjFb
 7Rawc683iQ8qFLYTPDCHHiYvGx7/qlz19m/57c8Oj2ida5NG1JWwoEJujV6JJOynT+Gv0sSCPpUXTvOn+jOwDsjG+hrDBUEejq+BxGoyQW/UUSx5f45tR2WhEOPjdhPZJj3mY70gftJqZFIzSHa31Dtk+UH8cKbiFKYOOmI+cbTq7eJR6NW1HrqsxYFvnVFNutEz7Jn/XBpGNx1rgfIiUmrWHO1rxctpapwJnqe9pbST0T7bBYJeLrSNVrwyuHCnBqLRBmTjbm09FjRbLsywjdj3OfWxoJgD4v/NCgbyu1SI8s5evcDw1A5KfELceUrrKoMgu6QMeQaIt/Fcl1o+XkAWVdErTFNjzhNtR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB bootmem vmemmap optimization still carries its own early setup
path, including pre-populating optimized mappings before the generic
sparse-vmemmap code runs.

Now that section metadata records the compound page order, HugeTLB only
needs to mark the bootmem huge page range with that order.  The generic
sparse-vmemmap population path can then allocate and map the shared tail
vmemmap pages without any HugeTLB-specific early population code.

Do that by setting the section order when a bootmem huge page is
allocated and dropping the dedicated pre-HVO helpers and related
special-casing.

This removes duplicate early setup logic and switches HugeTLB to the
section-based vmemmap optimization path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h |   1 -
 include/linux/mm.h      |   3 -
 include/linux/mmzone.h  |  17 ++++++
 mm/bootmem_info.c       |   5 +-
 mm/hugetlb.c            |  26 ++-------
 mm/hugetlb_vmemmap.c    | 124 ++++++----------------------------------
 mm/hugetlb_vmemmap.h    |  13 ++---
 mm/sparse-vmemmap.c     |  29 ----------
 8 files changed, 45 insertions(+), 173 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index fd901bb3630c..dce8969961ea 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -171,7 +171,6 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
 extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group __read_mostly;
-extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_struct_page_init(void);
 void hugetlb_bootmem_alloc(void);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 31e27ff6a35f..f39f6fca6551 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4864,9 +4864,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap);
-int vmemmap_populate_hvo(unsigned long start, unsigned long end,
-			 unsigned int order, struct zone *zone,
-			 unsigned long headsize);
 void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
 			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index bf4c40818b63..d6a5dd042c25 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2264,6 +2264,18 @@ static inline unsigned int section_order(const struct mem_section *section)
 }
 #endif
 
+static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
+					   unsigned int order)
+{
+	unsigned long section_nr = pfn_to_section_nr(pfn);
+
+	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
+		return;
+
+	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
+		section_set_order(__nr_to_section(section_nr + i), order);
+}
+
 static inline unsigned int pfn_to_section_order(unsigned long pfn)
 {
 	return section_order(__pfn_to_section(pfn));
@@ -2417,6 +2429,11 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #else
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
+static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
+					   unsigned int order)
+{
+}
+
 static inline unsigned int pfn_to_section_order(unsigned long pfn)
 {
 	return 0;
diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index 3d7675a3ae04..24f45d86ffb3 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -51,9 +51,8 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 	section_nr = pfn_to_section_nr(start_pfn);
 	ms = __nr_to_section(section_nr);
 
-	if (!preinited_vmemmap_section(ms))
-		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
-					     PAGES_PER_SECTION);
+	register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
+				     PAGES_PER_SECTION);
 
 	usage = ms->usage;
 	page = virt_to_page(usage);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8debe5c5abce..080f130017e3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -57,7 +57,7 @@ unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
 __initdata nodemask_t hugetlb_bootmem_nodes;
-__initdata struct list_head huge_boot_pages[MAX_NUMNODES];
+static __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
 
 /*
  * Due to ordering constraints across the init code for various
@@ -3111,6 +3111,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+		hugetlb_vmemmap_optimize_bootmem_page(m);
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
@@ -3264,13 +3265,15 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 					   OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
+		if (hugetlb_bootmem_page_prehvo(m)) {
 			/*
 			 * If pre-HVO was done, just set the
 			 * flag, the HVO code will then skip
 			 * this folio.
 			 */
 			folio_set_hugetlb_vmemmap_optimized(folio);
+			section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
+		}
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
@@ -3314,25 +3317,6 @@ void __init hugetlb_struct_page_init(void)
 		.max_threads	= num_node_state(N_MEMORY),
 		.numa_aware	= true,
 	};
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct zone *zone;
-
-	for_each_zone(zone) {
-		for (int i = 0; i < NR_OPTIMIZABLE_FOLIO_ORDERS; i++) {
-			struct page *tail, *p;
-			unsigned int order;
-
-			tail = zone->vmemmap_tails[i];
-			if (!tail)
-				continue;
-
-			order = i + OPTIMIZABLE_FOLIO_MIN_ORDER;
-			p = page_to_virt(tail);
-			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
-				init_compound_tail(p + j, NULL, order, zone);
-		}
-	}
-#endif
 
 	padata_do_multithreaded(&job);
 }
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4367118f8f57..730190390ba9 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -16,6 +16,7 @@
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
+#include <linux/io.h>
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
@@ -478,12 +479,8 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	return ret;
 }
 
-/* Return true iff a HugeTLB whose vmemmap should and can be optimized. */
-static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *folio)
+static inline bool vmemmap_should_optimize(const struct hstate *h)
 {
-	if (folio_test_hugetlb_vmemmap_optimized(folio))
-		return false;
-
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return false;
 
@@ -493,6 +490,15 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return true;
 }
 
+/* Return true iff a HugeTLB whose vmemmap should and can be optimized. */
+static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *folio)
+{
+	if (folio_test_hugetlb_vmemmap_optimized(folio))
+		return false;
+
+	return vmemmap_should_optimize(h);
+}
+
 static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
 {
 	const unsigned int idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
@@ -638,9 +644,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			epfn = spfn + hugetlb_vmemmap_size(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
 					OPTIMIZED_FOLIO_VMEMMAP_SIZE);
-			register_page_bootmem_memmap(pfn_to_section_nr(folio_pfn(folio)),
-					&folio->page,
-					OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES);
 			continue;
 		}
 
@@ -706,111 +709,18 @@ void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head
 	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-
-/* Return true of a bootmem allocated HugeTLB page should be pre-HVO-ed */
-static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
-{
-	unsigned long section_size, psize, pmd_vmemmap_size;
-	phys_addr_t paddr;
-
-	if (!READ_ONCE(vmemmap_optimize_enabled))
-		return false;
-
-	if (!hugetlb_vmemmap_optimizable(m->hstate))
-		return false;
-
-	psize = huge_page_size(m->hstate);
-	paddr = virt_to_phys(m);
-
-	/*
-	 * Pre-HVO only works if the bootmem huge page
-	 * is aligned to the section size.
-	 */
-	section_size = (1UL << PA_SECTION_SHIFT);
-	if (!IS_ALIGNED(paddr, section_size) ||
-	    !IS_ALIGNED(psize, section_size))
-		return false;
-
-	/*
-	 * The pre-HVO code does not deal with splitting PMDS,
-	 * so the bootmem page must be aligned to the number
-	 * of base pages that can be mapped with one vmemmap PMD.
-	 */
-	pmd_vmemmap_size = (PMD_SIZE / (sizeof(struct page))) << PAGE_SHIFT;
-	if (!IS_ALIGNED(paddr, pmd_vmemmap_size) ||
-	    !IS_ALIGNED(psize, pmd_vmemmap_size))
-		return false;
-
-	return true;
-}
-
-static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn);
-
-/*
- * Initialize memmap section for a gigantic page, HVO-style.
- */
-void __init hugetlb_vmemmap_init_early(int nid)
+void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
-	unsigned long psize, paddr, section_size;
-	unsigned long ns, i, pnum, pfn, nr_pages;
-	unsigned long start, end;
-	struct huge_bootmem_page *m = NULL;
-	void *map;
+	struct hstate *h = m->hstate;
+	unsigned long pfn = PHYS_PFN(__pa(m));
 
-	if (!READ_ONCE(vmemmap_optimize_enabled))
+	if (!vmemmap_should_optimize(h))
 		return;
 
-	section_size = (1UL << PA_SECTION_SHIFT);
-
-	list_for_each_entry(m, &huge_boot_pages[nid], list) {
-		struct zone *zone;
-
-		if (!vmemmap_should_optimize_bootmem_page(m))
-			continue;
-
-		nr_pages = pages_per_huge_page(m->hstate);
-		psize = nr_pages << PAGE_SHIFT;
-		paddr = virt_to_phys(m);
-		pfn = PHYS_PFN(paddr);
-		map = pfn_to_page(pfn);
-		start = (unsigned long)map;
-		end = start + hugetlb_vmemmap_size(m->hstate);
-		zone = pfn_to_zone(nid, pfn);
-
-		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
-					 zone, OPTIMIZED_FOLIO_VMEMMAP_SIZE))
-			panic("Failed to allocate memmap for HugeTLB page\n");
-		memmap_boot_pages_add(OPTIMIZED_FOLIO_VMEMMAP_PAGES);
-
-		pnum = pfn_to_section_nr(pfn);
-		ns = psize / section_size;
-
-		for (i = 0; i < ns; i++) {
-			sparse_init_early_section(nid, map, pnum,
-					SECTION_IS_VMEMMAP_PREINIT);
-			map += section_map_size();
-			pnum++;
-		}
-
+	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
+	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
 		m->flags |= HUGE_BOOTMEM_HVO;
-	}
-}
-
-static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
-{
-	struct zone *zone;
-	enum zone_type zone_type;
-
-	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-		zone = &NODE_DATA(nid)->node_zones[zone_type];
-		if (zone_spans_pfn(zone, pfn))
-			return zone;
-	}
-
-	return NULL;
 }
-#endif
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	{
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 66e11893d076..0d8c88997066 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,8 +9,6 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-#include <linux/io.h>
-#include <linux/memblock.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
@@ -20,10 +18,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-void hugetlb_vmemmap_init_early(int nid);
-#endif
-
+void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
@@ -69,13 +64,13 @@ static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
 {
 }
 
-static inline void hugetlb_vmemmap_init_early(int nid)
+static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
+	return 0;
 }
 
-static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
+static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
-	return 0;
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 69ae40692e41..b86634903fc0 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -32,7 +32,6 @@
 #include <asm/dma.h>
 #include <asm/tlbflush.h>
 
-#include "hugetlb_vmemmap.h"
 #include "internal.h"
 
 /*
@@ -372,33 +371,6 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	return tail;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
-				       unsigned int order, struct zone *zone,
-				       unsigned long headsize)
-{
-	unsigned long maddr;
-	struct page *tail;
-	pte_t *pte;
-	int node = zone_to_nid(zone);
-
-	tail = vmemmap_get_tail(order, zone);
-	if (!tail)
-		return -ENOMEM;
-
-	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(maddr, node, NULL, -1);
-		if (!pte)
-			return -ENOMEM;
-	}
-
-	/*
-	 * Reuse the last page struct page mapped above for the rest.
-	 */
-	return vmemmap_populate_range(maddr, end, node, NULL, page_to_pfn(tail));
-}
-#endif
-
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
 {
@@ -600,7 +572,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
  */
 void __init sparse_vmemmap_init_nid_early(int nid)
 {
-	hugetlb_vmemmap_init_early(nid);
 }
 #endif
 
-- 
2.54.0


