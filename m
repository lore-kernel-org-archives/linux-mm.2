Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFC2606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=cs24fn99
Received: by kanga.kvack.org (Postfix)
	id 7B6786B06BF; Fri, 13 Nov 2026 06:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768316B06C0; Fri, 13 Nov 2026 06:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62EA16B06C2; Fri, 13 Nov 2026 06:06:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3582F6B06C0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:06:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AAD261207D9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:06:45 +0000 (UTC)
X-FDA: 85429817970.06.B42E626
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7D76F40008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:06:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=cs24fn99;
	spf=pass (imf27.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794568003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOfKcCjPmoFVxNvHRsMjSuV1nF3lxCw3Rbpal3XJvTQ=;
	b=O69qaDDY/WWtSrGh2kWJRRm0Gu658Vd+C0Mok8A5M6KiIHhGFh9V8yiw97RSFYRoiAngwH
	JiaK0lOmpjRzhfMCK/qPjxBi4jC25lWz6/+KuGT79i3hcp/h2/d5ZU0Ewj5O7kTQBqGxQY
	03YBwhZ0OOl/O4aCf5RzT01Y7oxXcP8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794568003;
	b=eO5uMNHMN4TWdRfnkt8mv/zOA5WPForQmVzWlEDEL9EfwxkWGo5LxKQ2ww1ox1p1wsj92D
	/WmH+L1dxBXljMMtCb5faz3+KAJ5cLklJjkqay/v0Gb1PRP1/Fxp31uyBcFOiWaAroe8Wv
	uAKYu89Vyv2Qs+PECEuBMzxjo6SDiJc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=cs24fn99;
	spf=pass (imf27.hostedemail.com: domain of "prvs=770a1a5e7=dipiets@amazon.it" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=770a1a5e7=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1794568003; x=1826104003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aOfKcCjPmoFVxNvHRsMjSuV1nF3lxCw3Rbpal3XJvTQ=;
  b=cs24fn99Cx/KTbWIECBtAqMVpE8cCDiw9eE3ltxfBUnzzxa/nHfqWlgg
   UyNTe6zVSB0icdWXuW7DG1hmSzlqGesNmEl/hemHpDm8jUkjtO8kwhiUM
   GRnXFfmE06DO0fWNR0wZDqUqMbGY1owTAQLxKcnBcHHfF2gIAA8WzUo5V
   s/8CuPnE48Y1KSHMRC7ddvM3C0WM/Fn9nKj1BGt9QI0CkB85w7QdIw38W
   hQcbkrlgBRhDK/ecaEFYsczJgzCJApKGfFAQfpm8i9wHsOU9YqtGijJ16
   8YjRYFy5eGt5tlEWvBgFc/lPTU0Gf0ZKR3+EAnbmiRunuJReRskmAg1Cb
   w==;
X-CSE-ConnectionGUID: QtgUMWGqSt+p3CFB/WIkEQ==
X-CSE-MsgGUID: Ggj5FpeGQJSWZsyqo9GNTg==
X-IronPort-AV: E=Sophos;i="6.27,211,1787011200"; 
   d="scan'208";a="33653125"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:06:42 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:13314]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id 9c504881-c221-4689-b6dc-c42f93e91edd; Fri, 13 Nov 2026 11:06:42 +0000 (UTC)
X-Farcaster-Flow-ID: 9c504881-c221-4689-b6dc-c42f93e91edd
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 13 Nov 2026 11:06:41 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Fri, 13 Nov 2026
 11:06:40 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <stable@vger.kernel.org>
CC: <dipietro.salvatore@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
Subject: [PATCH 6.12.y 3/3] mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Fri, 13 Nov 2026 11:06:11 +0000
Message-ID: <20261113110611.2915381-4-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113110611.2915381-1-dipiets@amazon.it>
References: <20261113110611.2915381-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qa1x3y9mju8uer97psks3za3q7y5duib
X-Rspamd-Queue-Id: 7D76F40008
X-Rspam-User: 
X-HE-Tag: 1794568003-968040
X-HE-Meta: U2FsdGVkX1/MP+1E/hIadIK5DLeEXjT+7uQJSBBOKrdUpZYWz5hjtFm39BhUZJivR0Kx1NF+gxGWGH69F/oeze9tJewclmNZjTSuApF2B29ApRnKAoKtwUkOnvtYCMBeCquw94FTjUDpRPTmB0Rc2yTsD0YoNUI1vW8wxlNFzjYgUfzwrrYT39G7WOOi6fenb1iFjKS8aqBipeXrslY+bV4fnOjP2s/4iOEDM/1bxphHnKSRyfXnW6gv6w+yFs3PLYitYsz83vhIYO0Zz78X9A603in5nNUxr+FmrvfEe4lRpDsa9NHZyJMkTLuHBViZpFdv6u8E5fBnxy2+Vzqhi9GCMF74TCGSioZVbP4WvK1uZUcVXftT7oEtQbCbw0fJYYzE7WRsAju5UA2O/vsFu1v6XRV9HCNR4sWlYtHsFF0JMGi6CnAOa1p8YCbGm32PC9qW0v7njd1JVnTJ3ajgHGcgTXHtU8agF7UBq25LQeD9opeYzNxKRmSoMzfUgq4mSc1R9pzQPSmCWA2jUKYQO3KqZnhrBIQJ38r6riKHz6KhgrS9nj6+xXrTXt5p/Nfms/98TkQvDQYZSWMS9RWdhzd0dGjmEWpKa6nSJaGurJ7flO/bkQzUEfEve/XW4zQYpTChWzRuC7BiP1m4XYKxMBRANkINqaAjQjTgnGESX/gsYdKsuCjifOmT4ORf7ngMNhViyWsse/1X3Nh8/zQNAhR/NbaF80Y/thdSl0Qlz/PCm4oEuxqbl9YjgA+u2wJkmDbtl81RwbXe1vHUOvMmq+jYrd8V8i5Cr2VVfLDIWYSCNqPL3HA3Vd26EooudpxxjqrdtxBHnVZ8gffuH/sF5gA5789EeQV6LEUxDTEuJlbBurPOdcCKNRePclAuuFYKMBomv5Iqz+ySGZkDFWxSlrG6VUrzgBPlY/RsCrwMPOTZHPVHXld92omcLIwYaAz47f8LCDU0UpZbwp++8qs
 DtQ+H+Zj
 eHOHwqy4WAwP6TtQanf1WX+bTLKF/cfp3I6KxotCx2dZf2doJ3xyCnkh7hvjw5cWytC07OWlCWq+DNMXe+zwTWIkRdkno712Dm1iCzvZ88Fre9VnqK+RFF+fj/98wVx4O57Rshesk9ptJtIAroUVQyv9eb+kEtJYTHHnWN+K67r2q3Ya3DDbXgvVmsl4x0SABt/mDnsSsqywHEeIGtl5YPG8aeEQjZJh5zAfS6sC44llJcS9qpn3dseUxoAtzSWkm9kfw3PuQPPQc2oa4nn/zRgAa2k4r0A6gS0vrQnazpGdGbOh8O0cvdzg6Cvs7Pvj6dopLzyWN32dN7W9W1IBL3DTohozIuvV9kc+vLXhFZpqVHOw8BaZBnGwcuAYwkvt736oZJx650e57nRMYjRVI0Uskh6/H4vRuZQceFOhQ9yUz3/eatRPkg/By/hytmGiY0dzohNe1uNtZ6OIYCH2iFtLV4HBFJxxyReVONJVncgZvjA9D1gBonYIwgiy7XhTAU94As19EaKJoGJX/IAJIFlxGeg+usXVA2Je1lFBxqc4KXPVfgoAXVVbyhMChi1103sT3sUqTi2ZhQVaimv3zxwAWISqwdSXfLI35U2k5rKvcXt/MEIeclT1NxKmojZ4IxWwq/EkDgCVkv7FoehXFnoNjdg6uqGSx+lTrT3sd2/iFhrEl88hM7nKcGu9fDdsrF8ZWkO1bqeHKDHrm8oGMZAQiN8v8EsHfyD/gNuqp0VbahbOagCWVgDpsWeEe9awDK24k4jKXAfAaumWKCO13lXpI1d0U6/xS3ws6zHpOaTJWLHVlbUK+JMDsd2ZNtFCSZuf2x5+q/PLcKH6KusBJ5O6IgraKXPbUBoH5J5ZIo99ohxh28Onxe5a+8fHx55rR6GtI6B34vMf/JAPHKFVm1c5h1LZi8UelPiZmx0NqdfIfGLxa31JZd6mLBSYFAvOdtQM6dzAVUhNEunxjqKL3SHx9Q2NT
 DBEy7VgZ
 5/UfKRvuf+Y4oVf70FrVlzK9sQYks/MkqkT9b+baiui1ujy3Z89Eo7fLFrdjG13Pmv8tq2ZAvUZNPIpCLjvJC4tm32I6ObEx
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
[ Salvatore: backport to 6.12.y: can_direct_reclaim is initialised at
  its declaration here so assign it after clearing __GFP_DIRECT_RECLAIM.
  Dropped the defrag_mode hunk: defrag_mode and 4c0ed883e051
  ("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") do
  not exist in this tree. ]
---
 mm/page_alloc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3ecd3fd76cf9..999ef2224add 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4278,7 +4278,7 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	bool can_direct_reclaim;
 	bool can_compact = gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
@@ -4293,6 +4293,16 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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




