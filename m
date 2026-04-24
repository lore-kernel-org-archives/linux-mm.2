Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F5E2FE51E4
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 08:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DDC6B0005; Fri, 24 Apr 2026 04:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DE5D6B008A; Fri, 24 Apr 2026 04:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE736B008C; Fri, 24 Apr 2026 04:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 592016B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:52:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 011121607B8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:52:15 +0000 (UTC)
X-FDA: 84692832672.26.DC8612A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 41FCD80008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:52:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qHbu6oAS;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777020734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlYatT+5Re8K1IwyZ/oGPYbfbmVrpqRADiSmaTykRPo=;
	b=IH8+XX3EHaNVnE5WNCHKHO/radKsuFWh6AAkL48gkjuUgRALnG1jRiL3TEo3Y3L6GTaclA
	qIbYayaDp+Ht13HSsHuMo/D+Vr71vVHF6Fgw0Zam9yu2sq2fPMHcJqStszHOib4RbThSzf
	ZBYSz9umfbo2fFjKHljW5q1Bzaw3SHo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777020734; a=rsa-sha256;
	cv=none;
	b=gI3cJYnIAzEeCH8yf1VmSfKw+3MWozIleVxTDzJiHaQ8BDgZYmQXOMpahKSSp/7Pr9mbhW
	pwnXofzbnPUgFtabc5EW6L/05tuFL+Fv7BP+I2zBL4yPQgk41R2y40Dw1x7xo7lp737sau
	Rd/P2AvGWHSXD0pP1MXh3Wq+hUcwzTE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qHbu6oAS;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A06716001A;
	Fri, 24 Apr 2026 08:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8724C19425;
	Fri, 24 Apr 2026 08:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777020733;
	bh=qASsn7VxQuNfC4B609WErGpwcV6MK1E6TsPiTPwedI8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qHbu6oASLVcSZ08Zpc4nEsoVAmHkOx6JfyjrPg4mtkqF1lLtz1PDsn/tKY0d2CM30
	 kgm7w96xhaFBSneyNYbU/dEPE0cYQI/OxIpZAi4XBDyQvJwUIDhKT3Fsl2WmNnUO64
	 8aYT6byMe3dMiAB0jL/9YfxpzgzlI/XBAXczASO/UCSI0j9fxzUN9h3vMVrGdKlwD4
	 uYPtJ77sKC7Lo8LhDqsuacaHxcVdoOmYWw6rLHkwpiBVH0o7Le7x3BqYMEGfZrEKY/
	 qIm5aPg9j0h4uuCHaK1rWPEim3c35dnkRrnGkBWVTU60ptfWEYaMVOKlxUYUXYjZ9c
	 2V7ah/aO9veJg==
Message-ID: <1253ca14-69de-418f-8f94-b08e8105e924@kernel.org>
Date: Fri, 24 Apr 2026 10:52:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with batch
 page clearing
To: "Salunke, Hrushikesh" <hsalunke@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rkodsara@amd.com, bharata@amd.com,
 ankur.a.arora@oracle.com, shivankg@amd.com
References: <20260422102729.166599-1-hsalunke@amd.com>
 <20260423041249.156eb95889696ccfaf23dca1@linux-foundation.org>
 <ef5ad58f-0641-4017-a199-defd25430bed@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ef5ad58f-0641-4017-a199-defd25430bed@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: otco65acmjbdnca1k73gyk75nubdc9fa
