Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F21F2C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABEA86B009F; Mon,  3 Aug 2026 23:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75066B00A2; Mon,  3 Aug 2026 23:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937986B00A1; Mon,  3 Aug 2026 23:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 647196B009F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0B9EC08A0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:12 +0000 (UTC)
X-FDA: 85062224184.02.53B96F5
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0213C1C0002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z73EXPHv;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=am0LZeSfTFW8Wc/d/bGYBseEk8tEkihNTPFhmZRA4WY=;
	b=kcc/2OYYAkIzau/mXfJUNP7+R1jFqCjPuoqN8oXKfVk0oJik4NIy12hOgpDdGOcQpetBqT
	PiXusZX+juJz/QG9DLjF794VqZ6kTNIpXly/VOiIFMrIVcca8Ee5S9Ah25NACcFl/S7Jt4
	9nGFP/LEEW9OTO73zIufn8dbytWp2IU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z73EXPHv;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815771;
	b=8lyY5xDf6OflTohgLNeWslcTkbVPfZf1BERsNK2aXh+cFkpm1RTHHg9QLuGrwyM0mu5bSM
	WlWaQtxhMPb5BdFpYYgdNpWs7crF7PGOrZ3P0KxHi2hAZrscArpmbziINGBQilLBoMHhoX
	H6eY4bw941e298YLlAMss/CdVimsmzY=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d049069377so35038985ad.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815770; x=1786420570; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=am0LZeSfTFW8Wc/d/bGYBseEk8tEkihNTPFhmZRA4WY=;
        b=Z73EXPHv+Ygf4xkYM88FV7hLkdVvPGu2AMlNWgvX4BkNlG5tLXgA5BljyDRNoojAjY
         CZQQBHRcMQ2LpfVhVe9nZyPpBCg8MHWSFpIPXSt6AyVy2UvNgZM/efL4kdFrHw/16gDS
         sHyO+NDSE3+II4k/bhPleOw+k8mfEqTHR2fk46iMpcEGLCj9rDbUUqEe0c1zJItOVQdW
         MX1+UFtu3dvEZEvwBpZXML5g1dUpQmb0eW30ly5Cf3a0PENg/BAMcs4hmgg/Z8VI32nF
         zk3nrAWwVrLq/NYtDd7D8QnM/MS2x7lEceoHMGpCaCfhHM/jMv3yqW8EsF1/8yQiJN3l
         XS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815770; x=1786420570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=am0LZeSfTFW8Wc/d/bGYBseEk8tEkihNTPFhmZRA4WY=;
        b=NWZRKpp17yP4fdNkN9F/aDsfDI8n81qnsFV24mLZT8qyMu2g7xyCqSVJca2XtvfPLZ
         LiiRP4WfDc1sGV9PlFxYS5q2CeawCI4jEvtxw/2E8mntu0u8TV0Y/32pjxGFzl8dOZcC
         p9jwCmyELmAsdToGYQBn4SqBCpn9A5KV5/nM3ZiC8mKON+hLhjXAoYRYfIGTxJemajt+
         V4N8jWXcwKdL4Pr3ZCFguiQpKu0M00O8FrvEyBBe0rpjBH4XC3cEjXublXPbMD/XcTWP
         bvQhrTE0Tz8pZ+s2E4TKJbKlkfHuECTaT6DILKsTh1MUgIY1b7P/n0VJpYkNLFJxRr9Z
         3iOw==
X-Forwarded-Encrypted: i=1; AHgh+RokVVzdtYimD8vMr09XzDBXBI/yw9rtRcitNxinz6pGdx45nYLUprIKU+CpaLIaP0fEYYQPUebBJw==@kvack.org
X-Gm-Message-State: AOJu0Yw3YvvhjR1RZqOK7sRbIgVwPGl9QyvMqWITRyCT2XQrRlhZiU3e
	M2WGAC4VUjW1b+2Fkh4yTEviKpQzvAvqYGe0HXvy3FLgp1F+sb4lQ8lVbFN3v4uZZOc=
X-Gm-Gg: AR+sD13petODMZlmxVFE96Zz11al2dL+1t36s+B8i9WnO41QiZw1q4eVqyTtavifwoW
	PadyDChe6mO6BhoVo0qj7MDABr8Fw9qBFvQLzTa64HEXsZwxpKuZM2bgqY28Hv4kNMMkHVRz/3C
	BDNIpROzg6v9ukZfnAIeKriQ2YXyjVVfxO4njvOPhOf5Gr20+Am8I7f0Ht3iyMPdFtnai0ErE6W
	3wjnXGWJA2kHipSPFrUbkHxJSlke7Zu60ew8PoQ19lojBINPX3At4pzBeko+/DAzesJGaix6Tkb
	AUXiJC/tQrOezK5POj25hYC0TgEJvepR5OCcY+op2lM+kcr0MR7SCiCj73Ev6L6wHpUKW1qFQO0
	AQtljkv6dY0xwiPPS+npNTqSA4idWTWh8uK6ELJSrZx5wcXuNWmj14Zs+oNkNb0tufYc6GDqRNx
	hssphxmq/NeBNMPl6zmM4+qMcdL1dd5Q0/Rb0WJmiY861MHn/bGjC+EJfqYCIjDIb2ShNdm/Ye6
	muwVwE+VgLRn6trcsI=
