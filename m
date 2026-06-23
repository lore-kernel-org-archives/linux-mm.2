Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A09CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2F66B008A; Tue, 23 Jun 2026 09:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863C86B008C; Tue, 23 Jun 2026 09:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752746B0092; Tue, 23 Jun 2026 09:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 473866B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:54:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D31C9167101
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:54:27 +0000 (UTC)
X-FDA: 84911322174.21.FFAD916
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC40F80003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:54:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rS2VieSb;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782222866;
	b=LstQiHRiSG2re8xRyKtVTe9kvVZ/2nOY2ZO2jF4YR+bWkQ7K6BOoVpG5Pm4z0iO2yZM/ay
	vCqvCG44Qnf6CsDIFpGRfhTuc3M3Ewt8lg1XFOS6vDHgbW2RfRgxxpWiAb2DYkvlcLGAU1
	PTot52Fi+ZgPyMp/vreYhnTdTe5J0Ww=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782222866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1o7yLSn5YasTRPD43l8TMkxzBr6nytN75M+KULG9gs=;
	b=ONLJ1DnauVrWvbg7OqMANgtC14UMYAyBC6RrSwCd1x+W0rTFpjfD+bJes8WcOHuthNppZa
	adPCFjoTlXIaGAOGTfDpxgxSCzcg6JeKtUSR4ONPU4uQzeTqUkG3VTSRqyjpzWjvh3gRx4
	QitiXmwuH4e9xY3JdeiPUBbI5uNiPik=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rS2VieSb;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-9618b8bdc51so1904532241.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782222865; x=1782827665; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W1o7yLSn5YasTRPD43l8TMkxzBr6nytN75M+KULG9gs=;
        b=rS2VieSbu51EC67yG/9Q6lTGhZJnmstuRbWiaeBZjpixXTnQe+O3eC+1xeMY88b4i8
         Iy7xSn+f1VSK3Yyy86dFQx1zTuQUopwuGf5gGG9wrqH76PS85KC0ARMSXBlmFwGnOsxS
         26KWMmf0AXiLugogW6X3DPob7IAKa82Oa5649fcNoTMYJPTREt54ucISz34ll7be7G2M
         ww3vk899X0hmqzM2J2V8k5b1UDQ+aQcs3+6uuoEuV3MsPRfVQq4fLIctWGYdJ3/nWCxS
         /VpTKBmj7zCzCCSjErTig/kL90CfuiFxQlNYpTrzgQ7SoFFrY8dqJ2VlLQiPV5TpWCz2
         /v3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782222865; x=1782827665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1o7yLSn5YasTRPD43l8TMkxzBr6nytN75M+KULG9gs=;
        b=M3XHAG0Skm96hJo+t6mMwBxOdhxXkEziz1/8S2ofFiE+jQ9jpCJb51eBoFjSSormri
         5rUuRZUYeBgOmEOaGgGegJUp+TgMfxUZidXf9mNsqThoLs7URw9DpBqKSFTxAZ06HZFR
         xWDm/bPDXMieeYPz5N7znDj+DRPriZUr3yIgF0pnk9cNRLxhJVnl4wG9gYirshZqL4yj
         G/cr+TSm4dEGWPiVKsk6woU+AGfyBjbUKukrTR1s5aWbbQgSkhoz+3Z6LzgrvEtB9p+7
         TX3ZlETXwk5qtNvvvw2jMKX01KNvWuNlVdRdaxCHa0upI7TEsKRyGwBbfMcQ5fFkaKYc
         /8fA==
X-Forwarded-Encrypted: i=1; AFNElJ+ZR7vQZlTdYme4H6XS9BPIS3j1a1dZDDWOQ2nTOEx1MIjXfvZnYfCDFi6RkKzmC0v+pAWxnXkn8w==@kvack.org
X-Gm-Message-State: AOJu0YzR/UrBSYkiUYaQvrYHmMDSmgxQiz5sSpz0vzDslNWTlleYpMEN
	uQjm864N1TOz0SMbv5eg6lOp0mBW5/F0SFnL4zQOM+ud1yguszfjQOek3P53lmE8VYA=
