Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1313ACD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CCA6B0098; Wed, 17 Jun 2026 10:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FFF6B009D; Wed, 17 Jun 2026 10:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20ED6B00B0; Wed, 17 Jun 2026 10:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A81866B0098
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:57:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23003404BE
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:57:06 +0000 (UTC)
X-FDA: 84889707252.22.62E3809
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5FC714000D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:57:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XgFp1k9P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781708224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrfGjOmOPJXcDh++I3CnLLhJP9P9yWCrcpWYJkVADXo=;
	b=j0dY5LSdDg2p+8VmmpTvq0LZwxOOv1RIJjvce8VIo9ILMwKLIHdBbL/w93+aWFxvmqtVIJ
	ZdmfS07vmbAIJsSzmOwCqvlYzHkr87QSttuNZ8U/RalMc1CFWorOzRLhnFrPWC7pYJ34gM
	fgbeiCLZIvLNMiAiG+RUZ8CwLPy1Ny4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XgFp1k9P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781708224;
	b=mwcFPRorgBNHTIGIpPqVwqrQUKL8eQszPYm0S3qBttPH7PhPZF7uou2MPGlrQMyZgEZi1x
	ddr8cxMvIaO1qO8QYa3pSQ57J85wWHWnkqO9KmWNJ1NABNV4/sagvNc7H7PNErOaDLB7yW
	WlEe7NqrAqEf7sCQ1gclFK3Qk0rvSsQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD85E600AA;
	Wed, 17 Jun 2026 14:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451D51F000E9;
	Wed, 17 Jun 2026 14:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781708223;
	bh=JrfGjOmOPJXcDh++I3CnLLhJP9P9yWCrcpWYJkVADXo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=XgFp1k9P/dScG/0MwNL3xeu3uWnqakesjXiQFGSgyEt3sIBFxG92nv/pZKKSRsUIJ
	 Svg5oTYzHqshNPe6Bf937iNLaGYCcLXOU/owaCO3Fbt3atKKVFEHWIffFo/kUVBWSc
	 rHVvDzp6BrCUbJm6DW9utKp2bLcMSCfO7PxZ4xoNc4hJb/+Yz/zTJuu3mb1iZNCKWH
	 hgGym3kRiqcsOuN+7XR7Av1KKkpGeNaewcK0a6hi3J3BRk+iG9dnywc0jaYn7xGPKJ
	 biElo+NdDsqqsWPFvAnxEU5HW1xnthPmSMu0iXVcWyaUIUj6LcxF14fiPPg7tMw/En
	 F/0DhwG/BRaXg==
Message-ID: <1bf749a4-1519-4d14-a0a7-6d8a56a6c850@kernel.org>
Date: Wed, 17 Jun 2026 16:56:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/15] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
Content-Language: en-US
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org>
 <78b67a9b-44e5-4649-957a-9d42bfaa098e@kernel.org>
 <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5FC714000D
X-Stat-Signature: uqzcoob1o7545bgby3zy9in6wrqt8gor
X-Rspam-User: 
X-HE-Tag: 1781708224-229315
X-HE-Meta: U2FsdGVkX1828BGnvf/FZwzL8REmJ8ifRfMYBL8cQWsTfyeggvni45ne5K8YJlGFgb0qu6TubZBokWeQL+CLOQqaQSiahKDoYGDTucF/3EWtazba9h396Oap5jPWl0Ys8k6nwGgiVmzLS4rMm3EHiYmYOKq+Ub8B6GzxCuDMf5dk6ijHZQImMswnTDj4f0QVX9tA8zTFAHw8FHs8WnWjJvaY0Ms21F92/S+uacjAHhQ4+zskQK4Zs5KUDY50aynNcZBJBNYtzFQuASwwt23oDf+tYvu1u/X8/4PboXHvm8Gk7DKRk6qqaTjgtMRF5DNrxMjldnPxDPlae+OHa+HMDZNuAWMk5c7XqSGyfAGlHqdzXrqYLpVGxKo/HnX1M9t6JP6DT8HBjXurMe9oZ2fuIKD+Yy5yqKQctTeqJXgod7fwMiaNSyvOjywyFmL0rWKOpxshlTTwuWEIErQCE3KO6J66y1hGQmb1Xvj+uysc/DOO4bTPfLlj7oj0ZWPy73E7tYAv293+ZKCXPJtkrvwfNhZK5aHdI8ZTeH4BH0UYwIh7RaY8hrqNxLcqQIQV8giUiY5KG13eQydGNL7qvHX7iWZfEFZfLViSW9SFUGMOk+Z5PNgaO3psFi/frF3GIWfMLCvwgji8/UDARORR7j0kzlpGAr0TjBgo/764S0sg39i9fA/+aHGoSculCWatPjXCXvhmhj6vdbVqvTXomnPwXb6AwuCxkJ+VQ4xqeULeZaOjj9go9vmqZSfdGNvbNYf0xea+2X1KoQsPw/zkuOJDfevawgtXz2Vvbwg4n0LVsoRxPk4b4Kn/7pNDqNXBy1Uc/03Qs186yRvY4JTX1IEOEGbChGeYCO/1YU+FegnlwQrZvKHsWOVec0kVPGjuoyUReBDRqGUOTxR5W9bYsHITMbg6GD4hGHEm+I1N2sJToGX8QFgVZ1b+bg67ym/QbiyVU75tjS9yMUksfBFOjqM
 cwjXvVcv
 JgROlQcYiUpuFYM0KxzwBEWLW03D/zOocmVKSyc6t3nPB8kx9wufayOWtaSQDQp7qxvNULZfrr+P6is/63SCbi7EEYOmWaJIDDNLck77Pb9HGz1Iku80qzCMZSm71Vo6in/HypCkHIlaTKIHxisrdESWMMNAMZYpX+6K96wDzHf3cgRfnSWUZ5RtYiKqQRX1O2OWnimxkxjsSHOaL+2xxXjVsw6EpM6CdsrGvH0TFf+Ry9OoqPG5F/Q7rZ4+0RuECtU6hufqecBLtIPKYXdAtYRgnyI90inPSVuFXVq3g5ERM3MRcP6LMYHkc2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 16:36, Vlastimil Babka (SUSE) wrote:
>  
>> With some comments below.
>> 
>> I was worried that perhaps replacing SLAB_ALLOC_NO_RECURSE with
>> __GFP_NO_OBJ_EXT will create a cycle of
>> 
>> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
>> -> kmalloc_flags(SLAB_ALLOC_NO_RECURSE)
>> -> alloc_from_pcs(SLAB_ALLOC_NO_RECURSE)
>> -> refill_objects(SLAB_ALLOC_DEFAULT)
>> -> new_slab(SLAB_ALLOC_DEFAULT)
>> -> account_slab(SLAB_ALLOC_DEFAULT)
>> -> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
>> 
>> with __GFP_NO_OBJ_EXT, it would have been passed to refill_objects(),
>> but SLAB_ALLOC_NO_RECURSE is not. However this cycle does not exist
>> because alloc_slab_obj_exts() clears __GFP_ACCOUNT (as part of
>> OBJCG_CLEAR_MASK) and memory profiling itself does not invoke
>> alloc_slab_obj_exts() when allocating new slabs if SLAB_ACCOUNT is not
>> set (which is interesting, by the way).
> 
> Hm yeah I think we should propagate alloc_flags to refill_objects() etc, to 
> avoid later surprise. But can be done as a later cleanup.

It's also not a new hazard I think because while previously gfp flags with
__GFP_NO_OBJ_EXT would could be propagated more thoroughly than alloc_flags
for obj_exts only __alloc_tagging_slab_alloc_hook() looks at them, and
alloc_slab_obj_exts() (from account_slab()) didn't either, so the amount of
(finite) recursion is the same I think.

>> Also alloc_slab_obj_exts() propagating SLAB_ALLOC_NEW_SLAB to
>> kmalloc_flags() is little bit confusing because it does not have any
>> effect due to SLAB_ALLOC_NO_RECURSE.
> 
> OK let's address this one by this fixup:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index fc5b8c85b690..dc4b4ae874ce 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2164,6 +2164,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  {
>  	const bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
>  	unsigned int objects = objs_per_slab(s, slab);
> +	bool new_slab = alloc_flags & SLAB_ALLOC_NEW_SLAB;
>  	unsigned long new_exts;
>  	unsigned long old_exts;
>  	struct slabobj_ext *vec;
> @@ -2173,6 +2174,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  	/* Prevent recursive extension vector allocation */
>  	gfp |= __GFP_NO_OBJ_EXT;
>  	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
> +	alloc_flags &= ~SLAB_ALLOC_NEW_SLAB;
>  
>  	sz = obj_exts_alloc_size(s, slab, gfp);
>  
> @@ -2203,7 +2205,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  	old_exts = READ_ONCE(slab->obj_exts);
>  	handle_failed_objexts_alloc(old_exts, vec, objects);
>  
> -	if (alloc_flags & SLAB_ALLOC_NEW_SLAB) {
> +	if (new_slab) {
>  		/*
>  		 * If the slab is brand new and nobody can yet access its
>  		 * obj_exts, no synchronization is required and obj_exts can
> 


