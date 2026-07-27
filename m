Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F8A1C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 07:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5A56B007B; Mon, 27 Jul 2026 03:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86D26B0088; Mon, 27 Jul 2026 03:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C976B008A; Mon, 27 Jul 2026 03:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3206B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:03:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1473FA065E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:03:59 +0000 (UTC)
X-FDA: 85033666998.21.6C3BF26
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id DF38C4000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:03:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ifZFJuEU;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785135837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cz1a+7SrWpcA7BmxT3EOEdRFojx84kIFKmGK0C1nBRg=;
	b=6Ez9vgg1G1/fLAFAAo/yU4f9JxalDTAtrcSb9IWUgOaUGJDUlKKMXL1qTQ8RsUEtmRh6b8
	Ok75yOnUuKhagHaw3q1OH15AQG6himT1ozd3Budin+KjDN1V+d0Yw/nvBwVDWhpzZPJHay
	AqvqeHkopMZmjnnzW9bYjHswt+UQVF0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ifZFJuEU;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785135837;
	b=NEPRRA5RXC7GvmJCBmE2ZQCznJ8yGxZG5XY5DKQMe8OUqRLqn188hT47AYKfgdcf0lfoLC
	LihPXOSXIwiwFSX7M+AHs8jM7lVANxvOfuhGpXx0ZAYdZJp6BY8s33cgDuvOvXmc4ySJe/
	Olmo8v/XP0OYt08taZq7sn681vLdIek=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77D09143D;
	Mon, 27 Jul 2026 00:03:51 -0700 (PDT)
Received: from [10.164.19.51] (unknown [10.164.19.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE69E3F86F;
	Mon, 27 Jul 2026 00:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785135835; bh=4ltq6LtZBqJVd3I7pMRg9u6HVMA61yXfYDc8FQY5yWE=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=ifZFJuEU4VWNW/epbN4+hCZvMbZ69RlJEhdU1cImyCsU9NV6vfU3ttTkEghOFlwvz
	 WyVNZrWwQeebbS+fCJ88/AMYbNtcuQ6hVWTBqoLzSdhX2nZitlsOgyv8nBgVJ2Gag2
	 YrcwzppSiJI40iegLyh8rlslss0lNNIm/r6CUOBA=
Message-ID: <0a312983-3d63-4d60-8ff4-d53dcfff7819@arm.com>
Date: Mon, 27 Jul 2026 12:33:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dev Jain <dev.jain@arm.com>
Subject: Re: [PATCH] mm/usercopy: harden bounds checking for vmalloc
 allocations
To: Matthew Wilcox <willy@infradead.org>
Cc: kees@kernel.org, akpm@linux-foundation.org, gustavoars@kernel.org,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, david@kernel.org, urezki@gmail.com
References: <20260722142936.3287702-1-dev.jain@arm.com>
 <f3db438e-6cf7-4ccf-bd4f-379c549d1e9d@arm.com>
 <amXldUo3LfIGs-zs@casper.infradead.org>
Content-Language: en-US
In-Reply-To: <amXldUo3LfIGs-zs@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF38C4000A
X-Stat-Signature: cde3gy6ffbaqzkciomchfozh4romat58
X-HE-Tag: 1785135836-264564
X-HE-Meta: U2FsdGVkX1/MFfiKMYGjSkmq2JKSTvzC5Eb4qTXt4ITja3WmtPmXwBwbfqCZv/OQaCGmY6q65zkFReWCqsOjwdIIxa2hQq2axeuzv9f+3UsriauJ1rvzDBiS4Yu0vH/TfG75zPxe5HCioN2E3YTpHgAAzyUUeZdxGYHH6COe+UqL/ro6pOxx5LaQouiA0eIDRahVBlMNGI1FRjZxyX9BabWJF2QgiFZ3G8o3Le5BjK0z4gfenUUObQf5n3PT+P6r8+4N/y0vSV2MN29wafJkn29g+3d2UXY7uefqGAXnCZuSdlmNvGh0O/Sg7PwqYEspZBnkKPiHDj+xGrmeQpLpqoBreWYh4n+M7SRyQ143AB4oEKIp2ZCiFdUEhjYLcncsLIu8izc76bEP865HGbB60cgaFQXnzZCx3nnTh6RcjJw8XYzhZleb3NQf4guTVG8sAbm70gbYTOCCmEPc1JY8CGASLoKcX7nMIemPxbeJjKwaW2E/Vi7XxP2r5p3lqqo9s1CWublyE41YHWNv84shQd8kyT5cu4GYyzLJWSKWYGItsHMhpRgugSl8ib7H5XXUlx127/N55nzvdt7Onto8qRe1ehQ6UtKik04i059OCVUixFe/kB5mFiRPaYcFc5h61IYgPAcl8K4mILMMdXq3k65VhzwPCzVsRI0Jd0MdHc8ncX9arer7focGo0IsOLEE/Tz9e6OEampwHrLiBowpKJPkO2F9Om4r51n+sGl+TLshnJPpbdmHP1I0ZYAKZBpgeUYb8afo8V6FfAWwHfRwguAHabxYbWV8CJ2tE4S9yIoXWO7i7dN15UhZNFTxWya63alxjNDoyjAO0msl9VXICgwkSCSUhGTYJfQwHuJcErx9oPmIdhJwE5dlFgqME8CM49TEMGH53aLbWfKtq1c5Jxf4xgFMi+1T636gn4r4/jiud92GwJ2vHtFMPpVIFXUNVQ/VhaopBqMeX8yHpqo
 CZW0RvUB
 46mI3RzMfxRa9XZkaCgmWX9jbKsBWDPZ2rDGPlE/ZywG9oOeuhlBPq96LJelT9KpQ9hhydo0KvI6AGt/HpdwVdN7vaTxsHBqQ2DZ9EgbvIclGmMo0cFK6sDBcxo2zOlVaBEqvOtNbfDedreglX+yBj0P44+MOmgHvsu1PDiZEnLDzXoi9oHXY0+DhZ11hEclhxLzMK2bJvaFEcc1i21F0xa3nQjTx6Vdqxq0PDEOBrlVLwtZ3+cl6fyCVl3GpvLmcg/YT0Wy4vC3cCnugcoUafQeCH8xO6qruqOUE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/07/26 4:16 pm, Matthew Wilcox wrote:
> On Sun, Jul 26, 2026 at 02:23:20PM +0530, Dev Jain wrote:
>> On 22/07/26 7:59 pm, Dev Jain wrote:
>>> The vmalloc allocator stores the actual allocation size inside the
>>> vm_struct structure. We can use this bound in usercopy instead of the
>>> page-aligned va_end to catch usercopy beyond the actual allocation size.
>>>
>>> For vmap, the requested_size field is always page-aligned since it maps a
>>> certain number of pages. Same for vm_map_ram (alongwith, not even having
>>> a vm_struct). So the check is only relevant for vmalloc mappings.
>>>
>>> Because there are early vm areas registered even before vmalloc_init,
>>> requested_size may be zero. So also check whether the requested_size
>>> is set.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>
>> Sashiko:
>>
>> 1. "Does this locklessly access area->vm after find_vmap_area() has dropped
>> the busy tree lock?
>>
>> If an out-of-bounds pointer falls into an adjacent vmap_area, and that
>> adjacent area is concurrently freed by another thread, its vm_struct
>> is freed. Additionally, when the vmap_area is moved to the free tree,
>> area->vm (which shares a union with subtree_max_size) is overwritten
>> with an integer size.
>>
>> Would dereferencing vm->flags later in this function cause a use-after-free
>> or a wild pointer dereference?"
>>
>>
>> I don't get it. So usercopy is checking OOB for an object but shouldn't
>> assume the existence of that object while using it?
>>
>> It is a bug in the caller if someone does vfree() while usercopy is operating
>> on the vmalloc object. I don't think usercopy should handle it. For example
>> we don't handle it for slabs currently.
> 
> I think the question Sashiko is getting to is how we handle:
> 
> 	char *p = vmalloc();
> 	copy_to_user(p - 4);

Thanks Willy, I completely misread Sashiko's point.

I think this is an existing problem? We are using area->va_end currently,
so we can access freed memory.

But with my patch if the area is freed then area->vm can actually be
subtree_max_size. So now we use this unsigned long value as a bogus
pointer to retrieve ->flags and ->requested_size, and may accidentally
pass the check.

Trivially I can move my diff below the existing check to prevent this.

So now a copy_to/from_user() passing a pointer not lying in the vmalloc
page can be caught by the existing check. Then, my patch will always
retrieve the struct vmap_area of the vmalloc allocation we are checking.
So at least my patch won't regress anything from security PoV.


> 
> My quibble with this patch is that you've made this more precise at the
> cost of making it more expensive.  Is the extra precision worth the
> cost?  You're not running into anybody else's allocation (ie these pages
> are allocated to you exclusively), so I would tend to think not.  It's
> like calling kmalloc(93) and then accessing bytes 93-95.  It's out of
> bounds, but they're not anybody else's memory.

I hope Kees can jump in this as I am not a security expert :)


So the motivation of this patch is: From the perspective of security,
I am looking at ways to use arm64 MTE only when it really matters,
so we can get maximum security with as little MTE overhead.

Currently if we enable KASAN_HW_TAGS (i.e arm64 MTE), the kernel tags
vmalloc, slab and page allocator.

There is a measurable overhead for vmalloc and slab tagging. If you really
think about it, the semantics of the vmalloc allocator already give us
a lot of security.

There are broadly two ways an attacker exploits kernel (C, really) bugs:

1) OOB corrupting a member of the same object (type), and then using
that corrupted member to do nasty stuff

