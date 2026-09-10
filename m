Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC232C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9D36B00A0; Thu, 10 Sep 2026 02:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B5B6B00A1; Thu, 10 Sep 2026 02:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971596B00A2; Thu, 10 Sep 2026 02:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 684566B00A0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3308160428
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:43 +0000 (UTC)
X-FDA: 85196886726.05.85849B2
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3FA1180013
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ChhtNXTp;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022021;
	b=GsQtmkGnuhZ7/UWTz0ITFuOwdhtCHNCWZmYXVJzZ2VPqp/vOL1PQILQxbHPcipg9fepWMp
	T7BHTU/ukTVthQCHPJRUsvqI83pF61GUgIjANzzL1tPL/QJxasBPJjlwVagCJwISTWYExi
	lVuYGjwTo14mbt7P38dQjqoZmceND18=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ChhtNXTp;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wA3VEQ0Gv26Nz0ZpUy3A1OXLwMHz5Ri5QNZ6qYOOTyY=;
	b=n75H9dUoiEwM7JKo/Tpq0PYE1zsdeFknZTWTky412k3QRv8w3G7gGccxmqF8DfDMU0A0L7
	bjB0maBVdzLCvccFeD8cNBvUvxrJHmZVUpt8VUvcA32Dzs2UbbFNVRKv2WWnjcsgIZnX4o
	nXAXQtGRjNve7GUdnxgRCJWE9dviNMQ=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-39b2ad862bdso7477104a91.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022021; x=1789626821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wA3VEQ0Gv26Nz0ZpUy3A1OXLwMHz5Ri5QNZ6qYOOTyY=;
        b=ChhtNXTpGHvja3BvxY7Q3UOmpNYPAtIe1Hqm/1dUDmE2XmkIGg7h2ovMSdJUiH1F9p
         xTJqRuXBaqiKqBhSFhLgf+aDeSN0Y8b1ca3a/a1j2YmX8KVd/y3jQ+spC3FNI9bwsGWu
         ukj0SQRNh1DDadaZ2u9CUh/I0UN8IeIAqfz9Au3pUup95s7vmy0zoGWTf2DDKlphxorE
         1IkEJ5S2iAGMRRP6PEsGRmj1TNYUS7IlVdT1+M3djWysEhFN+KiE/TQvgFcv0Rb+fiM9
         rCECdroPe6hRUoD2XJ0Fda8Dx5QgUvXCx3zN6v8EXTF3AQuhgDs9Nh0ymeyPx4YdsZfu
         XCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022021; x=1789626821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wA3VEQ0Gv26Nz0ZpUy3A1OXLwMHz5Ri5QNZ6qYOOTyY=;
        b=GI0ojG0DWSMlVL3pcBFqCSsj6EeFkaGG7nvx126GAdk4kwli5cXn6yTsFB0YgrBYVl
         vugv2L+wDCV0fRIBciRApPewN2LNa69V9Z14fnZxzqfQq2cOBoHgj0MUBzQeDs+5MdGp
         lBRNhL02PpjACe7X7tW6luny62AD6uaFEApWMPk3zest5oux3ONNqbqW5XvbGt+bkylL
         h6cpzzxooSi1Ui7Fg9nlyLb4ON+LbcsoLucDDmwRpWGhXUgSoBRIfw9/XYHsZXmJpswN
         mfiwQfP6E2JvHNsLjEFDDsXSnI2JyLeQfsXPzqM3Ajo/AXgKHt6fm/2piMwcsXPYrOHT
         PPQA==
X-Forwarded-Encrypted: i=1; AKwUvBzE8agLqJ47ETHmGLDndAxp8q8wQnUzdUTjZsIqat5sCrM1Qh2q4KOCdIPjJGGUJhSXRvf75vM/bg==@kvack.org
X-Gm-Message-State: AFuF++n5/D97xc0kObnVqnKwLgcDU+NPgQrBMFbAciRN0Vlicnkpwo8J
	vNuUyDGuUDlbVaNPEPe3/2qi6y761Ckxmd/xbT4/u+EPP1KbhQxMUqPLQ+o5pPRYQik=
X-Gm-Gg: AYBFou2R1PYbrmGUG06E7Hnr+VTCfFSvxn2LJ2jAOEiQXArfVC1Dxutx4fGNnbzFSbl
	tpcoID07mSWOdEIbZkHDOx6vNVMqBHkRNr9pqMkKKUzSlM1hK3SSnwa9woSpfnv/PvdtEcIQOIs
	Kihi9NCOK+d1Ffii7PkU8xeZY89DpwEUaloLEfXwhej9bOK2efFjgqkzD5dSZh5j9b8if9A3r5q
	/WVzqXCT6pxPJLTw1R7CaCE75tW1oo9RYcq1RN7rXYRxx8UiTsPzkb8HiGRPZwAlqoEqgiX1Brq
	ZgZ5gtMsg5Up6RG/iJdAp4WT2xjrt7CQpgicnQkj2oW49joio7RTacJBYA3QJwcDNb87DBJwTAR
	c/SXmkdPHrWW1ogvt9n5iyFh7/oTrcYXAiFx7ypukuJyyiCQ6n0Ju0oz4qA/EIWGbVaI0RUeaqS
	NPcuwpED1wAyN0aWnxtJacSuzPPgMh0VDzV+eNtDTnB77uP033Wpl2FTHhihrHMk5FYNQJ66+jP
	hz0LigLmwKbBb7xldzCMlRnRImJHWWA5MM=
