Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78A75C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79EFF6B00C8; Tue, 14 Jul 2026 10:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728286B00CC; Tue, 14 Jul 2026 10:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EFB46B00E5; Tue, 14 Jul 2026 10:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E93F6B00C8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:42:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAC49A03BD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:42:14 +0000 (UTC)
X-FDA: 84987647388.16.392519C
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf18.hostedemail.com (Postfix) with ESMTP id 475D91C000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:42:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Jaj36pVa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784040132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpMZBGnVH1LoGqPVWbO7ZJz4oedLo0cUw3XKjxOqUAk=;
	b=Kc9XInVKPA/L3BnHUpqz7P7irrNpu0OivbLeilLH1yCk7Kbf+TGaxw9lWzegE7NbI4zJ63
	B8aYXJ12Kg+n9hVSUP72Gd/XwhY5Hh0IKq52sxPhTWkzVq6Y20jdHXjaQ/+ockP5Kwsp/Y
	lXfmRCSK05yWjlkqcR8kwCgpOPbIAt0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Jaj36pVa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784040132;
	b=DP+RVXfmhLdqM7vQ5rUsgFkJaDYF3P1aT1/hlPzb5T58jqcnH8FHRI/LZ5R6OlyjctsXAY
	q0Gc901CZpogmYit5dj15gvtSZijx+Q3eq9ySpE/8ySNa3HNh4DiOi9Vu71MozD/X0oHbP
	BvsbeTecY6hovHQwQ2stNVgRh+8ZA4s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LpMZBGnVH1LoGqPVWbO7ZJz4oedLo0cUw3XKjxOqUAk=;
	b=Jaj36pVagf4W7f+AcihSwUnlPVxwTr6mrn6CRJPvbQPNACRX3PAOMQ1Q02SdheN6cUI3wOvk6
	sc6t9V5xaxCM9+DO6Pg9fLlnAMU35qahCJQDVXns8bLcAU62TK9EOrrHD2HCwES4zUzeVVZdDM6
	xkAYyz8KcoKb2mO2NlK8tIU=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4h01wq29QSz12LCc;
	Tue, 14 Jul 2026 22:32:27 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 8671740561;
	Tue, 14 Jul 2026 22:42:05 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Jul 2026 22:42:04 +0800
Message-ID: <ac0fd6d3-b429-44f8-922b-cfdba2d0154f@huawei.com>
Date: Tue, 14 Jul 2026 22:42:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: mincore: remove special handling for VM_PFNMAP
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, "Liam R . Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
 <20260710120052.103886-2-wangkefeng.wang@huawei.com>
 <1bd96ae4-f59d-4103-a700-f9478e88c05b@kernel.org>
 <8b94da35-a9f1-4729-bd1c-151da2f333ce@huawei.com>
 <d4afd345-d18b-42e8-a6ca-d7018350420a@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <d4afd345-d18b-42e8-a6ca-d7018350420a@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 475D91C000E
X-Stat-Signature: est1on4447urt8m3d8g7pteg68dbqm4c
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784040131-423443
X-HE-Meta: U2FsdGVkX1+PSow+dlvjpYR5FVq7+aWaHcm38osrVXOp4M9xQdnYS51QOlEvV44NpDwsNpckjcPHeZOqQ7yQ6l4e8xeUum89cAwpdUaJDzjQN6TdfgUrgzy9o9wSKNSROEv055G/XSICOAod9Ty6e/NUVdnc8OW6bX/urk5BX8oKh2IhtgynY6P1SFzKvQNSc5RusO0yglWfSXJlntYuMrh/IEE1h6B+Ok+obtJ7eql6AyRf0mZl4CJdXZvAL3/EQws5hs1SUoj53hKxEgGqlHPu9XcF3K9KKOPPyE2ykk2NthFeqOoafeI/5gDpHqdgd4ZzZll5s2osK92EW6Byu+bfKiZF808mRmAjxdHYiYgOawQeG1y0Ag2t4b7rF8JZjaQEbvxgs2ky1W9A2VqY3zyBASpKaXgmXYb1VY9nbiIgMmEqin8iuK8bCMEDuz6W1puG1LopoPKxo6bRM40vtlmuwC3byWoKJzKVoBfQLzU5NNgi9T+G4KeYztX6CyUDGT/JA9Rq+wAEFPUgpakP8raHSwqkM34eqAbpazv5g53qeho1sjBK6G1yDhO7ncHwT4HqkwafvN40f+oTvNJ3SfUAY1NiWbiec3rZPCJwvPQl8mIrvF/DSM7I3xPCkt1vy7AKJSw5jLYEDz5hsKkaNZO+glaUxtNZJt4MyGM/zu7UtN+fi9swocr7ja0JoTfXlIhQDNKIXb/3KfSb1RKJWk23sEmuKWJxDlJyF0thUd8gvoCJth3qMRFbNL/bs5ETrLqCdtqmDSSZE7xjU/9HQZFP/wsWmKTQDEyCGvpapun6hfJS9N3cVkmX9Z6JMv7CUjKbdgKoNnDDR/Ke3ytFtaZDaXY9Sqxu7cO3eg8yUl8FGaXxtPmKudIDmIkehioKTC8c3TiougXbKq1xFJAV4KPVGJ5C2bv6Fd2wTyd0RsVzzmo45kIJ+ltTuGL/oVEW3Va3/oFHddo4CikKUZU
 INz5ji/d
 h5YRzxQOsRnu+GYIdEUyYAd1XzlP1n7O12KTVkL6Z2HDM/0dKsK6KvZwYj/MatSJdwxM4FVSYbAfmS4bPO5AioWPaE37uJJYorzzQWn8wcBfFWjX/IWN/zlcZ6+B2nn8GgIfMz2Tij3Dv+9bhFVYx5S07Griej7WoHx4AIMzRL6tz3mF6s/o8oItZlXg+MvCMwXmVsorAgpOnARGnbe+vEdtdaPE0fXVbwP3dfwdD2ryY7zrftf1iairEoIp554GdKcvGDL5fiz1zvAkV/MuSREZiU4c+7edYX/uC7VIYB6qJHuoJcwXdaLhBcQc4H/+xClvvmQxplGHinnZ4VrfI0mVF0U8Uy2vlQXC57N1uhXWGZETfKxq59acmpoNL7G25Xt7Ku4v31j6BVR08peRSChw/lT+qF4XL+cC7MaPtoj0YlzsNldIJLm/+jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/14/2026 8:55 PM, David Hildenbrand (Arm) wrote:
> On 7/14/26 04:47, Kefeng Wang wrote:
>>
>>
>> On 7/10/2026 8:07 PM, David Hildenbrand (Arm) wrote:
>>> On 7/10/26 14:00, Kefeng Wang wrote:
>>>> As David pointed out, "it’s hard to believe that someone depends
>>>> on pages in VM_PFNMAP to *not* be present", so remove the historical
>>>> behavior that always reports VM_PFNMAP pages as non-resident.
>>>> Instead, make them now reported as resident by checking the
>>>> VMA_PFNMAP_BIT, simplifying the code.
>>>>
>>>> Link: https://lore.kernel.org/linux-
>>>> mm/0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org/
>>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>> ---
>>>>    mm/mincore.c | 10 +---------
>>>>    1 file changed, 1 insertion(+), 9 deletions(-)
>>>>
>>>> diff --git a/mm/mincore.c b/mm/mincore.c
>>>> index 53b982803771..0eb832ee0a30 100644
>>>> --- a/mm/mincore.c
>>>> +++ b/mm/mincore.c
>>>> @@ -219,7 +219,7 @@ static inline bool can_do_mincore(struct vm_area_struct
>>>> *vma)
>>>>    {
>>>>        if (vma_is_anonymous(vma))
>>>>            return true;
>>>> -    if (!vma->vm_file)
>>>> +    if (!vma->vm_file || vma_test(vma, VMA_PFNMAP_BIT))
>>>>            return false;
>>>>        /*
>>>>         * Reveal pagecache information only for non-anonymous mappings that
>>>> @@ -259,14 +259,6 @@ static long do_mincore(unsigned long addr, unsigned long
>>>> pages, unsigned char *v
>>>>            return pages;
>>>>        }
>>>>    -    /*
>>>> -     * mincore historically reports PFNMAP mappings as non-resident.
>>>> -     */
>>>> -    if (vma->vm_flags & VM_PFNMAP) {
>>>> -        __mincore_unmapped_range(addr, end, vma, vec);
>>>> -        return (end - addr) >> PAGE_SHIFT;
>>>> -    }
>>>> -
>>>>        err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
>>>>        if (err < 0)
>>>>            return err;
>>>
>>>
>>> What about MAP_PRIVATE PFN mappings with anonymous pages in there that could
>>> have migration entries?
>>>
>>> I'd assume that we'd want to scan the thing and simply mark present ptes as ...
>>> present.
>>>
>>
>> Sorry for the late, thanks for your review, the current modification is
>> not very reasonable. After reconsidering the original Sahiko report, if
>> we want to remove the special handling of the PFNMAP and not split the
>> PUD page, we can add pud_entry processing and skip the PUD huge page,
>> and mark pud as resident, the change is as follows,
> 
> Yes, that sounds correct.
> 
>>
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index 53b982803771..dc976713ee5b 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -160,6 +160,25 @@ static int mincore_unmapped_range(unsigned long addr,
>> unsigned long end,
>>          return 0;
>>   }
>>
>> +static int mincore_pud_range(pud_t *pud, unsigned long addr, unsigned long end,
>> +                       struct mm_walk *walk)
>> +{
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> +       int nr = (end - addr) >> PAGE_SHIFT;
>> +       unsigned char *vec = walk->private;
>> +       spinlock_t *ptl;
>> +
>> +       ptl = pud_trans_huge_lock(pud, walk->vma);
>> +       if (!ptl)
>> +               return 0;
>> +
>> +       spin_unlock(ptl);
>> +       memset(vec, 1, nr);
>> +       walk->action = ACTION_CONTINUE;
>> +#endif
> 
> Do we really need the lock?
> 
> pud = pudp_get(pudp);
> if (!pud_none() && (!pud_present(pud) || pud_leaf(pud)))
> 	...
> 
> I'd prefer not using more of the pud_trans_huge() stuff directly.
> 
> I'm not really a friend of pmd_is_huge() either, but maybe we should just add a
> pud_is_huge() and use that here.

To make it clear，let's introduce a pud_is_huge helper，
still use pud_trans_huge(() in it,

static inline bool pud_is_huge(pud_t pud)
{
        if (pud_present(pud))
                return pud_trans_huge(pud);
        else if (!pud_none(pud))
                return true;
        return false;
}

and in mincore_pud_range(),

if (pud_is_huge(pudp_get(pudp)))
	...

I will update it, please correct me if I misunderstood.
Thanks.