X-Gm-Gg: AfdE7cnAWY6Mg1e+O+hC5fr6aWCWHjk7ZAX4Q9UcPuddNCE5CRVLuxDYlsKNVEiEOgk
	Gn4bfwlIeuwesXSUES3yMS/4P5jbeZ6jrt/d3QDp0kupkwgrVGrEYyRn6TGROohq422H7e/G6J1
	q0YfJ7UXnAspdt1bNoD4mi7/JCb57+LQJ6Lvjo7MDBAhyqwSkaIOioxkozEfYxacaeCByE/CG+T
	LIH4Rw1btBVEtPXMxVFn1AqNWrAVo3av/UBOkjMqzkvSSnNnNijTP7l/wSypn95n0jSK6JTBQyH
	DpJyoK763GfvCpqQYw94MVYM3QSbh6mvjf52qIZO3PqLcF6W9538k0Kaa8J7j8GLT24F9uHVECn
	44KggSuNdQG444IqMAu0S6o/7uodqNLWrA5RMq60qE0JnJl1dv5c6alOhwY2PnRDG0sWceTJ9gH
	MTBJFDJVNayhI=
X-Received: by 2002:a05:6102:162c:b0:639:43f5:1fdc with SMTP id ada2fe7eead31-72a1fe01533mr10497444137.26.1782222864583;
        Tue, 23 Jun 2026 06:54:24 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df7f6fa440sm125150726d6.17.2026.06.23.06.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 06:54:23 -0700 (PDT)
Date: Tue, 23 Jun 2026 09:54:23 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: suhua <suhua.tanke@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/page_alloc: bypass watermark when PCP has pages for
 allocation
Message-ID: <ajqQDx29gGOxKR-q@cmpxchg.org>
References: <20260623132917.104234-1-suhua.tanke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623132917.104234-1-suhua.tanke@gmail.com>
X-Rspamd-Queue-Id: BC40F80003
X-Stat-Signature: knixbffef7jr6q6z3ynnpx67mhn5jrkw
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782222865-272179
X-HE-Meta: U2FsdGVkX1+Wkkot67cl2Nqa3O9mhS3ZrffCD0keyrTxT6Of+9m8D/4IOzqEGYn5gYaGYT/51ItVkEnBt60zW5d9EzmcYy2A9d73MFjPk1M2vbnW1bfrK5N6xYd2bTgyguPaK6FHQ63dQ8FmkNCcF0ac5Db4AizX4x0tBJ+LNoavldeHUrLyA6InVwdYlSMpdAiaBPOOcYRi/hPG31keLEK8i0H49CCe33MSqXpIkp9FOCJ3FN96oegqrccDPrIEWEgqKpNuEd1thAkVpZIgCEuMbeXymC02yOKfA0P/NWZk8XGWqCCl1TxAbs/jJIUIFIsQlRV/w9dDS/vNKuZczRmPATNi2fr2xPMxZ+Zs5T36aQq8LNsi9hsqiK11s/lv833G8bYnoS3qH3cVECFVEGktFARWHlp7Kw4/wgy73xMRc0wuJrMNKOVGpVbQ+l7ZqKACqS4/HwYrYjUHvFhuBFzUpgLsLQbRVG1aQu2i/F1EzDK6Z+9sQXShDahGyC53kTd3EfbmWG6g9qggMFIjJnr8DANGqejBpXwOBXRTif8VvqSzxUn1WznReDPid0gsXdvdgiVl3uByNyTBKnytVceH37hOsQpkTHgbo0QoobqaiQg/DIw26TjxK1ddi+Y7ubMzoJmsyRWTKlLAIk0rW8TG0yWAcv2zCFZgjeypXlesYfVSvZqecijleixcd/XF1lW9iMchypHiQHxLoxLJ2WfiPClEbIEQ2fokTio0DrkaC7hzeLtnglCSoTYE3p6yWkLNtslR1FdkmBnSPYejBFhv8WOR/Q3UAHMxnNuznx8TfXzaYnsa2aT+sjTWQ5U9RxFzOt4lXpHY0+meskN661TxJeFpEutYXHoRNLWHNJlL95bCa4ANsCpv01bVOjumtI7UHG+Jdt84E09jBVjXp65oPNxhJAgdmVNJU9knouD0Xc4XC7tv5AMRHUbaEfPiXmt3j/DuzOoCznssChA
 HyTA9V2r
 Nrd+N79cE56iC1AItDvpGWgMF9np9VkOHlKCgptC2aHAwWurJJsFXccLjezrMXJfP3LAogwBmrv/ZyvxGv5ARWgMq1IiNDE7TtMNptXTZyixFSdQWfmZSgRi4oPtVWVHleRdQHBRocAt7uPS9l1eebiDjrCn1vZLE0Xk3Rhvkm00UV5P0MGXxGOHdqiXJiK+F6C0GqEz+XL6npguYR2AJnTU7Zio4WLMi2bO73az5j8eHdJDx5tWDoruWV2NdEoN+KCs5Wg669Bo18RqRYID+Q4i+UpzYsziUQ+4MQGELBIFloIRlgOQyS5C7ugRWZq3tvTgeZ+SmRFuWE/FPu88XDkpCWHDopr+FSU9LYlfdGy28zzjTFexO+XqFaYxhs3X+Fxf/vYVeC7odSqmeX9Yz/QIvDDR29YjPPTtiHvHf7XBAVnrezAu/g5vFXeT7GTj9i6zLVywon/k4dMgEmU3k+gjp9VIMCDzZbplSadUUKBnqtGL7jTqoyJL0Kz6MUkMXY2uECuJcNbr4iDEt4pJG4mmNqht+s6Xv7PF0n6HDUDVFT1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 09:29:17PM +0800, suhua wrote:
