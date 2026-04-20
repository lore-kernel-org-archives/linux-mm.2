Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA329F588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FEC36B0095; Mon, 20 Apr 2026 08:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1936B0096; Mon, 20 Apr 2026 08:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102A76B0098; Mon, 20 Apr 2026 08:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E975D6B0095
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 954AE140A5F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:49 +0000 (UTC)
X-FDA: 84678918618.03.9E914EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6839B40002
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JlY69wbl;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1uMYUyGM2Qrt5nxh6GVo3Jl5MBn378JvNFc5Ca6urQ=;
	b=a4ejxtuV1cIUVEZdiDTB90uNgHvIPXj5e+sNT0a2sjFI49aEu+khsD4N3WBQc4aAfJmX94
	0txN7ztPyUPPC7w11yM8amy3rqTl84K7pTZ2YbFh/2ARPe/NDRAF/RWfXpFdPnQ2BSY3qj
	VPglLsIt+/Fix1W5FRf6Vl+sNFOWBB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689447; a=rsa-sha256;
	cv=none;
	b=39WdXrf9BJsiPMBsuucrix0IcpIBUrm9YpLNtZfoaJ0IN0pPzc9a1hjIgv3l79rtlatTQV
	XhErHgPSeW/nbeXOjzL8v4srRr32NJx4+pGhJerBEPIqTCDy8oD2PA21T/b9ZrFvCunx19
	CdZO64FdqOG1kUF42HZVYrRDLs3xCFo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JlY69wbl;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H1uMYUyGM2Qrt5nxh6GVo3Jl5MBn378JvNFc5Ca6urQ=;
	b=JlY69wbl0eI7nIOmwbKpLfxTdCo7xSHqdQJb8iqAMpEfy6zX6WwCfNJPFg9IyDZFLvwigK
	jRb212z0lxeaoxVxESEqX4t/uyCjZJgncx30eIhAwjUvsmLiEed8E2z+1z9VnIZplahQi6
	t+zkC/3RjitwXVJtFLTCRh5DUzlooDk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-2qVwKKhtPr61Z2u8V8TfqQ-1; Mon, 20 Apr 2026 08:50:45 -0400
X-MC-Unique: 2qVwKKhtPr61Z2u8V8TfqQ-1
X-Mimecast-MFC-AGG-ID: 2qVwKKhtPr61Z2u8V8TfqQ_1776689444
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488bd1ee9e7so21559185e9.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689444; x=1777294244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H1uMYUyGM2Qrt5nxh6GVo3Jl5MBn378JvNFc5Ca6urQ=;
        b=V1BK3etT3KV0YaqqzL7uA8r6UFdaDeDfXq/C4sFg80+WLThYaD6YAFQeX1d7jAHrW2
         jCLckULLM1sAy8r35DlGc5ZGGOmJupW7bpADSuxif2mSWyjLt6CdHeuDFqPPMw53bSPe
         SCNZNFPpFgeutL18i+206uvVVkS8/eDp3ITVa5MLizo2HG/r7f7ClZb1m6emljx56YS0
         5o6qCokpHPn8pfjFjY9EVHFBjn9bJyFf7HVxNBFubIbZkrqe7T810r0qzf9zABUMZ6tH
         8DbBpyzV9q6sqZoOMLv6i6YA1iF6qlT/D7H/H4QU6f1krli2PIVDm+UVVE/M64vq2OV3
         gIjA==
X-Forwarded-Encrypted: i=1; AFNElJ9D0Mnkk8zZ7xACluHjCMgulHI8/9qk52uajmVWGbvlrmlrC25+GVRSFdIhpAYsC0dmdxk/K8aQIw==@kvack.org
X-Gm-Message-State: AOJu0Yz56h9bnLXXtNmqbjJ960P0th0DQwcrBfzu+7FMEBmAJZI1MGeE
	vB4MiQLDOXrcXtxOIQhJH44kX9g1dz/eQ7Mm82Rt0K1dLmTUXPiARTyGQzXdPESEtIblALcee69
	hLfcTFw65o0vuAOHq2GB+d0RKeTmmPzfiDDf5CEfFafdNDjIqWgU4
