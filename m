Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B96C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC3A6B0005; Mon, 13 Jul 2026 06:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784496B0088; Mon, 13 Jul 2026 06:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6731F6B008A; Mon, 13 Jul 2026 06:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B11D6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:34:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5018140A7B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:34:58 +0000 (UTC)
X-FDA: 84983395476.27.5655902
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13843C0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:34:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hsRXNUQK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783938897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Gg6zcvzOEOlwfKtfjKwTjYa7q99CzNlGtktYSfy79w=;
	b=wYUUGELd9CuUV9j94MJPM8UDWEX7R3gI1BR6ohXQF5+yObizj0ybYwO6jzXP1nsavbHMHp
	YcgNJzpA8BDfbCxQos+7xXvsPqZNdVwT+mQ3N8g108waYFqGK7RJAUvPtF2wFhacvCrNiI
	2H7Pj8H54W3hUfn/NwDKzh7Nl1fIn28=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hsRXNUQK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783938897;
	b=wkDPlkPt8HD3RD7jR+Xk55q6Rp8NIGg/+2IH+mSkeqigY7cpsgCey4c0jh8hYZjN/v8UOB
	6qufAzeTb1SIEj7DKkmCXpgtCK5qeOTGxMZdmLe1ICvCM/1NF7JVMK4PkcA+me5U7oc9pU
	MYFxiecCLGyiV0MqWQ52KwBAvlCW1L0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 058F7413FF;
	Mon, 13 Jul 2026 10:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04371F000E9;
	Mon, 13 Jul 2026 10:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783938895;
	bh=8Gg6zcvzOEOlwfKtfjKwTjYa7q99CzNlGtktYSfy79w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hsRXNUQKVx+rEC++ym4RrSK7/O9TMsKUyCkHp2Fg5BaNtVwEVYxvkkmgaR+Wguu09
	 AJ5HFafZ1LjP7/u3Fgc8gxcHzxLjfx4zXcIRFIYi6BvOLgrr07hM+Ta+QWh6fjcb+l
	 wve84ooRTdU7Qzf6CjmIrgUpzVfPSdQlFAmkalqu1snmaYobmTcGZX9jmYQnjMRlTB
	 1E/twWmbcCOvsOE9bVKwCXN/0nk5W7IoMpjbhNabWDtFckxXER+Sjc9oGXAE2tnDWp
	 5Xm3brj5LRdA0NE1lkvKXyTB6+5JUsiNhwRkti1osmsmy3Plx6bClzAdgcXJdUtdTP
	 zyQheO9XMUW3Q==
Message-ID: <db3c6f52-7a82-4afa-9720-1edf2f5c855d@kernel.org>
Date: Mon, 13 Jul 2026 12:34:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm/rmap: Add try_to_unmap_hugetlb_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-3-dev.jain@arm.com>
 <49b408b9-6d10-4892-916f-ad8e7ef875e5@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <49b408b9-6d10-4892-916f-ad8e7ef875e5@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g11pktk71g4gdodx5ccemb4gok59gfff
