Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EC5ACD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97DAB6B00BA; Tue, 12 May 2026 17:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9546F6B00BC; Tue, 12 May 2026 17:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86AB16B00BD; Tue, 12 May 2026 17:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 752256B00BA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 439181C117D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:54 +0000 (UTC)
X-FDA: 84760002348.24.492E0AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id F378F40006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b3tTjBPb;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgzEDqlvhoYP0aAGYME8rWUPvmasj5/ucpL5w8urRD4=;
	b=tgxYRTBIECQ8f2thpKZ0BwGsg8kZe52t5jOHbG8riFjT8EK2+c2FQoRU2Vgk3fgq+7hvZ4
	Ts5Q92coXMsX0eefqxaTk+yRagE+ZN6ZNQC5q1w8G/HsP8cyeMFFix6Pq2JM4QiYpOIIde
	CpxcS1PGhDZu0nHgLMxJ018B/r6a5Co=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b3tTjBPb;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620012; a=rsa-sha256;
	cv=none;
	b=iGedDW5FuOvi1sZZfIXnurfYxQXSlbvj0j6PKf/Vuu1/m4gBYm3a9ie4RKE4yz9Q6IpNXs
	tpJ1P629AatD8KX0+7priOQqBaelz4rqr48tpq5/ZIwlGWhFEO1z/ti8HjYHOAr5j05zG3
	a2lgzSA6XF3NLqCTkCeNZEtImc+VHsc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vgzEDqlvhoYP0aAGYME8rWUPvmasj5/ucpL5w8urRD4=;
	b=b3tTjBPbVDQGNXjfJz7pLiU27TlvDJ03gqrMPTwCQjtvyZgNFk0NkTYgsKaaQ/zZyJ3oke
	sdp4y+bt5Aq/zMWQmk2ZyXmikF6ic50Krdy49zhGhK0c4Btcla+sBhgyDPwz6PfRqLrQPx
	xmH/WDNG9i47spf8eOuBT3VBJRb+j3E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-epUraEIVPVSqtGBI6xRVPg-1; Tue, 12 May 2026 17:06:50 -0400
X-MC-Unique: epUraEIVPVSqtGBI6xRVPg-1
X-Mimecast-MFC-AGG-ID: epUraEIVPVSqtGBI6xRVPg_1778620009
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48906aa28cbso52278475e9.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620009; x=1779224809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vgzEDqlvhoYP0aAGYME8rWUPvmasj5/ucpL5w8urRD4=;
        b=imNS5B1OyWyZcOID3ISIIR/OILCg1ISPwqoG6uy4+91dZKfx4SAgdReK8vG7RSD1xf
         VSyY7+jnKodh8V4L/PsMnN0d1ne+M9/ryVjbUg8sTl61OPLMqvCxkBeDQA5faq5ekU9X
         uD5nQrkHmuQOoEMtwufB+EP2V7KQQaw6XTRZq+IfulunIrnv6iyDbcNFL9SYn5JeiUo/
         Ry8JimDMOfyEBLt7jFRoLhSrnx5JIjaErkwS+TmKrTJqqPJt9xL73UOofpIRh5mbUodU
         C5h/zUQMcCLRuOrAT8DvAMIov6Sl+8CZrmVd21Ki7ugYJvlDFWoJ6qs5dA5mPAuYenYQ
         wgcw==
X-Forwarded-Encrypted: i=1; AFNElJ+Z6Uc7snFQSREO1ssH9XY0COgem15XCJTERbiP2Xtwp3h1rqyfv9ceIwR7qhySj5n4B9RJTtvp6Q==@kvack.org
X-Gm-Message-State: AOJu0Yy8cAqq70sknSuydgw1V3qgzfL0aRpst6ZKYXm28rhprBNTrLK+
	rAWoAr7UKZpoZpgwcAYG7MLY5DvcjlfmcWo4k48bat9FCOemwPsMo6FXxBsnR6mFTvCjs2MMMwv
	rEsji0cM3pGkb8bqcNA4l86UEkh4R4jnU8mzcsuYdVB3Fv43qWvAg