X-Received: by 2002:a17:90b:5844:b0:38f:5869:387b with SMTP id 98e67ed59e1d1-39b26101c20mr60325860a91.9.1789022020648;
        Wed, 09 Sep 2026 23:33:40 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:33:40 -0700 (PDT)
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
Subject: [PATCH v6 05/17] mm/sparse-vmemmap: support section-based vmemmap accounting
Date: Thu, 10 Sep 2026 14:32:44 +0800
Message-ID: <20260910063256.64386-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E3FA1180013
X-Stat-Signature: mu6u651e9y4d1d4o9ib8hdcwuncdfx37
X-Rspam-User: 
X-HE-Tag: 1789022021-309042
X-HE-Meta: U2FsdGVkX19cBKjZxyMCFxZtLzI8+ORPOt4k0RBKJ3HMQwFNnTB0Jk4LkuKBJx59FyknO25xlFaIkDI3fQCoc/5GfhO+zd/T82hc/AqLpa4ELUsK5BDmGQTvCUjrKKDvh6Soi31aLFRYcZsH1H+YyFrS2q8llWgBuxzQvV+DvIVP9xWbAVs+8pHQKvV8S0L5d4G+0ZSWKrXEmnu6xN90EwmQ0VZ8e0g1THUek/s0YpJi/fu5xsE7cOQ40HyEw67nzYoNqrFuCjtGI6zr6EH1DeSORksfun8XPQo1aZaHCMAkEMIqeydhS2xtXke0e37wfPPVFCByQAXPWQXiT99RHVmd4TCmZOAf3jmyp07Lszdsj5Y/gADb7jxDBExUOfoi3Fb8BGASU2qKUO5qi2rC0p670xKIUF8Kx+TwBL4uVU2uSHzibK95kokXnPY9oAYxLtEn3y3d6jiCMrbU9uIUsgE5MZQ8XADHlFbkxAYIo3TstrmA0gG85rVl7Rvh/Wqrf9HyYe7dqNHMScrmeMAe7FIt4aX/TSy9HDdnsEtQeM5QaqP70RxkNrxzfiDDsth/e+NrN8ZKBSEXo+Q78NP9A9nLlFs2mB27ks43OIj/CaV7uERlmpjY04Q/0BaEzWhNOc6W6mHcZrfPEKIZD6tXcHZPc/lVR31ln0X4OXhFPGyVrNrCWFjyj2WdWnudlI32DTYxymaF7mmbUy0GnMGmRJdpX9FRby7vn1UYB6XxYK+LiEmCoVQ0GRNcxB7NQULNqpoWDlb8RfF1HyNZsHFnFY0a+tkiQPO+QlfIfIc03J+FgKWkitPh2LwoZAC15OuMBu77h6CM+vldS57rp4hwkoSwmhCFB14mD/NaMZd9sBqoURV8GqxZOv9Ye4ybJ79FWUcI4b3dFNy5nQwJqRdJtfmOISaGNDc+e0Bf0n68vfKD1xYXe5RnSmY7XwnMqpnEpAzyUZx2V8TMa+CMES9
 lLFvZGQu
 jJ+bndgIFru2YJ8Y3X0OBz/Ld+n1yNceXb4pAGq7R2KRTJuFUG62XJ1yJEMwXMxL20bwuIioDyGg2/eERXP6I0I2Pf3jyDZCLj7XOxGJR6Ox/9uldZv6BsQAxqvIDDAIyzckl7JkHb5UWC956A3r/QsWqJjuMGkPL7g0CQJc3q7ga7Kvb9bKhHAcmrZxTdtWqEacENfJYD13jTIJfCTBSXgRyYQpBJ1vNan3OF/pNo+xB/uM4E0VYizD9bzts5/s3O6CfHNlrzY02DqqZrd0z8fj3j+slfKGbmtrepJ8urSKIVPBxJ4mtsuwEk5VwzNDJIC1R/12NKWeHshL9L4ozfZqalALiPh7Kri9we3S+4IFhR7tVQZbP85BiCZr3eJGailhuU8Y6y6EeMilEcTc71ZPRd3O6DuNP6YV7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_nr_vmemmap_pages() can account ordinary sections and DAX
sections, but section-based vmemmap optimization stores the compound
page order in struct mem_section and retains a different number of
vmemmap pages.

Teach section_nr_vmemmap_pages() to recognize section-based optimized
sections and calculate their vmemmap page count from the stored
compound page order and the HVO retained page count.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Use the compound page order helper for vmemmap accounting
  (suggested by David Hildenbrand)
- Collect Acked-by from Qi Zheng

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
index 738bf3d27256..2c4f63e379da 100644
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
index 107215cf8488..dea7179fbc90 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -649,24 +649,26 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
-	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const int order = pgmap ? pgmap->vmemmap_shift : section_compound_order(ms);
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
index da79c83adeae..563fc1f4d717 100644
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
+	return vmemmap_optimizable_order(section_compound_order(ms));
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
-- 
2.54.0


