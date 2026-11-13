Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3335606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CivLyJHr
Received: by kanga.kvack.org (Postfix)
	id C52776B0696; Fri, 13 Nov 2026 08:17:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2A3C6B06D8; Fri, 13 Nov 2026 08:17:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2606B06DA; Fri, 13 Nov 2026 08:17:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DBF86B0696
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:17:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B8EC1C3C24
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:17:03 +0000 (UTC)
X-FDA: 85430146326.01.2C159A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6E41020002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:17:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CivLyJHr;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794575821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/lFPjYkfyvd9bsV97VZl0i3yOB/qzb2CVkcE25kYJg=;
	b=6sDrvYOrzgMF8L/C0eYenp5XKoLMnLIzr06z74NhEB+OrPLyNr+TEW5xxEzC12H/bmtWj4
	cmlDnNUuptE9Qvlq49LxEhRSqGa+m92KWNhhjdFKSC9IETbUqW37KH+2Zpa7v3SPX5lQWk
	kLklfmKLXAud0ZUJ+sFIuffSIn+f0/A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794575821;
	b=v2xN4E67102bJrmbY0sFwqmiofPnAlAjzD/lIaVA49sCRKCVHnPC+YcSN4YU59q9iz3rMt
	pkvEPfCz9kP7EacScnRnFpOu6E02DOEVa0gDU8xHfzcZ5Gl4dr3sAKZuYPTFYFnHSwDmX3
	IhZCgRUVkxKQuMakLtYqkylX3x7ZWio=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CivLyJHr;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F39FA618DA;
	Fri, 13 Nov 2026 13:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9C71F000C4;
	Fri, 13 Nov 2026 13:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794575820;
	bh=p/lFPjYkfyvd9bsV97VZl0i3yOB/qzb2CVkcE25kYJg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CivLyJHr7B/h6VXedWf4rDhzw48dN7J+NZfhTHijKz2usW5fkrEYfK5gxStT8t56k
	 7WMOIm3Qr6xNjK89skOn1gqcYsoeGeJBCf0PGnX/cvkSekPpRQAWztA2cgEtUfJYdq
	 thVkR6/ZE4ARHyezJ4UNqMT1XTXYsd3AIIq8dLjCN9dHMFLJEKoBLnuYqZOV93iEhK
	 V/O5yvhz1rLS3r9SbHbWfXDC8QLArEaleyUXpNEfDpYUBIEFPGR3aZ4teO74IQBub6
	 jQU8FDSUk5zpbEEb1/qOQNLFlVKdnfuWAFbV4nC8d94JkwgZlzV5TFZAwH7IAdQEQu
	 +m2MMU5Clgauw==
Message-ID: <575076ac-abb6-4e7b-95c8-872ea513ff50@kernel.org>
Date: Fri, 13 Nov 2026 14:16:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: use pte_table_clamped_end() helper to
 calculate the end
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org,
 hannes@cmpxchg.org, kasong@tencent.com
Cc: baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, mhocko@kernel.org, linux-mm@kvack.org
References: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
 <sashiko-outbox-212685@kernel.org>
 <9f0d2468-b086-457a-ad3b-a452020305f0@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9f0d2468-b086-457a-ad3b-a452020305f0@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wscp381r5n3xti4bfuys8yrn8b4wbttr
