Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FFF1107638D
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E8C6B0005; Wed,  1 Apr 2026 13:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6287F6B0088; Wed,  1 Apr 2026 13:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFBC6B0089; Wed,  1 Apr 2026 13:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 391F86B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:46:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 721C3160145
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:46:43 +0000 (UTC)
X-FDA: 84610717086.06.1E9195D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7C1AE40009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:46:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t4+8YjAY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775065601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilvAZvX6c8awgrEddN/eAnjZjT2zGT0xUPSsgoIUxtw=;
	b=GJTUG/OuzCq2nlV2k2sb6MEZ1sibOdebufG/J7Bkh7Ab7kJukFFLrlzabnwQGfKXhJE171
	CGyfRzXfQgsmD+nErdJZGbW8xQEf6uDhtJRlreduUWIm3z8FNfBtgbY+sbYnaR+s88Sajf
	O2Xe0G3BPXTVqz7pEQICtWZDagXY3ao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775065601; a=rsa-sha256;
	cv=none;
	b=MW5Gu7DrqpYPyoJXhr6CiLrZCfuri1UWFzwNUaeATL29Q7XNCTOeJc+cX2YBOq4pplJFIn
	dXHihbOxvIfzFvLB8yutTtDJ3lkc943+wLNlVliky85tbvo9MZKmc++IN5Le8iD+Rxkldd
	iqTh2ckqZF2fit5uhOZYf01Bo6ZGDMk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t4+8YjAY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FEA0434C0;
	Wed,  1 Apr 2026 17:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6175BC4CEF7;
	Wed,  1 Apr 2026 17:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775065600;
	bh=fohMRa5K9g7ocVeE2BTtOtg64GbOaCSV2v/AyKbYIx0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t4+8YjAYNy57lJHDN6YAsvie1MhYiKifQRrUrzv0aY/Z8Sy2P2I2WuppajvkT+DBT
	 V7hsQrh7uVwJB4VhjhM+pjZ3Mac84DefOTyzV6HBR9ghVshnzRwN9xXcLIr6zDiWqP
	 0JtJc/FAhn8bul6Hx0+DSqWlKXVp0BawzGSdrfyK2gNwlQaJFRIOszsJ2Uglajj77d
	 18B5UwXwc2HLWygT9Wl8X4PPf1GsQsfv/4Qc2eYOKaDNyeZ0Z+Uh3hYfEj2RRrbDKe
	 xb76dPtJgfgXad/1r67uMO+4YTgQzOo7x0aCgfcAaFrOjqFcIG9DyugUAuHluRFhVv
	 zZupFcILz0ZIA==
Message-ID: <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
Date: Wed, 1 Apr 2026 19:46:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org,
 shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C1AE40009
X-Stat-Signature: zcpiykogjbbn8hs8ysqempufa8aspbdk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775065601-221334
X-HE-Meta: U2FsdGVkX19GY26Ad2ulFpbpGKDYoglHHUkn62nUAaR3qgk7AHNih5828MYaCX9Sunokb/gnqa5aSgzvCIgRTtxwm8YfanUe3YNIDdtvUThiWEvSKxpcV2awFZhekmbwPtLJbp2g6MWYHELiJnmlw7WU+Fegs+nnFyAdz9QljngwEsIkNks6GGcgY4RR0mQ9VIaZBEg2o8hYuB8AXaqni8i7IjyggwXwf2Zqzo9+LUNfmQi8SpJ+EoskEvwQVoRw3oMm3gs9QQ068OWeAfEZPU1m87iw7sUczXHxvQfQjAPr1d4FlY5fI5lxIid3ZyJS7YRX9CqxfAAV7gxLG1I7DE6jrVG5guDZf8QGhiVvByv/IxbAK2YhNwxnMw1ad0q6H7sSK+v8tXbcW9ip8SWvtbMrqr9+gMrrVEA1/m8k7r5jgKeX/DF1gHpaO7mlVhnfhW8McZkI1yzUT8IEoOIBlTOiWcHs0hOFITSNocgWjTt8UOv8vdTafs0b7rH5ou4unWmJQ0kzXE3D1Vm+V8UBwzge9ZxUBMy7cuSR4bULMoZnngs/wsjv5bebUI+s7k1B4h5CBZYNEBVmqJKxpWGdiuzVpWIQy9iec3OPtVzQHQJHv0PNVdexyLbE/ThbGWyvhhtaV//TwPGcDM5q984I2hIFqj3udK4aWaA+FYs+7/ye74AgNqLNzTi2KEItZaI6go9M3fuO0tGlKpAhxlx1Q4JCM6ec56Pvq2GmrJTMYyI8fTtgjz2WQo2UDJew3a30tzcG+9fUsJAG263+xXj62Yo6maHJdRGLSG2rs1AERDnaKofTnjJzJGQRjR9qwEnPt1ZX5PTxZinjdQJsVGFcPBkWBp6Gj1MPKVec5eTKwdr0rju1e5xfB5wPqMDif6wSWSY5LVX2mDcfpZcRcTsrunPKeKwejJBr64GLqO5ADdxhxsjKuySvlz5C0LolCOfSn8eu3fBdhjzen7STDhF
 VesMHXpF
 FQxy7M13x18iBq80RTwOUzzmPOSBRsq7cMtVDnnFSK1MIZnjX1yvbDF2iFoArYEmKRFzv8FvaSI5aN+6ShA1pSFZOB/A/kdlg2W/vkMVBUpyPKLvWStn5vxXK44m1i9HXGdAGaltCamPGiaSHY/7sRzVwjNhElxn3njxXO1fbNk9tmvy7OYGw0MAV9h8qIKov1TU7L3vlYcnHgekXn3YpJ3JmP1pvlAsAPv/WOY0wjxTZEM6lgsOMZ5onwbr8hHY1yJz7tdsLuVzSAs2mBNxfOWgdj9zp24Vdsf0/XvbziMf6R+YIgyC8A8ls1FdbTZ3u6GTP6smbwCtLqxy2scx/PWDy3OEPKUSImIm+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 15:57, Breno Leitao wrote:
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

Cool!

I noticed __round_jiffies_relative() exists and the description looks like
it's meant for exactly this use case?

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

Hm doesn't this mean that lower id cpus will consistently fire in shorter
intervals and higher id in longer intervals? What we want is same interval
but differently offset, no?

> +}
> +
>  static void vmstat_update(struct work_struct *w)
>  {
>  	if (refresh_cpu_vm_stats(true)) {
> @@ -2042,7 +2065,7 @@ static void vmstat_update(struct work_struct *w)
>  		 */
>  		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
>  				this_cpu_ptr(&vmstat_work),
> -				round_jiffies_relative(sysctl_stat_interval));
> +				vmstat_spread_delay());
>  	}
>  }
>  
> 
> ---
> base-commit: cf7c3c02fdd0dfccf4d6611714273dcb538af2cb
> change-id: 20260401-vmstat-048e0feaf344
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 