X-Received: by 2002:a17:902:ebc2:b0:2cf:bf32:b754 with SMTP id d9443c01a7336-2d05219f1cfmr130780515ad.8.1785815769791;
        Mon, 03 Aug 2026 20:56:09 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:09 -0700 (PDT)
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
Subject: [PATCH v3 06/17] mm/mm_init: factor out pfn_to_zone()
Date: Tue,  4 Aug 2026 11:55:24 +0800
Message-ID: <20260804035535.2846016-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zeqsqt5c5kjr79mbsuj5pzgkscfnbu66
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0213C1C0002
X-HE-Tag: 1785815770-195603
X-HE-Meta: U2FsdGVkX18nZeMXldbJlprBbUZWs1eMw1I8RFdiCngwjs1RpllriIn2GhZw76Hs/QTO6AIgrqAYWQ6x62DRN8ojFDmfwdZqd7iPUmJ5d1G3GKetdX0AyxfJVN7ydZeLVHQdRt+0cVV4lmR931NqiOGAQUSPbEsxXAJ0gsHCKt4UfrXoW87GpSZvUV8VC9PG/k1s0YUfYBjNiVkL8EQVWxrN/0XJJzoIO0maFwSbtE+ftJc0G7z+xbETJH020XDcimGFDXUgH/1xHA0zi4KMJ9YhD127XfWgWUThFs/hdTJs490yrCMNVsJZfA2SyPJG5wBYHL8gWZHliwgyZRlIzqdaZ+Syfe59TprlrfmDvq1EqG0X0mimcn5j6QegZuCIs1mP5MbGAPI0LutSKkTVP1V2CWPBRUUtnBTemC2w6X81J1q2CW3e6YyJ67lmGaY4P71l4AN3qKBY1FhMpvly3Mv1HdwWRuopRgs/HOog/sQMi8cF4mAB/Bu1YB+sz5gxFB4xe5BDdd74CNF/qiH2BC70IqQWLpobEyy6Ru5nmFD6ZNbNlBRMkcSQKxFx6P7wrNrxEgAHwpyJFL69mOc4HIvYBbs/cyjDhee8Xs3yjKssXWwQWcEOTnbHE2wi31XyKi3v/zoXESGVEoMKmBYkeyhg56okxfozbwUSk5BNCeO47BVRELEXFcA+dUZEBDZQbSOdDSJeGnuNvc6pPSZHMivlGdLaZUBi4s4XX0IIbYwQbdtabMJhyliPcmEZ80HjHEF8iJ7Rkk0R64i6LGDKu8mEe6CBeSY0NKr2WaIYMafXpeeMdx2PkCNzxaRXkHEcaggbqtVeMt4RN8s9xtLuPhf8KanA7bJh6W+FXdH7ovEXI/Enpiv7Y3jl9B0PVpjXAHyitkvIkzTcs+j0idqZaj6UlGAO77a6/Q6iinFcsQlUEHEBQE26pGNtklW+thryRmXB3QE3zx+eyHn/FeG
 Q1wYHPbC
 UVgYQnjHy022bCVWb5pNDdmv6KKzAnRet/xtszJloxV0J8W9knAzIDykCNRb/9YzLP5Qv0W5NvJh9Kg9MxmknbKbdUe0QOZzWPw4BHPXmvit0+kUI21FBlChoNDwjD4R0WKUY4esdLh0+VaoLZ1OGcaNgzbVza1aE2AiKv2glPZHExGAoGTnM3WJqhHkrcInjgFD+h1o+Rb9hg++jyJqYf60zxYObbRsAhaFb2C445X8wABwKpm9M/MQj9g1ygo7x7aYaXimeaJ15zE3/qHkWCaZYG+Ip3W0nAB3AZhqLpykZcAg8LQLOleu3kK7QwyR0RfGiIzfhSVebRv7iZXcsyi+/9EVLyjXjJVLe3tLST8CnbvvhuBeQ3ooQKtT89U/U/MTK+YH0Z9xd5nS+uQeNcpChPOs72iMy6UTqA6gqcTRdx7couXzr/35OWVtsVx/0B6TM4OB2M/1W2Rw=
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
index 1823381a69bb..c37fcbe9a319 100644
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


