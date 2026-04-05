Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4A6F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0756B00B2; Sun,  5 Apr 2026 08:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7796B00B4; Sun,  5 Apr 2026 08:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED18D6B00B5; Sun,  5 Apr 2026 08:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEA396B00B2
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:55:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8043140A94
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:15 +0000 (UTC)
X-FDA: 84624497790.08.0B2D9AC
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF817C000E
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="DA/fBJff";
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKli8yHSnxAMZ2GmFUDAbnEpbh1w6hBHm6LRjyjJACk=;
	b=WAE9yqyBROOTks8j3lEUIhKZkJX4kPXBrq1jnH9Hdcvy40Vr/x1G/jNdF5AV1513D2PgKM
	Thaqd/5x+H19XLdpVJcXwoOTeAJ21Vm4kUHjVY4XQZi4A01n77KdI10QyxlgKkkREU2aTj
	Ps/LLcNAODxrM4h2Qz94zQ7luXiVOwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393713; a=rsa-sha256;
	cv=none;
	b=sLvQXDFy/nZh8toE14zm7X68Nd8EVAfxzvgqKhlcy8Nzn3WxmkNV4cqRCwMyIpbhSrdHpq
	ISdUk9RotSwez4Mg+m0g8rGEsgL1+vQFDw+0Flc9g1y4PO1yeoltIk3o8C1tgfx2TzZmUM
	fX/mQlc77oLEK50ywalcUCXLMXSSXfc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="DA/fBJff";
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so2875320a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393713; x=1775998513; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKli8yHSnxAMZ2GmFUDAbnEpbh1w6hBHm6LRjyjJACk=;
        b=DA/fBJffln3mzCqt/LOKsK8YFSrfz7RuoLpcr2U+wXhxCXpWRFrVZnuTgM1jPgyft9
         Li8TP1mq5vWLceNjR2qQsDXXBLqnw9tasmknd/YbFudHGgg85bGb68TqYYk8ZuwX42pq
         ybXWl/vzd84iTVRwmrdFLv8WohA5MTvAxThGiiVmEwcP0io4ZOafP+wa8caykZkvcG82
         r78kOSQzBNZsitKcJNAPs+QprAPdYnoQchWW4U5Ro2IufA7ozcm+U4xjIeg8Hr/H3es1
         2yKr8A1zoG1n1Kw/7NgH44KDxE8cLejDYtXLQVkUCLOTny7PUzz4t5K420Y36V5LXzaf
         Yrow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393713; x=1775998513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KKli8yHSnxAMZ2GmFUDAbnEpbh1w6hBHm6LRjyjJACk=;
        b=QxsK4YX4+Oiu53ET3U2WJOUt3w2R4EbdlImVf7FubKwyMtqA8rCXFASyKbDcU+0+pR
         ESBiaYqrk39rD5e/ETaWLAkYIjlAM6VPR/jm+WO6QfvCaJfZjmLYvP2a31VLwsUCTGPv
         LI4qR5pfq8jEROrFQt81lV6WzAMhiEf2QJQuCPxtLB+cnhVzHVO7ww2L1VeEjPemeE4M
         rSVKyP+1GuqTQ+4HZ2+mfq3iTqvo/hMxZqePfMHnFy6LV6a5dM6id3MQ9M+Hb5rG1ApK
         sWpVSPha7MttbRdGF6Cl9kdMNOkt84JC/fImNGm3ztBWjJTpUqfLYqHY0PX++4P8Wjfo
         l/ng==
X-Forwarded-Encrypted: i=1; AJvYcCXIYXc/qrrr6FHny8JgkLzMXAb7duBBmfaZKNBqJTXNcsZIiE3B9ilUCf80qgD/kYo4W5iFz8SGtA==@kvack.org
X-Gm-Message-State: AOJu0YxXrTEkNjCQG9Rq0/YuYOTr68x8pCECVUuc8dqhMDVlwOxqkTj8
	kQxthS9K9GE/gUF1n541yjwzkDy73XixfFQOk1JKyiWiLdtyeK0Hgf7B9+HipYc86mI=
X-Gm-Gg: AeBDietqjdcDxZOUOyrZWQRbHrBWhtkCdjHzZb4OjFItGUJGN83yDlIjDdk3Zv2SCKz
	KWRj9VR4oCA0zmX5y85EbpyEdnxNJVmyB6YsAIVs7PuUeyhr4p9LQt0poAgCGV0a1ir7J9iXXio
	prZHso75tpLf4Aba8r/A96rVoJpZyruT6VekExJoNJKa0QdQQflQE4l+KdjvDjWxsT7+GbYiQFM
	JSCaOXWdMi22NuyqQmQUVXwqvH51/dxVaFOlvGN1FbUXqDShtZqvqHQn13rmzXYhaNXQthH2r2V
	m81YnUMtirjIJqzoQ0LsZ1zIPwmuxkqmV+WrkHawI79tl49ErBRjb11e26GuSsBMq6lHVtKzIhA
	tbICDtiCkXsc7PT4TuKHyLeNHf6ESVYT1/X0aMjNjUlqw1znnAMb7tyVwCmjTEcNc2tKF4QNMV6
	5UhTsxPoAend4Lo/jvHHb3NHiLSaisqYi/3rUcCg9oIQSRv/CXceGS6Q==
