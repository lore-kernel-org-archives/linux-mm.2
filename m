Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64307CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 03:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404316B0088; Wed, 24 Jun 2026 23:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B50B6B008A; Wed, 24 Jun 2026 23:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A4156B0092; Wed, 24 Jun 2026 23:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 050E96B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:40:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FFB012053B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:40:33 +0000 (UTC)
X-FDA: 84917032746.24.EB9E4B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9147B40007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:40:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QyCgbFPV;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782358831;
	b=UgTyQrn7BHAI40Q4v4X2pOhejAMHltOa6JqF5Yom/B/GEU4UYHrAbwozbu1lJg397FodSi
	4HdzC9v9bkc2c0LZ+ICKoUf1Ol09wOe6g/Qes1nDDjwI2wrgI5cO+vVuosyy5tiO09TXxN
	VS3pbVMh2/kUmDUw9P5y45TrIcT1SIs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782358831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3Q4eDirsu3BpY4kvqH6rJbYy80lFPyTIC7ZlHsn9K4=;
	b=QUX7uH0ggiZfa3snSBNFr/dgFmUEpxZIuAtycvRZeA18V5LEvg/bwrSfBmfh2j/Y3aXGZM
	BE8OAgCQGd3DIHqmCz59TYzfb+AWCA/5PTSo5SEseXcC4hsT6V+9Afa50mF2pwOq3i8m8J
	E9a/ipCvic5BvAoRw12lIMrva0g53sA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QyCgbFPV;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC6CD600C3;
	Thu, 25 Jun 2026 03:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D411F000E9;
	Thu, 25 Jun 2026 03:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782358830;
	bh=g3Q4eDirsu3BpY4kvqH6rJbYy80lFPyTIC7ZlHsn9K4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QyCgbFPV3DIh8qIdxFJfyAYkJFZT8Wl7DDSBFUbWWiUJNbvmnjQV97OUG+pCLTPm3
	 oLjGcOBSh8otP0rKYT9ZQ0bF02sX27NkB70dZjgXjrU84+BHMhz04qzJuvmI13j6bt
	 nj+PMA4mz01lJ2E0qEO8Dktu/QuG3RqwXKOES0Fg=
Date: Wed, 24 Jun 2026 20:40:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: rppt@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch_numa: remove redundant nodemask clears in
 numa_init()
Message-Id: <20260624204030.3c8baa67713b6ca1d537baba@linux-foundation.org>
In-Reply-To: <20260617163919.2544899-1-ekffu200098@gmail.com>
References: <20260617163919.2544899-1-ekffu200098@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9147B40007
X-Stat-Signature: cae813bdiwn5gx797wnfbscyb5n8ruxm
X-HE-Tag: 1782358831-602107
X-HE-Meta: U2FsdGVkX19TtQjDB9aDSoU/W+ndfzRJfQgXaJCEoTIFKiB7G0azhePu5PDXtTQuFa4XhtQWZAQ26zBxGBogrlcunnsSExqSfChg+4iSc9SE6PQw46aoclZRCu8W4f5d/Rq084Z+jBafX+b6m3QXlgyWx5S/BGx4AdYuN0CvFf3ALV25LZoVVh+Td3zSMxN0XX79xa6r3nQNGWnZkvaOEY9W0tXHeh32QFtdLN1P4BYe0YImpMiiWaMkyrvaPdqfRHeMm7hHBKWeXDzs2ZpNesaATy7MfR1g6/703pBnuqs2HVDlLu1WlmX6Elp7Ka1tRR+JuWeYLSaVAYh07OvKyiAdZ9S8epY/J+bMx5tLYs3aGrP45mmSgDGfqwMkZB3ZOlhON17gfCe7amAwHBIsjkyInmS8Fc7UpW34p2eBt3DFcA/nGWIEo05FJ2KqFJ1syie5jgEk4S8TEbJ0Q10y3cbxEp2PHkKAVxadbwiEvsv2UZd8T1hSySssxzl/fDV5u8swcsHGYxMCO3ZkUeULGWTSMGOsIIYYyfJGfbDMVgb7iF7P+NuH0qNM/Ev/tY2APSZL/Nw11DhdTS5BykFXRiQBoqbiayDSKBQ5sWmQWyWM+BHpDa06KX/rrz7dPLT4ocjj6EBP0J+VB3XFP714etx0oQqgfrTNSNcbnOBB7hp9eqDmarMA2G3fS0UmNvy+sTWXmvkHrGVGX1kX6mTaf/if3SVlgAkqa5JBx0UPKPrDkFbSKpSZlVP5h2KLou4rN98Ws5+Vf/f8qH0R1TnW333NWz3EFLs0SDsy0+b6/d3x9sJc2Jq+6Uad5MbB7Tr4yP4eTQTMCyle9QGpSrQ9WpQuESWb2e2wSO8Rejt6mrYQ3ZpZKrupkwUY5vvhiPyoJvtw98kRKnpWcc7Crt0ijXDhkgAhw6dYnTcIly/uHQII9i5Uv6+zuKusxbZNd7DOf0sfYknNsjVChkYICuS
 i13i6ioD
 ExOy+W6SbtVoHBiA2+jkMSAl12g+yrUch7v3vxXk1zSMe0hgT434XorQTZdc2ku9CtbwSMStc8pGpvc7ylPSCN32DUifB0Nii4j6jvNMVQq3/WdpBAPssrFmC0A/u3P+aJvrczNcJN6k4IV64uJk+dtjNFWt9cqkYL+pv7WT/+hNRsdVqGeyL5oshwdBmjyZKC5C7SKzk8VIu0afknQi5y1BtjLIcEV4TUFw2p3i6o0bRFDki3yzp9RNGwNjAneBKa9flI8OVCTc8b7hRAR30cRa1Gotb0wT6jeVM1cjXUkvJONwdDGwIIMlMO+ohMVhTEWIb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 01:39:19 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> numa_init() clears numa_nodes_parsed, node_possible_map and
> node_online_map, then calls numa_memblks_init(), which clears the same
> nodemasks. Nothing uses them in between.
> 
> These clears have been redundant since commit 767507654c22 ("arch_numa:
> switch over to numa_memblks") made numa_init() use numa_memblks_init().
> 
> No functional change.
> 
> ...
>
> --- a/drivers/base/arch_numa.c
> +++ b/drivers/base/arch_numa.c
> @@ -231,10 +231,6 @@ static int __init numa_init(int (*init_func)(void))
>  {
>  	int ret;
>  
> -	nodes_clear(numa_nodes_parsed);
> -	nodes_clear(node_possible_map);
> -	nodes_clear(node_online_map);
> -
>  	ret = numa_memblks_init(init_func, /* memblock_force_top_down */ false);
>  	if (ret < 0)
>  		goto out_free_distance;

hm, OK, thanks.


A couple of driveby questions:

Are the other nodes_clear() calls are needed - aren't these things
zeroed when the kernel is loaded?


Also, 

#define node_possible_map 	node_states[N_POSSIBLE]

...

nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
	[N_POSSIBLE] = NODE_MASK_ALL,

why do we carefully initialize node_possible_map at compile-time then
zero it within __init code?



