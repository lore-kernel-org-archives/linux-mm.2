Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C98ACD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9C26B00AC; Thu,  7 May 2026 18:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB006B00B6; Thu,  7 May 2026 18:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73046B00B7; Thu,  7 May 2026 18:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 932246B00AC
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:22:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B2D31401F7
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:43 +0000 (UTC)
X-FDA: 84742049406.04.30D48E6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7F41100003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ejJaseUg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGyUdojsR0b/AAxiGg7aPnV5Y+huy5DwlenqjNbFa0M=;
	b=5qi9iJmPXxjPYyqY0Lk6XnGKB6TW6FPlkBfrEIUQeZn1fyMFN0sO+1inp1igWJKilKvavO
	4LR+VS0QhN5XJnYG2ax/dyZEZIWF5N1sGi84qChCbSXkcZrZt0E5h3HsRG1+L8ZB5RgZiQ
	IjH4993zat71dtbOTaaPt5z5nyLwFOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192561; a=rsa-sha256;
	cv=none;
	b=Qu/J6FHgEIA2O4brO5SjRxpZkZtBV23ozBg4pHdZ/LorA0LUW7ip2XqJRgdzrHlRJdJrcT
	dnQVq1Vi6WczBLpajcMvkXX/vgtXXlp6QlqCsRehxxpeC3bEeQvWWdA4l1/hEl4SSeHbtN
	IHXZH73p52NKZhWF3fQe6bWDXsmWrT0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ejJaseUg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eGyUdojsR0b/AAxiGg7aPnV5Y+huy5DwlenqjNbFa0M=;
	b=ejJaseUgGzbnYQ/OwS4E/xQ63iETIeOlIjRPAsvd6tjU4ZY2McPDoemwYtZYvhy54lcYlY
	b8BY3dmt7mXOOnDA8ndCiXBMe0en6V5F6zqQfDNqrrfSvVBK1MJIZF0ctlFHd837ZE66vP
	U7q7E0thOg3J3qwBWV7kqCuxO4QnewQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-zE1LOrGtMu6ggPYHWRwp_w-1; Thu, 07 May 2026 18:22:36 -0400
X-MC-Unique: zE1LOrGtMu6ggPYHWRwp_w-1
X-Mimecast-MFC-AGG-ID: zE1LOrGtMu6ggPYHWRwp_w_1778192556
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48e60b55de2so7978625e9.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192556; x=1778797356;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGyUdojsR0b/AAxiGg7aPnV5Y+huy5DwlenqjNbFa0M=;
        b=CvX+/a9VrrYu17eHEo30oALeoi5MqY6MjQvwEtXjbfL3ETrhS9bRiYiLJwrjYYD7Qh
         4MlhOHxZvLiK0yDk8zVDEKgrcuBrrlUsMkJw8aMmKEGBfA29jbRUE4VFUbt2PKKB1SeM
         bqqMZ2e83pp5rMHk13iHE44uN1LBlwzhrcUhyOdw30D9qug/L/5oZGdgQ99Y/lbVI32K
         SCyYhA9v0VfBu9vjwJgAR/W8DBkmbo2hoyEeDO/X9pAkClm1aLFfzIMqN4r6cbjTphQz
         kyZI4mKNaBtSY7hxKWhvj7nSpMCMTBiIALVGk3RYp0Ax1tqmRgirYXG+Ev7LJggDb5IW
         kezQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ttGBEMGF1L0wyVA1ER2WPpKmWNJmgftwtNjIXycZ6Lcrg3ViBaM389PShEtzS57A+WwfDVregTw==@kvack.org
X-Gm-Message-State: AOJu0Yy+3Su2CKEKz8cVE08LG2/euelRlrXFVSNrsETGSNa2ikwUaPRo
	4TphSXd3MPyxsSdd7VR7IfbYF97FZcP7tCpK17Nn/RSHjqAhOkxek5lm9t+kjuW0Ls9H6sJepJN
	53Z46UgLHXO9toJzl88cV4RA0wjNEacNLbgkfKfiWCw+p+CID76EP
