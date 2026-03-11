Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AFE4FD88F4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 04:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1DA96B0089; Wed, 11 Mar 2026 00:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1406B008A; Wed, 11 Mar 2026 00:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3A96B008C; Wed, 11 Mar 2026 00:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE27C6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:52:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41681C22C9
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:52:47 +0000 (UTC)
X-FDA: 84532561974.26.8E92C1D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AB271C0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:52:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773204765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/AIPRsL72xS4TiVirHb6urVqK3vGu73T6WRDQu18bZY=;
	b=lI73iGaajkomp4/0V4k/hiGtciPk0KN8zWKuJtO3kSyIiCw/h1Ny6xnTT8V7ZUQyRT6z/y
	8YMUOuQUVMQIwIjwwMHeDl1AxCX+RsPUq2NPtw4OT1EL9bkXKUd1qVMeQehBPaAcLvAxWK
	p1+c7/q3wI+5Sx26wLlRhs6QF2EcuZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773204765; a=rsa-sha256;
	cv=none;
	b=knit1TiLgnB6kj0QtSpm20qxmccFuX3Vl/Vhb3jRhflOALZY0uupxxwfkB6+7jPjMfXkUd
	uMCEX6vWAHyVK9dfFrZpC3gTbrevVy2ldoD1YuTAKMiRieCyjgzoLZw8gY1KMVw8BAOs3b
	nk/XwRMmZ6zfsUy3RyxIE8j9T9klwgA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5C93165C;
	Tue, 10 Mar 2026 21:52:37 -0700 (PDT)
