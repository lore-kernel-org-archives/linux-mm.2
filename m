Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D19BCCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BAC28E002A; Wed, 17 Sep 2025 10:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3926B8E0003; Wed, 17 Sep 2025 10:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF918E002A; Wed, 17 Sep 2025 10:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB0B8E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:27:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB4A3BA150
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:27:49 +0000 (UTC)
X-FDA: 83898971058.01.73F232C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1FFB8C000D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:27:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VRhST95e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758119268; a=rsa-sha256;
	cv=none;
	b=xrycP/ddLeDQwOidY7yhzwCsrNm+uFib7jYZfyZWkk7eYIqUdNOttJ5dhg2DJjFeu8hxj3
	+BUTuyqawYyicOuXpBbZO7CJCWtdEbOVmJnzcGvBk7Blq8cq8oZmX/7kasmoGRzS9GQd0a
	+rztwsQSlE1ZpZzg92fGrT9jVx/1MMo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VRhST95e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758119268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2F1whqw3f8oSfwZw5QkxhptwD3fG5ea5Q8QE4Ni/oE=;
	b=jxfgzA97kFw+OY+hGi8HYOoK2iPm3pyhyL/hQOsmXYe3safuNEEt3hrawcOMuuyD8gHxcu
	ynB7v9DlACgIhOtYooHMYEeY9B8nq8A4+8hAK8O6IZuzAvaszLHKIpBqUX8uLhJyKDKSDV
	9T2BxeVq9axl4KORaaPB7pnPtFWOAKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84C69601ED;
	Wed, 17 Sep 2025 14:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF49C4CEE7;
	Wed, 17 Sep 2025 14:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758119267;
	bh=/EeIQi0ansmbb7h7cdFJIsa+CD2IvLgTaCfE6ZaIlxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VRhST95e6M0ImbIkRf5j2AWy3ejUWuNIjebo0Vt5MgW06Upoza4JsMhq27JsHn87h
	 yKsPubiKosrsh2UtkoE3UBwZpfyR0LGuOX7YdXCPVJpxq0Ob4OqZGNn08bkEjo1q+x
	 2gyHdVlX/zSQmvXVJs3gWIU59dKdulFyf3wG0CKQct2Ql/jg71r+KX3AK9noMREomn
	 2mDHcEa8IHiKzxJ0/hgs4GCC1spb4cBkSykP3thbZlneN5IaTzXevesTClml/8oRio
	 ntlD4I58un7kW10VNqX1FvWuV7OPi6imYkRWWiCDcupgRQ77X11nIAJ1OtVwacduZz
	 1K8D2iqyPVcew==
Date: Wed, 17 Sep 2025 17:27:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, david@redhat.com, vbabka@suse.cz,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, elver@google.com,
	dvyukov@google.com, kasan-dev@googlegroups.com,
	Aleksandr Nogikh <nogikh@google.com>
Subject: Re: [PATCH v1] mm/memblock: Correct totalram_pages accounting with
 KMSAN
Message-ID: <aMrFXOTrlcgPhqjo@kernel.org>
References: <20250917123250.3597556-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917123250.3597556-1-glider@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1FFB8C000D
X-Stat-Signature: p1imwgpg9ya8swa56ihhqf8qgwx4r3rb
X-Rspam-User: 
X-HE-Tag: 1758119267-291882
X-HE-Meta: U2FsdGVkX19uLel6D1MT2l6qMKHZRSOSpedtpcQAWY3IZ/vkUJY76Sp+cnBLxY4fWPCbei67vBbQNsHdXk/psYAIAPw0fo4V+GJYNSx5hS4FPeMHbuAxHIKBseWu90rONduo7jMaZvzCdJvY0rfS894sNSDISXFaXqxkYvKKtNONuekpBfZuJqJGZ3Ep4Jpa8Fh0aZkCjlDEMTXkSsW+sLswwy8j2Q1dEMazVSF9JJGYEo0NmGa4yLHpeb5+gzg33p98pfpLGPO6+dbzhh7JEBH6/Qu3pIiXdQ3Usaj2qQuGWEokj/CNa+HxV83IyET4J+2DMe0rHRtXrt9LlIBrTWJsKjx0zpQq3nHneDXcaK2w4tLJAhxYeNWZFjpSdlhFKzEbBO6gi5izEtJcLfjuh0tIT4geBY6gptVU8bDoT3LSfi/z2iVQ7vKfjTi7BxFrYpoDNQm9oubD23ndKmRBZEK667nSMoZB9SSLJZ9UOSRdthN2yduN/NHUlgOJTXrtw8xcZlBeaJm/UfJrZqhKp9oJU3Pjz6ySXGBJPzsrBipda5kroZgyIg4bcJxGXVx27mg7S/0HdQn2cAzLM2ZRVe3QE4PiN01XwgoRGmNEgJowme4dDv5ZqV3UooocCp7l8w6mlZgcKcflfP735p50GRYLq1VwGy6M8WXhfjmwxYXmSEQ7/4Yxki3rjP8eb+ZNcYPcVkdfJHbDLxN9lQrVTZzNWf8yPDbiXTZ+WtT6D3TFWGdma141trJfQDtPStztQH5edS+H2s9gOvd0L4uDM52MdQ2Hiqb7hu5smpgnDFx8rwrNbugoBUsVxFi3C9tLS9nw/9CfDYHZmyGzGr9HfOwBEfKwZdX0VEe+N15JtNLrdHlZ60guziCa1CgQB6XFCjpVSRwlICwzTrv2omXjph20meGwqd8xdCsnCywsGIMsc6dnce46PsOHuKqBtb6DcemFRe11OgtK2IsMykp
 wVd3+x2b
 SWclshLyWLwJMB2urO7ODaKf6Bs1fqC+pSrWSQ+Db9LWeFfhxuxO9oOY7iKcbsgArZrQLTAZ6TnmOceC9iYaQyVqSa4HDmFD7MOCFrsMMDyD0zVdZl4w0SVsw6wzE70+JFxr7tlmEYC1w4mD4nyizXwJITlZdG4gzZUEZblbDBFIUCUSWFFXbG9G/pvvw1NWxbiyS9WDbcNk/SbRC0FpFkQ58ZskK7W7lUiluoweijb/Jf4iqPhKMI6HiOwFthrsXuatxmz3q4LauTds9YmxqaAGmlgOznCjNFqEc2YbBuCfvX30XqW9nfoi2UTFzYSgLljCq4nR4g6Bo8EQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 02:32:50PM +0200, Alexander Potapenko wrote:
> When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
> for metadata instead of returning them to the early allocator. The callers,
> however, would unconditionally increment `totalram_pages`, assuming the
> pages were always freed. This resulted in an incorrect calculation of the
> total available RAM, causing the kernel to believe it had more memory than
> it actually did.
> 
> This patch refactors `memblock_free_pages()` to return the number of pages
> it successfully frees. If KMSAN stashes the pages, the function now
> returns 0; otherwise, it returns the number of pages in the block.
> 
> The callers in `memblock.c` have been updated to use this return value,
> ensuring that `totalram_pages` is incremented only by the number of pages
> actually returned to the allocator. This corrects the total RAM accounting
> when KMSAN is active.
> 
> Cc: Aleksandr Nogikh <nogikh@google.com>
> Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
> Signed-off-by: Alexander Potapenko <glider@google.com>
> ---
>  mm/internal.h |  4 ++--
>  mm/memblock.c | 18 +++++++++---------
>  mm/mm_init.c  |  9 +++++----
>  3 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 45b725c3dc030..ae1ee6e02eff9 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -742,8 +742,8 @@ static inline void clear_zone_contiguous(struct zone *zone)
>  extern int __isolate_free_page(struct page *page, unsigned int order);
>  extern void __putback_isolated_page(struct page *page, unsigned int order,
>  				    int mt);
> -extern void memblock_free_pages(struct page *page, unsigned long pfn,
> -					unsigned int order);
> +extern unsigned long memblock_free_pages(struct page *page, unsigned long pfn,
> +					 unsigned int order);

No need for extern, the inconsistency is fine here.

>  extern void __free_pages_core(struct page *page, unsigned int order,
>  		enum meminit_context context);
>  
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 117d963e677c9..de7ff644d8f4f 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1834,10 +1834,9 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
>  	cursor = PFN_UP(base);
>  	end = PFN_DOWN(base + size);
>  
> -	for (; cursor < end; cursor++) {
> -		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
> -		totalram_pages_inc();
> -	}
> +	for (; cursor < end; cursor++)
> +		totalram_pages_add(
> +			memblock_free_pages(pfn_to_page(cursor), cursor, 0));
>  }
>  
>  /*
> @@ -2259,9 +2258,11 @@ static void __init free_unused_memmap(void)
>  #endif
>  }
>  
> -static void __init __free_pages_memory(unsigned long start, unsigned long end)
> +static unsigned long __init __free_pages_memory(unsigned long start,
> +						unsigned long end)
>  {
>  	int order;
> +	unsigned long freed = 0;
>  
>  	while (start < end) {
>  		/*
> @@ -2279,10 +2280,11 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
>  		while (start + (1UL << order) > end)
>  			order--;
>  
> -		memblock_free_pages(pfn_to_page(start), start, order);
> +		freed += memblock_free_pages(pfn_to_page(start), start, order);
>  
>  		start += (1UL << order);
>  	}
> +	return freed;
>  }
>  
>  static unsigned long __init __free_memory_core(phys_addr_t start,
> @@ -2297,9 +2299,7 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
>  	if (start_pfn >= end_pfn)
>  		return 0;
>  
> -	__free_pages_memory(start_pfn, end_pfn);
> -
> -	return end_pfn - start_pfn;
> +	return __free_pages_memory(start_pfn, end_pfn);
>  }
>  
>  static void __init memmap_init_reserved_pages(void)
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 5c21b3af216b2..9883612768511 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2548,24 +2548,25 @@ void *__init alloc_large_system_hash(const char *tablename,
>  	return table;
>  }
>  
> -void __init memblock_free_pages(struct page *page, unsigned long pfn,
> -							unsigned int order)
> +unsigned long __init memblock_free_pages(struct page *page, unsigned long pfn,
> +					 unsigned int order)

Please either align this with 'struct' or drop spaces and keep only tabs.

>  {
>  	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
>  		int nid = early_pfn_to_nid(pfn);
>  
>  		if (!early_page_initialised(pfn, nid))
> -			return;
> +			return 0;
>  	}
>  
>  	if (!kmsan_memblock_free_pages(page, order)) {
>  		/* KMSAN will take care of these pages. */
> -		return;
> +		return 0;
>  	}
>  
>  	/* pages were reserved and not allocated */
>  	clear_page_tag_ref(page);
>  	__free_pages_core(page, order, MEMINIT_EARLY);
> +	return 1UL << order;
>  }
>  
>  DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);

-- 
Sincerely yours,
Mike.

