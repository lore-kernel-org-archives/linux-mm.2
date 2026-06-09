Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F85FCD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 16:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F4D6B0088; Tue,  9 Jun 2026 12:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7E06B008A; Tue,  9 Jun 2026 12:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996BF6B008C; Tue,  9 Jun 2026 12:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 843876B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:28:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2511712069C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:28:35 +0000 (UTC)
X-FDA: 84860907390.01.07AAA20
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 217FE1A0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:28:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aEhNyBBw;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781022513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os2EOsUBH5Y105INP1cDhq+ANm25U6M+e7FDSnCAoH0=;
	b=2tvOVGs+w9qUXCDryZt9WcSjgN2QbsrjhE5nTXMPXJOXanGjshvbwHnatEHBuGHm4LZlc9
	9KEhYom5aSUWNaI7b2L5xz56VmbfN/ukQ9qaeO1TSQ8TElD6097f1TlqWNePQl9CnpJFbB
	V+Yc3ryUe+XQ5UGdSV4sJs7WqVM4YmI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aEhNyBBw;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781022513;
	b=tF955xJ7021dNt/CVuBKOlCoOJOKrfjepQ5/MjnLxmJcGhTEWmv5x0jsJNm50j/ZOTujKX
	HavmRFMmxiaxm2woQUquqytAvcYKe/wEwkUpx8Pk12U07l9kAbT+sMI53ABgD5ZuXR+ikP
	si+nWiHle3+gPUzAzIbXGyLWjn0VO1I=
Message-ID: <9e548d7d-480a-42cb-8912-80f415cd0bb3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781022510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=os2EOsUBH5Y105INP1cDhq+ANm25U6M+e7FDSnCAoH0=;
	b=aEhNyBBw4zitxBz/ovKzaEhoFC6QXt0dhiYPjJBkpsozOotVZPug2ybeDar2If9kWeb0Vb
	AEkQDW9LbzLNrY6Ym/PIw5F6HHgW9wCWdZQHCw3AYqBvGXdk2DGaBro6NJPmy1V/3SAe/F
	Pfg+8/elwy0xHrKooF+Nxq10uFfqDBk=
Date: Wed, 10 Jun 2026 00:28:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260609120443.71864-1-lance.yang@linux.dev>
 <7d081256-5b30-4e3c-b948-85ba76ad0e1d@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <7d081256-5b30-4e3c-b948-85ba76ad0e1d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 217FE1A0005
