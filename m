Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF084FD065B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12E66B0005; Wed, 11 Mar 2026 04:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1046B0089; Wed, 11 Mar 2026 04:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1F86B008A; Wed, 11 Mar 2026 04:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92F2B6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:42:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DE9B8C0E7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:42:36 +0000 (UTC)
X-FDA: 84533141112.17.5A2E796
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 21DE912000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:42:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WcMxpyXz;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773218554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=do4vHEgx//2ZE2oBeVySUVvd3IyqCD6MeIi5bwH33io=;
	b=Xv5cqgwvIaIjXVjcZXv6/+YBx5b9DfuNbWC4tVjpwhcWMo/VnPzIIOy6RXHROIo24ZlLYP
	bkRfCaHZhWDfHobFW2fAKXO27Xb3f0tkKdFVvF2hYjXO4yw5pnLR63bEs7hAlgNYV7f3st
	2TiDK6Cxht51aBk60sJAeVoFQuNEQb4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WcMxpyXz;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773218554; a=rsa-sha256;
	cv=none;
	b=rQjyOh3SKHJM6ilevl0u1jrY4L4KNLLRB7sda2PAZfV70iFCgNHeqrebrkzYjetDljgTz1
	+R7lap3Q8/Uv+tJQpJVDXuGKJM9rhEjLE6KYqH0wVF7n1k5NK8A4iCC4kuiGi5Po5vZH0F
	bGuAcBLGK0RJyfqhkAgTV21qN3Ad26A=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a107b387a5so9153958e87.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773218552; x=1773823352; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=do4vHEgx//2ZE2oBeVySUVvd3IyqCD6MeIi5bwH33io=;
        b=WcMxpyXzt21QP5cS3yJVlaeShR34pQ95DNwXtqSfFTv9THkTdooihPTIYO10Cm7fvz
         SI+4vXZgKqev/PQxbBEKhSm9EDmxZ4/fglpz6mDVCE8KRCpwzztTt7qiLAPLI8Hdzbgb
         As0520jNHExtkeK+EwuyxLqnWqO1vdI4au8uJbaA94hpLPTFfHkvG5HpLZ0Hj01wBB2A
         AzhlXlG/2hxGYHs33cYbD8RxbvnM5Ji8AXqSCJlczYmV/AIxBzhvIE7SAkSLXennniWy
         E15DGN5P2JnTKdXJoUJzN47QbGRbGPQYy5QMAqrmazL3WsFYPcaySm1bqIzXF3GgzzmY
         IPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773218552; x=1773823352;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=do4vHEgx//2ZE2oBeVySUVvd3IyqCD6MeIi5bwH33io=;
        b=qnmmyk5FiILCiJ93uay+thp/pRjNyibjzm6VJHtaa100qVdjmH6XEsckqOwULf6VKH
         eT4LEzA60HuFSxcW9v4BeyYpUnwZjjZfEylzDi+CJWfFYJxN8kpDZUXkPwd/mj3wDyee
         A1pCdEl6b0o6kiVR4QpCvllr+d6B+AM3+Q1Q5B6Hc6h8ATrO5bUsslyFMwZMbX8MdAdK
         RTsWFR8uIcub2UUwJtlAozydmW4Y5Xz20O4/w0sSHUOu+5w+g8JrwwNYR4V1N/lB1puM
         C8H2YZkAAr+i1Sz0kAATvR37Dv5jgKqKTbHUPZl9p2JyBUbP4EJUV3ePFPbYHgExbvXo
         tr2A==
X-Forwarded-Encrypted: i=1; AJvYcCUXvQVp7G9Lg/2FkMfkn1Oh/QQfkMHisIAmT8cmEwVGwZuCg8Tuv0+YVMLOC3Iqez0oox9CRbG3tQ==@kvack.org
X-Gm-Message-State: AOJu0YwEYzSXA+VWe1zKv8QEM27JcN9rQbmj3bqEiGlZUWR+7h1r1YQd
	wgRBbUZEdGlJpogEF+7fykuUjebnBZWZgcJhNyMneZ4EdUf4YZnN8/wf
