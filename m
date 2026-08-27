Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F347C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE4A6B008A; Thu, 27 Aug 2026 15:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F366B008C; Thu, 27 Aug 2026 15:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466526B0092; Thu, 27 Aug 2026 15:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 259E46B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:17:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0F6C16019F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:17:00 +0000 (UTC)
X-FDA: 85148007000.22.2C35AD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id CB4B31C0006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:16:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dV2N0mMd;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787858219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEpP2BnAXHQluqzj3NyGIHq87SgVRnjT2448sKJuaD0=;
	b=fXPLMxW6wb5FbncVuPIBbIHp/B2TTrRlbPMOanc/vUcEGJsvu9+4ii3xc4vRwkVKPEfNau
	hNuZiSPD/aFOEEcRwPyTUpKHDr8uT7+kc4HkMlvvE8uCyZEprWI1RllR5FnUwruPbsxxiP
	1sN8n+0/HVO8/3dVNtLIcb5ppn9C3vM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787858219;
	b=e3R53L4XAG6TadDloFF6WGvLA+QfiIJae+Vj0rki9DRGFmmnty3Z873bbIXjx4bHYxCRL0
	LqD1TWfkN7Y6gFidQbreIEq4NgPjGFbZTwPf1FMY7EHBGeO/Zl/dUo9yJ5MYSS33gcPidJ
	frbtCYe7SJR1/V3G8dbVW+iSKmmE6EA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dV2N0mMd;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22D24439F4;
	Thu, 27 Aug 2026 19:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD871F00A3E;
	Thu, 27 Aug 2026 19:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787858218;
	bh=cEpP2BnAXHQluqzj3NyGIHq87SgVRnjT2448sKJuaD0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dV2N0mMd91+dFywln9Jt35a4npPi8ZYKFRMHClsuAqmc5A2CnQBpQWHHE5ipIMGfg
	 XSqcUXS85DE0wspKZyZA/QgsbnFi1f7gi7+I3EO+qWMa/YNsrR6qcG5p7RrN/roDAi
	 2ZyQYxMTG/bLiJcP2eHF5aFNafwnw451+SszpAWWyupzns7JJRLLA8z29tMH0mx6uP
	 ibg7ixsLcwWnQHhVyDfNRGV9wk73SEp6x1GjHXVY8+mt2kfQunjIsoazSznTtYT9ZM
	 5MK+sOuWN1KLvd0eMmTNX2+3wPSB3yXSvB50WcyoMDQOg/Y2J8yRj7avEe+5NyzDbi
	 w6ghhttrBtKsA==
Message-ID: <02cf0864-9a0e-419c-abdb-361bf32f43be@kernel.org>
Date: Thu, 27 Aug 2026 21:16:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm: gup: cleanup gup_fast call chain
To: Aristeu Rozanski <aris@ruivo.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <20260805035847.936054733@ruivo.org>
 <dab040ff-e495-4e7f-9932-c60b8299b89f@kernel.org>
 <20260827191042.GN1736962@cathedrallabs.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260827191042.GN1736962@cathedrallabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB4B31C0006
