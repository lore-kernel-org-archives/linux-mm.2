Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E33CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 09:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8140D8E006B; Fri, 24 Oct 2025 05:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1E78E0042; Fri, 24 Oct 2025 05:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729258E006B; Fri, 24 Oct 2025 05:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6315C8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 05:28:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A86F497D1
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:28:39 +0000 (UTC)
X-FDA: 84032482758.23.DD5BE72
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 15E8816000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:28:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HPJiCYOF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761298117; a=rsa-sha256;
	cv=none;
	b=aT9Dwg7cOiagbVZRBJ09vXXmbnYVEPAHP48XVfDceLLhiIVDHiT+bg+jB13Wip2e9DT02Y
	XbwG6lYQ2ipJXcmHWkFUW3pzwmIub0rhaEVVzY3c7n27ZF7BnpguE4aBSupbsii4TrYlR+
	qH3xW4CcUE4bVkombUZ/Enc5LZwXx9s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HPJiCYOF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761298117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEjiKaJQmXfdvCFlzkFqU/zz27ee+mxZNS3z1hWWko4=;
	b=RRWAVwbfkKLVd1ubPOw7/u+Xfk/tWeNI1u9LmczvIIQ/tcopE/MxFmnj/ckNqMBy7TURZq
	4bAcWu9vI7HclyT5M0tuLpxr/h2GAS3RafXP41mHgdJXbClt3gZj7JQSn7vxdDKatZ1KyG
	4y9gA9GZjGCXsETU9OLxjSQN2yz3//A=
Message-ID: <49a186cf-c248-45ff-a61c-a6de1a3a98b7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761298114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WEjiKaJQmXfdvCFlzkFqU/zz27ee+mxZNS3z1hWWko4=;
	b=HPJiCYOFHl7B44O3yhgS2sA0eZwd/Z/eqa//JdqqG9CBe4DhWJCsZN3Hi+9ELs/9pGVrKA
	4b2T2eJPJnglMw/NBxx2mJgE+xOQyExKN9BUC4RD7mN7sqOQxBKCIc0OoB0IVr91qLdgWz
	0AY1awteljfV/UOiMJi7eDfClZqmOmQ=
Date: Fri, 24 Oct 2025 17:27:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] slab: Fix obj_ext is mistakenly considered NULL due to
 race condition
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hao Ge <gehao@kylinos.cn>
References: <20251023143313.1327968-1-hao.ge@linux.dev>
 <aPs-sKOJQs-OelVM@hyeyoo>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <aPs-sKOJQs-OelVM@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 15E8816000C
X-Stat-Signature: siqfm1ukbinyqqi16y4xe8za7dt8j41e
X-HE-Tag: 1761298116-791885
X-HE-Meta: U2FsdGVkX192LcB38y4Gf/wpxQowJKcz87rSlTxzq61OWR436PGWvvos3gVH0SsAWcZdcDNQd27SH2KDmZ57cbQP+tRSuhixT+EL031mJiy5BgmBWlB7CPtkEaZP4hK6U1cpCJKaGzs9C+/LNuNT8i5/TVKt8ri383SEVwf1PdbftJIbqLMtu8dUdOYvrrkuKE8ILucy8zmg2vfWD+uEJXXHVFvh/rvGSYR69So4Yog8lMMGN3+kbBZJ46z+HLgbZ4VoHH1PP1C4VQcqW0ujZVrgguD5FkAr+XAjeidyea2oqRQABzYzs+YVKmkEWBZuGIWPGwMrH4PDnE17QpNhA6wdWXQd2axb5ubfJ+B2Km47czhU3gY3Isa6vi1RbD/pt79iJM+68kgACPLTYHzp/NRZD3GHV3vwQyQk2sj7Xc7dEl82sbETqzuP7vGmGNNqUwUYHBVxPU2QbOxqEYamslFo4TzD03KxYQm4iE1dRfyhuBysaC6dtiDYbY6hZeT/rkdqiHHqL4NCrAnAXyYiO2JsadS8jbghZQVbZZB9itz2bSb4q9ZawMA4dlV4wlZ/4lRf2YtKT2A2ij5alNbA8aNwcAAR45kHw4ccUbRuQKTFYR4XsoI3eOS/WTSrIQYX92iPgT3k0Qwr8+Yhg6id39fneASH6w/WwmiQ+kngyXXE6LY7NDbhCQF+JvlnlYDJRLQmHaGbJRGNaTlYo88co193mSlViHP7mBv3oAm+s1MGW+kUrZ3zTCyOBK9xm5hTQkzgNYxeau97k/AB3jZvPHzKQ/ZrNFbIryO15oXlSq6Aqeowvw8UqnctnAvfr08bOKwf112fDXJ84byQgmTXms1iXSUh1SaQIFis6pQq1GUbYGCWp2fAQwfLI+i77tDqg/SUS9eRuEK8UWiqmHNySKxor8oUGfSOkO0hmxR6z2pdqPHt08ClOQHvmdx7s1Y02gFA+gT4tw/E/95ylZ3
 di9F0aQ1
 KBGlKrzn5dFBThQR5Y5QB6imwioLKRr0mRKT8CX7f94fc3arEd0zj2QqpKdXZ80/7sfutbYmcUaN7tKYhQXfFppZERxjwewfanW/dkAlAtIiAIaoMWhTt1oVj44CBTa6mSSfr2Wz7VWWjk7dI6NGrFgD7EnJsn+PjlR+2Y7tuhcSdxxrXoNPno9WT4y9hhG8ViqukAfVza4LsAcsOQ5CvfTxRvD+8I6uKu6/siH0zolh+OP3FsfZoYrF35SoEn87LhFmRSE9qvMVAXctq7+kJdy3vUkhobT+lDSXIqQ6z3pkaXUV74k7JsmVpMkDMtSDODYQ/u4H1WUPDCW1g5NDMOWrAKWv2EMWRifPW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry


On 2025/10/24 16:54, Harry Yoo wrote:
> On Thu, Oct 23, 2025 at 10:33:13PM +0800, Hao Ge wrote:
>> From: Hao Ge <gehao@kylinos.cn>
>>
>> If two competing threads enter alloc_slab_obj_exts(), if the process
>> that allocates the vector wins cmpxchg(), and the other thread mistakenly
>> assume slab->obj_ext is still empty due to its own allocation failure.
> Massaging this a little bit:
>
>    "If two competing threads enter alloc_slab_obj_exts(), and the one that
>     allocates the vector wins the cmpxchg(), the other thread that failed
>     allocation mistakenly assumes that slab->obj_exts is still empty due to
>     its own allocation failure."
>
>> This
>> will then trigger warnings enforced by CONFIG_MEM_ALLOC_PROFILING_DEBUG
>> checks in the subsequent free path.
>>
>> Therefore, let's add an additional check when the process that allocates
>> the vector loses the cmpxchg()
> You mean "when the process that failed to allocate the vector loses the
> cmpxchg()"?

Yes, I apologize for not being clear enough in my description here.

>> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>> ---
>> v2: Revise the solution according to Harry's suggestion.
>>      Add Suggested-by: Harry Yoo <harry.yoo@oracle.com>
>> ---
>>
>>   mm/slub.c | 16 +++++++++++-----
>>   1 file changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index d4403341c9df..d7bfec6c0171 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2052,9 +2052,9 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>>   	}
>>   }
>>   
>> -static inline void mark_failed_objexts_alloc(struct slab *slab)
>> +static inline bool mark_failed_objexts_alloc(struct slab *slab)
>>   {
>> -	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>> +	return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
>>   }
>>   
>>   static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>> @@ -2076,7 +2076,7 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>>   #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>>   
>>   static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
>> -static inline void mark_failed_objexts_alloc(struct slab *slab) {}
>> +static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
>>   static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>>   			struct slabobj_ext *vec, unsigned int objects) {}
>>   
>> @@ -2124,8 +2124,14 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>>   				   slab_nid(slab));
>>   	}
>>   	if (!vec) {
>> -		/* Mark vectors which failed to allocate */
>> -		mark_failed_objexts_alloc(slab);
>> +		/*
>> +		 * Try to mark vectors which failed to allocate
> nit:
>                                                                 ^ missing
> 							       period
> 							       (.) here
>
> With the comments resolved,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>


A period is indeed missing here.


Hi Vlastimil


Thank you for adding V2 to your tree. Now, should I resubmit V3,

or can you assist with making these modifications in your tree?


>
>> +		 * If this operation fails, there may be a racing process
>> +		 * that has already completed the allocation.
>> +		 */
>> +		if (!mark_failed_objexts_alloc(slab) &&
>> +		    slab_obj_exts(slab))
>> +			return 0;
>>   
>>   		return -ENOMEM;
>>   	}
>> -- 
>> 2.25.1

