Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1AC606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=MHkvBt5g
Received: by kanga.kvack.org (Postfix)
	id B866C6B06C0; Fri, 13 Nov 2026 06:06:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10C76B06C3; Fri, 13 Nov 2026 06:06:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A267F6B06C4; Fri, 13 Nov 2026 06:06:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 746AA6B06C0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:06:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDE338053B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:06:46 +0000 (UTC)
X-FDA: 85429818012.22.054A971
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	by imf26.hostedemail.com (Postfix) with ESMTP id B0D7A140004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:06:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=MHkvBt5g;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf26.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794568005;
	b=uh5o44kZq1yxkE0VfAYpLbfHUKsRSUGgebz3b7oezOoKvItQ+5oP99Y9YjZC7neVjLsvKn
	JnlZc/w/9v52+/zdB39qfGiItZfu7u/7n90ltZgkLR8Ch/7sBxyh1M+2for/sUr/qrgzV/
	rpiYrcfsa+d8y0M6t0BuWkemSFKR8KA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794568005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgfafqxJ8artQ03Q00H8cCZlfCmZMXK1TVx1mQzUt/U=;
	b=VROTooD5YaPcl/Hk1XpPuDm4GRiygM1t64C7WY7Douz1ExB3LfNsFgWpSpuu5nzx4RZHbf
	/M/Rk6TfIxAYxpPoosUQ3uX6+tx2YgYVP5iJWw0xSoulNXvrA8BUF3KQfuOBEasqe53JEA
	AtaZgUf1GKXPYByts3+g8QtzWAsmx0U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=MHkvBt5g;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf26.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794568004; x=1826104004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sgfafqxJ8artQ03Q00H8cCZlfCmZMXK1TVx1mQzUt/U=;
  b=MHkvBt5g74SWzJKwFGJJiBTyJjLKYK03f2r9yrogtYvbDmg3mYfw442X
   bO4WRlSs3u1n34jqZ8FFo06TrxVSfrlKUsC/yl1Js4fF70ylesogZKSm8
   5i36Rpyf4njTC0OrYldGSUWF+tdWdZWgGoN/uuLahyeeaNdxbqgof22oc
   gCxuV8tcMQ/ubbMpMprUZqAh9BQk1dodgqzEkaG4QDfvrw9rReUx85Oos
   5/77ICrfIcZAJjtJ56qTj5MsuPdfLo2f1n1GjVLNs2GOk8psxE2aGxmOa
   m9WeRSDrHtyyutD8AaYIe5RvAKx8IW2OTpvyQbCLSlHJ6W9LE+2XFDKb8
   w==;
