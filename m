Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3C2F8D750
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 14:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472AB6B0005; Thu, 16 Apr 2026 10:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FA276B0089; Thu, 16 Apr 2026 10:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C4A16B008A; Thu, 16 Apr 2026 10:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1638E6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:29:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72F8DE399A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:29:18 +0000 (UTC)
X-FDA: 84664651596.07.6B04974
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9D2BFC0016
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:29:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ry5ZQ9au;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776349756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ME2oIxQC/BlMBONrj9wSvcfiYOecLgTx3azH08gpCm4=;
	b=IixQzUiDVsnM/gtD0MqvAXMAyf4wSv2v4FJFkcRVo6POwVghXtr7Q3Hoj6jJoenBOPSBrV
	/nEyyV1+cT/pQFGLjWy0wsCA4WGCwFYKfxKhbvuWDaSe94wMA2WZNoF+2Acd2H2VdlcWUZ
	1zTMJ4cGvMpfDW/1Kb6wFSS4mvPBQ3w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ry5ZQ9au;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776349756; a=rsa-sha256;
	cv=none;
	b=NNN4KLmfomEIXm5Z97dakskva6zYLE1d09L0cl1EIPOhMajMWIwa4D/okfueDFkE747xBX
	R1MIwqWe7+rEpw53nrrXaaxF0Z64sIumudcVldQg8FRQDA0Y3T0VYDOYGv8BrJfqo14KNO
	wymtB0KScEGW/OfEQSyAeHfI3lVS5A8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B98A43D98;
	Thu, 16 Apr 2026 14:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1A0C2BCAF;
	Thu, 16 Apr 2026 14:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776349755;
	bh=mJ+2km4a27hm3+3zImENgIzZDKUVxc11NGCjlIVugQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ry5ZQ9auYIORiGKjLpUUG1rNt7wCuSniM9XBAqxGnYPiYeF1ThrcNuv13UhOpli0+
	 +dis84PFHrAn63+jkNbbLC90aJJjjxZZgV7xfjnyGuhUvEW6dh+XfVxHXgcJC77Z5F
	 0xm1DSIDvmTJ33+u5eF7Am4zgljNLodnxFAZH+9gEaUasx2BY7h5u7+OyRaTNg3wZO
	 Y8/sgOTjCr11m6kSXF/ri5iujVDm2OKQGyNkT4EqwI+r5dQFynH2p9cAOJu2FlUcpx
	 E7M6SJyid44QmIYjbzjsFomWbyiwvFAjBznH4WB+E6BjAdN3wEyyhSJjClaRbOtDac
	 250qVcx5oDD/g==
