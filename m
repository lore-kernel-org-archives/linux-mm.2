Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 355A3C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C356B00A5; Wed, 19 Aug 2026 05:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974E46B00A7; Wed, 19 Aug 2026 05:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892646B00A5; Wed, 19 Aug 2026 05:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59AAA6B00A5
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9FFF1C1576
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:24 +0000 (UTC)
X-FDA: 85117556328.30.C46132D
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id A28EB140009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GlMojh1A;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJXoGFcGTrfgHmFDIP9742DptQ/jUwqkzOwo8zU38YU=;
	b=X8mJQdwvzmNj+51DR8w9JnPZnJToivVEiIQOn5YtTxG5djk56uvk5qXYp9rR3y6sdN5xM8
	5RZony/sKZglIQzyyoyTLVy/3soBqoagePwWPUqFuAMERdmNpl9w6yg7U3xaXNb8lVI806
	0hwsr6h8C3IKse3f4H9HQtfodqPvwmQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GlMojh1A;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133202;
	b=D3br8/yyImJ7rzEzjv+fmT2vU38EnpRqi7UKNSZyPADUTh7iV3wqjX5kXObngRNGIaienV
	ZVVmgLILI5S99cUfDnv8EaCQBZxCyOkvzUoITodY5YhMg7M3ESG8U7mXbtwQZX4Gg0ZqNi
	ew/Io3xdnVveAG7F2CBzfza90j+eSUs=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso9355675ad.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133201; x=1787738001; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rJXoGFcGTrfgHmFDIP9742DptQ/jUwqkzOwo8zU38YU=;
        b=GlMojh1ASrRIsFYkTKc7plfaAwgnIDUa41d7nc1XfY9v7kHWAbjc9slvbyIyKXKRiq
         /ZzlcKt2L9IoORruHogV9nz6kHgVNyGy4F8kYHasrkcTYg8OgERnd0k7yDq/FGECdLXd
         812KLm1gbgHiaQ7NKn8/fj2zAzn1HnahoiXz+D8RdwTQDw4y+xBjg1RCu6iWu8wIRgHg
         LDhXbrfgXWbdJgn5po8QLyKUa2TJb3PYzsHZ9EptY9N4IGjY98ShYxaFw9eCJcjcwH55
         NGybAPxMub/CFTRXik+kspSAxbBVv4AN7V+FlbbVobYhi86iyUv9qR1eaV/rYj5hShAC
         Ms6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133201; x=1787738001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rJXoGFcGTrfgHmFDIP9742DptQ/jUwqkzOwo8zU38YU=;
        b=pXFI5zqkINS1t018Taun6lauczyCuIcYPnKpD3E0gRzGQxwpotCsMVLYHDM3Hyvg89
         nu0ZqPrMZHgDWRVsDgfhBQwr/5xb4RRRB5sSR72G5xF8938PWNaEziA3FGrOL7Qn40zL
         OLj1NDqXnYcPvUuUU/1lRBNTcanuKpj/8m5n+m2x6ZDuXk+Xwf3nz1876qvqmS2MQJ5j
         ogUpSH1hjd9V67e9PNk380zPb4pJBeWld97I3E4bHB3RMe+kab5vDX4matx7pB3OZqF8
         4gnxXws0zL5g/HCdWxDKb4GOSOzfUTbc3Srhl1buEY62pbxe+J2ECd1XmNUADulkzP/E
         XCTg==
X-Forwarded-Encrypted: i=1; AHgh+RrBisVIBa5tS+5WQ9sES/pzQgsQuTDjyaEKuQK7Hv3Ro3tAvG1GfH+255dOTr26bBzm3MUhZEJ/FQ==@kvack.org
X-Gm-Message-State: AFuF++luJRDkK7DoxZ+KA2f+VqlwkxXqOrW7p1T0I4Hk3jY+8eUGHbW1
	Cw/UZUn7tHvEB0RwaQ8kvAs+oygX7OP+Fb4T2HhsXLvi8CP5Dfup/kYSfmTNefVeKDY=