X-Gm-Gg: AeBDievLOHNyM1CA7LQRhgkEu9RIymeTLBbNs8nFlKm+/LYmaMHzDP1kUX36AifTYs1
	qs05wtw65ONtfru6CwhZn9jrELtVq/xEGJrGKCXPmy1XLg1R/+OBxsSrGkRX6CD43WkIidAryfz
	n0HaV1T3V4tICXr5P3xkeaZ2ZR8/sJMW5oPKXci4i1zMXPmcicltx4qY8tzwWbOpL28gVfWHPB8
	7ZUEnIOwmOgkqkpa1R/d66pX7bm1EyjOxRmkZuIHz0qu1aK4PABtijW6NwhM14UFGNdW3A/BoRo
	UBzY2dOB2FVoRe8UfdvwtoeasyHFMSS8+zXU6VKYxKCZD/6VuSkZm6ii2VQQauO44DTgr2eWqJN
	Yla8GTHoA6kE6e+7xpIPcuSTy7fewHYPUwNxlKyHqrtmICGMoDmRbAw==
X-Received: by 2002:a05:600c:1390:b0:483:709e:f238 with SMTP id 5b1f17b1804b1-488fb78ea6fmr191197905e9.29.1776689444272;
        Mon, 20 Apr 2026 05:50:44 -0700 (PDT)
X-Received: by 2002:a05:600c:1390:b0:483:709e:f238 with SMTP id 5b1f17b1804b1-488fb78ea6fmr191197445e9.29.1776689443758;
        Mon, 20 Apr 2026 05:50:43 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0f82bbsm466309085e9.3.2026.04.20.05.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:43 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:41 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH RFC v2 08/18] mm: hugetlb: thread pghint_t through buddy
 allocation chain
Message-ID: <ad75b8d2d13bc92e1ee369a4a3fff646d90018d9.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 40S8uC676BhSHUkVXJWjsp1taJEDZDgKqxJ-Sevu2R4_1776689444
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ry69ttpnnizra4zurq88b8i84gg5asrr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6839B40002
X-Rspam-User: 
X-HE-Tag: 1776689447-807913
X-HE-Meta: U2FsdGVkX18vkFJx4v22ZhfMggX77lvgggqeKLpVfQJXJb6vlrR2oYkDUUWW+B41Ef6cWxOQLkFsgOkOtE8W5Z9dNoQqcLM5zinyqDj0nDP1wz0bi4cKiuC6f6GkZe4znTLPj7Ti8tnJxh94twAZ1zkjZSzvYOtEFSfDgnocGVL5+5p1wfACDx4BFEKfBmpghWvHimyEWh6ooLOWJZhv+X9cROhkK4LBsHv6blTTcndE9JLiWDkWbfPTppxJsUhrJ5pAxvgI5DYl6nIpPjYCHPHe9n2hvenfy8nKaNP8CKJsaIQXSLAZeIZprLxSONa/AhsqhsQ6XVfjM7BIT/3nlZ9alQ9siWB6gOm0Oa5CtedNeHFHAcSlPJKLCsLZMsKeHK1ndULf7qMzrXEh+PENhzDMzR9VrdC1x5qW4QQNSqAqFt9FPE5oYmabE8qRyCGJQy0tT3rMaqZyeVsZDCB6r/ybHRvqvOrNQziUnFha8RiSCYgKe5sSMrHSfWsa8bs7EfcFGaqZAYtLCe0ECssqyzHunLEMkHElAr9xoRUrUFVhu3jy9LuImJYnHm1x0XpBLkNVRUVznjxCAawAtT4godW5ANKZJ1Z2Li3c6NeIKC4S3k+NZgN4++6Fnibk4HaJ4QTdzq78EZ4qxOekqdmQHs0OLpnPbb68MxFUQVUjUA7C84AuLgmj0LImtvWJIeg99iHP7gOt4VVuCmOePj9g23cvWKH70oxUOy91z8L+aWKn2oRXUihDaqtfa54XUHt9qLGgkd84mT1erColUiB8oE0FjmidhZJ6wjBdt6zj1xxf6Uxq5HUHSxaOHIFYofUq1EO6WXzDkIsVKCRy2uBoi4Lmg2xg/kcqPf5xItETJAPTccqdgFiHugBAV56ZO6MKoyZ7APstxxbb4AMJH8F2TFeg4jMY6slowJiORpjPZbsD+ku6NG0hK62dcewP+MmRqUVUMDtMLjLf/yhvvUg
 4iR9klUj
 qZByNZU0GpExK37XpxSrKkIFyhZvL4DbvzC/xkGxPwEFgnAWV/jQm0z3Amw0194cm8r16Igf5L8C5jqiEebhXA20PW4Pu4AFccLw3tCbUbharnd1r0MjYmS65OFbPADvHFeAJyCh0Ze23XlhYdd4xNFWsBx9yXh/6d4nytruBI1PPe1HD1GqhXF/yOjLsNyOQXYn3o1hWb3dNWHMN3dmadWJGqQIYASlcYDXP7IEW0aSsiZGhKThUnu+IzZ1cj0T7xyxvN82+i93D0QXRNP5td2/smP8cIUXwd/gs3tx1gkyOC/iWdOhs5HFslU3cec400HtRuT6UMwd/U4JaWpKTwsU9Q5rv5WeJTdA3eRwHaQGw2WR102v7Y8nfPkFqLYTPMerujogPky7InRk2p2OsY4uqhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thread pghint_t *hints through the hugetlb buddy allocation path:
  alloc_buddy_frozen_folio -> only_alloc_fresh_hugetlb_folio

