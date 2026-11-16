Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68164606A897
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=cOwex8nE
Received: by kanga.kvack.org (Postfix)
	id C977D6B0601; Mon, 16 Nov 2026 06:22:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C1E6B0603; Mon, 16 Nov 2026 06:22:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5966B0607; Mon, 16 Nov 2026 06:22:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73F456B0601
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:22:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0707D1A0908
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:22:04 +0000 (UTC)
X-FDA: 85440742968.29.AF10932
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf28.hostedemail.com (Postfix) with ESMTP id C2915C0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:22:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=cOwex8nE;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf28.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/j3n71nMvjpVJ76o5ra7tyojZrZYI/2MTP7C4zA5JAQ=;
	b=mz0VHGUi32e9SxU/OsSb/FNhVlNKN7Mz3Xl/G5xxYRsKlpMcCWT32MWBuAUi2CIgS0dk+5
	ii2hXV9N3D9o4cIx/Q736nNge2LrVzChJ+4QweQhopvBb3xn5DAKWnqNreoppW+4fe4+kH
	Gzd/9sMOV8VfAV6HGIoXjMiKadg3auU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=cOwex8nE;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf28.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828122;
	b=GsS7Dl+0qEVmDJG3uKouKz2I/1klWZYERbzpfrogorbfMFvwN+8N7owJDak7nTch57to27
	cPqPOQVaOwtcN1RVUK8arUp5KQ++AVlDlLEJVprrDVvwvDqBz1evGmAX5QEDE9/a7e4a8Q
	lw9HX2MJf2adQN9up1qG/my8Pkn0jPY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794828121; x=1826364121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/j3n71nMvjpVJ76o5ra7tyojZrZYI/2MTP7C4zA5JAQ=;
  b=cOwex8nE4F1pKE9D8l9jaKLCbk6IXqV9kkRWO+nzNS37ZS3QMguzjMqs
   yegG2bkXSEXhkIEoiQ1Qq65faQxjoopPY8TO21rfZ3VU7E1U61ZP4YleV
   wyUiPZO3N0vIJf8i6rsNuTSQtnZ/CpvYs7INsD2fHg1KXqwngzDsJm5sJ
   yv7kXi8npl9cS52TkU99r/5/RyIVAmRZytb0tEL5r8zfOOlgFrS9M/7GH
   Hs/yBr3uUcN+3aOnUcnNiSSt5W9GaOHYcQAwq4BNxeE+fVt+AsPe6mwXn
   ZDwXUUYPDkfefyMtpwj+PCnKAQdmEeouyGpgTjEUvw4v7/0HmH6WCc2SK
   A==;
X-CSE-ConnectionGUID: J45JDIBVSr68Nm1foogNJg==
X-CSE-MsgGUID: hCkwUz47RrCTbMBcYKs+NQ==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34193208"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 11:21:56 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:22710]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.141:2525] with esmtp (Farcaster)
 id 94b71232-b214-4a4c-93ea-dfd3ae7d78bc; Mon, 16 Nov 2026 11:21:56 +0000 (UTC)
X-Farcaster-Flow-ID: 94b71232-b214-4a4c-93ea-dfd3ae7d78bc
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 11:21:56 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 11:21:54 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.12.y v2 1/2] mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
Date: Mon, 16 Nov 2026 11:21:41 +0000
Message-ID: <20261116112142.3813013-2-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261116112142.3813013-1-dipiets@amazon.it>
References: <20261113110611.2915381-1-dipiets@amazon.it>
 <20261116112142.3813013-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C2915C0003
