Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76850F34C65
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6EB86B0088; Mon, 13 Apr 2026 12:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1EE96B008A; Mon, 13 Apr 2026 12:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935206B0092; Mon, 13 Apr 2026 12:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 845C76B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:16:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1ABCF160265
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:16:21 +0000 (UTC)
X-FDA: 84654034962.02.280AA75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 762F31C000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:16:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kSEiYwVV;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776096979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+FrOfT4Covm9FV8Q8vZRx7hii6aeNYLt2ouslmn3OM=;
	b=GCwM/iAdHbgNNh1Lh8dRMJNHVcHXBVHzk0jjuRkjeBdgoY4j1n4s3eYMGv0NYKrXg287P+
	7RgyUtPZ/0PpnCqU8vCpNr8nRgMo7btMPnhUasd/tWZyLGctuJr23HUlLW1Nogg53IMjJF
	Edkr3rbGKc8LAe3DZISAIaBJLDtsRo0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776096979; a=rsa-sha256;
	cv=none;
	b=8DOAnR+dRiem9/H7sQVkQaRHnp9obBAMZIK/lGNl5EtdXy/VEJPImFzoBgK+++I45iP1do
	eVQdhwgHsifRSAL8cSFbRVzNzNz7qZY6SczpHY6mrEADyW0QFIDJq5Zk8wFILLU8aRsqHh
	XepAOyD4V1XOUUi3oQGaI2FTY7Wn5ms=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kSEiYwVV;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9314D6133C;
	Mon, 13 Apr 2026 16:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201E9C2BCAF;
	Mon, 13 Apr 2026 16:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776096978;
	bh=s0GwUHExH4iN6ORL9X/gv2Ol3KDyD0IWHk3CIXYTiuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kSEiYwVVNDqkNOGFJlyXyMEfXbylJRhQHfHiecOFmq/5hD8BLWtz4RNtQBt4oQgUJ
	 IDmkPBS9QF4yIrQjGHjGuni8vDAPswk8iJF4zZsQ3tRvOuYsqWfC+aRdn8YqHNjv/6
	 jHM7kdzTSaQ++71op3y/TQPHhLsNMUYgMjh6ztNrwtBu1KJQS26m/TTiEG2C/X5ZEx
	 VJ97LP/CF1M2ecnrQ3b7mrdVHZn8bgGaYqyUA6HBnvX2NQpUNAdl9GjNC1WJPYP1p1
	 RY1bFEvthjSK1toNlL50id84i1EqNq7rumXyeTrF1u5l+qTxKtvPa6y6mV6zbIWD5Z
	 7ojaosHo643pQ==
Date: Mon, 13 Apr 2026 19:16:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	urezki@gmail.com, linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com, ryan.roberts@arm.com, ajd@linux.ibm.com,
	david@kernel.org, Xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH 4/8] mm/vmalloc: Eliminate page table zigzag for huge
 vmalloc mappings
Message-ID: <ad0Wyq5--L0SeIqr@kernel.org>
References: <20260408025115.27368-1-baohua@kernel.org>
 <20260408025115.27368-5-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408025115.27368-5-baohua@kernel.org>
