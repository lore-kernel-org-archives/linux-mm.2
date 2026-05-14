Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E34BCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3586B0088; Thu, 14 May 2026 06:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665046B008A; Thu, 14 May 2026 06:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B226B008C; Thu, 14 May 2026 06:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 441806B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:23:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3EAEA03C9
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:23:05 +0000 (UTC)
X-FDA: 84765637530.13.CB2BB2C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id ABA831C0010
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:23:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VaCIY3e1;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778754184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBDnikyoTzyGCTEbUI8lgMaNXSiYKzrKprl5Cy00gZM=;
	b=YcnmELY18Aj357/jLJIcJAntNFCQLhsAqcQyqvyb2+ESi6MoLdU7BhhNPYy16gYe/keO+S
	0uFWl1+TR5PiGdVeEtXGkcrjT78juXtqthOXVF99zkVbNniPFc486ybWYCx8aRM5mgBher
	YyPkanpcucmub9vJIgWhd2TGx84F+gM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778754184; a=rsa-sha256;
	cv=none;
	b=HBHgT2m4rXtx8a/25FxLhJxsH0KlGSwhAPlNB2SnDJQ1l6Pdm5YIYDQpf24aWPwt74qj/L
	tzHcdGoSr6ViS+wiwg89DbhKtGKn9xKfAWZfx+c7ARep8TBLN2QkdLlxRqc7a42rIMhpQb
	l/AcqS909xKGyzODLBvY8VDK4/FfgGc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VaCIY3e1;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 072061655;
	Thu, 14 May 2026 03:22:57 -0700 (PDT)
