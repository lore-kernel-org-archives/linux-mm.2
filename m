Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58055103E18F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD226B024F; Wed, 18 Mar 2026 10:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361386B024E; Wed, 18 Mar 2026 10:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3DA6B024F; Wed, 18 Mar 2026 10:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 003646B024D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:17:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B33F71A075F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:06 +0000 (UTC)
X-FDA: 84559385652.10.276DE0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CB9B8C0009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l2n98eIW;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FZ5QXHUzU1ata4VbBabv3m2vQppMp/lSd5sxHdN7Sc=;
	b=ZiOb2RZdq75kXNmNyxno5uKj4Ur2OVj39TeCCUbeR0FGlXMIjfd+zMZPIv+vDkYXwmqGwz
	6hrVWTSMTwyhiFakdleJowL4y6OoDKBBlM7sJ9WSebQ1bCihd+9s1/s4knx4MQfnJr4BYV
	6FhyvXEGvhe/26gPQB+vZsnctnEVZIc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l2n98eIW;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843425; a=rsa-sha256;
	cv=none;
	b=6ScTwHvt9Q2jp4Eu1dJswo1rfhNFcVsN9FTOpIOvmIAoXZSrw3qxH//trkZCyQJKk3wfVv
	HbO2I6fMcfJ09GF+sTQvZySygB8xSN1pQndtFvZjMDnn5tcd/Mb62zcN4ReBdBW5nd6zNH
	vwjY5bdZXOe0l2mIgHxv9k6xA7v4hI4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCAC7415F6;
	Wed, 18 Mar 2026 14:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B834CC19421;
	Wed, 18 Mar 2026 14:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773843423;
	bh=Nka2tAu2xfrAzh/LVz+kPzjJGV26abtbTSAN+jQ1zCs=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=l2n98eIWgaO3CjkFjgd0Sou85/DdxxIF5f5x0NNXjCnRCCUzjcWJiinkayJ878aww
	 BMJ0pXZVJUefOLLhpj2fMemzle19sO2O1t5wBOu4oWg54p9ZGJdEhdeS/Czy9hnQXA
	 eulz6Qr5rpmd86XRFktfVxpPiPuG0bWwvXiusqCzjYmb/h8nhtFZfXIiV7SJql6pbr
	 L4xv+2VnZl426NR2cd+2lb906X8FppURSFBE0mng0zk5Fvon36cCbedPT6Sf5MOPBk
	 nKWZjGbed3op7zsa/QhDxrRfMTA0/5KlsKm4GWT7flFR84ReuRSkL4lH9ODOoxK1Dd
	 vepd5z1nkYYfQ==
Message-ID: <11428d25-7bea-4be6-a6ee-bfeac1d50807@kernel.org>
Date: Wed, 18 Mar 2026 15:16:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 3/8] mm: move free_reserved_area() to mm/memblock.c
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Andreas Larsson <andreas@gaisler.com>, Ard Biesheuvel <ardb@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Brauner <brauner@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
 Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Michael Ellerman
 <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Rob Herring <robh@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Saravana Kannan <saravanak@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Will Deacon <will@kernel.org>, Zi Yan <ziy@nvidia.com>,
 devicetree@vger.kernel.org, iommu@lists.linux.dev,
 kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, x86@kernel.org
References: <20260318105827.1358927-1-rppt@kernel.org>
 <20260318105827.1358927-4-rppt@kernel.org>
In-Reply-To: <20260318105827.1358927-4-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CB9B8C0009
X-Stat-Signature: cchfehuzo6r6oq5rmscozhsqqf43oo8t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773843424-265305
X-HE-Meta: U2FsdGVkX1//cvmrNRK19PgXVrU3+ygFL4l0mZ/CF9C6RBu59+7+SD24NFd1S8Av0oiytotORaA71z9ZjqvecO45h4/0iPFKXShTc9KUb2/Ki5v4x3d6VBZ1PErd7mCFE+z2q12hH4osQzZOszOML2z+kLvBrUhi+NcIGMzKz3f4TVgTlFPPAsMOLLfWVesJzQ7vCgEG+lSpSBLsoWKxnf/Q57QSd9yht2zrgWvYCXcqISj3J8gAk8hmlVD22KvPsK7QT5JCMqE+QRqrZqhnaTkN1ISHLKZmFr0R0ynL1siTSsvR3JVKFnXWH6IK1p6tRCpjwFON12GXnSvDJ1XISXwpWMj9+UJhdJlpQ4KQ5KkT4sYsktcqBzjCx4hAqonhtCnUdej8xU2EbCxxgUUsR+xta+6McnCnJHG5POMIufKm/oq7h+VVwrW5jyX0vDtFCCiJNr7tbnreUUMXY2CUpV0/qXD5lo3aCH73uJZlB5qcnkdcdyAumBWLK4znIi2wk714rEN57W+aXsr8gQWx8J0Q77FskduTZKhwd/4JiA+2XFsV7UzOKOz6B+Bpf77Q/qruHB/0Ik3yzdq7SeB/Yc9M36rAd4L/+zRIzcJGkhiuBvlPMMil6Zkgz0tAsnMv1q5+lHAg9jkNMxnL7mdbsqTt9GU97JvVkjQ35j9wbofR6IgDnglLvYJanrHxkS8cvLVEmn0OtniJlYLGGqZKmXJTi2h4w0CQJlpsdVhuu03hSAX+D1TXpV1+DnvcFIKEB/YbQvedXZmZaXyEaTq8WQSAjNFdZZOHj0a5+bnFfUB22SwBZ5aAdpQfocp34m50ltEfU3hstanQOh484mQhqj7GCYOSnlL9LuIuh5oTf0hVnNJ8aPq3X+YMEoFISYuNMa79CAJLyrw9tVk5JgmNBsK3k4NAMwJE3vu56LXiaHhCRd6VO/8LwwVQzdCsCekK1QpsXrWuEYAlkUticSw
 bnqEwfbt
 dvpgxxc2eNRpBChTijI1dAlAQvR7Ry3/AY8KexkotPavdp52isjU6TiMX4OgspcR2yxjFvEE1UhPwEO2bRBoZFVOU+cGzcNH1TsCQLUCw0EFtypKvR4TN4l9hJ2wDioHxdZX1I+hwE0MvsnDOW45aHNrePnBTmnAGvMspZ8zsIClRuyFJ2ZgfbD5ZWJ+jkC3kU0eM+jrhEL2c5cRlU5rNGb5LEp4rczrMsPrC+oG73n8YvJI85a+6I92krdwAXEMV98FS2H4P9MaJFVtILa/hUqEEGyJ7vKAEcvfvVpAiyE9znQ1tE3pxw2/tkGhTBW/e37B74Pr+bbnctNcsxr2NJRtsaPagPrxT1lf+/s9jMhs5DrE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 11:58, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> free_reserved_area() is related to memblock as it frees reserved memory
