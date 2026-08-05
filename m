Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B92E6C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74CB6B00A9; Wed,  5 Aug 2026 03:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C268E6B00AB; Wed,  5 Aug 2026 03:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEEE66B00AC; Wed,  5 Aug 2026 03:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78C136B00A9
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:27:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 027E71203BD
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:27:16 +0000 (UTC)
X-FDA: 85066384914.09.DCBCD68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2B4E2140004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:27:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y+v/98Al";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785914835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLCEDMEWoRWDPyfIvG4ZyZLFV2PRUJ/ex0Ur9410S/I=;
	b=yrz/VYEuncAsqF6sqxyL5gaR3NbLIxZkVbjwlt7RH6iM+yIgBIVii1kVTvTZtnuXsWbAFE
	XLxuyLPSsSArHCVYnPZPc3hj1I2fhuYXkpqAzs6x3gL6RY9p8dEh8aUaJnj/lThP7zgvrP
	ZDBpj2eTeFPQ7GiBmPIo4Y/MIfzmTEI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785914835;
	b=vTjOlvZVz8ePeAB85wf4O8uICFuCUO+NmaYDpFol6RSwEaTGl6SciuKgEQVje2uda5/XAg
	Q8IrubtG7mpJ92SCwrqk7ZdjXmg64g45iZLpNWYYeQzDL3tBPEf18APEwAwCq2cMO1Phnd
	rj1ShwRdqNKfybV28u3pI36h7FJ7fQk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y+v/98Al";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15E81402EA;
	Wed,  5 Aug 2026 07:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08831F000E9;
	Wed,  5 Aug 2026 07:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785914834;
	bh=kLCEDMEWoRWDPyfIvG4ZyZLFV2PRUJ/ex0Ur9410S/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y+v/98AlrzRsVa+G/E+YOuw9MyvNxHaK7U8nTX8z9IaaR9fbUg62QVfb+weIf50pU
	 R+ITkdhH36uOj9CdpupgW3NYmI+WZQ306cvkxQZiUKBXSiJwcJwDBrwJJvUz9hfd/2
	 baSwFxoPR8uinfUSut7f7pmhKbvKDujtKQL4rMl6N1Gn/sLMpLYpbDt403w9nk96WI
	 NeqmRnldtJTWIyPFLaCpb38J0LT5AgEtGzNz6oJt1tkJSzzZfeNoPnH68crx911xCF
	 OaZ1CQCxp1/8WBgkyEYtrJsiawcSViajjWWsUick2CO15YzILgU/5cudI/TZ9KXzxR
	 rJeNH7Bp4b0og==
Message-ID: <784eab3a-2b37-476c-a6fc-7fb6e27b6c66@kernel.org>
Date: Wed, 5 Aug 2026 09:26:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/15] mm: introduce and use linear_folio_page_index()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-8-e8ecfefea812@kernel.org>
 <0d9f3040-825d-49af-9d07-1e7945dd3e9d@kernel.org> <anCdkHNmG5K43E6l@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anCdkHNmG5K43E6l@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2B4E2140004
