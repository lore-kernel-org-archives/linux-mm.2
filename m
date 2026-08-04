Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C148CC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC996B00AB; Mon,  3 Aug 2026 23:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D556C6B00AC; Mon,  3 Aug 2026 23:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6BB16B00AD; Mon,  3 Aug 2026 23:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0BC6B00AB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35C831C0D3B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:31 +0000 (UTC)
X-FDA: 85062224982.26.4A9C492
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6746940004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="dZwLdcE/";
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815789;
	b=a0QxXcLeuINy6srXO7j4JdE4WcbqMEkEgijWP7sjw+rsynU3BfQ2gxUuGj/T1kY9s2GNes
	YlxT3PYL0pJ3wmYfQ958wS9adgKVP/koQNn9yG3boXBqZrUUwctSJku4dHU5C5ufyN0pe5
	CZTGfmAxnqauofYizvfDkI+73POHS88=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="dZwLdcE/";
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rx6ooyM+fYIa9IWfVQ2BTryW26cGLhdtaYHkTbeZ4Mw=;
	b=bS2pAC9p5qcNJtmFi5quMLgq6dXaj6nrGRmOltBqCGZ4UpmWf8mRBymePMGfAyMfOxrSJE
	RM6N3Dm346twKYElPw9rzqFY8keoW8PP/8Nsr4HdGhNbHpOZwQZ25aVfjHn9cCSBq9ahtM
	86cg2xPqwXcQ7MgtKjdPX+C2XWCS+Ko=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ce7d2adef4so65475325ad.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815788; x=1786420588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rx6ooyM+fYIa9IWfVQ2BTryW26cGLhdtaYHkTbeZ4Mw=;
        b=dZwLdcE/X6MPDFGu20DQTZgPAhNgaKitpoHr6VlcFmJ6CAuvjXOGGptb2wg6/0FWZk
         C4DW+8ynQwq8FQeixOIt2hbKH+/HQ+ANekIshFJAqb2X0DO/IRDBDaVvXF5t999zTpmj
         zHIFWsPz3Ke97GtbNSjYxeR6eyBngKqH4oJTxHtpOHyqhrqwLeNaAiIvM7HTv6KpJZ4e
         dnbHv6bm6shseCxHJmd1zFWfQ1r7hWmW4HqDoqc+mX/3Fz8ZzlowLTcI1LUpbWIKUD/+
         DMZ6OLfDDSOZy/rtsSk7Hu49HToKDBYajbg9vgrJLgXPdyPwB4G6ZVv//dAbGPesMeQh
         eiHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815788; x=1786420588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rx6ooyM+fYIa9IWfVQ2BTryW26cGLhdtaYHkTbeZ4Mw=;
        b=pXKoexDOiJ/OEb2eFohDlP2ava5P6/Th8G+Nmp4eIGX1FxPZiqpJ4V4BDwJtbJPiCV
         bRgR2008mZ2H+tUZBtUc/ruOI75EdEa7CUzxnNyFklD/mOpIkEamWJd/laGbeJVmizBA
         KPLbYIg+Zh6RJsVwS+mGV7QVtlgmFLxC6pQf6e4divrwXdxA0STFor+UqkUOKzZGrj04
         6DRyNLX4fUY8NdYHzN8lbQLMsFCnWiPUtq0Hv1Gbesi3yPyhAmPsaybOWMqviQbv+z6g
         jIQwhnB1/QH2SL5ZUpiSuVZiZ9JPNYClM0CbcWQUVQ7T0ftdQqQVnJ9Tl4z0p4G83p7G
         cEsw==
X-Forwarded-Encrypted: i=1; AHgh+RqLo2DM4UGpEEz7nRkAsAyU775YHpxZF/0nmumSOXdw1/ABQ9oY62eNB59sZDtrUyk0uY7TaEn5AA==@kvack.org
X-Gm-Message-State: AOJu0YwtDyN6z5vGhmDTHHH7mqGk2ey/+LrIQ3ZEOEmi0Juvwwmu2Q46
	QZtgtRlkDdoIO/BeSMpIsBWcWahrvLDiwZSxqwRPfEYgV9by6Jq9p0kvTYtuCxTXkYQ=
X-Gm-Gg: AR+sD104lbjXOHDcOwi5bBBwi7jkO1BzXIrEiwllhSUsHJRjA2XRDE3/L0zjO9S+yOW
	Pv7qy1iaODNlEthtHImxNztEGsyrWiE6Kfo/ZsQyZc4DebouKcmPx0zD4ExAxA4GKRXIOOOlm9g
	xBKbQ/oYbu+CWnW6idJjC1IFZLiOUpYhFBj9BaxUxHmW1i5rj04janc2AgDw4nL+a/XYWPre8D1
	lR67Du2E0loDB/1qdAS/32V1i7NqmqsLujpWiyuZ6thsizWrSQppQ6MnifS6GDWYyEwuicVABFE
	ABDGIZLP86yHdPIj6xVKnWd+7GZtojbngO9c4VxmIjvJqeMu/9sNM3cHg9tKL1bK2+UPDvAusMm
	v7cMDdfbYCDEW+IbhMGKFopC5XX6QLF3FulFtEkg7proJG14Aynp7fGhoazHMNP3i/Cyu+radyD
	Vwm9s3tbslNrIp7r1rKoeg7OifoIqjIRDiGyfrOCu63FJF6E8Tl0ILSTEKqWKN7st1GC7ols63K
	TrpxzHc