X-Gm-Gg: AeBDiev+h00y3sAG/1O/qjhfRjuasVc3n9JRBzvxytS5u3ahfVeNviWnDhRP2L1tiB6
	Gu0vQKN0AxmVh/4tLGe1eKl3BCw1Upoay02cQpdWKhq4t4Hjhl2dzbvISA+fEi6Lf48TbMLTDOS
	Mo1pK9bSBLqndgeRSjKQ/gzb+TcnqujHbbSWGgTggXS+KjGWG/ybrgt8E5xWAO0gsVC/hXn5+Z3
	MA2y6XfsEdsJwBpdpGr1RxWtYVOgdBt1mT3fpDg2Z6YDUvR7D+K9hMwLuOdMX4/iPY3L7UUWc9F
	a8Hr4WNgqJC6Z0ilK4lcv2Mnp3P09aIw4s5OLAJAXcDlJvSqgg0iwbdjOlXQtRZ/3CX7k/ulQfY
	ze7Xt+GzHC7V7rmkZZzj3VHQrfG14rAxg/ShnxMIx
X-Received: by 2002:a05:600c:4449:b0:48a:89d9:a419 with SMTP id 5b1f17b1804b1-48e51f2e67fmr155695195e9.11.1778192555268;
        Thu, 07 May 2026 15:22:35 -0700 (PDT)
X-Received: by 2002:a05:600c:4449:b0:48a:89d9:a419 with SMTP id 5b1f17b1804b1-48e51f2e67fmr155694655e9.11.1778192554712;
        Thu, 07 May 2026 15:22:34 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e642eb9e8sm5315695e9.9.2026.05.07.15.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:22:34 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:31 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: [PATCH v5 02/28] mm: thread user_addr through page allocator for
 cache-friendly zeroing
Message-ID: <ff9370f1b7bfa0b671940122d81f4b58ba5fb868.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hkSoW-hPqqOp-hp28N4-ZurOrCaXojS4DFCmEViOFaQ_1778192556
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: D7F41100003
X-Rspamd-Server: rspam04
X-Stat-Signature: 5qw45khthzx5mdo8unk596nsfnmnwgi1
X-HE-Tag: 1778192560-899376
X-HE-Meta: U2FsdGVkX1/q+Xyh0k/RoBuNQ22B1kTaf0P16WVTijseMxgtA/0W5kMSgNjVM1oNNx3aXJSOXfAAETMVYQu6EuDrjncKCgC1jAhcMsRCRtO3l9uQ80E4psNUSi3KawytceHMhFCameDVjaZq7+Q3LlrlJ3FGQrESr8jcYZ7e9xUoFF5EBKrS1nkNIYMyw6/g6/cGxtrz7CBYbYFJiwy8nlt9lyxG7mLtQH4gLeJHwQMnP+2qQoRyq/9pDs2ADs/+DKhAkyFDAcfh0M3XxfD4QFaJH9xoshbb/q5ya60LXB8MqkceKJ2pEYeWkKws9FQLHbF0WF3DrSjsgn1I8vnWtGnG9nYGOlV8ZdMpub/mW8x5Go0G5zh32aWmlhk9okVxSQpOaTibHFNtFUMNti4SfUHPaEowr1mXCa2t1dzIitFJVDpzHSO4mhps9Gdv7oAU0y3Ho9dl0VtYCodWyGHsoJvxkB2M4nfVXfLL6T/dsp4Au3qXcHQQSnDTT34MeYMV2XLVRnW3pvf7tNAsFWO6QHJ45yQbRxlyU0O6HC7etT8LehxZ9r0EYel7V9P0uRkxdOybtt15uqlMsKA7jYNTP4Xbfrx2Wr4C3KFb89d1JeyvmyYDvN9k0hLrIebjwJ+d+bo5XjDlqdYIaqEk/nzW10v5LcShIavIs+o8Og4uPrrRY+pDGuWHJV4QcBYSf0P533qGnmzTu7PM6nU7fUzyoOiQv+1u09lguzRUDRyVpXNnPMs3p0MykHzVbiA23ILwz66sq3lwyyuMQ6R3zhOZ5wBJ2pX3ZMBVhdxnHjZsTQ+PvF6JxVC8qmzqdzoOcQ7gwHvlOYj+GH7feGVmAfBxV08gh3AzqZGFWVnF5MSQ0CdLUdCaaYJq618yCong33WfjdwXpt8dmHiUlvpR/W5l5f+MZ4pK8P82vYynSmKTRE7qF4KoLMZRYMMxBg6/FW/QeSIfKAlt5OZP4B+7uCh
 0oiKKJML
 9XfLtv2uncsDNEDQak9a4QyLxjSMTHRDPPbnDR4rRFFoh0MbNMC5ouv8F0nOK2QuJc4upiAoKtxR2hiVQ13QR+i6LPBoY3YAnTfXvrKShWHO4xqCvSasJViS4bjg12q+DrPbu5VFIzS7plReG+i0ainwDP/0dN8iyp+eNEnfBvM1NeZ3HkRsszKNZOocbkyN3419It1e8DYI9UTZL1W2Xk7xUPBRksjQrBeEq2eGPSKlVLPcWBloBw9sbPr36Y1Yuu32wjlhLVCru6Sdm5crBJtqbhcbvro1Kz95w7ZEKzjls/8kJTxDTHbLflfGEvJGmAXQJhRbaYAJBM+8P3PqZbBowKPXDLhVDuYnRhhBYWCiNX6m8vvQCTtdGjL5yg5VIJSr7/czKOgU+BFJFJK4wjtL5eRc1ruXa/RsHceEeDMYWMafbel7I7biGANUPWkyXfn6V
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

