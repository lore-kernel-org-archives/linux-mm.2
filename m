Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18235C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1106B009E; Tue, 22 Sep 2026 09:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53B46B00A0; Tue, 22 Sep 2026 09:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942F76B00A1; Tue, 22 Sep 2026 09:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 663E96B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:18:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 001681A046D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:18:46 +0000 (UTC)
X-FDA: 85241453094.17.FA56838
Received: from mta1.migadu.com (out-63.mta1.migadu.com [95.215.58.63])
	by imf25.hostedemail.com (Postfix) with ESMTP id BAF8CA000D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:18:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=blm2aYEg;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.63 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790083125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5gTFdP1jPsU2Elav7GHTxAdITz3iQ0LqafijB0zVD0=;
	b=wuREtGlhH7HG6sbl+1Qw/YH6DvbPPpzpgIgl7XcDqfArhkSSd+rzNNnNmy9wS0idXCeSXc
	5N2B55D5EIW4mDET3A/f8jiQx9lA0G+hp9MMtZpIdpTrqEqU+5JHreIm/Cu1qPiWJhNqZH
	IjzWL7+Vq+FU1YWxErd2MDP86a91uS0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790083125;
	b=eDGw6Ih69Nt+MsuILpfvC0Etd4nYn0y4xvo7Jc8QKkaNJBDn1h/7Y/zIeopfQB3lZ2wxkA
	L2Hr1ofF8PU2WX5LWLJbaJ7xke2OOZPzaWGpbijdqUiepx1q5GRB0M6LrHZ6Wi6U5dp141
	ub483A6OlswOlkyewgn5yi2Vx/+xrpg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=blm2aYEg;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.63 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KnQFWOHI/uWFbK2yV+XgO5ozKy20KZ6FFsL/eg8FxkY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790083123; v=1; x=1790687923;
 b=blm2aYEgSSnRIIRmIgSJEqGAZggbaZPSy/vPCO5VeEIyNmgezy68bnnUfYrNHkX7eKAmJofp
 cLdJPyQ2S56Yc6ryQwqkebxqVem1Z2W6kwQ09UiVjooPS8Zl4AffRlRbBdR7BPTV48UdMjOIJBd
 32+4N2fBcrFySyLv4u0QRXBg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 855e594509f545e4;
	Tue, 22 Sep 2026 13:18:43 +0000
X-Mizu-Trace-ID: 855e594509f545e4
X-Migadu-Flow: FLOW_OUT
Message-ID: <17c88cf7-61d0-48f6-bc94-773b3662122c@linux.dev>
Date: Tue, 22 Sep 2026 14:18:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 11/29] mm: split PMD swap entries into PTE swap
 entries
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-12-usama.arif@linux.dev>
 <aqqwFOoPxqFnxclE@thinkstation>
 <4101d661-7b16-401c-aaef-b87e81fdaee3@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <4101d661-7b16-401c-aaef-b87e81fdaee3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BAF8CA000D
X-Stat-Signature: xpteh6xi4g1am3qm81rx3dgeo8hcgfky
X-Rspam-User: 
X-HE-Tag: 1790083124-609795
X-HE-Meta: U2FsdGVkX1/TgNgT/kCgxsHisPY7dX0+Mjr6s+LS0HVxZR5gu6cn08iCESI4ryurI7PbMaCV3HipUZPay+ziQNj8jx0VkLeI5wZjTahmh3aMrawV/F4CZbgK5Nr1TV3L1kfqg6sDYNkZ4FNDOe7M0XPXoaX56P5SNfTblNpmAX2OMLKlgQvZjxLAEKeMAY3PBgT2CC2C2mkwg8yvfAvLMGBL+a9w6wIKKW2Ow+6rhYQ49JvbPHxIgwoV+vn/bGjWswteGqnWR2zWdiSDa2xNLqPwboukmmMSPx15hCXbEYmlNb6eK40j/CxPV0cEnCQGTjvpqU5zR56pFnukmu+v/4n6+yyANiOMScZieUp6g0IB856GSZch8jxjLDAkXRX2e7EX15ZQh/1kazJt+7BFbiH5ofGuJYjQRtCE0K32LH7MR7wGvh01HboPzn6+dnDjpx2qk8WNRCx7RbXwTwN+wkzlxZQnooNeKsiJQFMUQ+KTysfRfSnpJu+0B4MbJrdSzr6oOGXzt2gxlkPR4hZDP85fArUkppvUiejKlHhqriaztSkr6QvtoKVoFGF7JVm1LIX47f1lU4Byy9FueXk+UVKLkJcoqzLg5hhhcSGnpELzJM6LuZIlVEB0q0pZOswq5tYJEznCi+DFTpPrOP7eOAn7O5tt4P5GtYglul2pIYnEcRkUiRoM6MA5ggpS6ZFOAsUNRnLPxGJ+qeyEjHpxiKyPI3wGCpxczBbRqUC+T8rhDuk/aE5tAMRmKn6XIPgL6TvR6XkARdni4W9vsw80JGQ/dItBvM/K5aoAncz5Ab3oibDEdUOnYBvGD2o/E5VSkav7Iowtrdyts3Xnsb+bo/A/c9+ttm2mOMPYH6xptgt17WKiKfIwLy+nigO6Wh0d/WU4X8Hsyr2XLT8FWLigf7C71vcZV7X3q93fw96u888IBtWR6NxT3jnMVxYDC31qZ4oC8gFWcrtETNnNnGU
 W/b5h6+j
 1Jjk3sxV5an/0OhB8jrEj8WJdxSpc47PD07yahty/cOypB4/Ua/7EQXepXGPYixrZjGZiU1mpmmnfdr/XpyDL3hmYedvpSwt6yBmJH9FITJHyA+v9TcQH6OkNB5RpHUwDqoNv5cWtr+1hbDambwCcJJ2eeI+LtAUEloCyM444fz2CSDSngHOdiEB+fMQGtM3HwtTKt4rCq5L+TcbMkK1xWWOgK8iw9aFvrwawzYngLhe5EpVOq0Sxe99MXrvc+7v1U5yruR68/wRZbsn0yqrR56jT9PxAkn6EkhV7ECKtqn11ENCDK2EyQQaiM5DIlDcREZOq61jjPsfHC6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/09/2026 12:46, David Hildenbrand (Arm) wrote:
