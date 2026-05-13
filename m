Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 129BACD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D7D6B00B1; Wed, 13 May 2026 09:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7056D6B00B3; Wed, 13 May 2026 09:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B596B00B4; Wed, 13 May 2026 09:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 500236B00B1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D88A1C056E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:04 +0000 (UTC)
X-FDA: 84762427008.30.BA0A087
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4CD1520009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Sg0/53E7";
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6ElOBv7vrKvKF8FNit7K/7AGAfvZCZIjE1YfuNh7wQ=;
	b=NDmmwsS9f9w3p0JCEM5LvnZtUrMdVXVdGxND5OF4DP7DSXZFvymZmh9tNh7LNO+/rVctoc
	2aVSoC2LTifNpa+AK4DVdaDDS6o6kSbOMasPoNLO/TdDIkZWUkfYb8zEVr0DlVZOJvqcM2
	qZnp+8Yaccy9sw5eHz4vvFCx7FCbKnE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Sg0/53E7";
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677742; a=rsa-sha256;
	cv=none;
	b=f547JCKP9WYTuskPmgGzfNnX16X5hPg40QSA6XGd/4v5Q0Hy45MvJaKUJp1d12e1Q4Dsek
	yCVV5HE+J+RDvYhluP/j9+OP9kP/ygP7QqfBkrY5XSWOn9hXQ/6dQbllFqnN6Hrbz1slde
	yYK5yGBgDNa4uE1KO1B2jrsvybHxdts=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ba4efedbeaso47452205ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677741; x=1779282541; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6ElOBv7vrKvKF8FNit7K/7AGAfvZCZIjE1YfuNh7wQ=;
        b=Sg0/53E7gNuskMMM7zKrGyvto3PoCq7cZtW39JWIMxPFmY9hq1KkVhvxnr3dm+S/z1
         csFr5tUUzWgJlS3y4xCrdV7MHv1aJDKRLB3Vzye6IEWCIXehf9Xi1OL8C/oM9M16GJQc
         jpONmPGoQM5e3WjQ82FO/zp8b6aM3tPSa3iLXt0vWLLtq+EJasDTqgP6d8GY+/WA05pV
         n5XCeukLxa+1itNLbwZXidaz1fS3p4HdWX8tngmlEMlZEXALeL1GrfG+V1L4uiSMHAWF
         GANFc3b1rgobHXyUJLaDwkvFZaddyqGdYLuPzqrepIefVTjtSJ8kMhLoy6Og3f7vvD1v
         KJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677741; x=1779282541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J6ElOBv7vrKvKF8FNit7K/7AGAfvZCZIjE1YfuNh7wQ=;
        b=VU+7j61E0UpIVwDxQG6BlOoM8s4GWx7+pfoYkp4nZKoi5AGjGWln/I8YnxsE0dwc8w
         WxBFZrcFIDUlOE6ggByCg+yZtMqw/L1pSUwIZdWMabfWHQTBa9XKr+ys9ZP9/J+Xmj4p
         HpJCiAtMxkk2ZT6BzmJREf462JICWDq3gz+BU6sOYCkNVXPx6trHkunGYJxZwc3lEBvJ
         4kRFQsDgmjZ5jF3mQ0zlit1aw0xq7mMkxFF+ANg7eljoreEoaJMLoey1FJCZEXl9sbNb
         57ohSbXzMdPlQTtuAd4DkDdTrkfQhbffeqehdMtLRDKq8ZOUTn5ZuaNomfY6tzwkEmQ3
         ZNhA==
X-Forwarded-Encrypted: i=1; AFNElJ96+SitFOC0JuwwIDaUoIzwFBalHwxdP/v6j/TvU2FBMTCN+jyRKdY9QVEqvjtP8zIJQM9mtGK1mg==@kvack.org
X-Gm-Message-State: AOJu0YzDljfiAKQQdZRZTzYO52VEvBwrCU/JtBYWF5XmxLRiajLx2GEg
	9YGDRE1tfbfIvnV8/w3UkbG8ZPzj7gQbPERmDE1G8O4yYRPJK6UVXxHO2oxsdx9zrDU=