> NR_FREE_PAGES only tracks buddy system pages, not pages cached in
> per-cpu (PCP) lists. The watermark check in get_page_from_freelist()
> uses zone_page_state(z, NR_FREE_PAGES), so PCP pages are invisible
> to it. When the watermark check fails, the allocator falls through
> to the slowpath (reclaim/compaction/OOM) even though PCP may still
> have cached pages that can satisfy the allocation directly.
> 
> Add pcp_has_pages() which checks if the current CPU's PCP list has
> pages for the requested order and migratetype. If so, skip the
> watermark check and jump to rmqueue(), which will try PCP first via
> rmqueue_pcplist(). This is more direct than draining PCP to buddy:
> no page movement overhead, just a list_empty check.
> 
> Signed-off-by: suhua <suhua.tanke@gmail.com>
> ---
>  mm/page_alloc.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee902a468c2f..70f5d0dc2485 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3784,6 +3784,32 @@ static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
>  	return alloc_flags;
>  }
>  
> +/*
> + * Check if the current CPU's PCP list has pages for the given order and
> + * migratetype. This is useful when watermark checks fail but PCP may
> + * still have cached pages that can satisfy the allocation directly.
> + */
> +static bool pcp_has_pages(struct zone *zone, unsigned int order,
> +			  int migratetype)
> +{
> +	struct per_cpu_pages *pcp;
> +	bool has_pages;
> +	int pindex;
> +
> +	if (!pcp_allowed_order(order))
> +		return false;
> +
> +	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
> +	if (!pcp)
> +		return false;
> +
> +	pindex = order_to_pindex(migratetype, order);
> +	has_pages = !list_empty(&pcp->lists[pindex]);
> +	pcp_spin_unlock(pcp);
> +
> +	return has_pages;

I mean you aren't wrong in the premise of the changelog.

However, you're adding the above checks and branches to everybody in
the fast path when the zone is nowhere near the watermark, only to
avoid reclaim in zones that are about to be reclaimed anyway once the
PCP depletes. So I'm not sure this is a good tradeoff.

How did you arrive at this patch? Code review? Or are there workloads
that benefit from this?

