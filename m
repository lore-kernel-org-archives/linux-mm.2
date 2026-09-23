Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A506CC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44006B0096; Wed, 23 Sep 2026 17:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4E56B0098; Wed, 23 Sep 2026 17:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD196B0099; Wed, 23 Sep 2026 17:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6944A6B0096
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:10:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2715C0114
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:56 +0000 (UTC)
X-FDA: 85246271712.06.7ACB1D4
Received: from mail-qk2-f36.google.com (mail-qk2-f36.google.com [74.125.230.228])
	by imf01.hostedemail.com (Postfix) with ESMTP id 876754000D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UvbzqdfT;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.228 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790197854;
	b=x6vAlhM5A2Am/LgOdjePEk3464+7soHPFa+38cDbFsYTnPNCgleWRFoMXIxlc8lHgvMxLt
	WDkQ90+pkC8kc4chkN+3Lpje7qRcsN96lC76LfhFxttCFz9V7t5SA+Il9JBo4SAqVG6NuM
	cLK+o3k4r1w+9rVscT67Vob69sl2axM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UvbzqdfT;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.228 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790197854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z68SIWaMimWKPBbcPzrXpDhBMBPzNt9VtEr/ioTExD4=;
	b=DP6cbqWKcYdcVpJ9YCl4eanZ8Xj65BCfX71HKaSZLKqqV5oSIDBIS7lyP0uebZ7VH5lhXH
	MKdtNma7qp1poRrv3HQMcdMEV66Byjp/dMsgHIqbyRs5u7HcQoknz5EG2XTzOcbk1VTrBa
	oSg4tNmzg5ghbscgW10KHrj4eZ4KDjU=
Received: by mail-qk2-f36.google.com with SMTP id af79cd13be357-93910cadeb7so131341685a.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790197854; x=1790802654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z68SIWaMimWKPBbcPzrXpDhBMBPzNt9VtEr/ioTExD4=;
        b=UvbzqdfTZboapOOn9xXHwrkRR9P3UeaXwQ5tS6Nt8s4TTAOEBmpiVijtETeyKy1e6b
         Bi0lNjvztCbapIIFPRh+yOYE9S01m27FZc6IC3V8xVt7TesUK+uo+lFrIKlrQdrXYNj4
         gjENME/eijjNYm/IJCtHCN6D1rpw3j17ONnVfy3VZPsbk1FTg9X0WZClF3dCO2eDAIvb
         dvxQCwHfo6Tma2MB3GR1Nsud50Upj3I6LwoZLfblqSAfeXYqtb/tW8rjwHL/95ksmWPU
         9HaeFHzWdsWZ0A2MPzubf6cZxJby8j7EEZiT/xnJk8Pqbdcn2FvVfoHlzlxtT9jTSaVu
         LBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197854; x=1790802654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z68SIWaMimWKPBbcPzrXpDhBMBPzNt9VtEr/ioTExD4=;
        b=DOg8Ed2dVyN1eI5zCYpsjSpMQtl8O4I2R7IR03FvVhjIfCZ72I4oYN2UhXHH90GJf7
         6rclPa1gzz7CshRB7urL4RIgHIZPSQpNHDN6fUSixSG7OBui5NM+9F9xaGry9SNK+LxR
         Wk1GPvN3cWZ76BHXpg5o8U2pYYgRPhTSqIQmtKnyGCtSWW8gwusZdFRr72oxZD5rlhEy
         pjKiCFlYYrjrtsWXl5vzo562p6g3OS8IqJPxYazk1WoNGCjlOZijotmEwYU9eF+IXlw/
         JTJ3Lu94irzDwnCm0tJH+NhSKsabhm9uQ/Ab9lOXaXjZgoJLmCzm8cHvWRe+T8ZXixpS
         r8BA==
X-Gm-Message-State: AFuF++nq2y8bVXBQaJiTAAmPYOblyPIPcFD4nguz7IjDmfiZETzfTtzq
	jsyGP0JSKOzzj5ZnBayLuxJtuGM9Zi5TJGADsk27QVYsSX9L/qB4AOg8wvKn/4chT9+BldPmLPa
	9OXj5eWw=
