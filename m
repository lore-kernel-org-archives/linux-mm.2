Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFDD1C98328
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA976B009F; Sat, 26 Sep 2026 22:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A27E6B00A0; Sat, 26 Sep 2026 22:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8586B00A1; Sat, 26 Sep 2026 22:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6726B009F
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD4AE80972
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:32 +0000 (UTC)
X-FDA: 85258026504.01.7A6F3F9
Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2669620002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=apBJVRNr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477731;
	b=Mi9IvRblG49AUvPekspFUgkHLxZ0Yq1O1aay4ewuORyTA6QTGywsqDCya+aqqAadP7utvH
	6V0m6jmHz3l4e8VpGCF8m4GmYwjvsGIu9yTRmxQALx/yGfy1xzqrrLc7UhVTp4VPpQCX8/
	irOtBqvogA9k4rsGbIx5W527j5cqmY0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=apBJVRNr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAcaB474KEF0IVelcpOPWrCamxFeX3XsOjErZzGRGOo=;
	b=wvTcEGFymYqqY12a1zGlizAglOb2G2IO096dH6c8BfTcal2S9ejT0RC0ZYazMf4V7ymkEW
	IlT3ro9slUMsNbfmAewr4EhvnYwAEkbPsr6lNWSqMXxFn5MdJLdJMYz2RqwRriK21nAXqJ
	61Ofo5dWn3gE77Yy/DzU8uh9fSRNb38=
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a0bd71827eso1035487a91.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477730; x=1791082530; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pAcaB474KEF0IVelcpOPWrCamxFeX3XsOjErZzGRGOo=;
        b=apBJVRNrRBMv1YKWb42Yb29HaUsN+M3gxPKeDsvfHnM0AvKUuceqeUPse4e59yjAeS
         QkW6Y973q5OtHJYYzQgFbbBSN1pLwsFKXI6IL6UHzssn+yYIsba1nfihbYuT6a/3MNBb
         w+OvETrdt1X5T8jMlAIrccj5B1LTEv9uvjxe/4DUJ2p6wj4H8JktNn3HJR+jRWJlLwiU
         M0Ho9AXLtjPjQj8+BGF8C8Q+CduhduG9aGAqNVrasbSi2KhTA6Jy+pe9PYErli9+SLm3
         BhomvWpRacvkLLV57vblPkHRbZFOtZRuuHcp269se0ZBchI/UtaKV1KOdLgIEex4e8Ow
         PSxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477730; x=1791082530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pAcaB474KEF0IVelcpOPWrCamxFeX3XsOjErZzGRGOo=;
        b=M9xVUkgUUBs+X9b39x/CZQUJZYnW6Sd+kegq65pIuEtreJWZQrvR5bzHiH0hk/LVJr
         KOzHyrvu9REfrWDkCifZe78uZqwakgX0ZuHjzMCdhbzwqcwABd0drwNzfCEF9HX/GOX5
         kK16xNL/9yLKgxV1UmwsTqKjbrfA3QW6qyKslnKJLZG753IwEyW9n2eyC2QgaaXjAjX3
         +ODyTzDChdMffOwvI6oCgmzu230IA4Ywr7tZGO0GGRAdP9VDth1FgAipt0brKz983nli
         OsQtZJPW919TOE9PzVpM2maiBCtDqst0jjEcLwjGMZTJeGXnHg3s1AmhRWr1PNhUrJm+
         xWtQ==
X-Gm-Message-State: AFq9FYLeVeMfLe9QhJmY+tO9Nls8lG0ZzMvpZyoiaq8sOkPB2stgPDr8
	d4IufpJaQ5V7UY0zKmBnJrTERTrVjNXwtLsmEdzAoD5n1bSeWc23sSSx1MRqnXiT+/s=
