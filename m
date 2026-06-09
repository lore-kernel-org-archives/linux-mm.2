Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3DDFCD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314076B0005; Tue,  9 Jun 2026 06:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C49A6B0088; Tue,  9 Jun 2026 06:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B35C6B008A; Tue,  9 Jun 2026 06:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 079456B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:36:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9503A40520
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:36:56 +0000 (UTC)
X-FDA: 84860021232.02.E3B1558
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4802E140005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:36:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OxFA9un9;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781001414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/rAkLlXIlXwRgQb+cLefFBf2z5QC1/Z0DCE0BETG/c=;
	b=ZKSPnjyaVGHgXspJGmDztYXRQkO2CJHmsXTHr3ROjqUGAbUo0255PhbIv97/wcCxdG9vDm
	PDnbrBEQZAgCWMeUf3QNNxh1yAgkq0HThLhAjlZo7hGuXrPI2JL8FUi9EtRRxgoatBO1aW
	x3ti8cvn/Mb8Rd+qlWYkV/Vp3nyVLt4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781001414;
	b=JB0OJjA7ugqxA4DjbWwP5hYHORU9fjje5WlmYCxzrXOn8dIKCs8ZrwlrkwxJBihFypH1J2
	0PR6wQl1ArnR6qDYs5GlRjWW2Ws64YFcUCfWK0emN7faAUrfYtFOGVFtloXXZhDwXYwYfe
	qr6Whscxa2LUnXFfnGNJ6AXDJZf2ziE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OxFA9un9;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <7e36f7f0-b4d5-41c9-b399-9e0079907d33@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781001411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k/rAkLlXIlXwRgQb+cLefFBf2z5QC1/Z0DCE0BETG/c=;
	b=OxFA9un9vu0GW542DvVoiEKSZvKgU8m+pFneJhMgeukhwmrYt4Cnz+zD/9qEHska0Zm+it
	w02Mufbjx8vAI7xkfWKQ6k/fxd+dKq5O+h1nA+/pRzFEhofRlBQPjXC2b9LO+W1mqNpYo6
	Ly/xyxg1oW+1zQouZxts70DutOiLlr4=
Date: Tue, 9 Jun 2026 18:36:20 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v19 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Content-Language: en-US
To: Nico Pache <npache@redhat.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260605161422.213817-12-npache@redhat.com>
 <20260606102800.26940-1-lance.yang@linux.dev>
 <2553caae-9e0e-42a7-8b61-d1216f1e81fa@kernel.org>
 <CAA1CXcBY_2372eJru8VoCq90rUMxn7w23hHou68MmXRv48NRXg@mail.gmail.com>
 <b7fb4184-7a99-42c7-8ee2-4c7fa20827c4@kernel.org>
 <CAA1CXcAhw8V+_dYcrqmtZ9ht4Pqz5PPB8EOcDrVCp4DA4y7pLg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAA1CXcAhw8V+_dYcrqmtZ9ht4Pqz5PPB8EOcDrVCp4DA4y7pLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4802E140005
X-Rspam-User: 
X-Stat-Signature: yhtd4y5cuxua3njju88cbk6rz78oa7u5
X-Rspamd-Server: rspam08
X-HE-Tag: 1781001414-577798
X-HE-Meta: U2FsdGVkX1+0CB/dnXU1undxj8rOGpoCcxOXeDvfB8ASTeLLjKEfaLuYn8mSv+zfD1q/kzu1uQhsOJZ7uKTIq2h48LG6aGrHDmsLvtc5RTMEOGDz32E5bG8LeITAx96FbR/gcoSkYUlCmY6w39xELn51AshUlovZezIT/PXsfETdED/p9zNzjCqbipuG0zApRSq/By5DG27HwKZAtd8xUgHQ0z97q+lYyFwSJK5LtFMG7uLqG4wFESNrBgpss59Y4TNSqGYivrzAjU6y0Qz9ov69bCYXi6N44Agz05dBno6gmjzYrdfPpKKe1WyEiJuMArWrzSiI9+/8Xmu/VI7JDnRQTAkk5NuVGrUJJWHyh1zSPXqD0cFA+VVZRQJkjqJhMV8/rEtotBzHh4xR2BNS/+iIndE+Rh4mDh1reNB4wO9lCWRVaaWBjZqQU4STG3nUNoQ9mYyhi3ugVxAtNja7MdZEu6U/YfpaHfI7WZajqvMZvBZ8VoiaGY9ZUtPU1i7X7SmHaoHtd37pwDJ28/nnZzl16GmuRtsHvYACv2zpA4SmuoaFQk9MKqcdkHADOgtIKC4JV7omDowPkXU9xPzjjpjMxtHmtXC9C7lRL7evw3hWkODCvIqcF5beSU3B5Q4Mm5YNua2Y1OtCUiGAEwZA21+BFTEWk+zPhs78S4f+/eBzN2FI1aPxkpZniRXxn7hB9QnpwL04iNCcTQv3ktbzOrW6jstHmZ+M+IpIXawEeFrl9MUpOefD4iAmtwvVZQU+0tmoXrFUc1sN9MkRXOHiWvVH/4pWyfgjrdelzfjZfXEmkDPR9p4wjW1d1Fxdos/fgUZopzE2u/3G4nRpQZVHrEB9v2Z+LbRH2kHKqCXrMir7lrEqJpdO4SfbI++wAwqAtLcUKti6Z8CNAjDo69YkdKR+X/q/8JUC2i+adpe1KmOnd15PxC+G3Al/OO8kQIi0AqdczJTMyR7pVVHpuEp
 eRByTl88
 8HwN3ksiCgITZ3KFL1XEoOfXdnduxGlKAaCQCoWy+g4PTn2Ogr4uvu4jv+Qs1WXqW19ZNdJZiqP0gzBsEHZquCiVaoWTSUYSyogZKSVWWBz9DxNaR3w/PGazKSqAqKK3n4m2DsDqFmL8pggjElDUhREWlxdjKPJ5Ngky4+BzWAaA4i0b3pAyGhMcbbJPc20yvnSAQPqKFfEWOdJ5xAc3gVdAvcsJ/PGGD+eQQ66uIrLDhnRnRXz5qQCzWLk2LGz4g4rhN3nvd0o7E8PH7JASZp1R0QEgSYvk1DDh5Kaza4sYV9c2BSDCEfgIuuuOSg3sfBikM1lKNLHd4h2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/9 17:32, Nico Pache wrote:
> On Tue, Jun 9, 2026 at 3:26 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 6/9/26 11:06, Nico Pache wrote:
>>> On Mon, Jun 8, 2026 at 8:57 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>>
>>>> On 6/6/26 12:28, Lance Yang wrote:
>>>>>
>>>>>
>>>>> Looks broken for swap PTEs in PMD collapse ...
>>>>>
>>>>> collapse_scan_pmd() allows them up to max_ptes_swap and record them in
>>>>> unmapped, but they don't get a bit in mthp_present_ptes. And then
>>>>> mthp_collapse() does the check above:
>>>>
>>>> Right. I assumed this is implicitly handled by the optimization in collapse_scan_pmd:
>>>>
>>>>          if (enabled_orders != BIT(HPAGE_PMD_ORDER))
>>>>                  max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
>>>>
>>>> But we perform the check a second time.
>>>>
>>>>>
>>>>> nr_occupied_ptes >= nr_ptes - max_ptes_none
>>>>>
>>>>> So max_ptes_none=0 + 511 present PTEs + one allowed swap PTE won't even
>>>>> call collapse_huge_page() for PMD order.
>>>>>
>>>>> Shouldn't we account for them in the PMD-order check? Something like:
>>>>>
>>>>> if (is_pmd_order(order))
>>>>>        nr_occupied_ptes += unmapped;
>>>
>>> This solution seems good for a temporary fixup. but longterm we may
>>> want something else. I'm still not sure how we plan on supporting
>>> swapin without causing creep. So I'd be ok with adding a fix for
>>> legacy PMD behavior until we know how to handle mTHP creep correctly.
>>>
>>>> As an alternative, we could either 1) skip the check there for
>>>> pmd order (as the check was already done); or 2) introduce+maintain
>>>> a bitmap that tracks non-present PTEs.
>>>>
>>>> @@ -1475,7 +1477,9 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>>>                  nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>>>>                                                        offset + nr_ptes);
>>>>
>>>> -               if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>>>> +               /* Check was already done in the caller. */
>>>> +               if (is_pmd_order(order) ||
>>>> +                   nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>>>>                          enum scan_result ret;
>>>>
>>>>                          collapse_address = address + offset * PAGE_SIZE;
>>>>
>>>> 2) would probably be cleanest long-term.
>>>
>>> That would be best for future swapin support in mTHP, but I still
>>> don't think it solves the creep issue.
>>
>> It wouldn't, we'd simply maintain the state we collect + rely on in separate
>> bitmaps. On swapin, we'd have to update/refresh bitmaps I guess.
> 
> Yeah, I'm saying for the future, it obviously solves this issue here
> as well, but if we have positional tracking of the swapout, shared,
> and none PTEs, I think we can use this to determine whether the
> collapse would lead to creep. If we detect creep would happen it may
> be best to automatically collapse to the N+1 (or greater) candidate.
> Just thinking outloud here.
> 
>>
>>> Perhaps we could combine the
>>> two bitmaps to determine if it would make the future collapse eligible
>>> again? Not sure but ill start thinking about it.
>>>
>>> Should I send a fixup for this using Lance's solution? Or does Lance
>>> want to send a patch out with the fixes tag?
>>
>> If Lance could send a fixup, explaining the situation, that would be nice.

Sure, happy to send a fixup :P

Should I send it as a fixup to be folded into this patch, or as a
separate patch with a Fixes: tag?

Will get one out soon :)

> OK, I'd appreciate that :)

Cheers!


