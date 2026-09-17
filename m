Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39826C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB366B009B; Thu, 17 Sep 2026 01:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30DE16B009D; Thu, 17 Sep 2026 01:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223356B009E; Thu, 17 Sep 2026 01:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF0706B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:30:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D241C0210
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:07 +0000 (UTC)
X-FDA: 85222128054.04.0C3A93F
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9C6A9180002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GyWPR3w1;
	spf=pass (imf06.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789623005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iHoeiOn8M1Js0lz6hY05jc0JjGSYBNXCmk3v6q8ZOE=;
	b=lPMzobHn/mrQ+Z6c3KJNEpowtJ4siSnQhfpWJBrhvKWnaYX/ED/qrnVUOyNIv1brD+JYfp
	NgEpGM8H3lfitzG9WPOij8GopYAhpokubbswZIiPwvKcsqYjNaFhaZia5IryuN6z6FDx5o
	0vgSHUbgPV/DQJIxgR8pZpKIYMdo1+U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GyWPR3w1;
	spf=pass (imf06.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789623005;
	b=vTNQezbM2hTDbwepr5DHOLepBeu6bE5XCCKqA1TCHxdTV5vXpJCggnNtheYZn5Air2lmYx
	rZY3t2B6vAymOhvS0KsDML/8KBIr4ybVs80foS+dT4kvgGEcndWi+B63q9hQHm3mmyJ6f4
	LcEj4uoERfATCMv2hl2SqH0/xDIF8ss=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747eefae4so1128645ad.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789623004; x=1790227804; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/iHoeiOn8M1Js0lz6hY05jc0JjGSYBNXCmk3v6q8ZOE=;
        b=GyWPR3w1ioTTAKuX8wBl3wqSbqeej49EAakChJ1WGsPUHKEgKhoYbghc+6jW6ni33S
         P2HnRSFDQWRBNrHTOJ5gmuIoiRycdOXTf/wqPHLS08+fKD/oj+TneDYUOsPZ4LbTgxyR
         FI63DGudxGSWcjg/xniaJw2tMq/OeXHA7ytVWrBTsj8mSrrz+zInkrkCM+dq3BAtJKwO
         ybjHVUsG5IdbmvtOvq01wg9M7H9xNMWjw+gs+bxB7x8Mz0K78levZDtSQ8woJjEKl3p5
         qZISn6yqixGoaug7lLlKhWWUE1F9dCgn9doai6Pq5vvRYV40LfmGQh1yyaU37Iupk27V
         6csA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789623004; x=1790227804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/iHoeiOn8M1Js0lz6hY05jc0JjGSYBNXCmk3v6q8ZOE=;
        b=Glbi8W7GExNcRCmL41xBby0hLsD/c0/B1ZBGW2SofgUtlFKPhxs+ChLLdxVB0LhJ1k
         26GjkkpGFEe+GZbYwTmk1eHSqbIwbMBuKsPCmNA6L51tm8furmv4iEDmwj0ocf/7Sroe
         A3iqmUj90TMGdJ7UZR5pdTz/1S5DetgRCVxcREUdPiQRXOr5r/pRJiHr1dTFoS+E9xyV
         P1qzLYPTo6TRmUtHeGhlNbKQvTEUTc+gyPCoCiZ8W+Mbp1VQCYqnF+FYXjQbEFkpTN6W
         G5kG+QysnfPGX1pG/Lbf7rq+KCG0n3ybOb6+Jep7+fSXNKMradbYHutl7NCsY2bmxkDt
         IthA==
X-Forwarded-Encrypted: i=1; AKwUvBxZYOdYO2U4UwwYtIdhmjGC91me+sQl+BEo+DuUNI2O45kJ6Mn89o16/AqfeDlcwmkH90ohSPcP8A==@kvack.org
X-Gm-Message-State: AFuF++klYhfbqZOs3Rqt3cWumOC6NcuuRbdIk68E5S6lqwWpK3OrbQc3
	QmW75dtTbejHccB2d8JBHFIauB7T92ecOSWbvnGxHUxDwp1gDktPLNWN
X-Gm-Gg: AYBFou1gr194LA3HivpPY5l44TDoqA/uInELt4N/kgNBigXtgD4QEWeXuztusKVWiim
	K2ov8ctRdWYMiyMAHwR2ozkJZVjz8NnOou3mQnIqEbhLX1RZ6BqCq7L1p/qwg6d3kPFY4l9dkSl
	qP6Q/NV+54YVwdJV7iZ67y3i3idhhE4jfVN0GQnQSs+9hc/hoerLUELdnAuX62ouhCrLH2MWJOP
	UMASmOYhClkK63WY42pnubCufG+rC5K7j5WZ7iVWs/pJ1wRCoRupnzqDYHjTps9DSdTeImPAqK9
	rSJNeLifc/LbHUzLd6xGA4wk82H9NnRZ396m2J9UZ6RtPL7LFa0Yc1TGZzfoeX3nirmrP2U2gKL
	SiSnEaM5rJ1p4oKtzGoRifZQt8zXS7jXux7yTSwEwVUAxRdp7Z7G8affIsY46O2t4DT8U4J6f/J
	J1OfGZHew9LKtv7okLQ7tIFQfuNKHT1/OMPqJBVaU3FzXGcmqtz2eBiA+3QqLmPYJ9likkgbgzC
	8lCFoAWSS4rOBnfiIHWEhdGBrc=
X-Received: by 2002:a17:90b:5484:b0:39d:b57e:b47d with SMTP id 98e67ed59e1d1-39e35f809c5mr2777472a91.8.1789623004300;
        Wed, 16 Sep 2026 22:30:04 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:30:03 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v8 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge() for PTE-level block mappings
Date: Thu, 17 Sep 2026 13:29:26 +0800
Message-Id: <20260917052933.188679-4-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: peaxttk6bcgaj7m96s1jramaamohf5yz
X-Rspamd-Queue-Id: 9C6A9180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789623005-780556
X-HE-Meta: U2FsdGVkX19J8zSCbQ7H0WaQoMEkOLo5EujRdG3mGc+686A0x8sb6vGaoWP6GtEWrVoG+0jk+yOZoAbtBqVLomMzQAPcvKNSX4MotOfbN45Ro0qLWHWRY+kh48RpajIb7RfJu1r1yEJuCQRbKlLb1NY9J9QGKc7026FxsIfQZ/unnD4uPES7pmu6kHZ5/fGKreojSK/X19IT4xTPJ1lgtSmiYExEeO6reqpwsrHySBtXu5noCmUIpJCBPWrG2yAKKFXtx8yF606hJU8lRM1i2nTX5hHX/7EdxUdxepA7F35oCGm/29M0HrafAMZsIZ4UfYPCzJO7mBwa5ZaX0Izv/1FoGG1wagViUsD5/Tqj7RFUTinlhYjLdYGJU2IgPaoyTwowTuTRDeSI4M+Uz5BaH581HMoetr6pyUWj1kt9mjyVoOOeWy1fL9DW4DC8dWPZ8x1dqUC+y0yC/q8A3ZqXt5pXkHAQaSz04sJtQzozfmNW0XN6DCc25pk6VqgaR1vZewgJXN97HsB55veR+Vg6FeYOZxTPzmlCjRsY+qsF3qGnlBymIBG2jZIgQ9lUH33ZN3wU6RRH0RuPZWKraM6beCxBq51fsU0qaheJwB1pj+5fNtYkPMJfgPWc9VGcKjB6jWV2EpJTK5e5trZr4vVz/gFUzChrw9Vrqn80a3myRSmukm4ldkpg4ZEDVkc+3BEJiEEIvBXCxx3VwlJn2JbIg4Grzyr38MboMmQDWGWCn2ca5/3Z7s/GWJJdfAIE+tvFE2aygIbdvtWJboXv91WmWSurhdzpBgyqh898POuXVS1fzPR9meyMpsULCYflkLxoirk377eYRgsUFsxAd7EaDTAY+v2WUJna/50WEFPCO418KqbH/iDZ85I6Y0yAwzUPP4ww0wvt+JpiA+MSvirEl4L5ISt8wS84YyiDZbtc429WdAuzPq4c3zb2HmWWKoCWmXNbaa0ObPLjfnQ9sPD
 dJlRJ91F
 154M1Z7OcgLOnt4/h0ZJnL4nO2N9dCWV9ZTslY1ghR7LrJfgfazyJtC81cv2AIHZu7H2WYKuIq9WvJ/JOvcXgzEi2RnP8Lk6J+0TeS+5CA3/LQBJbdWB/hvv0oYjnh5X4ASbJS36jfcULYTd8XCcExicJv1FuuFVlprj8XyW2W6/up+scutZcJtsPcrGbofCuX5foVPN+d0hv742IpPDdP6LUCUQxH9esbwN1pTL/MieTCNFXxa/JQeyhbICGcKD86uT9pbUMlVYFDIHmx2BpkxqSU/cfyMLMdnCtd8U3cwKYKLBE6LlGQnvb4jbvlTnLnSi+UwAa25dn7YaOMxfNylbl3gieTS9sVwepIooHbt6VLJfZG4IE/l8XlUeSC2vz6HZcmG6gxjFlgo/cOqhqdrhWauv9ZwNWhCksAaqFVTk4TP5uVgf243sOj2qMl4qX3eCiLAg9Muo4uuhcEtymq7hvpIcwbtB3jjwKZ4Le+z7vw29LlAJ6xPqfW+8k30c0Bq+b3qEhAYSpqkSNylkV9VQvuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wen Jiang <jiangwen6@xiaomi.com>

vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
the feature silently unavailable on CONFIG_HUGETLB_PAGE=n kernels and
couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.

Now that arm64 and powerpc/8xx provide pte_set_huge() and
pte_clear_huge(), add the generic fallbacks next to the existing
pmd/pud_set_huge() family and convert vmap_pte_range() and
vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
around the block-mapping paths are dropped, so PTE-level block mappings
now also work on CONFIG_HUGETLB_PAGE=n kernels, and mm/vmalloc.c no
longer includes <linux/hugetlb.h>.

The fallbacks exist only to keep the build working on architectures
without PTE-level block mapping support. They are unreachable there:
the callers only run when arch_vmap_pte_range_map_size() or
arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
which requires an arch implementation. WARN_ON_ONCE() makes that
explicit rather than silently doing nothing.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
---
 include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
 mm/vmalloc.c            | 19 ++++++-------------
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a9..349ced999f959 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2134,6 +2134,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 }
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
+/*
+ * PTE-level block mappings for vmap.
+ *
+ * pte_set_huge() only has to be implemented by architectures whose
+ * arch_vmap_pte_range_map_size() can return a size other than PAGE_SIZE.
+ */
+#ifndef __HAVE_ARCH_PTE_SET_HUGE
+static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
+				phys_addr_t phys, pgprot_t prot,
+				unsigned long size)
+{
+	WARN_ON_ONCE(1);
+}
+#endif
+
+/*
+ * Likewise, pte_clear_huge() only has to be implemented by architectures
+ * whose arch_vmap_pte_range_unmap_size() can return a size other than
+ * PAGE_SIZE.
+ */
+#ifndef __HAVE_ARCH_PTE_CLEAR_HUGE
+static inline pte_t pte_clear_huge(pte_t *ptep, unsigned long addr,
+				   unsigned long size)
+{
+	WARN_ON_ONCE(1);
+	return __pte(0);
+}
+#endif
+
 #ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bb6ae08d18f58..025b3a848d564 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -38,7 +38,6 @@
 #include <linux/rbtree_augmented.h>
 #include <linux/overflow.h>
 #include <linux/pgtable.h>
