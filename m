Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29FF1CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3086B00D0; Mon, 11 May 2026 05:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CAA16B00D2; Mon, 11 May 2026 05:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492D76B00D3; Mon, 11 May 2026 05:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 380B76B00D0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:01:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0477A1C0E0C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:01:55 +0000 (UTC)
X-FDA: 84754546632.29.A5B2823
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id A3DCEC0014
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:01:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GorO3DW4;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsz4Yb9WaP0J2d/ovLyM+GlU9a8IJXiQXaVWXPUNWME=;
	b=Ko7Zne7wqFdIhBiprvFauglRNdes8S70UAaI/aeyo38RJwfgjLs8ZppR+9lENk/TpEcPHo
	+y2pjYQzCZin5BD48D93Hb5u57fH9CUmKyQ7vvFe3a62luxe7rbi3wkgrklNA1fx8nLRqJ
	bwKTzvuT5FHY3T3kW59+5lyZ4SLVTqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490113; a=rsa-sha256;
	cv=none;
	b=O/sCu2t8j1/FcpnAa6FFF7OXgh9eN/n26xL+vnaNeRi3Pjv0GYcR49Sb9WlGda1wiawZK0
	j2f+pWp0jlWtGtcsZnRzT1GJQa2NTJ2qp1QIXiQ2MP8JsAjX2PTjjxRxcXO1yEYKKxugIE
	4l865EMrXIp5uWR7ddaojprTBd7aQEw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GorO3DW4;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hsz4Yb9WaP0J2d/ovLyM+GlU9a8IJXiQXaVWXPUNWME=;
	b=GorO3DW4x8slXHIc3ikYYA4jhiRgu9O7r4G7GldAZVw7Zj/PTLOgSDr/Guu4XTuzVDBmnw
	uAlgAO0MUNExZi5Q2mlZhn1hlusBHvlsVRhPYQQs8EMHwk/NY2LFr0GT6RUS3UBJ0ClUPZ
	mvriB5i9MiXypnkw1pJN4x0eVoejNfg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-SLCA8TizN_-f39WUKU2BIw-1; Mon, 11 May 2026 05:01:51 -0400
X-MC-Unique: SLCA8TizN_-f39WUKU2BIw-1
X-Mimecast-MFC-AGG-ID: SLCA8TizN_-f39WUKU2BIw_1778490111
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso2609735f8f.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:01:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490110; x=1779094910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsz4Yb9WaP0J2d/ovLyM+GlU9a8IJXiQXaVWXPUNWME=;
        b=QfECv+Rf01lc/v/balzdHY93PzX+yhyYxA+ljppEZn5nP5QC/cRqubxsedSmNqps+T
         uA8doNIYQ5tOawzgeXSJdVeNsGxLovVydw30aCZk0BmE+kTq3TOMsZ1BWl1yufQtzphQ
         URzdexxDi1AG+kdJl+UczclJyFJ5gPgFhJ30qpDb+IY5ET+TtogW8AIuBft1QJy6BbHG
         6ZyhHcMEZPakhUOWT1cXXhEV2d6VH3OsWeGLwtz9qBTxZB3jx+mBCY9y07rwTVBsg2Mo
         WilwvJ++A7DE1q47DCzWIShkoj6z6ocmocyCb6K6vF2I2lDAmO6cGlUpyk0vkUDggWoI
         c8Pg==
X-Forwarded-Encrypted: i=1; AFNElJ87NLsycehGy8TzerQe1CsTEFYTcKmQkRYoFGDyqwTa4I/zEY1GA+mRioyXKR3jPCal1RMsEPhpug==@kvack.org
X-Gm-Message-State: AOJu0Yy6wq9zcwh6RU0ig4DjGQAql6yxN9OrjQGbvVu+5NsefxmmVBxm
	L8SxcRx32CrmqlIRNeVlqJnVB5m73WsaJwNyiic2dwH6ZZFjGcUzGb2O+fqdaNm3gsJ1eglUTU0
	XHINr2siOgB710+i8piVlAzY9hjt0FcAL3SxNmXeW1LKqJ9mdJene
