Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DCAAE9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 10:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA146B0088; Wed, 18 Feb 2026 05:46:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4880F6B0089; Wed, 18 Feb 2026 05:46:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33FBE6B008A; Wed, 18 Feb 2026 05:46:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1ECFC6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:46:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAC5C1404A4
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:46:36 +0000 (UTC)
X-FDA: 84457248792.06.80A417A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2AF8440002
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:46:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IG0GMRCf;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771411595; a=rsa-sha256;
	cv=none;
	b=rnHHUrUMr9MNGaGWzH0g4ar0nVwKdcQnLd8Twz1T6piTJcv+hLdTj9maMY+9jIBUTu3+0p
	mpNjmvNrq9LgE5r009JY+4701Tz1Qe0ulZ7kXTqsxmIYzqVDYrEfQ5uTJ8nTsCJfe2AyNo
	nl3BPEleYUBRnr2ZQiSvAp79ur05yoM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IG0GMRCf;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771411595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K+9i2m7ogITdn6nzrZXuWEXXRacMBnzKuw8OGKGRhk=;
	b=BYM2Lzdkp9dShAackoL92i15O8NUeUX5J+d7/7LSbJegM7O9GzP/XjJFHYkZLtUdM/AJ1z
	k9t1w/XzxqQkZqs5u+4w9bAAc9HWGrT2s83Ex3IY0fDwLYvmM++bh8ju5wrs7OXzllEsa3
	RFiM9euBQp3xTyrc0Mwu9mjUoO+yhhU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84E96600AE;
	Wed, 18 Feb 2026 10:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB605C19425;
	Wed, 18 Feb 2026 10:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771411594;
	bh=7XhNNSvmExkbDNTO5Fje9LxDjaIAJ+98Vm+0ntU8Uic=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IG0GMRCf3UsdcF1GtjK7G6hfwJr58csKlNTW1jawJzOIXYSAFxkwn9maOi3PXV4CQ
	 il+QHs1pWFt/17uApeDdE13QCpOsQT5jA3CjyRXl4Tl9D3wnefC95j+m0ERcsHEX79
	 GAdY8LDp1untUC5GhrkN8+OHtvFscC36X+wX0hHqPqaqaVtefM+d4BdnThvk8uN9xc
	 4i2vqNPGn8uhqalR3U4f1CzJegHZ5UVn+99cP+Ba9MmRvX3Xl0mOZ0n744PcXTR5Zv
	 r9TWyIVStgNJf6Wi5iFq92CHz1qBPTAlTvxIIvMiUCFddSkKCCrYOdH0L/rmD3BuNs
	 C4Fte9qINIUlg==
Message-ID: <340be2bc-cf9b-4e22-b557-dfde6efa9de8@kernel.org>
Date: Wed, 18 Feb 2026 11:46:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Dev Jain <dev.jain@arm.com>, Pedro Falcato <pfalcato@suse.de>
Cc: Luke Yang <luyang@redhat.com>, surenb@google.com, jhladky@redhat.com,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, willy@infradead.org,
 vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
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
 <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2AF8440002