-#include <linux/hugetlb.h>
 #include <linux/sched/mm.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
@@ -98,7 +97,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -119,17 +118,12 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			BUG();
 		}
 
-#ifdef CONFIG_HUGETLB_PAGE
 		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
 		if (size != PAGE_SIZE) {
-			pte_t entry = pfn_pte(pfn, prot);
-
-			entry = arch_make_huge_pte(entry, ilog2(size), 0);
-			set_huge_pte_at(&init_mm, addr, pte, entry, size);
+			pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
 			pfn += PFN_DOWN(size);
 			continue;
 		}
-#endif
 		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
 		pfn++;
 	} while (pte += PFN_DOWN(size), addr += size, addr != end);
@@ -368,25 +362,24 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 {
 	pte_t *pte;
 	pte_t ptent;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
 
 	pte = pte_offset_kernel(pmd, addr);
 	lazy_mmu_mode_enable();
 
 	do {
-#ifdef CONFIG_HUGETLB_PAGE
 		size = arch_vmap_pte_range_unmap_size(addr, pte);
 		if (size != PAGE_SIZE) {
 			if (WARN_ON(!IS_ALIGNED(addr, size))) {
 				addr = ALIGN_DOWN(addr, size);
 				pte = PTR_ALIGN_DOWN(pte, sizeof(*pte) * (size >> PAGE_SHIFT));
 			}
-			ptent = huge_ptep_get_and_clear(&init_mm, addr, pte, size);
+			ptent = pte_clear_huge(pte, addr, size);
 			if (WARN_ON(end - addr < size))
 				size = end - addr;
-		} else
-#endif
+		} else {
 			ptent = ptep_get_and_clear(&init_mm, addr, pte);
+		}
 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
 	} while (pte += (size >> PAGE_SHIFT), addr += size, addr != end);
 
-- 
2.34.1


