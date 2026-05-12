Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE932CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FCF66B008C; Tue, 12 May 2026 17:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5316B009D; Tue, 12 May 2026 17:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29CBB6B009E; Tue, 12 May 2026 17:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 196E16B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:05:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF81D405E5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:48 +0000 (UTC)
X-FDA: 84759999576.29.E23E98A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 87CD31C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a01XYBoC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619946; a=rsa-sha256;
	cv=none;
	b=WqbaWp3Lf2W9f5pDEBFVT3I74o5COg6eSJAZO6+fzpM7Yhz5lFtmvhYsmeGXyr7j7olbr5
	Vcteh9346vgOtkxGQoZfxBUIKxucou8Tu3UXv7vwVthTuH3oayF19uL/8+nE1F0QZNTKpg
	Q+n+bkCxmeNvBMFE3G7TttxUpGwHGJk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a01XYBoC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tN2+L1RVKNLEiC6SOal2R5Ri9JooNcSUKgYv9R2PK/Q=;
	b=NPJyHZckeyNmrwzCU8WUZQKxonAlTaI8FnXxZO4T1PVAF9B1rwEt90k+d/uQKbW1nsUSOy
	hOJL+Gi31oaKBtHq2mA89ugKuyzm5t4otOr3hfnQ0Yc6QQ+fMw/5mx3F1vb02bpT2VzA0J
	EB2MbxZjMKm3gPXUnJvwp1g+dLObpA0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tN2+L1RVKNLEiC6SOal2R5Ri9JooNcSUKgYv9R2PK/Q=;
	b=a01XYBoC8QT+vtt1IhbbayF34R3Y9/cAwgNdkDbOQeroonjK4dsOgvfIxP69R6juC9gofN
	+RizU3n7vcGm7Oz32mswhkmRJa2LRV5vVP3wRTZ8OkTJ3edA0+sjjVJRNqigowYOg6RElw
	Jz4D13t5JtaqJX45BAAX0meH2Xz/k8I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-fg0-ebqgPt6RmvCAyPJboA-1; Tue, 12 May 2026 17:05:44 -0400
X-MC-Unique: fg0-ebqgPt6RmvCAyPJboA-1
X-Mimecast-MFC-AGG-ID: fg0-ebqgPt6RmvCAyPJboA_1778619943
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45b7ff2140eso817485f8f.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:05:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619943; x=1779224743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tN2+L1RVKNLEiC6SOal2R5Ri9JooNcSUKgYv9R2PK/Q=;
        b=Tmb6K+7tgfjo7bV7TDfzR74Y2dt9G1o34y+Najng45bMGmcNF9wy/X901k1irony6h
         P6zWatgSyv6lgJMOyKtEpMx2kqHazjortCAyi+8XJUuHnemDBgYUG56TSMpqnOoU1trl
         T175cnWQMIatDjTpref/RIMH5HByAL3Fg2dXptQLZuRtWi6pWR89jYLnTR4Ocd84InOG
         IrocU0it7qFj4MiBF7pQQ87ha24tvRvhSQjEHikXzkKE2EV34pfzn4Ar6EmcE/28CmNf
         xhC5a7vo1vnVfDxRfJdbwvAKIcYHKWCRpx5Ja7mdzMIy7VNRvcVweiblYiEvi9dObKMD
         APHQ==
X-Forwarded-Encrypted: i=1; AFNElJ8YD92kRhE6otYFNIWOUow5JqsY2lqh/xhl0RWCvOevToNRvolXY4H3K8YiM/oTVCxgqNlLOo5xAQ==@kvack.org
X-Gm-Message-State: AOJu0YwFIKJYCwDm5DpLjtOSSuCJj4CUF/tXv0lyncE76M8ejWOJw883
	o57XX3RkGAtz/mDm36UXTLvvR9QxtZKmzwR24GySOdjfaDUROPLNoifPccpxk0zWso2dhO/GMIG
	wJfYSULNG9VPfGVkY+z57zCPP31nmFWvstHV8CE/5OXg8L4FcvXkJ
X-Gm-Gg: Acq92OGKvo6H57X270wxFNH4yELk01hZAeWi0TNnH3uL4LoPDG2yQnNdlwD3Qu74GfK
	MDkFODKxNdQkptDA5+8VPM/Gq+Q+OjSuEn6zgNlWN5oUx59Mtg3DqMNH+I2TaEo7Phc/Gdsn7B9
	UPUgf2CiakKiTxGUYBipkh5f1hWQJlfwD8xTQm7RiX7dSdl6oidvMxHgwbvhU9GDfSKSBDxQSi5
	sNk1sXXLzZpA3tf3BikFhPsATC9ficllyi+6K2LQPgOVDvVKUAWt4sRYRKFaKn6UVr9NESSH3V/
	Kp4nuFHGB1x2/n4QTgG2N8qFSm1gS2S4H178lD/PkOx6gFTn/BUqogavf+ukEp4wnRKjiJMbnIM
	gn+HaiNg6K4j79sPBfqjrR9ihce1QcTZnfONEKuQO
