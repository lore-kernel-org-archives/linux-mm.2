Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00449F9D0F1
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C966B0088; Tue, 14 Apr 2026 16:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4048F6B0089; Tue, 14 Apr 2026 16:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31A3C6B0092; Tue, 14 Apr 2026 16:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1ADEC6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:26:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD571E33AC
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:26:36 +0000 (UTC)
X-FDA: 84658294392.29.53ED659
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id E7DF040014
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:26:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oV5qApRi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776198395; a=rsa-sha256;
	cv=none;
	b=5zHxrKE/Pc0eyeYj6oF/bk4qE56mzaLMnqURXZcSUHaHtbD+83qLsNMf2Eq5UcWzDMM1bZ
	e75va0YPmSVtMkIdGqYJYa5nVJpKclewaEwFq96B19qyyxdJ2yGqYhEQr1UW/4v8T/DsO4
	Sdd0Mcl27B36Sfy8DxmmtzJRe6rEJS8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oV5qApRi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776198395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/UR4m3dl9VK+BroM75Hxq4WeXIJgGbxy3Rl4ETefDxA=;
	b=gkMo6YdTdsf1K0jjzAWIMk/IkNTrKAKnziHCACzfUMFo6Vj0/3ney4nEDXfGOe16xSKfWU
	wC1ii5SMUyHxw3BK2xj4Zw1C6kW24v8vEsICijync4Y6TjoQS6/H/uZMr10gQI0x5aTiSh
	cJyOFQQHe/oN3CGX3y6kabMvoDdFDKU=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-47938ef848cso1393008b6e.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776198394; x=1776803194; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/UR4m3dl9VK+BroM75Hxq4WeXIJgGbxy3Rl4ETefDxA=;
        b=oV5qApRif0higXCTKjgf3lL0fDsdVvILxmvydSYwfbrLCawXruIpEinJ1J6CANnfqj
         tOzsIGEhwfzuTIiQHXNAAFDQwXKoRNuOgleiB0QlydgiR1ZiXqtsIWdBRbbHtAtqEKl6
         sSARHcL+beFRzx3DCa5/RDPIIB1pAa+8o8WD7glShWVjHtGGl5Yfcsa0MCvWRvE48Ugl
         3QJtVHr2eh+pU9t+aEq9qBak3dcrH4qSs0m/dYKJ7nI8vpWbTcMbZd1YVakdpwt+I/Hd
         bFeORDCu1Vioyro18tsEj4uAUawVJiOEd5mSZMp+Mxd7n+otMgZqN69zwplu9HdNImt4
         HEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776198394; x=1776803194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/UR4m3dl9VK+BroM75Hxq4WeXIJgGbxy3Rl4ETefDxA=;
        b=TPy2l7c+LqAH1kRK3GLEvhCdiXiRpfn25a6RZafJomNQED3IVUAwAYiHWn8iy/vrUi
         dk5AStpaU2uslhZqgKMjLGLVON8Ud5cAgLeUhoxEGMPFm63t9j4+/MNY1hXXRtjc1eVg
         oVm6E8OYKgi5Du+/A17+GA1m2fJFOjOOZ3dG8EfFNS8FXLgvid+o2GcqU6PQ9F7RVn+N
         hhPKGJq5tzd7Ruq7Mcr9AB8bJ50S6dLZn/hSJK5cgAs5S5o+R89VJZnHUlDtgrHDpTKg
         RANvtntlmfU50mk1PRftYPvj1i8SgH93U42EQAXwZoTCdEyE4BPlxRrj/CfAkGyhmVnk
         QdLg==
X-Forwarded-Encrypted: i=1; AFNElJ/5yDCLkxc09Opp02aOpjV4IdQaVGkGxf8S6t/BANuZKhFcT3upAhh/LWIsb64qp8GGm1G3IyuHKQ==@kvack.org
X-Gm-Message-State: AOJu0YyvWpsyWAC0fvWp66mnD+gtKtrWNw9VAMvlnF1mCN8EpKSjBOH7
	zc7JbrtZ7rZhVoXf6gcp+oeZOtd1ZCv+3krzPNtLXm2Elhz2nY5Irmou
