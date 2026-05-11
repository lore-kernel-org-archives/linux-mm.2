Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DC05CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 05:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455BC6B0092; Mon, 11 May 2026 01:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF186B0093; Mon, 11 May 2026 01:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7646B0095; Mon, 11 May 2026 01:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15A1F6B0092
	for <linux-mm@kvack.org>; Mon, 11 May 2026 01:45:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2C851A05BA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:45:03 +0000 (UTC)
X-FDA: 84754050486.14.73EB9FB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50EE4A0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:45:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B35HU+Zy;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778478301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+AhzYrwcdhuBVFvi2BNFi1TzNm/e/n7k4N+Tm+Eb2M=;
	b=utqfSdmphpysRMp5+0OuLcKa8uzr5BbPE9lTWsbypE6l1d8CZKj0zX+0GcF9c0hzS6OBAn
	sqFyY0enWx4xtT2oGaBOPPO3a+pBVmaxqs5I7SkLu7KppRrWMnq/ScNOfNwLg65Vrvc299
	1PzjQonudnojagy4BpEAA87kDJ4muxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778478301; a=rsa-sha256;
	cv=none;
	b=lTQYjbcKcVHJNMts8EL5BTBs63iKFBRRGXxWBcNPa54om9mCwwLjgw9qIFofaDzdhPFBnx
	5Fs0e2VJtYhyDIVbMfadx4NKcdcikY3Rjsz9Vh5r++NFyThnJNIzL+lNw04mkc0Ta8RWXi
	Ae7qJV3umnCxU4VUumNSIuLiSEwooy8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B35HU+Zy;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2AE41713;
	Sun, 10 May 2026 22:44:54 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2DD173F85F;
	Sun, 10 May 2026 22:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778478299; bh=7yGxy1hSiTPiJ/R/loniiIx69AviSmIS7dZo6EijhcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B35HU+ZyrdKyuHrIW7B9PSu/JFFFgMqRt308Qf+b6/hNaIEvJl4FSohJWX2xNwojM
	 mqbcbwkxnEEWeGJBGFMtXd1rSgN2OAgWKT3kdwxxxDw9+3e40z+Rm8UXr3HgidKkkv
	 L4dTV5TRG1O04flCgcGCsJix7AydrZ2JDbxPeUtU=
Message-ID: <fcf4693f-1dc2-44a0-a30a-5daa60de85a9@arm.com>
Date: Mon, 11 May 2026 11:14:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: clear MMF_VM_HUGEPAGE on
 mm_slot_alloc() failure
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lance Yang <lance.yang@linux.dev>
Cc: ye.liu@linux.dev, akpm@linux-foundation.org, ljs@kernel.org,
 xhao@linux.alibaba.com, liuye@kylinos.cn, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, akpm@linux-foudation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <3fb8c00d-d60d-4fec-81b1-e7633384a52d@arm.com>
 <20260506105150.21504-1-lance.yang@linux.dev>
 <6b6b094b-8dcb-423b-bb86-ef1439887eed@kernel.org>
 <41676526-ff0f-4172-8871-0a825ab524d0@arm.com>
 <5db3ccc6-7184-4068-918f-72dbfc31a781@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <5db3ccc6-7184-4068-918f-72dbfc31a781@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 50EE4A0004