Received: from [10.164.148.48] (unknown [10.164.148.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09EB13F73B;
	Tue, 10 Mar 2026 21:52:33 -0700 (PDT)
Message-ID: <2b9146bb-31e9-4bbd-843e-221f13a7097c@arm.com>
Date: Wed, 11 Mar 2026 10:22:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] mm/rmap: batch unmap folios belonging to uffd-wp VMAs
To: Barry Song <21cnbao@gmail.com>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 david@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
 weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org,
 willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-6-dev.jain@arm.com>
 <00f65edd-5b16-4f9e-a9fa-b923eba052b7@lucifer.local>
 <CAGsJ_4zMQReykifGVmXJEgPqORhRoFBKKJq_bjBzDGT5hfGGwQ@mail.gmail.com>
 <CAGsJ_4wmrV0+wxiXAgEWRxBpv1QT9Sm__Pi+yREGvT9YH2n4uQ@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4wmrV0+wxiXAgEWRxBpv1QT9Sm__Pi+yREGvT9YH2n4uQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x5bxkpktst58hhmxst3p6jg75ugby3ot
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AB271C0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773204765-165580
X-HE-Meta: U2FsdGVkX1/pdumlfYd7OrCQ53yHL/9sEI2LbbEAOaLZk0OPcPvBS7s1k2U0ntiVjmXVbi9imcU6XWJJ54OUh5/ZAvl1X03wcpnY2VInEnemoyJmDKY7nnz4w4Ndn8WFueqkSxLOyFMe8MlUDXLm8i8+ZHGUqbqRWXo0z91wFkhFAgw+ySdTNrkVYLn/BA/Rl4/fuYdFOn40L1EIcCj5MCVgVbaliX2SDhqMj2lFWI5HQMfe+NfvU2gDg1LjXtmBySKw6K0R3d2WknGXoGeoU2L8rzWCgDkcxpzg6kNPB2rp3m+0p52/6SLYNpjlNMf0M9FAhl7K/OjzjtCxAT6OCfiah6d9iXvlOil9NgbSc3VQmzu6mRB/Euz8E1MkLEPPO23gPOx2DL4un4LY9v6E9tZccWaWDg+kiKy20MUmypY4Y+mX81lLRz+z6YmULVn5fXpDmja35GTHUSntDqKwnk3EtYVT+vdAsiR9rZPeJzDI4k+DRKEILa63LeC8yvXA4UhW7UGdiIJCl+mOw9+pLwRK3A8SQMSzFtRnXH2kQIlVp2qdFVI+G+qvVXkZT6pc3KU1UGgpQoyB3HxjI4d7ie6UcIm+IA8tX2a5h8Uewv/qNsFVRXplTXh6OEHXAz9g1EO+z9xVsXBiPuqKqaes6aMtz+w7jUeoJhQj/nSGiCn/OD5P+Z6zF6qxiDpZKAJoKKggoxYM05hvyrnkKmekmI0U02PMmfAREqvUzfuuhAPgM6Q+eQD43D4qg4NAHk8A+4s2VYTPW9EabQR4j9USM42BUxL1UtwrTPZlDg93CN0ehyrvbGkuyc9v9kJKJ1rFTAaGQU/rNYJ2Z8QrlO9kPA7CpE36JQN4eVFNfBrCW5OGyKu0kxamHbIhwxa8+SILMgL7UkTmtIdqiFYA+vG72cQuTnHUkl11sSPLPyL9E+0rHN+RbTjaINChUB36vTye3HPxai9TRiRob41/Vf5
 NKu9Th3X
 F/QhgqluMc44/1tQTx1dcMJ6mjJhsAjnddD3IFFVwQJqesJN+SGwT+vc3J4wxcGjeA+vK38Acokbbq2rFvx7M8ChTcyTQxGK4RU4QLXiy+4Qhl8uuuEhKFjzVHBHtqCDhFNrhkF7HFW0rv1yt5DFaPIbmX8i3vqF8gAHDY1EI9770qwdgw3JkkuE36GG72iIJ4ucbp4dAXLebNl/1+VG9CSDNsD3yiiuLqv61lWLh4jdDxLtaFgJug10DZnfudUxeyR9FlDir6Bx6i0mRI50G7ImYvLOWtlVgNKQNlVvxERHlGjMtL+rROsyMWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/03/26 9:44 am, Barry Song wrote:
> On Wed, Mar 11, 2026 at 7:32 AM Barry Song <21cnbao@gmail.com> wrote:
>>
>> On Tue, Mar 10, 2026 at 4:34 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
>>>
>>> On Tue, Mar 10, 2026 at 01:00:09PM +0530, Dev Jain wrote:
>>>> The ptes are all the same w.r.t belonging to the same type of VMA, and
>>>> being marked with uffd-wp or all being not marked. Therefore we can batch
>>>> set uffd-wp markers through install_uffd_wp_ptes_if_needed, and enable
>>>> batched unmapping of folios belonging to uffd-wp VMAs by dropping that
>>>> condition from folio_unmap_pte_batch.
>>>>
>>>> It may happen that we don't batch over the entire folio in one go, in which
>>>> case, we must skip over the current batch. Add a helper to do that -
>>>> page_vma_mapped_walk_jump() will increment the relevant fields of pvmw
>>>> by nr pages.
>>>>
>>>> I think that we can get away with just incrementing pvmw->pte
>>>> and pvmw->address, since looking at the code in page_vma_mapped.c,
>>>> pvmw->pfn and pvmw->nr_pages are used in conjunction, and pvmw->pgoff
>>>> and pvmw->nr_pages (in vma_address_end()) are used in conjunction,
>>>> cancelling out the increment and decrement in the respective fields. But
>>>> let us not rely on the pvmw implementation and keep this simple.
>>>
>>> This isn't simple...
>>>
>>>>
>>>> Export this function to rmap.h to enable future reuse.
>>>>
>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>> ---
>>>>  include/linux/rmap.h | 10 ++++++++++
>>>>  mm/rmap.c            |  8 +++-----
>>>>  2 files changed, 13 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>>> index 8dc0871e5f001..1b7720c66ac87 100644
>>>> --- a/include/linux/rmap.h
>>>> +++ b/include/linux/rmap.h
>>>> @@ -892,6 +892,16 @@ static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
>>>>               spin_unlock(pvmw->ptl);
>>>>  }
>>>>
>>>> +static inline void page_vma_mapped_walk_jump(struct page_vma_mapped_walk *pvmw,
>>>> +             unsigned int nr)
>>>
>>> unsigned long nr_pages... 'nr' is meaningless and you're mixing + matching types
>>> for no reason.
>>>
>>>> +{
>>>> +     pvmw->pfn += nr;
>>>> +     pvmw->nr_pages -= nr;
>>>> +     pvmw->pgoff += nr;
>>>> +     pvmw->pte += nr;
>>>> +     pvmw->address += nr * PAGE_SIZE;
>>>> +}
>>>
>>> I absolutely hate this. It's extremely confusing, especially since you're now
>>> going from looking at 1 page to nr_pages - 1, jump doesn't really mean anything
>>> here, you're losing sight of the batch size and exposing a silly detail to the
>>> caller, and I really don't want to 'export' this at this time.
>>
>> I’m fairly sure I raised the same concern when Dev first suggested this,
>> but somehow it seems my comment was completely overlooked. :-)