X-Received: by 2002:a05:6000:310c:b0:441:3144:efc5 with SMTP id ffacd0b85a97d-45c5ac533d1mr457594f8f.42.1778619942719;
        Tue, 12 May 2026 14:05:42 -0700 (PDT)
X-Received: by 2002:a05:6000:310c:b0:441:3144:efc5 with SMTP id ffacd0b85a97d-45c5ac533d1mr457511f8f.42.1778619942032;
        Tue, 12 May 2026 14:05:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a6a64sm36428239f8f.6.2026.05.12.14.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:05:41 -0700 (PDT)
Date: Tue, 12 May 2026 17:05:36 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>
Subject: [PATCH v7 06/31] mm: thread user_addr through page allocator for
 cache-friendly zeroing
Message-ID: <e53d8a3f05612a3ac01a8b7f13000ad02e3c63ad.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5ooY22liFRM4qX4Qq4cAnVT9j4mJX-zE680mhzWfFps_1778619943
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: gnei5bsib5jomz8be1cgsx4myjopehpo
X-Rspam-User: 
X-Rspamd-Queue-Id: 87CD31C000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778619946-65046
X-HE-Meta: U2FsdGVkX18CEINtLfq3vppY3+YTiBvBDq/MBWFQbmbTiabMqF6Hok66mJJc67RCYtke5K4H9/XnMrUgEi48icLT7WVjqmIkHNEgzaqz2e7HaXGMuX0vBhk2uFQWDFB8RyuIt3ecrKIk752GQAGRckSDsIb1LADhLwV3LdEyB/oyDOFC0YXDuCCsOBbarZzCVMx9VbxH6HrfNDD9qfbCie6JfN4LStS1PXKBblJ+yXOduLmS8v17hJbmL8dR9DV2sgXhmVn+wKZxnZodDOrlgxP7B6VDvv+AF8MQeXumD2vzWKa2Xx+qItXeKE9YCyW/S1AvBPsfXWN5IY7cimzEPJ4hhwzeADg287rVNtaHfR9EGYirPye0LRRfkgpDzysUlWXd9MQJmkKtF3PauxN4rN/wgzreed4AF2E86bBgSIGOQm3cr56OiLlX9vE6n/Nmkv5rHxMoAZfNRV8QqIxDR7/Do9F0Vg31IuXMO4H9eD2xKyivmMFzXEmqr/Tw3W3siZEhYtyE3Rg2L4A4OjZIg/fii/X9oXwjABPjOjmZrWrTyNyUtYct7Y8ILAqhQutEhdZ2xbT6sM+4skd9ryTVFdn4YqTbv6txJLK6XaueyRLI3U9k6wnGkGZwTBjaH6EZBp4dCTwtPVUTPsGtMvO5j5gIDvQlNlr/1A7rD4c84eZvQDeBHbMcIUtPQX/zgHhS/kB1sVBXz30v7xkn8uk6FHfYE8K5PJILYBdk3rMZWUorls445Wc1fV/aJI8FfECpbLbrBx6kkFf31mCGNvRMptuWEO0LLzPvFp/CEnL/RM/es5sm7l8v6thV342X/9HO3ylIfo2KwPqQ/sXS/i89jNfa7FIl9AzF3s386GpBV5tYFYvK0ZGTiyPFy1TUmmE8wvSsdp/5YKsEy5aN8aTW9c7yGDC7WIaSIeUsv45BqqFwSSh3eF7DIxadapzW8Qo77Ut3j7b3FSQtt7nUGMq
 PEvaZAG7
 4Bke0cpx1Gl4ol6H9+bu/EyqyS8GzRTIELxD8chsOfOQkZFD1IiGUD7fBY3btwFeDicmmzp8OdPYHs7bqB7TMbV8PwB/m0nwkgnsIQyh2dzlIGTbpjNjmQ+hUywtCfBV9MLWyAcY5hEILljAJxqdw9I4GbA+zbef9gckPy1+y5bxF+5FniaDlb5A+43VDkQwbUWD2oh/Deblgi3+taetela94DD5KQRuekAvKgI4iKRJFud7w8ODhzU5lMvTOOdsiCd5C+LgTggV9HQ3le31V48DzQVTN+3P3OUB6i8Mx0+w/XVWGjmPr1emsZNAnd4cp5FKpqSfgN0iVS5+uzmDTKxO0sjqNgqhc65OuDrtaS5tNLNJRGjEwm+LmAGlvGCT/OrVyE0mdmo+FXgW+umQtzaFZEp9u+RL9poI9Gbs+Q9fgx8pOOxpUNhuw5Q==
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
 mm/internal.h       | 22 +++++++++++++++++++---
 mm/mempolicy.c      | 44 ++++++++++++++++++++++++++++++++------------
 mm/mmap.c           |  6 ++++++
 mm/page_alloc.c     | 44 +++++++++++++++++++++++++++++---------------
 mm/slub.c           |  4 ++--
 8 files changed, 111 insertions(+), 52 deletions(-)

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
index f24bf49be047..a999f3ead852 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1806,7 +1806,8 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 }
 
 static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
