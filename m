Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF29CE9126A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 06:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EA1E6B0098; Thu,  5 Feb 2026 01:40:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C21C6B0099; Thu,  5 Feb 2026 01:40:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 097D06B009B; Thu,  5 Feb 2026 01:40:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E75256B0098
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:40:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E6D813AC67
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:40:16 +0000 (UTC)
X-FDA: 84409453632.01.B6325F9
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5448D140004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:40:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dRRpvfRI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770273614; a=rsa-sha256;
	cv=none;
	b=NJGgibOP6wXRUo1+ToQHex0AxrahXhUqmwi3mNkf2gMKZrh6rzxcXnPh+7wc4QevH99GV6
	NZ2vSb7omSO0voIVObWIphomKWdpDdTWDpXV0E8pP9Uk6i05Cq48XNAvhRIJD6Nq64tH4s
	vdDmXGvKDF/DoSkuooEjLqovz1ymHs8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dRRpvfRI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770273614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxUlt9iOzTlAUVTV6PVTek3fJpMPieKvkeAmkn/pVCM=;
	b=mHHcU8aV/4bMb95mnGGkXwijhVuiuQyxyabt7QYiRxyqKCkRerGZ986NdhknXyAr2ffXOJ
	9ki89eVhUMePY2ET1YCN1xvsl5yx/UT+GH4QXeuU8l4HuoRzp9JRV0+CjWNiCPs0PK9cRY
	M+H+xMuUpbTeS1V5Z4f1430ieN+rMYs=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-124566b6693so1868252c88.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 22:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770273613; x=1770878413; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jxUlt9iOzTlAUVTV6PVTek3fJpMPieKvkeAmkn/pVCM=;
        b=dRRpvfRIsAyBmaDH5ROm74kJLS51+zJpW6FdvuFuSF7ch0oN7YWMFr+LyKdIk0R0CA
         hsZq4qrCexPWi+JibRgqFGHFnsFX1PdreKaNZO1gG+y7484DS77Uh6aAT94KUVMwkuK7
         KX3xDzuoCq5IPH0+q/5ake1sVAZUD6ebc8cV9GloQViSRJoDC1JuVaVwZ7uAsD5evXRJ
         Lwy4as9HKOl/UaQpI7r+TO9mTYGHMjdEkbDEyVItx4TeamHxcEm8DQ0V+BMO/towK2cF
         LCiCG2UPuNZIVuUGJScq5WJkTug9uRig85XcmtOlbtGS347osRRL1kcU83gPhsU9as+G
         h0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770273613; x=1770878413;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jxUlt9iOzTlAUVTV6PVTek3fJpMPieKvkeAmkn/pVCM=;
        b=GHiD6aO3d1p9WIfAy8MoNbaQp8rdtHuIAuCunietqKSax5/Q8wPbfWhCIiK1lPXxCm
         JYtgL/RkVEkBp1/g0bBWza99n66+ykcxCavFlfYPPNFo+j9/vwVT2LjVu/+PGV0FKWCC
         gPEtWaCp49MoLryF3h2gUHXDPXdDHt2aU2DtJt7jWjPmvqDVW9thLkl+jvibwRvzhRGS
         1CtzJq1d8KukxIQh2k0GvPoRTj4r8PtkuG517zlVd00xgLDMXtWl7dLfMDhAsGJNRt9T
         eIhITBkSmIGr7OvGuou7LIinJpo1jrqGSJjKD8TuKg5xUbXLGKEvgEUiiR/y+D5DWl+n
         NEUA==
X-Forwarded-Encrypted: i=1; AJvYcCXYUXR62SPHfw9CUl9Vq9oeaFfgHDeWN+qTKh/2Evqh4nYXHcimzTzDUrfIUyX730bqyxAe0fXTEw==@kvack.org
X-Gm-Message-State: AOJu0YyQfDc86wI6zzyxtOoVFgX72eEmi7Af1M1BbMnA8KkXU4SHCk08
	LoL/QeQw534MT9yhcn7t9a+y7VgWmHfjREKCHMzkLSEbUtCjBqu5yfcm
X-Gm-Gg: AZuq6aLf6QioTeRI1Bq+//zyQDyiFDWZ189EDtujtSiCVUWfJ6KgBZYfjcbHX1FDnFy
	qGv0L/A0PnaOE7ZnM+Th/mTE9S7M4LXv2ukZPXvDasWzyWp92oZ5iT6/AFlHy0/qwcXnnScs1+q
	H2Fb95PDcF0MTnFfwRYpNXtgpbQ7qnsoRibKAupOpEZ9qiE8ziNK9ZMfTNE2WJNoleCRCwe5buF
	GvnRFsj9F6eF/wfLGTVAn/yMrgHRg7CxjPsvmplctLJMPJCrt1WNbl8RdA2HHoMUtnXl8Wp0nNy
	AK6wyc6oFZ4NSN7qkRy5ao/uDMO2+TNBF6ZLqWhDJd07B7IJOsIxDQG+hzJIBgfusqVm4++m2D5
	Ek1okBqKwizbtSZ7hYz0pRcUJ7gR/g3Cs7qocSyGEGAfJKqAB8PvDZnbCN+tTcY4ZvyY0zH7vrS
	Li9lsvb41LVqj0zgGT5l/sSVvGHXCklOWTwA==
X-Received: by 2002:a05:7022:623:b0:124:9acd:32d1 with SMTP id a92af1059eb24-126f477ab10mr2613028c88.9.1770273612526;
        Wed, 04 Feb 2026 22:40:12 -0800 (PST)
