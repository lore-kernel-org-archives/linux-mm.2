Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3BDC88E40
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9686B00A6; Thu, 10 Sep 2026 02:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B836B00A7; Thu, 10 Sep 2026 02:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1B86B00A9; Thu, 10 Sep 2026 02:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83ED46B00A6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B79ABC0422
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:03 +0000 (UTC)
X-FDA: 85196887566.06.F886A68
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2B5BC0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ru8QjM7S;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZQQoff6/2tRsBf1VWP2lVrpNpayqt4CNshAPxaCdlQ=;
	b=AtPlZmUvXj0H0FAdy8uSRnaXjclaxsjyq676WzkI5dVOrduXcoWDgTZ7NCXXRHcl1TdeBI
	s4yjZZeOK8x9KGdISeousOp2urG7kx3tta7+hCqUrHhnUtfeb99IgnzYvamzd4MGpInV7G
	qn4x1toJBnMbm0zt2vE8Z28FNw/uol4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022042;
	b=GnVLxpMzkdYhJJ7VtUNJ9wIHjCbdC0vPe6idxMGRHwfkY4rPV/Zl5QpHf/mOmERV8culMl
	qAvGOcf3HfWBZEGIUFzOiwjBG9UuGDjR0hb2rqPWZ1HO7Z+/4wOASYxztmJU5HskV5OJ/h
	+k6Atn1yH8CinXlFnpOgSL1iN+rVG08=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ru8QjM7S;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-398c1101c1bso6395692a91.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022041; x=1789626841; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bZQQoff6/2tRsBf1VWP2lVrpNpayqt4CNshAPxaCdlQ=;
        b=Ru8QjM7SgyAbqsWQ4fmX9TvAmrQSzWomXOXDa3gBHGjrBJSlobkehm0+XJ0O4qCjTh
         mWMr3yggzSvfnLwTrQ2d0KbNbMXVh/QKDpmmu8qAMzKVt0RS99rNXxthUYj4CPSmWCcI
         JGl0sqSww+RQtcJPKydAdxQuU9BhmuQMsvPhiGs2RLivJC0JKMMar3HXgLF0wQo1gH3Z
         nb7SUtwr5Lrg9eoS6G7Fff1BKtup6YvuSEyn4tm5p6SYOOPVMWmg8+eB+2IZEuNogKiH
         jwNB6f5yRDT/ZsHH7EqVXeGTf3657/IySBLqsnTNaKruVExZkgMmj9QuzIh0UnDgpLMJ
         sQbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022041; x=1789626841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bZQQoff6/2tRsBf1VWP2lVrpNpayqt4CNshAPxaCdlQ=;
        b=cBdoHVJrTzRMa+rFWTaNQBxO1zyoe3DIa42xcQ45pssjvo8wqghziIZgDM9d3EUA3a
         SFwusXDIuPa/fX5lnb3oHcQ/Ie5pkhZAIFm8E++bWalQ0AMtnzr6HddpI0e4ekZKl9sR
         KaPweNuykQxxo/IyIwmuj8CHR6o02tt+4yjToJbmIiPBXHbRYCpBiIxcRa2jhUxzPFdZ
         i+6bEBbFis752v+adRTqAQVnb26xo7mIS6xBoB7We5cGJLgQvz1W15UdyhHrvJ8bZvlV
         TJSFBBmBOkI5ls88DmtkN7JIde8tlkE3OCUbRZboUQpTXfQ7LRr492hc69DJ6jzIgGwo
         //9Q==
X-Forwarded-Encrypted: i=1; AKwUvBwOE0QxX5WXW2wIB+BDnod6IKJF+BKl5+kKvbqkCMkqbYlyZhQ1i9MKFxr1bc/Y76n8C4PmXPai/w==@kvack.org
X-Gm-Message-State: AFuF++mIhuosZev4JotIuEz1VupG6qkFowz/2DpHSeLf5JzY4HWx2kTT
	VQUjWbuguXez62BdGB47jz191AUcV8uJcGh682xkG6j+DvSiRAUJU9BchQr8MnGcQJ8=