mm: vma_alloc_folio: accept unaligned address

Align addr to PAGE_SIZE << order inside vma_alloc_folio before
using it for NUMA policy lookup. All current callers pass order 0
where any page-aligned address is already aligned, so no functional
change. This will allow higher-order callers to pass the raw fault
address without pre-aligning.

Fold vma_alloc_folio_user_addr into vma_alloc_folio since it is no
longer needed as a separate API.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/gfp.h |  2 +-
 mm/compaction.c     |  5 ++---
 mm/hugetlb.c        | 36 ++++++++++++++++++++----------------
 mm/internal.h       | 18 +++++++++++++++---
 mm/mempolicy.c      | 42 +++++++++++++++++++++++++++++++-----------
 mm/page_alloc.c     | 44 +++++++++++++++++++++++++++++---------------
 mm/slub.c           |  4 ++--
 7 files changed, 100 insertions(+), 51 deletions(-)

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
index 1e8f8eca318c..c1039a9373e5 100644
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
@@ -1832,8 +1832,7 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
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
index 0beb6e22bc26..de8361b503d2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1842,7 +1842,8 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 }
 
 static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
+		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry,
+		unsigned long addr)
 {
 	struct folio *folio;
 	bool alloc_try_hard = true;
@@ -1859,7 +1860,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask, addr);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
@@ -1888,7 +1889,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 
 static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+		nodemask_t *node_alloc_noretry, unsigned long addr)
 {
 	struct folio *folio;
 	int order = huge_page_order(h);
@@ -1900,7 +1901,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
 	else
 		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
-						 node_alloc_noretry);
+						 node_alloc_noretry, addr);
 	if (folio)
 		init_new_hugetlb_folio(folio);
 	return folio;
@@ -1914,11 +1915,12 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
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
@@ -1958,7 +1960,7 @@ static struct folio *alloc_pool_huge_folio(struct hstate *h,
 		struct folio *folio;
 
 		folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, node,
-					nodes_allowed, node_alloc_noretry);
+					nodes_allowed, node_alloc_noretry, USER_ADDR_NONE);
 		if (folio)
 			return folio;
 	}
@@ -2127,7 +2129,8 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn, unsigned long end_pfn)
  * Allocates a fresh surplus page from the page allocator.
  */
 static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
-				gfp_t gfp_mask,	int nid, nodemask_t *nmask)
+				gfp_t gfp_mask,	int nid, nodemask_t *nmask,
+				unsigned long addr)
 {
 	struct folio *folio = NULL;
 
@@ -2139,7 +2142,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, addr);
 	if (!folio)
 		return NULL;
 
@@ -2182,7 +2185,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, USER_ADDR_NONE);
 	if (!folio)
 		return NULL;
 
@@ -2218,14 +2221,14 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
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
@@ -2332,7 +2335,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * down the road to pick the current node if that is the case.
 		 */
 		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
-						    NUMA_NO_NODE, &alloc_nodemask);
+						    NUMA_NO_NODE, &alloc_nodemask,
+						    USER_ADDR_NONE);
 		if (!folio) {
 			alloc_ok = false;
 			break;
@@ -2738,7 +2742,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 			spin_unlock_irq(&hugetlb_lock);
 			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask,
-							      nid, NULL);
+							      nid, NULL, USER_ADDR_NONE);
 			if (!new_folio)
 				return -ENOMEM;
 			goto retry;
@@ -3434,13 +3438,13 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
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
index cb0af847d7d9..e39abab956e7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -641,6 +641,12 @@ void calculate_min_free_kbytes(void);
 int __meminit init_per_zone_wmark_min(void);
 void page_alloc_sysctl_init(void);
 
