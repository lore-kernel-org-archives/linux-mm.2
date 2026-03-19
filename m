Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 449A51075270
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A6C6B00D5; Thu, 19 Mar 2026 13:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761B46B00E0; Thu, 19 Mar 2026 13:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FF86B00E7; Thu, 19 Mar 2026 13:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 591D76B00D5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:19:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1768213B6E3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:19:25 +0000 (UTC)
X-FDA: 84563473890.23.79C5552
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6E3B51A0007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:19:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b+wzekxD;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773940763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPxeA7UEwEAYOk9ri8DSAFM20l68K0j8KZqIRa7ecgc=;
	b=0WBSLtjtqWQdSRRM+IHCnmLeeCf+QfYg8mOnR2VN6a1fDwvcVjzdYNOOjqEoa0zLnXd7Fz
	5ODb3ctVVbsm06IqruTxJfk0Cy0bPl+JKK7h1viTFAAgVB326zjQBRRpuA6/2uEzTxvPOL
	0VKRVFJ/VcHuZgs2sPneCyQKku0pCTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773940763; a=rsa-sha256;
	cv=none;
	b=MaWl0qoiG/dniBdPURCi/My0ZccWgBxUsHVf2bInE3udQte16NheoszEy/Lk/xk5eahNsg
	JCCBWoa3zdnGeC81L7X4B11nUeVTGJXVIGSZAg16QhMgC/rHBUmA9jeaXK0zzOP/lAWMTe
	Yr/XozNEeDSwOkOhcX7ZpcHoSpoQKMs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b+wzekxD;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D489360097;
	Thu, 19 Mar 2026 17:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805AAC2BCAF;
	Thu, 19 Mar 2026 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773940762;
	bh=CRe67mkIC0ESRXKT0XqoUIZu/d4VKlx16OMwh4bOfWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b+wzekxDzyYGWpd8oVd26XrZqlejzgkU5gHUwgEyk3UYBxVd1s3wxcoofE4uru0/G
	 CkPW70WWc8Eai1R55nSb480qEWmyHlvjuKhGSnQbQtXIFNFfAwCzPyQdKI8hvzSgGJ
	 EE/pcfqqJiY4TRtY6NVBktWL12FERYck2tbIvp1Mp8ImeSyMa0gkSbHvJ2e5bz7OR9
	 JaA3JPmxCdxGWQWSruKgN/SV8VsHrodfZTNv/R05Y0PsYJHmGptKtHAQhWUPAEElXo
	 DWiAnoDhU/Bn29O5cXMPK3OiNrnocQCKss2Bh9QJz8cC44uDSq+p73TG7gEgyag0n/
	 c1OsrJZNMKkyg==
Date: Thu, 19 Mar 2026 19:19:15 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Hubert Mazur <hmazur@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Stanislaw Kardach <skardach@google.com>,
	Michal Krawczyk <mikrawczyk@google.com>,
	Slawomir Rosek <srosek@google.com>,
	Lukasz Majczak <lmajczak@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/execmem: Make the populate and alloc atomic
