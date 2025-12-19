Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EA3D711CA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08DA26B0088; Fri, 19 Dec 2025 01:11:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065176B008A; Fri, 19 Dec 2025 01:11:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDDA06B008C; Fri, 19 Dec 2025 01:11:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D906F6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:11:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 807E48AC5C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:11:14 +0000 (UTC)
X-FDA: 84235198068.26.17E96CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A5FCC4000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:11:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p9uW/ErX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766124672; a=rsa-sha256;
	cv=none;
	b=JH/yeNZ0OWWoPlWyUIb8kfCVTxtYvDdJCvjbfDCM/HxUsfHDKLxNHaDMgQiqxQveaNbCzn
	ScHfLlK9tyY2zNstN8W6JsHg+nQGlqEFSx1IryLMP0NAWLjklCkLah+AQv6hGznqL2BrcV
	QjgGx5uhlOUHaFnstfUVZBPL+9M/O4g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p9uW/ErX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766124672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A40medSLWFhpVyTQLeNEahQ+b6ziVHQsD/Y587JR+wU=;
	b=5B695nFguL8wGikoXelnMnIAswsDs5WKi2awCUReRAzweWXsbWQZOeLjzL8TPkyBULaw5B
	l7t5RenvP+xM0xKnG17aEYRv8wlknU3ySVDnD2AKoqfNK5UidfftO8W6Pfw9zg7QNUX8u9
	IhWbz41/JTw5nI/UeZLJIXsPeVn4trM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 48F4A43DBD;
	Fri, 19 Dec 2025 06:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09355C4CEF1;
	Fri, 19 Dec 2025 06:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766124671;
	bh=lMx0tZHit8feygPc0c3IX00fMWdf+rQft4YAallTkBQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p9uW/ErXy0F6ct3rFLCv4PBWLBoEIWy8uzSJ+hIW3grHckseSAUus0VQIUpGYPXvQ
	 2lwtlCx5UzczEeLqQXDQa100Wfvwd/q14qVhh1L0b1GalXww8TT63dMNyXmHWqxMv6
	 q+41ZmwWmwwyre3RaKoRXzlg1gn9l5W/DrGhw0BuM8oW4J6BsCZZGlzf+dsMobg+OR
	 KCTzt0O6Fcir7Lu+xJk+7vga32wWsNZ4Dy81d+sZ5WnMnn5ryv/XU1cAO1K6ypJn1t
	 Py1EyuZuY/GLPZkGsGx125qn1YBx/QUWYWKN++Bl/7NupY58pqjQN23Sr8M4zFmFjN
	 uHZKCXzvE24Lg==