I do recall, perhaps I was lazy to look at the pvmw code :) But I should
have just looked at this earlier, it's fairly simple. See below.

>>
>>>
>>> If we must have this, can you please make it static in rmap.c at least for the
>>> time being.
>>>
>>> Or perhaps instead, have a batched variant of page_vma_mapped_walk(), like
>>> page_vma_mapped_walk_batch()?
>>
>> Right now, for non-anon pages we face the same issues, but
>> page_vma_mapped_walk() can skip those PTEs once it finds that
>> nr - 1 PTEs are none.
>>
>> next_pte:
>>                 do {
>>                         pvmw->address += PAGE_SIZE;
>>                         if (pvmw->address >= end)
>>                                 return not_found(pvmw);
>>                         /* Did we cross page table boundary? */
>>                         if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
>>                                 if (pvmw->ptl) {
>>                                         spin_unlock(pvmw->ptl);
>>                                         pvmw->ptl = NULL;
>>                                 }
>>                                 pte_unmap(pvmw->pte);
>>                                 pvmw->pte = NULL;
>>                                 pvmw->flags |= PVMW_PGTABLE_CROSSED;
>>                                 goto restart;
>>                         }
>>                         pvmw->pte++;
>>                 } while (pte_none(ptep_get(pvmw->pte)));
>>
>> The difference now is that swap entries cannot be skipped.
>>
>> If we're trying to find `page_vma_mapped_walk_batch()`, I suppose
>> it could be like this?
>>
>> bool page_vma_mapped_walk_batch(struct page_vma_mapped_walk *pvmw,
>> unsigned long nr)
>> {
>> ...
>> }
>>
>> static inline bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> {
>>         return page_vma_mapped_walk_batch(pvmw, 1);
>> }
> 
> Another approach might be to introduce a flag so that
> page_vma_mapped_walk() knows we are doing batched unmaps
> and can skip nr - 1 swap entries.
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 8dc0871e5f00..bf03ae006366 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -856,6 +856,9 @@ struct page *make_device_exclusive(struct
> mm_struct *mm, unsigned long addr,
>  /* Look for migration entries rather than present PTEs */
>  #define PVMW_MIGRATION         (1 << 1)
> 
> +/* Batched unmap: skip swap entries. */
> +#define PVMW_BATCH_UNMAP       (1 << 2)

Exactly, I just also came up with the same solution and saw your reply :)
We can just name this PVMW_BATCH_PRESENT, the comment saying
"Look for present entries", and fix the comment above PVMW_MIGRATION to
drop the "rather than present PTEs" because that is wrong, we are currently
also looking for softleaf entries by default.

> +
>  /* Result flags */
> 
>  /* The page is mapped across page table boundary */
> 
> 
> Thanks
> Barry


