Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED4BF606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=DyG/QrqR
Received: by kanga.kvack.org (Postfix)
	id 2094C6B06B7; Fri, 13 Nov 2026 06:03:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C486B06B9; Fri, 13 Nov 2026 06:03:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29B56B06BA; Fri, 13 Nov 2026 06:03:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEABD6B06B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:03:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A8D541C41DE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:03:23 +0000 (UTC)
X-FDA: 85429809486.02.F202866
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6728240003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:03:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b="DyG/QrqR";
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf12.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794567801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBr8YA4fmyeQoevzG0PDemh8JNDakDQrN1HqOxrlam4=;
	b=gj8M3UBYl8LRnbMSz+JB53sXf2KbMMs2d8l8ktOnwHt2xSm+/c2+arjROB+OOb/umZwJyd
	UzocdrKDImr4OYfngb5ItnxG4u8F6GOUg+DNvp4Z4SfAVU6tD8mnY+TvdoJ710coUxS5q0
	HX6qgqB5ZvXNh8isj/lMnjxlOkjfSTo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b="DyG/QrqR";
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf12.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794567801;
	b=S9vakvNsBdpH3cDblbRi3721RDbN3YCWeDAtdPhWIO92Mi3WoQeSuLVhFd7n821yXpW33T
	SxNnVMJgkorPWfSKKiiICSgpzgVcWxsZtRPlgPtRUnrSyyAhUs/wI6C8rWj6+CRusGsl4H
	wRMbzpq0VH1SWAbuNam33QOXmIOxmoU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794567801; x=1826103801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kBr8YA4fmyeQoevzG0PDemh8JNDakDQrN1HqOxrlam4=;
  b=DyG/QrqR/oK06ZHRGdw7p4sJ+dp4Adtf301DRu4dtnONevRO1UTJsaKa
   p5SvVDpFyJdNXa63PphW4KNBgllCnegszbtTg15zrmHRr8f6+rT5r05qc
   lARrjw4ULNF+VEI7dbIW3cB8AO0o3yCc1jpncFjeC4EOSpgqVLP/lKu+M
   8eBJBIherUpbaJICY9amyK/dkT8frbjsL7llpPlltysBOb9VGFbbXkuVU
   mc7H5kxMX8v467OG1GJ0GtaG4NI3Efed2Tk3B9iKvTHlFIPm7KPt9sQac
   qaNbj3MUQw1R4RelIaHT9xefGkPEV81DkyWGepz1WbfhJeOJYZsdDN2N3
   A==;
X-CSE-ConnectionGUID: tHHg/bCfT625U3FgJvHbTg==
X-CSE-MsgGUID: 0z+DYYSIR1aoDgwz6qy3iw==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33653046"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:03:18 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:23028]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.127:2525] with esmtp (Farcaster)
 id 92b15291-78fe-43d6-bf6a-ed9bae8607bf; Fri, 13 Nov 2026 11:03:17 +0000 (UTC)
