Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3EFE9537B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AE5E6B0089; Wed,  4 Feb 2026 06:50:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086546B008A; Wed,  4 Feb 2026 06:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0E26B00A0; Wed,  4 Feb 2026 06:50:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA1F96B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:50:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 835B755CBC
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:50:57 +0000 (UTC)
X-FDA: 84406607754.03.B7163ED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id A9DF81C0009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:50:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770205855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=54e3nnMEbMlRo4NYQjEDgRFvwOYUnGfz3igbMPvxkxI=;
	b=PoK/+kedbChfm00+VQP43di9e1IfBiDxa2PoDeJuxVH0pl+x2IGkuW1yoN3Shx4Or9vE7W
	Ri+bnkHPvcJCBRoeebj7s3fKHRmkZeJFaPebiUc1J2HvjQKr3dCIefl0x7SMbeBoP+xqRY
	0xBgWvModYl6V2nwhoiXCUoaWjmcBU8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770205855; a=rsa-sha256;
	cv=none;
	b=tSnXQKh2bh3bNTr2Zb891HYN8r1uLZyAADqS9qgUjr4wa09y+GA/B+iIC1P5DVtsqWr94G
	Mga2cRkmStzaSXuC0T6CZbS3KNxuIke46XB9VgT1Qctj0f94mCGEURdiiYtSYpffdHGSWE
	QRpBTXDUlVSzyrxtePyBOKXRtLgWe90=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 497A9339;
	Wed,  4 Feb 2026 03:50:48 -0800 (PST)