X-Gm-Gg: AYBFou2HPc4evqVlia3A0UkFVK/nOzI2++qSbJYAdEl/QYC1WV70L3LKdCnHg20NhMY
	Xir4MBjrdV3HQQ7CuHzj8TASjICOCwDoEh66MG8Rtp5ne1mIfuvfXpMJcAKEvVacvBihKf1NwHW
	XVGF4xOlHEPuVq76h0+9zXk/Wf8nUGCYph0ey4Andj6OuOIL4hX6GluZGnzMgnHLw+g/3IwJKfS
	1+C7SAGcaWizo9/UGq1V/wSVrbjKfoZGJC0rw1A7pu5lObzkPiFrT78tq6MhQyIH/f2bUj7ed+i
	umHKA06WNHmCFfE9gFd29aLewDpSacD/yszidy2WCuoalF0zviyhaaPiIDFyl6olsLapk7Ot6H/
	u3geTjL+GQevoL6iRZOp6E/r66D9ebVXbf7nq/inOwJJqoRZ5LP/2I4QSudZb0+wPjKAeI3dUhp
	9tfEDjsR9AHI6VEYLXSmEl3ilPStzzAUv+cLH6Rvcvjtit4OQcru4vYSa+2CdHFrGR4XVa6Z5zn
	CPctUe5GK/xnmXTpTsFlnRhi4lFwOWpdJrxLnxwNQDClcF8PLas2eGCvP3n
X-Received: by 2002:a05:620a:25ce:b0:93b:d79a:c464 with SMTP id af79cd13be357-93c3480c8famr61505485a.60.1790197853636;
        Wed, 23 Sep 2026 14:10:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2485926esm305893085a.19.2026.09.23.14.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:10:53 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org
Subject: [RFC PATCH 6/6] mm/page_alloc: let the bulk allocator carry alloc_flags
Date: Wed, 23 Sep 2026 17:10:40 -0400
Message-ID: <20260923211041.3127588-7-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923211041.3127588-1-gourry@gourry.net>
References: <20260923211041.3127588-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: m466ptjzaoxzp4j4jemt6nxbouxof9q4
X-Rspam-User: 
X-Rspamd-Queue-Id: 876754000D
X-HE-Tag: 1790197854-398806
X-HE-Meta: U2FsdGVkX19emkWzw+E9QDI4JUeBF6zxbPb6Vk/XhqEuxYA/WkVYUKH18fWKJCUXYdDPWojkm+lfijV73uegX6Bl4JRkUZ8+z4YjJJXfWpL1sia+6/2vnmgTB3Y4kDkeBMwSy/qFoUiZO6MzxSNEh/NJGk4vTiSYcMdR4vjcLCSISUjmjS9pYBz9mCT7ZTe+k2lK5AOWPmphDnOIeQJo9znF9NA/O6AaT/RGGoyD8qJaNbUMWzGTBpONKYLnB4cm6VAj8jjpHaKx6hAE/X/COQ2FPkI8pH+e4TEcHv9txcisoTR1Wf7RhnKdG9fHapBwc9BvDOZr9tAp1svSq/cd7HHabsaRMiIEkgzA4k3va8yGe+mvqghn8yGANB1JgLhW+VQsr7KSWoFX8g+gAfOMR/jWP8rjZICG5Agrk+TjXzz+ovCZQocLJSSXGn62tAGn0VA+DzK/JPWOhLyH6TRvdk+jukrovGWOinMPJu6qy9Ei8FUcEx9F69FVka80Yolp+Lkrh0Rq4AanPtXc/b7PVmFrmUS7PpV9SFs33tVeifwCO5pkmH0wH9i6laxl/y4QTAJRzylqWGh4gxAuw/Q9mTqiDIkesi11LP2jDsh6Bj44cpd3xYClNJpLJ93B79KHKqZNw+Yr53PRfTa+ex8mdILXEM2HWIks2oXJIeBfBmFcwoiMlk2NeeentXmAhSquRdKp5bA1+9rhRp4NkPXfaIeYQbTIcI/WLxN6eAeB/tZ7VPmMQjZev4v99oyRZ6PZytgp/bEVD9WEVdWEzL2WQsaRwm4PtE9tgCRJuO266BvMDgfIl7mrZvW6TEhFTlZNrdD9jOXCHjBuXZbJVnuSBB3+jztGlYPZkLwDJL+WZp2OLvqKntELocZibJVjUXssOzAuwDmb/2C5HVeLDXwCB5VzH/Y2BKhSRuu9fXfxYor4c8kMhIyVIvnU5xmaP3isPvs1E0XNcvTUxk5BCN+
 T+JB62ji
 mVKoi/lmORfBMawblcgJDAt/6A0V5R0SNI2dh00lwcpEFp6YJyygPP4gPJ2ipo6411I14hofzQ4miLFIf/mEth3ksBWHty3UfWEjXxi2ONHf8bBS+tkulDXkRGD6h8iQT8yfan2hL+Rajm17O7YSBlTwJH1OmbMdbYO0/C+A1Jo7tQQgIA8ROG6Bhjya3fY+UqGoQ7a9ybXNbCuApcha4NQXzHEjGVE9aNpGguepuSsey2hH+otWnLW8YVJwqMm8qNSJoztefQpiTEKnsTMlkWaIE99uo5SfszU+mxKrd3p80/+p6OljOA4x8ecPMuQmKGEpz2WSceDzcXXCC85Zni6/O6DPZ2hUva2sWcfZn6VCqR3O+gEkwXva7M1YUk17ysuuwM5Gw953OIPG1LK6JCBCbhEKZrYXYNnhaxcEI5VT+joQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__alloc_pages_noprof() accepts explicit allocator behavior flags, but the
