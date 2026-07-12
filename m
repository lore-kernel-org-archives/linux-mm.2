Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36BB7C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 11:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28FA6B0005; Sun, 12 Jul 2026 07:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED96A6B0088; Sun, 12 Jul 2026 07:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3446B008A; Sun, 12 Jul 2026 07:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2EE66B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:34:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A3461A0907
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:34:33 +0000 (UTC)
X-FDA: 84979916826.18.0E3D1E4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6408040003
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:34:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AiUG0i6H;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783856071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+Aa6jyG0fEkgQTKo5R2R5BGjkiXEItVdvI1P9GpXYo=;
	b=Xy/YSzYeEVo435AE4EB6pv39RZOtwLm2nGDfpQXMeAWvzH+laVdAzoyePYsgRtTQUH3h2y
	6kK3Ybfw2jU09xxW348iMYQo3YjZECsc2rvm8js6GqKZ2ZTcj3HfMPOvheyEPbCbnK8y2l
	FvHyPK+vgJ0z4SKQzLKyLW9yVjSjXtM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AiUG0i6H;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783856071;
	b=Y0qo2sbBJoebf2k87Nfd8hLKQ4nlBzfW1kO5nPg7ipdJDEueQL34io0uPZtncwY7YmY0/I
	oTeMFPV/W8cI1pgqSXVdu6rWz3cm+kuUGfoGFcKBb5LM4b80hsJEl+8RfqETfWTZOyFaLN
	EeHCAGRXsIC/CuMpoqaAj7DApXZtqI0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52D411688;
	Sun, 12 Jul 2026 04:34:26 -0700 (PDT)
Received: from [10.163.128.224] (unknown [10.163.128.224])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 63FAC3F85F;
	Sun, 12 Jul 2026 04:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783856070; bh=iQApNrWkND8FDy5QIKIhPDy1QVXCWDK+2ahXRVfNZeQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AiUG0i6HoybQfWvQD5k8wcZYBMuYiE+/LWz2ZFFXWT9FwNzEd3pme6sZ2tyvAD2fw
	 d2MaY9HG0Ok/VneoWcP0mYNnwIOITPtTxKPHsvan+cxcefm5KWJegnHiv5dkmRsfMX
	 gSqRoC92a+ZQDjFzLZ2SbgpzR+ZTYy41929BQt4o=
Message-ID: <8d109bba-4a8b-4d2e-9b3b-7c79441f7a39@arm.com>
Date: Sun, 12 Jul 2026 17:04:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: fix UAF caused by race between ptdump and vmap
 pgtable freeing
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 David Carlier <devnexen@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <8e320b30-9658-4e9f-ac4c-f99dcf855944@arm.com> <alNQccqtx5-QApup@lucifer>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <alNQccqtx5-QApup@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6408040003
X-Stat-Signature: pt6d6ppy5g3hm8s9wxj3uij5t3ot8yn7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783856071-329905
X-HE-Meta: U2FsdGVkX1/jDmSsrGQ/A391Y4sRMQoPJEk0J+JcqJjVM3gpxHXhonc3iGsDhbDC9uH3hB4QIom3oC4vD0QFG1dJhFNdfNb/5mEWy1jMuo+ig0FOw3fI7SfbkD0EKNQy4HbbPlO4/vp5XixY2h6c87S2/6pJWV9WOEqcfdUamtuGBfplpaPcapcRrhUPgjhn8n1pTgtQK2Q3DZmlCwBT8kydJfgAE+uaTI4JMHDFQrC7nWu8JEpAvIc9sgNmO6I1c9kLsyT0hUokkH/kwadfBXxPYa1lpt3UGkny8nyUjeYe0O2SmSFbHW0+Eb4xfoQhN+UypSi6Et1eC+DxursH/b6IHqggtMsf8bYRrBvPCnMJ4OOy5IZot2ZFR66IT4VSHL+AdNJx6VCwujA6QAtPycY+nDu4D+fmj94h3CZdU1RYR6ZXGrqrbwhSsABWqziMltjQ3rQxvOLA61Nu/aI+ul1bKUwenU7CSdvR+Tg6Kuk9TULq00hsdjuvDXE2z2EIRB7m2xEjBf8fBmYra2cH4fzojL78zNEae2TkoerZDIpa528kktVzhhxy46wDWxuFEvZS5PscLkAaUw9qJ06Dak0RRH3s907CBrVtZsrca9PlspAWfGztpdGrPixWaG/JyR0xwB+gQidx4GMorQbLPWpxakFYUL5J+KVhc+dYNeGKmNA4bhL/W921oMbhB36LrcKbe0wWe3br8ptLecxp+NwXy22ZhcqRw6He98fwSoqOecf60HJYdRwZdVJfgQI9T9r3lkQYyo5c1xyGVaw/iLHovShcGxdS18aN1Kx/Ld/zAnRZMK1rL6C/Vwf0ej9Y87GJkne0hKHWRgcjZcXPQYAv+BoNoxc+ZOfC/J82l/8OtTJUWYzpoHdvxS/2new8/4GTfcN0sBku8IhibWduOZ8eg4lP4VNZUxipEIYq2eMkaQl3IU6jCKx3O2PowSVrR7NX3YYOKJzxUmUlZTY
 3EHEjBkK
 CkPBtOFVfAi94sCHpODDiJylUiKK3O17aLGyqOfFGP5lBOm5WY/bYlBB4ghC5B6Vh71f9e/qgP32uS1/wIMyptBgLkm0Rh9VDxi2Fr5HAAmlzBTtbw0BV0DDACxVVXeBtYxernZmDS4fTtz9Y6egehQn30GYMhQLjsmw9beDnJddYp7Zjdvwg07PMA1ds+CmS2MQiclNkTgs08hWw7TEksFzLKu1DGDKGX+2QvTTPHI5xA3tiJgPT4JXwWukWulWuID481mMWRPTD3fzNH06r19evh9oiwlf+OqibYUVcVZXoyz3R1q3CJKTatdD87W4tdo3Z30valdX4aDYtr4lJpocYq+ZnW6U9rEVBc38hPLiqUBw3JXkA7JAPs7kOn+jB4WGzgG8LnLYjAXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/07/26 2:16 pm, Lorenzo Stoakes wrote:
> On Sun, Jul 12, 2026 at 12:50:08PM +0530, Dev Jain wrote:
>> Will Deacon had pushed back on a similar approach:
>> https://lore.kernel.org/all/20250530123527.GA30463@willie-the-truck/
>>
>> Although now when I read back that thread, it feels more so like my
>> incompetency to convince :) because:
> 
> No haha not so, I think more like this stuff is fiddly.
> 
>>
>> 1. I don't think this pmd_free_pte_page() path is a hot path at all
> 
> Right, and we don't actually alter that path anyway
> 
>>
>> 2. We are doing a try lock which is almost guaranteed to succeed,
>>    so it's not like we are losing out on block mappings
> 
> Also it's specifically only on when vmap tries to make a mapping huge, and
> this path is being inconsistent with a convention that already existed - if
> you manipulate kernel page table mappings that can interact with other page
> table walkers, you have to take the init_mm mmap lock.
> 
>>
>> 3. Any overhead from the try lock will get dominated by the pgtable
>>    page free/TLB flush
> 
> Yup.
> 
>>
>> I guess you did not take the RCU approach because that would put code
>> into the generic kernel pgtable freeing path.
> 
> Well a number of reasons:
> 
> * firstly yes it makes the code path always RCU only to suit a specific
>   debug user as you say :)
> 
> * Importantly - we risk genuine RCU stall issues, because the ptdump then
>   has to be RCU too over vast ranges.
> 
>   To work around that you have to shard the ptdump walk, make an assumption
>   all callbacks are RCU-safe, and that the sharding suffices to avoid these
>   stalls.
> 
>   It's a ton of complexity and assumptions to account for... vmalloc doing
>   the wrong thing.
> 
> * It is an established precedent that we mmap lock init_mm for kernel page
>   table walking as per mm/pagewalk.c. It'd require significant rework there
>   and would disallow any future walkers like this if we were to require
>   RCU.
> 
> * The mmap lock approach is simple, safe, and as you say is only actually
>   required in code paths that manipulate page tables and thus are already
>   not hotpaths.
> 
> * If there's future work to free vmalloc page tables upon vunmap()
>   (currently it does not), we have a stable, established basis for doing so
>   that again puts the weight of the work on the operation being performed
>   rather than anything else.
> 
>>
>> I liked the RCU approach because I hate the fact that ptdump takes
>> an mmap_write_lock when it is literally only reading the pgtables.
> 
> Well you have to do that for the userland side, because there could be a
> concurrent downgraded mmap read lock during an munmap, and the same goes
> for non-VMA kernel ranges too, so it would have to keep doing that
> regardless.

Oh right, I didn't know x86 was using ptdump for user tables too.


> 
>> But your approach is simpler and fixes the problem at the particular spot
>> and not hammers the fix into a generic path. So overall, ACK.
> 
> Thanks!
> 
>>
>>
>>> Lorenzo Stoakes (2):
>>>       mm/vmalloc: acquire init_mm read lock on huge vmap promotion
>>>       Revert "arm64: Enable vmalloc-huge with ptdump"
>>>
>>>  arch/arm64/include/asm/ptdump.h |  2 --
>>>  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
>>>  arch/arm64/mm/ptdump.c          | 11 ++---------
>>>  include/linux/mmap_lock.h       |  1 +
>>>  mm/pagewalk.c                   | 22 +++++++++++----------
>>>  mm/vmalloc.c                    | 41 ++++++++++++++++++++++++++++++---------
>>>  6 files changed, 51 insertions(+), 69 deletions(-)
>>> ---
>>> base-commit: a635d6748234582ea287c5ffeae28b9b23f91c7e
>>> change-id: 20260710-series-vmap-race-fix-2a4cac988938
>>>
>>> Cheers,
>>
> 
> Cheers, Lorenzo


