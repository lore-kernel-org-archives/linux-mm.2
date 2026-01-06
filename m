Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D850C47BEA
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815846B008A; Tue,  6 Jan 2026 08:51:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3436B0093; Tue,  6 Jan 2026 08:51:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC396B0095; Tue,  6 Jan 2026 08:51:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0B96B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:51:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA591135DD0
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:51:26 +0000 (UTC)
X-FDA: 84301676172.16.608428C
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id AFA9E120006
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:51:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="QOHL/IAX";
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767707484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCoOPztzEqaTsy0dNYQf6c1IFhf7sLhplgQewyTuM64=;
	b=XllClb0ZuMrfNz68LQtMVpMaCPeNhqmCkSX2CZatzdsMfY98d9JmjvOg2j8H9kdAsak06U
	MEvFzLun3G/KH1PbEfPiZovyQOv8P2s23auKFLSbgOgEWKCCrMsMyVVL7BDvIR5Q0Xozli
	o3KM8cVpOCBvafD5EYV9xGY+oY2fMIg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="QOHL/IAX";
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767707484; a=rsa-sha256;
	cv=none;
	b=owyX56kYjKtqGSjX++wZzRoLINHixJLy2xOAuzJCr3i4ZnhEasU5qsSe7ZEUJXupmv5Omc
	ZZDViO+aYiqKsTuIGiG2+4ZDzJmNvADp9ORbXAyDbmXsP1rpxwfhsbq+wzLbFeUODAhqJ+
	I/J45e5/vPd5Won42NgfAo81z5RAENI=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477563e28a3so7023625e9.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 05:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767707483; x=1768312283; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jCoOPztzEqaTsy0dNYQf6c1IFhf7sLhplgQewyTuM64=;
        b=QOHL/IAXHCDoYOFQQVt0sCxvvOQzZpmpEeRvf4hz5Lm+q0G3ui2LFWKhJfZf/xpnh6
         nO7KiU/+c8VRHguXTYiPuvDqNrgrMFYBz8ufF4AnMNfqHRc09cul30qONKPQnSgCg0Hv
         aWodeDCI6+lqixfOWH9cZXPAbDsYLnZOg2S7VxlgQpejvAVANo/lz9YY/AsbQBCjXaXi
         34Y+mvs3y3JmA72c6WNm8HnKysDDl/X+2WakCCiodKZgiBHNkx66yiP7IVU143JDp+sW
         JaMpnzQCeaKjb3w9Ad9bRWRLhoZlYAxP+OLZQhrRE90yq684UtxVdGnHgjnHMnxX8pJG
         ULBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767707483; x=1768312283;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jCoOPztzEqaTsy0dNYQf6c1IFhf7sLhplgQewyTuM64=;
        b=avzeTnLrF4ECpOBc736rXNzcgo7OJROL/JOW6e36nIXMrElUCC/3upUszmEbrgZGBS
         MdpDkoC6tL8uf8a2eTvYShWNoN3QAKl3St19RnyOXLHGUGFyZi+NBy7DbrQ6Jal9PU3x
         NmwGToTDworJFgxPtaFIwYGOaYQl38iZRfkZp79HpIU6bi1tjdpALUc2LNnlg1sN45E1
         5FJJmLGg0RBDauJavcA5NjsMK/5maBmJ6kvdrmOotd8iAwXXB7CiPjHIYGc7hpbxzn/w
         MzNJmBDeTk6EbeGhVKhP3nLWZtM1DI3IYRiZqVG4Nt7sY8uMFtDY3bU3pqmegJxS/Zjl
         O0xg==
X-Forwarded-Encrypted: i=1; AJvYcCVgSNi8CqbKgMwLjiGli9slRVFGlS35axhPZ7Sc30NStFYmj7gh9jRhDk1nZ346hnN9esDqC20v3w==@kvack.org
X-Gm-Message-State: AOJu0YyNPJmfxOauPTyh5nFs5DgwlC1W8c1s1uxR9btmdZHO8Z/1q9Pz
	e1u4mXpwAzuzxOsjXg3Wz8ydrnRgWvjx9SaDFqhC8/tsajKRG/BDLZvfOmiMPPg1Hn0=
