Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E4D2CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 00:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5486F8E005A; Thu,  9 Oct 2025 20:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F91A8E0002; Thu,  9 Oct 2025 20:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435D18E005A; Thu,  9 Oct 2025 20:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32AE48E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 20:32:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E05CF51C18
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:32:30 +0000 (UTC)
X-FDA: 83980328460.25.ABEFBE2
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28E24140004
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:32:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j+gYBVsu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760056349; a=rsa-sha256;
	cv=none;
	b=N/SlzBTouMzcIJXehlrW5aGvWZNTTJYk5GuO0ATnIuVvftbJVlvAOSS5fzfjhjCnJWiFn8
	uyOBGSUyaKehnam1PTtJGlJlAAs4/JbKBljE/LXFK7YDKPX6ULSXFPSur9ZLFRv/BIkLT0
	uvKvBn3QfmlXiDZHAV+BRcEckTptA7c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j+gYBVsu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760056349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XjmMM8FOadfDH2bKmNKtpW1btFVf4eiY20naezZdF8=;
	b=GT7ERLF/pnij3ex8uRl6b3rVm/QNOrT/6qXeSLXRVR7bPJFZbhmrLZjLZaDABUCxmCTaId
	CBhtgq4Jd46/TdIrNXVNLANawvRV37cN0OKTj8106x87pn06sH+VIYtLBJAOc/7jnPpsi4
	fitMR9A67fmEXKnh2cVMKNwrAx9CyeA=
Date: Thu, 9 Oct 2025 17:32:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760056347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XjmMM8FOadfDH2bKmNKtpW1btFVf4eiY20naezZdF8=;
	b=j+gYBVsu2udOpyZ76DEdDaJVwJ1nFBy7pAC7jMSF3bNmmF69PxxdYmONjSwcF1gIGyTI5R
	G6h2jq7IkvpOFUBX+dkvvwEr+O1EvqL9PKO0gqYs0YFHEWZM+8O2gTIOspsXUG4x57lCyn
	//tr3wkFHutTugKihehv79TmGaq48nY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usamaarif642@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com, 
	kas@kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/hugetlb: allow overcommitting gigantic
 hugepages
Message-ID: <6bzfxls4dltmmogvjbr5q7wr2zf5grgcbla3mr4bah7kg6pdbu@qgx5lslkza57>
References: <20251009172433.4158118-1-usamaarif642@gmail.com>
 <20251009172433.4158118-2-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009172433.4158118-2-usamaarif642@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 28E24140004
X-Stat-Signature: jke98nqqxskyhi1tqbnyuekpetthgdwr
X-HE-Tag: 1760056348-468677
X-HE-Meta: U2FsdGVkX1/h6p/F+9Soczjb9VlEMUb2GhZgFBaJcMsALXpCHcN4j55EPs8JjV1QY45lHYXm2M0yIm9KGpMnTiWefRsjsochwjnNM7wsq1WStG8KVun6BsXHfbX0YIo/VULnkws//mY7wdmUcr4cng4l83d8RO8ATqFD4Fz3SsXqlLeCug1Sz9bbisnNYxafOe20+osG00sQUCotSwLlLmF/4j2YjdcykDo9lAGA1ScndfLUhMVo6t/GiLMz4kW+t6ax0DJrWAtgSsCClIvoDg+tujzO4bHt4xklRAeVvzVQPdZ18ixZqcBYk0UYj43IFs4btEgH5NpHaC++o9XgamFgCUsZj/wCnH5HqEtZl/gzrgXptOYX4etRDnqKslXbtVWpOOtRj4N0irGZMcB/Ox4tz6iFwakCDT1NxjRwnP+1vbkv9AAHxH9iuBd4t+ICOx7XNFyyyRIJoP8BHVyP9NGfEZnvLP9x5gTezI37+SADqm/PMdySrtKPp8P2EFyZEyfyYLKVTSY5i5oNqbGPbbgkUXLXWrZC6g0+s0U08iyw+PRLxgYjs3G1YBcKjMd9LI7yozlVlfh51WVpi5rJUluuv4SswWCYivAITD0d+aPInn+Ut9e+grYe0nMPN+xj/HF0jASaK9mRqO0xMhFkuLBPpZy7W0Ob66BVZVDXzk8G8TOd4uyvfr6O8N7MU6HJDQaUObXuEcFu22eRXCtC2B2mvpjwPQimKHutLYSOmiEvfll6dcBei/5mlh3OR7fqQdlnWAbqcvXOySUMJIDx13hX0i57nviWkgW2DjOld2u3we+IgxxrSjhMZT/t3qF5/uNGWkIBf5di51A+EHBY29c57OLxQ23skVdgLdT0EtEBR8wNNLOw7p4l+ow6XyBLuNjoEs2RHWvJPJcus//LSvwv5cQhM0AydBUEv3sgAqaw5Y981N+MehhKzZ0tEaUGlv2LQRwvoeh6JdvQpBo
 68D53tZ5
 2/FvnxKRknHd3Lmy+eFeXcPwCC7gbJgJg+Kt/nmxDfESEEX0NH4KVaxeKfn7DsM7hnFdPgY6EvL03qLeMLbMARvtH1JS9za3a+5TJPDWic9Af20Smxz1jIPQYLbF8GHGw9NsbUwRCVIZuoah3qT0/yb9pxsyl0DVz4Px8F4zUBsP29XYRu7nx4IfdnC7F34NoWkxvMd/nCI0hqblcgkdpBSwU0yRPpvTNLxW8gtYZZLbaWrl/jNiWnqHVfWblzLqKVosKzCQIEXhH23YctW8cT1z7Odd8zQ0Ag6SL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 06:24:31PM +0100, Usama Arif wrote:
> Currently, gigantic hugepages cannot use the overcommit mechanism
> (nr_overcommit_hugepages), forcing users to permanently reserve memory via
> nr_hugepages even when pages might not be actively used.
> 
> The restriction was added in 2011 [1], which was before there was support
> for reserving 1G hugepages at runtime.
> Remove this blanket restriction on gigantic hugepage overcommit.
> This will bring the same benefits to gigantic pages as hugepages:
> 
> - Memory is only taken out of regular use when actually needed
> - Unused surplus pages can be returned to the system
> - Better memory utilization, especially with CMA backing which can
>   significantly increase the changes of hugepage allocation
> 
> Without this patch:
> echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
> bash: echo: write error: Invalid argument
> 
> With this patch:
> echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
> ./mmap_hugetlb_test
> Successfully allocated huge pages at address: 0x7f9d40000000
> 
> cat mmap_hugetlb_test.c
> ...
>     unsigned long ALLOC_SIZE = 3 * (unsigned long) HUGE_PAGE_SIZE;
>     addr = mmap(NULL,
>                 ALLOC_SIZE, // 3GB
>                 PROT_READ | PROT_WRITE,
>                 MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_1GB,
>                 -1,
>                 0);
> 
>     if (addr == MAP_FAILED) {
>         fprintf(stderr, "mmap failed: %s\n", strerror(errno));
>         return 1;
>     }
>     printf("Successfully allocated huge pages at address: %p\n", addr);
> ...
> 
> [1] https://git.zx2c4.com/linux-rng/commit/mm/hugetlb.c?id=adbe8726dc2a3805630d517270db17e3af86e526
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