X-Gm-Gg: Acq92OHWzT4ydHZdyDgY4JK0pftuR8o0uSo0zPTIL4fs7zDaWY6S/IgXyxGdyO/A6qM
	oYQMSuUjN2tnp/SZAhKjbtxoJhkAbulf2TcH18aLj/FJq9XT1ny/zBXkrZvAiyqn09t9Lhrne9c
	6jo7ck6xdtup8URVHJz0ve4CSe06VkaTBJZQaCb54UJizDwVTcPCS6ysVq8tSgoJn2pIN7YCY/R
	xC4tMuIFk43Cq+z2mqHHJkK8StFq/CgB5lc9ApxhjmJXyK87WyiO4BziN5S88kFGos405RGCUmm
	ot2p9oyPwaa1+xxtgrSzl6i9Bl10jEHGo50PJ5oG2/tkav700vmkDBX5OXh1r047ulwDATNVKGg
	R5/8Dv3NA4dS4ngyai+rKVKTaY8dOwWnOVe19lkmFSJak9G6lBgNAVV6kPkozgQVHTuJQAj7+q5
	xDOeKPOhB/jEPbmHoidGJErwMkokjZpvbF3GW1Tbepc05K9d/E4QfXfcHOhna+8FDllPBLMg==
X-Received: by 2002:a17:903:46c4:b0:2bd:2de3:51ad with SMTP id d9443c01a7336-2bd3043ca95mr32688825ad.34.1778677740889;
        Wed, 13 May 2026 06:09:00 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 16/69] mm/hugetlb: Remove obsolete bootmem cross-zone checks
Date: Wed, 13 May 2026 21:04:44 +0800
Message-ID: <20260513130542.35604-17-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: djmo8dc36tny1tmz4rz7nj3hca33s4dd
X-Rspamd-Queue-Id: 4CD1520009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778677742-467208
X-HE-Meta: U2FsdGVkX1/qvieNfkAb9iJOwMsol2xfHn7swUvi+mqm3uTz93CWZt5KKu0l19DDwUXxhH9/GO0VAKt3UHxfYjZpnYy61J6x5S3nsVL617erajK60HYnrU3y6ir7X8VFKBKRxU9AzW8rFq2f931n3lH7Prw48VuJXQJGDgxi9LtfFIH4iq7M97tBnmrhzOQcGw0EgHa3jWqUzUhgisPo8eOIYcbXiUH8LEzLH4QPAs+yK5N+6yU179XerROxePOT/6PkKu+o13E7z+sNXVUmmAtb+mGeVEqqB6+Q9eG5fjt7NMB77hlgwZYKj9VRHsQasFcjrz1RRzff6+nDu2WR+Sm9iYudqimwPnvZpdSEbgRAx2KQwav/6DuY70IUDsJZEqZqx0Yd32njO8qV1ml/MlrCHIGhFK16Pq7MgVYWEJc6sQac5/y2zJ9byywZtVRTdJT+iGHjJsghyll+9CxiQGOrtZk1lldqQIvAjzIWB9CUTcB1Y0JNcNLTCIQaenRZZtwR+b8UaBvGwjNbp+lM/MrmsX0aE4qbD2L+QPwCaxzRWQg3PDFhqVUmbsxwGVvXuXoysVT+rWez3FjnGK5TGe5ejcQEsnHooXPLxktxJqN3CcQQ+MCuRJkDn6gfqCskOkdbXK/2spbGgWZ0B33Df8GTB2G+Mfp7Zj3/akLVJJdX5L4uhxIwegBFscbp8EmmzJTmVG5+Ms1Pq2KfmklGpg5JvOPYTkabjY/NfxOeF7taQKI1uj6bWLHmWMtrEMc5+rd6kmMjpi3mHyvMgew5mvZ1X+mzI2cUdyunJlnTduHSdHYx9uvXo8U28AMJB0CmuSeqKuMa7CaZMlZSO8iwrVyZWkJGthWvCtX3xayil9ZvBgSwrY6nxTwkOxAItqyjmtClCPFNNDZE5f9pVsG1kVWkrV29a4I9rXTwuKzPtZDT8cB1GMtOzFqeNRjX39UCFwBEsFgWUfMlNjr67bp
 xqT8TgG0
 l3mr0HMJshHq9z+rdgb2WE0Ts6MrenNeyvvywl3fN1T+HhntzG+yTDhXQdaXsvXMpB1s+3cKN2NLZVLgtrC/fzyQsP33E62OZ+F5F7y56RTm35JqmMbzZNsiNoh+FE/YO1iL8eAlOMug7AVKRBpf5zkBGHJeyCseP4IJxg+/3fk0dxsB9UsVjhB3rm89Z2VdgDx3PR9mcfx5N6k5V02QIAcsNN2sCeSnSXmCKTcyWqYWA+cMg+bhPI/aJnS/vccfTfbpZP3COEdvcaVSASDSdSo+yNSxvrtqUgMZ2nCA/ywIbgEahWqXKBIFYVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bootmem gigantic HugeTLB pages used to be validated again during
