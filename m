Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D560FEE642E
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 12:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E4D6B0088; Wed, 31 Dec 2025 07:21:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4465D6B0089; Wed, 31 Dec 2025 07:21:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372FB6B008C; Wed, 31 Dec 2025 07:21:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27B6B6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:21:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB4401A81C0
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:21:20 +0000 (UTC)
X-FDA: 84279676320.20.A4840E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 13AE540004
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:21:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fsHKDW85;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767183679; a=rsa-sha256;
	cv=none;
	b=ZzOQ+5o46ReShLlikKXe4m8rlWLz8ZSrKOJOMk+vdX8GNzQ7zDe7bA0ZpdkYqfw7lkfM/9
	LxrAHVxNVzXi8B/2iUsuZ36Mhg/NnKdcOIMKqZ8iU3RkC+zA3Qa7P1ZLM1AKBgThSoy4Mp
	m//QcLT5W8MEJZRaHZ4TDygo/J+Hjt0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fsHKDW85;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767183679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5yUllBZRICPghEcqhs/zzNseWFX/hNU3nxa0gIGachA=;
	b=7FDtwgTDYEckQQwUGyLWoKvCJ9nlHsKwROg/PexIiVrc5ZWSapW94iwe1zj6B0wxOJT8cs
	94U2Pf40JFj2LEtPt3L8RSzk60jY3O9NrLvI+9YijQ1dm4o94s1VjT2SPrk19Mx2HCxKvG
	gj/lPGP9onJazkmORO55My+tc2ZUxto=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BCA1423CE;
	Wed, 31 Dec 2025 12:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58764C113D0;
	Wed, 31 Dec 2025 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767183678;
	bh=rwOuVs4lpDDF8bKqR4rIsZbo/WNCoOlr6UVNDV5zcrc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fsHKDW85kpgeh5hk9sfPbsVQiXI2NRDc9AFhqDOQFeWTdCGVkAEHcjUk//b9zVU40
	 i0k1uSSvdRpjyAz71zdtC7pLe1niNddntqdU9x7HBhEzvnBnNbw94WVHfH6NXrNOSP
	 cf2yxUJmksMtRrrm0xom5u9fEMJLIL3djtPPD2ezQURTVNdVfORvQoOUjX90BElub4
	 uYRn10UUxF/BaFLDAcKNX4GeTPnK7QOMnVMsf3pRKgWgdV2VMiZWV0WyfedgYMgLKY
	 GmqqokazWPglXAK6QUzirHH6LgNYiw9DApVCw7W5tWzOefar+iSxITAHgPb8JhkfkV
	 hl+4ekmargpAQ==
Message-ID: <9c3b81da-f0e8-4652-8900-05593e124c26@kernel.org>
Date: Wed, 31 Dec 2025 13:21:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: khugepaged: set to next mm direct when mm has
 MMF_DISABLE_THP_COMPLETELY
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
 <20251229055151.54887-5-yanglincheng@kylinos.cn>
 <f47b6192-2115-4f4b-82ae-dd66e65f4340@kernel.org>
 <20251231025112.uzlgrs3dgbyzul2x@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251231025112.uzlgrs3dgbyzul2x@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 13AE540004
