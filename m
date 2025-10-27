Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E1FCCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 17:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2143C8007C; Mon, 27 Oct 2025 13:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EBA48000A; Mon, 27 Oct 2025 13:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1032F8007C; Mon, 27 Oct 2025 13:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F22168000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:29:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A96F160204
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:29:18 +0000 (UTC)
X-FDA: 84044580396.14.29C4E2E
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5BEDCC0007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:29:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iCrUOTis;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761586157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hkk/4jH6EBlfw+AjqDX/N89lF3rHfzq/zegSXixlTQg=;
	b=xGN0uZZfAT4Fr7iMySwZ96Rps1Zjy7BCcSusG5wuGzXGf23p2Gq1dDhApGcZzRrVhBF+IA
	Npt0BKP0QxxlyxSQ546hIDpul4aa1JXTwtAbQqsIjCH6ryUuuinMh5XKL3zle3elSEAftM
	G93bR5+6IjPxTIjRJ/yizNQwBZB19sI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iCrUOTis;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761586157; a=rsa-sha256;
	cv=none;
	b=7r4zE6qys9lzU0bwVWpNwOqhU38PeffdW7YQkI8USPUiy0DwvYZr99Yte4ayMH5qBEfWwt
	B+eyU/jLC21L51yivXqSH9q0l8WZ3a/lzXGU/yNgEFKc61ZvtaAFZ7dr37yg/ZgMMNqK9N
	2tWCL1z0drhsj3CljB29tM8qnGQzYYA=
Date: Mon, 27 Oct 2025 10:29:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761586154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hkk/4jH6EBlfw+AjqDX/N89lF3rHfzq/zegSXixlTQg=;
	b=iCrUOTisVmn0Gyrl01InGTa2hzUTpre3WhDeV4nG+iN68gBLiKGojyC5U0wmDX0tmxfP8z
	yQJdQfCm8TAAg8+SpB/IJ2zMuTZ+0wMy+kGHMIsY7qgpVRe8LNBWf9cwZImH4btrtwfuDw
	NENplaCH8pXB94SRHmPauHF+yap+3C8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: jinji zhong <jinji.z.zhong@gmail.com>
Cc: minchan@kernel.org, senozhatsky@chromium.org, 
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com, 
	corbet@lwn.net, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	axboe@kernel.dk, mhocko@kernel.org, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, terrelln@fb.com, dsterba@suse.com, muchun.song@linux.dev, 
	linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, 
	zhongjinji@honor.com, liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [RFC PATCH 0/3] Introduce per-cgroup compression priority
Message-ID: <k6jwua5rlkds7dxomwvxotwtjq4hauyevvyoxd5hjz733k7kk5@mmezlradxhpu>
References: <cover.1761439133.git.jinji.z.zhong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1761439133.git.jinji.z.zhong@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: us8bejindzf5ezf5z3t7z3kd6ctyq1ne
X-Rspamd-Queue-Id: 5BEDCC0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761586156-479072
X-HE-Meta: U2FsdGVkX18ipxfCAUnKHVNjRyT09rBQ1GMGhWboTQzFkSt+JDjDcqCCCvelJG7dI0bgl7xDKc84KfDWXlwZjOCHE/KtOiK4K3Ml/aun8LGtLpN6EPz3/QGErgsijJUXp7qIoVVbwbbTUPA4pZ23dV44C9DjRcgQg4cGM2hf7M9QDgbgpz+bD+BWb2V7NOlVCM3q+8Snd3MAp8E29Y/YnyD0Uy4DAaTG9FDryaA4LJEgKPj4cMj7FbFLSKQiZgtoEM1GdikyQnGliMGIKa3IaazIna8u9taaTkc6pcqdQWo2x6zVqnscBaLmV2BN791NrqKVkco4NXPDGRVXfjQPiCtY2eT6E3Z922RVot8XRQOw2MKiK7LR1NRKoRoIKv/RIJVp/IarY3ok2HkPStV9TOfkCkxy5yMpC4s4AhK48Vj/T3pi+XZMfY7TISeAGaSljy2N1TJePjnzmRw7+/GMSdCObfgbpJ8+fbwQio0NXqpHnp5nqjgWD8ZUEKaejRH+weceBpu2xjGn5yE7C30tqNwFQ6lAUwb7vLqKt8ou+LMe9zrrTtOYZzsJkriXb6w7fMzNs2GST+OTsvhhVpuSn2KPypz5NBsE8MqjxicY7sknuLU/nyxTQuFgo+LCHS8KuH9maJImUjORYIkUNT02z/13vbIStQxdLJFIcXAHHh25PkNJqBV52FM9HfxbeXnrhJUV8jzlWXRz8W11ExZjSSX3a3KQgfvtxkzS3lv8R1Mu/Cz1AScjfmwho8yluK62OVSFwys1W4eNAr6/upQIRIXcqoOlogm1Kbegs8n2jSVEG45FnhFoXb+PtSFjxVK0Vmhm+WY/KkASe1CpFhuR2w75LzhRkUlVo14E37d1qQKcn4QeFNAeQ6It6r2gDQtGBHW0Sr6wBCvwfJLV3KAjOm2HN4PRlwAdfQ7XT9DCZ4bhzjvq261nD2ECXq0Av2nv/7k13hCIaxRHq3ff0pv
 9TmuC326
 77ldcyGFY2KOyMGncof7d4KcxUrebXiYAf0EJLYPX74eMMcvKWHqp2lmhXxzlQD2lMEDT3q7lwv8zbHnpSNcQlKciHX0mEnoxdDvM2rFiZdV9qutGx/jicSKkQPbJ/DTeNnElZpMoKuQrIXfjyF1ouf0gbzmcvXO18YsNGlUj/BeOReDalDaNXWIcAl+KFnbmz3HJD9Vrn4NbvUSrPxwkVAz/NSba5J3FzQWTiOu6Slf1xOT7Uus88aC6XDz2HS+P8jMX7I/FfhBx5w2kYN3dSEmC7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jinji,

On Sun, Oct 26, 2025 at 01:05:07AM +0000, jinji zhong wrote:
> Hello everyone,
> 
> On Android, different applications have varying tolerance for
> decompression latency. Applications with higher tolerance for
> decompression latency are better suited for algorithms like ZSTD,
> which provides high compression ratio but slower decompression
> speed. Conversely, applications with lower tolerance for
> decompression latency can use algorithms like LZ4 or LZO that
> offer faster decompression but lower compression ratios. For example,
> lightweight applications (with few anonymous pages) or applications
> without foreground UI typically have higher tolerance for decompression
> latency.
> 
> Similarly, in memory allocation slow paths or under high CPU
> pressure, using algorithms with faster compression speeds might
> be more appropriate.
> 
> This patch introduces a per-cgroup compression priority mechanism,
> where different compression priorities map to different algorithms.
> This allows administrators to select appropriate compression
> algorithms on a per-cgroup basis.
> 
> Currently, this patch is experimental and we would greatly
> appreciate community feedback. I'm uncertain whether obtaining
> compression priority via get_cgroup_comp_priority in zram is the
> best approach. While this implementation is convenient, it seems
> somewhat unusual. Perhaps the next step should be to pass
> compression priority through page->private.
> 

Setting aside the issues in the implementation (like changing
compression algorithm of a cgroup while it already has some memory
compressed using older algo), I don't think memcg interface is the right
way to go about it. We usually add interfaces to memcg that have
hierarchical semantics.

Anyways if you want to have this feature, I think BPF might be the way
to get this flexibility without introducing any stable API and then you
can experiment and evaluate if this really helps.

