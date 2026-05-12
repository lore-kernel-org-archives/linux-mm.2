Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7433CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208626B008C; Tue, 12 May 2026 04:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DE5D6B0092; Tue, 12 May 2026 04:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C0F6B0093; Tue, 12 May 2026 04:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01E0A6B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:59:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8E7C8C857
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:59:22 +0000 (UTC)
X-FDA: 84758168964.23.8F4027B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id D810EA0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:59:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tqf9cy7q;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asISnngeBA0oNblrssDXK0ljGB/7PXMzmljm5CknqUQ=;
	b=UseWatlG38foG8U/qP23UcG3wITVqTJqfufsHmQ+6wEw9JnBvEy2cVrSXagWoOep1/z1t6
	VJdjSD//Qt5dYsqNp67L+icQ6+VmESsLnTaBnxctoH7jUSxwaN0GbGTfpBz9EARJUo4W/B
	EYXKDfx8lo+KFATsQbXtMjn4pLMPtas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576361; a=rsa-sha256;
	cv=none;
	b=dC3e1gdoPYQ/fMpjcUxUl8KO454BslnlxIdu5X0ys/qq1p+TX22MO+QHEitF0aUvd5lwtD
	rjDZ6gaKJm6w3OKiUwT+Ld8mH17BG6F9Hzn4LDWwr1G6oUZl3b+uHpKduuUtqFGBloTVIy
	hgCVlX+6LzQr1iEWVfe1uTxF3YyDcvU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tqf9cy7q;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 923C315A1;
	Tue, 12 May 2026 01:59:14 -0700 (PDT)
Received: from [10.164.148.42] (MacBook-Pro.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98CE63F7B4;
	Tue, 12 May 2026 01:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778576359; bh=dyGIFBYBc7vTYuZy6i+a3650vI0jAfmiTjuPo3qSCvE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tqf9cy7qyK7wO0mURj4OkxuC09qcuxSe/gLANF/trgSU12x7rhxpikRgexN9FVIiB
	 BszJ05RqnUWKAUwmPZsYjPVjb56vYE4QwGKVxKFy0AhPzw2WF1Fy/p2fujmcbzRN5Q
	 38oQ8d4Ty0PDYDRU54DCIdUaFAyRlQJpifEDJnIY=
Message-ID: <31b1ed29-5645-4804-8a3e-8d63abfc291d@arm.com>
Date: Tue, 12 May 2026 14:29:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] mm/rmap: enable batch unmapping of anonymous
 folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-10-dev.jain@arm.com>
 <a8aeeec5-5913-4b1c-80d0-ff49928d34d7@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <a8aeeec5-5913-4b1c-80d0-ff49928d34d7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D810EA0002
