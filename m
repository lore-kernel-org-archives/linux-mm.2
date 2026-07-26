Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73F0C531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 08:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13B26B008A; Sun, 26 Jul 2026 04:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4BF6B008C; Sun, 26 Jul 2026 04:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2496B0093; Sun, 26 Jul 2026 04:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B85B06B008A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 04:55:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AF9040451
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:55:13 +0000 (UTC)
X-FDA: 85030318506.27.723D0C5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 16DE640005
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:55:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m0xK5Px4;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785056111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hs1N9PJukNo5yhYX5Ar37gMntAG8X4mI7gcRyRjegA=;
	b=QlOTD/UOm4adpoP0xfnheD5mKsbXdwYXP75HKXrzGLDStstkejcIfPAfaF3lQYGLxAP8Mb
	GNfXBDQ0DBqhlD0V66I+GBMrdG2uJovAnMPdbemltWs+eJMk87rLOpNIP03ziha1dW1zca
	SwCGtjK9hozR51Ur6xmIpfbkPOc4aN0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m0xK5Px4;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785056111;
	b=34ZrTlfRvrE+TU1Wuk5YYS4eTVOT0fqi9BqVaFPnJV58V4TQEMMj/vHIMzaCMhj5o/l7Ek
	jTCVOBpY7PgonOND30t2W9JAhQLNsHOklP82B3wP6Fn3MpGPfuHnIvbfSOsdEWmB6bXEq6
	C0rj3EtqK+H7KNLJihpu+4gxtc44Ztc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F30D8339;
	Sun, 26 Jul 2026 01:55:05 -0700 (PDT)
Received: from [10.164.11.0] (unknown [10.164.11.0])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77BEC3F86F;
	Sun, 26 Jul 2026 01:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785056110; bh=B8VxLtUEWm05ZdkQT5GF34OFvxULa9Qs32lGvh5m4W0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=m0xK5Px462Tdkk8/a8tejI65BdEdLV2kdmwsjuendkcPeZHNW++/uyhcg5EThmU0x
	 YNRjzaNhyZlO2XipAKPK5rstDmXP8atv6mE54T4XYyWx+7ZYqzLFxogYyNw6M1lEEM
	 xItu+sptKlW2borPTneoqRMYRa5LVthxpC1Rf1wM=
Message-ID: <4e140f87-2928-4c87-b075-153a111884df@arm.com>
Date: Sun, 26 Jul 2026 14:25:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/usercopy: harden bounds checking for vmalloc
 allocations
From: Dev Jain <dev.jain@arm.com>
To: kees@kernel.org, akpm@linux-foundation.org
Cc: gustavoars@kernel.org, linux-hardening@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, david@kernel.org, urezki@gmail.com
References: <20260722142936.3287702-1-dev.jain@arm.com>
 <f3db438e-6cf7-4ccf-bd4f-379c549d1e9d@arm.com>