X-Stat-Signature: rb3pw43ongbmuc8dto757yq67j11yn13
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771411595-243722
X-HE-Meta: U2FsdGVkX1/NmbXT4BmqkTeEaF4l1SgCSUJfSWcuyCJZqYZ++pxEt1Y0DzbLTrSbjmwarj1/X+xDyMXf2jlohyLLWluOJipEElAwVJb0oixoCBu3SzQWoRGXDbycdPgXrh9MwKd8F4PmuShE/G+74bEZz6hp41copvs3XydvR+LkchLWtZN9JmS+kROCkWbQ11AxS/70bkpyQgTGansCTz//0GC88rMKSs3M+CrY38kZUrMbZUdI+Tzp1UdRnBW7Vqu9tkve/bRmsrJrp2WMO9OWMT9GcL5ck0ACz9AfeFHMk/3WcFRXvd+W8o+mExCxdItxvlVgCW6DxdkfdzZ1RV0o/zLRLuhgjT4Yp5vuReJ3joEOLonoiRTVm6iu81Rx1yqyp+Q0IEf0+nYxWxYikH/Dd0NXvu9JBr1uHCdZ2Xw1m5Rr5tf8oZG3biktoYiWDsj7c8TPU4Hn8YxJO/wtwgTI4ROoBCtb/hJDTzagu9xfmcQV6CPyJf4O9ynjDT+VvLww7jOkDtulnPaTlz/PE+0LO3yosFTpBt7QFf71nlm/Y6uX/3sjyPZIAc6VHkaMi2kXFi7yvFLljRmT3u6dicN/fYfUoTgDn8BtAplyfvSAIhHghn+Yj/qdVrOHNAqJD/f7n3wIya9qZTFjNbbw2t96Taa+Hd/OKJL5rwKIa9djbH2PMnLG5uwmoHAfCmH1Zix5qlQm31r+cKqTsn0tn1udQ/FjvUaxjOioKkntJ+OdI+sW8SMx2yijEvyTTdI5DPJZ9zQUsbSpTV/TkJ359xP5I2EiRb2KKn6cyiCL44sUG4Jg5QBafjnxwO1GHsbhEA92nx8FZodDv7EwZaZx8vVJcy0fqulSkF8SzRu8NIdJ1uasff36ZE9wbFy2ThVD7AvcF4XEs4BHK1/DNywOTmCdddRSdufF4vbfTHW/qEX+BxE9EF39vQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 11:38, Dev Jain wrote:
> 
> On 18/02/26 3:36 pm, Pedro Falcato wrote:
>> On Wed, Feb 18, 2026 at 10:31:19AM +0530, Dev Jain wrote:
>>> Thanks for working on this. Some comments -
>>>
>>> 1. Rejecting batching with pte_batch_hint() means that we also don't batch 16K and 32K large
>>> folios on arm64, since the cont bit is on starting only at 64K. Not sure how imp this is.
>> I don't understand what you mean. Is ARM64 doing large folio optimization,
>> even when there's no special MMU support for it (the aforementioned 16K and
>> 32K cases)? If so, perhaps it's time for a ARCH_SUPPORTS_PTE_BATCHING flag.
>> Though if you could provide numbers in that case it would be much appreciated.
> 
> There are two things at play here:
> 
> 1. All arches are expected to benefit from pte batching on large folios, because
> of doing similar operations together in one shot. For code paths except mprotect
> and mremap, that benefit is far more clear due to:
> 
> a) batching across atomic operations etc. For example, see copy_present_ptes -> folio_ref_add.
>     Instead of bumping the reference by 1 nr times, we bump it by nr in one shot.
> 
> b) vm_normal_folio was already being invoked. So, all in all the only new overhead
>     we introduce is of folio_pte_batch(_flags). In fact, since we already have the
>     folio, I recall that we even just special case the large folio case, out from
>     the small folio case. Thus 4K folio processing will have no overhead.
> 
> 2. Due to the requirements of contpte, ptep_get() on arm64 needs to fetch a/d bits
> across a cont block. Thus, for each ptep_get, it does 16 pte accesses. To avoid this,
> it becomes critical to batch on arm64.
> 
> 
>>
>>> 2. Did you measure if there is an optimization due to just the first commit ("prefetch the next pte")?
>> Yes, I could measure a sizeable improvement (perhaps some 5%). I tested on
>> zen5 (which is a pretty beefy uarch) and the loop is so full of ~~crap~~
>> features that the prefetcher seems to be doing a poor job, at least per my
>> results.
> 
> Nice.
> 
>>
>>> I actually had prefetch in mind - is it possible to do some kind of prefetch(pfn_to_page(pte_pfn(pte)))
>>> to optimize the call to vm_normal_folio()?
>> Certainly possible, but I suspect it doesn't make too much sense. You want to
>> avoid bringing in the cacheline if possible. In the pte's case, I know we're
>> probably going to look at it and modify it, and if I'm wrong it's just one
>> cacheline we misprefetched (though I had some parallel convos and it might
>> be that we need a branch there to avoid prefetching out of the PTE table).
>> We would like to avoid bringing in the folio cacheline at all, even if we
>> don't stall through some fancy prefetching or sheer CPU magic.
> 
> I dunno, need other opinions.

Let's repeat my question: what, besides the micro-benchmark in some 
cases with all small-folios, are we trying to optimize here. No hand 
waving (Androids does this or that) please.

-- 
Cheers,

David