X-Gm-Gg: AYBFou0fqtu3jIG2mHYruqd5Mj2/xYnKDjTUg7d93TSC+tyGDiSxaFuKWnxDBl2EQRe
	7+AA+CBXctWtubS0iE3rTQokv9Jn3KkaW78EYPlKcp24sBhUHqOGrA6JnZo22t0xOQxraBJYX7T
	igVPDEyF1sctzZDJ3TJFwlHR6wn5/VR5CswfumVM2HerZYuLx0WNG7X7mkpF1IZ8W+x/MQaEACz
	Lga7XW8uQmB+6xIKMDt4oTKrkbA+8dyxQ/L1sxJpkfFcp1fubH1LczFIvTabUfGSTCLcmFSeoV/
	rzuReiDr99oG4kZjN4QR+i0F4lwV2LgFxprJJE07ZSF5+xbojxEQpDgQCNnQutTQgbW+dBU6uZK
	wDSqEN9DXBjN/2Z/kwKaaxr3xzGT3PZCC0LH2FMmkWAlcJFp88+FxdhfxMBqS3xFM4l/3jSmg5B
	B46Wn5EkpbzhXzdu2Wjq7y+WpmR7gPj2rme7qAqpyUP1Hxd4WnQijk6JLNRInX9v/gldbDqRAOh
	M3+L9crKDCDzsunOdiMx3UoN2fqOSLuvwqT2v30XaxSwQ==
X-Received: by 2002:a17:90b:5844:b0:398:dc16:3c29 with SMTP id 98e67ed59e1d1-39b26101530mr61206968a91.7.1789022040618;
        Wed, 09 Sep 2026 23:34:00 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:34:00 -0700 (PDT)
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
Subject: [PATCH v6 10/17] mm/hugetlb: switch HugeTLB to section-based vmemmap optimization
Date: Thu, 10 Sep 2026 14:32:49 +0800
Message-ID: <20260910063256.64386-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F2B5BC0002
X-Stat-Signature: fymap7edh7xb8iadbttt9pa6q3o98zsi
X-HE-Tag: 1789022041-380058
X-HE-Meta: U2FsdGVkX18oseIrs+5oYGrQgBC2a90GUgx3od2io+mVQAi71Z5gZ34vMh5XtNw5QfbFnXv0PSBSbBVUDKuSWAO3m9JntysbsRvyNlje65FOmrLr/XoSNmEXX3OZ4JZkvqPonGwTw9dZLytSKw1qJZiPEjGYOSuqnTETS0C7VJQNvpDfkDCYsiLPJUoz63cLXUQQ0nCcghERPdgKURFLZwgwoDRlYGelQs3NN9MU6XAuqtxtd3Okw3NjsV1obRFuSqXnLM4tFueIGTwfozJgGCIiOTdC7nsKcC23dPo9Ld0Avcz9hv/P9bPfNYalf9JA4U5p2F5o2393qukppeDDUL0F20JKjY6DZPTVauV74GwSA8sEwIuQ6LIopHpW2u/RYhKtDINwYC0DyIqwyAqIiuwoBaWBwKlzr27mmXkBoXLq+A/EuGLjpry5lQDtSRu6JmBjPwELL7rF+eao2HMBRPxOF/BuAc/Ucoj4nYI9wcUgb4CvlgNK0ZvZIMt7wqIgyy1SmtKlLd8QWgBABRrq7KNU8CBQh/3Tk6qjUmmg0cS9sYfK0ORnLdLML9D3NYQopMIHc5wk80479EG2IZbYPUqzN2sPzT7dfMFF8Xy0MATlFqkwyS2wLaTxg6w03kWMD9gp2e2REVNcaiaQ7WSiVTyhgwz2rGEqzbpNsPWmaFB2YOWAX0cytybRuUWlXViDUV2z88lFlrOFgLk0YtqGA1qLdX74IZdit3Yj4477gvLdPnMQQqWxOy1/ZK8xxmuk5IiHwCUQ2UZLbkQDYhh0VUfYEsB3b6KCFjNop4NLjuSIcp2xVeHtpm4sQPOjOFx6y1Y2GbrSrDar/Wu1s67ma9g0pni/MNAJrm7981RgZEbfaiiuNh0ygzzul3Mdpiue09VUxPbMz6wqX1TlUH6HRCBrCUSyj68hWIXno/Pj9/yNXh8svs3NR9KpkKQ54MwFJxKGrOjdyrjc7ncEZkt
 l/SyJ6Uu
 qmrd5cGgN0QNwzzgOAUWXJt4dhTzRJJ9yuSknIUF4jE4r5yYuUUYsPqk8CO8RCgb275NWe1Vba4BfrNhjrmHu/CrFVyWA+ZJbQagHmBQZremobCO3hdSPk/A8rr2outbWurrDitdqHt5tn9lX7iNeBM3d3eQ7H7c7568Pj7BXWN8wHPkne2FNJoIeNzyjCEuojmBUFNvyU8/kZMpfjKqXEFguIcaSQ0IFNN0eyKfP/BB0aeb7nD1t/y10iSreMX1NJlySUWx3xptC1wPivRXCVritn6fIr3rwoa6rWtGisqhVWj+/GePh75dc99QO9KawLqbCDW/R8rzbGXO2PiQjCpygwYOs6kUPZzKBSVUTIW2ZHv5cssQivPrOr45FJytcI3EFNdIxrODbALjph35CZF7/KaPrL6nuznl8
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

