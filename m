Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38123606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=glo6CCoX
Received: by kanga.kvack.org (Postfix)
	id C99A06B06C7; Fri, 13 Nov 2026 06:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFBBF6B06C9; Fri, 13 Nov 2026 06:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9CA6B06CA; Fri, 13 Nov 2026 06:07:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8166B06C7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:07:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 106C9A07D9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:07:45 +0000 (UTC)
X-FDA: 85429820490.27.02EFDDC
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf28.hostedemail.com (Postfix) with ESMTP id D3EEAC0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:07:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=glo6CCoX;
	spf=pass (imf28.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794568063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+aU29i4FlpG4VRqfKhEXxht3GqiB5XRyTtEVnMa3xQ=;
	b=PQmtibb+LWRc0VGmGVwv8kaAPlhS+JE2SGilRTOcIA8qllK5zkaMqhIF4Vqoy/1u1mvZyf
	VfAK1nrek4plPmKe3/Bn4/sECsjNCzgZ86dsPfZ9iNZzEcVnrcKeNBnWVhOOy1kAC2mReu
	ptvMKSVWC/eacC3R+lx+C+8Oyoq26D8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794568063;
	b=q5QPobHZ4QNVTX3yK7NY6BgNXhWhOnEgyfHSU/WztidTP5dDiW25v4RoVO58yspCH0a5mY
	DiFnqx/4tIB3wBBtnX9DorMkADccz5ENpVvSndcYZXpoVYEHOkPE54j2ON+l5V3QxRqwrV
	COg1k6zY7rKpZCPriEQGCjaQHY9o39g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=glo6CCoX;
	spf=pass (imf28.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794568062; x=1826104062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r+aU29i4FlpG4VRqfKhEXxht3GqiB5XRyTtEVnMa3xQ=;
  b=glo6CCoXat2Q8ZlhmamP/LArbsbwtjVcypD/zfADRjp6qTicbGTnjr46
   +2mCSE3XXSwTSBUngYmve5Dcj+R6MMRr8oRiPtm5po9xJFEmOcev7wl1D
   H9RlDcPMC4aN1+xNNQv7maIsppKWgrUaz9uGNJRKLioMDR2Dt6MddzET4
   lxhVroShl9ZRXDWvEyrBAg6EYCf484clGfHB9JA7Vj+GZVWmXzzeBbrhR
   gvJnyLLmJijxurzQ/cyULbYB+nlkGPOa3za5mjJhKT/87wh9tj9ejh+Bq
   +tJrTLe8XsAmjEoKv+S32gq6us46ZKDjiN0LBZ06Ky30zRQx84fBshrz0
   w==;
X-CSE-ConnectionGUID: XoRZ7hh9RGCqXQi572LSoQ==
X-CSE-MsgGUID: pw7v+ddOSc2Q4mIID5Vwyg==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33792839"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:07:39 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:29456]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.127:2525] with esmtp (Farcaster)
 id d921e8d7-8a7b-4495-8483-58be71fbed47; Fri, 13 Nov 2026 11:07:39 +0000 (UTC)
X-Farcaster-Flow-ID: d921e8d7-8a7b-4495-8483-58be71fbed47
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:07:38 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:07:37 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.6.y 2/3] mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
Date: Fri, 13 Nov 2026 11:07:23 +0000
Message-ID: <20261113110724.2920455-3-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110724.2920455-1-dipiets@amazon.it>
References: <20261113110724.2920455-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: acfo7skr1nx34u4g3gzyd7pequ13o6k7
X-Rspamd-Queue-Id: D3EEAC0003
X-Rspam-User: 
X-HE-Tag: 1794568062-891943
X-HE-Meta: U2FsdGVkX1+k9W1lXrDvYl2alS5vprzwqb5ke6AkBgzrtoaGF2Ko1SxaMn3Vf8sS72xdhKOx+ABdps9eQFSsM6cEdBeFXp2doiJSaDn7JG2SH31I0Wv/Ad+6oJL4M1eYdIrQiLAhnGuNmxj+RAZge5+XHwe9knPQM4eQEpPba9O394wKTKS/BwnGABrpNjgFMuxGoj4+HdvrzUf3T0hMPHmxkh/cijnTjpyX54jkcZ7EHNwM/pHexP/IJ5v39y+7Iyii4kYbyo9IbgAEuXqilSwr0FQo0BpZBUNZuJtu5kGfxTAp1oYx5iT25/TWd35O88oa3nsHQuE73R/XYwr0pTNU0SvcBwYFjU0YtcpQiGbf8vZ6jXSkcptnygGA9FGm/thJKfwjQytx8LnKjeQl6t+Z2aElLhGovS31ZSWXOXqF+EcF1a7ntF8YXkobcDdRvF1z0mD0Xp/r22FiactiEOB+YKgYNT885nN6Kek2FpeQP6VPMq+ky4y9T41UbtH2RfARVAzViEylCKn+b95jz2KmagdqQMegW/bExIvga8fiBcXEcSlFw3slnV5vLIT1JbiMrVk+Y0BbWVq4KEsaFBiWo8hcFgQ7CgZBgPliGmNQrBr+h4oI1LZIT44z7VYGpNM0hfaWE37gPBqXg37XJh+v2jR/Z/njztsr9byXv3pVxdLu6pkjcXCfzAcMzGdiA4Iv7dbcL2377lCDStlmtEIXILxj2PeHbtHLEuS34/lcl4NSiXErt6ITAGRtjnYuTHDgbdENEECYAAYKW+5f6vlTVhQ/K8yKmx01s6zzgA51F+jv/X03dMNtnImEJf0MXMvotlCYn8KsvjxYhnAYJ6O3purTA9V4mxFRTR5C5gGFB+zbrI9aRBEnUUWQRzGb2Eja/DvYfrDerl1OwEMXAPa4STIix6xNwRGRUA19/exe/PD6XK6bPn018GI0QZNZ8UGQ3mhCDK/SoBiGR7t
 y7EaeNJz
 b4l7aiIIz/aUsluNJn6uWCm2IMhF0G7Z91AN5vObA16GnMFvSLiQgG282T0zKegCHtIPwMB1mhZ3liTCUZ2mwL7S1s/nCBRjA/kSYeR8FyvaDn0++s0d58Or7wBX0xj+eBsxpQ2o87QRuPKrCWZza22KWQDc0zbiItUrSHCrJXEldNRMeDE8bcKsB4U0s2LMLUZOZhj7odrOW52CyrTdUnxkrBNLHm/icBq3eua+J9wej5977ezplxHwMiIKwtV65EJqJvxRcD9x8BSfnj5l4DSMUkAtWjwJ+lm1zyCmY3YOHzzk+mgN7aLAhAsadu1BMN7ILlEpS9EC0Zmud4lYTNG7VxHrGAJVJoS9zzS6kdOXlwQIxcz0HQCvz0JmLt3UHBJxJ5cIcSCFnwu3neGvkpEj8q+lsuRjVcuib9FEELGYXjwBYPyRCT9pWe5RKXKIwxFrVbSbLxmVYrEZShN+Rp/Dpn9bLxsZEzhxd9AyJMytYHxZDCDqumrsO94Nhis8sR634wPxJ7vZWDiLZAUNbIHCMB2JVeA40BUAmU0sugZ0/P4NWxUDxzHarI9jku73p62UXTGibU0OVHousSE9933L8Dyu+w0ZZzWIFc7kqjGj8D+MOgik92ehwnTksVWVi0T3vbJ/bsAEj2WgUc+krPQqkalVgbbc2KTlXXp8yBy6I48g77DDfnwenz4xExUtZGlf9RfOFEHA7KvjcsOzG5VuocE962i9HDu48m0aKI/K23yw3SVy3bkNgX1phJw0PXRDCKHjkYiwmGXAJC4RJ7jo8G8QXqlkNPydm3acLRr9CeedDQ2cR/oIsxMheISrdBAqCT9ailCT2eENqa75wDGd+0NhJcgEy4hWzCXRUE1ibpERJbcreLznwGXw7OHWLYvL7dZSxdz3m7BVBHXwe/Nrx1YFaoW62oJbssUpQ5fvl6zD5ydWcxwKa+WoXV+SgsotAxSKilknKzYsxtIGItbL6CaWx
 tnQCfSga
 TfTRx/Ws7YX+6j6+kPpk4BfpBxEZfugtmC2+IUbx6tLaaHgGqDtNlk4KglfcDaRFM/nojVp+bvE3JYouwfGluQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit fe21f930d1e64d121191673076fc4ebe79fc82d5 ]

