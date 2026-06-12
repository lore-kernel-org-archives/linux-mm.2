Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20811CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813776B00BB; Fri, 12 Jun 2026 00:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EAD16B00BD; Fri, 12 Jun 2026 00:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701606B00BE; Fri, 12 Jun 2026 00:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C68E6B00BB
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F6F2407BB
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:50 +0000 (UTC)
X-FDA: 84869909460.20.3646351
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2C399A0006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KvmA7qzK;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236848;
	b=EquaiqrtFLCOwhYDdgvnAHrBiAoobI0V5p6nixz8QmJA0NOOgKCwQkw6THQRLaa+ievuH6
	r5IBrbj8diyMnYWe3VgEfSaHE1270drODcB+xM8rriF+2xs9yPJ4/U8sRt1gNp5kc+i6VH
	yAiNcxrGtN1Y03faYCHBD7zaOVI3dv0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KvmA7qzK;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idHdbNQvIYMC7O/PUhqtBCVSyqTiFPMkYhoG6e6axFo=;
	b=dxIFyCZYJqvRU7/pc9J3D2pFWOhe1hMhXtnab8/AkK43/CIKV/mlqF79/AA8K37sPIb+QK
	kuM/Qj399s9jxJ40/LqBRzJJ7QKuqh3BoxixW+MOJsSnvvNT3S51YzaQeSwT2O6Qqw/lDm
	mI5eAOB4enzT6myACVlVq1trIMbzeO4=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84230ab8857so295635b3a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236847; x=1781841647; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=idHdbNQvIYMC7O/PUhqtBCVSyqTiFPMkYhoG6e6axFo=;
        b=KvmA7qzKlYqJ6wSORsycZrhsIsXM3QEua0z8rWygv7qzjZtCgZWE0eWJ88nh12vK76
         YcquIz26mhgkqCrPyUk2HGcpKIs9ippeGQUO1wCf3gwwxw0qXC64+l4i6yR662ND9MMG
         c7cC89VWXFiNXGSCDoy99+mLCsBKYf6+XPf4hSoZjngNCHHJszZHrnPmRy1Hew3hP5X3
         QkLEEhZigCkEtt6QySkLnhtorVWyiBmUD9+t4VWFJ5raj+yYe7b7GqjTx71DI1RxpTdv
         yzFybOe59ptjpRbj8nW02mH3EYCAgj21qRfP1bozBxyvMfM7ZiUMTTMej1039KXdorVg
         A5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236847; x=1781841647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=idHdbNQvIYMC7O/PUhqtBCVSyqTiFPMkYhoG6e6axFo=;
        b=aUSKX/is2+Ze9WErbMjZNoPZni0ffjrtY3Ex35p2e2ClLgBBqAbAXaTOWhNb7897CT
         EkJJYOkpzYqHrmcBcgWTvafPmZbyPYtHRTlo/2iud/m8zMCa3uddSc9GYY/XtPxgtdFD
         qJ/gf/pLqZ9WUVEIFRzCb4/x7qDIvkFy7dcHA06K7cgFnF6G4ALz9tN3WQJdDl5oEsIh
         pBmSiR3STCm8w3EYdxHuDHpDzdBaPi1Ze5h02aW6aAqK7sTMXTBGsNiuZl3Zqil8mXZ2
         99VdYrthFrR6GgANzUeAhXjkf4IpIyLcA6uP72lsndHzgpWuf4xVQPxf0uU3asovX24r
         XQ/A==
X-Forwarded-Encrypted: i=1; AFNElJ8Yf9TXD23G1Kn/gBnBDtxxkzZ0qUg1QSmqaVivi4rMJraTnTIn5YnBsszUUSaB79dvFhIlb5aUPQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5vDAK2OXAnqtxGCEFgBzPK3PmpXnNyeDN4nyc8MK50EoAwHnO
	Zvtb51JRovDPeNuCJdFAP4O3h0Iae3w90OZpnwfBUB5rywSzeJeUX02vq4PJNV0DLBQ=
