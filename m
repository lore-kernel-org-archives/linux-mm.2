Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9586AC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE096B008C; Wed, 23 Sep 2026 05:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795456B0096; Wed, 23 Sep 2026 05:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC596B0098; Wed, 23 Sep 2026 05:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 321ED6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:26:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE1DE1C3443
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:26:25 +0000 (UTC)
X-FDA: 85244496330.01.66118DB
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf18.hostedemail.com (Postfix) with ESMTP id 591431C0008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:26:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=oGGEk5YE;
	spf=pass (imf18.hostedemail.com: domain of "prvs=719a38815=dipiets@amazon.it" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=719a38815=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790155583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cN5MLZiwNeqRdcxWX8m8G6mrJrXWNABdWnBEab4FCPQ=;
	b=VYJ9Xq1DurTFNPKuc2uE0RM0jp/V5rRKRepI43LHyjO31W++dXUIrK+tBtyDmZrDkv/r8y
	ta5BqUXA84vTUXhOpPD8XEby/mI55/6J/37fpDUEhTiPZqDtXLXCb81nNwNj3e+6h5dzIY
	EH19aiLKt1CByHyUHbng6kPmuUGM0/E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790155583;
	b=jn8o/ON4petVy9HnUuz4VdaKqU/36bBWiB8lg5REPbY6ZXbSwa0saQSxbREVAGiGUDdqZf
	0ZHO+K8xYe+nn+i1IGBKROl6YPCF4ILoIRxrKRRKwAborwi2ZcIYOnuUp5+EQKe618iGJ+
	o5DdUXi8kLfbbzqmCtJhQ8gnvjIZyKo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=oGGEk5YE;
	spf=pass (imf18.hostedemail.com: domain of "prvs=719a38815=dipiets@amazon.it" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=719a38815=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1790155583; x=1821691583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cN5MLZiwNeqRdcxWX8m8G6mrJrXWNABdWnBEab4FCPQ=;
  b=oGGEk5YExfdKtGDkirTlu0eBCqp0xxa9hyaH5KPBtz3HPgmwfIoys0eo
   EYxQPtEctU7xkkjtTIDaD4tWFSfwSZN7WXPRivznPvDDx3aGj6B9cKRVj
   Gt6wu7r8TX0AEDCqPbh39qExcuocOd9wUFG9etQ2y/OUr0YA3eGj6aXEZ
   rK6JnSfR7/VHr/gx3hVPy/VeXrTIJW6O5UOOmlIkfEIQs+PE0Dv0MN1iH
   gw7+MKKHEAHfx0r4P3a08jpekI1d2LoYBHxAhMlxh8qBc+ZS31lWiTJ2T
   rQs75SDXhK4XTPElGSxOcQG+kOL4e/q5BXLPJqRtYsWm+pMqrW/yJwLDU
   A==;
X-CSE-ConnectionGUID: Swfc1b/cRayzY0r31UWeqw==
X-CSE-MsgGUID: rikSOqHrQaeO+po9b2UnIw==
X-IronPort-AV: E=Sophos;i="6.27,118,1787011200"; 
   d="scan'208";a="29214507"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 09:25:29 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:5405]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.59.1:2525] with esmtp (Farcaster)
 id cd567582-b90f-43f2-a34a-5f02aae20a7f; Wed, 23 Sep 2026 09:25:29 +0000 (UTC)
X-Farcaster-Flow-ID: cd567582-b90f-43f2-a34a-5f02aae20a7f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Wed, 23 Sep 2026 09:25:29 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Wed, 23 Sep 2026
 09:25:25 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <willy@infradead.org>
CC: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hannes@cmpxchg.org>, <hch@infradead.org>, <hch@lst.de>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <mhocko@suse.com>,
	<ritesh.list@gmail.com>, <rvvandan@amazon.com>, <stable@vger.kernel.org>,
	<surenb@google.com>, <ziy@nvidia.com>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Wed, 23 Sep 2026 09:25:12 +0000