gather_bootmem_prealloc_node() and any cross-zone pages were discarded
there.

That validation is no longer needed. Cross-zone bootmem gigantic pages
are now detected during allocation and freed before they reach the later
bootmem gathering path, so the remaining pages are already zone-valid.

Remove the obsolete cross-zone validation, invalid-page freeing, and the
associated discarded-page accounting.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h |  2 --
 mm/hugetlb.c            | 70 -----------------------------------------
 2 files changed, 72 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 9a65271d167c..ece4e6a4a4c6 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -701,8 +701,6 @@ struct huge_bootmem_page {
 #define HUGE_BOOTMEM_ZONES_VALID	0x0002
 #define HUGE_BOOTMEM_CMA		0x0004
 
-bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
-
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d5d324f69d7a..dcf8e09ec6be 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -58,7 +58,6 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 
 __initdata nodemask_t hugetlb_bootmem_nodes;
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
-static unsigned long hstate_boot_nrinvalid[HUGE_MAX_HSTATE] __initdata;
 
 /*
  * Due to ordering constraints across the init code for various
@@ -3238,57 +3237,6 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	}
 }
 
-bool __init hugetlb_bootmem_page_zones_valid(int nid,
-					     struct huge_bootmem_page *m)
-{
-	unsigned long start_pfn;
-	bool valid;
-
-	if (m->flags & HUGE_BOOTMEM_ZONES_VALID) {
-		/*
-		 * Already validated, skip check.
-		 */
-		return true;
-	}
-
-	if (hugetlb_bootmem_page_earlycma(m)) {
-		valid = cma_validate_zones(m->cma);
-		goto out;
-	}
-
-	start_pfn = virt_to_phys(m) >> PAGE_SHIFT;
-
-	valid = !pfn_range_intersects_zones(nid, start_pfn,
-			pages_per_huge_page(m->hstate));
-out:
-	if (!valid)
-		hstate_boot_nrinvalid[hstate_index(m->hstate)]++;
-
-	return valid;
-}
-
-/*
- * Free a bootmem page that was found to be invalid (intersecting with
- * multiple zones).
- *
- * Since it intersects with multiple zones, we can't just do a free
- * operation on all pages at once, but instead have to walk all
- * pages, freeing them one by one.
- */
-static void __init hugetlb_bootmem_free_invalid_page(int nid, struct page *page,
-					     struct hstate *h)
-{
-	unsigned long npages = pages_per_huge_page(h);
-	unsigned long pfn;
-
-	while (npages--) {
-		pfn = page_to_pfn(page);
-		__init_page_from_nid(pfn, nid);
-		free_reserved_page(page);
-		page++;
-	}
-}
-
 /*
  * Put bootmem huge pages into the standard lists after mem_map is up.
  * Note: This only applies to gigantic (order > MAX_PAGE_ORDER) pages.
@@ -3304,17 +3252,6 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct folio *folio = (void *)page;
 
 		h = m->hstate;
-		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
-			/*
-			 * Can't use this page. Initialize the
-			 * page structures if that hasn't already
-			 * been done, and give them to the page
-			 * allocator.
-			 */
-			hugetlb_bootmem_free_invalid_page(nid, page, h);
-			continue;
-		}
-
 		/*
 		 * It is possible to have multiple huge page sizes (hstates)
 		 * in this list.  If so, process each size separately.
@@ -3703,20 +3640,13 @@ static void __init hugetlb_init_hstates(void)
 static void __init report_hugepages(void)
 {
 	struct hstate *h;
-	unsigned long nrinvalid;
 
 	for_each_hstate(h) {
 		char buf[32];
 
-		nrinvalid = hstate_boot_nrinvalid[hstate_index(h)];
-		h->max_huge_pages -= nrinvalid;
-
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
 		pr_info("HugeTLB: registered %s page size, pre-allocated %ld pages\n",
 			buf, h->nr_huge_pages);
-		if (nrinvalid)
-			pr_info("HugeTLB: %s page size: %lu invalid page%s discarded\n",
-					buf, nrinvalid, str_plural(nrinvalid));
 		pr_info("HugeTLB: %d KiB vmemmap can be freed for a %s page\n",
 			hugetlb_vmemmap_optimizable_size(h) / SZ_1K, buf);
 	}
-- 
2.54.0


