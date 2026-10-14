Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7501CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 10:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3886B0088; Wed, 14 Oct 2026 06:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74236B008A; Wed, 14 Oct 2026 06:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2016B008C; Wed, 14 Oct 2026 06:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACB236B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:45:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53C66A8015
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:45:40 +0000 (UTC)
X-FDA: 85320900840.06.6B07BB2
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf21.hostedemail.com (Postfix) with ESMTP id 05FF51C0003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:45:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FYzHg0Xn;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791974738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blI+0pSqSuATt3s7ccT3kLKAD9SFsP3tmGqnNgFKm2c=;
	b=X/AgR6nzoRWOUg+lhZPYgefA5m3mMlSeIbFnekJ3eSzOhuyGFeY3OmeCPnFGWtSG6o1ugQ
	ZSEbdCHaZAaqOW39fX/z09uu+NTlAUIFuOLu0TbZm+v7RSeNDf4A/JjJn8JFWKhmzp9Ur/
	c4n5AEpgRc9uhlRuSuyiGc7drxBCQOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791974738;
	b=wWVWclnJDv6mb0pCbL5sZpYy3x+oQx0k6kzJAzyMk4ySx6eO8yAnxDqFMBWwdCFDhk1LLo
	UO0bsEfIpSQuXurugyuv/EYOeCK0Iw48HR/At8Qt/G8XdGEZ1qhECD+kqxyH3ENjon8TLd
	RxdEpgVBE4wsGqjsaX+DMT1PEc91CLE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FYzHg0Xn;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4j71whs7pU+NnCMQt6l/U/Btk6pFemJHjPQ5tC3+JVI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791974733; v=1; x=1792579533;
 b=FYzHg0XnYGEUQq4gQZ5cIbHAgUUe4PpGS1L3xemdo1QSXQzcIC76202IsBVcUhpf6mVVskX/
 XK4ZbrCHKtKxf26lrd1wGSJh0rbd9KbjJDTAkElHSfV7oM+6YU8/nTeRR4QAv4kDQFKqJpC0wiE
 r0uD1vFxp4NgP+ne0cKlS/C8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 767be9f59756f718;
	Wed, 14 Oct 2026 10:45:21 +0000
X-Mizu-Trace-ID: 767be9f59756f718
X-Migadu-Flow: FLOW_OUT
Message-ID: <44aba42f-0355-4643-826f-0c7abec4499c@linux.dev>
Date: Wed, 14 Oct 2026 18:45:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
To: Dev Jain <dev.jain@arm.com>, Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
 baolin.wang@linux.alibaba.com, mark.rutland@arm.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
 <20261013153953.77575-1-lance.yang@linux.dev>
 <516828fb-558d-4a20-9532-51f50d6ba042@bytedance.com>
 <0bbbe312-47a4-4eeb-8299-1f20daf4e949@arm.com>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <0bbbe312-47a4-4eeb-8299-1f20daf4e949@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 05FF51C0003
