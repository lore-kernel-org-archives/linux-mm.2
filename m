Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A43CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1F46B00B0; Mon, 22 Jun 2026 06:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151416B00B2; Mon, 22 Jun 2026 06:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F6E6B00B3; Mon, 22 Jun 2026 06:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4B9D6B00B0
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:04:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54E4F1C5742
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:04:10 +0000 (UTC)
X-FDA: 84907113060.17.A478128
Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2B287120005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:04:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122648;
	b=jotwA1nzaBxF1ft3LoVzHiefbbo+Su/Js3VNfU1rYGxXvscPQT1en1LBjvPkIla850r1p+
	zV5HyiNxcX4YYm8S51YGgO0Cb6vM/Z9vWhZG+G1ewM5ZjZXp3JqKsQslzcv8uU6ujkE53k
	nKJB3n+ex2XbRr2uQ48NlPn9gbNjR1Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O6zbUsJPwY31MYZqbiboPmNakd9AN0ZgAQ8puffnPl4=;
	b=1TlB895SU5QcXzC6KJADaGBvbBf7IpPq+qOdL+COX+YIGwiilxS9iqZtCPBMRmf7+uqr1S
	yjTEhJNZd+Doi2dSJZRKULyNWJY4c8nr6kE7Y9QD3To/WMiW5Hg0+AjIuGdaeKD3c1Pj17
	1Ijbg05kHXP7BSIsdArcakCLRfvcevk=
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.53 with ESMTP; 22 Jun 2026 19:04:03 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.154)
	by 156.147.1.127 with ESMTP; 22 Jun 2026 19:04:03 +0900
X-Original-SENDERIP: 10.177.112.154
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 22 Jun 2026 19:04:03 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, yosry@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v4 0/5] mm/zswap: Implement per-cgroup proactive writeback
Message-ID: <ajkIkyajJEW2b7/0@yjaykim-PowerEdge-T330>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <CAAAF57B-7DE9-45EA-8AB6-DE6CFAF60F47@linux.dev>
 <26a034b3-9cfa-e4f5-eea1-e69fbfff02b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26a034b3-9cfa-e4f5-eea1-e69fbfff02b4@gmail.com>
X-Stat-Signature: xo59jdmzqgxgkz1r89xe7xdygmw47ou7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2B287120005
X-HE-Tag: 1782122646-965178
X-HE-Meta: U2FsdGVkX18CqwwVgGos+xwut1cl1NCQOmilqVK0vrrQ976htFQsDD0LktdV9e54DRlDVp/7d7C0Ye873J5P9bbaK89oxkPKwZoMOOEsRLsdmFpEwhO6uErF5lzQcrdMDWcfzbcTsDc+o/0J77vMgs4+C+iFuSPpc/n1DfqB62m95g39eYd2iOPbDTk2HENofOz5vYcVi9THZg5qJi/TQP/GdAX63ciHHUxmgjSlhZAv4gCIfjYUeIZYw79/p2EHiGNHuhfTfTktKydolfsUHMyVLMRKoaEf+HrhtET/R3lAE3yXCwJlEhpmwn45kYR6SKA9bJzKoTrbVvRItL9oFJE0PmoLMuEU44AUc+h4oQuubh+1trJtN3dK3nUGz193sVyvFXpBFpmQ+E3QwLYIvyJ6PFUprjFCVfLHRyVSVm1T8l/7HBAASESdkZkqfKS7n7J3yAVTrNuRf0cvSYm0+tphHaTxIuQXL5SOKu0ZeBkj1PpM1qxRipe8Dn+Kb/v1swMgg3Yma97yj6C5lSQT+1itiMz40vQeHJFQP6cXvHHlM9NL9yWI6yRgC83uIJ/6mNShoMgm05EYPoQlGDrwkzKBsRtkufY0eb1/XU0hc188Hx7kWz9J0FGnR4+qKRouCwzIL0DCiWl6qTc+HMo8RGGKNxH5Amvz/SOWBDtpBCjcimbm7MAX63AmpEndGlHOFr6buKnQfQEs1xn/W2SiACasjkjhp7hg/GOE8Oc6P7oLP+V/Opm6lT3K8t2h+uyMlH0HwrbpF8IYMzBQQe3MRbz+xZehcfmyqbpmkQ5SMq3PxxYozyb6Ebho5Zny9eldF7bYmBYcrjIcBmVxRFh0d8eqL0EWBVt4I/DJXtO5vI9xA6ar92LX5gqW9zZF9b7v6oz69PKBfh7shBl1gbQzvef0ND8rxzKSTpjTG48lovm7jMxCLmN0meOPYbUnLCbh25MnyMrDBOadLAS1vxN
 3yU+l+Od
 jjHL1zV/Idx8prK0VP8JSGxUkyjCv12afaF7UZzLbAAVPfOK9GEIQnKjIhpD9VoWF3/AfKoplpU/v+wWoq7FILLoZQODol0AO38kWq5pgeW1XCJo2JUNoc671rkNXw1yVThblAv+a7kKCOmXrJQn0fAz5pX4UQSrupSLbC0KQr/YL+z0T0vUxeaYFE40e39YIdfQtkYJyP60BTRytqb+gKnpYiVz0YL3trlD5L8KP3WSy7VC4dMzMn0d0+ab3hoOTwYJms65w1JtUkZRL4E6yK/p4cF8VD+HXXipGum30zFLWTUX7cRcSP4R/5Hzgt2LipdUxBCekiKpCN5p6csL6OMEMqJHjZ+eoikkwftXYoPYjJIk/OTjWLg4rUVQwD4xiGh/4aq2rpNC/Cho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 02:08:49PM +0800, Hao Jia wrote:
> 
> 
> On 2026/6/21 12:20, Muchun Song wrote:
> > 
> > 
> > > On Jun 18, 2026, at 12:48, Hao Jia <jiahao.kernel@gmail.com> wrote:
> > > 
> > > From: Hao Jia <jiahao1@lixiang.com>
> > > 
> > > Zswap currently writes back pages to backing swap reactively, triggered
> > > either by the shrinker or by the pool reaching its size limit. Although
> > > proactive memory reclaim can automatically write back a portion of zswap
> > > pages via the shrinker, it cannot explicitly control the amount of
> > > writeback for a specific memory cgroup. Moreover, proactive memory reclaim
> > > may not always be triggered during a steady state.
> > > 
> > > In certain scenarios, it is desirable to trigger writeback in advance to
> > > free up memory. For example, users may want to prepare for an upcoming
> > > memory-intensive workload by flushing cold memory to the backing storage
> > > when the system is relatively idle.
> > > 
> > > This patch series introduces a "zswap_writeback_only" key to memory.reclaim
> > > cgroup interface, allowing users to proactively write back cold compressed
> > > data from zswap to the backing swap device. When specified, this key
> > > bypasses standard memory reclaim and exclusively performs proactive zswap
> > > writeback up to the requested budget. If omitted, the default reclaim
> > > behavior remains unchanged.
> > > 
> > > Example usage:
> > >   # Write back 10MB of compressed data from zswap to the backing swap
> > >   echo "10M zswap_writeback_only" > memory.reclaim
> > 
> > I’m not entirely sure if other candidate names were already brought up
> > in previous discussions, so my apologies if I'm repeating something here!
> > I do think expanding memory.reclaim is a great approach. That said, I
> > was wondering if we could make the interface a bit more concise while
> > keeping it flexible for future extensions.
> > 
> > Essentially, what we want is to control the specific targets of the reclaim
> > process—such as file, anon, or zswap. What do you think about using
> > something like "source=zswap"? For instance, if we want to reclaim 10M from
> > zswap, the command would look like this:
> > 
> > 	echo "10M source=zswap" > memory.reclaim
> > 
> 
> Thanks for the suggestion. TBH, I personally think your approach makes more
> sense than "zswap_writeback_only".

> Hi YoungJun and Yosry,
> 
> I am not sure if this suggestion from Muchun could decouple zswap proactive
> writeback from the swap tiers, or make it easier to migrate to swap tiers in
> the future:
> 
>     echo "10M source=zswap" > memory.reclaim
> For now, we only specify the source. Later on, the swap tiers feature could
> extend this to control whether to demote to SSD swap, HDD swap, or other
> tiers.
> 
> Thanks,
> Hao

Hi Hao!

I also preferred sharing the `memory.reclaim` interface in the future swap demotion,
since it already takes `zswap_writeback_only`.
https://lore.kernel.org/all/aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330/

Alternatively, we could use a separate interface as Yosry suggested
(e.g. 'swap.tiers.demote'?).

But as Nhat pointed out, allowing user-triggered demotion from the swap tier
perspective could lead to issues like LRU inversion. We probably need to
discuss whether this kind of user-triggered tier demotion will actually be
supported at all.
https://lore.kernel.org/linux-mm/CAKEwX=NfSy0XiD_UMsDOHGCwpE7sYmBmhV4Y9vk_cbnnr6J6PQ@mail.gmail.com/

So, IMHO..

1. If swap tier demotion is NOT exposed.

We can simply choose between "source=" and `zswap_writeback_only` based
on preference. (since there is no need to consider "swap_tier" demotion.)

However, "source=" seems to offer better extensibility if it is expanded
to file and anon use cases in the future.

2. If swap tier demotion IS exposed.
We need to consider integration vs decoupling.

(In my view, This is a design consideration. avoiding potentially
redundant interfaces vs adding a new one if it is architecturally correct.)

2.1 Integration
 - Integrating into 'memory.reclaim':
  - "source=": Seems easier to integrate by explicitly specifying the target. (Your suggestion)
  - 'zswap_writeback_only': Harder to integrate than "source=".

 - Integrating into 'memory.swap.tiers.demote'
  - 'memory.swap.tiers.demote' could absorb the memory.reclaim functionality.
  (But since we only want to allow tiering for vswap+zswap cases like
  the zswap writeback feature as we discussed, the reclaim interface behavior might
  still need to stay for zswap only.)

2.2 Decoupling
 - 'memory.swap.tiers.demote' handles other swap devices (excluding zswap),
while "source=" or 'zswap_writeback_only' handles only zswap.

I think future discussions might lean toward "integrating into
'memory.swap.tiers.demote'". Therefore, from this perspective, either
direction seems fine. However, I slightly prefer "source=" due to its
potential for other extensions.

I don't have a strong preference, though!

Thanks
Youngjun
> If we only want to reclaim 10M from file pages, we could easily extend the
> syntax:
> 
> 	echo "10M source=file" > memory.reclaim
> 
> And of course, we could even combine them down the road:
> 
> 	echo "10M source=anon,file" > memory.reclaim
> 
> to only reclaim anon and file but bypass zswap.
> 
> Just some thoughts of mine.