X-Gm-Gg: AR+sD138hLlYynYsWYdkuIE7WUTD8pj2wNFaPro+K1WC1KJ6kYqFuhVpYJb3Cf6SYxY
	nCI6h+m5KB0juQLMlCDFXjndVSZdX4a0WkClyt1tBaaK6/o6WBEN8kNXt83T4DM5uMsybuf0muB
	bso9WaB0xTg5B33dhFIOa1k5Sa5okcs08aM0Ebg8GUmGH+lQgIb6I2tAzuXfpc+1mph/CD0AjUp
	WIyvMidSarIeSjMWBZ6b3uWJhoa9sFfG0ecVfcSS6IopFKy2vDEnmMctcr5EFLpfkCHXhCaGlf9
	Sn/M3vrbeqS0KeT8gNRjcw3+c/AuML40m9XiH3Bf4xpLnJW5GhsRRzIRyKFynE6mNbqsVPJ0vaP
	iyrkStbyirK6iEUdoSlZnsk8L6J2Odo7VKVh7O14cSxw+ULC4Ix0Qbq+pCWUMtLNuj8XCF9wwzl
	YO/Gb1YRvQoW0970gkfsiu7j+Gc8+OSb8VCqYAupBKrcKxocXPy17vqhKY12sOFMTBIGP8veGm/
	WYGYioU9iohZ72u3uTNcPNjTA==
X-Received: by 2002:a17:903:b83:b0:2ca:e5c:7fcf with SMTP id d9443c01a7336-2d5fd5eaca9mr65885345ad.3.1787133201498;
        Wed, 19 Aug 2026 02:53:21 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:21 -0700 (PDT)
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
Subject: [PATCH v4 06/17] mm/mm_init: factor out pfn_to_zone()
Date: Wed, 19 Aug 2026 17:51:28 +0800
Message-ID: <20260819095140.17252-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A28EB140009
X-Stat-Signature: jb7py1cca4i7aj5y64i67qyny5eefcci
X-Rspam-User: 
X-HE-Tag: 1787133202-187567
X-HE-Meta: U2FsdGVkX1+tA5AIbEhZElRZlQscrx6NLIW5DUGqsrkY8NDJcLLrZ9M23OnfGMHsn9Bhz6+w0OL13C0kQofAPCrqe+AKseVdXOK+erZygaer1hoRKwKvhfHKjCm7JpZStS/fm/6yTSed5zJJ+4hho3aiujKyWCkN2zabgUfb/y5j9XOsfs4mA5YIlkEMuIwnVeRKUj0cqH3ADDviANXINhcI/YQYfBpaofHojqqR/iAG4Z5tJ6XtN1Mj7+OkODy2aQL3+wd4Uy9IOEhpW2sNcAXC0ozOdSYcG3wCYN9w6h1ZDFUytjVUScQpRr5lxIg6KY7TMWPw2vaRjr+LrxFOZscLYe3ggHjstxT8Phl94VPFU4cw5PlniZgUfa+Ph8CeeBS7jmOClBOXW9VUjUS+HnJ7hYKIj6YvmeOXjRy3ZKgfP/TmoNFuFWpve/b/KHZk/OnfTUsc1ieEc41ReuS/4if8iVKtFBcTgzEuTDf1PDsM8gQO4qiwIIRq/U5U5hfjLYP7GUHh3qB6uSiXO7JeuQAm2HfS4ozw+Ny8gOLM8HUlku0H0tSdLb5OpWCo2r5Qhbfa/N2sh4TKZwaBj/c3/OJQPGa04Rr5WnNRYovaj9EypQgacxTzX0+EPGsei5bfyjBta4ZIC+DkQjNz1X07zhO0CwXdkSRf1GmiuZtVld7auOKcGjJrWsk28l/tBmLvQhCXuhF21oD38nrURBhbnXJiMCEcAZFahzy+kdmqViKIPmG+OWqakUVG6PgPMYLL8TbHqJHqsbejn+QFQyCSvIu9MJ7iJV4X+TNFbJfjAROoHcHs1rbtBBc4e1HnHLdnTNw2oVDnnAUr0MtidH6THZ0rgkMgzL2IRw8ADtM8rHpBdtRGxMzRLkyrRMkl/dFkONJidkJyxjA1Hwvj/6wM4KjbQTFHXN26COnwp7qluMuksDNHKBXJIARa8hn7tOPftb2Ncaj9uD2NIdGl8jq
 HdVs7XAq
 psSdqHdxX8cD96oIe2g8XU0OMoAiDIJcJut0tKub4qfRT772gLCQmIBwYGraN/MAo5IOj7tZJvmYYhgq4BMOIZbBFSPqOdFHS9/gjkxrK2YRj55F1GlNiPMxKEWxg7VrWkjczKtCqEKb1YP8a9YAETM8ST86RVzMZaE4cmg2iEko8aBeRc2pSCMfB66VvJTpAgTVq7kTgMMHOtAW3D2yMkZJzXh9dNLoKNb3CcOO11ANkxPZo+O0A6uABVaKkZgz/YbbB48fNMKwZld8cYvHBzp3RJqfe/gLjjr4snW0Vv+g+9Ioy/J12UEBGkKFSLiJCcqc08zWwO7R35brT/z0iWN9usWlZty7j8wMZttaPRQhW8l0JxPVfEBQA0C5y3ez8hQ4KXoF0iOn/2fcbWVv3xk7F38iQ8o3Wd0LUhks7OIuPxMsgM92I9AcmXZHUkLNklK7VyQsRCJxlCAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pfn_to_zone() in hugetlb_vmemmap.c duplicates the zone lookup logic in
