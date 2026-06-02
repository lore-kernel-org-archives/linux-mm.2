Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11D10CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 09:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78FC16B03C9; Tue,  2 Jun 2026 05:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 766FA6B03CA; Tue,  2 Jun 2026 05:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D166B03CC; Tue,  2 Jun 2026 05:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5759C6B03C9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:30:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1ADBF1A0823
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:30:54 +0000 (UTC)
X-FDA: 84834453228.26.1DAFDE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 51A7C80008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:30:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cc4WT3Dq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780392652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RhX66fkdtzWkODIz9nI8l9eW5veNrNS+XM6ojvk1z5Q=;
	b=PPrqN65wCfPmdPlQzi2/aiIkKSO4aS88LcZrppogwYnCQ2VNbH6hQV2gusgjS+PDqhoD5d
	aJ+HBnoSTrOpu4Gmhpq7In9+RZ3PyxK3qfyRXUhjtLENECXruhs8ILVUAm/2J3941aOL68
	oH/vARatQDpxfRnohslnTmQYWpqoMqU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cc4WT3Dq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780392652;
	b=avBHwObF2U1hUM+bLJF+LZHqGLvmfFnoJKfUZRfEDzYb4z6IB8b3/3hl3sjwW42FOyZVMV
	4cMOnIt0uHfES5B0ONAaH3gK9dOV/KIDElfNaLn735RJR7+4D0WOy58iBbCsQViLo/hUC3
	O/uZJWbzA9fruIhaFzuS2GhoSDEl4Hk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57ECC42A05;
	Tue,  2 Jun 2026 09:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E621F00893;
	Tue,  2 Jun 2026 09:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780392651;
	bh=RhX66fkdtzWkODIz9nI8l9eW5veNrNS+XM6ojvk1z5Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cc4WT3Dq2NWosuhrUMUzUiXO+MBDXbLJeBWfS44QcT6hNBAqlNBQ53D/0pBWUbdPK
	 maaSukjU3EiZDDqMHGn394m+2Amx56dgaDHmDNYMT9osAtFCvRsgJvBEM5TvTA2bKG
	 jfgiOuLdK2d8PK+iI+lAjraUFb09GyVb0XBQj10CCiMW0zDhtNzYg62h34KPrxx8T7
	 yDs9krGOYgE8MIdjMLI200MM2R+XVmu/telXZZrWbvOsiECfUj0nkgGC/fs5lNu2AY
	 cMasxdWResCX8YUZ1F3BW3DJfBzB5iiloyTY9JXRNFy7yJprbmv0+HR10V4w5USh15
	 XuDWhFOBDalVQ==
Message-ID: <6dd5f74f-b454-46a0-b2f7-ba906792f5ba@kernel.org>
Date: Tue, 2 Jun 2026 11:30:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_isolation: Avoid hugepage scan step underflow
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 liushixin2@huawei.com, osalvador@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>,
 Muchun Song <muchun.song@linux.dev>
References: <20260519121646.40833-1-kaitao.cheng@linux.dev>
 <20260519105424.e422131a0ffb49e19ed1aebe@linux-foundation.org>
 <bd3667a2-fd81-4761-a763-f6418d9c09f9@linux.dev>
 <4bfe16a2-3bb9-44e2-8b3b-8c77857a4944@kernel.org>
 <88aa1f75-1cdd-499e-b352-0cd6c7f0d079@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <88aa1f75-1cdd-499e-b352-0cd6c7f0d079@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 51A7C80008
X-Stat-Signature: zes8fpfdx3o8mfrbkpa6rs3jgdf7npe4
X-Rspam-User: 
X-HE-Tag: 1780392652-314854
X-HE-Meta: U2FsdGVkX1/MOxpXtJIT3BHxlgjy7dj6OE0sEyvQ+mHYdFWu80efCmEMivCggxvAw7tjNruqk2qreO6A1G/i1oiz0H7JyKFyGLosXL7A+5h6F5LtELkkHxWr6CStxT9mPXp4RUdmCIWMcjVV0dw42f9PEYyKCuoQgfrpRp85x7uT50xyALxyEiwKkXwbMjz4ochp4zis/9GlTVJbolLCwIR9uRmXQ+hAlh106rqBO8RmAFUGLVMhxy6/8f4t2j5xCaLGd6TVgPPjpKihbmaY6fW20+ikIqV1RN+kVm2/rR4B4OwW2QWEoJ0Zk7Dj0k56Ay/3Qw9HZHFCUyilfeFhIwqiWioyueHbGHLxr/SeUR4hFVDZtWnjYPZ7jj1XmdYaDdaF4clLzsI7AOm+n5jUCed3pjmKnUhEj2DwY128+OWm0Y0diBiToCgoRIwXYZrRvnPdJLdj/MptC/zexzBfG1BXhB1TSD94vgi66ly3g9quWyLZr9H7cADpxjt0HyVXh0ub9eLWVVpIUQD/QLKDw0NoYeVXOX7TuczAsCJxk2s2ezACPaefiBJryFwz9WDAStTiTJZ8MyIMwHPHwefBl+3AowrvbiGBDX5EArYkdmBEC14Tge+mVehibuXZrFPB8Hf9c4htBZUNMhlH6wUc9En4XFBd8p5JLs0pUqEInU08dTmJDNdLV226OdDfOrB/Rh/fdfCkjUUHL4jILiX1fsvlfLDLdXftdXXRqA7E51zpDEZRfcpak6cGob0ycvYgQA+HVJMMhdpdpG/fE0cWv4mBIUoI0ALTx3M887mzXaO74xFGTisMpteNfHimJ5WrV9EpARkcEKoajsSAYj1zUAowYWBbj/CctgmwO4srdmM+kyDKFtPy7aKhxvVnp47DCj6UkbCI3gpjRMWkXwP9BekMYyVkfrI3JNXW9QwDi4cQ/P93AZw/tyGSG05xJi+PGFxKg3xKZcvOCjyrkCG
 c1APLDEc
 aIoXp9TLdqAFrmd9kXve1A05sVTIlaFcMDD0vp9qfaz39/g1JyQyou+74CyCJm0BP8NSpRZesY1WXLRwl+EZ7VlgfBIh+G+LLwz46fxluqwKeqI5ov6Yx2VjgAtkkqhuqo+iVeWT6V3wClzYu0k3s3CVxy3HhJUJ4fT04TQhPWLbU/ck4XcOPFns9jtEyrC3UhLEbmTYSp2fnkI7hyn7qX4WC2hIm9D6dqLL+iL4wiL8DsYYNVK3+9mPxdTWKno7bZQZbjI2nUYoFKjh3yvTK3E9loC2pTL1qReCIzsSEex/EYTYrBko7gxoYHQTofjkKu9FBp97/K6zWMy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 09:08, Kaitao Cheng wrote:
