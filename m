Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D553CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E996B0088; Tue, 12 May 2026 03:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF7E6B008A; Tue, 12 May 2026 03:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DDF96B008C; Tue, 12 May 2026 03:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA226B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:05:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 022A71603C4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:05:51 +0000 (UTC)
X-FDA: 84757882944.04.877B66D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1107C180009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:05:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aMd8+LCt;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778569550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ZvCS9OOCXT5y1ggHMo4llNIkw2RzMuNWgsdCN68Bi8=;
	b=nDxO9oqFU5N17U2qSLV7pMtIfAgTGKYxtze0J0ifaeV0BG3+kUK4uqGkvSrJI1od45t3Wt
	33MESvFz2SmcWNh7rftO7pnmuj5b4GJYJA1NRMuI8Df1jO5p+N+yxQBPaxb3E/s9Ck6NiQ
	cIQaXExTsfRowK/DDBYAglAMRg44ha8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aMd8+LCt;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778569550; a=rsa-sha256;
	cv=none;
	b=ET+h0XglXwrrKzl1kXP00T8WhaQ2Q6fJAlFpOWDXQwj0kvDNRE6JgylmG7KtLLbRNme3JD
	vUDwbdl3GNKVSLwI+hclrDIbeEkxLd+Hbf6YeeVuTfFhqENg9G1X2QeFP1t17LEUmi/WY6
	OaG4VHF9vgWKNLEBsE4zY/kIhsAdvng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18D344405C;
	Tue, 12 May 2026 07:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A601C2BCC7;
	Tue, 12 May 2026 07:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778569549;
	bh=gBYC5Bpnkr9r0ZdtTk6PBMzluCJtfMFiwicke0Go8sk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aMd8+LCtlMmS58Pmu9ZgIEgIcWJ3fKbPNAtfDG3wkI4uJEQ0xQJOjcEfYA3zv4Fmz
	 xO3PYcZKm8YsCWaMWMdf85By4XjUjONgFm9EhqscQL8PKojZnIKUOZjNEezjU32Z1l
	 xznnDrn98sLfhbaUl3qUWLeYnFg/iC5/zwoP8OlP+xh5/utdzSZu4QKFRKvBpx/Sk+
	 JaMxDIYkt6CYcIMxNQ9vMdx+mUVTt4q/fqpYYxdVvGR2OlARYU4vu6ewhYiBEFl+zL
	 hv/uSyPgKXh0dfmpAHAVSfdJBX5UevsAF52DuNYknoxUTg69MYiEaZSIXGmxGenmee
	 +lWsVoIRQvfKw==
Message-ID: <2b2feeda-e4a0-49f3-800e-b2391b67e018@kernel.org>
Date: Tue, 12 May 2026 09:05:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, lance.yang@linux.dev, baohua@kernel.org,
 dev.jain@arm.com, ryan.roberts@arm.com, liam@infradead.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, ljs@kernel.org,
 akpm@linux-foundation.org
References: <20260508170509.640851-1-npache@redhat.com>
 <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
 <CAA1CXcBGEUUzUYdot9j5ftNrwhxDa+2C-aOMCtKfUBEobHP0Wg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcBGEUUzUYdot9j5ftNrwhxDa+2C-aOMCtKfUBEobHP0Wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1107C180009
