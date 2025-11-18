Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83ED2CEE351
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 20:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F2E6B00B1; Tue, 18 Nov 2025 15:17:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDEF46B00B2; Tue, 18 Nov 2025 15:17:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4DC6B00B3; Tue, 18 Nov 2025 15:17:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B960A6B00B1
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:17:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56E411A015B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:17:22 +0000 (UTC)
X-FDA: 84124837524.04.389FEE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7C8DBA0003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:17:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KGapez5G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763497040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9TJEHsnuM6YDCKx/V5tYDWOCLmwLmyG2VLIo7T7TWY=;
	b=x5/HcTYuOfBtckqehUUEDG8vyhA93CiC+qS7qLgJ+pDcGMuZJG8e2PpAWoc2zDSH4z5vus
	Th281Ua8zl4i3GAsKN/4ekOzDnFeGSau4P+EESV4DOAURVE8PJmuxZHndOf1yocio7o9ro
	GU8MWnj1UhRLyyMkAnF293eFWR7ncq4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763497040; a=rsa-sha256;
	cv=none;
	b=Dxq3g9fXJFmtZKjzDDKOuiuT9kHtvBJceWO0Ctn1Nlp5QvGCiLUvKoIrySR83DvBBhTXnA
	/xlI62lgQHQpCXY9m1ziyTAlsPr8wqmapKmTfn0rwnpPY2YcbNWSU2AKQF8L6HVUDQwLDc
	uZ2wPPkTf1oZVESVKXUd3rN+yE6l63s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KGapez5G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1824643518;
	Tue, 18 Nov 2025 20:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719D1C16AAE;
	Tue, 18 Nov 2025 20:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763497038;
	bh=RC7bvzRPZvLD+gGNVvZePs2odrCB3/V0ltzjIa7+7xA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KGapez5GKW+uFPVuEcSI5QGb1+yyj50h9TU1gXrda1EKF+xF5K2sVXNp9NwgvpkQT
	 hHm/eaagLbpSQJIC46TAMw8m1vWE3M60Ql/KtN6kEn8YI68tdPFzXUeplc8DiIobRO
	 JfbUaQUH8qQgd16K7ShbkrBmN9z4i+Y2I218EABk4luXs8LG+aKDB7I4YrxZLzN7KZ
	 EgdDiPQ7e6RcTtq3SQk8fTG+ydC7/i3hMmvi/5ZrL7X5pBMYiCYBf0qcz8MuyTYmMs
	 xssgniTFLOgQf4CeIgtOT+7CiAlg0YCxyr7C5s6ZoN7DjhJ/rP9fVQRelFgIh8PsJT
	 PI9wRqR96Sjig==
Message-ID: <c782bdbf-de29-44c5-a8ad-619ce89c212d@kernel.org>
Date: Tue, 18 Nov 2025 21:17:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
To: Zi Yan <ziy@nvidia.com>, Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <048134fd-6a3d-4a6c-a2eb-9a9911c3b35f@kernel.org>
 <efa37c4d-8c9f-4094-a713-4fd4452ae917@nvidia.com>
 <826df5b1-b61d-4794-a96c-dcf9ac19e269@kernel.org>
 <bf8e0c95-15a1-4eac-ba2e-52d361050039@nvidia.com>
 <20ad8b5c-1bb3-46bb-bc03-8e9222a7f7e1@nvidia.com>
 <EB4C7FF1-8350-43FC-B879-20EA0E733F09@nvidia.com>
 <ebdf1926-2e9b-4226-b80d-4f9975f72f7d@nvidia.com>
 <56BA0323-C976-40D3-B61C-D698FA0720C2@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <56BA0323-C976-40D3-B61C-D698FA0720C2@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yekdz45tgy63ndqbudu6b79713qy3uw6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C8DBA0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1763497040-261820
