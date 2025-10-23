Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E948CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F488E001B; Thu, 23 Oct 2025 09:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816F08E0002; Thu, 23 Oct 2025 09:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CCE8E001B; Thu, 23 Oct 2025 09:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA088E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:18:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5DFB140B04
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:18:19 +0000 (UTC)
X-FDA: 84029432718.25.DB473AB
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf24.hostedemail.com (Postfix) with ESMTP id C6D9C180008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:18:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SU1tA276;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225498; a=rsa-sha256;
	cv=none;
	b=Dcb+YmDoyfPvRO1aa+lkhRfIPV/0VS8s/LplogxRVyF4+hIT35E2i344BgSrLdJ7bIBO7R
	QE0Ky69u7ifj77dymhlpmVrzce7Z/JHDrSTXRyRur3d/RbEilK3o0FHtgHMvuM/eeqUSnF
	54y7O4R2mpl+RGgIXDLeG7VnX75U7OM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SU1tA276;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3He/u9vFruVYiw+KrZIv2T9bBvLzWNfQ1++/hzzXmzs=;
	b=SlDbbbfiLCkuhPY3/e26pMtmLNPDX91T4/FttwI8Jq35e1SEYBB/2dTLbMDnx74nfyRk9p
	O6rxkjlpGqdhbM/CMnuEfySMWa6QA1lk4+WyC9vSFraXRCWGcu7df68uFu6vzxVA4gwK8h
	WZllk4zfUJfsOT1hUIV/YxTMwEDzTnA=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-46fcf9f63b6so4723215e9.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761225496; x=1761830296; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3He/u9vFruVYiw+KrZIv2T9bBvLzWNfQ1++/hzzXmzs=;
        b=SU1tA276CjJpWIgM/kOOUhNWrVkExuzujE+UpkSQjzVhFw3ZlDJwuFm/gxfp3NQSD+
         2Wf8cEoE5HGIpBOG4QujHgf841XdfZdQ3RBMQn5qyWEcZMmU7knoV6XWK9lSo8nER65I
         9yVwZ9KBUSeVgI8A52G0RywNcrU85hoEwGStVcltWAFJF7Wl6uq/M+dznrGvP8gmYyTw
         3aAh7BmM/2+GRkiccW5EfRUiY/kOmGSIkSzDCn0Rj4EtFTHkBVAVED9FhkGPvRJ5J45c
         OvtTV3cbeuNzQSzfyrzMMdzkYEBtuyQMMyAn+Xs2/sIsg0sPgJ8d/tKLU9wbNnbE8Atk
         ZaWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225496; x=1761830296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3He/u9vFruVYiw+KrZIv2T9bBvLzWNfQ1++/hzzXmzs=;
        b=VLhcjA9cCnMj4io0WBOrk1CxRY3qu2NdjI98UsgHHsvma3sph+pOEZh7ZCd43hrW/P
         WL0oAGb4QOc08hXi8QTfV7EZ8H+38kEtgczRqB5U9x1o8zqNJ+b2WKuDOtaFVH5mNHvg
         WCCojqKWvVCMi4udeLBOXuWkYdl0Uo5A+tCViuDgOdKJ4WZ9trv8iU/jPOOF0a2OKXDy
         4nenjbs2v0r4VainKJhnDQGUo3yt5Kml2dkQAvVVgtAWEr6Ci/Ei4y0bg/nS9ep1qnqg
         sb9gFxMfc3uVhXLRaEdBfIaaBmlHvEchK3EV/b1cNsYgpyO9lB7F5TOveyeA1uy7pRWk
         AkJA==
X-Forwarded-Encrypted: i=1; AJvYcCWTVXDFhOiBD0FvhZ3FJ5ddTcsoE3gLWZj3Oy6AlXOKWcJOEvbZHedwwC+yZ+Ncg2pxe23Z+ee45Q==@kvack.org
X-Gm-Message-State: AOJu0Yx7B4q1GFHF4F4VhVhyGYUCc0ZVnCQGr854eA+glCI5z8cDdziI
	V7rU69wY65iiWkBHRQQ9yTz8XBvREtdeKpX9lqHl5sSDobAVyQVDmbMrpyL2IRRFM/ruJQakIou
	gVVnR9LkUSHn+
X-Gm-Gg: ASbGncubPfAvXch3VRUHi+Ec2SR2RF3LCaoSGOklQzTbRhbDPbmwBw4bT12y4m5/4ii
	D5oPQ9dNMHqHKRuTkY//Y1vTrbasQhK9N2UL2u8Lwu5dM8xnIJZlkyqfeM9izjlErTY/kai4UcM
	UQQDgRA5TVuCrf3q851eSgEj6RcFEOXEe6DLl9L7vddYFSAFLLfPiuZy30fVJjk1XvJtCY5owLE
	bjuOtwyxLjRWS90MTH6N88yqrfY6klr54lzpKyKhi6hw9AtTZkOeWeS8zAeDL6t0H22CMA8iGwX
	GKH8M1KEbbxmNGM4Dqge79S1/YH/hy+y1T+Y1wkoTH2+1yKZiZlq4rZBywxFiaYIw15mvPsVcC1
	ZTGL0Z2LLNo5NZtnL5PVNmd+ihQxmGdYYGwTSWQnUzL7pkQXeglrVS9kjttsX3b0x0wYJNSToFT
	fBJwNOnz47NE/0D38fkByHKMjK3705Mt9EalpJ
