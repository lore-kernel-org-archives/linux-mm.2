Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20435606A334
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=KBI3d6bn
Received: by kanga.kvack.org (Postfix)
	id 2A0D36B05C2; Fri, 20 Nov 2026 05:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277C46B05C3; Fri, 20 Nov 2026 05:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18DA16B05C4; Fri, 20 Nov 2026 05:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7B126B05C2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:10:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E627A8E57
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:25 +0000 (UTC)
X-FDA: 85455077610.14.5B255A0
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id A49E0120006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KBI3d6bn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169423;
	b=r+CIaPKDpbHIhQ0Z5ji9EmcL9m/8ZrkaIIzGMoR48icJxrDcRf11aR0R5t1iytbwmg12GL
	Azel7hCQ3Sli+NrDW4nu9vZa5NonM2sqSVgDsXU8wVmOeZoPhama+/H0kJx4SK+n+RXbxy
	tv8bRGATpMB051POfPpo2hqG4iETPdg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nr35iIMLyd10/NozvM5fMxHhJ/DSRkplZFTVJM0aV2Q=;
	b=p7sFxuBUPsdIlX8nMMPCMr07VxyajHwWaTBlvADKi37XKNAh8wL4MGHqaG9F6hi7Al5any
	KLXYvBdSHN77g3qXopf3vWZvdBE+JaFeBzfYdLcnZBSnmywIfDVkrorDkAfVHgbrO0QMOr
	TkGcMPMqzctKCoDJgLWN8ycJ02FJBUg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KBI3d6bn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3b40470fdd8so366871a91.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169422; x=1795774222; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nr35iIMLyd10/NozvM5fMxHhJ/DSRkplZFTVJM0aV2Q=;
        b=KBI3d6bndP8YhYghbxTbN1JuKUH/ljkWPDmQu+qNyS1PQ7c7x78r6R5DOlIigR4tQY
         Njxpe//mVlIIduGXfg8Vgbe+QIu2VCULW3RZcUkUbWRYVHwofTAU5BWa0rENHjHUWulD
         q8j4BdSLDJWaGvn53OP9JBf2vjQVvHwI+LJv04X2QHvCsQr+OZFNrJPPCCNOUhRZP1GC
         RVM06+mmVPGxG+QDspM/4xi/ulCEBZss7ssgJIiQKn6NxzRkn3AXVV9aUMcesqzhJDFX
         JkA4NCXpBkfGvveQn+Ca3JBXldELO7wRmU0U0Ln8OmvxnX8vEOrCCNMBaZafgc5BtBsD
         K3Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169422; x=1795774222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nr35iIMLyd10/NozvM5fMxHhJ/DSRkplZFTVJM0aV2Q=;
        b=yzKLmpTdwk/QpLGGTO6G5+AURVFQ9XEM20/RY7x3DyYADztbip5yJZD7lIS7b65F5G
         nsVV2hZfwRtMtYZm1THCaJffSypsiGTrTIJxCKaz7958vyR8SuvvSYRJeqptuz8FJXoC
         PPesXbhVToJLwUWOu/GksH2veRmbABN3WJcI4aQ7y3gsfJi00h5mCtRvyI66jxzE1zTd
         7vddh+74ofbHDTFzMZfGVvDG6aCaYXeRkbalqYLCu/3rijP0MLt7ANrYrIaD3K/A9+9A
         3oAtMIlPnoPpQQ5KO/NKqnqe5htyCiQAiQtRXZL/xSkLj26LFWLp1SkScLEz+BHuPl38
         hZug==
X-Forwarded-Encrypted: i=1; AL+hErFqh3oNcykl9cKkM+BZ1LNEVUKoHoBlUZTyMMYLSnyPqaURZcRV/4UypjGbVYjsy/JjstXcsNeI4g==@kvack.org
X-Gm-Message-State: APuU4Z/rWNi4MvWe8/RWVQb4kbhS/qo1pAi6L4xUHnBPahOf+jUB+uJt
	3XA6uWI60XcLxqkwzCFqo4GpFR8EC9zgkWWGwfaULGb1Rc3p96rShIpmB0hKjB0mbqs=
