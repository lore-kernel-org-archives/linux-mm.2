Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CE9606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 19:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LyZfe9UI
Received: by kanga.kvack.org (Postfix)
	id 115D36B05B0; Thu, 26 Nov 2026 14:04:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6396B05B1; Thu, 26 Nov 2026 14:04:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6F06B05B2; Thu, 26 Nov 2026 14:04:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF2C16B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:04:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55E9BC0552
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:04:22 +0000 (UTC)
X-FDA: 85478195964.28.D075FF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8524E40016
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:04:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LyZfe9UI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795719860;
	b=HQW3rwqxjb/CaaDnkbX80rkrOH6YgnZztwaChYpuaNAdygI9Q/AKIHmlBLkG0RG5COWa7I
	/wsA4q1k7o6/B1dkXV8Vhpwb+D+iFkIhHzsw//Ae8jBFnmuGbC36aCYQZUWXD4FCDHHAjn
	8CUe937+ujJxxfO546fjdTEZkbUx2e4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795719860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8S26I6ok0b8j0h9YQ9IUuW55x9LrqcCKF+IrYf7BDO4=;
	b=zWtSymgSTvDDZpvf1D7JnMg+SOQibmRpD1r8YzFAc5ucMBq0gtQE/hGX3pBqCTZBaRSp5R
	qgy+80DUD2bVaDKW9rjpB86HsvGnRA5CUNkChg0Molt8dYkozL+763ByBKAvfhJBAV5G2z
	Fg0e3wZGM8rWdvq4lI9ShGpoYBr+ZeA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LyZfe9UI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B519A4443D;
	Thu, 26 Nov 2026 19:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C5F1F000C0;
	Thu, 26 Nov 2026 19:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719859;
	bh=8S26I6ok0b8j0h9YQ9IUuW55x9LrqcCKF+IrYf7BDO4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LyZfe9UIsfZsjtR4FVcI9/XOT/YilWBirVEmLuQzo7NPIBZ8XUYKiLRNl93xFqLnq
	 zSH0VxCrqEegpTdUq1tb+9rHrBq5IdmhfNp8Fdnqf08N/UYw3+9UMrV5cp6kLiTEE/
	 oMFelfcH+pgvoufFKnwd9FzvE6z+rboT+5Kx5LmuHXc1249mPSxzg+WQvmzr6wZrDS
	 cPD8zRmPJQofozgSCYI9NvvgIZ6xPjL7NlDH8qxxDjc+vxew3isRm0SzH6agL4cFFC
	 9DwfvPWPFYsSt6bT+UkBrIL7ibz2TPdvhZCvEVWTPRx2gzWo+odibnTCilwMfjEWMw
	 nOhfyb8O7aO4Q==
Message-ID: <4cb6e0ea-5e6c-4ecd-b673-70b42864c694@kernel.org>
Date: Thu, 26 Nov 2026 20:04:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/slab: add own entry points for
 kmem_buckets_alloc() family
To: Harry Yoo <harry@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Kees Cook <kees@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Marco Elver <elver@google.com>
References: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
 <20261124-kmalloc-entry-rework-v1-2-37b1631a67b5@kernel.org>
 <awg-2hrOmY5U3vzS@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <awg-2hrOmY5U3vzS@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8524E40016
