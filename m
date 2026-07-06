Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B83BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 10:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559A66B00D4; Mon,  6 Jul 2026 06:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509616B00D7; Mon,  6 Jul 2026 06:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FA486B00D8; Mon,  6 Jul 2026 06:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2D26B00D4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:55:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 685571C7C92
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:55:09 +0000 (UTC)
X-FDA: 84958044738.21.B138B7A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7138B120007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:55:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=shX+3OKH;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783335307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kekZYZNc2HULcFXRWQtxXNVLPrL3Z9GBbHLrRK7U5m8=;
	b=Jdazk4FY/aTHviLHksZkBCF+pmuqMuyI5rqNb4NKhuz7QPYbOnSnruppIYmipDYJmNI/sk
	bNTFuewiePKxj23Eu9Kc1lm8Q2+nEhTdIVG5+yB0vF/St0QlUb/nbBOc7JQcFVCDlCAwrS
	Q9JKPW5bUOE62QOfMV+fc4GlqkFPmPY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=shX+3OKH;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783335307;
	b=PwgrLG6OGz1kQfY4JfX06pBV6k2DB3uWnjkGyURmnO26u5cmo9wUsEDE4/4wJ0bwAq/N9e
	6P69gpDgR5XGhRQCKMKvl4vzTUbHnXyNiGqytNV03ci8Q7GgZro3v6viREc0cHx45v7BjE
	H754cOOd4dh1qG3zC3B66FT0Fq/Z5KI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4572C3297;
	Mon,  6 Jul 2026 03:55:02 -0700 (PDT)
