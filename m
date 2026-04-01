Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6989A107637F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7D66B0005; Wed,  1 Apr 2026 10:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79576B008A; Wed,  1 Apr 2026 10:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967D66B008C; Wed,  1 Apr 2026 10:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85BCF6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:25:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 309A71608EB
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:25:40 +0000 (UTC)
X-FDA: 84610210440.20.98770F2
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1C3E9100012
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:25:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ffu3GeIl;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775053538; a=rsa-sha256;
	cv=none;
	b=mCeO2wNnVCJQ2AZYHQv7PubD2Cg2GQ/b5WSCgP/64t4SDubcKmDbE7KaETNMVjbS2ZT7GS
	QK+r65v3D8kMmQ14sp5YClIRHbqthZQVSSMh23Hevq2EQI4w0MsJidsK9fCBTdEhnyDdij
	ilBcqqQBSKJVIbXdppnFOq7X0h4tl1U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ffu3GeIl;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775053538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z0enE4GAHK8hrP3H3mmhLmXee0EMRPHy0H0LDOHahRQ=;
	b=YjjInLMWeSCn/HKbZKLYwCD82W/VyiX8sEaCLJIW1TiOBtQAiz1ny6mVlu1uWx5vr10+6S
	agloXkdYWMeRppmR6DzzGZVwMzLzylGaTCrOK7wqO6hDiaT9tMIDVL2/I6Nl7lkqplP0Bq
	MZss2z/ZR2Q314KVZP3HRtMBFSTvJ3Q=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a4b8c3a30bso7394356d6.3
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 07:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775053537; x=1775658337; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z0enE4GAHK8hrP3H3mmhLmXee0EMRPHy0H0LDOHahRQ=;
        b=ffu3GeIlHlgldrob/R2vI7VUCMo4ukX2K+J4FjoMdBTp8T21/70gpjkAVtJa8cJBe6
         4g+2IkKwy0llUfL0k/XfabJS72rdVRTWdagX8pKxRdz5MXbAo70jfwptjpD0JgRAwseP
         N4/laxiJFTvq5pdJoFUOKLWxH40pXROzybkSU1UnWwzQl0SwmXNywk8l9PVRwEQxHb3N
         VIsAfpiNHZzegaUFn1jQK+jlabbbNrZYIaL7JmNuSbhaRsNW2+RAmAN6ppCzWe+yfFNs
         U+TIT868TY9KYmqnssiBuuR9mIa6pjx2/Bor4Lmb0g83CLRyFQXbYZazP4ipGGps0Dna
         Lb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775053537; x=1775658337;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z0enE4GAHK8hrP3H3mmhLmXee0EMRPHy0H0LDOHahRQ=;
        b=gy/HbzEJwgbFmnZuhg2oKjuHsHgRbyQd8g6FvPlUMvH7j7uJ3PjZd3CtOpNxcZSbn3
         ypZQxlMYj2D5DNlaOK+jtBqc6tg2sVrEhfbIOU9WB7igKnapKSVFUqBVtde6IfDd8rLS
         bFmKUzcinsm6UJFjuTH1vXGnjQcF4O2sEy0JwOUqQJgnUmO35Cq0kqbSStwNMhgsbttE
         /wXPkawzQMwOXKLxW0EdTkIJENroAKDS7/j8qvFCzdMA72RdwwPBaI/czJSja9eSN8b2
         2aXX2jScqCL6boNp4oADZj2CJgy0Uf8ZYVm2J6jhBnIkiqj0TTSWUKH1uNgIQtdE+8XJ
         5e3g==
X-Forwarded-Encrypted: i=1; AJvYcCU7A5/b1mrXkXMzGHYkmM1ap/8V1Lkiw5rclAJwe7BhzvNHpHA2D43MmKOq067fNhsqzRwNFl+V9A==@kvack.org
X-Gm-Message-State: AOJu0Yz17eaVd3fvU0VF5iEOEzS5yj/WHtKMHJjKmpGxF64uEfYElvaa
	L4qxdJO+iaQKWUFSI9Id2pbx2FGAqLDOVzLadmwtSQoOyVoSW6U2WoUsfkssjiWHChU=
