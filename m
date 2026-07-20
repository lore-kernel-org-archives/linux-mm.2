Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A5AC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34226B00AD; Mon, 20 Jul 2026 05:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4586B00AF; Mon, 20 Jul 2026 05:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC726B00B0; Mon, 20 Jul 2026 05:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B57636B00AD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E0A7A1033
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:39 +0000 (UTC)
X-FDA: 85008640038.08.36E83CC
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71CDAA0011
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cAKDivrt;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiNjPlndk1ck6Ov28MIeX8psN0Q1u/TAdFlhmNElnGE=;
	b=V+UjJr5t7Tky50gxhrKvVMiAGF5RDQZ0mVzeWSa9P4vIz/aW6or4D3ruT0ElE/MnmP5szD
	SpkIi/IsB5WVx1loAfvIIp+IQJ1Jpc4f86yLd08hsQOAX98Fh0Bl0Akpu/TvaAQU6Q1TMj
	TFgaVVQB9HfwqJc3Skn905iIcnEiMYs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cAKDivrt;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539957;
	b=10bYyeF/VhMGUp+p70zbIs7zj1wjrQy1mL/Mnht91nbYWPATdOxd7imcCNq7kK2xo/Hdho
	GhR0knl54ysi6fR1Tt4ZXVobsCFiNE/LFBoH6hT6/MQ6g+vQl4o85TCmMfUOv9DMdG1V0X
	SbD91il+GZ4XptzDtRYCbHpdBpxj4vs=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cce6a0c9c3so88840365ad.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539956; x=1785144756; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SiNjPlndk1ck6Ov28MIeX8psN0Q1u/TAdFlhmNElnGE=;
        b=cAKDivrtyNtFMLPFvXQpkMsaCARHDn8s1mVjbIMJ/ZhaE15RGL6UXQ1eHHPpTgzsna
         +YK8DiDWAFsNJbqWRz63j+S3DhyedIuFcj1ZU1gsCQ6eECTP6J7K0lsspcRnvXDhNEZD
         vf44iHr/BwEkYz61dVIHyAbLN9cbBB9oWCJHcxfndfJ1Yrjhs01Uy+UPR2Up0VGFNzEh
         uZaJRhrIVHuhihNMe0K5EMjPiB3p9YBJVIvFzsrSXtWi+AIFoEFK1D8twPiKFaJFXe1I
         Wu+QrUFaUn5MfS2/3ZjxBbQzYiVPEo0sAxr020cxcQG6W9SsaaN8eS5+s/hDaXnDVsi6
         t9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539956; x=1785144756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SiNjPlndk1ck6Ov28MIeX8psN0Q1u/TAdFlhmNElnGE=;
        b=W2SzGpnNqu7ZzS7JTkuMiDs1WoiZiaQoKWiPuPR5fAj6oixMiKAsopj5ZkzuEsX20+
         h4qUVsKlp+LX3Q8nlWW/js3Y3jhNzfVhe2q9RxXP9+YO1jKw9mWz+kig/IJna3BmFHCl
         w2n60F9+zuyOzVS2BDpt4YnOYkUAqeIdpaOHntmXRtpRH251GsEQWkcRlIHseWIPdZUh
         bV9jIgfMB7fovIRSq8ux/jb2IVcw+YJ2Vtb6qZRWGeeR5IGNVI6N+Abip+TnsvIbi6RW
         0yHZSX9nwfVB6myXmYl54Xj4Erhdt7cCAgG0g2Wiv1wyfwl8fJbSooH5ghFfc/3kIGdc
         9A7w==
X-Forwarded-Encrypted: i=1; AHgh+Robf7D0LuwQCMccR08mmWphHi9qUD5JUN1kZwfW1zc/NB7NTAHNFJMOwpnYs5yAJXYqUXvLsFGA7g==@kvack.org
X-Gm-Message-State: AOJu0YzRdhYY/pL7roUESOxdFfOlrDeKy2zdRfrTNbcrSHqMEt2EHbQJ
	djr1fT5NEOasVUX9mn/3EeF0/Ux04XIQSodCRX6wU5AnWQimhEAgjPvbqJhohNp61mw=
