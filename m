Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA23CC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792786B00B7; Tue, 30 Jun 2026 12:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769D76B00B9; Tue, 30 Jun 2026 12:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681BA6B00BC; Tue, 30 Jun 2026 12:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2976B00B7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:07:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5E8B8E13E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:07:28 +0000 (UTC)
X-FDA: 84937058976.29.B7B2EBE
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf31.hostedemail.com (Postfix) with ESMTP id 98FB320003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:07:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="QzPwZyA/";
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782835647;
	b=iTDeHE7Mn76yOeR1Z9tgSk0gaIx9qVFWQCFXblGfkhtkRLR9Ln1EQT6HRj3A+vcDYblARI
	yodD6uBomU8ZF3WOI2oSAoGBja4gz/Hy/xmeyrly0d7949Bg+0yKvCra/tdXCEWAj12Ure
	EBV36vOzqz7+fOSTTlSgsF+nP4M5Dis=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782835646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NGWPvsKd5xy7dR4RHMj1I0r7F9MdH0Syh6+XpRuoCxQ=;
	b=Mo5szzAWkj+/n5u6w0/9vNpr/mlgu0zowQTEMm/yFz5TlgyGAn38ePey/VpDBprUkAzHWM
	d6HMRCV5fpfMDu2kleg/o9dTfReGwX8LuWKo9vGuT7DR2T/DrcCYzQgoQVBTBp5v8eC/0x
	kPB6S6RgzPes40hVrA1pz+liQnChxJ4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="QzPwZyA/";
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9217d13c276so340479985a.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782835645; x=1783440445; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NGWPvsKd5xy7dR4RHMj1I0r7F9MdH0Syh6+XpRuoCxQ=;
        b=QzPwZyA/WBBov0dpatbyTNGwYJUUVSireDs642tFUoSgSvRLNhIG3ZQ8NZVeSVlarb
         VpKBJ3gR+J1qvTh3zhWEpqXpqLfT8kBJq5ApcH3j2Kw7EgvZD6wEBAejh9W5YHK5fxYY
         wV6QkLjkz56YtrTIGbWSOYa+6DAyS4B9iTDroI835RZW2MLPomKByy8/8CgiTnhDPLME
         i1XkOpPPUso6WKW7skvePqUVnTaRhHUsH5SDEYDBiQ4cnJIbEi9q6w70rs5CjPvrsiVQ
         f9LnA7GqXy0oXVEDZbirMsXAvTPgkB7bpzkGza/An1qe18BAI3fv4TfgY6K6Q3xmozuT
         2Myg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782835645; x=1783440445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NGWPvsKd5xy7dR4RHMj1I0r7F9MdH0Syh6+XpRuoCxQ=;
        b=j4op6TKYEr40dDjv8qqVEDSV/RtH6ouPV9TnP80CAuRg/co/GsQNBDxRz+iaqcVpSU
         bDomHng4xU9ZYFKM2IV3a/qdgwAWvmI/Fr24O6ihaZCBx3KAy3lIHaZx1c1yJQi5cJsY
         Ycm8y2MXDzOj46eWhaLdVaC/sEAsGfmAlh0Cytcf5jSSijdXvkLsVTPEXC6M38DP2OX7
         0QKhN4/7g+wmvOTKLIv6mupN1cYn6GGAD61D9bOYpOpHQm6buZhRpSrZfgQ783TUrgDe
         3NFdp1MMoUxRSp6i6orpbg6aEWWWGtleMIJ2Ywt3jMd5UX0nNzmguyJh4r9Uj7MwsnUx
         wbSQ==
X-Forwarded-Encrypted: i=1; AFNElJ/1pD53NdckeIcsXQpcyOEwH5pRfWQjF8Hz+tYHXORRlyrmglHsL6sY1LQ46HSChzfX66wPD7jY5w==@kvack.org
X-Gm-Message-State: AOJu0Yx5fZ3hNyz6Bp7yrznSNmcMjq9JhsYprHjxESZhOFaRsl+6I/cX
	MsHNavCHXc7WwopAu52e4MrewKArZh76nMlrHTtbgibMWwoJyU2pNRtxBNhX8UcahfQ=