Message-ID: <abwwE-yFTFHC8CMZ@kernel.org>
References: <20260319085907.3510446-1-hmazur@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319085907.3510446-1-hmazur@google.com>
X-Stat-Signature: 89pxfcju59mo5nercu8nj4zii7c1by46
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E3B51A0007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773940763-531562
X-HE-Meta: U2FsdGVkX19ip3tqFJiQFjZnZkCH+tCqZjtl8kGjph6syeL23LeG9UbZPrvmPaUEVHNnu/dWpkFu0Yc1AnGWzT5RzjczpcLDWppVpT6x3vFDV6JY7R4R4OGW0/b7nE+Q5WkE7//KTdxcxUbw43tqdJAGRIz046PDclzjQ7PHnzUyGe7WGIPZf0q2iqY6KFNyxPbxUzNF3dGAwuRlYauST02DzIxjLeitKWRMKHgjfecTYAbqFSg6vws/zaDXitVa33R9wlGC9D6vrGZG7xOtglCZMcbxU/IIvcTuunr1xYNFvQHhhdZV/jcFnOXlig90FhOJsGkUF90iA3fZSrPIhYFC6fgE9zUBDht84+GrfiMgSLINqPm0GK/rNnK9tLnWJLODWFQ9DKBJJYVYfC3sYs5fSwjxBN+n/hyGR3aLZAk+ZCB6NUVCUANNWMz1ayIeaFS62fktIkA/kj3tJIgcvhCmqyeWg8EKMEqn73sUbLzJynBEYsy1ikfAg9RHZUbpAT+4wiA/LOpDHZb+AISl6DVMTl18rPQOIREwajBh4oesV/mltSoNUh6xTM1av564OayPlCd+f3lL0tCwuBPRa+d+l0jWh/nKaMIiWlYmpeCwoMUItGbL8lvmMvwXKI/KkNqxZM9k7ZMUo+j1yAOORkedKcOBtDn0TBMM/0qXq2uW+EKJ4h3JISKvzwZ02enKSm/DjSntoWI2xFcI77StGGF1lvivM/UzKcwF/KMOYOyme0NoWjZbKRv4BWfhLrCbATA4HWuBviT5Qcrsgz5OV17xyNpBnQvtVbgLt87TClE1BybjryO36xVsu0YDb4P+r32Sy+cOsKaGT/bd27hBaqTutHD1asMrHpf+HCbfMKS0xTdCzRDOh87TTiM5fkBq5NFLQCP9IFf4YC9717XncTZ23Z0wicXp3zeZoemn1JzKzI/UcObZy3PzAc5JdEs6v1faG0YaGwxmn6HZfNZ
 kpOrCRCK
 GxjkQWzSkc8jr17jaPB7wzgv3ROare2z72hguJhm+GtDAhb+VPp/mTD0v4DuoXZcjWFaF/1+/ZCCTySJvb09c93yNONcAPm0Re47bQtuoyJDj2jGsarVovrq5f7dXQJuku+DDkrJYicHWP7/QW+nSuhJlQ/W0iz0yFJXnUhUREU8ONToLLT56MbftKogncUO6o/Q5jyJo81qOZ4MSNSlSkLoek0jmX/xlvO3Om4hNizBr3BjsiaWqFmvssSXG6Kpo4M0yZgYucdG0qYGSGIT3ddWEkrhn3Ui4lc1SMz0ipbI8rWsrKSZRzCG1retT36sOl1/EXAUzeGFAv+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 08:59:07AM +0000, Hubert Mazur wrote:
> When a memory block is requested from the execmem manager, it tries
> to find a suitable fragment in the free_areas. In case there is no
> such block, a new memory area is added to free_areas and then
> allocated to the caller. Those two operations must be atomic
> to ensure that no other memory request consumes new block.

Sorry if I was not clear, the motivation for the patch you had in the
cover letter in v2 should have been put in the commit message rather than
completely dropped.
 