Content-Language: en-US
In-Reply-To: <f3db438e-6cf7-4ccf-bd4f-379c549d1e9d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 16DE640005
X-Stat-Signature: oe4am8uru6n31a4n9j6deo4k6rtu4wh3
X-HE-Tag: 1785056110-776867
X-HE-Meta: U2FsdGVkX19GT8VLFvaJ96/B+/mjZ7XFXMYvnkZYSgiPiK5SNS/APT8hQUwFT/E+Gvw8S3aXUx0n+3BE7ebcsOgUfqJqjFD1tN570D/jdcEhKDSSVz8ayewEC1sm42tW9ZgvVctujNPq3cj+JOs/DrUfwpy7PbekqOuskA/2GL9b2Ht0mRajXuos0bAlBZvACBcgaGWFq5dtqGLbWi7wtu5KWT+RIsP0We3sYZiJx3OiVSa/+0aKFRby6zhLpDb1OTq9p6i8ztGkRW0rIt6DUGv8giCU4Hxxh5MLmRQy5dzuoTgyUBxeSxJHOAC2jt+1R6PyITlNJF56fgqZVakiRuRnO4JpU5E8q7ijuxeSk9kLv/PCDaYHTveilfSRTEUI1wgKFJnuKqtZh7+bV1wbR0tLleCrnMgZuW7ir0Z0v1Q0SnKszekHK5kC3KAigNq4yV2uuYUn5OzfsmQ/IjF/Y4inUwSog5/wjnWABlhVZRTF03KBnt0rL4aVlWQyx/A9KW+cxr497Qb1TQSgO8pD3tk2rM7syralwXm0/B3G1u6v9/NUyst2fmckflD4rlfbQiX1oI6uzXSDoFrS9awRioWOqmJn1xD7cJn+nvSV2iwGQjDvEPQ+jU5xuoEWV+Udf3BXOxtFzoThtAFTlyHFWcg/nhK3+yGUs+PAVeLMP0c1GuMlYY9eF/BMajBTg6vPUcX+UeHII1fwzV3ygfXrGZPgdlFgk275If4iaisq9W2PDTrCkYjwuLtDEn/qhPMWzYkm/CukYvBEFrukrENP8oSi9BQDnc0IC9FHrX+xvJA9SszHUeZCX8jCwdB647QN5oWrOa2tThdOqOMB9ENuA6dDXt9z/XpJuW7e+ku75x+Jkm0LgKzAVw7401LU242FnRIbkEjIxy7La7ey6/bg0CEFCw3iab19+Fvq+WqtRCTJAvtPpmO5cxMtpncQXdF70RrC2uQqnUG6JzdTVnk
 ZbRae3DK
 lfAgLxYcty7NgwjbXBj2r0cJojMPTzRebXwbhkM9nYHamcn83U66nA7uAs67tU8GPG/9JBCS3eoz4VF5pM/A1fSW/oRPoqFqt5Sg52MiI/Qf4muhXhkRZYKR3UMCUTgvfj8SPp/MYpdNQVrSj3Tc/TXPFk05N107+9RFloDSlit5WgTaMppOzmFSUVLlW7boIn6jJRQshNr1MkOoEfE2yAXSDNCw4oSCjSEYUDm7y6WlhwoJP7VqT7VsIh77xPK7PXIocPLEdK+K9lC03ORH8Pjy+2aSkyfXpK5SA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/07/26 2:23 pm, Dev Jain wrote:
> 
> 
> On 22/07/26 7:59 pm, Dev Jain wrote:
>> The vmalloc allocator stores the actual allocation size inside the
>> vm_struct structure. We can use this bound in usercopy instead of the
>> page-aligned va_end to catch usercopy beyond the actual allocation size.
>>
>> For vmap, the requested_size field is always page-aligned since it maps a
>> certain number of pages. Same for vm_map_ram (alongwith, not even having
>> a vm_struct). So the check is only relevant for vmalloc mappings.
>>
>> Because there are early vm areas registered even before vmalloc_init,
>> requested_size may be zero. So also check whether the requested_size
>> is set.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
> 
> Sashiko:
> 
> 1. "Does this locklessly access area->vm after find_vmap_area() has dropped
> the busy tree lock?
> 
> If an out-of-bounds pointer falls into an adjacent vmap_area, and that
> adjacent area is concurrently freed by another thread, its vm_struct
> is freed. Additionally, when the vmap_area is moved to the free tree,
> area->vm (which shares a union with subtree_max_size) is overwritten
> with an integer size.
> 
> Would dereferencing vm->flags later in this function cause a use-after-free
> or a wild pointer dereference?"
> 
> 
> I don't get it. So usercopy is checking OOB for an object but shouldn't
> assume the existence of that object while using it?
> 
> It is a bug in the caller if someone does vfree() while usercopy is operating
> on the vmalloc object. I don't think usercopy should handle it. For example
> we don't handle it for slabs currently.
> 
> 
> 2. "Can addr still have hardware KASAN tags (like ARM64 MTE) attached in the
> top byte here?
> 
> Because check_heap_object() casts ptr to addr without calling
> kasan_reset_tag(), a tagged address will be numerically different from
> untagged kernel addresses. When calculating offset against the untagged
> area->va_start, this could underflow or produce a massive unsigned value.
> 
> Could this cause the offset > size check to evaluate to true, triggering a
> spurious usercopy_abort() for valid usercopies on HW-tagged vmalloc memory?"
> 
> 
> This looks genuine. check_heap_object() should be doing a kasan_reset_tag().
> We probably didn't catch this because no one is running CONFIG_HARDENED_USERCOPY
> with KASAN enabled, since the latter kind-of already stops the OOB bugs.
> 
> Even if they did, mostly we care about slab OOB's I think, and the __check_heap_object
> in mm/slub.c does a kasan_reset_tag() already.


To be clear, this is an existing bug, so shouldn't stop this patch from going in.



