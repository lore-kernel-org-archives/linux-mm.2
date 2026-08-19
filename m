Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C602C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A86E6B00A1; Wed, 19 Aug 2026 05:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359276B00A2; Wed, 19 Aug 2026 05:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2484A6B00A3; Wed, 19 Aug 2026 05:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA6366B00A1
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51814804CC
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:15 +0000 (UTC)
X-FDA: 85117555950.02.9FE8DFF
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4960520005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jAlbiZs2;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20tETBVEF5Pi+yuhDabHc5ZMMKGnCZY104Vd+m53HpU=;
	b=og4RPYaEiCw8PPvXtF+FX7ZP7c/WlI0EHg2jGILI2Y6z02MA7tHsvxS8q0ekvHDFJAWOpT
	nj5GQABydEGoI54vBP5Z6fYXE+UVlvjh/JEWucaK/Vsn6LLj+tioTa0KkvQVgGesJ3szzn
	IJJE+q7TtuoLI1zTiccWXQjAfBrB9Eg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jAlbiZs2;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133193;
	b=xqGjLaSEP9sb9sWnVP9yD4K7Tp4U2N8tXpKe8pJNvXQMVpOQRbEOt+LSGL7HX3oCSaz0Ms
	FFv5JN9VZVcBjsDMz+y30bNRR+tXLI6RjqINssyQOq5+WB/hYbxGa/AI0lFWS9EQlP1obx
	BYLh5WK12SUKQYNTYVWHwLJy6LX0v6k=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2caed617615so8431085ad.3
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133190; x=1787737990; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=20tETBVEF5Pi+yuhDabHc5ZMMKGnCZY104Vd+m53HpU=;
        b=jAlbiZs2nlf5SO5Bcq8KWKvCjvnA/uAXzdcmOxsIpnRMG0l7pMnHujxEvolJBBlcdk
         0k89j+mHlX92L5XNRFs11raVexsrsCR+BgImh9fLJKJyYvxqlVHLoo7Tamb8o9EAbmv7
         NBxA8Ap/3pFLx8SlueY1rCViTQAJ7VfcxsMWv78xnbPP/Td6Y6eR8efOdqTC04nLr4jj
         Pqlw3K6W1Y7Z2Y1wXt8FPYSCzWHm6H6Q/d3ExnXwAtha4MEYcTQgYISw06SQpKr5KfdW
         5/Xi6KScDG8LxLFsKgE/QgyRBoLNbXuv6cv8EM/JEUB/Hy6475cl5XlkqZMyhjbvsWSD
         Jk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133190; x=1787737990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=20tETBVEF5Pi+yuhDabHc5ZMMKGnCZY104Vd+m53HpU=;
        b=dnsJEUm4y9iyp9+Vimmt/SX5xoJjvnmbbGn71D8RgBb30tUIUsRw2MVqXfTalB6vvk
         bYko/BE+6oDZknrtEZSVN/i0hW/b8NMfHG1X5oPVSUyqgnSmC5eBYzb1WzU81rz829xG
         6deX1Pt1bRSng1VY3uLXeZDbaxFSG/6ayd6w+lodVSgqXoyauHcEflg/DAbOqfzX5DVh
         4T7DvkDdjFqGWvfY5i0iXVtOXsbtV2MC0T7r6OdIHYlyUiseuC4N8214+GQ8tXK0mNRa
         FUQQ7GCQdEJPHlargxMoVGWhnNcuafBLcEzzwgXnpT8ZNOBczWd2mv3KkLzUcjUFUZfR
         SUWQ==
X-Forwarded-Encrypted: i=1; AHgh+RqXxoykEFcN1R7drIuM6tpxOqSQ6Hh9ENj+MOTKwOO3yFSdbhL1mqKV+37MBIk4s2pce8ympoM5WQ==@kvack.org
X-Gm-Message-State: AFuF++mBGRq+u4//Ezi5XUN1M5kE2F+qXMF39tByjOYi/F8Jk+TbeBBg
	tDs2SS1+pPYBJYJl2AGqy2SKWktLbR61j7E+3Yp13HINzsBGFelWkXWcB64oeuh9/6k=
X-Gm-Gg: AR+sD13DGIPB9kT3cbYwwbdd1zXjUywZzF3hBU3w7WmsUsT8E8xQ8ymashRCrg1/XM/
	8A+rkTZr0pyc61iDP5mmeYA6nA6FMVIIayQv8k5qQils5iB3lDijYHtxz0pI6jrA1leNInjSvKL
	i2kSm+qMu4ZdN8F8PXE609r7gRDaAjwAwZ1gNvcpt5Su2DFBFMcLAJnqksqdH4e9UTUQBJ+AiOf
	9zEE9RL8KabOFJD1ZGqNkrzRUfEvxdIEqJ7uURT0185EDT0cz3DDbGjLVoF0+C3vz3I6XGOl8MW
	7Jul8wnWm1NgEzG8UyZgDYoZo5dXXRm786vj5VZLFkjpejEMcPywV5SzgIALjanBmQFLmYtCTZe
	6CxRRK8EppHf2jRMYJNvKf49hrj8Uge6gtt/tRD+lmX5pt1RCMUfG/e0Gw6SpjxR3HI6sSJsxYt
	y5Uvf7T9OXUixYJH7C3CQUli19q8VCuIiI3tgxnaI7lcwXB2ZAbtUNzHti6WhFxTmbCym/Ra5Sr
	MyBbyo46wW6LjdyutwlnnrXQqyv/S+KESOq