X-Gm-Gg: AYBFou1atUqXVXyR0hhFUiVI6XWsKcCGQIpHtZ7RRqrulyyeAL88niUs2yw1a8wSRIO
	tIjRi6oUPJib8MZiX1Qk3KqpEAw6yQtwwvZahs+Iq8wHaMOlfuDLB7kjA7wvYHNPFs9ga5Ddif5
	uDb6T1PYUHHMBR0AmASCoa9/57+38CKG1RgdWGmLgTkfU8Wvv5d/lkErjx1VsVJBNGFEfpOLG0s
	FttPX4a6GABOHnhPTtGoiG/yuyiyjzcmg9HbbjmT7uDoB61Vg1Bu+Y5lfUaXVI9Znae4dtqJk3b
	AhDRXlxeQRXf7Rr7WqFMktXi0o3tavSrt+G2pzs4WHRKKSWllBrVWLYkj0CBDJcpHJYNHAsUE0w
	EJcAK/BJpd7tfGo+7YeqQYV1By0bbiOg4TIvWKOkB7jTdxQejbTO/i62mKyzTNkdALKqEQyhZLD
	FMVc7Q7yskQIBtE+LsCV7uw7Tv/ethecPwp6Yk1JDHoffDATKRaRbWC81mkRDeIWK/fk8GhrnEj
	G4upq54/DD08bgiXWaB
X-Received: by 2002:a17:90a:d41:b0:39e:4c81:6c5f with SMTP id 98e67ed59e1d1-3a0986079a8mr5017252a91.26.1790477729889;
        Sat, 26 Sep 2026 19:55:29 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:29 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 08/12] mm/sparse-vmemmap: move vmemmap optimization helpers to a public header
Date: Sun, 27 Sep 2026 10:54:37 +0800
Message-ID: <20260927025441.741633-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: rpx7mk1c4h474anaage1d4tpmehg89ja
X-Rspam-User: 
X-Rspamd-Queue-Id: 2669620002
X-HE-Tag: 1790477731-58637
X-HE-Meta: U2FsdGVkX18VyyiJAel2JaTl1TqWgm+ivf6y0yMHJDBJTaCcEpG1t6lGhU8R7HdK7k3vxl0MFVzervvPfJG2y7yWsiBwesqcirxq0+sTMpgB3syDGY9meOVRBpmQKURHl1uRNMj2FSLYq9pg1SN46KB6NAB+QiDLZ4fUSAmVJoG0IOeZY8phy+MZ9K+NaKNegc9a3KXFYkkaNDQWLgkxW3OmsJCcbiByWAez834HakE5KPG047HVvjgAwnD6OPggUm75Ex8fIIadGUnXs+gJAsEOLKLBa9cgSHWl+BiqWEwK3BuaDtfLTJVIvrLoCHFJRvDIyj8RUJ7QeRIHhP220Boc/GwPO58UTDnnYGt7ATvHKCP9oaAJfJj6pBidV+3KAlWvAzM2mIxzAFzOmPkJeMhhEgtU1e3I7RO0328nqmGzcNivPlwyBTdQFCXXX2dwmePi6DBOdlJA36HysENLFMW5+VMdnwLshP0LffzrQvlEUCG5Ybv5g2NFER9YkAMtle9LT2ru8O6Z5KuTpwpoIddKDmrZA6l6wPueNIebzd37lghsmcMVhqs4kggVHEyuNOtkUu0xVKU/ic3a8hZB8pK22vVz+aB05/hPVFqBA7H075FjOjURAu8pfOX7/Dv6OnzWzXWC5Ick0HHrtncQeG8Q3jWBS/jKZjc6OCwZFuRCTZ4NcjLgyayTxQZGlOP6lc+xIVxRLqm99CM5dFooc7sOUKys/3cjE1GEHp7v9k+KUDegfI1qbOJ+0QTYcDa55S2r/kpYx3N/Q1SHRab2xi86MNj3KSrqfziUMaw20b4IfVX2M6OB5zfmgu33oxXDn+lsm+VciDCJhpHQXUD/Qry6DbuRRWFowjxHx7sMJg2Rns6fZt3gWfEpDVEx9SkLhTzC1EEvJMloIe02MHKGxzqLKf2VHr2J+QcS6dQ4Hk5wrU+HTFyJfKicFtuNnS80VNR+ps4KOxx89rrh+lT
 Rwu/FdXj
 NmgOhzzpArtJbXjW07hoGEETSF+mgChkPtk4P0wlcGG2kicUL89kru5zpRYm9xepYPf4a3iKXBosmVco8hRCgEegYOf1R/kT5tKoRs6jF5flGb/4lxBxJvR/n/QDiq6oPveMEMnnb20v/5DJiLQ6qGiVlW/0FQNs1lOg3yjJEAb25OTfHaaSiKbshFHvjskJywcRflKAtioL9r9sdDDGIskYKMX4Rak4VDgVmkCZfwSd1qjQIu8NUJEnMTJeJ8pN/78jco/pnHz8Z/4dkCTeUuEhTY4bc0e94Fzd1vXHnAJExnFh/6U9bEBtVzw9sdBJohvCFGNxp3DHcJyY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vmemmap optimization helpers currently live in mm/sparse.h,
