Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D17C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 03:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C0A6B008A; Tue, 22 Sep 2026 23:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15176B008C; Tue, 22 Sep 2026 23:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD096B0093; Tue, 22 Sep 2026 23:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0DB6B008A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:39:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDA23A675A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:39:34 +0000 (UTC)
X-FDA: 85243622268.17.427CA92
Received: from mta1.migadu.com (out-242.mta1.migadu.com [95.215.58.242])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7FFCD1C0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:39:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ABB4USa2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.242 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790134773;
	b=L4Flg7Q6lz4nv/L03DB1sd0K1AanA7QR2HtusZdgLdW+SNfJlT8rxl64YPvs+Tb7+r/rY2
	Q9KWcvTJgYBjfX3IqXPaN4IHABkLSitddYeBa5qFOAWDiOEUenQwHvKrxvqyXwkem+GxHf
	w5YKQf5ko87NRAUy9teNe4Jqa+BJnOs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ABB4USa2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.242 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790134773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TptEs3dVH890tylyf3i/qImne671caOdboC4cbmfnM=;
	b=2//oeWrSME6+K9jFsu6szqOcwFgJpLkRxqJuHNSn6eBrj1FFKa8ZlT12K/S9dn/6JgVLd7
	mCSs1pH8dlNyEOdpZe1WHkioL+RW587EbksgoIV2XnsdxFPxT5jtQbaOHPKG04E1LtBtSa
	kLIxUs82s4VYG0KGGjXd5D3VBEV68Ks=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QY8AVjCbcaW+wVLRtHjQxzMTz4h9U9+ldEP+b+H2GcE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790134770; v=1; x=1790739570;
 b=ABB4USa2vu6w6QWM6kEX42ZQQoHM9Gxuc2x9l0bTvGcQKklfXHgbDlXtCcBNUl4++CITb+Ln
 7zU8QcXZBNXjlHBsecDtE5ZQBSzqYr4npPnyBnbjWnjVo+Rfxx18VXtakgOhYCQulJi5SS1q3CH
 EmUa6xXOFyz5urVSgh7eXN7w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e2387b4930517eb3;
	Wed, 23 Sep 2026 03:39:30 +0000
X-Mizu-Trace-ID: e2387b4930517eb3
X-Migadu-Flow: FLOW_OUT
Message-ID: <19136e23-3af6-4bf5-93cf-46bb1dc46c08@linux.dev>
Date: Wed, 23 Sep 2026 11:39:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/vmalloc: fix vmalloc_dump_obj cross-zone VA
 lookup
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Walmsley
 <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
References: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
 <20260921-vmalloc_dump_obj-v2-2-73fceb3ed1c8@linux.dev>
 <arJ4PLGlF7uhNWOs@milan>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <arJ4PLGlF7uhNWOs@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: o1mhc9ypmwwpf77p37eg4skajpzdpqoy
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FFCD1C0002
X-HE-Tag: 1790134772-163371
X-HE-Meta: U2FsdGVkX19AM/cGdVuenjFzyTWryc1xtsls/ewrib4MtdkTT0t48PN9F15Qq71/RmN3gCvhwQWwOAT9e70vy+Ch8y3zGsgaI1aCx901nNnisK17UHuob41Aob1IXR96YXjoBNWWgr+YZJHSOm++SdYKihYkYd77WoIcYw2w+Bwlb+zjq286a3bBI6BIxoJ2gZy5htnTjEsngwf8CSNP3H9wo7avvT6xHjz/FGiyw9o4M/Ss1QfDxMiS18sQ9Lk6onXvscuphBWNJw3bd2xgdLoyDjORQapJCh4tdH+r4MbOUW0q8JnawbpO2K6GbV8OvLGtWmdafHjbwsp5b2arCex0r1vROFfzpw36NpnceQOmnHLWjs+DMwlcJdPZyNKirFu1qB3vxXX5m8gHXMzef6QjeAdf+YADeiSw1K4+T8oYwVP2dHg2cy8cboztyzmv+N/Gv4jqtv+wQ6DJtKTMCQDRAKtG4MSh8J5iLnnLbvVRRiU5OiQAiqmzPCh/eSXHV3dHGdlphtP/jQnrBJKNnIoTluW+fSca7K7dnAfaDVPqrWqNq7lNE5jBP+fNRXvH63kqk3CJFPo8/s9env8C2i3mWph5AocxaEe4HZOUgdndvR8SgBMNHeEkbegOgH48DO9AUjhYDJxeOV6gaIJsSKibvVTkdaiWm2ClBmKBS4QpOidiOIBuIzmmgjODhgKnTHvpdHXOICuHho+PmYevMWodPOF9YNGE49jfUvmw6u3g4/KExB69jKlQiAIAhF8M0sQMNoT3CeP6pEXstgGelnR72MQSwxw3lYpYXjyW43ZOksfQa5hhevlejcbWxRSuK5xOiw4AJ84cVjaTyFx1unB+cOCkwgons3sS1/YSoQS6t7lkUBH0LtCLsotWolQpZgYB+RznqAPvQT0rbp4lBWu56y9b5+ice+TR+4FSP/X7sUxJfEeqOnLwFWxeIsmoZa4goIaa+1Om6yNMeRE
 NYNNtK9p
 JmDMYwijHiV9YpadMonJkvn3pWjy21znNtWlY/sxrhfsxXsiY8/5pfnCNePr6w9sFxImYdnWHNgySvshegcJDdNBr+eiLnlGYD2mFMrWL/kD9p8Ohm5/NTDImAda0npmtpnBrkgbrpFQfUCEwzHm9+jLehG45qKLrmFuSzBwTG7KlqqcXQ/7tUPRkIJfHZd+q13EKUie/BAQUAvV4B0y+pbgIVd+d4prBH4Hw1rYoM8EzC16NgmMiQdc/nfQQK1onU03uBEYw91j0pcqV7gGlLxqZ2+wXamJ0KVRX/H0KfT2n5c+0pSiq11OACM53iTbnVsvU1JnqTw3ugV8nvPwu+dBYfWrGzdCUUtnw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/22 20:44, Uladzislau Rezki 写道:
