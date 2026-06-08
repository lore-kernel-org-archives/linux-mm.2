Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51053CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F59B6B00A3; Mon,  8 Jun 2026 04:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5E16B00A4; Mon,  8 Jun 2026 04:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846D16B00A5; Mon,  8 Jun 2026 04:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD456B00A3
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:35:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A6E51C1FF6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:36 +0000 (UTC)
X-FDA: 84856086672.27.F3649DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id E20104000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HFyyD+XY;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2/zUcZBQmNnar2to9U33SyX02FPb9ifpYfk2LvDheA=;
	b=n6FmCMpKvH5ZF/z0c12aR700eR/f6QSkHwMFuh2nHwWMYFmRWCNaMNqfDPLe9PGOa+InZ6
	CgF5BopyGTKWjXgtyb7jaVvo9vD3CDBQcKPPyOsol4Ji/Z3EnFhU8iT8Im7PqBHNkPdpGo
	nVRhpDI2HVqneJY/3ioaX0i8uvATgZ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907734;
	b=VkKALq7ActOgSO3HPoD61vUEAz0rSTc+gQ1JHmqas7k8SYt0NeoJMqOdxuoNndnCcz/T21
	A13JcGqiwQ2GAYoPeg3WznKPBDG15k52k9ZZzf1fQR/dFP9R4GHw3tKVe4OwwTN9eg4DNN
	j1n4xdpLswVtJnoRXqFGlGPVrs6PEQ0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HFyyD+XY;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2/zUcZBQmNnar2to9U33SyX02FPb9ifpYfk2LvDheA=;
	b=HFyyD+XYGHwCuI1JQVjYTEVZ6UQ9OcnYJyuh4t/dDMah+B60FhLaxuajr/xA0VyISxXgCF
	FcqwMbsg4HCk+W00qi8H17UyNYdqiZrBGIyRq5xErP341g2BW8wQbCdxz1yhx3ARXU1Ffs
	085s/M4fifbHqGRPg5umN8PaUOo4epQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-dsVc7nQkMPiTy5yvxZrmjQ-1; Mon, 08 Jun 2026 04:35:31 -0400
X-MC-Unique: dsVc7nQkMPiTy5yvxZrmjQ-1
X-Mimecast-MFC-AGG-ID: dsVc7nQkMPiTy5yvxZrmjQ_1780907730
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-46016bedbaaso1385516f8f.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907730; x=1781512530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w2/zUcZBQmNnar2to9U33SyX02FPb9ifpYfk2LvDheA=;
        b=UiQWIzgIf1kFcfd52u4pug3zUACAC1xk+PLeCBt1r/tuqhXyM5owx/TpNqHzLI408n
         0x3Sp9HX7/ighYx2TWn4qbI/rPfxhFbi24DOyV+K/WWIaIGpJtFwCwryuGIE7riA6kqg
         V5tjvD/sUrWSmg4CfysZ/ZbrXEYf4Vj+TjbZ+CfLZ+uvxxJowb0/P14ltG1QgJOjlSUB
         iJHYs94v9WPq/e41F+sntKaXT9s5/nKFozACIxslrt9fMS8EOU2uWCC08uPAsizpBnNp
         kQOAahgSepw/ff3RSoyS8Hm3GJgdN4xvDGxZy8kQ+zUvZUl8VYdiXEBpcA1rjs/3QI0U
         bgWw==
X-Forwarded-Encrypted: i=1; AFNElJ/G/ChSlFf6ATLKaw2N7+GYEHjPAnkD9wxDnvdYlMGaVtccIErf1pR+13ZWu+pt8VpjcxKHcQKnRQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7jV4L7xBj5Nr2QGYKAMIsl3pvAKf0ayrIyivGq5oZMVomG/pJ
	v6cAX8jkckqZZ7ihoDWc3dlE3eY6TMI+LCcZqqmTmOivWe4/7Bzf6keF4UEkd5jpQK+12WojXXT
	690aLwRsJ9TJESe2LOrTuxgbGv+Lbj+7PlniNkhfpND3NXQtBlVPv