Received: from [10.36.158.92] ([50.175.227.221])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f504e860sm4141883c88.17.2026.02.04.22.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 22:40:11 -0800 (PST)
Message-ID: <a95971cb-bd90-48de-8b8f-2d6d1f13085a@gmail.com>
Date: Wed, 4 Feb 2026 22:40:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Content-Language: en-GB
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
 <9033fac5-1dd2-49ab-be34-c68bde36ec11@lucifer.local>
 <1638e64e-bc66-4bbe-9fc3-c4c185d86ead@gmail.com>
 <eac3e28c-974d-4bd5-a8f5-ec703295f624@lucifer.local>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <eac3e28c-974d-4bd5-a8f5-ec703295f624@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5448D140004
X-Stat-Signature: yzbhoh3hkejz8e6hb4xy68q1jyoq78tk
X-HE-Tag: 1770273614-794775
X-HE-Meta: U2FsdGVkX19Umt5Dl/G4F5Bs+v8sqs4uIPJaQumh6Z1hZ/k40FgEUdzsTUHvRsZG+d4SKnWmJwkrkx7LW2Y/8b1hpdA7VKfKR/E1kfyANzKN+D42Tv8VS/344EzVR/hR7GhI3wxTNk6mivLG5CueUlDZEvOWJJxiIb3wmz8lLnO22jKc6fkNA5RDUrTatA3U8uon3lKzdNQChrmsuMMN42X0uiyBXJeub18gWqEwVa7VoU6jBa1Mp3UNXpzOfccPHXeO/qxWYCdSQfAnbcQN4mqwK5+LUW2QbnD0D0RsaVUeu55mqk5u69H57kJ4fX/87n6Lnz564/hPo/whgLwGViDQ1CXsALUNGyGHtOyFe5739bBiDCINL7SYmUdh4BCe0WEQJtB3jA/LRU2ZXco+6XUpu0UPaVM26n00WCGzEzKhQYyDHfFOjdjv1kkWbzooz/9lS8onQY3VseDH0irtm9kQE7nBW0KY2IIjlpYfIyGdLDeXH2IAEV7rMekOqV+v9+GAd7gCJ3aA78bAfRrREtdg4/KAd423Y/8O/kRO0D1r6LPo1V0Qzinn5kab+VltIhd13jo4D7+LnOEeYBNixtIdtOvBHRAmDalKpiRJ0izdVhwsIHG7+n1B80pdMrtN/E1kj2mHvwP9g2vMWRqb8QeTU2YtaA8Sg06/iKLPDQL9/ddy+3bgprpGH5wR9ru2TcsIZNKBpHvP5+1RY1fUlrfcXiY8m2EAq7Q2reM1enNxTzU+8anlwspTPiPFPtl56LBUjI0X/aUGLktPzSyyMyjw7xo3kc9xJiimr+ht7HPhBytSNd8zU7+AVW0Z2MenBxL6gMhqS4Z+TqjOfso1vaAggoY82ZhPoOEMVSWGaUZ5fqEsh1QYuiSWtN+8jT46Q7DXJSN0HSJJ/XiZJNBy1kgbJv4QSta1PXyPFK9sXB0J9CjQ7iJ5Dc+uqlMA+9H/xHQYWZImdkf2BWfAvGI
 Ieu+1C6W
 JI0aE1q0ZT8LDzeqnWODv0m1XLJQPcD0plJ3hII72pwwnxsT1cTh2AMO65Kbk5PJFlsvSM6Pe+6hHLeqEacocA/dYvcf1hmBR/fwPQnIPjXEOa2gbWtc7vBV1T3lVWehYg73vUDYuas5G9LRtj0Ed4fLNrD9y8nHot1/8Tc2wD32FLcpk9HXLtX63qcj+7fxjjcKsJ5p2rrgUHeIFQqaWblWoByvLnldVY8Sv9YN6Foa8cis9NE49QLVvnkLquHufVfbc8R4jMzMafGq+oOqMgCsDtUIxN/tS672/QIJtUyMMDf0uVQaRQ2foLxinwLLUpKIUR4biXSqRrYAZcalolUar+dR/4qQ1UNlBsNmkzZy25SCZ6i8qtdm9I/sPAvYuA1qFiLpefPOmGQjNSiV3xOQlsuIEUxH0Y5QAEFBp937IXOFlICaxMQfIEysfj9qWBt37Bqgreupt8A/rAhXHvYs51B8t2Egnbz1dgnSnfnhjogKZD5KXkxssGDm7jf4n1uhWa91Kb2AupD7YHAfyXEKRXLE1tkWekBq7j+eeumP7LlBfKvzV/cVvgTWDIRldUdCjQzHkl+Q1CJ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/02/2026 04:55, Lorenzo Stoakes wrote:
> On Tue, Feb 03, 2026 at 11:38:02PM -0800, Usama Arif wrote:
>>
>>
>> On 02/02/2026 04:15, Lorenzo Stoakes wrote:
>>> I think I'm going to have to do several passes on this, so this is just a
>>> first one :)
>>>
>>
>> Thanks! Really appreciate the reviews!
> 
> No worries!
> 
>>
>> One thing over here is the higher level design decision when it comes to migration
>> of 1G pages. As Zi said in [1]:
>> "I also wonder what the purpose of PUD THP migration can be.
>> It does not create memory fragmentation, since it is the largest folio size
>> we have and contiguous. NUMA balancing 1GB THP seems too much work."
>>
>>> On Sun, Feb 01, 2026 at 04:50:18PM -0800, Usama Arif wrote:
>>>> For page table management, PUD THPs need to pre-deposit page tables
>>>> that will be used when the huge page is later split. When a PUD THP
>>>> is allocated, we cannot know in advance when or why it might need to
>>>> be split (COW, partial unmap, reclaim), but we need page tables ready
>>>> for that eventuality. Similar to how PMD THPs deposit a single PTE
>>>> table, PUD THPs deposit a PMD table which itself contains deposited
>>>> PTE tables - a two-level deposit. This commit adds the deposit/withdraw
>>>> infrastructure and a new pud_huge_pmd field in ptdesc to store the
>>>> deposited PMD.
>>>
>>> This feels like you're hacking this support in, honestly. The list_head
>>> abuse only adds to that feeling.
>>>
>>
>> Yeah so I hope turning it to something like [2] is the way forward.
> 
> Right, that's one option, though David suggested avoiding this altogether by
> only pre-allocating PTEs?