Date: Thu, 16 Apr 2026 17:29:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org,
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: Re: [RFC PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
Message-ID: <aeDyNm94j7ikZl-A@kernel.org>
References: <20260416102558.575210-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416102558.575210-1-ekffu200098@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D2BFC0016
X-Stat-Signature: kq5ybd5qytch1p16xy57y316bfqhjmgp
X-Rspam-User: 
X-HE-Tag: 1776349756-859665
X-HE-Meta: U2FsdGVkX191L4Bf+Q/PhJMBVASiaLjSeW4/NdIkH4k32afJr8MRlfc+XZ/VWWYJzyydPmGoqudwWTPolqFF1jWhqgWASibAelTkWwAoPrl66G7l1/qv1rr7UbR+XNRqqgm3JsbysF9KaxuwbO7aG5fBsviYiSqWa9YI6rVTHQKadbh4BeTdCZm1lp5FxJB+fYbkv4yyqdLWuew7Jam/XOoYeRs4veFE4sWbEb0pSbXvj9BiAGOLdSKUuSCaYpgFoGA3f+RpAF3HnoDo+rtFwwqdLRKFk9N6yxqpVQCwTbngqWTayoZYsVpcO6j8OhBQMrCMenM3hBIo2NU9zKtCJDu5r6Sb08BQ/D8qAD9ZuuZ4/5PjXmekQIXZl5q3o+mkvfYs6YQTdoF/TyEWgfgVdjvmpzXsEv5o4e17/oPmwbq5Alcgg/yreAi5Wnidu6yVzOFD3q/HlRo7cNDseGwnIo8TyMWBKESTeo9h6yZ4HjZlZO8vWxJZCD0Wu1Y68sPA144Y4SDEvdC67qcq3mAp65f+ZBz8tfgv2JrUZqZhVxnEEIXwBvT5aez7UesoPNoMQCPh2xI+o3RCjKGFo2TWlGk7jm9CCD/MNBSmIsPoNQ4K3QJVpjGDqV6RrTmCvc576x6z0hxIQBGW3Qf7zW3pcvyJyt6UlIHF9rdlLSfnzKEdGnus+wib8WrW2IrDPMh9JxvFmGg8NsjEAklfT51wmlzgxrQ5w2bFNJS2cZZ3xPPiH3v4Rg0qXo6WwQcSkZfg4qFqqCE8OMF1yOrDgZ48BANKdZiHm33gWclArNxuMluZ1MyCi6j6uz02gSi7dvoFMeZ9qJSf0/8n36t1Pfcs/hhuE6UWpTEFBE1MvwvwvAIUKSS+baIqkmGUGlxXvvz5fTPVIe8WbrUkqpavozJq6MBfq+F1YcurlCfqngAkdnpOzMMqOPcUk8ohEaoMaNNuJ665/kbxg3hVrLOBfsK
 e3GbkzuA
 FyyDw5MxHXvPSpjtvZ74Ek1wXrRRKWBzm3h5pMrHCqYS/fPOB5ebFF3957Od/yH1JuyD5qj+X2mbNP7ue7JgKXBfB5+TECxXDVXexw1sYrN/7zcpxIF3O3BEpeloE1ZCU6UfKjI+dzusmxxL7Q/Je3zpTXUmlUvEErdt1bwAEhspZv9x/seYfnZDiQ8FyBgsSJisX/6935NtGouVhieFDDY6pRsNLpZd4R4YwE3f8gxN2HZAJGzF5jEyGhlnbAqQ551YV3W4ZTVxHCsyZ2a4eMWUCSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Apr 16, 2026 at 07:25:58PM +0900, Sang-Heon Jeon wrote:
> Subject: [RFC PATCH v2] mm/fake-numa: fix under-allocation detection in uniform split

RFC in the subject means you don't intent for the patch to be included, but
rather want to share it to get an early feedback.

I believe this is not the case here :)

> When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> returns the next absolute node ID, not the number of nodes created.
> 
> The existing under-allocation detection logic compares next absolute node
> ID (ret) and request count (n), which only works when nid starts at 0.
> 
> For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> 1: 128MB) and numa=fake=8U, 8 fake nodes are successfully created from
> node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> fake node nid starts at 8, but only 4 fake nodes are created due to
> current FAKE_NODE_MIN_SIZE being 32MB, and
> split_nodes_size_interleave_uniform() returns 12. By existing
> under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> under-allocation will not be detected.
> 
> Fix under-allocation detection logic to compare the number of actually
> created nodes (ret - nid) against the request count (n).
> 
> Also, fix the outdated comment to match the actual return value.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> Reported-by: Donghyeon Lee <asd142513@gmail.com>
> Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability") # 4.19
> ---
>  mm/numa_emulation.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> index 703c8fa05048..c1d0a76aef64 100644
> --- a/mm/numa_emulation.c
> +++ b/mm/numa_emulation.c
> @@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 hole, int nr_nodes)
>   * Sets up fake nodes of `size' interleaved over physical nodes ranging from
>   * `addr' to `max_addr'.
>   *
> - * Returns zero on success or negative on error.
> + * Returns absolute node ID on success or negative on error.
>   */
>  static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
>  					      struct numa_meminfo *pi,
> @@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
>  					n, &pi.blk[0], nid);
>  			if (ret < 0)
>  				break;
> -			if (ret < n) {
> +			if (ret - nid < n) {
>  				pr_info("%s: phys: %d only got %d of %ld nodes, failing\n",
>  						__func__, i, ret, n);
>  				ret = -1;
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