X-Gm-Gg: Acq92OG1r0uhBQH/2yztcMmoPVBfucMQ2/KMhV0RQWL+Wrh1BkgSq5GeXvW0z8MkBJj
	od6GRacuKtlhAsaHHKDqWvFNp2my4azyACKz+JnYMrMNP7cT0pm7rtmBTpRsNICl/1ZFHCYJDou
	DTkDJoctERq2wJkcvS5PVWBvMI/5xhtI/Xzog1seJjxFvIARJ9RagRM0ql/YR7Biiuvf3SInRy+
	IaL346TSDeTXH/FoNhu7U23FTCzZpfNc/xaWlQpGKNwy3IThsidoGM3jErhJ+2DmQ6KqM05ZuRK
	c5Oeq5Sb1JGJUeUwBhvO9yT4Ih1+NEw6A1NFmNgiP1ZqAFPeFNtEDaw5AW7Qd5OffEbyI8h1T1w
	Cnc85vFog61455KvZyj2QgqiqtZsvOkFwRjB4ujAb
X-Received: by 2002:a05:600c:4ed1:b0:488:aa33:dc8f with SMTP id 5b1f17b1804b1-48fc95a5989mr7783425e9.0.1778620008843;
        Tue, 12 May 2026 14:06:48 -0700 (PDT)
X-Received: by 2002:a05:600c:4ed1:b0:488:aa33:dc8f with SMTP id 5b1f17b1804b1-48fc95a5989mr7783135e9.0.1778620008280;
        Tue, 12 May 2026 14:06:48 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce065732sm23005e9.6.2026.05.12.14.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:47 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:43 -0400
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
Subject: [PATCH v7 18/31] mm: memfd: skip zeroing for zeroed hugetlb pool
 pages
Message-ID: <0ec51a9091b5ed3f61a49935953dd537d6c87428.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zfirQD4bnb9aRIo6xWd1iHYoAGgVO6agPVGTWcfZv9g_1778620009
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ow5udd17kcwkodf7xpehb5joo5h6hskt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F378F40006
X-Rspam-User: 
X-HE-Tag: 1778620011-469658
X-HE-Meta: U2FsdGVkX1/1g6QhvEPFu0+dxeaNqaubNOXAwZ63DZHSzJ5w74lyxQOu8P0CJRdZbotTjOOfB6W+jPQ0IJLqOZHTg8ao+2x/SLPrFgi+YQCPLSBnWwLY5/6D788MD0a7nkyyPJoZobNQFy0PB4yILmXNDqsdZ0ZAh94IXF4n5DVqskRBBv9I5GgD2unWZchxXX1X+GT4beT4h6ot0UACBOwGNDnMAu30U3q+rGMFb7chwJWmLNLs31PQChXjjQHEGcgRsxh4jY17EcEHgvRevDR2aertaS/ayCHMfnZQrIptcfHMXk9VDZM0dsabmQSUV/hCx+XUf8cIEZGdX1xhKT/6fecOGxZSTiF8nKg05auqtJecJjKQQh41uMA/rnXR2NRZrjYF/0/4mGYyG7SMFn4nBDX1DkO/MNd63e4M6BGH4L+aypY62ItSyjVTFliQ3IEHkzthy0pMC+XpIds+DWDEG7CEdnnlQ8mwwsHXbS751PedgSv68XKtwtNToE9BqVgWrlcAZLKp0RpALHeP22AuzZWYpXr4lXymKmv4rvPRnx1Qi07ftYKfDxaF7nu+C7Wqe2hFp37kj3OFjI8I+7042zKQzdTQvg0JN4GKq8UAs6W8vA40VL3Q9cqVLGioA1iMv1ACnUmPgX2/MH56qX/7b2PcuJCD4LKVsfBATDyzad2GDEzpI2kdNxZ7HCg4D69rkfLK77Ze+fw0+XUeaXrIrXElWwUPUz3c9a6Z2xCMvmY3uORkfqQWqeR8Jh9IFP+YKNK1dIkaSaaJE7nFadkOBggLcrLfCWDdHh7GvzP4LoSfvU2oQuF69xGaF9DE6TUcUS0NnwCPGVQ7+tKqgT4oUS8PXV2u2WXifHfTlcCFUZZ1qPP21dMDU55pu8vdclmtxQ6DcddzU18Cyl49VHGFxIlG45Mp4690u1pvb1KtWe2Kg6ElaXIz6VpPIs5DXK9pfS1TafP103IL2zu
 cCQFR4Ms
 B05dB9DBzndWd3tzjRqGJE5WsLSf6twMdGLK6rngZO2ChJtNtNDMGSk1PqN0GzO80Q3zVy0JTqwLMgwnQRya7n4zhW3DiTMlfAyQ6avuIN2WoiROxiESZdJztM/lJ2gmb4q5zWeA5rUfp8dQQ5JTJKSo/XD7d8CYcCaLbAwVfe59nIgtw7Da09VcXOR0t47FFdJzCPI7xifYxoHtPDFN+PSMuHEVQwZ8+BJ3tbl1Uz2yp7WpLMq/qnY5yVVc8JDz8iflbrAxq5HHIjV+XKn9Zii9StDmwYaaj+B188XoKvHjhqKVa19vgWyyNstyTtCh2IDzh3jat9VCDDCEhKdQstIQBCujiZ85XMCg/8O/aobOvO38fa9Z/XS4SGCA/aIvmVxhXK5i1xuQR5V0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gather_surplus_pages() pre-allocates hugetlb pages into the pool
