Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FC3606A337
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=TBlhDD3l
Received: by kanga.kvack.org (Postfix)
	id CBC696B05FC; Mon, 16 Nov 2026 06:22:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90B86B0608; Mon, 16 Nov 2026 06:22:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B349A6B0609; Mon, 16 Nov 2026 06:22:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 929146B05FC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:22:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E55F1408CB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:22:58 +0000 (UTC)
X-FDA: 85440745236.04.EF23D79
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf11.hostedemail.com (Postfix) with ESMTP id E7DE440006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:22:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=TBlhDD3l;
	spf=pass (imf11.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828176;
	b=X3sCTWksQeUqvGPtBRTjuQM/7nnCEIpj79aciGKgailhCtfzGWISCZEdGncRU8k2Z0qwj3
	9TzWQE4ujXQBDsh93VcBnwkFh2dS4wFi+77KpqdKvjTXhYn4TXYPZMWHu+GtwSnMwvRCt0
	pfQY2qwqlLFvAdAcLzLgm/tpJhCfTQk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=TBlhDD3l;
	spf=pass (imf11.hostedemail.com: domain of "prvs=773eacc47=dipiets@amazon.it" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=773eacc47=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZ2xMBw9p2P+GDtsKRUl+xR75t2Ln7tnvEPupVvld+0=;
	b=IUz0wsf9dKn+fayZkmxQK77f7c4LSBaGGl8F2/NJmp8p2tBbxRjrgr8jkRCiPfj3SZZUVq
	RX8wE4wCLhTcnvUxmdiIehCm+sH5lffCEfKOegIXSBjXGZS0hDE1eMKoaRazm37Ty4/UOw
	P6BSDgdcaDl+kG/2SIJt/pMIjw3qVlA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794828176; x=1826364176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TZ2xMBw9p2P+GDtsKRUl+xR75t2Ln7tnvEPupVvld+0=;
  b=TBlhDD3lR6qN8/lzRynkI+61WZ18lBFaxZoZRXwle+5dhfBpbxsdUtOO
   HJ/MSbWvuajlwlj9Y1PjEkQx+K6gwsvDlb/B7GmvAkVDYg549wnMRBRbU
   3hpkgkcEbJ4BE8QGtRx9RUcY6I9m67nH2G6btwT5JubRW2inZPdQtS/Io
   366BXoEOD5+dEscRhDGX2tcHdO/iKcMFFQmlVEiaaxMeNHChyP52MmaGM
   rhRk4VDm7WKJqwWwnMJfgW5PXgxahky62yKqSv5ozNBegr0rG3gM8C1kh
   2vgA9KKjlN7kl7TJ+GgJ0KVrgMhi2rp0UM1zrAEqxOqER4IXZsDnTpI/3
   A==;
X-CSE-ConnectionGUID: 3zpRHl2zTk66XqFushM7sw==
X-CSE-MsgGUID: ZMgafQU0SPqdxkSo+0cMvw==
X-IronPort-AV: E=Sophos;i="6.27,216,1787011200"; 
   d="scan'208";a="34147601"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 11:22:54 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:17470]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id 8cc5d681-942a-40c5-a29c-596e3f0f5d4b; Mon, 16 Nov 2026 11:22:54 +0000 (UTC)
X-Farcaster-Flow-ID: 8cc5d681-942a-40c5-a29c-596e3f0f5d4b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Mon, 16 Nov 2026 11:22:50 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Mon, 16 Nov 2026
 11:22:49 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.6.y v2 1/2] mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
Date: Mon, 16 Nov 2026 11:22:28 +0000
Message-ID: <20261116112229.3815501-2-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261116112229.3815501-1-dipiets@amazon.it>
References: <20261113110724.2920455-1-dipiets@amazon.it>
 <20261116112229.3815501-1-dipiets@amazon.it>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E7DE440006
