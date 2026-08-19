Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4336FC5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B5C6B00AD; Wed, 19 Aug 2026 05:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2946B00AE; Wed, 19 Aug 2026 05:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493A26B00AF; Wed, 19 Aug 2026 05:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 144C66B00AD
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A7781A0515
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:42 +0000 (UTC)
X-FDA: 85117557084.26.F989454
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id B276320009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NS9SzhwW;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133220;
	b=G0uU6fRubDAUsL4FC4ttS/wb0UEPdfll9tk2r6StKYboSZZmVlkeCaCXawiCORRLJUPEUA
	jLqyVTzkzbdEPf5Y2XJD7QNOFVx1Q8FsP1WF3ebTdFNnSqkY7tBcEIFEXKRGQ2lD9XGl5H
	qzG9GoPrL4KlHraqdJO7hGDA46C+98U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NS9SzhwW;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SWP1aSDIxPqpucFi2P6HiR4lR16ch7GDnI9FrMPGnfA=;
	b=i5gknM0b/OobW11jVKt/WeUWqWk7hPeY841/q78+pKRHr7liFVMOYIon+bKTE3U5LMDjn5
	RqPawAkM+h07RQluLcAeaU3dQdAtoDHShrzd6NmDgxM3xtVBhPi9ruW1BtfkhY+tgXr3WX
	Wjrb0plBOOu/GWjwVmrqnlRm+1xnRl4=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cbeea240819so398183a12.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133219; x=1787738019; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SWP1aSDIxPqpucFi2P6HiR4lR16ch7GDnI9FrMPGnfA=;
        b=NS9SzhwW6qnGHjEAWwqR+sGeTBbzPpgQ2Vu+udLKtZSiF8EVcLjwnL0UPIu3zvqYDD
         WkVUeHia6QxelyKQ8xom8LNdSb0T+QYTHBzHfLOhItp6mDrF87zmKBipZumrL7L1wUUp
         Pe/TDl9BOGtvkV7IFCLuCRv4NtuyxJF15jWH0Np7psLPXJelkUKjuoU+2YWfzRbdIhE4
         Rn39RiI98LelNl83yAvstbBCgn4dVuKtzKXDCrScM7hlTcqOKSna98HhgMUWw0+7aImj
         OlqypYsMyDTkGmv5ZvKchGhtmoXG2d+0aqL/ZhfSh16m8REL92jnMKSEm3IiHS6Zf2Wu
         8ZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133219; x=1787738019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SWP1aSDIxPqpucFi2P6HiR4lR16ch7GDnI9FrMPGnfA=;
        b=qtG/Y/uL9/oI9xH8IdeKynmSH556IZ+7xz1Hg49DRn2xgdDoo7ff8p/r9EAHxdyfGZ
         0X4oBjsmKfghSRZBjJ4PXl0rycqvefwfJC/1HBZaACalqZlbwVRLRD3fQ4ipf5hbDJsY
         loYFSanKvsS0h5lURp8WJWAeJZZCtc/31PVqSPxTVlm7hAP/b/1M/o3kbjTPm+9qt4Ye
         lh/HbMv09JA5V07Q2kcKOkVJI1ZidPp4vmf9vH0nI0zrGvbYQ84lgRUuYsmpKI9RmVYz
         cwUx0qzLH2osdAjcyuKd5JOHlt0mdjymWZgjaT/jIwhRAavmq1nYTeZl/W+afDNV6xql
         KWxQ==
X-Forwarded-Encrypted: i=1; AHgh+RrRdDm1YckXTY1suP5y+aGKf5dSzU+3KzCCp2DW2CqMg1hq34ja2o/8/IdU4TdhAz7jO3DeKNEdBw==@kvack.org
X-Gm-Message-State: AFuF++limbFJ2ZIdr/2YnchNcwEhMK4S5q7dKtA7kgWHUv0+NELiA+2v
	Zg19vfvz6PssUo+TSOFhK7QbG3NNXlENwVq6QYovRUrGp61w75psoVtHrnsaebGGl0o=
X-Gm-Gg: AR+sD13a4K1d20GG1CKhtYEIv6P2Cgz1iocmyYJt1etRqgHNh9ZlHO8vwmNfcq89GjO
	JTy8L/4hSXi7ugOVn8a/6dtzl0cw8vodpbv/GdLEYr4KVgBQf1MdJmNq6N4FiI+Hefp26c5ooxZ
	MNR+P7V5rFdgNAchWQzcLqv1F7NC1uDmzx5XDDkVpNv31GU+YSyzesc1HBu72gwM9sdZXC7AiQC
	j8hLB4usg0JwoKMJ+Bf1wXoEjNejujOGLb4pGq9wUkTvzLojHWZPaqHA4s21TN2cB6WPdzcUY3t
	NuLLFbAxvTPn+MTMBDxdzWSjBImJrx/Vl7y1C4uY0rwCbsF2+mf+ACvOwm/251Wld5FyyDkHZmY
	hudqXkzU1TUbj71qFwKVy/PG+AI9tNXBfJFSNWfBVjsoQLjK7gSwrYMEekPAuFuK2HMVXxn21KQ
	KVD8m52SIcwdbxvGtcjFRNQ87mryE5n+4BL24Ww3XRJ5WtqNtlcBH+a/8E+jev1lL0eWyuTRvKp
	xw26abeAM/aCLEunbjuB+nm4g==
