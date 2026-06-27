Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E46AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 09:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F3A6B00C7; Sat, 27 Jun 2026 05:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57106B00C8; Sat, 27 Jun 2026 05:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B936C6B00C9; Sat, 27 Jun 2026 05:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95C556B00C7
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 05:00:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18989406B6
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 09:00:49 +0000 (UTC)
X-FDA: 84925097418.15.7068ED4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id B336318000B
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 09:00:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ckMRKwOr;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782550847;
	b=RiT4q36P4frjtHRDcKzQgeGYhe87viHGEc3tscu98YXcKD/nGtoeWKx9L2CNbmfjznVVcj
	DIhfCj0PSRtbXlRyUBgCpK2Pd4fVwM+ma9hKHFWx3MFWo7nc7z9RYO7loSY0eD8kIz574j
	uw6TEvPlWg0HtvAcOgJmiMU1KZitCRE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782550847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+B+5XHDEOIaoJiGrYwAZTBVUZIWjDN3PtKIsz2gYPg=;
	b=q859BOE7V+04dxj6525iUy56Mvhx2fv5ln48scDq/GOOMR1qfvxYHB5kKqJKZ8y07JFKLo
	MBeHuWx/KtLeaTzb30iWBs5ybzydUWzAhaT77HZ82v+JS6cMycVYWivz9WL0lvgys51mwT
	YAJa6d/72TD/4Ud++DpnEt7r/sPK7g4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ckMRKwOr;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BBD135AF;
	Sat, 27 Jun 2026 02:00:40 -0700 (PDT)
