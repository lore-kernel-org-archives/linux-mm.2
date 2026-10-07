Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 015DDCA6007
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 14:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157866B0092; Wed,  7 Oct 2026 10:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109DD6B0093; Wed,  7 Oct 2026 10:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01DDD6B0095; Wed,  7 Oct 2026 10:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE4426B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:05:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A49E14022B
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:05:56 +0000 (UTC)
X-FDA: 85296003912.14.D4C2FA4
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf02.hostedemail.com (Postfix) with ESMTP id B1AD18000E
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:05:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EnF9WtG5;
	spf=pass (imf02.hostedemail.com: domain of 3wFHGagkKCNkO5MPIN5CPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3wFHGagkKCNkO5MPIN5CPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791381954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rU5wB6bHQgxWOlREbKkjzu4hbbXBoycTkgMxfiJ0Mmc=;
	b=ZUlqzHZInmwCl7JnsKgLukTfQkGVjheatZhTbWqXR5bvR6NSJW0I1bfR3tH8m1RqHvil9X
	z9jrgyn4Eq16+stiMTwPdwv47FfjM+tbSLVWCm09NfTpdkVy25CLvjcFQbudgcEK7iMwQZ
	mr4eEdUJBSmFVxlsqOj8VPHtAEqTL7I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791381954;
	b=q0F5JVtDvyrrGVan9BeA2eKpGadtSDdG6kmmGU7qGO2kVWNXkN7DpRc+wOMICa6O8/n6Nk
	LzrPFuIuE08KYBY4rew0tAQngOeIfgBtkb5ixYeDvPsdO6AarXNG/ywnCFas9nHeLdSrEn
	xs7JCBpAlbNo2KreyQdkQWmjwULoc+E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EnF9WtG5;
	spf=pass (imf02.hostedemail.com: domain of 3wFHGagkKCNkO5MPIN5CPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3wFHGagkKCNkO5MPIN5CPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c2e2da5823aso200815866b.0
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 07:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791381953; x=1791986753; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rU5wB6bHQgxWOlREbKkjzu4hbbXBoycTkgMxfiJ0Mmc=;
        b=EnF9WtG5z0uWh8WG4nwQpu8kNksNtbHIkqTcB1AIj0Db4B3SBXx+27wrsCQgNC+WAQ
         WcPYCYrHFhSc3o0jY2FIFrk4/TKsarM/IjME63wXnkl66SHkx9wyGw7nFHdES2aOWKjW
         DPBJD3lblPZBe8xZ/oRHT4oTmQFPKBaWQ8Tn725SVW5XaxJjVjPkXbxOzWLBkbqyT1FP
         eAvyGb6quHGi1Ijy17OSxrQHrI7P1tAu/NheFEZYfIq2Pjr9UNv8GDkL7mwdXXwzmpyH
         nhUVQsQDJYPMH1AxXfngEq2DxflVw8tBavS2y5Fh4vWjbstjiS1I1MnNKCXhPFuyiYSK
         riGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791381953; x=1791986753;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rU5wB6bHQgxWOlREbKkjzu4hbbXBoycTkgMxfiJ0Mmc=;
        b=qFz/e5tKsXzmkv4kAzj6DflqPgfsE9/8y30J6ci+rapO3Lj+rrCKhpDkMKuotlLKQW
         Zk/viha9Oy7cuPU1MwvM2Rb+GaDwqm3UkXoMyzGrXJbYRFAyZzS4Nk6IdegYzmRC5Uyw
         lZWZjEwzv8MJOIyZz7pMonZPmCv16YQTqGDMZdZpuHyJg3F/YvKTTW+fS0iaQV4RV0Tn
         lJ4/qi3XLwR0dH9RK1hGhbjuqZ56XNQ6uFxNnJTPRMFVHd1g+phPSLAMYX+ocb130ElL
         hvM/2BfeaF2d/oTWJa6IrEBGtHnK/USd1j/JB7z2xPIgaNj7LVCqYpByU7jDGS7R32Dz
         rkUQ==
X-Forwarded-Encrypted: i=1; AKwUvBzQ4VdNq+wT4s/0tHlrKEReoiIC1k6rjyUGWcbUyxWi+vBS3vtvxZwxh16RJUwW39iXn/oZ3IR3jw==@kvack.org
X-Gm-Message-State: AFq9FYKBdWYTAdcvbsOVqZuJ6u3TbvrHLoLO1+zF0k+5VbYRTaU/DBiO
	muUawJ0vHJkhBfcaJRVeo+KrjiDHHnb0v65zyZX2/eYx83EqbvJRwltjNSq0REBXyLZzHosPruD
	DR4VINfNnVnU8kTpD2g==
X-Received: from ejac25.prod.google.com ([2002:a17:906:3d9:b0:c2d:c729:d7a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:7956:b0:c29:f5d5:5a9c with SMTP id a640c23a62f3a-c317c088215mr242709366b.38.1791381952681;
 Wed, 07 Oct 2026 07:05:52 -0700 (PDT)
Date: Wed, 07 Oct 2026 14:05:51 +0000
In-Reply-To: <2vxz8q4dlgrq.fsf@kernel.org>
Mime-Version: 1.0
References: <20260926092448.4090401-1-tarunsahu@google.com>
 <20260926092448.4090401-2-tarunsahu@google.com> <2vxz8q4dlgrq.fsf@kernel.org>
Message-ID: <9huz1pa1txkw.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v3 2/2] memblock: use binary search to locate candidate regions
From: tarunsahu@google.com
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	dmatlack@google.com, Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, dev.jain@arm.com, 
	Pratyush Yadav <pratyush@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B1AD18000E
X-Rspam-User: 
X-Stat-Signature: q5gf7exe4pcad4otsb5pt1yx1sk9h9gy
X-HE-Tag: 1791381954-181882
X-HE-Meta: U2FsdGVkX1/tEhMaS17Y/G5Rtt4kE1di7SlIX37mlAB6E3Nm4nsRJlo+pZuP1nA+d94/CMYuRNrZZUodnZhj13x/O0L8HxN53iFoTcCS7SdgNfeSY55GEFpkVPwAn+JXDq9pLsaZVe4gpd7gs8dTypfkZNFGtBL/Il3e4xLlazdtLhArTRuyfaw1hwRbuwifLDSp7Hn/C/cFauGF/J9VqqZdf6Ure/4t1R88p4Ifojh2VEPfOyzp9w/8Jy4Ptfv7eo047IlbUnZ4mp8Qkb6pomcNJuHAuxZ6X0gaBMAjdjhWGfpg9GIcG9Ip0s3MWqKBRNO5vEv1bUY1ytPXOtHLf5x0KzHTEexA3Wdh1mLR727z5mq4VIhLzzlehXx2comjVD5Hx4MfOchmKC/9GBQZYBIszjHH/lkhL3W9sjkCm5RCiA1ZSgAvj3v9coXhQNEQjTeWDFn99iYYgORL+GtALMqPeoBAqs7ajED6oyklLe3vGgTPOSB4JKlxGOe7Pj/XmFP/f7xgs2OlEyevWaLONtslmhugBAxM1RWkIE5O3qHtqskfQhThPXV1wt/P/vod/jTaSGRetG+1dob885WUC5opmqjY/1rE2q1ZTb83RDTQOcmZTa4VuS6r0RHASwaOntOva+WexxmVUoPOzKZJsfcmIhF04l9uo2/Nw8eOMB7Div7wdqcBxwXC1tNn6/ZjovNUfGg7A2UfgpsQzjlunE7Knf1fbdM1mzEPFwvDmO6G8jIhxjCYiXEPWXrOnX1x0SGGwZMo3DqA6F446D9qudz6MbU01rmpls5oLl3lq/UTlN/2olBaywVCRuwCelEwzLusimtoCViPHTTqgZBJpX1nlxsVZ29th0ceQ43y49Z1+F8eWQ9oG5U87cCd+7T/NXC2cfiTVu7MMdehWwhQLWI6IEHLgjRWv6uHWJPKy4fYlofiBCWdSpKK2GE9QXGcrmwwyStsbsTIMRYsU0t
 24cjeF6v
 qrvWjylJKNMKq6kVeLbBYOeBDyipX+Jr0wIh2e+fnJSITxyuo5rBiMongrJORA5pbeJNW4aN06hfPhhxoD/07te96vCqQoBLQVgjDH7q0NgQw6z9pK/N+vG/yaVO356EDQWYx4xKHZYlUKXzGk274yM/q34atMgKUDzoChXvt/2EMvPE37sacSqSRiyDOSC2vHUUz+eKeR7gceKlGVaw3x/LKa0MTNi56AHLjI2NNEEe5EjRe/U2BAvLW+U3sMf0mey6GBzeg/R3NmJy3IrE8aFbZDjHY1dzhakBPwbQCCQZTp+Nl+pjiiVOT6AucUPKQZkP5ENJPZaGTd9e7ShSfN2oT4wutB75ww5kIuIee1vtB9iw74oh0AnIRw6QjyJ/W94k2CxUG5W85fdzGDccrVzzehmw95Ge3Ze0VeJ9zFiPz+hN6Co5WHpR6cKLQINnUzwfcjLaizQgzYAztIRLtcti/vynPaFPtcXT8a2FHDkjSmAcUzHjh0eRzhFl96rM2P8aQS2rgyBqgDoIXWFbyOYEGO/5hkuJCgkG1xwOryDpjArC60/LcxihRKLdX0mpCHcmjBMcMVbOLZtAHrajQfKNJD/2qTFFXovH1dqbQS/ql0t8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pratyush Yadav <pratyush@kernel.org> writes:

> On Sat, Sep 26 2026, Tarun Sahu wrote:
>
>> Use binary search (memblock_bsearch_start) in memblock_add_range() and
>> memblock_isolate_range() to locate candidate regions instead of linearly
>> scanning from index 0.
>>
>> Under heavy memory fragmentation (such as KHO page preservation registering
>> hundreds of thousands of disjoint folios), scanning from index 0 on every
>> insertion and isolation results in O(N^2) complexity, causing boot-time
>> memory retrieval to take several minutes (~268s for 393k pages).
>>
>> Using binary search reduces the worst-case complexity to O(N log N)
>> (and O(N) for sequential appends), cutting KHO memory retrieval time
>> from ~268s to ~50ms.
>>
>> memblock_search() open codes the same binary search, so reimplement it on
>> top of the new helper.
>>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>>
>>  mm/memblock.c | 53 +++++++++++++++++++++++++++++++++++----------------
>>  1 file changed, 37 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 59dda7d085f3..87c71435c80c 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -586,6 +586,33 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
>>  	type->total_size += size;
>>  }
>>  
>> +/**
>> + * memblock_bsearch_start - Find the first region index where rend > base
>> + * @type: memblock type to search
>> + * @base: base physical address of the candidate range
>> + *
>> + * Returns the first region index that could potentially overlap @base.
>> + */
>> +static int __init_memblock memblock_bsearch_start(struct memblock_type *type,
>> +						  phys_addr_t base)
>> +{
>> +	int mid, low = 0;
>> +	int high = type->cnt;
>> +
>> +	if (type->cnt && base >= type->regions[type->cnt - 1].base +
>> +				 type->regions[type->cnt - 1].size)
>> +		return type->cnt;
>
> In some testing I did of this patch some time ago, I recall that this
> check didn't have much of a difference on performance. The binary search
> is the real optimization.
>
> Do you think this check is worth keeping?

Yes, This is true. After giving it a second thought. Binary search is
fast enough to find the candidate. Also it will be very common that
Incoming reserved entries are not only from single provider (KHO). Hence,
reserved list will have the entries that might cause above condition to
fail.

I will remove this. But if anyone wants this optimization in future. can
revisit this.

>
> Other than this, I only have a couple minor nitpicks below.
>
> Regardless of these small comments, this patch LGTM so feel free to add
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>

Thanks for reviewing it.


>> +
>> +	while (low < high) {
>> +		mid = (low + high) / 2;
>> +		if (type->regions[mid].base + type->regions[mid].size <= base)
>> +			low = mid + 1;
>> +		else
>> +			high = mid;
>> +	}
>> +	return low;
>> +}
>> +
>>  /**
>>   * memblock_add_range - add new memblock region
>>   * @type: memblock type to add new region into
>> @@ -609,7 +636,7 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>>  	bool insert = false;
>>  	phys_addr_t obase = base;
>>  	phys_addr_t end = base + memblock_cap_size(base, &size);
>> -	int idx, nr_new, start_rgn = -1, end_rgn;
>> +	int idx, start_idx, nr_new, start_rgn = -1, end_rgn;
>>  
>>  	if (!size)
>>  		return 0;
>> @@ -644,8 +671,9 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>>  	 */
>>  	base = obase;
>>  	nr_new = 0;
>> +	start_idx = memblock_bsearch_start(type, base);
>>  
>> -	for (idx = 0; idx < type->cnt; idx++) {
>> +	for (idx = start_idx; idx < type->cnt; idx++) {
>
> Nit: why have start_idx as a separate variable? Why not assign idx to
> the result of memblock_bsearch_start() directly?
>

Right! thanks.

~ Tarun

>>  		struct memblock_region *rgn = &type->regions[idx];
>>  		phys_addr_t rbase = rgn->base;
>>  		phys_addr_t rend = rbase + rgn->size;
>> @@ -809,7 +837,7 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>>  					int *start_rgn, int *end_rgn)
>>  {
>>  	phys_addr_t end = base + memblock_cap_size(base, &size);
>> -	int idx;
>> +	int idx, start_idx;
>>  
>>  	*start_rgn = *end_rgn = 0;
>>  
>> @@ -821,7 +849,9 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>>  		if (memblock_double_array(type, base, size) < 0)
>>  			return -ENOMEM;
>>  
>> -	for (idx = 0; idx < type->cnt; idx++) {
>> +	start_idx = memblock_bsearch_start(type, base);
>> +
>> +	for (idx = start_idx; idx < type->cnt; idx++) {
>
> Same here.
>
>>  		struct memblock_region *rgn = &type->regions[idx];
>>  		phys_addr_t rbase = rgn->base;
>>  		phys_addr_t rend = rbase + rgn->size;
>> @@ -2062,19 +2092,10 @@ void __init memblock_mem_limit_remove_map(phys_addr_t limit)
>>  
>>  static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
>>  {
>> -	unsigned int left = 0, right = type->cnt;
>> +	int idx = memblock_bsearch_start(type, addr);
>>  
>> -	do {
>> -		unsigned int mid = (right + left) / 2;
>> -
>> -		if (addr < type->regions[mid].base)
>> -			right = mid;
>> -		else if (addr >= (type->regions[mid].base +
>> -				  type->regions[mid].size))
>> -			left = mid + 1;
>> -		else
>> -			return mid;
>> -	} while (left < right);
>> +	if (idx < type->cnt && addr >= type->regions[idx].base)
>> +		return idx;
>>  	return -1;
>>  }
>>  
>> base-commit: 1f18d740165163910df64d3063e1ad31648bc5e0
>
> -- 
> Regards,
> Pratyush Yadav