__init_deferred_page().

Move it to mm_init.c, declare it in mm/mm_init.h, and reuse it from
__init_deferred_page() and HugeTLB early vmemmap initialization instead
of open-coding the zone walk there.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Fix the commit message to name mm/mm_init.h instead of mm/internal.h
- Collect Acked-by from Mike Rapoport

v2:
- Move this preparatory patch before the sparse-vmemmap optimization
  changes (suggested by Mike Rapoport)
---
 mm/hugetlb_vmemmap.c | 17 ++---------------
 mm/mm_init.c         | 28 ++++++++++++++++++----------
 mm/mm_init.h         |  1 +
 3 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ae8fdaa42118..c48fcea076a5 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -19,6 +19,7 @@
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 #include "internal.h"
+#include "mm_init.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -744,20 +745,6 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
 	return true;
 }
 
-static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
-{
-	struct zone *zone;
-	enum zone_type zone_type;
-
-	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-		zone = &NODE_DATA(nid)->node_zones[zone_type];
-		if (zone_spans_pfn(zone, pfn))
-			return zone;
-	}
-
-	return NULL;
-}
-
 /*
  * Initialize memmap section for a gigantic page, HVO-style.
  */
@@ -787,7 +774,7 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		map = pfn_to_page(pfn);
 		start = (unsigned long)map;
 		end = start + hugetlb_vmemmap_size(m->hstate);
-		zone = pfn_to_zone(nid, pfn);
+		zone = pfn_to_zone(pfn, nid);
 
 		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
 					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 05c09e755e0b..3625de86d1d9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -692,6 +692,20 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 	}
 }
 
+struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+
+	for (enum zone_type zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		struct zone *zone = &pgdat->node_zones[zone_type];
+
+		if (zone_spans_pfn(zone, pfn))
+			return zone;
+	}
+
+	return NULL;
+}
+
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
 {
@@ -750,20 +764,14 @@ defer_init(int nid, unsigned long pfn, unsigned long end_pfn)
 
 static void __meminit __init_deferred_page(unsigned long pfn, int nid)
 {
-	pg_data_t *pgdat = NODE_DATA(nid);
-	int zid;
+	struct zone *zone;
 
 	if (early_page_initialised(pfn, nid))
 		return;
 
-	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-		struct zone *zone = &pgdat->node_zones[zid];
-
-		if (zone_spans_pfn(zone, pfn))
-			break;
-	}
-	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
-
+	zone = pfn_to_zone(pfn, nid);
+	__init_single_page(pfn_to_page(pfn), pfn,
+			   zone ? zone_idx(zone) : MAX_NR_ZONES, nid);
 	if (pageblock_aligned(pfn)) {
 		enum migratetype mt =
 			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 39f75df9be1c..c9fc35e7e9f1 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -39,6 +39,7 @@ void memmap_init_range(unsigned long size, int nid, unsigned long zone,
 		enum meminit_context context,
 		struct vmem_altmap *altmap, int migratetype,
 		bool isolate_pageblock);
+struct zone *pfn_to_zone(unsigned long pfn, int nid);
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
-- 
2.54.0