X-Gm-Gg: AfdE7clLbW80BjThCZzWYImSUm95nxenaC7kNiwZGMn814dzfphzd5BzoFTRMaEnL5Y
	lCB5h7WTxKVmekvNBzMaJnJXwu9SI8w5qJBnb8qDnKD78sg5J9XxuPDe1nGJiBeOIARRngB7k35
	OjSxy3k4EJGkDdhFlqH7KQBWBBjjVRLlXW2SvtxQBatUe8cRVSgCSeQY2B5FyZWfm5wA2VLyE+h
	zA9oYKLdfbFQzOzNcLM6SxaAWudQtn9iWkQjLqUwqi8mmKxXf7HvzzQmeCUXIE52iPqqqgOFsmE
	P4rFHf4Etg4dMq2OU8YpW/tzAHVwkSchskd5eX227q2nJYu4SinHBV6sbprgZb1Yy2yPYoq8T40
	DkKbF9MSDQZTd3GsdaDK+ruPcnfJZhldq8vb6heTr3mNsSHlgMSaNzsrxqo3JuUL8hkxlVV0GU0
	gvwWe2Z1l+DX9jUIqt6pKkVIk=
X-Received: by 2002:a17:902:ce87:b0:2c9:bf82:dd11 with SMTP id d9443c01a7336-2cf34895290mr137263395ad.7.1784539956087;
        Mon, 20 Jul 2026 02:32:36 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:35 -0700 (PDT)
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
Subject: [PATCH v2 10/17] mm/hugetlb: switch HugeTLB to section-based vmemmap optimization
Date: Mon, 20 Jul 2026 17:31:20 +0800
Message-ID: <20260720093127.540540-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 71CDAA0011
X-Stat-Signature: ig9fms5cn3hfezzc49px5ycssf6ocu75
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784539957-376346
X-HE-Meta: U2FsdGVkX19c65VIKE4U4TH7SYjWBBrwQo3iNwRDojjMZ7VIeC8ydgB7JsZ2KK/QGAnZqbu+d61l3NXqybzQqxzVwjlDHLajm6LLTDjt8oEZT5fH/ZO38G6xk99Z+mJWqGbmlfdhpwHekIsGMmLgSahXK8DRHZM3m/hss8hZLXGRWuPxaxvsD8KL86FMsRBrgzdrZ9ymUOWqr2MKun5eQvUSOhFIXtkpjQIMyD/4WXsM+HodHND37zfYt8NUPDhiPkc1PkDhHyzMpAdAEGBKfMQ4h5BrbFGh4tCLo2n8byzX8NKrfxw53BTVx+3HH4f//HJy3TC3JeY76gBUhqQwiK64TxxPHWFYKNWhD9VgCgR0xLCzIAIPK/m1hRfC09bjfc4VzelWHCE8Blq20HGd6c0yCMsIIBKeuz87brH9Srs9CcoJ91THjx6kOjsjpxVE6DOQUJF56RoRq1rsPhSZ1WXAw6iMzFZp1J/NSHKKgBGUpNDeILZ1HEoYIP5GyIka9PVoNeBBG2T3voyV2RIhYrJPlYjHXC5IgOqtO3AbyPf09krys9p6hqXAK6LaJRJQKlvX0bdbJu0T7OG8hYqv/A66ly+FFSapqYNdwbV89VJT85z2LaFGzF8FiaYo4PtF60GwyrQMOeITd33E6PK1LBtKTZdim6+JIA+cyUNdwl6E/hH8Iisglm/CmdHxzWd459KMZmRGW+Tz0dmb2hprcfg/PEryoOyMj1qeFjAj3J1MMePZ9ObKxz8O9mKq/xW62JbxFxdk1Xd0nEDGKCreT1pulNAZqTbieEcruh16mSVCWZ0teLBBjBkoJ+qbyZFUBXO2vU2JFf1LfbEuRoNTgeJ9ZxcqabrmdfziHuNjayHsTalAvSslXPH/iMnvi5xZARMfqtaVHU0BO7ZUY/YI/kqIVHtB3VMbRk/YYBjbo/JQJI/EtKBhfBhn+M4I+cgdoTZSI702xfLQrOo5+0c
 3J5DR2gK
 LjcqYtdGENLl1pJYr25QCaX3t/MhU3rrYot5vE03p+M7zW4m5Vb7hf794qGE0Sj9ryPKkEJNZ4DbeTdi9KjOVc1FTa65VU0FIP2dhtLTOM4nT/EWVtvEIGvb6CZwBam6rBDc9rHyvzbSntFPmrnUo1ASoZY5gWosN/hXJrwUzw2y7fLmjlSFpYZJtllplGq57sGCsDxJ7H5SkA86NhQmFJYZHw3uBd222QHv7VFuIwKlQn4Es3ROP/3HqpTau1Yz94zSJDbNCTS7AFq0+6iweybIZc7sjtSxDAdEHJ8qGkYe7IiEyxmFa3feRLwHrvKUaD6N86vYh4NyvjDXwg/0aXDeugqzct8JCcGLpIti/zPbROY/wRbhGYauPRIc3W4tZtMUOSPTbBJT/7Ct/g5qHXWHI7+t3PxPfgk/j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB bootmem vmemmap optimization still carries its own early setup
