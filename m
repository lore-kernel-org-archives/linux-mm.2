Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 997DBC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB3F6B0099; Mon,  3 Aug 2026 23:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB416B009B; Mon,  3 Aug 2026 23:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A1E6B009D; Mon,  3 Aug 2026 23:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE8A6B0099
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D752B120862
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:01 +0000 (UTC)
X-FDA: 85062223722.28.73D3850
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 740CA100006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:55:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hNQLieL4;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815760;
	b=5RZrEDU3hxtCKX9aOqE5SG05j82HpEiXJFZzaLh1Pl3G1pYyYBhHUw2VBNSvyxilQsuvA4
	ApBDml4Bw05BVjLNzezpSdF5+lL0XGMFyrbQz0IXp+lQhGvNPnS7WqFgSioGwu5nEi0uIk
	WCskRbsjDYDMm6ly1pBnV5B+fqT1U9U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hNQLieL4;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7rwKsso5Cym2RVCEFeMn64q7fu6QVT+bsIVBVphtqw=;
	b=VfShs06quXHOXlb1LpZElOUmbDNCBOou/Mihx8bL0k7huFKeBeia7kIvOFX3o4NsjKwXLa
	2WCgk679Es4PhrpdhRjy9ACY+u7moKOje8eIee8FeX5yu5N9+aDsCADF2VT81o3PdYHEv9
	iYyrDFWXDjTMkFZpMV9RiIJF36M6/kE=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso31892535ad.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815757; x=1786420557; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c7rwKsso5Cym2RVCEFeMn64q7fu6QVT+bsIVBVphtqw=;
        b=hNQLieL4e1Il4ktuFggxoYq8rY/fQ7N222V+tBn6uW7mm/BRWae3ylAY1McC98cJ0l
         ntNrp5+UXVG7A9p1pYwY8ClxrxCpb2llgLQv765pJ8fxv/AlZ87OBgmbyDWSzcBc0wvj
         QhJB2A+Wtyihnn7MkNixjbsGf5lqqt6YZa1C9+yRpnWLofWgXwm8jTMC76YF9aCh2MRW
         0stj7BME40UMwhVfsGSRyN/ZWgiEUinp5XnsE7jn9VCthXOx5UvUKaQHYylCZt4M3H1B
         IFv5K7wEZ7heC1nEtCdDuAaBViadwqlSn79cYJlIEL3/LjI6AgV8St0R/YjqCIG0VDhF
         Qiqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815757; x=1786420557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c7rwKsso5Cym2RVCEFeMn64q7fu6QVT+bsIVBVphtqw=;
        b=jpQhgrmPmDg5tFU9sosVzFu0LgTeXRcXp4a7MjHdG8KLBqPHFl+YOytsss1kmjsK/N
         O/HN84ArKvs5jzeIsShwnsNkxnB/Sb4kaJyUPj0ihB3pyJSnSlT0P7FbrhUnrhWMqPzE
         DeIYAhYnPKe/ndaKDySoYHyqQqTE8i4svyE8W5mGYrKl8dJZ5/2tkvGHOM12Rkrlb3kH
         PKOWssDmdeV7G6fewxF9glIb/rteIWnjINZr0PLvikdFwlmFBKhvwoFaaNah5frE+ng8
         Z0d034qN9tII5FlQJWzOvZiBy+zlTkNlXjLLFjNethDw7O1rNzfThPzaryUCPssKbyHZ
         M5DA==
X-Forwarded-Encrypted: i=1; AHgh+Rr+2+OkrretMzZaEhHyFujSOBsfeVOPolgjRxnL6qI2xMgluQjAZMo+A3ach91HEIvC/1uTiCnbww==@kvack.org
X-Gm-Message-State: AOJu0Yze/HS9jPcaRQP/afhGhKragnDr1cweqYl4jkyg9FGDI4T/s2bL
	OvLW7lQKjJeusQKjcbq8hpirlZweyJEykxTerKlHE1CWudJ0ASfzzdOuNu139nxlmOU=