which is an internal MM header. That works for MM code, but
prevents powerpc from using the same interfaces without including a
private header.

Move the declarations and inline helpers to vmemmap-optimization.h.
This is a preparatory change for powerpc, which has its own vmemmap
optimization implementation and needs to use the common vmemmap
optimization interfaces from architecture code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v5:
- Move the VMEMMAP_OPTIMIZATION_* macros and MAX_FOLIO_VMEMMAP_ALIGN to
  vmemmap-optimization.h

v4:
- Use the renamed VMEMMAP_OPTIMIZATION config in the public header
- Collect Acked-by from Mike Rapoport

v3:
- Update the subject and commit message to describe common vmemmap
  optimization helpers
- Collect Acked-by from Qi Zheng

v2:
- Fix missing header dependencies.
---
 MAINTAINERS                          |   1 +
 arch/loongarch/include/asm/pgtable.h |   1 +
 arch/riscv/mm/init.c                 |   1 +
 include/linux/mmzone.h               |  17 -----
 include/linux/vmemmap-optimization.h | 109 +++++++++++++++++++++++++++
 mm/hugetlb.c                         |   2 +-
 mm/hugetlb_vmemmap.c                 |   2 +-
 mm/sparse.h                          |  78 +------------------
 8 files changed, 115 insertions(+), 96 deletions(-)
 create mode 100644 include/linux/vmemmap-optimization.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7eae9228f547..6aa7308cb6c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12096,6 +12096,7 @@ F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
 F:	fs/hugetlbfs/
 F:	include/linux/hugetlb.h
+F:	include/linux/vmemmap-optimization.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c
 F:	mm/hugetlb_cgroup.c
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index cf29a4c8ac59..f87603135131 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -72,6 +72,7 @@
 
 #include <linux/mm_types.h>
 #include <linux/mmzone.h>
+#include <linux/vmemmap-optimization.h>
 #include <asm/fixmap.h>
 #include <asm/sparsemem.h>
 
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index fb37b0b67efe..857f9a55039c 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/hugetlb.h>
 #include <linux/kfence.h>
 #include <linux/execmem.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/alternative.h>
 #include <asm/fixmap.h>
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index cd68c1904c91..65de3bb13eb3 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -96,23 +96,6 @@
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
-/*
- * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
- * be naturally aligned with regard to the folio size.
- *
- * HVO which is only active if the size of struct page is a power of 2.
- */
-#define MAX_FOLIO_VMEMMAP_ALIGN					\
-	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
-	 is_power_of_2(sizeof(struct page)) ?			\
-	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
-
-/* The number of retained vmemmap pages with HVO enabled. */
-#define VMEMMAP_OPTIMIZATION_PAGES		1
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
-	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
-#define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
-
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
new file mode 100644
index 000000000000..bd0974b262a4
--- /dev/null
+++ b/include/linux/vmemmap-optimization.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * vmemmap-optimization.h
+ *
+ * Generic vmemmap optimization declarations.
+ *
+ * Author: Muchun Song <songmuchun@bytedance.com>
+ */
+#ifndef _LINUX_VMEMMAP_OPTIMIZATION_H
+#define _LINUX_VMEMMAP_OPTIMIZATION_H
+
+#include <linux/align.h>
+#include <linux/log2.h>
+#include <linux/mmdebug.h>
+#include <linux/mmzone.h>
+
+/*
+ * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
+ * be naturally aligned with regard to the folio size.
+ *
+ * HVO which is only active if the size of struct page is a power of 2.
+ */
+#define MAX_FOLIO_VMEMMAP_ALIGN					\
+	(IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION) &&		\
+	 is_power_of_2(sizeof(struct page)) ?			\
+	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
+
+/* The number of retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_PAGES		1
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
+	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
+
+#ifdef CONFIG_VMEMMAP_OPTIMIZATION
+static inline unsigned int section_compound_order(const struct mem_section *section)
+{
+	return section->compound_page_order;
+}
+
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
+static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
+{
+	return section_compound_order(__pfn_to_section(pfn));
+}
+
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
+#else
+static inline unsigned int section_compound_order(const struct mem_section *section)
+{
+	return 0;
+}
+
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
+static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
+{
+	return 0;
+}
+#endif /* CONFIG_VMEMMAP_OPTIMIZATION */
+
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
+{
+	const unsigned int order = pfn_to_section_compound_order(pfn);
+	const unsigned long nr_pages = 1UL << order;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+}
+
+static inline bool vmemmap_optimizable_order(unsigned int order)
+{
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
+		return false;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
+}
+#endif /* _LINUX_VMEMMAP_OPTIMIZATION_H */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fd00141b089a..2003439ea13c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -38,6 +38,7 @@
 #include <linux/mm_inline.h>
 #include <linux/padata.h>
 #include <linux/pgalloc.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/page.h>
 #include <asm/tlb.h>
