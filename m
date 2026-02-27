Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EFBBFD9E29
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 02:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60D86B0005; Thu, 26 Feb 2026 21:15:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E536B0088; Thu, 26 Feb 2026 21:15:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0D7C6B0089; Thu, 26 Feb 2026 21:15:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A55C76B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:15:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBF215051D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:15:23 +0000 (UTC)
X-FDA: 84488619726.18.395488C
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4EF08A000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:15:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WDaw2lOs;
	spf=pass (imf15.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772158521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o98TDglwcJHUCopNU0gmCCHTHd1XGXRq3ZF2Z1HVahI=;
	b=p+VO8wqIndIRGodI20uzYo4/xU7AZwtBOp9uyt/LMKTVTyB9wSBuSDBGVzPv7c9WHHHaY5
	aB07y2E2QrjJH12B/igq/mjHk9doC7RoM3Grd37umR7xAAEmKMS8UQE+lij9dEgF0vaw8r
	xyN/matEoKMZjk/n6UrBwPPkrluLzN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772158521; a=rsa-sha256;
	cv=none;
	b=QPgI9OP29eVtZ+biCN/VU1GjBZbj1rcsL9Yzz0cLoaqcLf/Swn9UTBT4ETWbAbjbM6bIw4
	ERpixavH9nJZtIDnYkXsHjGcAdMWahFYBAY9ayRq6TWxb6hJ5VEqIRd8K/bRWzbt+NVmQ+
	Ai3Xbi+M71+GSK/s+sjHsn/hTfNIjvY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WDaw2lOs;
	spf=pass (imf15.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 27 Feb 2026 10:15:09 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772158518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o98TDglwcJHUCopNU0gmCCHTHd1XGXRq3ZF2Z1HVahI=;
	b=WDaw2lOsrL6h26ZT7I+BsHLM+jiG0hoIZt9f7HOv8nbeRTugqRp/lG5l7WPnFs8cUmXXTq
	Bz5g/YDzmoltalVq6BEWUzVOb0M2w166rDecbLcL3a6GSMT+VhPoyvL5AlHRK9wG4Tni5/
	cCgC6tOnv6McXYXMjpv+ivWhrYFcqIM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>, mhocko@kernel.org, 
	hannes@cmpxchg.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org, 
	chunguang.xu@shopee.com
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when
 reclaim was boosted
Message-ID: <6sx72x4eulir6hxacg7wlxpprv4hwszsvqsmz2qst2gjgd5s25@47sizxwwyrzh>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
 <e5bdgvhyr6ainrwyfybt6szu23ucnsvlgn4pv2xdzikr4p3ka4@hyyhkudfcorw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5bdgvhyr6ainrwyfybt6szu23ucnsvlgn4pv2xdzikr4p3ka4@hyyhkudfcorw>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4EF08A000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: i79cohz13u6achrodwc4mrzwqdxp7o3p
X-HE-Tag: 1772158521-184445
X-HE-Meta: U2FsdGVkX19ulb9NHYPzpQLNKyknWkPlTpGnD80pCNfHrsyUkurP2LVFPlXA6PXKNBqw10pZ/g88JT65iR13xi8/5jcuSxTBQfnMNpZLmu2dMXqBPTEm24+b8mcgBjUaXw6TSqadGDFXbrQ9D2KSDRYvCEI1nbi7CIPJ0SJlCIoj3fmvUzc41krabagygZMBucNvgtTNc6DVFpQbWWYHHce7SnkECNlGsTGUwU+8lqXj2sauQ66evFU5EMnKZQvQv/8EeC2iajeCBWexOpTTXdxKS+H4XlAVXGUzDJF8BUMD0TPS+P/SV/oAf7Jl/nqNXp43p1/ut7COe5yFfqCR7lUXgljGKXKZ8akCSH1qREl/+XvAldImp1U4H7cYaZ5FFNGKWfN9jBKOSNjHcEHDMz06KbdwUOwPDDQgcib01xHTNCruuZRz+PFch6/npaXL3t1odg/DOC+6XAmP+jKpaGA+nSz4fd9DDRW44IcTZI/B8KECfHysXMm83OpwG0sqOZ5iQIpj5nSCPcSIk+YuBpOUS007PM8z33hZ21zuKDfsr5bS43oEUDHKileX3A9nNPIGJKmq1xBYeScWLp4Jud1qDoNKOFKSA+3Nv9c7sMCa77RtDDeqrkH1upXvThIuhn8Z/ZYan3ANnxIe03Tu0dXzNWM3o1cNM1To7MQNAUBYaBYc/7eZcTS3L3aPvVvTDinHiKtcUGMvwZSZWS/OugPkT0CFODxjz4Oa5gKGN67mrqjvrHDHZunWGI8W8PL8apYkppd4yex6+r+B2CPZ/qFFmiWZQA0/H9mXimd3Hf3ToCkSlvsTD9qF5dAzgScLGPMpd8Y6usfSfmTvSVXhZK1s7K05RO3raRt3aJJFI511HO4H+oqp6y6A+jQN1hN6hLR3gXS/9WC/0s/zRcKN+5Mw+PC90zWrAq6c+TyDlp4O8eB0nLXDnEl77MAOTBtaS03hm5B9yJxpgXhHmSj
 dGahXw/i
 nXDYg9dhPP/y4GiBQJBDuaYRr/WnCiH4r73oDVETO7vIpIrqBb8fun8KqDClW5ksRlRfkSfnpv58ha3+hFS3k/KuqsEtItSOwTJRMSAqanHFeukKbnmUhrFzK764++k8YZrNvbn/ek1wb5wmhvg7niIHOHjzwfmpQWgYu6KgtwYz4/jTF10x0NzTHNk7ckW/2w7xqGqZ1qG2uMkF1sRVWjqozPP9/FpEZU3j1HmR5POC7IsrPv2OsKhwnINF2KKPFV9m8kWKpzWUa05iFdV50nDo7BStXroFBZDUBr/P4XGWcy9ucKcyxD+HuKj5/W5sHXNl5zqTaSRUfFFpIuVIcmu5B0e3Zxl3WwSXDRGITHILKF+h0mQ15oP8G6JvAJILMKmUW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 05:11:58PM +0800, Shakeel Butt wrote:
> On Fri, Oct 24, 2025 at 10:27:11AM +0800, Jiayuan Chen wrote:
> > We encountered a scenario where direct memory reclaim was triggered,
> > leading to increased system latency:
> > 
> > 1. The memory.low values set on host pods are actually quite large, some
> >    pods are set to 10GB, others to 20GB, etc.
> > 2. Since most pods have memory protection configured, each time kswapd is
> >    woken up, if a pod's memory usage hasn't exceeded its own memory.low,
> >    its memory won't be reclaimed.
> 
> Can you share the numa configuration of your system? How many nodes are
> there?
> 
> > 3. When applications start up, rapidly consume memory, or experience
> >    network traffic bursts, the kernel reaches steal_suitable_fallback(),
> >    which sets watermark_boost and subsequently wakes kswapd.
> > 4. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
> >    triggered by watermark_boost, the maximum priority is 10. Higher
> >    priority values mean less aggressive LRU scanning, which can result in
> >    no pages being reclaimed during a single scan cycle:
> > 
> > if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
> >     raise_priority = false;
> 
> Am I understanding this correctly that watermark boost increase the
> chances of this issue but it can still happen?
> 
> > 
> > 5. This eventually causes pgdat->kswapd_failures to continuously
> >    accumulate, exceeding MAX_RECLAIM_RETRIES, and consequently kswapd stops
> >    working. At this point, the system's available memory is still
> >    significantly above the high watermark — it's inappropriate for kswapd
> >    to stop under these conditions.
> > 
> > The final observable issue is that a brief period of rapid memory
> > allocation causes kswapd to stop running, ultimately triggering direct
> > reclaim and making the applications unresponsive.
> > 
> > Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> > 
> > ---
> > v1 -> v2: Do not modify memory.low handling
> > https://lore.kernel.org/linux-mm/20251014081850.65379-1-jiayuan.chen@linux.dev/
> > ---
> >  mm/vmscan.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 92f4ca99b73c..fa8663781086 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -7128,7 +7128,12 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
> >  		goto restart;
> >  	}
> >  
> > -	if (!sc.nr_reclaimed)
> > +	/*
> > +	 * If the reclaim was boosted, we might still be far from the
> > +	 * watermark_high at this point. We need to avoid increasing the
> > +	 * failure count to prevent the kswapd thread from stopping.
> > +	 */
> > +	if (!sc.nr_reclaimed && !boosted)
> >  		atomic_inc(&pgdat->kswapd_failures);
> 
> In general I think not incrementing the failure for boosted kswapd
> iteration is right. If this issue (high protection causing kswap
> failures) happen on non-boosted case, I am not sure what should be right
> behavior i.e. allocators doing direct reclaim potentially below low
> protection or allowing kswapd to reclaim below low. For min, it is very
> clear that direct reclaimer has to reclaim as they may have to trigger
> oom-kill. For low protection, I am not sure.





Hi all,

Sorry to bring this up late, but I've been thinking about a potential
corner case with this patch and would appreciate some input.

Since steal_suitable_fallback() triggers boost_watermark() whenever
pages are stolen across migrate types, and this patch prevents
kswapd_failures from incrementing during boosted reclaim, I'm wondering
if there's a theoretical scenario where kswapd could end up running
continuously.

For example, if UNMOVABLE and MOVABLE allocations are competing for
memory over a sustained period, the repeated cross-migratetype stealing
would keep boosting watermarks and waking kswapd. If kswapd can't
actually reclaim anything in this situation, it would never hit
MAX_RECLAIM_RETRIES and just keep spinning.

Two questions:

1. Has anyone seen this kind of sustained migratetype stealing in
practice? I'm not sure how realistic this scenario is.


2. If it does happen, waking kswapd for boost reclaim itself makes
total sense - reclaiming order-0 pages to reduce fragmentation is
the right thing to do. But a busy-looping kswapd that can't
actually reclaim anything would still burn CPU cycles, and keep
grabbing lruvec->lru_lock and zone->lock on every pass through
shrink_node(), which could hurt page fault and allocation latency
for other threads. Would it be worth adding some backoff mechanism
for boosted reclaim failures?

Just want to understand if this is something worth worrying about
or purely theoretical.

Thanks,

