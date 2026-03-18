Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E3A9103E17A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A876B025E; Wed, 18 Mar 2026 10:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EEDE6B0260; Wed, 18 Mar 2026 10:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903586B0261; Wed, 18 Mar 2026 10:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FDE26B025E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:42:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C11161405D7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:42:03 +0000 (UTC)
X-FDA: 84559448526.08.B4CACC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E65A140003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:42:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZweRF6sX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773844922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocQyl5qQ1lVbPqoOrFvESGCrySyf/wu9bjduHpbv378=;
	b=BSM0IiwTa85GHxDj3Ud2qIMhDdyxSQ5PciRnNtnKfNcC3cyeJUSHEnY4cq7FN57mhH84oW
	J2iVRTFaiTh0nDCQjVsghg7kcnCvXmBXJLKfdEW0CHw/rXyNk9m1l4YbAZDv5qs4ZRQ898
	+FhtmOdbIyh+IdZFfdqUANJJXFVqwy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773844922; a=rsa-sha256;
	cv=none;
	b=uItgdpSA8snW8Eos81eLesmyCnL4BvyeQB15dVyZ9DH0qv5i5akPJm4hUWwIE+jMARVM0P
	ODu2VhpfNWBHDbc45ZXZhLO/teZlUr4CGaun27Lkxzt7cT+AIF4B0NPaa3osYlLm846ch8
	lgos0xpaM/0YcdzGn5f0x8gLWrTrQL4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZweRF6sX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21D3C40845;
	Wed, 18 Mar 2026 14:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9775C2BCB0;
	Wed, 18 Mar 2026 14:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773844921;
	bh=gvbA48VpWYkVOPX5lZqPv7gAo3cly3u7OwHMgGbjqZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZweRF6sX91Ge+ftPX9NqiTY3bKofWcnje0RqZ0GXbBGuNjj/FDdce+dSPMd3ciI5a
	 +YJjtTOk0Rp/ZxnvrODXkXmaZyisuc3NsjK2AU9wl/IAQtXxny04zdoPxp98m663Ip
	 pHrKypzwH9lMKMR2KMmjpoQMHW+MEApp4lssb5AQIv/9BPbRHwsehQhxznJsLfeOix
	 48drbi58N196v1dfEm1kwdS0pyVjpZgaxfowuQP6IAf3SAQdLM69+wAHrGRVVEpsOp
	 pt8Rx+Qk/R7cdzyBAfS+KPZ7JLKnZItiewwT7Crw2HI13/Y+NcDzRj/Sd8lx0vZXjU
	 qT81LYKT1xQYQ==
Date: Wed, 18 Mar 2026 16:41:54 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Hubert Mazur <hmazur@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Stanislaw Kardach <skardach@google.com>,
	Michal Krawczyk <mikrawczyk@google.com>,
	Slawomir Rosek <srosek@google.com>,
	Lukasz Majczak <lmajczak@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/execmem: Make the populate and alloc atomic
Message-ID: <abq5ssET4kjny9Y6@kernel.org>
References: <20260317125020.1293472-1-hmazur@google.com>
 <20260317125020.1293472-2-hmazur@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317125020.1293472-2-hmazur@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0E65A140003
