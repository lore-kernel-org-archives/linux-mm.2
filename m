Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D71DD4A5F8
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 01:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52A976B0005; Thu, 15 Jan 2026 20:26:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D85F6B0088; Thu, 15 Jan 2026 20:26:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5326B0089; Thu, 15 Jan 2026 20:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC0C6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:26:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F4801BCCF
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:26:16 +0000 (UTC)
X-FDA: 84336086352.01.676B4F8
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8349E20004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:26:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F6SB+8K0;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768526774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuEXkOxJzOQTfqz9UqIXyqfyYfaVffILd2CeD8duhw0=;
	b=H8rZ8SMHEGXALova2rAsRwQw12EzDOt5bqCQHZv2CxqOPqhjEMaYdzNoJ0VvDD7cfHbybG
	HkVM2hdEGVsQmFEKhqUUMvoK/xJnFxxH5Vkxz7PWEzYbt15YzitKUarpGxAk9DUdL4CWHW
	PshCzuQpyvg11V4xPLE4dSZVkBnPJeg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F6SB+8K0;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768526774; a=rsa-sha256;
	cv=none;
	b=N4MBFkSMdsbS3rI2nQaFgo7JbyB0Zmv+tVdiHApbhR9YM3JJMhsSytuGYwOqYDWVkkNRk/
	fO5j+QxiJo5TbbFrGkVQuSmaSOGHFRMtT98201YLWMuvuglhRNzRoB5ubLh6y0ThKG891S
	WRxy1brhaoDZJnSKPat7GPNaIber4vY=
Message-ID: <62e637cf-91e6-454d-a943-e5946bdf7784@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768526772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HuEXkOxJzOQTfqz9UqIXyqfyYfaVffILd2CeD8duhw0=;
	b=F6SB+8K0qMEmK182u5aL6lA52ZRM+q9D6PW81v7J9Lg3oK8MITOuakZmdJUuLqTK+OekPF
	00mnTc/5gGMxQlvucmY2hezUpIGg5MWqsXgihtgpb+32Xigp+kIsd8hKRkheI1/eDio6GX
	dFDtp/0tpFTtk+WzhY6W6jkJjUagm/A=
Date: Fri, 16 Jan 2026 09:25:54 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 1/1] mm/khugepaged: move tlb_remove_table_sync_one out
 from under PTL
Content-Language: en-US
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: ioworker0@gmail.com, lorenzo.stoakes@oracle.com, david@kernel.org,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "hughd@google.com" <hughd@google.com>
References: <20260115071651.42626-1-lance.yang@linux.dev>
 <0bc3807e-2c1b-43af-9aab-665ce30d49d4@linux.alibaba.com>
 <8754b56d-b9a8-4b94-b5bc-982384234527@linux.dev>
 <26cb8bfa-67a7-43d8-b431-a3307df3e559@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <26cb8bfa-67a7-43d8-b431-a3307df3e559@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8349E20004