Received: from [10.164.148.47] (MacBook-Pro.blr.arm.com [10.164.148.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B34D03F7B4;
	Thu, 14 May 2026 03:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778754182; bh=jzWryjg+VuWmthERUhxtCVABBovPPSvPdO9zYRbLN9c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VaCIY3e1mM/3lajYRe+4kEeATPJjHgU8XC8DGOZ/gGNs4k32VM9U6XL3g1QNFwMX7
	 aiE1mChsAlQuWiG6dtlqRE2QG1uwezLRN5eWNRz4nneCDgGMRgbFGO85Pk32T8U+pL
	 1qRkiXei4Y3UKQbNxNmYYSp43V/UdA6VLpVX9moM=
Message-ID: <794cc60f-4d51-40e3-9e06-4848d05a0f07@arm.com>
Date: Thu, 14 May 2026 15:52:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] kasan: hw_tags: some micro-optimizations
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, ryabinin.a.a@gmail.com,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com
References: <20260513105734.3380544-1-dev.jain@arm.com>
 <hk5e3gfh7hiiv3wknhkerz4k7qshortncqmkzsto6tn432364w@nidukxmif6ne>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <hk5e3gfh7hiiv3wknhkerz4k7qshortncqmkzsto6tn432364w@nidukxmif6ne>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ABA831C0010
X-Rspam-User: 
X-Stat-Signature: jsm7xqd54en94rw4mpp4rnp9ewbg8uj8
X-HE-Tag: 1778754183-595365
X-HE-Meta: U2FsdGVkX1/B4Yj0ZevDVYtyjTHuoFFEp4B6EPsTOFbsq8nYj2mrjXHf45jInG/X1k1a3f2ep6GrWuo27pY9u3GCKb4E9enVKT+ZzOON2JZyX5R6ZIyrSFYxY3YN3YxBPWfdtW/73XSopU1Mb29tdrA88N7KzNeeDqPt5bCzvLdWYhc3ImsvhUcoUvKl/4f6zEHAjeZGDE+Xkg3FH0/emKVIexDRa7D5iTfeNbppZjw78TmBZE7jLhZQLtpz3eqeUelzUiuWzMMK7LehlZTWGIKc9TNzzRkpL2TE4z5ed+XP8LjS7eQMOanI2pZeQK+z6xjdk3EI3PpDvmGniiLMIFdYFz4r2DkVa6ToC1kqR/WSw5FqDD9jhmDVd67pfAAzfB9ZhKnY5TANEltsUQUTU0bR1ARcRgqaw+SlRMop0CCx6lothO7X0W1FRHCU1VukSbPT98Yd6eFjN78v/xu2J4ZuEjINZLG1n8DIm+XwRQOb5zfMbj2VNJHcI2UWGYdeH9VLnBH7ovvawjaqAmj6Hfrw5v9y1OvJJdoIcSogoNWWVk1PE5O8aQrOhipkg+9O9tv9WwxUhvCqwJZVhzBoO8m+LdWGRcp8c/Q5vOvFCG0BFf4m3so5RpMd2waQADavltZsViSWbRZfTVudfJRHMjJRYiFCIjZEcP5pvzTgfRbGecip731VRiI8A+seSG+UvXiIvljrOAwlBYVbQS2lk+dOceOdqVbmAk3L/BWwCE9UA/hXzd1TkFYVMRGOvgYdlYr24Q0F0wzdfe7qUmlsMnpjMi8d25qeY6C6h0V4+dcSb80J9X5frgJKebH1toLCGplZkDCnLdQ58oQfIC4e8JSL47a28VfFqJSSs6vifoxozMArDDTVfQlCwXO1XHp1RbNAcIXB/7Nzh2x5qOmR6A+9ldMhWgDz7TW7ldR2TTVVrQD7x2D+6hXLKIk2qUnlwshNSJBRdtFwpZLJRvR
 pqaNhugp
 uwvAJVD0ydmyzqg6FUoKNH6xsUyH/jLdRrSgPDTtyvzNd7aRa3kXt+pC74FFdDkgtEVQihdyUm/6qzJLM0P5LbUjbu3EDB8CoewyJkjbtMt8rUNTAS/7yoGrSfKGaa8oRtt8btvuBCB4itp5SFBOrWIJeDrggPFqAAD0Xs2+Iu7Uhip6ZCfrSicjIb/nMKpkC6u8iyng5tVsHdF5oxyjTyWBpfDjXoyEkXL0j7/NOWWUbS9lHHODSRDQUeVjgkQlmnZ7LsvE1DOG2sA/9UJudHRCkZJdbYL3vMoXLZn6ao3WDxJx216FbgvOtGtq/2gdlMJOfZgVoAedLapE8KDtDspt4/T/MgavwMifn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/05/26 3:26 pm, Harry Yoo (Oracle) wrote:
> I have a few questions...
> 
> Does the performance of KASAN_HW_TAGS matter?
> 
> Yes, the performance of Hardware Tag-Based KASAN matters because
> it is meant to be used in production on mobile devices as it utilizes
> cutting-edge (to me) hardware support instead of compiler
> instrumentation.
> 
> Do you have data or are you planning to measure the performance
> impact of this work?

I will get back on this.

> 
> On Wed, May 13, 2026 at 04:27:31PM +0530, Dev Jain wrote:
>> Patch 1 uses GFP_SKIP_KASAN to skip unpoisoning of a slab page in the page
>> allocator, since slab allocator itself poisons the slab page immediately.
> 
> If __GFP_SKIP_KASAN skips unpoisoning, why should the slab allocator
> poison the whole page (kasan_poison_slab())? It's already poisoned.

Nice observation! Although it may not always be the case that the slab
page is already poisoned. If should_skip_kasan_poison() in the buddy
code triggers, then a freed page is not poisoned.

But, the point of kasan_poison_slab() is still served without it -
an OOB for a slab object is still caught probabilistically because
the allocation has a random tag.
> 
>> Patch 2 and 3 remove wasted work while poisoning the tail end of the
>> vmalloc/slab allocation.
> 
>> ---
>> Based on 7.1-rc2.
>>
>> Dev Jain (3):
>>   mm/slub: hw_tags: skip page-allocator unpoisoning on slab allocation
>>   kasan: avoid re-poisoning tag-based kmalloc redzones
>>   vmalloc: hw_tags: optimize vmalloc redzoning
>>
>>  include/linux/kasan.h | 17 +++++++++----
>>  mm/kasan/common.c     | 55 +++++++++++++++++++++++++++++++++----------
>>  mm/kasan/hw_tags.c    | 13 ++++++----
>>  mm/page_alloc.c       |  2 +-
>>  mm/slub.c             | 22 ++++++++++++-----
>>  5 files changed, 79 insertions(+), 30 deletions(-)
>>
>> -- 
>> 2.43.0
>>
> 


