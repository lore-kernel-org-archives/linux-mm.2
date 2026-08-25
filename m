Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2749C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B69D6B00A0; Tue, 25 Aug 2026 04:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08D006B00A1; Tue, 25 Aug 2026 04:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD6D6B00A2; Tue, 25 Aug 2026 04:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B17A26B00A0
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A54EC037F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:24 +0000 (UTC)
X-FDA: 85139167848.04.7EB287F
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 136DC80008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lu1bbw5T;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhkaTEU/tSM/+MOCHKQTY4aSgCg16Ul5HZ94OnnT8FE=;
	b=UoNjzcbTWUSaHh4nvcS6Hl9AC1V8TTAhc97oEis9GE5/WaH9Nr9ltekNMr1PCL6cn4j6Pu
	JfvSgUq5e6aMCzJWy90jcawuuKqWD/A2OtEok2UiWmODhZgUBwm019ZZpIza+emyh82yDk
	BJkSIIBlpD40otoY9Dg4i759Hf68Xgo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lu1bbw5T;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647762;
	b=sUMIZeHpa97DhDbuSiA3oPeKOptCxdz3a51MJ0d+VNJbCHACkdsdIFXdO2wlrStUtlcgsi
	7L9HxJayR3YS3C6+zCI7zDR1Yt+wugzqUV3BPyynA64OSaM7MmHAgt/DBjpo4/s/L3bdQs
	jtsqV5oZGqItphFMzVilCqD2MfANb/s=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38e58034d05so4013534a91.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647761; x=1788252561; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NhkaTEU/tSM/+MOCHKQTY4aSgCg16Ul5HZ94OnnT8FE=;
        b=lu1bbw5TMlfmwlGWiUlzA0yhe0rYsF67A45ItvLUri1pFwyFF7Ft2YO7aj/ucBJRqZ
         BVll3s9E1eoQuWpnD9ZqLtObLmXT0oV+OJnvaFYmbGcC1XDD6kOwS8INRppVEA/lmo0D
         WAoNfdnBD8+hpMk6V3wb52+GRejRd671qrliyeTHThsTgEfozvJaoKQFI+uCdMhhrpWH
         u5Jul4wtaIVzUd/soNmYN7LJlbqKjtIQx5Sr6xhIme7dJCNs5SZycz5GgsUb6ubbP3ZN
         BCSwx5t2Gawa1KTpmcvH69iT+umoZIEmBFEO8SGP5N08HLY1qm1OG/soks5HDvJuha7F
         S12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647761; x=1788252561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NhkaTEU/tSM/+MOCHKQTY4aSgCg16Ul5HZ94OnnT8FE=;
        b=LcM4FE0IQQV9G757YdZenzcMuzwMkq920v/6kxXFXIz4pw8M2IArtoUWxl4tHoSB8+
         nJweNdW+dbYVGaEJ7r/DZjsdmfGqseTbt9x9N/b7NzzYXjwfQktCNnEvJML8pGYDkdQM
         U9ixKPolAWIQ0J338g8CgCmKzGkvuzTWUC0U0yvUSJ3whAsoJGno6emH4yP3YsT1UFG8
         pkTWyk5xFClPQY3SuXrZWQVgqyxVxgrMxTqu7sRdbdPU/gIetax0v54XzjrPxahzERP7
         LOjtohIGIFmik9ZVLhC7j6ic8DvuXZgPc9ballEnrJ7Xxc45/BgHMCahjGGWbSDWeO7b
         yahg==
X-Forwarded-Encrypted: i=1; AHgh+RoPlKpumXwlGOOs69FYL2mJZQP20O/WLC+Ud1ju2srCWP4JRdA90d7wgepaVyPyBqLu+1UIVfMBhA==@kvack.org
X-Gm-Message-State: AFuF++mn5WLRqO8AgVG28r5e5nWrDfed0BLC/5NtJ4wodxIoxvc6w0+Z
	0aC3Vnb1do5A1wV4BL36T+OWnIgdQ5+Is6/yaFHFqhbWex9KxIu8wH9RzPACnOaAwXw=
X-Gm-Gg: AR+sD138EX9lPBKLUn/I3RGy4gxQNsa0AgUQtDSBUor8idqURSIyzzHnFyRl7WZswQO
	CLzsbEMmrgatqbqZBPCGXda+8KxfLjdwbunk0XUVsFsxWOBDxiLKfSRIh0d+igL56odxDHTVbwu
	m0E75KPZjxaKBPXFovb7TzsV+FyyzUTpobbRW+gBCfm3El9r2hSBwTMBIi37CInFth6IzcrOIE+
	OU8RVEubsvdUyDNg36lpe1UkCnR2OUyz9T0Kfs0+Uq/X1YcJtVePp9SlO7XSSEcJvQlNeCcbMxm
	4RBxpW3k6LUPi/QVuGSWQZ9YQpzX7ujbZTzs476qbn1ydxKRvLlhXQ1tglQntWI+j6p5OAoT8uV
	v0FJKBcIVVi4Sk9MVuhlIYi3CMNhSIhxjZKMWkbMW73td56ddgdlXWMwBKJztw/p/A3fyI4qq0G
	Yzmm7T7SHKGB6YamWs874WPz3evKjI7L+DRCPGi5IosI6Ig0WcqbBR7kVZlekznGLgbvYw2bRKt
	MiY7yuA8JSN/o/bvq+WCM9JjlR7mo+b1h7N