X-Gm-Gg: AR+sD10uQ0NG9Ap+15b2GBqIjY2IAxas1HicADRBOGO8+AdzOm4EzrFXcVZnvP7/qMR
	qzMmMeOcqzZeJkJC7uPfbU3MGK2q3XE5yb2pjuUjvu7nLNlClctdLCh3yLDUafIZdLsFqAEvbDD
	MCgh6vnOwbOOyHeJBf1vvD2wtNxI+jNfxnrmwg9t6T3Vod4Kk444rX6L0b81ZVAUgKSBdGbP1L1
	6v0jBBTtNmEbJafIU3qHuYOGmwyrY6ll4jkPtoE16caZH4o9chMf9ZqsWaWH6nbJtF4xV+7+NOZ
	MnC4nosL0og65xc8rCRwLSX2TWjvuWfGKmqxLn+9aVqGJatm7YB3IltmRLdm4qROPcaGWFbV/2R
	6+h7SrZYK1yJIjE/VDSP8Du1snDE9rUKSoPI4bSBeWEhWof4SBE2pXjLAKpNC9MdAEDRmERLxyv
	xXTqCXP84UlmB0Ct3n50fcC066fkBduI3Bydx26E0nADRpHfcft9JqS2plPQYwfe/gsXvbjXNAW
	2OH4OLcTQ==
X-Received: by 2002:a17:903:2f50:b0:2c9:b8b7:5d1c with SMTP id d9443c01a7336-2d0521b7f1emr128708045ad.16.1785815757210;
        Mon, 03 Aug 2026 20:55:57 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:55:55 -0700 (PDT)
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
Subject: [PATCH v3 03/17] mm/mm_init: skip initializing shared vmemmap tail pages
Date: Tue,  4 Aug 2026 11:55:21 +0800
Message-ID: <20260804035535.2846016-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mc8mdhe98ixgc7mixhpjumfq8yat15or
X-Rspamd-Queue-Id: 740CA100006
X-Rspamd-Server: rspam08
X-HE-Tag: 1785815758-447050
X-HE-Meta: U2FsdGVkX19WyR8qXgUjUG0d/UQGKKMozHwMbRfgipaqdO1+86zpalI6g8WkdAyVhvA9ebnMXuE1bOT8GV8LxPk8ShyZwVOG+JCiptZPCf4/J7DN1agcpQnInhUWqiR89qkbCoFEUvuG7txK3qDxM4aTnKbrRlR+/acyz4cD55QbqhiK9KtfMT7lw24RXefICkYVyFBTPq0vFl+NOZTTzxi3ow2rzyR2hoLIrC+hA7kDjbNU4XCLf71bju/8+o9nRk6jgPtSbzFNNb10ft6kpWpPppjlMmvYXAEvwllshrnHH+naYSYpcA06lIRuT4/trKMR2mpKOZ0Txsx18sr/GWkLm8Vn4elsrETWIRPn2nFqoaHf4s7oerDtTywwR1TZ0sWQzAIXUrtn+hHYYWgr84zRheiRI1cIN6S2kQpVqI9L0a3OzFJwdz+s0DVDNYaKtrorv8VkrBfZnqpLGse2sddTHCSP+DQj2L1sNzxhpd0wk2HqWPAc2j5vd4MJ4rcSGP8YQQZwE3nITLtdPAqP3bzRSMmAB6aJMRGA0PixZDXWZokOWgov8rZgGeo9/NmVBP1de+jtGNB2RBxrt3fjQ74WACgW5zTs74bReDkbUniAq3b78LoWLmNLLiVP5AVyz5r0wanwX74816LLOkdjPzuld2gkb7UpE8QErk7wY5fDUvsH9tMCCiUOwoEApOKCk8VWe+CH6K+s4OjMcPwpzWemQs8smCVSMGWedaN8FFvCEe+nCprku3aShntuqgqkTTJBBcVye1qBO9d54D66PhjbyO2F1qEaZBIO+qzrmMpX/0Ydvvl9P0YqDodfNWSRtQtFFPknn/uEalIqKixFEDW/JrtVxWFSJVsh1JKQSvn412viny45k6diLH0Z/TEM3rTfiPOrVM+I6j9fV0PUBvMPb0hmCLLVOJTbjv31pLfZ15Ra7jf2nSmxxnTJjKGiWxaHq+6qmetAk3KxjBt
 nF3n2XYp
 Rvj7Ykid1ijBqGBKCN5sFmY5iL3ZmOoNsb+xzXF0MFkJ92NDB5jOk5n/4Sfp6lCYDS3HYuiHII32A58sxVq14x3hxEklumkuk/gbyG/PYqAg2LXeVXJv8fAnT259mbBhl1Tr7B/6NxmP0BWx7e08YI14zJBrY2fDyhsjjpa88rMCB+oQlwRJB/LT/cCihOg3W97kARkBakuyCR8KCTCw7x9RzSr55a8+cXbYcTievURPCQo6N2k+N/hZuHtuE6M3UKWxbyP9U0S+BCuxoEJqOX0DGlFiXw8hiuNffBdl/jp++7qhcAhffu7ADouR3eOr9UUXEM749vFT2LIRGx4AptjhIcU3a+Iz92Un7Uq3Gs/npuo5cPIbJ1QVtPVxemz+9gVdTvWQGLNqCPLNUXTKlzv+shnihZBt1sd+kFRbf0gw+9gJ2PYqy8yqneQ==
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