+/*
+ * Sentinel for user_addr: indicates a non-user allocation.
+ * Cannot use 0 because address 0 is a valid userspace mapping.
+ */
+#define USER_ADDR_NONE	((unsigned long)-1)
+
 /*
  * Structure for holding the mostly immutable allocation parameters passed
  * between functions involved in allocations, including the alloc_pages*
@@ -672,6 +678,7 @@ struct alloc_context {
 	 */
 	enum zone_type highest_zoneidx;
 	bool spread_dirty_pages;
+	unsigned long user_addr;
 };
 
 /*
@@ -887,24 +894,29 @@ static inline void prep_compound_tail(struct page *head, int tail_idx)
 	set_page_private(p, 0);
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
index 583b64f2b4d3..fc4c2198da01 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2407,7 +2407,8 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
 }
 
 static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
-						int nid, nodemask_t *nodemask)
+						int nid, nodemask_t *nodemask,
+						unsigned long user_addr)
 {
 	struct page *page;
 	gfp_t preferred_gfp;
@@ -2420,9 +2421,11 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
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
@@ -2437,8 +2440,9 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
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
@@ -2446,7 +2450,8 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
 	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		return alloc_pages_preferred_many(gfp, order, nid, nodemask,
+						 user_addr);
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2470,7 +2475,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL);
+				nid, NULL, user_addr);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2482,7 +2487,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, user_addr);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
@@ -2498,11 +2503,18 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
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
 
@@ -2510,6 +2522,14 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 	return page_rmappable_folio(page);
 }
 
+struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid)
+{
+	return folio_alloc_mpol_user_noprof(gfp, order, pol, ilx, nid,
+					    USER_ADDR_NONE);
+}
+EXPORT_SYMBOL(folio_alloc_mpol_noprof);
+
 /**
  * vma_alloc_folio - Allocate a folio for a VMA.
  * @gfp: GFP flags.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0e6ec7310087..c9efc07741b9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1837,7 +1837,7 @@ static inline bool should_skip_init(gfp_t flags)
 }
 
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags)
+				gfp_t gfp_flags, unsigned long user_addr)
 {
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
@@ -1892,9 +1892,10 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
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
@@ -3959,7 +3960,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
-			prep_new_page(page, order, gfp_mask, alloc_flags);
+			prep_new_page(page, order, gfp_mask, alloc_flags,
+				      ac->user_addr);
 
 			/*
 			 * If this is a high-order atomic allocation then check
@@ -4194,7 +4196,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	/* Prep a captured page if available */
 	if (page)
-		prep_new_page(page, order, gfp_mask, alloc_flags);
+		prep_new_page(page, order, gfp_mask, alloc_flags,
+			      ac->user_addr);
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -5072,7 +5075,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
-	struct alloc_context ac;
+	struct alloc_context ac = { .user_addr = USER_ADDR_NONE };
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
@@ -5187,7 +5190,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0);
+		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -5212,12 +5215,13 @@ EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
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
@@ -5278,10 +5282,12 @@ EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
 
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
@@ -5309,7 +5315,8 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 		gfp |= __GFP_NOWARN;
 
 	pol = get_vma_policy(vma, addr, order, &ilx);
-	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
+	folio = folio_alloc_mpol_user_noprof(gfp, order, pol, ilx,
+					     numa_node_id(), addr);
 	mpol_cond_put(pol);
 	return folio;
 }
@@ -5317,10 +5324,17 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
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
@@ -6938,7 +6952,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask);
+			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7144,7 +7158,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0);
+		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7809,7 +7823,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
 	unsigned int alloc_flags = ALLOC_TRYLOCK;
-	struct alloc_context ac = { };
+	struct alloc_context ac = { .user_addr = USER_ADDR_NONE };
 	struct page *page;
 
 	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
diff --git a/mm/slub.c b/mm/slub.c
index 0c906fefc31b..fc8f998a0fe1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3266,7 +3266,7 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 	else if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages(flags, order);
 	else
-		page = __alloc_frozen_pages(flags, order, node, NULL);
+		page = __alloc_frozen_pages(flags, order, node, NULL, USER_ADDR_NONE);
 
 	if (!page)
 		return NULL;
@@ -5178,7 +5178,7 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 	if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL, USER_ADDR_NONE);
 
 	if (page) {
 		ptr = page_address(page);
-- 
MST