X-Stat-Signature: qmd5dg56xwtg1x5mmc4txsf8sz5m4i9p
X-Rspam-User: 
X-HE-Tag: 1785914834-904559
X-HE-Meta: U2FsdGVkX19/KCuudWvqJvIqOj/ItDXqgJDcUhmeTI8x0/cujl7c7Y0C2oW3FCg6YTebf4ypUUco/DASip0izOWZPNm0nG4xs4JljOfopMW6Dnq8wFAdTIdsBv7p3G4CsGpdgJdAIvpueGW3CBKhB++OZO5Thhp+PCjOMCUj4IugWG8LRC3vggwd32n3fsLIjLXmxCROLsCGTsVdwnp3+S6CUAhJz1Fvw18jVQiaR213uWKzmvPdHZjqUCZ0ap+x2iCSVyou4mHFlplI1VRX9PscmszfVVWpnbS1KNdg0sz+nc4yZnQqggDnpXywT/IFuieHdc7ZRV2ght2LlXSGSkc1a93NkIJZMD/8BljFGbj9zYSYCjVIUuFre4P1/jk0HmKTwCRYY/9Wq7+NbvFasy2957b9PzMXNnteOPpHaVJhhVLqfuzB76N1y2Y1QB4z7E6vvvDMi/Z3DmAauRD/rMtAySfCqIKL322horDhd9oGo+I5yUaVBxXahSC21a0nQld5JvAON8GvzIoFvImDkEzIEoXvGqvnyETts0gR6O08FDl2Vuz6VV0iXRTekG5PnNue/IERST2ELH3vrWoWF+aSnn0lZnlBOVEyLOvIQFfH5pSdqC/kBDLpFm3uN66R/6jv+ka1g+cUso+sTOZlO852a0QyqLyVYF6U/XTHYLWbewDVSrYwSq6x9zPNLYQIJ17YWKvmrFVHWNTuMgJAhnDrGjkuu26/P3hnHIdJmDAxsVT2bfWuT50Bo3QHO+ftv8IwfWdGaIandMkkCn5UDNSAOvKtJCZxzXsrrBz5N/atNhzCDe+Xf9NW1gpfmyJZ11loqcKI3HbcB3ie4FfQnrPWPhqQ90stWMwV8RiQ1zrZMTGdG7U4+fbOcZ+oGvqzE8GhTzjYBJ9Q6gEU7/VdBkZA/O3IMOL8p0ZO6TLrqmuawy4B1+CCejOjesTuAMb+w7a2D1vsIb8VYyudR87
 U2Kyql6i
 IazJD0m3pyXmLO7DiGguDbkwpUs766Yv/FXOLUK6WcEQegp7meiU6L3e2PQ890b5XLCBY3NJLi1mCB4E2L62ypWOD1cJCqdrOnEj1BkJ2XsMhWTlLXBivUqDhk+uwAzEmFRMeih8JVUGPd6KRrcM/hw9IJZPt6GvP+P6Vx0TFLlSuxGdsSQQi07tC5nQ4d/YHphkSsHjz+c00V9PAG0lYZCeN4AYwxfnIKsbEAwZovoFhd24gQ/tKoJvgy/Jirn4toy31Hhg2oZcY3pAeDipvN3VKMlpo9iD4edNaeGxzQ3tx/NXGCzieDfrdqyT4sBgPBYK2iRj2kHAu7TwbrkwXBJEqxcTyB2Npq1KvnM8pNaNlSNF8/YweieO0+sw+2kCqNF7SQDMsy8JI7SElVgyzz1ew9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 16:30, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 01:27:09PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
>>> This function is, for now, a placeholder; it will be used in future to
>>> determine whether to use the anonymous page index or not, based on whether
>>> the folio is anonymous or not.
>>>
>>> Currently it simply wraps linear_page_index(), so this does not change
>>> behaviour.
>>>
>>> We update callers that will, once the change is introduced to track
>>> anonymous folios by anonymous page offset if MAP_PRIVATE file-backed, need
>>> to determine which index to use based on folio type.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>>  include/linux/pagemap.h | 18 ++++++++++++++++++
>>>  mm/huge_memory.c        |  3 ++-
>>>  mm/migrate.c            |  6 ++++--
>>>  mm/userfaultfd.c        |  6 ++++--
>>>  4 files changed, 28 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>>> index 259177544b03..6eb8d811ba4c 100644
>>> --- a/include/linux/pagemap.h
>>> +++ b/include/linux/pagemap.h
>>> @@ -1143,6 +1143,24 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
>>>  	return pgoff;
>>>  }
>>>
>>> +/**
>>> + * linear_folio_page_index() - Determine the absolute page offset of
>>> + * @address within @vma from @folio.
>>> + * @folio: The folio whose linear page index is sought.
>>> + * @vma: The VMA in which @address resides.
>>> + * @address: The address whose absolute page offset is required.
>>> + *
>>> + * For compatibility, currently identical to linear_page_index().
>>> + *
>>> + * Returns: The absolute page offset of @address within @vma.
>>> + */
>>> +static inline pgoff_t linear_folio_page_index(const struct folio *folio,
>>> +					      const struct vm_area_struct *vma,
>>> +					      const unsigned long address)
>>> +{
>>> +	return linear_page_index(vma, address);
>>> +}
>>
>>
>> I found this to be rather confusing, given that we now have a "folio" helper that
>> receives a folio and a "page" helper that doesn't receive a page ...
> 
> This is just to avoid having to duplicate the if (folio_test_anon()) { ... }
> else { ... } stuff.
> 
> Agreed it's a bit confusing!
> 
> Really you are figuring things out from (vma, address) - 'what is the correct
> page offset based on the VMA'.
> 
> And yeah it seems migrate can do it via PFN as you suggest, it really is
> just trying to find the page offset in the folio.
> 
> But...
> 
>>
>> I guess the problem is the "page" in "linear_page_index", as it
>> reminds of legacy page->index.
>>
>>
>> I wonder if it would be better to have a linear_folio_index() and
>> force that address points at the start of the folio.
>>
>> Looking below, this is exactly what we want for all except one case:
> 
> ...I don't think this is true.
> 
> The uffd code uses this too in move_present_ptes():
> 
> 		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
> 							   dst_addr);
> 
> And it's now _updating_ the source folio index to the offset in the destination
> VMA, so it doesn't even relate to the source folio's offset at all?
> 
> (move_swap_pte() calls linear_folio_page_index() but obviously has to be
> anon, so that can just use linear_anon_page_index() there instead, will
> update.)
> 
> With your change we can just eliminate the linear_folio_page_index()
> function and open-code the uffd case.

