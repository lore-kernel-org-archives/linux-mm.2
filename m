Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E63DC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 04:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8206B00A5; Mon,  7 Sep 2026 00:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9376B00B7; Mon,  7 Sep 2026 00:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF726B00B8; Mon,  7 Sep 2026 00:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECE4D6B00A5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 00:00:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8ED9616067D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:00:32 +0000 (UTC)
X-FDA: 85185614304.26.B381C0B
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf09.hostedemail.com (Postfix) with ESMTP id E341E140005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:00:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MTCkLR8I;
	spf=pass (imf09.hostedemail.com: domain of 33DaeagkKCB8O5MPIN5CPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=33DaeagkKCB8O5MPIN5CPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=um99HQvxm8U8bWkMubZ+aKjTZImXgaTd+AqHI5SXH5Q=;
	b=CymJsjZ35Q91t+jrZi7SdN+PJ5QKGFjWoyBtZQkVVf/ULdWK4UJQKSz0tkclOtp8sUwL6C
	rgozKsVPW4uia3cZC9XzPi6RYObDWUQjbjS9qJnXwB7dlWsJJrA71+vcYrY9m0Q5R9HeHk
	vlhK8Ex3bXN9eaVyh89nLXajWQkj6Wk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753630;
	b=qkDo4UGpJqlDcyTX4xOY3OoewirDi4tfcFapIxeZFuv7/sLaCJWzMFTn2KYDD32RT/ushZ
	nBxe8WhL5hlqmXVnIuzf+bXbAfuek4butP2zJDRj5CFn7IKHMzNEmA0A7A6yzVOPNs0rwZ
	Iuq7J/ntPFZcEHq+DmkmnE5rQj0pCXs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MTCkLR8I;
	spf=pass (imf09.hostedemail.com: domain of 33DaeagkKCB8O5MPIN5CPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=33DaeagkKCB8O5MPIN5CPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a64cb77b0aso2445407a12.3
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 21:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788753629; x=1789358429; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=um99HQvxm8U8bWkMubZ+aKjTZImXgaTd+AqHI5SXH5Q=;
        b=MTCkLR8IN0uJnOkVEmRB+Sysg+fM62hiKx2HOibHj8iND9+tQV/4TMcFFMPt8jJYvr
         jdQpUGB5FSpKUfrkIXkpRWsB3sCu2pleGCIRz4gDQs2IoVwyrcg3RX8dz4JAgaPmc612
         wFMp9hpjSlPy4pKTwRZckTF03ld9bDbPzM6peF0vvJJQJ+vNvInw9FtJWQCl62viJSA3
         Zb+S2cW7pZkyzydqo5gn/gP+eFSD4KVJ7RUOG8AMQNL1y37Ma9THPbRiwK/cGyXRbJtA
         z6L3qaKrma0LwI1/ioIKgPhulo//sZ6Fc3UbyP+JqrApsyn1rkF+oV4MgsZZnKTR3F8O
         CtWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788753629; x=1789358429;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=um99HQvxm8U8bWkMubZ+aKjTZImXgaTd+AqHI5SXH5Q=;
        b=JvDumaKicK9JAtP2wmgpAWASCdqH9k8tsOPSFcqvZPEKf+RdZyntIVctLvhZxstgbD
         rTJgYoaSPVl9Jcc3mraKN6uSJZQqx1F4zHMjaMrkK9zsgicoY4HNY9Z5+X+NXgXw3VZe
         gB1pEDdQPuNKvrX5hzimAokosHJU2iMyJ+LAOsh6DP9tzhOpibm+4pZviLzINFjjUtpZ
         omquP/874N4OcQq+S/s5K+0nAZnEmqSEgiC2qEZ7bXAupPnUlohOLl6bUZuJnfEpTHIV
         QqKZ6b3V2oHlug+uK68pegN4QzofWqJr/y3C1MRu1966iA+mSr7jWtNJ0BPgTIX9eIYE
         MpOw==
X-Forwarded-Encrypted: i=1; AKwUvBxt7dIzcuM0vF7NKkG4jtyewrs4NHmSN6qUgSFgoa3lMx7ObfNVL8a2dJrFWqCGrWJA2iQbrcpz+w==@kvack.org
X-Gm-Message-State: AFuF++mwWDyHlVsBcAy+gg1unGzCnZ0CO5WTizlswZgNd7mCxN/zg0hK
	beMJPnSRjeDmAXZW4je3sqMjzlbhjWGCu8t9oyhWID8w8eQe8pqkJY+i0hT/uGGWp6i7EeKdPES
	QtxJfi9noXLYkJE03iA==
X-Received: from edqt8.prod.google.com ([2002:aa7:d708:0:b0:6a7:60c4:e4ad])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3241:b0:6a6:32fa:1e9a with SMTP id 4fb4d7f45d1cf-6a7e90c2f67mr4994847a12.18.1788753628866;
 Sun, 06 Sep 2026 21:00:28 -0700 (PDT)
Date: Mon, 07 Sep 2026 04:00:28 +0000
In-Reply-To: <ap0_lSVF43FP3PPb@kernel.org>
Mime-Version: 1.0
References: <20260903155907.1065681-1-tarunsahu@google.com> <ap0_lSVF43FP3PPb@kernel.org>
Message-ID: <9huzwlsxk8wz.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH] memblock: use binary search to locate candidate regions
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: dmatlack@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Pratyush Yadav <pratyush@kernel.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8ceo7kjehuky8p95atmmtu6fzk8q6q6x
X-Rspamd-Queue-Id: E341E140005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788753630-105361
X-HE-Meta: U2FsdGVkX1/s6wxfK2boKBgUabLPxvF6CrrdTpjIXDWipqJLbnQpkqI4pqyD8PyATkCUTterI979RUORE0euLvJdgkJIPptTE/hTO048v9sSX5gUrUdiqYUg6uGBOdmN7fjxDxg01A41x+3/jV57oQtMv3BDEWOjxRDtn7cwrTRs9WPhCCsgHyRh3kKlnCIyFITsf/+3I8OmJJrRkI+Xr6huD+0gHVazg9GpxxJo0/+b1vwcj6jHvrhNczrCsGPkGoxlJbQlKi6d7sJyYrxGrc7RFWSb4Ble0S69GGLu4VpLoPbatkYamywYQ44CWicwpLw4xPoe0IYMamvSvHpgSGAmJ5ESqlRzgpMi8ERiKUYwNg0jLKk4U714StUfS4ez0zPxPbO3gZTyFEqQIAqx/oZLqgAtNUSyuQFB7Goc/uNbukhkPoVWpksXPMMlpjY3tHMEHLd/KFDEw/8d34K7evQCpg36gMo98LzTcSzn8EOo9sx9gAS2fAvheAg3PoZOoSwI+4mO6USgB1qJ+KnLO+m4gMtTr636RZtFGiojtGu6DLNuWQA9WA1C79PZur275wCWdTicNUfZgFRT2+7kyWFJXrrZhZKcefp3vaGfLDNsJPEEPLNO3+dyFVdR1ByKSFBHq76TGzDY1oyhlTPXZ9LufQ+k7Rg1gTX+gKH1tCLRlTs83j1lfG9UeJe1BH4kVktvx0vASEqp7j977CKRZ55k5Kb9iEJalhX5Mo0o3buCgifScg6rMO39v9E91iquzfGJ+PMisFq9jq00Soc+QmkIpVXhS+7aB4gz4a7Akl8FEav+I2X+RNEnMhtU84dJIGlTkGRSJgHjdSA3dBe8W9hqqKCT+74IlU4Nc5OSTemK64JEBtXBt7piZIgQE7ClAKoNtKUKg/lSQ8bppQbPnw+w3URyh/k5YsmUjjK6XerGYaxoWO184t5NKQdY1foljOvHouloZrY4LLB60T9
 LamobfSo
 L6e58pIGGB1woTyjBOCL62YrfD3havBmoBY410Qw3WuUzCX+nd/wTUremuEfwBrfb02SH60Za/BP4/PJMfZu9S3UhqOZ7mwR4eD6JqOCo/5QtCGmJxYIAItz6zflLnW6TMZzb/aWre3T3ybdD9q9uWj6myc873OU3CLNi+r/gPAqhjqBZLZFi7RGu0fThyDfqdP+hPa0AfaTv6ywfyy+eJPPf7cryHtilVLF3bG+sIbWdTD68PJXeDBrsQc29WnS2uyHSOqdScHu1WExvWxWunm20zRmOzalhk7UsIY9SLfk32Z+wkBcOeKNRlTJpm294PnythhmvL7ndcwR9v5NKYAtMsSR9Mgly5FJphRzfRe1JSrgXsZeXEvdbkaUTX9P4h1Zp9v0Z4OlKdlCmx1Hgp4K1QCraVo11mpcqO5YXuTU7jtYrV0I4C6t8VIkX+W+R1fnQzUlnOXWypUIKSt38BlG8GJaXdyDqyvODNvi3Ar4e0gFZGD+QfHFScOblf+ndI6REuDafk5YeFUAnpNUrY5MgOPwCN2qKVznBlY+Oj/1fKMU5Wsn/9S0AvEa60VNR9QcYA9H+SIS67YGE7lnsqh200oXrd0Acz8xJBmqzSJfQkD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> Hi Tarun,
>
> On Thu, Sep 03, 2026 at 03:59:06PM +0000, Tarun Sahu wrote:
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
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  mm/memblock.c | 38 ++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 36 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 9ce86349a29f..88940474b020 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -160,6 +160,11 @@ static __refdata struct memblock_type *memblock_memory = &memblock.memory;
>>  	     i < memblock_type->cnt;					\
>>  	     i++, rgn = &memblock_type->regions[i])
>>  
>> +#define for_each_memblock_type_from(i, memblock_type, rgn, start)	\
>> +	for (i = (start), rgn = &memblock_type->regions[i];		\
>> +	     i < memblock_type->cnt;					\
>> +	     i++, rgn = &memblock_type->regions[i])
>> +
>>  #define memblock_dbg(fmt, ...)						\
>>  	do {								\
>>  		if (memblock_debug)					\
>> @@ -591,6 +596,33 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
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
>
> We already have memblock_search() ;-)