X-HE-Meta: U2FsdGVkX18zROHlHCgB3xwUBa5iPCGrX2q+h37Cy+AiWq7FLh+gq5UupF1GQv/TsRBjNvUG2ooz4wh9UEH/67x3AzlFQps7QnbJEjT2LDUsFdHAa0aVUtWwEbCfKUrvt01t3xM5pfLXEPW8uxMCDjHjvk9SIaYymj1aKLtlQqiNhemDU2LtEIwA+6yZOvkQ1DKXJ35v1pZyn1Kip9sQI3tq3IF2PsSp983pgc23WDU4zEpCcJpGX7C+/torn2nc2tRwuQYAe+0EB7xKXqAaJ+n+lMscvMFKpC2x7UDHqNpJT4AWqlfqZhBTKM2lQQkAJKfBjOwvL76zE4jijT68M25J+jDRSmZYuxPHRRMukVNfv62OPzZs7Xb0hZwuwcTan94gP25Q6JogFTi70HSH3kSYrLBmt8eOHv0UIYvYiS6oVAgxsacorJkHw2QQDkm7KPl8lzVpFiwfiU5k5sndeXrqMjMcK6PCXudJUUOrkS0b6BoAc73G5ITp7oBQC9LD8tVreWdzghlFQFaMYPimvtmnY4gAQnU+hLsAHso5FIpExzUzATFstgkjVKKoysHR0MmDUOdF4mGc9stJTp+ndauq5XTGg+nojt/r0D5gIWUr9CnocLUXTPcaI3yarCjyyoWqdfhIijIl5cXXGHVnrsuOQv/p15NkUehMtyG11ETkU6Qr48MIobYIuZiLwTTRxiRyXYcwe/ofY4+jA9BBwixO8wpsYQX2jd8aqnjjYG61bHc8Cn752WrMiemlIv8/fwXKBvVwKUYrzx6Jsd8aFNVyb2WHgnS7adxvCpTUWT5dqEYPugcWNdQ4Rl/1GdSKQDxcZbl8mLdQq/YwfolGX7p4x8Ty4GYreT9b7SvKKpgQsjz7iLs9eRNsHq14CaJerNnPnnTk//MV5bBY9hj1QCWqxcmyFRm0bW6juJYJZrQ+pKainxE7I24AwVdddsLVhaxEUSrMfoEoEM8LcTs
 07fXB/aa
 rsc7Pp56AlQrj18LH7LybdCDEIrI+Fbkqe59+SNaIwNkTT5Qs6ovxeKvCqbbCyFRuydG71525ozgKP9CDIHkxR3j8prSFCctfXU5A/6aow4zAC4dhvVA8JBQJERY1QonbLH8dXjcQL7NqLHyip4WpO3pAfUuSQDEHWq+6Lq5Ycb2UJNtd1MTvaQBnni7eFhfvLMVn4dLaJlMPW3hbZdKHbzOPmbT0Z1UAnpayrcJqlpD2k25wvQpMf19kuMbBskckXEj4Ovs4jm6bNAMmaPVhV1Snm0brULO8g2xMS1wQ0OfdH9nKUv1wyNOvtxZkHt4WcAehRGJiuVYz+mJn0TY6myqYYWreobgpoWHbuWIAfYZhSfNywRkKcIFMeGFQAKmCor3aN+3IAjN1VP2SgUG6h3csQ8v5KH1JjBHHkt4pjXrfVUm4A8q+7XXGeNOD3rmVjRpK/OZmDacVrOjWoGIMGQ1rEiUyQ5Ugx+sHk6e4WkCA+b0E7pZn/vXEBBH2jpl3ALpeMdblkiT8yBOdL92jANzVXWQp+/q3QJLSvilVETlegA4Y5nWjVTpgUh0qY43mP/7Fq2K1N83aadldyUjeKARNVP8c65I3/qJ7i2/zfALeittYNB+pWdccgiKSRFbFG7a/Hz6q51QecCdsVhAVS3x84B1YymuYRb26yqeFOWGnW2Cwzc+R0SlzkfaoTqERZoCzjzUyhyPLyNRB78le+4HTxQxNrqRpHR/MyGaDf4wj9L66KBFsrjZHQbkVjYQ8ir+TQENohaWjrWsrwYCcalXOy3ArPWPzGrgzB6WdLTw3kp0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 01:23, Zi Yan wrote:
> On 13 Nov 2025, at 16:56, Balbir Singh wrote:
> 
>> On 11/14/25 08:45, Zi Yan wrote:
>>> On 13 Nov 2025, at 16:39, Balbir Singh wrote:
>>>
>>>> On 11/13/25 10:49, Balbir Singh wrote:
>>>>> On 11/12/25 22:34, David Hildenbrand (Red Hat) wrote:
>>>>>> On 12.11.25 11:17, Balbir Singh wrote:
>>>>>>> On 11/12/25 21:00, David Hildenbrand (Red Hat) wrote:
>>>>>>>> On 12.11.25 05:46, Balbir Singh wrote:
>>>>>>>>> Unmapped was added as a parameter to __folio_split() and related
>>>>>>>>> call sites to support splitting of folios already in the midst
>>>>>>>>> of a migration. This special case arose for device private folio
>>>>>>>>> migration since during migration there could be a disconnect between
>>>>>>>>> source and destination on the folio size.
>>>>>>>>>
>>>>>>>>> Introduce split_unmapped_folio_to_order() to handle this special case.
>>>>>>>>> This in turn removes the special casing introduced by the unmapped
>>>>>>>>> parameter in __folio_split().
>>>>>>>>
>>>>>>>> As raised recently, I would hope that we can find a way to make all these splitting functions look more similar in the long term, ideally starting with "folio_split" / "folio_try_split".
>>>>>>>>
>>>>>>>> What about
>>>>>>>>
>>>>>>>>       folio_split_unmapped()
>>>>>>>>
>>>>>>>> Do we really have to spell out the "to order" part in the function name?
>>>>>>>>
>>>>>>>> And if it's more a mostly-internal helper, maybe
>>>>>>>>
>>>>>>>>       __folio_split_unmapped()
>>>>>>>>
>>>>>>>> subject: "mm/huge_memory: introduce ..."
>>>>>>>>
>>>>>>>
>>>>>>> I can rename it, but currently it confirms to the split_folio with order in the name
>>>>>>> The order is there in the name because in the future with mTHP we will want to
>>>>>>> support splitting to various orders.
>>>>>>
>>>>>> I think we should start naming them more consistently regarding folio_split() immediately and cleanup the other ones later.
>>>>>>
>>>>>> I don't understand why "_to_order" must be in the name right now. You can add another variant and start using longer names when really required.
>>>>>>
>>>>>
>>>>> Ack
>>>>>
>>>>>>>
>>>>>>>
>>>>>>>>>
>>>>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>
>>>>>>>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>> ---
>>>>>>>>>     include/linux/huge_mm.h |   5 +-
>>>>>>>>>     mm/huge_memory.c        | 135 ++++++++++++++++++++++++++++++++++------
>>>>>>>>>     mm/migrate_device.c     |   3 +-
>>>>>>>>>     3 files changed, 120 insertions(+), 23 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>>>>>> index e2e91aa1a042..9155e683c08a 100644
>>>>>>>>> --- a/include/linux/huge_mm.h
>>>>>>>>> +++ b/include/linux/huge_mm.h
>>>>>>>>> @@ -371,7 +371,8 @@ enum split_type {
>>>>>>>>>       bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>>>>>>>     int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>>>>>> -        unsigned int new_order, bool unmapped);
>>>>>>>>> +        unsigned int new_order);
>>>>>>>>> +int split_unmapped_folio_to_order(struct folio *folio, unsigned int new_order);
>>>>>>>>>     int min_order_for_split(struct folio *folio);
>>>>>>>>>     int split_folio_to_list(struct folio *folio, struct list_head *list);
>>>>>>>>>     bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>>>>>>> @@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>>>>>>>>>     static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>>>>>>>             unsigned int new_order)
>>>>>>>>>     {
>>>>>>>>> -    return __split_huge_page_to_list_to_order(page, list, new_order, false);
>>>>>>>>> +    return __split_huge_page_to_list_to_order(page, list, new_order);
>>>>>>>>>     }
>>>>>>>>>     static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
>>>>>>>>>     {
>>>>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>>>>> index 0184cd915f44..942bd8410c54 100644
>>>>>>>>> --- a/mm/huge_memory.c
>>>>>>>>> +++ b/mm/huge_memory.c
>>>>>>>>> @@ -3747,7 +3747,6 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>>>>>>>      * @lock_at: a page within @folio to be left locked to caller
>>>>>>>>>      * @list: after-split folios will be put on it if non NULL
>>>>>>>>>      * @split_type: perform uniform split or not (non-uniform split)
>>>>>>>>> - * @unmapped: The pages are already unmapped, they are migration entries.
>>>>>>>>>      *
>>>>>>>>>      * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
>>>>>>>>>      * It is in charge of checking whether the split is supported or not and
>>>>>>>>> @@ -3763,7 +3762,7 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>>>>>>>      */
>>>>>>>>>     static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>>>>>             struct page *split_at, struct page *lock_at,
>>>>>>>>> -        struct list_head *list, enum split_type split_type, bool unmapped)
>>>>>>>>> +        struct list_head *list, enum split_type split_type)
>>>>>>>>
>>>>>>>> Yeah, nice to see that go.
>>>>>>>>
>>>>>>>>>     {
>>>>>>>>>         struct deferred_split *ds_queue;
>>>>>>>>>         XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>>>>>>>>> @@ -3809,14 +3808,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>>>>>              * is taken to serialise against parallel split or collapse
>>>>>>>>>              * operations.
>>>>>>>>>              */
>>>>>>>>> -        if (!unmapped) {
>>>>>>>>> -            anon_vma = folio_get_anon_vma(folio);
>>>>>>>>> -            if (!anon_vma) {
>>>>>>>>> -                ret = -EBUSY;
>>>>>>>>> -                goto out;
>>>>>>>>> -            }
>>>>>>>>> -            anon_vma_lock_write(anon_vma);
>>>>>>>>> +        anon_vma = folio_get_anon_vma(folio);
>>>>>>>>> +        if (!anon_vma) {
>>>>>>>>> +            ret = -EBUSY;
>>>>>>>>> +            goto out;
>>>>>>>>>             }
>>>>>>>>> +        anon_vma_lock_write(anon_vma);
>>>>>>>>>             mapping = NULL;
>>>>>>>>>         } else {
>>>>>>>>>             unsigned int min_order;
>>>>>>>>> @@ -3882,8 +3879,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>>>>>>             goto out_unlock;
>>>>>>>>>         }
>>>>>>>>>     -    if (!unmapped)
>>>>>>>>> -        unmap_folio(folio);
>>>>>>>>> +    unmap_folio(folio);
>>>>>>>>>    
>>>>>>>>
>>>>>>>> Hm, I would have hoped that we could factor out the core logic and reuse it for the new helper, instead of duplicating code.
>>>>>>>>
>>>>>>>> Did you look into that?
>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>> I did, I ended up with larger spaghetti, I was hoping to look it as a follow up
>>>>>>> after the series with the mTHP changes and support (that is to be designed and
>>>>>>> prototyped).
>>>>>>
>>>>>> Looking at it in more detail, the code duplication is not desired.
>>>>>>
>>>>>> We have to find a way to factor the existing code out and reuse it from any new function.
>>>>>>
>>>>>
>>>>> I came up with a helper, but that ends up with another boolean do_lru.
>>>>>
>>>>>
>>>>
>>>> Zi, David, any opinions on the approach below?
>>>
>>> Looks good to me. We might want a better name instead of
>>> __folio_split_unmapped(). Or __split_unmapped_folio() should
>>> be renamed, since these two function names are too similar.
>>>
>>> Maybe __folio_split_unmapped() -> __freeze_and_split_unmapped_folio().
>>>
>>> Feel free to come up with a better name. :)
>>>
>>
>> I had __folio_split_unfreeze() to indicate we split the folio and unfreeze at the end, but
>> it does not reflect that we freeze it as well. Looks like we are trending towards folio_split
>> as the prefix (IIUC Dave correctly), I like your name, but if folio_split is going to be
>> required then may be __folio_split_unmapped_unfreeze()?
>>
> 
> OK, if __folio prefix is a convention,

Yes, let's start cleaning all this up.

> how about
> __folio_freeze_and_split_unmapped()? __folio_split_unmapped_unfreeze() sounds
> like folio is frozen when the function is called. Of course, a more accurate
> one would be __folio_freeze_split_unfreeze_unmapped(). It can work if
> it is not too long. :)

Let me take a look at v2.

-- 
Cheers

David

