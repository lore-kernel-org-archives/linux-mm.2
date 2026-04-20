Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E75F588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9F36B0092; Mon, 20 Apr 2026 08:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC18A6B0093; Mon, 20 Apr 2026 08:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38E56B0095; Mon, 20 Apr 2026 08:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 869496B0092
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2587B13BF3D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:44 +0000 (UTC)
X-FDA: 84678918408.13.380677D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id E8FB41A000C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c03A3tyo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689442; a=rsa-sha256;
	cv=none;
	b=u2KY2tT1ciWeKy5pXtKjVKDK2gZAiNHI1ZkjZ7ddFPcGj014Gl2/R8pQ8TKCNWGGvZ926S
	fpMlQcvyMz9WEUXF7afM0/g3zYn0eJW/ITonxWfbGbI0ss72cYqkFfSy+Ng/HgMFySHRkT
	sY16PioR5Wq4ftelZkINYgVhWtdRDSg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c03A3tyo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOqefyw2xfKGzGmt4FILCNloyRh5kydROPG1tzzp9Iw=;
	b=6RG465B3U4xSCX/adxDGOYDhU4mWs8+HpawXEyG9Xni6Zlv2xFpYs4LIXCW0QuO9RuTKBX
	WPoXohzTx0GH0+o2eiLrBkggpB1ENspbeYlXzWreIQ66k4L9Kg8HuYFOj/UATABlRFqpPF
	uN/B3JkV7JUKe1OhSeDu1liNTIU0Qbc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOqefyw2xfKGzGmt4FILCNloyRh5kydROPG1tzzp9Iw=;
	b=c03A3tyoc//Q9LfOERjuGnxPCIKtbLqMwxEk/V4mftT0g1u8269sIraSnekF5t1lpB0jTB
	6M4hoHuluSPtqjJ21OzmLVy2HrrswQke1Z3/6Y0JsFW4XNvGYwoeLsI8bDUyYNyROUmazY
	BJ3jf1bpAFM9JTYISy5Xu+89nIysCig=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-plwtTOwGOryAHnDiE-BTlw-1; Mon, 20 Apr 2026 08:50:40 -0400
X-MC-Unique: plwtTOwGOryAHnDiE-BTlw-1
X-Mimecast-MFC-AGG-ID: plwtTOwGOryAHnDiE-BTlw_1776689439
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43d7d0947aeso2269909f8f.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689439; x=1777294239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOqefyw2xfKGzGmt4FILCNloyRh5kydROPG1tzzp9Iw=;
        b=GTe2FutPrDLfYQSi35Y+2qsyYXERuee6UjNB6cGm8frgllb96AfgniUEFylySV9z30
         9Gm1PFfaS6QsS1TA5hrMWepo+4s0zuPk03CUfgs4gn9lPSLqv21iRKOP8IHE4WScee7K
         qPHhU4M6uWEyImckHwc4OSgxTMKilJTmyF1Hu201pjknZ9Eydy0x7VGAOOauZ4YN1+P7
         v15OREZkRxfnvTAo0ScxLatEOxh4qgp/i/ALBdIbo7gRiCEdZkAIct54x0ol+1gM9QhW
         r9Z89+JxDrKZf0RlAU82g3viSDJzBhxLgCXf56k7EFm1q6Ag91dWp7/lYu+irpPcGj4C
         uKBw==
X-Forwarded-Encrypted: i=1; AFNElJ9VujNP2NuvwhaJsM4LvvGJSdiaRsMDE1J02lyRIivdaRQ2mMqlR+4tfHvkvz8z1XeWjnWsuSwMug==@kvack.org
X-Gm-Message-State: AOJu0YxU9cJKxPt+VhO3/4qrjSxD/00D8AGDMLzu8y4Dpyy+kf3ppk9t
	/sA84BYY+dJYycKA+qZ44g70TdphJBcNIudVaVR0FGj4azJfm2ANQcgPkAhW46QfLr91pwBKLI8
	JZz/fUtbZVM4TUhA+2ndcYW1S0J0LvQBYi4tP4+YBMDjJIT2fMiOL