bulk allocator does not. Internal callers therefore cannot select those
behaviors through the bulk interface.

Add __alloc_pages_bulk_noprof() for flag-carrying MM callers. Keep
alloc_pages_bulk_noprof() as a flag-free wrapper passing ALLOC_DEFAULT, so
existing callers and the exported interface remain unchanged.

Preserve the original GFP mask for the single-page fallback so it repeats
flag preparation from the caller inputs, and pass the prepared fast-path
flags to prep_new_page().

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 28 +++++++++++++++++++---------
 mm/page_alloc.h |  4 ++++
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index feb9c64efd84..8fa2522ef418 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5219,6 +5219,7 @@ static __always_inline bool prepare_alloc_flags(gfp_t *gfp, unsigned int order,
 /*
  * __alloc_pages_bulk - Allocate a number of order-0 pages to an array
  * @gfp: GFP flags for the allocation
+ * @alloc_flags: Allocation behavior flags
  * @preferred_nid: The preferred NUMA node ID to allocate from
  * @nodemask: Set of nodes to allocate from, may be NULL
  * @nr_pages: The number of pages desired in the array
@@ -5237,15 +5238,16 @@ static __always_inline bool prepare_alloc_flags(gfp_t *gfp, unsigned int order,
  * @page_array were set to %NULL on entry, the slots from 0 to the return value
  * - 1 will be filled.
  */
-unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
-			nodemask_t *nodemask, int nr_pages,
-			struct page **page_array)
+unsigned long __alloc_pages_bulk_noprof(gfp_t gfp, unsigned int alloc_flags,
+		int preferred_nid, nodemask_t *nodemask, int nr_pages,
+		struct page **page_array)
 {
 	struct page *page;
 	struct zone *zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
+	gfp_t orig_gfp = gfp;
 	struct alloc_context ac;
 	unsigned int fastpath_alloc_flags;
 	int nr_populated = 0, nr_account = 0;
@@ -5285,7 +5287,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 #endif
 
-	if (!prepare_alloc_flags(&gfp, 0, ALLOC_DEFAULT, &ac.alloc_flags,
+	if (!prepare_alloc_flags(&gfp, 0, alloc_flags, &ac.alloc_flags,
 				 &fastpath_alloc_flags))
 		goto out;
 
@@ -5296,7 +5298,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 				 &fastpath_alloc_flags))
 		goto out;
 
-	/* Find an allowed local zone that meets the low watermark. */
+	/* Find an allowed local zone that meets the required watermark. */
 	z = ac.preferred_zoneref;
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
@@ -5332,8 +5334,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	}
 
 	/*
-	 * If there are no allowed local zones that meets the watermarks then
-	 * try to allocate a single page and reclaim if necessary.
+	 * If there are no allowed local zones that meet the watermarks, try the
+	 * single-page allocator.
 	 */
 	if (unlikely(!zone))
 		goto failed;
@@ -5366,7 +5368,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
+		prep_new_page(page, 0, gfp, fastpath_alloc_flags);
 		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
 		kmsan_alloc_page(page, 0, gfp & ~__GFP_RECLAIM);
 		set_page_refcounted(page);
@@ -5382,11 +5384,19 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	return nr_populated;
 
 failed:
-	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DEFAULT);
+	page = __alloc_pages_noprof(orig_gfp, 0, preferred_nid, nodemask,
+				    alloc_flags);
 	if (page)
 		page_array[nr_populated++] = page;
 	goto out;
 }
+
+unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
+		nodemask_t *nodemask, int nr_pages, struct page **page_array)
+{
+	return __alloc_pages_bulk_noprof(gfp, ALLOC_DEFAULT, preferred_nid,
+					 nodemask, nr_pages, page_array);
+}
 EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
 
 /*
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 986e733b586e..a09bfd201c3b 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -264,6 +264,10 @@ struct folio *__folio_alloc_flags_noprof(gfp_t gfp, unsigned int order,
 #define __folio_alloc_flags(...) \
 	alloc_hooks(__folio_alloc_flags_noprof(__VA_ARGS__))
 
+unsigned long __alloc_pages_bulk_noprof(gfp_t gfp, unsigned int alloc_flags,
+		int preferred_nid, nodemask_t *nodemask, int nr_pages,
+		struct page **page_array);
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
-- 
2.55.0


