Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2E0C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EED0D6B0005; Mon, 13 Jul 2026 08:12:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75EB6B0088; Mon, 13 Jul 2026 08:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18006B008A; Mon, 13 Jul 2026 08:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB9576B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:12:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 313D8140121
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:12:07 +0000 (UTC)
X-FDA: 84983640294.13.28C5391
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id F290B1C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:12:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=I4r31t5F;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783944725;
	b=YXAisUCDh2gTDu3vbefrWLChJRE0hId9pM5In1bx7MsIz9QabNqd8R5y7jPmQEk8VvIiQQ
	xBYEF1EoQ9cL2TNAkVmVpDVkmhnihOHQyArHtCYCJycej+0ScOYHP9MPDPgPeTGi27elEX
	z7j0gAYonlVrbUcWI0rhse52xTE2vmE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=I4r31t5F;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783944725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLc0zX/jtJo4npYIZG87HtU2Q1QEGTOR7NdZBK0Cjds=;
	b=L3wwIs8FAqXMasP+uFhhkVOV4cC6ZEirLAqMR63L6SHPVR6QLjaFw3wmm8oDKvzUy6Yldt
	A1bVsGZ2RhBUoLUzI5zhkD8ot6g/h4BpMcHHr9QOrAmvKGj0PDx0hdGR5KnOn2ky+6v6iN
	4wyqERJ9+f/FATaEhsLogP9cFO8dyH4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC7AA1576;
	Mon, 13 Jul 2026 05:11:59 -0700 (PDT)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2ED133F93E;
	Mon, 13 Jul 2026 05:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783944724; bh=XybwoLlYtcu13ujCRHeQdo4p5ZZ7uLYbhY79oGKMjBM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I4r31t5FDkY2Ahd5+cnL3anhmAw4hSrrFiuA00uPSP3uMe14XaFKKAu3bMN0+22ox
	 QcJ2h3zFqhmePduDEtgmoY2An4UNohHvjD2Ag5kyl54FgvTOtBFYddEQ1WneVu6G4q
	 SPOck9PQRA68LO772OTnP4LXJ13OYkeXzCk6GdZw=
Message-ID: <de714ba1-2d97-4403-bd80-6de914500461@arm.com>
Date: Mon, 13 Jul 2026 17:41:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm/rmap: Add try_to_unmap_hugetlb_one
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-3-dev.jain@arm.com>
 <49b408b9-6d10-4892-916f-ad8e7ef875e5@arm.com>
 <db3c6f52-7a82-4afa-9720-1edf2f5c855d@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <db3c6f52-7a82-4afa-9720-1edf2f5c855d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F290B1C0003
