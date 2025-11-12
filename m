Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29389CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847948E001A; Wed, 12 Nov 2025 06:34:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F88E8E0003; Wed, 12 Nov 2025 06:34:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E868E001A; Wed, 12 Nov 2025 06:34:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 604748E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:34:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4440B98D2
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:34:32 +0000 (UTC)
X-FDA: 84101747184.16.E865430
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1EF281C0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:34:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EpsdFkP/";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762947271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WQGRH7KRj0RlgERGH5biPvTuq4UWnPKy8zeURx4as0=;
	b=onWa0Ql1GXfc7/7JgL2TcIHgXzGHjs9RHnhytSNLJnncVKIQKt7y5BuNmDNRYtmwcceltI
	5A2SOJlNmkuAt3v1HnCP3YXvVkakb4/K+nkTpKJRlS3GjzAM0ySW/XdsxUKI8K/1++WqjO
	NawZ2LyLC6WYr5zciUwvWAoLp5wQJis=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762947271; a=rsa-sha256;
	cv=none;
	b=Tm3FyKtaOvPv3AsNHQ1u943NAD6gFcj3+Nxg6uaAVOkSaan47D5NM2lPNmUBeDKKLWwyGG
	wNO2AonGG13BJrEIqaA+SMiDCW0uSxkq+M4CMJnE+hyNLTLpygGIAcrrKYIy/5RRMHshDa
	GoIOTIiwebV2xLi/OuYuwiZS1l68J+Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EpsdFkP/";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D67E341AAF;
	Wed, 12 Nov 2025 11:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FD7C4CEF5;
	Wed, 12 Nov 2025 11:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762947269;
	bh=rAhECoWyxD/5mXaMjAqq2GVzvYlNQTIj7BGyaTujbEc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EpsdFkP/HSPMUyE75qXCFNFWREmp6aDwYXrqWGnHUDTd8l9G57vGIQkZCpqTldbe8
	 Wq3NemyJQYf3yz3cy+1bZogBnxlVXDFfM5C5TlNoQWh+0eKG2q0xQIRfEZbm+ZfCw+
	 DEABNOWriB4d4Vns/BFpn0B+73GB2rmEchf5PLehQFa2lW28Tc6EJLtp9KAlTOtIOh
	 1ME4IZ515mBuKI3BSFGS4sKDmcUSlL7Vt/2Xz5pQn8m5xBcB3leGw4Z1gvLE8o7bfK
	 /KcLe4kCf30H/2kFg4AT08/Mf/BfYQlt0OrtI3HNKxQR2Xfer2TKovKzjJzoQMpEzR
	 /NlGXfYC+LFQQ==