X-Rspamd-Queue-Id: 13843C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783938896-668314
X-HE-Meta: U2FsdGVkX18IxWm/8UxUsRvUqTdvne9MQzsMwuYFeFAm1BguaVig6n4xlywVJHZC9I5TbvlDvL0ZIVOFsnLjotf2qP//4w2PTiOQ16t5Fs3K66BA/Plkn9vVu1c7p8wFi5kzwVa0rA0bbok+N7cip+NLrSII0Aq9GsRHfr11WJZfEyNGrrU9DFZ7ZFPCwasvkOAgzlsOBTsEMgRGe4kk251/Gn5VwOJeeI1nKW0ssBZ9/EE6bT5094wY6u83UDb9HwcKeCSvA6/A7Tt3L3zFMW+Yguypq2AWy+XHlp/AKcQR/AVohR/YXiNT2tBqDvHfUCNdQlGJaC8L/pwbvdF0SqiAkPcN6d0NYeo8fA6WAtZEmmDfbmVbsE4MDjAWSuBB0tKFz78qKYyhEVq/ibEQ/jQIBKbAIXWL3yUiMhMT3hH97tBOhicdkFoD1RifitwWGRtEaF/Lt1Etp4R74HjogH/Q0zHOohrwv1kGPezDqYmOrfOKiju3+1t3A59vn7qQ0D5C0NBhcef0j79WFKuH8uErHXHOBEHCEVnIaTql00m9gew+Aq7OW4GpTsc6m7bxt0jyqGhIfMvsQ0Le09vmhEakigKnN1NGMDJtSVNk5qGOOXlwczV08aIuvY4uwpabSMvAcIehLnDDuZCA3VLRkAcV3VtgCFjBRSTlCKAEM96CNEFKXS83Kc5dFrqMv/tON1IjbY+u6iA2bb2/Ii1Q5jM8K9eOWUUQUN+IC0tDwNbC6tpiLqjb5acCvk5+wxtdv2qN1dDHHVmQ3q0+rDQ0PFEnRRFj50Vis4H0ePt+vXU+0fxgFagJd+zLs+xGzcF7iKj4kgEvHX9lQ5QWiO3Z0koXZmTU/41coL2DFd6vwOoj2fy4feHdNMos7rucoa9QO6QP3H11C/FzaKPronjh/re/S0Q900RYkkwZPlieN3NaeMzI1ObWtyN9cNQsxz47SWJFLbI3tJk7JxGnS+P
 Ey9Grtsd
 9cm9woT4Rc9EG2hoeQVib7Pj9zBKPWnaP4Bvwy8Zb0edVp96aLaZgBdedd94ugk1hEFP44M3QoXTOjWaJ3egkSgadynjmi9cm0Ay0zgED5BqACNlMeX3wS8CZUxujO8xm+sXQ5FmZDF2ysOXAVXzmZ6w6RMJTF01wiY1IuqWIWhzroR2LXa6sr4qC79Ao1WjJbLwbnsF4IPjrM8iPbsBWKp0dg5zd2PIPbuu0sb5mkXyCn6qBAZSmTKQCsmjHyQjXUw0VuH4zYsiQIViK+U7NE0UUaFj77oNebMye5D7XVud+s+SmfBJ6te4CRyn+/IWhqmlloTaScRjQN882KitbUqZx23m59qFD+o+NLf+7sGTphFSm2ApTBS7xPlrjH4UI7Q6vo2pDsl+6XKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 15:16, Dev Jain wrote:
> 
> 
> On 10/07/26 11:29 am, Dev Jain wrote:
>> Simplify try_to_unmap_one() by separating the hugetlb parts into
>> try_to_unmap_hugetlb_one().
>>
>> To understand the correctness of the refactoring, the following points
>> are noted:
>>
>> 1. try_to_unmap() is called for hugetlb folios only when they are
>>    hwpoisoned.
>>
>> 2. A hugetlb VMA cannot be mlocked.
>>
>> 3. page_vma_mapped_walk() returns at most one hugetlb mapping in a VMA,
>>    and that mapping points at the head PFN.
>>
>> 4. We won't ever process a softleaf entry that encodes a hugetlb folio;
>>    hugetlb folios are never swapped out, migration entries will be
>>    skipped (PVMW_MIGRATION not passed), and device-exclusive does not
>>    work for hugetlb.
>>
>> 5. The hwpoison entry is constructed from the poisoned folio, just as in
>>    the pre-refactor code. Any previous uffd-wp state is deliberately not
>>    preserved for the hwpoison entry.
>>
>> 6. TTU_HWPOISON is always present; for it to not be present, either the
>>    folio has to be in swapcache, or mapping_can_writeback() is true (see
>>    unmap_poisoned_folio), none of which is true for hugetlb folios.
>>
>> 7. Hugetlb uses separate counters from normal rss counters, therefore
>>    update_highwater_rss() need not be called.
>>
>> While at it:
>>
>>  - Change VM_BUG_* to VM_WARN_*.
>>
>>  - Do not declare variables which are only used once.
>>
>>  - Constify some variables.
>>
>>  - Add some more VM_WARN_* to assert some invariants.
>>
>> Except the above 4 points, no functional change intended.
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
> 
> Andrew, could you squash the following diff:
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index cf02b315a2ead..b61051b879c4c 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2229,8 +2229,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>                 update_hiwater_rss(mm);
> 
>                 /*
> -                * With TTU_HWPOISON, we only expect small folios or hugetlb
> -                * folios here for now.
> +                * With TTU_HWPOISON, we only expect small folios here.
>                  */
>                 if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
>                         pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));

Note that the comment likely fits into a single line now.

-- 
Cheers,

David

