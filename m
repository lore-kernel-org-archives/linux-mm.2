Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32129C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3254E6B009D; Mon, 20 Jul 2026 05:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD4A6B009E; Mon, 20 Jul 2026 05:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DD66B009F; Mon, 20 Jul 2026 05:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6E416B009D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F6A9C077F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:06 +0000 (UTC)
X-FDA: 85008638652.23.3D28ED9
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 17E5CC0002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LR6MI5EZ;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/mMY7wFDptG7mxg7a2Zuzc5cMIttYTPNMUojd8S+fU=;
	b=IL9XFIeNMoC3X91sJS8hhX/Er+4cVHrsAEV6G7LlJZx2UpVjvY6jno0yCcHRVk0ODMbl8u
	8AR/Bs4UuSYJIkiIEvrTC/JZNMhpltesWBNivZJYEe8Mqouia+NpwrF87Kwc09Wp7jxMcM
	zwFVfOAjS/KnS6HjJRuZIXlqoFpsn2c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LR6MI5EZ;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539924;
	b=eRDc7xhdwvdDFvRBDKufD0g7H14KaV/aCxIopx/qWdS9mMlf75MmXOUX+nHn7t6ylSU3i3
	NOCm1yuPmqL8sISzVF6TKXFAgoDPAYFxjLW2Dw9HDQv+iPbQEammUmFQa5sPkgAQ/x8f0S
	SLoa9/JW6/x6eY+ux5BSg1aRynEvVuA=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so7781395ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539923; x=1785144723; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T/mMY7wFDptG7mxg7a2Zuzc5cMIttYTPNMUojd8S+fU=;
        b=LR6MI5EZZsPBxzPkkck4+J+B3YXavIfs2NkEhd+A7EcxijHi07BoTtONcdzX3hyrhm
         FzldmxL8PQxNYbwL3rzmfWzYISoGtC3KJlnZSRnYXre8oRNFJ9DARstoRg16mZQkvy+S
         owKZeF6Hh995bLlmm0aCSpApH1s29XlGfZlgGzSrp6vSxAq4cL2/s9cZpQxgtBICCgOe
         D4UTif85zSb3R38o9fRnDrylrT8oYpjJHaltuMTMp9eKS7bEOKrjLTr7V9Xq6WUdcQ4Q
         aHj+N3d2877+T26mY07G89BB8oUBhv+gR3ekr5xqfTJ+LaoCwzBqiR7508hC4XaFJgWV
         2jfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539923; x=1785144723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T/mMY7wFDptG7mxg7a2Zuzc5cMIttYTPNMUojd8S+fU=;
        b=j/jJMa2VPrdmuCRUEywIYXR835YqV9ehbp+j6UOb6baCdb067uu/f4aVgPg47KDiaZ
         dPpC11sAyzGp618orCuEP1lysGC9+nRU2ho6bzzx4gf0hW5M00OwDnu8PyL57z3evz0J
         nlsbCrskV4meGwSfvSsX59M9lLtSS/yr7j0gLjtUc6hmou0N8xRgQtPJy3ZC9b4P3ulo
         oKGhVkBV9lfH3sdPz3jmjFVdcbzfkr98AoYGHvXGwIl5K3gFfyTj6Kx3bJLyl20w9Bth
         54Pbe7rwQecBXTgQ7sIDdxAt2ZJdsXdHoaLuLETCQ0XCUxXwwV52ol5RS8a5ToLRKWI6
         J7zg==
X-Forwarded-Encrypted: i=1; AHgh+Rrn3Y/e5ldFvnTzHCJJPBMYoYBIYdvRgT731H9lGl7ZaDZK7QK8MIQK+200+9utbI/MdmnjHXlr9A==@kvack.org
X-Gm-Message-State: AOJu0YytSslyZNr3ZXlUBOTEb95yAJUX2qMtc8U+pPDG6OlFmsD1O7i8
	vEqww1fU3msoTyCQUsHLPUrmILnMMdfMAV0Iu3rUnw1Wv0Dyw2CPJDE8uf95kA89JcA=
X-Gm-Gg: AfdE7cl9yIFyiCfZtPpgvK+v+FXKMkaShdX00hrqFCIjupoceRI5yPAuLlfczfRFQ9C
	J3iR3m47qMLX04EU7YbofFhH4e9+FhIXE16v0raz8+g2aA4IBpbEDSFjcXAFiJvw3hhSFc/Ehx0
	GT84pem5BY94XJuqMPBIKTjVoDo0bN/k9hKoUdkOn4oIsufatUFnyA14CqRcTb7BA4+QYDXxh0i
	GyG7zKVkdNkH3k2sdTZ8gujNA6N7T5KQSOGq1Evk4Q+WoDmCWmxIK9tkSCzI4n7V8OtFIPQxXvH
	4Jdi1c74VN8t4hP21N0QSuWk+CgxRr9Bi0aLBLhIX+Fcw84rkgHRhG3db/EwmYCCMfva7s5YqID
	K+Lw8JkozcLRXvU9eu7ssiT4XeKi/2Hl/0L+f+jUNAj17khNeYrCA5zPVfl/7aoEk4pH3llyT7F
	EXKwzZJuW91CO+6tujmHMrc5R6pf/5dBR9ow==
