Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BB6D606A8A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=iQ7f8RwT
Received: by kanga.kvack.org (Postfix)
	id 684576B066E; Thu, 12 Nov 2026 22:35:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635CD6B0670; Thu, 12 Nov 2026 22:35:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF2F6B0671; Thu, 12 Nov 2026 22:35:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23BBF6B066E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:35:58 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE8441C4508
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:57 +0000 (UTC)
X-FDA: 85428681954.13.195CCDF
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id DA3BF1C0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iQ7f8RwT;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTrWbknatFVsI+awgWDkyqVXl5d5IMgRvIrLdIBP3VA=;
	b=fM7jlSZOnYpBINDgE5N0gccC4ARsd2b3sg2Lg6Ak7pghMDw9ZwSZC7VPXtALaM1L3ox6Sl
	cUdNS8CtE8nQsAjEiQvkQ6qF1HbsT6M6EfoyFiK2yxbtr/uJjd788LxBz24ZQEe/XoiKMW
	QgN/hXq6G5M2PbHCLhqchU1YmpTHD0w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540956;
	b=UTRaWvTMWmHI8oVJektn3g2jn1H46X3zLcoW4S2Q8YHBQZG0OD6tcb7VHtqviD994bJtxk
	a9lG43DUvpuxC0lmt3jjvy3A4LojOLv68C5WSReppgw4vzh+2gsB0UhCmFDR4JnLBUKX6t
	s38ns/aBi1ctaaVb8oLP9cQEdJky6cg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iQ7f8RwT;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-37986eb6fa2so941418eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540955; x=1795145755; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mTrWbknatFVsI+awgWDkyqVXl5d5IMgRvIrLdIBP3VA=;
        b=iQ7f8RwTHmuN8NhIi+e8wllx4O0NSvUZRWZwKTperiktcSxzRI6LMfZC/HciQDlBCK
         zJAxyQB3sRq9zqpOZxVoKrZBIHAPztC6Lx3WD4PMUdxwPe1kzMkGnreCRr8a0u7lS1oB
         a2isGv525FNsrVYVvd5x2L3yRPByHcS28kyPEJ8gWoiaXMZWR95NMol4WSDG5JNoL4+k
         fGWCpxJgX/kMcXM3wOL7elyQ+YintlGz0cJaQZIsYrT64VRvqSLLK8SoC8rjo0p8w4bP
         ej427//GSiva4JqvA7OTUNZ+MJJGCBrnDaeUBu8r+6EOyj1BJUF8WAPpWzrEloOsufpT
         IDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540955; x=1795145755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mTrWbknatFVsI+awgWDkyqVXl5d5IMgRvIrLdIBP3VA=;
        b=F8RLnBTepU9MZtU1fVz7JTD1b92dBkBWwD79taGx41qTmnwPL+KjOSwdlvrO9BeM+0
         DsKSwO83hj39SyQs7rxTSBT0cJq7OfEulloaYMu/aij1DR4X8IdEn/veDqj7yKVEQSWc
         sQ0TegNhUvZ7FcfchJq9ji4k7pMXbiSOWx8mdiA+Y/ilOenWvWmrRBLWd20WpqRd/NFP
         ozTNZGeodd9VeQicrC+mgVeMDVEsOb7KdK8aoLIfKEhuyBfTRAwM+LQLm4YOaR9FQzqE
         rlX1vhOAW34eI3cEjhKHRmpvL70wY2QbDD0yeLXpRqnpVPL+k8SKoAd7EGbUR5EnFKyn
         jdgg==
X-Forwarded-Encrypted: i=1; AL+hErEMi47p5kJXieBcmvHvKfTkiGiHGYhwAUfd0cTXrxKsoEPDwbwLBx23F1j3XYz/BlqxVBsZCuKXNw==@kvack.org
X-Gm-Message-State: APuU4Z+FeXJP0N+Nq9Kv+B+snR6zHDaxtBG4puhcCMzt9YZl63gHs5zD
	2O686bvl06PeBd7zfbg/O2NG9OCe829SnZQMgqdIz7Qlt6RzrtoJc/eVvji1ieXKGr0=