X-Rspam-User: 
X-Rspamd-Queue-Id: 41FCD80008
X-Rspamd-Server: rspam05
X-HE-Tag: 1777020734-537748
X-HE-Meta: U2FsdGVkX1+jqK9jb4a/jt1pVgsujRt1FqcYuBIJhbH47TBzI7Q2EpoWFCxNAFSzxdc7Q2yEfZx9r49RHhl38UG4Rm2D4oYJKjLyh42uQFwoPy/akiDhw0Yl9uHuzeb9EBXeUGiWEqGC9X9RwLzh+b1nOQbKH7KXb3DH9vlV9vp2kHCsO7ZGuXQMEhkGvmcDMtRiy4BozqbLY6NX5WlpU8xlF9wX48aViPqu1ZM7Ih7qIPH21NMqZoO3aRabSo+gb1BFzSmQe9z8LqUlgPLOfqoBQdD+XbL2D2wHS1JoC0AVqaC/aylZHCiyLxq22AZjARZVsHeflqqPuZ9zpIAHhSX6hsszUKPx5Ajgmrt30BNwl5VxxloenesSplEyD2zthCObCu/yUFKP+dTl/NVLKXPZ+5am660GdjOaQlYVGcIeHMkmeHwKovwkQ8mEHUVXKFDGzM7fEZ3/bcOga2Yt9bjO4pBcVoCp1lAmTvUsoDf/qsW97BY1NQqMKahs7AwHSu+tZPxL3XsfB6x1fJE1fxlwdki1h1D/Gr2CQBgI8wNslku7gTRAgbdsXE9glGopk0+kJoBVd6dMABJasRTO0kQWQgQ3JZkpIzuZ3XXB5JKeqIfsmvvS6cJHXKCn6rX9lgGUPrvb5B3jUSglSqR0wx0nvLrfZQ1MQGfGIZ5HTZ/6H8T9EzPR0G9LLq8pgDd5Vn3/OMOzugzxp6MWDGlhzywrZV7LPkasKPdmhZsSmRMhQ/eVvHeG5T0HBDq0iojprZJRXQfk8fj5uk52wzqBoAAZAT/mFr4qGwokvxF4Y9nJEhlZNAYn4jv+9PsByaaO/bIE+CmzLSOoPa670/wRI8ZJgqkp3ovk5rRcY3HCa0evZRYUOUmeSk9/vBzN1GW43ddefD0fR/Q3wj7r8gcJnxyKJlo/hVn2M7FYg7TMlM/6KYzRMBKTnk6w3vL9Zd5GsGhXnebPPW6lUYNuxse
 Du1YvhNZ
 jP7swsx/GvrX+vKy+j2WuDBmoJrje4RvT433EH8qAzIALObJY/z7anr1iU95/tj4vaIoUFGP9Bs9hrO4SzDJth9qL1bDpf4q7Yv3CZlhQn1lJSbw2yDVx4Mp94nMULn4xbuhnnziM0BfHaNBcgrsPOeaHoSeRLOOd9p+VoYmmEYZ40Cb7Tzl7pqTR6QwT82YCQZvuwdoREp6N67kBbILmX4Sju910PrXZv7AoG66MwSRHlY8AvBvG6SOSaK+hyY3cZOR1h+1vBxhvDmCF/Zw37bYc0S93VT80eTHIjCjNKphzgpcxnuEZiX0a8sEosLIeq0g/PrH5ktFO31k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 10:42, Salunke, Hrushikesh wrote:
> 
> On 23-04-2026 16:42, Andrew Morton wrote:
>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>
>>
>> On Wed, 22 Apr 2026 10:26:58 +0000 Hrushikesh Salunke <hsalunke@amd.com> wrote:
>>
>>> When init_on_alloc is enabled, kernel_init_pages() clears every page
>>> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
>>> kmap_local_page()/kunmap_local() overhead and prevents the architecture
>>> clearing primitive from operating on contiguous ranges.
>>>
>>> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
>>> clearing helper that calls clear_pages() for the full contiguous range
>>> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
>>> a single invocation of the arch clearing primitive across the entire
>>> allocation. The HIGHMEM path falls back to per-page clearing since
>>> those pages require kmap.
>>>
>>> Replace kernel_init_pages() with direct calls to the new helper, as it
>>> becomes a trivial wrapper.
>>>
>>> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>>>
>>>   Before: 0.445s
>>>   After:  0.166s  (-62.7%, 2.68x faster)
>> Nice.
>>
>>> Kernel time (sys) reduction per workload with init_on_alloc=1:
>>>
>>>   Workload            Before       After       Change
>>>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>>>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>>>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>>>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
>>>
>>> ...
>>>
>>> --- a/include/linux/highmem.h
>>> +++ b/include/linux/highmem.h
>>> @@ -345,6 +345,21 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>>>       kunmap_local(kaddr);
>>>  }
>>>
>>> +static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
>>> +{
>>> +     /* s390's use of memset() could override KASAN redzones. */
>>> +     kasan_disable_current();
>>> +     if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>>> +             clear_pages(kasan_reset_tag(page_address(page)), numpages);
>>> +     } else {
>>> +             int i;
>>> +
>>> +             for (i = 0; i < numpages; i++)
>>> +                     clear_highpage_kasan_tagged(page + i);
>>> +     }
>>> +     kasan_enable_current();
>>> +}
>> Why was it globally published and inlined?  Is there any expectation
>> that this will be used outside of page_alloc.c?
>>
>> Both of the callsites are themselves inlined.  The patch adds 330 bytes
>> to my arm allmodcnfig page_alloc.o - did we gain anything from that?
>>
> Hi Andrew,
> 
> The idea was to keep it alongside clear_highpage_kasan_tagged() as its
> batch counterpart, but currently it is only used by page_alloc.c.

Right.

Looking at init_vmalloc_pages(), I wonder if it could also benefit from batching
if we find that pages are actually contiguous.

That would require looking up multiple pages at once. vmalloc_to_pages() or sth
like that. Surely, doing such an optimized page table walk could be beneficial
by itself.

> 
> Your concern about the code size increase is valid. Would you prefer if
> I move it to page_alloc.c as a static function and drop the inline
> in v4? If an external user comes along later it can always be moved
> back to the header.

What is exactly is responsible for the code increase? Two calls in
clear_highpages_kasan_tagged()?

Surely the compiler would just inline kernel_init_pages() already?

So my best guess that the 330 bytes are just clear_pages() overhead or some code
layout changes?

-- 
Cheers,

David

