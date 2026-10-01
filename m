Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FBCCA5FD5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433D96B0096; Thu,  1 Oct 2026 04:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BC46B0098; Thu,  1 Oct 2026 04:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321D16B0099; Thu,  1 Oct 2026 04:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02F096B0096
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:22:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70D65A0241
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:22:31 +0000 (UTC)
X-FDA: 85273365702.03.025C6F5
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 36B5F14000E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:22:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=fj1KEwNn;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf09.hostedemail.com: domain of "prvs=72778446d=dipiets@amazon.it" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=72778446d=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790842949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pMNM3ezMCf72JOW7w9gZHwjUf5zgBeoBXpZHv9GCuqo=;
	b=vyjE5r/NXtaRDtopfVV+GM4gMnXJvKxPDoDCeyrJ0xjd+wrj+yWFr7ucawmg8uOZksEyLL
	0YtMJcTuBJVerUQol4xZ0dbD0DcHzgqPkOiCXDp0D8sNsZBIK2UWCA6/nHUsxv6NnHedIc
	Vd+JpAdG5eAFpWmatVsyVSZB8ttvlF0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=fj1KEwNn;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf09.hostedemail.com: domain of "prvs=72778446d=dipiets@amazon.it" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=72778446d=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790842949;
	b=u0Sc3W3soMTWy/KihAmi6VLQ8D93Sor7x5E+1m/6bCa6ODZ3+yZBAj40MXZweVYSrcpPRA
	hSa03HbjvMdLTfWR9IkwKZ7RBBEo/E2NeF+kwnOviO+AJFURQv4caFp1xrwuC0k4yiBkkI
	/iXSdp45jW9tle6cgSBP9ZZKTqle8iA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1790842949; x=1822378949;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pMNM3ezMCf72JOW7w9gZHwjUf5zgBeoBXpZHv9GCuqo=;
  b=fj1KEwNnTJdDPLKkvXMB2AiDOCM/Su+i5MYK4jbrIS0W03VE6a0CkBgp
   whIfEbe/Zl0QAkYeonHv2f+XGmafmE6BsqGDyhTgR6OqBB3wxUcnd3pWs
   Xjd3L3HYlVfGrBEoHfcQCRD5RrV59nEPoqDm4Kwx/lNcNhfGubr+qe111
   xjiSQqkwkdP0rNjgjA1BzIHhbt2xZ8ocW9OMor9uQLZU9vbKqvJxv1+jm
   y8Z1vggDdWg4Ki/LVcPlRJ2/yiGBPqwD5d+BOy/m0F2X1rSDqc9RBaGkJ
   y0mJcMXJR8FnECOaB4cnny37px6oP9NOcSoI9xdk2Mk/3V4cY0Mka7PuW
   w==;
X-CSE-ConnectionGUID: tST3wUViQXKbYg0FlT4gLg==
X-CSE-MsgGUID: CeFmmwQxQA+xgUJufVb77Q==
X-IronPort-AV: E=Sophos;i="6.27,134,1787011200"; 
   d="scan'208";a="30088223"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 08:22:24 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:9288]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.21.22:2525] with esmtp (Farcaster)
 id d7332f4c-b57b-4f23-8dac-76fc3c82d408; Thu, 1 Oct 2026 08:22:24 +0000 (UTC)
X-Farcaster-Flow-ID: d7332f4c-b57b-4f23-8dac-76fc3c82d408
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 1 Oct 2026 08:22:23 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Thu, 1 Oct 2026
 08:22:20 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <linux-kernel@vger.kernel.org>
CC: <hch@infradead.org>, <abuehaze@amazon.com>, <akpm@linux-foundation.org>,
	<alisaidi@amazon.com>, <blakgeof@amazon.com>, <brauner@kernel.org>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>, "David
 Hildenbrand" <david@redhat.com>, Christoph Hellwig <hch@lst.de>, "Dmitry
 Ilvokhin" <d@ilvokhin.com>, Brendan Jackman <brendan.jackman@linux.dev>
