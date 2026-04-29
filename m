Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C6D7FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A676B0095; Wed, 29 Apr 2026 11:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB346B0098; Wed, 29 Apr 2026 11:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA216B009E; Wed, 29 Apr 2026 11:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19F1F6B0095
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:46:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FC38A02EF
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:46:28 +0000 (UTC)
X-FDA: 84712020456.22.3D9CD3D
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id C02DA180009
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:46:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FWlt0D+G;
	spf=pass (imf24.hostedemail.com: domain of 30SfyaQsKCEAlqqpyqpmcpiiqqing.eqonkpwz-oomxcem.qti@flex--joonwonkang.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=30SfyaQsKCEAlqqpyqpmcpiiqqing.eqonkpwz-oomxcem.qti@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777477586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wv7l/d7stfmZDhBxwEoQyea5vyEpHne3OgvUxiVZSCI=;
	b=YHD0AXS9LGsL/vLYDoOCZ8NeOYw+l4oigFBljHHA4nQvOExdxLaaazNOL61pC82mP77X5A
	0vh5R5b4R0kTdYH6hceGXpvEF8e34I2AIKifUcXhh3KOh7DazJ77iglRcy8gTh/03VfuFc
	A6xqA/leToHfHg/mNUAqFEv+qrDjYYc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FWlt0D+G;
	spf=pass (imf24.hostedemail.com: domain of 30SfyaQsKCEAlqqpyqpmcpiiqqing.eqonkpwz-oomxcem.qti@flex--joonwonkang.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=30SfyaQsKCEAlqqpyqpmcpiiqqing.eqonkpwz-oomxcem.qti@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777477586; a=rsa-sha256;
	cv=none;
	b=6yr3TvbXO/EiZjnXC+HtTBPy9/ViyRTpFCzocfF7p76W2UCb648JEG5rwzAYx7XBlZ14it
	H6+S0/xr14+uWUcBKuxtBMv5hMZPgqpWCHzbV7k/dJG2ugOAIRM22wy0Ard9KUS8Yu7hBL
	hBcbGN+uvt/iIAeO6nd0VeHvb2DhTzg=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-362eaa3aa61so6976914a91.0
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777477585; x=1778082385; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wv7l/d7stfmZDhBxwEoQyea5vyEpHne3OgvUxiVZSCI=;
        b=FWlt0D+GwUBHkJUrfYizT0CXvv0VGWFydsnG30CgmSFOiLUuspzfXx6AB7PhJl6Krg
         01Vft7Wq1LVgoxkRQo5xvheJkacwA406YW7Gt0u2a+FTsZBNyXEIGjADT3cbfhXyfLEr
         /sd2aMwKMLPeKTJOxLnB/h15hcPO2D/DvgGpB3jUYZFB/CeqdZQQea1xpHtMzLrQlakN
         fNQXOToYs6L6GOHrN8ApqkS0KT0zMPzFsV6sL0NUvNL+sl+DPCNyihxEDPvcQgUNS0Ue
         D00MZ1lt6f3SsrtZCUO0YFoqcz8BDVJWqa3GEQesuinfN4hh+kzl3/KC4oIfgfgTax63
         LRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777477585; x=1778082385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wv7l/d7stfmZDhBxwEoQyea5vyEpHne3OgvUxiVZSCI=;
        b=Pq/YZPuupIaA2FsaGUNLfg2o/fUmcEYXdT14UWXGnDkFE8zH1i0wfuyjodqBj2gQlO
         sJWUB/YbSxLJs6MENWB1hpk4kjL4oWgirwxWfLh4vuCDw7DelEf6maJjc+s3QlEXSTnN
         9iSoaBECR2gvoSkVvsaSM1lNl03X7IXGKWgR6r6fPtljUNDXujKsflp9uuE4E6DeTT/Q
         IH6rOoHKmApB6gx7NJpKLGlcoHV1W/ovHpz42DGGPKCqwqN1CdpNMHMciUtrZjYyGNNP
         umzBUL4j2sasGvPtcH7DqYlrHLe/4RgNP90ne1QozZfbrtFn38ZQWWZDrkqNH9nMQzZO
         97Ig==
X-Forwarded-Encrypted: i=1; AFNElJ/nrTcozGort57kxvexMHXyZMnL2IfarsHPOh37Ysj/FzWgtqXUKz+rbVWOZHB55IcWChlZvzvKgQ==@kvack.org
X-Gm-Message-State: AOJu0YyKQlwWKi6kslw+tczAYlf8cCbI24g1ZI5eoUod1id2KWjb084e
	1od0NBk/hFOoCvjWAX48Q8gvD5kdP/844ixWsTdToi1jZninLWDCKTd0iFMDZcWRxkC4+l80c8x
	zmI1iP/B9RdkmrhvUCyLLiczdZQ==
X-Received: from pjbfa16.prod.google.com ([2002:a17:90a:f0d0:b0:35f:bf4f:6d9b])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:264c:b0:35b:a418:698c with SMTP id 98e67ed59e1d1-364a0b82c88mr4365221a91.12.1777477585304;
 Wed, 29 Apr 2026 08:46:25 -0700 (PDT)
Date: Wed, 29 Apr 2026 15:46:23 +0000
In-Reply-To: <aegQgyf3KuIZMK9x@palisades.local>
Mime-Version: 1.0
References: <aegQgyf3KuIZMK9x@palisades.local>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260429154623.2389935-1-joonwonkang@google.com>
Subject: Re: [PATCH v3 3/3] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, dodam@google.com, 
	joonwonkang@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C02DA180009
X-Stat-Signature: 9pqwazr6sw5tngxsrhtxcxi6nxg38zyc
X-HE-Tag: 1777477586-65976
X-HE-Meta: U2FsdGVkX18cxUJ/IH0oqiNHBLM+xE4NvkT58uLot6HmJ4DAm2hUMRWdViVsB1WA7Dy3ulLypAMXRcqzz/UbDv1yiCiP6dVKp020bHBZLkqkxzfq/ODLWWfL6P2t0SDm766rX2HTb22OvdsouWCBRfwFXUP/fDnxrpnUmXYSViyVWoXQEIcOMpJ0nVPCFlKhPxYFiy1QWagpkzMhe67kP+jP08cTi80zaSXTEEqYYgZ/R98qNjfe09x4/HTkFEsTRPYwWK4/THmqIYpOJeJ7qAgailETmEPpJ5uce5IDLQ4Lxbl3F6msLlptlkeSMEk/fmKFNIhNPNj3M43KkgHjP4ViVQcMsv2wiPO21OON9H/haTJowP8GcqWYyKOexQ1oXnNP6I5WdPphf4WrI7wWjfRXs5HRPfqN5VLxCxsmNVsy98I7nwFDRgsOuAX+IFLcMMk8CLXmx6053OW6GXq9AitlRvQUv3WyJJutZBqId/hijpVGv8pE9sIsSuJ2S5g6BW7bIYsCZLFFoeQuvhYueLkefP8C5K080Mbye9HQ9KBrOeMNP9zxgDz2Ej/CsqTbi83Y3PICCQanVId0mQ5Ru/1QEbD4JXr6lkStBNz33TIExWrpeLNdGNLyP6AWhumJlnpN+1EMaOkwCXAu411SJNMaobwqQhyzQACHm12ZwG+AYsYd4G8DpJb6qeSvQMSW/6TCO0/3xeEaDwT6tiKr3uzBQyCTkz8ZxSVQkzQFbHjObSQaZsCEm1+mNSgR83IIQzQ94VJUg43ZIxKZk8/G9boPAHpTGIBX974qdlJcNxmIVyiG+/96+AQ5z9sXRnuWnSUEk/y9JDiLcR2alg66PpgIyGVYxNeFj4F7tQJsa4KlcWlLpEDs/oW/AnaJh7ifguzJ/OaNYWddfl9OapRrKcEPRRGuWNzbXSw+0tVi5Hol2gWOs5dITKNNIEPc/ogP1dArZKXZlOBZVWKe4rv
 5JYhYuV/
 oaSvkuIuewYInCF6qRihSBH/s4CeBaSMSVHzzcF8ThTGzsllPqBY+lVGeKdjTSrS7lA2o4ZDYm32ef5qu9rkTmcBH88Eot98YMEfVNo6S8pxwrStk/rDNC+8duKaI27UqJrTRaLyNxx0/JgEDP1iu0+tbGFKt5dSRdEI+egbm4uygtdY0VeOQz+4iRkB4BwJpXZIvwh+j1OIgFplPRZgSFn7MetCVs2IgBIPFYPIDYeqqX+HpEh3VMas/Dz8/+qd/xOSXnNLxPY0Am/Cb5hD23p8tho2oqQXPZaJzHhB9zlMOZoebik9jSYjzucstzaHvKO5HewYSX/nqS8EjFfoWF68xeh7yli+e+IacBM3Jo7C4nRu7eJdg9I7VnNpPgvRJoxY9sk5xMp8t3te9cQrVeYmbqgV7c4WI5SyqshmW8VpwEE/nmj+/bfaqOsDb2GyWm216j/FbIT2E9Q2XE1aecTgCOC9AVvYx0JCgfknsy6bHUFy8yOoujbVUXTphXIfukGRsyZs6Ih8DBiUSv1/g7AhZFmPyXc1I6uhgz0I3rkyV35XqQG5AjOTaf9wjd5kBAkAHwVdvRpVxaCgo2YhlHtp6ca/YmsPNce4OkkcTij1neTW9j2uC1awevFDL7Ycau673+CWSMnxngyL+s6uIP1NRmeK/fbUX7qqT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Appreciate your insightful reviews!

> On Fri, Apr 10, 2026 at 05:44:17PM +0000, Joonwon Kang wrote:
> > The invariant "scan_hint_start > contig_hint_start if and only if
> > scan_hint == contig_hint" should be kept for hint management. However,
> > it could be broken in some cases:
> > 
> >   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
> >     scan_hint_start < new contig start) && the new contig is to become a
> >     new contig_hint due to its better alignment, then scan_hint should
> >     be invalidated instead of keeping the old value.
> > 
> >   - if (new contig == contig_hint > scan_hint) && (new contig start <
> >     contig_hint_start) && the new contig is not to become a new
> >     contig_hint, then scan_hint should be not updated to the new contig.
> > 
> > This commit mainly fixes this invariant breakage and includes more:
> > 
> >   - Refactor the percpu block update code to make it more visible on
> >     what to consider, e.g. when the new contig overlaps with the old
> >     contig_hint or scan_hint.
> > 
> 
> Could you please split this up between the fixing the scan_hint issues
> and then refactoring. That way this commit isn't doing too much.
> 

Agree that this commit is doing much of work. However, when I tried only
fixing the scan_hint issues without refactoring earlier, I realized that
the overlapping cases were also not being handled properly in this
function. Without handling the overlapping cases, there could be other
hidden scan_hint breakage issues. Handling the overlapping cases required
restructuring of the function, which led to the changes to the code that
were also required for resolving the scan_hint issues. Let me see if I
can decently split them.

> >   - Merge the new contig with other hints when it overlaps with them and
> >     treat it as a whole free region instead of a separate small region.
> > 
> >   - Fix the invariant breakage and also optimizes scan_hint further.
> >     Some of the optimization cases when no overlap occurs are:
> > 
> >     - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
> >       contig start < contig_hint_start), then keep scan_hint instead of
> >       invalidating it.
> > 
> >     - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
> >       new contig start < scan_hint_start), then update scan_hint to the
> >       old contig_hint instead of invalidating it.
> > 
> >     - if (new contig == contig_hint > scan_hint) && (new contig start <
> >       contig_hint_start) && the new contig is to become a new contig_hint
> >       due to its better alignment, then update scan_hint to the old
> >       contig_hint instead of invalidating or keeping it.
> > 
> > Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> > ---
> > v2 -> v3: Merge the new contig with other hints when it overlaps with
> >   them and treat it as a whole free region instead of a separate small
> >   region.
> > 
> > v1 -> v2: Consider cases where the new contig overlaps with the existing
> >   contig_hint or scan_hint.
> > 
> >  mm/percpu.c | 130 ++++++++++++++++++++++++++++++++++++----------------
> >  1 file changed, 90 insertions(+), 40 deletions(-)
> > 
> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index f16533ed4a49..d5b0b4863ffe 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -629,7 +629,27 @@ static inline bool pcpu_region_overlap(int a, int b, int x, int y)
> >   */
> >  static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
> >  {
> > -	int contig = end - start;
> > +	int contig;
> > +	int scan_hint_cand_1 = 0;
> > +	int scan_hint_cand_1_start = 0;
> > +	int scan_hint_cand_2 = 0;
> > +	int scan_hint_cand_2_start = 0;
> 
> I'm not really a fan of this cand_1 and cand_2. Re-reading all this
> code. I think I really should have introduced something like:
> 
> struct pcpu_region {
>     int start;
>     int size;
> }
> 
> It's really easy to mix contig_hint and contig_hint_start. If you don't
> mind, it would be ideal if we could introduce it but it might be a
> non-trivial amount of refactor.
> 
> I'd say the shortest path forward would be to do just to fix the
> scan_hint issues.
> 

It will be great if we introduce the struct. I will do it as a separate
patch in v4.

> > +	bool overlap_with_contig_hint = pcpu_region_overlap(start, end,
> > +		block->contig_hint_start,
> > +		block->contig_hint_start + block->contig_hint);
> > +	bool overlap_with_scan_hint = pcpu_region_overlap(start, end,
> > +		block->scan_hint_start,
> > +		block->scan_hint_start + block->scan_hint);
> > +
> 
> This one isn't used again so we should probably just inline it.
> 

Acknowledged.

> > +	if (block->contig_hint && overlap_with_contig_hint) {
> > +		start = min(start, block->contig_hint_start);
> > +		end = max(end, block->contig_hint_start + block->contig_hint);
> > +	}
> > +	if (block->scan_hint && overlap_with_scan_hint) {
> > +		start = min(start, block->scan_hint_start);
> > +		end = max(end, block->scan_hint_start + block->scan_hint);
> > +	}
> > +	contig = end - start;
> >  
> >  	block->first_free = min(block->first_free, start);
> >  	if (start == 0)
> > @@ -646,56 +666,86 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
> >  	}
> >  
> >  	if (contig > block->contig_hint) {
> > -		/* promote the old contig_hint to be the new scan_hint */
> > -		if (start > block->contig_hint_start) {
> > -			if (block->contig_hint > block->scan_hint) {
> > -				block->scan_hint_start =
> > -					block->contig_hint_start;
> > -				block->scan_hint = block->contig_hint;
> > -			} else if (start < block->scan_hint_start) {
> > -				/*
> > -				 * The old contig_hint == scan_hint.  But, the
> > -				 * new contig is larger so hold the invariant
> > -				 * scan_hint_start < contig_hint_start.
> > -				 */
> > -				block->scan_hint = 0;
> > -			}
> > -		} else {
> > -			block->scan_hint = 0;
> > +		if (!overlap_with_contig_hint) {
> > +			scan_hint_cand_1 = block->contig_hint;
> > +			scan_hint_cand_1_start = block->contig_hint_start;
> >  		}
> > -		block->contig_hint_start = start;
> > +
> >  		block->contig_hint = contig;
> > +		block->contig_hint_start = start;
> >  	} else if (contig == block->contig_hint) {
> >  		if (block->contig_hint_start &&
> >  		    (!start ||
> >  		     __ffs(start) > __ffs(block->contig_hint_start))) {
> > -			/* start has a better alignment so use it */
> > +			scan_hint_cand_1 = block->contig_hint;
> > +			scan_hint_cand_1_start = block->contig_hint_start;
> > +
> > +			/* Start has a better alignment so use it. */
> >  			block->contig_hint_start = start;
> > -			if (start < block->scan_hint_start &&
> > -			    block->contig_hint > block->scan_hint)
> > -				block->scan_hint = 0;
> > -		} else if (start > block->scan_hint_start ||
> > -			   block->contig_hint > block->scan_hint) {
> > -			/*
> > -			 * Knowing contig == contig_hint, update the scan_hint
> > -			 * if it is farther than or larger than the current
> > -			 * scan_hint.
> > -			 */
> > -			block->scan_hint_start = start;
> > -			block->scan_hint = contig;
> > +		} else {
> > +			if (!overlap_with_contig_hint) {
> > +				scan_hint_cand_1 = contig;
> > +				scan_hint_cand_1_start = start;
> > +			}
> >  		}
> >  	} else {
> >  		/*
> > -		 * The region is smaller than the contig_hint.  So only update
> > -		 * the scan_hint if it is larger than or equal and farther than
> > -		 * the current scan_hint.
> > +		 * Consider only when the new contig is larger than or equal to
> > +		 * the old scan hint.
> >  		 */
> > -		if ((start < block->contig_hint_start &&
> > -		     (contig > block->scan_hint ||
> > -		      (contig == block->scan_hint &&
> > -		       start > block->scan_hint_start)))) {
> > -			block->scan_hint_start = start;
> > -			block->scan_hint = contig;
> > +		if (contig >= block->scan_hint) {
> > +			scan_hint_cand_1 = contig;
> > +			scan_hint_cand_1_start = start;
> > +		}
> > +	}
> > +
> > +	if (block->scan_hint &&
> > +	    !pcpu_region_overlap(start, end, block->scan_hint_start,
> > +				 block->scan_hint_start + block->scan_hint)) {
> > +		scan_hint_cand_2 = block->scan_hint;
> > +		scan_hint_cand_2_start = block->scan_hint_start;
> > +	}
> > +
> > +	/* Make scan_hint_cand_1 be the best candidate for the new scan hint. */
> > +	if ((scan_hint_cand_2 > scan_hint_cand_1) ||
> > +	    (scan_hint_cand_2 == scan_hint_cand_1 &&
> > +	     scan_hint_cand_2_start > scan_hint_cand_1_start)) {
> > +		int tmp_hint = scan_hint_cand_1;
> > +		int tmp_hint_start = scan_hint_cand_1_start;
> > +
> > +		scan_hint_cand_1 = scan_hint_cand_2;
> > +		scan_hint_cand_1_start = scan_hint_cand_2_start;
> > +		scan_hint_cand_2 = tmp_hint;
> > +		scan_hint_cand_2_start = tmp_hint_start;
> > +	}
> > +
> > +	/*
> > +	 * At this point, it is guaranteed that none of the scan hint
> > +	 * candidates overlaps with the new contig hint while they may overlap
> > +	 * with the old scan hint, and that the first candidate is larger in
> > +	 * size or, it equal, farther than the second one.
> > +	 */
> > +
> > +	if (block->contig_hint > scan_hint_cand_1) {
> > +		if (scan_hint_cand_1_start < block->contig_hint_start) {
> > +			block->scan_hint = scan_hint_cand_1;
> > +			block->scan_hint_start = scan_hint_cand_1_start;
> > +		} else if (scan_hint_cand_2_start < block->contig_hint_start) {
> > +			block->scan_hint = scan_hint_cand_2;
> > +			block->scan_hint_start = scan_hint_cand_2_start;
> > +		} else {
> > +			block->scan_hint = 0;
> > +		}
> > +	} else if (block->contig_hint == scan_hint_cand_1) {
> > +		if (scan_hint_cand_1_start > block->contig_hint_start) {
> > +			block->scan_hint = scan_hint_cand_1;
> > +			block->scan_hint_start = scan_hint_cand_1_start;
> > +		} else if (scan_hint_cand_2 < block->contig_hint &&
> > +			   scan_hint_cand_2_start < scan_hint_cand_1_start) {
> > +			block->scan_hint = scan_hint_cand_2;
> > +			block->scan_hint_start = scan_hint_cand_2_start;
> > +		} else {
> > +			block->scan_hint = 0;
> >  		}
> 
> 
> This seems easier to invert and do something like this:
> 
> Probably something like:
> 
> bool overlap_contig_hint = pcpu_region_overlap(new_region, scan_hint);
> bool overlap_scan_hint = pcpu_region_overlap(new_region, scan_hint);
> 
> if (overlap_scan_hint) {
>     scan_hint = 0;
> }
> 
> if (overlap_contig_hint) {
>     contig_hint = new_region;
>     return;
> }
> 
> // Now the new_region is distinct from the contig_hint and then can do
> // the standard logic here.
> 
> if (new_region > contig_hint) { }
> else if (new_region == contig_hint) {}
> else {}
> 
> What do you think? I think makes cand_1 and cand_2 not necessary.
> 

Hmm, with this, if contig_hint == scan_hint && new_region overlaps only
with contig_hint && the entire overlapped region > contig_hint, then we
will have a wrong scan_hint, i.e. new contig_hint_start < scan_hint_start
even though new contig_hint > scan_hint.

But, I can see your point here. Let me see if I can get rid of cand_1 and
cand_2.

> >  	}
> >  }
> > -- 
> > 2.53.0.1213.gd9a14994de-goog
> > 

Thanks,
Joonwon Kang