Maybe I dont understand it properly, but that wont work, right?

You need 1 PMD table and 512 PTE tables for a PMD. Cant just have PTE tables, right?


> 
>>
>>> And are we now not required to store rather a lot of memory to keep all of
>>> this coherent?
>>
>> PMD THP allocates 1 4K page (pte_alloc_one) at fault time so that split
>> doesnt fail.
>>
>> For PUD we allocate 2M worth of PTE page tables and 1 4K PMD table at fault
>> time so that split doesnt fail due to there not being enough memory.
>> Its not great, but its not bad as well.
>> The alternative is to allocate this at split time and so we are not
>> pre-reserving them. Now there is a chance that allocation and therefore split
>> fails, so the tradeoff is some memory vs reliability. This patch favours
>> reliability.
> 
> That's a significant amount of unmovable, unreclaimable memory though. Going
> from 4K to 2M is a pretty huge uptick.
> 

Yeah I dont like it either, but its the only way to make sure split doesnt fail.
I think there will always be a tradeoff between reliability and memory.

>>
>> Lets say a user gets 100x1G THPs. They would end up using ~200M for it.
>> I think that is okish. If the user has 100G, 200M might not be an issue
>> for them :)
> 
> But there's more than one user on boxes big enough for this, so this makes me
> think we want this to be somehow opt-in right?
>

Do you mean madvise?

Also an idea (although probably a very bad one :)) is to have MADV_HUGEPAGE_1G.

> And that means we're incurring an unmovable memory penalty, the kind which we're
> trying to avoid in general elsewhere in the kernel.
> 

ack.

>>
>>>
>>>>
>>>> The deposited PMD tables are stored as a singly-linked stack using only
>>>> page->lru.next as the link pointer. A doubly-linked list using the
>>>> standard list_head mechanism would cause memory corruption: list_del()
>>>> poisons both lru.next (offset 8) and lru.prev (offset 16), but lru.prev
>>>> overlaps with ptdesc->pmd_huge_pte at offset 16. Since deposited PMD
>>>> tables have their own deposited PTE tables stored in pmd_huge_pte,
>>>> poisoning lru.prev would corrupt the PTE table list and cause crashes
>>>> when withdrawing PTE tables during split. PMD THPs don't have this
>>>> problem because their deposited PTE tables don't have sub-deposits.
>>>> Using only lru.next avoids the overlap entirely.
>>>
>>> Yeah this is horrendous and a hack, I don't consider this at all
>>> upstreamable.
>>>
>>> You need to completely rework this.
>>
>> Hopefully [2] is the path forward!
> 
> Ack
> 
>>>
>>>>
>>>> For reverse mapping, PUD THPs need the same rmap support that PMD THPs
>>>> have. The page_vma_mapped_walk() function is extended to recognize and
>>>> handle PUD-mapped folios during rmap traversal. A new TTU_SPLIT_HUGE_PUD
>>>> flag tells the unmap path to split PUD THPs before proceeding, since
>>>> there is no PUD-level migration entry format - the split converts the
>>>> single PUD mapping into individual PTE mappings that can be migrated
>>>> or swapped normally.
>>>
>>> Individual PTE... mappings? You need to be a lot clearer here, page tables
>>> are naturally confusing with entries vs. tables.
>>>
>>> Let's be VERY specific here. Do you mean you have 1 PMD table and 512 PTE
>>> tables reserved, spanning 1 PUD entry and 262,144 PTE entries?
>>>
>>
>> Yes that is correct, Thanks! I will change the commit message in the next revision
>> to what you have written: 1 PMD table and 512 PTE tables reserved, spanning
>> 1 PUD entry and 262,144 PTE entries.
> 
> Yeah :) my concerns remain :)
> 
>>
>>>>
>>>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>>>
>>> How does this change interact with existing DAX/VFIO code, which now it
>>> seems will be subject to the mechanisms you introduce here?
>>
>> I think what you mean here is the change in try_to_migrate_one?
>>
>>
>> So one
> 
> Unfinished sentence? :P
> 
> No I mean currently we support 1G THP for DAX/VFIO right? So how does this
> interplay with how that currently works? Does that change how DAX/VFIO works?
> Will that impact existing users?
> 
> Or are we extending the existing mechanism?
> 

A lot of the stuff like copy_huge_pud, zap_huge_pud, __split_huge_pud_locked,
create_huge_pud, wp_huge_pud... is protected by vma_is_anonymous check. I will
try and do a better audit of DAX and VFIO.

