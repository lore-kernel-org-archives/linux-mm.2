Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63207F36C5E
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922BE6B0088; Mon, 20 Apr 2026 12:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3006B0089; Mon, 20 Apr 2026 12:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9CC6B008A; Mon, 20 Apr 2026 12:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C74D6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AAF613BE6E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:51:16 +0000 (UTC)
X-FDA: 84679524552.06.56BCD60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 42D3C1C0011
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:51:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="F/jR/IpR";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776703874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ry6PhxjWb5+thKKcKNV5IxN9CxgPHTnNbYMDBvjayR4=;
	b=8de2EeFj/axFaN52/wY3U/YQESY4DWwiZE5gDNXlGFo4E97MkzOAS/HMNTQ5Dx9yIU6qDG
	Ve7L/cX1MniFdtqSXLIijIaklsT//eMblPRzmNoX++93og0fLoh6EVgh92CoaPfxtrhGe4
	GD19x4JR60GyvUeCh0ZL7zFr92LidOY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="F/jR/IpR";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776703874; a=rsa-sha256;
	cv=none;
	b=3BN2c3wLWZ+Dddn+pfnw7YH+lnP82a3aHZ1NfOSPwgoD3e64pUm090tkw63qusEDpZViSb
	BcHg1OuwjieKH+zyLmzFVO/5ws71Qh+HfT4r9ICkGxJJNdm4pXByJx3g0ZYe5ZFKRi+sJJ
	OKxhSb7jKQnqw7I04i8B2kNWk2i0PNs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D7A5D4412E;
	Mon, 20 Apr 2026 16:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358F7C19425;
	Mon, 20 Apr 2026 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776703872;
	bh=jv9KBJPeWPD7HQ/S6MXPqVdupIpZZVJJB35zyCJWuOE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=F/jR/IpRjnuPCyTQ/2dwBsw6QpfproLKZqT5GNGgZDHEFWfm2VclIV3GrcLYyBfti
	 ZT82lfiiz1xenX/v9WRDFbONv9BMa5AbbbQQpSzzGr0uSr7oU3qyrVz3MgxHOQEFjo
	 UGDOf6ytD+3+LqlmBNFC2NwfwKTdQOBbVhUxqMLo=
Date: Mon, 20 Apr 2026 09:51:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: <linux-kernel@vger.kernel.org>, <ritesh.list@gmail.com>,
 <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
 <brauner@kernel.org>, <dipietro.salvatore@gmail.com>, <djwong@kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>,
 <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] mm/filemap: avoid costly reclaim for high-order
 folio allocations
