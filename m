Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C4A2CC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 06:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F226B0095; Wed, 14 Oct 2026 02:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966686B0096; Wed, 14 Oct 2026 02:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2336B0098; Wed, 14 Oct 2026 02:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6368B6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:46:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D573C12040D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:46:37 +0000 (UTC)
X-FDA: 85320298434.04.785E842
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9AF45180004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:46:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XduXr+NW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791960396;
	b=xCF52Ui5NTcPVL1SHKJqyHHUKVb2s20C+B4687jkJ1gNkouEcQ5Ky9NuxDAzYtqbXDtQUk
	FNJrOsGfMKsp/UU3PZ11Ihf0xRRYMHPWAx4y7fNnkjGcoouZmyRqQOm9tPx03fPiWSyMAn
	DEFYajvG748XFvyXxQbzHFnYBZmwbIQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XduXr+NW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791960396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyOVQO2Ag1zGISI6pO5VoA/zNNqmIYt5vkvpyI+5aQ4=;
	b=ygkqJFsdSBiFFqc59wwUru0bNfIqpY1KoxdIkVrBhtSXVMvc7nmJyWf7HOmt8xgTu858ab
	nCXi0/q9XjMnXgv+r5OHiGWDEjNP5A38eW3faC7MH3ThaofoP8UugerT5vc9kNs5uNmd86
	Mw6u/dLmD/deVMwmvqBZj9XKPRWDyoU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JLmTAoue8gGf1ERWgAb5UXzBAVBda1/ywkl4q8ms6rw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791960394; v=1; x=1792565194;
 b=XduXr+NWEQc2k1ced2e4wi+9s8WN76WAicldStKItAcufoJI3wVXZKFuaTRVUBF7ND96HqvN
 R0eN5dIVH8BZYV8hJprCPN82Jcgo77XC6FmBjysbkspL0JlH5jDAJN1pNq1vsLzkIQt/NFOchYo
 W3JiTblzWUaZR9iCpLyqRV+0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b9d4fb5be1186799;
	Wed, 14 Oct 2026 06:46:34 +0000
X-Mizu-Trace-ID: b9d4fb5be1186799
X-Migadu-Flow: FLOW_OUT
Message-ID: <f111bec5-6148-4649-8805-79a250f6e736@linux.dev>
Date: Wed, 14 Oct 2026 14:46:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
Content-Language: en-US
To: Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, mark.rutland@arm.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
 <20261013153953.77575-1-lance.yang@linux.dev>
 <516828fb-558d-4a20-9532-51f50d6ba042@bytedance.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <516828fb-558d-4a20-9532-51f50d6ba042@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wkwjs1apz9j7d3qwsjwcy96qsfzntefg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9AF45180004