X-Gm-Gg: AeBDieuEbn1VBx5FAgzpp65N1RBI5j+C903cnXhUItjTSynXX3g7//auCIHK4+sufrR
	zsZz5Yy0rIq+m49+6Y7FLfV5/ZtrF8JAYO566jTRzzS8VJe8uB/Zgrf68nu+k+vx42V2+3kypf1
	kVN7jAR6xLoWIYvqINYY/m6OtYS0/cq8EY01ieEG8SfiXVSVHeNqQx14cqa7AHYKn8RZElQzlpy
	IxNL4bVln1mZ5dfbvg//mkvTVtylB8KNWMbBhn/mMWZGIDeLMUysgcesinI9hfN6Yum5j2YspdR
	Ygt5PmvH8RRDFEZzQbIhGfw8CyTP7GCqZtTX/NqSHgMeqyRN5PwtIYZ04VKbzVhixJ2ijs+vVKW
	JrWKzf0zX35tY1Id/EpDSg4VFlJvSDB1cubGY99ueeAEXzCn5wtM0DQ==
X-Received: by 2002:a05:6000:40dc:b0:43d:7b7b:ab77 with SMTP id ffacd0b85a97d-43fe3dcbbeamr19710753f8f.11.1776689438733;
        Mon, 20 Apr 2026 05:50:38 -0700 (PDT)
X-Received: by 2002:a05:6000:40dc:b0:43d:7b7b:ab77 with SMTP id ffacd0b85a97d-43fe3dcbbeamr19710690f8f.11.1776689437905;
        Mon, 20 Apr 2026 05:50:37 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1249sm25931964f8f.5.2026.04.20.05.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:37 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:35 -0400
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
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v2 06/18] mm: page_alloc: thread pghint_t through
 get_page_from_freelist
Message-ID: <e4aaa5244f129a0a057b190ff65b87526a1f7c8c.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VvKOJEL3u5ZmkL7wftkXfwVCF1ftvwb9yNg5Yj8glZY_1776689439
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: E8FB41A000C
X-Rspamd-Server: rspam12
X-Stat-Signature: zge61r8nngorsjb5h9qxzudy64ddirj4
X-Rspam-User: 
X-HE-Tag: 1776689441-360902
X-HE-Meta: U2FsdGVkX1892HNFrCExsuVEXNRF74M9jrimba0k1Akxp7jqqF2S2vjE9JZZinlx+Lbc/J36lm72xrKOv9SrUUBO68KfcS45pHasgmTnS7K28yumggeR2x/cH5fueOlmJL7YRvEkUzcuvNC4YAHN34fD80ZWqcZYJjD+eBoZAa0a1DBdmm75sto1HHGrBA2j5FAdn/PtEUVUtUSQMQzcw4mTfbX1M2LxSOMYWGlEESSMS5aapDFumO5FvPrj0imXgsR67as19kyyQl6KK9TvYqouFg05P34RDhmKcbNOBNp4OhSQ+7zMujxtSbwodFM/WENWBFqVs8aMLcIsUraAThunks/r/szpiomwqzyYcinpPi3JIX38OuIQV73oA/OCI9fAsvII9geY0x73vuO5+mu0lkxMTc9wZZQKvJYZrhF6h89yKNzSOyMeEepaqmYCw0JfQkzvjHByllIkGCDZI3vpro7K9y1StZEqYEIXtkeKcnShkg1WBhma6N9IX8jNSNgOkPsacRWPzo64XJVl6EkiTdXFkdmmC0wYT051ARpvgI4lCfUJ4YtUiWiuMyRsVzML3UoFaRikMVujOXH8pQ2KT+dM1MyUG2DmCA1y27GSJ9FQWDISYlNheXZuXpJg9nPR5oAvYWF9jXbOyJrDdeDnj8/4ucs1LGoAigdZU4X/x9afBB/FOTd7pQBdr6zEIMbdzLq5djAQVcXnY/n9VZHiK3n/18YpC80R8531Mtp0M8DZ/9FVkgX8k5eCcvZVywgp94RKIugJSRBzEiXiOqFDUEz5+Ve7R4nvKPXe8pl9/T/WqX5R9NiCO0rFrzOx6/To6GTAIGwSrjac40a0+TJsL6qV0v6PZn+3flF5WBm6OzyE/HR0TH8HebcS9EzEWQ6wx+7QeSM3GtElg74L+7cN4RtZLB3fLhHkA32eeYGimW+llfAeSVOz/q0AqmW58avvT13tuqON+zO73Pz
 9dPFYvYk
 xvcfhpiqFo/8I9ydhrE/7vRwSGtVntJhRi/PihY3O/YcreiUtiFak32I1ZBzEVyE4NP7WJ76WosLYmYCZDzPCP8PgWioh60h41vMhg85Zh2DJOmIey6ZkNR5J9DDpylpb/XZQ83cqT/hWyBGB0ciPJdbr4v4T3/bn8CysGPwcLuuiU+CO3hBj7wZ2FXVyXuNkEWcOU2iYNDpPgpophbCeo37uJNSakhlZ9dHK6VVDKBqOgCl0Bl6RckvxoMmfkQUGzF6oAXKLQMWKtXF+WyDPmVFpb3MGpXsqR+syYIZLrihHBCtq9JPO1aGqPXEM4l4nvQcRtv90l1jR+9Czqk/RX/QU4PtPta3dc7G0AnA5EBx6zYb3JBLL+e+iEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add pghint_t *hints to get_page_from_freelist() and pass it to