X-Gm-Gg: ATEYQzw/wVf1tvtcKsnkvpdMOY9M9XbZTe2/vNKQfP2HDZcKdX9/gy7qqnjEowFQtd2
	/89gFcezLwc2voRljAdcXM7AOW73bR4kgtcEXFu0x026D3KCjr0rpUx3SWlRzfD8JyPtHg8jqYT
	s1TpTPBhEKmiQgfEsfkuOuVQZK6Zs/TbvrnocJhkZCY6K9/hLsUS6TrumVlJEbs4+UusCvg7Jp0
	boOF22uJoEVyOXH5p7Ez1lvd6uDB2PQV3FIkPXyFDu0dQ3Pns1k3D8N+oTIBT/Y8SqM7cs8NdEq
	UjdXA3SOFaBZMoKOAXrh3TvJQCRytIPmz4OKdz999l9Z5TC1SH/7/45vUJV73Npw9IXmwIEXKWT
	IHXVXs1KdCcW17iXqEPGYO5BhUcfC8uFVVWXRfh//l3Uxbi8nyjhpK99ckA4XCrkonKVnbUUNq6
	Dvq+5xXq8nBsD/6R/FA3kSsw==
X-Received: by 2002:a05:6214:4981:b0:8a0:598e:897a with SMTP id 6a1803df08f44-8a437415ad6mr59972356d6.13.1775053536759;
        Wed, 01 Apr 2026 07:25:36 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecb5cb530sm121185876d6.7.2026.04.01.07.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 07:25:35 -0700 (PDT)
Date: Wed, 1 Apr 2026 10:25:35 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kas@kernel.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac0q37PYB-2DZhLk@cmpxchg.org>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
X-Stat-Signature: 6ax1gfkrzjnf85ryphxoob7a7mcawbsn
X-Rspamd-Queue-Id: 1C3E9100012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775053537-462264
X-HE-Meta: U2FsdGVkX1+pliigJ4gAiON+mrueS+gosuqX3KYsFHoY6rnECl5lyUYds7z2XCGHgUwcnLraGuv6nD7LaOiKOSIeIIF2wzb93FqJXm+ad8lECkqbk8Aej6Pe7KlABhAJZG/FzfHN0lkVkryXI9YbOWv2cUlpppupn3AoWdiwUeToj0Sqfu7s+dcVppfTpcQU83ufxtAHeyE8GckfNqca6vv+Ig8ZhWtu6Yy65wssaOmIZQR9Km31cL5quX5Mzj6ZIL8OPOawMrfQ0hXdZanbnZPYcAuy78S/mz4qTauUgFNA8hHOT9eG5AlmWQ2L7kNo9rmZzGCbtg+EogY854Ufj57Z3OG3PPrDUV+t7ouAePVfImF8lwq1JhONN2L0bURhuGHXVqyaC9AMV1envf3kS1F74OpLx0lEK321yM2PlNC8w4rNUYz15iVRqJWodrL6k03nM/2jj/SZWH5DmDRzJ2/LQAA/fVFr+ZRdnWQ/V8PymhpRxxmEREHyIwZDpprBF0hHskkqTr5o6cNIZWfbUYdkXiJ3rU9qJcOLclTXXxhlfTiSeuN520VxU8h4FzIxoeK/cGG8Hw863XcRu1VmJ07UP1m0i1jBzEKXG1oX1o25e1ox7jr95A+y2Vq+k4eZWmzgLl0f5kyAZgMwGbD1+GTqT9hk5GTWICZcnnjHvKKnF5Yt44D4pEoKVZ5xKf8pKgeFiYzcHYO5P9ZF6//druPtBwxt7ZxLN83i9mEiHq3vPtMxIOPUGC00EMZ2eAs2dpw+OHbkQCOHmgd28/sxdXVf654lmXyV5enbYKHUY8HaeADTltWJgOaaBdfT9aVM6MoDC190naZwrz20mdMq+BXU5N0v8FCJHGsIlgYT8OsifqGD+MSiUYybOm6HlyROEKYyNewAhbUoxCyknDEwXDXMyg/9TSeig4hKy1+vu1fhWlIPYC/4QSej2Jnq4+lmuZKj1C6/3J9z2JH4TZW
 6AIxwRNx
 jQiuieGxDyJibPvsaxz/RRFR7tWkQ9mru91dy7cpOgF1hQNRPgEAk8A+fw8nmBcD3XIS4YlmUUQPkgwMtQaoheqqt31+4fW3vWqlIlofY03kCCdCM1MNdA0CyIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 06:57:50AM -0700, Breno Leitao wrote:
> vmstat_update uses round_jiffies_relative() when re-queuing itself,
> which aligns all CPUs' timers to the same second boundary.  When many
> CPUs have pending PCP pages to drain, they all call decay_pcp_high() ->
> free_pcppages_bulk() simultaneously, serializing on zone->lock and
> hitting contention.
> 
> Introduce vmstat_spread_delay() which distributes each CPU's
> vmstat_update evenly across the stat interval instead of aligning them.
> 
> This does not increase the number of timer interrupts — each CPU still
> fires once per interval. The timers are simply staggered rather than
> aligned. Additionally, vmstat_work is DEFERRABLE_WORK, so it does not
> wake idle CPUs regardless of scheduling; the spread only affects CPUs
> that are already active
> 
> `perf lock contention` shows 7.5x reduction in zone->lock contention
> (872 -> 117 contentions, 199ms -> 81ms total wait) on a 72-CPU aarch64
> system under memory pressure.
> 
> Tested on a 72-CPU aarch64 system using stress-ng --vm to generate
> memory allocation bursts.  Lock contention was measured with:
> 
>   perf lock contention -a -b -S free_pcppages_bulk
> 
> Results with KASAN enabled:
> 
>   free_pcppages_bulk contention (KASAN):
>   +--------------+----------+----------+
>   | Metric       | No fix   | With fix |
>   +--------------+----------+----------+
>   | Contentions  |      872 |      117 |
>   | Total wait   | 199.43ms | 80.76ms  |
>   | Max wait     |   4.19ms | 35.76ms  |
>   +--------------+----------+----------+
> 
> Results without KASAN:
> 
>   free_pcppages_bulk contention (no KASAN):
>   +--------------+----------+----------+
>   | Metric       | No fix   | With fix |
>   +--------------+----------+----------+
>   | Contentions  |      240 |      133 |
>   | Total wait   |  34.01ms | 24.61ms  |
>   | Max wait     |   965us  |  1.35ms  |
>   +--------------+----------+----------+
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Nice!

> ---
>  mm/vmstat.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 2370c6fb1fcd..2e94bd765606 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2032,6 +2032,29 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
>  }
>  #endif /* CONFIG_PROC_FS */
>  
> +/*
> + * Return a per-cpu delay that spreads vmstat_update work across the stat
> + * interval.  Without this, round_jiffies_relative() aligns every CPU's
> + * timer to the same second boundary, causing a thundering-herd on
> + * zone->lock when multiple CPUs drain PCP pages simultaneously via
> + * decay_pcp_high() -> free_pcppages_bulk().
> + */
> +static unsigned long vmstat_spread_delay(void)
> +{
> +	unsigned long interval = sysctl_stat_interval;
> +	unsigned int nr_cpus = num_online_cpus();
> +
> +	if (nr_cpus <= 1)
> +		return round_jiffies_relative(interval);
> +
> +	/*
> +	 * Spread per-cpu vmstat work evenly across the interval.  Don't
> +	 * use round_jiffies_relative() here -- it would snap every CPU
> +	 * back to the same second boundary, defeating the spread.
> +	 */
> +	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;

smp_processor_id() <= nr_cpus, so

	return interval + interval*cpu/nr_cpus

should be equivalent, no?

Other than that,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