X-Stat-Signature: 496rbdf4n7itbb1m3t6pu681y3rdyi5g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767183678-930256
X-HE-Meta: U2FsdGVkX1/dbWCic9mOzTA5jF2w906/URulCiMm074FJOnjBQygbdRHsztn6uttSZ3ooimOqQJK2+yM5Os72d2f1VIuPf4y5ETQjJByF4iB8WKvcbZx1M20oiJeg4iaA7FmMzq0ba0Jv8mYap+pDFUgy+gNaMORlq/fC9G1wkhoxm8UhyQk4BWncQUEnS5vmkvCOLZw5V2S0onvOQ4JOLwJA3vxlGe9HLp0T2KggyyNFnmGG51dg9SuUWCEX+5lqO8/Nl2wC+bAJBsAuSsGsNFViGGtulF0xHe+lZBh7QTStc3UmfJKui/cjGwrrp7jjBEFi7rw71ELA6I+Bk8P819iH1c8rG1jjED+C0VmDMjDx4lLjAyYpzbcy7/4l0/+sh3hXxZoDbRIT5oHDcxvhmXU4Wahi22Xq64mW3WtNM2+AZxj0/gzrhDpTLGLnegQY7fCGtswXQrnqzKi0FxR64NIw3JN5dZ5xunYLcbv3+cMtNDfMEfJHanx2XbUYRsCr+9vToYqdct5fB/2SLx/dHiBwA+yufiQJacQL45FN7ZuiPkQz2+/7UEgARUartnwPg9ORUat9C7MXRrWqBos+kbpU+vErOrxguhz6qOCcG/xe7gPsLCyWzu57C5bIDoTN0PLFskQNCnv1ICvc962D2stD7rCsinujmbPbgVwbNfa79lEMDno+v3LmLAbV6fGplWnHLC/xCGy9yHPE9JuEkaWj4+yqamzN+4SkuE4shPCnLxxoSAeH4oNhbyF6mE3odVp2irXIRxORT1nqULWVl6QqnLxPDnHQ5gyFiaMtDuhU2fIF04lRAxItCMbWIb8s+5tArRYdvVE45LiMVeAutERe0FmNHls9yFykpePPWN5yq88LL5pUsvbSqnNBx26IiKI7YBBEVHfBpAM1LmpJphAsKdsSp4gLdK1tU4W1rd461C/EiVEZUCWup0sI56mwvM+fxNiXqrWaJE9Foi
 pSuXdgWx
 BcND2QRm0zOm2hKbVGgclB9UNgle/nYT71OtgiCn74iykNhAvUvVOax2Y6mNzfXcMKY9yIdEV/H4kuc955zLX9dml6j/fjUYuCnRgVvTtILm+d5pO4zf12GKJjeJ/ceb9YX6nOUly4MUVEoMA5dxWmBM6YtzdnwGHGX0bcgogBhsHdk04EFTeouDAOvJ/6sThL+CzJFCFZUcuogWWKxV3FviPNfjozFmN7pkEJc6RZXoELXTC/Cj00KD8SeyIOJ6eVf6Hp6ND44lIRM29tb/s4yFWuS1bmnsgBwMV0t648lwcYIPssoN4au6h/ViplTsCrzcRatUN9tol3SmiBjf4tD5EncK5/vHAAtoMgAC7bJ8zZk4IrKAGCLCuRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/31/25 03:51, Wei Yang wrote:
> On Tue, Dec 30, 2025 at 09:03:23PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/29/25 06:51, Vernon Yang wrote:
>>> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
>>> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
>>> reduce redundant operation.
>>>
>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>> ---
>>>    mm/khugepaged.c | 9 +++++++--
>>>    1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 2b3685b195f5..72be87ef384b 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2439,6 +2439,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>>    		cond_resched();
>>>    		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
>>> +			vma = NULL;
>>>    			progress++;
>>>    			break;
>>>    		}
>>
>> I don't understand why we need changes at all.
>>
>> The code is
>>
>> 	mm = slot->mm;
>> 	/*
>> 	 * Don't wait for semaphore (to avoid long wait times).  Just move to
>> 	 * the next mm on the list.
>> 	 */
>> 	vma = NULL;
>> 	if (unlikely(!mmap_read_trylock(mm)))
>> 		goto breakouterloop_mmap_lock;
>>
>> 	progress++;
>> 	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>> 		goto breakouterloop;
>>
>> 	...
>>
>> So we'll go straight to breakouterloop with vma=NULL.
>>
>> Do you want to optimize for skipping the MM if the flag gets toggled
>> while we are scanning that MM?
>>
>> Is that really something we should be worrying about?
>>
>> Also, why can't we simply do a
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 97d1b2824386f..af8481d4b0f4e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2516,7 +2516,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>          * Release the current mm_slot if this mm is about to die, or
>>          * if we scanned all vmas of this mm.
>>          */
>> -       if (hpage_collapse_test_exit(mm) || !vma) {
>> +       if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>>                 /*
>>                  * Make sure that if mm_users is reaching zero while
>>                  * khugepaged runs here, khugepaged_exit will find
>>
> 
> This one looks better.
> 
> But the sad thing is we can't remove this mm from scan list, since user may
> toggle this flag later.

In theory we could readd it to the list once the flag gets toggled.

In fact, we could remove it from the list once we set the flag. But not 
sure if that ends up any cleaner (dealing with races? not sure).

-- 
Cheers

David