Message-ID: <506fef86-5c3b-490e-94f9-2eb6c9c47834@kernel.org>
Date: Fri, 19 Dec 2025 07:11:00 +0100
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aUTYE9fHf5Fq3eHa@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A5FCC4000C
X-Stat-Signature: 77ic9widpwopr76d667saq9ojshdfytq
X-HE-Tag: 1766124672-731749
X-HE-Meta: U2FsdGVkX181QcsivMMuUedPaw1Hb+9FgjqKstJS7CPat6+TI2RtIqUBvQKTtEefnM+s2opfzuhoFiKSmO+P0PwxzwSog1jfDoIQgEV0dUi+9AFB6eOlC/UUQk9x2gK3YUhNBmxbXOFurPQYWd1ryH2FnABkP9v124A+kJ+Og4N5d6ueOhl5XEk+uuew/rXUz/PCYisGkb6d68lRNDqStPBjrELJpI+F5a02VlPiAK2Q6huZpklJCSU9OhsQQLiWK0UfBlmrguZvjgc09cuJs3p/FRXB/vZrVq2m5dMuXYAtvDDfiZlptGjoipEL3qoHShKyLyagx3arZOSPycS/TRoepv6a+VDgVlZ835X4wUdt8TerpgqbE2UNllxZb6KSRhA6fFTZrJ8gIXXKRUcoQ7FkMy/q7f2wN8DE5yrwHh4VKNS3/Nex6K/ZmMOlHh9o6xs1cZsVp9VZxs8y4SeX+GJLPV2RW+JEi9Kolgb35N5WvAQY7Ed4v78iqC4jwmhZtkdeRMuEfIHvUYd4IqOBvOkcfbdyx07V709gTl4AP/P7muN8T0OgVknbuh8LgxGd02KIaeiw4iEVkyOI0PR+oqfFErjRpoXPCU2J0PfDTEa8k9D5Wez8ZBCr1Qgup+PueI+7HGz2LHp39byH3a5mLubPCeNYzj5znJAI9YH+qJvFXDOKClouymIn7//fMmPyMtq+wqkXKJ/FIqvPXLNqpv0VJAo1TPZw1wYMixntvbb8HWaLQum6NJTjFTfZDjyiK3mjWNjqsw+vhnJb5NMeYymMOAdTnknyVL/lAMqDCUi4CvT9S9MK7XxjoB+XyaPR1QWlVhEDl0lisWIXpT//aZ6K/TZy03t4XbIenxr9huU3QruxCJqZqhKZb+jme6TaXTaIncpP23r5Zzfe1P20VxpH5P3Sc5XoAYZhJB+N5QR4C5CWE/UjO9mNTsMHBDs3qluRIs+liydSzEhxpSr
 HR1SvO2v
 Vja6YfJBIeVAHq78ev6Y3ym3VPGH+bOJVDZFfEa6xqqUPzR3MangF70ikExNIWquCjOA17cpy9YkGIDyuqSe2QydTwx6ZzeE71FsUm8FAvCTlxMb4t4bEaLzMmnFTdP6NofH93k2t/QdI5aqIS0QTdd9kLJFGha4r6V06FdJfflKbFFuAWSga803j1ybzqineRvtsygB4ah5+neyC4aaUzDdyeGPYhvANRfn+w+K8qaDnXjmCw7GdK6j2YshNC6YZH8HOo6IKUaKAk8uh3OG/DvOcI6utO23Tb6kjiojBsj3HWJGvri3q959kc6fthFy46LJFllpihfxd7MJ8AgWr1E7dv1uqY4GWhtAU//y6lz9GBJTB1Utp+kDoFKmSTot31qvF7Nw+Bnhjgh+f7MyTzqOspTBN/qlYy1Z8EqRGwlBMi0RmvPx2JBOIyiTegfgyNGKpqviGV7+3r3Ln+SpDY3wV2GAbvk7qJVQrmE+dh30dAOE+HMzqQXFX4p54ikfymdQAWdm0TgkjD5VQ/rNCxcbjog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 05:44, Harry Yoo wrote:
> On Fri, Dec 12, 2025 at 08:10:17AM +0100, David Hildenbrand (Red Hat) wrote:
>> Ever since we stopped using the page count to detect shared PMD
>> page tables, these comments are outdated.
>>
>> The only reason we have to flush the TLB early is because once we drop
>> the i_mmap_rwsem, the previously shared page table could get freed (to
>> then get reallocated and used for other purpose). So we really have to
>> flush the TLB before that could happen.
>>
>> So let's simplify the comments a bit.
>>
>> The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
>> part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
>> correctly after huge_pmd_unshare") was confusing: sure it is recorded
>> in the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do
>> anything. So let's drop that comment while at it as well.
>>
>> We'll centralize these comments in a single helper as we rework the code
>> next.
>>
>> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
>> Reviewed-by: Rik van Riel <riel@surriel.com>
>> Tested-by: Laurence Oberman <loberman@redhat.com>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Acked-by: Oscar Salvador <osalvador@suse.de>
>> Cc: Liu Shixin <liushixin2@huawei.com>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> with a question below.

Hi Harry,

thanks for the review!

> 
>>   mm/hugetlb.c | 24 ++++++++----------------
>>   1 file changed, 8 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 51273baec9e5d..3c77cdef12a32 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -5304,17 +5304,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>   	tlb_end_vma(tlb, vma);
>>   
>>   	/*
>> -	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
>> -	 * could defer the flush until now, since by holding i_mmap_rwsem we
>> -	 * guaranteed that the last reference would not be dropped. But we must
>> -	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
>> -	 * dropped and the last reference to the shared PMDs page might be
>> -	 * dropped as well.
>> -	 *
>> -	 * In theory we could defer the freeing of the PMD pages as well, but
>> -	 * huge_pmd_unshare() relies on the exact page_count for the PMD page to
>> -	 * detect sharing, so we cannot defer the release of the page either.
>> -	 * Instead, do flush now.
> 
> Does this mean we can now try defer-freeing of these page tables,
> and if so, would it be worth it?

There is one very tricky thing:

Whoever is the last owner of a (previously) shared page table must unmap 
any contained pages (adjust mapcount/ref, sync a/d bit, ...). So it's 
not just a matter of deferring the freeing, because these page tables 
will still contain content.

I first tried to never allow for reuse of shared page tables, but 
precisely that resulted in most headakes.

So I don't see an easy way to achieve that (and I'm also not sure if we 
want to add any further complexity to this).

-- 
Cheers

David