Message-ID: <20260923092512.101833-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <6c94405a-48e4-4842-a096-e2fbbbaa862f@kernel.org>
References: <6c94405a-48e4-4842-a096-e2fbbbaa862f@kernel.org>
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 7g88yn3u6im18fgp5q9az6ceustymrq6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 591431C0008
X-HE-Tag: 1790155583-239218
X-HE-Meta: U2FsdGVkX19Hjv6vLGijrxGlN6/+UsM8jePudPulTcP6C+HZBCRFWSWADlBSU3m0A+qhflL4iiO7zcTbnfV2R4kJcjikXOUybh5jeC4hDCPJvFeVT4zHJY6M/XK7m1k2XKI22Zm6CggWjfQCp/DmPbQ6zP3lVDD0SOAKtOZkrUusDJGAQ4qkmt4P46I9ucFPAP5hXKItEa97eLd8oDHW0XKD/0ViCCd6Jb0UmJdGlFhEKN4JMuC5hMp2ufc4Ep4fuYJBZm+jUrZCKeVN6gXdOX2SXfYzJe7ZK8tCw25RfBCJV1+1BKT9saVa/mbJgvv9zUdE9Abo7LdHzWniQ0lv4y4gpjm4c19em7FTFyU/t0X+UP7wvM+9j3ZREuVvQtUR5JAaY7sTIFo5VAFu0rHYf0YhgkUMMmha2D+78bIr8/EDWp3bAvSoJXCVMgIUKW4c9mG+YhQ8UV+MxDi+rgsAM57p6zx73Am3cb4alyrEOgPEEXGWeHgU6s+gVhtXgG50bddFwX5hTS1hmY0XhfPfH+Xx2Vq+zE6ZKcJyKjLysawqewopOxDpdCM6SO7rl3BpLw9X65JwcA5XXRPIa6/fSbzgeW/iX3UMjo3McNBeOAEOBhGfNAnytlDMgWyP+XbA6Rd+9ILxfDgM0VOyRsvzJGVpRRSttKgVAdT2vP37tNIZ+b8xby17R0BDDZDnuvdo1bHSQ5+RrEjIkYM4aA7Y1u5Tn1U9eSVKpwas0WEyMfT/tXOrC2+QYS4kDyohRxQRKj40KhRLWZFU5YZhNvEa12cEFpKZXeuO1tFq0S7fUVYQq5qAz/bXywB0XCq5AoOoSxWGSbyBG0IzzbvBQJLv8++liFEyucqehRQ+d09QCmdFRz6Af2x5spIMbXONFPcFeWDIqSOIKcobSkiS1j4EPxzuxq2Nz3Ca5ccWD8EClFm/tD5gqTnOMEegCzIOXpFFHUBFMkCq0kmKOL6YQin
 DwsdJO3t
 AsimLaQKM8WpwP+jIqqQLiS9fNGa8/eBOL39wBPbYM1wexJ1Ju5MiYWOxikxlWELTRQ4VcsrW/z/4MuNl377xgbEVSjlWNgR73wZyjKu0Sfc8+6QK2dZ6Gr18WbtE/p79XtJHBWo0KXBMU3RysO0hsJZRwmw9k9lKVq8YyGxfMTVXyTG7bpq4v4zKpXUmFIkIpNEmERm7KnQbHCchLVaz3n4h3WBFCL3uolUwSF8nYoLI7MOz9lQFX1MUlkMpIqJp4bY6ic+0rs6vlcvaX1GVDRLUv6cmP/KaK6uLKWTxWJ5HRcqT0q6OxOTWfMqzlXFmEbapoK0pvc+y8CUGPgAhEySlGnHjZNCahrnTrlVCgE9lUb8bR9Z81stG7i9a5kM9OEmiLc/QLrGgugG38PaNzLJ36Nky17pgQDg0DCVhsl6zhf45QJ3RB+TAlfd8MCYrvqPxM8PVnXhAet1Qy1Yvt85yyDerx0aA3pvmPx0NoCnR3luhx9eZRKvBxihUbnGonecq7usg4nrmWmqenRNlzPKGpNiKDMHPAoZAH+yhYkCrX7Hv3ssFsMHU7F7l3FMTq5qw3IJH0QPIni0GZJcmrsiUXsWa0XqY9Elulh+UqLanifF7LrMZrU7D31yT5jpRyDbrhBp1XXAOJ3jRwRrDB2kSG28LELlMPCPUBa9zvtjATq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/19/26 06:13, Matthew Wilcox wrote:
> This patch is still piling hack on hack.  We haven't made a serious
> effort to understand what's going on, we're just adjusting flags until
> things stop sucking.