X-Stat-Signature: yw1x5zcqj91uw1o35dtai8tksepsuai8
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794828121-171672
X-HE-Meta: U2FsdGVkX18Fmk8OMVLj6qflqUa/cT6wWNAPyMHQGLxda6wn4DtRLjVeXlrEvwJekoKcCsjqhwaHwcIJnsA04iUSGWccqXPEpF7ofgaDdMQpc4Qd2Q2Ci3RKuEBGZK7rlMnwM8UnolXROCLyo47eo1a7ONa8wX6TLnV5F9OjRT3/tNhjOXjIi35sSKm3og8FO/b/E4Qgc228v69sWti0OYpYza+cMU34fUUDTS5w+4mxozoOosuWm01iya0iZ9qRg+41azvBM4BFXkLHcqSHtVpTU0GuOyyl1w3cf7yLm1lAhHORxcte9B2ElttRGutj3ugFQiZGKjnCzq9BQ+bFsb53dPJCfxSEjGSCCRova4IbNkMFfcUFUh+A2eCmw41qdxcnBRHoEfrPyRgZgdtTPltaUgPthhrnyvHGG+QT9K99+dqDOaojKjVJEcUZ4WJsrXda8F5HRtHGjR7/qxV+my4oB7/P74N2e6s/134waDuW1ld/g/25SSGPSGGUEPSfKNg5mnplEH/juhniyZhfo+gFicn2AV+hGa6CXVHq7ccmtXQi3qR/jaaSCFNq9+MF1nZaLIL66JkqOsc1GDi8OsubpPVnmI9v1E/1lBoRjwCLIWKXJMicDO/2BMJ6Uiu5kLl2yDCNDGrPl11UG4pRDmFh+qmOf8dDDgcX/ZOH0n+J7xcn0kKttw7oIKoY3YDJ9INPe/NyIrMWm23qywugPKnBsGxZTnvjhP6ujM50DVfiQw7q7uvb/mvjVDr1AdH7kLquTfPGLDwS09kcjYMUY7Mr2K7Pkfaxv+GCqzinFdMkaQPuyUMADUf/aSWbcTJ0LjCUlIJrtxS4kWa/cRuNW8NeFlRinfvsm8lVR/58WSlQIWHRB9NVF5Dz+0yN0W0MX7CpIAYwOfP96J1XVUH4OqNae52BMOto+8edi+XQTFoffOcCcskINCxjNJvhMLG/cQuvtPThPosG7oh5zqK
 qobcB9uX
 WHAap38S4RqFRHNcNHr7GyzJP4EDwjE6KpBQv4f4Rb+1dEXow4Xo5nDgWv2WG0dc6C/85rTIncA40N5L1uqOAyQPEZ/duv22AhdOy8K9C4MRBUMaTODeCQ/3q0UqIwBdR3nXOEyQu54o2Zw4mf0tLxLYWTc4Q+e4WlmZqbhVAKmXUEIXg7BFSpSQLro9XJpWOk/SdyqGpOvasr6LEBMaIou7/oTcefIJ4Afe9HxmdWTdX+S3MFsKOCCGMrAGukvXa77rMIzRMKSR5/6Doxqc1aMmqiWCYU/zajlcObc1ZxOVbNjG2g313cSWBF1WgpzVK9/pFVmJNxNsPBpCVVcFJDT6TIVwcUqxt621h5ZgEk9wKr42wu9TLxK+N8Xj+C8M5CwQx4b/zA01Up1kIftVcSfNR5v1smNw7hjHnbLJZYu4pyGKD9p8w35NJScit1Os2HyLfbsGe3Wemxdbapv2UKl7OCLvHI9g9BkuSI14csx3oLQYa1XwjefLJY/QGJ80HXd8CoLmC7kRGxq0LyOz+tHXShNeAXjAuVIAC+ioPszqFTP9pHD9UYLHLQ5vzuA7VBrZZNiDpXZdv+LLh5+5TG/K934E0T3JyzIqdhSsO7PRA868uEipLUtOAXs80IqI69B0KTyv/trrYS1ugxKU5vc36C4mtcEDTvSd8XQmWzuFWozKm5NjmQxZ1bCsfRrrVZCG0o70FbAqL4/B+Y/V2lcQtTxzDrOu4CfAt7Ocappiqf6hgunvXSgrC4VMfYxuqJMWx6wdpIPqCFIju4mS5+Btfg7VnrTymB2HbDGRLpIMF23r50S42AVeNMdaTPJiy32Enab+N0DQkvN/TBUSyvXZXH7ctYQlWAmS2maFvX779nHbxSUVBoGP2SIuzHxrfezSBjRu7v5mD29YouN7zNhzFgeBg6Ayo2wmrbeo2Y89Gdie4UobNCTJuYXFzHCbuRuFy9ol6FJ5PU+vfZtmbva2+vtaM
 aew2yAFP
 zeWYxYGxQHKmEi1yJT5wmqoeoYdjig/kfVgQsvvxrRRnUDRXgmkeR12/ZjzpQs2nO/j25X+dE0YpQmqVNR1qZA==
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
[ Salvatore: backport to 6.12.y: mm/page_alloc.h does not exist in this
  tree, the ALLOC_* flags live in mm/internal.h. No code changes. ]
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
 mm/internal.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 9fbed032a9c1..a13a4799bfe8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1210,12 +1210,11 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
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
@@ -1228,7 +1227,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 /* Flags that mean GFP_ATOMIC */
 #define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




