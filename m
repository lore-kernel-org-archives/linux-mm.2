Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4EDBC531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79AE6B015D; Thu, 23 Jul 2026 05:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A9C6B015F; Thu, 23 Jul 2026 05:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43E16B0160; Thu, 23 Jul 2026 05:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8B246B015D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:30:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C3C440402
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:30:57 +0000 (UTC)
X-FDA: 85019522154.10.A191676
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 586A140005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:30:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QrnqwayX;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784799055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wt67XsmwkQaRLRB+uB5Oux958CHUJdn7g1FXjqMrLvE=;
	b=bYEI81BJbm5Fe8Zs6QY/f6zG6AJmbKvyTeooYgx4odYBQIKOY01X9dMSoaUMa+flqUWTfS
	kT9oQGYWNdGHoUDJX+RbvnbL53n/Ei0gSqoS8JkBqc+J3tkOKy6LSUh/noShZBIkWcq9oV
	Y2kUh+QtKM7XG3CUFm/lmT2zfiMrN7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784799055;
	b=e7YB/Gmab9O1x/hk/JrvDhCXt3f/OQwl963qWd1hJNWfP0dFryebUjsR/yTEVc6Cj2320v
	merJw8RyP8n1OmwpI6aTjk/pGEaBKPMVOyMifDkvEwPt+uXnVHv2S1EeOyLNK00mFh7rCq
	VxjsKZhgxShJfuDOEnIZPMZ6ktNr6Ig=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QrnqwayX;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2428D40818;
	Thu, 23 Jul 2026 09:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5431F00A3A;
	Thu, 23 Jul 2026 09:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784799054;
	bh=wt67XsmwkQaRLRB+uB5Oux958CHUJdn7g1FXjqMrLvE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QrnqwayXlJrmoiZ0u1sB6zSrdj3atfwQyJsUJxcCMfxbHkmnZnv8ZLcdb4R9RpHBB
	 FvQwOsQEGHluLfqGsSA6HgV0J27MWpP15ojOdmv22bKAWAx05QwuPO0y9xnXVC/WHN
	 q3//A/panHvy6AOi4VBdoAtal6baa6STqbmSVoAwf0h5OCPvHSeDFREThUCsE/ZvIo
	 GRywI7kYLfR2dIpMW0D1bgFxqn8o/tRVNyHirXRzQqQW2WEZhSTSeo1ZzAFdsEB1M7
	 dWISBVl056PFk58nrAodqbCurGD+PmvhYzGuRKAY9SLP9i2Qas1pEnOC9/sI05LaIe
	 zt6dFVgml2+Hg==
Message-ID: <e8b503fe-c97f-4747-aa95-97be42cdd832@kernel.org>
Date: Thu, 23 Jul 2026 11:30:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/13] mm/slab: add cache_ and slab_needs_objcg()
 helpers
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
 <amHbnLLrpOmwmusv@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <amHbnLLrpOmwmusv@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 586A140005
X-Stat-Signature: 73ojb6bosyeqfzh7jg3cojsorepk5irj
X-Rspam-User: 
X-HE-Tag: 1784799055-128754
X-HE-Meta: U2FsdGVkX19ECtg7DRJ0AZUhVY3Alp3tclHm+e9G3eCGvn9yzp06XtcYKzL17JDNsS6EIGt4YOhJ5kREeMfIIblCahdUhoFkgBRL+0axwynL0u2as+7DkcmAn3vvxAtNIeg0Kfpz0zzA7X8dDT53xLTrakXXd6IaI3rEl45ftq9NXxLI/bVlOzBDVP0e64SrLjHRc6xkxEqAOdAkS1YHQL8fhnGkCMh84JPdrvCNLCJRT00X0XV0KIiUmG5XVGiI/Mpa9jaypdRuRmchrDIG5iX0zJyqXBqiz2dtynu2VrE4C3fI9+NH/LkTK/weZNu/xd3nC8Z3zwooK3K6Ki6ButhxbzKRxxQbX8vOWQndFfETvflORjCX9tGCRq9YWDngM+Nc0q0VCUguttfqspvKJ/Ol8QiqOcEuJhbvtRzKHxbzeclb2OQapyLUbRlhfm1yKAtynqZ6slzHvBYjWMZVidIvGaxSN8gR5tu54w7luQbkGO/FmfpFwTLiZjMudV98zB9dP9ZWEJggeYrgTqTxqAIb3GEDEmnwyOCOE3Q7N5kJPm99gWv3vJgBoQ0ynlI4u/B7sPay4ABk3ga2T75Gh2Ka/axTrdkzT2KalnzeccF+b/45KA1tFxfAVxy58P8YEHbidWa4tJX5uMnc7zqwRl7TbsgRXhNy5kKVLSODRIAXTXd0AzoUUxvs+lWvU70JjBl2BZafAa6pekTfq5crSbWC4ua1t7KvYxIqeK9w00mdx9VON74nz70w7XBg/9LYxu3kYFNmGuSCj9Ez4fpCTwJSeliJeEQprgGxJyFrLKcc/7XivPpkMi+DlBPMG0+aFRi8/QEipr9AMU7WuLNihCCubQg8SgMcBsyZFrad3/2Fp+j6aMJ8C+vRdj9iPwBQ307UPcXIQzZUntscbXiC3TTxP8BgQbkdswL21nvp5okbBae79iArwhkrFVksJpSWoo77Lt99xNUqDWhQx/5
 exAahaZR
 F51C+WbAo+r25Ruuf7qtEIHEG1i3tiIDvlu81iwpZQWhp7s2rPqAH/HFtFk3ZQGnduJ76p19uvX8Po0Lxn+cYqHiMyLH63lq8CyraM9kaMpj7AGZz5X1srA9SADZmk4zG5AWWww21YrFwpey3gGAT6aXLOUznOuZEBS+2jclSEpe8WrYa6OM/ovzXLu5Pu8wm/1naBpUjOcukcWmqt65zoDV03NmCZto/VF9O8h0XT9GnTAH7fYPzLWosxW/hCAxpWj2hMDxyPNoj60eFZ42mUFur9S3KRqS24uHpsAjT51uVw8q3SkZStFTdjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/26 11:25, Hao Li wrote:
> On Mon, Jul 20, 2026 at 04:16:26PM +0200, Vlastimil Babka (SUSE) wrote:
>> @@ -359,6 +359,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>>  		goto out_unlock;
>>  	}
>>  
>> +	/*
>> +	 * For now we assume any cache can be used with __GFP_ACCOUNT and thus
>> +	 * may need to store objcg pointers for objects
>> +	 */
>> +	if (!mem_cgroup_kmem_disabled())
>> +		flags |= SLAB_MAY_ACCOUNT;
> 
> if memcg itself is disabled via `cgroup_disable`, mem_cgroup_kmem_disabled()
> still return false, so maybe we can use:

Aha, but then shouldn't rather mem_cgroup_kmem_disabled() take that into
account on its own?

> if (!mem_cgroup_disabled() && !mem_cgroup_kmem_disabled())
> 	flags |= SLAB_MAY_ACCOUNT;
> 
>> +
>>  	/* Fail closed on bad usersize of useroffset values. */
>>  	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||
>>  	    WARN_ON(!args->usersize && args->useroffset) ||
>> @@ -984,11 +991,19 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
>>  #endif
>>  
>>  	/*
>> -	 * If CONFIG_MEMCG is enabled, disable cache merging for
>> -	 * KMALLOC_NORMAL caches.
>> +	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and  not
>> +	 * aliased with any other type, make sure it's never merged with any other
>> +	 * cache.
>> +	 *
>> +	 * In other cases the kmalloc cache may end up being used for a
>> +	 * __GFP_ACCOUNT allocation so mark it as such
>>  	 */
>> -	if (IS_ENABLED(CONFIG_MEMCG) && (type == KMALLOC_NORMAL))
>> -		flags |= SLAB_NO_MERGE;
>> +	if (!mem_cgroup_kmem_disabled()) {
> 
> the same as above
> 
> Others look good to me.
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks!

> 
>> +		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
>> +			flags |= SLAB_NO_MERGE;
>> +		else
>> +			flags |= SLAB_MAY_ACCOUNT;
>> +	}
>>  
>>  	if (minalign > ARCH_KMALLOC_MINALIGN) {
>>  		aligned_size = ALIGN(aligned_size, minalign);
>> diff --git a/mm/slub.c b/mm/slub.c
>> index d78d3e50c877..30435e2509ea 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2557,7 +2557,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>>  	 * of slab_obj_exts being allocated from the same slab and thus the slab
>>  	 * becoming effectively unfreeable.
>>  	 */
>> -	if (is_kmalloc_normal(s))
>> +	if (!cache_needs_objcg(s))
>>  		return true;
>>  
>>  	/* Ignore already charged objects. */
>> @@ -3435,6 +3435,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
>>  
>>  	slab->objects = oo_objects(oo);
>>  
>> +#ifdef CONFIG_64BIT
>> +	if (cache_needs_objcg(s))
>> +		slab->obj_exts_needs_objcg = 1;
>> +#endif
>>  	slab->slab_cache = s;
>>  
>>  	kasan_poison_slab(slab);
>> 
>> -- 
>> 2.55.0
>> 
> 


