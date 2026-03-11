Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9ED1125857
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 16:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4D96B0005; Wed, 11 Mar 2026 12:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093386B0089; Wed, 11 Mar 2026 12:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0F06B008A; Wed, 11 Mar 2026 12:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C871E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:59:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F8BDB8061
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:59:10 +0000 (UTC)
X-FDA: 84534392460.21.4B9D2AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B63AD40007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:59:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lMmXpJ7u;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773248348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v28KtvC2GBFu5RpPUkG/xanGqU0AEH1tzZxsgoFKRG0=;
	b=mKUcS0TWwj8gNB21SbUIfKGGW1ZzdG1aWtv3C/rcejf8jJX3Gz15RF6YdESRmLizJOlQj0
	Ld5PXk5c2EUmwYKnP/0MV4pZuOW0wcPnnU1kYn7xS/83EX8uo0psn0d4dg8holnJEsoQG2
	wN31o7DV7+VeHHZsPH9Xrnn2zGWaiCg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lMmXpJ7u;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773248348; a=rsa-sha256;
	cv=none;
	b=APaVmLSMJc/nUFJA2gQj+J1etNSXKqYSL9sv1qAFGmKQkFpkU3f1RwbfE46L28xDRlhidF
	LBuQ+KOIufDpoxT+knJAD2IgTyKtrkoHIux5V8Gqh5ib8ciOmUV7HIZOdqfAG8vsk8+RaS
	Q8N94lFjFXsWD7LkB6w/lMW7CyA3Tys=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA61E406F4;
	Wed, 11 Mar 2026 16:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF58AC4CEF7;
	Wed, 11 Mar 2026 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773248347;
	bh=LxU4Jmzb48ECfIuqmqY9+SrwRi4R0KnxC2jMteOCe2Y=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=lMmXpJ7uxf0MVzwxwAT6gSFDWQu4bT/fhhtR0TSooudyOHbNkFA0faH9lwiAX/Ybv
	 hsrE0g/ShaDhSJGCmu5htgQoXY13cFtDQmUZkhsAYqJdnoZIyqGqfZvTPK0ChAMRYc
	 Q2dpbDdTB14iUOvhByk6iA9pLdUedS9bFxGpFyQQGErMGXW/cXEoGaCmyIEohs72aK
	 fRxJ/HLbPrZ3iJ4YoNtZD+dszZ0bZ6bqOTJ5MoLs+piZhDQx9mrBdPbkgFC2DEbns4
	 SMpxLyorOE0PFnw0fW/kYN44S+QWhRwIZthigs64+FNn9mig0ue9PiqsSPtYRCYVqs
	 US4TGh46xZWgA==
Message-ID: <7791ab6a-4707-44b4-a868-d88b93502b1f@kernel.org>
Date: Wed, 11 Mar 2026 17:59:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Qing Wang <wangqing7171@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311093617.4155965-1-wangqing7171@gmail.com>
 <abFPHpBDe5DsPL2u@hyeyoo>