> On 9/16/26 17:08, Kiryl Shutsemau wrote:
>> On Mon, Sep 14, 2026 at 05:28:01AM -0700, Usama Arif wrote:
>>> Once a PMD can hold a swap entry, everything that splits a PMD - mprotect()
>>> or munmap() over part of the range, MADV_FREE, a pagewalk with no PMD
>>> handler - has to be able to split that entry too, or the callers that rely
>>> on split_huge_pmd() to hand them a PTE table would find the PMD unchanged.
>>>
>>> No reference counting is needed: a swap entry pins no folio, and swap_map
>>> is already one per slot, so the PTEs simply take over what the PMD held.
>>>
>>> The migration-only entry point cannot reach the new branch, because
>>> page_vma_mapped_walk() never hands back a swap PMD for the folio being
>>> migrated. Warn if that ever changes, and force the regular split anyway,
>>> since the branch leaves folio and page uninitialised.
>>>
>>> Test the pre-split old_pmd rather than re-reading *pmd in the trailing
>>> folio_remove_rmap_pmd() gate, so every entry-type test in the function
>>> interrogates the same snapshot. That part is cosmetic: pmdp_invalidate()
>>> leaves the PMD present as far as software is concerned.
>>>
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  mm/huge_memory.c | 36 +++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 35 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 873887aed0bc2..0e347a545588c 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3304,6 +3304,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>>  						 vma, haddr, rmap_flags);
>>>  		}
>>> +	} else if (pmd_is_swap_entry(*pmd)) {
>>> +		/*
>>> +		 * A PMD swap entry has no page, so it cannot be turned into
>>> +		 * PTE migration entries.  page_vma_mapped_walk() never hands
>>> +		 * one back for the folio being migrated, so this should not
>>> +		 * happen; warn, but also force the regular split so that a
>>> +		 * broken invariant cannot make the code below dereference the
>>> +		 * uninitialised folio and page.
>>> +		 */
>>
>> The comment can be shorter.
>>
>>> +		VM_WARN_ON_ONCE(use_migration_entries);
>>> +		use_migration_entries = false;
>>> +		old_pmd = *pmd;
>>> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
>>> +		uffd_wp = pmd_swp_uffd(old_pmd);
>>> +		anon_exclusive = pmd_swp_exclusive(old_pmd);
>>
>> The logic looks right to me, but __split_huge_pmd_locked() is getting
>> awkward. It is close to 300 lines with two if-else chains that have to
>> be kept in sync.
>>
>> Can we have a preparatory patch that moves the PTE-install loops into
>> per-type helpers?
>>
>> split_pmd_into_migration_ptes(), split_pmd_into_device_private_ptes(),
>> split_pmd_into_present_ptes().
> 
> There were recently patches about related cleanups:
> 
> https://lore.kernel.org/r/cover.1787941780.git.yintirui@gmail.com
> 
> I'm fine with cleaning this up later (I hope we can land this series in 7.4).
> 

Will follow Davids advice and cleanup later if no one has done it.

Too much cleanup already :)


