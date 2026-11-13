Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED30606A890
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=n+AmwGCd
Received: by kanga.kvack.org (Postfix)
	id 40C976B06B9; Fri, 13 Nov 2026 06:03:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38EB06B06BB; Fri, 13 Nov 2026 06:03:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192FB6B06BC; Fri, 13 Nov 2026 06:03:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 982C26B06B9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:03:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C854C0790
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:03:25 +0000 (UTC)
X-FDA: 85429809570.11.297D853
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB226C0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:03:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=n+AmwGCd;
	spf=pass (imf28.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794567803;
	b=hwjXycWz8GeAgh2xeMhN2Z3L7npKrAaXLkm9F5lxghf78Oef14DBq47H9VsPvkI7DttIvR
	aFgUl35FWvulNsM3vLSHjZiqpzfBEIP2Kfcwqhc9Tiw+UPKwfWx/yAxQfRjPB/2N9X8XDs
	FVrwYRZdCKwA5+7B7Qedf6cqrRa8b9k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=n+AmwGCd;
	spf=pass (imf28.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794567803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBrctbWCr0zoW4q3CpOYQqWzbyJ/Y4Bqv54BvH7JL1M=;
	b=qSC0F9V5ypmoVklL9k84Mf2FcvxZcBxoNXeVc3Mn6cry7yyUjZ2L3DoViq4didWdsBgx3n
	X8/xxYfw4CwnDCYKkHhUn3u6d4jA96nDCDkKufBJD3TTJ0sphhbEGzSFRGlZ3CRx89CEL2
	a9P1HYob6/eT/j23a+1XvvFhB8neqkE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794567802; x=1826103802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LBrctbWCr0zoW4q3CpOYQqWzbyJ/Y4Bqv54BvH7JL1M=;
  b=n+AmwGCdfrRdqCE6DtuczUps7PXOxLr5lKZOHL9SSj5yE+urGHhcYgxA
   2Us+UI79uVge1mZBXA2MHp3+PB4+He9ShxfUFXoqhFHA1zjSGHBlSHpJf
   OwZDTAMGBRdTYosdhdVEIhg40KEE2EzMtnwt1bd7wHJlPQTSrBu2wZ5qo
   px3TXqiiUEsvK4e4bl5gzHkk3oKSwVDjVeiIpskf6x3Y+eXGgxQIKow5z
   k9hZ4Mrcj05r8XNCebv2u1Xc6akkp0dATGJEmX5bEgBw5o83tVl8kIGA7
   Uk+s3CYr+MWLe+Vdj4YBSHHhLDafBXD6smKQHZ5+V1YImtm4+s1Ppx5fG
   g==;
X-CSE-ConnectionGUID: dzx5j+V7SlyOc5phpvLg1w==
X-CSE-MsgGUID: CJlgEYTrQ3GbNQnddhx25A==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33872378"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:03:19 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:17871]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id fd0d30c5-6cbb-42e5-b507-e181ed6e2226; Fri, 13 Nov 2026 11:03:19 +0000 (UTC)
X-Farcaster-Flow-ID: fd0d30c5-6cbb-42e5-b507-e181ed6e2226
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:03:18 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:03:17 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
Subject: [PATCH 6.18.y 3/3] mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Fri, 13 Nov 2026 11:02:59 +0000
Message-ID: <20261113110259.2901456-4-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110259.2901456-1-dipiets@amazon.it>
References: <20261113110259.2901456-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CB226C0006
X-Stat-Signature: b4igdnc8h9tqrds5cj3wcyfb96ifyaq3
X-Rspam-User: 
X-HE-Tag: 1794567802-957626
X-HE-Meta: U2FsdGVkX18UpGw3MWFmB9LfbsNFRaTxnLY9SjiMVc+BBHouo+LhHPgXKa1aXPjt2sYihorG9leR2QHoHDiZuCHQNI8CvDWIAWIajoTFyq4tev6p9+pyn6PSvdNBh82M56xX3r1WkDXT+QU4K/3M36untnB0DyfcQ70dipNIrnOhFNZ2k/fPBX80QUH7Q4rRFwxp0i7F4dv8w4zmI9/260r25LGDxkYQawfIPZwQtrskcs8ON7t9g26LWz0aIeHfBmVZjBMfndHxbV3rNfDywQgBtldGa3N55ai57s+j9hF2DKbyZpom0fAZzTxD0wJPfDgZ5nZeUn+6LJytHf5wHBNdA+jWcBDVPrV5quJVfFk5SWplOsrrxLAJjts1EdR69IV97Mk9pFcpSoIkKP3sjClKjTt/8it0/Vu76Re5CaaNHycsDNwYi13zKxhUFxdArUqJSP+Mo71sdUFiszJ+J0aYVCjN2kW3Lud5dxOEjjmId3DHjR1Gp09zgfYGEORFBLeSBeEMNbSlcKm24mYfCiz/wDBpw3uxie488i0xPEoVfnwrD15G/FxXSH+e0GSllcdNmoI9o3i0AZscjzcyImiDVLYqZ4ljBzj8UxLhnLXTqJm2mQWgavwSfVjstV0I31Rfi7+bTTOv9M0mIC06tpTFgOa83CtpP8Fp8noFwNkQBPa0LkgsvgmZw3n8FLyI1LK7fpZUYRgmuYewQ/t9smPYOaENF/6AJTeirWUrctaJJT2MhP/q/HNIdbxd+nSyTkvJvukwkMzPzTj6JzGavRGwPNy6E7T2tQ9RpQiD4ffTYy8Y6LdHip8E7owDsDmywNrOal0QKEocIF46/uYQSbxC+r54QBd4YWIA1wA0sC6wrkqDgFKGSQ/htghiDjQLf705pY8UTsh2dvZy6JJf65DCetqkARjS37R9YcqdH+AC1YwNOPHLsCmmz+fZdT+W7KS3vjVRe68aqbQ8pJI
 Vr5XwCr7
 WSeKD+c/fQxXMcuPBmCJ+w6kgaP+m3MbWXzPp+Js/m3miRkz6xf/blscN8pLb58QfN+42F0nImIbtVpuuTgveNmEJ0q+cMX2zgavszDK7/0Bgu5WSVcbZPyp7IThliBtByWaS6FnB82uh892eBSz46FNtfq5ZGahoYwJuG8D0VZYUkuqXwGLaJbcrRnc7zK55YKD7dWrXrZlhMI1djVOpA1aZdZRsDaNBBhP1dL9+YVQIYBPIuFbSfdoSF0I8Cqlx/4CcjZcxIYe7q+9hNbmzl5JG6HWHovvKr+ha55j1/MwAxSf2YuGg1fcuUHWL5Q2kY+Luy1nkb+Mc2GWOqIITuvNM6omGPhlKq8/CUay+tF0/tpqYUF4UnVLcYB31Uwuwi/7CWZsWPifBAbD2r/k1m//w+Evp4xMGJicZF/fCfv4MVZcsVq2ktHViN5PCljNoYBVHGPWUb7/EJ6/CZPpmyd2xZG6nTCLC3V/eGyZySlFwxfIf0O6ekso/GpKqthQRmEbJEQg1ZKF+r+i5F1O1RteE/5EK1YxF1Yb4zb38z6SlqPXJKNnNQjHEhkAsR/s52guL7O5AThXVD+G1JfGw1YuxFVJVqRApllwudclMAgNbuvwwvbiAEfMs/8XsmJaFtnnbGFGD71Z8lLJCP/kZfwRBYy/96AtZuTN6AE0rlpo58xvZ5GCPvYEJAYg94hfqlSBP5oFx18Ocxn6T8mWDgnBV8mXXjnySYMQCQ025i/IvU1HZHmXvNXP6M6lTWlCDIyw3UI0a6oc8icDEnInk2db3yVbt4RljpKuXa1BzbRbqrOnRFFAYmWnGe1Bd2L0ehatwKZW/DB3Jf1ie760hhreH2H1GFTrXByOv/pv12hsBY+WnJk3fMecK04MyJENVToq24gbDdpJ/5LAIa13LxTNw5pJbAWQqO/EixnRczFDCJFlsMvodvZz5eXkP8OXS3tWpZ+s9FdXNKNQelDSRzQFeJTNK
 654NUkaO
 NKF/fUwN2lZNPJAv41z3QE4nFDxMMxgGgpGSrZ98O1PsaNXRk4Axu0HjZ1QIFp9dU23sCt8HCkk0nWsEdKcSYCIQbkp+amutKs8hxHU93h6lcPmBlDjMGklmJCxBcRWB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[ Upstream commit 0e05a469c29400eb6e35448ce7318581688a1806 ]

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write path.
When memory is fragmented, each failed costly-order allocation enters
__alloc_pages_slowpath() which runs direct reclaim, direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
(simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct reclaim and direct compaction are too
expensive for hot allocation paths that have fallbacks to smaller
allocations.  __filemap_get_folio_mpol() already marks higher-order
allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the caller
can handle failure.  However, the page allocator still enters the full
blocking slowpath for costly orders with __GFP_NORETRY, which is
unnecessarily aggressive when the caller will simply retry at a lower
order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
makes the entire slowpath treat the request as non-blocking: no direct
reclaim, no direct compaction and no drain_all_pages() IPI across every
CPU.  Reclaim and compaction move to the background instead: kswapd is
still woken for reclaim, and it wakes kcompactd for defragmentation.  The
system keeps its long-term health while the latency-critical direct
allocation path no longer stalls.

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
for a caller that has already communicated it can handle failure and has a
cheap lower-order fallback, so exclude __GFP_NORETRY from the relaxation.
The exclusion is not restricted to costly orders: any __GFP_NORETRY caller
has said it can cope with failure, so failing is preferable to fragmenting
for all of them.

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

Link: https://lore.kernel.org/20261001082152.2879289-1-dipiets@amazon.it
Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.it/T/#u [v5]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Cc: Ali Saidi <alisaidi@amazon.com>
Cc: Geoff Blake <blakgeof@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <dipietro.salvatore@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: <rvvandan@amazon.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Garg, Shivank" <shivankg@amd.com>
[ Salvatore: backport to 6.18.y: can_direct_reclaim is initialised at
  its declaration here, so assign it after clearing
  __GFP_DIRECT_RECLAIM. Dropped the defrag_mode hunk: it targets
  4c0ed883e051 ("mm/page_alloc: fix defrag_mode for non-reclaimable
  allocations"), which is not in this tree, and without it the
  !can_direct_reclaim bailout already fails instead of fragmenting. ]
---
 mm/page_alloc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fced085ae4a4..3cc4ccb722fe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4733,7 +4733,7 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	bool can_direct_reclaim;
 	bool can_compact = gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
@@ -4748,6 +4748,16 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
+	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
+	    !(gfp_mask & __GFP_THISNODE))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+
 	if (unlikely(nofail)) {
 		/*
 		 * We most definitely don't want callers attempting to
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