path, including pre-populating optimized mappings before the generic
sparse-vmemmap code runs.

Now that the section-based vmemmap optimization can derive HugeTLB
vmemmap deduplication from section metadata, HugeTLB only needs to mark
the bootmem huge page range with the appropriate order. The generic
sparse-vmemmap population path can then allocate and map the shared tail
vmemmap pages without any HugeTLB-specific early population code.

Do that by setting the section order when a bootmem huge page is
allocated and dropping the dedicated pre-HVO helpers and related
special-casing.

This removes duplicate early setup logic and switches HugeTLB to the
section-based vmemmap optimization path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h |  1 -
 include/linux/mm.h      |  3 --
 mm/hugetlb.c            | 30 ++------------
 mm/hugetlb_vmemmap.c    | 90 +++--------------------------------------
 mm/hugetlb_vmemmap.h    | 14 +++----
 mm/sparse-vmemmap.c     | 31 --------------
 mm/sparse.h             | 27 +++++++++++++
 7 files changed, 42 insertions(+), 154 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 16c4c4caa126..fe28f98e1b22 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -171,7 +171,6 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
 extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group __read_mostly;
-extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_bootmem_struct_page_init(void);
 void hugetlb_bootmem_alloc(void);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 550fb92957d1..1462669418b1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5041,9 +5041,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap);
-int vmemmap_populate_hvo(unsigned long start, unsigned long end,
-			 unsigned int order, struct zone *zone,
-			 unsigned long headsize);
 void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
 			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b8e1569bda15..efe0d639933e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -52,6 +52,7 @@
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
 #include "mm_init.h"
+#include "sparse.h"
 #include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
@@ -59,7 +60,7 @@ unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
 __initdata nodemask_t hugetlb_bootmem_nodes;
-__initdata struct list_head huge_boot_pages[MAX_NUMNODES];
+static struct list_head huge_boot_pages[MAX_NUMNODES] __initdata;
 
 /*
  * Due to ordering constraints across the init code for various
@@ -3151,6 +3152,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+		hugetlb_vmemmap_optimize_bootmem_page(m);
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
@@ -3311,6 +3313,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 			 * this folio.
 			 */
 			folio_set_hugetlb_vmemmap_optimized(folio);