X-Received: by 2002:a17:90b:1e0d:b0:395:4e0d:bc60 with SMTP id 98e67ed59e1d1-395c354d7ebmr51570267a91.9.1787647760819;
        Tue, 25 Aug 2026 01:49:20 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:20 -0700 (PDT)
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
Subject: [PATCH v5 05/17] mm/sparse-vmemmap: support section-based vmemmap accounting
Date: Tue, 25 Aug 2026 16:45:56 +0800
Message-ID: <20260825084608.47437-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 136DC80008
X-Stat-Signature: 7n8sqifz71ra61u8ce5y9wymhwwqfr4a
X-Rspam-User: 
X-HE-Tag: 1787647761-754887
X-HE-Meta: U2FsdGVkX1/QNEm1Ge2wA2lhOPA8Rtewiw6N/P3TOvYT5KX/c2BDyJdjua4MDur1dNJbO6LZpa3Q9p5sCnehX2HTllQiMf0oBPnm5vtvPksglVI7UO6zsebaI2x/btD6ItYCAvkIQ43covE4JDTZpogJsQ8h1GaCrGfLAAQj0PcH0Z3wqlPMXzSKwJDHpgMne96wJnFjnd3UqhGXXG66iPx1B9Gaynkdv7usq+k0QxvDpcxPBI3HN+lStBZ56uELqDvcflCOdu3ba3avJuJMLvyjzjsENDD50hZyl5oBkRGLQfY765liBNW7AMmvU0Hz0wrIMbE+M5iSn7g2nYwbhueexjSIsuc22V8klbv54z4lFtaVNorAVKInigJdoo4fSQVg9yDBCyxfUzzFfGkLq88D+M8RJgaZ75dV0siA3XJQUmEFiVc0zHtPsyLvj9fXdV56RyOj7tAV5hbSKOh6TSYw9/NmN2iW27ZxTIdPQY+gogKbopZ89XbbRKZ+VENJCqE28X13KHM+S+Fit3PbMnicJtqh7DZRqcu62aajdhRybHz3dY4sOd+ewn/e9/ZRJClP5XCuhh/824jiPjhSGK4hIajkr4oVRfzi6x0yUo/D6YrRSR+JN9dThKwn+xxkjpXHkW+UHMQPGBueN/2pEyVhqcvzzNlyxucn76+i+88eqvBrW01JB3Lf4W+D3aJZmGGgzIzKjwufO1U42iA3NaeFHqR/tQ3JZE6JdSSf0fC0/pqKyVS2Ox07+74jqyucfpZWnEwpG2MRM2SR/DJon55GYiK3zB9lFcRRlqOKwOT22vG476XhdhAgAVoPP/F1W0p3mWrzTWGHITX3C5BrdNJObhBvTQBoRZjDT1kabmYhLu3Q71Cs3/WtUq1wi2jehtuDSACkk7Meo5LpkXcKTUPb2beu3OuRccU9fmHuLvMLOHb/T5Tkd/1V/ha57Qi+QM0pVC0nbkduULhcttN
 OFgNOizh
 52KadnLm3VcrSfMfTjjFyYdfJCVipWj7kXX9x8W1n9mcf39dveYImaSxx8l8Uqm9otwRi+/kqyXtzf8XG1hDjv8Ge+AdbxxtFRglUzOIgb4fJwQgTBHfNBhzjdUncpk8KQTrHjxPmXDTwdV1QcBirecDSp7qEGvKfBWiZH8hCa1DRF83RhlYtcJwgiIp5PMeOWnZ2EMLQ0rlyMPzU5FZ7/EHiAsMjVTojj3TTDZ0Ecwc5dAnXojz9/kFLgFrUiFD8taQIzLFbDTXT4zoNcMUUSSEIyapaocxvJxO6x9rosqFfSwkiFyLgDmk4dNIb4adW0dfiZw8mfioiylYYzH7FxtjRKdJUmXoyBwElMkNaocsJvgL6FtgIBIhdwqFwyBflDqhCJP6bu/TQmBQh3CiJa+gT8yLqp5reEuHy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_nr_vmemmap_pages() can account ordinary sections and DAX sections,
but section-based vmemmap optimization keeps its compound order in struct
mem_section and retains a different number of vmemmap pages.

Teach section_nr_vmemmap_pages() to recognize section-based optimized
sections and calculate their vmemmap page count from the section order
and the HVO retained page count.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v5:
- Collect Acked-by from Mike Rapoport

v3:
- Add vmemmap_optimizable_order() for order-based optimization checks

v2:
- Remove an unnecessary vmemmap_can_optimize() call to simplify the code
  (suggested by Mike Rapoport).
- Rewrite the commit message for better understanding.
---
 include/linux/mmzone.h |  6 ++++--
 mm/sparse-vmemmap.c    | 10 ++++++----
 mm/sparse.h            | 16 ++++++++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index df31cac12311..177455d98064 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -107,8 +107,10 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
-/* The number of struct pages covered by the retained vmemmap pages with HVO enabled. */
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(PAGE_SIZE / sizeof(struct page))
+/* The number of retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_PAGES		1
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
+	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
 #define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 107215cf8488..b7abc5494bb9 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -649,24 +649,26 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
-	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+		return vmemmap_pages * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return VMEMMAP_RESERVE_NR;
+		return vmemmap_pages;
 
 	return 0;
 }
diff --git a/mm/sparse.h b/mm/sparse.h
index 1fcda8a1c270..02ed0f34eac8 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -43,6 +43,17 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
 	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
 }
 
+static inline bool vmemmap_optimizable_order(unsigned int order)
+{
+	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+		return false;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
+}
+
 /*
  * mm/sparse.c
  */
@@ -86,6 +97,11 @@ static inline size_t mem_section_usage_size(void)
 	return struct_size_t(struct mem_section_usage, pageblock_flags,
 			     BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS));
 }
+
+static inline bool section_vmemmap_optimizable(const struct mem_section *ms)
+{
+	return vmemmap_optimizable_order(section_order(ms));
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
-- 
2.54.0


