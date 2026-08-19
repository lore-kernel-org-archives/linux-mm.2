Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18A0C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88156B008A; Wed, 19 Aug 2026 12:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F3E6B008C; Wed, 19 Aug 2026 12:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C772A6B0093; Wed, 19 Aug 2026 12:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90CF26B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:04:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25D6FA21EC
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:04:30 +0000 (UTC)
X-FDA: 85118491500.04.6D320B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3B6D61C0013
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:04:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hcr0xUY3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787155468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5kAxKnh+shNjKHhIlDBGkRziYRxhPK0Hcw4pJBYv6o=;
	b=p3zQwcyO1QBCNsXVMqdtQu14fDSv0JIiSu3fHkqJC5NfRIjigKyq7VJ98/l1wpn0NBW3eV
	ShMSxpGIfrw8WRBOkr8PXOgEMQ7rvwSl35YpUBYAL3QiTYlUiHWntw4Baa3NTlc+kMXog9
	54e111xwrCRnlcEClmVk1vKD+op6vOw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hcr0xUY3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787155468;
	b=eoSyE4Ogf0+1k+Cm35m1Xm9vUhcs+nQLL3Nrg+1zBzS6pjdvmhsKXMsbhd3EtYmumvvVQW
	qFg18rRW898UaQq2QxIffkYSSUOW45Odhgqpe398n+O/mlIgkjiF+EwM5CtTySHUvl9syx
	lJujLsWYlSivoTMyEkH1U42ZOcvKPnY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A7A9414CE;
	Wed, 19 Aug 2026 16:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9145A1F000E9;
	Wed, 19 Aug 2026 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787155467;
	bh=M5kAxKnh+shNjKHhIlDBGkRziYRxhPK0Hcw4pJBYv6o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Hcr0xUY3rZmYo43FngWYFt1EkBIEHXypw9lDw1uMYkfhY/YvviBtuS+sPTVnjKLsh
	 2RDVTKVsjSy+OMY29ql5oAsOJgr5NmEE70oq+MY57yMlkBwoN3GgaMCDDryXJ/6z5g
	 IyCMfwLzTUka+Pgkeqi0ZABqB47mVCLdIFFRizdA0K5KHpi8mnIu0bdkxJdGWCojRI
	 96148+u3C3+5n9ZjWhwRiHrz94ydcwNyu1IYYffXnT32/Ki+VDHpNyX1vCNm6/I91h
	 uTaWhEhKMaXxpAV9DH2gC3em2ziJmcYjOiNETzATAbsbkydQXuUSZM8+Y7a7VrKdM8
	 jxrtF0TzG3R6Q==
Message-ID: <ff19ed22-72b5-4c6e-9fe1-de780c9c6bf9@kernel.org>
Date: Wed, 19 Aug 2026 18:04:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/12] mm: add PMD swap entry splitting support
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-4-usama.arif@linux.dev>
 <a5c3a93d-fcc5-4fc1-a764-726ca1d0185a@kernel.org>
 <aoXIQWO6NEfEKipn@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aoXIQWO6NEfEKipn@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: onuwbrnkmmkr7qo5qeygck43ooiqizyg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B6D61C0013
