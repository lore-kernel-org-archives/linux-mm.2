Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361F7CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 03:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C27F8E0009; Wed, 22 Oct 2025 23:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8737E8E0006; Wed, 22 Oct 2025 23:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AFE98E0009; Wed, 22 Oct 2025 23:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68AE18E0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:12:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17444BC7D5
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:12:59 +0000 (UTC)
X-FDA: 84027907278.27.6BC57AA
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id 285EF20008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:12:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SJMdsd/v";
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761189177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFkWNTRoB/vWjqG2R3wUjVcnbHUc9YIZUBF8y0lylxA=;
	b=kuoGWPYNJ22t9mXxioI2lVRnfBi7lt/qUrPVNsblFYvkph1J7J7ax8TRZVtdjuNQQPUTxQ
	GTAZpZe1QxqDOdyen3aMOKCNKK3pmxBiSJKCAvo0ErW4LYKb87refJwffwnZ6qY1zeHlr+
	ozUfxQHmH+xpxMVcOpChDAdHi5fwvaM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SJMdsd/v";
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761189177; a=rsa-sha256;
	cv=none;
	b=xlfhWxhXG1qB5VRKo+Ds72nR9Apw9G0JvWjATJbHL3QIYWFKs/IivitYh9cpf/sdS5iUXq
	gYzyXSw+1GWLVIOGCJSxQnm5GlgROhNelwM+n/8hbDlnJBisTSX2l7HrQueQGhuKBZRA/O
	tnBzJ09No2yQclIIR1I39jF3sip2SSY=
Message-ID: <b8c90552-7be6-45bb-b586-ee21f63499c8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761189174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LFkWNTRoB/vWjqG2R3wUjVcnbHUc9YIZUBF8y0lylxA=;
	b=SJMdsd/v/n7qYpNMD0GsCkMe2XJR8wOEzvSvdCFiCAlKhs6jakoNH86bSAuk2ZTSAVA1yr
	mcpeQWoWfK0diJ92k0LlQzJPP7wRBJpvB7HdKx/kYWSEsmUfrX5aLKxZp1WMlBzEH+RFZO
	OI9eYVdTtQKpPqONpyuPavmZfqmz8AM=
Date: Thu, 23 Oct 2025 11:11:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] slab: Fix obj_ext is mistakenly considered NULL due to
 race condition
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hao Ge <gehao@kylinos.cn>
References: <20251023012117.890883-1-hao.ge@linux.dev>
 <aPmR6Fz8HxYk4rTF@hyeyoo>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <aPmR6Fz8HxYk4rTF@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 285EF20008
X-Stat-Signature: p3funwigqq6x1m1yue154shyckwxk5ti
X-Rspam-User: 
X-HE-Tag: 1761189176-360665
X-HE-Meta: U2FsdGVkX18UxZqX1HyJ5L/51uWc2QTkUIrCN4F1gfg6wIHXDmFGhwLBrOlZ3yePW3BechOBLFUXpDvGMM1qblMfo+b3e52x/V1R9iHm5y7Xyl1Cw2e4cjLdXsyDhsKChSulum6DRQa4olg/Adv2E1qK2BRdO0RCH5v418pvo+R4Oarm7bknk7AwQZ50e3jKP6DssIWuFNeedXd01c4HU8JQC0hPvI4E0lXIr5PQ1bPTbfI3J7HINs0xtdsF5Wyi8td7RCEAW8ia+4YDUquvMoTq3MzsR/O/ckDly6F48s9+JW+eMym5gNY6UOdzQNzpsno6kuZBhyLwvQNZI9Ui1DxkArhZAI0wwGE7nzugxld0IujAr8E4cxdGkVZFnT9ZDlKQOr81TxhBoWgVti3EZy55W71sadNfn3wokiXhP4g5JhIl3PzLTVxUVcDXrwF87nD3bSC5wAVvT5UI/H5dTYFeoxu0jQnKm5JpiPJUIHdnjfB3t+7yJxUMKLIfSX2wRmV32Gt7vep76LHgxY70+9B72TlvHscr+HZ7FB9g/g6OQoBsSA1GA4REg6IG3QC2EnJHyGW7XQDn7PZgRgop/1rRSTIx1Pq4MC3Gb7D3Nk0Xad9r7zew3DJxb/BnxQYTdNpFWSi2INGCpWrlye3VFf9kNVQ7v68ClkwblfOf/+O4UXfsG0QG+qaizZQha3ZSxvMHEO+NAbnkvp81hpuFmM5iSsZIoWL/A2xvdc0xss6gxS4BLyu6ENwC3nav7D0zIWaenO/ddyczUewOMyioFK7OwgwWBXpEOcqtNuz/QMNx/OI2bf4yQOhrQkoRRvlyp8iH2yMs79C2H9/WjkeqMSaKmRXIpCsEvbFmvsmGD6f8r80xSvuWzU8Zbd/H5ggM0KSefJjXmU29qIJon8U0cbE/MC9N/b2iZjKhtUw0rAwkjKJ+IdrUNIayUMSU+PmA9DyKJiDfNbyQubKbPxW
 ho+GBk13
 O31DxpKjKLknWcdiUHizOzhItiQrHnatkN49UTC/DjkqAtrDvSoXdfcv5HO7BmAMcviBDyyMJP+e5h3Jwhu094up8mQCtRUy3cMJKOeakspC/KTzrl9NtWCsTvUd6CL2L1TdC7BG9LMnU821EsbLrDtApuJHZK4fQjqvv8mKTvBsQKlx4fIqbxPpbrhf46qwyZzdQM0+q2NfprBVjVj5r+1dzm97/iGE/sURyLYEPsb3i98y1cOyWpOmc/TA/of0TKleSnjeOebBWwb/S3BhWD1J3HbzdAXhHZXvS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry


On 2025/10/23 10:24, Harry Yoo wrote:
> On Thu, Oct 23, 2025 at 09:21:17AM +0800, Hao Ge wrote:
>> From: Hao Ge <gehao@kylinos.cn>
>>
>> If two competing threads enter alloc_slab_obj_exts(), and the
>> thread that failed to allocate the object extension vector exits
>> after the one that succeeded, it will mistakenly assume slab->obj_ext
>> is still empty due to its own allocation failure. This will then trigger
>> warnings enforced by CONFIG_MEM_ALLOC_PROFILING_DEBUG checks in
>> the subsequent free path.
>>
>> Therefore, let's add an additional check when alloc_slab_obj_exts fails.
>>
>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>> ---
>>   mm/slub.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index d4403341c9df..42276f0cc920 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2227,9 +2227,12 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s, gfp_t flags, void *p)
>>   	slab = virt_to_slab(p);
>>   	if (!slab_obj_exts(slab) &&
>>   	    alloc_slab_obj_exts(slab, s, flags, false)) {
>> -		pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
>> -			     __func__, s->name);
>> -		return NULL;
>> +		/* Recheck if a racing thread has successfully allocated slab->obj_exts. */
>> +		if (!slab_obj_exts(slab)) {
>> +			pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
>> +				     __func__, s->name);
>> +			return NULL;
>> +		}
>>   	}
> Maybe this patch is a bit paranoid... since if mark_failed_objexts_alloc()
> win cmpxchg() and then someone else allocates the object extension vector,
> the warning will still be printed anyway.


The process that successfully allocates slab_exts will call 
handle_failed_objexts_alloc, setting ref->ct = CODETAG_EMPTY

to prevent the warning from being triggered.


> But anyway, I think there is a better way to do this:
>
> diff --git a/mm/slub.c b/mm/slub.c
> index dd4c85ea1038..d08d7580349d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2052,9 +2052,9 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>   	}
>   }
>   
> -static inline void mark_failed_objexts_alloc(struct slab *slab)
> +static inline bool mark_failed_objexts_alloc(struct slab *slab)
>   {
> -	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
> +	return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
>   }
>   
>   static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> @@ -2076,7 +2076,7 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>   #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>   
>   static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
> -static inline void mark_failed_objexts_alloc(struct slab *slab) {}
> +static inline bool mark_failed_objexts_alloc(struct slab *slab) { return true; }
>   static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>   			struct slabobj_ext *vec, unsigned int objects) {}
>   
> @@ -2125,7 +2125,9 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>   	}
>   	if (!vec) {
>   		/* Mark vectors which failed to allocate */
> -		mark_failed_objexts_alloc(slab);
> +		if (!mark_failed_objexts_alloc(slab) &&
> +			slab_obj_exts(slab))
> +			return 0;
>   
>   		return -ENOMEM;
>   	}
>