X-Gm-Gg: Acq92OGGDH9/Ro1npTooCyFHaSieKYu8zM0XU3lG6yY6gw+6U4hP4RSK0+mtGXyuLXP
	rK6BIr1orygn9aeXWny8E/uguPaeaH+F0FZiS98ZklTMAQ4jocx6bTtivIoF1z5S7cx5ZEVC/U9
	h3tfmmStd3wYiOyjMljm0ksJP/3JXCeLei8FnZNbxcyXSfGFKWpCMLz+Em60CamqB6NYpIXAq8w
	wG0zw1y/U0P9h7RITggU52ya0xDXwsdISPnFuMYwVDiijv3AG7n3syJovkc9h0TELZc9bsug2ql
	wI3uL816nkqQynWpeUpwdsiTC6VCjUKE2vgwNMsQ1YJaf7Hobq/o1KEOkBavAG61K6PUqWR51lc
	GpA7vMNKf+tFjartbHf3yiQP6sTdbGNnoB1pRytPWC7mw31XeZxH9IwK/Lhl+IRMe5uZBDMGIRE
	g39lg9B/19jtnb3wsgC/sEng50X0YhBNmKRHvg+Q1UnSs=
X-Received: by 2002:a05:6a00:238c:b0:835:41f3:f440 with SMTP id d2e1a72fcca58-8434cdfe0ffmr1116771b3a.14.1781236846941;
        Thu, 11 Jun 2026 21:00:46 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.21.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:00:46 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 19/19] mm/mm_init: Fold __init_page_from_nid() into __init_deferred_page()
Date: Fri, 12 Jun 2026 11:59:03 +0800
Message-ID: <20260612035903.2468601-20-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C399A0006
X-Rspam-User: 
X-Stat-Signature: 6y48xbzpirj7wbisxq6kapkz9fwggbgt
X-HE-Tag: 1781236847-598637
X-HE-Meta: U2FsdGVkX19e7PQfbDDe7cWKkarOHRhw8d05vEKiKnYBWX7aGOhYa37lNTy07QTgZcBvHsAujcRzjHOiAg1sFM4UgZsghnd9OFS1S9IELLU3MsMupHdYvsI7E77Y6ppuin13kfCgqsjg4ueFjPX+G8OXyhxDyzUanzTTQW5Rs5fAG3XG/RXJR2JQiy+j4gJseh3FANvC9pZ5565xfUuVSb+P3T5DtBzNoSNbUQvXsFde1UPaGgpyC8CkWmphHjZEZpjNbmZ3J3CWkuM7G40YvTWrfjyBiJemVZRo+Vtr66YTwgls5GRHcpOzeKY7wrHHM0K3IuxOt6T0obQnQlGU0h/laqILTTprudupcFMK3hvVJYSh/bVMDMUwwS7twvn8E7W1CG3m+xQ2c3PxT0lVuRZflcdaEyJhT/CUuF3a05EPetE/czfAJC6aUJqYRHp+mmX2xkUcQ0b/itRK9WmKcUUamNlIwhtYQfSkKjmFyh+8+Q6PD6cTPcTTSJEl9cERtbw1cV4izz8t+rQa8a6+Ctor371e8jWL+8bnty9mR0F4UnJF9R5PKb0pUBNRrPQv/RsPp22LKoCbKbHSeJbA2OmMyMkOurTNc9hB35N3X7HfOxzz3s7x7d5xv+iJSwewCnbHCNd+ZpApIrIXUQZqPycfFG+/JxXirSX9dacUOpGFrwp656dMxdEj1KUVssG9lJt2agH7fpOrQ81t16ykplXXtdFMiXPTkcL6hMB0pM282098U6lUi3JZEuNSBsS88w6fYdBZ6AP7FU0f+Mv/TUOIUHbqbxBMy8Fw33MR04FP6mGqpI/ELkFH6ATsSb3tm9jbCWhpgCt+OtVA8kD+1gucic4SPTXztB7x6YMLMyydASpytKzlfY8jU/LWFsl3s8eP7K3DJlEym2+dID0EnY/z/zOyY2PMX8fT17HK7DzK+SERr5du7LJpFxC0cijFiXO0fQwh30N9FLFyNn5
 dvnZf91q
 oftOQj8TO9Dm9dNBT3ftxxY8i2iSZrlhaHPMK0u6d94x1rsFk9hkUCjNHD6f14UmaVV4GrLve3rgIYigieFv/69Fnq74wnkjuCVfLDGnIcf+lA3Umm5IMqXxWRn0rERtiZbeuoaNSipUGL9BKW0ElS9KJIOuoOfKZLvDxO0aNt6d1TvIdKwPJ329nru3Y9/5olJvOEmx7cLe/sZlkBzU31HPJAHqSdVN25yJTuOar7Qmx7zTvVwvgLs5asIvxuB3KQhJvrZUO1GZcvoSp+JJtuHfSZMRw1EhwMjmSPD76BMhyDCrkwCJrMGLVwDzTOnrqZPLgZ5VZIr/87O0Zoy+74cnfrd1L6biT6R/7ewr46Zc7H9gq1hIXut/F6H2URf9WdBQsI/GA3niP202xvG08G+B4FHxEAlXO9WmanIiMAC7unLvEAi4Lp6Shc+Hqu+me8hGNqVzXaeqNH+YHL1AGdmuOxziO+GfVtSSLxCZCq184rO2bhGQiEV8txRL+xfv86xQhb8zkGZeKUYNwKlFoRiv0N1MgjZ1ZMIMI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__init_page_from_nid() no longer has external users and is only used