X-HE-Tag: 1787155468-279747
X-HE-Meta: U2FsdGVkX19wOvsjisnJP6NBx9G/0snLMHN/f8t2cOuKNI+QFSGAhXJp5tjYhH9kRoKF2pELiqOMjX8VYcdBxacTv4WYIlahXvHp8GeXMNkmxXK2Uy1lkhnEToolkGY9OAtNZPU5jc6dCTbFGGtMVaFseDL9NPv4xBidvxbFxfTrif0EyRyuvvVVYEPAbmKZuI2BIvareca0qq6V1ItvrVLYbkQrOmvaruCH1Y0rQBHkOiuKvKXHPOzE8JGz/s28g97z83A3VuW/p7uVBxVF3g9S6oft9sp3Kez36Y5f8VzI9+j+gOgEW+fZ/Ql400+TrcUh4i+iE8b4Vq0D1sZUqcIbsWA+g22vYW3+drmTeeT4QyUYEqxMhcJn2BI/bi0YzEQMLDy2hxNHeM0BmSX0ST4vmvt6hc3sZrpu9zvs5/CGdbzEPE5+7ydhAwMdjnG3498BsudIx5ioMVfTLNwfX1l9Qu3WNmhjCcFExxHNI3+PABlGcU1NlJmlGKaBm9cvK1nUtb3r26VF2rHmgs0jJJcHO+0utURAp1t/jjeCJS4jSYkNm+zb0W2KnxoOSt2Aa1Zdq20JZs3HaCdFITjRQpKWHuIlzLoQrwGCKTNLFav3reBGYPwutSnIkp9a+6kwbwSOCOJgHFZdsTNHVtjoA97sxZmKTGpCxgaRYNpzao3w5KTYnBhD9mETEo5nGcng6j8kFMFVAnLkHfj3G78YAJCUCmCf6pUIOqPO0LIcRVWbUvfaayR3L7w7SncCpz+b+cxIIWcxf8k4Z/QaabQIYS4CBUTF24rNooFPp7sEZIRId49GlP1XEosTW/77hFqJIxWaEKJtyAP5PZm5luDoNAYvLtD1ppMDRVrVp/p6L7EySsWVj2+Yl3Cz5Gf9hKdIH8x44XOEDpHgxi0Mgasizwle+/PohmKIsjI/y//zIR4XPfYjWt6Xcq3EVuvzZvFsK7a05Ptv9K023X9PpGo
 2+nKMf55
 Mrxh2yL5KbHUXzEH3sVLG/QW7anru6friIwBlbFHKskB/DX5bciwnYWmnnduoRBPrMzSbNjl62Z5S8lZ8RntnrXDUHKbxQbWifBfNFfvAzKHmmO1GqpweHfaKBcNzy6OKmeUh173mqKVb0y2O+1PtAAWXgPYib75Z8UHwhInYYWa/YbSjO+TE3CpaBj8ZpLdfgHy+MlnMOaMmdBEGLx6otzR9XOgj14yE0ayXLfLi46+ZKm2Z9TOmDRbZqn0FCPTX89sqDMwpkQM+fKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/26 17:16, Kiryl Shutsemau wrote:
> On Tue, Aug 18, 2026 at 07:53:48PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/18/26 15:09, Usama Arif wrote:
>>> Add a swap branch in __split_huge_pmd_locked() that splits a PMD swap
>>> entry into 512 PTE swap entries. No folio reference is needed because
>>> swap entries point to swap slots rather than pages. Each PTE inherits
>>> the correct sub-slot offset and preserves soft_dirty, uffd_wp, and
>>> exclusive flags.
>>>
>>> The folio_remove_rmap_pmd() gate at the end must inspect old_pmd
>>> rather than *pmd: for a present THP split, *pmd has already been
>>> cleared by pmdp_invalidate(), and that invalidated bit pattern can
>>> decode as a plausible swap entry.
>>>
>>> This branch is reached from the explicit __split_huge_pmd() callers
>>> that hit a non-present PMD: partial-range mprotect / munmap, the
>>> wp_huge_pmd() PMD-COW fallback, and the swap-in / swapoff fallbacks
>>> added in later patches when the cached folio is no longer PMD-sized.
>>> page_vma_mapped_walk() does not iterate PMD swap entries, so
>>> try_to_unmap_one() and try_to_migrate_one() do not reach this branch
>>> and freeze=true cannot occur in this branch today.  page and folio
>>> are therefore left uninitialized in the swap branch; a
>>> VM_WARN_ON_ONCE(freeze) catches any future caller that breaks this
>>> invariant before the freeze path dereferences page_to_pfn(page + i)
>>> or put_page(page).
>>>
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  mm/huge_memory.c | 29 ++++++++++++++++++++++++++++-
>>>  1 file changed, 28 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 1b6b0aa2baa3b..a473e85d30f51 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3252,6 +3252,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>>  						 vma, haddr, rmap_flags);
>>>  		}
>>> +	} else if (pmd_is_swap_entry(*pmd)) {
>>> +		VM_WARN_ON_ONCE(freeze);
>>> +		/* Swap entries have no page for the migration freeze path. */
>>> +		freeze = false;
>>
>> It's odd to VM_WARN_ON_ONCE() and then set freeze=false;
>>
>> I'd just add the comment above the VM_WARN_ON_ONCE() and drop the =false.
> 
> VM_WARN_ON_ONCE() is compiled out without DEBUG_VM. The freeze = false is
> what actually keeps the swap entry out of
> 
>       if (freeze || pmd_is_migration_entry(old_pmd)) {
>               ...
>               make_writable_migration_entry(page_to_pfn(page + i));
> 
> and out of the put_page(page) below it, where page is uninitialized in the
> swap branch. Dropping it leaves nothing on production builds.

Right, because it's a condition you shouldn't hit on production builds.

And I raised how we can restructure the code to make it clear that we are being
overly cautions here.

Let's not add unnecessary code just because the existing code is hard to follow.

-- 
Cheers,

David