Yes, I preferred to have saperate function because we need to search
lower bound but not the exact match, as new entry might not exist and
memblock_search will return -1 in that case.

To not duplicate the binary search code, we can update the
memblock_search as the wrapper of memblock_bsearch_start (Approach 1):

diff --git a/mm/memblock.c b/mm/memblock.c
index 88940474b020..d9a71234abcd 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2096,17 +2096,10 @@ static void __init_memblock memblock_dump(struct memblock_type *type)
 static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
 {
-	unsigned int left = 0, right = type->cnt;
-
-	do {
-		unsigned int mid = (right + left) / 2;
-
-		if (addr < type->regions[mid].base)
-			right = mid;
-		else if (addr >= (type->regions[mid].base +
-				  type->regions[mid].size))
-			left = mid + 1;
-		else
-			return mid;
-	} while (left < right);
-	return -1;
+	int idx = memblock_bsearch_start(type, addr);
+
+	if (idx < type->cnt && addr >= type->regions[idx].base)
+		return idx;
+	return -1;
 }

OR Approach 2:

The above approach still introduce two function for doing the search.
So, I thought of updating the memblock_search(..., enum search_type) but
this will require changes to all the places of memblock_search also.

I prefer approach 1, As it will keep the binary_search code
within single function and have two function for two different type
return values.

