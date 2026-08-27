Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E23C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D67C6B0092; Thu, 27 Aug 2026 05:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986E96B0099; Thu, 27 Aug 2026 05:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876106B009B; Thu, 27 Aug 2026 05:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF116B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:21:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D893BA3B77
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:21:35 +0000 (UTC)
X-FDA: 85146506550.03.3F51536
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf14.hostedemail.com (Postfix) with ESMTP id 60198100003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:21:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=TcIb26ae;
	spf=pass (imf14.hostedemail.com: domain of "prvs=692c25607=dipiets@amazon.it" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=692c25607=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787822492;
	b=BZGVWcAaEnrEmta3DHMgCN6NHEJZ9yYMVHy6g9QJYcAHLsISe770M4top6qXBZo2Rt0cng
	JzY37kZ3cNg8R2TXJ6dIVYaOfZ86DL3GwrhGRb9TEQRumEjgMREn8R0cVaaQLwc/r157w+
	sCrOQSXi5tXPdZfODE9bqlpUBGUKbVg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787822492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7TNb3PzZ5LF/z0aOAcLHf9VQM7UzSXd9dJnzyzxr1A=;
	b=WedMNcfvT7Y5M9C8glerjtzASejbsGlpxsqCxrpUdhGo8yaWb54bhCUxdpjxlKfv7TsM6e
	kcjkoYFMGXz/92RXYw6fHxKQKCw4qK2nACeuwQpqODC0glfPPAhmOyiT2VVr+FKnjdaD2v
	Y20VIEEQ2VpGiWcPrkBvYsqZzBvxYaM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=TcIb26ae;
	spf=pass (imf14.hostedemail.com: domain of "prvs=692c25607=dipiets@amazon.it" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=692c25607=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1787822492; x=1819358492;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x7TNb3PzZ5LF/z0aOAcLHf9VQM7UzSXd9dJnzyzxr1A=;
  b=TcIb26aepph8I1svXIYJHJHOE/pjB/sdl+tEiV2wlvfyNgaushtLph0x
   CNnfNqm9qkjuln2Uvpc2iJAili6EaOx4F4JzS+hYqPk22HrmxunsnM5NP
   967TvwM5ei0Q1vTO+eCjcoUojeRZTCKpS9KQIXdFpvPSnnTbSY1LoygSo
   IZZGu8/wNjrK11iMixK/0PGGqeEUQFaquvXwMO/Mnwggdlyy3LS3NCqY5
   kyoCYRk+Fb9s4P/Bk/oPxXl6qMQEY68ViFGE35sl6UIlPI4MQ89GGTQCf
   0IXRngj9j0LPrP7S7wgQxCV8V2a7yVy6CEWkSPQwWr5VQD2JepBOmAjeS
   Q==;
X-CSE-ConnectionGUID: TIVzVIwxQRGxNhHQ7zupIg==
X-CSE-MsgGUID: HUlh8tT+SpuI9Eceq6oHvA==
X-IronPort-AV: E=Sophos;i="6.25,246,1779148800"; 
   d="scan'208";a="26899945"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 09:21:28 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:31814]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.244:2525] with esmtp (Farcaster)
 id 3d6197ce-b226-432b-8cc0-0137c0d8e6d7; Thu, 27 Aug 2026 09:21:27 +0000 (UTC)