1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
non-blocking allocations accesses reserves") stopped handing out reserve
access for ALLOC_NON_BLOCK on its own: the extra 25% below the min
watermark is now only granted on top of ALLOC_MIN_RESERVE.  But the flag
was left in ALLOC_RESERVES, which produces something odd:

With the ALLOC_RESERVES match, __zone_watermark_unusable_free() doesn't
subtract the free highatomic pages for them.  So in the slowpath, they get
to consume regular blocks below the min watermark by the number of free
highatomic pages.  The highatomic reserve is capped at 1% of the zone,
which on any decently sized machine is a multiple of the min watermark:
GFP_NOWAIT can drain regular memory to zero.

The user-visible result is brutal hiccups during bursts of GFP_NOWAIT
allocations under memory pressure.  This was found in review and
reproduced with a synthetic burst, not observed in production, but the
sequence of events is a realistic one: On a 32G box with an anonymous
working set, swap, and a filled 290M highatomic reserve, a GFP_NOWAIT
burst drove regular free memory in the 28G Normal zone (min=60M) to 28M,
0.8M and 0.6M in three runs.  Swapout failed to allocate its swap table,
reclaim scanned 13M pages to reclaim 200k, page faults stalled for tens to
hundreds of milliseconds.  The machine survives it, but not by design:
direct reclaimers eventually fail and start unreserving highatomic blocks,
until the allocation succeeds or the reserve is gone and the OOM killer
runs.  That reserve exists for high-order atomic allocations; here it is
destroyed to bail out a GFP_NOWAIT consumer that was never entitled to the
memory.