prep_new_page().  All internal callers except the main fast path
in __alloc_frozen_pages_hints_noprof() pass NULL.

The next patch uses this to return hints from
post_alloc_hook() to callers via __alloc_frozen_pages_hints().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b0971a1eaa73..ece61d02ea96 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2483,7 +2483,8 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 			continue;
 
 		page = get_page_from_free_area(area, fallback_mt);
-		page_del_and_expand(zone, page, order, current_order, fallback_mt);
+		page_del_and_expand(zone, page, order, current_order,
+				    fallback_mt);
 		trace_mm_page_alloc_extfrag(page, order, current_order,
 					    start_migratetype, fallback_mt);
 		return page;
@@ -3294,7 +3295,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * high-order atomic allocation in the future.
 			 */
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
-				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+				page = __rmqueue_smallest(zone, order,
+							  MIGRATE_HIGHATOMIC);
 
 			if (!page) {
 				spin_unlock_irqrestore(&zone->lock, flags);
@@ -3414,7 +3416,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 */
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp,
+				list);
 	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3451,7 +3454,7 @@ struct page *rmqueue(struct zone *preferred_zone,
 	}
 
 	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
-							migratetype);
+			     migratetype);
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
@@ -3835,7 +3838,7 @@ static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
  */
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
-						const struct alloc_context *ac)
+		       const struct alloc_context *ac, pghint_t *hints)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -4084,14 +4087,14 @@ __alloc_pages_cpuset_fallback(gfp_t gfp_mask, unsigned int order,
 	struct page *page;
 
 	page = get_page_from_freelist(gfp_mask, order,
-			alloc_flags|ALLOC_CPUSET, ac);
+			alloc_flags|ALLOC_CPUSET, ac, NULL);
 	/*
 	 * fallback to ignore cpuset restriction if our nodes
 	 * are depleted
 	 */
 	if (!page)
 		page = get_page_from_freelist(gfp_mask, order,
-				alloc_flags, ac);
+				alloc_flags, ac, NULL);
 	return page;
 }
 
@@ -4129,7 +4132,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	 */
 	page = get_page_from_freelist((gfp_mask | __GFP_HARDWALL) &
 				      ~__GFP_DIRECT_RECLAIM, order,
-				      ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
+				      ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac,
+				      NULL);
 	if (page)
 		goto out;
 
@@ -4227,7 +4231,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	/* Try get a page from the freelist if available */
 	if (!page)
-		page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
+		page = get_page_from_freelist(gfp_mask, order, alloc_flags,
+					     ac, NULL);
 
 	if (page) {
 		struct zone *zone = page_zone(page);
@@ -4477,7 +4482,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 		goto out;
 
 retry:
-	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
+	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac,
+				     NULL);
 
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
@@ -4831,7 +4837,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * The adjusted alloc_flags might result in immediate success, so try
 	 * that first
 	 */
-	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
+	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac,
+				     NULL);
 	if (page)
 		goto got_pg;
 
@@ -5249,7 +5256,7 @@ struct page *__alloc_frozen_pages_hints_noprof(gfp_t gfp, unsigned int order,
 	struct alloc_context ac = { };
 
 	if (hints)
-		*hints = (pghint_t)0;
+		*hints = 0;
 
 	/*
 	 * There are several places where we assume that the order value is sane
@@ -5279,7 +5286,8 @@ struct page *__alloc_frozen_pages_hints_noprof(gfp_t gfp, unsigned int order,
 	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
 
 	/* First allocation attempt */
-	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
+	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac,
+				     hints);
 	if (likely(page))
 		goto out;
 
@@ -7855,7 +7863,8 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 * Best effort allocation from percpu free list.
 	 * If it's empty attempt to spin_trylock zone->lock.
 	 */
-	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
+	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac,
+				     NULL);
 
 	/* Unlike regular alloc_pages() there is no __alloc_pages_slowpath(). */
 
-- 
MST