X-Stat-Signature: ifzuwskurg6693w8hfos4roy5ys5gwr5
X-HE-Tag: 1791974737-130894
X-HE-Meta: U2FsdGVkX18mwpIaS3DnPgJUZqXrfw1xmuQZjokvNMSWigyXHetT/b4u+M3ZiyzSAKMCHLhG8QwF5to2xf/LPpBJrmIBVvd5brKba8wR6tXn6Qgwp+1wiDmcIFmiDjdSGags6tuZntCl9JnLEGoiE3wxWvIlD48VX2n6RJug0aoi5QSWlbXj++mhQOk1nFQaYhGGPm+MRHKTEJLTMZzJDfLDpzuOd8TZLAiOCjsuITyCgzQsRJ8TLrychI4p8woZEnsCBrWTnpRdhpJTJgVzkRhIEYadwrToGQs9AmDZRCJOuWO1R/ffFX15ZHPUNVDxGFBlAWuMB2mX6Iqd841dwDdtTArqHbO0MPh0NpbF+vzzDTVoQGq+9yTSRMgqje71uEzrPRqMoXXrh/CvHSGbAoNU7APEN05nedZ118Sk78lVDu+yOYWwhY52Xdiv692QYUhYkO1TI6XWNQwQULNtLVXs3idoqXNu51x40Nc1nyjK9Tz2b7M9bU3lm83QRxpTv9Mxsrdox+KJKuVHyHTKU0kgt4RWJGhq+Ed4AgQIaKaFtNYADWIMN8VXoOpkC+U12aI8DRtdEaut9P5lph0XxEFyttCTNKCmWCxNgEdtZtngv7NDICVZ+SSIlMrTb1WB4Vpo7J2zfAtHutKLxc1GtG6InOZQP0+khYS7FY7rb1/GecAuxb5ILhQ41RF+xugif0zj6wXdPX3Y0tNBRGB8rTeKK1c92SnJ7hQg7M7rpiOCnaMAyf32C0RPcEQAPJCyXBFqiQQiM0wQLl9socJ0nsanI/kyNGk909NqIWAb24qbeBXgn1JhiInv1eVio/Vr5x1lFE/f3nw8TpUIPvSwIAi/bsOogjLicH6Mt7cTTDPl5VnklkzW06hF7vCBwyOqEuI/LME9ys6gCiyb+OrwnPT2yCjPeu+xlQItnVbmNj19N/t58O1MhXNjRnR0Dwh2CDKTHWDQbcHW2z6RuXa
 kszXyQFW
 u6UROzdVU+vIJouB6ybQNLZVBlFXmwheTYOf4Piw8RYXTaqEJSGyuL8fKy+DHeTfk3TMjVDManvAIxxj4edJujV376mCZ0m9oKENqA5c+BpNtTYLBttCuE48h1d6kB4zeBh7oWKidD+IkonQLdTHboidZ4bFODSAUc+It6BdoRrWVo55csgTX0nMNl/pVx7qpqN38pZRelnbOlDtS1HGHuUVvL106pBi/Qygtxxd9sdCga66rOLJK5GvBOvmuTp1oOmvBd50qA0HwAavefP3CYO/FsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/14 18:03, Dev Jain wrote:
> 
> 
> On 14/10/26 12:01 pm, Zhao Gongyi wrote:
>> On 10/13/26 11:39 PM, Lance Yang wrote:
>>>>
>>>> +	/*
>>>> +	 * Keep the producer-side invariant documented in pgtable.h true even
>>>> +	 * if a direct caller passes an invalid descriptor with PTE_CONT set.
>>>> +	 */
>>>> +	if (!pte_valid(pte))
>>>> +		return __set_ptes(mm, addr, ptep, pte_mknoncont(pte), nr);
>>>
>>> set_ptes() is the only in-tree caller, and it already clears PTE_CONT
>>> before we get here ... no? Why not fold !pte_valid(pte) into the
>>> !mm_is_user(mm) check below and return __set_ptes() directly?
>>>
>>> 	if (!mm_is_user(mm) || !pte_valid(pte))
>>> 		return __set_ptes(mm, addr, ptep, pte, nr);
>>>
>>> If a direct caller does pass a !pte_valid PTE with PTE_CONT set, I'd
>>> rather add a VM_WARN_ON() to catch that. Silently clearing the bit would
>>> hide a caller bug :)
>>>
>>
>> Hi Lance,
>>
>> Thanks for taking a look.
>>
>> Yes, you are right. The public set_ptes() wrapper already strips PTE_CONT
>> before calling contpte_set_ptes(), so the pte_mknoncont() in the invalid
>> path is unnecessary for the current in-tree path.
>>
>> The issue I was trying to avoid is not that the incoming pte already has
>> PTE_CONT set, but that contpte_set_ptes() rebuilds the pte from pfn/prot
>> and then adds PTE_CONT again based on alignment. For an invalid descriptor,
>> that transparent contiguous encoding should be skipped entirely.
>>
>> So your suggested shape makes sense to me. I will change this to return
>> through __set_ptes() directly for invalid descriptors, and add a warning
>> for any unexpected direct caller that passes an invalid PTE with PTE_CONT
>> set, e.g.:
>>
>> 	if (!mm_is_user(mm) || !pte_valid(pte)) {
>> 		VM_WARN_ON_ONCE(!pte_valid(pte) && pte_cont(pte));
> 
> set_ptes does pte_mknoncont(), so the warning will *never* fire I think?

YES. Just a sanity check to catch a future direct caller passing
a !pte_valid PTE with PTE_CONT set, rather than silently clearing
the bit :)

Cheers, Lance

> 
>> 		return __set_ptes(mm, addr, ptep, pte, nr);
>> 	}
>>
>> That keeps the fix focused on not creating new invalid contpte entries,
>> while still catching a bad direct caller instead of silently sanitizing it.
>>
>> Thanks,
>> Zhao
> 