X-Farcaster-Flow-ID: 92b15291-78fe-43d6-bf6a-ed9bae8607bf
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:03:17 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:03:16 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.18.y 2/3] mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
Date: Fri, 13 Nov 2026 11:02:58 +0000
Message-ID: <20261113110259.2901456-3-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110259.2901456-1-dipiets@amazon.it>
References: <20261113110259.2901456-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6728240003
X-Stat-Signature: 3o86bs373a93911ms8gcmnnjznsbiy43
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794567801-875127
X-HE-Meta: U2FsdGVkX182EuNXxRqbrXhvUArCy+i6Fn3Uq0rdRQb1oyDpmtbWHvi4UvPRhg46j9RobO4Qi9I1HTESVNABO7RyWLDlXsJjDCyeUq+K8eVxFSaRf2Jh7tDsDA3nWpET99Br8T4CL2vSE9Ye4lqaq8IlBgkaEOTwpCYQ53EMBRwSlufn2IizxkhDd2BoNP29vwwc6VwSZYm32cRu65JM2AbikpX5IRYdR63yVdQpotNlg8ch85YglYZWTnATFVbsEG5/lGfLG1abPfv3kbhz6VeujaBBX7+1ez5uW5VsfLw+g1fxKdKnqxIXCtFp+T8aeOmLh/KtJUIMuSxVm1kMWWyTV0rqx+WZCTub3SBO72ZZC+AjodCXPS56WzDT0Y0by5BpmtVkVW8/090Rwn3hxOPAKeusJIY1VNM/LunusMBWWW1RMHzt0gurXa/W4yt1rLaEf66rThGNL2aGmofrXZiheojrSuLTDS5jGqzPwfo69zCACS5k6B7OmssBIuKWNnPxB4NB8QLJZ8ve7Zqi/L11+nJCeSIc3HcbNtZwPBc3jU5rxn7d3nRJ9BAgFvME3T8AzzaeTGig2+1EIWoGY/W8RO9+FPNfP3IL8NWN6DYL8OQAI9Zm0j+e5DxGVeuyHWggavAuDKpXyBCkyrNZ8ALIBUq7YqZpBkCY0GT2lIjewB4XkjFZ0gXCVd+PY2abkzMF3OiuOPj5dIJm0whhyAR3Riqow1uYbvesGaQTqmqiJ3sd5AYkp8aiEw6OkmoYthO0VgPV/jhYAy6tImYS4jma1xHM6pcKH1TLEe80gdL0EP7nbBqyI0u7veLHKvxuaxin/a60ghr2H8H0G/Ak59OlJ0gyhcoAmZwtBGv9s+JY6g9XQvfIw8npSVpOu1ykjw8Kr2mc6hxBjoH/gpRRT2th/EF5PxyB3uMihQUkRaUnsHjys26waf/5dJjvPSZhR5WJWPAEd4SW/0wjGkG
 NtZX3PwS
 PtbRG7N88TlkEViEHeKiGBtIwMJLx6wLUouXsRNX3bat3+6Qmb320T7VHGdR31tZ4ZWyWIjz5zWsGnfc3ry2JYYxZE2Fufvqq/tl0OA0gcXMoIbQMO+5BNCCvuVwAD87doLxLl+YrYhNQ0Dv5bv2qi8gRFnOxds7dqDoMN4d1DhhGG5wBi1FgcnmUAFHvCC6HEB/awgqP2gT9JB+QC6S6DQWJoqiFqA2xSYJLMFmO/2+Lp0hGLDY88gWJfmu2yY0pg3flbCYW3W/7Rfn3nPRE1CwN6bugYY8mzSlbv54n4s5YwVBjKpVpHoD7yf5jTI0WJ+L3SLw16qmz2JW1RsTpNtpEe7CFcY160yC8gFsPptTrXlp3Hqbid0LQrStk9hytmTNHnNax6swnHlXpF5nHlY0afa35w+CVlKe8l5Jws4buzqg7YxAcoss1TinrC3UO9OolCTHW4nM0ummzCWZcwyGjhy9vuvV/UjKbURIWl5OBMjJ7O9hefkz1klaBKclzgSD14o5GPHAw7pbUbeo4/2YJ3yPq2OxRnpogxfulTGJLDN6GQn7otyi0LOup5/DKTdDDYcdiBBPHfzHbaEe2JMUTQxGYcgpSoDEon0ndLUQWGM5Wasa/FQVGunIE0OcT52QYdMe3tPe2DaluLhYBw9ne9uFn2rYe6gXRYYsdPOdj/psVYp06B3833rVHM52rpD76/+UsNj0KBXCv3dZWRn32A8e5OzSS/EmVG22dsoSxUEWVK84UQls3kcnroc6sAJcV2i9i28F7db+QdohVAOyPeVttLgzBJ/KJdGhw1eoKI6EjqWFyfvRNFilBP7w4Btym+FgNPIQzvHV2iTDKSeZIc6hlNk08X987DysvA9cQRffdV6On+gU78lMV3PkKmIzSuIM1ZigbnreL7D9NwKZSfZe85tXs6rbsLkis80v6eEYAtBZr1qARq6rVMkWql/LlP/gqR9ntEqrJ4K928+ywkjoI
 xxSbEjNU
 vJhgtApfyDoOzWPFsKyXuz4C8wWAVu57ZhqkRfIi+6AVw7C4s7mliSIGxW6/E5w7acGiyhH/mc+s2URZEwrlbw==
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