Subject: [PATCH v6] mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Thu, 1 Oct 2026 08:21:51 +0000
Message-ID: <20261001082152.2879289-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D035UWA003.ant.amazon.com (10.13.139.86) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zfztrpa44nhmgqetqty5jqwgmkiiqwyx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 36B5F14000E
X-HE-Tag: 1790842948-889587
X-HE-Meta: U2FsdGVkX199XwecI22b5BikZ633tDlzuaQ2liqE3sX59h/0T6I3RE+A97GdvBCVZOOnoIYOa1wA63MdQYSNY0/JRKtPKagX/otDTCkRMaom7AOuj7YBA1xmQDt+KltWgkWpW3k3L2g7x1QwjZUfjmudNliSpNCO40romBMAzG4V2hYSZ1/BYY/JHbbPWwBkwrWysJDz9X8IOJing64VbIZr3K5kVdir0sBh5N0OpPXq/7LTZ6OW4wqdVnAjQ7lRwimMPVzFm7rUVBedMuxDBHSrpGx+9DMG1fb865Qvmtc7Qf53/6oeeV+i88DOwu1//nj/u1EpoOeVGlL5BVIxDyWwH8UGO5tSfQtI9CDRbkTy9g+wjAi+c2OqEBikjHeTDki5BmUPtEQJ/KcdU8g89bAq8D5EEkIFfRhPVTBRTP13OVofGM6IQkXvqfiWLaHU4OABJAnDSS/ABRCBTI07tqZSaeOwgb6Twit8p5RxmI0HyDNhn73z9taSmBqO7h4Ub5Qrpvojgbo1g7aBxZVM1BHQImY1gxuPLS0I9ZSOMpx9RuF9AcnwVQ+6aiF8f0vYacgioObnY8ptOXVKAr1/2TXGtZ3qqAgMoJA5VnZFR1ZTT3Cinblc8UAeZ/ymsan5/jvPMcq4DJbmEunHaMVQNMMVTxppwKslY0DlCU2vZLOa/wjRFmpWHLt45wmV4VhW5vL3dc7sTmWzzBEKPMj5nMV9wwY86cXJ8XDm4zB43QyM4qTzQ0ZhmoETSHvoLgkTXsBLFbvBRoXG218WAyC0awcXWmLgIi3ZE+VEGUyynOXxVAJ8bYGSBBhIQpeHMjg9AjK6yWKAALoy1EoRxsQq75aQvN1PN6h+ISuOs+XLAI5was+4JKNOnkMs4QBsneRl7QFlgiO1reaEg0ufEN3Ll2uZaIlRY3hi0lak7Nx19qxdWXkI5Jcfet+7uGZ+YwJu/AkRGYRCZectmcn4UbQ
 oCZgDosM
 4Lw/X0wtRsswh6Px65PvmWm4RiaKpsHzoSfoTjvEWH9v8RPKzZj70MOAMUmWZFJX+x/wg40psZKkEAvdxaPzqcZ3it4BoFy4crzjkAIT3O8E/87iwU+tmIQK2lwlOC9G6aRxiBkpaBgJbdDbE7WvoGfzpjsU04Kmvyv5b6tuVHpz3jZSMkJ1iFyhI3FU+s9F38afmb78VVXtQjjI1G2TuBHvT5gTG0BIpggGsOUdA1XrBJD5K6sPH8Fnyc8FQP8aQlaXuhFrUpnQLh90woxu9V773JKwIGt8SgBihIj7Fso4yyeciwsVal1NB+Szma53bxy6N1uuXjr2hEVc6RGidONuLgcpL3Vo31KqJDzAZKJsrchkHqN95DO2XAJbURvcWOOiFWBCDyp5VKFa7u5XQxUmwOEfb0t3FxVma5fBTBq2jOEoXOwtW97bD53vgecx1JV6VgTg2f4u5LZnmufMGT39Flx9ItwzrWtTzsWmKGFm7T81sGhuqEtNh0w0PPX5buazMsJOiPYSicIR1Hm4fMIcGdzsXBzbO3VNKduk7IXMHrAKmIbw7WlfqUdKigzPZ4/ll9K/P8527yB/1dOP7UaOSue8EZqWmApDRshl9Ncy+p++20BFCdqjJALRpxdckvfZv8XAkq9Q4jUbjB0wRmuMtid6qEt3YfPOPt0BtbuHlpaiCcVuOtiAxaZBwt1XBmdlD4ZZAs05Aq2cfH41CE5sLiwVnNQcGq9CUd6Adn2TjMXk0We1QxXEoBIMC7IKIPZ5emsqwuJ1o+JnJ9q29PuRlfUbwg1BHB9hvVdNsFibMpqsIZ+BH9qn7jVzwn2ZMy4kGS6MM4kkVQnWxTtwEEUJ+sYlzxbU6GPNfePIM1BkNOqgR/SGmC84c5NgpD7Bom6dM5xzcXUZC9zZs/uGYgSG08c87/8Jgze845FAWlPi6yLkUexQjAzGJlwKLOSVN1AcnScV3hAlpgXJtke6O+ICjOhF/
 5Fr3KZzN
 7nLDUAPXQ2iSoAhTgAWOIGH+Q2ujRmpar4zoeP6ZqgbaFq5R1XlCCYfHb1PnupXPffMtj0Sq4d0DS2ABmTLFLciR54Hi1kcK7K94le871hc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write
