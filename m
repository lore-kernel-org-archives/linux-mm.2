Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDB3CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 12:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58CC6B0031; Fri, 28 Nov 2025 07:39:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30146B0032; Fri, 28 Nov 2025 07:39:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D1A6B0062; Fri, 28 Nov 2025 07:39:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C16986B0031
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:39:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 726E31605AB
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:39:19 +0000 (UTC)
X-FDA: 84159971238.02.7D176B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9F99740008
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:39:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZ9LaEnw;
	spf=pass (imf01.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764333557;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BhS1UHOlZ0zTu/sEX4vpXCuhVMMva0NKWYGwDaSpbS4=;
	b=TpCWsqxVT2SN9tUzrDTsIVgGHs7TdSScyQVOVdFvw1WTZvzONRq6AHiYojYQdNXKm42Wqm
	gkgVg5InVc/xRhvB2s8Gma38IAGs5zzavbt9u2AtrhLeySC4XyuJYFJoSUHOwSMvRoQIdL
	1Ye6W+HML4s5DkdoW2MTTqQw128LxrQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764333557; a=rsa-sha256;
	cv=none;
	b=06dVQTFDBUeZhSIBfIMhJnJVIqhWg356mcjxbF5WoHDV6MEMxrNGmxSwqR30iBmRjeWAvn
	zUHmJS9gwA/Ldvd1+u9a3tHP0ixt21NF2X9Hx4A6rwdBwJteObWQ6CDEqpXtvQpdWN3tL6
	OSFnFKYn74DFPy2ZxG5rhToTGvS/DMA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZ9LaEnw;
	spf=pass (imf01.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFD0C60154;
	Fri, 28 Nov 2025 12:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E500C4CEF1;
	Fri, 28 Nov 2025 12:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764333556;
	bh=g+SkIfajbV0hqvLZ2wup7Z47s5dD85cBMdZ7+aTYs9E=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pZ9LaEnwtoMzE2wP2JePzB0UIbDFe/z9WwsqJMrJ6cu8/bpETlbYrY84oneD3Rkik
	 eQQX0YSVwarX9f71FzDcafq2O+YLCxYZB6Wo1LRQZ9kkbJx25PobIAKjp3XyCr+4EQ
	 uOyDZo9HbPpk8BUZm2PlqLrPbneIgJr0SFU4xMvNKThQDt9V9IsR2fLb9sqNFP4k8p
	 Oyxdf3sZUU9P5Hw4UT3x0zX7fvyobkyNDnN+e+tX1I/rTHSs4xaXXu/na9egoDsvhv
	 E2puVi41ZsqqSRvNPDLTV/OnRNmuoq1+j9Hfdr63UB+JEVNZDlCJU04xKKeF1UZj1O
	 KbWaa4cLAs83Q==
Message-ID: <1f19b775-d670-40ef-9147-2dcdce62b56e@kernel.org>
Date: Fri, 28 Nov 2025 13:38:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Daniel Gomez <da.gomez@kernel.org>
Subject: Re: [PATCH V1] mm/slab: introduce kvfree_rcu_barrier_on_cache() for
 cache destruction
To: Harry Yoo <harry.yoo@oracle.com>, surenb@google.com
Cc: Liam.Howlett@oracle.com, atomlin@atomlin.com, bpf@vger.kernel.org,
 cl@gentwo.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, lucas.demarchi@intel.com,
 maple-tree@lists.infradead.org, mcgrof@kernel.org, petr.pavlu@suse.com,
 rcu@vger.kernel.org, rientjes@google.com, roman.gushchin@linux.dev,
 samitolvanen@google.com, sidhartha.kumar@oracle.com, urezki@gmail.com,
 vbabka@suse.cz, jonathanh@nvidia.com
References: <CAJuCfpFTMQD6oyR_Q1ds7XL4Km7h2mmzSv4z7f5fFnQ14=+g_A@mail.gmail.com>
 <20251128113740.90129-1-harry.yoo@oracle.com>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
Organization: kernel.org
In-Reply-To: <20251128113740.90129-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F99740008
X-Stat-Signature: a94jzoxyzgistcttzj8wx6g671xsg81j
X-HE-Tag: 1764333557-907922
X-HE-Meta: U2FsdGVkX1/PuRG6IWpuqIBFbNAH/If0saBCRV5L/fTUF7mJlOtkOYD6JG8H7RiEa+LCYsrJ8SWKKk0w+LRPmnVhDi0farO/CEielEbaTxxocgKVnCYvMERZAyEjZWIpJ2tlLGdb8LEQIRLif04Z8iLVextibniZRJ9w+sqLoTgiZjuey3JxU6nh+q1xHuZJVyewftPi/PijEW3jgoGZSjqt8NwYaJVegYg/11IcPaJnOcY+5oO1MvYJUXbte/wkfDKjW9YQzfyI3+QGY0yP9josz+jgKz6nPf41KB5cmUlDOQ91hTup5Jw4+dMAjs4YzLXwzBN6U1HTx4lZr2rre1nyGQXqRP0/DR34rlcnGCYlKznDoGt3V7vLRo5hmnySdbHY73a9c+1xxKY37U8IVos26CxQ94lu1w8Nq68MARkMIpene04SYkNNajgDAIR5mlSdv7cx8ahewZ6hFl+oTqTmdnEEZtHz5Z3IS4LgREZaDBpWnaoT2zt/+nAIMDS+q0Omq3otefebbUisZDnrLsRD2C+VWIuxQbChfsQxGlfB08A9IRkF17X7Mrnn4HaN00ztQwPrNVt3w38YnV7snCaIiCkTyiMQ/o4HN8uKQgO2kP0HzvtHYIT/g9CUxTTIK+SJWTPuXytMbYAI4CoZcAzOb4CbM10kXBL4WSxK9vNYlaEbE8wNpsl5lHmppvWeQIxEH2ueC21ZvjfxIqmImEjgWO1Ssqv5jOUQg95feBVxKk0Hb63G5U6MQ1e89j9WHXDa2QiNeBCVh9VySTn4FTdnJQ1b3Cj10pcAFtfI9dDz6N/4HPnJVbM+N+mvJnXAthmIwtZmZ2e8CLJqJaugmO0UpO62OzPN4odnzELWVmkCh8RqwH84OhsblnLnGrKIy0EVkatrbbrD15NEAVPm+dF3rr8H1bLA6IhAaQb4mRBwdVjw0TfgKAKjyrtW1lWmhCxb8f4D5SqX5xSgfIe
 Bhwo3iRw
 h3ndmP1U0deICMUSph15NLZBLbJamlgur76mV4r3pnxf7sSjQsfEc5s/KXG+l4QZIXOZsjF3OOZPHXKlKH4ZTzHasWbxBhJamQwUR/e9lNJ3cCZe7xpOaPPn+TwxMR3yMHjG0rwniT0KiIq0e7oA+4ez1P+OzEogVEw2n1LL4hSG1ckuFnU6Qo4Di8NMPoSPiYUZWxW0y6ny4pQsEvVeBo0hYqDHYl4tb3zcDbWbYv0y8F2nkEy6gRxgCOFEUOEGo/IxyTcLsYI1Ui4vQIGU22FfQjEdcJoxa2xCFGN/Tm7nl+yCTjutyJcLLtsuBLVK1MEGC41O52bBR460QT8d9OzhpNn0SEJMtWJDAppiQ3qdT6fgVG4qRpCLyyM3nKC4R9JBWuu7tP3AWaVpC+my5Jt+zF0Qi63iiPavPs1TVA/BYhypjRISCbdjUCUrScW4OdYKMQ5FGGdmxAy9r8bb0IAsM+rCtu7VKcBSeIV+aHOSV7jZqDy9pcmXHV8C0JXhIwW8hqAovpvm87ujNl2Tr1aMzsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/11/2025 12.37, Harry Yoo wrote:
> Currently, kvfree_rcu_barrier() flushes RCU sheaves across all slab
> caches when a cache is destroyed. This is unnecessary when destroying
> a slab cache; only the RCU sheaves belonging to the cache being destroyed
> need to be flushed.
> 
> As suggested by Vlastimil Babka, introduce a weaker form of
> kvfree_rcu_barrier() that operates on a specific slab cache and call it
> on cache destruction.
> 
> The performance benefit is evaluated on a 12 core 24 threads AMD Ryzen
> 5900X machine (1 socket), by loading slub_kunit module.
> 
> Before:
>   Total calls: 19
>   Average latency (us): 8529
>   Total time (us): 162069
> 
> After:
>   Total calls: 19
>   Average latency (us): 3804
>   Total time (us): 72287
> 
> Link: https://lore.kernel.org/linux-mm/0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org
> Link: https://lore.kernel.org/linux-mm/e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com
> Link: https://lore.kernel.org/linux-mm/1bda09da-93be-4737-aef0-d47f8c5c9301@suse.cz
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---

Thanks Harry for the patch,

A quick test on a different machine from the one I originally used to report
this shows a decrease from 214s to 100s.

LGTM,

Tested-by: Daniel Gomez <da.gomez@samsung.com>

> 
> Not sure if the regression is worse on the reporters' machines due to
> higher core count (or because some cores were busy doing other things,
> dunno).

FWIW, CI modules run on an 8 core VM. Depending on the host CPU, this made the
absolute number different but equivalent performance degradation.

> 
> Hopefully this will reduce the time to complete tests,
> and Suren could add his patch on top of this ;)
> 
>  include/linux/slab.h |  5 ++++
>  mm/slab.h            |  1 +
>  mm/slab_common.c     | 52 +++++++++++++++++++++++++++++------------
>  mm/slub.c            | 55 ++++++++++++++++++++++++--------------------
>  4 files changed, 73 insertions(+), 40 deletions(-)