I have tested two new kernel patches on v7.3-rc1, each isolating one behaviour
(diffs at the bottom), and ran the same pgbench simple-update workload
(1024 clients / 96 threads / 1200s, 3 iterations each).  Baseline is the
unpatched regressed kernel; target is ~135k, the pre-5d8edfb900d5 number.

  Config                                          Avg TPS   % vs baseline
  v7.3-rc1 baseline (no patch)                      59,408            -
  (a) post-reclaim drain step skipped               70,615       +18.9%
  (b) compaction disabled only                     107,210       +80.5%
  (c) v4 (full non-blocking, reference)            154,835      +160.6%


We can notice that:

1. The drain_all_pages() IPI is not the driver.  (a) skips the whole
   post-reclaim drain step for costly __GFP_NORETRY -- that is
   unreserve_highatomic_pageblock(), drain_all_pages() and the retry
   together -- and the entire step is worth only ~11k of the ~96k gap.
   Whatever the split between the three, the cross-CPU drain cannot
   account for the bulk of it.

2. Turning compaction off is not enough.  Your gfp_compaction_allowed()
   one-liner (b) gets about half the gap, and it declines across
   iterations (135k -> 98k -> 89k).  It drops compaction for
   __GFP_NORETRY at every order that can use it, __GFP_THISNODE
   excepted, not only at the costly order v4 gates on; the decline is
   consistent with the zone no longer being repaired.  (c) only makes
   the costly attempt non-blocking and leaves kswapd/kcompactd working,
   and it does not show the decline.

3. We have collected metrics to understand how often the
   allocator stalls and normalised to a million page writebacks (nr_written),
   over the same 3 x 1200s iterations as above:

                                        compact_  allocstall_   pgscan_
                                           stall      movable    direct
     v7.3-rc1 baseline                       513          277    90,230
     (a) post-reclaim drain skipped          912          472   129,249
     (b) compaction disabled                   0          778    44,737
     (c) v4 (full non-blocking)                5           39     4,407

   The baseline enters stall compaction ~100x more often per page written
   than (c) does.  (a) makes all three metrics worse.  (b) removes direct
   compaction entirely (0 stalls) but does not remove the work: it enters
   direct reclaim 2.8x more often than the baseline (778 vs 277
   allocstall_movable), and still does half the baseline's direct scanning
   (44,737 vs 90,230 pgscan_direct).  (c) cuts both instead -- reclaim
   stalls 7x lower and direct scanning 20x lower (39 and 4,407).
   That is why (b) recovers only half the gap -- the stall moves from
   compaction into reclaim instead of going away.

If you agree this is the right direction, I am happy to send a v6 with
(c)'s behaviour plus the defrag_mode fix discussed in the v5 thread.


Thanks,
Salvatore


---
For reproducibility, here is the exact diff behind each measured row
above (all against v7.3-rc1).

(a) post-reclaim drain step skipped -- 70,615 tps:

  diff --git a/mm/page_alloc.c b/mm/page_alloc.c
  --- a/mm/page_alloc.c
  +++ b/mm/page_alloc.c
  @@ -4487,7 +4487,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
   	 * pages are pinned on the per-cpu lists or in high alloc reserves.
   	 * Shrink them and try again
   	 */
  -	if (!page && !drained) {
  +	if (!page && !drained &&
  +	    !(order > PAGE_ALLOC_COSTLY_ORDER && (gfp_mask & __GFP_NORETRY))) {
   		unreserve_highatomic_pageblock(ac, false);
   		drain_all_pages(NULL);
   		drained = true;

(b) compaction disabled only -- 107,210 tps:

  diff --git a/include/linux/gfp.h b/include/linux/gfp.h
  --- a/include/linux/gfp.h
  +++ b/include/linux/gfp.h
  @@ -380,7 +380,8 @@ static inline bool gfp_has_io_fs(gfp_t gfp)
    */
   static inline bool gfp_compaction_allowed(gfp_t gfp_mask)
   {
  -	return IS_ENABLED(CONFIG_COMPACTION) && (gfp_mask & __GFP_IO);
  +	return IS_ENABLED(CONFIG_COMPACTION) && (gfp_mask & __GFP_IO) &&
  +		(!(gfp_mask & __GFP_NORETRY) || (gfp_mask & __GFP_THISNODE));
   }



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