X-Gm-Gg: AfdE7clrgfwG6k2drMAKswyfcmjl7HIr3DaYw6EsMehkDmaovdOTFmamKZtsZj2m6+A
	y4ryn5I3Alu3BDIlpbhK7te/ZRhCN62PQqNGjcU4PHrv9WqN4GiPLZjpJe942850+8/LFXAewry
	VTRT8tNg/KYqBNuQyIQy40c7b0cSWpZdUJ9NV+65V+VqYb9W2EP5vw8ORWDkW3sM/mt/r0aJY+F
	1PupjcexZ+nYo8ad4b8WnRthkfDhgnAleJM7S/tOQ4Hz7RzOuD8pYjuhSJaMfdnow1pr2IzoDul
	1ixG/eRUxoIUuPRTQhCA5+NjI1hYuTUUNDvqeVTB0EGgrGW2xQjhyXz9A2PAF0XJJK6qLa9PVUQ
	JUkbyS242FZuRU/UQSLWgXoQhMKaoOnc9bvSZdSd+R/jFT4IRw1TL7VF7Hi/lDy96CApoTlZzWw
	KtYOBT6TCp5Nc=
X-Received: by 2002:a05:620a:4493:b0:92b:6805:91a9 with SMTP id af79cd13be357-92e62ab75e6mr685496985a.65.1782835639247;
        Tue, 30 Jun 2026 09:07:19 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6213b953sm269848585a.2.2026.06.30.09.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 09:07:18 -0700 (PDT)
Date: Tue, 30 Jun 2026 12:07:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com,
	shakeel.butt@linux.dev, roman.gushchin@linux.dev,
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
	mhocko@suse.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] mm/vmpressure: skip tree=true accounting on
 cgroup v2
Message-ID: <akPptQjnQEmvCXhD@cmpxchg.org>
References: <20260630112617.1198623-1-usama.arif@linux.dev>
 <20260630112617.1198623-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630112617.1198623-2-usama.arif@linux.dev>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 98FB320003
