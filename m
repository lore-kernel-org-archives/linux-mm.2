Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA09C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AAA96B0005; Tue, 14 Jul 2026 08:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133EF6B0088; Tue, 14 Jul 2026 08:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E616B008A; Tue, 14 Jul 2026 08:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF6606B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:02:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52366403E7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:02:59 +0000 (UTC)
X-FDA: 84987246078.21.0040A09
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D79CA000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:02:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=JXzxi9yw;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf15.hostedemail.com: domain of "prvs=6486dc810=dipiets@amazon.it" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=6486dc810=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784030577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xg7sx8Fcwnz35cM6X5s89ftjr56njrrKRxrcpCwNiT8=;
	b=0LQGpFec6U+4ez0dL01BM5OS/u4+kcdcJdH5XJwMpzrzI4zSM+st0pEbpWTTYfm6rgj32l
	Kz/iJfAEMoy7uh5hBNHOFTOvrdG+at2gdHuQl9qQJpsY1QGIbzN6quVKryyj4uJq/C78Gk
	bEMpInhlrSkHk2Ji+Jke9nuVSzOxY0k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=JXzxi9yw;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf15.hostedemail.com: domain of "prvs=6486dc810=dipiets@amazon.it" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=6486dc810=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784030577;
	b=PA4hHJyUuRVzq2i5haWCIbgaReh3v0JhM3ZTRBuJ2uckHpq4FkWnovSL4BfGP5VlZJtEMe
	81W/zoVA0ASM9H/ymKIM0+7Si7VU2X3Csuj51VUdDyJFneW7ZJvtjW56Hiwhfsfyz1kl1c
	VD6UaqxxKaC3wHI9w7Nzrpil6kz0yFU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1784030577; x=1815566577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xg7sx8Fcwnz35cM6X5s89ftjr56njrrKRxrcpCwNiT8=;
  b=JXzxi9ywWJTBdi0I14WVYXtvDVt5DFXIqHrvwTac4Q32CUDZZAoU3vK5
   2nLUSRIif7QYzYvLSN8MXJHdSAE3dkjTGMI1DjXsFGGCJNm01+jU4pPMg
   2CHeqUOYpIIQ2cxuClE+FSJJ8GChmcEhqTxlVN34LM77ss/130OyttD9e
   aw/B3jc6QYqHw6aHeGE/tCZmGktUd3/sh86401BtWwjdwXmdznbTvBZyz
   YAMDBaB7NruU9UAJeBNihueyHBWz64EJBNNbrP+MAym3ymIJJYepJGYuf
   HpW8K7YMdIwS6qvUQTzeWbrP4MiWwVrbHAYiEVpFSLOUYPXRr2m8VIZu5
   Q==;
X-CSE-ConnectionGUID: BBEVK6/MRkyicl38cs1lxQ==
X-CSE-MsgGUID: 4tRkKufeQB+DvyJnPm7R1g==
X-IronPort-AV: E=Sophos;i="6.25,163,1779148800"; 
   d="scan'208";a="23659306"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 12:02:52 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:17218]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.51.175:2525] with esmtp (Farcaster)
 id ac228d5a-c9a9-439a-935a-e5fef6abf6b4; Tue, 14 Jul 2026 12:02:52 +0000 (UTC)