X-Rspamd-Queue-Id: 762F31C000E
X-Stat-Signature: fhp7niresaebax34mkscrkz17mq73nbr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776096979-816099
X-HE-Meta: U2FsdGVkX1/qguH8YA8iCrcwOxQJATB2m0Cy7QksEUOs+ETbj2roxcr92enP08Z3wydIdSq2ycaDCQB623yRfZ7ydmRrA2CESyLVqbbOqKwmt9/MrPdsv8o93ODbTzPwZW18MMa3U4LWI812VYzAt3Pnexi1vzg/MT2WSi1SUacZoiR2CL83TlYHyI+ofHqmINBOYCcdpdWQiLzRzKSOj2mOEJ+MHEXhaHRTVgG00QYWJoPRH+fexlH4JHYtuuoEO2MibCtmdYi5TBLOGqMt3WKrRbYPlhOa49+2IOs5ldG0ZsisWGxb4hY3UYa7LFq3rUtkxh+Jjo3hWx0sm54hR/00K34ldPHc9RHlDyWJzEr0yvEAhG/YZ3zRw8N7jGTSaT0rgzrns+HNnKrC3DgDR05hJqyyNrIIPV4X79VOjUBBYCqZQpVZhK7eliA6Pmesi/UWmjXgDjgm7l9wdxk2XvdV/o7WAbKHlrNDBiJRH6i/ZR2hMk8I4+9r50OEHl9ZD9H01cQksvB0XlKPuUmN3hum4BGbViO2Lwac+Go7wpvezR1JZqb85mVEJEMWG230D8An1HBdDQKHn4JNJ0OtgdaWc3NbnRFyMZnsdjbD8qWmecDb7j1tQU+uBkVpPTUPBWrMv/o5ZNFH5QXDfkfLykMhmyxhEp9E+nqlQ5xeDAKjM2YJTKxUwmHVnlodYYNH1T2q65nvU0y2ZrvWbT+/o5rodvBtJYe5jeKRdl5MmGOGnfey1GLMTCtC1e9RMLieTotFCaCpvJVMVVGOlCCkrJZ21ZO+q6FCwHL9xp9zj5qe8k0+IKSLOu+5NfgjwUKulEmMuJgspQqgw9+x88wMNziNy/5RzohSHxqe1p0K8nwsGI5kYDQV6AJ6Qa5LNC747Rp0he+v8aSYzoj8spsUSNNIaKlM2thm2ZVZWAoM4fDCedN7ArZaS7Wih6AYIwNLFaPVSTXxGgouhb4aLk3
 L22s5MHC
 LqnZb+wo9/PJuZbXtcyzYDI9e/ujSsbRIGvRHGu+tKdpwg0/XL5t+OPQHPEzJYNFMI5CbZLmyiriId/aOnVIJHcNPkpNqcxtmWHl3saRWnl0AZVuwqQYyPNcbiNK/Kx96Qx7GvGyDcHB9LbqMATw0ZId8yyqd37Gv4NuuuWG2Qs5arRucb4lHX5zhCd+43rf5dKLoJvjXrSbZbjIXKde9pfEJibSyQOyE+qpV2jM3eD0Wi/GhoJt4lismj3BR4yzVUZqMev1FZWLp2bKInbR6kzefpwOKY8g00oFlXNtKRq79fzSIh1wGnUBwz/pTmorEgwqVWWzlgE7S0lfgpC4I2PW73mMI3ElQWXWZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 10:51:11AM +0800, Barry Song (Xiaomi) wrote:
> For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer
> need to iterate over pages one by one, which would otherwise lead to
> zigzag page table mappings.
> 
> The code is now unified with the PAGE_SHIFT case by simply
> calling vmap_small_pages_range_noflush().
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmalloc.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5bf072297536..eba436386929 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -689,27 +689,13 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>  {
> -	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> -
>  	WARN_ON(page_shift < PAGE_SHIFT);
>  
> -	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -			page_shift == PAGE_SHIFT)
> -		return vmap_small_pages_range_noflush(addr, end, prot, pages, PAGE_SHIFT);
> -
> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> -		int err;
> -
> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> -					page_to_phys(pages[i]), prot,
> -					page_shift);
> -		if (err)
> -			return err;
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
> +		page_shift = PAGE_SHIFT;
>  
> -		addr += 1UL << page_shift;
> -	}
> -
> -	return 0;
> +	return vmap_small_pages_range_noflush(addr, end, prot, pages,
> +			min(page_shift, PMD_SHIFT));

Wouldn't vmap_range_noflush() already "do the right thing" even without
changes to vmap_small_pages_range_noflush()?

>  }
>  
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> -- 
> 2.39.3 (Apple Git-146)
> 

-- 
Sincerely yours,
Mike.

