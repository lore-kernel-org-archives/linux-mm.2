Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E170E6F079
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 10:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953236B0005; Tue, 23 Dec 2025 05:11:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909FC6B0089; Tue, 23 Dec 2025 05:11:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8171E6B008A; Tue, 23 Dec 2025 05:11:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70EB66B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:11:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 232171DF587
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:11:43 +0000 (UTC)
X-FDA: 84250319286.12.3E5CA6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4F4791C0020
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:11:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qfaXd6LV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766484701; a=rsa-sha256;
	cv=none;
	b=qXFJTLn2RRUoD6onVDMSU/Je/QFOFgSDKnOX/7s99+a+21BEGeLtOvNXC6zOvQSJWsyURo
	5t0Pvkp0sosxeA23ghl4RPJGLlDsj3ZM2MjLxSPEAJinHYpaLhIC9ppFNWqE9AiXuq8Z8F
	pcHJ/Gj8wFoIyAO+r06JxfI1tDz4DBY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qfaXd6LV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766484701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYFlAFzFbwFCN8fJHsl6eJ/5fVskPukiPnB+yIB+bjc=;
	b=XxxnweQLmbrHZt9jOY8pm0c7IdZhRyjhyA/djSDgznOxvt18XTTQoHueFdCcjflXIrlHFX
	nqh0/F8nYkaplNGzEzJdFDejwUQC0Ksbavjq287/fVJQwbf+f1Mi6LydJFLVk5oCsnNtSK
	PmmZRzxcpEe/LiGQL3whVrzNT7VKCwU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EB5F43C23;
	Tue, 23 Dec 2025 10:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF5EC113D0;
	Tue, 23 Dec 2025 10:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766484700;
	bh=lW5sFlnkDGCk5rH+BKM70TDQJ6o2G2rSA6rdfTk92Ec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qfaXd6LV/97eGac5d66TW/vMC1F2uEZNncbDZ1FyoriP7J98H5Nybs4slrobcIJ7J
	 dlTKbCcLUsGqSrz8sp0FcXG71yBQf+mVVvZm0MJ/l0yNuHUR8wK1AeCUb4NlXGXmAw
	 biqiCyn7eokdhMsAt9PKTfNdGdoYNj3x0bSYJQY04sZLDvUoqUEYKaOhwBeczBGB3a
	 3I5xTomu+vzAAtA6tNhUlpJOibM0RRYr1LBQqxWFxFHUfKf0GMo7H3tcDDwNbcVQlT
	 CPmV9BX11DGezT9ng0FMOKbtbUTvPDE27/nkKJsJwwX8MMxsGjlZdF4PEd+PRIWOBg
	 QieAjEaN/ZE6w==
Message-ID: <4e3ff85e-2c8c-489e-92b4-088189eed63b@kernel.org>
Date: Tue, 23 Dec 2025 11:11:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 8/8] mm: folio_zero_user: cache neighbouring pages
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-9-ankur.a.arora@oracle.com>
 <b34ce151-45d5-4074-a869-de93b2bcdef0@kernel.org> <874ipnwlky.fsf@oracle.com>
 <87jyyjv5zy.fsf@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <87jyyjv5zy.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4F4791C0020
X-Stat-Signature: fhj8hi1azpyrgbzhs1jmggtizhria4gm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766484701-934868
X-HE-Meta: U2FsdGVkX19224Wm46YL0mxsP8gGm1pb9H6+AjAfOHY4Oo9YKcmwVbKxadQAfhrs9EIURGE+qLM07vxessWfoKpwl9D3bpozB6bJkRDsXmueU2rDWY9v+8QWrDQ8S7LRee9ZRCkVKkW6tQuua6frAJ264PERyh2uKbssAuooGiVP4xClW01NAWLvijVAr7FsjbLOL35kbFbkzBfhJ2xp0UWKnMRaigxy67ZeUsWVgheJ3uo4m2bzStorB3ohEag63Q/Y74UzQUkNsgTRexg6rRI44w/mJexg0jBPucOog8OIoQATEq5T527KEPh5B3Qxwq2zVK+G0dwpOaCQGHHWRLU/VREwmOO10dfxRlfbW1fums9PB7PgZo1nsLGJPlFzQJ7NVUX158aZSo9e8Axd+sxasHSiq9ZuoP4imPA4sPmkALo4ZnOsBELVMvcKv1I7yFmRTYycDVy8YGBoKd2dS3xe9PgQpZhmkRLCqEiWxZWZfOW1/ZBUYhtOUxmsZkSC9YN9KVjCENRVNSM5AzFnFYgV/fnrX+DnHctSXkIkvQFZD+xUAlp9V9UZfP/jzde2tKZvJlvHtJBjnRIe4yTRN/nxijqghoxXNINomXkuKvatfwwzhaj8z1akY42+zMRLsF9p+qeXstbrDIl9PK9kPqswsOEsurEEDyL2CLSdGz2P84QEW+49KALMHDa4cvjBetb064XRBC3dEdFY3i6mYYxnNShz1dMEnONzfJ1NsL+0/Yt++uBjVgaUSPF5qJCxFPKZQ3e9caH0+KWujfUgfCCuwXgBWRdU2FipR1WrMqBtW60HgkUA/1OpK8SCeofYBZVlwb8bPe3gKa8+DQb860PdQbDhdEb1ytTY7a3wW25W/pLpWRPt++b9UtRGJ/NVZb7BhJVhCxt6csC3WgnfeR02Cic4oan5cGOULqZ0No662zgm+sdDBUUuRvT46FC6ajeLUzKQrlBEnGmAglH
 GEUOyP6v
 06ZibX4/exI3Wpa2JEoqRhnnu5VhhJ4JkwszJi/9pscPhfqThrPcA/8rlGBLdbd3leK704QuiUNDGSxF82eEeJF8jt2wu4wBNKvK5tSjkE2CzvrTrv3ZkmI1cpPDWza+Y3LSGCc+/gAOq+3awFr9h3Px1e9ca8PO8td6X82N9f0AzXynUfvtPDseMyoluuokCQypZ5V+l557UsfpFspXmrdRW+mkMlIGuYkcP8s2aOkyUxTuG7X30imPPP8HF6jXtJmQLwRfqBtSfY7XwAwFYiQ/CqtYYQ/aqvQpu6d7RmyhWuR7luJIZJUHdrVGK1UQitdvOVGHr2qzggd5UcWOQnoUhG9Q540OwmIdc8vPc26bcipFFyQ97RKfUwggQ+wyvI4oh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 22:23, Ankur Arora wrote:
> 
> Ankur Arora <ankur.a.arora@oracle.com> writes:
> 
>> David Hildenbrand (Red Hat) <david@kernel.org> writes:
>>
>>> On 12/15/25 21:49, Ankur Arora wrote:
>>>> folio_zero_user() does straight zeroing without caring about
>>>> temporal locality for caches.
>>>> This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
>>>> algorithm into a separate function") where we cleared a page at a
>>>> time converging to the faulting page from the left and the right.
>>>> To retain limited temporal locality, split the clearing in three
>>>> parts: the faulting page and its immediate neighbourhood, and, the
>>>> remaining regions on the left and the right. The local neighbourhood
>>>> will be cleared last.
>>>> Do this only when zeroing small folios (< MAX_ORDER_NR_PAGES) since
>>>> there isn't much expectation of cache locality for large folios.
>>>> Performance
>>>> ===
>>>> AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
>>>>     memory=2.2 TB, L1d= 16K/thread, L2=512K/thread, L3=2MB/thread)
>>>> anon-w-seq (vm-scalability):
>>>>                               stime                  utime
>>>>     page-at-a-time      1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
>>>>     contiguous clearing 1602.86 ( +- 3.00% )     970.75 ( +- 4.68% )
>>>>     neighbourhood-last  1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )
>>>> Both stime and utime respond in expected ways. stime drops for both
>>>> contiguous clearing (-3.14%) and neighbourhood-last (-1.46%)
>>>> approaches. However, utime increases for both contiguous clearing
>>>> (+19.7%) and neighbourhood-last (+9.28%).
>>>> In part this is because anon-w-seq runs with 384 processes zeroing
>>>> anonymously mapped memory which they then access sequentially. As
>>>> such this is likely an uncommon pattern where the memory bandwidth
>>>> is saturated while also being cache limited because we access the
>>>> entire region.
>>>> Kernel make workload (make -j 12 bzImage):
>>>>                               stime                  utime
>>>>     page-at-a-time       138.16 ( +- 0.31% )    1015.11 ( +- 0.05% )
>>>>     contiguous clearing  133.42 ( +- 0.90% )    1013.49 ( +- 0.05% )
>>>>     neighbourhood-last   131.20 ( +- 0.76% )    1011.36 ( +- 0.07% )
>>>> For make the utime stays relatively flat with an up to 4.9% improvement
>>>> in the stime.
>>>
>>> Nice evaluation!
>>>
>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>>> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
>>>> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
>>>> ---
>>>>    mm/memory.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>>>>    1 file changed, 42 insertions(+), 2 deletions(-)
>>>> diff --git a/mm/memory.c b/mm/memory.c
>>>> index 974c48db6089..d22348b95227 100644
>>>> --- a/mm/memory.c
>>>> +++ b/mm/memory.c
>>>> @@ -7268,13 +7268,53 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
>>>>     * @addr_hint: The address accessed by the user or the base address.
>>>>     *
>>>>     * Uses architectural support to clear page ranges.
>>>> + *
>>>> + * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
>>>> + * pages in the immediate locality of the faulting page, and its left, right
>>>> + * regions; the local neighbourhood is cleared last in order to keep cache
>>>> + * lines of the faulting region hot.
>>>> + *
>>>> + * For larger folios we assume that there is no expectation of cache locality
>>>> + * and just do a straight zero.
>>>
>>> Just wondering: why not do the same thing here as well? Probably shouldn't hurt
>>> and would get rid of some code?
>>
>> That's a good point. With only a three way split, there's no reason to
>> treat large folios specially.
> 
> A bit more on this: this change makes sense but I'll retain the current
> split between patches-7, 8.
> 
> Where patch-7, is used to justify using contiguous clearing (and the
> choice of value for PROCESS_PAGES_NON_PREEMPT_BATCH), unit based on
> preemption model etc and patch-8, for the neighbourhood optimization.
> 
>>>>     */
>>>>    void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>>>>    {
>>>>    	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>>>
>>> While at it you could turn that const as well.
>>
>> Ack.
>>
>>>> +	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>>>> +	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
>>>> +	const int width = 2; /* number of pages cleared last on either side */
>>>
>>> Is "width" really the right terminology? (the way you describe it, it's more
>>> like diameter?)
>>
>> I like diameter. Will make that a define.
> 
> I'll make that radius since that's how I'm using it.

All makes sense to me.

-- 
Cheers

David

