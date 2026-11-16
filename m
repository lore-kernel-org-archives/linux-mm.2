Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFBB606FE99
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=qiURCFAc
Received: by kanga.kvack.org (Postfix)
	id CDB426B061D; Mon, 16 Nov 2026 06:18:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2636B061E; Mon, 16 Nov 2026 06:18:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8536B061F; Mon, 16 Nov 2026 06:18:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 950F36B061D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:18:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 291FB120893
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:18:40 +0000 (UTC)
X-FDA: 85440734400.10.402344C
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf31.hostedemail.com (Postfix) with ESMTP id DD58420006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:18:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=qiURCFAc;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf31.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=quBf2sjewmLKNEubAKIywkdVQas7/YZKwBG4LjKfbb4=;
	b=MeMUgWSBCXLCXUNUmaWV/gjYtSt/0QzBdmJhsyCt/KrbQCRuqCB/POukNLaweBJQQLis4h
	e/F7Fp66aE5SovSStidocuw45lGJyWTrrrp+2XQR/fLVegbQVzbxds5HMs6Bx1soT2qUlk
	wPIJTTSCvWHZjVrFeFpC2u4bEWs5ngw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=qiURCFAc;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf31.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827918;
	b=u4MGaXz86924t839XNKxAbeLyb5AHu5fLyHlJoZDO1qOk7M7OMprv0/vMPxjLt5deMI6LR
	xFQmcePs5Czm6idHL7k5zRarclEDXss8hBs0xrYCafKrtH9Ao+Y4mcjDYct7QhmO7SNyoJ
	jDiLHS5Q8nY6t+t3o1n7l9+O5nsu/Bg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794827918; x=1826363918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=quBf2sjewmLKNEubAKIywkdVQas7/YZKwBG4LjKfbb4=;
  b=qiURCFAcN+tH0B0XIB4zlc/PZrA6TgV8JQZ6LiOqLi3oKOp/mH+EFFXS
   5pKSMhQBdPNU+YeA77URSJ8VAKt0sj5f51daSjckBXpfliVESOV32freX
   6+C+sWk3kSvc7/0wa7iWubJZkfB/lLQlLpIdDMm92Ip7fMbSc7tGVeBVn
   5q+o1YjCB6odW7RaKE/DybAq/EOq+zRBGPt+Sh6keraH9Qt3xgWFaBUT0
   IT6GkLSc5BasPV7PHo7CBzFPVMaUH2uvSfZXQn49uPzIRFAFR5L6t0ywo
   +Y4bBa2WeVlKh93QPANAjt36F7dXlWv3Ddp/5JyBiH1LsTb9qbg1xKiUx
   Q==;
X-CSE-ConnectionGUID: Ei0vhUJwTGecDpCk9al8Gw==
X-CSE-MsgGUID: wWz7feGfRhm+wQ3YEgqy/A==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34187293"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 11:18:33 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:8750]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id c67a8b08-e321-42c7-aa2c-ed251e7d78d4; Mon, 16 Nov 2026 11:18:33 +0000 (UTC)
X-Farcaster-Flow-ID: c67a8b08-e321-42c7-aa2c-ed251e7d78d4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 11:18:33 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 11:18:31 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.18.y v2 1/2] mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
Date: Mon, 16 Nov 2026 11:17:33 +0000
Message-ID: <20261116111734.3798483-2-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261116111734.3798483-1-dipiets@amazon.it>
References: <20261113110259.2901456-1-dipiets@amazon.it>
 <20261116111734.3798483-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DD58420006