Received: from [10.164.148.41] (MacBook-Pro.blr.arm.com [10.164.148.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 302593F85F;
	Mon,  6 Jul 2026 03:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783335306; bh=kUg3SSlZYOMQVG94aHXp/3YGAOJyzCEBoYwrgN+THCA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=shX+3OKH0GDEBl7HPAkKvHndWQPXZWFDYKZCnRDHc9zSOZOlyrOtxtPdT7WkUnZn6
	 drCorekkLPZ520O6dDK+omcH6IgAdV1z6HYRZqrAw98nqbl8DNSHUS0Yu7Cfzw9nSQ
	 K3tyrSAYUqGV2vp3jALusUBwt8fqAi6J+2p6EhJA=
Message-ID: <7ac558fd-1081-456b-b997-c7321241cf8c@arm.com>
Date: Mon, 6 Jul 2026 16:24:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] arm64: make huge_ptep_get handled unaligned
 addresses
From: Dev Jain <dev.jain@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 liam@infradead.org, riel@surriel.com, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, apopple@nvidia.com, rcampbell@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, ak@linux.intel.com, nao.horiguchi@gmail.com,
 mel@csn.ul.ie, j-nomura@ce.jp.nec.com, pfalcato@suse.de, tglx@kernel.org,
 dave.hansen@intel.com, jpoimboe@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-2-dev.jain@arm.com>
 <20260705003559.8b124d2b94b685cc2e4e77ae@linux-foundation.org>
 <8fdbe0d6-87fd-441c-b6d2-baac380f6fb3@arm.com>
 <4b4e8007-3747-457a-85cc-d1003e1c8fe2@kernel.org>
 <39a13445-dc6f-4a75-92b8-f4a122c63b89@arm.com>
Content-Language: en-US
In-Reply-To: <39a13445-dc6f-4a75-92b8-f4a122c63b89@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7138B120007
X-Stat-Signature: ujnn3hs3cnk8xj1cp7tdza6jxsig4y68
X-HE-Tag: 1783335307-242226
X-HE-Meta: U2FsdGVkX18JI0dQjOC7UTzeHOZfryBHgpEaQ14gZmQeXMLQ9ag+mAR4KWyaU0CU3ziONv4kcdr8ePOjHs/tG3Pchb23mNVa0wOmdyL9G4vzEpeIDctWgmiodcqbaeXp5yO0CYi8CJPn/47fFYXdc6GkuPXSSNplOjCMhBe0OaMEJs8FaPDB8amw2804dfLbnjmV6RW3b6dIl99/N1XBtnhrwKkeZpWCZZi/8YqmQokvt1i79V1LCsSOFokbmBxt3eC4RJsHCCxhLxsbNxVZmMIpSZPym3pn8pSzCYdPyepc+0n8Rf9sazJJ6kACzis0Zml1onjMTqtUscodn5Gy2yPSUpdhpWg3YIkmOS9SEUlf0DKyxHdO1dp3jLwozR28sIFOZvjM1BPB4zXWdmoVX4hC5xkL5QWZl4lPNogUY1BxRS0CD7gTFIVP8UGviBGfCyKlJQ7k6rUPgoK1dx9RGvjqdSh3HpaL1bPDuZ9HWG9aPXq0dVeo399p4TVQp4a2SkJZnx2Xz6/6t4nOYTCk8wC2iltZQVP6l+xTeIHoq+MvIJPul2uyQ2M3CTowK6bJDaxYFTpQHgmt9CjQm9UvlOKh0KJG9DIqEBmjVC3hDRZt5n52+aEHwF8+32abcebEa64N04Iz68bxhXAnIXuPAkJLFBX6SVZQ3W9ORNfuK8sNyswJIBJjJeL9QU3aikDxW1a4e5//Mg9ZbTqekLVArxqiGIh86LMxX3rGnqG6z+q5NSLIQfLrCyYqy/8x59VbToTq8pgqz5rGq+0FOd5JkqSWXYqwNCqvKgTbAXugvUvG4fyrdK3P6gexw3gu904qzYfwfuCFNXwiI9WH67OzaJ/TqHGyb4KbEZF42u7sei0Gtydv0vj8KCHDegqiAeMyZg3F4Fv4Xj0s9ORSphLLW4I2Bf8QhJPsOjeYU0BIal2R+nzlyYNu3f7vlQIEvKoseZOucJUm8XBmpbLDofF
 ibdw9kxb
 zebZYwXWreWXPpewV/n4dUnx8TgDVaxtUgqI1Jdc7CRPaT8ILNfp1FVm+aYEd/L7pRKnGuEec8hzzRgkp0tZgF7oSqOS+B++K8b4an8XnKcCw5pxvYXFe4jcjqOEMI6h6m17auSfpJPFFdA6PsQ16I0isETO5y61GA7BCZqX8EqYQiCM9+tXpNPEC03+IlIWV7qqIfNnRQFeDO2rMvbJJuwfntHpuXzw55WnqOUo3BA/hxXMoX6FfAx+3CUVKFLWAupZ5b9SjkXBxDr4tNqTqRqOMlHpNeO21eX3dTk6R16GcT0buYCsISdI18REooAw+isQ32b0pg/GPs8d6IvN0Lmk73/MNeK+SWgkO65kW3aX4wixfEmGnzWql1qd7lBW35vRgjNLdTHAvUrChC3QsnPanHyQbrDpuvQRGLdCdkcavft0NHHZOMbXNG7ZDv+QG3ete
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/07/26 4:22 pm, Dev Jain wrote:
> 
> 
> On 06/07/26 2:15 pm, David Hildenbrand (Arm) wrote:
>> On 7/5/26 10:08, Dev Jain wrote:
>>>
>>>
>>> On 05/07/26 1:05 pm, Andrew Morton wrote:
>>>> On Fri,  3 Jul 2026 11:41:54 +0000 Dev Jain <dev.jain@arm.com> wrote:
>>>>
>>>>> huge_ptep_get() can be handed a virtual address pointing to the middle of
>>>>> a contpmd/contpte mapped hugetlb folio (examples of callers are
>>>>> pagemap_hugetlb_range, page_mapped_in_vma).
>>>>>
>>>>> The arm64 helper rewalks the pgtables in find_num_contig to answer whether
>>>>> the huge pte we have maps a contpmd or a contpte hugetlb folio, and
>>>>> returns CONT_PMDS or CONT_PTES, so that it can collect a/d bits over the
>>>>> contiguous ptes. We can falsely return CONT_PTES instead of CONT_PMDS
>>>>> if the addr is not aligned.
>>>>>
>>>>> Fix this by aligning the pmdp pointer down to a contpmd base before
>>>>> checking equality with the passed huge pte pointer, to correctly answer
>>>>> whether the huge pte is the base of a contpmd block.
>>>>>
>>>>> Fixes: 29cb80519689 ("arm64: hugetlb: Cleanup huge_pte size discovery mechanisms")
>>>>> Cc: stable@vger.kernel.org
>>>>
>>>> Please describe the userspace-visible effects of bugs when fixing them.
>>>> Particularly when cc:stable is proposed.  Thanks.
>>>
>>> Forgot for this one. It should be, on systems where CONT_PTES != CONT_PMDS
>>> (meaning page size is 16K) we could collect excess a/d bit state, meaning
>>> extra work for the kernel.
>>
>> Even worse, right? We could walk 128 entries, when we really should just walk 16
>> (IIRC) entries, possibly reading garbage or even worse, into a memory hole at
>> the end of memory?
> 
> Hmm I was thinking that the checks pte_dirty() and pte_young() wouldn't care whether
> the pte is garbage. But, we could actually dereference a ptep pointer not having
> backing memory at all.
> 
> Does the following sound good?
> 
> "On systems where CONT_PTES != CONT_PMDS (meaning page size is 16K), we could collect
> excess a/d bit state, meaning extra work for the kernel. Even worse, we may iterate
> beyond the PTE table and dereference a garbage ptep pointer to access physical
> memory we don't own. Since the ptep pointer is a linear map address, we may run off
> the end of the linear map, dereference a VA not mapped into the kernel pgtables and
> cause kernel panic."
> 
> Although I checked on arm64, there is no case in which there is a hole after the
> linear map, but still that assumption shouldn't be made.

Oh but we could access a linear map address which corresponds to a DRAM hole, meaning
there is no entry in the kernel pgtable.


> 
> 
>>
> 
> 