X-Farcaster-Flow-ID: 3d6197ce-b226-432b-8cc0-0137c0d8e6d7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 27 Aug 2026 09:21:27 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Thu, 27 Aug 2026
 09:21:24 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <vbabka@kernel.org>, <hannes@cmpxchg.org>, <willy@infradead.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <rvvandan@amazon.com>, <brauner@kernel.org>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hch@infradead.org>, <jackmanb@google.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <mhocko@suse.com>,
	<ritesh.list@gmail.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<ziy@nvidia.com>
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Thu, 27 Aug 2026 09:21:00 +0000
Message-ID: <20260827092100.3988386-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <7ddb704c-76a9-4071-8969-06fa1403eb07@kernel.org>
References: <7ddb704c-76a9-4071-8969-06fa1403eb07@kernel.org>
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D040UWA003.ant.amazon.com (10.13.139.6) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 60198100003
X-Stat-Signature: uxk3ebc6ay7pjdky5xmu1p37rqsqwjde
X-HE-Tag: 1787822492-531660
X-HE-Meta: U2FsdGVkX1+2a6b8EPfF5CreueCFi3zMQNkLpkDqTLHQzQnZJgUmhtyab3YURM1wrCjWj34CPcCKqHr+zQq0e6Bn3/w5z3OIqYPqiCSyfSmGh4RqmSES+3gqyVd+lFn7TQoENNgnoaa58kvsE/9PoN6X80OLp5sNafH4bC9eFmYVhJ7vBNUNJjpGElFH3QZpGaVSGv5VQxdWAkO1uN5ioDnW/Y99Rft2Eyb+HFQCcdk7CDe8PrGRVWJHrvo1C6FVCkstC+Vgb0cSzqI/SyURlLZtXkwJImYKl5B/loWrD7JJ96HCnaEfe9xOfz8KtnDc9N+mxYw2Uh/Vciaj1fyqiKF7S7J/1n+2pwpfpwT6l+n2MD8TK4XwbSwDSySVIAl/YfmeGmgtb/rqAESJzJkiNhojcAlBwHLJKWaKveCKF+CJ44aHOOzZSd9glPVtgeMNuvWjYYdVuzdB+ADanPBhxvV0oxO9XIdIAdVvqUcMP4s54N/LhooKjdr69tdusYMTIU1RMj2ZFwHczjkWldAlWG9BEFk3Vl4upwsciU+cVOG73QA+rljIngSom3GpY8UcKdFOeipqVsiEkx+xSfX5SLA6YZhRaQkAplDyysbWidtIq2FXQ3cs3BZ/f4kKJVgin8pCl7NqHCfqqhTi8dnF7I8wSwsZayhI/Cto29JJWruN3lpiZYfrrX6fSCg9Ehn3PSejHOgXjnjOuXqD6JCZbVq0AVCgTbrREHiB67AbgrnCTvSDJZF3jgBPPt9HM8L0D0Htp6VBlQp6rsDiTHOP8yVXj46nl0T7pUCmAu7QiC4AUCNCq5Oa4yy0ad4F+/tzqg5irxoCpI/K3Rs9e2KbTgLz3dVwx+z03bFfzBOaWJ1ruVY9gcmlRezs6ViFyos63InkjpBdQPO30V+fp1AX6baw1amrNYQUZZdJzqdskhvZZc245iQMbGluu/5TMMVEOJumr0ppcaLtxrHxYus
 A4vbUhlI
 rEjjJWAxjTjVcvCn0unAf4L882mH2d3QUGDrRROlejqgUDvfsNi8kiut9z7G1O1J1Dd4GbyG4lPnGQsswdu3l9twPl8OIpQUO+u6R8lNF+x/HjjfybDnUYpwgR8AgDUuOKmfv8Kh9iObVFtNF/IO4jVFaK99+wIQE4SuUaRPI5TYgA9RIm80pgk6Hzg7fCHVK/qkFMhhNPg2Hl+ypvh4SMekMA5bseAdrHJIv91+cenGv0Q6CkxdYBqGrlIhNw6b86FD4LU69UJ5FkEWoi5nPXktpZXd+c4PI0AJGxhv2G60stANLIH36koNyJ2VTa7DZqQ5BqOjaI7jOY16xTG5yAm/ylEb3X6UULy96psTtlJ862mD9IR2NfAOMbFeZZiCy1JWPMNznRf01d5pJbgYO/y4P09h4rqEcla7pnhu2zwnbdJpbxfuXPGXU7WtEeGvRADB1kjXCTwsXq8wrTo0RQV6CelpMEOLECmKa7ERwXR7i8Vq8qiqk8yFhuGEeeXM61d29fsaqrwlkgTHLlcezNGafy6FybwVGcXMutGgxNvn6naNtqmzbT0xSRIXzn3FaBIU532T/O2THep2dE22hQdbVlc8nYrJq7AhC6dRYhJ2yO6xKVcNMQhVlAGJCgTHa6y3mgBGcgNfP6jcEDowOQLYvzKpJUU8t9/+9AsnTGaMgKm0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jul 22, 2026 at 02:35:00PM +0200, Vlastimil Babka (SUSE) wrote:
> AFAICS both your v3 and the implemented Johannes' suggestion effectively
> make all the compact_first logic dead code - at least for the intended THP
> use case based on costly_order. It will only continue to do something for
> the non-movable order>0  case. So that's a significant change which will not
> show up in your results, but might affect other workloads (I'd expect mainly
> by having fewer THPs).

Right - the change above modifies THP allocation requests as well. So instead
of applying it to every costly __GFP_NORETRY allocation, I restrict it to
callers that do not ask for __GFP_THISNODE. That leaves the local-node THP
attempt untouched: the same bit pair is already tested further down the function 
to bail out of the compact_first block (page_alloc.c:4899), and alloc_pages_mpol()
sets both flags on the local-node-first attempt (mempolicy.c:2476-2478).

I tested this with my PostgreSQL workload on kernel v7.2-rc7 and results look good:

Baseline:       70,735 tps
This version:  144,670 tps  (145,280 / 144,037 / 144,694)  +104.5%


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..1e4b0c1e7296 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4725,10 +4725,10 @@ static inline struct page *
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
@@ -4743,6 +4743,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