X-Received: by 2002:a17:903:2347:b0:2ca:bb6:e7c6 with SMTP id d9443c01a7336-2d0523f9f88mr112432745ad.37.1785815788226;
        Mon, 03 Aug 2026 20:56:28 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:27 -0700 (PDT)
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
Subject: [PATCH v3 10/17] mm/hugetlb: switch HugeTLB to section-based vmemmap optimization
Date: Tue,  4 Aug 2026 11:55:28 +0800
Message-ID: <20260804035535.2846016-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xr8skmgfutfyqyeipc677nmsyr4s545u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6746940004
X-HE-Tag: 1785815789-556778
X-HE-Meta: U2FsdGVkX1/5L59CPthBRbUAh7MieCgNkzcOo0WIHgAIjxA7V/t9nMNpV3zLWydzm7MD0Abgo8+l6PZf3hGTixJw7vgmMv4Ox3m3E0altJM06BNCpjibaLfBaarsbGP6pDoJJkd8EJf7YXO7/4gTi6Gi6I49wQK9OxrKAl4gfYKxe6ncnSfrld8bou6jGwNjyTdVL02Lw7SbFwA0W58f/WGQzeTLGeWeBoVk2I+D29crbujQpIe5L/oi6E/QkyPnmDwzD12OL95jHpBvihb7gTDnazAG0ncCk1e+hZwLEzirvPoYPv6tezIRXxX5Fjw3XfVrNzcQvytKqEi/AzWuH5kMKUfpUh5bGSpPJrk3nczJR0KLIq5AmL5sA4cK4eTHf26kScKYA79PJ+nPyZa6yAFsamDuO9WTwyIdcNaOCg9PmowSs8Dp8H6AlN8MOV0O5+gRqFTGmI7NJZJiIkJmYd8iGFNJ3BOgHtDB+xhyDriFdPHqXx2MVvdhKfZGFSC+2dgb+wD6oVwUuSBgSNxpg+r3Lo7jhbXpU5lsWdMUNGwQaIYpVHvRLPbXq1eM/+XTiz+A5znYzlAFFyAtdOflNPd/BifUi9KFVWEaRDSaHqT1NdBluK/ZUwBmbghbr5Chr+XtadQFq8B4sm/FpkLBdPvvymlyX8YBjWJWtnVj58Y9qAibdtmLjUhomeuikklfG+BKSI9zfHHP6EqAzcjHO5rHP61q/Abd/i6KGaBV3MxMRVe4FVO65DnE1iB6j1KRV/u4rrHQq0ZpxlwldQYt0oxMmMe7Xf0xMCitVGWeVb6SQepeGlsERt3Qm95tTjQTKQ2yW2xA8UKsT0AOM8J2FmytF1jObX0FLWvEcG3hWfuMKGI7h3yz0eCPEwdUvXdHdjCqmdXFGhKvMQjGoytayPiWRBfhPABJ6OCQX/5XR65p7ri7US3UC+gYt9dWbI0SXzm8EIGuyx7pOePhLsJ
 3uH1A6LL
 Q48bBcG9YgVBimamwzrfY7uaBSpCjlK4i/MeAUzgz822Kltfcb9uyNK2M8CsZV1wwdBJms8ciYmISpU4fZ65fyc6GQT+E2g+D58fXPu/qglKly/1Hu6To8r30s8VvwdbGX0v4ClKSzA1rBCfvFNY2M8TuAVkVmC3Wfvn69dLR2TvPqD49A7I6zXB8vwNBCt6gRiJVDlkG+QW8pFnFD4V1lr3ymjUIgiANPCnxC3IXW6FT5t3XtBxDGvU4d9nUfsDMPyko5kxpUk3+v23JgtiF1atyOP6kMHmIc9YdLrmGfBXTeepjuVoL3AF59Do8G5RoiCeMBZyBu5kU3NPTTonCHGsLled7zWitV9ktyX0YD8CtzS8Hse0rPA9iJa3qE2jjC0S7VCXWD5xwi9nWThP83zBK1OEaKz7t41wR
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
v3:
- Use the order-based helper for the bootmem vmemmap-optimized check

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
index 7fabe6c66b4b..fd7dc85f58f3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5097,9 +5097,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
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
index d212bbff4c83..7d8507aa4c5b 100644
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
@@ -3137,6 +3138,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+		hugetlb_vmemmap_optimize_bootmem_page(m);
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
@@ -3297,6 +3299,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 			 * this folio.
 			 */
 			folio_set_hugetlb_vmemmap_optimized(folio);
+		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
@@ -3340,31 +3343,6 @@ void __init hugetlb_bootmem_struct_page_init(void)
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
index c48fcea076a5..7293706b532f 100644
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
+	if (vmemmap_optimizable_order(pfn_to_section_order(pfn)))
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
index b69a7af76858..7759f9de748c 100644
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
index 16b9bd3070aa..bc4c58ef24a9 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -16,6 +16,24 @@ static inline unsigned int section_order(const struct mem_section *section)
 	return section->order;
 }
 
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
+
 static inline unsigned int pfn_to_section_order(unsigned long pfn)
 {
 	return section_order(__pfn_to_section(pfn));
@@ -26,6 +44,15 @@ static inline unsigned int section_order(const struct mem_section *section)
 	return 0;
 }
 
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+}
+
+static inline void section_set_order_range(unsigned long pfn, unsigned long nr_pages,
+					   unsigned int order)
+{
+}
+
 static inline unsigned int pfn_to_section_order(unsigned long pfn)
 {
 	return 0;
-- 
2.54.0


