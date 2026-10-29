Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585FA606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OteUheN2
Received: by kanga.kvack.org (Postfix)
	id 77D8D6B05C0; Thu, 29 Oct 2026 10:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755AD6B05C1; Thu, 29 Oct 2026 10:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66C666B05C2; Thu, 29 Oct 2026 10:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0786B05C0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:24:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C23D71C3A3D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:24:49 +0000 (UTC)
X-FDA: 85375885098.20.98F9CC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0B6261C000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:24:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OteUheN2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793283888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxkkcfsluS6d+NVCz2poz3Y5Si8QKMa7Ic0pVGQHkyk=;
	b=KegkKdgDl08N1sVfat6zfqnOYrqZry5VXUMkxUk/nc4IDMpEu1uJbTVUUfnv8lR58KXIO4
	1wEaBZVao39zBYh8aqvNF6S23nk7QLgHFFAgh6O3m1pkS3I69tteRA9fvfj2l48eiSnm7V
	N4niLNJ7DTV6IspsQzl1UzxQ6J3bzVk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OteUheN2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793283888;
	b=8JT1FhlD5pPTAlAyqG8d/nF+OOCdsKHeKn2nzfZEgWnCE5LcIKzRgSG7JTHTTzELfRcFzO
	f89M22oeXx6CGRiRNOgUM27RD51OfiFIkuYIyxjumsvxoaHOZ570CGkDLNCqtI1pH0l9oM
	iGlYAYzNIsXdQ+7CUI9Y2XcAcCcg6YM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90152601F8;
	Thu, 29 Oct 2026 14:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE3F1F01825;
	Thu, 29 Oct 2026 14:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793283887;
	bh=SxkkcfsluS6d+NVCz2poz3Y5Si8QKMa7Ic0pVGQHkyk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OteUheN2B32bcN/9f5UfOzNiidLI5B9Hm8n+cfKENxQbbyPjAfgEMmAWpOox7ULf9
	 ADd38P2P44AqXSb4hgJKIJJDlmNn2Apmwre5vkrE6g+eEXgL+CVK/idHVFGO+OtJkn
	 t6RxcY2eYwnapJ5IuPh/5zax4sVLJj3IEFkePyURCFjWkkAQqrNgdgffbKpO9oqgb/
	 +PQosj7oDILNllKB6L2+ZbiVwSryf1sa9VQDCaS+zZZUTej5L/1oj3MuBsIRhtR2U2
	 00APFSv+H7Z5hunV3cf6MkVbD6jPPuCCb27PyQXie7gQ//fYDIyQmQXkEjiGBxEWVY
	 L3K14QXYNVLzg==
Message-ID: <9f4128a4-85fc-4f4b-ac41-b9d348f56e37@kernel.org>
Date: Thu, 29 Oct 2026 15:24:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 42/46] mm/huge_memory: split huge PUDs when adjusting VMA
 boundaries
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-42-6f74bec9a5bb@kernel.org>
 <auMxQPze5cOvGbCe@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auMxQPze5cOvGbCe@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0B6261C000D
X-Stat-Signature: wujroak61f4pkt5xhqoqo9hi98zonia8
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793283887-522183
X-HE-Meta: U2FsdGVkX19JBzL0t/GC3dUAaUDs/pd3+elGe2Uzay1EQKEWaqjJeNSmtvejip9QGVyqkBBTG2y400vbMxDlw4myjxUxiH+O8FwL0gce1DGC1PKi4nsaiiDITWaoF50e6ydcFHVNU0OmPIUZ7FeVRgASw/MuOPGSHE3Mxsr2ceOy5WnABNdNe1i6x+fi+0r5/a6ejbL30wWZ5177S72Ur2Kmy9Vajai+Ih0dlMd5LH36lD0CAGV5F2QFJbKLLDmQxpLTzd4Bm/Ug9rK0eP9jewV0KBGAW/hhCPfNbbEmtCSuWKHhUfwSSLWmwe2XIPaq+ZW6KLQBTGABM6eMQmk3GB5yDGjy+BNrlav7d0rq/XB23RRVDxDMI8535ApEIgVeFjnwbhinmPsc6uO1Z2NaLaFHH34y2IEYKZZPYSwP7VSxAzQKCNaAB6Q5Ro+aEd+igdJQxCP7eo5FvOuO6L96AiD5y9xBeE3QfBQ15rzpZftYkmvCGAhCvjgKA2E1EGlKiZ17iowzFWLGM873vJU43P1IWd8olsWwZO5y8/QOZR18pxUytb8N56TVJgzfqQCqQFL1zNy9yEamYQQ/2+mH7DDUIfoxDwx/Evv5egL7OzzPJ4Yz5L0LQfoIJOknCIH68pivYRF3KMSc3j41uEyjgTI7cQCpFv9M6xnUZSA1nzQJDWUaNCHkAo6bPSvUQC/3jSo9xfAgu5m88lv4GyeqiKePXvuajdDWKlhLQVS7vBKbti7kdnKv1+GJek88kgXfkCZQI+HFSnDhNVdUZndhP5T66F6N+cVZiWFcRYDfqGW0VltoXTPv0mjV+fNOFcNJERm14rgIc6arjN5+OOj9ktZYQ+ZJLElDLhTXfhREBlKtyBTg+1sLw5PCslT3IghR5lALINQMq8TAOYvHGqWF+YnvvaNzNtD6D2ZghfLKVFRYVLvjj/RdUHUpA0nyVAeTID5l4CaM9WhupVyQu0h
 ufJfDyHf
 GxDixJChclilm/y6H4J2c3n6I1wKRbQnZS83xO107aS230XK8LaL0fv2QZIiCtxDoYcGvMIJEHZMdsUTPIR0IRAXJmAwpPn57m5kPm3XXsz/2MoMO1phvBYjRhcTwGe3C9q7zc5KuUZzcGKu3UJ1FPwX4TP7NkZXfqOnrwAIsxCP2/HxsejUhvK5Bj9zgXrlI3PI/rGZ+eoCqaaQwNeLZxyfVkjU6hyZex+F/QLlRDf6GfaMC1xTIq1AWpq8uPsZMkw9k9Wj0OD7wo/oM1l+3VHlKaWCOfsRqLp1sIXM2jF9Ff1QLCFwRPD6QsJ2/AQQ0KaNjNUSB87EdIJiHbUjwcedOEmWyttMs4PuJmk3LIPpxlj+K0vWh/tCP0kNKq4Xo99Ae9Sg1Iko1y2RnJTbcWdD+7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 12:45, Kiryl Shutsemau wrote:
> On Tue, Oct 27, 2026 at 12:18:02AM +0100, David Hildenbrand (Arm) wrote:
>> PFN mappings such as VFIO PCI BAR mappings can use PUD leaves while
>> allowing VMA splits at page granularity. However, vma_adjust_trans_huge()
>> only handles PMDs.
>>
>> After faulting a writable PUD-sized VFIO BAR mapping, changing its first
>> page to read-only with mprotect() makes the PMD walk treat the PUD leaf
>> as a PMD table. Applying MADV_DONTFORK to the first PMD-sized chunk leaves
>> the PUD spanning two VMAs: the PMD-aligned boundary skips splitting.
>>
>> Walk the page tables once at each adjusted boundary and split a huge
>> PUD or PMD leaf as needed. Handle PUD leaves even when the boundary is
>> PMD-aligned.
>>
>> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/huge_memory.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 60 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 08e58cda7d37d..d090642ac8c2b 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3503,16 +3503,66 @@ void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
>>  	__split_huge_pmd(vma, pmd, address, freeze);
>>  }
>>  
>> -static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
>> +static bool pud_split_required(const struct vm_area_struct *vma,
>> +		unsigned long address)
>>  {
>> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
>> +		return false;
>> +	if (IS_ALIGNED(address, HPAGE_PUD_SIZE))
>> +		return false;
>>  	/*
>> -	 * If the new address isn't hpage aligned and it could previously
>> -	 * contain an hugepage: check if we need to split an huge pmd.
>> +	 * Only selected VMAs support mapping PUDs for now. Lift the
>> +	 * restriction once this changes.
>>  	 */
>> -	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
>> -	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
>> -			 ALIGN(address, HPAGE_PMD_SIZE)))
>> -		split_huge_pmd_address(vma, address, false);
>> +	if (!vma_is_dax(vma) && !vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT))
>> +		return false;
>> +	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PUD_SIZE),
>> +			    ALIGN(address, HPAGE_PUD_SIZE));
>> +}
>> +
>> +static bool pmd_split_required(const struct vm_area_struct *vma,
>> +		unsigned long address)
>> +{
>> +	if (IS_ALIGNED(address, HPAGE_PMD_SIZE))
>> +		return false;
>> +
>> +	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
>> +			    ALIGN(address, HPAGE_PMD_SIZE));
>> +}
>> +
>> +static void split_huge_leaf(struct vm_area_struct *vma,
>> +		unsigned long address)
>> +{
>> +	const bool split_pud = pud_split_required(vma, address);
>> +	const bool split_pmd = pmd_split_required(vma, address);
>> +	pgd_t *pgd;
>> +	p4d_t *p4d;
>> +	pud_t *pud;
>> +	pmd_t *pmd;
>> +
>> +	/*
>> +	 * mmap, VMA and rmap write locks protect the walk; the split helpers
>> +	 * take the page table locks.
>> +	 */
>> +	if (!split_pud && !split_pmd)
>> +		return;
>> +
>> +	pgd = pgd_offset(vma->vm_mm, address);
>> +	if (!pgd_present(*pgd))
>> +		return;
>> +
>> +	p4d = p4d_offset(pgd, address);
>> +	if (!p4d_present(*p4d))
>> +		return;
>> +
>> +	pud = pud_offset(p4d, address);
>> +	if (split_pud && pud_leaf(*pud))
>> +		__split_huge_pud(vma, pud, address);
>> +	if (!split_pmd || !pud_present(*pud))
>> +		return;
> 
> This looks wrong.
> 
> We should bail out here if PUD is was a leaf and wasn't split.

__split_huge_pud() must split a leave. Either by zapping it (what we do right
now) or by populating page tables (as in Usama's PoC).

We can throw in here a

	if (WARN_ON_ONCE(!pud_leaf(pud)))
		return;

But I don't see how that would be required.

If we run into an un-splittable PUD something else is completely messed up.

(this is not hugetlb code :) )

-- 
Cheers,

David