X-Gm-Gg: AYBFou16akLPgtel75CEBTkihVEqKUVQMUbTuzQnnitLd06gs0Lf2qqESOyjjEZi8/p
	LVSwgC6ivdFFswLsJmPyW+vWbrFQHsQVT7jj0Lzdg+QgVAeUjZQeft5nP9GmUX76erBXnPYEbEK
	8IRIs+5y3iftbIpihukbU6C7kYTfyp09E5XOXKm2AzMspeB7vzX7JtOba42MABbeyQEmnbL5KDI
	bLplPIFg7eaaWHB1l8ydQtFeTfXHqewivIxx87cVAYpN2Dt69VgQsup5H8knxMD6vJL1Md9Xz7C
	SmfL8kRUEnZ+0YYK4CbJAsMs/kcTrIHn28bpFb9xFdvnUr2FVPCruOUfjNpcT3DuxHouY85ggyj
	ZpZ5IDO93Vl+PrCQDQQ+Sxw3jFUkok03wYQauinAH6T63HKzmud1djOFPSE3qb5trKw8yJhf0k6
	1NSTMl3zgYK522lJOR1vemp2Tm2ven1hhNkmRQDkUcBGS7KdStMMmvpKZsHzesjGE+uEOJHWQyc
	JPgRkDvaJUaX0wuFeZcx7B/pdBeWkPjjEiA20eYflVZJxi39XBZY+IdwA81PFcYowCsQc5eKpg/
	whpbrG/0cQwO+gSQVKKVZjS3kZGGOCtUgs+2Kc8d4XIoBnzyl9LnlGMU8Cd48RSosiBcccKyDbI
	xDhkoiy4=
X-Received: by 2002:a05:7300:f694:b0:375:fb27:2c59 with SMTP id 5a478bee46e88-37966c4a50emr1738130eec.20.1794540954454;
        Thu, 12 Nov 2026 19:35:54 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:35:53 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 08/14] mm/hugetlb: initialize all struct pages for bootmem hugepages
Date: Fri, 13 Nov 2026 11:34:36 +0800
Message-ID: <20261113033442.62970-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6higzypf3znhdbr48ykhwhjh9gs7ggjg
X-Rspamd-Queue-Id: DA3BF1C0002
X-Rspam-User: 
X-HE-Tag: 1794540955-187486
X-HE-Meta: U2FsdGVkX18qw7vDKSGP9dBjFO5rPFPS96LwoXakAsPs9Lkfs0phv892XtTsp6HgpojDYhT5SfkW+2iNFxqAcaDvOOJNwFdPlty2MkbZEVqUX5USe8FgMb47BWxDmj6hBHorlcQS/VDO8JtuRc7aDJKGVnz9t2+9t7fVifWMxv4zji0eMW/ZwAMyI6buFMeDkHYkQPDKJDGK/4owX7kDGmxPsHuBOc5SaIfZLWe6cyFqcEb0xrIR9TCBBrsy6LdW6rvWqeEmBmEg3rMZGj3jYydyVA72Nrs3Lr5fG1tOnFc4oWt9KY8DfdJr7J95NW1j/1gku+CJsxqFYCTgnfLVvOYtLVFNCS+fml43d7kKJQS/5dWnGWgn46F+anyl5nFzypRQ/1ngvc79xL37SCAlWK1FqC+nOt0ZOZYSvMOl/qFoUNNrwsr0PkhW73huLvV7ZymQzn5tN5Xt456e2HsK94gPCcn4Mx1GKbqf27eSrVxOekIjOwSv08m/+Djx5iS9GQ7NNfrcMAXEWsFZOaBMcEqLljh+O1wVKOMqeMXds8TmPAtvD72cQyoGOW6/cBZH3TlfNGqg+Ff92IkMy8MOyj3aEk9/Qf3P3oUAibVjMVhzGzwYIFWFe/l39ztoWy+Kg2gmVwYKfqBMLS8g1SEK0pZ7Y2LS7NXrwWbf97n8YxYh3QBAW2ybUrCOSmgXFCBKcreESEYKoXH+/Yv+1JbplHF+gUseB+sm/J2l2ic3mA9zFQ1twk6ZJMRjkg5KGP29s8c/Luep/8cvy2j/Iof7GsNd3M8G/7zFHsYDqVNRaRv9eamcf/yIPGzDvIUBS2TGtmP3C1WRfvDXFogswlZfM0HhEtt0QI9pXM5isce8O/RysUMMAyOeeqnnixPbMi3YwJi9JmYDTgruuzOWf4uFfaLZfjrySBUmXIKUqlgT9OSQg385tERXEUqtnhvksHGOkcHBU8QVI+welh9GltR
 c87EvAlt
 uactII8H/zGE9UXuFGDY4AQljhrsD0SQS0C1Hgl4oa+gxE46i4ChVfVNqoNBiJq6kvYUn0uk2cRrTVvf/5Z0Vt+gfOrMisfMSLubMRQK0zBx70/kU/eCnYfip/FQkg0W3a+LRxObtuX6lYVmb4lUvMGzh0U2pvL3mh4cs1FI5NNz4Em8Q2ECdxIfSNIHFQLExX9OTxSOMCajjbVL3LVKYOPBTGUSCKnDyF4frxvew0EumMmCYZjtBErvoU8f3qT9Rnc0l+5H8uAp2Uqt6YbXnWFd+wOf5snk9Mi1Aw1rd38RSnNpVCz8Km4LLKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Boot-time gigantic hugepages currently leave the head struct page to
