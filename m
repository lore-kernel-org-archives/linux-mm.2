Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E180FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12A86B009D; Sun, 26 Apr 2026 17:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9C56B009F; Sun, 26 Apr 2026 17:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900336B00A0; Sun, 26 Apr 2026 17:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2CD6B009D
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:47:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 207001405A5
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:50 +0000 (UTC)
X-FDA: 84702044700.16.B450974
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id D542514000E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="c/OM9ECZ";
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huPFgAdwBnP/c9GYBPeC0qLQn/5dXNlXXwvv1VfNs5g=;
	b=TsQyizRVAtxDnl6Ar2R9UG+37BT1ot33kcRF8bXhrv5Ywad8tA1/4rjnu40mPxezGgyAOX
	x5GSSYVOqO/LvPleNERA7EGkoegiW1gg71f0Il6nHp+BdrJ+RXm3TPng+fx+z39LECWhmj
	Ti7EMnRwQWLEdh8gfnpPxkuu8b860uo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="c/OM9ECZ";
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240067; a=rsa-sha256;
	cv=none;
	b=qAtKBwSV2ssHUh0SPzzXFClBTkuWX1R5TDf/bbG9wN5bSNjyi3qPiULER15cHZbbtC1f8a
	Hv1uQ0eOwtdQCC3gE89WVzx2NTBNRsA8iyz36BVfbFCm6QDjFCLlADkIGbz3UH9Hg5C1xY
	bjhW6xn5O/51xiP3EYwodc4Xcscz0l8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=huPFgAdwBnP/c9GYBPeC0qLQn/5dXNlXXwvv1VfNs5g=;
	b=c/OM9ECZ14X8QSTIqK4bABIB0krhic5BfbE+8hzzD1ti2TmUzlRWwYQMLwEh4IAM5mBOpl
	5P7cw6OTzGuA2EzmqOiFAgexV6lrsYrjy57Ns+kFvpBXH9VHou+l2LQsws6BCe3PmJcEhr
	KS6M+ydmUMCkMTnrtAW4vNYuOvBof4w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-Nv6-pG4_OK-o6ceEuLE6NQ-1; Sun, 26 Apr 2026 17:47:45 -0400
X-MC-Unique: Nv6-pG4_OK-o6ceEuLE6NQ-1
X-Mimecast-MFC-AGG-ID: Nv6-pG4_OK-o6ceEuLE6NQ_1777240064
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-440d12a472eso6750359f8f.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240064; x=1777844864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=huPFgAdwBnP/c9GYBPeC0qLQn/5dXNlXXwvv1VfNs5g=;
        b=L861tdP3w1ZuTC9J0ewr2REifkp68gKh18CAvlMMmzdbD6CeYb5PlNv1RLJFfoLsZ6
         fAzAivSbawcZpJ7EEyXZp5H7w2cd8beGl++5t/s2xwK+F4pTx4VchUBKQKdBtlSbiind
         v4NME6smFwst05P97eUHBRX6yJBn2l2Ho4A+1iLdVZ8cXk9/cmdQnYBUWHRkeGg+BhsM
         MPInvheOVatYwx/Aj/CYaAUQUwy3/ovrYApk1gWFzVDICeIW4Gx1Jn20HUQ+KJn+4Ioz
         pnIQY8HSaaSGV24jqkcKlbfvSMAhpX7vMgsSx5McIsXPQ/JoxeukSdMZ1BrqGAaTYJig
         krDw==
X-Forwarded-Encrypted: i=1; AFNElJ938zPThbR+XQJOhBFYp7Ow3EKbub+aFWeDO+HreMR7C2CE4xJe4ZHCE4KSWos8sv3V5LIl16+btg==@kvack.org
X-Gm-Message-State: AOJu0YyJ6Gr7uOtQQd4bK+AzO21ct+9fTWEV9xD41VQ7xorQMXwKD1+t
	lZ+93clfET9FZjsUty/P6qr0dBO3osbTXP4mPJl4X0gcTZs6LHrvN/Yx4p2864TcavvMu7G+KbH
	DH114tYFaKpozCgIOesuIB9IFKaBhSV9zIJIeuszRGBm+sJUEPOgk