X-Gm-Gg: ATEYQzxD+5oHUYwDHT5Df7uPoDtc4n12ARDvR2qZf/4icvRQWFWwwsg64Wt+Yql08UE
	3QK9D5IitrOxzqzSyGgsosta7TupKkTBH5uMRO8WXpO7rn3+wbe9mOgNuoXPUBJLkoSNWCy0aWz
	/3WWzl1gohqiyyz6UKcf9EwDtamxxO/zlPz+lzIXkAJd3PZRIwEi7l6UjJbgryG1Di9o1I8SYdo
	17QfWj1NqP6szlHyrSD7uLvGXbp42e0W5jeah/k2fgvZ56fFjFt7DvwXOSN98s1MrQc+6wof7jU
	iyssV8ODJleaIfemJN6iobpioJtN8u195FVatWiHfsmYGgD75e0bDeexgxKcEvkukKCGW15HXCX
	cq6Fhgj1UzjuSH5irTZL8LcSXW9evrpo3COzD4m3JdQXgl0i2S+dmXmCxRvDJd9u9hf/xElAYbg
	v17VWgLZHgnopV2yYyBUHt+6uDUjuh3oa8E/xcYAuhuUTZSNv+5Q==
X-Received: by 2002:ac2:5627:0:b0:5a1:1e11:7532 with SMTP id 2adb3069b0e04-5a156cbd1d1mr442823e87.24.1773218551777;
        Wed, 11 Mar 2026 01:42:31 -0700 (PDT)
Received: from pc636 (host-95-203-16-219.mobileonline.telia.com. [95.203.16.219])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15636206bsm289527e87.67.2026.03.11.01.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 01:42:31 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 11 Mar 2026 09:42:29 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Mikulas Patocka <mpatocka@redhat.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Vishal Moola <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
Message-ID: <abEq9eX3-7yeNHVB@pc636>
References: <20260302114740.2668450-1-urezki@gmail.com>
 <20260302114740.2668450-2-urezki@gmail.com>
 <a8010888-ce49-9232-f132-338de8e18cee@redhat.com>
 <aaXcLRdhq0IyoNIG@tiehlicka>
 <20260310155914.9c03a9f4cc2f433fc741e222@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310155914.9c03a9f4cc2f433fc741e222@linux-foundation.org>
X-Stat-Signature: 95zmb98qygqnkhgo68oqspny9ep43gbt
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 21DE912000C
X-HE-Tag: 1773218553-531054
X-HE-Meta: U2FsdGVkX18ZsJZ0x3ECRQumQygObaMNRlPhNZ72ObDBxdzUXBZAAbegEKaqvGgxnUsST+RmlGmvncA08upLWvE4eGfkXR4AK9bvDK3FLVoIVfQZrouxYZ74P5/3pEG/xLiZapSwhDFIzT1HEzXYbtghoUjeMxmY8ExuBEY0tL9QjgQ9cZ8EogxXSSA4iCIjOwBiMr/ttYkimPKPEuK5qWQdGhmxQyOAp26JsGYmz+NHpoNUm8X2xwetA0COpqkWDYTNSPKzxpKLKZB8Lwi1Mi8zZfJ0kZx3/nMz7+kd1R9928AAX8wi+0+MbuUb4to7DgvIyEswH/c2MuXpKZfgZzgaGGiIo0UgpcFdc64q9RysPXGIB2yMTeOKhSVhS9rigJAqs5XOo2uMDykCClMaMiUW40bkX0z1RtYcXX0lPT54d8e6uvADIZBUDoBstNU+EY2xFYFWMPHC3/uXemhkC2fIznZXJvMqq7hhIqXqDHTkicFLpw2pME4E/DY7O/whBo2KjBAOTbTkWU+f8oFoyfRXW8EM65t29E/R2qzd9HlI6NSPkpDAWBiS1Tb3xrEkt/TL1l5avgdolet+XIfo9zw1hHC9elYsGPXQCRBZjEIZcG+k6B8Vgo1yfRe65f5IusseEOEI35fkKnt+yMZY/iLyfkHUNP1dCftPepQ+99K83EWmvDSGpLBwAWrouHGPHn8jBCfQNcTwfwMmrUQ+BiVyfaIJHqh5WeHF+GaHy/C69yVHngaQ1KfJPU2UmvFNy0n2otPNgRBh+pe5Mot3KMRIx6kKcozHVoHx1LfcmPDlED8mbDO3k7+Nsfm4pog+mIPn3thPgPrv28roCELvHieRLynrBtvqS8yJ/bAnhjvX4ItUauN7SrMsUfRTu32fAOO23YpUug1N5P0gU0hFZDa7Xa6z8KwPLnpM/8BeBB7sZGyftd6nTiJaaYQ3xGSdsVaf7b8B3ABlCI7Dz/W
 NdwiZZlr
 2k+ksNL1DVt6JpkcQgByjmTG4fBV1F/bp7qwxtzS9YX8CmwGe7kY/+j4klw+QzIGO0utIlh98aovE5i/uPVXeUhokEa1U4iYBnlAMCjfI4oG/wDF4miRPX3cgAz0CF8cINP16LWHNWtqdXrIFxWXJu4PL4EnhfqfdgYQdz85tZu7dB9dYfT5jlf1MbCH3loJIvrhKlwkYlnaT+0NNTUb++KF2NUnWP+sjX5wWCc2nAb0+ULsoU7VH+A6JxMZXG9228vok53thwU8ZT1ie7I7Za7BrHgoqdSdYQqUyWY2VYw5kHtX72Kj6Ja2j3+7f8jUe/C1fIdPDtfiUB1U12LVieue3V/OgUnA6JfzC0p5hUAnX+3SMX+n2/iIf451z5ugYBnkBWARAmn9ISq/1HAb3DmzuqE9rUIf/A8bH6c42d+OmG8jo+xtWdzefdwdnGDuDIrvPZDLum3EZpjVt5PwpyqHkpBFptyHmXXBkK350zBLbJL06jiWknh1G8dWo8LJUsJNH84MRvRfG+xPK9Nc76x6HnFi5y5FBLTfM3jzc9Nn7ltco6GqIDHVQlX5jDsU69FXPmATwsN94GQxpBHej71XYgTqrUhbc1uDA0RekkJQfCuZg6Vf5TAhTraM+BdTNYBADK9SCB7Y08LieYmshfIi4NScVjuhXXwAsJAgTsRekvcuMKsN2DUmN1+tJSXxDnIbUiF1YJb/agMrN5tzRWWma0Z7GRAS1BR9QnZYAZjV3Ft8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 03:59:14PM -0700, Andrew Morton wrote:
> On Mon, 2 Mar 2026 19:51:25 +0100 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > I wouldn't do this because:
> > > 
> > > 1. it makes the __GFP_RETRY_MAYFAIL allocations unreliable.
> > 
> > __GFP_RETRY_MAYFAIL doesn't provide any reliability. It just promisses
> > to not OOM while trying hard. I believe this implementation doesn't
> > break that promise.
> > 
> > > 2. The comment at memalloc_noreclaim_save says that it may deplete memory 
> > > reserves: "This should only be used when the caller guarantees the 
> > > allocation will allow more memory to be freed very shortly, i.e. it needs 
> > > to allocate some memory in the process of freeing memory, and cannot 
> > > reclaim due to potential recursion."
> > 
> > yes, this allocation clearly doesn't guaratee to free more memory. That
> > comment is rather dated. Anyway, the crux is to make sure that the
> > allocation is not unbound. The idea behind this decision is that the
> > page tables are only a tiny fraction of the resulting memory allocated.
> > Moreover this virtually allocated space is recycled so over time there
> > should be less and less of page tables allocated as well.
> >  
> > > I think that the cleanest solution to this problem would be to get rid of 
> > > PF_MEMALLOC_NOFS and PF_MEMALLOC_NOIO and instead introduce two per-thread 
> > > variables "gfp_t set_flags" and "gfp_t clear_flags" and set and clear gfp 
> > > flags according to them in the allocator: "gfp = (gfp | 
> > > current->set_flags) & ~current->clear_flags";
> > 
> > We've been through discussions like this one way too many times and the
> > conclusion is that, no this will not work. The gfp space we have and
> > need to support without rewriting a large part of the kernel is simply
> > incompatible with a more sane interface. Yeah, I hate that as well but
> > here we are. We need to be creative to keep sensible and not introduce
> > even more weirdness to the interface.
> 
> Was that an ack?
> 
> I'm still sitting on Mikulas's "mm: allow __GFP_RETRY_MAYFAIL in
> vmalloc", which has
> 
> 	Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> 	Acked-by: SeongJae Park <sj@kernel.org>
> 	Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> I'm unsure how to proceed here?
>
IMO, we should drop the patch as it is not complete and replace it by the

[PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY

https://lore.kernel.org/lkml/20260302114740.2668450-2-urezki@gmail.com/

--
Uladzislau Rezki