X-Gm-Gg: Acq92OGmCK72lg06UHiRie+RaNA1Y/K3k9ahQtCpf7F4vqLJe7GkmFNTCfG6dOCdkF8
	HrJOyVndU8YmmqKw7hPFPuQWJqeowayq4Rxro1qXi3OADvSnIo9M+l7kkrYG1h6Z9/gz9+9v+H3
	7jqeyEcFQ7qNURru9IC3o9YtQkRALH36cz/bkYiF9s8uPzkCBzn0mFwvPh+iFdZPXxyeTUGubsw
	CqcNKH60lA9SE69Lk1JuQTAbbpVJU/eWRo30EddKcVTvSydUrJDaX9F7DtlUZsVtJm57cSpz8KY
	qTbIzDh5Z6lmcAZ/4bdw264hDWZhGaSHj4TKjspJWfPcoWg7oZYC2yhRFk9f+rQLfvB2b3ZB9rt
	nl9tipbQRr5pq8mAIhnfEBOY=
X-Received: by 2002:a05:600c:5248:b0:48f:d612:3c4a with SMTP id 5b1f17b1804b1-490c25604demr238925765e9.1.1780907729451;
        Mon, 08 Jun 2026 01:35:29 -0700 (PDT)
X-Received: by 2002:a05:600c:5248:b0:48f:d612:3c4a with SMTP id 5b1f17b1804b1-490c25604demr238925325e9.1.1780907728919;
        Mon, 08 Jun 2026 01:35:28 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f351d69sm91125727f8f.29.2026.06.08.01.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:35:28 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:35:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 07/37] mm: thread user_addr through page allocator for
 cache-friendly zeroing
Message-ID: <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kyP2YzFaC4NsOwmB06QEvsyBrVJ6LHz3zZe0E8GYYEA_1780907730
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E20104000A
X-Stat-Signature: pg1fwx9wm3y5t98qfj987sbcexjze9u3
X-HE-Tag: 1780907733-15705
X-HE-Meta: U2FsdGVkX1+b8rsr9VdpS31ToBVX+zzVy24fz1IgR8KE+jb8hxgTt9ZXcYJnn9ESoTmIYblUbpEqXY77VRdgPJFq891X+9rowyck95ivmvXGvJLmKcsJU/LOHyRqfFeFqFA3eaIhvNSBd1SoY10J6Ty3/TDzLH0IaOooUpUIZNFe2Y+/Z28Lsj35Y/KfeHmIi4rGcwpDq5FDAbfEPYgdAwqA5yf9QISJKMtnskLqHZu5A3y+nTErfxjX5hFX3QoivELPet4RUA+PlRxIK7x3dDH8Jwaeb6d3/vNyRxr1VQMm9gjFUVx0fvAdoqjSDlZjhBDsYuIxb/keLnQsX4qbgoYh1H6u90CYamx5rNb5cGGQXkMuO3Ji0cGZgGqQ9qMTfQik74SPtuJkJA+H7wiv6r6rZLoOC6udhCg3FwaxPQ86jB3E43qI13Od1tGIy1Aemc1pMRvwjEckp18pThgadF80mGKM58BYy8/S0o8FnLAsDegtfaNmTcnncFc2ONJlgeCKMmPKfX574TKRKRVwok1bnJkJZSI12iXZuiLOnEIVgWGWXVhL1oUQKwxCeiiFq2JS8HruwExkxad8KGI5q67kfBu6OS4O/YVsI3fRs4Aiu0PEVxNgYsMK6YVEwhNOPLpZqa9z5drEfE76VSjMxmuK0Uio7CVayxMOmMBfIxVgw1dDXtsQCqh5E6rY/tRebCdyZymHUcKe2FWavRGk/3HGk1e0RHfZUhGg4g75a13KjcTseWjiBCAG9y+kYn6SmsuK65KpLW6bUC+c2UsJP1i9F1MVmLOAPsqQsqFIlsbYxwgqFGzg9CYvsFN304y/RQPjU/YPgkES7KmYlQJgyJq9KBNzMF+NFhgY4C2iK9FP9T1LvygUqkxpaKylkodPOtF5Pjy++TdZIRATZD2x+kemDLTtVAiBu/f4cO/xoXiD9tBx51uKlhAmbs5QUlxc7qo6asH1ix51s9Lq5ZT
 nsnxC+nz
 ERPg6IHZc0WbhtyBF3V8k+HS/Soso7dqf8capxkwIJyUmcNWGXl4rf7Dsl4/O2uUyw+sJ7BGmm+6AHdiBS2/rMI/L/nKj5nMtcPgAD2/mzV2PapGy6lD+gY5TRvtgeRVn6ai0uCXvwIlyzCwVe903X7BemrIsmDfwWb+GhtjIBJbhrdZSl1s+PB+VU+DQ+gUNDdrtWuGjh1Wa4dUNN3Y1RTt8UQZhlCMFEZsX/x2PSozDuUyOlpnlM+vqkwWhZoldW/tbpDR1IE6qFWtQkus+6AUyippLCSV2BgY8GG7FAGmFLOYpu2BHez8VgCsjUcAwBxrfitanzGk5ql45Kx+VMvJ7BqvTlY+OBCgb79Be4FuibNSlmfhf3Ptcxt0RxnyE4181Bf/1hByC2jxO4rop9pWLqTyvORlnd22bBTdqr8P4wn37MvkFKPtIi4p9j2o4dtqn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thread a user virtual address from vma_alloc_folio() down through
