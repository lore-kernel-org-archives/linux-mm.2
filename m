Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3662D41170
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 11:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0223E6B0098; Thu, 15 Jan 2026 06:08:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0EF96B009B; Thu, 15 Jan 2026 06:08:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE72B6B009D; Thu, 15 Jan 2026 06:08:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CADE96B0098
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:08:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79E5757CF1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:08:11 +0000 (UTC)
X-FDA: 84333923982.20.6E8826F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B031912000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:08:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPQ80tW6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768475289; a=rsa-sha256;
	cv=none;
	b=YhsMHk2Voyt7caEB3OzMTJ4i0aT1E87Z1VCsDSkPFfy3jrzg4pC0BrCu0h+QZXUfXlkeXO
	R/MJ4Y+kSoPTmyKna+d4fQmXMTY+EyeGeIsZeGa1wxEDzvpE3ZR3bVV8pmBaqDCzaPTiIT
	3nDgSiyZsx87J0ZAwQF54TA1kBFyhvY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPQ80tW6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768475289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1z51B2tTbdcBOWzcrhbC9GPDp47T95LE+4K2YUPTWgs=;
	b=y3z6TglmZVwSIMDSQa3nqb1CqdgnHNZjH1dDnHd4dJelY8WL4clUrS/ekldNPA3omDZY+O
	arFCXrTxGbbRkU6Q5yGkmouodCjvB3/5yme8zrPJ5qJKBb0uPLbN5BHibM+aJZrYz/8ViG
	nZXuM9XcvJEXHypZsiZb0aPRqiR0vQA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22B19601B4;
	Thu, 15 Jan 2026 11:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02623C116D0;
	Thu, 15 Jan 2026 11:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768475288;
	bh=xhdaHl4/ngri70l/ireOIGRjuzbSEjHleSXgbBiALEU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EPQ80tW6ps9GIXyGSKlnRjsotHo4vGwae8JkIVV+6qUGCnwfSuvT7fheuomv0MWJ/
	 SmhUfQSK67qpxtATdlsaEwGAMi6jfTNiHPSv0xJgqPlOBZgl5XJZnKkTfeaZuVc8FR
	 IsamkoHDRcfuFFGHFvskUe9JNGMam5V3jEvxkWIKTUDMK9i+slKi3sdaiRvN/l4Nzn
	 ATRiuR4qIQ1XR5/ypj6og95ukRXLrQrcnZVy/dhczy2H1gR87wSLOX92QW1kQuZ+1j
	 prUR4FUJV9ydLCBP1KK88w9Nx9zC+rQ60fOb5tbxPLRiwwqHwLjtGbvjBSTo0zOKfZ
	 OlvGlF75JD4uQ==
Message-ID: <83798495-915b-4a5d-9638-f5b3de913b71@kernel.org>
Date: Thu, 15 Jan 2026 12:08:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, ankur.a.arora@oracle.com, fvdl@google.com,
 joao.m.martins@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mhocko@suse.com, mjguzik@gmail.com, muchun.song@linux.dev,
 osalvador@suse.de, raghavendra.kt@amd.com
References: <9daa39e6-9653-45cc-8c00-abf5f3bae974@kernel.org>
 <20260115093641.44404-1-lizhe.67@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115093641.44404-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B031912000E
