Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8709C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C1A6B0160; Thu, 16 Jul 2026 11:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663906B0161; Thu, 16 Jul 2026 11:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CDC6B0162; Thu, 16 Jul 2026 11:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 187BC6B0160
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:17:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6CA40120198
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:58:26 +0000 (UTC)
X-FDA: 84994794612.04.8E2479D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 928A240007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:58:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J3QpNxlK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784210304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZVvwb5gue2Pu5bCd5TzfBGCtT03YhDYvhjRxQgTOBY=;
	b=KRAArTCqzCvyFmpfEJfxI8bTIIe5lnjbdjMaslkJ/5La8XVB2D3BmFSaZT7qOBtTrm6LDG
	DMX57xYygjzPqsR9F0sULBT0OUNwSZumppz9Fi2qYxZvF6k0tChY9241uhoSSh339qN8ol
	tqLGnkZXFIS4OijtvnSZpodWlEnkIew=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J3QpNxlK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784210304;
	b=IVWrk4ljOoDKcU1iHbBOf86oDLEfHDbA2jXLQ0AjucGwD3gl6x6jKqVaGcRB/GMwEwGIfh
	Tpm0xig3dXGJUtC0Kqs5hUMx+MWtClWgFwo6TqEj9jupN8CVBtDqwWmFFxV515eYz3/UWP
	QrN4FnhRGn7hfxGzcrfFDKdQgkv8IAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C32AD43A6D;
	Thu, 16 Jul 2026 13:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B711F00A3A;
	Thu, 16 Jul 2026 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784210303;
	bh=vZVvwb5gue2Pu5bCd5TzfBGCtT03YhDYvhjRxQgTOBY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J3QpNxlK+VfRxOQBqJ3Un2Zp2XZu+SBFJoDzQKLY+1pcxm5h5JkuCmJePpKOi+bV4
	 FcmoPvyk+dtTe+rj/Sgm5BobMog+m8r01RYWJmkuIOv+y4gep+fqYziq43dFNUuz08
	 lLyDEkcWlpC6SlWuyKtQIEO8wMa0Bj15QBwbmJLBSleZ56WMyiWv9K9b4vJFYfwSJc
	 ZsEXhYV9Hl9MkVd7PMqi9AWwi1zYmgK3uH6Yc3HURviDObyLSXClZp2D/pc8IZU6Uw
	 cTlTiafXjZZVXG2b4SciG2SOTAWlJX6xnavIdMVZezkTWpn7jQ8fiMfbMCtI7hWExJ
	 AErWQyHw/crHA==
Message-ID: <eb3fc4d3-c8bd-44e9-88ba-7fb974a58aa3@kernel.org>
Date: Thu, 16 Jul 2026 15:58:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
 <CAJuCfpEJV=OgCmQ9=tuMHOjMMh8bgHrpFe1gLtTXjagAenKZsg@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpEJV=OgCmQ9=tuMHOjMMh8bgHrpFe1gLtTXjagAenKZsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 928A240007