the page allocator to post_alloc_hook(). This is plumbing
preparation for a subsequent patch that will use user_addr to
call folio_zero_user() for cache-friendly zeroing of user pages.

The user_addr is stored in struct alloc_context and flows through:
  vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
  __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
  post_alloc_hook

USER_ADDR_NONE ((unsigned long)-1) is used for non-user
allocations, since address 0 is a valid userspace mapping.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/gfp.h |  2 +-
 mm/compaction.c     |  5 ++---
 mm/hugetlb.c        | 36 ++++++++++++++++++++----------------
 mm/internal.h       | 21 ++++++++++++++++++---
 mm/mempolicy.c      | 44 ++++++++++++++++++++++++++++++++------------
 mm/mmap.c           |  6 ++++++
 mm/page_alloc.c     | 44 +++++++++++++++++++++++++++++---------------
 mm/slub.c           |  4 ++--
 8 files changed, 110 insertions(+), 52 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 7ccbda35b9ad..ee35c5367abc 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -337,7 +337,7 @@ static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
 static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid)
 {
-	return folio_alloc_noprof(gfp, order);
+	return __folio_alloc_noprof(gfp, order, numa_node_id(), NULL);
 }
 #endif
 
diff --git a/mm/compaction.c b/mm/compaction.c
index 3648ce22c807..72684fe81e83 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -82,7 +82,7 @@ static inline bool is_via_compact_memory(int order) { return false; }
 
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
-	post_alloc_hook(page, order, __GFP_MOVABLE);
+	post_alloc_hook(page, order, __GFP_MOVABLE, USER_ADDR_NONE);
 	set_page_refcounted(page);
 	return page;
 }
@@ -1849,8 +1849,7 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
-
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
 	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4b80b167cc9c..f3bc15a7889a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1786,7 +1786,8 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 }
 
 static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
+		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry,
+		unsigned long addr)
 {
 	struct folio *folio;
 	bool alloc_try_hard = true;
@@ -1803,7 +1804,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask, addr);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
@@ -1832,7 +1833,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 
 static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+		nodemask_t *node_alloc_noretry, unsigned long addr)
 {
 	struct folio *folio;
 	int order = huge_page_order(h);
@@ -1844,7 +1845,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
 	else
 		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
-						 node_alloc_noretry);
+						 node_alloc_noretry, addr);
 	if (folio)
 		init_new_hugetlb_folio(folio);
 	return folio;