X-Gm-Gg: Acq92OHHc5wjvObmUTnNOepTh6EvmvXi/y0bt2+ki8ufj1f9C3+CDRLnUn9nXB8EzCa
	OYrOX5l++2yqXqFvhjIKgzYrM5qmjhIz4i9sSIouSDI1GIqBvani1+8RSpazKV8RgwYL7n6Ihir
	+h9FYN77UYCWqZwXd5LK5ZobRdd4r+xbXM90gXqEbSH9HJ99PpsMk9TF5BCTfs86YHnE9fjpvDB
	M8ujJ4+5W6EMkDEIJXPfMsGgvAO3uiHnY0esmm9QWDH6dDKE9C6p2+EHU0lrotMQmuwTfEzLHAJ
	1nV9Nrxq+2M70ENqXhSRa+evAL/AxYGGnpWDDpFm77u3UWjrkWCUxKMPI+CbNsgnBLP+3ax0U+1
	kUXpydjfKcp1swFUrZ/+e8GTyQddwUijBGeuIvWpZZY0HYsPGDbM=
X-Received: by 2002:a05:600c:46d2:b0:485:364e:9328 with SMTP id 5b1f17b1804b1-48e51f32aebmr335187035e9.16.1778490110164;
        Mon, 11 May 2026 02:01:50 -0700 (PDT)
X-Received: by 2002:a05:600c:46d2:b0:485:364e:9328 with SMTP id 5b1f17b1804b1-48e51f32aebmr335186515e9.16.1778490109502;
        Mon, 11 May 2026 02:01:49 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e80ca2666sm91504845e9.10.2026.05.11.02.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:01:49 -0700 (PDT)
Date: Mon, 11 May 2026 05:01:44 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH resend v6 01/30] mm: move vma_alloc_folio_noprof to
 page_alloc.c
Message-ID: <a26c5850219e349f8a666282aa8003a82a4819b8.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZjuGQif3L6MyddmFNyjGubT5OH5qUwD8tZYZ24F5F64_1778490111
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A3DCEC0014
X-Stat-Signature: see3yjs5isb4jm3jaqdch1qxe7fn7sn3
X-Rspam-User: 
X-HE-Tag: 1778490113-184132
X-HE-Meta: U2FsdGVkX1/IPEgIYHxtWjpRXtH0Qm5UA8h8jfALWc1JswCkBi+Of7sAFZAv2bSa2t0kyzrJjrv4YaHY+VsA9JFPm2bj8KYamcPH2eDZczAP85cEutHxL+WSJKlfk5dLcF8P2doxnZ2YMrImW0wGbBEWLvB70Z1bL/MmtGEeiP8PANj/38UCVgZ7bS2TzaU6m/0NEH3vbGlMQfsT/ieujMAlaQTEnCqQXs+evj82BB/onk0lwkPMhHf61xt0vcwYgDJ05L7zEWDduUKVL/RzeEK7r4S1NSHaOndzQPtiJacpwuURrcOBXdU6jSvSv3YFiNbDWZ1wCYLpCNmggtt9Tu8oYuVjRb1h1maP7E4w3T3kAzRu/6pj/3WeXwkKmEWZXOT8+IQMq1roIh80cUS0rOHWHZJTyXX8yC0VCV6OixXzoVMdF4pXpVWeK1QBXgroXNzKOWBbfBt9+fEW8306uNCen1hYa+hrBuBqUYnbmSg6sFC/LtHjgJ2Cfq3Q5maWWBuOUVm6cqUtggd8iQatBL3/v80rEtVJwoSeSasDvCVF1f4kpxbnsWjSxuyztWWDzEPtpcFG+ngqDs3pSGtaAN1B9lvJs3Y1v7eLumGlFRRVS6fvuiNsS4rhSbd/AXcydvSm+E2j/ndlS2xSx8GQvawbbuXP6Goj5GSRJTdOWlagb2RQXMwZCTcyLBYJz/f+CA3V+orGEO1Wzy2aB5z9kdRtVGPmvXmMQRSSOmDC1zpTpU9uEew2xyGwgEArgL8zeT7KTTH9HVYd//uTC69lg0pX3u4ZI1i1w6iPvGbfJP3d21CTGorDtRwTNjzFfA4fAmz/ENf9xXRZyvA4uTXa2WM7SvDE7J6JOiNNbHzOtCBBSyoGgmRjv6DkssGQ413Y1bWMovhrZ3l6DoYpccVXeKyx6BEOap0iHtvctLpFqR8bd3njx3RiB1whVn6jrlxwMCoJiETb9u+BDgpYd8s
 t7UGGGMH
 O9/lUb176WNnUZI0FACmE4kEavb1wQSvtpWOkO/oGTs3lJ81htK+mMiiXp5bB/WbfyyhKKIZ7qnivBstL7z7ZbI9fzXApCN9TLJfJNv0D6pU3CX1PwQ66dkxA99x8c3FMUXPKOQF48qbPix+TgTwX+PunuwT6/jZbGe7oJd0t71sULPij8mx64flhqkUJs/MjxG5L/DG0F9mhwbk64izhauYBfFCTIVD9TvMTCoUaT9aFnYFZO4arnC0vmlh+STan/s/5Yvrku0khqWcrXc7ILHWSYwR1Nn7MUynl8tNqyq33bLVqdSKZ5TuUZ34O16RjwL4wZc2ouP5852rw91XV5rmGDn96vIVHcAE5NZxlbsDqWcfv6YzTWTroBAAu0Zql7UvmXerR3S56POKzRsUDrPVAckOuUyckCytYvW7ox0r7xHQdmmJqBCymqpTbDH6EGeZf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move vma_alloc_folio_noprof() from an inline in gfp.h (for !NUMA)