+		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
@@ -3354,31 +3357,6 @@ void __init hugetlb_bootmem_struct_page_init(void)
 		.max_threads	= num_node_state(N_MEMORY),
 		.numa_aware	= true,
 	};
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct zone *zone;
-
-	for_each_zone(zone) {
-		for (int i = 0; i < VMEMMAP_OPTIMIZATION_NR_ORDERS; i++) {
-			struct page *tail, *p;
-			unsigned int order;
-
-			tail = zone->vmemmap_tails[i];
-			if (!tail)
-				continue;
-
-			order = i + VMEMMAP_OPTIMIZATION_MIN_ORDER;
-			p = page_to_virt(tail);
-			/*
-			 * prep_and_add_bootmem_folios() can access pageblock
-			 * flags on bootmem HugeTLB pages, so initialize the
-			 * shared tail struct pages here before bootmem folios
-			 * start using them.
-			 */
-			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
-				init_compound_tail(p + j, NULL, order, zone);
-		}
-	}
-#endif
 
 	padata_do_multithreaded(&job);
 }
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index c48fcea076a5..e37ac4745add 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -18,8 +18,7 @@
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
-#include "internal.h"
-#include "mm_init.h"
+#include "sparse.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -706,95 +705,18 @@ void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head
 	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-
-/* Return true of a bootmem allocated HugeTLB page should be pre-HVO-ed */
-static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
+void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
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
-/*
- * Initialize memmap section for a gigantic page, HVO-style.
- */
-void __init hugetlb_vmemmap_init_early(int nid)
-{
-	unsigned long psize, paddr, section_size;
-	unsigned long ns, i, pnum, pfn, nr_pages;
-	unsigned long start, end;
-	struct huge_bootmem_page *m = NULL;
-	void *map;
+	struct hstate *h = m->hstate;
+	unsigned long pfn = PHYS_PFN(__pa(m));
 
 	if (!READ_ONCE(vmemmap_optimize_enabled))
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
-		zone = pfn_to_zone(pfn, nid);
-
-		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
-					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
-			panic("Failed to allocate memmap for HugeTLB page\n");
-		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
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
 }
-#endif
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	{
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 7ac49c52457d..20eb03df542a 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,8 +9,7 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-#include <linux/io.h>
-#include <linux/memblock.h>
+#include "internal.h"
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
@@ -27,10 +26,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
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
@@ -76,13 +72,13 @@ static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
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
index e818b4109777..531927bc9380 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -32,8 +32,6 @@
 #include <asm/dma.h>
 #include <asm/tlbflush.h>
 
-#include "hugetlb_vmemmap.h"
-
 /*
  * Flags for vmemmap_populate_range and friends.
  */
@@ -369,34 +367,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 	}
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
-		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
-		if (!pte)
-			return -ENOMEM;
-	}
-
-	/*
-	 * Reuse the last page struct page mapped above for the rest.
-	 */
-	return vmemmap_populate_range(maddr, end, node, NULL,
-				      page_to_pfn(tail), 0);
-}
-#endif
-
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
 {
@@ -599,7 +569,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
  */
 void __init sparse_vmemmap_init_nid_early(int nid)
 {
-	hugetlb_vmemmap_init_early(nid);
 }
 #endif
 
diff --git a/mm/sparse.h b/mm/sparse.h
index b2dc7362af4f..b904cf3f0a2f 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -58,11 +58,38 @@ static inline unsigned int section_order(const struct mem_section *section)
 {
 	return section->order;
 }
+
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+	VM_WARN_ON(section_order(section) && order && section_order(section) != order);
+	section->order = order;
+}
+
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
 #else
 static inline unsigned int section_order(const struct mem_section *section)
 {
 	return 0;
 }
+
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+}
+
+static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
+					   unsigned int order)
+{
+}
 #endif
 
 static inline bool pfn_vmemmap_optimizable(unsigned long pfn)
-- 
2.54.0