@@ -1858,11 +1859,12 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
  * pages is zero, and the accounting must be done in the caller.
  */
 static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask)
+		gfp_t gfp_mask, int nid, nodemask_t *nmask,
+		unsigned long addr)
 {
 	struct folio *folio;
 
-	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL, addr);
 	if (folio)
 		hugetlb_vmemmap_optimize_folio(h, folio);
 	return folio;
@@ -1902,7 +1904,7 @@ static struct folio *alloc_pool_huge_folio(struct hstate *h,
 		struct folio *folio;
 
 		folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, node,
-					nodes_allowed, node_alloc_noretry);
+					nodes_allowed, node_alloc_noretry, USER_ADDR_NONE);
 		if (folio)
 			return folio;
 	}
@@ -2071,7 +2073,8 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn, unsigned long end_pfn)
  * Allocates a fresh surplus page from the page allocator.
  */
 static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
-				gfp_t gfp_mask,	int nid, nodemask_t *nmask)
+				gfp_t gfp_mask,	int nid, nodemask_t *nmask,
+				unsigned long addr)
 {
 	struct folio *folio = NULL;
 
@@ -2083,7 +2086,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, addr);
 	if (!folio)
 		return NULL;
 
@@ -2126,7 +2129,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, USER_ADDR_NONE);
 	if (!folio)
 		return NULL;
 
@@ -2162,14 +2165,14 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 	if (mpol_is_preferred_many(mpol)) {
 		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
-		folio = alloc_surplus_hugetlb_folio(h, gfp, nid, nodemask);
+		folio = alloc_surplus_hugetlb_folio(h, gfp, nid, nodemask, addr);
 
 		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
 
 	if (!folio)
-		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask);
+		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask, addr);
 	mpol_cond_put(mpol);
 	return folio;
 }
@@ -2276,7 +2279,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * down the road to pick the current node if that is the case.
 		 */
 		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
-						    NUMA_NO_NODE, &alloc_nodemask);
+						    NUMA_NO_NODE, &alloc_nodemask,
+						    USER_ADDR_NONE);
 		if (!folio) {
 			alloc_ok = false;
 			break;
@@ -2682,7 +2686,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 			spin_unlock_irq(&hugetlb_lock);
 			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask,
-							      nid, NULL);
+							      nid, NULL, USER_ADDR_NONE);
 			if (!new_folio)
 				return -ENOMEM;
 			goto retry;
@@ -3380,13 +3384,13 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-					&node_states[N_MEMORY], NULL);
+					&node_states[N_MEMORY], NULL, USER_ADDR_NONE);
 			if (!folio && !list_empty(&folio_list) &&
 			    hugetlb_vmemmap_optimizable_size(h)) {
 				prep_and_add_allocated_folios(h, &folio_list);
 				INIT_LIST_HEAD(&folio_list);
 				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-						&node_states[N_MEMORY], NULL);
+						&node_states[N_MEMORY], NULL, USER_ADDR_NONE);
 			}
 			if (!folio)
 				break;
diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..9d2198114510 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -662,6 +662,16 @@ void calculate_min_free_kbytes(void);
 int __meminit init_per_zone_wmark_min(void);
 void page_alloc_sysctl_init(void);
 
+/*
+ * Sentinel for user_addr: indicates a non-user allocation.
+ * Cannot use 0 because address 0 is a valid userspace mapping.
+ * (unsigned long)-1 is safe because:
+ * 1. vm_end = addr + len <= TASK_SIZE, and vm_end is exclusive,
+ *    so -1 is never inside any VMA.
+ * 2. It will only be compared to page-aligned addresses.
+ */
+#define USER_ADDR_NONE	((unsigned long)-1)
+
 /*
  * Structure for holding the mostly immutable allocation parameters passed
  * between functions involved in allocations, including the alloc_pages*
@@ -693,6 +703,7 @@ struct alloc_context {
 	 */
 	enum zone_type highest_zoneidx;
 	bool spread_dirty_pages;
