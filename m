Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A725CC6B24
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 11:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554286B0088; Wed, 14 Oct 2026 07:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504BC6B0095; Wed, 14 Oct 2026 07:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41AC96B0098; Wed, 14 Oct 2026 07:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 221DE6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:02:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DF9D1604FC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:02:21 +0000 (UTC)
X-FDA: 85320942882.16.F5CEC7C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2FE072000D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:02:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vvDFoElS;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791975739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WODyRHZCqpCFnY9ULeQ8aRVFdb2QnTT9smgYMgrQ/5o=;
	b=1VUIWbyiwH8iMc87bzZ//vx8lkfVGUtKcTFmiJdUc4fWOYEHp05p1x2rFXNg9vOPyck1nr
	SH6p0ov7x3GXfBL5bt+WLG37dbUNhKcwL0J5TbfPcslygiSSHPAHn7bRmns3p9UryeY+VM
	U+8x3lUDgfawbfhdKejVE+T9NOQF0Ns=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791975739;
	b=QJ7KHmVC23/SZtrXegysacRurAQaP3EtFshBORalMtc/PcclS39eddd81ZolaGseRQK1ik
	MZ1bsbXPiuY8/DI+ACxe1VyAPveSBSa0oZBagCPWyuOgx8XBQEG3VfDSPSEJQBc8Unl1vU
	JqVwLhojAJRMaxICTPNn8IW6g3CoKvI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vvDFoElS;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFC671595;
	Wed, 14 Oct 2026 04:02:14 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 414993F673;
	Wed, 14 Oct 2026 04:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791975738; bh=oVNV5iMCm9Xg6NFTetIT77HNSLPF87+/20UvMr4ytKk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vvDFoElSzHAL7njvysTrWnNvK1GtCywEfeK9mwdUkPdlWjR25Zq/BQyZmqDvwvbw0
	 oeBbCutseoX+rcvFkBPEzdhk+v6NZrmCyMCI0/P+IW3Q2JPebR+H9x8kouSJavsQt2
	 hjGpBZtDcC3NjE+ByOKTUqA0EcsIv1XDwSL+o5lw=
Message-ID: <dd2cc3df-f8be-4263-9c33-cbf0f3343dbf@arm.com>
Date: Wed, 14 Oct 2026 16:32:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
To: Lance Yang <lance.yang@linux.dev>, Zhao Gongyi <zhaogongyi@bytedance.com>
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
 <44aba42f-0355-4643-826f-0c7abec4499c@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <44aba42f-0355-4643-826f-0c7abec4499c@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2FE072000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: eqpa7ibttfwjzz34r76hmowf3inkpqmx
X-HE-Tag: 1791975739-780352
X-HE-Meta: U2FsdGVkX18E/XuzEKsn+8bgDxYdoI1yOBfnNEfsh92uvAMoEjv3K8bW+oIoZZL4dn78n0ffQpe4gkEO2EzXyxHypewYuDSpr+i7eQDF9TFHUJjK/m6fynA5EBeTDh6f+A/+/Nd3wrfH1tCpplfFG8JB8NaV9T3EdeCe71ikadkSOWAnDC4PTok39aX7xELIa0xOGWm/fegXUO+/AJRo2T1wClTetN6O5LEN/lbeW6Oy7kEgWmqPwWkxsZNZEAFOKQVFLRopijll7gQLHiFu3N+lxWEr96rboDI2Yg+UjEYdAo2FmoneqS2mTg2Kjpo7eb1YmN6hMx/rq43hiwVotdwjNuxDz4+V3Esy8hYsOiD4UjcQO/H44MvhNIu50jBSeDWdqFiInx6ECF5RSFWBn9ghIwJ5nOwnS6FPa3DlnzKYUIRRObyTmXLrcX3nGPL6vQzyFt2755L2N3tpRRpTw44VhR1ViTyS+6HCcGcO0wEmk6r5CBA3IIKYCsh0UHMhglsRsX9mJ81zCUqgQzqVewZX+yR+YGhwBL5Zn2jH64jzxmKojzQmCPob8+1psskJO0RTIUEf1f6PldMADNS3stXSTwSXD9o/23I7hiCigkKKewC01g2qsEg2naC9qayn7DiutzHm6+eof3ou8a/z+6Q8fqOySGevh+MX09Xl68pxlf6rXlaCu+X6bqH85GgQJgD9vRkl9HSyPvz8hoFxWhAG2dR2INI4XnENTwXf8yhZ9D7XtuhQKzr94HGGZDksJy88TWTe2JFZIkHv3Qx83qbLkk9bvkt90QbdogGMHACu8g3WjBtfJIBYbrEMinOrh/44aYrisdU2Bry2imBKNkOcOqvOnxUIyRNladsNa6zlOlqMJljzcX8TcU9cOisL3p137qZFAm0Zt0ePhoLoRAgCg4u6Aqo+OCo1aU+4iYcQzBYVPdtgpkkuLJYos7i8ZPC+E/F9BZtci6x5aNP
 VDzj99JN
 s/Ub07sqXxQP1iU9//KCHMw12/x/xe7Mq2foBhrKjCW9RBbSEyOUrIKT0SBU42YSCPnEC5+wgDWUBxmRLDEIc20OcLlDnUXpotZ+/R7vqktEOFz7JJ87REwjnhvcqLKRo2EmDRNrCutV08PoaPNMbq681VYIaMI2OH3mxcumRhLncJlS7jsL/ug1FTFandnkx+puNMpTUzftFWBIqqdhln8pxrZPT4j9Bur6pQS/Vo+UwFokvewMFMW6pxiQ49p1gaUjT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/10/26 4:15 pm, Lance Yang wrote:
> 
> 
> On 2026/10/14 18:03, Dev Jain wrote:
>>
>>
>> On 14/10/26 12:01 pm, Zhao Gongyi wrote:
>>> On 10/13/26 11:39 PM, Lance Yang wrote:
>>>>>
>>>>> +    /*
>>>>> +     * Keep the producer-side invariant documented in pgtable.h true even
>>>>> +     * if a direct caller passes an invalid descriptor with PTE_CONT set.
>>>>> +     */
>>>>> +    if (!pte_valid(pte))
>>>>> +        return __set_ptes(mm, addr, ptep, pte_mknoncont(pte), nr);
>>>>
>>>> set_ptes() is the only in-tree caller, and it already clears PTE_CONT
>>>> before we get here ... no? Why not fold !pte_valid(pte) into the
>>>> !mm_is_user(mm) check below and return __set_ptes() directly?
>>>>
>>>>     if (!mm_is_user(mm) || !pte_valid(pte))
>>>>         return __set_ptes(mm, addr, ptep, pte, nr);
>>>>
>>>> If a direct caller does pass a !pte_valid PTE with PTE_CONT set, I'd
>>>> rather add a VM_WARN_ON() to catch that. Silently clearing the bit would
>>>> hide a caller bug :)
>>>>
>>>
>>> Hi Lance,
>>>
>>> Thanks for taking a look.
>>>
>>> Yes, you are right. The public set_ptes() wrapper already strips PTE_CONT
>>> before calling contpte_set_ptes(), so the pte_mknoncont() in the invalid
>>> path is unnecessary for the current in-tree path.
>>>
>>> The issue I was trying to avoid is not that the incoming pte already has
>>> PTE_CONT set, but that contpte_set_ptes() rebuilds the pte from pfn/prot
>>> and then adds PTE_CONT again based on alignment. For an invalid descriptor,
>>> that transparent contiguous encoding should be skipped entirely.
>>>
>>> So your suggested shape makes sense to me. I will change this to return
>>> through __set_ptes() directly for invalid descriptors, and add a warning
>>> for any unexpected direct caller that passes an invalid PTE with PTE_CONT
>>> set, e.g.:
>>>
>>>     if (!mm_is_user(mm) || !pte_valid(pte)) {
>>>         VM_WARN_ON_ONCE(!pte_valid(pte) && pte_cont(pte));
>>
>> set_ptes does pte_mknoncont(), so the warning will *never* fire I think?
> 
> YES. Just a sanity check to catch a future direct caller passing
> a !pte_valid PTE with PTE_CONT set, rather than silently clearing
> the bit :)

Ah okay you said "future direct caller". I got confused since if the only
caller is set_ptes() then the warning is useless by construction.


> 
> Cheers, Lance
> 
>>
>>>         return __set_ptes(mm, addr, ptep, pte, nr);
>>>     }
>>>
>>> That keeps the fix focused on not creating new invalid contpte entries,
>>> while still catching a bad direct caller instead of silently sanitizing it.
>>>
>>> Thanks,
>>> Zhao
>>
> 


