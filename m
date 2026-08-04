Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E691EC55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679F96B009E; Mon,  3 Aug 2026 23:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653406B009F; Mon,  3 Aug 2026 23:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F696B00A0; Mon,  3 Aug 2026 23:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 233D96B009E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABEB6A07FD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:08 +0000 (UTC)
X-FDA: 85062224016.13.B932C52
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id EC6108000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dLbuLL0w;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yohn6K8Ptfa/JAUk45adVcXjDpZpli+rU2UEedJpBRU=;
	b=U0ZWwCZy9nUlecv6iYoTEqzjF+pgxjYxTG6lYTawtet0nyDUWVd/ZKeejtKJlFaaKn45ry
	D2hHVb/JTozy6gDlvTESGJHMDqIIONn0K0YMaQAK2P3uPI46mYuaisMdj5pVbiDRYRPkel
	wdzzdd+RZKbyIdpn4Nc8VvFBVTg/Bjg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815766;
	b=xjffoCxRA5C7gimZgmUm6fOKIIvepLSyEjs1Y3aPEK4zQrX0uDP1aHFyLCqiv29vnvsY0j
	lc6mrDpCkfcnGhVyUPeC3VzvKdd+OZM+biUe3ZdjXVLoI7QUR0lYdgD3AZuN39ryKdVq6N
	4VxyCpxoCLXD2Ri+jZeg7eVMQKcwiRg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dLbuLL0w;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cc97653887so44759595ad.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815766; x=1786420566; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yohn6K8Ptfa/JAUk45adVcXjDpZpli+rU2UEedJpBRU=;
        b=dLbuLL0w6it+ZvqqVxgs1fh+KgXmlPv1/1wyHA5r1nTLPk4kHJ8ya6nTUQQrLxXuFK
         NkB4OvzQtonyZJXh9wbGhTH2teC0FnUivh5kxkQpxTJ2fRoYup5DZRhK61ugva+e3E63
         lJ3sUzOV9LnF0joMKs909K0Zzd6j6MLy7XvgjyG6z/GTSVVAb5dFF8llJI2fs3IvQBKW
         wwXiHr+/GTVwYlLiQ0eL7WObBiknjbATmhDneS22xyePti5tGXJpzVDntvaGwBT3vXFw
         HvkdyTNj6Lc7MibVb94JowBFFVddaN09X9/sOtkpN0YdfM/GkY13IQLIZEh+/Gg6lQQQ
         aAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815766; x=1786420566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yohn6K8Ptfa/JAUk45adVcXjDpZpli+rU2UEedJpBRU=;
        b=PA5uR13STQ0xmUaE0iL6ZAeTMrX95mhMZ+dUdp/z59cV9POJ+RNb3NkXlgM5TMAQ7w
         yCE+DNuIsAWeuKar7BS6lCTQ6khvLFV7ETdeIBIWRVvNuHzdJOBB4aHtmiuh5J4OxPAa
         Omt5TkL3PVA078h1gEUyAF+L3cJobfq+IHVYw+qwKC6HxfLSHEF2ci9ZTEZANYCjZ2V/
         aUJLg5CysCSvnNjqADRcTpcIDWpxf+vYCeSVVicAi3G8ui0+dvxlEfug1G3wtbBUqpxh
         xo7C99ipzBMBmRR+jdrsr/FJ1DfJ3KVsuRJ/ZHZlKGVFTltOsDR+tCp8rbCjv9h6HGMw
         Y2Ng==
X-Forwarded-Encrypted: i=1; AHgh+RotNaFw88kuhDJ/oC81rEgo1k6ENa2j7RqpevJXgtrcNut3uTqk/BJWoQuQEGInFxmyM3br4JD/cA==@kvack.org
X-Gm-Message-State: AOJu0YxvuAYK0pwzHceD+FNe7s2mH8osaMAVSS4zWBCspLoeWB1ZK00p
	CjCFTVifV9Y+KI2bIDUu5irK7jI4bWlQjW0wak0JvJNYyhnEk5XR/zPi8qGgZ6L4xhY=
X-Gm-Gg: AR+sD13MiEJMlx+/rUnNxyOmWLrCRjq0K//2I1bdckQQHaCn5+V/szqEjM0zatfUlbJ
	HuIMGNaSfl283CkW9qzrZU0ygLOLEsE6djBj7jwa+n8gGHadkDtx84mapxvGCpTlhBXmMw6iYa9
	y+0216gtK33Ebn+RuF4hOC+wgguJkYIZUyQImY1X4Q7+8zw+b5R9gxpT2U+2eGiLRmzEfT6w53C
	oOz27bxiS1nRbBdkq6FuBCK1Le/ry0uivIMF/KYjSnHkqVO3l3NI/aLO9ySFAME2FDzDF8BDsSy
	YQ5N3bsg7WKDFppw/ojde6LMXe1kAZEEeNa1RBdKH6f/fQxusfkbtvkQ4WoucwticRw20Z0+Q0I
	qWbLpWLgGshVOEEBDq7JGI0p0iDcyY/giO7r5+kCkmA1dTbQOpTC/3ChehF71hnx6ziOLxsepPF
	hQZCs9LL57+8VMhXjjrupbNZ3XJqTKc4mLC9d0vq/LmAN+xMvOQzoodzlugEvKy2n8qrCTCM4Hc
	O+bXVk5
