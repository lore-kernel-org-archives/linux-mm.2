Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1199C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF266B00A1; Mon, 20 Jul 2026 05:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7216B00A2; Mon, 20 Jul 2026 05:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5B46B00A3; Mon, 20 Jul 2026 05:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E39FF6B00A1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 756AAC077E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:19 +0000 (UTC)
X-FDA: 85008639198.28.7D03412
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 72600160005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=COI0PrIO;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539937;
	b=56PZr7X09jVeMAFfmEly9+mzjA7DIrxWW6g2NuHvf5rOeV/SWS249fTwPLTRHsk919Uvjx
	4uk5BLX5u9aJtd+gVBBCyIob+nlyZGOZ9DKSXheGmgcCYhtSSn/x+qi9K7xGWL4ivuNLFw
	Y7AdpLdeIMLDmV4A603v43JuyoaCmSU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=COI0PrIO;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkBZ2UA32uh7FYNyMozkAkSKVt/rRvYA4e3apZ5ZvVc=;
	b=ExazCAZ+/fUVZm/R36S4Wf2iy4I5T8tWWdzKyYCYyKiLn2+GgnYC66rECsbnZ2TgrQvsVH
	W+vy2WYjuuGX+6BpMKj72nWOy+iE3VnlP0H8jq/AsYfdojXLPxLIO6XmqjHICQXYs7M3zG
	WRlLyQg+jGJ+9pN+ZVozRG5x3Av6OPg=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cea3004256so113742215ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539936; x=1785144736; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MkBZ2UA32uh7FYNyMozkAkSKVt/rRvYA4e3apZ5ZvVc=;
        b=COI0PrIOW5Z9gGso0wEwpbU1ZtckhjUvaE6DYWxueVSwtL21Sdye/TkCOTty7xj8ra
         9I7qcGuOzC8d3syvMnWwj4AAfH89om4Up3LXfaimrXvnARNZtNVeo29jq5Mmvf9z5qRG
         i9m4yeUuR+iY/sbAV+oeTEFWmuXDi2oP1NnnniUFqrN1w+pe5SNtqSRpAXtOvnlbILMm
         nBflNWgeM3WLDTN+IlvlxSnNymx6ZCPgCgIcKuhBuegrSJsDjjZ7hVyRYQCdDf2fQ4ZT
         Oq0S4LfmefDTwxNVRbk1VtI7P3V5+Pqw3htH6z64ZwPGZX5UmDiAbADj8Bdxl3Gq4SFM
         Bkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539936; x=1785144736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MkBZ2UA32uh7FYNyMozkAkSKVt/rRvYA4e3apZ5ZvVc=;
        b=pkdw6yPiNinlspJJPhEQ1Y8IuQhNBhiCiFGhYsFlCDQrMYV1p9Ws962TpYsvgW02Q+
         aJ+2JVI4Jq55eWd030GdVdAIhUtXd7XnUaVaLC7M43AjQfCxi5xMUZ7KucBd8apUI+v3
         RkWB6hBQhJDWBzAWZe2hlcfiquRGauHUAhB69/+e2DgJQXXHIuEfrbjJct1bvcD0EvhE
         JCk4S9qVBYsB017K5/zJUrDdfUUQ3/uXDrMs63N9g9gqM8P8SybmS32/Uflswx/uXDJT
         HyMcSm9Sw8Zak4IIYEZwt6AKDS5A6aZTrtlKLi7Kcweql81i8NaOkHc3zmbOtybumPB2
         u/iA==
X-Forwarded-Encrypted: i=1; AHgh+Rp/jXf0P6hlr9nvffmVyp35pF8zQzm/9WQ6I56Imn404D0UCV+u0ds43Dib3qvWQb1kw2nk1viQQw==@kvack.org
X-Gm-Message-State: AOJu0YyGwsARoIqd6ejjTXrgQE6+bhJFcI0r+g+T6mCgJxT6/lNW5b2j
	YGG70cJ/vZFIargl5D/75TBIfW5zDd9IrKDePWwKSzyaswecI2V55dC5uQfy1m21xa0=
X-Gm-Gg: AfdE7cncK6UwVlMbGvm6Kyk2Fpwn/lcQEVWRutohyY5ZPmPS4u5Jf8zcP7IaZXDZLmY
	AKYd5tn4HpaZQlFWHsjZBv10O7LpiWWTs8OU0McSRV/t94rqPZZ7fEqiQIv3jFWW7pnhjWkTZzT
	6t9U0dz/SbTMK1QSq3ZTjxp4cugof9uC9JBAJoF8mT/clBIo267AZzNqRACvTSmnEk3SsqFYHPy
	9QKsvQIlDM3XxWqG0UwBvDBCBdJC5WGBPamkOudOThhYSX2DH5RA6zdRyxDnwRg7ByguFEc0RLh
	1+4aqkib+amMU5c4RvaKvPhtyfIM0ZbmSj7x7Nd7j6cluLgIk19JatrLlxd3mzFRMeRGG8k2az7
	gzBz2YpKje/3skYt0oGgZFM1RIXyJd9TzMTKboMcYUR2BDnCKQzOqI1uIyyOSDXBueHJg7YzkZ/
	e3vlXy3wLX1OyurHDlbkUnHNo=
