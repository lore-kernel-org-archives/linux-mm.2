Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B9B4D43342
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 19:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3694A6B0005; Thu, 11 Dec 2025 14:21:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F23A6B0006; Thu, 11 Dec 2025 14:21:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1346B0007; Thu, 11 Dec 2025 14:21:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09B316B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 14:21:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90984C02EF
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 19:21:27 +0000 (UTC)
X-FDA: 84208159014.03.3C0FF9B
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A3F44000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 19:21:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mpPhEumS;
	spf=pass (imf27.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765480886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3W9fwDrcHoldv9DpxMw/S2gNbgaU+8zE2YQ9rFD1zWo=;
	b=OtAuY7FkMC5LvDySG1whSRJDKjY89z0t/YnCjF8mkQ95WhwIM3rdt7pI66/asHOaetl9qb
	4SwUrSCUzxdvs23T+NET34QB5ETencEbA8XMjjFYm+byUV4USI5U3tqca85OwjY8qGl5lP
	/aH3nQ66mgvwsEynguxKJOPcyihxEZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765480886; a=rsa-sha256;
	cv=none;
	b=UPzQ3Mg0Px2Fhx7pjqxmTE9QMuEfg1HInZXbPfzY4wlI6GoIcBARbYoF9IRAzqpuNLc+lG
	H9194jmE/I8BLN8B+wmEjTR2l7Rydl7E7nB6dCmiovrJQHQXajIVdMTozJWXfqQ2eIpwek
	2mT7E9YwIBgRDJk1oH9p7RPrMYqx5CU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mpPhEumS;
	spf=pass (imf27.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 11 Dec 2025 19:21:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765480883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3W9fwDrcHoldv9DpxMw/S2gNbgaU+8zE2YQ9rFD1zWo=;
	b=mpPhEumSry4YKmfKQHO7LmlRuVeo+pryIyyMDhbaLogmdeU+0PvYO1NmvxEFhr9O4GwmPl
	uD4mTaswToJ/Ael/CGi8KBHMQJP5RQi6d7KnXkCY40cSuHKhN2Ay/8OH4Vh/3aBYCAyBdb
	cVbClk8ijetedVxJ/0INEBzFSnAwEiA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: zswap: delete unused acomp->is_sleepable
Message-ID: <kzjyxqcgqlv27wopipjvv7pjawhiefi4dykkiaatx5tkruch3b@gz6knzofpqei>
References: <20251211025645.820517-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211025645.820517-1-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dch4ph9ib591bz3hd771g89793dicxhu
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A3F44000A
X-Rspam-User: 
X-HE-Tag: 1765480885-873105
X-HE-Meta: U2FsdGVkX18gAdfkmC0vv8nRZ7UWCdiz5BHK56BO86DKbZlxLcINil+6dWcCLq8eX0KWscw9uZPuCecDbS+Mtc0ABWmn1QlGAC/Z1xIbfuZcKCPFAXnEFgUEwOnB7mco/5XMfHw2WmsxF256KJGELTvMV8RC2iE5k6dRGAKxuZdkIYB6wp2boEDhMjmIrYSgkuZov01uVU4pA0/c1I1mQtoXARWV+3lkRsXHgODDI3ns3gvgr4EeoDRvXB+WNjztUslvQoqGhKn/emQK6zzTkBQ9XcJNbvDPMRRsgSo5NCkwb8gLLJCvd1pSxMFFmHLAQ6X3n8fSAN9t1g2JnWRNfYf1Rl0OxeewdIOOGeKu2ydk71yrgYwn6oqdPXhXdQGj/gEBJVhZCYXlN+ocbZq6WYr1b97JkUEVT+CuX3Klqeqa5TR3/egPAHOxrwkbabhLDCGvjTa1RGoiZnkDINCcKWuEdVGEjg4KDykDcgtT9Oz4zhAOKCNnKHhU8HLMSyMvkoEuj+pKLVuJio0BccYw+kuQdsm3JQVTB9NSD9BALW7ch9qcaWuq2RcpXWzhpav7u6VT7GTQNfqxMMwCQSFrrqdm9f+bW0fx4B+nNjXeHJNaSL/gOvyxg1+nqSO2sesDU2JhUk2zwcB1kttWMhnXbzxGucA0FLy4plNy5QK9vORMbTsp09sEs7puSsG/2TXq4woqCdAV/1asm74eIxkhwK/MBCUHoWNEfg6M28D36B9+24VClMDMrWanQVBeaBhideCLinMtBg5PH9pmEXxUrObepuZD6jNtmhPuTzU41PxUlB5iA6uxjFRw+y7nwlno8TuHWNZDOYDdS6s93ED2R6EucT6xbeTn8z7YEbI7/j/EZuy1VhyoVyEEenpInKuGEApa+pDPzFeP16qULLjYaPMFyeESZwRyYoSCoeSelrOXKZDSOBGi/VeoBG2gCrWFXvQFkOIhzsg817OYUSk
 LN5YZd0C
 5ld1pjxwFj4jidkX/Arb7Dzg9qcqkqKKsLbfLjWoProANtdriWexjRjudG+u7M4l9TeJzjqHscGRGHjM4/889qSMq2B3tT8MyUaDXKD11c7/20VXV3jxmj6S2yDlj3570cbOoEA4d2nHpV0JHOPbi/zZ+4I50dw5i3ooRZtw8+X02qwVEMqU9Y9gwHyj6jZA0qHa6uOGsEfYXtUjtd6xAqD+R3gn2CkfOjoAnH1ILxoylH6DWEfRpqWw1WkkCdF12wmzDa2bOTlBTgKWEoe/r8YPf5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 09:56:45PM -0500, Johannes Weiner wrote:
> This hasn't been used since 7d4c9629b74f ("mm: zswap: use object
> read/write APIs instead of object mapping APIs"). Drop it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  mm/zswap.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0f8b13a958..84797ed4d3f5 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -141,7 +141,6 @@ struct crypto_acomp_ctx {
>  	struct crypto_wait wait;
>  	u8 *buffer;
>  	struct mutex mutex;
> -	bool is_sleepable;
>  };
>  
>  /*
> @@ -781,7 +780,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  
>  	acomp_ctx->buffer = buffer;
>  	acomp_ctx->acomp = acomp;
> -	acomp_ctx->is_sleepable = acomp_is_async(acomp);
>  	acomp_ctx->req = req;
>  	mutex_unlock(&acomp_ctx->mutex);
>  	return 0;
> -- 
> 2.52.0
> 