X-Gm-Gg: AeBDietUyLE8jEqWdWwP6cbOMMcroRTYfYaWKpPlTnSeX7mP98/kRgZ0qAriBrKxJSZ
	e6iiJSu5xj9czp0gbjI/Jh6etooSDYtGtwWSwNr7jHIrXmd1V8cqLZEXdyEEs5dvtegtevB7KaW
	PfmFDQCZFLasMMhRwA1luDt1LzE8mRkHUlJkXY7jf9fZZqVgXIlp3yfHF7J4HOjabMLY1xhjjWJ
	HYpXGIM3LS/fP14VM7artHA88DkPCwyDVPlAXA5512bfFhPIAGXMrFZHUcs3YG82boDw1oA7SJD
	X/JzrS8QNrY947BkXgOxkcc13U5CsoHPUusmFofE1/1QkaeE+YZb0VkfNyZ+0eBpwZA+XrKJqUz
	q7wQqFXZ5c3MWSuaWV23wxklgdkcyXitFgE8pszd0QFiOnogZuffMliA6GAqeoEpnh1NwTe+t33
	Q4egCwbmzcxVlDhROwYIRfoA==
X-Received: by 2002:a54:4383:0:b0:45f:13ad:83c1 with SMTP id 5614622812f47-478a19124cbmr7485767b6e.51.1776198393796;
        Tue, 14 Apr 2026 13:26:33 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:44::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-478a0f1e841sm8167402b6e.5.2026.04.14.13.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 13:26:33 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Date: Tue, 14 Apr 2026 13:26:31 -0700
Message-ID: <20260414202631.2753640-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260404033844.1892595-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E7DF040014
X-Stat-Signature: rh4ih695bme5re11kbzh7rnfxrn5z58z
X-HE-Tag: 1776198394-91980
X-HE-Meta: U2FsdGVkX18r5oQmf+IsBiQK+IQxVIU0td45k8EJp8q2SUy0FN7RmvqJzOdYGPmTsBwi+8Z+8+vKN6uBOCTN0CK5WPjsw8k2LlpfHTy4HPtqUXmzR7oIpSKHsdzmoXbGThFy5Xjx3wgtelTsLcTlGjovzTSUzKqADNh0EQ+sGEDtC/cEBfFDAYyGgxMv7jCMksW/U6Twgpl7TuV8RG9bdEB80m6QqpqL/0xzdwwesa5NzUD40n7Tl3DQ57Txt8248Gf06uXoiVnEwHmzDEB6LAECV+J5+3YEHSBAa02OThnpwFgMtoU3zpfvbtW7ls78mueiOgu/DcGVG+nCR9CtJDBgXxdhZzycMogWVlof8vPS0G+5b9PPTCyOW2zYgQyVtV072W9Ek8PHiBIVI3toGb2qt9UrghvHddB4BqSssUoxoN+ZNvATqwGFcXzVNRDd4F9gNDlK7MZDh3b7gKpjCWoaZBU6Cboftib45tdKL+LJG2JD0rMoKHYGxwsxMJFrvXJZn/c2IKvpm50gV8iRgKLLoj5QYPwg2jKgzJwiD6kIRPe8IGaECQPJ5WN+MkqJPgYbuWT2WVP5GjZeWVZIg5sdNex0di+wmJEaDmjRhgtPjcVts65h+yI/ulfX5NYFgg35S/lRUGMOYwJesFmom92Fw85emlbna3xokWc1nBNHTi+ZDg07bPZT0DaQpdw6Wd7mic/PMmg91OgHaE5hz+S83rSWxdU9wvD2XwIgx0OT3JXhJoYHPTKbA81Lw/x5DNmK5CeZMyd1Vcp2Fq7bUWU0Pgl5GoQ1gxPhkAR+XfX+7lOH7Rtce5+/XiIcux6b65Ibd39D2UMEf8kdljIlr7E5GqRK7lG/DjICD+pKECG9L3S0tVXPMOSYGo0D74/usA1ZypOGOzM4GPubvbabbt7Wu6MC2Y+Sy+sY3j017fn4BMq6k5RXUXYT7ot7IIVC9POeFcUrZxio1RPl4/J
 6QF6bD8C
 kZeRjyM+ApNOAFlbJS/3uVwIs53o0BSVJtDg26ut95YMTn47KPv0/OOTIP+cAX4eEo+n/83k6I3fcdkuFJjlv+SfiEhzTVJo4A2LChysmpQJCxk9xBg2PlqDay6DYuqWybJHIKUP1u7XGEb+Zn6vlnzwZncOlRlXpT3sB/TjoW/cgX4UDZfyJPTg6w/sjzs3JhzHIedZGRdtqiL46i6MmhggWnIoPjbR4jECBDEJsEMf5+Us1ZI1pD0n+/VpDMuJa034AZ7eShTqBt7FbOWWWY9sb9O0Rt+reMNX2Di665X9YYCG7JG5kjEB4djQgyW5CAo1dc7t1QVA2DqLyuSXEA203LXi0OFRozI46rQQiMkSIPJOkX8c5KPVNa5/xubTBJWulJnIo7ex8+cwbg2kbUb4KnRpWob+46y9bnTjituQ6pSRt23P2Bb1uL4qiVZ+NsNmZFLbBaIHOyEk6PBOPFxLskGNbDj2T3xpnvNWR2PcipKND5g7PU4qwaKj34ya4XstZ18vEu+aQbeUkLAAvecqDn+gvATPtLkmYGm73SXJu1v+LJotCCEh4Lgz1BtjNIH3rvJT0ZzTPiXyFOF4CMJ5mXrHYYplxnlCbg59rQwxtfz59JLhjXsMQVyRO9cF+NLA6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Apr 2026 20:38:43 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> enum memcg_stat_item includes memory that is tracked on a per-memcg