+		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry,
+		unsigned long addr)
 {
 	struct folio *folio;
 	bool alloc_try_hard = true;
@@ -1823,7 +1824,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask, addr);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
@@ -1852,7 +1853,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 
 static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+		nodemask_t *node_alloc_noretry, unsigned long addr)
 {
 	struct folio *folio;
 	int order = huge_page_order(h);
@@ -1864,7 +1865,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
 	else
 		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
-						 node_alloc_noretry);
+						 node_alloc_noretry, addr);
 	if (folio)
 		init_new_hugetlb_folio(folio);
 	return folio;
@@ -1878,11 +1879,12 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
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
@@ -1922,7 +1924,7 @@ static struct folio *alloc_pool_huge_folio(struct hstate *h,
 		struct folio *folio;
 
 		folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, node,
-					nodes_allowed, node_alloc_noretry);
+					nodes_allowed, node_alloc_noretry, USER_ADDR_NONE);
 		if (folio)
 			return folio;
 	}
@@ -2091,7 +2093,8 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn, unsigned long end_pfn)
  * Allocates a fresh surplus page from the page allocator.
  */
 static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
-				gfp_t gfp_mask,	int nid, nodemask_t *nmask)
+				gfp_t gfp_mask,	int nid, nodemask_t *nmask,
+				unsigned long addr)
 {
 	struct folio *folio = NULL;
 
@@ -2103,7 +2106,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, addr);
 	if (!folio)
 		return NULL;
 
@@ -2146,7 +2149,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, USER_ADDR_NONE);
 	if (!folio)
 		return NULL;
 
@@ -2182,14 +2185,14 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
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
@@ -2296,7 +2299,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * down the road to pick the current node if that is the case.
 		 */
 		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
-						    NUMA_NO_NODE, &alloc_nodemask);
+						    NUMA_NO_NODE, &alloc_nodemask,
+						    USER_ADDR_NONE);
 		if (!folio) {
 			alloc_ok = false;
 			break;
@@ -2702,7 +2706,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 			spin_unlock_irq(&hugetlb_lock);
 			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask,
-							      nid, NULL);
+							      nid, NULL, USER_ADDR_NONE);
 			if (!new_folio)
 				return -ENOMEM;
 			goto retry;
@@ -3400,13 +3404,13 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
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
index 5a2ddcf68e0b..389098200aa6 100644
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
@@ -916,24 +927,29 @@ static inline void init_compound_tail(struct page *tail,
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
+void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
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
index 39e556e3d263..ea3043e0075b 100644
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
index 4c5610b45de5..8c673095c11f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1816,7 +1816,7 @@ static inline bool should_skip_init(gfp_t flags)
 }
 
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags)
+				gfp_t gfp_flags, unsigned long user_addr)
 {
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
@@ -1871,9 +1871,10 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
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
@@ -3955,7 +3956,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
-			prep_new_page(page, order, gfp_mask, alloc_flags);
+			prep_new_page(page, order, gfp_mask, alloc_flags,
+				      ac->user_addr);
 
 			return page;
 		} else {
@@ -4183,7 +4185,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	/* Prep a captured page if available */
 	if (page)
-		prep_new_page(page, order, gfp_mask, alloc_flags);
+		prep_new_page(page, order, gfp_mask, alloc_flags,
+			      ac->user_addr);
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -5060,7 +5063,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
-	struct alloc_context ac;
+	struct alloc_context ac = { .user_addr = USER_ADDR_NONE };
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
@@ -5175,7 +5178,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0);
+		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -5200,12 +5203,13 @@ EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
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
@@ -5266,10 +5270,12 @@ EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
 
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
@@ -5312,7 +5318,8 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 		gfp |= __GFP_NOWARN;
 
 	pol = get_vma_policy(vma, addr, order, &ilx);
-	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
+	folio = folio_alloc_mpol_user_noprof(gfp, order, pol, ilx,
+					     numa_node_id(), addr);
 	mpol_cond_put(pol);
 	return folio;
 }
@@ -5320,10 +5327,17 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
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
@@ -6904,7 +6918,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask);
+			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7110,7 +7124,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0);
+		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7775,7 +7789,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
 	unsigned int alloc_flags = ALLOC_TRYLOCK;
-	struct alloc_context ac = { };
+	struct alloc_context ac = { .user_addr = USER_ADDR_NONE };
 	struct page *page;
 
 	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
diff --git a/mm/slub.c b/mm/slub.c
index 0baa906f39ab..74dd2d96941b 100644
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
@@ -5235,7 +5235,7 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 	if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL, USER_ADDR_NONE);
 
 	if (page) {
 		ptr = page_address(page);
-- 
MST


