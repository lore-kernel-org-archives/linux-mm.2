Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EACBC5ACC1
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 16:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A726B0005; Fri, 20 Feb 2026 11:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518A96B0089; Fri, 20 Feb 2026 11:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F00F6B008A; Fri, 20 Feb 2026 11:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2470E6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:30:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB2B9C077A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:30:34 +0000 (UTC)
X-FDA: 84465373188.18.86FC3D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AC8A7140014
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:30:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bFryxPfa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771605032; a=rsa-sha256;
	cv=none;
	b=eFqocjomfz5OyumRzVuBI8M+o5xGxcDAUKSDWmB4PJVoPEENASwcKi2OhKrTND/zXdTBPH
	wItJe30U+Bxy8QYp24BmHFFRWrK5PYX6U2tG0MP4CnkbFWFp9oUNaOlhG2LNf5whSwPpJx
	uV5iqwi3PbBteOcXLz5A4jJsvmdM01I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bFryxPfa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771605032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYGaFRJ05g87+Sek5Ast2B4/jm4t2ocDfmqoMH8u7zE=;
	b=xOJiDxJatPvLBEUNc2MjS8Sjoo6CpW/EVGBfuqblq1DDP1mAeika4ouL+VrbZ8lv83qXkS
	uQN59gaJjaC9it3w65NVZKjgbmnmYp3Gcu5qxPWV0ISoz9e1qz9+ILydWygR4S5s8TewN0
	Y4Komk6Q+EUnQRDOvMG4nm/paD6q8ao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 524AA43EF4;
	Fri, 20 Feb 2026 16:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E468C116C6;
	Fri, 20 Feb 2026 16:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771605031;
	bh=JiZCe/FwEzVP6g82N9cIiteYmDx9uRiqXXFnuX6Wf50=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bFryxPfaPofpnUuQr6PsLFX49LVbPlqil4y3AAdJ1kusbzUKIOwfr7HPdRDlDGaq0
	 iphZd6FVGiMgugBHQrji+2uT4KRb9S3twjJ8eHShGTORZjFcgss37Htqf7lXU0C4k8
	 Z9KbA/Yvzdo8nwFU/YPp7TKe9srTYG5cCvqI7jZjLD5ZcNmQ0xAvl1JXOaVkrv/dcY
	 KxK1Ha5uJGaJTKkLZ+GbPSJSejZS4AABHXMuqoxh6y18TZVYp504wkJRJCd1NKrGdr
	 GJxSWa8GQYmdPn7Y/Uuom8YgXmB2vbgIGt5WP8XvUfNfgxksAlaQxTvB7+fIghLkAL
	 o9f6iFK4l1+Iw==
Message-ID: <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
Date: Fri, 20 Feb 2026 17:30:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation>
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
In-Reply-To: <aZhErt9DZcWI24_v@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AC8A7140014
X-Stat-Signature: k6q8eumfgufzhwtnofg9jt6nxig1679f
X-HE-Tag: 1771605032-778301
X-HE-Meta: U2FsdGVkX1+yKVuz7EU6wQJl1fXix3sjlfTANSVyF1QmdeaGjW2R//X17ZdTbLdj2q0X+dR0MZ0lD2yVkH/T9rt+xXVNgf45ft48OBcQItgpeUy6gOP6Hg4pzV8cegA4PKJDjZFUc8y0IEiZk4PvI+G74u3oFntPgQQFV2m7OQosDx1Il3XfF+NZk+Nh4LQ7WBBLSMbgIJh2r2OGojG45jvYVCs1x3MyZiyEj2tEZFzXdR4zEBeuol3iWAq6bIa50oUe9utgQuWzmD1YfvWHn6G91xk5azTQ9Dpg3OsCzG+laH4aKZ1gX3Lu6zOvS3GCvKIr6jj8C4ZT4DtGUrAQQ9qvFMFORMvWO2z0VjC2qXADr5tRRd+cmqFAqo+exxJnCKGY1uDZraJxtXqh71hj1sNfVuE5OdjoFHLte6y1yvE5XG9tSG970i9BFbG4usEqsX0XXaeqvVYWle5bF6xdxGVfnslN0eyFPV7sWQY8OWjbpi97YVSL8HezgvvhHVpEkiM6AmTpPI3DNxAxzdrtjn54RvGBRrK8uSm0WxlzFoN00rRGTvuIWNDNcNsVVtkgzTfSBtMRe2XmBLIboudK6UE8oiW5GYsYHemO2BfRJDRNMevgnKOAOU222lshJMjbOIfoIxPrDi2Sehf9JIJegZoOaMo4cdtz7YB4HlWJpq6M389UJ5TjS/w6X+vagukCzQxV3ewokirOLG42DX5iFDcCLr9T4+r8bC75B75p6easkgkGRrozt0MOKcz2sotClJd0yJrydD/UalpYGlgJDDITOgJ3JKBMuTY6j9mZizs+i803P/s2jJT0UVCOcVTQ9yb/cOt0S+n0qQGc/DN80mKDul5WFkigEwSSoXCUhC2gTUzoN1x1z1uYJJ5/pZLHbflukPZDFCY+abeFwRUe1+t81qAZAs1YXR/AIE/OgxwktGE49n8nvLOT/j7gOYHt/2osfoaORmn+jyR8znZ
 hunaDLsb
 jUEXs8KR2E+fHvlFx4sJCM7VFzOpT4k/1Y/xHzJDvoW+OcnN9AeovVKW3iPASCbu7dm2MTZ6oQjjqJ6vM5jzOrMtlsUjIPO+csC0hFxv1RwhrKZ9YS9hsjXPpgWrEIXraXurbtzsCuuAbN4Qp1QbqLRNJE0qzfwpZBZyQGz6l/1RHsMJAvToSw3W6/7vtRFiUZ9bCZ2U0A/rHg8s15UGEqtGUxXGusQUlsyqlXNoR3umh6iPERTq7Ao6bOQD9OTYotC2J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/20/26 13:07, Kiryl Shutsemau wrote:
> On Fri, Feb 20, 2026 at 11:24:37AM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> Just to clarify, do you want it to be enforced on userspace ABI.
>>> Like, all mappings are 64k aligned?
>>
>> Right, see the proposal from Dev on the list.
>>
>>  From user-space POV, the pagesize would be 64K for these emulated processes.
>> That is, VMAs must be suitable aligned etc.
> 
> Well, it will drastically limit the adoption. We have too much legacy
> stuff on x86.

I'd assume that many applications nowadays can deal with differing page 
sizes (thanks to some other architectures paving the way).

But yes, some real legacy stuff, or stuff that ever only cared about 
intel still hardcodes pagesize=4k.

In Meta's fleet, I'd be quite interesting how much conversion there 
would have to be done.

For legacy apps, you could still run them as 4k pagesize on the same 
system, of course.

> 
>>>
>>> Waste of memory for page table is solvable and pretty straight forward.
>>> Most of such cases can be solve mechanically by switching to slab.
>>
>> Well, yes, like Willy says, there are already similar custom solutions for
>> s390x and ppc.
>>
>> Pasha talked recently about the memory waste of 16k kernel stacks and how we
>> would want to reduce that to 4k. In your proposal, it would be 64k, unless
>> you somehow manage to allocate multiple kernel stacks from the same 64k
>> page. My head hurts thinking about whether that could work, maybe it could
>> (no idea about guard pages in there, though).
> 
> Kernel stack is allocated from vmalloc. I think mapping them with
> sub-page granularity should be doable.

I still have to wrap my head around the sub-page mapping here as well. 
It's scary.

Re mapcount: I think if any part of the page is mapped, it would be 
considered mapped -> mapcount += 1.

> 
> BTW, do you see any reason why slab-allocated stack wouldn't work for
> large base page sizes? There's no requirement for it be aligned to page
> or PTE, right?

I'd assume that would work. Devil is in the detail with these things 
before we have memdescs.

E.g., page table have a dedicated type (PGTY_table) and store separate 
metadata in the ptdesc. For kernel stack there was once a proposal to 
have a type but it is not upstream.

> 
>> Let's take a look at the history of page size usage on Arm (people can feel
>> free to correct me):
>>
>> (1) Most distros were using 64k on Arm.
>>
>> (2) People realized that 64k was suboptimal many use cases (memory
>>      waste for stacks, pagecache, etc) and started to switch to 4k. I
>>      remember that mostly HPC-centric users sticked to 64k, but there was
>>      also demand from others to be able to stay on 64k.
>>
>> (3) Arm improved performance on a 4k kernel by adding cont-pte support,
>>      trying to get closer to 64k native performance.
>>
>> (4) Achieving 64k native performance is hard, which is why per-process
>>      page sizes are being explored to get the best out of both worlds
>>      (use 64k page size only where it really matters for performance).
>>
>> Arm clearly has the added benefit of actually benefiting from hardware
>> support for 64k.
>>
>> IIUC, what you are proposing feels a bit like traveling back in time when it
>> comes to the memory waste problem that Arm users encountered.
>>
>> Where do you see the big difference to 64k on Arm in your proposal? Would
>> you currently also be running 64k Arm in production and the memory waste etc
>> is acceptable?
> 
> That's the point. I don't see a big difference to 64k Arm. I want to
> bring this option to x86: at some machine size it makes sense trade
> memory consumption for scalability. I am targeting it to machines with
> over 2TiB of RAM.
> 
> BTW, we do run 64k Arm in our fleet. There's some growing pains, but it
> looks good in general We have no plans to switch to 4k (or 16k) at the
> moment. 512M THPs also look good on some workloads.

Okay, that's valuable information, thanks!

Being able to remove the sub-page mapping part (or being able to just 
hide it somewhere deep down in arch code) would make this a lot easier 
to digest.

-- 
Cheers,

David