> back to the buddy allocator, similar to what memblock_free_late() does.
> 
> Move free_reserved_area() to mm/memblock.c to prepare for further
> consolidation of the functions that free reserved memory.
> 
> No functional changes.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> ---
>  mm/memblock.c   | 37 ++++++++++++++++++++++++++++++++++++-
>  mm/page_alloc.c | 36 ------------------------------------
>  2 files changed, 36 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index b3ddfdec7a80..8f3010dddc58 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -893,6 +893,42 @@ int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
>  	return memblock_remove_range(&memblock.memory, base, size);
>  }
>  
> +unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
> +{
> +	void *pos;
> +	unsigned long pages = 0;
> +
> +	start = (void *)PAGE_ALIGN((unsigned long)start);
> +	end = (void *)((unsigned long)end & PAGE_MASK);
> +	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
> +		struct page *page = virt_to_page(pos);
> +		void *direct_map_addr;
> +
> +		/*
> +		 * 'direct_map_addr' might be different from 'pos'
> +		 * because some architectures' virt_to_page()
> +		 * work with aliases.  Getting the direct map
> +		 * address ensures that we get a _writeable_
> +		 * alias for the memset().
> +		 */
> +		direct_map_addr = page_address(page);
> +		/*
> +		 * Perform a kasan-unchecked memset() since this memory
> +		 * has not been initialized.
> +		 */
> +		direct_map_addr = kasan_reset_tag(direct_map_addr);
> +		if ((unsigned int)poison <= 0xFF)
> +			memset(direct_map_addr, poison, PAGE_SIZE);
> +
> +		free_reserved_page(page);
> +	}
> +
> +	if (pages && s)
> +		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
> +
> +	return pages;
> +}
> +
>  /**
>   * memblock_free - free boot memory allocation
>   * @ptr: starting address of the  boot memory allocation
> @@ -1776,7 +1812,6 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
>  		totalram_pages_inc();
>  	}
>  }
> -
>  /*
>   * Remaining API functions
>   */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..df3d61253001 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6234,42 +6234,6 @@ void adjust_managed_page_count(struct page *page, long count)
>  }
>  EXPORT_SYMBOL(adjust_managed_page_count);
>  
> -unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
> -{
> -	void *pos;
> -	unsigned long pages = 0;
> -
> -	start = (void *)PAGE_ALIGN((unsigned long)start);
> -	end = (void *)((unsigned long)end & PAGE_MASK);
> -	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
> -		struct page *page = virt_to_page(pos);
> -		void *direct_map_addr;
> -
> -		/*
> -		 * 'direct_map_addr' might be different from 'pos'
> -		 * because some architectures' virt_to_page()
> -		 * work with aliases.  Getting the direct map
> -		 * address ensures that we get a _writeable_
> -		 * alias for the memset().
> -		 */
> -		direct_map_addr = page_address(page);
> -		/*
> -		 * Perform a kasan-unchecked memset() since this memory
> -		 * has not been initialized.
> -		 */
> -		direct_map_addr = kasan_reset_tag(direct_map_addr);
> -		if ((unsigned int)poison <= 0xFF)
> -			memset(direct_map_addr, poison, PAGE_SIZE);
> -
> -		free_reserved_page(page);
> -	}
> -
> -	if (pages && s)
> -		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
> -
> -	return pages;
> -}
> -
>  void free_reserved_page(struct page *page)
>  {
>  	clear_page_tag_ref(page);