>>
>>>
>>> Right now DAX/VFIO is only obtainable via a specially THP-aligned
>>> get_unmapped_area() + then can only be obtained at fault time.
>>>> Is that the intent here also?
>>>
>>
>> Ah thanks for pointing this out. This is something the series is missing.
>>
>> What I did in the selftest and benchmark was fault on an address that was already aligned.
>> i.e. basically call the below function before faulting in.
>>
>> static inline void *pud_align(void *addr)
>> {
>> 	return (void *)(((unsigned long)addr + PUD_SIZE - 1) & ~(PUD_SIZE - 1));
>> }
> 
> Right yeah :)
> 
>>
>>
>> What I think you are suggesting this series is missing is the below diff? (its untested).
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 87b2c21df4a49..461158a0840db 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1236,6 +1236,12 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>>         unsigned long ret;
>>         loff_t off = (loff_t)pgoff << PAGE_SHIFT;
>>
>> +       if (IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) && len >= PUD_SIZE) {
>> +               ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PUD_SIZE, vm_flags);
>> +               if (ret)
>> +                       return ret;
>> +       }
> 
> No not that, that's going to cause issues, see commit d4148aeab4 for details as
> to why this can go wrong.
> 
> In __get_unmapped_area() where the current 'if PMD size aligned then align area'
> logic, like that.


Ack, Thanks for pointing to this. I will also add another selftest to see that we actually
get this from _get_unmapped_area when we dont do the pud_align trick I currently have in
the selftests.

> 
>> +
>>
>>
>>> What is your intent - that khugepaged do this, or on alloc? How does it
>>> interact with MADV_COLLAPSE?
>>>
>>
>> Ah basically what I mentioned in [3], we want to go slow. Only enable PUD THPs
>> page faults at the start. If there is data supporting that khugepaged will work
>> than we do it, but we keep it disabled.
> 
> Yes I think khugepaged is probably never going to be all that a good idea with
> this.
> 
>>
>>> I noted on the 2nd patch, but you're changing THP_ORDERS_ALL_ANON which
>>> alters __thp_vma_allowable_orders() behaviour, that change belongs here...
>>>
>>>
>>
>> Thanks for this! I only tried to split this code into logical commits
>> after the whole thing was working. Some things are tightly coupled
>> and I would need to move them to the right commit.
> 
> Yes there's a bunch of things that need tweaking here, to reiterate let's try to
> pay down technical debt here and avoid copy/pasting :>)

Yes, will spend a lot more time thinking about how to avoid copy/paste.


> 
>>
>>>> ---
>>>>  include/linux/huge_mm.h  |  5 +++
>>>>  include/linux/mm.h       | 19 ++++++++
>>>>  include/linux/mm_types.h |  5 ++-
>>>>  include/linux/pgtable.h  |  8 ++++
>>>>  include/linux/rmap.h     |  7 ++-
>>>>  mm/huge_memory.c         |  8 ++++
>>>>  mm/internal.h            |  3 ++
>>>>  mm/page_vma_mapped.c     | 35 +++++++++++++++
>>>>  mm/pgtable-generic.c     | 83 ++++++++++++++++++++++++++++++++++
>>>>  mm/rmap.c                | 96 +++++++++++++++++++++++++++++++++++++---
>>>>  10 files changed, 260 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>> index a4d9f964dfdea..e672e45bb9cc7 100644
>>>> --- a/include/linux/huge_mm.h
>>>> +++ b/include/linux/huge_mm.h
>>>> @@ -463,10 +463,15 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>>>>  		unsigned long address);
>>>>
>>>>  #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>> +void split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
>>>> +			   unsigned long address);
>>>>  int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>>  		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
>>>>  		    unsigned long cp_flags);
>>>>  #else
>>>> +static inline void
>>>> +split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
>>>> +		      unsigned long address) {}
>>>>  static inline int
>>>>  change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>>>  		pud_t *pudp, unsigned long addr, pgprot_t newprot,
>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>> index ab2e7e30aef96..a15e18df0f771 100644
>>>> --- a/include/linux/mm.h
>>>> +++ b/include/linux/mm.h
>>>> @@ -3455,6 +3455,22 @@ static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
>>>>   * considered ready to switch to split PUD locks yet; there may be places
>>>>   * which need to be converted from page_table_lock.
>>>>   */
>>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>> +static inline struct page *pud_pgtable_page(pud_t *pud)
>>>> +{
>>>> +	unsigned long mask = ~(PTRS_PER_PUD * sizeof(pud_t) - 1);
>>>> +
>>>> +	return virt_to_page((void *)((unsigned long)pud & mask));
>>>> +}
>>>> +
>>>> +static inline struct ptdesc *pud_ptdesc(pud_t *pud)
>>>> +{
>>>> +	return page_ptdesc(pud_pgtable_page(pud));
>>>> +}
>>>> +
>>>> +#define pud_huge_pmd(pud) (pud_ptdesc(pud)->pud_huge_pmd)
>>>> +#endif
>>>> +
>>>>  static inline spinlock_t *pud_lockptr(struct mm_struct *mm, pud_t *pud)
>>>>  {
>>>>  	return &mm->page_table_lock;
>>>> @@ -3471,6 +3487,9 @@ static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
>>>>  static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
>>>>  {
>>>>  	__pagetable_ctor(ptdesc);
>>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>> +	ptdesc->pud_huge_pmd = NULL;
>>>> +#endif
>>>>  }
>>>>
>>>>  static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
>>>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>>>> index 78950eb8926dc..26a38490ae2e1 100644
>>>> --- a/include/linux/mm_types.h
>>>> +++ b/include/linux/mm_types.h
>>>> @@ -577,7 +577,10 @@ struct ptdesc {
>>>>  		struct list_head pt_list;
>>>>  		struct {
>>>>  			unsigned long _pt_pad_1;
>>>> -			pgtable_t pmd_huge_pte;
>>>> +			union {
>>>> +				pgtable_t pmd_huge_pte;  /* For PMD tables: deposited PTE */
>>>> +				pgtable_t pud_huge_pmd;  /* For PUD tables: deposited PMD list */
>>>> +			};
>>>>  		};
>>>>  	};
>>>>  	unsigned long __page_mapping;
>>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>>> index 2f0dd3a4ace1a..3ce733c1d71a2 100644
>>>> --- a/include/linux/pgtable.h
>>>> +++ b/include/linux/pgtable.h
>>>> @@ -1168,6 +1168,14 @@ extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>>>  #define arch_needs_pgtable_deposit() (false)
>>>>  #endif
>>>>
>>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>> +extern void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
>>>> +					   pmd_t *pmd_table);
>>>> +extern pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp);
>>>> +extern void pud_deposit_pte(pmd_t *pmd_table, pgtable_t pgtable);
>>>> +extern pgtable_t pud_withdraw_pte(pmd_t *pmd_table);
>>>
>>> These are useless extern's.
>>>
>>
>>
>> ack
>>
>> These are coming from the existing functions from the file:
>> extern void pgtable_trans_huge_deposit
>> extern pgtable_t pgtable_trans_huge_withdraw
>>
>> I think the externs can be removed from these as well? We can
>> fix those in a separate patch.
> 
> Generally the approach is to remove externs when adding/changing new stuff as
> otherwise we get completely useless churn on that and annoying git history
> changes.

