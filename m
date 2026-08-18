Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF19C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B576B0261; Tue, 18 Aug 2026 06:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27826B0465; Tue, 18 Aug 2026 06:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEED26B050D; Tue, 18 Aug 2026 06:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8FBD6B0261
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:03:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E6CF40B99
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:03:13 +0000 (UTC)
X-FDA: 85113952266.29.DCC4E9D
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2226540003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:03:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fngKvVUk;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787047391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTSEVb32olrehgQ8+kMO9r1tytqXhQqOIt2PkeskveQ=;
	b=sS8OVG87uOeYH84kk18cWRH/2iFiHfMYCOTYtaf8TldhzQpYCik+zIFb9epov/11CdpQKk
	dnrrDbbL7b30K72yGI6w3NqshP35a11C/jiBv4r/IoWY1CbXMxe5iSDd7wozNAUt6lzXSp
	Bn2lAmZbv3ckaCUSY9KbKNdbGbsMopw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fngKvVUk;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787047391;
	b=uiBLVTCJk8Ccr05Ci0uIONB87dw4ru6f4uBF0fp51YyPXS2QLRP2uq3B2pnJ6iVb0D+d47
	FsQs1tGZJRJgPiHMD6pylaUOAd/xheGPM7mf6x3FD4c/0crRCJ6buuEt3VEojHwHZqMawN
	qGexBlr3VvrfcqN3AX746ECXXEkN2Ko=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49954b88fffso49558325e9.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787047389; x=1787652189; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BTSEVb32olrehgQ8+kMO9r1tytqXhQqOIt2PkeskveQ=;
        b=fngKvVUk9f2dZzgtBXh2eJyDQ9if3S5DeXUUBY+gbaKxdVQdMyLwr67vGDvT7Hv+HZ
         koam1pmDh/GXIpz053KptRzCagU1UL1hzvsAVVuCL9ZUMgrb30gvKHXKYUWfkfJukreE
         w5d20B/yZAEZ5rGZrdYPQykTf/Z7P2VhAcTJ1H2tPQgJx3LWFyzu87v/mpJhEV7Czwpm
         2LdNvoDRN7dqOL50gmSQDukOUfk5EJpbw8fKvCF0yV8GDGYZ60FkEFueAXNeY6CGtrWr
         3Fstm5rucFhd4mwbuaYUyCYoDfl83b3O0Ch2g98kZbtrj06FoJwxVbJ7GwjFTQDnLUNa
         GG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787047389; x=1787652189;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BTSEVb32olrehgQ8+kMO9r1tytqXhQqOIt2PkeskveQ=;
        b=Uy9ijYJRfhjjVju93WecukFrKQt0kc4+iNJzSu9zflf4a9Ttm0IVkjZmUL+c7RpI6d
         xPxnrZy9XCgTh3hGK7nXYtbOSFSUlfPBr8bnIalNpzw1wBPtJGj+SgMd2o2nH0WBy1l8
         kg8taMecHvfL6LhmHdkxKu2S5QZAmamK/HPE6Kdiyn/ETOrfsLuNmQWwO7tEfAm6t9oE
         hCiGFECCE0/LLpkcpXlPRF1DjTGIYAslTJk7SFiME54mNszoyKJW56UUTrtw+avBEFPC
         Zq9TXRUAUHJf6O0fWjcK4UEd0y6vCIn1dkLpIfbrcSqDpIYm3/DNrQGz2Lu/DwxMeUrM
         Pu6w==
X-Forwarded-Encrypted: i=1; AHgh+RpTkS0MErBeFfI2/6sth6TjHDZzocvvEoImD0TIPf3dVhb3wUxN65UsXd3v08EwEKRfDMIDPs80YQ==@kvack.org
X-Gm-Message-State: AOJu0Ywa0hkSPpL7DRjic1F/J7d5vdw+qdZYtxHmTXW8VGlGAepQPZ85
	RqEuGEiO8HSUPfhMj1Gq7VGP8li0gRaJELuI8AnNoAR0CDY6vhIC5Oe60MF0bXU3Fsk=
X-Gm-Gg: AR+sD13FvtgIxn2r8KIoWkDtfOs2qNYFegToBSdOYtugWwOVj99NTcq5x88bLTsUTld
	QVFJ3YiU0MnI3YsadkVaFbkQz6rNOudktlhuaB+17KvVqm6vjzvKCUyzNFukuh5kfFVGe2me139
	vKYheW5ti4TBrTZibzbptXnWSDJ/nPBbeHhMI3NVf3FSy/h36e3qexCF/e7u2J6yK//sIj9nkZl
	8PAa67i+bjzr1+GyrSheevufomLx5ok3Wc5csfTbnYXw+hMJobxLKKRrg5SfmIGjn5LAfeTrHzs
	cA00iWhM/Hfy3Jp7R8jvejnAzA4BIn9KyJfdf7UywNDv2De4KP5lDjMn1gPPoX9f61ruZzziQeZ
	5jgbYrjRP6P+d+k8QXEtOGxZtS2uGiBYFqCllRpvl+HCGXpfDW0WcXjy7axBaJqi3zhX4Tq1x0X
	7OivojYVX0LWJVFm+qV9Xqxwno6na+eNcGIPS4aDZhekAprOoMolMKBh5lx5nVqMTqhGTLoRQjV
	A==