X-Google-Smtp-Source: AGHT+IFI7d4omhBXbweB66gvKZIb/3KhXaNp52twT+N2y9aaJX7j7EPXuCFbvF4eTwXcj+1QGz7jOQ==
X-Received: by 2002:a05:600c:3512:b0:471:12c2:201f with SMTP id 5b1f17b1804b1-471179134f0mr209161265e9.32.1761225496200;
        Thu, 23 Oct 2025 06:18:16 -0700 (PDT)
Received: from localhost (134.pool62-36-43.static.orange.es. [62.36.43.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c428f709sm98414875e9.8.2025.10.23.06.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:18:15 -0700 (PDT)
Date: Thu, 23 Oct 2025 15:18:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: manually uninline __memcg_memory_event
Message-ID: <aPorFhxQc7K5iLZc@tiehlicka>
References: <20251021234425.1885471-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021234425.1885471-1-shakeel.butt@linux.dev>
X-Stat-Signature: b9senzryik75az5k3qcsbz67pxmoz5qn
X-Rspamd-Queue-Id: C6D9C180008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761225497-908644
X-HE-Meta: U2FsdGVkX1+7iHmzENodujVXGaRpCfd2aKPIOsYSim9gfppGdTMHzhyum3aM7v57AxjTd4X2QPaW8PaYbAegMeTnkVHMBizp9dmY+24iPJiIgcCfEGH7xszL324aZfj7lq9zNDvxk835eWxGI5EWiswbMkMaPUIN43MmUDUDublD0siRn6tOcLBYCsmRfbaZ/Aq+zGis5usfyTBhL5HXRXQd5zZAAQ92WhjszAPUsilvwpeXf0KdWah2ayIJv0C7V6EoSQBR9vMYTWX5/MBoXOf5r+qjPqJUX1X3fvXNPUO4M+7gRudoQTk56+QqGy4KqoU3fuKtrOoyVn/sBtfwCZQPViwn+zTeZJjhGyoxkM59hzPaTx8Qea5NiwZHD55LplnFXGiCBj5fKYtzbBPfWxyqyGsqImMSaOJo38vgy265+dmZjS7QZsYe478GkBWQS+NOEvB9mZ2KOVZwY2R7o/F230476jg/rQdDXYZ8jg/qDGEUnE6d68bTYd0w96B8/H42nZD1n7GO5Ug1JtRUXcsLhcwW8vXCa4OZ5h9LYoufFxK0nXg6razAAXcEBKmjiruTfCKef2lbpjLVmsDZdW2e4AKaAbjnn6VjOCSlpOIk+xhBlnD93lzFzDRBgmMx7qJ3K13WfugkLudh+9ZwxEuDGz9DGZRGuHmEvsa8Zs7aT+18lEqTkeumAgkbdC76coq/2lQfOpXquuFkClidJCdegMe0hJDS+mw8Ic0doN0EzOIf/3RSfzqH4G58FQTmyQ4BSUa4hgE9G9k8QCXMcw117ku3s912h2DpwgxZCps6B3Br9XKu5I+3g+Yir4VIxxzv/h1acEzAJSell8e1NztCWVeh2zIY23S+SHu3F+PDEAz/zHVTdiBRBF+JRkAmwc51mOsnrjGlG2QxmZYxn3rSr+NUfg7N8m7uHXrYgmRf0jCInfek4g3Otv+PxWb3As0vpVHal1jfdWd//7g
 HAcUEHhq
 LTg8xcXnuIYV5gETplb0SuEGNVp6m2ZGix30xqn3uH9vgtlVDQWnVykvw1WuWV/hwkTk7C9mefjz4taXW9nyk5c4kJyb8YWV2GkVsvRfqRVYX6Yc3gL8OQqfX3pZMq0OkLB3YhkD8AftYlJbvhFJ4uTWUvoM9Qm129kYHfJZPoOPbUMJrR4Gqwc/lA2b2FZk7LKwQzoleQ6ptwva+K4AGEkom+YSEcFdvNfbrJkorg2uXdpslbtTSr1XPkFFonnHGJH/+UWVuZrvIg9Tz2kzzgm4pvWrJAQ/urxqFtXxVFHXAaLtlvOehhM2wocwyVSSj0FUePcGqC4uWmtN8XBnMzW9YsjZBUfRn3nXmI6b9/OobHWx6EjYSi77+hNGJMHjAbYMWpW2l7qNWVW29/KAgIdxelGkxu94jwhqTfIl7k6nXau6TGXUJ+JS2ePAg23uyovcjyY8koossNsk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 21-10-25 16:44:25, Shakeel Butt wrote:
> The function __memcg_memory_event has been unnecessarily marked inline
> even when it is not really performance critical. It is usually called
> to track extreme conditions. Over the time, it has evolved to include
> more functionality and inlining it is causing more harm.
> 
> Before the patch:
> $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
>    text    data     bss     dec     hex filename
>   35645   10574    4192   50411    c4eb mm/memcontrol.o
>   54738    1658       0   56396    dc4c net/ipv4/tcp_input.o
>   34644    1065       0   35709    8b7d net/ipv4/tcp_output.o
> 
> After the patch:
> $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
>    text    data     bss     dec     hex filename
>   35137   10446    4192   49775    c26f mm/memcontrol.o
>   54322    1562       0   55884    da4c net/ipv4/tcp_input.o
>   34492    1017       0   35509    8ab5 net/ipv4/tcp_output.o
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>

As the only user is in tree should we make that EXPORT_SYMBOL_GPL
instead?

-- 
Michal Hocko
SUSE Labs

