Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D80F357AD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A856B008C; Tue, 24 Feb 2026 09:27:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415876B0092; Tue, 24 Feb 2026 09:27:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AF76B0093; Tue, 24 Feb 2026 09:27:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4516B008C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:27:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7489562A6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:27:00 +0000 (UTC)
X-FDA: 84479577000.11.C0AAC4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BE62B20002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:26:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gXS1Lw+M;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771943218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgM7jS0cBg0plUTo1cSHYfPUoVqf2Pvxv925xxsrQ+U=;
	b=hllSL77Z+TCBxMrbfvuV/QMo5Ure2FUDzYpobJfZ8p0YNlgwpE5TV2+dgOHay4hVzBpmIH
	Bte7FaDtpHQh8CdqBhaXoFyuJ1pFKZbyPILXQ6sSo5SOuzekqaASh8PtK1GJvWN8D2MraM
	v4XC1wUDMzpaWONtnGSnzAE2dRQ6wKE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gXS1Lw+M;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771943219; a=rsa-sha256;
	cv=none;
	b=OokDXCrKTq6l5X9rJsamiKzNdeP6XlP8I7+iz+aE/2njDSrROvvDiu8KFo3mWNZ3zc0xWK
	NNKR15yiJJfpclvEEBkL50u7rKtOTViK9uYHSrIXLV4jlI+pEzDjAe1Rspb9d32/45WysC
	Qtt8BIZmz4fai7hkOmdRHBNIQrRvB0A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B482942A35;
	Tue, 24 Feb 2026 14:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5F9C2BC87;
	Tue, 24 Feb 2026 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771943217;
	bh=BOiJGrddjCxvgWVKKZBDfl4YuYUoUq3aMdjFP3iMbUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gXS1Lw+Mc6aaEqFMUfP7GItdAiZafYoGuZqd98hKKTt7LeEiLpwfgpHCLLdZu0WCm
	 dtmtGZ+nXtammriyfV6va/hmaqHBEZi4JAOAFCB6w92C3WTTKwsfNgawEcaxG5KA8X
	 0VX8N0LyWtOU55Jbq58G9to3YIZRdQgkA/k6gIL1fp8ccTgiXEdFnSyStjjd8HUwZH
	 sSMDX+M1XyITOZapFtg+14G27OR0wcWujEAuZHFIDagw+GK2QRJOT+3qIonxV2G8kx
	 eEyYZs5QVkSfgZ/SWD/kgeBTyAxd9aq8HJ+fMn6ZgWJdTzCa9q08tv4RWAiaJPUCyy
	 RwUotiblOd9Ig==
Message-ID: <10fb20fc-b379-433d-9a08-cc962ab70480@kernel.org>
Date: Tue, 24 Feb 2026 15:26:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fork: zero vmap stack using clear_pages() instead of
 memset()
