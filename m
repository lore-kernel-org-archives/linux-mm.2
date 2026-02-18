Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D139E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 12:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9B86B0088; Wed, 18 Feb 2026 07:24:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C737D6B0089; Wed, 18 Feb 2026 07:24:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA05A6B008A; Wed, 18 Feb 2026 07:24:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A48AE6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:24:37 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FD0E54FD4
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:24:37 +0000 (UTC)
X-FDA: 84457495794.20.BE2CE25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 75927100005
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:24:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uh294/Qn";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771417475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4Rt0Jpmx6xExghnf0gjEIklWmFbMuD/NwdIvrNmnPM=;
	b=i0glq9/aSoZiVb9P/2RPgt/e6DlrvLD600/2AXeH8f5mjAk60cuEku6mIh77fZ4p2mm46g
	vg/q+thrI+qRuxiVadnE4WPbHaaEKchZxYdnd2bfB3ID17ijOIp/D98mphnI2e4Dp0WI3T
	korDpIGiGvzlJNuLV/J7eZHDTgrQlzA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uh294/Qn";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771417475; a=rsa-sha256;
	cv=none;
	b=Kji8WLBhFugK0KPzbJbllegUxgQBgBaHu/CPd3bmDPZVs88SDzsUeAvOLGNtFQPMdCRiOK
	NZ7LfkToluHrf4D5aR0/NUfILinBDQ2w++EkymAz5mmJEaZC+xVNztXbrEUGbpm/BAVZj6
	czY/8S7yZ5gxXLfBRd2RGxk+YzMWdng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 912786132D;
	Wed, 18 Feb 2026 12:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7B5C19424;
	Wed, 18 Feb 2026 12:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771417474;
	bh=w0zaQmuF17puT1y8ZmYGEPX5/kSjT5tOT03uas0O31A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uh294/Qn+b2o0QGh0Tn48GRcIH748SERgSwzjoNmoRQOLBGhqi1OQFqobMHt/JNrd
	 h1tdHwecvQa3Vy20O2EXdyL2OiSdfd3h1Zh1tjCfk78t69nUDMr6FQw+7F0DGFRkWj
	 KhEYwi34CAt254MhRVWYG8YULzpF+n1mHWOxXCdZHYBIKcyfw5YFU9Vhx+w6+3Uu8I
	 UF4mdi7dRlXiRQMLg6znhdWHtKYJpdamYSTn2OBaMcesn8cYa0y8CVuPp4g+X4EXyF
	 uqo7ZzVeNCE8yPb824NZtKmhrFAZT0NwJ7Gn6CFE1xnFKY1Ns9gyJ6l0dNI9GWNRqH
	 kQBpZQ6jbdobQ==
Message-ID: <624496ee-4709-497f-9ac1-c63bcf4724d6@kernel.org>
Date: Wed, 18 Feb 2026 13:24:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Pedro Falcato <pfalcato@suse.de>
Cc: Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 surenb@google.com, jhladky@redhat.com, akpm@linux-foundation.org,
 Liam.Howlett@oracle.com, willy@infradead.org, vbabka@suse.cz,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
 <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
 <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
 <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
 <5dso4ctke4baz7hky62zyfdzyg27tcikdbg5ecnrqmnluvmxzo@sciiqgatpqqv>
 <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
 <340be2bc-cf9b-4e22-b557-dfde6efa9de8@kernel.org>
 <cdrrvtzy76f7wplcrls3pbfe37kzrvzsrlaed7glg2cq6j3yob@wjbjklvovpl2>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <cdrrvtzy76f7wplcrls3pbfe37kzrvzsrlaed7glg2cq6j3yob@wjbjklvovpl2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 75927100005