X-HE-Tag: 1791960395-101050
X-HE-Meta: U2FsdGVkX1/QjtsL1hsQ/oZf4Noq4DZXJsbI9IjKkQQ9FpbPnBo748V9lI0H96xR+GcVIAGJmwdlVDvcAam/AbTGnwuG+Nw6XkNYIoZCshdXDG0yle3rylfnOLGN/fssQn9DR2gM/kyhGdDHX4EmgY2TPW9GBdPcjCYaotX9rVl5U8KZVAlyIj6RnZmUB2JRY/WT4fQ5Y25ombDmAYronOVXj6exwxzGMSk8W/edLwhEFc7R1OwPYTuUjfmxMS7e7cE6SC6T3vCOlxLWc9PhAlp4TU3HEVan1zR58HKDDIZlCweroN3C2tw9HOQlO25kEKmQoeORBlBnFUno4Hd/am/ZP7iyN/Ri/wF6frNqACCZePUrht6HK9jvmnhrloNOnN1E7ouvN0vRnuZYPx0ii9xZcJyP6q6UVeBpERRn3NvN3CkmE5wpbhilEcE+43+V1JWnZMxSc1qHSdFmzhsIpFLNjjJ0nejLI86hwa2BJWQb/2gIKIut3flzTOCsXp5P6Ze6KplQu7YV1TT9wkNhh3yCyXNQj0jpuidJCx53511R3k3Ac7CpJy5pb1WqJTalIisHNVmQ4Q+HTz9DjQ18niSh0/TZnflgQSXy2OptVBxeLxYMQo3xZx2diGeQx48DB/BCznuqyg2ug+DcrxNTeR5WKK9DQMW5xbZ5KhzrBKHJ9kDd97BGTdxSuYcfMqcP8D+0xsR7IsZlBRlhVSftY3uiDwzjbAV/lDPLaNEMlplIJh9+SOzgcVjTb7OqxQswVQ7m7uE7cr2ZfC3uXwzMRVcjbeyCxEIFSK21ODq+7h3vx/Wzdgqc1JtO1l5TXGWHv2lQQzLkv67qSkP8Y2/qZu1Zw85pCnk/gkVNmQF1trxQ3XPMotRSa30e6t+tXe+DJFCjvowLrTAb7dtaLKf7sx19mzqH42LlbjsjzWPARPHideLG3BhhDoYkuLOhfr5IPbnP4AXxocAJdE3Z7jl
 V82uOizr
 hXdNARF+jTFXbJX49V7oZcin0gCGahsrQZfuGzROfmDx7fXBhvDfS10aUFLD6NR90MMfaWgIfOyEMBbJgSLu85e4BojgA1LBt4JuTAKvPMMuc33G319n67DW7lGC2lb1OzmkKKb5b1SbgkSAh6sJCAuuUQs1a6kLbHnM7njhW2yqBosZ5vs2RN0YZmiuP+NoIJGd0PCDUZPBksZPEgCAmbXkIsHNMoi6rWNptMMdmsdxZdaZ6kpXz70mys8wA9OW3KF5gSMpR0zbP7397G1NWGb/hvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/14 14:31, Zhao Gongyi wrote:
> On 10/13/26 11:39 PM, Lance Yang wrote:
>>>
>>> +	/*
>>> +	 * Keep the producer-side invariant documented in pgtable.h true even
>>> +	 * if a direct caller passes an invalid descriptor with PTE_CONT set.
>>> +	 */
>>> +	if (!pte_valid(pte))
>>> +		return __set_ptes(mm, addr, ptep, pte_mknoncont(pte), nr);
>>
>> set_ptes() is the only in-tree caller, and it already clears PTE_CONT
>> before we get here ... no? Why not fold !pte_valid(pte) into the
>> !mm_is_user(mm) check below and return __set_ptes() directly?
>>
>> 	if (!mm_is_user(mm) || !pte_valid(pte))
>> 		return __set_ptes(mm, addr, ptep, pte, nr);
>>
>> If a direct caller does pass a !pte_valid PTE with PTE_CONT set, I'd
>> rather add a VM_WARN_ON() to catch that. Silently clearing the bit would
>> hide a caller bug :)
>>
> 
> Hi Lance,
> 
> Thanks for taking a look.

Cheers!

> Yes, you are right. The public set_ptes() wrapper already strips PTE_CONT
> before calling contpte_set_ptes(), so the pte_mknoncont() in the invalid
> path is unnecessary for the current in-tree path.
> 
> The issue I was trying to avoid is not that the incoming pte already has
> PTE_CONT set, but that contpte_set_ptes() rebuilds the pte from pfn/prot
> and then adds PTE_CONT again based on alignment. For an invalid descriptor,
> that transparent contiguous encoding should be skipped entirely.
> 
> So your suggested shape makes sense to me. I will change this to return
> through __set_ptes() directly for invalid descriptors, and add a warning
> for any unexpected direct caller that passes an invalid PTE with PTE_CONT
> set, e.g.:
> 
> 	if (!mm_is_user(mm) || !pte_valid(pte)) {
> 		VM_WARN_ON_ONCE(!pte_valid(pte) && pte_cont(pte));
> 		return __set_ptes(mm, addr, ptep, pte, nr);
> 	}
> 
> That keeps the fix focused on not creating new invalid contpte entries,
> while still catching a bad direct caller instead of silently sanitizing it.

Thanks for the quick fix! Nothing jumped out at me :)

With that:

Tested-by: Lance Yang <lance.yang@linux.dev>