> 在 2026/6/2 00:21, David Hildenbrand (Arm) 写道:
>> On 5/22/26 11:35, Kaitao Cheng wrote:
>>> 在 2026/5/20 01:54, Andrew Morton 写道:
>>>
>>> The direct user-visible effect is not memory corruption, but degraded forward
>>> progress in the page isolation / contiguous allocation path.
>>>
>>> If the race makes folio_nr_pages() return 1 while the current page is still
>>> treated as a tail page of the old HugeTLB folio, the computed step can
>>> underflow:
>>>
>>>         step = folio_nr_pages(folio) - folio_page_idx(folio, page);
>>>
>>> The caller then does:
>>>
>>>         start_pfn += step;
>>>
>>> With unsigned arithmetic this can wrap and move start_pfn backwards, typically
>>> near the beginning of the old hugepage range rather than advancing past it. In
>>> many cases this only means rescanning part of the same hugepage range, so the
>>> effect may be limited to extra scanning work.
>>>
>>> However, it still violates the scanner's forward-progress assumption: step
>>> is expected to advance start_pfn. If the same transient state is observed
>>> repeatedly, the scanner can keep revisiting the same PFNs, causing excessive
>>> latency and, in the worst case, an apparent stall in operations that rely on
>>> page isolation or contiguous allocation.
>>>
>>>
>>> Here is another point raised by AI, the old code also used folio_test_lru()
>>> on a folio pointer obtained without holding a reference. If the folio is
>>> freed and the old head page is reused or observed as a tail page of another
>>> compound page, folio_test_lru() can reach const_folio_flags(), which asserts
>>> that the passed folio is not a tail page. On DEBUG_VM kernels, that can
>>> trigger a VM_BUG_ON_PGFLAGS() crash.
>>>
>>>
>>> Following David Hildenbrand's suggestion, I made some changes as shown below.
>>> I'm not sure whether there are still any other issues.
>>>
>>> --- a/mm/page_isolation.c
>>> +++ b/mm/page_isolation.c
>>> @@ -41,8 +41,14 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>>>          * We need not scan over tail pages because we don't
>>>          * handle each tail page individually in migration.
>>>          */
>>> -       if (PageHuge(page) || PageCompound(page)) {
>>> +       if (PageCompound(page)) {
>>>                 struct folio *folio = page_folio(page);
>>> +               unsigned long nr_pages, pfn;
>>> +               unsigned int order;
>>> +
>>> +               order = compound_order(&folio->page);
>>> +               if (order > MAX_FOLIO_ORDER)
>>> +                       return true;
>>
>> Would we also have to care about non-order-of-2?
> 
> There should not be any non-order-of-2 compound pages here. Neither the
> buddy allocator's allocation model nor the folio_size() / size_to_hstate()
> implementation supports non-order-of-two compound pages.

Ah, sorry, in scan_movable_pages() we use folio_nr_pages(), and that can give
you on races a non-order-of-2.

So yeah, clearly not required here.

>  
>>>
>>>                 if (folio_test_hugetlb(folio)) {
>>>                         struct hstate *h;
>>> @@ -54,15 +60,16 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>>>                          * The huge page may be freed so can not
>>>                          * use folio_hstate() directly.
>>>                          */
>>> -                       h = size_to_hstate(folio_size(folio));
>>> -                       if (h && !hugepage_migration_supported(h))
>>> +                       h = size_to_hstate(PAGE_SIZE << order);
>>> +                       if (!h || !hugepage_migration_supported(h))
>>>                                 return true;
>>> -
>>> -               } else if (!folio_test_lru(folio)) {
>>> +               } else if (!PageLRU(page)) {
>>
>> Hm, is that required because we could VM_BUG_ON?
> 
> Yes, that is one of the reasons for the change.
> 
> page_is_unmovable() does not hold a reference on the folio, and the folio
> can be freed and reused concurrently while this scanner is running. In that
> case, the previously obtained folio pointer may no longer refer to a valid
> folio head. If the original head page is reused as a tail page of another
> compound page, folio_test_lru(folio) can hit the folio flag checks and
> potentially trigger a VM_BUG_ON_PGFLAGS().

Okay, spell that out in the patch description.


-- 
Cheers,

David