@@ -52,7 +53,6 @@
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
 #include "mm_init.h"
-#include "sparse.h"
 #include <linux/page-isolation.h>
 
 #define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 76765c97ff68..0057fa2a16a8 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -15,10 +15,10 @@
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
-#include "sparse.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
diff --git a/mm/sparse.h b/mm/sparse.h
index 326ad43bb5c3..a5111087ee3a 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -9,80 +9,7 @@
 #define __MM_SPARSE_H
 
 #include <linux/mmzone.h>
-
-#ifdef CONFIG_VMEMMAP_OPTIMIZATION
-static inline unsigned int section_compound_order(const struct mem_section *section)
-{
-	return section->compound_page_order;
-}
-
-static inline void section_set_compound_order(struct mem_section *section,
-					      unsigned int order)
-{
-	VM_WARN_ON(section_compound_order(section) && order &&
-		   section_compound_order(section) != order);
-	section->compound_page_order = order;
-}
-
-static inline void section_set_compound_order_range(unsigned long pfn,
-		unsigned long nr_pages, unsigned int order)
-{
-	unsigned long section_nr = pfn_to_section_nr(pfn);
-
-	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
-		return;
-
-	for (unsigned long i = 0; i < nr_pages / PAGES_PER_SECTION; i++)
-		section_set_compound_order(__nr_to_section(section_nr + i), order);
-}
-
-static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
-{
-	return section_compound_order(__pfn_to_section(pfn));
-}
-#else
-static inline unsigned int section_compound_order(const struct mem_section *section)
-{
-	return 0;
-}
-
-static inline void section_set_compound_order(struct mem_section *section,
-					      unsigned int order)
-{
-}
-
-static inline void section_set_compound_order_range(unsigned long pfn,
-		unsigned long nr_pages, unsigned int order)
-{
-}
-
-static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
-{
-	return 0;
-}
-#endif
-
-static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
-{
-	const unsigned int order = pfn_to_section_compound_order(pfn);
-	const unsigned long nr_pages = 1UL << order;
-
-	if (!is_power_of_2(sizeof(struct page)))
-		return false;
-
-	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
-}
-
-static inline bool vmemmap_optimizable_order(unsigned int order)
-{
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!is_power_of_2(sizeof(struct page)))
-		return false;
-
-	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
-}
+#include <linux/vmemmap-optimization.h>
 
 /*
  * mm/sparse.c
@@ -142,9 +69,6 @@ static inline void sparse_sections_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#ifdef CONFIG_VMEMMAP_OPTIMIZATION
-struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
-#endif
 void sparse_init_subsection_map(void);
 int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-- 
2.54.0