Message-ID: <826df5b1-b61d-4794-a96c-dcf9ac19e269@kernel.org>
Date: Wed, 12 Nov 2025 12:34:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <efa37c4d-8c9f-4094-a713-4fd4452ae917@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: co7iczp6xg8zhh6u84o14u7ikg46nzag
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EF281C0011
X-Rspamd-Server: rspam01
X-HE-Tag: 1762947270-45479
X-HE-Meta: U2FsdGVkX1+jLJ9xdzaYYR3OxtS01lj3/EKoulc5DsTInsoAidnO2XHHweHs07jyMtXJDj8M1FMPgf94g21EVIIqedk7eYjHosGINuDnybvKNzHKzOlDNqsv5oYfP1B4EfMDo+2rklJbvz7lMyxzsOHRR07gvYy8L+bILWkrOfxmLmULvJk25wymD54m38FeEWW19n/Teg3KkYe+h0e7tGEs4VIOxPeYUcjYet4PFPj56fiUe4GTZJDOKQhI0D/aZuKgS0HEJiJGblkKa+CIZS3n5RF6SPcPvodtcH3UCG9FZ5KPAoNvINrd8DYvprIma3c0EOVsk507Cw6bbDCh4ijY6FeCgVJVWBHYfvuOvPbRCtbzKUiuhMpvU2/2iBFhDrMEGwrClNZiD+axBMLj0zoD5wzXStirkuvcLqV6S6diE2xjStvUu3xOaGrhfJcy6i/V6aswfakowHKwebSxwrxzpsozqfZ2HgrjYop0IlhsCsNG6/r/pgu2LmgfdI9gF0JweQBnbTxdSd1YUdqSNzz88CSizV79SSp5XgjiVk0rYuUysYktCpiL1ShK1eLrF8brfrLKSCjrutahheD8vPwokx46J+AJGcKdP3U0dg4MsaRfSWJtK0PigRZ+XyKrFRROMU78spZkjlSI/KqcHd2wh8YqKTc4AkA73bVGX1G3njRDD0rS7Wt8pWie127Rb1cfbQ+IW2u2wI1EJgs9qXGsl6LgT2n9dU2Doek1jPS44n4abbpJ87KQxL9cP1LD/zevMP6DB40nPQT1aBn5hvyOXW4uBZfU8VL/sUQvpZsVMxQ+2fQtPuHMvycdgGwpblRsrYWI2p7awiPdQlugXoziF7qrJhV51uaimPNIErfdcYoHWApH8i5TTs/Ma8j9RBB4scWoccm38+1f20RRU0toq/LKOjCQZtBmKyV6jF36e00YycZbrYs4TEljCqqM78gHKevodeDxh2ASpOx
 PA2MIF6A
 rjoKEjfSm1sDPY9+ZJYvkd8S8+4q7wqeDvMk2ssne2ZgkzLq+3J5kC11zwwBBDk+FeKbJIKxMdkvTmnMsG0phYHZ1pb8IPEqVraA6DXrUwZOOfjY0H/89lFUUhgI+iMyAAAPF3d9ZPWLnE1GKyDCeLmPz0hdFgycaXWsbxMdh0vchBnlnUuWvjv9sbYWTFu63DF2hsb0rqsl2Ifb2P2vKBfgItw/9jne506EOSmKhTTmZJAq9XW2Dlw0nWoiKI1K4jSdvvRmkbYMwWMx9jcLI6Ey4JBQxQhbEea0/BtgPh1VVJES68TFsbp0Np2BuSvKE/QKMkgNEsx5+EHe0Ti+apZVtL6FnYwv3vg+fvAAzqwiRCriLxNpOoAA1y9OXn3SETfXTLLlGLNL8/fX4VAsLzDumeWS9ahJ0iqJAc8a02IO65gAb6/lXo+30F1ZpEK3DCzVs1y7VVpvmPko2aXDvuewyvf4OVpaOU7PAYQLRDnT+XrkxfcsW0FCNhoqFtKxAXNoYNVQkMj3B3cB/TxOSWK9C57ONENYzTckhloyUNiXEcRdGWlik5BGtJu7wKV4C+tLnKWnU32aiTO+mLHXi6n+OqNqT/3sS6j0P6KQCbbmHOq4o94wFgzLb6LdYX/dGXY2f3SNs6F5pj6/YVomwmvZecGQJn4zJ9/Dma/ktk0SndZZINvluOttgdBGjhchEWtT8V0ZqQx4YKEf0C+CrqgEG9yYB9FLcRmdOIpqCbCRUMJg71x/Ugpf1L9ylrAESxzl9la2Q3DUIMPXtwyQETfsuApMa18IKwfrqejc6S+69PjE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 11:17, Balbir Singh wrote:
> On 11/12/25 21:00, David Hildenbrand (Red Hat) wrote:
>> On 12.11.25 05:46, Balbir Singh wrote:
>>> Unmapped was added as a parameter to __folio_split() and related
>>> call sites to support splitting of folios already in the midst
>>> of a migration. This special case arose for device private folio
>>> migration since during migration there could be a disconnect between
>>> source and destination on the folio size.
>>>
>>> Introduce split_unmapped_folio_to_order() to handle this special case.
>>> This in turn removes the special casing introduced by the unmapped
>>> parameter in __folio_split().
>>
>> As raised recently, I would hope that we can find a way to make all these splitting functions look more similar in the long term, ideally starting with "folio_split" / "folio_try_split".
>>
>> What about
>>
>>      folio_split_unmapped()
>>
>> Do we really have to spell out the "to order" part in the function name?
>>
>> And if it's more a mostly-internal helper, maybe
>>
>>      __folio_split_unmapped()
>>
>> subject: "mm/huge_memory: introduce ..."
>>
> 
> I can rename it, but currently it confirms to the split_folio with order in the name
> The order is there in the name because in the future with mTHP we will want to
> support splitting to various orders.

