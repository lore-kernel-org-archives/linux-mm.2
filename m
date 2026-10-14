Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E23CC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2166B008C; Wed, 14 Oct 2026 04:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7897B6B0092; Wed, 14 Oct 2026 04:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62AE66B0098; Wed, 14 Oct 2026 04:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FBAE6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:04:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A80374045C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:04:55 +0000 (UTC)
X-FDA: 85320495750.15.833BB11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E8586160006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:04:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GtJFiXxs;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791965093;
	b=hYLJWiECSJbNCFgxFDLiJxDyU9oLPt7BDG0LkqmOpKvIhofIYhTgQSHw+g9Pkd9WaL/tRm
	4QCV6FjOYrLwy9+hcj7WYt0FMQaKRDOCfbhvfzyViaqWbcahM6h5LSEseno0HtW2xmh7GD
	8A2E/MxT7v5Pigj5MR7GQzh2VM41Rww=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GtJFiXxs;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791965093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiKsa8Ig/ghze008rN6845jhkYU7VXnQAYeoEEL06go=;
	b=HKP1RorWlo8T5WJpj28VzPIT2s+3YFNHPAw14D3s563eMca4SAXC3jZhDqiAg97M1UyKZb
	FVvL7iWTOt1pmh3sh2muZUfts1gnVa7wdKLgH2LV0ImNNX28eR/TDRjHR9xhUkprr8y8yD
	D8r20FdPe9Wl1jhy/G5E+LNG5Z4yDYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B18760213;
	Wed, 14 Oct 2026 08:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66851F000FF;
	Wed, 14 Oct 2026 08:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965092;
	bh=QiKsa8Ig/ghze008rN6845jhkYU7VXnQAYeoEEL06go=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GtJFiXxsKGSlfzuWOthSOmfiQNpfxaQlI6bcx/fGTgscsjDFyaWqjcLhYlKL7TJBp
	 LtEekQF1iHC/qWP7/p/Cvfv2V2fqzXuW9ocLWw81yMIuU1nRSpDLn6mKXb83C8dLHf
	 QaV9TwNonCKDkqqQWHJytB9y8f55GBeK7DSt0VR54FyE7me9TTeWSuUpu4e7VWDn05
	 xC97kkjWLQly6dLxK1jQz7qt/H49gyBY+1Ap7nHrjTg/6gW67abb5GCNqYSc1Xincc
	 QfcSi1KUxTtV4BEnNV5EZ3hLmLINjB3InKbnq+0pljhDs3f51ctnVE8KzD789Lkl8n
	 Bi4twOLPHRBbA==
Message-ID: <0cc60b43-eae3-4264-87a2-1026490177e3@kernel.org>
Date: Wed, 14 Oct 2026 10:04:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Chuanhua Han <hanchuanhua@oppo.com>,
 Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
 <as4qKLx_XwQ6qY3p@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <as4qKLx_XwQ6qY3p@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E8586160006