the generic memmap initialization path while the HugeTLB code
initializes the remaining struct pages itself.

Mark the full hugepage noinit and initialize the head struct page in
hugetlb_folio_init_vmemmap() as well, so the whole compound-page setup
is handled in one place.

This can also reduce memblock metadata overhead when many boot-time
HugeTLB pages are reserved, because physically contiguous hugepages
can be covered by fewer noinit regions.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3a307bc6db17..2716a83a7386 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3243,15 +3243,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
 		hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_order(h));
-		/*
-		 * Only initialize the head struct page in memmap_init_reserved_pages,
-		 * rest of the struct pages will be initialized by the HugeTLB
-		 * subsystem itself.
-		 * The head struct page is used to get folio information by the HugeTLB
-		 * subsystem like zone id and node id.
-		 */
-		memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
-				huge_page_size(h) - PAGE_SIZE);
+		memblock_reserved_mark_noinit(__pa(m), huge_page_size(h));
 	}
 
 	return true;
@@ -3295,22 +3287,23 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 }
 
 static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
+					      unsigned long pfn,
 					      struct hstate *h,
+					      enum zone_type zone, int nid,
 					      unsigned long nr_pages)
 {
-	int ret;
+	struct page *head = &folio->page;
 
 	/*
 	 * This is an open-coded prep_compound_page() whereby we avoid
 	 * walking pages twice by initializing/preparing+freezing them in the
 	 * same go.
 	 */
-	__folio_clear_reserved(folio);
+	__init_single_page(head, pfn, zone, nid);
 	__folio_set_head(folio);
-	ret = folio_ref_freeze(folio, 1);
-	VM_BUG_ON(!ret);
+	set_page_count(head, 0);
 	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
-	prep_compound_head(&folio->page, huge_page_order(h));
+	prep_compound_head(head, huge_page_order(h));
 }
 
 /*
@@ -3368,8 +3361,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
-		const unsigned long pfn = folio_pfn(folio);
+		const unsigned long pfn = PHYS_PFN(__pa(m));
 		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
+		const enum zone_type zone = zone_idx(pfn_to_zone(pfn, nid));
 		unsigned long nr_struct_pages = nr_pages;
 
 		h = m->hstate;
@@ -3382,11 +3376,10 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		prev_h = h;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
-		WARN_ON(folio_ref_count(folio) != 1);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
 			nr_struct_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
-		hugetlb_folio_init_vmemmap(folio, h, nr_struct_pages);
+		hugetlb_folio_init_vmemmap(folio, pfn, h, zone, nid, nr_struct_pages);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-- 
2.54.0