Do that by recording the compound page order when a bootmem huge page is
allocated and dropping the dedicated pre-HVO helpers and related
special-casing.

This removes duplicate early setup logic and switches HugeTLB to the
section-based vmemmap optimization path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Rename section order setters for compound page order
  (suggested by David Hildenbrand)
- Collect Acked-by from Qi Zheng

v3:
- Use the order-based helper for the bootmem vmemmap-optimized check

v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h |  1 -
 include/linux/mm.h      |  3 --
 mm/hugetlb.c            | 31 +++-----------
 mm/hugetlb_vmemmap.c    | 91 ++++-------------------------------------
 mm/hugetlb_vmemmap.h    | 14 +++----
 mm/sparse-vmemmap.c     | 31 --------------
 mm/sparse.h             | 30 ++++++++++++++
 7 files changed, 47 insertions(+), 154 deletions(-)

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
index 003cfac98f14..ee5567fcdbe9 100644
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
@@ -3161,6 +3162,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
+		hugetlb_vmemmap_optimize_bootmem_page(m);
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
@@ -3321,6 +3323,8 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 			 * this folio.
 			 */
 			folio_set_hugetlb_vmemmap_optimized(folio);
+		section_set_compound_order_range(folio_pfn(folio),
+						 folio_nr_pages(folio), 0);
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
@@ -3364,31 +3368,6 @@ void __init hugetlb_bootmem_struct_page_init(void)
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
index c48fcea076a5..d1b031dcd177 100644
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
@@ -706,95 +705,19 @@ void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head
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
+	section_set_compound_order_range(pfn, pages_per_huge_page(h),
+					 huge_page_order(h));
+	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
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
index faebf344cdac..8c2b9bed236d 100644
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
index e998347867f4..d3a71ef4fad0 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -16,6 +16,26 @@ static inline unsigned int section_compound_order(const struct mem_section *sect
 	return section->compound_page_order;
 }
 
+static inline void section_set_compound_order(struct mem_section *section,
+					      unsigned int order)
+{
+	VM_WARN_ON(section_compound_order(section) && order &&
+		   section_compound_order(section) != order);
+	section->compound_page_order = order;
+}
+
+static inline void section_set_compound_order_range(unsigned long pfn,
+		unsigned long nr_pages, unsigned int order)
+{
+	unsigned long section_nr = pfn_to_section_nr(pfn);
+
+	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
+		return;
+
+	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
+		section_set_compound_order(__nr_to_section(section_nr + i), order);
+}
+
 static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
 {
 	return section_compound_order(__pfn_to_section(pfn));
@@ -26,6 +46,16 @@ static inline unsigned int section_compound_order(const struct mem_section *sect
 	return 0;
 }
 
+static inline void section_set_compound_order(struct mem_section *section,
+					      unsigned int order)
+{
+}
+
+static inline void section_set_compound_order_range(unsigned long pfn,
+		unsigned long nr_pages, unsigned int order)
+{
+}
+
 static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
 {
 	return 0;
-- 
2.54.0


