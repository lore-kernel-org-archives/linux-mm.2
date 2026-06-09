Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 046E8CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6B76B0005; Tue,  9 Jun 2026 07:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E536B0088; Tue,  9 Jun 2026 07:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB5E6B0098; Tue,  9 Jun 2026 07:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B89D6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:03:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65187120551
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:03:36 +0000 (UTC)
X-FDA: 84860088432.20.CF0BE8C
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A9141C000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:03:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QPtJyjnA;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781003014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dI5cOHs81stexVS+TJ0IdzvicKkzLLJVhtLgf3ExdLM=;
	b=AXVRwmCgRgEEFNQXLaMlwI61ObKsQOFxrkDCPLg4+OwiRpOU2qrZukyFJEyQ6Hxj0VcPm+
	/+S6QZBTXIDcM8f1cX+qtN9nbBwre/E8gYNjIwAT5BEusGI3Y5VdNLBkfMElnVFxgQYaUG
	A1x8kJC8zzGOedUeYCFCGwiiafWGjbU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QPtJyjnA;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781003014;
	b=BDScOKHf0hrHwS9Sj8Fu4INO8iTVTeZM5+uzRyulvs75adxeaQfIhJ1PeQFdy2oB1TxuVF
	91oJZv15+yVRgC/gboR+zXGdygWBiPYHVIp+2DUMOcvpVVG0iFDh61CltW3+bIaOtKJSWx
	xUMh83xpGuoiyc807bQXatZ6zoK4MQU=
Message-ID: <4fa58f7c-f3c5-484e-a8ca-7dfef50a1679@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781003011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dI5cOHs81stexVS+TJ0IdzvicKkzLLJVhtLgf3ExdLM=;
	b=QPtJyjnAVUpuKkOipFitQws2650ZZAmAmPAlY7FzBYw2ZmhXpnnfb91djH0or0I7+kaPw8
	Ph62G3GKtpA94JAQIBnHvYjTzNr3gSvUUhmTn2f8pe7wSsC2rhthFsnjmCiBbyXHiW77lL
	7hGV1SDD3Sn4iMWUYYlTyxe/K4ZEevM=
Date: Tue, 9 Jun 2026 19:01:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v19 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Content-Language: en-US
To: Nico Pache <npache@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
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
 <7e36f7f0-b4d5-41c9-b399-9e0079907d33@linux.dev>
 <CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3A9141C000A
X-Stat-Signature: t7tt84tn6gwufwrpcmsrbohd13p78fyr
X-Rspam-User: 
X-HE-Tag: 1781003014-710431
X-HE-Meta: U2FsdGVkX1/wF2tfu7F4eIVeDeyQaAmwlQByL/0JU2cUiJ7i7UV/KRgbdp00r6Mi5tEIHditpuQmxjgcpNKCiyQqgaSinQNmnc2E7Llf/fdJ6PeTQUriv5HW6dETmYZlTB/5p+as5sK9L6OD7gZJHSsvpeikhKYFEvKAEcqEW8bIgmIL+a8bWxZwP4H+FgPodUgSlMXvU+/IgdpKjGCxJ2GjPt9lyejZhWTZfnEQbLbm5S3NiK/UrA/0FGUHM6HrA/+0HrPkdEc1OT0z6APDNFjumltqZ6OGPqVC64BdQNguOr2SWBPof3o30B+j2ltp1mp6O9lbIPdp+o4t7pLnnb1mWcbYkhrTbLMUtUACqwA8JzgaUZMt+XHUVxg56UIUwptxLsFeOS+tED7dybaWWF8q0lxPVhmhORzRiVuZnuHdx4xC5BNcjzoQQ+FiaU85P71NMBxfC+y4Fp+UcEy8Dm6ZLpqzlRsrbrRcVNXYEjso+zeokPJTyzukpwmUKI0g545Jk8KJ6dqRAFHcCSwDd0o1kyrFbxIEFi4OEam9fcKND56atGOzoXdTf91UQ0XkInPuimoSY0frJgSxlHLmYz/NSp9THsKyUJbjlY6+FDn1dXsyTmoYalnvf9V1Gt9Gg7cgI/tsBKh0cADBb+k0LNkNt5q4nhN9xHh1AQcsGrODwfECLZftvlD1rQEoXtimd+crAAM477NPBSAd0XwAwW0KqP3f4jOuhyASeBbpaM0xp4VWqZ99ghIZ3BPkYxe75WSvaQFaGskgTL9MmM4OvlwppvNVcc0AbvQ5pm71c+2gUsEEbEZuhm+Nf4OP7aH0xcc2F3RE+vx/X1QOdzeNS8nk4icMvXVH5TMAlYJwWUZ613G6LShoFmVd3KWkoflL3lFlRVnBa4HMru8DkrfWw3TbnNQntbqCS9Y4PHdIFc2wIEt/o34XknVORc4YHPNG561qz7Thk7XjLuHxFvr
 AkVG6jZk
 GR9VQSDBTAQ8nZWcxnKbYEExnT+utfDfFb5DotYlZ+wfPjWpRRvet7FJkJ7x3bg1RmMfW2nE0hgSW6mhkgHJx6bAX9+umLgAJm1Ch1YTU7DzADNph8v4CMEYaaO+VDbcBcORfiliDNLwyB+eU1Z3oQYhPviqrxUwVT9s95zfd3VauShgl5mZFeNuTbtt4Mb9rIO1ftPrW9yqO4XI5Kr/UdgmQ0uzvHdyVjBOygyM1jMH+sBwfUzBSGCDRgfUxL0j6H0hfVnv14hYFhiUeuXz1MX4HYyuGeH8/jPXp691GHpXEPRqkH28pX7etcToX5t152eQztQM4V4pUj9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/9 18:50, Nico Pache wrote:
> On Tue, Jun 9, 2026 at 4:37 AM Lance Yang <lance.yang@linux.dev> wrote:
>>
>>
>>
>> On 2026/6/9 17:32, Nico Pache wrote:
>>> On Tue, Jun 9, 2026 at 3:26 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>>
>>>> On 6/9/26 11:06, Nico Pache wrote:
>>>>> On Mon, Jun 8, 2026 at 8:57 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>>>>
>>>>>> On 6/6/26 12:28, Lance Yang wrote:
>>>>>>>
>>>>>>>
>>>>>>> Looks broken for swap PTEs in PMD collapse ...
>>>>>>>
>>>>>>> collapse_scan_pmd() allows them up to max_ptes_swap and record them in
>>>>>>> unmapped, but they don't get a bit in mthp_present_ptes. And then
>>>>>>> mthp_collapse() does the check above:
>>>>>>
>>>>>> Right. I assumed this is implicitly handled by the optimization in collapse_scan_pmd:
>>>>>>
>>>>>>           if (enabled_orders != BIT(HPAGE_PMD_ORDER))
>>>>>>                   max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
>>>>>>
>>>>>> But we perform the check a second time.
>>>>>>
>>>>>>>
>>>>>>> nr_occupied_ptes >= nr_ptes - max_ptes_none
>>>>>>>
>>>>>>> So max_ptes_none=0 + 511 present PTEs + one allowed swap PTE won't even
>>>>>>> call collapse_huge_page() for PMD order.
>>>>>>>
>>>>>>> Shouldn't we account for them in the PMD-order check? Something like:
>>>>>>>
>>>>>>> if (is_pmd_order(order))
>>>>>>>         nr_occupied_ptes += unmapped;
>>>>>
>>>>> This solution seems good for a temporary fixup. but longterm we may
>>>>> want something else. I'm still not sure how we plan on supporting
>>>>> swapin without causing creep. So I'd be ok with adding a fix for
>>>>> legacy PMD behavior until we know how to handle mTHP creep correctly.
>>>>>
>>>>>> As an alternative, we could either 1) skip the check there for
>>>>>> pmd order (as the check was already done); or 2) introduce+maintain
>>>>>> a bitmap that tracks non-present PTEs.
>>>>>>
>>>>>> @@ -1475,7 +1477,9 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>>>>>                   nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>>>>>>                                                         offset + nr_ptes);
>>>>>>
>>>>>> -               if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>>>>>> +               /* Check was already done in the caller. */
>>>>>> +               if (is_pmd_order(order) ||
>>>>>> +                   nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>>>>>>                           enum scan_result ret;
>>>>>>
>>>>>>                           collapse_address = address + offset * PAGE_SIZE;
>>>>>>
>>>>>> 2) would probably be cleanest long-term.
>>>>>
>>>>> That would be best for future swapin support in mTHP, but I still
>>>>> don't think it solves the creep issue.
>>>>
>>>> It wouldn't, we'd simply maintain the state we collect + rely on in separate
>>>> bitmaps. On swapin, we'd have to update/refresh bitmaps I guess.
>>>
>>> Yeah, I'm saying for the future, it obviously solves this issue here
>>> as well, but if we have positional tracking of the swapout, shared,
>>> and none PTEs, I think we can use this to determine whether the
>>> collapse would lead to creep. If we detect creep would happen it may
>>> be best to automatically collapse to the N+1 (or greater) candidate.
>>> Just thinking outloud here.
>>>
>>>>
>>>>> Perhaps we could combine the
>>>>> two bitmaps to determine if it would make the future collapse eligible
>>>>> again? Not sure but ill start thinking about it.
>>>>>
>>>>> Should I send a fixup for this using Lance's solution? Or does Lance
>>>>> want to send a patch out with the fixes tag?
>>>>
>>>> If Lance could send a fixup, explaining the situation, that would be nice.
>>
>> Sure, happy to send a fixup :P
>>
>> Should I send it as a fixup to be folded into this patch, or as a
>> separate patch with a Fixes: tag?
> 
> Id assume a seperate patch so you can keep credit for the discovery :)

Okay :D

> Thank you for all the review you provided on this series, its been
> really helpful!

Appreciate it!

Nice work getting it this far. Nice one, Nico :P