2) type confusion through

  a) UAF: Using the dangling pointer to access a freed object which has
	  now been reallocated to a different type

  b) OOB: Corrupting an adjacent object of a different type

I believe 1) cannot be stopped. A way of exploiting 1) is usercopy, but
vmalloc does not have an analogue of kmem_cache_create_usercopy().

2 (b) doesn't happen since a vmalloc page contains a single vmalloc object
(although I searched and there is weird code allocating a vmalloc page
and storing two different structs on it, let us assume this is rare enough)

2 (a) is stopped because vmalloc has a concept of lazy TLB flush: virtual
regions are freed into the lazy list.

The lazy list is flushed after certain parameters are met, so this gives a
vmalloc virtual region a natural "quarantine period" wherein a UAF cannot be
converted into type confusion. The dangling pointer can access memory it
already had which is not a security problem.

I just noticed that usercopy wasn't checking the actual allocation size in
vmalloc, so to further harden it without using MTE, I wrote this patch.

(Note that KASAN_HW_TAGS creates a "poisoned redzone" beyond the tail of
the allocation, so the concept itself is not new)


One way I can think of exploiting an OOB into the same page, is vrealloc()
extending into the attacker bytes. Following is a snippet of vrealloc code:


	/*
	 * We already have the bytes available in the allocation; use them.
	 */
	if (size <= alloced_size) {
		/*
		 * No need to zero memory here, as unused memory will have
		 * already been zeroed at initial allocation time or during
		 * realloc shrink time.
		 */
		vm->requested_size = size;
		kasan_vrealloc(p, old_size, size);
		return (void *)p;
	}



> 