X-Gm-Gg: AeBDieuhTu4j3WL5VGxgC2OJEkcfPRSQusEMjAjiIK7AdRgfI5JXBTa8oK9hEH6AfGE
	rBYVKH2u2b39+J7fMI6kCC8WvV2SiQkRbrhAk6DkTmyvn4TB+trb5OZt/PQ6LhIbvkyO61H5YQM
	oB65qt5uKzpvxl/COubV3f8nbr/pQ5gsY3b/72iaKIjXzMLzcCUy2EH3ezNuFCF3OrJko3bYqg5
	QKV+LqGa7bgAxRxQ8qvjLAPSxpNG+NhRBPcPDwvZYHlHdVINlb+Hh8A+YWRuigjbaw95W2ZNSuP
	rPCd18iScOe6V5g48Z9mCYrwA+tH6Ng02mKr+DOmYrwTOSupDdQoa2Q29TYaGMv9dFf7pffbRbI
	7KM9Ex07K6oWhLa4NyRLr4BauB9IRzATPsFqVIukL0LzqFu1ZuWG6f+Z7
X-Received: by 2002:a05:6000:240e:b0:439:ae2a:755e with SMTP id ffacd0b85a97d-43fe3e0b606mr61745917f8f.23.1777240064083;
        Sun, 26 Apr 2026 14:47:44 -0700 (PDT)
X-Received: by 2002:a05:6000:240e:b0:439:ae2a:755e with SMTP id ffacd0b85a97d-43fe3e0b606mr61745852f8f.23.1777240063489;
        Sun, 26 Apr 2026 14:47:43 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e46898sm81017698f8f.27.2026.04.26.14.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:47:43 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:47:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH RFC v4 03/22] mm: thread user_addr through page allocator for
 cache-friendly zeroing
Message-ID: <83d63423ea5575de831afad200af32524df5958b.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U_IQjWRrumRIw9XVSBOFYjKuNsCz9Umeuvnkz60-hp4_1777240064
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: xxpw6pnx195xaxcbwhdiyemcnftxid8q
X-Rspamd-Queue-Id: D542514000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777240067-832929
X-HE-Meta: U2FsdGVkX18E4e9gPMl8L2HaDxua4KW6OGRSkbLXhKo4aZAfrE3DYFWmXjYJybiWerXGmPFT1VuKfD0C/A0fentXG5+h81kJUqV9pWpFbRP0oX+XYZps6Dv9degc4oiEWIuIyPW3KAqWzEPAAsvikKtVYEDjqfyDWF6MejWmHvAyAJfUFGp/g7xw8pOpM5iW4Q1N9oA6KmGLAmJtog+mHw/aREJSE2A9XcGN3/HJHQQTNeCyQ2jKvr++GOviwrEaVe1LpuhYOckRzhyqTapsr56yjzXu1rvI2AoiNKdbgEvn9jSy0CO7t/Qv8vFzTuUfv/x6BkFYXLiu7EtBjSgTsU8dFxcpisc+YtB/83QlpK7xoCxGBIUp773nnk+HntoHhazNiSIDlQzi37/J/cWW4uGnkzg5Go55ejOumq9yNGHXaYoyUKIw/Llw664aJHlBQo0mm5qP54HNtfzRtyGq0XUvnIkk0TcwiEkKs9TbWbRzq2PyBypdP3FhqXUGNvh1ilCALKOapW3NA7xtwWZPzCSnsjXpBo30i9fTbgpaSYbKGehdQXKrtbxagvF0Z/3NVsp/0QE/4p1GZN7aM1xlXqI/ObJlF57z7WwiybS6JNJK8BYdKnKwgdAOApqX4Q7TM9tyeRmdemljocP4tNZspUjoOgRCWdbqoD2CYbCtugCUpnPPJAorAXJ1oDUB8Qf0ItjEEcth5pumcboU4d4x13tK12Qdi4vxkBUEakl39sANYMlcxYxkHGgbAsvwXQgnzpOV5HUGsVmbhWQhnEaos1SX/8jb+tUPoNuEhSZjOS3TYMvbxDBHiSrvntGGtN6dQYMWR+WkXfG/0hjDX1nqClJtu3qtt2tSKQ6G/RvPoUfnZ1duTcr4VwbgfI2ArQUYy6pSWprGU6lW2SBKs3KW6tn763qgJ/V0p2DvhzuQneoOkW3J2atZPUZnmiW6lJJ95od3cnJipPQcutRjSRP
 W895u/1I
 0Tv2DZ10580neLVO7jO446kgxzuHvhe7cojX9/usuyRGLVZmn0zXfDNJWpn8xi7E4EORHCLepibojwZ32dHg8dtSdY10ofHb8EOUnp3Q08Wsl1Xkp0uXJIU7E3mCzn82UGBQsnLV/+iBb8P5cqqTTgmrBAhlZs/yQVIaKCW4g4UWPk3u/8QXje0U2DZrBdV7jKazWbPFV8uCCNV+bi+fDSw7jHWdRPGpr0X4i8bmHTuGl3uqhvl7qy7Hf0LS0k4oMOapVvwIv+/JLHUSxMoto8I7/mWmRV5V8QQq8sgN3hJU34wa0qEaavM/AXXRbGEU7bbaIX6NJ1TqnBGm+olGxMnh19YnweKBok2F/9DBrva/GMPEH/jtEzpx7aipG2Txjy4/nLex7OsVTFSdORPWver+Qm6VKyoctrYSv8A/0zQiGW8DDm9RJBf/XgeU4a8XLcz+v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thread a user virtual address from vma_alloc_folio() down through