X-Stat-Signature: bgyhmb4i8furon6it55pxfsr6sf6mczc
X-HE-Tag: 1771417475-525514
X-HE-Meta: U2FsdGVkX190tcVnNv8tR8WZ3QaPWmHQCCSTRpmzwGXa+93viK0IrISIU+oYOptP5qZdFXiee387pCu03cTlwFmV86xzOwm3ta5KaJRd21iLhHOQsjKiGPu1rQrPwjfD/OPV49OEZtJH8j5DKQb9zJ/BPBIlfw3jD0yq6f2eVYPzkP+AhOqSzVF+MtSc3cf1qVWvuqCDvq29x6I3dEw9wcccu69f6Ctdd0z4J9HKrS81P/NFzxupHPPt5foLn2L2y5nr4isn2BMnRgRwyvZtNPwNwBMOyvhGVSE3qIuzwEMjZybJYzhO/Hv5Z6Aojxuyf2b+HrFi2aFM5lNUxf63DjJoSuznU4oVEQUQ/blnP0zFGQOQPzUvBH8mIjkq63HCzy06a+UPMI5KCABvcX5RFhpKiUBWKH3gxA70SsYBn8zF4ewfMb2iknmxQgWcdykEAyxT4KB+okM41OrJJH4fR7ZweE+Oa/ofIkJ+xwBa1HgAxMFhdvdmp7p2HtOrHuGPY92wBwFhji7Igzu5xc+OqV9pGGFxhpL/0c9oVQMbKhh8X8lLp89znoOBoRVGZ5wl1xqrYPqBxfR1oZsasmT4jZCzQR+9syhwAoYlJQVb4IqUT2VTsSyT4QVAnTMWYaimH8HsAqCVRvNBOYDQfdIBB4ROT9OCbrX0wg1nOcn1h4+L5smDrPqRXyzblFJjzUT8qqbsAsm9W6YrMkJ2u2m5cHLdM2v6BNah5DGqx/0GSRVIR7U/uuLuKq4jUrAzYf2/i3xSPNscEA9m1bXADHmcfLn1mREgTsnRvwH1/pRSjm0yZgPJXJCEUv4VbfGoC1mc15E0Glsij9qtVLb8XXZ6lQ7KSlGWn8+pFJS753uuQvQTbcqdvuwF16xE7QKQVFSIZn+cwoITIgk+VpvgI4p5LF2IsR+tYocQPvGEJ/MuvOjM9z86LlX0oFYM3LHjkYGbMnITIbCCMTgRo5/9Kja
 gyBJb/j3
 4DjpcmO2ZjtBoAVkXJl4zElxDrDXuEDJq9LxGbaYfhY59q0pxlvDtOkfhpZ1OJ3/0VK0MX3rzQHbJpCxduD/p2o2czleMkawaEBe5gWq65XcL8sXfgfGfjlyXTxxjsZK8EyTWm1hppmTRQKVentOW3TmKyRvW5m1m/sQ7h0Z0jWRD48qHHANKVvkA1i9UQIlUJ2wh0JfkdYSSiBoHSZdDW98WYQvGwamhxdbyuXlVCtewlWIa9S8FvTQUjk/GRxVDpOTe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 12:58, Pedro Falcato wrote:
> On Wed, Feb 18, 2026 at 11:46:29AM +0100, David Hildenbrand (Arm) wrote:
>> On 2/18/26 11:38, Dev Jain wrote:
>>>
>>>
>>> There are two things at play here:
>>>
>>> 1. All arches are expected to benefit from pte batching on large folios, because
>>> of doing similar operations together in one shot. For code paths except mprotect
>>> and mremap, that benefit is far more clear due to:
>>>
>>> a) batching across atomic operations etc. For example, see copy_present_ptes -> folio_ref_add.
>>>      Instead of bumping the reference by 1 nr times, we bump it by nr in one shot.
>>>
>>> b) vm_normal_folio was already being invoked. So, all in all the only new overhead
>>>      we introduce is of folio_pte_batch(_flags). In fact, since we already have the
>>>      folio, I recall that we even just special case the large folio case, out from
>>>      the small folio case. Thus 4K folio processing will have no overhead.
>>>
>>> 2. Due to the requirements of contpte, ptep_get() on arm64 needs to fetch a/d bits
>>> across a cont block. Thus, for each ptep_get, it does 16 pte accesses. To avoid this,
>>> it becomes critical to batch on arm64.
>>>
>>>
>>>
>>> Nice.
>>>
>>>
>>> I dunno, need other opinions.
>>
>> Let's repeat my question: what, besides the micro-benchmark in some cases
>> with all small-folios, are we trying to optimize here. No hand waving
>> (Androids does this or that) please.
> 
> I don't understand what you're looking for. an mprotect-based workload? those
> obviously don't really exist, apart from something like a JIT engine cranking
> out a lot of mprotect() calls in an aggressive fashion. Or perhaps some of that
> usage of mprotect that our DB friends like to use sometimes (discussed in
> $OTHER_CONTEXTS), though those are generally hugepages.
> 

Anything besides a homemade micro-benchmark that highlights why we 
should care about this exact fast and repeated sequence of events.

I'm surprise that such a "large regression" does not show up in any 
other non-home-made benchmark that people/bots are running. That's 
really what I am questioning.

Having that said, I'm all for optimizing it if there is a real problem 
there.

> I don't see how this can justify large performance regressions in a system
> call, for something every-architecture-not-named-arm64 does not have.
Take a look at the reported performance improvements on AMD with large 
folios.

The issue really is that small folios don't perform well, on any 
architecture. But to detect large vs. small folios we need the ... folio.

So once we optimize for small folios (== don't try to detect large 
folios) we'll degrade large folios.


For fork() and unmap() we were able to avoid most of the performance 
regressions for small folios by special-casing the implementation on two 
variants: nr_pages == 1 (incl. small folios) vs. nr_pages != 1 (large 
folios).

We cannot avoid the vm_normal_folio(). Maybe the function-call overhead 
could be avoided by providing an inlined variant -- if that is the real 
problem.

But likely it's also just access to the folio when we really don't need 
it in some cases.

-- 
Cheers,

David