Message-Id: <20260420095106.86ecdb685cd31e0847362512@linux-foundation.org>
In-Reply-To: <20260420161404.642-1-dipiets@amazon.it>
References: <20260420161404.642-1-dipiets@amazon.it>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 42D3C1C0011
X-Stat-Signature: 738sqnxqbsypxkmmgkm63cx8qssaxe7h
X-Rspam-User: 
X-HE-Tag: 1776703874-172365
X-HE-Meta: U2FsdGVkX18YQnnY82Jk8vRPhTPc0k20stXBaNSJQ3RfsgurdLZeHNfIz76064xg8GLWyM3AKYapaLRHuDYPIEXGwSFOZr3qfCQ/fZ4mkOSM43uZ8sLNRo8tdAXeSCRS5jD6KnKZA6W/UCpCbJa9+QljbvWnlGAiu+OaN4P0GoyuRve7SufFyc+N084rxfq9X8/EofeSIP9j6ZbskrKPatuNgBj2L0+y6wlZvA9CSYmR1aOawlIDpo2rKbBoydJ1ISISmB7QUJb3+t96dinwQVx47QJLYKPubQWma4Q/ZeL3cPDrn1Vzk/YzvYOVhjY1/fcEV4JSnW8Nzo8J9S+hVUXCHcKCujsi8rvFU6pnOqrJqG+0YkfH4yfpCu0JVHq/mtrEch3qbZK6uWJGTm5gexLHGUjIxXH0zWKgUUqvSZrAh/7UCKaXhoID0d5M+5jVoaUJNtzSIU+X/a+jYu7tHmXhOFHlNz6ryGHB1ut5pwt8G2nW/vkMORQFmlOeagvBUz9HJfeUyQvCAVMwUgUVF1lobdwkhpddmz8v0H9IWU+FIHCuGlrc5RmOvKafJqVXu3/+DNWApYAHLMRwQsJYEPW0/rabn4gT7Xj0u2Zdwd7UeuHn2JnW0wux6wTcykvDhBdrywHgRRRdt9zBWvzBA7CJLJXv2VISOAAtBYBYUpBHn6j3mqUO5vKD7rxrZ9k03hjryNYxKwWsC9wJNBRgUniVsIZOCeWMPZ629VUxGLiKyJXKp2vz1OMrAZ60VpqwtcFs+4Vl1iA97qnEXC1TSEeqTrET/le4rQClGBpGtPFBw6mJVLFhdWhljXa0f5VHFVC7kSXHL/RoyswieDJ6lOq27hGl0TVDaFjaccyyk48YHdUaB40kvih4HpVPFG6Cmr6jxSfywA7RQ1Qbgxl1eDzQ/DSTCo8ZWW7NtPzQYVPaWZcApVIzRvsSruFhfuDAlO7i6R9cKPh2btIC+VH
 LALL1wfW
 0wRHB9pKR/eEs359KJzVwlPzTU4wWsBXwRe4dCWrvQcncI3l0d9GJQbsotGtrqAgM2AtLSxsb6Z8SNWVahnzNeSK3dRfK3GDimkOxX6M9DJiJ09wXHoM3RAUTnHWGnIqvgfgMmYQTjNJX1vRLUpCLyn6eENc6M834kwLbvWioNy/rBpXxKjnnlLPNch5zgWhB8QhRiNyCzdCNHMJJNOVZ4dcO3xmZ7oPX4bhBlhhDHje2Cg9dpbJDTdCvlwcX5QWAuJOIT673zi1YdzHey3Tq4YINzAhvsHcQYDMOKeYYEdxTjbFTzVf8p7oWawYSe/26mIIA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Apr 2026 16:14:03 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the buffered write path.
> When memory is fragmented, each failed allocation above
> PAGE_ALLOC_COSTLY_ORDER triggers compaction and drain_all_pages() via
> __alloc_pages_slowpath(), causing a 0.75x throughput drop on pgbench
> (simple-update) with  1024 clients on a 96-vCPU arm64 system.
> 
> In __filemap_get_folio(), for orders above min_order, split the
> allocation behavior by cost:
> 
>  - For orders above PAGE_ALLOC_COSTLY_ORDER: strip
>    __GFP_DIRECT_RECLAIM, making them purely opportunistic. The
>    allocator tries the freelists only and returns NULL immediately if
>    pages are not available.
> 
>  - For non-costly orders (between min_order and
>    PAGE_ALLOC_COSTLY_ORDER): use __GFP_NORETRY to allow lightweight
>    direct reclaim without expensive compaction retries.
> 
> With this patch, pgbench throughput recovers to 148k TPS (+67% vs
> regressed baseline), stable across all iterations.

"Good money after bad"?  Prove me wrong!

Instead of performing weird fragile hard-to-maintain party tricks with
the page allocator to work around the damage, plan B is to simply
revert 5d8edfb900d5.

5d8edfb900d5 came with no performance testing results.  Does anyone
have any evidence that it improved anything?  By how much?

> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2007,8 +2007,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  			gfp_t alloc_gfp = gfp;
>  
>  			err = -ENOMEM;
> -			if (order > min_order)
> -				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
> +			if (order > min_order) {
> +				alloc_gfp |= __GFP_NOWARN;
> +				if (order > PAGE_ALLOC_COSTLY_ORDER)
> +					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> +				else
> +					alloc_gfp |= __GFP_NORETRY;
> +			}
>  			folio = filemap_alloc_folio(alloc_gfp, order, policy);

I don't think it's reasonable to expect a reader to understand why this
code is as it is.  Hence each clause here should have a comment
explaining why we're taking that step, please.


Look.  I'm being grumpy.  We know that patches which purportedly
improve performance must come with quality performance testing results.
How long have we been at this?