Ack

>>
>>
>>>> +#endif
>>>> +
>>>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>  /*
>>>>   * This is an implementation of pmdp_establish() that is only suitable for an
>>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>>> index daa92a58585d9..08cd0a0eb8763 100644
>>>> --- a/include/linux/rmap.h
>>>> +++ b/include/linux/rmap.h
>>>> @@ -101,6 +101,7 @@ enum ttu_flags {
>>>>  					 * do a final flush if necessary */
>>>>  	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
>>>>  					 * caller holds it */
>>>> +	TTU_SPLIT_HUGE_PUD	= 0x100, /* split huge PUD if any */
>>>>  };
>>>>
>>>>  #ifdef CONFIG_MMU
>>>> @@ -473,6 +474,8 @@ void folio_add_anon_rmap_ptes(struct folio *, struct page *, int nr_pages,
>>>>  	folio_add_anon_rmap_ptes(folio, page, 1, vma, address, flags)
>>>>  void folio_add_anon_rmap_pmd(struct folio *, struct page *,
>>>>  		struct vm_area_struct *, unsigned long address, rmap_t flags);
>>>> +void folio_add_anon_rmap_pud(struct folio *, struct page *,
>>>> +		struct vm_area_struct *, unsigned long address, rmap_t flags);
>>>>  void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
>>>>  		unsigned long address, rmap_t flags);
>>>>  void folio_add_file_rmap_ptes(struct folio *, struct page *, int nr_pages,
>>>> @@ -933,6 +936,7 @@ struct page_vma_mapped_walk {
>>>>  	pgoff_t pgoff;
>>>>  	struct vm_area_struct *vma;
>>>>  	unsigned long address;
>>>> +	pud_t *pud;
>>>>  	pmd_t *pmd;
>>>>  	pte_t *pte;
>>>>  	spinlock_t *ptl;
>>>> @@ -970,7 +974,7 @@ static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
>>>>  static inline void
>>>>  page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
>>>>  {
>>>> -	WARN_ON_ONCE(!pvmw->pmd && !pvmw->pte);
>>>> +	WARN_ON_ONCE(!pvmw->pud && !pvmw->pmd && !pvmw->pte);
>>>>
>>>>  	if (likely(pvmw->ptl))
>>>>  		spin_unlock(pvmw->ptl);
>>>> @@ -978,6 +982,7 @@ page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
>>>>  		WARN_ON_ONCE(1);
>>>>
>>>>  	pvmw->ptl = NULL;
>>>> +	pvmw->pud = NULL;
>>>>  	pvmw->pmd = NULL;
>>>>  	pvmw->pte = NULL;
>>>>  }
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 40cf59301c21a..3128b3beedb0a 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -2933,6 +2933,14 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>>>>  	spin_unlock(ptl);
>>>>  	mmu_notifier_invalidate_range_end(&range);
>>>>  }
>>>> +
>>>> +void split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
>>>> +			   unsigned long address)
>>>> +{
>>>> +	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PUD_SIZE));
>>>> +	if (pud_trans_huge(*pud))
>>>> +		__split_huge_pud_locked(vma, pud, address);
>>>> +}
>>>>  #else
>>>>  void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>>>>  		unsigned long address)
>>>> diff --git a/mm/internal.h b/mm/internal.h
>>>> index 9ee336aa03656..21d5c00f638dc 100644
>>>> --- a/mm/internal.h
>>>> +++ b/mm/internal.h
>>>> @@ -545,6 +545,9 @@ int user_proactive_reclaim(char *buf,
>>>>   * in mm/rmap.c:
>>>>   */
>>>>  pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
>>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>> +pud_t *mm_find_pud(struct mm_struct *mm, unsigned long address);
>>>> +#endif
>>>>
>>>>  /*
>>>>   * in mm/page_alloc.c
>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>> index b38a1d00c971b..d31eafba38041 100644
>>>> --- a/mm/page_vma_mapped.c
>>>> +++ b/mm/page_vma_mapped.c
>>>> @@ -146,6 +146,18 @@ static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>>>>  	return true;
>>>>  }
>>>>
>>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>> +/* Returns true if the two ranges overlap.  Careful to not overflow. */
>>>> +static bool check_pud(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>>>> +{
>>>> +	if ((pfn + HPAGE_PUD_NR - 1) < pvmw->pfn)
>>>> +		return false;
>>>> +	if (pfn > pvmw->pfn + pvmw->nr_pages - 1)
>>>> +		return false;
>>>> +	return true;
>>>> +}
>>>> +#endif
>>>> +
>>>>  static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
>>>>  {
>>>>  	pvmw->address = (pvmw->address + size) & ~(size - 1);
>>>> @@ -188,6 +200,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>  	pud_t *pud;
>>>>  	pmd_t pmde;
>>>>
>>>> +	/* The only possible pud mapping has been handled on last iteration */
>>>> +	if (pvmw->pud && !pvmw->pmd)
>>>> +		return not_found(pvmw);
>>>> +
>>>>  	/* The only possible pmd mapping has been handled on last iteration */
>>>>  	if (pvmw->pmd && !pvmw->pte)
>>>>  		return not_found(pvmw);
>>>> @@ -234,6 +250,25 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>  			continue;
>>>>  		}
>>>>
>>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>
>>> Said it elsewhere, but it's really weird to treat an arch having the
>>> ability to do something as a go ahead for doing it.
>>>
>>>> +		/* Check for PUD-mapped THP */
>>>> +		if (pud_trans_huge(*pud)) {
>>>> +			pvmw->pud = pud;
>>>> +			pvmw->ptl = pud_lock(mm, pud);
>>>> +			if (likely(pud_trans_huge(*pud))) {
>>>> +				if (pvmw->flags & PVMW_MIGRATION)
>>>> +					return not_found(pvmw);
>>>> +				if (!check_pud(pud_pfn(*pud), pvmw))
>>>> +					return not_found(pvmw);
>>>> +				return true;
>>>> +			}
>>>> +			/* PUD was split under us, retry at PMD level */
>>>> +			spin_unlock(pvmw->ptl);
>>>> +			pvmw->ptl = NULL;
>>>> +			pvmw->pud = NULL;
>>>> +		}
>>>> +#endif
>>>> +
>>>
>>> Yeah, as I said elsewhere, we got to be refactoring not copy/pasting with
>>> modifications :)
>>>
>>
>> Yeah there is repeated code in multiple places, where all I did was replace
>> what was done from PMD into PUD. In a lot of places, its actually difficult
>> to not repeat the code (unless we want function macros, which is much worse
>> IMO).
> 
> Not if we actually refactor the existing code :)
> 
> When I wanted to make functional changes to mremap I took a lot of time to
> refactor the code into something sane before even starting that.
> 
> Because I _could_ have added the features there as-is, but it would have been
> hellish to do so as-is and added more confusion etc.
> 
> So yeah, I think a similar mentality has to be had with this change.