Received: from [10.163.169.90] (unknown [10.163.169.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3F153F905;
	Sat, 27 Jun 2026 02:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782550844; bh=G2e0ceuQUsxQ6NxyX9ix1UWAx5NCHXsCEJR9LZp7A7k=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=ckMRKwOroPTMOl54I45VF2b2udxZ3FbiCwnkJnkEvs8ajGIaDhqUWW9+kV0AoSFdp
	 CPlR9AcsXqgdvIi8tpl4p9T70ajPeWlZV89n+fYzkLIedmuftFMHwf3LKsZl+TOyUV
	 Vt28YHoPGsrCj+eWZNk1NZkN2kFTvSgqsBNl5ckk=
Message-ID: <0654116a-235d-4eb0-9970-414322645aa3@arm.com>
Date: Sat, 27 Jun 2026 14:30:32 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/12] mm/memory: Batch set uffd-wp markers during
 zapping
From: Dev Jain <dev.jain@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com, hughd@google.com,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-5-dev.jain@arm.com>
 <a9483db7-5b13-40ff-8d45-12f40dc97c77@kernel.org>
 <562addc1-b334-4258-b0d2-0154ffed061b@arm.com>
Content-Language: en-US
In-Reply-To: <562addc1-b334-4258-b0d2-0154ffed061b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bp95wfir967wm54bcm8c6ifr9xiemt9i
X-Rspam-User: 
X-Rspamd-Queue-Id: B336318000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1782550846-568876
X-HE-Meta: U2FsdGVkX1+kAE2otbWuDR5Epw/03L/Qg+ezHn9q21YqkEITFv9koy/KT1sl0ErM7D9gF3X2BVrfbRTW2wwvIBzq1TOUcd4xzguGPt9GucWYMBxPn99HHKIaAzbD+dWhG8X3uKcKCAHTpJ5nAL/MGOUp3bATXkQD8Cr6S+pzcjJEtLdy0cEqY45SEqdWBm/tR9arwVJfRe0cLXrxj4SqeDC/iQwTPGgii6fUl08hPEwbn5XU+8J7uEjU41p7BfmW+zFWg8W2/4h91FuqKQK0NL9irbcenPdeHdE0ogDkSGG93uWwca8n4rtP8BXuwefUUKSfjyIj9waGz3Vgx1vYw0S0k3T7z9WJzh0Lv8G6eV+jyjbpwBr4HqRnAPGguMGWIB9l8rnmHSPKarY02I8KqzBRmm5p+pk0VQUroPoso2zvnynaL/ZTxNgHQu2oHJw6K6LeHMf2KD2w4bGsRDs4kbXJPe45dJdej8udCXfVcuU4Pe/+gixH+QXM2wnrsH8/BILHGDsfsOmi045Flwe342i2mzAi85Ixqveg7pHjnHAaf57qEqeF8etoikmQ0nRcLTvUOyWg24D9EDJr3jSzfz/B/B4kSAFxd8i+sPYDmoHStiojc3kko9jtQ+5DISSHuUxFsjh0EtJY1LUCtV5tT0cvb5bMmocmq/DeCvcZ0iMszXnfpMAp4cpopoYAs+yCecdxscfJEg0ZC3LO1hi7mLVgeqIN+GZGZR1HJ+/ZOt7cyYgbaINUJOBH8dpapqMILmz8oDaDXtNP1oONZRnnSzWC+TmE84kW1J9ikbKIw4WBaVfPhbn7chWz2pNYpI/0On8Xvnvkc38PEbO2J0KKv8K4+jekTDdfbW5GJ99kM1X4ievYEFuZsX7LmLP4B9eoNnem9C7iMmbgy8YZGVYOun0uhkjzK0vN7CsPfc2ATSoICM7yYWLF1xNvVRCROnr2jc7/IUMPUSAeniRqqDH
 fttsEqMJ
 ufErtz439LxrEfwcizijFrPY/Idg+OCbMb+45ZynObpveOeFEw0WPdkVm3YSEa7a1TB5UDfHdiUl1YmD9SYmtrARAwuOG9aaNyE8EJPSC5YGsYyzbOYSJe7h5l0e534g0r156fzfxpkO8VdOmSAm+xbNCKBJ8M/ROYMhxnEUV4N/mQ2MnCgDJ6pYqvj6sJ+L9dTHwaK2z5fz+lYpULOnYndoi3/FIYLc1wdc0A42jh1PNBXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/06/26 3:31 pm, Dev Jain wrote:
> 
> 
> On 16/06/26 7:13 pm, David Hildenbrand (Arm) wrote:
>> On 5/26/26 08:36, Dev Jain wrote:
>>> In preparation for the next patch, enable batch setting of uffd-wp ptes.
>>
>> Avoid talking about "next patch". Phrase it as "In preparation for batching...".
>>
>>>
>>> The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
>>> that nr through either folio_pte_batch or swap_pte_batch, therefore
>>> batching is correct:
>>>
>>> 1) all ptes belong to the same type of VMA (anonymous or non-anonymous,
>>>    wp-armed or non-wp-armed)
>>>
>>> 2) all ptes being marked with uffd-wp or all being not marked (same is the
>>>    case with the pte_swp_uffd_wp_any check)
>>>
>>> 3) uffd_supports_wp_marker() is independent of the function parameters
>>>
>>> Note that we will have to use set_pte_at() in a loop instead of set_ptes()
>>> since the latter cannot handle present->non-present conversion for
>>> nr_pages > 1.
>>
>> Below you have
>>
>>> +	/* The current status of the pte should be "cleared" before calling */
>>> +	WARN_ON_ONCE(!pte_none(ptep_get(ptep)));
>>
>> Could we easily extend set_ptes() to allow for non-present -> non-present with
>> nr > 1?
> 
> We could have a set_nonpresent_ptes() in general, but then for some non-present
> configs like in this patch, we don't need to change the pfn, while in some
> configs like setting swp ptes in one go (like I do in later patches) we have
> an underlying pfn. So I don't see an obvious simplification with a common
> helper for non-present -> non-present for nr > 1.

I think a "non-present" entry always means a softleaf? In that case, we can
simply branch on softleaf_has_pfn().

>>
>>>
>>> Rename the function to cond_install_uffd_wp_ptes, and convert the
>>> documentation to kerneldoc format.
>>>
>>> Move the function to memory.c since this has grown too long to be kept
>>> in mm_inline.h, while retaining the inline hint.
>>
>> Well, for functions in the header you really need "static inline", so it's not a
>> hint and I would just drop that comment.
> 
> Ok.
> 
>>
>> However, the move while modifying a larger function is rather suboptimal for
>> reviewing (more like "spot the difference between these two pictures"). I'd
>> suggest moving it in one patch, and thenb modifying it in a second (this) patch
>> instead. You can perform the rename already while moving I think.
> 
> So I'll move the function, do the renaming of pte and pteval, do the kerneldoc conversion
> change in one patch. Then batch and rename in the next.
> 
>>
>>
>> Nothing else jumped at me.
>>
> 
> 


