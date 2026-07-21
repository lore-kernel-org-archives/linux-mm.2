Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DADA3C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13E86B00A6; Tue, 21 Jul 2026 05:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB5B6B00B1; Tue, 21 Jul 2026 05:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D044E6B00B2; Tue, 21 Jul 2026 05:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A37A96B00A6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:23:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C6DDC03F5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:23:21 +0000 (UTC)
X-FDA: 85012245402.11.097C343
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7D4EF18000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:23:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bI8/+VZ3";
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784625799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AATOw6YQ1sIpEbY+KeCTcTRiayqedE1/R6uTPVHB/gA=;
	b=8VwVYSZ5D8db10JZ/8DXfytBtmtgSDWmfWzhYfwJU6vNZMkJVB2rSOI85Qm4+9qt9Bime9
	HmzkXHjinAbNRVReWt9OnQezlMAEooofG+1qY7HpieG9ySTKpiwrNfo9oRQa2vTEdfAxFe
	U5YQ1O6xWyl1W/KECDkMxZOPHuR74lY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784625799;
	b=zfDAr4vPKzFLx1e7pGnqbWV5x4yaPIf8493BOJcSUcWPAFJgY8XxJP4mXWn5mpm6tA/s6p
	D3CFM9o5ES0mkaKTbRd/zQJerVzTNvVzPY+YUEdKbor/X7ZrMj0G8X35jPoxys4ppc1wQf
	Sx9GfNlfLN61R2ttrEPIi+/sSGHL9vg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bI8/+VZ3";
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7D7660AA1;
	Tue, 21 Jul 2026 09:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C25D1F00A3A;
	Tue, 21 Jul 2026 09:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784625798;
	bh=AATOw6YQ1sIpEbY+KeCTcTRiayqedE1/R6uTPVHB/gA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bI8/+VZ3mWyeB/E6Z3Q4ZSlnsRIcq16tiBSwfW6RbFFtGhrAHc4o4lCmnQAmY2HIc
	 6CBwSeN6fhTSyOvnVZH5YtxDkcORiiRoYOezxfCJK174jOoviLo3hYOd/1kwPzM1mc
	 StD/fVAF/hnr3pvXdmbSy1cXLdPEEb6B6RWIeV5i5M7euryuNXUayTYfMhsyvHhlay
	 chBgHTbl+wtJoPdtSZLJ2b3E7AVXZkbgY70pk4KYFDMqTg2/bomwr6vQP4AamD1DaE
	 HykGvfuiQfro/3Vil7c72LtnEZI0Zx1eYHZ4h0mGfRnXC30fcduPAile8zfTnZmrhm
	 amZNRn03nw5aQ==
Message-ID: <392e6115-cc92-4c33-bbbe-1211c279a518@kernel.org>
Date: Tue, 21 Jul 2026 11:23:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/13] mm/slub: skip handle_failed_objexts_alloc() with
 profiling disabled
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>
 <d76d5e96-ccf7-44b1-9dc8-3246466f9640@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <d76d5e96-ccf7-44b1-9dc8-3246466f9640@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D4EF18000A
