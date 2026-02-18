Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4F6E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 10:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D086B0088; Wed, 18 Feb 2026 05:38:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B716B0089; Wed, 18 Feb 2026 05:38:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FF46B008A; Wed, 18 Feb 2026 05:38:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E69F6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:38:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 208C8160514
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:38:20 +0000 (UTC)
X-FDA: 84457227960.25.1DDBFCB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F4A7140009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:38:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771411098; a=rsa-sha256;
	cv=none;
	b=0UGEYTcVrz3IOcPEO3LJ80DC3UQGAq4GR8+Z6lIGhFM+xO92iYdJdEuzh9dhUbaslHHNua
	lxHm7KFvInUJMLikjSqS+Lvpe67EkzCyf+0KlcZnYR6F8xg6az+O4iab+QvOfO8/vK7Ado
	Lfn1gafUA1LApVfOSMV6XRRpI0Nj+QI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771411098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=avwwh3WxJg4dUAHa39kIjhIhmqYlDgya9MjleoteMtc=;
	b=PRRw22NOHdgK3vMGjmG+yQiQrcFCrGbyTRqIKDZiV8aIMo+EuERRbOz8ZOsLfmUDrHWbiu
	r/l54rHGZ2QhsTTYCL6tEFfsgRey8w0XzHWU+35SJ4Can/L1fhBGJDbTwh68hBg37gDmaP
	ol9jZjnez7nUA5znRql1hlxWEqVsGTU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0691A1477;
	Wed, 18 Feb 2026 02:38:11 -0800 (PST)
Received: from [10.164.19.71] (unknown [10.164.19.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32FF73F62B;
	Wed, 18 Feb 2026 02:38:13 -0800 (PST)
Message-ID: <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
Date: Wed, 18 Feb 2026 16:08:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Pedro Falcato <pfalcato@suse.de>
Cc: Luke Yang <luyang@redhat.com>, david@kernel.org, surenb@google.com,
 jhladky@redhat.com, akpm@linux-foundation.org, Liam.Howlett@oracle.com,
 willy@infradead.org, vbabka@suse.cz, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
 <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
 <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
 <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
 <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
 <5dso4ctke4baz7hky62zyfdzyg27tcikdbg5ecnrqmnluvmxzo@sciiqgatpqqv>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <5dso4ctke4baz7hky62zyfdzyg27tcikdbg5ecnrqmnluvmxzo@sciiqgatpqqv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uunnhtenurjtqmt7k7fc43wg1cdr1zt9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F4A7140009
X-HE-Tag: 1771411098-319939
X-HE-Meta: U2FsdGVkX18YMNu26Sqms2U7Z7S73DI+XFVyX5Bzu8QzrQcs06ufvVGiM1g5ytXL40yMtTDZexBrzF27vDMNNiHrt8dw6FlXq+Os+uL6ULFQDLbmGwl81xrIYuAiBDClxUa+NEilfS3MvTteYshs0tVCDIx+UHxTFFqXHdmYhRNtkMuIJCnhu1n6K+u8jAxNdRjP7W65AyaLFoyC4Gbr28DyY7MU9F2eYzw6XhmjmJOTyDBz2/NyJVYpo7Oi9lVx8NsfVMFNQvbM4Wg7XOZvJTUz7A26W1ngdCOPKbagQ6xViLbf/WhiaUCVI/VmFgKh95Nx1JaaHoSwRi5adInDEV2QjHR4u87js7z9ulbyQ3PdQKS6fgO6UufaHX/xEuSh4MfjFmQtdomOLpE2mgzmRaF6f8cGyb79W8UnbLQbIaVPz/0buEEDjPhTq4J9PiBuiNtyaTnqQcAwGZW2q7+rEKUJ3yP8/5hlfpTHWbWftVduhQMf8SldEmpOMNqKQlOtcDU2tQcfIOVWhGUfvA5kHCX+viLu8/Jzsc7xsIgqfNxjiDbIeluRqD8+67f3ElUmzzwicU2k+n2nvTRKEeeZOUlU3Jr3Re6kmwJzvdzdIXq+HXGu0AuUyDdvH4nlWxzQzgSyDkVZ4opsIFe5A4/lehKUAFGVbtlLFjs8QaKgV4UxnWY/9V+5Gqm7eYT78PYVQGD2lWvL07DfQfdf9gUTXAGsJwBZMSs9O7Am8nIxjwrgF3mUBP/J6TB3us7iQgWOGupdZQlsZhioZuZ3VIAdLYcLEayTXjhof6czwLK5vGfr9uzvJYDA4cYXBarUGTe6I0h0CWclUL9T80zibZZ+fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 18/02/26 3:36 pm, Pedro Falcato wrote:
> On Wed, Feb 18, 2026 at 10:31:19AM +0530, Dev Jain wrote:
>> On 17/02/26 11:38 pm, Pedro Falcato wrote:
>>> On Tue, Feb 17, 2026 at 12:43:38PM -0500, Luke Yang wrote:
>>>> On Mon, Feb 16, 2026 at 03:42:08PM +0530, Dev Jain wrote:
>>>>> On 13/02/26 10:56 pm, David Hildenbrand (Arm) wrote:
>>>>>> On 2/13/26 18:16, Suren Baghdasaryan wrote:
>>>>>>> On Fri, Feb 13, 2026 at 4:24 PM Pedro Falcato <pfalcato@suse.de> wrote:
>>>>>>>> On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
>>>>>>>>> Hi!
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Micro-benchmark results are nice. But what is the real word impact?
>>>>>>>>> IOW, why
>>>>>>>>> should we care?
>>>>>>>> Well, mprotect is widely used in thread spawning, code JITting,
>>>>>>>> and even process startup. And we don't want to pay for a feature we can't
>>>>>>>> even use (on x86).
>>>>>>> I agree. When I straced Android's zygote a while ago, mprotect() came
>>>>>>> up #30 in the list of most frequently used syscalls and one of the
>>>>>>> most used mm-related syscalls due to its use during process creation.
>>>>>>> However, I don't know how often it's used on VMAs of size >=400KiB.
>>>>>> See my point? :) If this is apparently so widespread then finding a real
>>>>>> reproducer is likely not a problem. Otherwise it's just speculation.
>>>>>>
>>>>>> It would also be interesting to know whether the reproducer ran with any
>>>>>> sort of mTHP enabled or not. 
>>>>> Yes. Luke, can you experiment with the following microbenchmark:
>>>>>
>>>>> https://pastebin.com/3hNtYirT
>>>>>
>>>>> and see if there is an optimization for pte-mapped 2M folios, before and
>>>>> after the commit?
>>>>>
>>>>> (set transparent_hugepages/enabled=always, hugepages-2048Kb/enabled=always)
>>> Since you're testing stuff, could you please test the changes in:
>>> https://github.com/heatd/linux/tree/mprotect-opt ?
>>>
>>> Not posting them yet since merge window, etc. Plus I think there's some
>>> further optimization work we can pull off.
>>>
>>> With the benchmark in https://gist.github.com/heatd/25eb2edb601719d22bfb514bcf06a132
>>> (compiled with g++ -O2 file.cpp -lbenchmark, needs google/benchmark) I've measured
>>> about an 18% speedup between original vs with patches.
>> Thanks for working on this. Some comments -
>>
>> 1. Rejecting batching with pte_batch_hint() means that we also don't batch 16K and 32K large
>> folios on arm64, since the cont bit is on starting only at 64K. Not sure how imp this is.
> I don't understand what you mean. Is ARM64 doing large folio optimization,
> even when there's no special MMU support for it (the aforementioned 16K and
> 32K cases)? If so, perhaps it's time for a ARCH_SUPPORTS_PTE_BATCHING flag.
> Though if you could provide numbers in that case it would be much appreciated.