X-Received: by 2002:a17:902:d2d0:b0:2c7:ebfb:618f with SMTP id d9443c01a7336-2d601985763mr48725705ad.14.1787133190083;
        Wed, 19 Aug 2026 02:53:10 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:09 -0700 (PDT)
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
Subject: [PATCH v4 03/17] mm/mm_init: skip initializing shared vmemmap tail pages
Date: Wed, 19 Aug 2026 17:51:25 +0800
Message-ID: <20260819095140.17252-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6kq5a8mbhdamsjy8tcqjsggrya6ugtuz
X-Rspamd-Queue-Id: 4960520005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787133191-544243
X-HE-Meta: U2FsdGVkX1/B+9K/Y+gbplzzzAbq8nPA3QsYFVcuwtdVe52vBzEIOn9oGwTcOCd5EdNKEw5dGh9QGmaetCefRfR/6N6DujG0MPa/eggtp31VzyG5jxzeOeoJSgXyd8rql7SwOEus8fBsX9Ns842weoDGApne3ZEPe3gGtgGYehxTODlS7AXacpKlid5G01sZZhRCNPuSSDShG0CY36JqLFVKstQ9zoozGmpok7N7pEUrjC6JVGA1TDwoPG9+aMTmP+VfRlaV+tNa6a5OQp0anEJCEDeMRnO2UtalEV1Lor24YKAHp3ncdOKmaTBSsuwoNwtvbTzUDmEXWxTYIOioKhdjb2G0T9kYXJ/saHOcs767L2FD94+gKAcUr4ui4X4X6sFWjSqBgNBSP4rLXlMukFuO5PSEFHEPYHj8iTnbSLb3DriOY2TT2/rqdUGrF0uDfnnbDgOn8SvAkNjSiTyReprzJ/fAKkRMDNH1hjsxrX01hPZWJjm2JpvlBj0AYG/z/S8N7czemk405FtHVXqJvfhMyRgMrNq3hP9DQrji8HAaEsftjRmec0Ti+VzKElIwQilPLSytVG/hlhhzUPewNBBqvRiHrh5XR2On/qlf2pa4R0WCvMd+ryXLcC3MNW51amCzbOpEJIqJXkjQfPn0V8rdsAkCgGvSSld9ZziDhe0aiC/Leoowi9BanknsDUzf/blJTeMGstJab3GvKZ2A6Zl6uZkZX55A48RXU5ToO8pfdC8h4l1J0Q1W6zaB5q9TlK5WkghRHinTqGI2r3I/mbrVvYfKV63DVgs0689gNzETiToszxa6bWQsqABnGZ4ZGi/5Ob8a53pLF9dMQodM8Z1kCcBc1A4LasFVl+tMYz6donoAowSpXmTwHqwLgYxtpdM2dj6r55+an/ySq338cFUpHvx4eBqVD0WvjZAmccs/eHsjj6Yf3epjNtP1avEJLsDIwCkc1svB4ne14Vt
 n+6f8klW
 jR9SX2sGMtukr3kjvcXqOnlOkHmnYXDYnoL4slRQZ0Cu/GhG2r2OCMdeh35YQRubjRDfT4zdGynaDA7PFbAaBKfEFCIp38fbQ9G4foZ/Y+sBjkBpVNH7ue4phQk5trYrmriP2c0Fri+sEgVTH8Jb/5/MVdPoXOchGZVx026iACtCPPDodTp3DlZWodF5gLRP6CezsJx1I9LO2/jHJwVnFvB/3JNAvjXPAatjhfI5GBU3X5inuIJGJoDccB4wZRNSgkGnyH7kGI+K2WgKrVNFr2mu4EcvjjPyF5y/ueuhCahd0YBaC0pJUs47C0P9HzU1VuMdC8FQen9PcNsUXYVdFOFVlyZKHAuZiv7eJHFAkaM9xROF0kY4OUFUGT7BI9z1C0GPR9vlVbpdB76GBod7SgKDMH7x+1YdilvdmZs7L3gF5HoZ7+IkpMmAOCQ==
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
v4:
- Rename pfn_vmemmap_optimizable() to vmemmap_optimizable_pfn()
  for consistency with vmemmap_optimizable_order()

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
index 5fb9b37819d5..df31cac12311 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2022,6 +2022,14 @@ struct mem_section {
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
index 1533aebafb68..05c09e755e0b 100644
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
 
+		if (vmemmap_optimizable_pfn(pfn)) {
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
@@ -1921,7 +1921,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
-	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE, true);
+	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE, false, true);
 
 	page = pfn_to_page(pfn);
 
diff --git a/mm/sparse.h b/mm/sparse.h
index 3b744667a7e6..1fcda8a1c270 100644
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
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
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