Keep direct mem_section access inside sparse helpers by exposing
pfn_to_section_order() to users that only need the order associated with
a PFN. This lets memmap_init_range() skip shared tail vmemmap pages
without exposing __pfn_to_section() to !SPARSEMEM builds.

This is a preparatory change for consolidating handling across users of
vmemmap optimization, and it also avoids redundant initialization of
shared tail vmemmap pages during early boot.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v3:
- Replace the !SPARSEMEM __pfn_to_section() stub with
  pfn_to_section_order() (suggested by Mike Rapoport)

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
 include/linux/mmzone.h |  8 ++++++++
 mm/mm_init.c           | 34 +++++++++++++++++-----------------
 mm/sparse.h            | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 17 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f96a45ac558f..81e16d71e1f0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2023,6 +2023,14 @@ struct mem_section {
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
diff --git a/mm/mm_init.c b/mm/mm_init.c
index e5aa20a9b898..1823381a69bb 100644
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
@@ -677,21 +678,19 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype, bool atomic)
+		unsigned long nr_pages, int migratetype, bool isolate, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
 		enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
 
-		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
-		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
+		init_pageblock_migratetype(pfn_to_page(pfn), mt, isolate);
+		if (!atomic && IS_ALIGNED(pfn, PFN_DOWN(SZ_1G)))
 			cond_resched();
 	}
 }
-#endif
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
@@ -886,6 +885,13 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 			}
 		}
 
+		if (pfn_vmemmap_optimizable(pfn)) {
+			unsigned int order = pfn_to_section_order(pfn);
+
+			pfn = min(ALIGN(pfn, 1UL << order), end_pfn);
+			continue;
+		}
+
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
 		if (context == MEMINIT_HOTPLUG) {
@@ -897,19 +903,13 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 				__SetPageOffline(page);
 		}
 
-		/*
-		 * Usually, we want to mark the pageblock MIGRATE_MOVABLE,
-		 * such that unmovable allocations won't be scattered all
-		 * over the place during system boot.
-		 */
-		if (pageblock_aligned(pfn)) {
-			enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
-
-			init_pageblock_migratetype(page, mt, isolate_pageblock);
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
@@ -1112,7 +1112,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false, false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1922,7 +1922,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
-	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE, true);
+	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE, false, true);
 
 	page = pfn_to_page(pfn);
 
diff --git a/mm/sparse.h b/mm/sparse.h
index 95aa031213f2..b9b6b47e85ce 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -10,6 +10,39 @@
 
 #include <linux/mmzone.h>
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return section->order;
+}
+
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+	return section_order(__pfn_to_section(pfn));
+}
+#else
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return 0;
+}
+
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+	return 0;
+}
+#endif
+
+static inline bool pfn_vmemmap_optimizable(unsigned long pfn)
+{
+	const unsigned int order = pfn_to_section_order(pfn);
+	const unsigned long nr_pages = 1UL << order;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+}
+
 /*
  * mm/sparse.c
  */
-- 
2.54.0