X-Stat-Signature: q17r3ez3zsa1txk1rb8wqxzk791e8ncs
X-HE-Tag: 1768526774-710749
X-HE-Meta: U2FsdGVkX19/lXRh5zSeerHn8UQfF579RWU4uKSDQxBa9hEJn4xeGuUy72xxFn0pMBnasMC9TUr3yJHm5PlD9LcM9erVUZOB31zCIowLbMc/W1v3BoxlP0Zfni36HQ3wnEvWBbK2D0Eq7WsDLrSNPEReo0981vQKdW7/KjF0HDMVvBP0ZlW0uU8G9qofTOsSwv0eouRGWxEhx2TMt23A31f8s5GPMysJN7S/JofBVeo0bjYGLuQSklSyOhtyIag64tNiFL2Mm933EWaVnOR66G6EXDGrQDEXfD0KCPJZV00+CVl9DACE4vWTn2M7JLSyblhupRhhKRsGk4OjHtNFdwXoZ4gaFK6wgCjnKLDNeYZbS3myu4n+0BCs2WnPr4cz64RWYj1yLoQE3wlPvdUlSBzJqsgR1l9Pv10ZNvuML0jooCqJUD3040ODNGltR5CVUTdN65Hixf+gjkXFu+c8tXb4TRl1P7tAe4+4RXzzxOSjwudPjGrLFBSvn5gIySB60TCF5IRAxCi0XTJMBKh1ERojvSRWh8cLAg3OdgFaJCLw3jyXxnTsyloXctsOmU8UCO/kUYK+j2w/Crv1GOdR1CcIMDWIfs3Bcx6ykcIveN3SMRMsCCGgm8V2ITNY+GwlpMvesFI8iZiQpxVN5vYKhF7WJNagmoIpg9MZ2rS/Xe6uEXtStzujvLhpnxL7juPMCp7UKJZJbUls+jKOxZzeLmgNzfJXPkabtb4eFKkkyA4Ngr/YLgG1yOoRIS+EIG9iTz+nDhOHn+q0+9N/yah5gdLl73dSVsoNL8wSavyv7o+xG5DW/I+FXTwJG52GFe4ZoO/eUboOUyv57t5l9ZBzvDf5cZGen4F3TyqKTDxfsk1SvSsrhrNW4E+G0VyerOuw1+yzTrCOwBp5aLnWCdUddlmre+MblBFonUFcHexNryGhGIjHgDbOYkaJAOKRb++scWfu3s7yXhkwZbwuPkB
 yF8pXqz2
 rSidrR+X2oCWVKS3PaA4mAnanJU6jUdzkmAfbYPbvJHN2ZxFZUPufmUFwMSEABsC4erRbz/3AgvUZUAzFr5HINGd3CCotmfLQnMKaNyY9w6Zoee9aEGRiehv3q6jQ8t0OfrGi50+DP1PKbquwvoGDIlM8XTrmb210+cvUsqKD0OoR5wyGekFMq2NLn69w94O3RrvTFru/cc27PeI+vglz5D0LmPVltvOeA+MHCWsSsfuFoTgEwZsZVXQs0lvuoidH/iOlDA+obsJPjKvcv8HXUqPF2CLpBRZ1Qnz4WrHCA9+aC60=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/16 09:03, Baolin Wang wrote:
> 
> 
> On 1/15/26 8:28 PM, Lance Yang wrote:
>>
>>
>> On 2026/1/15 18:00, Baolin Wang wrote:
>>> Hi Lance,
>>>
>>> On 1/15/26 3:16 PM, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> tlb_remove_table_sync_one() sends IPIs to all CPUs and waits for them,
>>>> which we really don't want to do while holding PTL.
>>>
>>> Could you add more comments to explain why this is safe for the PAE 
>>> case?
>>
>> Yep, IIUC, it is safe because we've already done pmdp_collapse_flush()
>> which ensures the PMD change is visible.
>>
>> pmdp_get_lockless_sync() (which calls tlb_remove_table_sync_one() on PAE)
>> is just to ensure any ongoing lockless pmd readers (e.g., GUP-fast) 
>> complete
>> before we proceed. It sends IPIs to all CPUs and waits for responses - 
>> a CPU
>> can only respond when it's not between local_irq_save() and 
>> local_irq_restore().
>>
>> Moving it out from under PTL doesn't change the synchronization 
>> semantics,
>> since lockless readers don't depend on PTL anyway.
> 
> Cc Hugh who introduced the pmdp_get_lockless_sync(), to double check.
> 
> Sounds reasonable to me, please add these comments into the commit 
> message. Thanks.

Yes, will do. Thanks!

> 
>>> For the non-PAE case, you added a new tlb_remove_table_sync_one(), 
>>> why we need this (to solve what problem)? Please also add more 
>>> comments to explain.
>>
>> Oops, you're right, the original macro was a no-op for non-PAE.
>>
>> I should just move the macro call out from under PTL, rather than
>> replacing it with direct tlb_remove_table_sync_one() calls.
> 
> OK.

Cheers,
Lance