X-Received: by 2002:a17:90b:224e:b0:35d:a90d:580e with SMTP id 98e67ed59e1d1-35de693d12amr8416296a91.23.1775393712638;
        Sun, 05 Apr 2026 05:55:12 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:55:12 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 17/49] mm: remove sparse_vmemmap_init_nid_late()
Date: Sun,  5 Apr 2026 20:52:08 +0800
Message-Id: <20260405125240.2558577-18-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: nyfarbgf4ubnjbpkoemkkfbd586rhsyc
X-Rspamd-Queue-Id: CF817C000E
X-Rspam-User: 
X-HE-Tag: 1775393713-699661
X-HE-Meta: U2FsdGVkX1+CtLRKLOFXv+yGYa813dz9Qnr0v2rm75v4wLrACQ1gCk59K+KwK/3M9lfVtpOK6+jOuPj/I19rHnsO5mpBH7Np9IqBQtY6u9BClMkvxMindmvr29RGqTn/ifES2PnllS+bv0EjK/10LHFu+uBJJmoI8uZYNHMyrJtkt6byCo8Xa1EG3MEvd/JkFVex5cXoXwPvVciNoEJOinV523Wwi179eD7dhYsjd6OdCMzhdgFtrpzNICUXiDToKamfu+9vm9Kna1JzxiOos6e4EVmLTrMsYCK/ziQoL1bgbGYUw0o7Uapd6zm3fZ3EN+ibWd/b9mVl149XnLh++wQug6JWSqar91mfu1cr2CqUnATm5bQZWDvmlafT4Z/pl+l+02XWexa+Tiy3YR/PbeOeKLUBdFAc43A2SqYdiZo9tWuoCsaVFQl/bGUZ/dfXSD/Na4OYS7cS3yMfSucvH5wMnx5FuTvyTX3Os9GvM7zkBgx7ot7ANxW/AmezeIOku/WFSOSDxv5Sl7PkPORLlZOygfABVjNtULomkLVzi1EgG405niTfQYvk649xOpT9NMiSGd81qO37LFlEP3DML8aH6X1x5tBun94oC63Re+ttyCj34Q8yq2lviV/9djiFAEGQmqSbCxLq/LBgsMcBttYV8eMu3L6HFeveMMy/HClIGRRFjf4Epdd7AJ3U4dWbRFAGENpq717kiFEyFQPA7b98r1cI+/FlCi2CiUHzqTLk4FE3RQA1U9NQtGXcCbS0MdPz3XXxzTPPkMjDsjBMF/Esfn+wQFMV3ZfLXJmdnLsB+Ejr9aiMLLloZvhPAaFBPKSe3LbUrx9SwyCUeN0zkKvZHb23DL0Bsxb+63WspkjKoHlFe0zr2RdBjuXbfVJJ6dkAGP8s8LokXpKZqHGtDh2yAiik1A0Q9BwiECRxXzdD8+W+o1xEm+9ehlUwPOyi5Tvi0CeLMhoYV0Z5cpW
 nrc7da0I
 LEODIr6V0CLbg6FNOCmGMfVBxOjPSplp1EwEt+Cj9lDFiO7rLyg0JfMh17o2gU+z/+9qZArMGDP3PbEXozuvwxPseNZRlnHViDCZIWrdRVbXpfpl2GwYEqd68Vsh08wq4y13hlMfbhRsP0F3RDI7QG/IsEG4ckLeFTMsCE4GUVqoASfdGcElBJ/9Fink6qWILJdxoxKxo7otz4niJuIue7fdvVwfXPMzC8REqa1Plkg3nTXadqfsVCWGKAR4ocJU4akjlB/3/lY33YOBS+V+SHt6tnL7rXhUVMv6U1hr/iHpx+67jltEleZHvPrHAJvVrEZP3nDHUi+amP3ym6lOgtO5B0Gc0+AtFCGB5KEKN6joydtE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After deferring hugetlb bootmem allocation until after free_area_init()
and checking cross-zone pages during allocation, the hugetlb_vmemmap_init_late()
function is no longer needed:

1. hugetlb_bootmem_alloc() is now called after free_area_init(), so zone
   information is available during bootmem huge page allocation.
2. During alloc_bootmem(), cross-zone pages are identified and marked with
   HUGE_BOOTMEM_ZONES_VALID flag.
3. After allocation, hugetlb_free_cross_zone_pages() frees those pages that
   intersect multiple zones.

Since cross-zone pages are already handled in the allocation path, the late-stage
validation in hugetlb_vmemmap_init_late() is redundant and can be removed.