X-Received: by 2002:a17:902:fc85:b0:2c9:bd37:ae76 with SMTP id d9443c01a7336-2cf34a3ef59mr151673285ad.47.1784539936212;
        Mon, 20 Jul 2026 02:32:16 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:15 -0700 (PDT)
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
Subject: [PATCH v2 06/17] mm/mm_init: factor out pfn_to_zone()
Date: Mon, 20 Jul 2026 17:31:16 +0800
Message-ID: <20260720093127.540540-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72600160005
X-Rspam-User: 
X-Stat-Signature: 9hftjiccpgxj1nmmgju1hxb5n3ci78eb
X-Rspamd-Server: rspam03
X-HE-Tag: 1784539937-192957
X-HE-Meta: U2FsdGVkX18/RS1zqJ8iymYfbrNnPHRx70wD1xmRSebuELaYTAuqceSipaBHlqcGRGiEZnlIsZZWSLbcRx664p1CY/czmmGCMMo7DsWqLAxDp+udlttTh3CKDeD3DO8zhnayVy6Wz2iBo35x3EFDbTqxoBXpCuTd7R9cQnCixqdIWKbKXdzbZVSn+fXioKXL+0axTzVeOBhCiD9AVm4u6Qv/n4bewJuCwqkrjTc6a+zH7AMJ3xM8vT9OlR8ZNWeK+vcJHVz/CAynYLqr8tXgOZ/xpUjo58HuuIpU8B9nMsEZsZdmJSNmpxy+5cv7xN9PQBLXilZ2XVZs+Dd4Ke5JErvlVwVytLihglNjSepair+GSjzeKoKJ2u8VWHJEbszkuL+pvGb1eY56ezMSnRtDg0jjbUpitlSIE0x8kLlYmcOAihVntJzSoMWcoKUU1uRIwFDGymUMuefr1QP4QrvQyw1ItgTXD3hXkRoLc+fKypsBcmNZozBfVJMRd8TJEkDubElvl0vdHjLJFnvm6W/Vzu0lVLsBOIgiSUoqpTKmLCRhe0QkPrm6FQQ7lH/rHBNQB//JweaUrIYn3bNXVww2F0AcLiOk6b9kktM5euSZJ+beCjVNyqwvyJhfjDVkkKyRvMlceqp6GrbZB4xC4k/au2BwpHfS+W2+yEJO4AWANCRwgU1scxVWBF+XlRlocr+Pl9i1wGcEMqVpDHMLpFC5nz51g1Zgcg1pAgQrYUUMhFlQizdCJ8LEsYsW3U5m3s/uJUCBe+uXxEP3Wgg9UO74jImsOIWBOy1/9O9SFQVL2gVhZN06sW03lQC8caN29riM3P73w8SSg7yU/eWc1+61Xmho/b7qw/8AwJskEC+R0KSWdnttp9YKDnNn6Rs3zxC7A/HMCo8mOPhRm8x863oPLmjsRZzJoyH3WAq8SdfA7yIfQ7uMyEStX0wV6EmwZbZ0pu4NGR3XiNRtlmGqQHm
 cxxfiLPz
 wktvx5Trm0wxJl4wLx9fsYe1QcQEhkbCmkcjsCrELfE0ZaEtxe9srjhG87p2XleMSlLPL78QPK973YaZIZCd2DgMxNrrvxYYr1U6CJs3OF3bqTuncRAoVY7OaFA4P0mPbKgBHTzCJrLiUk8y9Ui9SOldxueMoTaSbHdND9NATBgYs+eBeXokMzKiQkT3M/be62Njq8F/qpURiEr6/qZd2TnUNiYaKPfV0CaWzxlylQ4CIzph1s+BIZngRch9sJRGUGAikO0nXEzh8Oe1Ey+Zwq9l8ZC6VqgP+x7Gl+s3lV6jHA+exjjQ04BO+FgAavykFCLGnG3jnxUzIqljJKjcJfaxDrTOAFmgye29/a2Gzev8V/skIMN1u8U4i8V5G3cGiEMWWJN4vkp/tdm4YWw6y9hx1Fz2uMfC9GedMeFzsPAZOa4MLmxgCSq+j7D51fSQArA9z/URC2bDBNS6gsMA8tbSqyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pfn_to_zone() in hugetlb_vmemmap.c duplicates the zone lookup logic in
__init_deferred_page().

Move it to mm_init.c, declare it in mm/internal.h, and reuse it from
__init_deferred_page() and HugeTLB early vmemmap initialization instead
of open-coding the zone walk there.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
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
index dcb757b36902..191d4ebe9314 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -690,6 +690,20 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
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
@@ -748,20 +762,14 @@ defer_init(int nid, unsigned long pfn, unsigned long end_pfn)
 
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