path.  When memory is fragmented, each failed costly-order allocation
enters __alloc_pages_slowpath() which runs direct reclaim, direct
compaction and drain_all_pages(), causing a 0.38x throughput drop on
PostgreSQL pgbench (simple-update) with 1024 clients on a 96-vCPU arm64
system.

The root issue is that direct reclaim and direct compaction are too
expensive for hot allocation paths that have fallbacks to smaller
allocations.  __filemap_get_folio_mpol() already marks higher-order
allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the
caller can handle failure.  However, the page allocator still enters the
full blocking slowpath for costly orders with __GFP_NORETRY, which is
unnecessarily aggressive when the caller will simply retry at a lower
order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.
This makes the entire slowpath treat the request as non-blocking: no
direct reclaim, no direct compaction and no drain_all_pages() IPI
across every CPU.  Reclaim and compaction move to the background
instead: kswapd is still woken for reclaim, and it wakes kcompactd for
defragmentation.  The system keeps its long-term health while the
latency-critical direct allocation path no longer stalls.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.

Clearing __GFP_DIRECT_RECLAIM makes these allocations reach the
!can_direct_reclaim bailout, which since commit 4c0ed883e051
("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") drops
ALLOC_NOFRAGMENT and retries instead of failing when defrag_mode is on.
With vm.defrag_mode=1 a __GFP_NORETRY allocation could therefore succeed
by fragmenting another migratetype's pageblock.  That is the wrong trade
for a caller that has already communicated it can handle failure and has
a cheap lower-order fallback, so exclude __GFP_NORETRY from the
relaxation.  The exclusion is not restricted to costly orders: any
__GFP_NORETRY caller has said it can cope with failure, so failing is
preferable to fragmenting for all of them.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                                       Avg TPS   % vs baseline
  v7.3-rc1 baseline (vm.defrag_mode=0)          58,602               -
  v7.3-rc1 + this patch (vm.defrag_mode=0)     157,246         +168.3%
  v7.3-rc1 baseline (vm.defrag_mode=1)         109,012               -
  v7.3-rc1 + this patch (vm.defrag_mode=1)     157,778          +44.7%

Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.it/T/#u [v5]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
---
 mm/page_alloc.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..64d09964ca77 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4784,10 +4784,10 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
-	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
-	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	bool can_direct_reclaim;
+	bool can_compact;
+	bool nofail;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
@@ -4802,6 +4802,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	bool can_retry_reserves = true;
 	unsigned long alloc_start_time = jiffies;
 
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
+	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
+	    !(gfp_mask & __GFP_THISNODE))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
+	nofail = gfp_mask & __GFP_NOFAIL;
+
 	if (unlikely(nofail)) {
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
@@ -4918,8 +4930,11 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		 * Reclaim/compaction cannot run, so defrag_mode's strategy
 		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
 		 * fallbacks rather than failing the allocation outright.
+		 * Not for __GFP_NORETRY: those have a cheap lower order
+		 * fallback, so failing beats fragmenting.
 		 */
 		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
+		    !(gfp_mask & __GFP_NORETRY) &&
 		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
 			alloc_flags &= ~ALLOC_NOFRAGMENT;
 			goto retry;

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




