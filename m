Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8CCBD41D61
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 15:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8736B0007; Thu, 11 Dec 2025 10:38:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289196B0008; Thu, 11 Dec 2025 10:38:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0206B000A; Thu, 11 Dec 2025 10:38:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3FD06B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:38:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3291140230
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:38:15 +0000 (UTC)
X-FDA: 84207596550.17.F4112DE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id D329F140014
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:38:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765467494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GbUM4g7uKw8vYe2Nt2y2OqI2UjY9+TowbckYxK7VsiY=;
	b=nWlM7AzXqrZoWahdmGBaRiqmX5VTk+xTx7tImAnAq2aiF7qPG38bUB8Mady/vt3uBen5Pm
	iQhPvtcJcZ0IM79R/oqYecBYngwdlmWmxkBrEAllBkVNnJwZEAXeQlsJFD1XO4TeQEocUF
	BdwNYfQWIUGuiut0404s5xOJaOPZCzc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765467494; a=rsa-sha256;
	cv=none;
	b=0RXceOFGumBM817egOS4cy/5RDZ+1l/zNIwZFuQQVNsK+5seyS3FDqyA3wP9O9WePtoRLC
	Rgonyl1jsNFklMT21+vKrfKqRrl5fUfCj3Uan6DDHk3kuzA1wAJWpQJjmtiIUzjk8ia9t3
	ugHpwnamZNblEumSupFaigSbd1yc4KI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D3681063;
	Thu, 11 Dec 2025 07:38:05 -0800 (PST)