X-Stat-Signature: 57163w7fscr6hogu9p6wfeaodt5d3mh6
X-HE-Tag: 1787858218-867106
X-HE-Meta: U2FsdGVkX18QBGJ6b4nsET3pXGMUzECFbL3d7Wn06GERvkjSbbON2yWcQYCvcx+fEbSJ80kUDSn+tchrBbHHpbJ8lvHfR1Jmfmy5lmCr9znNrizgrfZb+hiPwXXZSSQuVIfxJjYU0jG/MsA6QsqjKvZDJIc0QzKFARd+pDFP3gcNo6pyTn6GWZ20iikjUyRqHk/Sy+eJ+vuYSjt6xrj2MoTJBTSL8fSXnozx/u8z7TNTY5afooVIiM/RO72y5hBymy+kfURuVHtkk7/bafgggWb0bAppE+gPG9427tccHTuY0x0g0L2s8rtA/xZlXySQuBneg8C+IX1ryNb4WUunh9Ji/arfXRx0DBYWMwUMsO/WW12EZJJjUjZ6p8xQdGLvE+uA4gRj/aMzqMGmf1efU3qo0DplpizEHY39yl2YxAI8w4Bb5NsaZwKXsJCfc1Xo3PCga/Hc/EgwbjvJYYWol1k+ru//jhovedoIf0oJV/J3GRNTerZsMkzKK0OQIo4E4NxtP2JgP5ugRwSK1ZHLZ97mu7w4W1yQvo25jrkru1C+7nU/vpjfIeBVb1ksaimrtKrR1EKzmQHoJp8GtCViB9Vcth+pqWv5SDK8E9jkmqjq084I9URmekD6Vtar6T1FenrJnZxJlBhR7LK33do8rGFfkbcolbMLEqeTnnNhleCq9MOwXKhIKxKf3iiLJk38Wo/3e1B2kF2cH0KvHXbSXuU3/aP8Y3tvH5zebi+5ifibqKAWAUa8G+W+8u+5pa3kVGVpCjkNkBnHeEmDsMUxPLLWUsnc8Zc9Qv6RQLxCtKSgvevkpBAWkAZ02nbc8iEfpm8aJcR744zkJ/c3OC1pHRsFcSq0SyZsxQVcHQ7lf9N8qJiMhhZCJMe4fW2aXsfl7tkVlZnPU+DzIJMv4MlPdS7XTYTjG9gVivDnlminke9WfFS8XvAcFYj9g14iqeDMFpdL5ywnB+WeTv3M75s
 UoBXKhES
 3/RA5fBgz4V7hMSrJCmGP1kJ5GXIudNgS4NzHls1HLE3zwsUK+eYVhnEcfIQtPSLysz4t6ye4BmFS8ztFH3DwP49NscXnbRjQ66fB1Cq9QZ3WO43ASqWneDO2W258TDONEyJyx+FSpkZ+Ge1WRKeM4gUwA5k3W4QwDx/14n9rJTJFnKFSddFjbMkUS54IVsQ357wMJnwAm9DweYSrqOxBPSKGayajRFdSFwQH3u0h6JEw70ftuJHxZCGrpXJOmEDmijfmCZDWDJQhFbI4+C19YDRko50bEkw2kxGEg/RkC0bg6Yn4JwDPrTgPlCvjofwu+QfytqGtG+ykZJVWFsN+qgnpkb/mQDz3mN8a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 21:10, Aristeu Rozanski wrote:
> On Thu, Aug 27, 2026 at 12:01:17PM +0200, David Hildenbrand (Arm) wrote:
>> CI flagged that some test cases fail:
>>
>> https://github.com/linux-mm/linux-mm/actions/runs/33031249149/job/98384037627?pr=3620
>>
>> ==========================================
>> ✗ memory failure test failed:
>> # not ok 1 memory_failure.madv_hard.anon
>> # not ok 2 memory_failure.madv_hard.clean_pagecache
>> # not ok 3 memory_failure.madv_hard.dirty_pagecache
>> # not ok 4 memory_failure.madv_soft.anon
>> # not ok 5 memory_failure.madv_soft.clean_pagecache
>> # not ok 6 memory_failure.madv_soft.dirty_pagecache
>>
>> and I can reproduce locally.
>>
>> They do use get_user_pages_fast(), so it checks out.
>>
>> The following fixes most issues for me (there is still one failure on my machine
>> but it reproduces even without your patches, so might be specific to my machine):
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 9b68242b6b602..a4036c02e2137 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -3010,7 +3010,7 @@ static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t
>> pud,
>>                 unsigned long addr, unsigned long end,
>>                 unsigned int flags, struct page **pages)
>>  {
>> -       unsigned long next, nr_pages, chunk_nr_pages;
>> +       unsigned long next, nr_pages = 0, chunk_nr_pages;
>>         pmd_t *pmdp;
>>
>>         pmdp = pmd_offset_lockless(pudp, pud, addr);
> 
> oof. You want me to post a v3, followup, or you fixed it already?
> 

A resend would be nice, so Andre can pick it up (and somehow sashiko refused to
review IIUC).

-- 
Cheers,

David