X-Received: by 2002:a17:903:11c7:b0:2cc:864b:539 with SMTP id d9443c01a7336-2d60175df80mr48678865ad.6.1787133219241;
        Wed, 19 Aug 2026 02:53:39 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:38 -0700 (PDT)
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
Subject: [PATCH v4 10/17] mm/hugetlb: switch HugeTLB to section-based vmemmap optimization
Date: Wed, 19 Aug 2026 17:51:32 +0800
Message-ID: <20260819095140.17252-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B276320009
X-Rspam-User: 
X-Stat-Signature: 3s8y1aq4fqndhmif34633s87g73bsdh8
X-Rspamd-Server: rspam06
X-HE-Tag: 1787133220-792866
X-HE-Meta: U2FsdGVkX1/1QdBQrSvr2GUBqTsUmw80Ywhohu5/1Bnm/C+PCT0vKetptY3C3mdTR8bSI1tTm+D6SKLzkgAjjc1Hhc08aSyMCtnhfDITWb9tQnOxOOs5i0B05GIKTHpDhRrNi/qI7vA2EKN8XGPEwtkz2vwta0G5wKsMhonOdn1FQKuzCdrTQTteRyLWvXUuaNmHVjyQpUN1w8rLZUebJiAfgbFIODJXL0kJfFx64qzGy/cm4L/vABg7kC9UVcx9UvpAlTm96ujuELKOg4K0lEBBzxc/BP6E+wSKvKdE/tQPeNfQQkkzG3+yh9n4DvX6cN/JjvuEzpmDGv5Pr2NVvTxkvwEW8dCjRIACTqhqq/+Sqa4MOxDsf7Lr5nfvoFSmtgkPXhvFUJ0exXuPB2DJN6iLN2LV2t5VfO5FMFYtVe93vpQ6/9Hpa6Zw6iHsaOpEJ1SIcYL7S/7R63lVzLjbSvASmOkpZmR27Jcmpj7gqK+K9njsK+pbcIBckwpCZQj6gPVcLi4+7fUpW5mIQGM2/a0gLfq7ufntaUBB11kdfiMVbehUbOuRHylLsLqsQ+++lNZifzR7O1dU0iZNIPLpfOEjqy3CbCX5tOEm0CGnkYpxkhZsUjjgyCGRQte5REBYXWnc7lNz1neKgn8mIMKzThaP7WZwkeiCEmDrV/VdiXm2V6xd3fgjT1SDeT18Uwb+xFZQabY3Z97CFVV1+BwDgTyAQfS7zq6LOv5uFVqCTgCKn7MYCGFxPoN1YvKkXQHY2gzXrYVXAcXpxG5Mn6WM4lM3zzjr1SARyLnEmth0GTtw4W00BQwDwxALfqOzpTHfUnqUM7CIH0B+fu50CBYNA0QkFgn+LpEQjE7EAhCPOkSvPosnhysqweoBR84TquOmfylsbEtBC8nl6re+OzGLNuIpQR+9+NtEyPvNFhyunIg+BKDUHD3pJdCEs57rxXd9b34nWoEkRn1mtjxOqa0
 ARXjV72h
 amjdxrXquYXgErvHVt8uFrPKclSslt4KVNH1DhPEWuYlW79xmnkgVgES96i0lQsWixfmTaVlju8KGEZl2RGWVszLLUtfPb8T7Cm8oL4aL/zvjYc+4HWO4iDcZHV+Zcg3eqHgkKPZIE/mxpmOQ4dpwbhGz9Iy58mrQ73iXpneAACEutfWrXA9wgtcNS5bDlMYxuZMnUqp8pnuxCkKZ/endhs2q241BcTMQs7Vm3gKuiuYLzAQm097m6a+QOv9ieyvXHKjWQSVSKhIHCf14oSp//QzNSWQNKVCxeuMkZAMe2qbn3wObAQevPknmdPUVv2SznoId6RM7Duh/NzpvIEeA8q0nBssx6Ep+8tN/6MIY+0tr+RXB1L/+uoFRjGGH6o7edFxDqekG+dtY+dm98dQgt7Eiz9DDB197Rzf+
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
index 0829e0d3b2d1..2cad82cc466d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5159,9 +5159,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
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
index a018d0da4ca7..fc579ba9ab39 100644
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
index 737d50bdd3ef..97888f146571 100644
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
index 89d7ef91c041..bd1538a0a61b 100644
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