X-Rspamd-Queue-Id: 6E41020002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794575821-356153
X-HE-Meta: U2FsdGVkX19MPsooMb2RNyHqhAo9QmBkv524OnwFh+OgXIYzcs3DQoOLAUCAFdiwfwBpNeF139QjWBqHxlQUBU+rOokge6kksDHzRUKc5pQ9mieYgthpH9rWdwoUO0oJQGXfS5QDvHEX9ruVUvgl1c37dCW/TTSanmbCa7+s0sUb8kXXpGjE8iMl3bRK+fVducq/u2KmPVDzQIKSQbKca6NNT/QxQRlsLR1qyLwkzatDAVCVAF+o06RpomIHI65+AWYy2jzb9T3V0g5WmO3f5aHfl00jMGH8qftIEk4PjHSB3tggp3etH7YNYwe5c6d/4O3dDP/coIgJCfwW5rgATrekqk7AJHe2t7lZ8HtPE37Tr6Z2E2+G9bjuqqhF+hhKUZB/1oCQgINmXrybihMBkgoPfrvgZh0WOx2GKzo0hqHLt+9aF8fT25LM+FTaztis5zXEho3ObR2V1UcD5w2c2SNfsG9CKtRcLnVbb/LbUspHKFcWQ/60mM0/LDGny3PrqFudPqub0R2U+pUQaW9xLpiIBOYyX+oiU2LUOTRVjnaRNp24V+yU7Qvo9bxaNvzIG5G21RqW+w5kqmQqgpkBPtR7sEYpwMm8+gVX2tH9CZk14dHfQKS5tcrRnImfSQAxYtvC2Md7SjtXBvbBpVinMgyfqHGIOpDyKwELGW5jm1w2fbD3COVmcGJ8L25VNWUlYgyRNRHTNfqhoGtlfcdv3V6ym5Mr+9aI9Gd+FH0AgpjAovp72YnE/pEZsDWR1sgy5hjd9sSZIk/eAJ5j1CUDFQ2ipZhYR3TQicL1c4oEo0pONs1YJU5p7C6IE+Y5LFvdnDKMG1CcybkGGc/lCroZMSFJPATAgtpplLkzQkB09LIAbNCvzg01Sf5TWm17ezWDPdzgGHuFMae3TNvh/+t9gZBD/dDz+r5qoXuHyeLoJXQRrF2OIyDTH7lizv024z6pUHkl8KHNn/jWBgiHPte
 /EW2RTny
 AWOjLNj4QfgHoKcZfgF1DWE0XetEv+4e6+xXzaiXHqbgGadVEUYaPPGz40demmp+vo2zim8RDdWM/M05jkyw7UEVvdjFaXYyUgncQhflPfwSHtP0zJHw+GmwxXoiS8ie4Tll0nH0DI2y3aNqzpHXlS7W2KWbeH6Stb8nZ0LiCvzXq/Mv0BQrzkgQkcyvDLYCqBDfswOsuTiD9XfWTXbZKYwVCv1aKaWGBM4Fuc2ERZKzg7Mj39EwkATJbBkYRFZdE07fIiHZ1uWlT4LoHLtl2Sn8SFlRaLL4PvT7JoWGoLEA4BaNsevVcRkjoJyEZI+Zpox2ChkqKML9Ov/S012R3q4YEXH8hs32WF8Ss+STRLgx/wnHXx0IKQsq80bkVaCyJZc2q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 12:54, Baolin Wang wrote:
> 
> 
> On 11/13/26 7:13 PM, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential
>> issue to consider:
>> - [High] mm: mglru: call to undeclared pte_table_clamped_end() in
>>    lru_gen_look_around()
>> -- 
>>
>> commit 921adf1dcfd3cc8b15e0745e6085a76a09ac3fb5
>> Author: Baolin Wang <baolin.wang@linux.alibaba.com>
>>
>> mm: mglru: use pte_table_clamped_end() helper to calculate the end
>>
>> This commit replaces the open-coded PTE table and VMA end address
>> calculation in lru_gen_look_around() with pte_table_clamped_end().
>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 25a224746c36d..cb8635e41a38a 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -4340,7 +4340,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk
>>> *pvmw, unsigned int nr)
>>>       walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
>>>         start = max(addr & PMD_MASK, vma->vm_start);
>>> -    end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
>>> +    end = pte_table_clamped_end(addr, vma->vm_end);
>>
>> [Severity: High]
>> Does this break the build when CONFIG_LRU_GEN is enabled?
>> pte_table_clamped_end() is not declared or defined anywhere in the tree,
>> so compiling mm/vmscan.c fails with an implicit function declaration
>> error.
> 
> No. Because you applied the patch to the wrong tree (mm/mm-new). The helper has
> already been picked up in David's mm/core.git tree.

I'll get the relevant fix upstream next week. Once Andrew rebases he will be
able to pick this patch up :)

-- 
Cheers,

David