X-Farcaster-Flow-ID: ac228d5a-c9a9-439a-935a-e5fef6abf6b4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 14 Jul 2026 12:02:52 +0000
Received: from cdd-al23.dub2.corp.amazon.com (10.253.66.177) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 14 Jul 2026 12:02:48 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <hannes@cmpxchg.org>, <willy@infradead.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dgc@kernel.org>,
	<dipietro.salvatore@gmail.com>, <dipiets@amazon.it>, <djwong@kernel.org>,
	<hch@infradead.org>, <jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<stable@vger.kernel.org>, <surenb@google.com>, <vbabka@kernel.org>,
	<vbabka@suse.cz>, <ziy@nvidia.com>
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Tue, 14 Jul 2026 12:02:04 +0000
Message-ID: <20260714120204.542300-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <alEz4Chf7Ibyg-ZG@casper.infradead.org>
References: <alEz4Chf7Ibyg-ZG@casper.infradead.org>
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D041UWB003.ant.amazon.com (10.13.139.176) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ktxgcn1amiyr6cymngum4wggoqkpy1dz
X-Rspamd-Queue-Id: 0D79CA000F
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784030576-912251
X-HE-Meta: U2FsdGVkX1/xM780kcYvl9Kce/QdLJNk3aNhpbewdQMgaSs8YRohiPXScRwSiTrgd3xSx9Mg7HcLpIfdqGIli7iwwQ2v9K4YH1tAZ1RTa7x+b2jN++WjkKdIJTrUgZrmagQZxF8d3/H0zn4vnKKBLDrsCHPAlaWPdhuYwipd9uIy04T703hURA7FLJbB542oZrcSKXvpo02bOkpemi2gm1E7VEnWjzQwzoDHWnoZ3VR+FUrXJm8Brag+6Vpz21E7QYSDgGzWEAbvj6UoZKDWic9Z8KQ6VCcxpcUbDjqe15akrwcWpnpq8r4RtGunMd+u1r/OAa6gClfraxknum087NGuIXLK7GioB4y/dWcWHkaqGIWz2MVqv8hpKON82tvpghufkMPBHMGspKGN7HzgjXRCwbaLc8M5LEzTBd718HeA60Yd/iy7JyOxXsR3IwNPVS/1dmx52I4LeFBQSI9MOMKcXPuFwKGqlAdGlWaNKIXe0QJa13JLhpiw9MAndun92ybuVAHMsaM889udNt7rSHI7yC4DFG7WS8Pbv4sNnyqtxLj4WwY2k+OD/7vjcdDpPs3r09EzX+7F5+44T54mRMs9UX3YwuFf++cvJNCU5Vsajzcx1WfqGiRz9inM8Tx6uwAmhUgRrEJFf5B/cbgGmSDI7TZN6+p77ATA/67F3W+jzjuD9AY8qTsUiOTwegZRJk54v4wbN+u0/yLCKLhU5BYi+SBCnmyYeQoO7wB5PhItIyc3NyEEdxHpOsSljidf0fGZ/EV4x+qEvyu5cL1IEK629A/QBh5QWy61YCbHFL2FgMBZ7flH9LTrGe6CG3skJkKG9Dw64OwxjVbzD9BwRlDlVw5VaXpf8Qt2vqQCCwz7eNjnJNCIx7b8XJKa5Zvw+RePZDLeM1MwEjd9dzrIiBDGCAMEoBIKtyA9kIVSPT86qfBTJVRjUb06dlqpdXW6gqC6vocsfuBYmtUq1ty
 3OeUjvNh
 LiFdDDVuyau5/ROCA4UMqo8Vf2aGrq5+aKJpR9vuMQXaOK8tN9xZ5NOj6Q1llGyibOUR9KGX9+CVzHf2EI8PQhtEoMCmhS4heUd1+3DHi/uUl+ei7FoBrNj12KOrmyxK1Wb/N2ZsYqwIlyZmrVCz+6dbzGfgYT8qVYJ34oKy+xEG+kxUpduAqal1uCJhfAW8uC7xIH4ii5q8SwCu6yh+qud312Qwzjloswwaw+7XTqhYaXXVmkTMwIU2O4Le+eNhi01hOHesutK11BtOgxVTk+IJrhBRhHotovMxg+pZGjzvn0iDgKuhafkf+nmFaqltNE4kYRqV89+aKoZxLHRPCA9F+SL1Pe5k5637zZaacBBHaFbF8kL0+k8VBF5q+BN7jO4a4p4PgSPUyu0M7RvsFBb+kKERj2PW5poIoPsZxm5JBtYTwdXfG3FHW82Rltn4sPHsafhBYxMqM17T8V+eZ7z6rQ9z9r18NpqZF89VQ13pDRxyJQkZ0RzP8knOZsSItakf5mFwWJjFFBD671qTiyah5JAJMnxXWZH/lZk4D0oPkxS8PnMRiiSo49LXU9Ma1X5939AJusyGhEBCS/rXPW+fhw+qdxKMAtGi9aBR+WDBlayCkuLMmHhi/nH/uJck3BbMNj0mX2hUljH5qxRa7bxh/mExD8Q5wPNqt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Johannes, Matthew,

Thank you both for the alternative proposals. I've tested both
approaches on the same test environment used for v3.

Results (4 runs each):

  Config                   Avg TPS      % vs Baseline
  --------------------------------------------------------
  baseline (no patch)       70,735       -
  Johannes' approach       156,908      +121.8%
  Matthew's approach        70,145       -0.8% (within noise)


Johannes' approach (clearing __GFP_DIRECT_RECLAIM early in the
slowpath for costly __GFP_NORETRY) delivers the same ~2.2x speedup
as v3, as expected - it prevents the entire direct reclaim and
compaction machinery from running for these opportunistic allocations.

Matthew's filemap.c approach does not help in this workload.  The
reason is that the first allocation attempt at max order still carries
__GFP_DIRECT_RECLAIM and enters the slowpath with direct compaction
enabled.  The __GFP_DIRECT_RECLAIM clearing only takes effect for 
subsequent lower-order attempts in the fallback loop, but the costly 
compaction has already executed on the first try.

Let me know if you have any other variant you want me to test, 
or if I should prepare a v4 based on Johannes' suggestion.

This is what I tested for Johannes' approach:


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a63733dac659..6e960c969e67 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4733,10 +4733,10 @@ static inline struct page *
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
@@ -4751,6 +4751,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	bool can_retry_reserves = true;
 	unsigned long alloc_start_time = jiffies;
 
+	/*
+	 * Costly __GFP_NORETRY allocations are opportunistic: the caller
+	 * can fall back to smaller orders.  Don't stall on direct reclaim
+	 * or compaction; clearing __GFP_DIRECT_RECLAIM makes the entire
+	 * slowpath treat this as a non-blocking request.  kswapd will wake
+	 * kcompactd as needed for background defragmentation.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
+	nofail = gfp_mask & __GFP_NOFAIL;
+
 	if (unlikely(nofail)) {
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,


Thanks,
Salvatore





AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




