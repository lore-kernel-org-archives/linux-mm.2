Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89D1D78780
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD566B0088; Fri, 19 Dec 2025 09:13:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AD66B0089; Fri, 19 Dec 2025 09:13:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CC86B008A; Fri, 19 Dec 2025 09:13:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C30786B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:13:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C0E116024C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:13:39 +0000 (UTC)
X-FDA: 84236413758.26.904C549
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8AA514000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:13:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SIqhcCbk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766153617; a=rsa-sha256;
	cv=none;
	b=vHmkgCflSuCg7u/+HM/VQ6su48wQYxG4KlKulkyy3es9FAhwFHiqHc9vQXvT/heYuSyZtr
	/n4ttdvQY+kj00kec7Avub4+tpAwImTDx9RJ3G2GgyUPj9lVzGodrbk4v12UmMKQndNUZr
	x7JC0Yztcrln/EZfyP/gZ3Q3uYYlrhE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SIqhcCbk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766153617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlQ/lIf/NH2L7gawVyDEnk7kQGpH1lhVi27DWGZdvfY=;
	b=zNOJZOECwldAazPK4MVyfo+DfhFxTJkFPZRTU+Vg8FWjexe2OTsGMPZoYvUW1BgqUHh/Cs
	Ueyj3PJB/OQKjjbndpCYagVzPq2tVpr3sL4+5PhgRr9q8FazWNGxfC4GeS7psGpq7qAi6o
	qjde9YY9wfgBNpwwRj/V+iH7jXiaE4s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E955A60165;
	Fri, 19 Dec 2025 14:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BDAC4CEF1;
	Fri, 19 Dec 2025 14:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766153616;
	bh=CrkOtUOzG/C+S+bRb/2kdsA2273FJPK3WzL22ob66m4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SIqhcCbk/SIwcMNfwkO6NCQwBss4ZaAM97VIiSj20QW7XS2NrW7NOulPhtZLJtp08
	 e1nUzeZMB9O+iEtSi9d+ad1kpcgyEEk+gEs5ef2H24VnyJnsiVOa8YM3Q3vATXR/R0
	 TIy+DQ2c1E5KfOjFRk0ilcCxMgA+evAqU7CKjKSWrtcur5CbfPifNIqgbxqlTnDDGm
	 vjEOJEdsszmmqzRVBKQMUVBWFC7cXbFWjU5Anz+tYT2JGXTRJtpzurxX0MeTxlAu23
	 IoK3jhKkWRbgImICt9oH22aSiG/bSE9HalI4KLa5l+jYAO7gCqLdrg0rKIY/R3ob4l
	 xQXQJRZfwTm9A==
Message-ID: <2bbe1e49-95ba-42ea-b6af-5eeb61d68c4c@kernel.org>
Date: Fri, 19 Dec 2025 15:13:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/hugetlb: fix two comments related to
 huge_pmd_unshare()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Nadav Amit <nadav.amit@gmail.com>, Liu Shixin <liushixin2@huawei.com>
References: <20251212071019.471146-1-david@kernel.org>
 <20251212071019.471146-3-david@kernel.org> <aUTYE9fHf5Fq3eHa@hyeyoo>
 <506fef86-5c3b-490e-94f9-2eb6c9c47834@kernel.org> <aUU1DY4206FibsLf@hyeyoo>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aUU1DY4206FibsLf@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8AA514000E
X-Stat-Signature: gfqicmk8tjf36wrtyuicu58jhc57f6eb
X-Rspam-User: 
X-HE-Tag: 1766153617-125307
X-HE-Meta: U2FsdGVkX19lgUm/As9xtOzxU+NNpuDsA2mMBFNef0SNeJVxRdlD0SKxf7lkZc4qcbh3wlgnLCaRAW+WLzH5hcCjpJXwzDenPI1Y3bJ47KdwukjKvxXEv6Ee3atUMUHyc7aQg0k9ykO9E15ZRqPgSVzBVV22zMDYaMLHj0aczKWi/Tb8yNneN6zjB4LV1LKn5SHBkun9XvMtD2nfGCmXo2Kt4AMVugEt9L4jBN0fju1ON93vrQTtqvnOG4imPWr9KFSC9hX5h4NFsnWiNib/Va/ikoz6j++3alx1j1E9USmTCjPOsbwBs2tGa5861Ldnzay/4EeMciNAqdfPeJnvlHaL8wNKIlVpevOpc5mcIUTC5jD+5u2JMn04Uqhmud16MpsJU8YJSGO4Jc2wD1Ys7UmnrxkLzmPgxTcHhZ3v/175c4DQ+JprOXHSA/uIwXsLxfPT3W2t+YmiRvdseNqEvX8Y6O4SH/GuJa5NdsbImFTc+3QAG34qDvy+4l17P4PB/SXGiywVDaxQz77kDNcn7TTzVpx91EYSuo9Vml6VxxEE0ok/VHfJPVdNQAjwA6yphwGyRcZecsZfo0JRdFiDoLjANXaPIo8jndw2vkX2QaUTzB5AZxLKn1sYw5wnsVi9rjMfVfc2RHhAX6UCtr7kTC9y/ORE8CK384HY74xKwr/UFJ7+NGExkqdTrytkIGikTDfv8S9AnGpgO75aGMSDiuKdvQxjCky/d++gHF4khxhqdW7adK03vS1URwqgFW5WyTVt+fOXSO8AGJRohTi59akR1DxGXHPfKht0cijGTzjHYqlmUUU17HXQnfYG7hkBW3hiOwX4wc7fhh9p11YXNz2jyRceeyy86yT1jt74cuhM3xcMuKpUmuhxXz1fuo+48oUjIS5cb9+8MELbAIRWSWow4mQ5X1kxOu68mZKvtTM14nlP3dBvJFtStRgaTxRKHADDA9EoUl6MdosBIGG
 msidKado
 Zf5vxK88JVARTfq93YHnMNi67ivQZZWT0dVoMDRqyV6MAzful9khz6djwIJd7HkOI6z+j9Duajv5UBHiDiGjV7akfCzs+qgIOiEqeOC1KXHVdkLpqQpBcAITldOSnaVctuntPAAnyo9uDBEGDh5YgIzDTemsGTYfDT0ptbHVDJuXbBLK7vm9G9Efpjy1HA4ObuhsXxk0gpIaLJERoUbYYS7hzbWhDI0hSf2RWVTGz3Rbq0xtdjFdu7ytNhLgG1H/F+jeQsix2QOoay+SsdPpLSzLsboYYlLw36Y/VByLY6o/3iZPJo8O8UcFHkxwRYUhg22D0A9l5kOuLkA/n+5pb8iRwnmRPo0N4od7myTqIlBtERuDGaJWXYoq/7D7itUN+98ihUjkow+PlQV2aaxyz4nMGy3UtjiJmhDe8lQ8Y93UqYREvXe2eHbXr/jh2cGvHBhc6cPaU/GI4azliXNYquVjUH56021VM5G6puURiVvWvG4mlHDxUb1E1IbfsaOW7yFBeg5MWr6ivRmQ2CH2SiV+b+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 12:20, Harry Yoo wrote:
> On Fri, Dec 19, 2025 at 07:11:00AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/19/25 05:44, Harry Yoo wrote:
>>> On Fri, Dec 12, 2025 at 08:10:17AM +0100, David Hildenbrand (Red Hat) wrote:
>>>> Ever since we stopped using the page count to detect shared PMD
>>>> page tables, these comments are outdated.
>>>>
>>>> The only reason we have to flush the TLB early is because once we drop
>>>> the i_mmap_rwsem, the previously shared page table could get freed (to
>>>> then get reallocated and used for other purpose). So we really have to
>>>> flush the TLB before that could happen.
>>>>
>>>> So let's simplify the comments a bit.
>>>>
>>>> The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
>>>> part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
>>>> correctly after huge_pmd_unshare") was confusing: sure it is recorded
>>>> in the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do
>>>> anything. So let's drop that comment while at it as well.
>>>>
>>>> We'll centralize these comments in a single helper as we rework the code
>>>> next.
>>>>
>>>> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
>>>> Reviewed-by: Rik van Riel <riel@surriel.com>
>>>> Tested-by: Laurence Oberman <loberman@redhat.com>
>>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Acked-by: Oscar Salvador <osalvador@suse.de>
>>>> Cc: Liu Shixin <liushixin2@huawei.com>
>>>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>>> ---
>>>
>>> Looks good to me,
>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>>
>>> with a question below.
>>
>> Hi Harry,
>>
>> thanks for the review!
> 
> No problem!
> I would love to review more, as long as my time & ability allows ;)
> 
>>>>    mm/hugetlb.c | 24 ++++++++----------------
>>>>    1 file changed, 8 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index 51273baec9e5d..3c77cdef12a32 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -5304,17 +5304,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>>    	tlb_end_vma(tlb, vma);
>>>>    	/*
>>>> -	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
>>>> -	 * could defer the flush until now, since by holding i_mmap_rwsem we
>>>> -	 * guaranteed that the last reference would not be dropped. But we must
>>>> -	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
>>>> -	 * dropped and the last reference to the shared PMDs page might be
>>>> -	 * dropped as well.
>>>> -	 *
>>>> -	 * In theory we could defer the freeing of the PMD pages as well, but
>>>> -	 * huge_pmd_unshare() relies on the exact page_count for the PMD page to
>>>> -	 * detect sharing, so we cannot defer the release of the page either.
>>>> -	 * Instead, do flush now.
>>>
>>> Does this mean we can now try defer-freeing of these page tables,
>>> and if so, would it be worth it?
>>
>> There is one very tricky thing:
>>
>> Whoever is the last owner of a (previously) shared page table must unmap any
>> contained pages (adjust mapcount/ref, sync a/d bit, ...).
> 
> Right.
> 
>> So it's not just a matter of deferring the freeing, because these page tables
>> will still contain content.
> 
> I was (and maybe still) bit confused while reading the old comment as
> it implied (or maybe I just misread) that by deferring freeing of page tables
> we don't have to flush TLB in __unmap_hugepage_range() and can flush later
> instead.

Yeah, I am also confused by the old comment. I think the idea there was 
to drop the reference only later and thereby deferred-free the page.

One could now grab a reference to the page table to keep it alive even 
after unsharing it (decrementing the shared counter), no longer 
confusing shared vs. unshared handling.

But the basic problem of the new exclusive owner reusing the page table 
for something else is not really affected at all by that change. We must 
flush before the exclusive owner could reuse it ... and the shared vs. 
refcount split does not really help in that regard AFAIKS.

-- 
Cheers

David