> level, but not at a per-node (and per-lruvec) level. Diagnosing
> memory pressure for memcgs in multi-NUMA systems can be difficult,
> since not all of the memory accounted in memcg can be traced back
> to a node. In scenarios where numa nodes in an memcg are asymmetrically
> stressed, this difference can be invisible to the user.
> 
> Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> to give visibility into per-node breakdowns for percpu allocations.
> 
> This will get us closer to being able to know the memcg and physical
> association of all memory on the system. Specifically for percpu, this
> granularity will help demonstrate footprint differences on systems with
> asymmetric NUMA nodes.
> 
> Because percpu memory is accounted at a sub-PAGE_SIZE level, we must
> account node level statistics (accounted in PAGE_SIZE units) and
> memcg-lruvec statistics separately. Account node statistics when the pcpu
> pages are allocated, and account memcg-lruvec statistics when pcpu
> objects are handed out.

[...snip...]

> @@ -55,7 +55,8 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
>  			    struct page **pages, int page_start, int page_end)
>  {
>  	unsigned int cpu;
> -	int i;
> +	int nr_pages = page_end - page_start;
> +	int i, nid;
>  
>  	for_each_possible_cpu(cpu) {
>  		for (i = page_start; i < page_end; i++) {
> @@ -65,6 +66,10 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
>  				__free_page(page);
>  		}
>  	}
> +
> +	for_each_node(nid)
> +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> +				-1L * nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
>  }
>  
>  /**
> @@ -84,7 +89,8 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
>  			    gfp_t gfp)
>  {
>  	unsigned int cpu, tcpu;
> -	int i;
> +	int nr_pages = page_end - page_start;
> +	int i, nid;
>  
>  	gfp |= __GFP_HIGHMEM;
>  
> @@ -97,6 +103,10 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
>  				goto err;
>  		}
>  	}
> +
> +	for_each_node(nid)
> +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> +				    nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
>  	return 0;

Hello reviewers,

Since I submitted this, I have been thinking about the feedback that Sashiko
has given this patch [1]. Harry has already pointed out the points about
drifting due to CPU hotplug, but one there is one particular concern that
I have been trying to tackle with no avail.

The issue is, pcpu allocations for CPUs on node A may actually fall back to
node B, if node A is out of space and under pressure. This design seems to be
intentional, to prevent memory pressure from failing these allocations.

However, this means that we cannot charge percpu memory based on the number
of CPUs present on a node, because although the memory "belongs" to the node
(since the CPU it actually belongs to is on the node), the memory can be
serviced from elsewhere.

To handle this, I've tried several approaches. All of them were either too
expensive (iterating through all pages at allocation / free time) or introduces
new drift (I thought of managing per-chunk statistics as well).

To be honest, I think I'm out of ideas at this point :/ So I wanted to see
what others thought about how to track physical locations for pcpu allocations
that were allocated via fallback. Are these rare enough that we are OK with
the misattributing here? Should we eat the cost of iterating through all pages
to find out where it is physically?

Or is this patch not worth pursuing at the moment? ; -)

I hope this all makes sense. Thank you all in advance!
Joshua

[1] https://sashiko.dev/#/patchset/20260404033844.1892595-1-joshua.hahnjy%40gmail.com