the page allocator to post_alloc_hook().  This is plumbing preparation
for a subsequent patch that will use user_addr to call folio_zero_user()
for cache-friendly zeroing of user pages.

The user_addr is stored in struct alloc_context and flows through:
  vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
  __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
  post_alloc_hook

user_addr is threaded through internal APIs only
(__alloc_frozen_pages_noprof, __alloc_pages_mpol).  Public APIs
(__alloc_pages, __folio_alloc, folio_alloc_mpol) are unchanged.
USER_ADDR_NONE ((unsigned long)-1) is used for non-user
allocations, since address 0 is a valid userspace mapping.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/gfp.h |  8 +++++++-
 mm/compaction.c     |  5 ++---
 mm/hugetlb.c        | 36 ++++++++++++++++++++----------------
 mm/internal.h       | 12 +++++++++---
 mm/mempolicy.c      | 42 +++++++++++++++++++++++++++++++-----------
 mm/page_alloc.c     | 44 +++++++++++++++++++++++++++++---------------
 mm/slub.c           |  4 ++--
 7 files changed, 100 insertions(+), 51 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 7069b810f171..e275cc80e19e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -226,6 +226,12 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
+/*
+ * Sentinel for user_addr: indicates a non-user allocation.
+ * Cannot use 0 because address 0 is a valid userspace mapping.
+ */
+#define USER_ADDR_NONE	((unsigned long)-1)
+
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
@@ -340,7 +346,7 @@ static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
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
index cb0af847d7d9..8e4616e42b4a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -672,6 +672,7 @@ struct alloc_context {
 	 */
 	enum zone_type highest_zoneidx;
 	bool spread_dirty_pages;
+	unsigned long user_addr;
 };
 
 /*
@@ -887,24 +888,29 @@ static inline void prep_compound_tail(struct page *head, int tail_idx)
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
index f0f85c89da82..06403a3812b4 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2406,7 +2406,8 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
 }
 
 static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
-						int nid, nodemask_t *nodemask)
+						int nid, nodemask_t *nodemask,
+						unsigned long user_addr)
 {
 	struct page *page;
 	gfp_t preferred_gfp;
@@ -2419,9 +2420,11 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
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
@@ -2436,8 +2439,9 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
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
@@ -2445,7 +2449,8 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
 	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		return alloc_pages_preferred_many(gfp, order, nid, nodemask,
+						 user_addr);
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2469,7 +2474,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL);
+				nid, NULL, user_addr);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2481,7 +2486,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, user_addr);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
@@ -2497,11 +2502,18 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
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
 
@@ -2509,6 +2521,14 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
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
index 6d31a5c99e93..c19eaf76607c 100644
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
@@ -5310,7 +5316,8 @@ struct folio *vma_alloc_folio_user_addr_noprof(gfp_t gfp, int order,
 		gfp |= __GFP_NOWARN;
 
 	pol = get_vma_policy(vma, addr, order, &ilx);
-	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
+	folio = folio_alloc_mpol_user_noprof(gfp, order, pol, ilx,
+					     numa_node_id(), user_addr);
 	mpol_cond_put(pol);
 	return folio;
 }
@@ -5319,10 +5326,17 @@ struct folio *vma_alloc_folio_user_addr_noprof(gfp_t gfp, int order,
 		struct vm_area_struct *vma, unsigned long addr,
 		unsigned long user_addr)
 {
+	struct page *page;
+
 	if (vma->vm_flags & VM_DROPPABLE)
 		gfp |= __GFP_NOWARN;
 
-	return folio_alloc_noprof(gfp, order);
+	page = __alloc_frozen_pages_noprof(gfp | __GFP_COMP, order,
+					   numa_node_id(), NULL, user_addr);
+	if (!page)
+		return NULL;
+	set_page_refcounted(page);
+	return page_rmappable_folio(page);
 }
 #endif
 EXPORT_SYMBOL(vma_alloc_folio_user_addr_noprof);
@@ -6947,7 +6961,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask);
+			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7153,7 +7167,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0);
+		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7818,7 +7832,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
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