X-Received: by 2002:a17:903:41c3:b0:2c7:1200:bd7e with SMTP id d9443c01a7336-2cf3486b0b1mr144824815ad.18.1784539922678;
        Mon, 20 Jul 2026 02:32:02 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:01 -0700 (PDT)
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
Subject: [PATCH v2 03/17] mm/mm_init: skip initializing shared vmemmap tail pages
Date: Mon, 20 Jul 2026 17:31:13 +0800
Message-ID: <20260720093127.540540-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t375dw9s4zzu713hh8ectokm8tsp4fia
X-Rspamd-Queue-Id: 17E5CC0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784539923-73589
X-HE-Meta: U2FsdGVkX19EHXdg63RcakpRAo8GrfRDvGvnVYdsJgzp/wc4qgVMMMLT0D8mrd4cKdQJ1t1K69J3LIWzcLxR1Rs3ZxvI80kEJ+vLGgOOfVFtE8whHWL0io4cqDxVd6JSMOT7f0iMefrSveHvwtl15RBKv8x9P5LIW6tvLG9UM0WimWZ/rwIJrUvZk5WbtrHqvFKQP8W7SSAMKfVurbVgQ9hjNIgGWXnp/q8HmcfkXuc5BaxSA+PR3e6MejwS2d8Wgtyjd29Umli6BGfKnWxlYFI33kZF0LO7nni80EFE519jyNR5/Uv7mkHgsqdqscFWIv6UOIZOibFzNoyAUbho/SPR1FhzRBK1YyT+BU1g5PSIZh/tQ2JmjwD+Lg+2GdS8Ri4i53/DuKQMqw2HT9+zAIPnB9ixclBMb3GfhSfVa0Po+lysH8NZlI8BF+fVWotP6wkn9EDlzUEIKWP0tYUFwnCAIqZnt9noHeBhtdJi8b6H3+BJQCG62j70FXbtgDhNadTzzdIaxXK+NaIsXHbfyFfTa0qSOWb71ezsTMvbTl7lh83gypaPVB/f0gWLbQUT6qXBFXcD0NQzTMY+SYtx505V4tDj1W1sEnMwGx0eP0gRubkzFcD9oBE8ak2ybY/f+fdGiALjLOQ7meE3mW3o22DxomfWVdfW2D19qZMIbnfakRjvfAHFOqT7pmeX9oWZvXosCLfYShIdD2SwRRzvzI3deelL1E3AKRdrQA2aCgukzAXVhdQ0eh8upeBi1Ti3wOqXRapepaUUiwII4qkjr6Ywvt3uwYkFB1lasWYJdcKGPxLTpLSd0/KxCLM7Qn0qfiqXni5CcSZqp5+vaA6wtyHaUXKS/CxUMSdxHHcMmxSDpiYYqdl9aHlU+uSjlzcfG2Ir0pkXNMhRvHB/7AAoq4g+9RnvxSBq6dBhZZhrKu7lwTO69bzLeBJnLn8xCYnyksl1vD0xP4pFA82uRyw
 3er+UyF2
 kv9/54XqFnedZyz8NZn7zf+o14b/7D+nBsYPx/YffBkhv9XICqLil2pDxuPjwM5keqC405ywBuKeXYf+pz3VuNGf9JYWFsFJsUkYM9p0IzTL+QplUAtbrPvL3yCasabJ/9KHdDPT6g/Phgz/q9BMXz0g+QjL1dXawto5u26w/S82oVkB1FQxtmxCEYy7oEou5dK3291qctSZH0D3AQBhXNMJqKQkrUuTdMzknr6oT1npjI77/BtkVbT8O0w4MUl2T9pLYtldmJDeULWyuinwA1v6dFUm/LqFZrJFj/9n8c1qlLnPffHREPNKSdTrYpts6G7afhv5ZDCmEV97b16nwaCGhixKFAzkeFa8gQWlg1VjZTlBnyMwMetZMYEZOtzkGaXZyqzgYFFzugMCiNVQSfZKRWKv8lCFrP3nGRSv3J9N0LBXCHcYysLblFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_range() initializes every struct page in the target range.
For compound pages with vmemmap optimization, the tail struct pages are
backed by a shared vmemmap page.

Initializing those tail struct pages would overwrite the shared
vmemmap page contents, requiring users such as HugeTLB to restore the
metadata afterwards.

