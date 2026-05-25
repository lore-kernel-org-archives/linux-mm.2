Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D925CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 09:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AFBB6B0093; Mon, 25 May 2026 05:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5602A6B0095; Mon, 25 May 2026 05:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4768B6B0096; Mon, 25 May 2026 05:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36EA16B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:07:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6F1B1C00DE
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:07:55 +0000 (UTC)
X-FDA: 84805364910.06.967A5F3
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id F2734A0009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:07:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dO+uRzHh;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779700074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKeRa75/JRbjnQhRaK29cTWmGYwVkcNGukeCupRKFx4=;
	b=HI7ysLmBglGelp36TnsqPCH4DUQ5k3YenPjlcOazt4EaFcfQX+u8Ieh3qzhm1NYfDlHVeq
	D3K7sfPYSpHXz2xt2yXPV7W/Oro8TjZHqo5H7pO39OD4iwwgGlNvz2GW81SCATnxts6eC/
	nVF80d4JcTivs48pGdGtNfSHd9MIwvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779700074; a=rsa-sha256;
	cv=none;
	b=txijA5rXMJOC+9F9KHexbImFK5ecRbYRw4WSV5LvO3oDToE4FDumTsZCL9BxtB7eOS2EKz
	WmkFpgu5im47MBIibJ/PUNj/P3X64d7POhL+lq6IjBuppUqabYZEDdmj6OkU0DvjxAoISq
	0h9XFEIK0gpSrb5Aqv6VdDN2tP/6Rps=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dO+uRzHh;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48a563e4ef7so69325145e9.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 02:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779700072; x=1780304872; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RKeRa75/JRbjnQhRaK29cTWmGYwVkcNGukeCupRKFx4=;
        b=dO+uRzHhRe+c2KiGmq5v1O1YxzaYpXZ+Zbs/pbz6pByWiEpTyUu4q7bPGdLCZ5+Sbw
         WlTWUmFOPKeuQSplOdLiCVJIL2fgYOPa0FzAwnZCak/SUXsJcpEarkdTTL95Eh5mKfLn
         KNpJ8W3CmwXaRslERWZohjvVaYl3YJR+E8a4zATEz2YIfU2QQn6Xh70cRhqdC13Al78w
         jkAY4OFf18c5ayG2J+VvZBMbfg2qNi+ZTjKKzTUQYLV14v2dWqP1EWQDSTnW7k8wTHmm
         foEEFZ88lkK3oPGRGsX5CO+7hjUL8UvbdKBpR27sSYbz2V1lPfx5DgGN+eCgUhwiWtyb
         dxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779700072; x=1780304872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RKeRa75/JRbjnQhRaK29cTWmGYwVkcNGukeCupRKFx4=;
        b=F/N98H76yhYyHsoO1d5QzdYu/jtyndft110ycP7XPDNKxM1eywIk7yejF4IS785pv7
         Yl/51Jr6p1QNHhxYaXaXRu1OddCjRkyG6I+N1135qRnm0Vbfc7CCBBnyI6H02GgDXIYC
         idiFlzY7R4uyuu1XovUCYzonbb7XPaMRdGl/sz7yjiW91VdrfME7f9surhlkhCbzW7R/
         bWl7KLBxgzNhUHePV+R6dYvMx+C+W9UXLbIwnI/VZDPFt/rXxrZxqtnTv478bAtXwR7a
         Px39Dh83fofbbp6ifLti5ihnVF9QrswCqgAYYloYnyuoUnhw5nVbu89m95KCNh748Y12
         GFbw==
X-Forwarded-Encrypted: i=1; AFNElJ/nbRCLE0E4eCzFT3L3KxgVpkB7d7KlrLF8WiPJu21wtsg5b/UchBjXtftzQrGGafeDIIAHdUBucQ==@kvack.org
X-Gm-Message-State: AOJu0YwdLL/l4AibhkRwJ3vwZrpijWXTgHy60eRZxWEJR0Q85QCLdG8m
	KM/BQ42ulIoXq1lzBkq7hf402ui4QSlmzYs8BUy/2xk37auJMD1sHE6ap8pF4ZezoNHaVFZqr+6
	6GsBU