X-Rspam-User: 
X-Stat-Signature: xqdbqs8yeh75axaowf4npnpwonqwwe93
X-Rspamd-Server: rspam03
X-HE-Tag: 1783944724-720744
X-HE-Meta: U2FsdGVkX1++ZE7yf5g15jriT0IR64oLRxjJa5sDFXUSs/mAuDb3x7scWGQWwsYReVbMhvUm710oNyO59lgRnbo4Rq9bWiJsrX7bsv1wlGFk8STHkHAEORa8GonEJtcLaLQ2EQmIsOv255jEGtMHkynNHVGzeA6EEC4Y4pU/1a3s6KQGn1fEAbtTKapTONYNTGuE9EB318QVw66Pde6HEm+9R2G/1eF5qNXzigYtMTXMvtDJvOkfHdTNHMHM6i2ozIM70Lp7PPmj8QltFaz8ClXfBAV1dFoK3Ga64vdooa3UOm1zf9Vx0fYsrqUxXNiPZM5Y7b0xM+IgBrWCuCn238e9bE7hFby+gJccE1f0MRh//zuyZSJS0eDtmiEwAOL/QvcZ4JEfCRf8CroDH8dL5lxmY823Xt4cq/zhx3NFqJbN+IjfMLrz+sP/lGhaAUIKCbrd0D0bBH7fNJjrfxShBP962XT1KgIoQeEvvsC4auy8m+fPzVsgu56UGYVfeKgeuhhPxkUSbTyF2q2bl4emC+uUZZ1wce4a6OLXyhpTY8WYijMCXvRXQDvE0nEev3o5IBd7q10QOd3ESRkyMutBFgQtYSu4yS6HqNuXv0eBd1ykevLrhuCDq9zYLl7lzWBBoh8Riw3jChikG1KfNNu8082Xtkh3ypN1eh9kqig6w2TtwrlLY2rJfNfCntnakx+DdUL08dxB8MZ2S4c2tWquNDikg64sbyLVQql//II1rkaFLIVI8hLvI2qHxI7VeYcFUP3PuZA77EJksp/MZSIUibfkwTklcuPXBFcVCw8vFvj8ckmRFsHszmzXdMkWsC6vOMRMIWW/bPcSqOVU7gstacrivsXrRfgEO/htHC8RstHyFA+bR2JlN0AXDxKX15A/LSr5hlDB34BwdhW5U9qYQunI63myBv8kUvqSDrPrciTB29g2jMPLUJh9aCJbJfZ/KkGbLsx1CvlFPPxWmz9
 iCUffntt
 h4cG1hojkZryVho25PDTb3ydg0Q5+BeTmd1k7FqpuSw8rX9bbE5uxBAhIWv7d9nX5/tTyF0/oC5FwXNDtRACCuJmmZec+rFrSZb897m0aEIwcMRGkIkDAUY03f5jodwWs8+Fm3e5QEf89S2sYnpNf3hhbkn2oFR3nkkRCf99BfUXuaylP0nTe8E4g/O1xyme3vX+3A/Gcmt5JVTxd3vj6B0LdJIfXhNP2wru6SyuKPZ39qt4tk240nxZ/IyTZRJ+R5S2LlYDu1wwfWHP/5cB70bfTy2q3LGbmdXMU123NfgI9GMbbE0Z+RZxBqeNkH2vQwBbAeK22LjQv19kkBnfhkFSgjaLecidxNveE9Fv6KCnbzYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/07/26 4:04 pm, David Hildenbrand (Arm) wrote:
> On 7/10/26 15:16, Dev Jain wrote:
>>
>>
>> On 10/07/26 11:29 am, Dev Jain wrote:
>>> Simplify try_to_unmap_one() by separating the hugetlb parts into
>>> try_to_unmap_hugetlb_one().
>>>
>>> To understand the correctness of the refactoring, the following points
>>> are noted:
>>>
>>> 1. try_to_unmap() is called for hugetlb folios only when they are
>>>    hwpoisoned.
>>>
>>> 2. A hugetlb VMA cannot be mlocked.
>>>
>>> 3. page_vma_mapped_walk() returns at most one hugetlb mapping in a VMA,
>>>    and that mapping points at the head PFN.
>>>
>>> 4. We won't ever process a softleaf entry that encodes a hugetlb folio;
>>>    hugetlb folios are never swapped out, migration entries will be
>>>    skipped (PVMW_MIGRATION not passed), and device-exclusive does not
>>>    work for hugetlb.
>>>
>>> 5. The hwpoison entry is constructed from the poisoned folio, just as in
>>>    the pre-refactor code. Any previous uffd-wp state is deliberately not
>>>    preserved for the hwpoison entry.
>>>
>>> 6. TTU_HWPOISON is always present; for it to not be present, either the
>>>    folio has to be in swapcache, or mapping_can_writeback() is true (see
>>>    unmap_poisoned_folio), none of which is true for hugetlb folios.
>>>
>>> 7. Hugetlb uses separate counters from normal rss counters, therefore
>>>    update_highwater_rss() need not be called.
>>>
>>> While at it:
>>>
>>>  - Change VM_BUG_* to VM_WARN_*.
>>>
>>>  - Do not declare variables which are only used once.
>>>
>>>  - Constify some variables.
>>>
>>>  - Add some more VM_WARN_* to assert some invariants.
>>>
>>> Except the above 4 points, no functional change intended.
>>>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>
>> Andrew, could you squash the following diff:
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index cf02b315a2ead..b61051b879c4c 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2229,8 +2229,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>                 update_hiwater_rss(mm);
>>
>>                 /*
>> -                * With TTU_HWPOISON, we only expect small folios or hugetlb
>> -                * folios here for now.
>> +                * With TTU_HWPOISON, we only expect small folios here.
>>                  */
>>                 if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
>>                         pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
> 
> Note that the comment likely fits into a single line now.

Yes, took care of that in v3 :)


> 


