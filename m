Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F9BC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 15:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC7A6B0088; Fri, 28 Aug 2026 11:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CCE6B008A; Fri, 28 Aug 2026 11:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5EE6B008C; Fri, 28 Aug 2026 11:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 080386B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:41:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83E3D1A03EB
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:41:09 +0000 (UTC)
X-FDA: 85151091858.20.9480F40
Received: from mta1.migadu.com (out-196.mta1.migadu.com [95.215.58.196])
	by imf24.hostedemail.com (Postfix) with ESMTP id 16DEE180005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:41:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DQkEsqQd;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.196 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787931667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrYAwaJw8UkVpzQYnn/0z7rkiYHVHcJGJQvVzaWfa80=;
	b=I2LLJJf3vZ3jH8zrjGBHi/8bWGNmg0TSOe9nBTME+jIBayjYdP7tZ4sYmE8/PuRj7ZQRRI
	E7QZ7gbYxf5uxJ/YIfsBVvoo9VZPiRHcIgyJUKZEmCOriJXNLfbOZhfziz5GrcS9CFcubg
	fzIel3smZBJqd1zupQHxtSSb7arRGQk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787931667;
	b=vSU2vg8sMMvczjrx45NT/4HaE7+UL1UVKPWNaFaabZ7VWihcLpWhTdr8XQVHy1cZMcJmQ3
	rhkQpJ4zFhRkaEfmxuS3tc8a76OIeutIncwq1GGbUZVcmjfOcPEsm9zbwW1X1YGxgCcKYv
	ZdRZUIj1epgYjshhuKLTMOj5pbzruAI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DQkEsqQd;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.196 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/n/dFd41yw+qx+BtMq6OW0k8OGtbcgNeqCbFA/CFiRE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787931665; v=1; x=1788536465;
 b=DQkEsqQd5vayNizX9figHd6tQSzlQ9exuguxF4XKOvPoRAmUzTV9KlAxX4kiikyUxQZJCnTe
 kHJ7QhLBeGHoVJGZ3MnKAEhXz2t/vBTeAvhgMkMDi0KlBgfMd7DayINMqURAP37vI0SXl1RatrQ
 MhQuRqco50MiJOOqSwqyVF5U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 10b1ae10f3c69f4c;
	Fri, 28 Aug 2026 15:41:05 +0000
X-Mizu-Trace-ID: 10b1ae10f3c69f4c
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 08:41:03 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: avoid stuck FLUSHING_CACHED_CHARGE bit on
 isolated cpus
Message-ID: <apGro0MJ-brPJfoa@linux.dev>
References: <cover.1787890328.git.riel@surriel.com>
 <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>
 <apGaZdxAPH68kkCc@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apGaZdxAPH68kkCc@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 16DEE180005
X-Stat-Signature: zcan9bijsu9pugfkem5h8arwxrzab5cf
X-HE-Tag: 1787931666-33642
X-HE-Meta: U2FsdGVkX1/V4KdZZfVHy3eq4BWOMkkec+KeX+vAaUxZLm8CeqpsGT9v+oj7fcxMbdBQN4n0MsLZNW91Iqs9U1B0NWT49ljUC44AShw0uvNi0kXHMcRlZEF9oXbxNsC3btJCL87VxIy9k3l8CZZ6KhQWHNUX0GHWR0wRQA8JrW4QLH9/J9g7J6aip4EzWpQ4+Ul53JTgXbmgFBmnHB/KB5IAkljWptrPiQnKuyKQWNLgNatA79WKfKMQBUWepMiUggBW43hTguv6hW+WXj04nYWygOCM0gKwEGdqREmVvQ6qt7orBltMIE+AEnONizR17/BhsUS0rqKNLSJJvhllSH5oTKi7nSwNw+yZf0pFWUXssYdbtMj/Qk4xjSDL1/Rn16JAqJCOPpm1NIHrrbS4rxlRX3vQYiKlwKpebtF327kzzrely/F7YMV6SMdcz3AsAJ6XZpv0XA33d822yiZXaujfBexSbT0HtHiAkEFEe4f7cVv/S3phIV6oDhqyBLYp+yD1d6h371nuDTH3x/eDB4FEVY85jZcp2wvZQWvL/6zkdRyYRAnoE7yhMUBRwH7DicmeUY2Gs/+NeduqbPAFEjr2lATLgvWMakRgmSSgLTokd36YPb2dIuLaZqEP/sIDJ4n4N1/IOYuYU6GFnn90TTxJk47Q4DAiGZOdX/mBxtqUPNUC97anOa1+mBZGQ3kRF3rD22wJvyt3b6AwGFTfpvj62DmnjnypzDMDTSvzsne7abqbnOY8PDH2xtoqFPNXWc8pa+VkQ16222VvyteSHu95Nl8596CthGpXawMx+Gjlir+X8bC8Lk1iWC7PbF+W/kGJcMPtch4mgmlkt2UU5zgmAJLOQFPrf8m9LwbIBj3yE7rUVALISJ3Mrdf8PfRwQZRkQG4Ap5YTiWCiVfjYYvca1Wr50X1X+og5IfsT9APNlIU0ZolgOkTBGfJQ/+CFnjQoNmaCruV+lPsMuI/
 2LaSolD1
 zznvkvdhtYJSQdDNoyeW9ycdF/2MizYNxstxgiMvEzW5lWeA1nOhA4Awb/CgU26rAEux+l0hQW/JyIGJmsfR/GUU4kyehRSafaHiUuXtvfLnrB0XRxsRcGHGQPr0Q4Maza9a6am90fs/8hBbwPxAiKaMUYKDAFYtmGzJOiqPpYO4eI7ciL6OldUDGt+nG3HxP4gEDYkgte+Wj343PZ+Z2yK7oiFq4r97eMkpGbg/S+uThLx4Hpw6O0eMNglEc16ILjVXO3idsuqit2PqXsffUCD7XhStSZczLpIdY4pgF+hTsZqLzkjtNhDUqEoyhukf4F+lM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 04:25:41PM +0200, Michal Hocko wrote:
> On Fri 28-08-26 09:46:21, Rik van Riel wrote:
> > drain_all_stock() can leave FLUSHING_CACHED_CHARGE set after the
> > work is dropped.  It sets the bit before checking isolation and
> > schedule_drain_work() checks isolation and queues in a separate RCU
> > critical section, so housekeeping_update()'s synchronize_rcu() can
> > race the second check.
> > 
> > drain_local_stock() only clears the bit for work that ran, so the bit
> > remains set and the stock is never drained again.
> > 
> > Reorganize the drain_all_stock() loop, reducing nesting, splitting
> > out local vs remote cpu handling, and skipping everything on isolated
> > cpus, which solves the stuck FLUSHING_CACHED_CHARGE flag.
> 
> Is there any reason why we cannot simply clear the flag if the work is
> not scheduled?
> ---
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 69b37f63a307..907ac63e5067 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2261,8 +2261,10 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>  	return flush;
>  }
>  
> -static void schedule_drain_work(int cpu, struct work_struct *work)
> +static bool schedule_drain_work(int cpu, struct work_struct *work)
>  {
> +	int ret = false;
> +
>  	/*
>  	 * Protect housekeeping cpumask read and work enqueue together
>  	 * in the same RCU critical section so that later cpuset isolated
> @@ -2270,8 +2272,12 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
>  	 * pending work on newly isolated CPUs.
>  	 */
>  	guard(rcu)();
> -	if (!cpu_is_isolated(cpu))
> -		queue_work_on(cpu, memcg_wq, work);
> +	if (!cpu_is_isolated(cpu)) {
> +		queue_work_on(cpu, memcg_wq, &memcg_st->work);
> +		ret = true;
> +	}
> +
> +	return ret;

Let's go with this patch. We can simplify above by inversing the check:

	if (cpu_is_isolated(cpu))
		return false;
	
	queue_work_on(cpu, memcg_wq, &memcg_st->work);
	return true;

>  }
>  
>  /*
> @@ -2303,8 +2309,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  				      &memcg_st->flags)) {
>  			if (cpu == curcpu)
>  				drain_local_memcg_stock(&memcg_st->work);
> -			else
> -				schedule_drain_work(cpu, &memcg_st->work);
> +			else if (!schedule_drain_work(cpu, &memcg_st->work))
> +				clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags)
>  		}
>  
>  		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
> @@ -2313,8 +2319,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  				      &obj_st->flags)) {
>  			if (cpu == curcpu)
>  				drain_local_obj_stock(&obj_st->work);
> -			else
> -				schedule_drain_work(cpu, &obj_st->work);
> +			else if (!schedule_drain_work(cpu, &obj_st->work))
> +				clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
>  		}
>  	}
>  	migrate_enable();
> -- 
> Michal Hocko
> SUSE Labs