X-Received: by 2002:a17:902:ce08:b0:2cf:9f0b:b560 with SMTP id d9443c01a7336-2d05246fd0fmr131647825ad.29.1785815765771;
        Mon, 03 Aug 2026 20:56:05 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:05 -0700 (PDT)
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
Subject: [PATCH v3 05/17] mm/sparse-vmemmap: support section-based vmemmap accounting
Date: Tue,  4 Aug 2026 11:55:23 +0800
Message-ID: <20260804035535.2846016-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: 47j7hsxqtxghw5ixw9aj9bpr88w1xb3h
X-Rspamd-Queue-Id: EC6108000C
X-HE-Tag: 1785815766-727920
X-HE-Meta: U2FsdGVkX19lozqsVGVAr9pSI8PKzroznyw5KvU9DvREwoF3MGPG4qhTLmv0hxhJC69vtJF4tVxVHlVFpVWHi9+mhDIzQb4+QgFTiTvpyjS9lzG87pEALBxKrM0SDjHTsoQ0fX3upniqZYPKTyanaqDXk0McOC3VBBg3bLTq5esQHlZSGVJw6AIHmfPh1a42AyerZLuaP1bbJNqo6wCVGisxtW4toKMnbXlYW0a3GA/egS1oBONw1Y8Qlrdibl7gdl4cyOu9DC9JXwizg3atJuVcXPqlm/7nbT295pr15nQsacpZP8hOc7bWlpoyy/Tow7qfEYQTyLD5ca5BzTOCtnhxvwlkQ2jzMyncDU/kr4KV1OtT0Nj9JCwPtM5yGVJ8frzKGe1kcy8ZqsfLqU478J6v14UrZ2Nnu3IGWe1qjtuOq6wDTOmv8i8kGal81vynjgYViJ3SQmEKIp08T2TTBhd1lzVL2g7weRfV44IhacvtNVSMwHM4kRMPbMLuC02Zq2iRqHA3papOIT8/wCG1IcM8m7bD1m3bS9W8eM5Nkg63jQpjszFdHOxEMrt3aVpfrlMFfE4vHaxl5tB5wFg3tbtjMSMkd4qKZkhIB4uHtBvHXgNN2w/AvExqeZCbdRkzEfLOx9fE02MI0WDRXmRJV83MS8U3AUm2inaSitnrKCTkxfi7y8Np+dbzYiUNXeDypR4gAdojfbcI2EQgJ1KVy1FSQidEMT1tx7Ku+RNhE6burpsOGZw2L9SdtvVjwS0vG1IXXHQJeJKYlb/CUrk/gcK/UfYTp3AIQqR45oOt0nvTsOgzNHrA/qoY49noRfvdN564ilj+08BkFqGqQxndSM5dFW9VMP86ydRbkc/OlFVnCEoz2RKKYVikgMw03fCRwWUsfrOT6pqcU70ZQZeBOGKjOekPG+lUESuzEyMZB5Ij7uCsDWfzWgM0Ykm6QtuFANoRB5XLAsgOPKKqWhJ
 81rczet2
 yDtq5nuGpZzeyHGgI3wsoEvgAv9Hqlo4A8A6QRMiaUpg8yNvi0Sj9OtYmuvLajOJYMD7XfXROz3jJ3q7iqtBLeu6rR6XS9z57Ia+R4OsteUh8e2r+HuHoDZpQVLMs/OiYmp8CU4Bf8x5e+rGV6QNn28obA8/2RqsQ2ojmGqnXokhc4jX8zSbexxqzsLwgI42p1p53vQKiZ8yoXfIi7RDH1kY4T2zLnBK1VH64n0mq7MeW93ArQYRHU6e+qhppOTbDgr1nGn7iJVMLy/0fIWysdr5KqRgUttatCADZWLOp49yaL0g8izZmH9A7d9EeQ5zAYdZPRK5LwYFY9jppOG6WJpViKFxsWVbzsI78BFT19k6JCzAEHIQDWLJ4tnVlvAXfmlJ8DpQuLlsSrOE=
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
---
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
index 81e16d71e1f0..663726dd6463 100644
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
index b9b6b47e85ce..6ad190ec48cf 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -43,6 +43,17 @@ static inline bool pfn_vmemmap_optimizable(unsigned long pfn)
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
@@ -80,6 +91,11 @@ static inline void __section_mark_present(struct mem_section *ms,
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
+
+static inline bool section_vmemmap_optimizable(const struct mem_section *section)
+{
+	return vmemmap_optimizable_order(section_order(section));
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
-- 
2.54.0


