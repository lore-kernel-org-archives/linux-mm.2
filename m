Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E09ACD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01DF76B0088; Tue, 12 May 2026 02:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10506B008A; Tue, 12 May 2026 02:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7F36B008C; Tue, 12 May 2026 02:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD9246B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:36:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 973ED1A03A1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:36:30 +0000 (UTC)
X-FDA: 84757808940.16.21ED16E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ACC781C0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:36:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UGf1lj4X;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778567788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYkyOj8uwmDAUrNTU1515NerHJIFKnmwm6dW9Vl/r7o=;
	b=glzDfXXzl7dGV0h7Y+/yBFzCiFQUmVEjRXWEAFJE2jvcDtESjTh+Rfv7W7JrXTJQOIbTZY
	BKVZkuWSou6ccWcdRUe4bLzx+ehihJRm9aVGWEt9vsUf/aoDkPTx//HzpjrQHmnEU5qo+K
	jb/6PEpChuPc5MMwhBhRnJGmQ/BuHgk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778567788; a=rsa-sha256;
	cv=none;
	b=HmniyIav7RFlqLczQ7A//UsogsT/SCyQz1Lb3+BjZrIbUH7Itfslu94QSFYYvWxKeo58xX
	6iOM3b4VaYG4ZFGID1JXh4uh6iwomg/gvcLsD/RXubZ0NGITCjJRm/OgaQ3utG9T00+FK6
	vIwQvCozwQdKyVrYo3za7guIwFB8X+U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UGf1lj4X;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A6F060120;
	Tue, 12 May 2026 06:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B412C2BCB0;
	Tue, 12 May 2026 06:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778567787;
	bh=MQAIw3ZyffNmgGuJ04KGFS4SWQk/fNvbb0luJtW7QgM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UGf1lj4X4giUnBgph8yM4+FcvS1z+KnEKRsoWQlMrrCbJVAW56kwrqtCD3vK25dHo
	 IStlcmPii7yxFTWttvAMxkHyisnVCaKO5z0mrXZ6SXUBs2ELzCjycgb/Hkuwl5Ech1
	 fxaHbH50oBlkNxYdXKRartHfk0RWd53Nna6EsRmQ/NBQ5EF3feI/3yrDIo+dJYGoZF
	 wHGjhe7hR3D6nZgWwck2kAFP8bKcnXUwu5purbyRzALlW9seCOBVN7gAnqRTZdkBGf
	 B1G9P+2lNVJiHrRksC0Z+EGqdZdZrxjy3lsxQkvL+KNXwoe9wY9EjpqwIjRiMqItTL
	 /lsGiKW2b1ZXw==
Message-ID: <36d58c0c-bd3f-40b0-a64d-2c16c8fb1f03@kernel.org>
Date: Tue, 12 May 2026 08:36:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] mm/swapfile: Add batched version of folio_dup_swap
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-7-dev.jain@arm.com>
 <871d9a91-2d14-4dbb-934d-b52c12dae7cd@kernel.org>
 <72d09e59-47f9-4faf-8cd9-0d168895a4c0@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <72d09e59-47f9-4faf-8cd9-0d168895a4c0@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ACC781C0005
X-Stat-Signature: 8b4ostjk3dz318tu46e6qbb9jacai4ia
X-Rspam-User: 
X-HE-Tag: 1778567788-568825
X-HE-Meta: U2FsdGVkX19vIW585sfUqOZ31FZAoGx2VJdlV0KNLQJwKmrN/wliqU0rwV8uUx4IA2h7fT+276XodPtYBmNturpSDQY9B9CmRPhgrZpxsO6mWagJQGLBOjsIsnx/ApsbTZUZdEPoEhpf6Wm2/s08sqF0vlAi5gjbOFZLp29SZved29O546d1BvYNH2zDm2tVtskRGftEcNDxyEqWQuJmpIYgFFJp5MDVj09wAJ9qitdwj6vf/z0RxAmvwq1f99C0maDhvWBYqJZ3iwycw99bTYWNKc8sDkc3aSnp261xEQWsbJlIrEw3L4E5nTkdXSWhj1VOy+zmPBmfceK6iXsvSfdD7eqpdIrJODrgRbxbHRYxEr1vRr/r/v41YI6hz5O0iPzF6zHgiEfSVjHkohxFQS1FaAFppDYCMWHJjbfKTVWPs+3QniD4ZcMLA7itVqVirBZRU4R9iUg8B2tay5rFQ+hBDYLqkcnqHEY0ySJH0TacrTUJsdAut2MZOReeV2NFCLN5M1O3UM6wJNP5wOie7dE20zyeGGPB8kH3E8mvjWhUCsKv6sSQQXUK+66iJ+oL/cJcjm44YW85CsLWmbzJY49KO+CfoXVt0IQhB0A4W8H8VNk9sdBJ9FmF+I0+t4mQ96LPtIY982vHECWwvsjoVB61BX6Sx5D8GCcryRFHTc/g2prkkuF+piTlPm2AOvD6ZVPmU6TbFN6VZn2+k/6Sc87coHCSXnWsSUml8MVgOIwv9wj7lAtt6FIcAdlmo66h1rLVJpxDd4vTTZIR/RoAv9Bn7FxxRqaaxw6/I9OEpdeA9lkY494H/MZre4Uiy5lDIQkSbV3t8d8dzJ6t8Q2GFWMqV3nnRPOvBj79QeGDLyB/r3KI4fggaPuWPqgV7C/UVDCWBjh+F7wZDpRk2g2HNOoGxTZn6c394EVL5MLrbwUkpyjo2zB9NYRCF8vWVTn6h2arzyCktqcPpTpuGID
 xR7Enguv
 +zuSgoQdbjrHtltxnj5wuPhND1kvXna4Z4pfmcs3c4jvoeyRaANIqfGR4wt/qP7CfPH9lZBmA4qnh9e6D4gZ3osS7bkI2QKFrsxf2CMa2y2ApfvISOBqNrc4gX4tmaY93irugT4/LdUSiFUs2/I9HRWygoDWlSi++3ZmFS9wAePbxmPpfdnWyGC+pM4ekGAMD0xkZiAwtdzhXL3wGkHyB3tDI0dLeddZcMeJJMftWpLvgwyIkqE0RkUM/Cm5E/ZuyZkYXtOD+iLMyR3ZVBLf+D7oTIDJZpbbSDBRzCIV0DkqsqUgXrMeLjBxjAXdUHUymsa+DEQtLAtuIn8osc5ZKpLW3njqteCIU9UkK6DUIUg2DJz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 08:07, Dev Jain wrote:
> 
> 
> On 11/05/26 1:15 pm, David Hildenbrand (Arm) wrote:
>> On 5/6/26 11:45, Dev Jain wrote:
>>> Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
>>> that folio_dup_swap already can handle a subset of this: nr_pages == 1 and
>>> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
>>>
>>> Currently we have a not-so-nice logic of passing in subpage == NULL if
>>> we mean to exercise the logic on the entire folio, and subpage != NULL if
>>> we want to exercise the logic on only that subpage. Remove this
>>> indirection: the caller invokes folio_dup_swap_pages() if it wants to
>>> operate on a range of pages in the folio (i.e nr_pages may be anything
>>> between 1 till folio_nr_pages()), and invokes folio_dup_swap() if it
>>> wants to operate on the entire folio.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>  mm/rmap.c     |  2 +-
>>>  mm/shmem.c    |  2 +-
>>>  mm/swap.h     | 12 ++++++++++--
>>>  mm/swapfile.c | 20 ++++++++++++--------
>>>  4 files changed, 24 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 25813e3605991..352ba77d90f67 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2314,7 +2314,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>  				goto finish_unmap;
>>>  			}
>>>  
>>> -			if (folio_dup_swap(folio, subpage) < 0) {
>>> +			if (folio_dup_swap_pages(folio, subpage, 1) < 0) {
>>
>> Can you throw in a patch to rename subpage -> page first?
> 
> Sure.
> 
>>
>>>  				set_pte_at(mm, address, pvmw.pte, pteval);
>>>  				goto walk_abort;
>>>  			}
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index bab3529af23c5..5e4f521399847 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -1698,7 +1698,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>  			spin_unlock(&shmem_swaplist_lock);
>>>  		}
>>>  
>>> -		folio_dup_swap(folio, NULL);
>>> +		folio_dup_swap(folio);
>>>  		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
>>>  
>>>  		BUG_ON(folio_mapped(folio));
>>> diff --git a/mm/swap.h b/mm/swap.h
>>> index a77016f2423b9..3c25f914e908b 100644
>>> --- a/mm/swap.h
>>> +++ b/mm/swap.h
>>> @@ -206,7 +206,9 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
>>>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
>>>   */
>>>  int folio_alloc_swap(struct folio *folio);
>>> -int folio_dup_swap(struct folio *folio, struct page *subpage);
>>> +int folio_dup_swap(struct folio *folio);
>>> +int folio_dup_swap_pages(struct folio *folio, struct page *page,
>>> +			 unsigned long nr_pages);
>>>  void folio_put_swap(struct folio *folio, struct page *subpage);
>>>  
>>>  /* For internal use */
>>> @@ -390,7 +392,13 @@ static inline int folio_alloc_swap(struct folio *folio)
>>>  	return -EINVAL;
>>>  }
>>>  
>>> -static inline int folio_dup_swap(struct folio *folio, struct page *page)
>>> +static inline int folio_dup_swap(struct folio *folio)
>>> +{
>>> +	return -EINVAL;
>>> +}
>>> +
>>
>> Much cleaner.
>>
>> Can we have a common folio_dup_swap() function instead that does what the
>> variant below does? (call folio_dup_swap_pages())
> 
> I am guessing you are saying to simply remove the folio_dup_swap stub because
> we have a stub for folio_dup_swap_pages anyways, I'll do that.

Right, dropping the "return -EINVAL;" variant, and instead move ...

>>>  
>>> +int folio_dup_swap(struct folio *folio)
>>> +{
>>> +	return folio_dup_swap_pages(folio, folio_page(folio, 0),
>>> +				    folio_nr_pages(folio));
>>> +}

... this variant out of the ifdef, that will call the folio_dup_swap_pages() stub.

-- 
Cheers,

David