> Signed-off-by: Hubert Mazur <hmazur@google.com>
> ---
> Changes in v3:
> - Addressed the maintainer comments regarding style issues
> - Removed unnecessary conditional statement
> 
> Changes in v2:
> The __execmem_cache_alloc_locked function (lockless version of
> __execmem_cache_alloc) is introduced and called after
> execmem_cache_add_locked from the __execmem_cache_populate_alloc
> function (renamed from execmem_cache_populate). Both calls are
> guarded now with a single mutex.
> 
> Link to v2:
> https://lore.kernel.org/all/20260317125020.1293472-2-hmazur@google.com/
> 
> Changes in v1:
> Allocate new memory fragment and assign it directly to the busy_areas
> inside execmem_cache_populate function.
> 
> Link to v1:
> https://lore.kernel.org/all/20260312131438.361746-1-hmazur@google.com/T/#t
> 
>  mm/execmem.c | 55 +++++++++++++++++++++++++++-------------------------
>  1 file changed, 29 insertions(+), 26 deletions(-)
> 
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 810a4ba9c924..4477bb9209ab 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -203,13 +203,6 @@ static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
>  	return mas_store_gfp(&mas, (void *)lower, gfp_mask);
>  }
>  
> -static int execmem_cache_add(void *ptr, size_t size, gfp_t gfp_mask)
> -{
> -	guard(mutex)(&execmem_cache.mutex);
> -
> -	return execmem_cache_add_locked(ptr, size, gfp_mask);
> -}
> -
>  static bool within_range(struct execmem_range *range, struct ma_state *mas,
>  			 size_t size)
>  {
> @@ -225,18 +218,16 @@ static bool within_range(struct execmem_range *range, struct ma_state *mas,
>  	return false;
>  }
>  
> -static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
> +static void *execmem_cache_alloc_locked(struct execmem_range *range, size_t size)
>  {
>  	struct maple_tree *free_areas = &execmem_cache.free_areas;
>  	struct maple_tree *busy_areas = &execmem_cache.busy_areas;
>  	MA_STATE(mas_free, free_areas, 0, ULONG_MAX);
>  	MA_STATE(mas_busy, busy_areas, 0, ULONG_MAX);
> -	struct mutex *mutex = &execmem_cache.mutex;
>  	unsigned long addr, last, area_size = 0;
>  	void *area, *ptr = NULL;
>  	int err;
>  
> -	mutex_lock(mutex);
>  	mas_for_each(&mas_free, area, ULONG_MAX) {
>  		area_size = mas_range_len(&mas_free);
>  
> @@ -245,7 +236,7 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
>  	}
>  
>  	if (area_size < size)
> -		goto out_unlock;
> +		return NULL;
>  
>  	addr = mas_free.index;
>  	last = mas_free.last;
> @@ -254,7 +245,7 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
>  	mas_set_range(&mas_busy, addr, addr + size - 1);
>  	err = mas_store_gfp(&mas_busy, (void *)addr, GFP_KERNEL);
>  	if (err)
> -		goto out_unlock;
> +		return NULL;
>  
>  	mas_store_gfp(&mas_free, NULL, GFP_KERNEL);
>  	if (area_size > size) {
> @@ -268,19 +259,25 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
>  		err = mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
>  		if (err) {
>  			mas_store_gfp(&mas_busy, NULL, GFP_KERNEL);
> -			goto out_unlock;
> +			return NULL;
>  		}
>  	}
>  	ptr = (void *)addr;
>  
> -out_unlock:
> -	mutex_unlock(mutex);
>  	return ptr;
>  }
>  
> -static int execmem_cache_populate(struct execmem_range *range, size_t size)
> +static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
> +{
> +	guard(mutex)(&execmem_cache.mutex);
> +
> +	return execmem_cache_alloc_locked(range, size);
> +}
> +
> +static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
>  {
>  	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
> +	struct mutex *mutex = &execmem_cache.mutex;
>  	struct vm_struct *vm;
>  	size_t alloc_size;
>  	int err = -ENOMEM;
> @@ -294,7 +291,7 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
>  	}
>  
>  	if (!p)
> -		return err;
> +		return NULL;
>  
>  	vm = find_vm_area(p);
>  	if (!vm)
> @@ -307,33 +304,39 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
>  	if (err)
>  		goto err_free_mem;
>  
> -	err = execmem_cache_add(p, alloc_size, GFP_KERNEL);
> +	/*
> +	 * New memory blocks must be propagated and allocated as an atomic

Nit:                               ^ allocated and added to the cache

> +	 * operation, otherwise it may be consumed by a parallel call

                               ^ they

> +	 * to the execmem_cache_alloc function.
> +	 */
> +	mutex_lock(mutex);
> +	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
>  	if (err)
>  		goto err_reset_direct_map;
>  
> -	return 0;
> +	p = execmem_cache_alloc_locked(range, size);
> +
> +	mutex_unlock(mutex);
> +
> +	return p;
>  
>  err_reset_direct_map:
> +	mutex_unlock(mutex);
>  	execmem_set_direct_map_valid(vm, true);
>  err_free_mem:
>  	vfree(p);
> -	return err;
> +	return NULL;
>  }
>  
>  static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
>  {
>  	void *p;
> -	int err;
>  
>  	p = __execmem_cache_alloc(range, size);
>  	if (p)
>  		return p;
>  
> -	err = execmem_cache_populate(range, size);
> -	if (err)
> -		return NULL;
> -
> -	return __execmem_cache_alloc(range, size);
> +	return execmem_cache_populate_alloc(range, size);
>  }
>  
>  static inline bool is_pending_free(void *ptr)
> -- 
> 2.53.0.851.ga537e3e6e9-goog
> 

-- 
Sincerely yours,
Mike.