X-Stat-Signature: pxtp1g7qo1infh1uhoo9yg6sho75edg3
X-HE-Tag: 1791965093-717884
X-HE-Meta: U2FsdGVkX1/AgWA7GU1tRmxtqGdPo/I+U+9Y+Ya1XSgI5/vwDvAAsyqtdwCnpb6rNsPebLQyUGW83i51cQUNHdCV5CiAa5N4ciuremFJdl3apoEnurNcmfvPq21G7zmEN+AQjixvkiGmySTexoyT3zd+lDDTeL0lEHE1mzAyp0qa3y6SlsceKmtIzDtmZQGiFbfFdW6vNBjYUp5LQz15TQb1pZ2L9UoQumTTN3n/U8HICrHXHN8q4LZtQgP0VMG1tNSmFLOWwgQvTyNdRxwdkLHSLTjEHqo3R3lwehyKINDiix1+fH6l3lCgcN6NaXQbvpkMSKlhJVy11ec+VFm/CBTbmUUD9cAoPvavdDbHIEJX7Cjw8RvzcK92ZHvUXD31ZgT3N5SkiQa81BT2JjJIYdfZ9W3xAn+zflmXvmHmXdNU8MSGjTT5yBaMcuz3DyAbs2nYcx3FcskOCn1S84B7T11RNvBC7KG69nHxeq6Mpk/b/ezPk0TdB8Ja2hH7IasG8VfAQwa+e1xSNofxa3P/WyB+yvyCL/vxo/U1YEvYuB/EFwKbdoJoFxb+oa0xVnTweB/28zI7YS4+sThmaY/ztssm7gNsczQ+sTHgWBimuiK9RYDkqBd6xwGWSqRcmtKY6tLcx0+l1i1hevzHqVu5Phwolxv4BlKdBCh5h2kEa3qYojQnxJ/NwzKq+cnZr0L9fzxbC0BcJxg8JzO+CJgDA2R/T9E1mo0McRL1PBVeA5XnAgCz8KUcLO3oaBIlQ5aQSnETswE7MiRu4gTKFnB+j0hxui4gBEw/vpw2aAPWHI4JlfGXQSGPclc1PT292ES6DvcrJf4I9uowc5exzaKOVONhW1KiCsxze+bz/jh3XdU1aqTE3kdee8+BU9ZA95ozSo8Zg2vuHnGhe7mUyTzbpHCYNbaO4O7ELpv6rVPyIWCUXxmMGWSlPsmzvd61g6KuQEeDpH8ssD9v7xYOJzq
 obrkeZCC
 MdL0lXGuOIhuJhMvFOAzS1lF4kVjhFcODDFHwX5UABHMQQqceBUZN2j0014kZRarkgHoAq3c7a5c2nfkVlp7lfYY72ANS+8LlagmBFkb63xO8W+smB65eRvMPo8Ff+AjcsiEgjy66+wb5gyIlL3wyRYXIYtaGrNMyhr7rcSpI7G/POF6zUYyj33Czs+3l0qYL0YWW/oC8VY8OayMibkAY8e9d2vzRumxiiMnUvgO2Ip3aHDqXW2QcPJKv6xsZPz095ydavh2tow5p56pYN0hts48l1YusXXJE59qi+q2CB16GWmOuG7x49a4c3mrnD2JkaIZo4gFBeDl22eS5qNgEolRMDJgb6xHAjEyMh+rAG/K+BHVfOIKgbugg9VH46nCy/bMY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 14:57, Kiryl Shutsemau wrote:
> On Tue, Oct 13, 2026 at 02:30:37PM +0200, David Hildenbrand (Arm) wrote:
>> numa_rebuild_large_mapping() and do_swap_page() can be tricked into
>> generating an address wraparound, crashing the kernel. All that's required
>> is to map a tail page of a large folio close enough to the start/end of
>> the address space to e.g., make
>>
>> 	unsigned long addr_start = addr - (nr << PAGE_SHIFT);
>>
>> to wrap around.
>>
>> Let's fix it by providing a better helper, folio_pte_scan_range(), that
>> takes care of staying within VMA and page table boundaries while
>> handling possible wraparounds.
>>
>> Reported-by: Kyle Zeng <kylebot@openai.com>
>> Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
>> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/memory.c | 43 +++++++++++++++++++++++++++++--------------
>>  1 file changed, 29 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 1f5d5f7d39cd2..a3823010aa981 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4933,6 +4933,27 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
>>  	} while (--nr_pages);
>>  }
>>  
>> +/*
>> + * Get the address range in which a folio might be mapped, assuming its pages
>> + * are mapped consecutively and the folio page at the given idx is mapped at
>> + * the given address.
>> + */
>> +static void folio_pte_scan_range(const struct folio *folio,
>> +		const struct vm_area_struct *vma, unsigned long addr,
>> +		unsigned long idx, unsigned long *start, unsigned long *end)
>> +{
>> +	/* Stay within the page table and VMA boundaries. */
>> +	const unsigned long pmd_start = addr & PMD_MASK;
>> +	const unsigned long pmd_end = pmd_start + PMD_SIZE;
>> +	const unsigned long lower = max(pmd_start, vma->vm_start);
>> +	const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;
> 
> These -1/+1 gave me a pause. I guess it is for pmd_end wrapping to 0 in
> the top PMD? A comment would be nice.

I'll add a comment if I decide to leave that in as is, thanks!


-- 
Cheers,

David