In-Reply-To: <abFPHpBDe5DsPL2u@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xcxc4kr1joq7n6qxkeuq6z718wtjzdhc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B63AD40007
X-HE-Tag: 1773248348-932864
X-HE-Meta: U2FsdGVkX18fUrZf0yoZGumreuZq+c6a5eTMhOCvsicv4mQE+8Vo+8S9EogP5zdyZQEM/sxUlJTdrwflKlSRjTcItfBOJ7vNx2Rf0GbbrRvJIuxc5zgUm4Y5dPuG6Cq0wkRINbfDacajuo/YB3watAObWvQA22n5aZukCe01XF0UOnG8F7QOGhNUlvITns4qGYrpGG8eMxGbBttAvg/2Ozj6ktUjpWdBjneAbwwoGuAgZb5ZcNu2GqYNAeNXDNTST54nA+Y8w640dg8OmJs4ff74VtF+xk3VEdB8NXw+03/WBn/39tS2+5Zf+wclW6ENM6y96sVGW86epre1Y83Y7NvH6PyB4NtkmheDLFdgImSi/wIL5fV8R/Rugq/udsFg2C+DYiu74cPU6R/jFjwAAtmdACCXVOpvr1eReMscuYx1uz2O6ab0Lij0F8HtbK/A6ktuCR/ZR2jy5UNUkOpYSjZdxXjZYX+x0J022niqoe8QhTV8BrpN33tf43wM+uJSBDCzWtKOyTtW8/depFrRP/hittDGYCPinV1BouA3uohonICrcXjRDZO80b+rFRUml6wWVsUwCGI/iDEI/O1f/wStghNU8RxZ7tUNdNnHUThD4O8Bl7NRrJ4swvnrvom33LxkeWXpgXtqRrgZoXMoJxpt0fgTqL6hLA0NxSpWjhE2vKe6ubVGK27uPCaPXFnLtZDfUs0yANgTsyk19D3A0UHRpRVIMUL1a49ArTLyErfvqn59ryhVqn9Pu8XeL+kb1GS4puG/6iJfXGGcI2gXJrgz2ZFoH/4LmStCMVv8Ag+rvQSUSmRz7uEksX9UQJCDw0QkOFNYXJwb888HWmAQitZrupGmUlSgrBrsLA4KlBpsiuro3VR/vpW324pfrY7T+IRTE2lktXlWBBVWQE9IDmEEPBagg6zAS9GRwpMHIhDa7DV++1RC0TlcujK9oOObyxEDuru8rT1BJx1vvVk
 177Q8r2r
 claeS0HCH488d7QsGWNdZXHBWOUWLcKtsopT+L34HfDyLibJU3JaHKfZlQi9zi+ArsF6BbFZEyxXKHvZ7YYJnS8EkrhDxy3R+OBXFDSCN5Jxieap+IVwPduCqR+eAkrDCryZjdezvneGJeXe9OiDQNgbTy3KYSYPVTLCs8MNYVrHZHf9gU290ja9T2gQzETOdIzSxQm9JICQJz2jtezAnfPKIGz5G6SoN60ESosp135Qh6MLMKuPZxfhaeZ9Zoz9MA9CGDLhOxcDKQfsJWSZXJGygcpQBk5EZCCQwDyICV7jU082ytZvt2lSiB5b35pG82HJh9aRHOo3tDDV3WJEc29WB9Qatbp14hgffWlBDg8ep2nJTU3FPwlWMY8KVwJoipjJR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 12:16, Harry Yoo wrote:
> On Wed, Mar 11, 2026 at 05:36:17PM +0800, Qing Wang wrote:
>> When refill_sheaf() partially fills one sheaf (e.g., fills 5 objects
>> but need to fill 10), it will update sheaf->size and return -ENOMEM.
>> However, the callers (alloc_full_sheaf() and __pcs_replace_empty_main())
>> directly call free_empty_sheaf() on failure, which only does kfree(sheaf),
>> causing the partially allocated objects memory in sheaf->objects[] leaked.
> 
> Nice catch, thanks!

Indeed, thanks!

> Probably the need to fail new_slab() made it quite hard to trigger and notice.

Agreed.

>> Fix this by calling sheaf_flush_unused() before free_empty_sheaf() to
>> free objects of sheaf->objects[]. And also add a WARN_ON() in
>> free_empty_sheaf() to catch any future cases where a non-empty sheaf is
>> being freed.
>> 
>> Fixes: 2d517aa09bbc ("slab: add opt-in caching layer of percpu sheaves")

Actually I think that commit was fine as it was using bulk alloc to refill
and that was undoing any partial successes. I think this one is correct and
replaced it so:

Fixes: ed30c4adfc2b ("slab: add optimized sheaf refill from partial list")

> I think we need to add Cc: stable@vger.kernel.org

And therefore we don't, unless I'm mistaken.

>> Signed-off-by: Qing Wang <wangqing7171@gmail.com>
>> ---
>>  mm/slub.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 20cb4f3b636d..73b2cfd0e123 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2797,6 +2797,7 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
>>  	if (s->flags & SLAB_KMALLOC)
>>  		mark_obj_codetag_empty(sheaf);
>>  
>> +	WARN_ON(sheaf->size > 0);
> 
> nit: perhaps VM_WARN_ON_ONCE(); will be enough?

Yep replaced it too.

Added to slab/for-next-fixes, thanks!

> Otherwise looks good to me, so:
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 