X-Rspam-User: 
X-Stat-Signature: q9cpz93mog585sem4ka81cdughpy36nf
X-HE-Tag: 1778576360-897652
X-HE-Meta: U2FsdGVkX1/zYev6leiSQoTyG/iEYQUplubcjI6x9/z6jRDsBHx8Q2/0fGfYe6x/NY4Vr8rjDd3iyeUEwzSz43d1pgQmZ2ZHAhHeVCeiIYHmkV3pTPVSiVa+fjfutvCx7dZ1jqexzYLiICQ59Jy9Wq+fRbtGQilkc99sJO7IWxcVk0YUYkB1Tm79GRXjwUn5dBMADlwGF965VZanIigzHY+GBz1Flq+84+B575d1xk0qBiHw0WPbejBXkKC0oPuA1eurCm3aqGeltkHUUeXNUzsINuI5G8QdzcT7S3yiZLnuXpdiKSbDX6EyeyCO4beBzR2rb3mE1YjY99BCJNVsjEJaq0836snueQ8WdKMCAnx9Y25y1PL+tf3ZMAmbYlDhmdR7KLPKugbLpDqwp1vHPPoeSqaqr1BvCSe1f/a5iNq9fBHC4KpGZt8+BthQlAdqeXkhwN9vuendqDk/seR2t7rWtHGeySWEmXK1Zfzs+5d+gm1GmfVcRhZ0Z2Fz4kcNHEw551JsusOosIzhiSiVQVW4l5hMmRTYlAgSuh0QR+ovdx0a1/wla6lVcbcj4GpMvqgakxA5HaJO086gxmtw4xa/63Z8LIlf/aJK+ztli9Azq3Pod6ASKMixcBXhWYzYPaUWSpBFzPufomTD6nwrVctOneA0gVd3pf5T7+cnPHJ33igi4kVnXkw5IGS1PAcCCBTNlcFuy3PG+8N4Yd7mYyLVtbWggI/x4A1kdm0YEOgQwHbW0XPfJwtePjnQDqgorLdq845wMkSW93MhD/SpdnCxJz8fFUfD7eis+AR6UqMcr6tVHRpWhdYG3zCppSWlNO3fOnzIZpwIzlHRmfLEXNeJ2nfR621OVBOTwCixLpl8JehdQzJAtker0D4coZmhAB/8bYq8UXYDEBB0/gdu+1UYETpv62JabPaoWxNKA6CD+ErUL8Q8zU0U4Am2+bHV/U4EvvZXcGdAuHXTpTy
 cB4aLmsr
 oQda48+rQeCA+OUTlAiIVgG6Axt6dI9kHay/BbOO4QH4BDzVA3byVzsU9yJ2n6nE5t3jcOR2cqlygey7EtHCMzWwAG8M2o/KwNAUFMwqUPNxTVLGbmbog3kKHFD+Yqo90Nyqacm7QmeREnMR+QImblcVTrjzvRfJ4UR5uu2iNJy68PLxGh2feI3NWScTWnBN/MGWlrtbQVQIbzKVYeMBxq6VL3tg8DNOLIbxKE0KEApphhoM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/26 1:46 pm, David Hildenbrand (Arm) wrote:
> On 5/6/26 11:45, Dev Jain wrote:
>> Enable batch clearing of ptes, and batch swap setting of ptes for anon
>> folio unmapping.
>>
>> Processing all ptes of a large folio in one go helps us batch across
>> atomics (add_mm_counter etc), barriers (in the function
>> __folio_try_share_anon_rmap), repeated calls to page_vma_mapped_walk(),
>> to name a few. In general, batching helps us to execute similar code
>> together, making the execution of the program more memory and
>> CPU friendly.
>>
>> On arm64-contpte, batching also helps us avoid redundant ptep_get() calls
>> and TLB flushes while breaking the contpte mapping.
>>
>> The handling of anon-exclusivity is very similar to commit cac1db8c3aad
>> ("mm: optimize mprotect() by PTE batching"). Since folio_unmap_pte_batch()
>> won't look at the bits of the underlying page, we need to process
>> sub-batches of ptes pointing to pages which are same w.r.t exclusivity,
>> and batch set only those ptes to swap ptes in one go. Hence export
>> page_anon_exclusive_sub_batch() to internal.h and reuse it.
>>
>> arch_unmap_one() is only defined for sparc64; I am not comfortable
>> regarding the nuances between retrieving the pfn from pte_pfn() or from
>> (paddr = pte_val(oldpte) & _PAGE_PADDR_4V).
>>
>> (And, pte_next_pfn() can't even be called from arch_unmap_one() because
>> that file does not include pgtable.h) So just disable the
>> "sparc64-anon-swapbacked" case for now.
>>
>> We need to take care of rmap accounting (folio_remove_rmap_ptes) and
>> reference accounting (folio_put_refs) when anon folio unmap succeeds.
>> In case we partially batch the large folio and fail, we need to correctly
>> do the accounting for pages which were successfully unmapped. So, put
>> this accounting code in __unmap_anon_folio() itself, instead of doing
>> some horrible goto jumping at the callsite of unmap_anon_folio().
>>
>> Add a comment at relevant places to say that we are on a device-exclusive
>> entry and not a present entry.
>>
>> If the batch length is less than the number of pages in the folio, then
>> we must skip over this batch.
>>
>> The page_vma_mapped_walk API ensures this - check_pte() will return true
>> only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the pte.
>> There is no pfn underlying a swap pte, so check_pte returns false and we
>> keep skipping until we hit a present pte, which is where we want to start
>> unmapping from next.
>>
> 
> This patch is doing too much. Please separate the cleanups (e.g., moving stuff
> into helpers -- that likely should have a ttu_ prefix) from the real deal.

Okay.

> 
> 