To: Linus Walleij <linusw@kernel.org>
Cc: Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Mateusz Guzik <mjguzik@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Ankur Arora <ankur.a.arora@oracle.com>
References: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org>
 <2553a75a-6dc8-4295-96b3-58367879751c@kernel.org>
 <CAD++jLm6iyeFuGoC2zfHDOu6gYdb2L1gsjQhT5a4qS-CBWia9Q@mail.gmail.com>
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
In-Reply-To: <CAD++jLm6iyeFuGoC2zfHDOu6gYdb2L1gsjQhT5a4qS-CBWia9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: BE62B20002
X-Stat-Signature: 6zkcdnenf933o4ara1rce1igsq8pircy
X-HE-Tag: 1771943218-74464
X-HE-Meta: U2FsdGVkX1+x/9ROB3OxMGGJpuMrhUjh/2mUbYL2SG4rrSgi7kxGTyWwgoVsdtSgPrGxbd1/eV3nBD1dJH+K27sD37YV7EZwb9b1hr1jxHSrGzZy1itwAlvmZFJJPfSaXiSowCFN6fR5k2A0I9BT+6DV8cLqJBRqYitvVa03q9iLMUQMnBv3l5yfPXYD4HX97uzdgzkN4xmSXLs6RmdBDHHnPytuslboJGhRrH/FN5PfcfrwZluv+TYkyW6Lq4kVkDmdmi+Y7tSOecvjZv5VLcXZ7AHSA2o3Y0u6lEY4oq9MjwGo/IqMcy0Z8K1vulDE8KMuc47rFTp37pMKMxWgKpuzv3fdFQ/rpT7I3yOmKz++Kc+CagWT69FoMJTrv7COkGCsrAaxHTKu8cEmOxXAykmfgDli1DfzqXOkkYlo2pFecEOVqjcqPGxAQGzlBdcQOPWTjPVw7ZlmirRrCgE7tk4EfoCu7lMdmwQpgmZZoDwffKOfW8r9UC5HpLl1oHXy97VIgodLSVHYx5dT9sK+nAwkyLDwCCNLOqcFbczICqxvmtw2w28wLKwKvjGguChFNuCpCznQDXpvOpa/Tq8HVO1E+XeDTzkl7H3cMcWdXTYamp0pbQQhOR55CBMhvtVk08wK6aoM3TVhkDHd/428MgDg/ZD+BzsJY/atM4lVoSTStq8U427Ca+fdz36FReWqC/UKpkqiPqbpfFLAd8cPvAWUa7qoqmZ+UyDFrACOHatWYXjczRQUSvQMUDdkPxGRRpakyAE4QZrVyPGskczYbkB3LmCIny1jqZPsHRACjoBb0VRhXhp5luwMv3PNofZDqWNCHgo8URMXFs0s+yFglQMxPufeIlgMgyP4kgaomElDKpvRf+SJocrnJ5cHMWrc9HLiunK6cTI2Owj6xjOhT74aAkEq0JW5kFb2DAfLUWKSOSVb+NrloPUApK6MYhIeI1FBBaIiyqR3Viv7pd4
 NrkWt7f9
 AFdqCEzbJfTTI046wgfYDqDULTIyHeyjAjao3tVsWQHsE+edzRR1+3S1O2J9/x+gr/9f7lEMwrus9zJgpmZEeQhsRCsyLI8V4m+Ea5e2JCWLyk+1x1cZRniLq78LZt/OSqkfzWevD18Jy8xiLR/skS1rJCxrtPrKDoNqRghnfIcO5qFo8X3cu0BEqQfhZxsOjPJHidHCoZM56gmP3Zd5Nu03MFvtEJQ/GPpyeA88m7b7waiP267VnRvZGI5g82X3Aug+QH6KxPexSMmMeDP22ud31xvaKZhkGVpv3SXzpKMkaLD3YmNRk11NWHtAIi2sfclGA47NRGEv4vZ2UymEUMYFvBJ27kdkYOFQh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 14:53, Linus Walleij wrote:
> On Tue, Feb 24, 2026 at 2:21 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>> On 2/24/26 11:26, Linus Walleij wrote:
> 
>>> After the introduction of clear_pages() we exploit the
>>> fact that the process vm_area is allocated in contiguous
>>> pages to just clear them all in one swift operation.
>>
>> The pages are virtually contiguous (vmalloc IIUC), not necessarily
>> physically contiguous. For clear_pages() that should work.
> 
> Yeah that's what I meant with contiguous, sorry.
> 
>>>               /* Clear stale pointers from reused stack. */
>>> -             memset(stack, 0, THREAD_SIZE);
>>> +             clear_pages(vm_area->addr, vm_area->nr_pages);
>>
>> LGTM.
>>
>> Do we have any idea about performance impact etc?
> 
> I have a pending patch for implementing clear_pages() for arm64,
> https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-integrator.git/log/?h=b4/aarch64-clear-pages
> which is in a performance test loop, once I get baseline data from that
> I can test something fork-intensive (hackbench, I guess) with this patch on top.
> 
> So making that patch made me remember this one code site...

I'll note that clear_pages() documents: "When running under preemptible
models this is not a problem. Under cooperatively scheduled models,
however, the caller is expected to limit @npages to no more than
PROCESS_PAGES_NON_PREEMPT_BATCH."

We discussed during review that we should probably move that batching
logic into clear_pages() at some point.

PROCESS_PAGES_NON_PREEMPT_BATCH defaults to 1. I'd assume that handling
3 pages here doesn't make a difference, just pointing it out.

CCing Ankur.

> 
> If someone has a good fork performance test running on x86
> and can give this a spin, it'd be great!

That would be nice :)


-- 
Cheers,

David