during mmap.  Pass __GFP_ZERO so these pages are zeroed by the
buddy allocator, and HPG_zeroed is set by alloc_surplus_hugetlb_folio.

Add bool *zeroed output to alloc_hugetlb_folio_reserve() so
callers can check whether the pool page is known-zero.  memfd's
memfd_alloc_folio() uses this to skip the explicit folio_zero_user()
when the page is already zero.

This avoids redundant zeroing for memfd hugetlb pages that were
pre-allocated into the pool and never mapped to userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/hugetlb.h |  6 ++++--
 mm/hugetlb.c            | 11 +++++++++--
 mm/memfd.c              | 14 ++++++++------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 49e5557d6cc0..3d23267014e6 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -714,7 +714,8 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-					  nodemask_t *nmask, gfp_t gfp_mask);
+					  nodemask_t *nmask, gfp_t gfp_mask,
+					  bool *zeroed);
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
@@ -1134,7 +1135,8 @@ static inline void wait_for_freed_hugetlb_folios(void)
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask, gfp_t gfp_mask,
+			    bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2ea078d4e5a8..0a19a078d860 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2205,7 +2205,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, bool *zeroed)
 {
 	struct folio *folio;
 
@@ -2221,6 +2221,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		h->resv_huge_pages--;
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (zeroed && folio) {
+		*zeroed = folio_test_hugetlb_zeroed(folio);
+		folio_clear_hugetlb_zeroed(folio);
+	}
+
 	return folio;
 }
 
@@ -2305,7 +2311,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * It is okay to use NUMA_NO_NODE because we use numa_mem_id()
 		 * down the road to pick the current node if that is the case.
 		 */
-		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+		folio = alloc_surplus_hugetlb_folio(h,
+						    htlb_alloc_mask(h) | __GFP_ZERO,
 						    NUMA_NO_NODE, &alloc_nodemask,
 						    USER_ADDR_NONE);
 		if (!folio) {
diff --git a/mm/memfd.c b/mm/memfd.c
index fb425f4e315f..5518f7d2d91f 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -69,6 +69,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 #ifdef CONFIG_HUGETLB_PAGE
 	struct folio *folio;
 	gfp_t gfp_mask;
+	bool zeroed;
 
 	if (is_file_hugepages(memfd)) {
 		/*
@@ -93,17 +94,18 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
-						    gfp_mask);
+						    gfp_mask,
+						    &zeroed);
 		if (folio) {
 			u32 hash;
 
 			/*
-			 * Zero the folio to prevent information leaks to userspace.
-			 * Use folio_zero_user() which is optimized for huge/gigantic
-			 * pages. Pass 0 as addr_hint since this is not a faulting path
-			 *  and we don't have a user virtual address yet.
+			 * Zero the folio to prevent information leaks to
+			 * userspace.  Skip if the pool page is known-zero
+			 * (HPG_zeroed set during pool pre-allocation).
 			 */
-			folio_zero_user(folio, 0);
+			if (!zeroed)
+				folio_zero_user(folio, 0);
 
 			/*
 			 * Mark the folio uptodate before adding to page cache,
-- 
MST