X-Gm-Gg: Acq92OGSXCtk+F6OxYFvOvUt8Hc5yYPYys6uHaRBlkKX8FFauHR/iBP8TtyOAzNGXp+
	+oYTmRKPDwbPk9GJ7QMiRNnBxRLUELfgutWABqY733rWr5hl9XQ953HvCP9bLK18KfJbBx0+Cq4
	OHQyOfAWgcguXYJqGVThCI0Pyba3XoT46eCwq5UWD2vTqZ8+XZRAnaNAJnKa7f2RQV4XaNY/hLx
	sBWCg22DlsyciV+YV/RLYYCbFuRO50uo0jhCvPxrztElf14FqsEwpEOBNDrekQROvGte5ZSVv63
	iicymxv1mfYVXzR7g+uQsXBlomVSHqHsIIBG2AA5m3Dn3WuiyOp7P5+de6pv0tNVOup96BSLY1y
	7qVu2BvOWu+YfQPIwkl3EFexzWOD/fizy++pnd+933BgB13CGvgpT3fjxC7RFz3/M+np8W6EXsL
	rbw/B1bUlFOxIekba9SIZrt1i3WX1JFI4FD4VY
X-Received: by 2002:a05:600c:3d96:b0:490:5429:1513 with SMTP id 5b1f17b1804b1-49054291bbamr145600515e9.6.1779700072522;
        Mon, 25 May 2026 02:07:52 -0700 (PDT)
Received: from localhost (109-81-80-247.rct.o2.cz. [109.81.80.247])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm24638766f8f.30.2026.05.25.02.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 02:07:52 -0700 (PDT)
Date: Mon, 25 May 2026 11:07:50 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: use round-robin victim selection in refill_stock
Message-ID: <ahQRZlXliL6dhRXv@tiehlicka>
References: <20260521223751.3794625-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521223751.3794625-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam11
X-Stat-Signature: nw7fjfswrh6f3epwt7u9w5nh58cgq6zw
X-Rspamd-Queue-Id: F2734A0009
X-Rspam-User: 
X-HE-Tag: 1779700073-175882
X-HE-Meta: U2FsdGVkX198McposEz3YyAyjPjHRgZ1Gu1KYXsRGSthLaBbZp9kOQjJInEsNHkj1lYbOmHyiTBdQI9Elkbf+JDgGqWFecFt9ujLdXVO6QqmpChirwDhtGfsiGI8lzQWjj48sLnBZXCLhg7yEeh9YPXy/7nCsJs+qRRyL0wL3gHmvuLwwf3ZD4aTVixR5S83Y8+qYTudUVJg1mbL83TMoLehUd+Ph3oz4g1y0tvTZS73YnwSOO20Cv3JncxUHhloKjY7JTox1K3KLC799YByDlI0PdbhoJDTHE8UquQl05iYOv1Yk/HnWoZW703m54/9PJNH6IvmRVh6KbzfW9UL9M2kbfsYRNQ1ws1ZPYD0xzCAFrlL3vpMV8OriCNPtLYTYqxCxhEJApwFCI6PKiizmvEVDjRpu/WJ8rmPKjxdirzT+ZE02TnKOYwM3FnfLlNaehgS3vKQOYWyRTmulYALmTbq7RZanI2fNsXx1S4kjuJaw1CpuTwGplFJLfaSdXdwH6d3HpYiqujguGHMhvHYqnnl4YoHxU9FoUqRVG8obUxn07i140nTuYaTWn/8xfKyinM3NJmPnQRZxe2F2ipl1P2LdZb/O1VhZbuSooq7mbAmlrdsxPJB8EGjDlXjIdPZPOXGD45yL2Epr15zUQOnyr2iPTLg1XB/4fxzSP0a6a8FbPTqcHAPB9HGc8KTHq8umFoQSLeYyd0YxCgZKQRKD8D9OmhgNRPQfyPHdihPCoMy+wBo70TzgeywqjgRG8aqhpBT8daQ1ixF/NjUFJRdrsmyha8vWaz0VnrtlVkx4eGcDJgottUJiK0L7wkpqxj0dFH3Ocew2QvZfxnYP1XOPkHKYbqHA2MUycFzHotTpEit2hBGF24ogSggIIooIvxVsGBSDWUbgh+XVOIoAUx2ICMlQshdd8I6AUmhiWhC/wh3kjgbcnhS82vg9Y5mU4u7MMymJDukZKVslApd5QP
 6BQQJbaE
 koagE0tYPP55cDXRodDPendk9AtFEzPD214vXRE4p2lXcEmkwF6ZdhcfLh3+QFQFq5unXfQVH8suvMoWDMZ/l13F21YXU4jTlA3KxsMLmzeMh2Dah0NbxN3rqidTS6bi09JBvb/RBQ8FkIeYzmDqnR4hQ7/it2Mu3YUxUo7tNBOAM/tP/J2ezlyWpRRPyZwS8Xd2D9q3sxo9z7xsd0PasZ5KiSbasF00t1SNgc5gRnnECPC/lUBHIM2PSIuEeNDSvw5N3NZ3+oAaeJyZT3mMHk1JFvdM6aSegkCUHMNLxDm7Wwc62irqhZuI575k1yQMNhgEZCNT0GYnFrrUP+s/nVO9ia97v55bh4bDsKHlzo2RKJwfrQg9K/miR5yNKv3imibWC5L8Y56dUNxd35dFYas4r+ksFLxp+gNQLwpHKiAEtMLamzEkoYcn6R6J58HydvqctEKnIROrc+xbfIYVbsyXUPW3Gq1PqnRlnfMihRXHKfak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 21-05-26 15:37:51, Shakeel Butt wrote:
> Harry Yoo reported that get_random_u32_below() is not safe to call in
> the nmi context and memcg charge draining can happen in nmi context.
> 
> More specifically get_random_u32_below() is neither reentrant- nor
> NMI-safe: it acquires a per-cpu local_lock via local_lock_irqsave() on
> the batched_entropy_u32 state. An NMI that lands on a CPU mid-update of
> the ChaCha batch state and recurses into the random subsystem would
> corrupt that state. The memcg_stock local_trylock prevents re-entry
> on the percpu stock itself, but cannot protect an unrelated
> subsystem's per-cpu lock.
> 
> Replace the random pick with a per-cpu round-robin counter stored in
> memcg_stock_pcp and serialized by the same local_trylock that already
> guards cached[] and nr_pages[]. No atomics, no random calls, no extra
> locks needed.
> 
> Fixes: f735eebe55f8f ("memcg: multi-memcg percpu charge cache")
> Reported-by: Harry Yoo <harry@kernel.org>
> Closes: https://lore.kernel.org/4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org/
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  mm/memcontrol.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0eb50e639f0a..6392a2704441 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2031,6 +2031,7 @@ struct memcg_stock_pcp {
>  
>  	struct work_struct work;
>  	unsigned long flags;
> +	uint8_t drain_idx;
>  };
>  
>  static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
> @@ -2214,7 +2215,9 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  	if (!success) {
>  		i = empty_slot;
>  		if (i == -1) {
> -			i = get_random_u32_below(NR_MEMCG_STOCK);
> +			i = stock->drain_idx++;
> +			if (stock->drain_idx == NR_MEMCG_STOCK)
> +				stock->drain_idx = 0;
>  			drain_stock(stock, i);
>  		}
>  		css_get(&memcg->css);
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