X-Stat-Signature: sm1u8z7k3msbzbjhzihspedzxau8oprz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794827917-944847
X-HE-Meta: U2FsdGVkX19QuibsGGVGzxdn2oRrJMe+rLZTfthrAM2WOmpIJgMbus7A0ow6VMB2TKAkgGX6u0HPAZ52zLJvatjKbJ18N6FnFdZa7OhJltE718EpF3qJNLoJzFgnTBES52RreMpolsz6D9ZV6PKWEfcemwYTwNFYPdoQa8MyWMIIAzPMg7TY0uNmE6N64LztfdpjFvKJ5fmVw1H18/OpcMLfAnlDhnI7Vw58HenxalMs3GQG3Tn/kNG+wLHH1A8T1bl3rz1OvhVcAu5WdG5kB0MTtKh5pclNb0Xpfe8Vv3khV3NVmOnYh4650QwzEhrkmaTF5sW+SeRux7T2YdqNKjAyJ6Pt25Siu4/Z5yz5NdqRFV9IOerFO7oViJxTAsFKrK8tcbP+CJeuH09aWApbWQb5iEgWwPy+7w9I6JZQznh8t9N0NmenbH4IZw7XoQ7elJrgCX5oEcvDrUC+1z7nt8XIi4N/ay+sdXukPUT74rLK9WfJN+SeYJkeMm4S9EAkVqG0sseTzwQUS196o38z6U90C20w0v5Fch9otZ5roYPaspzgZMKRaOBhy789gN143yDorwVUJqtXCtp5iHxv40xGjj2p97AZhDl4NtMdHbdkSVPeSdIy2n/3c2Biov6irj5EktfBHcJRbzaXinmgU/in3/fFnfpQItNLo6/pBM0cazzwEu5tM8Xr9IYNpLAXxIXq1zBizAWE5KYNRizcMjx/fMXjETmK0GgjoxG4HRtdvtJM752X1XGt7BhX6rprp6k4q8cV7IotnnckLeHxjTtC/HaSKaxe8ldLZU3IlyPuAH7gJwkW7aTP57rDm+F2Xsw19R+5TNoZNwvStKIsGnhimQe5dj/1r+L6UTc9790iDFefsx13UdvxttvlAwWllrFWTKgZnHl8mVES7v+YPbZjJyPtIi+KkLGbk/+beueBorehrll2vtIb8IZXfRSC0UjMX/FN6/+5OKJzMHY
 n7K1FNeV
 cVshRXK6qfpeCeeHkVOKCndWuG588CY5YlSSDprn53ASCP32xBdNpDQh7jxT3Xf9qAIJ7C6PtOkzlUG/8UJly8EnbwFUG3KE+CGMN5+EQ8UqL8Trx836ayH7/aDROoy5MZ+FbRvCf9BtCMjHtsNG2TWvfvkYjcbguye5bvj6XeONir1VkVvIAxnNzgkKeTSQCz+d3cFTQ000K4BQD96uDcVArMJnBOHUau4lR3mYc6Df/OuIujigOTUCtBFbSAm8bmC3cFU1F4sgMmSQ6LCAafyB7JB8iMtVba9+QlXMENPZycatKrc2uHPRMnCvBb9O/6t+a3S4flzWkwtNwQnFu2PxyNpwLgXV1qoKMovonySht+4f5P2sMIUwfXhGJP+iOsQ5C7k6MDrJrjYEKtXZLcUPnaJQ+w1r4bFZJFe3rDR0Bl6E8a/pI7gXqrHXenBw2WUZ5rrXd9HUGdKZYSNGyqI+QhQdF54Fdei2vheyu0lDoGEQY33LJi+Lhkmy+RdqL8eLGBYjXj3Rk30cmhUyKN1kFkCCxiZyARDPFb1G4GrODaJyszv5CY141zSpmk718uMjY7sK8AURgvOjdWq3Bfy6NrC4ORChbkxXczfUGWHs4BDDSI/S8A6I5SDEpDjrlFT4cAY2crEln60mEPeQpBI72cxo+q8bXfSp0ELgztO1SD1/0Va8azP5iKoO/NYuinKAON2yzcDGVop7QoxmwxsxvB1Dc3kJeJEY/GUY8CiDaIFHRNQa2P8u1BkmbkF2NCOKYIfkkeLSfPAwwVzaQ9g3Fp5c3kNFaBeKiyq8q4wnOX0nzm2pWQt33Jdb1wTsMeUjvicx8CcH01YNqmxbkDKGz3wB30Ra2vLyKQTKknUcEy0X0GUzhLd8vvObCT4VxeLspHirkji/2QLLUfkTaYNR9zo/Z/6V98ripBQWYNP4mM/XUTF+x2qXTeFfT9roDjYGLZSxHM5T6M6mkBJQkf4gKceAU
 8mZVl5zr
 LN132bIqes7lfIRmQGpqT1LH9c8FGx7jQ+fgh0dfhJe2UvpA57rftz3CqAI0B8EXk5+RRVOoFdD7UOPXv7/KRA==
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
[ Salvatore: backport to 6.18.y: mm/page_alloc.h does not exist in this
  tree, the ALLOC_* flags live in mm/internal.h. No code changes. ]
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
 mm/internal.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 47f16afa892a..dbd6e3a0b990 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1292,12 +1292,11 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
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
@@ -1311,7 +1310,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 /* Flags that mean GFP_ATOMIC */
 #define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