Also, the sparse_vmemmap_init_nid_late() function is now empty and unused.
Remove it to clean up the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h |  2 --
 include/linux/mmzone.h  |  7 -----
 mm/hugetlb.c            | 70 -----------------------------------------
 mm/hugetlb_vmemmap.c    | 58 ----------------------------------
 mm/hugetlb_vmemmap.h    |  5 ---
 mm/sparse-vmemmap.c     | 11 -------
 mm/sparse.c             |  2 --
 7 files changed, 155 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 9c098a02a09e..23d95ed6121f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -699,8 +699,6 @@ struct huge_bootmem_page {
 #define HUGE_BOOTMEM_ZONES_VALID	0x0002
 #define HUGE_BOOTMEM_CMA		0x0004
 
-bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
-
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a071f1a0e242..8ee9dc60120a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2153,8 +2153,6 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
 }
 
 void sparse_vmemmap_init_nid_early(int nid);
-void sparse_vmemmap_init_nid_late(int nid);
-
 #else
 static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
@@ -2163,10 +2161,6 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
 static inline void sparse_vmemmap_init_nid_early(int nid)
 {
 }
-
-static inline void sparse_vmemmap_init_nid_late(int nid)
-{
-}
 #endif
 
 static inline int online_section_nr(unsigned long nr)
@@ -2371,7 +2365,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 
 #else
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
-#define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 238495fd04e4..a00c9f3672b7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -58,7 +58,6 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 
 __initdata nodemask_t hugetlb_bootmem_nodes;
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
-static unsigned long hstate_boot_nrinvalid[HUGE_MAX_HSTATE] __initdata;
 
 /*
  * Due to ordering constraints across the init code for various
@@ -3254,57 +3253,6 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
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
@@ -3320,17 +3268,6 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
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
@@ -3700,20 +3637,13 @@ static void __init hugetlb_init_hstates(void)
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
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index e25c70453928..535f0369a496 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -807,64 +807,6 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		m->flags |= HUGE_BOOTMEM_HVO;
 	}
 }
-
-void __init hugetlb_vmemmap_init_late(int nid)
-{
-	struct huge_bootmem_page *m, *tm;
-	unsigned long phys, nr_pages, start, end;
-	unsigned long pfn, nr_mmap;
-	struct zone *zone = NULL;
-	struct hstate *h;
-	void *map;
-
-	if (!READ_ONCE(vmemmap_optimize_enabled))
-		return;
-
-	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
-		if (!(m->flags & HUGE_BOOTMEM_HVO))
-			continue;
-
-		phys = virt_to_phys(m);
-		h = m->hstate;
-		pfn = PHYS_PFN(phys);
-		nr_pages = pages_per_huge_page(h);
-		map = pfn_to_page(pfn);
-		start = (unsigned long)map;
-		end = start + nr_pages * sizeof(struct page);
-
-		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
-			/*
-			 * Oops, the hugetlb page spans multiple zones.
-			 * Remove it from the list, and populate it normally.
-			 */
-			list_del(&m->list);
-
-			vmemmap_populate(start, end, nid, NULL, NULL);
-			nr_mmap = end - start;
-			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
-
-			memblock_phys_free(phys, huge_page_size(h));
-			continue;
-		}
-
-		if (!zone || !zone_spans_pfn(zone, pfn))
-			zone = pfn_to_zone(nid, pfn);
-		if (WARN_ON_ONCE(!zone))
-			continue;
-
-		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
-					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
-			/* Fallback if HVO population fails */
-			vmemmap_populate(start, end, nid, NULL, NULL);
-			nr_mmap = end - start;
-		} else {
-			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
-			nr_mmap = HUGETLB_VMEMMAP_RESERVE_SIZE;
-		}
-
-		memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
-	}
-}
 #endif
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 18b490825215..7ac49c52457d 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -29,7 +29,6 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
 void hugetlb_vmemmap_init_early(int nid);
-void hugetlb_vmemmap_init_late(int nid);
 #endif
 
 
@@ -81,10 +80,6 @@ static inline void hugetlb_vmemmap_init_early(int nid)
 {
 }
 
-static inline void hugetlb_vmemmap_init_late(int nid)
-{
-}
-
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b7201c235419..26cb55c12a83 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -581,17 +581,6 @@ void __init sparse_vmemmap_init_nid_early(int nid)
 {
 	hugetlb_vmemmap_init_early(nid);
 }
-
-/*
- * This is called just before the initialization of page structures
- * through memmap_init. Zones are now initialized, so any work that
- * needs to be done that needs zone information can be done from
- * here.
- */
-void __init sparse_vmemmap_init_nid_late(int nid)
-{
-	hugetlb_vmemmap_init_late(nid);
-}
 #endif
 
 static void subsection_mask_set(unsigned long *map, unsigned long pfn,
diff --git a/mm/sparse.c b/mm/sparse.c
index d940b973df66..5fe0a7e66775 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -383,8 +383,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 	}
 	sparse_usage_fini();
 	sparse_buffer_fini();
-
-	sparse_vmemmap_init_nid_late(nid);
 }
 
 /*
-- 
2.20.1


