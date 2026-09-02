Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 701E6C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DE06B008A; Wed,  2 Sep 2026 03:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BECB6B008C; Wed,  2 Sep 2026 03:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1622C6B0092; Wed,  2 Sep 2026 03:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D40F66B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:58:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AE2912076E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:50:50 +0000 (UTC)
X-FDA: 85168050660.30.FD4786F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B422B160002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:50:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ytq25x9Z;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788335448;
	b=SEpCUu0XDDmeHWSr5jBO91oykw7GJG+BmIofJIfi4RpHzmrGyj4501SI1I6Oh3vVCVnta8
	L5v5Zl/XLFF7AXY0dl7OgcqIWtNh+V4gDSOupn+6aMX5lCor5AZn/KR3LpB4j/JM3XNGlF
	v7wzuwCLpyUxtRIWtCOKNnhcCqMzEtU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ytq25x9Z;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788335448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQKQi6BjlLM/tFqlWQgDt+Hy+RAahli1Ac/ry6Tye0s=;
	b=NoUWMJPYBmKo3Whyt8Cj98SAj4WwX04Upbrj9hvElalFOr8H7914+cjzyfcWQl/Fww16vF
	eTlR+8CL6W9v2vxQZ3MmPazNNi1+qwQPYGGJDQvXDdmqy1IuzhSsC21GwOsE+MpZZukHJt
	NIr4alZs4/y2TOf8rUBX49UFlxMHMUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 136E340B48;
	Wed,  2 Sep 2026 07:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA171F000E9;
	Wed,  2 Sep 2026 07:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788335446;
	bh=HQKQi6BjlLM/tFqlWQgDt+Hy+RAahli1Ac/ry6Tye0s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ytq25x9ZypLI7pvIaWHby9YN/2xI3l2sCJNs7/09WI9M8Ijbrbm45iedYNdUZdYwJ
	 YztvJIkDFUF1FiiaArXjCDsuESH6MV+5J6IIL5xBG8TvYOr3lw4MRTy8RexGYD3lzk
	 ln7QNhswSQEXCWNIDEIeM/JMOGUVQ0/q2P4Ejmak4GMDG5NhoII6UUeBEOBfyHcbe2
	 NLurCHI6pSVyhUALB5kApFa1C13Ypo0/vMZm6cV5lND6j2RuKWh0dXlzkRlUlzfOGB
	 vukMqtASOWsB19/gDNEMKMBN+2kVygD42YfageoaNr2sjyvPzdVxNdL6VsMwzRiK3U
	 3NijN9UwqG6vA==
Message-ID: <f0b194b4-6f41-455f-b807-de7c24fa8184@kernel.org>
Date: Wed, 2 Sep 2026 09:50:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] docs/core-api: memory-allocation: add
 k[mz]alloc_obj() and clarify kmalloc
To: Mike Rapoport <rppt@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
 <20260831-docs-memalloc-guide-v1-1-547718c274c1@kernel.org>
 <23db34a1-ba1b-495d-91ea-18419e0dc8df@kernel.org>
 <apb47Rsnz1H36SOy@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <apb47Rsnz1H36SOy@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B422B160002
