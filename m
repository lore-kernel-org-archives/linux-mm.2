Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE150D41D50
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 15:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ECE36B0005; Thu, 11 Dec 2025 10:29:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E1A6B0007; Thu, 11 Dec 2025 10:29:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5E16B0008; Thu, 11 Dec 2025 10:29:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA9CF6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:29:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80CF3139E9E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:29:02 +0000 (UTC)
X-FDA: 84207573324.12.5DF9B73
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6223E40009
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:29:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765466940; a=rsa-sha256;
	cv=none;
	b=69iaSPEPu36p1iN+pSkTO9XBdsoaTbw2ugi8Iwz44pplotPLEJX1LDqP8EEulnE53upRZ/
	6RjcVDYaGtmIw1eSzCEMvZ2COf+mrsLRWlnsdZIBQgTWOMUyMD3zL60UKpZ95IJMTvC50B
	xuvv+LAr0Lu01JP2FVqeTXxQZkfLZM4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765466940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vs7m0PXnHgcQaiE943XMAnahN1KbryZMAdb3Js/av9w=;
	b=wO8ORfg/1Ggfdkh3NMsm6m2BV1HG6sBSMySGmbsF1wwbHWNUtw5BLFWNJbjoe7eoRykRmt
	7ouLn8+DnqHT9a1Pakt9eC5Eoz/oaWtX6JlGfFjSh6VbxMofdg91hAQjb06Up5NKsV3xBR
	p6ongdqhKiPjjCE+ELtP7q9HfwNOk+I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 250B51688;
	Thu, 11 Dec 2025 07:28:52 -0800 (PST)
Received: from [10.57.90.205] (unknown [10.57.90.205])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 664313F740;
	Thu, 11 Dec 2025 07:28:58 -0800 (PST)
Message-ID: <d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com>
Date: Thu, 11 Dec 2025 15:28:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Content-Language: en-GB
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
 <66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com> <aTn0FZig5a_DpTJg@fedora>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aTn0FZig5a_DpTJg@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6223E40009
X-Rspamd-Server: rspam10
X-Stat-Signature: 4b9u1nhpj744cfr7jq66k5cwitogd7xj
X-HE-Tag: 1765466940-531551
X-HE-Meta: U2FsdGVkX18lefXdbxvEAemonU/OknZrOSvZFd9c+mK6Qzd5mG+5+7k8V8Qw5naELT0HRhebMBZzg4a5l9IqzPVersktcwXJY+j9q0CmkYWeNr9PrQDzzOKZ8ZOeALOzkcXMj4nzMtAACHlVxuVEWVR1/W12NTgDfEEKBaFxV/AGVSbCBePzJl2Npb90ql9NPWBBAhrsXE8UxHiOxOZF572NmltJYSI99Baf5WvjyEGcljUrj16n+BwXtyha3Ltp0y/ykJKY0dQR84rQN3qVQbRDUV+1+T/z9df6edLYSFquCjk7RUbsW6MJYbirSu9OAn6FLpPzK6JW2WtBkRdzfkZPNCt530l/4Ctl0jtJLhkMql7n8cd+Bd6i+W580iedJtnNwRH1HIIrgAv5VUlpy1pnNhzXkKRNbxs0Hz6e8iLG+eBqYwIzXOHvCTyE0PUtlxAQgITN2OnuGgMS8IOd/EOkoCzine+wAvRta9tibpFH1YyTE7c1RqaFiu1jQbGZ7Z+ktuOWfdoGgXZZLK8F0B3C10pgTymLJB63Vat+9ZW5Z5X3RkkENjuVDcr5cg21HExYKP+n1egsDW85FcL+fCsLqeaO4y6iaDM4Sr4caMw85T57igaES3VWxQTfLxhTMGzS0km+ZcTSuGLL8HcjxZGqrzJyn/Ruzw3UAq8ORuGgUxOi5NdMRd83vGP+jgzQ75XkpaWxRUWe6zuUT97lmUuz8yW+Gc3LOkNhp5BuQXY034WUOTh3nthqHWY1T6o6e/sQJnruMeoN0tGpavwRvP65DkpfvUS2ZSnFmOryUrrr0ElD0e4rREVISDXMAKfNmpsCvh0SyOvA6Q1ZGlWaSYz3Jgwl+DBBvxd1zn1nsECmuM1y3S/ZvaHTeVg3okd+j+wpqyoPDrXd1ewnP3rYdMrTqyy81Aq2ihYFjg21QZQQfBr2OFGml94ZGP9tkWQMe1a93i4HHZ2qulSVDh5
 Q9KTjn/c
 GRSz1KJXmJfOwM8qccmJ4ZcC0EKvCakHz1f2ulk7V4SNyS6oleqZQ7ZA9WcLdb0B/R8J4LZQq7m4VwemkTw+oPVYiqKMvstztUaFiQ5/thN03/qiysjKMbX6Rm+ytp8+jU0mB6hgxGoLEYF6gDj//EaACE1smmUTM+LYJo6mDej/RFvb7w4/PwbUm+wbdXQac2du2Az9bmwOGlXQVQl17D89t3Gn5t/FWPsqb1rumBmxtfu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/2025 22:28, Vishal Moola (Oracle) wrote:
> On Wed, Dec 10, 2025 at 01:21:22PM +0000, Ryan Roberts wrote:
>> Hi Vishal,
>>
>>
>> On 21/10/2025 20:44, Vishal Moola (Oracle) wrote:
>>> Sometimes, vm_area_alloc_pages() will want many pages from the buddy
>>> allocator. Rather than making requests to the buddy allocator for at
>>> most 100 pages at a time, we can eagerly request large order pages a
>>> smaller number of times.
>>>
>>> We still split the large order pages down to order-0 as the rest of the
>>> vmalloc code (and some callers) depend on it. We still defer to the bulk
>>> allocator and fallback path in case of order-0 pages or failure.
>>>
>>> Running 1000 iterations of allocations on a small 4GB system finds:
>>>
>>> 1000 2mb allocations:
>>> 	[Baseline]			[This patch]
>>> 	real    46.310s			real    0m34.582
>>> 	user    0.001s			user    0.006s
>>> 	sys     46.058s			sys     0m34.365s
>>>
>>> 10000 200kb allocations:
>>> 	[Baseline]			[This patch]
>>> 	real    56.104s			real    0m43.696
>>> 	user    0.001s			user    0.003s
>>> 	sys     55.375s			sys     0m42.995s
>>
>> I'm seeing some big vmalloc micro benchmark regressions on arm64, for which 
>> bisect is pointing to this patch.
> 
> Ulad had similar findings/concerns[1]. Tldr: The numbers you are seeing
> are expected for how the test module is currently written.

Hmm... simplistically, I'd say that either the tests are bad, in which case they
should be deleted, or they are good, in which case we shouldn't ignore the
regressions. Having tests that we learn to ignore is the worst of both worlds.

But I see your point about the allocation pattern not being very realistic.

> 
>> The tests are all originally from the vmalloc_test module. Note that (R) 
>> indicates a statistically significant regression and (I) indicates a 
>> statistically improvement.
>>
>> p is number of pages in the allocation, h is huge. So it looks like the 
>> regressions are all coming for the non-huge case, where we want to split to 
>> order-0.
>>
>> +---------------------------------+----------------------------------------------------------+------------+------------------------+
>> | Benchmark                       | Result Class                                             |     6-18-0 |   6-18-0-gc2f2b01b74be |
>> +=================================+==========================================================+============+========================+
>> | micromm/vmalloc                 | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |  514126.58 |            (R) -42.20% |
>> |                                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |  320458.33 |                 -0.02% |
>> |                                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |  399680.33 |            (R) -23.43% |
>> |                                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |  788723.25 |            (R) -23.66% |
>> |                                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |  979839.58 |                 -1.05% |
>> |                                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |  481454.58 |            (R) -23.99% |
>> |                                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |  615924.00 |              (I) 2.56% |
>> |                                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         | 1799224.08 |            (R) -23.28% |
>> |                                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         | 2313859.25 |              (I) 3.43% |
>> |                                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         | 3541904.75 |            (R) -23.86% |
>> |                                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         | 3597577.25 |             (R) -2.97% |
>> |                                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |  487021.83 |              (I) 4.95% |
>> |                                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |  344466.33 |                 -0.65% |
>> |                                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |  342484.25 |                 -1.58% |
>> |                                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     | 4034901.17 |            (R) -25.35% |
>> |                                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |  195973.42 |                  0.57% |
>> |                                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |  643489.33 |            (R) -47.63% |
>> |                                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        | 2029261.33 |            (R) -27.88% |
>> |                                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |   83557.08 |                 -0.22% |
>> +---------------------------------+----------------------------------------------------------+------------+------------------------+
>>
>> I have a couple of thoughts from looking at the patch:
>>
>>  - Perhaps split_page() is the bulk of the cost? Previously for this case we 
>>    were allocating order-0 so there was no split to do. For h=1, split would 
>>    have already been called so that would explain why no regression for that 
>>    case?
> 
> For h=1, this patch shouldn't change (as long as nr_pages <
> arch_vmap_{pte,pmd}_supported_shift). This is why you don't see regressions
> in those cases.

arm64 supports 64K contigous-mappings with vmalloc so once nr_pages >= 16 we can
take the huge path.

> 
>>  - I guess we are bypassing the pcpu cache? Could this be having an effect? Dev 
>>    (cc'ed) did some similar investigation a while back and saw increased vmalloc 
>>    latencies when bypassing pcpu cache.
> 
> I'd say this is more a case of this test module targeting the pcpu
> cache. The module allocates then frees one at a time, which promotes
> reusing pcpu pages. [1] Has some numbers after modifying the test such
> that all the allocations are made before freeing any.

OK fair enough.

We are seeing a bunch of other regressions in higher level benchmarks too; but
haven't yet concluded what's causing those. I'll report back if this patch looks
connected.

Thanks,
Ryan


> 
>>  - Philosophically is allocating physically contiguous memory when it is not 
>>    strictly needed the right thing to do? Large physically contiguous blocks are 
>>    a scarce resource so we don't want to waste them. Although I guess it could 
>>    be argued that this actually preserves the contiguous blocks because the 
>>    lifetime of all the pages is tied together. Anyway, I doubt this is the 
> 
> This was the primary incentive for this patch :)
> 
>>    reason for the slow down, since those benchmarks are not under memory 
>>    pressure.
>>
>> Anyway, it would be good to resolve the performance regressions if we can.
> 
> Imo, the appropriate way to address these is to modify the test module
> as seen in [1].
> 
> [1] https://lore.kernel.org/linux-mm/aPJ6lLf24TfW_1n7@milan/