X-Gm-Gg: AY/fxX4uWFMh9pTnajSZCQsFshIvqTC0A84h6tUbeDTl1yzEJ4p1S1tpmW+r4emTdTc
	1YaNpWH0nwYZiHQbKfssEj73cNFX6THv1HmfYaMoccWYTziv/vM7bgATM6ZorEiGXQhkaI/jNbV
	rf5JuX+HVbX7Q1YFTSNM0igB/6/N6kY2w1L3k1W/y9TcQW92RHRs/JQwgPCPanDslG9/IrDaktV
	HsNE9tZbS+YXdLODOw3+rGeoUaouxFp9qKEgey6+09iqSDJoCuH0oD9Tb/KP+6nomHkZDhVZOz/
	XXA7V8iIe4IIjNYk2SznOkyexB1nIfwd2UadtFkob+pTO5EIHd7V5RPscUdf4HvA1jWRE3ZuDyO
	OoMdROhk1OwQyn8QtD6xjgmhuipA8L2ObrJMXAiyHtzve3PcYo9kqCIfRCqUTx1Za7ehW79zT4Y
	ffzeeGkKU4FpmukqrlU2d6/eF0
X-Google-Smtp-Source: AGHT+IESNrX8z008NyBGIbTqL31wCxSi3oeO2P9JkQEbEz6YZ0vWzFn0AdhDBlAvOu3JM7FeImTgWg==
X-Received: by 2002:a05:600c:4755:b0:47d:6c36:a125 with SMTP id 5b1f17b1804b1-47d7f425bbfmr36053145e9.17.1767707483000;
        Tue, 06 Jan 2026 05:51:23 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7fae6699sm17782635e9.3.2026.01.06.05.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 05:51:22 -0800 (PST)
Date: Tue, 6 Jan 2026 14:51:21 +0100
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Rientjes <rientjes@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable v3 1/3] mm/page_alloc: ignore the exact
 initial compaction result
Message-ID: <aV0TWde-Pu-8TBT8@tiehlicka>
References: <20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz>
 <20260106-thp-thisnode-tweak-v3-1-f5d67c21a193@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106-thp-thisnode-tweak-v3-1-f5d67c21a193@suse.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AFA9E120006
X-Stat-Signature: dzibbxyadn4uxgnkbso3c8o3azbfhh6i
X-HE-Tag: 1767707484-38483
X-HE-Meta: U2FsdGVkX1/x6/3SGujF03CBh4qOB/+JJzU6k3YtfLT6zyM/5U9Iob/S5Dyjbh1Sn0PhLO6vO3Pz4eYi+Y69d1zqRMgFh9pDWzi7fgjT3vVdXCGd13VoHDEC0C5yOqp0A/AR07SvLp10V3JXhXi1jtwCM/Yhx9U8o0rwA5HH3ARc4z+b82lB9b5N5vnzugGABVWajbCFh11dGzTYOoLFE80izQkWdo4lzJwik2guZ6KiQGOoxt8H/TmRyNNRmRjc4EvYf7hVnA7BEpiN64QasLX3NDayM+MEEKqJoHIP7Lzn3FrDY82OlpKCUX9b89uwN4bVJrSWz1jBcjKN13eBGHEIcnw/0XNQ3B6MR3GbB63u6YQdtutDk2XWBFWfvK5LnXqJjlPthkWocbQ73LL6ODRwRCpqiuDDX1aMlx4ZVneKtknR7YeuswI2aIJBR7rCg3y3DJUy6PYESkmaCK19+CkpscoI4o8MBDY/t+F+uX7M2Wj8VmcHeRnk5xtSUwDWJ/PJyoHb4tm4lulWLAriR3KRgcXr7aB+0bdTzalJAPDEg/c1HENHQ9RJbpH9weEjWSzPKv+Zh9rw9f8dUJ9RDtCibC1NZXguK4cPXhN2CZGnCK8C/unss3BCdkP6bISoVYMt7/E3gkdc7ulTzpMTO38QA8nNiZC+wgOHhLBD0dNHfjUv7Flag7oqWBDsrtOmBvzJLPz75Y8MUFBk5NgY3Bv3fVVgHs/46wRvE8RhNZFTCkUBBTX7WVfXJUg6B+xuroV/reCenQagDFDN3+kfpLze2SlIrBL/Me1HHSD7/iw44iQ+t4+mlaj8f6afAuSBX5gQQavIAkPzRv+wL0If2hmGXz4DVsdAkqKIkRx+AOzQmvpTL5r2cbX4/fk12PsSuA/HWR+seE9Fia/OJ9ZCTP42DG2UwDwnuXJtJjACJm9xkLHZkv5cWlAsMTM8vGe0K2PYfiw6oRfutUZ2Fbv
 DKnlQ6ES
 CqaWUrs7MBzHWPrM+s4ho7Xefme9Z2TLGjvwXA8bDMfZcdSHHG1bGj6H8yGQdDwePckl0HybBJksYuJldMNNe9VdicEm9TEaV9f9sHiiSUXpY2oAXXgb5Wk/ic4TsR2B32VPmHlwzRN4X+0p+Sfasq9mCOayccdU6UPSNz6N3g5D0d7MxrtkcxrLbbereCUOUpCoR0ag6gGT57uUgHhNNq42VzyLlRpW8alkoxOCKMRAmLyJov0P4WNuWfaxdx0hm8FfJA/roXyYAPJt5OpV7XOHyu4QxaiS0/utJ9B3/pWHqFIV0lDjmJiBdnDtHUG7QYp7Z+tSqMffgqpZ94WOoQFw2xBTmNQoxURuKrw+Ay1f6WyfWQqEnNFVY8G1abZPS2tw479H6uRSTm78pF1Adi/p5EZRj9m/CxKOkxODVmKR5TPxrPYZCv8QbrJ0J6LI0g1RlXjulqLpfni6jNa4tOT7zlHX4ev9wFcQrz1NrNRpUOo9wU87LCdZ+UdOmDomXyF5dVH2gkTT8kOXZybb8f9DCqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 06-01-26 12:52:36, Vlastimil Babka wrote:
> For allocations that are of costly order and __GFP_NORETRY (and can
> perform compaction) we attempt direct compaction first. If that fails,
> we continue with a single round of direct reclaim+compaction (as for
> other __GFP_NORETRY allocations, except the compaction is of lower
> priority), with two exceptions that fail immediately:
> 
> - __GFP_THISNODE is specified, to prevent zone_reclaim_mode-like
>   behavior for e.g. THP page faults
> 
> - compaction failed because it was deferred (i.e. has been failing
>   recently so further attempts are not done for a while) or skipped,
>   which means there are insufficient free base pages to defragment to
>   begin with
> 
> Upon closer inspection, the second condition has a somewhat flawed
> reasoning. If there are not enough base pages and reclaim could create
> them, we instead fail. When there are enough base pages and compaction
> has already ran and failed, we proceed and hope that reclaim and the
> subsequent compaction attempt will succeed. But it's unclear why they
> should and whether it will be as inexpensive as intended.
> 
> It might make therefore more sense to just fail unconditionally after
> the initial compaction attempt. However that would change the semantics
> of __GFP_NORETRY to attempt reclaim at least once.
> 
> Alternatively we can remove the compaction result checks and proceed
> with the single reclaim and (lower priority) compaction attempt, leaving
> only the __GFP_THISNODE exception for failing immediately.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/page_alloc.c | 34 ++++++----------------------------
>  1 file changed, 6 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ac8a12076b00..b06b1cb01e0e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4805,44 +4805,22 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  		 * includes some THP page fault allocations
>  		 */
>  		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
> -			/*
> -			 * If allocating entire pageblock(s) and compaction
> -			 * failed because all zones are below low watermarks
> -			 * or is prohibited because it recently failed at this
> -			 * order, fail immediately unless the allocator has
> -			 * requested compaction and reclaim retry.
> -			 *
> -			 * Reclaim is
> -			 *  - potentially very expensive because zones are far
> -			 *    below their low watermarks or this is part of very
> -			 *    bursty high order allocations,
> -			 *  - not guaranteed to help because isolate_freepages()
> -			 *    may not iterate over freed pages as part of its
> -			 *    linear scan, and
> -			 *  - unlikely to make entire pageblocks free on its
> -			 *    own.
> -			 */
> -			if (compact_result == COMPACT_SKIPPED ||
> -			    compact_result == COMPACT_DEFERRED)
> -				goto nopage;
> -
>  			/*
>  			 * THP page faults may attempt local node only first,
>  			 * but are then allowed to only compact, not reclaim,
>  			 * see alloc_pages_mpol().
>  			 *
> -			 * Compaction can fail for other reasons than those
> -			 * checked above and we don't want such THP allocations
> -			 * to put reclaim pressure on a single node in a
> -			 * situation where other nodes might have plenty of
> -			 * available memory.
> +			 * Compaction has failed above and we don't want such
> +			 * THP allocations to put reclaim pressure on a single
> +			 * node in a situation where other nodes might have
> +			 * plenty of available memory.
>  			 */
>  			if (gfp_mask & __GFP_THISNODE)
>  				goto nopage;
>  
>  			/*
> -			 * Looks like reclaim/compaction is worth trying, but
> -			 * sync compaction could be very expensive, so keep
> +			 * Proceed with single round of reclaim/compaction, but
> +			 * since sync compaction could be very expensive, keep
>  			 * using async compaction.
>  			 */
>  			compact_priority = INIT_COMPACT_PRIORITY;
> 
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs

