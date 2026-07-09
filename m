Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05431C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1270B6B009B; Thu,  9 Jul 2026 06:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE9A6B009D; Thu,  9 Jul 2026 06:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30F46B009E; Thu,  9 Jul 2026 06:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE4786B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:00:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6262B1A044B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:00:28 +0000 (UTC)
X-FDA: 84968793336.11.11A99F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A1ECCA0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:00:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=StbkFvHz;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591226;
	b=yc008Jozj7PqpOTHSFc6rs3ojvHmHiTBDKSKZslmH5M6iwydMEQcurplxvALUFlusB2Bo4
	mC83N0sm5pZ/HRJpizlK/mBCsmsCnzpQJIugxdzndkeuz/DIjBTuW8fJD3CooQM6HnpPIh
	GqlXH71MoBiVojNQL0GPqEIuKIIEI+Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=StbkFvHz;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TrELcVwRYyz8Jzkrxkj7A9TvS/0MDDsv0mFX1UjuUEg=;
	b=0LfFjawjRt5THJkgr0i+rk+pwS7n5sWY0U4XkLuCI1pG1ThDlzzZKuN9OYisY+58VwK3ia
	/g7bWqWiHim8nJMGLXqfnYz1u1eelM4EVAVg7vDNyZOHyH/zW0oLZePBENDsMTwiWOl+gM
	TdLz4CTm0+9IA2/FpTYCbkvyxxJclA0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D8E561372;
	Thu,  9 Jul 2026 10:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE771F000E9;
	Thu,  9 Jul 2026 10:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783591225;
	bh=TrELcVwRYyz8Jzkrxkj7A9TvS/0MDDsv0mFX1UjuUEg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=StbkFvHzawMhF0L4yrlgXoQknDDCvW45GVgyVKeSATD3sS6xlFsVQp7trQfrDH5P7
	 04NV94a2lyluspknNz3Ow/hXxTzu1AZG5xcF+7x8NiHfTl3hGVbXMlDFGbQpUjBJWK
	 VqKp9WEudr61e0Lf1pkXWy/00IKakbMp1yjPoEESVsLJGJWAHWzgOy6r4VEihNUBCi
	 WzwuugtweWvwWEfScgbUOvL33bhVQstQb2CWC74iWnlkFPG8BhNmaeaqEeSIDrTmqM
	 jiTcOnrjI/YYKDAZkBw9ylWcyZSmDd6LTWZY0zDczecZXYpxuMs9rhvTe+FdzpZgbP
	 kFURq7j8z28Bw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 09 Jul 2026 13:00:04 +0300
Subject: [PATCH v2 2/3] mm: split out sparse declarations from internal.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-internal-h-v2-2-695631425968@kernel.org>
References: <20260709-internal-h-v2-0-695631425968@kernel.org>
In-Reply-To: <20260709-internal-h-v2-0-695631425968@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Alexander Potapenko <glider@google.com>, 
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, 
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, kasan-dev@googlegroups.com, 
 kexec@lists.infradead.org, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A1ECCA0002
X-Stat-Signature: x1h3hqsp6yhktaqw197xnxi8j7cctdfq
X-HE-Tag: 1783591226-933680
X-HE-Meta: U2FsdGVkX19PTEWFk+A1dDNexMTOG7GPiYNuKeLD9GgQQuO0S7KTvoAYakBFnRagM6zghkl3oISVqzT2krLn+hOo9lIbaIZlSvqD5pXeVefgYQwQJs4HG/fYgjgd9y/IpOr42TG8ikaHd5c0zeGmzhxOZihYWVcBEAsop2V3HJHLbwV+ctIC8Ta1J/4BCLvSeZBDP+Q9mfABKpjvOGMn9DY2emQuCNzSYGn2tf2t0G2pvZUzS/TE3KxkJc/oZkyCj34QFNbdW5XEHDEBnlm8xtB3BbpmOtLiX2NfaRE7g7unr0UWZPAhUHOAZW5t//R8HZ/im/HTSIeo5ZEe+J0VKMdpfSx++KGwvOYRnM7OzsCKH1yI1WIilm2p9GX4GL56BGIZ5RstJpaW/ERLcT22fZUW/3pyBmmP1AXaVE+6Xrc78tmlE76G22YTrAR4ujhm81GOUjyLY4/Tt5pYGsZJRUA2yzD39uorLlfNoALP5fL8c9D7cVenkO8hXOLZxvw1vaDMMSZZpNJhfcwZtQ+bp8EaqEjm1xqJkt1v8vlEZCJpG6VsJpSLcY+0F9FzfaBdZ0/KEZH5oW4c77SRJYuKdOrlIjm+VvV+PGCg+of2Z5k+Imwek6zrY9kWaEBXLg1nGLdhr06h9cDg3NAk0b6Caoeo6k+yw7smjtwrBsjmAPwDbzeEWolvaFRNaVeQlVW2sH+zO8xgPgq6FIQKbykOuNHR5QCmRRew4dGzEM5jlKnyEWCN6txnvk7RH0HUyGTDrvKeQi4OOE4IjGwQIo+BWO17CVSEJ7qu4SkJF9F/wBR0Xial+Xku/fDlVN13LeNNl/pjh5gW5tXSiV6Nu3r0/ayeHRCSX34SgUGepHlbvWPQFs4UEo4RchAjGQPFKtgafPevE0qy+7ozo/P4bbb1qR7HBvD6Ds2+T57fv9R2qcw4h+qOtu6Zj4C0p3DMpCamQgOPn2INU2fTBfs8pHZ
 UePuhpQy
 Tuj8f8qUpn3fpYpH7rkVr3/M8klGfubfSC+OuAHgmKCVDtiCmnKkaMoqsMKOJdeWa4s7WHS2ddS/zWV47eJYv4fXaMDmmJF/8OZOpVzUYVro72e7GNhRIA+Oh0HMagXFgWdHAc3dL3JGVBHim/No1TD27QIsvjgMNl/hqxCuWA1KNUsYNBALnjUV+5OVCEbJvGgbO/iFCeKk6ePIuBxSnQdiVnqX9iMGfoqY3HUrPN8zUOHpU2JZJSfDfqFQ9I836dvqeA2g7uFqrpRzgVCothUZklQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/internal.h becomes more and more bloated.