locally in mm/mm_init.c under CONFIG_DEFERRED_STRUCT_PAGE_INIT.

Fold it into its sole caller __init_deferred_page() and remove the
separate helper declaration.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

---
v3->v4:
- Initialize pgdat at declaration line in __init_deferred_page()
  (suggested by Mike Rapoport)
- Collect Reviewed-by from Mike Rapoport
---
 mm/internal.h |  1 -
 mm/mm_init.c  | 42 ++++++++++++++++--------------------------
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 39c9564fba0e..dc10291f14bb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1760,7 +1760,6 @@ static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
-void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
diff --git a/mm/mm_init.c b/mm/mm_init.c
index c76498b7abd1..4026b084bd4b 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -688,31 +688,6 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 }
 #endif
 
-/*
- * Initialize a reserved page unconditionally, finding its zone first.
- */
-void __meminit __init_page_from_nid(unsigned long pfn, int nid)
-{
-	pg_data_t *pgdat;
-	int zid;
-
-	pgdat = NODE_DATA(nid);
-
-	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-		struct zone *zone = &pgdat->node_zones[zid];
-
-		if (zone_spans_pfn(zone, pfn))
-			break;
-	}
-	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
-
-	if (pageblock_aligned(pfn)) {
-		enum migratetype mt =
-			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
-		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
-	}
-}
-
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
 {
@@ -771,10 +746,25 @@ defer_init(int nid, unsigned long pfn, unsigned long end_pfn)
 
 static void __meminit __init_deferred_page(unsigned long pfn, int nid)
 {
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int zid;
+
 	if (early_page_initialised(pfn, nid))
 		return;
 
-	__init_page_from_nid(pfn, nid);
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		struct zone *zone = &pgdat->node_zones[zid];
+
+		if (zone_spans_pfn(zone, pfn))
+			break;
+	}
+	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
+
+	if (pageblock_aligned(pfn)) {
+		enum migratetype mt =
+			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
+		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
+	}
 }
 #else
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
-- 
2.54.0