There are two things at play here:

1. All arches are expected to benefit from pte batching on large folios, because
of doing similar operations together in one shot. For code paths except mprotect
and mremap, that benefit is far more clear due to:

a) batching across atomic operations etc. For example, see copy_present_ptes -> folio_ref_add.
   Instead of bumping the reference by 1 nr times, we bump it by nr in one shot.

b) vm_normal_folio was already being invoked. So, all in all the only new overhead
   we introduce is of folio_pte_batch(_flags). In fact, since we already have the
   folio, I recall that we even just special case the large folio case, out from
   the small folio case. Thus 4K folio processing will have no overhead.

2. Due to the requirements of contpte, ptep_get() on arm64 needs to fetch a/d bits
across a cont block. Thus, for each ptep_get, it does 16 pte accesses. To avoid this,
it becomes critical to batch on arm64.


>
>> 2. Did you measure if there is an optimization due to just the first commit ("prefetch the next pte")?
> Yes, I could measure a sizeable improvement (perhaps some 5%). I tested on
> zen5 (which is a pretty beefy uarch) and the loop is so full of ~~crap~~
> features that the prefetcher seems to be doing a poor job, at least per my
> results.

Nice.

>
>> I actually had prefetch in mind - is it possible to do some kind of prefetch(pfn_to_page(pte_pfn(pte)))
>> to optimize the call to vm_normal_folio()?
> Certainly possible, but I suspect it doesn't make too much sense. You want to
> avoid bringing in the cacheline if possible. In the pte's case, I know we're
> probably going to look at it and modify it, and if I'm wrong it's just one
> cacheline we misprefetched (though I had some parallel convos and it might
> be that we need a branch there to avoid prefetching out of the PTE table).
> We would like to avoid bringing in the folio cacheline at all, even if we
> don't stall through some fancy prefetching or sheer CPU magic.

I dunno, need other opinions.

The question here becomes that - should we prefer performance on 4K folios or
large folios? As Luke reports in the other email, the benefit on pte-mapped-thp
was staggering.

I believe that if the sysadmin is enabling CONFIG_TRANSPARENT_HUGEPAGE, they know
that the kernel will contain code which incorporates this fact that it will see
large folios. So, is it reasonable to penalize folio order-0 case, in preference
to folio order > 0? If yes, we can simply stop batching if !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE).

>