X-Rspam-User: 
X-Stat-Signature: 9t6joo39ym59dktq785z5tcrm7angqkn
X-HE-Tag: 1778478301-456779
X-HE-Meta: U2FsdGVkX1+lGcCKAF4NeW+11039y8MSqK1x+C82cWfp05Tg+/dAeGklV36MUiZXICXvg26u326ziyHpcncupq8IWCyG1JCkkqgfOwcqJENHoU+TXI3ujVRwC6OVlkmn9sc21wifiRPI3W4BClX2YZ1aeNSyyuW9o605PjNA1PZb9qT9qQRdC3ytfJOmtHzZN48TuPmao6Ka6hY+FubanfUB0owzJbyrY00INfEjS7bs/jzwglurqiLVt9irJDLuLr0OPyquDeSf3oRUbm5s8yu4UKUl51OZcFB3iF3PTE+O6TPU50XpebcnYUjrvWR4qJmKG0gygyRoNBOpstRCwbMry/LIb/UgJ+pkgp8PqHBzRgftrzWysKig8KlmBhT55UD5Z8CtwkYVz16q2/KdQxRIDA2AWz2YcVPrrVBnNSe/pR9EKTvwDjs+vzIvQhqLqLYBX7ehIenGov7gFoAPSdWIw+jaXezk9IUJPP1Kvq6mf8NlQXe9qyvHo6f9m4CO9a5hPHIxhf9iaZy5BYkI0/tkVwQGEUbn/G9GrdbH/u3yh1p3NQwn5HzPiibj+35DlROeDBSKEE8XbU5USgbYO599lQJHBjfZZX9pG/hvEFGok2hsb64m90/nDANFlf67y0E2qmSHQ4KWT3wTTfISGIg+ltSIIJYp9+930GCSGSQVvtub/htdN1p5AYYB5vOe+2x2ZOjwV/BpKn8zBNfNI3ghqTDAuFd1L9R17vFgKnZnP2//wSUPbRzU0MkU32GPl82KVYuU+9WaeZh/FW4XwK4JdEfM0dQtazaeT54Jd00m2NvGHpPP2dtJ/k7E+VFjZzxEggjzB1b/hXKLRC9gWGiZjfarI75dV73jNm+CPrsNvSZNV5VtW3ms1yogGvrHHDkptiinG9DDVKoFL9Q2o9BNrCTAiaeBvoy31KXVoMumFoRdVyX9V6TiItjX5cz7JDUhK1Ho6zMBjXFbp5A
 Vasz7xbc
 ClWG5e0AaYpdrtifHo9r/544F6kRAazs6sE37i86NBg+lTpNhw545FUEx6Z3DTNz9gGgbj4KVz+GtPTCDhAcj/KrJUAq3lhfQFCDDaGAdhCqR/tCYuPNEza0jFTg4eKIhiyiNyREGrWFLNKi78cWbeztf5f1mVdrcPtYnBIASv9wu4M1IbxO6H6vQCk++8QwZFJrQW3nXFraCafqOrJFftAhi8kd0UcMQqokqmuvaZLpfV4me3vLZcbcobEA9qFKpA5KzhId290ks0x8/J9SKgHa9ia/xqc1ftMldJ5+PhxP5bESHGUYTfX6iBUMo5HxuTT3i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/26 11:10 am, David Hildenbrand (Arm) wrote:
> On 5/11/26 06:00, Dev Jain wrote:
>>
>>
>> On 09/05/26 3:11 am, David Hildenbrand (Arm) wrote:
>>> On 5/6/26 12:51, Lance Yang wrote:
>>>>
>>>>
>>>> Right. A racing khugepaged_enter_vma() can see MMF_VM_HUGEPAGE is set
>>>> and return, then !slot clears it again. If there is no later
>>>> khugepaged_enter_vma(), the mm still wouldn't get registered :)
>>>
>>> So why not
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 5f4e009593e0..78735f34250a 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -437,13 +437,16 @@ void __khugepaged_enter(struct mm_struct *mm)
>>>
>>>         /* __khugepaged_exit() must not run from under us */
>>>         VM_BUG_ON_MM(collapse_test_exit(mm), mm);
>>> -       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>>> -               return;
>>>
>>>         slot = mm_slot_alloc(mm_slot_cache);
>>>         if (!slot)
>>>                 return;
>>>
>>> +       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
>>> +               mm_slot_free(mm_slot_cache, slot);
>>> +               return;
>>> +       }
>>> +
>>>         spin_lock(&khugepaged_mm_lock);
>>>         mm_slot_insert(mm_slots_hash, mm, slot);
>>>         /*
>>>
>>>
>>> Arguably, on the race described above, likely the thread seeing the
>>> MMF_VM_HUGEPAGE would likely similarly have failed the allocation.
>>>
>>> I'm fine with either, just wanted to raise the (cleaner looking?) alternative
>>> where we just properly back off?
>>
>> Yes this is also fine - I am overthinking but I wasn't going this way because ...
>> A process doing THP allocations will fail on the mm_flags_test_and_set everytime
>> after the first time.
> We should perform a mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) test before
> calling the function when the flag might not be set yet: in khugepaged_enter_vma()

Ah that slipped my mind, you are right.

> 
> khugepaged_fork() should only get called once per process.
> 
> Which makes sense, because mm_flags_test_and_set() is expensive.
> 