and mempolicy.c (for NUMA) to page_alloc.c.

This prepares for a subsequent patch that will thread user_addr
through the allocator: having vma_alloc_folio_noprof in page_alloc.c
means user_addr can be passed to the internal allocation path
without changing public API signatures or duplicating plumbing
in both gfp.h and mempolicy.c.

The !NUMA path gains the VM_DROPPABLE -> __GFP_NOWARN check
that the NUMA path already had.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/gfp.h |  9 ++-------
 mm/mempolicy.c      | 32 --------------------------------
 mm/page_alloc.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 51ef13ed756e..7ccbda35b9ad 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -318,13 +318,13 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
 
 #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))
 
+struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr);
 #ifdef CONFIG_NUMA
 struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid);
-struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr);
 #else
 static inline struct page *alloc_pages_noprof(gfp_t gfp_mask, unsigned int order)
 {
@@ -339,11 +339,6 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
 {
 	return folio_alloc_noprof(gfp, order);
 }
-static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
-		struct vm_area_struct *vma, unsigned long addr)
-{
-	return folio_alloc_noprof(gfp, order);
-}
 #endif
 
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59..6832cc68120f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2515,38 +2515,6 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 	return page_rmappable_folio(page);
 }
 
-/**
- * vma_alloc_folio - Allocate a folio for a VMA.
- * @gfp: GFP flags.
- * @order: Order of the folio.
- * @vma: Pointer to VMA.
- * @addr: Virtual address of the allocation.  Must be inside @vma.
- *
- * Allocate a folio for a specific address in @vma, using the appropriate
- * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
- * VMA to prevent it from going away.  Should be used for all allocations
- * for folios that will be mapped into user space, excepting hugetlbfs, and
- * excepting where direct use of folio_alloc_mpol() is more appropriate.
- *
- * Return: The folio on success or NULL if allocation fails.
- */
-struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr)
-{
-	struct mempolicy *pol;
-	pgoff_t ilx;
-	struct folio *folio;
-
-	if (vma->vm_flags & VM_DROPPABLE)
-		gfp |= __GFP_NOWARN;
-
-	pol = get_vma_policy(vma, addr, order, &ilx);
-	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
-	mpol_cond_put(pol);
-	return folio;
-}
-EXPORT_SYMBOL(vma_alloc_folio_noprof);
-
 struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
 {
 	struct mempolicy *pol = &default_policy;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 227d58dc3de6..fc7327ebdf6c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5273,6 +5273,49 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 }
 EXPORT_SYMBOL(__folio_alloc_noprof);
 
+#ifdef CONFIG_NUMA
+/**
+ * vma_alloc_folio - Allocate a folio for a VMA.
+ * @gfp: GFP flags.
+ * @order: Order of the folio.
+ * @vma: Pointer to VMA.
+ * @addr: Virtual address of the allocation.  Must be inside @vma.
+ *
+ * Allocate a folio for a specific address in @vma, using the appropriate
+ * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
+ * VMA to prevent it from going away.  Should be used for all allocations
+ * for folios that will be mapped into user space, excepting hugetlbfs, and
+ * excepting where direct use of folio_alloc_mpol() is more appropriate.
+ *
+ * Return: The folio on success or NULL if allocation fails.
+ */
+struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	struct mempolicy *pol;
+	pgoff_t ilx;
+	struct folio *folio;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		gfp |= __GFP_NOWARN;
+
+	pol = get_vma_policy(vma, addr, order, &ilx);
+	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
+	mpol_cond_put(pol);
+	return folio;
+}
+#else
+struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	if (vma->vm_flags & VM_DROPPABLE)
+		gfp |= __GFP_NOWARN;
+
+	return folio_alloc_noprof(gfp, order);
+}
+#endif
+EXPORT_SYMBOL(vma_alloc_folio_noprof);
+
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
  * address cannot represent highmem pages. Use alloc_pages and then kmap if
-- 
MST