X-Stat-Signature: n8x4jnfpx9f1nxj3n5xxdckk5qu4mqtd
X-Rspam-User: 
X-HE-Tag: 1773844921-794761
X-HE-Meta: U2FsdGVkX18SntwDAgnemdvS2u/fs5MzJj01EKpgdpZBXSvhQ9kGUrGpvA6zv7zdQeyaeyYDmMOpQTel5bIfkYNAF4oRyJlbf9aU05Du61yW1dXTNAVRhzL0yGdD6fG+SpKfUd0rKqmOcp+NFlHYXbesbT1vqEBb+PbxgP7yNn2TaootI9jEMcgVGSIH3YKgGPM5BXIQacSGrNdI6sSkj+QjwyeJ/eqj3UTbCMhxYD4DxxgLCDBW0IYZ8cg0lMYBVyNDuQ3Z08uTZs6DDhMKxSeni+eOKwOAonAsHCsIhbv11lRy4/Vt/izwJ0YCjayJK9284wwvQZbe8K5sQM8STguFGQvR849wbnqOS/hFJjGJMh3uyHtBRY4eva5bu+qJDUZmDjd9cpEhnpUOrKw/UfpZLTqMqTcENpgOXzoEAgylouBtxAK9KuoFo8b1evlhhpsLrZzVhmyMW+dil7QFLmeYfkuvyr66qAGeW5ocHSvMUENPuQEV7+7yJsY3Zrs9CbZ8Byy/am/JwdZ823t6aS7Xw3wGSy+aotM7+86GwnWdYzAelh/LSUNrQNvu8+tATZvXr6Q7G/82LwxHi6sImOEurEbqkcIHjTosDlnV4tAFrBaU21LeboW8sZpGzcXbbu4nWRAYaNKSWbtr38bdvYv8JHA40NfyYVUSrnLIR/pz4VFm9Nv5WJI9XPXDPsWd7PiZgnrfTOxY5PBP4U0t63IuRBob+14CmMapieXgV9+6RUEJTuuSBhHN4KYPXhP7GHAPMucXdzUvfz60pJFD+kN/qaAgq7tVo/pavXclHRiY8gXnZUqT4wKimm0W5ix4f+uQZuw+5/vRJbsLTcxzDZEe6AjCt6jIwCG+ZxRhBxMPIDPq0+wh6KganJMXLT30IrIOI3lXgQonRCSRGtyK4pn70ueeWFmEsgkz+QmvQUMzWjO/eop+GiKbGPfhP6ilwRMkZk++wRN8crXGc5Q
 IMXnRgNe
 CtwvAJ30+SdQ6afwlnvHAd15qZkDQIFevUT5UGX+Jta/KN1BhWGcWDz7nhB/MLnzvolv0YTOjSKQYKyrwn7d2jmyYtEqEP3ARWXofMrLz0uFLGE6C6cpJR2yuKZIcqCT/KRu2YY1UW7YTUXeiLyTcep+W9Ds0UAyWjNz1jgRIBrnvOq5R7Tu9BpQYMAu1ecxmczx+2MGLdfMsSrv332BVSSDpHD9trwd348a+4a+uxlEBgHi3c7AYh2EDJABg6IB8KBIpcDjc59596+88bZPcPKvFnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hubert,

On Tue, Mar 17, 2026 at 12:50:20PM +0000, Hubert Mazur wrote:
> Subject: mm/execmem: Make the populate and alloc atomic
>
> When a memory block is requested from the execmem manager, it tries
> to find a suitable fragment in the free_areas. In case there is no
> such block, a new memory area is added to free_areas and then
> allocated to the caller. Those two operations must be atomic
> to ensure that no other memory request consumes it.
> 
> Signed-off-by: Hubert Mazur <hmazur@google.com>
> ---
>  mm/execmem.c | 61 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 34 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 810a4ba9c924..9043f0f8f61a 100644
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
> +static void *__execmem_cache_alloc_locked(struct execmem_range *range, size_t size)

No need to keep prefix underscores here.

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
> +	return __execmem_cache_alloc_locked(range, size);
> +}
> +
> +static void *__execmem_cache_populate_alloc(struct execmem_range *range, size_t size)

No need for leading underscores here as well.

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
> @@ -307,33 +304,43 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
>  	if (err)
>  		goto err_free_mem;
>  
> -	err = execmem_cache_add(p, alloc_size, GFP_KERNEL);
> -	if (err)
> +	/*
> +	 * New memory blocks must be propagated and allocated as an atomic operation,
> +	 * otherwise it may be consumed by a parallel call to the execmem_cache_alloc
> +	 * function.
> +	 */

Please keep the comment lines under 80 characters.

> +	mutex_lock(mutex);
> +	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
> +	if (err) {
> +		mutex_unlock(mutex);
>  		goto err_reset_direct_map;

Please add a new label that will unlock the mutex and goto to the new
label.

> +	}
>  
> -	return 0;
> +	p = __execmem_cache_alloc_locked(range, size);
> +	if (!p) {
> +		mutex_unlock(mutex);
> +		return NULL;

This if is not needed, we anyway unlock the mutex and return p, if
__execmem_cache_alloc_locked() failed p would be NULL anyway.

> +	}
> +	mutex_unlock(mutex);
> +
> +	return p;
>  
>  err_reset_direct_map:
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
> +	return __execmem_cache_populate_alloc(range, size);
>  }
>  
>  static inline bool is_pending_free(void *ptr)
> -- 
> 2.53.0.851.ga537e3e6e9-goog
> 

-- 
Sincerely yours,
Mike.