X-Stat-Signature: cngopy8bnsg344g13edrfrjfxn5iq1nb
X-Rspam-User: 
X-HE-Tag: 1768475289-919867
X-HE-Meta: U2FsdGVkX19eIm7FTfLx/IfqjQQo+PEIQDuKlyKhRZxBLvW+mRXod0KzXZlSETE8mF5i/pkEKfI0+q6zR2Gfk7zp341nIe4APXiOw1DETZK6nMaDpMIsx16SYu+yiUCuiffoYPspB4sA0+3uWpCMmiOs6ItxjpCmb/c9hDbXaadViayiWXycIB2sfunQe6x5ZKFxD30Jqot5zN2GZ1Drz6+D/f5zqwSFp6mKic7vpU87qpibvOd/e5IWNRt/2z2G59ax94cyhV7VBOY1Af8iKWWjbtBMlInOPFCR7C2wGsex/tRCAc/3Wpz51N5h1amLdxOSHM2hMO+uVrkw4tmggv7o0XSNWihI9ig6r9NtKH7E7fIzHELm7ookC6OEPP2IxeGrgG6U0y7a4Gz7sj+ZV8HKtC8QBhmpzx5EoFhY1zper2Y9AGKXbgCvUMTn3zVoFSrJzphgqe2cKNB7Ho/nbXJH5DvVfMg9883ArBQUgVk+ORjcu3nFV63Kpk/85/hTsWjl2QFt/YQ1gGJza16amZbdL3Qa7KnG/2nPL6rYvF0Y+37L50hFP/DBEwuVUwXCJOYAy/ct2YiP+BYA1GTi9RN41t0uG8E/2cIpL5h17H14PjMGEu+yTb1GB7FG/1JM78KTRyXcnhPH3AjdUYqOGUt3CFIm1GbPCqeW3XUP8aBp/W0jrP07VV52DNnfQ7y89QpJZJBmgSJ6BFC0UQUk49QjHv4ScotPwunePbKjQ2hH59y22uVHvYnQ7sq/diE3DIXYPTAHYb6h9VHuMm14RydyYVG8IM3MpZTresRVSV5XUUVNo0NKzNiif1wt27sWOeFT2Zo5s+HyS76gBtYpZtHk2O7vawOxaaqv3RQpIMu5QQ3/kRu5gHID5QiR86ZwGpJV8Xqo6YdGDqKYhpR2BRq4DwlX9ThAmFkY2WUaP06wCDAVuAqPNEd4RulrFkhbeUy6QqbbRHUtu7cgR3H
 Now8hj2T
 OrLI1fE8rRO/d/ZEvxAH1iPORxRtJTkqPA2Ck10I6Y8KFna5ePy8q7Ip7LI8ZXCvHBdmKs7w5s48FoNPdV1IAjev+exjVi77xFOaeScqdFkVAODVQyvVZkVSRcfgTWY8hlltL2PyWGwHv0HVh4nagvgPOLwTlcQNEor65ZnM0wzsG4fX8rz1yu06zWRXwA/LEc2nMX3xePuTDy8mUBU2iRCAyguewHZeR6qY5544BOU0E2ctT7ywRtoIt2CIapavyq1zzVxTI0EBQzKlQVR1SjlGZqZgiK6rhiS45
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 10:36, Li Zhe wrote:
> On Wed, 14 Jan 2026 18:21:08 +0100, david@kernel.org wrote:
>    
>>>> But again, I think the main motivation here is "increase application
>>>> startup", not optimize that the zeroing happens at specific points in
>>>> time during system operation (e.g., when idle etc).
>>>>
>>>
>>> Framing this as "increase application startup" and merely shifting the
>>> overhead to shutdown seems like gaming the problem statement to me.
>>> The real problem is total real time spent on it while pages are
>>> needed.
>>>
>>> Support for background zeroing can give you more usable pages provided
>>> it has the cpu + ram to do it. If it does not, you are in the worst
>>> case in the same spot as with zeroing on free.
>>>
>>> Let's take a look at some examples.
>>>
>>> Say there are no free huge pages and you kill a vm + start a new one.
>>> On top of that all CPUs are pegged as is. In this case total time is
>>> the same for "zero on free" as it is for background zeroing.
>>
>> Right. If the pages get freed to immediately get allocated again, it
>> doesn't really matter who does the freeing. There might be some details,
>> of course.
>>
>>>
>>> Say the system is freshly booted and you start up a vm. There are no
>>> pre-zeroed pages available so it suffers at start time no matter what.
>>> However, with some support for background zeroing, the machinery could
>>> respond to demand and do it in parallel in some capacity, shortening
>>> the real time needed.
>>
>> Just like for init_on_free, I would start with zeroing these pages
>> during boot.
>>
>> init_on_free assures that all pages in the buddy were zeroed out. Which
>> greatly simplifies the implementation, because there is no need to track
>> what was initialized and what was not.
>>
>> It's a good question if initialization during that should be done in
>> parallel, possibly asynchronously during boot. Reminds me a bit of
>> deferred page initialization during boot. But that is rather an
>> extension that could be added somewhat transparently on top later.
>>
>> If ever required we could dynamically enable this setting for a running
>> system. Whoever would enable it (flips the magic toggle) would zero out
>> all hugetlb pages that are already in the hugetlb allocator as free, but
>> not initialized yet.
>>
>> But again, these are extensions on top of the basic design of having all
>> free hugetlb folios be zeroed.
>>
>>>
>>> Say a little bit of real time passes and you start another vm. With
>>> merely zeroing on free there are still no pre-zeroed pages available
>>> so it again suffers the overhead. With background zeroing some of the
>>> that memory would be already sorted out, speeding up said startup.
>>
>> The moment they end up in the hugetlb allocator as free folios they
>> would have to get initialized.
>>
>> Now, I am sure there are downsides to this approach (how to speedup
>> process exit by parallelizing zeroing, if ever required)? But it sounds
>> like being a bit ... simpler without user space changes required. In
>> theory :)
> 
> I strongly agree that init_on_free strategy effectively eliminates the
> latency incurred during VM creation. However, it appears to introduce
> two new issues.
> 
> First, the process that later allocates a page may not be the one that
> freed it, raising the question of which process should bear the cost
> of zeroing.