WDYT?

>
>> +	int mid, low = 0;
>> +	int high = type->cnt;
>> +
>> +	if (type->cnt && base >= type->regions[type->cnt - 1].base +
>> +				 type->regions[type->cnt - 1].size)
>> +		return type->cnt;
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
>> @@ -651,7 +683,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>>  	base = obase;
>>  	nr_new = 0;
>>  
>> -	for_each_memblock_type(idx, type, rgn) {
>> +	for_each_memblock_type_from(idx, type, rgn,
>> +				    memblock_bsearch_start(type, base)) {
>
> I think we can just kill for_each_memblock_type() and open code all loops
> that use it and make memblock_add_range() and memblock_isolate_range() use
> binary search.

Agree, there were three places memblock_add_range, memblock_dump,
memblock_isolate_range, This patch already updating two of them.
The for loop is not complex to be part of the macro, Open code sounds
good to me.


~Tarun
>
>>  		phys_addr_t rbase = rgn->base;
>>  		phys_addr_t rend = rbase + rgn->size;
>>  
>> @@ -827,7 +860,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>>  		if (memblock_double_array(type, base, size) < 0)
>>  			return -ENOMEM;
>>  
>> -	for_each_memblock_type(idx, type, rgn) {
>> +	for_each_memblock_type_from(idx, type, rgn,
>> +				    memblock_bsearch_start(type, base)) {
>>  		phys_addr_t rbase = rgn->base;
>>  		phys_addr_t rend = rbase + rgn->size;
>>  
>> -- 
>> 2.55.0.970.g62bdec98f9-goog
>> 
>
> -- 
> Sincerely yours,
> Mike.