The would be even better!

> 
> It's a bit of a special case anyway and is neatly the one place where you
> actually don't know if it's anon or file-backed (well anon or shmem
> specifically I think).
> 
>>
>>
>>>  		/* pgoff is invalid for ksm pages, but they are never large */
>>> -		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
>>> -			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
>>> +		if (folio_test_large(folio) && !folio_test_hugetlb(folio)) {
>>> +			idx += linear_folio_page_index(folio, vma, pvmw.address);
>>> +			idx -= pvmw.pgoff;
>>> +		}
>>>  		new = folio_page(folio, idx);
>>
>> I think we could avoid this index work entirely by using the pfn, which is much
>> clearer to me, and similar to how we handle it during other rmap operations.
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 222c8c15f782f..686351d353203 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -362,17 +362,12 @@ static bool remove_migration_pte(struct folio *folio,
>>                 struct page *new;
>>                 unsigned long idx = 0;
>>
>> -               /* pgoff is invalid for ksm pages, but they are never large */
>> -               if (folio_test_large(folio) && !folio_test_hugetlb(folio))
>> -                       idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
>> -               new = folio_page(folio, idx);
>> -
>>  #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>>                 /* PMD-mapped THP migration entry */
>>                 if (!pvmw.pte) {
>>                         VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
>>                                         !folio_test_pmd_mappable(folio), folio);
>> -                       remove_migration_pmd(&pvmw, new);
>> +                       remove_migration_pmd(&pvmw, folio_page(folio, idx));
> 
> I think we'd need the idx code below to go above where the idx code is now
> as otherwise this will be incorrect right?
> 
> But then again, if it's a PMD softleaf it'd have to be aligned right, so
> couldn't we just update that function to be passed a folio instead and
> avoid the idx here at all?

Right, that's what I mentioned below

"remove_migration_pmd() will work for now. Later it should just receive the folio
and do the same thing through softleaf_from_pmd() -> softleaf_to_pfn().

> 
>>                         continue;
>>                 }
>>  #endif
>> @@ -385,10 +380,14 @@ static bool remove_migration_pte(struct folio *folio,
>>                     try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
>>                         continue;
>>
>> +               entry = softleaf_from_pte(old_pte);
>> +               if (folio_test_large(folio) && !folio_test_hugetlb(folio))
>> +                       idx = softleaf_to_pfn(entry) - folio_pfn(rmap_walk_arg->folio);
> 
> Could actually be softleaf_to_pfn(entry) - pvmw.pfn even?

Given that DEFINE_FOLIO_VMA_WALK() sets

	.pfn = folio_pfn(_folio);

I think so.

> 
>> +               new = folio_page(folio, idx);
>> +
>>                 folio_get(folio);
>>                 pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
>>
>> -               entry = softleaf_from_pte(old_pte);
>>                 if (!softleaf_is_migration_young(entry))
>>                         pte = pte_mkold(pte);
>>                 if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entr
>>
>>
>> remove_migration_pmd() will work for now. Later it should just receive the folio
>> and do the same thing through softleaf_from_pmd() -> softleaf_to_pfn().
> 
> Ah you already addressed it. But since this would move the idx code above,
> I think I should just change it to accept a folio instead?
> 
> Or for less churn &folio->page...
Right, whatever you prefer.



-- 
Cheers,

David