Received: from [10.164.136.46] (unknown [10.164.136.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F04373F778;
	Wed,  4 Feb 2026 03:50:48 -0800 (PST)
Message-ID: <a9e0a6bd-46b5-41f8-be50-03300f938bf2@arm.com>
Date: Wed, 4 Feb 2026 17:20:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Usama Arif <usamaarif642@gmail.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kas@kernel.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <e65bc740-8e20-452c-b66f-0e13cd4e9c59@lucifer.local>
 <2efaa5ed-bd09-41f0-9c07-5cd6cccc4595@gmail.com>
 <b07a8d54-75f2-4d77-838a-7454ad559cd2@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <b07a8d54-75f2-4d77-838a-7454ad559cd2@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9DF81C0009
X-Stat-Signature: ss4pe1hehy36pd4urrc79rery5fkdntr
X-Rspam-User: 
X-HE-Tag: 1770205855-863897
X-HE-Meta: U2FsdGVkX18erbK6dBeBeMo5g/bzxIxo2hj6IoA6R4L4ZYltfJQSYi3sT+kXiSbPeTYfF6jNYqV6ATdqO9Vp+EBY94mPP3GyJ/xDZsaoODFpHQkIGxuKWwktcLe3sxC4GQrzIkgAaR4AaeXL24i01ixqn8qMcaC+pGC1QjYb2JnuqXpFdWmPJ1x3QUq7zmC2vdEBt6vJUw1O58TIyT6em5UdN9WxTFwCLbRzM5ANaD6xRHi+RQodBnTVQl7iFibMALDt2+dQfxvkpJgNPqVjKpDiBJUBwojj1oyicX/rOKBFExsdvdkcozPv6Ifhs7FJgE2FzKfW/EvmAo9KMctRGCX2JA2teNhAAB8VHIFvBYRpZuVUdBkTCa1DPqNZS+4b9xdCJqis8j1DlCbpxm1xkf3/5rSFJRxCuHE8eOQbbzSOtA7RYUYc4kRThyDCwnDbOZpNuuw8Ch9Pq560Mzlx/OrH5KaN2K3H9dVcx6SCRFSTir8rR1fQjDxyrE7bZ3g9xCCASDgCqM2/gau4V1tT76WD3kVlEQ5HTiRiRXuqkrxg7OZ9uZ2M+LvMYN+opjSM2WI96T3NUAq7nLSPLEE+Sk/8hGDso0ik1rQelWKY9quaLpTUWCC0TZiWti43rLOeciYTMgITYouMPDYo+6BcJdUyz3elVrnkV86PoGD+3vxjQ0Lv1aa7H5heA7dFn4R/NxI5oXFnqNiX5y3hC1I/0gQkTFSVmXmwSX0Xhsp9/6MQVNqBOKeZ+6t71q9kGT6SMMDNAmixF/dyZLkiTrA3qsl0GfXUQ0QizF8k7TesR9FvbUoNwz3tvnQ9t8CNtbuIHn+rNuhdRC9pYc3WTv60OmcDuzdm5AASO8GlKMFLs9MN0Jp+ZQuNJkKWgZuO08BhEhgK+gdrGsxjokOA7WBL3EH4IE1Ms09Z5AoBb/OI/FRF8Rw43vOI9+w+QFJgdAilRHoDeaZuG9Z21z3rNDs
 SpFTzuDt
 U8TNUhkZAlsUaBAFOfUo1ELOnXPfYXKp5LPhpvlrVxaXGzx4Y7vuqoEVpx1G0dDsKNJIQSOqYXrG5/Ss+mLzSwT7opUeUBOlepM0HAGGTg+LoLvCOI2pRx00CGI9/ndSPjqpVX7jJrtsdu2e1JRNafOJcrKyPXYXWyrOMO2aOtFKvBDvOMSDXztZ8+3MrUFnQ50hIyobSM95q/eZTvTREPwWA73hbul7nifMbq4otE1FX2lapkcswCD4du1e05zJQsf2WACCTciB2cN5BQ4hflXunvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 04/02/26 4:38 pm, Lorenzo Stoakes wrote:
> On Tue, Feb 03, 2026 at 05:00:10PM -0800, Usama Arif wrote:
>>
>> On 02/02/2026 03:20, Lorenzo Stoakes wrote:
>>> OK so this is somewhat unexpected :)
>>>
>>> It would have been nice to discuss it in the THP cabal or at a conference
>>> etc. so we could discuss approaches ahead of time. Communication is important,
>>> especially with major changes like this.
>> Makes sense!
>>
>>> And PUD THP is especially problematic in that it requires pages that the page
>>> allocator can't give us, presumably you're doing something with CMA and... it's
>>> a whole kettle of fish.
>> So we dont need CMA. It helps ofcourse, but we don't *need* it.
>> Its summarized in the first reply I gave to Zi in [1]:
>>
>>> It's also complicated by the fact we _already_ support it in the DAX, VFIO cases
>>> but it's kinda a weird sorta special case that we need to keep supporting.
>>>
>>> There's questions about how this will interact with khugepaged, MADV_COLLAPSE,
>>> mTHP (and really I want to see Nico's series land before we really consider
>>> this).
>>
>> So I have numbers and experiments for page faults which are in the cover letter,
>> but not for khugepaged. I would be very surprised (although pleasently :)) if
>> khugepaged by some magic finds 262144 pages that meets all the khugepaged requirements
>> to collapse the page. In the basic infrastructure support which this series is adding,
>> I want to keep khugepaged collapse disabled for 1G pages. This is also the initial
>> approach that was taken in other mTHP sizes. We should go slow with 1G THPs.
> Yes we definitely want to limit to page faults for now.
>
> But keep in mind for that to be viable you'd surely need to update who gets
> appropriate alignment in __get_unmapped_area()... not read through series far
> enough to see so not sure if you update that though!
>
> I guess that'd be the sanest place to start, if an allocation _size_ is aligned
> 1 GB, then align the unmapped area _address_ to 1 GB for maximum chance of 1 GB
> fault-in.
>
> Oh by the way I made some rough THP notes at
> https://publish.obsidian.md/mm/Transparent+Huge+Pages+(THP) which are helpful
> for reminding me about what does what where, useful for a top-down view of how
> things are now.
>
>>> So overall, I want to be very cautious and SLOW here. So let's please not drop
>>> the RFC tag until David and I are ok with that?
>>>
>>> Also the THP code base is in _dire_ need of rework, and I don't really want to
>>> add major new features without us paying down some technical debt, to be honest.
>>>
>>> So let's proceed with caution, and treat this as a very early bit of
>>> experimental code.
>>>
>>> Thanks, Lorenzo
>> Ack, yeah so this is mainly an RFC to discuss what the major design choices will be.
>> I got a kernel with selftests for allocation, memory integrity, fork, partial munmap,
>> mprotect, reclaim and migration passing and am running them with DEBUG_VM to make sure
>> we dont get the VM bugs/warnings and the numbers are good, so just wanted to share it
>> upstream and get your opinions! Basically try and trigger a discussion similar to what
>> Zi asked in [2]! And also if someone could point out if there is something fundamental
>> we are missing in this series.
> Well that's fair enough :)
>
> But do come to a THP cabal so we can chat, face-to-face (ok, digital face to
> digital face ;). It's usually a force-multiplier I find, esp. if multiple people
> have input which I think is the case here. We're friendly :)
>
> In any case, conversations are already kicking off so that's definitely positive!
>
> I think we will definitely get there with this at _some point_ but I would urge
> patience and also I really want to underline my desire for us in THP to start
> paying down some of this technical debt.
>
> I know people are already making efforts (Vernon, Luiz), and sorry that I've not
> been great at review recently (should be gradually increasing over time), but I
> feel that for large features to be added like this now we really do require some
> refactoring work before we take it.
>
> We definitely need to rebase this once Nico's series lands (should do next
> cycle) and think about how it plays with this, I'm not sure if arm64 supports
> mTHP between PMD and PUD size (Dev? Do you know?) so maybe that one is moot, but

arm64 does support cont mappings at the PMD level. Currently, they are supported
for kernel pagetables, and hugetlbpages. You may search around for "CONT_PMD" in
the codebase. Hence it only supports cont PMD in the "static" case, there is
no dynamic folding/unfolding of the cont bit at the PMD level, which mTHP requires.

I see that this patchset splits PUD all the way down to PTEs. If we were to split
it down to PMD, and add arm64 support for dynamic cont mappings at the PMD level,
it will be nicer. But I guess there is some mapcount/rmap stuff involved
here stopping us from doing that :(

> in general want to make sure it plays nice.
>
>> Thanks for the reviews! Really do apprecaite it!
> No worries! :)
>
>> [1] https://lore.kernel.org/all/20f92576-e932-435f-bb7b-de49eb84b012@gmail.com/#t
>> [2] https://lore.kernel.org/all/3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com/
> Cheers, Lorenzo
>