X-Rspamd-Server: rspam06
X-Stat-Signature: frnenywkz3dzyurbp6gkcryss9xkbhza
X-HE-Tag: 1778569549-866080
X-HE-Meta: U2FsdGVkX18fEgtRjZzqEgvGnVjiFyneSP1wYejewusRy2w6NuLPkSU6Ej7/r68UsjxtNyNi3WufY7rPvcOH42OinyPj/iRVfu+D7sdJbm+KQ8icCY/1rpyT0DltUHsMlMhT77rrkvzcyHDtRqjXojoglRSXGyXghGWibCpCqQPSb8TzTMDA68P+p4aC1S5sg7+D0rZmRvjk7Fs4tM1Ox74UovTemtO6CzLF3q5yvUpy0uzUlR92uuZNrBOyjYroonfI8k7G7RfrvCT7zIy8GVEmKRIztqwoNusyRh/+hPBxirfck3h959BtVQ2jleJUh3M/5nGOQBF1yjzGmQZwR58JyH4Yes4SoY0Ma+EDJeVuUmoqaLKpzmUzgTiPrF4RHzkLLO68g50n+1owlLBbGipLYYiBobSI29hahs5waDbCEPl1ipFJ+YjJjikBH0xHkruNVDtozf6hPB6vdrTtw6j6UOMuZ22f+xYUqfMnRdlOZdodM48mwGRaM0+7wRkNebY9wVFOb6Nf9xO5+2x2WnanrTf0xBwYIWVww0qQTBpDCwOt97DeUlH6iJbDjwCakT2lftquL8xHhWoiohfSwVFbg0te3KcgBHMWVGWewOZCD56CCPrZUK28tYJEGech/Ce9zHqk4Y7VvXGlxIJTJ18a1OSs2HuLUzfMouYXiqMm8NBCLpe2G8P7UbmOFN2ZCBeV7GaKr41BNmDhN5haPIP4dpzpPQtZV5gjuVglL42kn/gZsn2SeYVpqkd49vcKOWWkexNl7Ae4f0XdzR0zg6+umI4zWfOikhkteECn8NXG/0FSfzDXwMgAuVMWvh1Rd+0A0ODQavHWA8pfg+tqifvV9u268DdObG3QMduWQjirXzq11AqXK3gihTSXGASeM5C4+usLgAqbantb+kwIB02UI2CkVuevRmjGMX23rbHmL12EbHydBYdgQ3gcNlJt1BJdFxkr312FF78Qb99
 P9aFaqsw
 jlM9reM3ZLjghFZqmlEagqxfEJYfXhv6uuUZDnEJVJrcaH3J0t00Ps9aajXkvvQIV5lCAnZAEy9VRSOqyGT6+K+JaiZJWcMxVPNOdP355+0ZDyADDd+kpSKjxBo6WZyy68mf/+fM3/Z5Y/k2SEI9ftPIyab7nxQzhxaVgKUEM/g5zSXKSF1ZU9kDZBDYmln7X31SKtq38b3Jl1whQkTkeN+H5epOerKsA6zNCsyXJD7AqKO2U7T9Sd+gM0JtfL/vpSl50MngSTFqs5A1mBcH3nZ1OUQg4s16HpIMRojOH9qeTP67PYUdXTlVMkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 20:40, Nico Pache wrote:
> On Fri, May 8, 2026 at 3:32 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 5/8/26 19:05, Nico Pache wrote:
>>> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
>>> when splitting isolated thp"), splitting an anonymous THP remaps all
>>> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
>>> This flag is set unconditionally for every anonymous folio split,
>>> including splits triggered by KSM.
>>
>> And even when the underused scanner is effectively disabled on a system. Hm.
>>
>> I don't quite like that we scan for zeropages when nobody even requested us to
>> split because of zeropages.
>>
>> I can see why we would want to scan for zeropages in a setup where the underused
>> scanner is active, even when the split was triggered by someone/something else
>> (below).
>>
>> [...]
>>
>>>  /**
>>> @@ -4340,7 +4341,13 @@ int folio_split(struct folio *folio, unsigned int new_order,
>>>               struct page *split_at, struct list_head *list)
>>>  {
>>>       return __folio_split(folio, new_order, split_at, &folio->page, list,
>>> -                          SPLIT_TYPE_NON_UNIFORM);
>>> +                          SPLIT_TYPE_NON_UNIFORM, false);
>>> +}
>>> +
>>> +int folio_split_underused(struct folio *folio)
>>> +{
>>> +     return __folio_split(folio, 0, &folio->page, &folio->page,
>>> +                          NULL, SPLIT_TYPE_NON_UNIFORM, true);
>>>  }
>>>
>>>  /**
>>> @@ -4559,7 +4566,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>               }
>>>               if (!folio_trylock(folio))
>>>                       goto requeue;
>>> -             if (!split_folio(folio)) {
>>> +             if (!folio_split_underused(folio)) {
>>>                       did_split = true;
>>>                       if (underused)
>>>                               count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
>>
>> In general, this looks clean.
>>
>> But imagine the following: someone splits the THP for another reason: for
>> example, because migration is unable to allocate a 2M THP, or because we have to
>> split on swapout etc.
>>
>> Not freeing the zero-filled pages means that these pages cannot be reclaimed
>> anymore easily. We split a possibly underused THP but didn't free the memory.
>>
>> The only way to free the memory would be to wait for another collapse, and then
>> have the new THP be detected as underused.
>>
>> Hm.
> 
> And what was the expected behavior before this commit? Did we just
> deal with the wasted memory?

Before your change, splitting will always free memory, no matter who triggers
splitting. So there is no wasted memory (regarding underused THPs).

With your change, if we happen to split before the deferred shrinker runs, we
end up with zero-filled pages that waste memory. And reclaiming them (through
the deferred shrinker) first requires another re-collapse to a THP.

Or am I misunderstanding your question?

> 
>>
>> (1) As you say, the alternative is to let KSM say that it wants to handle the
>> zero-filled pages itself. I'm not a the biggest fan of that approach. We still
>> have two mechanisms interacting to some degree.
>>
>> (2) Another approach is to just let KSM handle this in VMAs that are marked as
>> mergable while KSM is active. That is, we check for VM_MERGABLE and ksm_run ==
>> KSM_RUN_MERGE in try_to_map_unused_to_zeropage() to just let KSM do its thing.
>>
>> That really just stops both mechanisms from interacting.
>>
>> (3) Yet another approach I could think of (in general) is to disable the
>> underused handling in a system where the underused splitting is entirely disabled.
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index e9d499da0ac7..5eca99271957 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -82,6 +82,14 @@ unsigned long huge_anon_orders_madvise __read_mostly;
>>  unsigned long huge_anon_orders_inherit __read_mostly;
>>  static bool anon_orders_configured __initdata;
>>
>> +static bool thp_underused_split_active(void)
>> +{
>> +       if (!split_underused_thp)
>> +               return false;
>> +
>> +       return khugepaged_max_ptes_none != HPAGE_PMD_NR - 1;
>> +}
>> +
>>  static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>  {
>>         struct inode *inode;
>> @@ -4188,7 +4196,8 @@ static int __folio_split(struct folio *folio, unsigned int
>> new_order,
>>         if (nr_shmem_dropped)
>>                 shmem_uncharge(mapping->host, nr_shmem_dropped);
>>
>> -       if (!ret && is_anon && !folio_is_device_private(folio))
>> +       if (!ret && is_anon && !folio_is_device_private(folio) &&
>> +           thp_underused_split_active())
>>                 ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>>
>>         remap_page(folio, 1 << old_order, ttu_flags);
>> @@ -4497,7 +4506,7 @@ static bool thp_underused(struct folio *folio)
>>         int num_zero_pages = 0, num_filled_pages = 0;
>>         int i;
>>
>> -       if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>> +       if (!thp_underused_split_active())
>>                 return false;
>>
>>         if (folio_contain_hwpoisoned_page(folio))
>>
>>
>>
>> I tend to like (2), and maybe (3) on top. Opinions?
> 
> I don't fully understand (2) but I definitely agree with (3).
> 
> Isn't (2) similar to my split_huge_page_no_zeropage() solution in that
> it only disables the behavior for KSM? but instead handled much
> further down in the call path? The "fix" commit sold this as a
> solution ONLY for the underutilized shrinker, but it is not that.

It keeps other paths that happen to split the folio before the deferred shrinker
runs unaffected (see above).

-- 
Cheers,

David

