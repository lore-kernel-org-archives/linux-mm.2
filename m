Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 177BEC44503
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02BAE6B0096; Thu,  9 Jul 2026 02:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0032D6B0098; Thu,  9 Jul 2026 02:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C156B0099; Thu,  9 Jul 2026 02:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B91466B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:42:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4814FC2569
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:42:12 +0000 (UTC)
X-FDA: 84968293704.14.CE10714
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9377818000E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:42:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EpKq0rX7;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783579330;
	b=be0Z0RN4ywzT5t2sTOR5hr0fvcdaI5zidSTI0a8k506XlcWI+GUkzzCj4VALdcpgAL7AZD
	u9DAzcDrw2xopWNZVwlJC/h7CzmuZqUL3u85/tu3UsdOnd01WiE6OX4lww6y9b+A6LCuRz
	uZuj2itZui3iMqeSNY793iXsYX2eLTU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EpKq0rX7;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783579330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lk6NZKSyfvP8qY4wirUwcY/CWU1GrxzbQKJbKa4/tds=;
	b=YFPAjwv7pM/CTjEagK4JhoJ3E5in9KcCTNwBV7g9WJGUNUrt2+/j/HFa9/1mibJifRHy3l
	2Jd+1fEfuxd1IDb3yuvwWfbFm2ixgLqHeffHdpngXWyl7yxedSa0dZ8vmtbzo1Jrn9vlA6
	w9pRCG2s+omDiF35Tkmu9+ivKGTOyrY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E22BD43A64;
	Thu,  9 Jul 2026 06:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD371F000E9;
	Thu,  9 Jul 2026 06:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783579329;
	bh=lk6NZKSyfvP8qY4wirUwcY/CWU1GrxzbQKJbKa4/tds=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EpKq0rX7j2v6MtATxB+UWMtaxum0UBPfNHtUKOFC6l3Y+pu8mEO5XvDRFxYNOuXIx
	 RgZnflhXOiREfmPzwGfxsAH2d/iTNnT/BBdI3fEy9hVir3o24KZf1HcwfRQyG9vFmX
	 BOZ3npTlhD3nJ0Y95D0UtoS+w9nfKqcLqSyp3V208hVS2G2ptal4MazxYphmbe5QwQ
	 luIJYN1vnMUvGcVXhbejBGv6I4lT8IzswgZHIfqHDqlIO0XmnQbfZ7VCnScInGMu4t
	 UqmbLTJ+whhhgTL001YHj8fRCuVoRLmWqFQnh81hmVUD6EIvTpaDzuNpd2+srIQGdG
	 nsJI0BA+SOTiA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 09 Jul 2026 09:41:48 +0300
Subject: [PATCH 2/3] mm: split out sparse declarations from internal.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-internal-h-v1-2-956d5092782d@kernel.org>
References: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
In-Reply-To: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9377818000E
X-Stat-Signature: 7xytgu4jz71b3qnx8a5ce117ippmundn
X-HE-Tag: 1783579330-757040
X-HE-Meta: U2FsdGVkX18lgCUIK7OuHS4+aJ8XA3O/jCoqO5tWIcJVUgUqo03CVkiwcTqjFRDzLON7apa3TKLGZplzU015C67/m3uqStsl7Gr2/6nfEDQODKuNTrl7xDcLJ5y5DUAMH3XCqq5v/7PPLueVRmmownT1cybewIfbLchXrujKdPx6vfabOcxIq6yo6+ZIlbrV+55ksmL4rpMctf12P718AQbRsgFBN5tEhaXrOmKEFIu9EuNPW1mSUGU94EVjvghdDIZB44G4Jeu2Q4rs7T9vc9h8IsKaFcTWcqgRvJ//15kgy4uZ+gxR6+R6iYBLnuGiYpozUCM5Lfpzd/iovDP7P/JLxAm6SnirV0UDnFZZbPaGijn396z1JjV0CRcl3OvrXHV8qIUc2ymWLc0wLfP+DtTSWaxItU/x0GehIbKosz7AlLWpp/QoqNkI/n/pNfk5mDj7Nf2GM624waq4yd9Ys1pzBKZbxn6Qx1QhSL0QZzcGwJWkTDEMYVuaHOQmC/BlBBfXRWRItOas2f1+Uv+80U841s1IHyq56hfTrPKxJU24aNXDYDEZwkyWqh1ctMUX1qg7v+nL+p9JRVx6z2krVJ1V/doClfnDs+ifunwos6PodCT5EAkeoXdvJ78JvpKb4NbNzngo26en1R8DpvdLSuLV/Vjynus3Ptyjzeyz029u1YhtAeftW0C99ReGjDcUj5F+ZXWvE3ZoK+2WuZ2bTqydnekDtI+sCqndFPjUWtSMHkvUOA2mjox6kVbwV9FsxvQ05/PWF7Yn9KKZ7sCw6hMu1VHWVjPMrdibDJS23I8Xuetl6314JFSuDRvwsjjiIlgPpAGIBp1Rcn7eDquJluA4K9Ar0aMt9I5zBduvZOhKVgRrmz5bRzPY50RNwEgVRfhmBub6EFKZ7xQP8bjB3bIsa4AUEoQ4HhfUsYWXE4NpMwqekyM75oPezd9NBtmUB37VxRfJZWfO1y49cOQ
 hrRpohG8
 raXIlCAlhQj4RMp1OZbQa2wivkm95iyW0peqWP9FgDRwa/CKveYOg22jrybD725eMPE+GZnOEKuPsh9lyGE8e0tj8JffRtOH1+VmRFaWE8xP92OzgfF9DqQu6KLCyG08MH2nOaojrq5rqbZWuC5dF1taCJUFP/v6vAQfW9F8xx1nNg/0aTpPoK6G/hl6FI04mGrwqrUC3QcwCtBxtTydka1YC511U2yo+YjYIInBTGdSdAgpO3LyZdwI/tIguoo1VBxlix/My0Ck19nMJtdnp6Ip4sA==
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
---
 MAINTAINERS         |  1 +
 mm/internal.h       | 52 -------------------------------------------
 mm/mm_init.c        |  1 +
 mm/sparse-vmemmap.c |  1 +
 mm/sparse.c         |  2 ++
 mm/sparse.h         | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 68 insertions(+), 52 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 537dbfd01362..406ccfe63974 100644
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
index c514b17c61b8..860cd31c3da5 100644
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
index 058ef9300367..4b21dd8c7dfb 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -16,6 +16,8 @@
 #include <linux/bootmem_info.h>
 #include <linux/vmstat.h>
 #include "internal.h"
+#include "mm_init.h"
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


