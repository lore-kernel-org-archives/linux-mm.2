Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95756606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=ZFa4tTba
Received: by kanga.kvack.org (Postfix)
	id 1A36B6B06C9; Fri, 13 Nov 2026 06:07:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174676B06CB; Fri, 13 Nov 2026 06:07:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BF16B06CC; Fri, 13 Nov 2026 06:07:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7BEB6B06C9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:07:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 485AAC07BA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:07:46 +0000 (UTC)
X-FDA: 85429820532.29.D1D3D81
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf29.hostedemail.com (Postfix) with ESMTP id 16E27120009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:07:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=ZFa4tTba;
	spf=pass (imf29.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794568064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TwbH58rgABqdDOvyTn1Vi8OElH8VyAKUruOXjK+bT4=;
	b=oxK4O0oCxqN3WkQnmk+CZk+KQ0swkf4MMtFbAm2lPvRRpG5xBplpk5OloDdZDs0Cuozcwl
	3NVdqfDLXx2Grr9OBqltj71WL8EeHWwXMwYYlzgDNFnc39b7ginAQ2VXYopp72zPhg3scK
	suWousDEumKqrC/ZnyQ+n/rzDd1vkaE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794568064;
	b=zsnDEL2Cb4p9g8EX3BLV4Ay7+YUjV8mWwEHd03KQKJRQMNqslBcyoEAlmyH6xTrE3sWYgJ
	yo5Bm0SGgaiwv9YU7tQ3M4/ADA/h/f3w//A2EbN5e/bTud7zhZg7OwqUAs/b6JCaef9kk2
	RGIwDRbQQ2wRnLwb3PJ/jT9qk2I1eK4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=ZFa4tTba;
	spf=pass (imf29.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794568064; x=1826104064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2TwbH58rgABqdDOvyTn1Vi8OElH8VyAKUruOXjK+bT4=;
  b=ZFa4tTbaTnVokwzh3naPkC43+SHSsVUIyHgx6AWZRVlxanX/AL2MXw/S
   qWDQUifylGi6iAghW+qNiD91ZwfEBvkBS4DAO+uv9BU/tu2GOJx19k5KX
   u57TkRvPxT60E4zcTkp1xfqFV9iBwpGJ6P3ABbJhdeagOuyKzCuMCEggd
   TGWQF4CxsQ1ArWD3gIuinA/xUCIfag3JKqEsJAA4HFhHADp2n1bdBF0Kl
   mW7up+86oA3yMSZQppe9PS4a0qPN6S6ufG0nqCmZJ64w37igDyI3B7aFv
   NzRB4/cK+ZoKWgx0az1F1/DrRFfQe+aKICrGt0REZ2Iku+aA5Pk0ysWHG
   Q==;
X-CSE-ConnectionGUID: BOO5pMNLROC/x1GaUhp+Iw==
X-CSE-MsgGUID: ZChfMvBJQgC6+nsVagIw1A==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33667096"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:07:40 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:14425]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.128:2525] with esmtp (Farcaster)
 id 7c22aa1f-c3a8-4ca5-9b5d-11e386881a6e; Fri, 13 Nov 2026 11:07:40 +0000 (UTC)
X-Farcaster-Flow-ID: 7c22aa1f-c3a8-4ca5-9b5d-11e386881a6e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:07:40 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:07:38 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
Subject: [PATCH 6.6.y 3/3] mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Fri, 13 Nov 2026 11:07:24 +0000
Message-ID: <20261113110724.2920455-4-dipiets@amazon.it>
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
X-Stat-Signature: ek439d1k3sh7se5grerckjmky49j6inz
X-Rspamd-Queue-Id: 16E27120009
X-Rspam-User: 
X-HE-Tag: 1794568063-282573
X-HE-Meta: U2FsdGVkX18muCcLXS3lNHIZft14/Vmw2Wp2jL/NUclOxRWqmqTm2Ia6VM8t3AxmqL5HP0D75ETqoUIYFtc2EALrZJwFE6tJSPZumX/DLKD+SDQvbw66hetHbRg7OCMVf1bkUpKDTiEijwyEkTLcLxFv0hGeubcLx8SUs00dBoOV9Uhbod1s9I9cLl0yYzXC8sETDidSCiwk8uRAUw6sonegGlVTzv2RyIro0uZJIV9oRK94NAqXtRH0poQCAVZlKk62KIjGfbg2Busp47rrL3zo6B5/Po6XeZdp8TAOTwebBYs0qLfO7bDRFifV4T1UrD3+3lYzGNG5OVUUZMMr7xIGJt3Wc28meR9XU07/6RYveuMN1USJnRg8faqU2NwF4gvPuhueVBhvtVKGheaNWwxjF7Aa7/bPJD7Bp5cftib8PAC3pI8r8djDT6i/7V9T7dLfcz4NJ20WL4N6fFA4R/r5SPqXnazrtU6gJJAogYnAqldITThGZvOX/stvSOCOa6oKUJPWXXyehQS38G/LViLKfj8Z0+EMBWxOdgpVk82kxssTjIVRWljdjsFOj3Nt8y3I0C2eC4Ue1vgnXoVerPelWvKp2x/M0QXVYhzaxw+b+COnNpuiUg0s/LKlO65ppfg4bk74FZXommdLnhM1hpqQKKPZwuyhS1z4MTfojWEomMoQJc141TfWgDQzi3T8WB9meaHPyo2EWl+ZJF9uusL8zVPbt3rdpNU0DbFEEa5ZPxhh53rFaGM5uC97QHn8WG0cVKkDyNRjLeYiT4N4qWHALXshVODrLLaaSCnV68q6zF3JtJWxjhT7jg8H6bn1xRBrvBRbcIfofp3wLQohaw1r1x/tuSrTnxcqT4MFkM3zPsNAFM60OL0qfgtEzt6mFdIkO3t0V3AKtw77TbMDRg0kDf0ZHTUjSx5YuLkEhM45stoq8Xfvf7GYA5Awy5GERFIWgAVAfzhLpAFlutE
 lri2aYvf
 VhaL4Z4g2aH0wzwB8E+JBZe4GO/ex3WtCyczNo0kDKj2SPykZFuW+pR1IGFE8v09BhtEnl2+nQCXbsdHDixlCIP+PK3A8KccW9UheCBYvMFF+DxYo907bvNnPitUCZWw8eirtfcdrYwiWNdEKPKR0VAQ6N2/bCCy569hcbMvsew4k/sSuuJ7na6H/LNMl07XntYnd1AElWXsr9kw18ugG613mG4RU0O6Trr6uw7Wlt9UEd1BdLst58z0Ra8mavGlfGf3DuYO5uvwVfm31CcPaDp5ykjt5vdAvzWyef5Kw/8WA8MFCTG71ZanWmVRGWNPO+93jNVtP79w1S4Ej9DL1+MPl08gBxJyVWdRa8Mv3SNulc6lmQDUZ2YQ7jkZbL75QaJ3NvJS8GF2G0+PmIP8bMsicuNo0WmWu+GWrrZYnMoM1BjjISAAqHZXca7Z7ipORS2CPJLn0to7kDvuaZwM0nr086485FQWbQJ6GgiOQ8U8B3WVZujTSGbI8SxeRSHr+/2GCkuK23BRJntf8lk0KXnwFsaHVbj2IgysBsV8r1v963wSuEeIy9W8B94ajQXa6v1vAN1nIsPnPYdl7wZdeHgyDoZM40fTHRApFGz2aXKPcNcAt5AmpF6WYVnZHrFo4nRsi7k8vS3nq2BndX83tHfBkCSvMf570s1g5QCtN6KjSEj/YhX4ibj9/8Tpx/1GoAwESgK3i2knC8Gt1V7TgbpHoCbe+28trw+Ws1vjbJm9vCJyRCwZEACoZcYp98t0c0K4JXIcj71yqwcpEs4Szf7SEDzXR76YSVyiqE1rsHkHaz+/05tjX44eaKChuvdJP+x0mOyQYQFe1k9C3cpyRX8w0Ouu6E7QGyNChRHNf8Dd/SbnrVlQZ7OhfNDzaY4QP/WJW1Zp28CLX8iKftYz2HKkFEMfbMmsdrhwM65kZrAEaPfwWqpaFAt43HFFe+eCQjmhZ25nHdIyZwf6rDSjKsXyxGTr0
 9ruZnYc9
 J7lA+GDg33Bo901NwtjP+UqWb+iI4nfzNooOPZ0L0cCxtL/Dmcre/tnXB0HXZpfDfvO0q1tiCSrATZF2c4OO60xKXfVk+rmj
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
[ Salvatore: backport to 6.6.y: can_direct_reclaim is initialised at its
  declaration here and there is no early __GFP_NOFAIL block, so clear
  __GFP_DIRECT_RECLAIM and assign can_direct_reclaim before the restart
  label. Dropped the defrag_mode hunk: defrag_mode and 4c0ed883e051
  ("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") do
  not exist in this tree. ]
---
 mm/page_alloc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8ac6556d19c1..02993879aa23 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3950,7 +3950,7 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	bool can_direct_reclaim;
 	bool can_compact = gfp_compaction_allowed(gfp_mask);
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
@@ -3964,6 +3964,16 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
 restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