X-Stat-Signature: rbfdtui6371w6uzmc6ks4kno6hwsftoi
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784210304-827576
X-HE-Meta: U2FsdGVkX18Vc88b47PP5KBJ5jgGfFdG6bCcnfxedhVp+3l9+gcX93K90Wobq8PQOx5AaZjLdAkrZiUbL9cJGSkctOc//DYg5O1cMNu+wDJakIgfTWKh++7YSqonpxrtd9kGgSPyOHvZeFXFzqn2yhzdZQeDNBHxcZEI0mEqMPwB5vuJwOvECdl4aPpQ/LG3s9VjRJoAa0vk206m1HezAqkKJo798KHzKlrEFvDO/mQLF6t3WKcp3UIY12Wm/V2k2pSE9RA97bwflDdYEh37xvOs4AMuhNp38osth7f/i+g61QkFXayZPLNPGr55pFic4rLidTosE4orVzLXxr/+sfHHpm8snmcMhpMiokZ7WOa6yBssNtpOWF+Aa1SAopj183WEijllVz6ex92elJ3zgrU2oSxyjCWjagJkXCdBoLviZyw383bOh7dKgnhmJ1fcElfZKgNDBLPClmVci1d5N+VZm77j1s6IQhfN8e7hi+RzMr1J8tdHWS7VzRnb4F1CiodCOu/9rK3ufHN4rrhDg0TawqlFutF00X9ZXf+8tJ/tl9NMhdBwFVlUjtBzhOR/Lmr5q6+mobEOxs4PgT7Cam/zJxdgOVDdbg+o7nTdFlGGT1p1wXoOUEdNEBj4EWCiy6kz30sHSNrMxP0cC90KJof8okW37jpSyTB6haqoVYBi9zmg65lfglg9PYkdAPtT+A1e/PVd49gF2nkXN8P987aTPpXaP2o5PFFKj+hV4QQwqQTMgr4wC/e0oS6vL325qSaxAnUUpV3xv+boqyiwyfj0J2/bg6vKAbauIbOLV/2jrngNzznORO6cPSdu9FVM128ueeHisNFp27RacOCx3Uf53mjKL+oRhnSG/XrZOBd+ruzIkqkAbjj2HFdMQIgaDbZtYjhl5ZUgRQIqYHyY1DXSasgtptlNKuimAoK+5DKJOu1lbOJDXlECgSc1DhBBJR1ZNRtmI20UyZpJ1f6
 OuCArImC
 agxereMejCtSmMPCcWgaTGeJuzUAaq7sCcYECpz6u5S1lAgS1kBB8UUgLU3ETH8zyUxfVGB1LzPUWHZfOQ+dODN54jt9GvQIp7kNqoCKGyINrpvEGmniUdc75tyeBiyzYCaYZV+/gCEkxcQdthRIzUjl09O9EFFUv5MkH1wxQcj+NCiksol9g0pUCTovVada0DM3NCD7HvF8Q9FExRFyeIFaUXuADanoSwG6DR9thRPvKTCsZxsnH0aPguV89FFAcKuS+GaaOAr4qGwMRXGb11bwSX2kCWsbn3ttznuqAtJA84B6tyJOm71hUsxLPR3QzMi+d2O2tz5RJHqruE61VPlnE+goilz7/g/r0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 03:27, Suren Baghdasaryan wrote:
> On Wed, Jul 15, 2026 at 3:11 AM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -555,7 +555,7 @@ static inline bool need_kmalloc_no_objext(void)
>>   */
>>  struct slabobj_ext {
>>  #ifdef CONFIG_MEMCG
>> -       struct obj_cgroup *objcg;
>> +       struct obj_cgroup *_objcg;
>>  #endif
>>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>>         union codetag_ref ref;
>> @@ -661,6 +661,13 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
>>         return kasan_reset_tag(obj_ext);
>>  }
>>
>> +#ifdef CONFIG_MEMCG
>> +static inline struct obj_cgroup **slab_obj_ext_objcgp(struct slabobj_ext *obj_ext)
> 
> I understand why you need to return obj_cgroup** but maybe instead we
> can have a separate setter function and just return a pointer here?

Yeah I rewrote it now and it looks better. Thanks! It ended up like this due
to some previous attempt I made.

> That would also help catch cases when someone wants to set
> obj_ext._objcg that was optimized away (for that the setter would need
> an additional parameter to identify whether we allocated optimized
> objext vector).

It would need passing the slab parameter to assert
slab_obj_ext_has_codetag() in debug mode. I don't think it's worth it given
the get/set is only called from few specialized places.

> 
>> +{
>> +       return &obj_ext->_objcg;
>> +}
>> +#endif
>> +
>>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>>                         gfp_t gfp, unsigned int alloc_flags);
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 5e3f53bcd0d3..48e10198a3ce 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2523,7 +2523,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>>         if (obj_exts) {
>>                 get_slab_obj_exts(obj_exts);
>>                 obj_ext = slab_obj_ext(s, slab, obj_exts, p);
>> -               if (unlikely(obj_ext->objcg)) {
>> +               if (unlikely(*slab_obj_ext_objcgp(obj_ext))) {
>>                         put_slab_obj_exts(obj_exts);
>>                         return true;
>>                 }
>>
>> --
>> 2.55.0
>>