alloc_buddy_frozen_folio now calls __alloc_frozen_pages_hints()
so the reported-page zeroed hint can propagate up.

Add pghint_t *hints to alloc_hugetlb_folio_reserve() for the
memfd path.  Callers that do not need hints pass NULL.

No functional change yet: hints are threaded but not acted upon.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/hugetlb.h |  6 ++++--
 mm/hugetlb.c            | 29 ++++++++++++++++++++---------
 mm/memfd.c              |  2 +-
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..7311ad87add4 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -710,7 +710,8 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-					  nodemask_t *nmask, gfp_t gfp_mask);
+				nodemask_t *nmask, gfp_t gfp_mask,
+				pghint_t *hints);
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
@@ -1124,7 +1125,8 @@ static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask, gfp_t gfp_mask,
+			    pghint_t *hints)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d3..faa94a114fd4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1842,7 +1842,8 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 }
 
 static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
+		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry,
+		pghint_t *hints)
 {
 	struct folio *folio;
 	bool alloc_try_hard = true;
@@ -1859,7 +1860,8 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = (struct folio *)__alloc_frozen_pages_hints(gfp_mask, order,
+							  nid, nmask, hints);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
@@ -1888,11 +1890,14 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 
 static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+		nodemask_t *node_alloc_noretry, pghint_t *hints)
 {
 	struct folio *folio;
 	int order = huge_page_order(h);
 
+	if (hints)
+		*hints = 0;
+
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
@@ -1900,7 +1905,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
 	else
 		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
-						 node_alloc_noretry);
+						 node_alloc_noretry, hints);
 	if (folio)
 		init_new_hugetlb_folio(folio);
 	return folio;
@@ -1918,7 +1923,8 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 {
 	struct folio *folio;
 
-	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask,
+					      NULL, NULL);
 	if (folio)
 		hugetlb_vmemmap_optimize_folio(h, folio);
 	return folio;
@@ -1958,7 +1964,8 @@ static struct folio *alloc_pool_huge_folio(struct hstate *h,
 		struct folio *folio;
 
 		folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, node,
-					nodes_allowed, node_alloc_noretry);
+					nodes_allowed, node_alloc_noretry,
+					NULL);
 		if (folio)
 			return folio;
 	}
@@ -2231,10 +2238,13 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, pghint_t *hints)
 {
 	struct folio *folio;
 
+	if (hints)
+		*hints = (pghint_t)0;
+
 	spin_lock_irq(&hugetlb_lock);
 	if (!h->resv_huge_pages) {
 		spin_unlock_irq(&hugetlb_lock);
@@ -3434,13 +3444,14 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-					&node_states[N_MEMORY], NULL);
+					&node_states[N_MEMORY], NULL, NULL);
 			if (!folio && !list_empty(&folio_list) &&
 			    hugetlb_vmemmap_optimizable_size(h)) {
 				prep_and_add_allocated_folios(h, &folio_list);
 				INIT_LIST_HEAD(&folio_list);
 				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-						&node_states[N_MEMORY], NULL);
+						&node_states[N_MEMORY], NULL,
+						NULL);
 			}
 			if (!folio)
 				break;
diff --git a/mm/memfd.c b/mm/memfd.c
index 919c2a53eb96..f1c00600e19a 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -93,7 +93,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
-						    gfp_mask);
+						    gfp_mask, NULL);
 		if (folio) {
 			u32 hash;
 
-- 
MST