Remove ALLOC_NON_BLOCK from ALLOC_RESERVES.  With that, the GFP_NOWAIT
burst is stopped short at the min watermark.  No direct reclaim, no
stalls, no failed allocations, and the highatomic reserve stays intact for
the requests it exists for.

__zone_watermark_ok() is unaffected, since everything it keys on
ALLOC_NON_BLOCK is already nested under ALLOC_MIN_RESERVE.  Update the
flag comments accordingly: ALLOC_NON_BLOCK just means the caller can't
block; the reserve math belongs with ALLOC_MIN_RESERVE.

GFP_ATOMIC order-0 requests have a milder version of the same problem.
Through ALLOC_MIN_RESERVE they also count the free highatomic pages in
their watermark check, but rmqueue_buddy() serves them regular pages first
and only falls back to the reserve once those are gone.  They can still
push regular free memory to 37.5% of min minus the free highatomic pages
before the reserve is touched.  Unlike GFP_NOWAIT they are entitled to the
reserve, so this needs the watermark check and the freelist order reworked
together, and is left to a separate patch.

Link: https://lore.kernel.org/20261028171719.2043421-3-hannes@cmpxchg.org
Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
[ Salvatore: backport to 6.6.y: mm/page_alloc.h does not exist in this
  tree, the ALLOC_* flags live in mm/internal.h. No code changes. ]
---
 mm/internal.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index ec8868828989..6c8d3a0f67da 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -897,12 +897,11 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_OOM		ALLOC_NO_WATERMARKS
 #endif
 
-#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
-				       * to 25% of the min watermark or
-				       * 62.5% if __GFP_HIGH is set.
-				       */
+#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. */
 #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
-				       * of the min watermark.
+				       * of the min watermark, or 62.5% if
+				       * the caller cannot block either
+				       * (ALLOC_NON_BLOCK).
 				       */
 #define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
 #define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
@@ -915,7 +914,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 /* Flags that mean GFP_ATOMIC */
 #define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