X-Received: by 2002:a05:600c:1d0e:b0:495:7888:281c with SMTP id 5b1f17b1804b1-499878cd5bcmr458829475e9.0.1787047389481;
        Tue, 18 Aug 2026 03:03:09 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499906aaf1dsm213884115e9.4.2026.08.18.03.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 03:03:09 -0700 (PDT)
Date: Tue, 18 Aug 2026 12:03:07 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <joyxiong@yahoo.com>
Subject: Re: [PATCH] memcg: trim the per-cpu charge stock instead of draining
 it
Message-ID: <aoQt2zKsQT-rvjd6@tiehlicka>
References: <20260817234651.666540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817234651.666540-1-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Stat-Signature: h3g5xfog8j6rgw58jb4h76m5tm1xng3c
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2226540003
X-HE-Tag: 1787047390-376327
X-HE-Meta: U2FsdGVkX19sZjRpKAhpnYpmnKHtVZKBuWYehzAOlVYX4jpGnJej4GyaRScGV/EMLL21OJhoN1mU3njqDZqzAdf3NnK7YbZ4zI3Uct/SsGAwqh7YZZCF1/v2RoVbOm24MiUXGT4ssK6HmK+4Uh9lI9W0K42fcwXDlQND4ud8X5VzoFQo+yf0sguvud3wa2MmGT2i0EgW7j3O5EzXHdgBCQ+X/vs1FagaYs8LUUyE5QgtwXRfse7q6uQvSFTf59Sak43cBjlZ6by5n/fz5gwNRB53+XCv9UCp8DjUmOejDCiZcqM8uBv5rJwV94+NSiREGBVVz+hw86rF9P3ieIIjx47nvhtv5gK29tHRYc3+vucdB8YWnpYIJKpXGMbP8OXpEBY71QNrAJN9RkxlFn6tIdulW46GbH1d7mjR6bSrDd5aMJdsKFSXVP1KfXcqoy9J3/7vtPrZQ6mDOQDYXdB2bRBemoLzqWZLkBMvWGcZRsCmbiURP5+0L43N/dYNzx5Q+pTUT+1BqckesDGCb4XQBq8l48G4jmV/iWISTsYuEitzMT2+ALN2fGuPrVYZQIJo9iCR7RIFUgUOszvQmD+/WIc+397aQVtijNMD2IRtNFvsg7O7eMbZR3AWi3H/5PJjBc6BDCglF1aSo45rti5B0/cXrIOO6IxI8gHG58rJPrnIpm3cUDQkv5bjFCWuJDrpMJ8SGYx6t9ShLkmfqd8gxnEYu79lbsAihxcj811BIsQuf0k54E18J7eTz+CuRgc6q0ieZzfNCtSbFW6FMYE5d4mO9PO3210CGjPoBCoqdfx6QLQkQj8N4OJYdEV/zVQS540VUAmxtS3zhGN2o3MHvtlIUYSwM5SkK6Dp8p+5MjMplvtE6J5rMM7/IAOLzru/Zz+rF/CeWiE23Til9jOrz78b1pmYIOfKJcSELsfNKD5/qk+X+RA4BXuce4ICKe0LTdY/kaRCjo3cnDkXs/j
 oDo0HtY9
 NfVSyrYsgznG4IG21EFT5P0RSN0+yFzZb13dmyF8tZ5nEvgWqBdM23Fyfp+KvGTnzDS6buPkuwpqLhQMTDg0XSRfYjp24H+kUzz0ouXkYFOHvKzKrQLGPw2+/oDCs13VsnRuw7kZEjFsoPiwO0nObVYbLUw3AFWlJKJKLMaUfsf8THJfKzzorfmk4rSuS9gWTea2WM4eVKUbIeDjjy7C7xNZJbbU82WwjFMpS3I2NcOmsPnVZzl89tHGqnpPH4xgihNIYpSO6C9MFRPAdKkaglV1HP46GtxY3tp5w9ZRZz9mnWH3zZ7jbmn12At6UQhE+qCSnjiMYAlSVg+tlG4uRE9HPAcXbQnCT4cQUWG5cBVncedhVtadYZjSsOrRGiXc4JYGYeJetdCpfyjH6xmjxLJUSMQiBhr27avDYMehEFCiqgXGn7gQsap4hhLXHmAQ7mAPLzJWMLSANaG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 17-08-26 16:46:51, Shakeel Butt wrote:
> Joy reported that an application generating a request/response traffic
> pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path
> for a range of message sizes, against 0.27% to 0.71% outside that range.
> Running from the root memcg, where socket memory accounting is skipped,
> recovers the performance.
> 
> Tracing the charge path showed that the application generates a pattern
> where the write syscall charges one page and the read syscall uncharges
> two pages on the same CPU. This hits a corner case in the memcg percpu
> stock code that thrashes the stock continuously.
> 
> In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
> watermark and the emptying target, i.e. on a request to charge one page
> the kernel charges MEMCG_CHARGE_BATCH pages and caches
> (MEMCG_CHARGE_BATCH - 1) of them in the percpu stock. The following
> uncharge of 2 pages takes the cached count to (MEMCG_CHARGE_BATCH + 1),
> and refill_stock() then empties the cache completely. With such a
> pattern the percpu stock becomes completely ineffective.
> 
> Instead of a single boundary point for charges, use the technique the
> page allocator uses for its own percpu caches, which keeps the watermark
> and the emptying target apart: nr_pcp_free() frees between batch and
> high - batch pages, leaving at least pcp->batch on the list. Add a high
> watermark MEMCG_STOCK_HIGH and, once the cached count goes over it,
> return only the pages above MEMCG_STOCK_LOW. The watermarks are
> MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
> batch. Peak cached pages per memcg grows from 64 to 96, the same
> high-versus-batch tradeoff the page allocator makes.

The idea is sound. I would just not increase the overall stock size in
the same patch. Fine tuning can be done independently and ideally with
some numbers.
Would it make sense to start with MEMCG_STOCK_HIGH := MEMCG_CHARGE_BATCH 
and  MEMCG_CHARGE_BATCH := MEMCG_CHARGE_BATCH / 2. That would preserve
the maximum stock size while preventing all or nothing behavior which is
indeed suboptimal and pushing charging path to a slower path way too
aggressively.

WDYT?

> Reported-by: Joy Chaoyue Xiong <joyxiong@yahoo.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/memcontrol.c | 31 +++++++++++++++++++++++++------
>  1 file changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..ff7fbcd27422 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2048,6 +2048,21 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
>   * nr_pages in a single cacheline. This may change in future.
>   */
>  #define NR_MEMCG_STOCK 7
> +
> +/*
> + * Watermarks for a charge stock slot, in the spirit of pcp->high and
> + * pcp->batch: MEMCG_STOCK_HIGH is the high watermark at which a slot is
> + * trimmed, and it is trimmed down to MEMCG_STOCK_LOW rather than emptied.
> + *
> + * Using MEMCG_CHARGE_BATCH as both high watermark and emptying target
> + * thrashes: charging one page stocks 63, an uncharge of 2 takes the count
> + * to 65 and empties the slot, and the next charge misses. The watermarks
> + * are MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a
> + * full batch.
> + */
> +#define MEMCG_STOCK_LOW		(MEMCG_CHARGE_BATCH / 2)
> +#define MEMCG_STOCK_HIGH	(MEMCG_STOCK_LOW + MEMCG_CHARGE_BATCH)
> +
>  #define FLUSHING_CACHED_CHARGE	0
>  struct memcg_stock_pcp {
>  	local_trylock_t lock;
> @@ -2223,17 +2238,18 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  {
>  	struct memcg_stock_pcp *stock;
>  	struct mem_cgroup *cached;
> -	uint8_t stock_pages;
> +	unsigned int stock_pages;
>  	bool success = false;
>  	int empty_slot = -1;
>  	int i;
>  
>  	/*
> -	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
> -	 * decide to increase it more than 127 then we will need more careful
> -	 * handling of nr_pages[] in struct memcg_stock_pcp.
> +	 * nr_pages[] is a uint8_t and a slot's count is capped at
> +	 * MEMCG_STOCK_HIGH. Raising MEMCG_CHARGE_BATCH beyond 127 would need
> +	 * more careful handling of nr_pages[] in struct memcg_stock_pcp.
>  	 */
>  	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
> +	BUILD_BUG_ON(MEMCG_STOCK_HIGH > U8_MAX);
>  
>  	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
>  
> @@ -2254,9 +2270,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  			empty_slot = i;
>  		if (memcg == READ_ONCE(stock->cached[i])) {
>  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> +			if (stock_pages > MEMCG_STOCK_HIGH) {
> +				memcg_uncharge(memcg,
> +					       stock_pages - MEMCG_STOCK_LOW);
> +				stock_pages = MEMCG_STOCK_LOW;
> +			}
>  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> -			if (stock_pages > MEMCG_CHARGE_BATCH)
> -				drain_stock(stock, i);
>  			success = true;
>  			break;
>  		}
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

