Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E643CCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 11:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32D848E01B2; Thu, 30 Oct 2025 07:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF658E007D; Thu, 30 Oct 2025 07:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B8E8E01B2; Thu, 30 Oct 2025 07:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 023518E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:32:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B38884A485
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:32:42 +0000 (UTC)
X-FDA: 84054568164.24.6015C59
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id 09F312000C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:32:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761823961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Wemf8aXpKyB1LG8YiugLr+USe+UeJ4B/YwswxkSidw=;
	b=TNU79EWmbaYtL8C236Es1wwk35T24l1CApkM+sWJPbuFDXJdlvkoNKyRDG/ei3nuku+2zj
	DuwN7vTLIetwXZtPcFmrMwZ8kANrRalh4xZplDZPD4i7PSZxFy9ICBsTcGeEYbvwQAvIjM
	t26bW1lnotQw4LcUg8thRUATvJRNNVA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761823961; a=rsa-sha256;
	cv=none;
	b=tYxPG/gTLwgjR5FQ6IwpIqAsOKRvakW8w/F/o+xKjmnFba9cN505PkkZLqo7aGh9Jd5Sm5
	AykR9bBdOinHXugSOu21xPhayHsYeFz9rhT+E77vXJ4kTf4g/pdu863jn8hdrNiJAi1Gxu
	zobstxNT+Wjq9UVq2d3ZztQGgSgPkDk=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cy24h54rFzYkxgw;
	Thu, 30 Oct 2025 19:31:32 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 30 Oct
 2025 19:32:33 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 30 Oct
 2025 19:32:32 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <shakeel.butt@linux.dev>
CC: <akpm@linux-foundation.org>, <axboe@kernel.dk>, <cgroups@vger.kernel.org>,
	<christoph.boehmwalder@linbit.com>, <corbet@lwn.net>,
	<drbd-dev@lists.linbit.com>, <dsterba@suse.com>, <feng.han@honor.com>,
	<hannes@cmpxchg.org>, <jinji.z.zhong@gmail.com>, <lars.ellenberg@linbit.com>,
	<linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<mhocko@kernel.org>, <minchan@kernel.org>, <mkoutny@suse.com>,
	<muchun.song@linux.dev>, <philipp.reisner@linbit.com>,
	<roman.gushchin@linux.dev>, <senozhatsky@chromium.org>, <terrelln@fb.com>,
	<tj@kernel.org>, <zhongjinji@honor.com>
Subject: Re: [RFC PATCH 0/3] Introduce per-cgroup compression priority
Date: Thu, 30 Oct 2025 19:32:28 +0800
Message-ID: <20251030113228.18817-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <k6jwua5rlkds7dxomwvxotwtjq4hauyevvyoxd5hjz733k7kk5@mmezlradxhpu>
References: <k6jwua5rlkds7dxomwvxotwtjq4hauyevvyoxd5hjz733k7kk5@mmezlradxhpu>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To a018.hihonor.com
 (10.68.17.250)
