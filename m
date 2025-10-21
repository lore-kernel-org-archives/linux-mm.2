Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C487CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 05:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558AE8E0007; Tue, 21 Oct 2025 01:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508F18E0002; Tue, 21 Oct 2025 01:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445B38E0007; Tue, 21 Oct 2025 01:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 329F28E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:25:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFCFC13AB76
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:25:57 +0000 (UTC)
X-FDA: 84020984754.22.B19A3A1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3911214000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:25:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kONxEFw+
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761024356; a=rsa-sha256;
	cv=none;
	b=2dtkxl48lP8arlswKk1PJRIax/S+oKtTADVIKkB8XzbBsjI5woL+D73bnmCf68umgdNDE4
	gThx5NBgfyhhh7JEPQ9bOufZvQq7qq9vTQtXQIwCS59iKkfNrXpgvVaO8zG61bqS3P8KWi
	TAXwqzl/z2M+4tArTV2cR4HZ1imY29Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kONxEFw+;
	dmarc=none;
	spf=none (imf09.hostedemail.com: domain of BATV+5669af1c49f76a6ebb22+8094+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5669af1c49f76a6ebb22+8094+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761024356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfhA1ZYpQWFjqWYb4xJjbR8w9o0oM9AxIrBG8WbsVnw=;
	b=vC3AhYkNpxC24dvBe0z+vCVLm4rRJsrYAwhpls0vJrajEuP9F3IcMLgPuiMYdjTB4izuBI
	Oakus6NUAxXPxp/h6YnCVBzSOj1fNdgCCTedE5fGTprLMnmKPxGE9gzVB+4oF+dVMyKyMv
	mzv7bmpPkz4c7lGurpuElSzIx9HqzpI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vfhA1ZYpQWFjqWYb4xJjbR8w9o0oM9AxIrBG8WbsVnw=; b=kONxEFw+jXtYeR126YKcVcN18o
	nYaR/VhcKRS2pVgSjp8KGtL3Rbi89WT/pZ8t/x/Yhrgf5AZHh+7CF4Wh/2tsklZJgh8T2XJT3/vbI
	Cc0jdxx8cgtT2f3lkO2wuL7W7hp6s6LBdNTE3vuLPAtkkmZRc6uUkPWOpzaLrwv4P5GZgZPp/hHRZ
	7a1N723E6VmpRRMq+XXZl7zItxZVAWJum+Ym/A4k5Fg5pu+qHfTzdGvM1nC6Q4nkQeKdrJnhrzGp3
	63bmiCcuh9MoQtqhClhi8VbprSK3dXChd92d8C1e47RKWnAjh9ggVtpx43Z7Efs6V4JAS2N4GFOGl
	2jN1i+6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vB4sZ-0000000Fqk4-2SXW;
	Tue, 21 Oct 2025 05:25:51 +0000
Date: Mon, 20 Oct 2025 22:25:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yifan Ji <412752700jyf@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Dave Chinner <david@fromorbit.com>
Subject: Re: [DISCUSS] Proposal: move slab shrinking into a dedicated kernel
 thread to improve reclaim efficiency
Message-ID: <aPcZX9dabaEqTBdG@infradead.org>
References: <CA+9cq0kkbk2Bpgyah=9bU2+=QNM2L1GfYLgMK6OuRhda-B80cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+9cq0kkbk2Bpgyah=9bU2+=QNM2L1GfYLgMK6OuRhda-B80cg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: gdk4e4gqdrd89y5g5nmpsj11prdz6eyx
X-Rspamd-Queue-Id: 3911214000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761024355-943823
X-HE-Meta: U2FsdGVkX1+3N5QJXus4rX2UO274CzH5SxqqPzDOHlTazXWt2A2GGD104bthCx0JfXkK27+0BIKha0SFfzuHcTny6I3I7nNz18HYg+XUINVTVD2vePgStCvppaps4oajvAhreyqSEWH4JJb9pZqx9v5DiXJgwU5sXg7B7/anIuH15NG5iHqAgLzZlT1iE/MpEY9SGPRF4lPiuQVZEd8N3+sQ4Ki2UI4vef89lUpcvoO5x9oHotLb+OcXf1WEGqJn3/SvVICO19fN6mYk0xlaTfJ3YYdM0YpSETpuZad/kBB7nPNOUUQxXjadxKItYWvhLf/SOXPZeWjDgY6a7RAFIiXCEPJ02AGxWGmE/CwQIVJc0pVoFK3iNvdO92aw1vETVphl1W0H6IFVWpZq4mqCTjZxsFdcpc/gcERX6+bOeBurX9dnbI+1STz1k8t2gZf1fSM1YNflwc4j9tISutsnrjpp8c8sbmRHPO6uvz48okSLg9csKA6veeqIpPgQ1yf9VHTZ1wWjMMNg/8zc3dJ9uRAfmrh+svtJDogQuxM/nLaVLysdHL+5ACCH1uxlpspp7xbac7gRucjCdNIS+oJ1JNaOvSzxIN/5Kpo/vDD2fbMPBbSvE7I34unzZ1gbleG0AgqZGsvsEoQOylW3SZfa6NJB8s4J8XRbz9e4K8h7Gbhiu2hZubB+wOgtV0Acaut1q6GFW4BRScu4CU6C3Hh3rbUGWFmSXPdNzYjaaqUwz2bH5xH5XMtEG3+5AOabHfrJ9meCOgCxI3PjksS00vIcCKJ8ehFiJbzLzEU8QKgwzSsCpxRs+qNs3Y9GxgouqtyKb1qvCO09eCZayGVH7VVDbfdsQUSfqwucJr40QIuc1iUGhkf0VNKklcrsUHcR3tFx4CPLZnybZ/yFxBAI5DVVmibe9rTWkR/u5X62tS/ATTm7jqXudhhoZBdbVjegJ6lXPudwIsWLMbmb9Vpq4ue
 DWQKSSPV
 VCMBKpib6zQNLxV/af8/uzHbZcH1ZU1t8CGkZuJCxFFwKAaQxFv84kcDwN5x+gdEYMYShizvEm8b9OS6+Y8Ku5VkwankDrtDTDCH362Zy4m1PYzFkPrB5PGbvX3Sqmi0GeXBuVgkogLqmvU3kooWGY06Ve0QiwtUHsYLqmPFPluj7wEqWln1VgJlAkVExUA7ux79PBAo+r0qj09TM1d1/1gJiBBnH+7/iDNQ4oFT4bP/PYWt4hgjrkbsHHC9DJ7N1gHecWVh8lJIawCFLSWMgZNzxeOuSPSi4FmduGuHmspLiQdWX8klguEZfvH2CBn2w5WGKLNv3r8QUnxcOR8K/LhO/970LHcQ/ztYKXsRR/gD8zX+cUYgwpIaiJRX+9KKkPoyjb0HWyVMQlvSDQ83GvTXZxcsTtB3BXOABg0j3gz+H9Ek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[adding Dave who has spent a lot of time on shrinkers]

On Tue, Oct 21, 2025 at 10:52:41AM +0800, Yifan Ji wrote:
> Hi all,
> 
> We've been profiling memory reclaim performance on mobile systems and found
> that slab shrinking can dominate reclaim time, particularly when multiple
> shrinkers are active. In some cases, shrink_slab() introduces noticeable
> latency in both direct reclaim and kswapd contexts.
> 
> We are exploring an approach to move slab shrinking into a dedicated kernel
> thread, decoupling it from direct reclaim and kswapd. The goal is to perform
> slab reclaim asynchronously under controlled conditions such as idle periods
> or vmpressure triggers.

That would mirror what everyone in reclaim / writeback does and have the
same benefits and pitfalls like throttling.  I'd suggest you give it a
spin and report your findings.

> Motivation:
>  - Reduce latency in direct reclaim paths.
>  - Improve reclaim efficiency by separating page and slab reclaim.
>  - Provide more flexible scheduling for slab shrinking.
> 
> Proposed direction:
>  - Introduce a kernel thread that periodically or conditionally calls
> shrink_slab().
> 
> We'd appreciate feedback on:
>  - Whether this decoupling aligns with the design of the current reclaim model.
>  - Possible implications on fairness, concurrency, and memcg behavior.
> 
> Thanks for your time and input.
> 
> Best regards,
> Yifan Ji
> 
---end quoted text---

