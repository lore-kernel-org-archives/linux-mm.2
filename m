Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E9F606A330
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=BFRGyZjX
Received: by kanga.kvack.org (Postfix)
	id 279586B015F; Tue, 20 Oct 2026 07:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A1B6B0162; Tue, 20 Oct 2026 07:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1189E6B0163; Tue, 20 Oct 2026 07:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D99966B015F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:58:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CDF81C036F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:44 +0000 (UTC)
X-FDA: 85342857768.15.7EAD38D
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 594161C0007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BFRGyZjX;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497522;
	b=obDqy99kxbGt4mo8tG0wQT9yjWxAyXdBXwanUlY5oJ9u5LhMquMa+JWOrR9XyUGtkqt+pr
	x77jT/bBHbXutAVQO9aT6zjGOp8Nc6hvvslKL7UgR4JpnYovnek5jie+SmCp2Hq4GaDov8
	Ycv1X9mkAc3Gcv5WkAFXiguagpFxu20=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BFRGyZjX;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTHS7FXG3yRMZ0GtPZv/7Y6mv5vhk3N/ykMwP6C0L64=;
	b=khEUQ2NochBphTo2F9pTbs4Je8GDaeSCDjPBsSntaAojDCi7vR04uMCTAbymqHNxfFs7Z1
	RCmz9dtbpSrvA6MGuA7PIOjHlztdBovSFCQ1ohgbzzXFdZIAMxn1KZAhs6gvQ9e76Dm/HZ
	ZMZbN3SMU87sWEw61Jq7uCCNfFKztIc=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ac677668a9so2660985a91.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497521; x=1793102321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uTHS7FXG3yRMZ0GtPZv/7Y6mv5vhk3N/ykMwP6C0L64=;
        b=BFRGyZjXQPg16NyHI68IcSM4vuThkRYYQGUza/yz8gnd48CuZmk4QQeoUz9A8yWmCY
         zNmseFcgGQF69qj9KzNKq0CILSg1WKfFt2a8aaMhbv/DevDZlymZC+EFa9EBnp9r9N6t
         Iq7U4jYedCwUPnkx9yyoA5TK8MImfsZa0LC0zVmnJMLCiVCxCssbur1c0Nw4OqCz5ab7
         3XEKoot1T6Szp5p1A8qwTjxd1LipAjnJ1GHsPqoJ0X39JS4DiAXd3cucesrBHpkw8qKN
         i1URfvqoU2KORaB4qH+DXMLxaBUbuor8h9FQzYnzFEIaxD46I0QHS00qhOJq8iwqtkHK
         o+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497521; x=1793102321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uTHS7FXG3yRMZ0GtPZv/7Y6mv5vhk3N/ykMwP6C0L64=;
        b=fP8GX6zMKRdyAatFSj7QI/ma3+fhVeoaktGrQxP1X4+se4MM9mKZtp1nRLF14lAQ38
         jhx76zDXADsM4fZL7P41ZlvGOKrw+96owUxLdDcP0T/86XVnAkY40Wtx/xE2EMVOg2Si
         EB8hbUXoA4aak/tE4aAl60IBeCsS9Dd4IKqpEfbKRM4RE5FL7YT5yMxNjgKXIjltGNze
         ZNH/52cfc4LkOAnjs3AgvTgTVg0NaWkG/hmZIBdtEQDuJ61CBOsnltt3iIxmSPnHa1U4
         ocL5P1G8vkZ8MEDdoE72H3Cg5fjzHjFbouKfD5NY6QOAN06gprH3QFoh3S7WGkyzB0W5
         bznA==
X-Forwarded-Encrypted: i=1; AKwUvBw++rmf/Xz+GGwMPrwDAf55kiSWMXbPfnnWYuAFj6WI094OSaoMNVPXl+oAbzwjYlTyTq/pU6cU3g==@kvack.org
X-Gm-Message-State: AFq9FYJl28NN4b9Ozdn8SXMM538W3QV9bOWZTDH93M+l8i070H/R8C7c
	Uy4Q3S9nuDLkXQUUypHvjJfvIgGX3eTMHWF5cCnK5vymuzd6JYteu7cJTbOlLH/alEA=
X-Gm-Gg: AYBFou0kUipY/qx6kYhJY/76rhT8CxAW0zEJMUlkx2iAKS8qt/kpnYrv+pRe+r7TNVS
	GH82k2kM4O3/p1DaQ0wK5E1KEOHjis9JaYn8QtCIMRs24h2n9gxmkxOUJEd8oJw3szuW6LO3qSN
	hWqHK+0jWmS2Mvu7O+2btnh0u6tnHa6iWo2gImgo1bij+BSZ5PSyxR7XAae1WCxoys0pSrtpxJR
	AbU+gS+S/AlNN/wcr5BBr3zJZWsBTrKuLzZqqe0/XORy0AiE/24fUXmwOd/bE5lUXGo8LgNBmTk
	tm12/fu2hT0U4HwSmXWcbHZtF7/AuR67zd+ipaTtwGw5n3zLHyUUfJ50Zt9GKR3QVSHqoZ/Nt0x
	8tY2IFbvF8GzYOZi+BwmXHh2QvNfKK9tYJLHP13d1yAOfW/g50mhIAJ+lpT/uRwxs+A81Od8m9a
	gbQbTIRfz5tH9aq/5FAhqHS4Sa6jZ5xxja8dgxGknXrr4/OQKB8kKODACT4X+O5fX2m15jNCyRj
	E59Z0HfxPZ6+mgahPcGP0IgfkeQ8mcWDV+9mUmjYV1ADV2/mNWFNFcJLZ8fnxtohQP4sLNokd3+
	cA==