X-CSE-ConnectionGUID: tPvZbgUfRhmIGvaU4ibTsg==
X-CSE-MsgGUID: GkvUhwbgRp2//Q7VofL6hg==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33886022"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:06:41 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:20712]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id de3b1e4f-647c-4bd7-a009-8a4c3d306e4e; Fri, 13 Nov 2026 11:06:40 +0000 (UTC)
X-Farcaster-Flow-ID: de3b1e4f-647c-4bd7-a009-8a4c3d306e4e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:06:40 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:06:39 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.12.y 2/3] mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
Date: Fri, 13 Nov 2026 11:06:10 +0000
Message-ID: <20261113110611.2915381-3-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110611.2915381-1-dipiets@amazon.it>
References: <20261113110611.2915381-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B0D7A140004
X-Rspamd-Server: rspam12
X-Stat-Signature: fcw3an99uezq81za4nonfjifxyauirkd
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794568004-449197
X-HE-Meta: U2FsdGVkX1+UfLxHZsUQTsDZVZGup4ih+l3h7Y/5T+S4UghaCKTbTTN9b6VxhbO2sm4GtkK8dgXEO2NYt5ZL092n3Szqtg2ktnMzTNQhMe6KE9vIbLNNxvuhjhKemuLhQFiU065zHC1JIUPcPUA/j9r8WTTYdK9tYvQNGeTTajDtWN/tnS4p+j4ADJ56J9WgOZQIen/tdgeJ97IMP5+YabO5qmLTCa1w5TFsbvKiVEC4Key5YxkqLEO1FttDPTOPffyOP6zIKxcBKbtVptWYeBbEwu5tgYoDkakhxADaqb4wMyRWHNSWu8dBgNL8cVyns5faq6LOGsGQ6H4cpuaRL3f9vzNxnbW5N4P+7sAU5j5SmAGXr7tE/+AKSB2EWROmhrf0up9pgzEF/SqavXh7m0ntJrSdqkFhkBfiF+9u3bXlSE4MTs/sJrTrwJLDnApMXy+E1NXtyM8cGTRsJH3OlpYjNJIj+2njjae6cKv9/eWTVoFwjYDGkVMFvJiPuespWGaU/EHB/9oo5HWT0Q9dWwanMLxk+82nDFpjCtq+pDjJgaa+39a7a+83ustbhCtoiLUKW7MTMq2q8h6iAXGouWCXNGFOWGkwQDyJpytHIeXLk7eUebcbmDoJ6yAhIDk1iFdT+GZuWIRY1L5qRpcHHP+BpKLtUzX6tqFYGVTpoSp6Q7koQDlv8Vaofe4LNItBYaAbQ7KSWGLkHYXqcLFeCu464NSPiOOgvIAVjdrYqVFApVM6GzgO6ui1ngRqidvMrmmxwOkadKlOT2x85afIdXTNYaMqjcMcXGVpMBzc0VJuh9cARTupdJKJjORBYWh30ulmIjXBEqFOlqP0DVScy0ZxMqGpKbH5raYTCy7+CY8/kyT6V9X2Gp+7pG2CX8oNlHHQQz8c+mq8IhdtAEAPiT2n1AUbTzEcc9D1hPVzdtNvKRTBigz9KLwcx50qmv7/iN6wApCWxgM9EndX2wR
 9eQlN3i9
 6GAjlwLwPxjpq5khcL3Va+hVOrP5k6aNY9YOgbA3Lr+hp92Jc3/5KKuvTViqzstW5r+Ok/r1WNu/0UVggyiNyDRbT2V820rTjOf9B+rmuX8FNraE4ha0WWsdJwpVsPed9iYItr745nS80pc0YUvgjAZjGUf9dLk51z4c0H89o/wOck0ZfKxP2eXul3QrSWXE73ysRPFZBc30QcBSdTcmMb26tsRZfI0poshogYAtUPT21cLq6PAufspWEnlDQHzC2BaDN67pvj2kmFvG+c/u7UpS02WRxeDH4iHGrVQVOGqDUlUQtf3LB7NX7+O4AG4ubZhV4D3PsjFapjvhZuyklJ7+ptlTI9aznvdE44hvCQgNX1hRvzTk1Ydyi1weQpqWaVQwhVWV3UZYglug3dVWbdy0Q0Ky+GLtYbx7R5tDxENq/Lle1e4mGLXXgXZdAGy2awlLb9ZrECs8eQWsjB5Pk+dnxlgIbN7Ook8Tilcr4QMe8SzKNMULJobQ83b3kA88gh3aRwvHJvAdJpH20pdYoFiGxhf9eQhx1k+AQ/+xkXN4NZ7yAs0/x5sb6CIV2NHh1MuAf2Slozx6h1xVSSXSgYzkjI9KNx2eNzerTWeazSFaEPBQ32UAyt7JQIJK72c59/2pKV1CtZ7fuZa79xkYyxYdgrxvvclK7JfZJGil54XLCdGUWg/gsGUSMsEN5IEIT6t3/y8sNe/6pWyZpnLpPI3ayakn8+/zTDteVRdkWTx3AW/n1ND/YFJPjqLnG9vokhUJ4sLT2ZKI1rfSA6W2JAi1Eg6NbdSyqWQXT+LqJ7guEWLfxq3FxqDBiKrKT9LEsNtRtYQv/C3reTENys1PPCZtGxyOfCjZR/ytqlxVcahqBszIdSTCWycjbrrMuXwtZhWECnWqJKbFOwrGLsLC6Mlyco4jfM7CFca1u8t17hPTMPkjw2JmyYgycfEOqNq8ABbrW9f5Bc8T8ieT5fpKMcau74rDE
 Iy91itMM
 MlDu2//hsTCA4BFcFU8eUMdYuwyakDSyGTJpBh1Z5EHeB/5Kc4HI8e2tzpx21gCj7Rzrr8KiU0lQd1xVeURE78yLYAK/8Hvo/bPShN7giYMVCfy+XGG4cQiX9a5V19dPX9g25TrVyBGWfLDKQq4l4+9p7WF6IYdNzLjKGBZIVd4eDsWKP04JSAKXudoNpvGeY/Wqra6vaO4OxVqCrIT2mQtQC1EZQFQGXapYSI8GgxUioAB44+k/XLmSw6n2CfXx1eJLxxpbCYE=
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




