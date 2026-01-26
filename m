Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D889EC88E76
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 08:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260CA6B0088; Mon, 26 Jan 2026 03:37:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F0A6B0089; Mon, 26 Jan 2026 03:37:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C60C6B008A; Mon, 26 Jan 2026 03:37:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F05866B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 03:37:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84461561A5
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:37:34 +0000 (UTC)
X-FDA: 84373461228.28.7ED1ACF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 043581C0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:37:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nOtrzNVo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5HuaIWBT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WaKuCiJh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ALuzgEkT;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769416652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItVJe7EX5a0KaCp3PFewhzHNmoMV6IH1mvEqTdGuR2U=;
	b=rC2ODmDUw4b9o9aH45UzaLfyDmH4kNK42ntuuxbZX4+U9uoIM46/y36S7z2Ah1xnZYXJil
	ykLnBP5S+Ljw3tUVhphehAWLQfbyOAGZWV83phrmD5tdqzFipNNxS0cOb2ECZfemFXjJ2b
	wpGmGrOwCIOdkwl0+zSd4e1/HNT5/cE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nOtrzNVo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5HuaIWBT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WaKuCiJh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ALuzgEkT;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769416652; a=rsa-sha256;
	cv=none;
	b=Dv0+Hs0fGemhawMVYmMuhum/G0CQkdmuit1+dfosVP6Vi12xGwEcDgzKTrww8xQK2NyTvs
	Idze8zUDp93aoKyo0ajrv7M5fI2Ad/qaLaSMblc/o8OohfZLRae8h9CV8UkPur/gv/8fSa
	20cEAffl2fstDAZioWQPWPe27no//gQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EBE01336B9;
	Mon, 26 Jan 2026 08:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769416650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ItVJe7EX5a0KaCp3PFewhzHNmoMV6IH1mvEqTdGuR2U=;
	b=nOtrzNVobZK+SmtfDIVfqP4FAtD5jH15w7xyDXOFUXOPwKHLAkL3nPyJF1lV7a2kRpfC02
	9VgCfDl0xi01UmUyMtS7Zk/crXtXFt9CQHtqhRVY+WNpmBtFJZgLOlz5+x7YG+1SlObpcI
	7EUHdTQcV6BMhpTqEpG7v08KYJM6WDg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769416650;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ItVJe7EX5a0KaCp3PFewhzHNmoMV6IH1mvEqTdGuR2U=;
	b=5HuaIWBT4KU85Ffu6GJp2V4mZtgm1hHGgGxaSxBIvlHI4jyIQGGu/rw2Lf9TsZ+Cak10q0
	mLc4oCna6zy+sIAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769416649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ItVJe7EX5a0KaCp3PFewhzHNmoMV6IH1mvEqTdGuR2U=;
	b=WaKuCiJh4yqZaIGkrbgJFPBU3aWVrWGUdejtXJ1CqJO1CGoOomyo/cN2K+1pf+fqqsWrX/
	FF9MHrJl0p2hbq2VJ2XHLsHJ+dW79wCFqhHgVRHHP1QU4AvxnhWVPOnxKJVLmZYrN5B+OV
	7UODzNNZaV/wVDKebqeGV+rwk/2Krec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769416649;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ItVJe7EX5a0KaCp3PFewhzHNmoMV6IH1mvEqTdGuR2U=;
	b=ALuzgEkTkHJBPgrue4sgK/GLUhPIxnEz5rui0w0fuYcbzYLq7g+8rWjNCSHt94T7Kiu6wq
	I2sGHLZGuIKFJ7Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE620139F0;
	Mon, 26 Jan 2026 08:37:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G8kKMsknd2lbJQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 26 Jan 2026 08:37:29 +0000
Message-ID: <55ab1a9b-1d7a-4e7e-b6bc-ee327197dc4b@suse.cz>
Date: Mon, 26 Jan 2026 09:37:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: avoid allocating slabobj_ext array from its own
 slab
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cl@gentwo.org,
 rientjes@google.com, surenb@google.com, hao.li@linux.dev,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
References: <20260124104614.9739-1-harry.yoo@oracle.com>
 <2b116198-b27a-4b20-90b2-951343f9fff1@suse.cz> <aXcmGMlH3sWO03rv@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXcmGMlH3sWO03rv@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i6955jqju335ywn1uocgw5xyffihbmyj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 043581C0005
X-HE-Tag: 1769416651-437096
X-HE-Meta: U2FsdGVkX1+BUVdWOXoK/6XDWFtH6lVQr5YCmcbB/mKwJwti/Ygh9oapdaIzXrQx6FeTcIu8OgO8HuHwvr8gMFHOzFlIwvO3O2LIPMl4NoepXP6TzlJpgZTtq74K24EhnjjgAh/TfN4XgDywkPXsfRgt3HUg7WlwhYnIkm9q8rmYmU8lhvNHuOrVcB5lfl/rYK0z8NIyImtqfrxZS5SFRaIJMsyIvwK2xesQFHAHTJ+iHoNT8CDOoPHl1knRcVcsYxgOB5C+3w1S2yamCkAfx5AQbTDi87hYEFijASPc9hWSi1WdrXwOgLJ+Ob//vjEckdCWr/h+YXq6EEp2XYimbbnD/b8hjNGa4XIhzknVioF+EsO6UByACyGha6oeAutSgPzFF90huVdFR2OlwhvKQ4MgWIsIuF4EMa3zsTEpt5WMzpTZNacwjwRd+LHd6XOyPoSGKozR1R+3ebxPbXQJyGagK3Cwr6WSVTpul/BY1w4jLvSLKlS8h0Ul3E6d4xShwJhcgxYafJhfn/QR8oDFQWlNTTcY0I3fnwkvZTjM5ZQM59Jamz7n+ADu20leVLWYXi0bFKxKChW7/QPGCDHrF8Um/OU5hj9PYqFESLQnwGu5xQ61o/Ocp66LcZj8D3oP0/Gpad5fLvkLdQIgUF5yN75oBlqfE3kjs+qGWkRVOyQaaH2zb/9Gl8C0DM8854K8OeocPve+gi+2ze4GYEKj8st31kbn9Ama7/zszvfVjKTHJZ3kC2kX3uQ4E3wYYqWQOvzPiMm35ZhtSBK6OThHWZCgp0ks2BROtAY7q4T+epvY1NmnN28UbslbOcbgxi5NFO9D3qJ2SXWanBqjQs+/na51v2TTrfhkqVFsxg4+cH5kATTuCZAQGq36TfgRnNvBHBS37auhqVND7SKtIuoB7DePc8K9UQdoeYGkv0mxYkoQqJ0P2iaENVu1rbzTIwh3CymXKhD6TixiBLiRErp
 eVGz8oOI
 AbFwE9+qpsO7XveF273UnmudaEaUVoWHeaRiI5gCYE1nnpJLrE6sT7QLdGZy722rzb+8/6/IWBSytqZJnM11qNaArKA+dr+TWf+9OiB6K6fYCGnrKo6k+cLUuXewpBhgsSACRQ7dh13brgq26w5YHRUlNvDkGwz5bw/ADzRmukkm5FAahyX5/cpQicJzvU7v/kOtXNsKnzVh/AySViDZxfCTEYkZ5WcbSC0UlWTJmxL+sW4h9E6OKKCY/nMKlh2OrwoXXDcuc6ydrSZygepIc7hfC6JbKPVh2FEt1Cd1w708U9gAKHfNR+0wHjtQ/IGW9lz1WGJt8GStUEI0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/26/26 09:30, Harry Yoo wrote:
> On Mon, Jan 26, 2026 at 08:36:16AM +0100, Vlastimil Babka wrote:
> /*
>  * Calculate the allocation size for slabobj_ext array.
>  *
>  * When memory allocation profiling is enabled, the obj_exts array
>  * could be allocated from the same slab it's being allocated for.
>  * This would prevent the slab from ever being freed because it would
>  * always contain at least one allocated object (its own obj_exts array).
>  *
>  * To avoid this, increase the allocation size when we detect the array
>  * would come from the same cache, forcing it to use a different cache.
>  */
> static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
>                                          struct slab *slab, gfp_t gfp)
> {
>         size_t sz = sizeof(struct slabobj_ext) * slab->objects;
>         struct kmem_cache *obj_exts_cache;
> 
>         /*
>          * slabobj_ext array for KMALLOC_CGROUP allocations
>          * are served from KMALLOC_NORMAL caches.
>          */
>         if (!mem_alloc_profiling_enabled())
>                 return sz;
> 
>         if (sz > KMALLOC_MAX_CACHE_SIZE)
>                 return sz;
> 
>         if (!is_kmalloc_normal(s))
>                 return sz;
> 
>         obj_exts_cache = kmalloc_slab(sz, NULL, gfp, 0);
>         /*
>          * Random kmalloc caches have multiple caches per size, and the cache

Maybe start with something like "We can't simply compare s with
obj_exts_cache, because..."

>          * is selected by the caller address. Since caller address may differ
>          * between kmalloc_slab() and actual allocation, bump size when both
>          * are normal kmalloc caches of same size.

As we don't test the other for normal kmalloc(), anymore this now reads as
if we forgot to.

>          */
>         if (s->size == obj_exts_cache->size)
>                 return s->object_size + 1;

Why switch to size from object_size for the checks? I'd be worried that due
to debugging etc this can yield wrong results?

> 
>         return sz;
> }
> 


