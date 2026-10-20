Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E4160A3810
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=foZdgH0v
Received: by kanga.kvack.org (Postfix)
	id 78C4D6B04CE; Tue, 20 Oct 2026 09:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7171B6B04D0; Tue, 20 Oct 2026 09:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653C06B04D1; Tue, 20 Oct 2026 09:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44CD16B04CE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:29:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D413F1401A8
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:29:56 +0000 (UTC)
X-FDA: 85343087592.24.10FDA08
Received: from mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id A17ED40003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:29:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=foZdgH0v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792502995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYMqg4ekhN+H2mR8y56+Gn4spdCq36SruBSB9+jht0c=;
	b=scPSP9RrkzRwLfMPoPSTpX+2XvumPIXYTRtl8aYURPh6R+1BvUi80A8S4nKZEJvHC4uS9K
	gvQeWs7qFHmSWSlqsDv88YYzOqdqfB/XPOUyaBkaCs3Ddh3iN8x/bv+wSylXrj1nDgIJJe
	mo8UfHpwVjbPmzegNsvw5olf93cRIBA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=foZdgH0v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792502995;
	b=F8MN6PlxNIxRt9d/1nxQjood/7gQwo1KfCsCF+osBWQ/uSffFHH5VsllLVMWQiaKGcHrmG
	iBUR1Is3UpVvb2TPUFX52OXSLUt8zMagrcuWNKYUfM8MA3B2k4TWMXFNwMLq605EX75bFd
	jwnipu6L/rmIpp7W0B5L9Upkpgxh0uc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IKmZlEGfS2yeIgifNi1WabbugRXmrQXpvhboXkIucAc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792502993; v=1; x=1793107793;
 b=foZdgH0vzJ1Ry6v+DDc52BOnhdPefzLWppgUV2qWM0BlMmNHPu4cjGGzHWW1fKkpK+sybq19
 KZ+QEzvQHp4KqjdWw0mz6IqMXKH6QYK+jd0bm6LtODNziAxzL8Dx+xHiehSwOPlU6JoYE/cCF+K
 bt2me+wteS6F8MU/rxKMWQI0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7f2e75a512db9909;
	Tue, 20 Oct 2026 13:29:53 +0000
X-Mizu-Trace-ID: 7f2e75a512db9909
X-Migadu-Flow: FLOW_OUT
Message-ID: <f6bdf823-be42-4184-87d2-fc7c128f4786@linux.dev>
Date: Tue, 20 Oct 2026 21:29:40 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a
 page
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: samarth.colleges@gmail.com, akpm@linux-foundation.org, xu.xin@linux.dev,
 chengming.zhou@linux.dev, peterx@redhat.com, kas@kernel.org,
 rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <efa6a28c-f0f9-4d1e-9cce-fec2c08e7d9f@kernel.org>
 <20261020055518.36087-1-lance.yang@linux.dev>
 <3da45e6d-2b46-4fff-9ff3-241f70d68296@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <3da45e6d-2b46-4fff-9ff3-241f70d68296@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A17ED40003
X-Rspam-User: 
X-Stat-Signature: 7we7pd67muehwic57gs5azk833a378gb
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792502994-688105
X-HE-Meta: U2FsdGVkX1+/pfMy2SIY2/Pchv1ZiMt01xPf7xaaTV0EeVpcbwiQs7qR8H7iFLChbqzJU9WeXYlAWIiQTDnPt5bauKrcccIT8OSLApUFPsDbvqdo3v60Q34McjNnw0URY9WRIykJ7nlU4nKAJuHQKAsrMZ6avS1yP/GjuiWIqZzFiUKOJKyvthUMdqI6jllIK1QEjovuCKMUNMb6iDkjQqEpx2IjK5BElq2H+cE0ahuC0NN6U3yOzk0CzTdUigL6PJXxD6EL0yKbktkcw+VP/Ad9iKLKdpF8arlBExqF4IFvVBUN58Q5sZVLp4GLMq3Q5yXAxeCCHBGZB5sE1taXpipNFuGZGXwRDfZh5NHdqArNry4kycjqbsWZ9DQwWv962QawcUZ0Rh/o8TC6Iy7We/tvOFQM9V+e1Mhm8wIuQOGlWlIxWY8Lv+fH9mWy5IxU7Vbu9Wmf0G2Ky7pm1u1Cc6b6cGie7+kmXydc1CDi8phPYDuFrMJ4+u6NEGUn5zHToppRolEvPoh2xJuF8XFBMuON2llPm0KYF/2oEEQ074MO+3P+pcEuM0iHgyRRFytm3T2dq/IMweIg3CNVIboxRMEsPRr/VIqk/UzoLZOOpRI4dfIy8NGw/jbNG9iTItf+HpNZVCJKGn9s2m10jespGht99ijagQJMKUtsVfqu7bUitIZuIs784/7k6oTlF/fWaWLD5SH0iBAe5lVthZP1erFaTIWQr8V4RUvdEmN9W2Lxm+G0R/sxGZ7uxcKJDZNZs8VVslf/dHE4bN/hEu328hlWHxyTeqMhPdn41CUXZ2oKG+QDMvaqgUHfLmsqHARHUTYszuukOYHhA34loaBkyBow0BrOFBOxya6W2VuyayWO0I/Z++c9Mz35iWF6sdgzq9iltQlb2bxnw1jfYESdwnA+hCJLYEr1z2SMh3QYmSZiJSuHa1b1QZysmuJeOyeTlB94jgIhcHFfpeUI3jq
 FV5q+Vr2
 maI9vbJMzH9gc8rnwKJIrAIQkZjIO/rXxTDgRDeFhrl4y8yU7GOhHnwTMl47OcdJYTUZI7zi/g8w0L+0JLj32WmiZA2SGUmmS1RUwuCErk/p+4YvkFae0qSX7U1wPJqeiTLf5EjjbhCKyz+QaKgmtWQ9XxuKt7cyekJuZrAaMEBTEb8ghjMlULxF9AoeE1Ugz7sLg7p3Y+phNIn/xo/fE63u02NfeptKoj/aBcgPDGNhxK+lPMz7OB93hQeXjgE+sqnVgA9km+/B+A3Lb6a53WRH60e29SH9mRbFpQ1Era6KmIBVkEj5TrkiHUtlbp1ozqi1QKEYWK3wamZ5W0i5bwOY3q+KLHLbZzrqm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/20 21:03, David Hildenbrand (Arm) wrote:
> On 10/20/26 07:55, Lance Yang wrote:
>>
>> On Mon, Oct 19, 2026 at 03:24:11PM +0200, David Hildenbrand (Arm) wrote:
>>> On 10/19/26 03:09, Samarth Narang wrote:
>>>> replace_page() maps the KSM page with a PTE built from scratch, so the
>>>> soft-dirty and uffd bits of the PTE it replaces are lost. Due to this, a
>>>> write before the merge no longer shows as soft-dirty, the next write to
>>>> a uffd-wp page raises no write-protect fault, and because the page is
>>>> mapped with the VMA's normal permissions, on a uffd-rwp VMA the next
>>>> access raises no RWP fault.
>>>>
>>>> Copy the soft-dirty and uffd bits from the original PTE to the new PTE,
>>>> and restore PAGE_NONE for RWP VMAs, as try_to_map_unused_to_zeropage()
>>>> does.
>>>>
>>>> Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
>>>> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
>>>> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
>>>
>>> I would actually split that up into separate patches.
>>>
>>> Over-indicating soft-dirty (as raised by Sashiko) is in general not a problem.
>>
>> Right.
>>
>>> Losing WP bits is.
>>>
>>> UFFD, the gift that keeps on giving.
>>
>> Haha, yeah, I stared at the code a bit. Say we arm RWP on an existing KSM
>> mapping, then do MADV_UNMERGEABLE. We're just replacing the shared page
>> with a private copy. That shouldn't count as an access to the mapping ...
>> no?
>>
>> But the protnone check sends us to do_uffd_rwp() before the
>> FAULT_FLAG_UNSHARE handling. No FAULT_FLAG_ALLOW_RETRY here, so sync RWP
>> gives us VM_FAULT_SIGBUS. Then break_ksm() does this:
>>
>> static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
>> 		unsigned long end, bool lock_vma)
>> {
>> 	vm_fault_t ret = 0;
>> ...
>> 	do {
>> ...
>> 		ret = handle_mm_fault(vma, addr,
>> 				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
>> 				      NULL);
>> 	} while (!(ret & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | VM_FAULT_OOM)));
>> ...
>> 	return (ret & VM_FAULT_OOM) ? -ENOMEM : 0;
>> }
>>
>> So we report success with the page still merged. Async RWP does unshare
>> it, but only after clearing the uffd bit.
>>
>> I'd let FAULT_FLAG_UNSHARE skip do_uffd_rwp(). We'd still need to carry
>> PAGE_NONE over in wp_page_copy(), though. That PTE is rebuilt from
>> vma->vm_page_prot, so the uffd bit alone won't stop reads.
>>
>>> How to deal RWP properly is a good question (see Sashiko review). I feel like
>>> some more stuff might be missing there to handle this correctly.
>>
>> Tested, this is what I had in mind:
>>
>> ---8<---
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 976cd03954e3..d99f5ef1dd8c 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4119,8 +4119,11 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
>>   		if (unlikely(unshare)) {
>>   			if (pte_soft_dirty(vmf->orig_pte))
>>   				entry = pte_mksoft_dirty(entry);
>> -			if (pte_uffd(vmf->orig_pte))
>> +			if (pte_uffd(vmf->orig_pte)) {
>>   				entry = pte_mkuffd(entry);
>> +				if (userfaultfd_rwp(vma))
>> +					entry = pte_modify(entry, PAGE_NONE);
>> +			}
>>   		} else {
>>   			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>>   		}
>> @@ -6656,9 +6659,12 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>>   		 * VM_UFFD_RWP VMA, a protnone PTE without the uffd bit is
>>   		 * NUMA hinting and must still fall through to do_numa_page().
>>   		 */
>> -		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
>> -			return do_uffd_rwp(vmf);
>> -		return do_numa_page(vmf);
>> +		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte)) {
>> +			if (!(vmf->flags & FAULT_FLAG_UNSHARE))
>> +				return do_uffd_rwp(vmf);
>> +		} else {
>> +			return do_numa_page(vmf);
>> +		}
>>   	}
> 
> Looks like a reasonable direction (without looking into all the details).
> 
> I've been also wondering whether KSM should simply skip these uffd regions, they
> it never worked properly ... but I'm sure we'd run into issue with leftover uffd

+1. Did it ever actually work there :) Why not just skip them and
call it a day :D

> pte bits :(
> 