X-Stat-Signature: o8zuot8edp6oqjzxadtq9exegqy3pmbx
X-Rspam-User: 
X-HE-Tag: 1784625799-276458
X-HE-Meta: U2FsdGVkX19uovjbzANE/QyiJkfd52Z6o0qpJvaOMPzK3p8CqNiLEklH0Zf54lJZ8DJ9zjURMzLdZ66yS3OYzGINSI3ua0pY12coewWqV+9nfpXA9sjpWEO0lVDnfNgRILxX8qHy7qtM17c4cAhfuOJsTJljeofgviexBw2sZIL8WVCfDU3/dJKecL9S0i9o19WK9fTKvnmSH8G94oZQjEyNoTEVExDBgxuBtY2rhlHxr7sBlAmaZmPdGFzoM0wAz1KYtcI91VsLtENUpAr+Gc6BgupR1TWzRgFqux6hHlsiB8gXnGf3VqpYzEa0d8IP3eFGDRkVmHhAhio4qsgj5dmRLiCbmx3s7tL0w6hHyRK+MhazSdGIGo7zSQovc49NYaNd1AhJ7/8AbiVss9c27SvMI033M15ASw2HpOTy1AS4vzHFlgEVkEsFH9tKRhqhYeZnQkUT9g8niKECGUM8vONIgbUxlb3qn7bVsYohlon9rUutjoIZgoVPByJv74moo+EQhiznKeyPPz4xxriE/riOTdM9DGmuHoNWqbIvmukRoCFv9UVLwczd6/I6nklIna1pld/13S0YaXysJBdB24rPtnIHtQqJv34k2AUQLvyFNeZfbOguA7otH9S/GitjiYnv0L+KeilSx4Pa1Rvoh8wWczDqbdAAImXXzfIpu+GARLmyWVNjoAKhKX5iZpjdR6mA5PSOdnEkq41Uix6JQ+iJXhtbOz2GO5M9UB9h48b/EVd5IXZkwKovfNPNjo/Y8tnkEI6JgmtDJZUufvBjbrylEqbTYOm+d6j55N0g1oiTLYQi2ap1yhI/TtbEmmNaxM6X0gU/hxGbuHbMptYCwmXW3NN5sReHKEhn22ZJL/DouOGz82lclXWzW6alDeon5GrxRBUnZF4OjSBw97m1+MEckx19X+Ti/+TdPN08XLGkaWNGRsFOxxRTiJmy6kJPWSEPZzqOnED/Hn7ZQIk
 DeO/5NWW
 yVs0NE38crygynT4lzI3fXYJyecXAv4XgkfEAHo+Ognq0v6ogpB/Lc+Ijlk5Gj+YCS5T5KXjiF4CGUWK+umarnkuYmgkKybOtObMvqLrEfaqOS+1Qv75doyLEJosqFnSh2v1OE9hWwYDnanWvIn5k8DN9u/1rbl2VJplM4xZMEco2uu/2zVz2G0odedH/a+birFK3ahdf4FHu1rGPKZiFRIEzUhb5BgIqPi1/dpS6nYKEi3iaerSXjJHmKGVMqxSp8eQ8XsJmFSd7zp/ZrWoD1pMRH1W/x3GxVlWKQSqTxUib6i+b9rknNorvdJGIsGQCFsxV7t7me4BarstHOJWw1w1L73QoAgaVQgh7C//rP/NFBr0B5ZCVCsDg50A3QqwAKQxdLwGqW+urmyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 07:51, Harry Yoo wrote:
> 
> 
> On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
>> The function might get called with memory allocation profiling disabled,
>> when the obj_ext array is allocated for objcg pointers only. The
>> handling is however unnecessary in that case, so skip it.
>> 
>> This would otherwise become a real bug later, as pointed out by sashiko.
>> For now it's just an optimization.
>> 
>> Link: https://sashiko.dev/#/patchset/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org?part=10
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slub.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 76acb78f2655..95fa6fbad11a 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2101,15 +2101,16 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
>>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>>  			struct slabobj_ext *vec, unsigned int objects)
>>  {
>> +	if (!mem_alloc_profiling_enabled())
>> +		return;
> 
> This looks racy.

Indeed, not sure how I convinced myself it's ok.

> Can we instead do this later in the series depending on
> slab_obj_ext_has_codetag_key's value?

Yeah.

>>  	/*
>>  	 * If vector previously failed to allocate then we have live
>>  	 * objects with no tag reference. Mark all references in this
>>  	 * vector as empty to avoid warnings later on.
>>  	 */
>>  	if (obj_exts == OBJEXTS_ALLOC_FAIL) {
>> -		unsigned int i;
>> -
>> -		for (i = 0; i < objects; i++)
>> +		for (unsigned int i = 0; i < objects; i++)
>>  			set_codetag_empty(&vec[i].ref);
>>  	}
>>  }
>> 
> 