Right now the cost is payed by the process that allocates a page. If you
shift that to the freeing path, it's still the same process, just at a
different point in time.

Of course, there are exceptions to that: if you have a hugetlb file that
is shared by multiple processes (-> process that essentially truncates
the file). Or if someone (GUP-pin) holds a reference to a file even after
it was truncated (not common but possible).

With CoW it would be the process that last unmaps the folio. CoW with
hugetlb is fortunately something that is rare (and rather shaky :) ).

> 
> Second, put_page() is executed atomically, making it inappropriate to
> invoke clear_page() within that context; off-loading the zeroing to a
> workqueue merely reopens the same accounting problem.

I thought about this as well. For init_on_free we always invoke it for
up to 4MiB folios during put_page() on x86-64.

See __folio_put()->__free_frozen_pages()->free_pages_prepare()

Where we call kernel_init_pages(page, 1 << order);

So surely, for 2 MiB folios (hugetlb) this is not a problem.

... but then, on arm64 with 64k base pages we have 512 MiB folios
(managed by the buddy!) where this is apparently not a problem? Or is
it and should be fixed?

So I would expect once we go up to 1 GiB, we might only reveal more
areas where we should have optimized in the first case by dropping
the reference outside the spin lock ... and these optimizations would
obviously (unless in hugetlb specific code ...) benefit init_on_free
setups as well (and page poisoning).


Looking at __unmap_hugepage_range(), for example, we already make sure
to not drop the reference while holding the PTL (spinlock).

In general, I think when using MMU gather we drop folio references out
of the PTL, because we know that it can hurt performance badly.

I documented some of the nasty things that can happen with MMU gather in

commit e61abd4490684de379b4a2ef1be2dbde39ac1ced
Author: David Hildenbrand <david@kernel.org>
Date:   Wed Feb 14 21:44:34 2024 +0100

     mm/mmu_gather: improve cond_resched() handling with large folios and expensive page freeing
     
     In tlb_batch_pages_flush(), we can end up freeing up to 512 pages or now
     up to 256 folio fragments that span more than one page, before we
     conditionally reschedule.
     
     It's a pain that we have to handle cond_resched() in
     tlb_batch_pages_flush() manually and cannot simply handle it in
     release_pages() -- release_pages() can be called from atomic context.
     Well, in a perfect world we wouldn't have to make our code more
     complicated at all.
     
     With page poisoning and init_on_free, we might now run into soft lockups
     when we free a lot of rather large folio fragments, because page freeing
     time then depends on the actual memory size we are freeing instead of on
     the number of folios that are involved.
     
     In the absolute (unlikely) worst case, on arm64 with 64k we will be able
     to free up to 256 folio fragments that each span 512 MiB: zeroing out 128
     GiB does sound like it might take a while.  But instead of ignoring this
     unlikely case, let's just handle it.


But more general, when dealing with the PTL we try to put folio references outside
the lock (there are some cases in mm/memory.c where we apparently don't do it yet),
because freeing memory can take a while.

-- 
Cheers

David