+	unsigned long user_addr;
 };
 
 /*
@@ -916,13 +927,14 @@ static inline void init_compound_tail(struct page *tail,
 	prep_compound_tail(tail, head, order);
 }
 
-void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
+void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
+		     unsigned long user_addr);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
 
 struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
-		nodemask_t *);
+		nodemask_t *, unsigned long user_addr);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
@@ -930,10 +942,13 @@ void free_unref_folios(struct folio_batch *fbatch);
 
 #ifdef CONFIG_NUMA
 struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
+struct folio *folio_alloc_mpol_user_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid,
+		unsigned long user_addr);
 #else
 static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
 {
-	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL);
+	return __alloc_frozen_pages_noprof(gfp, order, numa_node_id(), NULL, USER_ADDR_NONE);
 }
 #endif
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index a1707ad498a8..f573ff32e94d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2413,7 +2413,8 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
 }
 
 static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
-						int nid, nodemask_t *nodemask)
+						int nid, nodemask_t *nodemask,
+						unsigned long user_addr)
 {
 	struct page *page;
 	gfp_t preferred_gfp;
@@ -2426,25 +2427,29 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	 */
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
-	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid,
+					   nodemask, user_addr);
 	if (!page)
-		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL);
+		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL,
+						   user_addr);
 
 	return page;
 }
 
 /**
- * alloc_pages_mpol - Allocate pages according to NUMA mempolicy.
+ * __alloc_pages_mpol - Allocate pages according to NUMA mempolicy.
  * @gfp: GFP flags.
  * @order: Order of the page allocation.
  * @pol: Pointer to the NUMA mempolicy.
  * @ilx: Index for interleave mempolicy (also distinguishes alloc_pages()).
  * @nid: Preferred node (usually numa_node_id() but @mpol may override it).
+ * @user_addr: User fault address for cache-friendly zeroing, or USER_ADDR_NONE.
  *
  * Return: The page on success or NULL if allocation fails.
  */
-static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
-		struct mempolicy *pol, pgoff_t ilx, int nid)
+static struct page *__alloc_pages_mpol(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid,
+		unsigned long user_addr)
 {
 	nodemask_t *nodemask;
 	struct page *page;
@@ -2452,7 +2457,8 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
 	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		return alloc_pages_preferred_many(gfp, order, nid, nodemask,
+						 user_addr);
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2476,7 +2482,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL);
+				nid, NULL, user_addr);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2488,7 +2494,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, user_addr);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
@@ -2504,11 +2510,18 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 	return page;
 }
 
-struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		struct mempolicy *pol, pgoff_t ilx, int nid)
 {
-	struct page *page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
-			ilx, nid);
+	return __alloc_pages_mpol(gfp, order, pol, ilx, nid, USER_ADDR_NONE);
+}
+
+struct folio *folio_alloc_mpol_user_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid,
+		unsigned long user_addr)
+{
+	struct page *page = __alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
+			ilx, nid, user_addr);
 	if (!page)
 		return NULL;
 
@@ -2516,6 +2529,13 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 	return page_rmappable_folio(page);
 }
 
+struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid)
+{
+	return folio_alloc_mpol_user_noprof(gfp, order, pol, ilx, nid,
+					    USER_ADDR_NONE);
+}
+
 struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
 {
 	struct mempolicy *pol = &default_policy;
diff --git a/mm/mmap.c b/mm/mmap.c
index 5754d1c36462..73413cebc418 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -855,6 +855,12 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 	if (IS_ERR_VALUE(addr))
 		return addr;
 
+	/*
+	 * The check below ensures vm_end = addr + len <= TASK_SIZE.
+	 * Since (unsigned long)-1 (USER_ADDR_NONE) >= TASK_SIZE and
+	 * vm_end is exclusive, USER_ADDR_NONE is thus never a valid
+	 * userspace address.
+	 */
 	if (addr > TASK_SIZE - len)
 		return -ENOMEM;
 	if (offset_in_page(addr))
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6a605d05e8cd..21b52c879751 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1815,7 +1815,7 @@ static inline bool should_skip_init(gfp_t flags)
 }
 
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags)
+				gfp_t gfp_flags, unsigned long user_addr)
 {
 	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
@@ -1870,9 +1870,10 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-							unsigned int alloc_flags)
+							unsigned int alloc_flags,
+							unsigned long user_addr)
 {
-	post_alloc_hook(page, order, gfp_flags);
+	post_alloc_hook(page, order, gfp_flags, user_addr);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
@@ -3956,7 +3957,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
-			prep_new_page(page, order, gfp_mask, alloc_flags);
+			prep_new_page(page, order, gfp_mask, alloc_flags,
+				      ac->user_addr);
 
 			return page;
 		} else {
@@ -4184,7 +4186,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	/* Prep a captured page if available */
 	if (page)
-		prep_new_page(page, order, gfp_mask, alloc_flags);
+		prep_new_page(page, order, gfp_mask, alloc_flags,
+			      ac->user_addr);
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -5061,7 +5064,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
-	struct alloc_context ac;
+	struct alloc_context ac = { .user_addr = USER_ADDR_NONE };
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
@@ -5176,7 +5179,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0);
+		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -5201,12 +5204,13 @@ EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
-		int preferred_nid, nodemask_t *nodemask)
+		int preferred_nid, nodemask_t *nodemask,
+		unsigned long user_addr)
 {
 	struct page *page;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
-	struct alloc_context ac = { };
+	struct alloc_context ac = { .user_addr = user_addr };
 
 	/*
 	 * There are several places where we assume that the order value is sane
@@ -5267,10 +5271,12 @@ EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
 
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask)
+
 {
 	struct page *page;
 
-	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid,
+					   nodemask, USER_ADDR_NONE);
 	if (page)
 		set_page_refcounted(page);
 	return page;
@@ -5313,7 +5319,8 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 		gfp |= __GFP_NOWARN;
 
 	pol = get_vma_policy(vma, addr, order, &ilx);
-	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
+	folio = folio_alloc_mpol_user_noprof(gfp, order, pol, ilx,
+					     numa_node_id(), addr);
 	mpol_cond_put(pol);
 	return folio;
 }
@@ -5321,10 +5328,17 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 		struct vm_area_struct *vma, unsigned long addr)
 {
+	struct page *page;
+
 	if (vma->vm_flags & VM_DROPPABLE)
 		gfp |= __GFP_NOWARN;
 
-	return folio_alloc_noprof(gfp, order);
+	page = __alloc_frozen_pages_noprof(gfp | __GFP_COMP, order,
+					   numa_node_id(), NULL, addr);
+	if (!page)
+		return NULL;
+	set_page_refcounted(page);
+	return page_rmappable_folio(page);
 }
 #endif
 EXPORT_SYMBOL(vma_alloc_folio_noprof);
@@ -6905,7 +6919,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask);
+			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7111,7 +7125,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0);
+		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7776,7 +7790,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
 	unsigned int alloc_flags = ALLOC_TRYLOCK;
-	struct alloc_context ac = { };
+	struct alloc_context ac = { .user_addr = USER_ADDR_NONE };
 	struct page *page;
 
 	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d..f397fa2f3f80 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3275,7 +3275,7 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 	else if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages(flags, order);
 	else
-		page = __alloc_frozen_pages(flags, order, node, NULL);
+		page = __alloc_frozen_pages(flags, order, node, NULL, USER_ADDR_NONE);
 
 	if (!page)
 		return NULL;
@@ -5236,7 +5236,7 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 	if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL, USER_ADDR_NONE);
 
 	if (page) {
 		ptr = page_address(page);
-- 
MST