X-Received: by 2002:a17:90b:590c:b0:3ac:a5ff:2cc3 with SMTP id 98e67ed59e1d1-3acee97a193mr10603271a91.8.1792497518926;
        Tue, 20 Oct 2026 04:58:38 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:58:38 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 04/12] mm: hugetlb_vmemmap: generalize vmemmap page allocation
Date: Tue, 20 Oct 2026 19:58:16 +0800
Message-ID: <20261020115824.823278-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: awqgwrq586zkoz3d3a4wsdcw9gh6qoey
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 594161C0007
X-Rspam-User: 
X-HE-Tag: 1792497522-529416
X-HE-Meta: U2FsdGVkX19W9wFrXZg4ZJ4d3VYqFLd+Fc1Vm1w3Wg7yT+pqYsFvvRcyeALoCz6xUZPxDvl92LVzvh79KkOkAtvvClpVem/rDmqHWNwgEnaRCEnTX1T8SuFDDBYiRieAHKhNNKoF2S2EAbwwLzQGOZfmz9MJ5Ii+k9TJ/k+nS9mjdpwgokFC5TdlkFKU8Z6L8tkrADjqrPIDkOhOYzyO802i0Z4VT0NoaZaDsJSwqJxH1MCHQJrutKUTiJEPh5PZHeBcgOc5Kg1bjXVgdhBd3FNF9QYTt2rSX0U85sQ6Wi4qL2tmsqOlchqJanh/ZAwQCEfaMKDpdhExYN3R5SeUeCzpUp7N3ggyC7qYIa2b6nvUSFm9bQnM0rQ6owmeGqlvj3VEYGhwrJEvUwagU0vpCzQ0eCvFoK8NcwbCcTEidNlZoedCKwzdhsHhN3kwDvDkrfxahIktnRaSeZleD+fme06UgYuXFpe8pE2VKVugzwGVkngzLS7wNxbv3aRxA17OjMzqv3zDA4dzzpFSLpD+JkC8tOSRp1ztQFReZHotdH+hteIq2BWD1FqewMSPjDBQQyXHhcygG9MuLPrRKnratQay9ifNZ+u6m3Okhhn+YxOst8t1OCiVIkkTECCcT1q/1D3tiWE99J4EUx352Q80QX8qqIRfkdZUdk/7gb0PabURjmmCpYui8aGa2zAvPoTprqFJhnGLhBi2cF0vQmTepPuOAMpMOsOO7X0131Bl5GuwH9GewI8tlvaIlnA7XdXGRJrheAiSS/WATXDNgSeDpeYRlh+NHWnJuE671T3gkEtmuKTT2TxgVHBY55UUJZw3OTGwaXkmOde03JXVh2Zwy5EEHPIkyhz9c/YPT0JnEIF/Pvc426hTCwol3vCJ9uKc6ofLKQBlmaJWswRfkWKw4H3+DxC9YzhY6+3bNOvD5tpkzSgpITgfXU+vs3JyPAnLPK3P7UkzuMpQ7VRI8N/
 FUTxEqq3
 sOxsd52LBp1GMWGLbmUbrrJjsmWJO2PZix9NEuhVf+/uvD7MHWGFOz79/4Obd3sjQy6W/CFX3HxpdHtBXz1U/IkJzWfD4WXaZByHHpPaERrQU4JxJ3vJ2b+7PuttMAw/SOyUQbLrDNb2ziGAhltl4CKQah4el7pH7rwjwTD2QBOsK1WXGncoaQckXF3eIAXl0hJIGsqCdWqvXymAlrli6/GajQhVtPEG0/sfnjDBECc1hVxJKxERv6w1HebysS+zDjduZANmdOhAP+bJWJcpJ6AvnRURAKZZLYTpDmxsxLIFGQc3ehw6soDTsn9UdWzqT2f3Djg1dNCN/ABGgYtnoHPsVz9P55iNT+pYo/Djv6Pp5GPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Vmemmap page allocation is currently tied to restoring a virtual range
and assumes an empty destination list.  These constraints prevent it from
being reused when pages are requested independently of a vmemmap range or
appended to an existing list.

Generalize the allocator and give it an all-or-nothing list contract so
the restore and optimization paths can share the same allocation policy.
This also allows HVO head-page allocation to fail gracefully under memory
pressure without triggering the OOM killer.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 164e93e980bf..ffb56ffed680 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -333,28 +333,25 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
-				   struct list_head *list)
+static int alloc_vmemmap_page_list(struct list_head *head, unsigned int nr_pages,
+				   int nid)
 {
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
-	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
-	int nid = page_to_nid((struct page *)start);
-	struct page *page, *next;
-	int i;
-
-	for (i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, gfp_mask, 0);
-		if (!page)
-			goto out;
-		list_add(&page->lru, list);
+	LIST_HEAD(local);
+	struct page *page;
+
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
+		if (!page) {
+			memmap_pages_add(i);
+			free_vmemmap_page_list(&local);
+			return -ENOMEM;
+		}
+		list_add(&page->lru, &local);
 	}
+	list_splice(&local, head);
 	memmap_pages_add(nr_pages);
 
 	return 0;
-out:
-	list_for_each_entry_safe(page, next, list, lru)
-		__free_page(page);
-	return -ENOMEM;
 }
 
 /**
@@ -373,13 +370,14 @@ static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 			       unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
+	int nid = page_to_nid((struct page *)start);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
-	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
+	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
 	return vmemmap_remap_range(start, end, &walk);
@@ -526,15 +524,13 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
-	if (!vmemmap_head) {
+	if (alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES, nid)) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	vmemmap_head = list_first_entry(vmemmap_pages, struct page, lru);
 	copy_page(page_to_virt(vmemmap_head), folio);
-	list_add(&vmemmap_head->lru, vmemmap_pages);
-	memmap_pages_add(1);
 
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-- 
2.54.0


