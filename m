Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C36DC61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410806B00AA; Tue, 25 Aug 2026 04:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1976B00AB; Tue, 25 Aug 2026 04:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B446B00AC; Tue, 25 Aug 2026 04:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F09466B00AA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AC77A035E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:44 +0000 (UTC)
X-FDA: 85139168688.25.16E7E0B
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 81021140005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KhKiFO2g;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwgAWVwCNaVWIKBy7+zcDip0pYJw7K4FkYIqMzHRNkk=;
	b=ZS6QFTRWEX3Hgo9yyNbo6R6naPtOkvZS7onWwILOjTl9ps7GH5/yfs7cY6+BaXqoJ56Drn
	847cvYZeg3O6rDgdegKXK3nUR+/XcTSXBt2RgEN64P+vW9tqBaiVVA2AXenaJWTIBJGWK0
	pgT8akNnRaVlW5GyQH0oE4tUYMhSVfg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647782;
	b=kSErOajAu+hLZgCJDKq4+mK5hZC228rW/3eqpBGcYjCd1T2XrBCJxeiqdtzEMJvjd9QPeT
	EekGG1lmbQ6+GlHcOWz8bM2we0mFDWDYk9zaoRPD/gqi9gQcgz7yJBPbW6O+MW7Cs1TxhO
	sBJfHf5ayDqoBTMQVP6U+TNcdtzfgkM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KhKiFO2g;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d6af66ca14so20616755ad.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647781; x=1788252581; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BwgAWVwCNaVWIKBy7+zcDip0pYJw7K4FkYIqMzHRNkk=;
        b=KhKiFO2gAsaIIolmj/E7RaU1/sXBCKjUhXCq/wdHBZqnP059/brPp292Op4N8ACzv6
         5szXytrOVbuzcXYm7WS2NGbgLh32JY9+Q7yFks1h4jH5/GgK+CzdOUp7TU3Ws7EGiWTW
         X9ysoZViWn3t+s2N1neTlMGU2Q7jqigAmmhGuwYHg6c7hBwfwQBzAoZyy4kFUUY3jn++
         UgGJE0WtFFZpRsZs6pAue4NfmsY8rLXUVLlT8UMcVHK1/u/pPfygqRRcxHhGNug5upD5
         sR42rYCsPdNcv/u4pSvtawWqXDMXcrrsoJA2OnS0oUp4HAkVtXsx7eREULLquaZVju03
         PHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647781; x=1788252581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BwgAWVwCNaVWIKBy7+zcDip0pYJw7K4FkYIqMzHRNkk=;
        b=h39YZkCcPcws6ZfF1Q79SIb+wLb4mPzPtPij7nHSs5iNtOYTcvNpSU6hFWsgVuy5bg
         l592go2hjNBLXBYcFJTiqQCT5fKVmwYha+SZIgkQj6QP/4nQXuqbR7/XAlp5mEJoZeIq
         OQSelzg391g8JskV2RHa54brzcWVXTjoylxkdoaVGk+y6YbWShXy/KCiOHzuFfc7Wpap
         A2hdeWmOZZ5yMe9I9b2v1vKF1Qw9ZHFoBbOoIlvDpryxgNhMcswhZHUF60pQjgJ6mrt7
         hHaoe17l1ax7hswTKmCrGz0HMNPM/XsLWxfiVYHtrgGVBfxIqz2es2wkYNOYQp2NEdPd
         41Rw==
X-Forwarded-Encrypted: i=1; AHgh+Rq31bqBlzJa2W/HYwCwArEhkqdmGPR2p/MGtC5hKK4RceVvV+3rozX154VTHYWvVHbSm8txSCWP+A==@kvack.org
X-Gm-Message-State: AFuF++kcstRqVhlJtsoqyto6SuTv+fP4f/cyw6F5AlJK/KFQ/92QgWDj
	kDDtJgiqUc1iiTz4U21dxwM45eUmGfwMUTSnqrifTpPgZPf8TQBlMQ11MhbeZlWJmVRT9eS4U4l
	G5znAO9Y=
X-Gm-Gg: AR+sD10WPl0NTio9sW1yKK7cepRGT1D+YrRAtrrxbdTNKPAUv9rASwaM8sseOA1wOKz
	589DeR3F3xJSyCrdN3uEs2lZtr1wNPNCHaFLIL1H2+xoOvb6VJ+sshsOyXLHQ9Ls5wKHYg1bGOF
	eCnRCk/uvCrBpP4YCVzpxJxFQ0b2v9isaVYUxaGAgAaDgqzw9sXH8eyBgtkv6TV3fw1QISBFYoO
	U9ofv5+w1YQgYAYCJe3LbAg9VGRFHBWli1B3kMl9zzDTf1dGqKLcvkj9WCBhTyhcPKe1yetdntF
	UrbK9NCGRbuzBJiWXcBLspATO3PrOSicoQt1f2QoOL0sww1EGvpAfYa7c7Me+ZNTk0vP8KoQvl3
	7nzDpAC59mzqpEflM6ME0uwZZiwdOcV713Ukbe+CtNN041eooW7pK5YZBx+/9b+xjllpmeCcgY7
	FXRokNw9OaER9vscTuOkKJgY2A7MVOvIIsGw1SE2XtD0fYkbIvlPoQ8GymwAsT8QveUC9vwz/p9
	JwJB1HjgbJXUsDH1q6ds48PI2Cpz17yw18V