X-Gm-Gg: AZFdTZfPGqdrjzbkpoShWtmbYelLaz+QrHWFQdPIC7Y8OVi1n6FDtPPPtBfbLbK9K5Q
	RCVSSNuCKqeZYmz080YS0Dm67EcXJEYI9bd1bpwtrRfhtzKxV7kIl5FPPRegYPYHBrSXRkMelie
	zYtUn/Qjcni+rxcs4Rbjz7ecH/vG2ZWiaySi28JcUChN//ACarXctdebqfloPppE/+yoV4xNTZf
	A1uJkUMWnzBMkVAy2TDuPuOrvVEFCXQdRqH539X0y3hIcwLtMYnvKOM/TaPoSP4OmcjgCJlDnAI
	pd+mqywa9w2LhJG6WN/Toy1Nw9+OdULGV5FdxMywsgQIHiiY1jFNwHPUZBtwMZFnnCbgKGaFJPh
	yjjNzd5McEhp4+MFoGBJxta8iC3qQPJLXcjjWC7gA4ytlTdmvYTKAHermZPqAEPzFp8JQpun6OL
	7LyK5tylOdF/3lNlbx9G1qlBtezwsCKllEu5OdL5YuJoOkUwFg2WdVBVDd6+iUI+8NWxrxi+OWu
	ffgTN6pVrm0fCfdv7v20hb7dh4oYpsUn7muQyjEDeFUii+LTDL66MEJxrlQlDOVV6o3C+MI0S5X
	L0RNxUOWMG9Pt0RuKRSZUa6naID8upFV7Y5hpaeInWj1FEp8/k+j2yfa09t3wTFOpg6jKg==
X-Received: by 2002:a17:90b:1c03:b0:3b4:1bf1:988f with SMTP id 98e67ed59e1d1-3b41cb138f0mr2343147a91.54.1795169422392;
        Fri, 20 Nov 2026 02:10:22 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.10.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:10:21 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 09/11] mm/cma: centralize CMA pageblock initialization
Date: Fri, 20 Nov 2026 18:08:54 +0800
Message-ID: <20261120100856.16929-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: A49E0120006
X-Stat-Signature: km9tsynx54h6yw64z3cw8akrp4yx3fw4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795169423-765137
X-HE-Meta: U2FsdGVkX1/b6bb6k2KenpuCTmmv9sLDyxADqFW9ILGjaG0fSzeMcH6WAU/HWu9YSuUaBFSXlKRLSgfEFgTqrpAMwJDDJiY1e+b9BiiWjFv7g5oiSvGrf1aqal2F1zZbnR40ikTuPqcnqt8IBYR3/RPEhlHHBEVZRR+0A00jTtJQZe+32gMuZuGWLDGkQzntSz240aXltMoBm4i9zqhoSaeeg+w7f2+eDOTjjAPTRgXHeCsVHGqFgRFYCWviP1x1wpMBUsxRZGyBpNIMPZp7BZU05QyWzcKoznTpLWVzJUBUFvQngVpj7Mc71sAe0FaZ6XxzLZpEC22RCdh10lI3+rhZ3fmkSg2gTr/oUC23FzGlGGYDLnpRhSR5Fi7Ous6R+9SwRyyhd9xXglH1jxiGekKEkKj7wWbEel5Df/sUIY+TFVJ4vGWv1vsFkFD+1jmIlr1gKK4iZHXG5kglNMgYqYSffWnq6T6MHwNQwihorV4yfGQpspi9l7X/yf/s9ydsOlaKmuV0HB2G4Q+qGBjIgSDXlI96H96nyoT8wTfEj2DbFJvzaaSBvORaXPuJIhorPjenOGqEGGv1K9UY8zaV5F/CJDs4qbFwz0EvdLhvRHDf6VxOp7jcx2mv0nHg42PvM+6T6OhZXeOv/Hd8r1FsREtvQjK0hZKyNTeWcKqdbXldIGJe+1BrrOMLQYiijQJtURyf75PMMmlcHPAvvKbblrXHsljIo0tQ23+BAQLvBCmwzHG7vpMMevwxOy7MSwkZiQd5Pvv8aSszrH4bfKRDg5rOQB8jYJ7SkNvcK09k+2nVkiSuxtMDzRdjxXrxKPjlVkHOdbMV5jwE7NJfynjfYZxp4QRptz3dHDDMxWW1/SznccJD3hTIWcD9qoHJUBiITQDNKQ3ieCETed/9uSiqKep01K4b/4+jM9z6b07m23mL41EjGvIz3VvbIvAaEy2FpgWPFTIyw6csQ/4TGb7
 nfGA/26p
 g/hkKQJwrSnheDAxAL8pAuUmGBJiDRdZ7ynygmoWOviUMnsFyaYOIqL2rXQ9YE1Yfe1En2Cd0gOsvtckgw3Xem6b+IL1Txy5ZgNbezbxFXWoMh5c3XSTV1rcU8XEnZfuZ/m1vq/PZKVWPIBiRFdZP+JZVWwPaHEDg7I7DnOEJI2yzF3cogqiTHNeLM0Fjbv8CQZZz9u6yFXFT6wwh/l2BBbNHNf1BxYGOKCfB1Jxhpv6CheQ6/r3Gko4Mv4PHYiKurMxsdmnfLSpT3Af9TedGw6GavtIoQjXxlTphVO7GbamPL/64qV56kAZjW/XKZOIs1XHu6mhFpOBw2mHSIm5xedAIZifFJRtwTHyNS9SKB9Y7bdLtzMKDoz1hATx0vwU0813tII9CrPia/ocR1NvbKwaa+hPl0jRNOJwt/iWWeUvk/Ove0GGWTvq6UGDQ2GtiuuJ0QwBgbEmkIieS53u3+7CFdxRBBBZWfRP8I53oDQCTP64sHNgql8XR64oIAPGVZbrlLYg/1GktzbYSFZBnU/J8FHdjPbJzljsS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Early CMA reservations currently require callers to maintain CMA state.