X-Stat-Signature: 5yameqf1qj8s3aenqbfw7risq8c1744b
X-Rspam-User: 
X-HE-Tag: 1794828175-472549
X-HE-Meta: U2FsdGVkX1/ZAcnM1qXYnEIkLmusjy3XPl+VntErbi5KjuHBb0i1Mmjwt1yEpzC2ivU/4ubtMbfQmUoeVIWuOxuC0YpuwN+/A0BRNrZItdEp7JMnVvzmNMbLrTdb3NPr1C1tPt4vTdUTLg2dysqHFSzs2/B7NG5fC/zdw6rDFnxYRT0VlqVDYlvwrsSPiJ6xys1ia3rGfuyDHv9twSVC0NExqiZL/A4EzOTRBbW92wN7yhtLqfWdvDOb8nI62EascmUQUrQd9WAU0rfIWggHrxtqib/+4jOGdN51MJl/rH1xMV7nT5Hp4JXFEHqVCGK5Bsz4ktBfjKv9VaiQf44huIRYgyzZ3N6pEawAD+F7PmzT866rr/GBwv8ArwGbmnszngTQ/RUI6k83GjJC6c3S0m9YLN4vSCz9Kup4jRTjmi4cMePExQcsqA7RxA3RE2pAtrDAL6E2Bwm4m6Ltu/HqUzvEficlPlwP4wT0RTHd5B2sBDhtnVYxg6ZGIdbi8dIbXFEalPll38Xl96dpRrROoSKVmivcNv9Kln+eMeQ1l7tYV1l5DDlKL16FId7PP8Do7LZItblquGbgdu/H4oM6YBoi6ft9SQNbjx/NB1p2TcPOQaPclaqyTXOq145SUvRpzQsfsd/j+M9pVXvgYjTpZ5V2Ne9yQ2xnruje1B9rxA1Vax6O7rwcHFYRn1Sy2loHW+GUaM9BwaQ1SRy1BD7n+6dVRf/jZ6oXeT5gh2YgYOiL5UNfZnXiG7PyBY5NtI0H0MzbSDknS4O47CJ2CnQ9g4zmt1zJ8408lYr7hzPaF3x/096vZVBxTV+YWFqc0JgsCtIZmDyah+XQPwCnOaHiN5tdyco0QhO+nYTIp486hLZY1ko/dkhKfE/qlLccJkY4Ca2z7sXRNLN0M/A/LI7uQY3QLIMyF8NJbOe1EEL5ENsLm2c9dcwgNECHkM18HuW6ucSTU/LVtWniQkn9w3j
 nqdrZu7v
 IDrI+0xVW7HwS9LTWIM0FaUiSHtgoX5emzPGjCoEJCMM7fBvHi4OeN3BVPfxngJGHCaRcmeGjAAnXJVyhy+GUlKrwcuuCY1gOxXYFuI1hnJWYabtki6Z29woX//dKqJBZLnQj9TDekMYRl+qk0Obf4AmKtJTg4TBuxdMjhjqgLqKvNf1YWh6O7sIbnop4VFUvri+lqhpssyIIHaewVEYsIrzgZKPPxvvC6VME/II31I5OCTJPHtJLjG/+TN6FSzKtX6PPI3qqQfMWC+VTYuNsKyWnOhtEIzpkINkeeFKXBi6f8jX/6jHV8fPfiSPL9r/OXlw8WkWI83Z9VVQXEvTnU059Ejpd2zVeA4RJ6Y430dub2CNNYLNMxpkmql5MNu2x2vMaFMhZOJLO+9fXjjucT5HTWE8OtrucnRHhfmrc1xZReiZOYq5x2TKsQxlaLaj741gsFHDe24ABbru/7pDDqFXiH+7qtIGp7a1teAqRYMFPHyWkmnOOwGrk7KNWHJrI4X12ZJUoyixFSYmU7MI2+Muz4wu/xpaxaPPUtC8NLn/15O29Nrl/Ys1s5szeoKJosvngg3YacLOcRJxnCMXtT0f6hGsOzbaQ7JzKndQ6vT2rIgUv1lecPXIc32yd13eTCUXXoleEIFhCidoRQJ4nvTRQMHVumVhC2QrHwW9TEPAd3ghLogvDtQ60CwEgM+p36cBNNhB2EbqoKMtwGMJuFmTW2K8i7maHevFY5FCEmR6DbHS+T+Oe4eZ8uoXXKrKx/3jt8vem8Aq4XWx+meVRFHvuazgDIiuhIbLwcVtQo1OnQGCZPD0x9BYnxVT0apKWqwwhFre5KylqAzkJDFRSjUgURi9UPD6tKPVYVe4fcd2VAk9FUcE2EDULOsImQegXyfNMNFwtxtJty45od4FbCnffTPaXYL3o2C/j1QTNEiDZ3o5xBrhHE2ZXfACOPJkQq2P/jgoquEpTL7XOcEfjqbsbb3hR
 VBG76hJv
 h3f5rZ68YyC+k1Bto3r0ERzoaXXC5TNZ0z7uYa7jf0s+QQa/L5/fxujlCtFoyTZoYIGnVVC7tffInbIPKhriXpcAtFmSkNsjLgJVw2KnTxU+eLMt4T9woQb0930irJek
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
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
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