X-Rspam-User: 
X-Rspamd-Queue-Id: 09F312000C
X-Rspamd-Server: rspam03
X-Stat-Signature: mwiui5zuh3apfreafxr7q9bko7kbibb6
X-HE-Tag: 1761823959-83240
X-HE-Meta: U2FsdGVkX19hV5Eg7kUQzVZkSODIZSxqw/RTMkp9Q0ImxaM/XMExVmEiXWbyjkOB/tQ2pKcVCQhIGYeuL356bMA+wTP/X9zbGjY9PLbZGHy5vrdwOl07UD8iHcB/B/wfuvZQAL4QnrnBt/7ZNN3mILcORXtAYYTt/ZYX/PTucI+EfNSXyacbtEu2LUgqXY8farYXFN51JNa+/vQfvLJ4DjdtwOBhFMevUonHPW5pmo+2dI/+u70LYu7+ig1XBzlmfy3FoHcynDKFImpvIPildPAVgaGra5GWKVb2FdzJy/IJ0juA1SSO0vf6WqDpyZL3NIHGOuOiFPRWNdxAw0EeVn9qVjMxA/+i1cMGPnk5tGlFlXh+4B7I1UKoNKFBlUjg0gZtaNtZYKQZoQWrb1vwKG+OF0OYPI1f42GVwfrcjKPVS6A7zZMcVqB0elTeM/KfK1uVL8/Mwtb5CJv/K91dSeP3As+h9AAu0tuErFB51UpkUh8O3wT/ce7irs5eJl/WFb5fGXZeYPPCRIj7sQJ514lKG41WAHlM0iSA1aT6AZ9yNdpfMGDSN8dxnMAYctNcCXF6AfJODY/F6JhB/EvD5L+tihWBGMAaXzAB4QyYXqpVdv7nBwe8wvjYN5RvwEY4ocjJpJZgrdbEb6ihrh8ke6Q2Pli4XFUUep8r5yQuTCIIVCo5BNk/eSZ1EavROgKguttZdlGQvV/zHTrDhUMQ7VW4b9gzVSS5pguIuB7gtPF7haD9doGpXDmsc088gSQraEUEqL7XCDEfbDH1pnn9m0nEu5IVAC0DzTAbjp6LzTpnGUgXUWJsdu6tAQjc7a0H31OzPMzA0leW91CvoLepSbXB8a1wMHemHeOF/11GYEJo6WA05dErUIX0/eWQrgRAqnomoSR99B/N/dLTzgk5MtoQxxzpoLRoaFpBrYhL0etYvaO5MZKeavi56qFXc93wVfddIe6FZFwnThsz2kh
 5n79ziyT
 UfrKawylpOQC+/vsuOUtREzDiqZ/Ri8uRQsFNNYqj5YWfUCtjdYCMiGVCw46cIGEUfxppckppMQN1J0fobeAvi/493XO7eWjKJ9AJJviBfvuNVk7sNmfHvPT4VqTt7YOwY/CqZbbbh/blw+abe/qQe9gJA8wjNglA+i3hZtYxAw3SzpynHp7NUyf5Aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi Jinji,
> 
> On Sun, Oct 26, 2025 at 01:05:07AM +0000, jinji zhong wrote:
> > Hello everyone,
> > 
> > On Android, different applications have varying tolerance for
> > decompression latency. Applications with higher tolerance for
> > decompression latency are better suited for algorithms like ZSTD,
> > which provides high compression ratio but slower decompression
> > speed. Conversely, applications with lower tolerance for
> > decompression latency can use algorithms like LZ4 or LZO that
> > offer faster decompression but lower compression ratios. For example,
> > lightweight applications (with few anonymous pages) or applications
> > without foreground UI typically have higher tolerance for decompression
> > latency.
> > 
> > Similarly, in memory allocation slow paths or under high CPU
> > pressure, using algorithms with faster compression speeds might
> > be more appropriate.
> > 
> > This patch introduces a per-cgroup compression priority mechanism,
> > where different compression priorities map to different algorithms.
> > This allows administrators to select appropriate compression
> > algorithms on a per-cgroup basis.
> > 
> > Currently, this patch is experimental and we would greatly
> > appreciate community feedback. I'm uncertain whether obtaining
> > compression priority via get_cgroup_comp_priority in zram is the
> > best approach. While this implementation is convenient, it seems
> > somewhat unusual. Perhaps the next step should be to pass
> > compression priority through page->private.
> > 
> 
> Setting aside the issues in the implementation (like changing
> compression algorithm of a cgroup while it already has some memory

Zram uses flags to track the compression priority of each page,
which should be ok when the page is decompressed.

> compressed using older algo), I don't think memcg interface is the right
> way to go about it. We usually add interfaces to memcg that have
> hierarchical semantics.

Thanks a lot, Shakeel. I got it.

> Anyways if you want to have this feature, I think BPF might be the way
> to get this flexibility without introducing any stable API and then you
> can experiment and evaluate if this really helps.