This exposes internal bookkeeping requirements and splits responsibility
for the same area between CMA and its users.

Make CMA fully responsible for the state of early reservations. Pages
already handed to a caller remain owned by that caller if activation
fails, so keep their managed-page accounting intact regardless of whether
CMA retains the rest of the area.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v3:
- Restore managed-page accounting for early-reserved pages regardless of
  CMA_RESERVE_PAGES_ON_ERROR (reported by Sashiko)
---
 mm/cma.c     | 30 ++++++++++++++++++------------
 mm/hugetlb.c |  8 +++-----
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 61fc59fa70f8..3e4366213b49 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -174,6 +174,10 @@ static void __init cma_activate_area(struct cma *cma)
 			count = early_pfn[r] - cmr->base_pfn;
 			bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
+
+			for (pfn = cmr->base_pfn; pfn < early_pfn[r];
+			     pfn += pageblock_nr_pages)
+				init_cma_pageblock(pfn_to_page(pfn));
 		}
 
 		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
@@ -199,17 +203,20 @@ static void __init cma_activate_area(struct cma *cma)
 	for (r = 0; r < allocrange; r++)
 		bitmap_free(cma->ranges[r].bitmap);
 
-	/* Expose all pages to the buddy, they are useless for CMA. */
-	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
-		for (r = 0; r < cma->nranges; r++) {
-			unsigned long start_pfn;
+	for (r = 0; r < cma->nranges; r++) {
+		cmr = &cma->ranges[r];
+		end_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
+		/* Restore managed page accounting for early-reserved pages. */
+		for (pfn = cmr->base_pfn; pfn < end_pfn; pfn++)
+			adjust_managed_page_count(pfn_to_page(pfn), 1);
 
-			cmr = &cma->ranges[r];
-			start_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
-			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = start_pfn; pfn < end_pfn; pfn++)
-				free_reserved_page(pfn_to_page(pfn));
-		}
+		if (test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags))
+			continue;
+
+		/* Expose the remaining pages to the buddy. */
+		end_pfn = cmr->base_pfn + cmr->count;
+		for (; pfn < end_pfn; pfn++)
+			free_reserved_page(pfn_to_page(pfn));
 	}
 	totalcma_pages -= cma->count;
 	cma->available_count = cma->count = 0;
@@ -1020,8 +1027,7 @@ bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end)
  *
  * The caller is responsible for initializing the page structures
  * in the area properly, since this just points to memblock-allocated
- * memory. The caller should subsequently use init_cma_pageblock to
- * set the migrate type and CMA stats  the pageblocks that were reserved.
+ * memory.
  *
  * If the CMA area fails to activate later, memory obtained through
  * this interface is not handed to the page allocator, this is
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6a613d9c9332..7de65b540438 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3337,9 +3337,7 @@ static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
 	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
 
 	for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
-		if (folio_test_hugetlb_cma(folio))
-			init_cma_pageblock(folio_page(folio, i));
-		else
+		if (!folio_test_hugetlb_cma(folio))
 			init_pageblock_migratetype(folio_page(folio, i),
 					  MIGRATE_MOVABLE, false);
 	}
@@ -3402,8 +3400,8 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		 * in order to fix confusing memory reports from free(1) and
 		 * other side-effects, like CommitLimit going negative.
 		 *
-		 * For CMA pages, this is done in init_cma_pageblock
-		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
+		 * For CMA pages, this is done in cma_activate_area(), so skip
+		 * it here.
 		 */
 		if (hugetlb_early_cma(h))
 			folio_set_hugetlb_cma(folio);
-- 
2.54.0