X-Stat-Signature: kx7bfo7umdnwbcqspmaijb81zgzgd9ya
X-HE-Tag: 1788335448-847521
X-HE-Meta: U2FsdGVkX1+r9D1wtL9L/3O5NeJn7um/2GF1FT8GAo1fHXxAhfv7sk9VDYEjWqlwFzGse5rQp2WGj1pbttGjoXZv50jwpzEKOAzAJ+8gK0oA32PLiR1PsuKmMj+IlgEtg3YAHCWg15/uDwavbO8nK3UNhS/sVtozmV9rpJlNBLGOo5FaS1SjzGOZLHyGd0JKPtdIzFBAham4KHhnEhGaKh3Dx+/64Qcv99QQrvrQw8wuNQjgHv0n3Cekd3S5BZqGPD2X8Qe01Aen3ugurdIgVGBaGyV3ZRd8nJlf3SmDJX6ICCAMkpXXO6DWB113fxBJvP4Fx08BrpHUjUz6AVvRSXjZLYwSGkYHtP2KKw09Rse5OAKO7QS2qXK86yKVz/eCoFDQHdCSZEz48X+of1ODJoWSHlk2Vm4xVZDzD8eJKF1iwLm5VYW8zaX8pc6w0UCRfPe0aloYm0BdC9bP7XAJa8JYsW1rMUSzGNXc3DvG/nlwGYRUhut/JYfJbh0+RAWwSFHdPUmixy6bqV8xhaG6YXEoG9ZVlg4UyOJdULtx1BLB75lNLP2aiF0h8J2pEdYfHlympD2kRHLCjPKaSExQbanPuNDYCTKneJxFEshJ5KwieoYZKCaW7mrdj31zRw9JikX4DHg7Yy4agaX3IwIzpps45JHuoqARTxlGVNmjhDdiSpAJKyCmcRP3i3wSr435GE5MRMrttnsidn0oJfDQlH9Co5R7i6tnHsqTNztp25zseq9qd3Fvf2cBSPN9wXDS5Af+6FG4ejAXdGeM8yT/rgGnYs5COJz5kqVNHJI1M0rri76XeCzlnVmXlHOov7H51v8q2Js1LdsKtXolh/6IiVMaW2s4ZI8CHEVcJjUh4O36x4wCjOCp7l8PYrywn9+dzpJWR83KM6vgestbin8WsYteaDw9sndAKZ9N/oqMiOV0Q2QNv3d8KOG3C9uxcZV3Z+STWD1kXMTeOd/xtk9
 KJcT8ymr
 JhrWyXlhL8NRSbz4jGw+15Kxfn5Sm6E1+Z7aBJcUwVZkZOk0/mwKSeBYZc3KF1GhRTcCBH8crjvfb8bgDkSvxQPd9waBw28Q0Kw5EBLzttXeufrcUPhU8ePmfzmmNe8e77vD/iR45d2a2Nip+KqZE/GCtFjdUA3LUS2pwMxFKd5Wfm2v5o6fd7KFDY3m37rCMogdcEp1yGn1vHewPrA7XLhimY3xn92PJvTxdX+gQveA1sQt/yTpj3EUgfWeVkmR9EcJDop0b8ORm1DaYJ2piBQGTag2gvYLzSdfwRPxeKK8mlZyqct5+71U/AF0zSeAl5RXb7eil4PBbf3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 18:10, Mike Rapoport wrote:
> On Tue, Sep 01, 2026 at 12:17:02PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 8/31/26 17:13, Mike Rapoport (Microsoft) wrote:
>> > Since v7.0 the most used memory allocation function is kzalloc_obj().
>> > 
>> > Update hte memory-allocation guide to describe k[mz]alloc_obj() family
>> > and make kzalloc_obj() the first answer to "How should I allocate
>> > memory?" question.
>> > 
>> > While on it, clarify description of kmalloc() size limitations.
>> > 
>> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> 
>> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Thanks!
>  
>> Suggestion below:
>> 
>> > ---
>> >  Documentation/core-api/memory-allocation.rst | 30 +++++++++++++++++++++-------
>> >  1 file changed, 23 insertions(+), 7 deletions(-)
>> > 
>> > -For large allocations you can use vmalloc() and vzalloc(), or directly
>> > -request pages from the page allocator. The memory allocated by `vmalloc`
>> > -and related functions is not physically contiguous.
>> > +`kmalloc` always allocates physically contiguous memory and the maximal size of
>> > +a chunk that can be allocated with `kmalloc` is limited by `MAX_ORDER`, the
>> > +same limit also applies to the page allocator.
>> 
>> Would it be better to say the maximal size is KMALLOC_MAX_SIZE which is
>> derived from page allocator's MAX_PAGE_ORDER? 
> 
> My point was that whenever you allocate with kmalloc() the limit is
> MAX_PAGE_ORDER, not necessarily for actual slab allocations.

The actual slab allocations limit is KMALLOC_MAX_CACHE_SIZE and that's
indeed not the point and hence I wouldn't mention it here. KMALLOC_MAX_SIZE
is literally a conversion of MAX_PAGE_ORDER to bytes, and since kmalloc()
takes bytes and not order as an argument, it seems more natural to me, e.g.:

`kmalloc` always allocates physically contiguous memory and the maximal size
of a chunk that can be allocated with `kmalloc` is limited by
`KMALLOC_MAX_SIZE`, which matches the page allocator's MAX_PAGE_ORDER limit.

>> (Also `MAX_ORDER` doesn't exist anymore)
> 
> Will fix.
>  
>> > +Internally, slab allocator differentiates allocations of different orders and
>> > +delegates larger allocations to the page allocator, but for the users of
>> > +`kmalloc` family it is entirely transparent.
>> > +
>> > +For large allocations that do not require physically contiguous memory you can
>> > +use vmalloc() and vzalloc() family.
>> >  
>> >  If you are not sure whether the allocation size is too large for
>> >  `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will
>> > 
>> 
> 


