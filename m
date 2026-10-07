Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63DB7CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 14:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A12F6B0093; Wed,  7 Oct 2026 10:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575EF6B0095; Wed,  7 Oct 2026 10:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4658F6B0096; Wed,  7 Oct 2026 10:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1165E6B0093
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:07:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 959FD16021C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:07:00 +0000 (UTC)
X-FDA: 85296006600.22.493BDB9
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf01.hostedemail.com (Postfix) with ESMTP id DDAE14000E
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:06:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RBYe86N1;
	spf=pass (imf01.hostedemail.com: domain of 3AVLGagkKCBwL2JMFK29M8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3AVLGagkKCBwL2JMFK29M8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791382018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imywIXeZN+/or3shxnnFEehI44taL7I6PvUTOA24c8E=;
	b=0Ag3rRw0K9E5XDYlSDed1VffcP7/cxc/Ni3lASRxI49OjYHTbQcqsk77D3tJJ8tEEWCcAu
	XDEXYMusipNVKoa9tKJ/fYRHVTaz+5NTBSegISZAzOHlrl//ir4XIDiG2VzxZaZA4McS11
	ZpZbLn1npGJD6kXSKqmajpD9sjhomU8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RBYe86N1;
	spf=pass (imf01.hostedemail.com: domain of 3AVLGagkKCBwL2JMFK29M8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3AVLGagkKCBwL2JMFK29M8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791382018;
	b=Nob3RPEz2NPCm4+b/fzq65Eo/k6gjKTVO1zLF5bL8T6DDrJNHJP8Ql09FZ2tXQCIirwYCc
	Qy7fTJyLKNIReflZbpOndIm80p2KBy0qvxaDE8FCIm3TmN/QPpAIjgsJJ6Dgjy8KUQIHWu
	aLgfbYTdf7+sGfotqiUingxR7CYMqkU=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c2dd399f761so452753866b.3
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 07:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791382017; x=1791986817; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=imywIXeZN+/or3shxnnFEehI44taL7I6PvUTOA24c8E=;
        b=RBYe86N1flp6WYE2/C7UAcmsi0DyrUVTtX3uiY1HZU43J423jXsE4QA6xJCM3AMcOn
         LpG+TwaIZ1nx0B2cCw5OXam3TMVmMmQXYyU/C3lVECrdXYSATJwDpdKSM5jdpLS+Svae
         7nmCvoGW3Y7udgK+toHgKd0tFRH0OAoZ9gSaOUnNmEx0deyVJaY4H0JWTkzxCMn95uib
         gDl0BlUWfEvXS7qy4VMs6WVy1YmBBMzUaz9SuJib3C17sEDcP2HOsKxJV70fUVOlNdRh
         URl1VV9lm1zVZ3A0hd7kX+wH7UTxHgDnlFX8m1wygoG8FTlUu4IH/Q7pFOtjLE2O14Ck
         HO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791382017; x=1791986817;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=imywIXeZN+/or3shxnnFEehI44taL7I6PvUTOA24c8E=;
        b=abucOne+0jYktW7gbJfaRW8Y2x2IumgFug/rqddRv0MmBO19dGQ3tspGTY9yhup+Zz
         1I/5LIvkH8cYjmIydtRs42tI7nfAXwZxGJmwZdJtYsr/t6AaJjHAiJbPCChKl7Ve2N1L
         s2E3K5//bqbHYdrDyzDhrxSO651ISMeKY6ntKhi0UIod07ktVlLV6VOr4RtRvZ8//eKD
         FPwwLgxkIoL2W2RSaHN9Ot9mfIYUAXjE/TpoF/4gM+efhASQly07Pveep4VM4eViOPji
         FJLXkPr99fprryGLu0pxpUhr2aWE8evSGNicoj5JDxnVCT/1ezj8LfaDqlzmg1qBx7V0
         GHng==
X-Forwarded-Encrypted: i=1; AKwUvBwgdDQd0ijmVOgwTTKZQYpNkW7+jtnHMnfwRI29gEvbY87E9mWs+C8uuyK40dXM9hK8lZwhIebBOw==@kvack.org
X-Gm-Message-State: AFq9FYJbOf6AnYVPawQ+un28W6oiJMWFkaAANbW5/04Fh4LQbokj57TI
	u25eRkVcD2wExsfGQ9SbB3mKGU7AvkVcZ/W0zbzlhPBsPvEpq7tqxTX2i1igvocBnc5cehi2Jes
	ltcDAn6vv6Wpn0vIQOA==
X-Received: from ejeck7-n2.prod.google.com ([2002:a17:907:e1c7:20b0:c2e:3bb5:3475])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:7955:b0:c2a:fbe1:7340 with SMTP id a640c23a62f3a-c317c0d81f8mr206753866b.41.1791382017061;
 Wed, 07 Oct 2026 07:06:57 -0700 (PDT)
Date: Wed, 07 Oct 2026 14:06:56 +0000
In-Reply-To: <asC1FwHVHOhBHDGK@kernel.org>
Mime-Version: 1.0
References: <20260926092448.4090401-1-tarunsahu@google.com>
 <20260926092448.4090401-2-tarunsahu@google.com> <asC1FwHVHOhBHDGK@kernel.org>
Message-ID: <9huzy0c9siyn.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v3 2/2] memblock: use binary search to locate candidate regions
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	dmatlack@google.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	dev.jain@arm.com, Pratyush Yadav <pratyush@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DDAE14000E
X-Rspam-User: 
X-Stat-Signature: 9wudwaaih9fytxk4ishyk514mkbauh6a
X-HE-Tag: 1791382018-416842
X-HE-Meta: U2FsdGVkX1+J52lLjo+v7g+jdZu8B/+xi0CUf2AFqpjBHHijf28iAxBZb/bxMcOLTdG8mxG9qrN+zv85hOo9Ji50HXen+oBO5a/pwemG0+vCNhc6PGDzl+ZH3t//HnfTPUlE5v7TxroElxWKfw4c7T0mRSFeL9cjDwfPuOl83nyCq3qMPrrrJ7jyF/GxZxXIUEejNLaWhXafVolovADDLw4iRhUdxkUPDcXCxbVyTllyiJ+9hJ0FAcHMYJ+9FClEWC5gUigIoMu2Qqdo7XOZO30sTtIY15kRwyxg5D4AAbXOBe2zRAC43jVzHv/Eic6myX+bohzacmZTe/uIz2DcbcAoMojfIF9043RQUkbzV/pbaGolH3noEw19tDOQ8HsceBTI2ZZdUWy7dEpXf8vBeEPS+MEyG+90/KMpLH7+KzLuHk01i2dY8cJhNKeG4S11k6PC0WgTSypiEP94bwLm9kKOKALJ+FtMQeyKKSN3em+Cbx2LpeSnbnr4uwRO3rJprrpfBQ4EBgNbk7Yhddi4LZzDCPmz4lIvv6MEY6TVvQd5piKdsnamsNsT7pY5taOkzupAQzn0oWo5BAbhPc6Klwdvs9AjO8A+BkyoEgr0N2QWRpfkF2zP3KYEJkX4o1RLEpPdSLENzQExEWBfFihP01URGhIuuX8SuDJNNkcBHNM71K7/WYsc+ozMOpRIg2+SViA+qa49qE9PCoK20D4ovq+Xhd2uZxpbtY/x/QdCNJsus9WZcBWqjxnITmcNzBCGWsnIWa+xd8wrPCpSMiQfljyTZ2XK5uEc5nG7MJTCcKvzOC4pG0m38QCLnDHQqxrGFeQmSTSYa7CCQUu3XF8RNwusBHJpMZNtc2QOudtfsKl1ArgJErFRn/te+YoMYemLtiXG1WBPI0obi8qQrtn0sptbT/z1SBmSNUohZPXemxaDKh6YNxKFdf1GOVmHQM4p5YgSUCkaRs8Q3VP6X1e
 Wk7SGiCT
 qOjuKlkFGAtr2OLIZ8bxkHK/sCavIKNvjE9S0mq9uArwQjY58YvAbsywuWRyYBxTG0sLntWRbj3aIIjSQhzE7L+SNbfsFYxRJEHxqyuThlBGFT7vAUi7DsRqtlScja49IXCmHptQ6HM2f9IUJvPTJ5utRg2h960gjtFxYqdV1i6aThJHQdIDzkEnakhq7453IvVsEwfqAg2ssKvOrbzB+ET6vulJGa6pmXRoOHYRvexEtqZh5HIYpqtO9th0Jupm5CzGTgX//5DKl182D2ArxSNF8bbxcA5FtmTJBau1jIgvaPmY/w75HEY6SnDnX3iUBcOLcvqheIvUuM4l5ofLyvgWz5ykaSySXEfXhinxE/tjrydWHVtoXeUFfuSwpf9ONWQaxKJhBbzByfuXFv3IMnHAJmOYmpDb3X8T6282jwFwqzVp+MA8EDIBMrC2STV6iHVTk5Ochi7XGdURNpVTaBbIMOWdd0F5hspgRYhm/R5EtQlPCfhYX2v9+M8w2FY/aEBggPjxKT3fqpmAY9y/wUBvELECvfoDeAf5bXqOcGs2ionu+jwLXGLQoeWo6x9OiAWEMMUx+h0Dhylw9xXJMo3Qb2nvPmBnKFg+36YS1Hspb2LY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> On Sat, Sep 26, 2026 at 09:24:48AM +0000, Tarun Sahu wrote:
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
>
> I'd call it __memblock_search()

Okay.

>
>> +{
>> +	int mid, low = 0;
>> +	int high = type->cnt;
>> +
>> +	if (type->cnt && base >= type->regions[type->cnt - 1].base +
>> +				 type->regions[type->cnt - 1].size)
>> +		return type->cnt;
>
> Using local variables would make it more readable IMHO.

removing this as per next comment. Let me know what you think? Should we
keep this optimization or not.

~Tarun

>
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
>> -- 
>> 2.56.0.rc1.315.gc6ed9934b7-goog
>> 
>
> -- 
> Sincerely yours,
> Mike.