Ack, I will spend a lot more time thinking about the refractoring.
> 
>>
>>>
>>>>  		pvmw->pmd = pmd_offset(pud, pvmw->address);
>>>>  		/*
>>>>  		 * Make sure the pmd value isn't cached in a register by the
>>>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>>>> index d3aec7a9926ad..2047558ddcd79 100644
>>>> --- a/mm/pgtable-generic.c
>>>> +++ b/mm/pgtable-generic.c
>>>> @@ -195,6 +195,89 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
>>>>  }
>>>>  #endif
>>>>
>>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>> +/*
>>>> + * Deposit page tables for PUD THP.
>>>> + * Called with PUD lock held. Stores PMD tables in a singly-linked stack
>>>> + * via pud_huge_pmd, using only pmd_page->lru.next as the link pointer.
>>>> + *
>>>> + * IMPORTANT: We use only lru.next (offset 8) for linking, NOT the full
>>>> + * list_head. This is because lru.prev (offset 16) overlaps with
>>>> + * ptdesc->pmd_huge_pte, which stores the PMD table's deposited PTE tables.
>>>> + * Using list_del() would corrupt pmd_huge_pte with LIST_POISON2.
>>>
>>> This is horrible and feels like a hack? Treating a doubly-linked list as a
>>> singly-linked one like this is not upstreamable.
>>>
>>>> + *
>>>> + * PTE tables should be deposited into the PMD using pud_deposit_pte().
>>>> + */
>>>> +void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
>>>> +				    pmd_t *pmd_table)
>>>
>>> This is a horrid, you're depositing the PMD using the... questionable
>>> list_head abuse, but then also have pud_deposit_pte()... But here we're
>>> depositing a PMD shouldn't the name reflect that?
>>>
>>>> +{
>>>> +	pgtable_t pmd_page = virt_to_page(pmd_table);
>>>> +
>>>> +	assert_spin_locked(pud_lockptr(mm, pudp));
>>>> +
>>>> +	/* Push onto stack using only lru.next as the link */
>>>> +	pmd_page->lru.next = (struct list_head *)pud_huge_pmd(pudp);
>>>
>>> Yikes...
>>>
>>>> +	pud_huge_pmd(pudp) = pmd_page;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Withdraw the deposited PMD table for PUD THP split or zap.
>>>> + * Called with PUD lock held.
>>>> + * Returns NULL if no more PMD tables are deposited.
>>>> + */
>>>> +pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp)
>>>> +{
>>>> +	pgtable_t pmd_page;
>>>> +
>>>> +	assert_spin_locked(pud_lockptr(mm, pudp));
>>>> +
>>>> +	pmd_page = pud_huge_pmd(pudp);
>>>> +	if (!pmd_page)
>>>> +		return NULL;
>>>> +
>>>> +	/* Pop from stack - lru.next points to next PMD page (or NULL) */
>>>> +	pud_huge_pmd(pudp) = (pgtable_t)pmd_page->lru.next;
>>>
>>> Where's the popping? You're just assigning here.
>>
>>
>> Ack on all of the above. Hopefully [1] is better.
> 
> Thanks!
> 
>>>
>>>> +
>>>> +	return page_address(pmd_page);
>>>> +}
>>>> +
>>>> +/*
>>>> + * Deposit a PTE table into a standalone PMD table (not yet in page table hierarchy).
>>>> + * Used for PUD THP pre-deposit. The PMD table's pmd_huge_pte stores a linked list.
>>>> + * No lock assertion since the PMD isn't visible yet.
>>>> + */
>>>> +void pud_deposit_pte(pmd_t *pmd_table, pgtable_t pgtable)
>>>> +{
>>>> +	struct ptdesc *ptdesc = virt_to_ptdesc(pmd_table);
>>>> +
>>>> +	/* FIFO - add to front of list */
>>>> +	if (!ptdesc->pmd_huge_pte)
>>>> +		INIT_LIST_HEAD(&pgtable->lru);
>>>> +	else
>>>> +		list_add(&pgtable->lru, &ptdesc->pmd_huge_pte->lru);
>>>> +	ptdesc->pmd_huge_pte = pgtable;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Withdraw a PTE table from a standalone PMD table.
>>>> + * Returns NULL if no more PTE tables are deposited.
>>>> + */
>>>> +pgtable_t pud_withdraw_pte(pmd_t *pmd_table)
>>>> +{
>>>> +	struct ptdesc *ptdesc = virt_to_ptdesc(pmd_table);
>>>> +	pgtable_t pgtable;
>>>> +
>>>> +	pgtable = ptdesc->pmd_huge_pte;
>>>> +	if (!pgtable)
>>>> +		return NULL;
>>>> +	ptdesc->pmd_huge_pte = list_first_entry_or_null(&pgtable->lru,
>>>> +							struct page, lru);
>>>> +	if (ptdesc->pmd_huge_pte)
>>>> +		list_del(&pgtable->lru);
>>>> +	return pgtable;
>>>> +}
>>>> +#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>>>> +
>>>>  #ifndef __HAVE_ARCH_PMDP_INVALIDATE
>>>>  pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
>>>>  		     pmd_t *pmdp)
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 7b9879ef442d9..69acabd763da4 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -811,6 +811,32 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
>>>>  	return pmd;
>>>>  }
>>>>
>>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>> +/*
>>>> + * Returns the actual pud_t* where we expect 'address' to be mapped from, or
>>>> + * NULL if it doesn't exist.  No guarantees / checks on what the pud_t*
>>>> + * represents.
>>>> + */
>>>> +pud_t *mm_find_pud(struct mm_struct *mm, unsigned long address)
>>>
>>> This series seems to be full of copy/paste.
>>>
>>> It's just not acceptable given the state of THP code as I said in reply to
>>> the cover letter - you need to _refactor_ the code.
>>>
>>> The code is bug-prone and difficult to maintain as-is, your series has to
>>> improve the technical debt, not add to it.
>>>
>>
>> In some cases we might not be able to avoid the copy, but this is definitely
>> a place where we dont need to. I will change here. Thanks!
> 
> I disagree, see above :) But thanks on this one
> 
>>
>>>> +{
>>>> +	pgd_t *pgd;
>>>> +	p4d_t *p4d;
>>>> +	pud_t *pud = NULL;
>>>> +
>>>> +	pgd = pgd_offset(mm, address);
>>>> +	if (!pgd_present(*pgd))
>>>> +		goto out;
>>>> +
>>>> +	p4d = p4d_offset(pgd, address);
>>>> +	if (!p4d_present(*p4d))
>>>> +		goto out;
>>>> +
>>>> +	pud = pud_offset(p4d, address);
>>>> +out:
>>>> +	return pud;
>>>> +}
>>>> +#endif
>>>> +
>>>>  struct folio_referenced_arg {
>>>>  	int mapcount;
>>>>  	int referenced;
>>>> @@ -1415,11 +1441,7 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
>>>>  			SetPageAnonExclusive(page);
>>>>  			break;
>>>>  		case PGTABLE_LEVEL_PUD:
>>>> -			/*
>>>> -			 * Keep the compiler happy, we don't support anonymous
>>>> -			 * PUD mappings.
>>>> -			 */
>>>> -			WARN_ON_ONCE(1);
>>>> +			SetPageAnonExclusive(page);
>>>>  			break;
>>>>  		default:
>>>>  			BUILD_BUG();
>>>> @@ -1503,6 +1525,31 @@ void folio_add_anon_rmap_pmd(struct folio *folio, struct page *page,
>>>>  #endif
>>>>  }
>>>>
>>>> +/**
>>>> + * folio_add_anon_rmap_pud - add a PUD mapping to a page range of an anon folio
>>>> + * @folio:	The folio to add the mapping to
>>>> + * @page:	The first page to add
>>>> + * @vma:	The vm area in which the mapping is added
>>>> + * @address:	The user virtual address of the first page to map
>>>> + * @flags:	The rmap flags
>>>> + *
>>>> + * The page range of folio is defined by [first_page, first_page + HPAGE_PUD_NR)
>>>> + *
>>>> + * The caller needs to hold the page table lock, and the page must be locked in
>>>> + * the anon_vma case: to serialize mapping,index checking after setting.
>>>> + */
>>>> +void folio_add_anon_rmap_pud(struct folio *folio, struct page *page,
>>>> +		struct vm_area_struct *vma, unsigned long address, rmap_t flags)
>>>> +{
>>>> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
>>>> +	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
>>>> +	__folio_add_anon_rmap(folio, page, HPAGE_PUD_NR, vma, address, flags,
>>>> +			      PGTABLE_LEVEL_PUD);
>>>> +#else
>>>> +	WARN_ON_ONCE(true);
>>>> +#endif
>>>> +}
>>>
>>> More copy/paste... Maybe unavoidable in this case, but be good to try.
>>>
>>>> +
>>>>  /**
>>>>   * folio_add_new_anon_rmap - Add mapping to a new anonymous folio.
>>>>   * @folio:	The folio to add the mapping to.
>>>> @@ -1934,6 +1981,20 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>>  		}
>>>>
>>>>  		if (!pvmw.pte) {
>>>> +			/*
>>>> +			 * Check for PUD-mapped THP first.
>>>> +			 * If we have a PUD mapping and TTU_SPLIT_HUGE_PUD is set,
>>>> +			 * split the PUD to PMD level and restart the walk.
>>>> +			 */
>>>
>>> This is literally describing the code below, it's not useful.
>>
>> Ack, Will remove this comment, Thanks!
> 
> Thanks
> 
>>>
>>>> +			if (pvmw.pud && pud_trans_huge(*pvmw.pud)) {
>>>> +				if (flags & TTU_SPLIT_HUGE_PUD) {
>>>> +					split_huge_pud_locked(vma, pvmw.pud, pvmw.address);
>>>> +					flags &= ~TTU_SPLIT_HUGE_PUD;
>>>> +					page_vma_mapped_walk_restart(&pvmw);
>>>> +					continue;
>>>> +				}
>>>> +			}
>>>> +
>>>>  			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
>>>>  				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
>>>>  					goto walk_done;
>>>> @@ -2325,6 +2386,27 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>  	mmu_notifier_invalidate_range_start(&range);
>>>>
>>>>  	while (page_vma_mapped_walk(&pvmw)) {
>>>> +		/* Handle PUD-mapped THP first */
>>>
>>> How did/will this interact with DAX, VFIO PUD THP?
>>
>> It wont interact with DAX. try_to_migrate does the below and just returns:
>>
>> 	if (folio_is_zone_device(folio) &&
>> 	    (!folio_is_device_private(folio) && !folio_is_device_coherent(folio)))
>> 		return;
>>
>> so DAX would never reach here.
> 
> Hmm folio_is_zone_device() always returns true for DAX?
> 

Yes, that is my understanding. Both fsdax and devdax call into
devm_memremap_pages() -> memremap_pages() in mm/memremap.c, which
unconditionally places all pages in ZONE_DEVICE.

> Also that's just one rmap call right?
> 
Yes,

>>
>> I think vfio pages are pinned and therefore cant be migrated? (I have
>> not looked at vfio code, I will try to get a better understanding tomorrow,
>> but please let me know if that sounds wrong.)
> 
> OK I've not dug into this either please do check, and be good really to test
> this code vs. actual DAX/VFIO scenarios if you can find a way to test that, thanks!

I think DAX is ok, will check more into VFIO. I will also CC the people who added
DAX and VFIO PUD support in the next RFC.

> 
>>
>>
>>>
>>>> +		if (!pvmw.pte && !pvmw.pmd) {
>>>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>
>>> Won't pud_trans_huge() imply this...
>>>
>>
>> Agreed, I think it should cover it.
> Thanks!
> 
>>
>>>> +			/*
>>>> +			 * PUD-mapped THP: skip migration to preserve the huge
>>>> +			 * page. Splitting would defeat the purpose of PUD THPs.
>>>> +			 * Return false to indicate migration failure, which
>>>> +			 * will cause alloc_contig_range() to try a different
>>>> +			 * memory region.
>>>> +			 */
>>>> +			if (pvmw.pud && pud_trans_huge(*pvmw.pud)) {
>>>> +				page_vma_mapped_walk_done(&pvmw);
>>>> +				ret = false;
>>>> +				break;
>>>> +			}
>>>> +#endif
>>>> +			/* Unexpected state: !pte && !pmd but not a PUD THP */
>>>> +			page_vma_mapped_walk_done(&pvmw);
>>>> +			break;
>>>> +		}
>>>> +
>>>>  		/* PMD-mapped THP migration entry */
>>>>  		if (!pvmw.pte) {
>>>>  			__maybe_unused unsigned long pfn;
>>>> @@ -2607,10 +2689,10 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
>>>>
>>>>  	/*
>>>>  	 * Migration always ignores mlock and only supports TTU_RMAP_LOCKED and
>>>> -	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
>>>> +	 * TTU_SPLIT_HUGE_PMD, TTU_SPLIT_HUGE_PUD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
>>>>  	 */
>>>>  	if (WARN_ON_ONCE(flags & ~(TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
>>>> -					TTU_SYNC | TTU_BATCH_FLUSH)))
>>>> +					TTU_SPLIT_HUGE_PUD | TTU_SYNC | TTU_BATCH_FLUSH)))
>>>>  		return;
>>>>
>>>>  	if (folio_is_zone_device(folio) &&
>>>> --
>>>> 2.47.3
>>>>
>>>
>>> This isn't a final review, I'll have to look more thoroughly through here
>>> over time and you're going to have to be patient in general :)
>>>
>>> Cheers, Lorenzo
>>
>>
>> Thanks for the review, this is awesome!
> 
> Ack, will do more when I have time, and obviously you're getting a lot of input
> from others too.
> 
> Be good to get a summary at next THP cabal ;)
> 
>>
>>
>> [1] https://lore.kernel.org/all/20f92576-e932-435f-bb7b-de49eb84b012@gmail.com/
>> [2] https://lore.kernel.org/all/05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com/
>> [3] https://lore.kernel.org/all/2efaa5ed-bd09-41f0-9c07-5cd6cccc4595@gmail.com/
>>
>>
>>
> 
> cheers, Lorenzo