Track the compound order for HVO-backed sections and use that metadata
to detect struct pages that fall into the shared tail vmemmap range.
Skip those shared tail pages in memmap_init_range(), then initialize
pageblock migratetypes for the processed range with a helper after the
per-page initialization loop.

The !SPARSEMEM __pfn_to_section() stub is needed only for the build:
memmap_init_range() references __pfn_to_section() after checking
pfn_vmemmap_optimizable(), and !SPARSEMEM builds still have to compile
that code even though pfn_vmemmap_optimizable() folds to false.

This is a preparatory change for consolidating handling across users of
vmemmap optimization, and it also avoids redundant initialization of
shared tail vmemmap pages during early boot.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Fold section order tracking into the first user instead of keeping a
  standalone API-only patch (suggested by Mike Rapoport)
- Rename page_vmemmap_optimizable() to pfn_vmemmap_optimizable() and
  pass a PFN directly (suggested by Mike Rapoport)
- Initialize pageblock migratetypes from a helper after the per-page
  loop (suggested by Mike Rapoport)
- Use a 1G PFN chunk for cond_resched() in the pageblock helper
  (suggested by Mike Rapoport)
- Guard section_order() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
  it returns 0 when HVO is disabled and lets the compiler optimize the
  code as much as possible (suggested by Mike Rapoport)
- Explain why the !SPARSEMEM __pfn_to_section() stub belongs here
  (suggested by Mike Rapoport)
---
 include/linux/mmzone.h | 14 ++++++++++++++
 mm/mm_init.c           | 33 +++++++++++++++++----------------
 mm/sparse.h            | 23 +++++++++++++++++++++++
 3 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 82b0155d886f..2a32101d55e6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2011,6 +2011,14 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	/*
+	 * Normally, sections hold regular (order-0) pages. However, for
+	 * sections with HVO enabled, this tracks the compound page order
+	 * to enable deduplication of redundant vmemmap pages.
+	 */
+	unsigned int order;
+#endif
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
@@ -2365,8 +2373,14 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #endif
 
 #else
+struct mem_section;
+
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
+static inline struct mem_section *__pfn_to_section(unsigned long pfn)
+{
+	return NULL;
+}
 #endif /* CONFIG_SPARSEMEM */
 
 /*
diff --git a/mm/mm_init.c b/mm/mm_init.c
index ddda9d6837f3..dcb757b36902 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -29,6 +29,7 @@
 #include <linux/cma.h>
 #include <linux/crash_dump.h>
 #include <linux/execmem.h>
+#include <linux/sizes.h>
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
@@ -677,19 +678,17 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype, bool atomic)
+		unsigned long nr_pages, int migratetype, bool isolate, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
-		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
-		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
+		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, isolate);
+		if (!atomic && IS_ALIGNED(pfn, PFN_DOWN(SZ_1G)))
 			cond_resched();
 	}
 }
-#endif
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
@@ -884,6 +883,13 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 			}
 		}
 
+		if (pfn_vmemmap_optimizable(pfn)) {
+			unsigned int order = section_order(__pfn_to_section(pfn));
+
+			pfn = min(ALIGN(pfn, 1UL << order), end_pfn);
+			continue;
+		}
+
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
 		if (context == MEMINIT_HOTPLUG) {
@@ -895,18 +901,13 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 				__SetPageOffline(page);
 		}
 
-		/*
-		 * Usually, we want to mark the pageblock MIGRATE_MOVABLE,
-		 * such that unmovable allocations won't be scattered all
-		 * over the place during system boot.
-		 */
-		if (pageblock_aligned(pfn)) {
-			init_pageblock_migratetype(page, migratetype,
-					isolate_pageblock);
+		if (pageblock_aligned(pfn))
 			cond_resched();
-		}
 		pfn++;
 	}
+
+	pageblock_migratetype_init_range(start_pfn, pfn - start_pfn, migratetype,
+					 isolate_pageblock, false);
 }
 
 static void __init memmap_init_zone_range(struct zone *zone,
@@ -1111,7 +1112,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false, false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1923,7 +1924,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
-	pageblock_migratetype_init_range(pfn, nr_pages, mt, true);
+	pageblock_migratetype_init_range(pfn, nr_pages, mt, false, true);
 
 	page = pfn_to_page(pfn);
 
diff --git a/mm/sparse.h b/mm/sparse.h
index 95aa031213f2..030248030dc7 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -51,6 +51,29 @@ static inline void __section_mark_present(struct mem_section *ms,
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return section->order;
+}
+#else
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return 0;
+}
+#endif
+
+static inline bool pfn_vmemmap_optimizable(unsigned long pfn)
+{
+	const unsigned int order = section_order(__pfn_to_section(pfn));
+	const unsigned long nr_pages = 1UL << order;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+}
+
 /*
  * mm/sparse-vmemmap.c
  */
-- 
2.54.0