X-Received: by 2002:a17:90b:4d0e:b0:38e:659b:f366 with SMTP id 98e67ed59e1d1-395decb87edmr35646834a91.0.1787647781257;
        Tue, 25 Aug 2026 01:49:41 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:40 -0700 (PDT)
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
Subject: [PATCH v5 10/17] mm/hugetlb: switch HugeTLB to section-based vmemmap optimization
Date: Tue, 25 Aug 2026 16:46:01 +0800
Message-ID: <20260825084608.47437-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 49du94moxb75f67hhhe6eqmd57ta8hi8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81021140005
X-HE-Tag: 1787647782-666762
X-HE-Meta: U2FsdGVkX18WV3jhuZ29DzN6PfLccXQEmNZz0uN1Ak6EWA00af5kR99vPuXN2N6y4s/O7RaTccOjoRhYwo7NFXoVsDT2bUvRBUCbiB1zDNpZluq9+vjx0LA7+Rk/t/8kioMxwVvtPzHpIua+p3X7+y+ZsEY7iwvFcpT79rHiVjdz/JK7LU5ye+ojUZ4AnYX5nnaJ6rO3EuAQwjaWLuK+mfjeXf43lVj0d1KXBDLTZiBdVS1BAeRhsn1iuKqhNgchtCoI1WLeKWEIToRW1Lo0mcEtmB+m9HYTkQsRhOfuWgr/NMIdg6VmdHwAbka9fVlBZmoWQr/1JOlHdRDkVQX7dpNp23WuexIVoJgd0S3kFP82tPgpBlzaE9F7UjNawgHCTmAN3XkL+iIpO2EjYVYWlO06SVrfBDzcLXCNqx3X3xY6pCaA7Tfg7i+1/lnX1SOwJAIV0Lwkw797J6laLwHc+lt0USmCzKD8q771pospfjthTs6jd9kpimZneS3uJCZC4uMMw2J6AjPydgM21EWraHQEVlzabkOz7TNsdB8JWycGUR0XgciFObC3X62lzJVcBK9srp4jbEY9Cap0Mur6nAcPSiHSMa41eQuMAfOUjCWITR0L6ZENYs+CN8y4IvQGYB+KZBi6dl1+cBNjTqw5BYD93GvRCgn9Cww5WY69xkbyt28YzYjHcIumfjEk73kdhDOYcQD1htl1iR9qa7aQcObFBUiYkWE6KXlPRaAUSdPmzhZ/o7YRXJQw9mUUZTCtmrudSkGc+Muws6AjJQqEfR+mX5z9TXaIICqVsDuirl4qAd+wvWXPOOAifb6ontJdIMmjZdn5TzYbBoedlkrXEP0zL/MdZ+H0v1D8GKrgRLcoacZ8/Iq1E5IyHH8BbU33qxmRHdQ5mG6mn+s/WtLJeVafJb+hSvR6wGYKPloQEWSHgvEZWqHyI+hj2bJNHVh/CuBoxJsvqMn+oxhSNTB
 smHCPUJM
 qM41wv2xncF/iKQMDiWtmDe7jUZr/i58/66SLfBUCDWCD1VOuEXIQaiScAVQieoo3UaxdpUwrnbQz68JYQHvgdJWZnCkt2pWK/JNNEylmmcgKaFMQ4HYaR6MKWjnRgCjwL2b9lh6w2vGd5z54ePEcmUd7ddq3lJCcuYCkNlATZepS4ofXiJHIGLjX423HoG87Qcl7FPWkdCaRdMDH1WJ0HpO6NYU5dcji7BXt7ZjQRKZ3Qox25wbWMZmSeOL9XD3ee4cs7czv6O/LXTtKJUlooJcOMi46IOxrsTaq58HYXHTjOiJXHHiiAGDNZR01ePUol2F+Ow3eC3zzq74TFn/Qc4A9Mjudf0lUOx8cXASBHo7N6pDUz4dhl2BG/Ni/tXX4ShSEfKVEXH/CZ6Mm8JGsFHQTD3LdccgWdZgt
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
index dd09c438fa23..441bd39eab73 100644
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
index 04e6c4244cd6..fbb0c83bea79 100644
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
@@ -3139,6 +3140,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+		hugetlb_vmemmap_optimize_bootmem_page(m);
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
@@ -3299,6 +3301,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 			 * this folio.
 			 */
 			folio_set_hugetlb_vmemmap_optimized(folio);
+		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
@@ -3342,31 +3345,6 @@ void __init hugetlb_bootmem_struct_page_init(void)
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
index 8d39196f6d93..e48758805a8f 100644
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
@@ -404,34 +402,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
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
@@ -634,7 +604,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
  */
 void __init sparse_vmemmap_init_nid_early(int nid)
 {
-	hugetlb_vmemmap_init_early(nid);
 }
 #endif
 
diff --git a/mm/sparse.h b/mm/sparse.h
index e4617f9c8876..049272aba84e 100644
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