> On Mon, Sep 21, 2026 at 09:17:22PM +0800, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> vmalloc_dump_obj() searches only one vmap node (addr_to_node(addr)),
>> but a vmalloc allocation may span multiple vmap zones.  The VA is
>> stored in only one node's rb-tree (addr_to_node(va_start)), so an
>> object pointer in a different zone than va_start maps to a different
>> node and the search misses.  This affects any allocation larger than
>> vmap_zone_size (64 KiB) on multi-CPU systems.
>>
>> Iterate all vmap nodes using for_each_vmap_node, like find_vmap_area()
>> does, but with spin_trylock instead of spin_lock as this function can
>> be called from atomic dump contexts (OOM, KASAN, RCU).
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/vmalloc.c | 24 ++++++++++++++++++------
>>  1 file changed, 18 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index df42d8a6f058..30c610f678dc 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -5278,17 +5278,29 @@ bool vmalloc_dump_obj(void *object)
>>  	unsigned long nr_pages;
>>  
>>  	addr = PAGE_ALIGN_DOWN((unsigned long) object);
>> -	vn = addr_to_node(addr);
>>  
>> -	if (!spin_trylock(&vn->busy.lock))
>> -		return false;
>> +	/*
>> +	 * A vmalloc allocation may span multiple vmap zones, so the
>> +	 * node whose rb-tree holds the VA may differ from the node
>> +	 * the address maps to.  Search all nodes.  Use trylock as
>> +	 * this function can be called from atomic dump contexts.
>> +	 */
>> +	va = NULL;
>> +	for_each_vmap_node(vn) {
>> +		if (!spin_trylock(&vn->busy.lock))
>> +			continue;
>> +
>> +		va = __find_vmap_area(addr, &vn->busy.root);
>> +		if (va && va->vm)
>> +			break;
>>  
>> -	va = __find_vmap_area(addr, &vn->busy.root);
>> -	if (!va || !va->vm) {
>>  		spin_unlock(&vn->busy.lock);
>> -		return false;
>> +		va = NULL;
>>  	}
>>  
>> +	if (!va)
>> +		return false;
>> +
>>  	vm = va->vm;
>>  	addr = (unsigned long) vm->addr;
>>  	caller = vm->caller;
>>
>> -- 
>> 2.25.1
>>
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 89c327a6ce7d..3719dc02dcaf 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2511,7 +2511,22 @@ static void free_unmap_vmap_area(struct vmap_area *va)
>  	free_vmap_area_noflush(va);
>  }
>  
> -struct vmap_area *find_vmap_area(unsigned long addr)
> +static inline int next_vmap_node_id(int i)
> +{
> +	return (i + nr_vmap_nodes - 1) % nr_vmap_nodes;
> +}
> +
> +enum vmap_lock_mode {
> +	VMAP_LOCK,
> +	VMAP_TRYLOCK,
> +};
> +
> +/*
> + * Add a comment here.
> + */
> +static struct vmap_area *
> +find_vmap_area_lock(unsigned long addr, struct vmap_node **locked_vn,
> +		enum vmap_lock_mode mode)
>  {
>  	struct vmap_node *vn;
>  	struct vmap_area *va;
> @@ -2534,16 +2549,40 @@ struct vmap_area *find_vmap_area(unsigned long addr)
>  	 * addr is within 2 or 0 nodes we should do extra work.
>  	 */
>  	i = j = addr_to_node_id(addr);
> +
>  	do {
>  		vn = &vmap_nodes[i];
>  
> -		spin_lock(&vn->busy.lock);
> +		if (mode == VMAP_LOCK) {
> +			spin_lock(&vn->busy.lock);
> +		} else {
> +			if (!spin_trylock(&vn->busy.lock))
> +				continue;
> +		}
> +
>  		va = __find_vmap_area(addr, &vn->busy.root);
> +		if (va) {
> +			*locked_vn = vn;
> +			return va;
> +		}
> +
>  		spin_unlock(&vn->busy.lock);
> +	} while ((i = next_vmap_node_id(i)) != j);
>  
> -		if (va)
> -			return va;
> -	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
> +	*locked_vn = NULL;
> +	return NULL;
> +}
> +
> +struct vmap_area *find_vmap_area(unsigned long addr)
> +{
> +	struct vmap_node *vn;
> +	struct vmap_area *va;
> +
> +	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
> +	if (va) {
> +		spin_unlock(&vn->busy.lock);
> +		return va;
> +	}
>  
>  	return NULL;
>  }
> 
> 
> and we use the helper in the vmalloc_dump_obj()?

Hi Uladzislau,                                                       
                                                                     
Thanks for the suggestion.  I have adopted the find_vmap_area_lock() 
helper approach in v3.  The helper unifies the cross-node iteration  
logic with a mode parameter for spin_lock and spin_trylock, the      
latter used by vmalloc_dump_obj() for atomic dump contexts.          
                                                                     
find_unlink_vmap_area() is also simplified to use the same helper,   
removing a third copy of the iteration loop.  The helper returns with
the node's busy.lock held, so the caller can unlink_va() under the   
same lock before releasing it.   
                                                                     
Will send v3 shortly.                                                

> 
> --
> Uladzislau Rezki

-- 
Thanks,
Ye Liu