X-Rspam-User: 
X-Stat-Signature: p3s9e1647xa3dzp19kcd458oodf6wak7
X-HE-Tag: 1782835646-302074
X-HE-Meta: U2FsdGVkX1/aCb+CKqVhkcl3t4eTHQ79bCtJl3oglfnlPerAnRWX+QH9b/vv8jrFYtOLDd76ChWeGwp+HuzRmh9ChFy0rcrD8h6X51McVeuheH6MNVuXYC4f5/KdHgu0qz/XDYmsG/qoDDysxf+Rr6vU5JZzp9oIk+dF8h5WVnjyAlQ5lvLN5XNfQrGzHcdRSHJrB7gNh6bUBgIds4+Unsn84Y4rdmyvEVAcV8yEG63Z5XP773G/A0BUmKIwGlX6FFsmIQqqJTbwHo3JZk94TxW0SlX2I9BKd2z1YIwTMqAuNH9JRICEb4Uhbb9uH2+5RSuUM9cXiRG3NtviM2gSKI9RWON73JUg31CPPv0d2x3vhVNeBZgCPz+gxDLoZE4TEOVepaCkgE7pzpiuy0hYY1rWsKCOkAMFsdS/vCpBqfZt618N7aG6pNwuKUBi+VrwV/Qg0LcPTDcjqf9R7SMFxIjiTMZrM1VtD9r2aF59sijD7/6EL8b5C1EfYRkU4R6gBff93PfgV52s+JIb0BskAISYFLcNt81ApyXT27ogUpWArL/+UHpdILb/e3Mg209u83Ilp83O5DX5FoxKTGRCiI9m0gKkb8WmgLRWVPbCUB7CIdckUS1YW2D6uZONC4HKL/037T+PNDG5x5OfbcrP+pKjWQG0JJHBu1FP0Rn8mlcn5TEwgnmcgasCPexHYq7e7du/01Zujs64uVOfYWOLTDhCWS+fe0p5o6PMVq49fW98kJxn6aE5OTwvjMgU2Au3jQnYO63MTtAJzdChy6OrdnGgrL9+bmw8v+YWV+/CoBRVsMKZl7logVc57dGm0mqI1I/S4/J0zNzA72Af9Xjqvhtxsu5deZFUyzjSwtjmmFM36AxdOLpi8B6xzwcA8l0NQOlSYxWlOUJ1WD2EV5c3ComeF+Q4RMH4KpDOzBwk25dZ+eNoUgQlQLgLgWeFH8cnfi5UVxUVPAmiBsz56FR
 3uGr1wlJ
 3Cg+WmDjMMEwY0gDkefGp0qfWUCaiCNf4SbqMcd/0UwsZrsh84zQZf58kx3aHF+ioLeRF1q6aWLg4vUz3ahs33xiutrlrQj0ZqkIkuBjTHKeIcTvxC7UYB5YcK96tueeseAXtA67H/yfifHUo3QQ5cGnV29EfX5ICvFDd/wxochkM6rATEk00gy5ox+cyI+/97JAKSsjNjVM+XggrMplwHO94UJa7qeiyh9+lUpV5r9DL56+TwnCGO80qykQH8oERSvoS6IINDUFryzDVBltcS0byBxGwsU6Cqt7WR9nac0cW864fSbWHtb9fp2F0a7F5SmSJ4DgvCEUJRHM3hMFrLpBzONk48lv7ApAKqqlfTvY1fHOTzWUZ/Kk3dw6lE+pXifsrNkWVLj2YkT8yt26r3XQSsYmHsL+8vFjDV1XxpI/bfUUmU9ua5+aRug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 04:23:32AM -0700, Usama Arif wrote:
> vmpressure() has two outputs gated by the @tree argument:
> 
>   @tree=false drives in-kernel socket pressure (mem_cgroup_set_
>               socket_pressure), consumed by TCP/SCTP. This only
>               applies on cgroup v2; on v1 socket memory is charged
>               separately via tcpmem and the consumer reads
>               memcg->tcpmem_pressure instead.
> 
>   @tree=true  drives userspace eventfd notifications via the v1
>               memory.pressure_level / cgroup.event_control interface.
>               v2 has no equivalent: userspace gets reclaim signals
>               through memory.pressure (PSI), which does not touch
>               vmpressure.
> 
> The existing early return covered v1 + @tree=false. The symmetric
> v2 + @tree=true case was falling through and doing the full lock /
> accumulate / schedule_work / parent-walk dance for an events list
> that can never be populated. bpftrace on a 176-core production host
> (cgroup v2, CONFIG_MEMCG_V1=n, 285 memcgs, sustained reclaim) showed
> ~16,200 @tree=true vmpressure() calls per minute. Add an early return
> that skips cgroup v2 + tree = true which avoids us doing all this work.
> On a v2-only host this also eliminates a lock contention path that can
> serialise reclaimers on a single global sr_lock.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/vmpressure.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index f053554e5826..c82cee1ab43b 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -246,11 +246,13 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
>  		return;
>  
>  	/*
> -	 * The in-kernel users only care about the reclaim efficiency
> -	 * for this @memcg rather than the whole subtree, and there
> -	 * isn't and won't be any in-kernel user in a legacy cgroup.
> +	 * Only two combinations have a consumer:
> +	 *   cgroup v2 + tree=false -> in-kernel socket pressure
> +	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
> +	 * Skip the other two: nothing consumes the result.
>  	 */
> -	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree)
> +	if ((!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree) ||
> +	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && tree))
>  		return;

I had already acked this one, with a half serious suggestion to make
this

	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) == tree)
		return;

Anyway, no strong feelings. If nobody agrees,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

