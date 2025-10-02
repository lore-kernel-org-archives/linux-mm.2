Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40133CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 14:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598C68E000E; Thu,  2 Oct 2025 10:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570998E0002; Thu,  2 Oct 2025 10:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ACF18E000E; Thu,  2 Oct 2025 10:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37F888E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 10:31:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9C6D11A41C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:31:06 +0000 (UTC)
X-FDA: 83953411332.22.514B4EF
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id F1DC2140012
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:31:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V50gRus1;
	spf=pass (imf23.hostedemail.com: domain of 3p4zeaAgKCIgvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3p4zeaAgKCIgvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759415465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3U0yCIHNLTL7647O2FMhOisTrIzQr/JoD1Esv6My+A=;
	b=ObLRQZwANqXo5uHsvIsm9rw+1pqRrQnXdDW5SWiyWTBeBPRT/Yug1db4rEWYEP4dESy7WY
	Ie0XLX0d7UDcysAhgps2ctibzc/OgjGQRY3EygU7FPvg8tFCgQG/vtImhdhMfYRyaNSgKI
	BHB6x8295YdSiGd27nZ2++6mIOl4/nY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759415465; a=rsa-sha256;
	cv=none;
	b=WdAzZ1bXZQIAbqC2d3VSaZc4J/kATIUXWgM4Yp56jU6CAxs6pqEdp1xHBxwc9dtFp9Oe5R
	Z9kOj3RhbfPwRldiFIG5lMp7l6NBPE1gdyAcO1BaQZCkvRx/igazWIT2OUGUdDLZhk9cGM
	4MsSPbF6UtTdkZPZ2UYN1dLI4PveCuc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V50gRus1;
	spf=pass (imf23.hostedemail.com: domain of 3p4zeaAgKCIgvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3p4zeaAgKCIgvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-63049fca047so1411890a12.2
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 07:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759415463; x=1760020263; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T3U0yCIHNLTL7647O2FMhOisTrIzQr/JoD1Esv6My+A=;
        b=V50gRus1aILupxUlmXlNnQ2g7hA2czC0AmfiVhg1IKZrsbSY/Wjs6vi2jcF6/ceYQI
         u3MR3PBq/FyK7qYifinnAM+9l6Smva6H32PoJqNb6iTtGZBRpQiqZT7Se1lKn7TvNV3N
         lYyuR4lGdw59yLyfap9m8qKwTDf33LBDKbemf/jUWa5Cuy5cH4HkiFArHpcOwXh6aQnY
         1AEzAO3H/AT7cwej01co4SiA0FvRcp0Bh91KlHko+i4IKm+wtHNveNoYdxvPDIUvZz64
         nP9DffL2eqIjm/f/utRQPxyLT59MoDehPKBuGQrlAzqsEaSWQEQowRNAMZX1w/ZJ+PbT
         PD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759415463; x=1760020263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T3U0yCIHNLTL7647O2FMhOisTrIzQr/JoD1Esv6My+A=;
        b=Cfq5CGzU2dqU2fQLcFAWXRiHaeFN9881cd+r7Jfxn4Qa+Z65cFqIIQUzaViB54KqTt
         wFnCOYrETQDLwB3MwY6nG/CxRuEtI4SgLk6MAiNuRVKkeCMLcOSgls3iKsufhxZMgl39
         yAF7gTeI3NTVsls5WsG/MD3bZbWWbavbkVH79LvKe/GOzDGc7XPZAj+vY6jxCQu2ZT3C
         /j1WEfBrRoBvfp+MN+llb9fWLUD+MWkPlj7gTV6aBCBAEi2JbGfxfrh8a0CucJhgU5F7
         wWNp7w2GlmtM1x+2jEtuW/r/jDpqnWPmWrM3lq8usWeG0JZBn742AroQNBQZVyiJmgHV
         DEzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGeLmRsRcvb+zrLD0aIXM+YE2r009uTDMcQsJCu2AI28YWnGI8niPzNgxvvnTFaDkw6ix0MnjpxA==@kvack.org
X-Gm-Message-State: AOJu0Yw2NECzaVAyw/wG2qSK/3LR2WBbCtzyVQVUQOYbCYSnCtHQqnGl
	wjtQmfNwM3gDGw6lfgvqmxMkFoFIFxYoDWjh+MR/nP5w9YS/gJM+rZMLZdD1vBeknLRy79S+l7g
	6v2ZtasuHCfxhCg==
X-Google-Smtp-Source: AGHT+IE8MEQbvPTnpHeVFsAD/pDo+XU5CHB4S/EYPztJT8lypC4YxQYsalKuMeDgFWaBeAm3gcG8mOLS8jK6VQ==
X-Received: from edqp24.prod.google.com ([2002:aa7:d318:0:b0:632:b2e5:2588])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:27d2:b0:637:e253:45d0 with SMTP id 4fb4d7f45d1cf-637e2534824mr2698706a12.11.1759415463266;
 Thu, 02 Oct 2025 07:31:03 -0700 (PDT)
Date: Thu, 02 Oct 2025 14:31:02 +0000
In-Reply-To: <08338619-6aa1-4905-bdf8-bf1a90857307@intel.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com> <08338619-6aa1-4905-bdf8-bf1a90857307@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD7WQ97R8OG6.1CA5E2FU5ISMZ@google.com>
Subject: Re: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: <peterz@infradead.org>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<mingo@redhat.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>, 
	<david@redhat.com>, <derkling@google.com>, <junaids@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <reijiw@google.com>, 
	<rientjes@google.com>, <rppt@kernel.org>, <vbabka@suse.cz>, <x86@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F1DC2140012
X-Stat-Signature: d76gr1ywpt4swsjrf3zjqatbn7jqqund
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759415464-53364
X-HE-Meta: U2FsdGVkX1+MBYHEndX9CWSjHJGMlhDe8e2zO1vmhnPgNh4ag8L58UvkjQ6Ch7g7uYDuxZfdGK+HhZmc8xX53KCRTlEf6aMZSMHMq6HEQIeKvXRM40ZUzo+2KnxuGuX4Yyfc4t6obgPD79vSMkZnz3OeSNSk9Qy0R1axHMS2vNBC14B/kCUjeJCvh1K3bAPb7NbZxSqzKN0tFzSR+1YPw3GdzNqJo5gQ3Lsl4PYv6r+7QAxyp+WJCKU0kt7UshcxVB9n0Ma9YyEaz8kuhoJlkacAK11/vL0TGUNOrlj4/SDhXbysf8J27WMXxpP/efKdKORga+klu5i2/9sD5grT9wSypDZoo1FLhzwzJpvq6aSEPbvBr91bi02XiQk9itfE6xUaRx94HuRpFXDCqjm+5COAL6TFQzEKmRIMMaxgdVlSf5r8CIUbNSTRd9ZmwMxVyv3DGUHJxtFlED3oi/Io7Ket2UOE0il21JakKP7BAIp+/YRnDZ3SqkEBymtHzd8eD7E2cMxQzulLVtkLGBEZX3+bvYwsb3fmRNGetvGI+aM1ZU0/gAdUHhhdfzNECPY1fSE85hYzxh8hKp5IMgGX1G1qs/7t9c++chwDNF/GdoVk09iOgDfuZ1uxB+CKYYAODGEANrOVWB/XGLk1jK+Ts6ZxAsH6X7dEerlVSjH/rIUOnU8u2y6Fei2UReNl5GTT22PVEpL0gwY/Uy8VAGJ0xiTzacfhojdNUaeE0clgD84bL2GCOFNGcuPZ1h/MGgfpTfLgxk2C97790zTS84BiKYKjL5yyWnAoFxPBvpS4K1BEKe4Xder1nJOKcqS8W9eSLl4q7QCaGnlHe5bLSeUXokQDHls4psWUn5NpL2pIerjbFDCk6u8ifp/sVa6KM4kCHyWURF3wZ7l/VMWOBGdGqwxfocLhDiyOBjHDFm66JGekmesD0k4Ydc19lk16LC4VBqMZlx4KcuC2QZxf1ep
 +8+8H50P
 8UCW3nLQNklQNtP8xi+KB8+LB8of3f5lMJ4M+jCITuqN95e66zWY4ppyZMQzc6Y3Ms5o7aDIfr9pN22isEvyBMRKccQSf1vouhXmONktcPMglZyrWfvXUMBL1mVOllj5JhlsQTTuuYLND/WbPl2lM1szljeGvtkh41ws10g9KpGb+HdQRVC8CmhOHNzBbn+slCjvu7I5OKlbKPodhTMUe2v/6symbWCANH/EElTwadgKUYV6tsX4wjWEnMyOvmD0EPJA9FQwcC7CXod59yvyIZ8nvF3SsP92BtXLEEnIu0dZcdGzyQR+KjNrokgJ99YVeSQz9WEnKhf3q64u7Buz5+EWnRx0cWP8c3SyKRgIaU0KSHQjODNCz7QpZI3UDilFlK6OdrxOC3TkAeSWKODyYY8ItHeImBJSm4ErtXZbvyiSn5ZfmLdtHuaIMD9tWMloXcvcUqpEO5l0v1K/n5Z32IP/yCcZHrI6zNv2qQCiQSaQqmCEGg6afZPVhZV1rWlyKxJdDRkrwhEgCAYkRkABmwDP+fpsM3cBUx1Oe2cX0uG0lw0UFeBPL8O3ot+dFfppLcubV0xAQm1ynmA8a/nFlHhu5ycz32vR2z3sKoGXvNqewSbvL0AZ8ziHXPBYKSbmB8XYrtZwE3dl2G79mxOltaUuEdSXMK5TmHypY3LMJWp1cUCFutZWRDEPl0zwSd6OuwKqC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Oct 1, 2025 at 8:50 PM UTC, Dave Hansen wrote:
> On 9/24/25 07:59, Brendan Jackman wrote:
>> ASI has a separate PGD for the physmap, which needs to be kept in sync
>> with the unrestricted physmap with respect to permissions.
>
> So that leads to another thing... What about vmalloc()? Why doesn't it
> need to be in the ASI pgd?

Oh yeah it does. For the "actually entering the restricted addres space"
patchset, I'll include logic that just shares that region between the
unrestricted and restricted address space, something like this:

https://github.com/torvalds/linux/commit/04fd7a0b0098af48f2f8d9c0343b1edd12987681#diff-ecb3536ec179c07d4b4b387e58e62a9a6e553069cfed22a73448eb2ce5b82aa6R637-R669

Later, we'll want to be able to protect subsets of the vmalloc area
(i.e. unmap them from the restricted address space) too, but that's
something we can think about later I think. Unless I'm mistaken it's
much simpler than for the direct map. Junaid had a minumal solution for
that in his 2022 RFC [0]:

[0] https://lore.kernel.org/all/20220223052223.1202152-12-junaids@google.com/
	
>> +static inline bool is_direct_map(unsigned long vaddr)
>> +{
>> +	return within(vaddr, PAGE_OFFSET,
>> +		      PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT));
>> +}
>>  
>>  static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
>>  			       int primary)
>> @@ -1808,8 +1814,7 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
>>  	 * one virtual address page and its pfn. TBD: numpages can be set based
>>  	 * on the initial value and the level returned by lookup_address().
>>  	 */
>> -	if (within(vaddr, PAGE_OFFSET,
>> -		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
>> +	if (is_direct_map(vaddr)) {
>>  		cpa->numpages = 1;
>>  		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
>>  		return 0;
>> @@ -1981,6 +1986,27 @@ static int cpa_process_alias(struct cpa_data *cpa)
>>  	return 0;
>>  }
>>  
>> +/*
>> + * Having updated the unrestricted PGD, reflect this change in the ASI
>> + * restricted address space too.
>> + */
>> +static inline int mirror_asi_direct_map(struct cpa_data *cpa, int primary)
>> +{
>> +	struct cpa_data asi_cpa = *cpa;
>> +
>> +	if (!asi_enabled_static())
>> +		return 0;
>> +
>> +	/* Only need to do this for the real unrestricted direct map. */
>> +	if ((cpa->pgd && cpa->pgd != init_mm.pgd) || !is_direct_map(*cpa->vaddr))
>> +		return 0;
>> +	VM_WARN_ON_ONCE(!is_direct_map(*cpa->vaddr + (cpa->numpages * PAGE_SIZE)));
>> +
>> +	asi_cpa.pgd = asi_nonsensitive_pgd;
>> +	asi_cpa.curpage = 0;
>
> Please document what functionality this curpage=0 has. It's not clear.

Ack, I'll add some commentary.

>> +	return __change_page_attr(cpa, primary);
>> +}
>
> But let's say someone is doing something silly like:
>
> 	set_memory_np(addr, size);
> 	set_memory_p(addr, size);
>
> Won't that end up in here and make the "unrestricted PGD" have
> _PAGE_PRESENT==1 entries?

Er, yes, that's a bug, thanks for pointing this out. I guess this is
actually broken under debug_pagealloc or something? I should check that.

This code should only mirror the bits that are irrelevant to ASI. 

> Also, could we try and make the nomenclature consistent? We've got
> "unrestricted direct map" and "asi_nonsensitive_pgd" being used (at
> least). Could the terminology be made more consistent?

Hm. It is actually consistent: "unrestricted" is a property of the
address space / execution context. "nonsensitive" is a property of the
memory. Nonsensitive memory is mapped into the unrestricted address
space. asi_nonsensitive_pgd isn't an address space we enter it's just a
holding area (like if we never actually pointed CR3 at init_mm.pgd but
just useed it as a source to clone from).

However.. just because it's consistent doesn't mean it's not confusing.
Do you think we should just squash these two words and call the whole
thing "nonsensitive"? I don't know if "nonsensitive address space" makes
much sense... Is it possible I can fix this by just adding more
comments?

> One subtle thing here is that it's OK to allocate memory here when
> mirroring changes into 'asi_nonsensitive_pgd'. It's just not OK when
> flipping sensitivity. That seems worth a comment.

Ack, will add that.

>>  static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
>>  {
>>  	unsigned long numpages = cpa->numpages;
>> @@ -2007,6 +2033,8 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
>>  		if (!debug_pagealloc_enabled())
>>  			spin_lock(&cpa_lock);
>>  		ret = __change_page_attr(cpa, primary);
>> +		if (!ret)
>> +			ret = mirror_asi_direct_map(cpa, primary);
>>  		if (!debug_pagealloc_enabled())
>>  			spin_unlock(&cpa_lock);
>>  		if (ret)
>> 
>
> Is cpa->pgd ever have any values other than NULL or init_mm->pgd? I
> didn't see anything in a quick grep.

It can also be efi_mm.pgd via sev_es_efi_map_ghcbs_cas().