X-Stat-Signature: 6fdnmxu7zuijffni358kedztgfkymx5f
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781022512-224125
X-HE-Meta: U2FsdGVkX1/FmCzlbBqRtTZfh8ayU1DXqWMBNiB/n6Q0F0B2Emt6NfADv0V3Oicq3Urkvk2CLmXn14A/L6rapAEXeKX0Y5Tjo1vi26KwGTYtGSas/pBj2yC/Mo/63HD/DzRT7x9x6KKMXiL8tSjsSzvkupEsXoP79qHF9ewHSVf5sF5809hrL/l3eWCD0wJ1NidOtsfyKIf1HdsIXVN56ZDcSaB5lbrfGBKHhzCuY204KKlYKhsQ4ZtGQWWAqxAV4aNFIhy3OMzzqtNYg3Q3c4WmGMYsm/Tfb95QKXyfIjCvAFMje3abiHpUcjlPfNmomUwxXyGLa3/l5fqKnCyYZDV9XWpzXO611MbzLSSsE1fwpLLltxznFftRpK7FA9d/kPeTo4jJ9W6wVeqLddLNRG66+ZShDggYAC/HD0mIX7guar2968StcVLntG8e0bQ8YMcnnfxl5jJI+63bYO2mpdYCcYbf6j9DUQgqR5CjsZwIAMr4xC6NpAGJtcrz3WVxY2EtTl/WjJKGBpfFIPICoHZ1JSDY8t2ZsI/JAMs+n9lxFvigNyYstTKJ9rU+canVhM3xQDiQU1ayGHFHiFRbfH1f8IBISZjhbZ0XFtjneZYViPfYZhuhSoMuKl7KUPY5XKgnY1WTtsrWiMJge4xZvTl3TP89Xw3ao6TeiZuIc3p5qVKO4xAi/lCrtfGFZJUATHYEKCbIzHuB9J08se078QTCgPLesyi/prBVMWHQZzWFmhmAYH/QA/RICxcJas9ezElaLMW30bu8LCWVM82koOaak1Art7pghqZLm7UEpbBSWLbXOSYYfJaPUQWXN1XV3YzbebjAmBF6nhnSpNkFpY2aWHfJ/t287GJJdwuV78FTLpngfLL6+eHkNbFNYyhYfVvsUzCzQwfWDM1MLdSC9bRl3l+WwgzEh2gsxQQC8PbuLjR6s7oNLcJEdBCR1NGBXOOYosQ9QD2uk+0TLx9
 I7qJHIUe
 jAHtEYOaRgi/NagjLsSxE/eRrwwPrsJHO5RypKfQ50Np3qXcRIjWIFTQjajwr3BdBlx4If/dU442IC/7y0CilLoUCr9XoysQd5O2hVq00wUg+ROGnrKxLQREJJ02JGt+Jmjyom7s/8+TzZEyQbakYNa7jzKlOPSwHekhgAE+wjIG9XKHtodVi6aIS433yubVGarINhLyh41XcIQGopDEDjPQKv/4G6l3b2ba4lvLECxzMeDtK8tndeRUo79hSZxP43FO+sqZZo0T0VtZlRFtHx3VVc0ZKarKQvEtN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/9 21:16, David Hildenbrand (Arm) wrote:
> On 6/9/26 14:04, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> mthp_collapse() uses mthp_present_ptes to decide whether a range has
>> enough occupied PTEs to try collapse. Swap PTEs accepted by
>> collapse_scan_pmd() are counted in unmapped, but are not represented in
>> mthp_present_ptes.
>>
>> When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
>> so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
>> then checks the PMD-order candidate using the bitmap.
>>
>> With max_ptes_none set to 0, a range with 511 present PTEs and one swap
>> PTE no longer reaches collapse_huge_page(), even though PMD collapse can
>> handle swap PTEs up to max_ptes_swap.
>>
>> Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
>> through max_ptes_swap, while lower-order mTHP collapse does not currently
>> support non-present PTEs. Keep non-present PTEs out of the lower-order
>> eligibility check.
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
>> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
>>
>> [1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com/
>> [2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@redhat.com/
>>
>>   mm/khugepaged.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b12187709f6d..617bca76db49 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>   		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>>   						      offset + nr_ptes);
>>   
>> +		/*
>> +		 * Swap PTEs accepted during the scan are counted in @unmapped,
>> +		 * not in the present-PTE bitmap. Account them for the PMD-order
>> +		 * candidate.
>> +		 */
>> +		if (is_pmd_order(order))
>> +			nr_occupied_ptes += unmapped;
>> +
> 
> LGTM, there is a bit of opportunity for cleanup in the future :)

Yes, follow-up cleanup material :)

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

> For example, as we no longer have the VMA here, collapse_max_ptes_none is
> imprecise in uffd VMAs. We might try collapsing where there sure is nothing to
> collapse.

Oh, good catch. We may end up trying a collapse that cannot really
go anywhere ... One for a follow-up.

> We could likely handle the userfaultfd_armed() part easier: some indication that
> we must not have any pte_none() would be sufficient.

Right. By the time we get to mthp_collapse(), we probably only need
to carry that as a small "no pte_none" constraint for the candidate
range.

> Also, I don't see a good reason why uffd would not be allowed to collapse with
> zeropages ... it's really just about missing faults due to pte_none().

Makes sense to me. I'll take a look when I get a chance. And yeah,
as Lorenzo said, better to clean up the khugepaged mess first
before piling more on top :)

Cheers, Lance

