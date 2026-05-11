Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C59D6CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 04:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA82E6B0088; Mon, 11 May 2026 00:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B588A6B008A; Mon, 11 May 2026 00:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6ECD6B008C; Mon, 11 May 2026 00:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 909D06B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 00:01:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E0151A0586
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:01:13 +0000 (UTC)
X-FDA: 84753788826.19.40AF7F8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id E42A4C0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:01:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B6yi5fEW;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778472071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjWDLgclQIUy9f5xty+kKheorSs2pXPg50NN9Ixc12k=;
	b=NQwea6gE92+aqDbiu4O0BFV3sMvfTuH5wZNwFaz0fUzSEc8yD7mpwswhzdKFn2v2qtogHn
	uvPmP8QtLYREj2izODo4jNJWdsyECjjZjadvTbqiTY07cLWk5j3Qs/kE5AlvfBeyw2WFVh
	cn62Dtj2KHabQ2edvbNU7//w8jXBXiY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B6yi5fEW;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778472071; a=rsa-sha256;
	cv=none;
	b=Dw5aI8tVvLdGGQa8bBhqYWV4zM1OI3zItMATKEDQyfU2k7XarZtpFyEO1LiRu5JTaGu5Rl
	mbcuUF2nJ5JlKNmZO98+kSXlUU8ExsoG6sQPmgxdvywVENtv9+8smrDv4mVUKlUNJQmJCm
	6oXhLj5aafO8zhO1Y2cpCMV7FwpFs44=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C7D41713;
	Sun, 10 May 2026 21:01:04 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB4963F85F;
	Sun, 10 May 2026 21:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778472069; bh=Ze0K/dB4LHZYNGAyRbWeOVVY+VRDSzPHaSagb6AO+Ek=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B6yi5fEWqy8MWcTv8zi+90Kv9d8NeRJLHFRGZcn11QlHv0JTPwF7zuCmlgFNxV9Re
	 fR8jHQQP4pY3+/KE43KPG5+7k68DhFSiazqBxXQhdRy5GTed23z2GCMdHO+jMqzv1g
	 uEZhHCkbt1y1PqmxzH/ftuncw0x5YGcLU38lnq8I=
Message-ID: <41676526-ff0f-4172-8871-0a825ab524d0@arm.com>
Date: Mon, 11 May 2026 09:30:42 +0530
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <6b6b094b-8dcb-423b-bb86-ef1439887eed@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E42A4C0007
X-Stat-Signature: i7knm5jb3apefhnw99ghhipbrgdtfrhn
X-HE-Tag: 1778472070-482471
X-HE-Meta: U2FsdGVkX18TnA4nVOfmjutTj1YRlPcZdCAi7kfvFcyj5G0Tp2CgAbiYotUsb5oFwkLvzKOs1NGbVKuUWF+YpEckXCItdnlAVUTPdh/7kl64KYsDGPrgqT245qxqGLY26YwSQ/X6rgxFk5VqPHlKRChA5PyyTTaA8wZBR985rtorgsB+Jce1HCy//HQuV3XJgJ52XYN7DaBrjC7IkY3xzZW3BsiM9xO8VfNZB/cajgd0XMwdQpioczwMXnyUhRdsepsUaXo9GSyfE06JxvfC9w4B2y1keIRoL9WK+v2hUSpyoIrWh52OFKBWFCHvnFsb3A8dR81XoyRQEYAS0C2GsozcOBRoPp1jEKTQ/YqJGD17qgIB8qI+CJzUMpTp/nEfJ9bcmMEuqLO4iJ0ld8EWKjvAfA1G3xepRLeTZYoNR155sPJGdJypdO6jo7e0s35s3ptZZsvUeu9gSwt7OXUQR4k5XRqKuB3qEdZRcyFELuxwFqlgvnKjq5uzTdNkcEigfjlVmCv/IRP2vz8o6jP4yUHMl8Jn+OdMw8C2PG7XxbMSIMuZ+yhVifHVkVu7c+3SOGSONGyk3cg4KJ/LggJtop77nrOqNdtefvpM2Ypbs4HPguoI19eUqgL7bF/y0rwH1106svTjwOTIqfG9e5H5AKSEHuPSGuwFRjKdETFGiDWLG5VzE9b4rUTTxAZPZmbB8Hs/1CtRHrcBBarIdhvJCBZ+PkbsvqwN4b2Z0okEZAHr+szwnldobDYJsG0Sf6DFfVk3OzStM1KYDim/9rlpbObwlppHzBW15VSz+Q5mx+y+RlYxFOKj0DL/sTXMcQGUoPqr5H7yBNIhYU80XBvPw5FrlU1i6AA9Eubmvvn4zuRcY4cJZlCPuPeJuW7nmzCS9m4uKhTEP8B4itHMR6tt99B6yyq/rmEC562tBjnZLWgrv4LQfbzdasvg9Zgix3wCaoZl9rsQqPMV25rB4I4
 kxw54w2T
 oPuPDwBvkxk+zDYs8CNvVIoCJne70soXS/sUm0pzMHCun1kFFz/TtxALuUfn+1pCVfbAuIjFF09vzU8Cy/hdsKZ8o0Td64QuJM/0O/WDfCF8sX92KJgLYxVuwwFfMy9jm9Ykq+xQhCkuvirEjOUa1MPhpNqgymr6n5MgKfXpjvC/GaHWUWJ/AfEc6FtUjUshW5LJMs/kOZpEENOCY2KM7xuqB6Gb5iXHCwcVuWN3/odZ/SvLfVYJ4GUQjhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/05/26 3:11 am, David Hildenbrand (Arm) wrote:
> On 5/6/26 12:51, Lance Yang wrote:
>>
>> On Wed, May 06, 2026 at 12:16:35PM +0530, Dev Jain wrote:
>>>
>>>
>>> On 06/05/26 6:51 am, Ye Liu wrote:
>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>
>>>> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
>>>> corresponding mm_slot.  If mm_slot_alloc() fails, the function
>>>> returns with the flag set but without inserting the mm into the
>>>> khugepaged tracking structures.
>>>>
>>>> This leaves the mm in an inconsistent state: it is marked as
>>>> registered (MMF_VM_HUGEPAGE set), but will never be scanned by
>>>> khugepaged.  Future attempts to register the mm are skipped since
>>>> khugepaged_enter_vma() checks the flag and returns early.
>>>>
>>>> Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
>>>> restoring the ability to retry registration later.
>>>>
>>>> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for struct mm_slot")
>>>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>>>> ---
>>>> Changes since v1:
>>>> - Add Fixes tag as suggested by Dev Jain and Lance Yang
>>>>
>>>>  mm/khugepaged.c | 4 +++-
>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 7d48d4fbd5f3..60ab7c1b61dd 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -559,8 +559,10 @@ void __khugepaged_enter(struct mm_struct *mm)
>>>>  		return;
>>>>  
>>>>  	slot = mm_slot_alloc(mm_slot_cache);
>>>> -	if (!slot)
>>>> +	if (!slot) {
>>>> +		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>>>>  		return;
>>>> +	}
>>>
>>> Note that, a racing khugepaged_enter_vma() may back off
>>> when it sees that MMF_VM_HUGEPAGE is set, but then the above
>>> clears the flag after slot alloc failure. So we end up not
>>> registering the mm with khugepaged. But I am sure no one
>>> cares, we are in much big trouble if slot alloc is failing.
>>
>> Right. A racing khugepaged_enter_vma() can see MMF_VM_HUGEPAGE is set
>> and return, then !slot clears it again. If there is no later
>> khugepaged_enter_vma(), the mm still wouldn't get registered :)
> 
> So why not
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5f4e009593e0..78735f34250a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -437,13 +437,16 @@ void __khugepaged_enter(struct mm_struct *mm)
> 
>         /* __khugepaged_exit() must not run from under us */
>         VM_BUG_ON_MM(collapse_test_exit(mm), mm);
> -       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
> -               return;
> 
>         slot = mm_slot_alloc(mm_slot_cache);
>         if (!slot)
>                 return;
> 
> +       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
> +               mm_slot_free(mm_slot_cache, slot);
> +               return;
> +       }
> +
>         spin_lock(&khugepaged_mm_lock);
>         mm_slot_insert(mm_slots_hash, mm, slot);
>         /*
> 
> 
> Arguably, on the race described above, likely the thread seeing the
> MMF_VM_HUGEPAGE would likely similarly have failed the allocation.
> 
> I'm fine with either, just wanted to raise the (cleaner looking?) alternative
> where we just properly back off?

Yes this is also fine - I am overthinking but I wasn't going this way because ...
A process doing THP allocations will fail on the mm_flags_test_and_set everytime
after the first time. So we will have an unconditional overhead of
mm_slot_alloc in the fault handler.

Again I am overthinking : )

> 