X-Rspam-User:
X-Stat-Signature: gquyhgfe3gyqztuma4q3cr8phk6y7xu9
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795719860-667253
X-HE-Meta: U2FsdGVkX1/9cFTi+bEoGfA5jLviMucaThUED7UBFb4Yrl8mppXGp2QrtxWn2szLVIjQPZVhSOh9qmvE6sPR8qTQZ0VtIJ2M5IaTEPavdBFZ725RdFFyl5wdX4/iDFss2bXnD/7VtPm/L7/M/ishJAuwzhVOJBMlS7kFSJ1wkAkxyGDGJkHJ+K7/pQcMk/v3kwIiw87eDS4hHSTSZe1jL9sqFFdrvCZAnUfl9kP1jPZIMcPOAQ0+ePG1H9zTw730U0SNBkzVr5rNPgLBBAW45YlyoIg3onzJvudyvRVqhUJXaRktFsdjd5h8ogAZw92BP02m+FhAUwu4iYsDZa98c2XnH5vmcGRW1N2SJYAI3D8ECpw2WWqCzNYFoIoJPYMp+OkmuLErBlHlGG2fG/ADXieAhbiXK9CsMUUg31UjAop3vWwjJVwM9GQIarR3qbIUiBFatt1cninECrKL/W+mShn138tQSnKSAjoLoWhRbnk8WWePb5WUpN0CXhoqDc5JTIqOci3eIJ8A4Sov15T8XGRuaY7MvKbChrMxAc3qbStsER7bpFm7WT3OeIczBp9IccFkyGmqYnviLI2fZhf75bjuQJqSbL30l2BwRzWvxvFPz0b3tPZ1fDwuQ6M7sXnJDlYGgwVVGkPXoKXhXD0RydS/dSRT2W6TkUo2BmVBhg60pyv9Fem+aFLVdJdBYf4uSlzdx5TlRi1j/lriBnnBQ3DZlfaPA0dbmqhJQUpdMvGvp9dWHATJ7C5e4oKpim4lI0pxz2EekHdZTwdoDtb4crMxoAb171NkkS5hjH7zHH+AUaU/MoD4yRWFT2rLsU537G+lzZVUdTA2q4c3eZbV32q7oNyBfoBmRrKkJqWm3EqbBLEVa4IR+9XO7zB1MP/Hl/TAaTbGURvGRx1DsGEvjkPi/J3dTo9CPta9rAr1H8x0uZGRTTGAM3QTWZzFmiH7r+MjPLnhdV9uYPM4eHL
 0iZhEbB2
 9NFD5/ffmduSJ6NRfi4z2IlbQ9t7mGUxgbQv87t8U1256CIjR1T83hG9S9L8iawO3QzDsnMTxZET3UdihfjCmvvNs77NauchgpEZYC5g8qwt6l7j7mZjWmUcXprmB+ro66NqqoORVMf5BAUoQ60Z+bdhXDUVLKhZADPMslDqQ8gtu708frvuCjxpbPnizoV39A4zdR5a7tCR/kJiCrF5zsmRaQay4+k/kNZ4H64bcU66j33XVXtFnNvn1aQaI0b3knRHgCxN3ngELDDZr/8WJWUE+hktjX35R6ypGXQjEc1WoYpl0zN14RsuTsuuF9U+Q+KAYKIkRJ+1z1lhT8Qq92Msxe8AoXP+ZUgbsMg4zi11IG0J7wyhEYlvVGfxXwMymTv9R6hMDZhpsbWcOxuaHmAFMwFZzunExcTi7gmaANjchHkRaVg4iE42+qrn9CW+D5LGEXBCB4ai8X5QBgdxhvDNmNuZ4+HSArFAUOU9xknLZQwF1Y2YivPzRiJKOTZotFSEyhHi57kWi2Lt2XW49ZkfDY1K8JN4SDGK+7vH/QTfSylA554iNwG+WMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 15:22, Harry Yoo wrote:
> On Tue, Nov 24, 2026 at 05:30:03PM +0100, Vlastimil Babka (SUSE) wrote:
>> The way buckets have been implemented was to extend
>> __kmalloc_node_noprof() and two more functions with the kmem_buckets
>> pointer parameter, which means all kmalloc_node() callers now have to
>> pass NULL. To avoid this extra parameter with CONFIG_SLAB_BUCKETS=n,
>> we added macros for parameter declaring and passing.
>> 
>> This can be avoided by creating own entry points for kmem_buckets
>> allocations and not using the kmalloc ones. They all end up performing
>> __do_kmalloc_node() internally.
>> 
>> Since it's just 3 functions with few callers, do not try to do anything
>> special to eliminate code with CONFIG_SLAB_BUCKETS=n. Only make sure the
>> bucket parameter is changed to NULL in that case because it would be
>> ZERO_SIZE_PTR otherwise.
>> 
>> The removal of the now-unnecessary parameter macros is done separately
>> next.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  include/linux/slab.h |  16 +++++++--
>>  mm/slub.c            | 100 +++++++++++++++++++++++++++++++++++++++++----------
>>  2 files changed, 94 insertions(+), 22 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 70df0a2e3876..6674caabbb6e 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -5732,6 +5732,34 @@ void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
>>  	}
>>  }
>>  
>> +void *__kmem_buckets_alloc_noprof(kmem_buckets *b, size_t size, gfp_t flags)
>> +{
>> +	const struct slab_alloc_context ac = {
>> +		.caller_addr = _RET_IP_,
>> +		.orig_size = size,
>> +		.alloc_flags = SLAB_ALLOC_DEFAULT,
>> +	};
>> +
>> +	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
>> +		b = NULL;
>> +
>> +	return __do_kmalloc_node(b, flags, NUMA_NO_NODE, (kmalloc_token_t){}, &ac);
> 
> No type-based or random kmalloc partitioning w/o SLAB_BUCKETS?

Hm that's right, that excludes it. I didn't realize that, but also I wonder
if anyone would really choose to have partitioning enabled but buckets
disabled. It should be straigtforward to add it though. But as long as
buckets are not disabled, the token parameter will be effectively unused. Kees?

