Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0917C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5FFC6B009F; Mon,  6 Jul 2026 22:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37336B00A0; Mon,  6 Jul 2026 22:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D2F6B00A1; Mon,  6 Jul 2026 22:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1526B009F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:20:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D4168CEEF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:20:55 +0000 (UTC)
X-FDA: 84960377670.16.6CA2658
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7C30E40007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:20:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCEfBuSV;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783390853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xosg6/+k33dLwMJJrHbAyu6uGR9fsXM6wffwFdaii/o=;
	b=yiPPJTqqzQQfO35MfsEUkVwjPaeFQ91JL2+s3OwVC7VYf7mEg3UvK65HpDgT4c0Js0dIsf
	7OZV9WP8ylbHux0/zbSk30seZbMh1FolP+A3j7OH0NTfpnLGt8L4bQOaYAZh2VmIfZ9ip+
	u0xGFuFATXQ2Np9uYIR2xi2sPLNip/s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCEfBuSV;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783390853;
	b=JJaizWGRbT0n3p1/WqoXubsGaDPByz6/cmcpq7Fppa/WFIsh1PKwiq7MbA0eDNp9sC+3VT
	7RvGnIOFaJjm2IPgYuQRf/q/KAWUAnFRvxHqQLBQmuPhBoPOZV3H7XDmcJonfig7p2ReKf
	/54myAoPreDt808hIyDNwUUb/1kzzuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E3E79600AA;
	Tue,  7 Jul 2026 02:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE951F000E9;
	Tue,  7 Jul 2026 02:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783390852;
	bh=xosg6/+k33dLwMJJrHbAyu6uGR9fsXM6wffwFdaii/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KCEfBuSVz6P2oEpTaJQx86SF3LRLHMwOshO+F40I464fgDrvexALO5NQAwULi5JXH
	 aLJ7IZFVochK86XKQ089uoU0xYNjydNNkhjlMEHMtfMo3LelDYe3+W4OqJniPzlZAl
	 1jK161ZjiMXJAX1RI06XVtJlQIvO16HwJdBuPxbRfgC2cWd5SRxQ7o37dGJtVHJQVk
	 CTir5t2JUcbRRN8a97DIZ8l662PGISd6NLgKCP81i/efEPz1/L+NLpoa5SDZZ4ARSx
	 OK/bhx6THWL4pzH0c9UuYw39G0//W8lzibYSCNgzqkp83tIZ+ozOzo+W/0X8AAUOYg
	 YOoicMKgwdyDw==
Date: Tue, 7 Jul 2026 02:20:50 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
Message-ID: <akxiZryteM-mwlyz@google.com>
References: <20260706081218.3438762-1-richardycc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260706081218.3438762-1-richardycc@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C30E40007
X-Stat-Signature: dytwx64n34z8p3578qb7ai8gxjfkyj6w
X-HE-Tag: 1783390853-157887
X-HE-Meta: U2FsdGVkX18Jr1NecmvZbAVTfDBue5giiWGQzsToKUue/phC9h3L2Xz/JmSi9Go86Ibcl1ckGQVT9ar5jkBU2lN/hCRlUzIPUtXBkgcgty+fdB3pSc7Lpt1hvBc0cnI+nK4I14JYZz9/UaWRKaMzF271GNrXOEFRnYC+00dk1C/mqMP/lW5KxdAXTlPJk5CkricolZLyljnegMIuP3wqfZZ+OVknwiprFqIh7AsSCO85GN/34/fnRzon+IfZMnZi8jfw7qrtGrD4O2b76Ivu2xSIhHEGZaiUUwAZN6Js1ax6N2poQMcfFTQd4gf90yniRP4gmS+HtpYuk/auLBjuzvN6NveofcNOMrc3MslB6119n0ce3JCvR4sfLipVsY4eQ0ZlzjlD1AkRhR8LJY1ymVpN6zl/tK9Sx+tYz4siPQ2V4QG0raK23g98Ybg29uqnUHegJ2qlXT3ufkrD980+C85xnH9oVhZD5yDwPU4bbp6bR2ySYGJuxOLw+X2o1s7KYSlMJMtuXxg94sOdM89cRRr0yBGbSzF1E+/RISaq7winWH5X8EyFDabrnYal4YwpkyTeaG7srswjRGWURtGeNVJUJmsllKLz589EnIyLVRUml34icUaPVpxPaAiADyKdE1Zgjes+PiL7OhKo7s45gQTuecmw/vDevwIub8lhdGBIbh9e41M2x0y2Obq6wB8sYFJYiVGNXEWOI7wMpJHLf9NusJsh0V5dhrUt1dCpg4YyavzALW0BmtrOzkCxTZGmj9teAEVo4ekx+W50rEWSkF4phdnOTBrXHZvcEKV9LIR3yP1ovbApB9e3s4Yld2DLlZIjup7e+6N2XDGfvUreNYFdPQm0tvBxQD4gHFL0Uv48la5jpMT+5CK8KDwGY2wA8rTm8oahXcwiJ97jlDmRGS5l96EKDIGrd7rZhYVFrkyUD6KtICkTD41oixXwjg4+MFic7XiXWYq0pAjHDcc
 HC4ze/Ec
 UhnhTzcd/QXoVZWBotO1vc7SKbz8Y6EnTYolDS3Q1us704S9VdL2fHHmp2INqZAahn4LRy57XZ+WhPrLlG5obn231Tlh+J/K5gHzGO9bhxMTwG5clq+ySqESI15Z1bY4/FimaxWzjB6rPniPCxYh3y1pEOfOlGeXApUWZ2/vZq3a5SpYJNf2X7HQAd0ACOa0UE9y83tmKPkA9iytF/9hQKhEx1+w97aCFbyZd45+6oWUtyGzfQ2MVvTveNNGYu7hykrHS5nwSKakRd0y5NZoJd+XkAsYuJrugmXQ0GT71Le+NRmzSTAPvTdfSHWf5M500Et7il1MZhmwhchRhVoAe0kBvcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 08:12:18AM +0000, Richard Chang wrote:
> Proactive reclaim (via memory.reclaim or node reclaim) checks for pending
> signals in its outer loop in user_proactive_reclaim(). However, the inner
> reclaim loops—scanning cgroups in shrink_many() and evicting folios in
> try_to_shrink_lruvec() can run for a long time before returning to the
> outer loop, especially on systems with many cgroups or large memory sizes.
> 
> This latency in responding to signals can block the freezer (both cgroup
> freezer and system suspend), leading to freezer timeouts. This issue was
> specifically observed on Android when attempting to freeze background
> cgroups while proactive reclaim was active.
> 
> Add a signal_pending() check to should_abort_scan() for proactive reclaim
> paths. Since should_abort_scan() is called within the inner scanning and
> eviction loops, this allows proactive reclaim to abort early and return to
> the outer loop, ensuring the task can enter the refrigerator in a timely
> manner.

Do we still need the check in the outer loop?

> 
> This check is limited to proactive reclaim (sc->proactive) to avoid
> affecting reactive reclaim paths, and wrapped in unlikely() as it is a
> slow path.
> 
> Signed-off-by: Richard Chang <richardycc@google.com>
> ---
>  mm/vmscan.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..fb472e924fc7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4929,6 +4929,9 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  	int i;
>  	enum zone_watermarks mark;
>  
> +	if (unlikely(sc->proactive && signal_pending(current)))
> +		return true;
> +
>  	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
>  		return true;
>  
> -- 
> 2.55.0.rc2.803.g1fd1e6609c-goog
> 
> 