I think we should start naming them more consistently regarding 
folio_split() immediately and cleanup the other ones later.

I don't understand why "_to_order" must be in the name right now. You 
can add another variant and start using longer names when really required.

> 
> 
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>> Cc: Byungchul Park <byungchul@sk.com>
>>> Cc: Gregory Price <gourry@gourry.net>
>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>> Cc: Alistair Popple <apopple@nvidia.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>> Cc: Nico Pache <npache@redhat.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Barry Song <baohua@kernel.org>
>>> Cc: Lyude Paul <lyude@redhat.com>
>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>> Cc: David Airlie <airlied@gmail.com>
>>> Cc: Simona Vetter <simona@ffwll.ch>
>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>
>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>> ---
>>>    include/linux/huge_mm.h |   5 +-
>>>    mm/huge_memory.c        | 135 ++++++++++++++++++++++++++++++++++------
>>>    mm/migrate_device.c     |   3 +-
>>>    3 files changed, 120 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index e2e91aa1a042..9155e683c08a 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -371,7 +371,8 @@ enum split_type {
>>>      bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>    int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>> -        unsigned int new_order, bool unmapped);
>>> +        unsigned int new_order);
>>> +int split_unmapped_folio_to_order(struct folio *folio, unsigned int new_order);
>>>    int min_order_for_split(struct folio *folio);
>>>    int split_folio_to_list(struct folio *folio, struct list_head *list);
>>>    bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>> @@ -382,7 +383,7 @@ int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>>>    static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>            unsigned int new_order)
>>>    {
>>> -    return __split_huge_page_to_list_to_order(page, list, new_order, false);
>>> +    return __split_huge_page_to_list_to_order(page, list, new_order);
>>>    }
>>>    static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
>>>    {
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 0184cd915f44..942bd8410c54 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3747,7 +3747,6 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>     * @lock_at: a page within @folio to be left locked to caller
>>>     * @list: after-split folios will be put on it if non NULL
>>>     * @split_type: perform uniform split or not (non-uniform split)
>>> - * @unmapped: The pages are already unmapped, they are migration entries.
>>>     *
>>>     * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
>>>     * It is in charge of checking whether the split is supported or not and
>>> @@ -3763,7 +3762,7 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>>     */
>>>    static int __folio_split(struct folio *folio, unsigned int new_order,
>>>            struct page *split_at, struct page *lock_at,
>>> -        struct list_head *list, enum split_type split_type, bool unmapped)
>>> +        struct list_head *list, enum split_type split_type)
>>
>> Yeah, nice to see that go.
>>
>>>    {
>>>        struct deferred_split *ds_queue;
>>>        XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>>> @@ -3809,14 +3808,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>             * is taken to serialise against parallel split or collapse
>>>             * operations.
>>>             */
>>> -        if (!unmapped) {
>>> -            anon_vma = folio_get_anon_vma(folio);
>>> -            if (!anon_vma) {
>>> -                ret = -EBUSY;
>>> -                goto out;
>>> -            }
>>> -            anon_vma_lock_write(anon_vma);
>>> +        anon_vma = folio_get_anon_vma(folio);
>>> +        if (!anon_vma) {
>>> +            ret = -EBUSY;
>>> +            goto out;
>>>            }
>>> +        anon_vma_lock_write(anon_vma);
>>>            mapping = NULL;
>>>        } else {
>>>            unsigned int min_order;
>>> @@ -3882,8 +3879,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>            goto out_unlock;
>>>        }
>>>    -    if (!unmapped)
>>> -        unmap_folio(folio);
>>> +    unmap_folio(folio);
>>>    
>>
>> Hm, I would have hoped that we could factor out the core logic and reuse it for the new helper, instead of duplicating code.
>>
>> Did you look into that?
>>
>>
> 
> I did, I ended up with larger spaghetti, I was hoping to look it as a follow up
> after the series with the mTHP changes and support (that is to be designed and
> prototyped).

Looking at it in more detail, the code duplication is not desired.

We have to find a way to factor the existing code out and reuse it from 
any new function.

-- 
Cheers

David