Move declarations related to SPARSE and SPARSE_VMEMMAP memory models to
a new mm/sparse.h header.

No functional changes.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 MAINTAINERS         |  1 +
 mm/internal.h       | 52 -------------------------------------------
 mm/mm_init.c        |  1 +
 mm/sparse-vmemmap.c |  1 +
 mm/sparse.c         |  1 +
 mm/sparse.h         | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 67 insertions(+), 52 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 33cef4d8e1ee..5c1aed067656 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16999,6 +16999,7 @@ F:	mm/pgtable-generic.c
 F:	mm/ptdump.c
 F:	mm/sparse-vmemmap.c
 F:	mm/sparse.c
+F:	mm/sparse.h
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
diff --git a/mm/internal.h b/mm/internal.h
index 59adb140fc7a..a29a7dab2e6c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -807,58 +807,6 @@ static inline void init_compound_tail(struct page *tail,
 	prep_compound_tail(tail, head, order);
 }
 
-/*
- * mm/sparse.c
- */
-#ifdef CONFIG_SPARSEMEM
-void sparse_init(void);
-int sparse_index_init(unsigned long section_nr, int nid);
-
-static inline void sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map,
-		struct mem_section_usage *usage, unsigned long flags)
-{
-	unsigned long coded_mem_map;
-
-	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
-
-	/*
-	 * We encode the start PFN of the section into the mem_map such that
-	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
-	 * from the page pointer to obtain the PFN.
-	 */
-	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
-	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
-
-	ms->section_mem_map &= ~SECTION_MAP_MASK;
-	ms->section_mem_map |= coded_mem_map;
-	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
-	ms->usage = usage;
-}
-
-static inline void __section_mark_present(struct mem_section *ms,
-		unsigned long section_nr)
-{
-	if (section_nr > __highest_present_section_nr)
-		__highest_present_section_nr = section_nr;
-
-	ms->section_mem_map |= SECTION_MARKED_PRESENT;
-}
-#else
-static inline void sparse_init(void) {}
-#endif /* CONFIG_SPARSEMEM */
-
-/*
- * mm/sparse-vmemmap.c
- */
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-void sparse_init_subsection_map(void);
-#else
-static inline void sparse_init_subsection_map(void)
-{
-}
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
-
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 39583c028e34..b557e5fe35f3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -35,6 +35,7 @@
 #include "internal.h"
 #include "mm_init.h"
 #include "page_alloc.h"
+#include "sparse.h"
 #include "slab.h"
 #include "shuffle.h"
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 10dd4a9b591b..458b0b9570ff 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -42,6 +42,7 @@
 
 #include "internal.h"
 #include "mm_init.h"
+#include "sparse.h"
 
 /*
  * Allocate a block of memory to be used to back the virtual memory map
diff --git a/mm/sparse.c b/mm/sparse.c
index d54e30f58b93..704a9dec2b9a 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -16,6 +16,7 @@
 #include <linux/vmstat.h>
 #include "internal.h"
 #include "mm_init.h"
+#include "sparse.h"
 #include <asm/dma.h>
 
 /*
diff --git a/mm/sparse.h b/mm/sparse.h
new file mode 100644
index 000000000000..95aa031213f2
--- /dev/null
+++ b/mm/sparse.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * sparse.h:
+ *
+ * mm/ internal sparse and sparse-vmemmap declarations
+ */
+
+#ifndef __MM_SPARSE_H
+#define __MM_SPARSE_H
+
+#include <linux/mmzone.h>
+
+/*
+ * mm/sparse.c
+ */
+#ifdef CONFIG_SPARSEMEM
+void sparse_init(void);
+int sparse_index_init(unsigned long section_nr, int nid);
+
+static inline void sparse_init_one_section(struct mem_section *ms,
+		unsigned long pnum, struct page *mem_map,
+		struct mem_section_usage *usage, unsigned long flags)
+{
+	unsigned long coded_mem_map;
+
+	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
+
+	/*
+	 * We encode the start PFN of the section into the mem_map such that
+	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
+	 * from the page pointer to obtain the PFN.
+	 */
+	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
+	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
+
+	ms->section_mem_map &= ~SECTION_MAP_MASK;
+	ms->section_mem_map |= coded_mem_map;
+	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
+	ms->usage = usage;
+}
+
+static inline void __section_mark_present(struct mem_section *ms,
+		unsigned long section_nr)
+{
+	if (section_nr > __highest_present_section_nr)
+		__highest_present_section_nr = section_nr;
+
+	ms->section_mem_map |= SECTION_MARKED_PRESENT;
+}
+#else
+static inline void sparse_init(void) {}
+#endif /* CONFIG_SPARSEMEM */
+
+/*
+ * mm/sparse-vmemmap.c
+ */
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+void sparse_init_subsection_map(void);
+#else
+static inline void sparse_init_subsection_map(void) {}
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
+
+#endif /* __MM_SPARSE_H */

-- 
2.53.0