Received: from [10.163.53.200] (unknown [10.163.53.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B37943F740;
	Thu, 11 Dec 2025 07:38:10 -0800 (PST)
Message-ID: <3f4285cf-adb8-4fc5-ad18-c3a0d6de4db0@arm.com>
Date: Thu, 11 Dec 2025 21:08:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
From: Dev Jain <dev.jain@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
 <66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com> <aTn0FZig5a_DpTJg@fedora>
 <d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com>
 <0fa1c315-70ef-46f3-95ec-feb3a75a10be@arm.com>
Content-Language: en-US
In-Reply-To: <0fa1c315-70ef-46f3-95ec-feb3a75a10be@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 99giioss7gmrajpis1dmfcrx4nwfo1dd
X-Rspamd-Queue-Id: D329F140014
X-Rspamd-Server: rspam06
X-HE-Tag: 1765467493-563174
X-HE-Meta: U2FsdGVkX18VR19K17kWFLmCdu5iMXB+mdjrGIotT4EsjsgjmhFy3GcyTJ9ccQ3AYf7DVLbspOspAW4I6ja82qC+62jSX49AkSemBMeAbgRPzx5jomdhEFw4RZgdIIzg4/2Bb48LQXwS9bV6vglVT+jBMMunDfchX9Y5FGO5m/vtzvLkLhM095XsOYj8c9sYJ69Ue4eg8nvwFeGdIBuO6wYQyRLsy2XP/Q3qceaoXDOXnb97UdsTurGujc7Tq+6CBKGIXr9hHeybVmTCLvh32XKqzzxQsyC6NJ5uNo4AIPhd5idepCFP9vrexSlefd6xxjepGHgVFaz22RFrHkkx7jD35ChUhPociZcS6twUDYmk2SADOXnY92mfCW9qr+cavYQRmboSxrPRTJFB0kDjU+v02pGScsk8iboT2v70nnQehnC7rujximtT9qguuTOLi+WQBJFotBZzgJScDB4MfhxVOQ8BJydL+IQ/ira/0mf3NUGT+0ta94guacjt41cu7jIDeXFG3Gur9nCiHnUOllBhA+vBVy01qSBaxiIOQdjVWKbSmxf/9M/oIJnTOMy7o3949LQ+MZBUuwz51KHJJEfOarQSSxEcTPJ0lMRyjUmALudmHTvKIQgNk742ij5OYKCtTRRwt9YT3afPYBfKOG7vS7Krfoir0AtUxdv9WotBmLbS9YkPGrnlBG5L0fbhtuULbfuggdut7s9UXMIuO/WBDoY82wLHj7Q+J7okx7JkN+IjsOgQTrFRT8M+qOP0M4tTvi23bDS69XIEcsUzN1frJBT5H7dttH4wwwx86KIO0YUVQuka1lubqVT1HYgOjEflycycCQfZmyVoQN2UMMYst03XjdmHyCLNq1xi+25bG6kbqcs5/H3Ss2w0W25e15tG/V3h9AFTAJ55A1da4cb0JQin6aTEBNe5m/OMi1PTP6FjHUYxr6M5e+g9gY5H/w3SKrLxIHJq++RIjPv
 Lc8qD/Cc
 zDTJfROWsLOyBBgWhFWQw7wwtS0RdLCOMbQnHwU72Vx+270VNtLgtb/4jx+TEZYVSEE6pwaayCOYCH82OUCmMlPc1x4JflygdhVCRhzlmVf9ebE+xlgxtoKx6eVFnlY/eIw3p6Fk/GxN6UkMm+eBmfFbqHOj9zKoItMaUdEl6sLsvffNsB9hMbta4ZLuco9ttQLpUqSAaeai/Syt8+678PPBla3GP96urJFYXevn3FYDbNstPmI28nBXrWIo9ZKl/EfqN4dqdRcHGQZzBhOcE25G4wlnKfrhDShOYcb9muhlT4TPNPPlngwIdqghDKwsq5est
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/12/25 9:05 pm, Dev Jain wrote:
>
> On 11/12/25 8:58 pm, Ryan Roberts wrote:
>> On 10/12/2025 22:28, Vishal Moola (Oracle) wrote:
>>> On Wed, Dec 10, 2025 at 01:21:22PM +0000, Ryan Roberts wrote:
>>>> Hi Vishal,
>>>>
>>>>
>>>> On 21/10/2025 20:44, Vishal Moola (Oracle) wrote:
>>>>> Sometimes, vm_area_alloc_pages() will want many pages from the buddy
>>>>> allocator. Rather than making requests to the buddy allocator for at
>>>>> most 100 pages at a time, we can eagerly request large order pages a
>>>>> smaller number of times.
>>>>>
>>>>> We still split the large order pages down to order-0 as the rest 
>>>>> of the
>>>>> vmalloc code (and some callers) depend on it. We still defer to 
>>>>> the bulk
>>>>> allocator and fallback path in case of order-0 pages or failure.
>>>>>
>>>>> Running 1000 iterations of allocations on a small 4GB system finds:
>>>>>
>>>>> 1000 2mb allocations:
>>>>>     [Baseline]            [This patch]
>>>>>     real    46.310s            real    0m34.582
>>>>>     user    0.001s            user    0.006s
>>>>>     sys     46.058s            sys     0m34.365s
>>>>>
>>>>> 10000 200kb allocations:
>>>>>     [Baseline]            [This patch]
>>>>>     real    56.104s            real    0m43.696
>>>>>     user    0.001s            user    0.003s
>>>>>     sys     55.375s            sys     0m42.995s
>>>> I'm seeing some big vmalloc micro benchmark regressions on arm64, 
>>>> for which
>>>> bisect is pointing to this patch.
>>> Ulad had similar findings/concerns[1]. Tldr: The numbers you are seeing
>>> are expected for how the test module is currently written.
>> Hmm... simplistically, I'd say that either the tests are bad, in 
>> which case they
>> should be deleted, or they are good, in which case we shouldn't 
>> ignore the
>> regressions. Having tests that we learn to ignore is the worst of 
>> both worlds.
>
> AFAICR the test does some million-odd iterations by default, which is 
> the real problem.
> On my RFC [1] I notice that reducing the iterations reduces the 
> regression - till
> some multiple of ten thousand iterations, the regression is zero. 
> Doing this
> alloc->free a million freaking times messes up the buddy badly.
>
> [1] https://lore.kernel.org/all/20251112110807.69958-1-dev.jain@arm.com/


So this line:

__param(int, test_loop_count, 1000000,
         "Set test loop counter");

We should just change it to 20k or something and that should resolve it.


>
>>
>> But I see your point about the allocation pattern not being very 
>> realistic.
>>
>>>> The tests are all originally from the vmalloc_test module. Note 
>>>> that (R)
>>>> indicates a statistically significant regression and (I) indicates a
>>>> statistically improvement.
>>>>
>>>> p is number of pages in the allocation, h is huge. So it looks like 
>>>> the
>>>> regressions are all coming for the non-huge case, where we want to 
>>>> split to
>>>> order-0.
>>>>
>>>> +---------------------------------+----------------------------------------------------------+------------+------------------------+ 
>>>>
>>>> | Benchmark                       | Result 
>>>> Class                                             | 6-18-0 |   
>>>> 6-18-0-gc2f2b01b74be |
>>>> +=================================+==========================================================+============+========================+ 
>>>>
>>>> | micromm/vmalloc                 | fix_align_alloc_test: p:1, h:0, 
>>>> l:500000 (usec)          |  514126.58 | (R) -42.20% |
>>>> |                                 | fix_size_alloc_test: p:1, h:0, 
>>>> l:500000 (usec)           |  320458.33 |                 -0.02% |
>>>> |                                 | fix_size_alloc_test: p:4, h:0, 
>>>> l:500000 (usec)           |  399680.33 |            (R) -23.43% |
>>>> |                                 | fix_size_alloc_test: p:16, h:0, 
>>>> l:500000 (usec)          |  788723.25 |            (R) -23.66% |
>>>> |                                 | fix_size_alloc_test: p:16, h:1, 
>>>> l:500000 (usec)          |  979839.58 |                 -1.05% |
>>>> |                                 | fix_size_alloc_test: p:64, h:0, 
>>>> l:100000 (usec)          |  481454.58 |            (R) -23.99% |
>>>> |                                 | fix_size_alloc_test: p:64, h:1, 
>>>> l:100000 (usec)          |  615924.00 |              (I) 2.56% |
>>>> |                                 | fix_size_alloc_test: p:256, 
>>>> h:0, l:100000 (usec)         | 1799224.08 |            (R) -23.28% |
>>>> |                                 | fix_size_alloc_test: p:256, 
>>>> h:1, l:100000 (usec)         | 2313859.25 |              (I) 3.43% |
>>>> |                                 | fix_size_alloc_test: p:512, 
>>>> h:0, l:100000 (usec)         | 3541904.75 |            (R) -23.86% |
>>>> |                                 | fix_size_alloc_test: p:512, 
>>>> h:1, l:100000 (usec)         | 3597577.25 |             (R) -2.97% |
>>>> |                                 | full_fit_alloc_test: p:1, h:0, 
>>>> l:500000 (usec)           |  487021.83 |              (I) 4.95% |
>>>> |                                 | kvfree_rcu_1_arg_vmalloc_test: 
>>>> p:1, h:0, l:500000 (usec) | 344466.33 |                 -0.65% |
>>>> |                                 | kvfree_rcu_2_arg_vmalloc_test: 
>>>> p:1, h:0, l:500000 (usec) | 342484.25 |                 -1.58% |
>>>> |                                 | long_busy_list_alloc_test: p:1, 
>>>> h:0, l:500000 (usec)     | 4034901.17 |            (R) -25.35% |
>>>> |                                 | pcpu_alloc_test: p:1, h:0, 
>>>> l:500000 (usec)               |  195973.42 |                  0.57% |
>>>> |                                 | random_size_align_alloc_test: 
>>>> p:1, h:0, l:500000 (usec)  | 643489.33 |            (R) -47.63% |
>>>> |                                 | random_size_alloc_test: p:1, 
>>>> h:0, l:500000 (usec)        | 2029261.33 | (R) -27.88% |
>>>> |                                 | vm_map_ram_test: p:1, h:0, 
>>>> l:500000 (usec)               |   83557.08 |                 -0.22% |
>>>> +---------------------------------+----------------------------------------------------------+------------+------------------------+ 
>>>>
>>>>
>>>> I have a couple of thoughts from looking at the patch:
>>>>
>>>>   - Perhaps split_page() is the bulk of the cost? Previously for 
>>>> this case we
>>>>     were allocating order-0 so there was no split to do. For h=1, 
>>>> split would
>>>>     have already been called so that would explain why no 
>>>> regression for that
>>>>     case?
>>> For h=1, this patch shouldn't change (as long as nr_pages <
>>> arch_vmap_{pte,pmd}_supported_shift). This is why you don't see 
>>> regressions
>>> in those cases.
>> arm64 supports 64K contigous-mappings with vmalloc so once nr_pages 
>> >= 16 we can
>> take the huge path.
>>
>>>>   - I guess we are bypassing the pcpu cache? Could this be having 
>>>> an effect? Dev
>>>>     (cc'ed) did some similar investigation a while back and saw 
>>>> increased vmalloc
>>>>     latencies when bypassing pcpu cache.
>>> I'd say this is more a case of this test module targeting the pcpu
>>> cache. The module allocates then frees one at a time, which promotes
>>> reusing pcpu pages. [1] Has some numbers after modifying the test such
>>> that all the allocations are made before freeing any.
>> OK fair enough.
>>
>> We are seeing a bunch of other regressions in higher level benchmarks 
>> too; but
>> haven't yet concluded what's causing those. I'll report back if this 
>> patch looks
>> connected.
>>
>> Thanks,
>> Ryan
>>
>>
>>>>   - Philosophically is allocating physically contiguous memory when 
>>>> it is not
>>>>     strictly needed the right thing to do? Large physically 
>>>> contiguous blocks are
>>>>     a scarce resource so we don't want to waste them. Although I 
>>>> guess it could
>>>>     be argued that this actually preserves the contiguous blocks 
>>>> because the
>>>>     lifetime of all the pages is tied together. Anyway, I doubt 
>>>> this is the
>>> This was the primary incentive for this patch :)
>>>
>>>>     reason for the slow down, since those benchmarks are not under 
>>>> memory
>>>>     pressure.
>>>>
>>>> Anyway, it would be good to resolve the performance regressions if 
>>>> we can.
>>> Imo, the appropriate way to address these is to modify the test module
>>> as seen in [1].
>>>
>>> [1] https://lore.kernel.org/linux-mm/aPJ6lLf24TfW_1n7@milan/
>>
>

